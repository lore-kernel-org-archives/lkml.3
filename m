Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3JDSxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:53:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab3JDSxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:53:41 -0400
Date: Fri, 4 Oct 2013 20:46:40 +0200
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
Subject: [PATCH 4/5] rcusync: introduce rcu_sync_struct->exclusive mode
Message-ID: <20131004184640.GA17567@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004184614.GA17536@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rcu_sync_struct->exclusive boolean set by rcu_sync_init(),
it obviously controls the exclusiveness of rcu_sync_enter().
This is what percpu_down_write() actually wants.

We turn ->gp_wait into "struct completion gp_comp", it is used
as a resource counter in "exclusive" mode. Otherwise we only use
its completion->wait member for wait_event/wake_up_all. We never
mix the completion/wait_queue_head_t operations.

Note: it would be more clean to do __complete_locked() under
->rss_lock in rcu_sync_exit() in the "else" branch, but we don't
have this trivial helper.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/rcusync.h |   29 ++++++++++++++++-------------
 kernel/cpu.c            |    2 +-
 kernel/rcusync.c        |   22 +++++++++++++++++-----
 3 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/include/linux/rcusync.h b/include/linux/rcusync.h
index 33864a0..5689f24 100644
--- a/include/linux/rcusync.h
+++ b/include/linux/rcusync.h
@@ -1,8 +1,8 @@
 #ifndef _LINUX_RCUSYNC_H_
 #define _LINUX_RCUSYNC_H_
 
-#include <linux/wait.h>
 #include <linux/rcupdate.h>
+#include <linux/completion.h>
 
 struct rcu_sync_ops {
 	void (*sync)(void);
@@ -16,11 +16,12 @@ struct rcu_sync_ops {
 struct rcu_sync_struct {
 	int			gp_state;
 	int			gp_count;
-	wait_queue_head_t	gp_wait;
+	struct completion	gp_comp;
 
 	int			cb_state;
 	struct rcu_head		cb_head;
 
+	bool			exclusive;
 	struct rcu_sync_ops	*ops;
 };
 
@@ -34,32 +35,34 @@ static inline bool rcu_sync_is_idle(struct rcu_sync_struct *rss)
 
 enum rcu_sync_type { RCU_SYNC, RCU_SCHED_SYNC, RCU_BH_SYNC };
 
-extern void rcu_sync_init(struct rcu_sync_struct *, enum rcu_sync_type);
+extern void rcu_sync_init(struct rcu_sync_struct *,
+				enum rcu_sync_type, bool excl);
 extern void rcu_sync_enter(struct rcu_sync_struct *);
 extern void rcu_sync_exit(struct rcu_sync_struct *);
 extern void rcu_sync_dtor(struct rcu_sync_struct *);
 
 extern struct rcu_sync_ops rcu_sync_ops_array[];
 
-#define __RCU_SYNC_INITIALIZER(name, type) {				\
+#define __RCU_SYNC_INITIALIZER(name, type, excl) {			\
 		.gp_state = 0,						\
 		.gp_count = 0,						\
-		.gp_wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.gp_wait),	\
+		.gp_comp = COMPLETION_INITIALIZER(name.gp_comp),	\
 		.cb_state = 0,						\
+		.exclusive = excl,					\
 		.ops = rcu_sync_ops_array + (type),			\
 	}
 
-#define	__DEFINE_RCU_SYNC(name, type)	\
-	struct rcu_sync_struct name = __RCU_SYNC_INITIALIZER(name, type)
+#define	__DEFINE_RCU_SYNC(name, type, excl)	\
+	struct rcu_sync_struct name = __RCU_SYNC_INITIALIZER(name, type, excl)
 
-#define DEFINE_RCU_SYNC(name)		\
-	__DEFINE_RCU_SYNC(name, RCU_SYNC)
+#define DEFINE_RCU_SYNC(name, excl)		\
+	__DEFINE_RCU_SYNC(name, RCU_SYNC, excl)
 
