Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab3AVXOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:14:09 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36683 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab3AVXN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:13:57 -0500
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/6] net: qdisc busylock updates to account for queue spinlock api change
Date: Tue, 22 Jan 2013 15:13:34 -0800
Message-Id: <1358896415-28569-6-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1358896415-28569-1-git-send-email-walken@google.com>
References: <1358896415-28569-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to limitations of the second queue spinlock implementation,
a static spinlock initializer is not available anymore, so we must
use an init function instead. Additionally, for dynamically allocated
qdiscs we must handle the case of running out of memory as we try to
initialize the busylock spinlock.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 net/sched/sch_generic.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 6675d30d526a..1f9458b54ad6 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -362,7 +362,6 @@ struct Qdisc noop_qdisc = {
 	.list		=	LIST_HEAD_INIT(noop_qdisc.list),
 	.q.lock		=	__SPIN_LOCK_UNLOCKED(noop_qdisc.q.lock),
 	.dev_queue	=	&noop_netdev_queue,
-	.busylock	=	__Q_SPIN_LOCK_UNLOCKED(noop_qdisc.busylock),
 };
 EXPORT_SYMBOL(noop_qdisc);
 
@@ -389,9 +388,14 @@ static struct Qdisc noqueue_qdisc = {
 	.list		=	LIST_HEAD_INIT(noqueue_qdisc.list),
 	.q.lock		=	__SPIN_LOCK_UNLOCKED(noqueue_qdisc.q.lock),
 	.dev_queue	=	&noqueue_netdev_queue,
-	.busylock	=	__Q_SPIN_LOCK_UNLOCKED(noqueue_qdisc.busylock),
 };
 
+static int __init sch_generic_init(void)
+{
+	return q_spin_lock_init(&noop_qdisc.busylock) ||
+		q_spin_lock_init(&noqueue_qdisc.busylock);
+}
+module_init(sch_generic_init);
 
 static const u8 prio2band[TC_PRIO_MAX + 1] = {
 	1, 2, 2, 2, 1, 2, 0, 0 , 1, 1, 1, 1, 1, 1, 1, 1
@@ -552,11 +556,11 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 		sch = (struct Qdisc *) QDISC_ALIGN((unsigned long) p);
 		sch->padded = (char *) sch - (char *) p;
 	}
+	if (q_spin_lock_init(&sch->busylock))
+		goto freeout;
 	INIT_LIST_HEAD(&sch->list);
 	skb_queue_head_init(&sch->q);
 
-	q_spin_lock_init(&sch->busylock);
-
 	sch->ops = ops;
 	sch->enqueue = ops->enqueue;
 	sch->dequeue = ops->dequeue;
@@ -565,6 +569,8 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	atomic_set(&sch->refcnt, 1);
 
 	return sch;
+freeout:
+	kfree(p);
 errout:
 	return ERR_PTR(err);
 }
@@ -609,6 +615,7 @@ static void qdisc_rcu_free(struct rcu_head *head)
 {
 	struct Qdisc *qdisc = container_of(head, struct Qdisc, rcu_head);
 
+	q_spin_lock_destroy(&qdisc->busylock);
 	kfree((char *) qdisc - qdisc->padded);
 }
 
-- 
1.7.7.3
