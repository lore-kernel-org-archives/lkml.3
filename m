Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3JDSxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:53:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab3JDSxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:53:48 -0400
Date: Fri, 4 Oct 2013 20:46:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] rcusync: introduce rcu_sync_dtor()
Message-ID: <20131004184636.GA17560@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004184614.GA17536@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new rcu_sync_ops->wait() method and the new helper,
rcu_sync_dtor().

It is needed if you are going to, say, kfree(rcu_sync_object).
It simply calls ops->wait() to "flush" the potentially pending
rcu callback.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/rcusync.h |    2 ++
 kernel/rcusync.c        |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcusync.h b/include/linux/rcusync.h
index ab787c1..33864a0 100644
--- a/include/linux/rcusync.h
+++ b/include/linux/rcusync.h
@@ -7,6 +7,7 @@
 struct rcu_sync_ops {
 	void (*sync)(void);
 	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
+	void (*wait)(void);
 #ifdef CONFIG_PROVE_RCU
 	int (*held)(void);
 #endif
@@ -36,6 +37,7 @@ enum rcu_sync_type { RCU_SYNC, RCU_SCHED_SYNC, RCU_BH_SYNC };
 extern void rcu_sync_init(struct rcu_sync_struct *, enum rcu_sync_type);
 extern void rcu_sync_enter(struct rcu_sync_struct *);
 extern void rcu_sync_exit(struct rcu_sync_struct *);
+extern void rcu_sync_dtor(struct rcu_sync_struct *);
 
 extern struct rcu_sync_ops rcu_sync_ops_array[];
 
diff --git a/kernel/rcusync.c b/kernel/rcusync.c
index 21cde9b..bb311eb 100644
--- a/kernel/rcusync.c
+++ b/kernel/rcusync.c
@@ -16,16 +16,19 @@ struct rcu_sync_ops rcu_sync_ops_array[] = {
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
@@ -113,3 +116,21 @@ void rcu_sync_exit(struct rcu_sync_struct *rss)
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
+		rss->ops->wait();
+		BUG_ON(rss->cb_state != CB_IDLE);
+	}
+}
-- 
1.5.5.1