-#define DEFINE_RCU_SCHED_SYNC(name)	\
-	__DEFINE_RCU_SYNC(name, RCU_SCHED_SYNC)
+#define DEFINE_RCU_SCHED_SYNC(name, excl)	\
+	__DEFINE_RCU_SYNC(name, RCU_SCHED_SYNC, excl)
 
-#define DEFINE_RCU_BH_SYNC(name)	\
-	__DEFINE_RCU_SYNC(name, RCU_BH_SYNC)
+#define DEFINE_RCU_BH_SYNC(name, excl)		\
+	__DEFINE_RCU_SYNC(name, RCU_BH_SYNC, excl)
 
 #endif /* _LINUX_RCUSYNC_H_ */
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index d5f475a..fb1bdf0 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -51,7 +51,7 @@ static int cpu_hotplug_disabled;
 
 enum { readers_slow, readers_block };
 
-DEFINE_RCU_SCHED_SYNC(__cpuhp_rss);
+DEFINE_RCU_SCHED_SYNC(__cpuhp_rss, false);
 EXPORT_SYMBOL_GPL(__cpuhp_rss);
 
 DEFINE_PER_CPU(unsigned int, __cpuhp_refcount);
diff --git a/kernel/rcusync.c b/kernel/rcusync.c
index bb311eb..667eb7d 100644
--- a/kernel/rcusync.c
+++ b/kernel/rcusync.c
@@ -4,7 +4,7 @@
 enum { GP_IDLE = 0, GP_PENDING, GP_PASSED };
 enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
 
-#define	rss_lock	gp_wait.lock
+#define	rss_lock	gp_comp.wait.lock
 
 #ifdef CONFIG_PROVE_RCU
 #define __INIT_HELD(func)	.held = func,
@@ -33,11 +33,13 @@ struct rcu_sync_ops rcu_sync_ops_array[] = {
 	},
 };
 
-void rcu_sync_init(struct rcu_sync_struct *rss, enum rcu_sync_type type)
+void rcu_sync_init(struct rcu_sync_struct *rss,
+			enum rcu_sync_type type, bool excl)
 {
 	memset(rss, 0, sizeof(*rss));
-	init_waitqueue_head(&rss->gp_wait);
+	init_completion(&rss->gp_comp);
 	rss->ops = rcu_sync_ops_array + type;
+	rss->exclusive = excl;
 }
 
 void rcu_sync_enter(struct rcu_sync_struct *rss)
@@ -56,9 +58,13 @@ void rcu_sync_enter(struct rcu_sync_struct *rss)
 	if (need_sync) {
 		rss->ops->sync();
 		rss->gp_state = GP_PASSED;
-		wake_up_all(&rss->gp_wait);
+		if (!rss->exclusive)
+			wake_up_all(&rss->gp_comp.wait);
 	} else if (need_wait) {
-		wait_event(rss->gp_wait, rss->gp_state == GP_PASSED);
+		if (!rss->exclusive)
+			wait_event(rss->gp_comp.wait, rss->gp_state == GP_PASSED);
+		else
+			wait_for_completion(&rss->gp_comp);
 	} else {
 		/*
 		 * Possible when there's a pending CB from a rcu_sync_exit().
@@ -105,6 +111,8 @@ static void rcu_sync_func(struct rcu_head *rcu)
 
 void rcu_sync_exit(struct rcu_sync_struct *rss)
 {
+	bool wakeup_excl = rss->exclusive;
+
 	spin_lock_irq(&rss->rss_lock);
 	if (!--rss->gp_count) {
 		if (rss->cb_state == CB_IDLE) {
@@ -113,8 +121,12 @@ void rcu_sync_exit(struct rcu_sync_struct *rss)
 		} else if (rss->cb_state == CB_PENDING) {
 			rss->cb_state = CB_REPLAY;
 		}
+		wakeup_excl = false;
 	}
 	spin_unlock_irq(&rss->rss_lock);
+
+	if (wakeup_excl)
+		complete(&rss->gp_comp);
 }
 
 void rcu_sync_dtor(struct rcu_sync_struct *rss)
-- 
1.5.5.1

