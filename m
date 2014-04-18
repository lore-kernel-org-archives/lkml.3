Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaDRJkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:40:09 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45946 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 37/72] pkt_sched: fq: do not hold qdisc lock while allocating memory
Date: Fri, 18 Apr 2014 11:22:10 +0200
Message-Id: <36d8aca154bb7fe15aa62546dab3f62977a1d55b.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 2d8d40afd187bced0a3d056366fb58d66fe845e3 ]

Resizing fq hash table allocates memory while holding qdisc spinlock,
with BH disabled.

This is definitely not good, as allocation might sleep.

We can drop the lock and get it when needed, we hold RTNL so no other
changes can happen at the same time.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/sched/sch_fq.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 2e55f8189502..52229f91b115 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -577,9 +577,11 @@ static void fq_rehash(struct fq_sched_data *q,
 	q->stat_gc_flows += fcnt;
 }
 
-static int fq_resize(struct fq_sched_data *q, u32 log)
+static int fq_resize(struct Qdisc *sch, u32 log)
 {
+	struct fq_sched_data *q = qdisc_priv(sch);
 	struct rb_root *array;
+	void *old_fq_root;
 	u32 idx;
 
 	if (q->fq_root && log == q->fq_trees_log)
@@ -592,13 +594,19 @@ static int fq_resize(struct fq_sched_data *q, u32 log)
 	for (idx = 0; idx < (1U << log); idx++)
 		array[idx] = RB_ROOT;
 
-	if (q->fq_root) {
-		fq_rehash(q, q->fq_root, q->fq_trees_log, array, log);
-		kfree(q->fq_root);
-	}
+	sch_tree_lock(sch);
+
+	old_fq_root = q->fq_root;
+	if (old_fq_root)
+		fq_rehash(q, old_fq_root, q->fq_trees_log, array, log);
+
 	q->fq_root = array;
 	q->fq_trees_log = log;
 
+	sch_tree_unlock(sch);
+
+	kfree(old_fq_root);
+
 	return 0;
 }
 
@@ -674,9 +682,11 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt)
 		q->flow_refill_delay = usecs_to_jiffies(usecs_delay);
 	}
 
-	if (!err)
-		err = fq_resize(q, fq_log);
-
+	if (!err) {
+		sch_tree_unlock(sch);
+		err = fq_resize(sch, fq_log);
+		sch_tree_lock(sch);
+	}
 	while (sch->q.qlen > sch->limit) {
 		struct sk_buff *skb = fq_dequeue(sch);
 
@@ -722,7 +732,7 @@ static int fq_init(struct Qdisc *sch, struct nlattr *opt)
 	if (opt)
 		err = fq_change(sch, opt);
 	else
-		err = fq_resize(q, q->fq_trees_log);
+		err = fq_resize(sch, q->fq_trees_log);
 
 	return err;
 }
-- 
1.9.2

