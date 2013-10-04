Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3JDSxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:53:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab3JDSxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:53:30 -0400
Date: Fri, 4 Oct 2013 20:46:33 +0200
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
Subject: [PATCH 2/5] rcusync: add the CONFIG_PROVE_RCU checks
Message-ID: <20131004184633.GA17557@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004184614.GA17536@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be nice to validate that the caller of rcu_sync_is_idle()
holds the corresponding type of RCU read-side lock. Add the new
rcu_sync_ops->held() method and change rcu_sync_is_idle() to
WARN() if it returns false.

This obviously penalizes the readers (fast-path), but only if
CONFIG_PROVE_RCU.

Suggested-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/rcusync.h |    6 ++++++
 kernel/rcusync.c        |    9 +++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcusync.h b/include/linux/rcusync.h
index 30c6037..ab787c1 100644
--- a/include/linux/rcusync.h
+++ b/include/linux/rcusync.h
@@ -7,6 +7,9 @@
 struct rcu_sync_ops {
 	void (*sync)(void);
 	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
+#ifdef CONFIG_PROVE_RCU
+	int (*held)(void);
+#endif
 };
 
 struct rcu_sync_struct {
@@ -22,6 +25,9 @@ struct rcu_sync_struct {
 
 static inline bool rcu_sync_is_idle(struct rcu_sync_struct *rss)
 {
+#ifdef CONFIG_PROVE_RCU
+	WARN_ON(!rss->ops->held());
+#endif
 	return !rss->gp_state; /* GP_IDLE */
 }
 
diff --git a/kernel/rcusync.c b/kernel/rcusync.c
index 1cefb83..21cde9b 100644
--- a/kernel/rcusync.c
+++ b/kernel/rcusync.c
@@ -6,18 +6,27 @@ enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
 
 #define	rss_lock	gp_wait.lock
 
+#ifdef CONFIG_PROVE_RCU
+#define __INIT_HELD(func)	.held = func,
+#else
+#define __INIT_HELD(func)
+#endif
+
 struct rcu_sync_ops rcu_sync_ops_array[] = {
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
 
-- 
1.5.5.1

