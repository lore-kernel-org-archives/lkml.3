Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab3AVXOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:14:14 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45021 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab3AVXNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:13:53 -0500
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/6] net: convert qdisc busylock to use queue spinlock API
Date: Tue, 22 Jan 2013 15:13:31 -0800
Message-Id: <1358896415-28569-3-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1358896415-28569-1-git-send-email-walken@google.com>
References: <1358896415-28569-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert qdisc busylock to use the proposed queue spinlock API.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 include/net/sch_generic.h |    3 ++-
 net/core/dev.c            |    9 +++++----
 net/sched/sch_generic.c   |   10 +++-------
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 4616f468d599..456c06581a57 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -6,6 +6,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pkt_sched.h>
 #include <linux/pkt_cls.h>
+#include <linux/queue_spinlock.h>
 #include <net/gen_stats.h>
 #include <net/rtnetlink.h>
 
@@ -81,7 +82,7 @@ struct Qdisc {
 	unsigned int		__state;
 	struct gnet_stats_queue	qstats;
 	struct rcu_head		rcu_head;
-	spinlock_t		busylock;
+	struct q_spinlock	busylock;
 	u32			limit;
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index e5942bf45a6d..058c984cd024 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2440,6 +2440,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 {
 	spinlock_t *root_lock = qdisc_lock(q);
 	bool contended;
+	struct q_spinlock_node busylock_node;
 	int rc;
 
 	qdisc_skb_cb(skb)->pkt_len = skb->len;
@@ -2452,7 +2453,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	 */
 	contended = qdisc_is_running(q);
 	if (unlikely(contended))
-		spin_lock(&q->busylock);
+		q_spin_lock(&q->busylock, &busylock_node);
 
 	spin_lock(root_lock);
 	if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED, &q->state))) {
@@ -2472,7 +2473,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 
 		if (sch_direct_xmit(skb, q, dev, txq, root_lock)) {
 			if (unlikely(contended)) {
-				spin_unlock(&q->busylock);
+				q_spin_unlock(&q->busylock, &busylock_node);
 				contended = false;
 			}
 			__qdisc_run(q);
@@ -2485,7 +2486,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		rc = q->enqueue(skb, q) & NET_XMIT_MASK;
 		if (qdisc_run_begin(q)) {
 			if (unlikely(contended)) {
-				spin_unlock(&q->busylock);
+				q_spin_unlock(&q->busylock, &busylock_node);
 				contended = false;
 			}
 			__qdisc_run(q);
@@ -2493,7 +2494,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	}
 	spin_unlock(root_lock);
 	if (unlikely(contended))
-		spin_unlock(&q->busylock);
+		q_spin_unlock(&q->busylock, &busylock_node);
 	return rc;
 }
 
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index aefc1504dc88..6675d30d526a 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -362,7 +362,7 @@ struct Qdisc noop_qdisc = {
 	.list		=	LIST_HEAD_INIT(noop_qdisc.list),
 	.q.lock		=	__SPIN_LOCK_UNLOCKED(noop_qdisc.q.lock),
 	.dev_queue	=	&noop_netdev_queue,
-	.busylock	=	__SPIN_LOCK_UNLOCKED(noop_qdisc.busylock),
+	.busylock	=	__Q_SPIN_LOCK_UNLOCKED(noop_qdisc.busylock),
 };
 EXPORT_SYMBOL(noop_qdisc);
 
@@ -389,7 +389,7 @@ static struct Qdisc noqueue_qdisc = {
 	.list		=	LIST_HEAD_INIT(noqueue_qdisc.list),
 	.q.lock		=	__SPIN_LOCK_UNLOCKED(noqueue_qdisc.q.lock),
 	.dev_queue	=	&noqueue_netdev_queue,
-	.busylock	=	__SPIN_LOCK_UNLOCKED(noqueue_qdisc.busylock),
+	.busylock	=	__Q_SPIN_LOCK_UNLOCKED(noqueue_qdisc.busylock),
 };
 
 
@@ -527,8 +527,6 @@ struct Qdisc_ops pfifo_fast_ops __read_mostly = {
 };
 EXPORT_SYMBOL(pfifo_fast_ops);
 
-static struct lock_class_key qdisc_tx_busylock;
-
 struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 			  struct Qdisc_ops *ops)
 {
@@ -557,9 +555,7 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	INIT_LIST_HEAD(&sch->list);
 	skb_queue_head_init(&sch->q);
 
-	spin_lock_init(&sch->busylock);
-	lockdep_set_class(&sch->busylock,
-			  dev->qdisc_tx_busylock ?: &qdisc_tx_busylock);
+	q_spin_lock_init(&sch->busylock);
 
 	sch->ops = ops;
 	sch->enqueue = ops->enqueue;
-- 
1.7.7.3
