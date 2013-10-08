Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3JHKnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:43:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33587 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3JHKkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:40:53 -0400
Message-Id: <20131008103830.347463501@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 08 Oct 2013 12:25:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/6] rcusync: Add the CONFIG_PROVE_RCU checks
References: <20131008102505.404025673@infradead.org>
Content-Disposition: inline; filename=oleg_nesterov-2_rcusync-add_the_config_prove_rcu_checks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

It would be nice to validate that the caller of rcu_sync_is_idle()
holds the corresponding type of RCU read-side lock. Add the new
rcu_sync_ops->held() method and change rcu_sync_is_idle() to
WARN() if it returns false.

This obviously penalizes the readers (fast-path), but only if
CONFIG_PROVE_RCU.

Suggested-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131004184633.GA17557@redhat.com
---
 include/linux/rcusync.h |    6 ++++++
 kernel/rcusync.c        |   21 +++++++++++++++++++++
 2 files changed, 27 insertions(+)

--- a/include/linux/rcusync.h
+++ b/include/linux/rcusync.h
@@ -17,9 +17,15 @@ struct rcu_sync_struct {
 	enum rcu_sync_type	gp_type;
 };
 
+extern bool __rcu_sync_is_idle(struct rcu_sync_struct *);
+
 static inline bool rcu_sync_is_idle(struct rcu_sync_struct *rss)
 {
+#ifdef CONFIG_PROVE_RCU
+	return __rcu_sync_is_idle(rss);
+#else
 	return !rss->gp_state; /* GP_IDLE */
+#endif
 }
 
 extern void rcu_sync_init(struct rcu_sync_struct *, enum rcu_sync_type);
--- a/kernel/rcusync.c
+++ b/kernel/rcusync.c
@@ -1,21 +1,33 @@
 #include <linux/rcusync.h>
 #include <linux/sched.h>
 
+#ifdef CONFIG_PROVE_RCU
+#define __INIT_HELD(func)	.held = func,
+#else
+#define __INIT_HELD(func)
+#endif
+
 static const struct {
 	void (*sync)(void);
 	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
+#ifdef CONFIG_PROVE_RCU
+	int  (*held)(void);
+#endif
 } gp_ops[] = {
 	[RCU_SYNC] = {
 		.sync = synchronize_rcu,
 		.call = call_rcu,
+		__INIT_HELD(rcu_read_lock_held)
 	},
 	[RCU_SCHED_SYNC] = {
 		.sync = synchronize_sched,
 		.call = call_rcu_sched,
+		__INIT_HELD(rcu_read_lock_sched_held)
 	},
 	[RCU_BH_SYNC] = {
 		.sync = synchronize_rcu_bh,
 		.call = call_rcu_bh,
+		__INIT_HELD(rcu_read_lock_bh_held)
 	},
 };
 
@@ -24,6 +36,15 @@ enum { CB_IDLE = 0, CB_PENDING, CB_REPLA
 
 #define	rss_lock	gp_wait.lock
 
+#ifdef CONFIG_PROVE_RCU
+bool __rcu_sync_is_idle(struct rcu_sync_struct *rss)
+{
+	WARN_ON(!gp_ops[rss->gp_type].held());
+	return rss->gp_state == GP_IDLE;
+}
+EXPORT_SYMBOL_GPL(__rcu_sync_is_idle);
+#endif
+
 void rcu_sync_init(struct rcu_sync_struct *rss, enum rcu_sync_type type)
 {
 	memset(rss, 0, sizeof(*rss));


