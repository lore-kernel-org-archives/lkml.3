Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab3JHKlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:41:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33577 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3JHKku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:40:50 -0400
Message-Id: <20131008103830.403651548@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 08 Oct 2013 12:25:11 +0200
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
Subject: [PATCH 6/6] rcusync: Introduce rcu_sync_dtor()
References: <20131008102505.404025673@infradead.org>
Content-Disposition: inline; filename=oleg_nesterov-3_rcusync-introduce_rcu_sync_dtor.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Add the new rcu_sync_ops->wait() method and the new helper,
rcu_sync_dtor().

It is needed if you are going to, say, kfree(rcu_sync_object).
It simply calls ops->wait() to "flush" the potentially pending
rcu callback.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131004184636.GA17560@redhat.com
---
 include/linux/rcusync.h |    1 +
 kernel/rcusync.c        |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

--- a/include/linux/rcusync.h
+++ b/include/linux/rcusync.h
@@ -31,6 +31,7 @@ static inline bool rcu_sync_is_idle(stru
 extern void rcu_sync_init(struct rcu_sync_struct *, enum rcu_sync_type);
 extern void rcu_sync_enter(struct rcu_sync_struct *);
 extern void rcu_sync_exit(struct rcu_sync_struct *);
+extern void rcu_sync_dtor(struct rcu_sync_struct *);
 
 #define __RCU_SYNC_INITIALIZER(name, type) {				\
 		.gp_state = 0,						\
--- a/kernel/rcusync.c
+++ b/kernel/rcusync.c
@@ -10,6 +10,7 @@
 static const struct {
 	void (*sync)(void);
 	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
+	void (*wait)(void);
 #ifdef CONFIG_PROVE_RCU
 	int  (*held)(void);
 #endif
@@ -17,16 +18,19 @@ static const struct {
 	[RCU_SYNC] = {
 		.sync = synchronize_rcu,
 		.call = call_rcu,
+		.wait = rcu_barrier,
 		__INIT_HELD(rcu_read_lock_held)
 	},
 	[RCU_SCHED_SYNC] = {
 		.sync = synchronize_sched,
 		.call = call_rcu_sched,
+		.wait = rcu_barrier_sched,
 		__INIT_HELD(rcu_read_lock_sched_held)
 	},
 	[RCU_BH_SYNC] = {
 		.sync = synchronize_rcu_bh,
 		.call = call_rcu_bh,
+		.wait = rcu_barrier_bh,
 		__INIT_HELD(rcu_read_lock_bh_held)
 	},
 };
@@ -128,3 +132,21 @@ void rcu_sync_exit(struct rcu_sync_struc
 	}
 	spin_unlock_irq(&rss->rss_lock);
 }
+
+void rcu_sync_dtor(struct rcu_sync_struct *rss)
+{
+	int cb_state;
+
+	BUG_ON(rss->gp_count);
+
+	spin_lock_irq(&rss->rss_lock);
+	if (rss->cb_state == CB_REPLAY)
+		rss->cb_state = CB_PENDING;
+	cb_state = rss->cb_state;
+	spin_unlock_irq(&rss->rss_lock);
+
+	if (cb_state != CB_IDLE) {
+		gp_ops[rss->gp_type].wait();
+		BUG_ON(rss->cb_state != CB_IDLE);
+	}
+}


