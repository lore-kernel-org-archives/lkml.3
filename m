Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab3JIS5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 14:57:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab3JIS5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 14:57:44 -0400
Date: Wed, 9 Oct 2013 20:50:38 +0200
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
Subject: [PATCH v2 1/2] rcusync: introduce rcu_sync_struct->exclusive mode
Message-ID: <20131009185038.GA19280@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009185023.GA19264@redhat.com>
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

This will be used by percpu_rw_semaphore, and (I hope) by other
users, say, freeze_super().

Note: the only current user, __cpuhp_rss, doesn't care because
it is already exclusive due to cpu_maps_update_begin(). However
this patch changes it to use "exclusive = T", this avoids the
unnecessary wake_up_all() which needs to take/drop wait.lock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/rcusync.h |   29 ++++++++++++++++-------------
 kernel/cpu.c            |    2 +-
 kernel/rcusync.c        |   25 ++++++++++++++++++++-----
 3 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/include/linux/rcusync.h b/include/linux/rcusync.h
index 0135838..aaea86a 100644
--- a/include/linux/rcusync.h
+++ b/include/linux/rcusync.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_RCUSYNC_H_
 #define _LINUX_RCUSYNC_H_
 
-#include <linux/wait.h>
+#include <linux/completion.h>
 #include <linux/rcupdate.h>
 
 enum rcu_sync_type { RCU_SYNC, RCU_SCHED_SYNC, RCU_BH_SYNC };
@@ -9,11 +9,12 @@ enum rcu_sync_type { RCU_SYNC, RCU_SCHED_SYNC, RCU_BH_SYNC };
 struct rcu_sync_struct {
 	int			gp_state;
 	int			gp_count;
-	wait_queue_head_t	gp_wait;
+	struct completion	gp_comp;
 
 	int			cb_state;
 	struct rcu_head		cb_head;
 
+	bool			exclusive;
 	enum rcu_sync_type	gp_type;
 };
 
@@ -28,30 +29,32 @@ static inline bool rcu_sync_is_idle(struct rcu_sync_struct *rss)
 #endif
 }
 
-extern void rcu_sync_init(struct rcu_sync_struct *, enum rcu_sync_type);
+extern void rcu_sync_init(struct rcu_sync_struct *,
+				enum rcu_sync_type, bool excl);
 extern void rcu_sync_enter(struct rcu_sync_struct *);
 extern void rcu_sync_exit(struct rcu_sync_struct *);
 extern void rcu_sync_dtor(struct rcu_sync_struct *);
 
-#define __RCU_SYNC_INITIALIZER(name, type) {				\
+#define __RCU_SYNC_INITIALIZER(name, type, excl) {			\
 		.gp_state = 0,						\
 		.gp_count = 0,						\
-		.gp_wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.gp_wait),	\
+		.gp_comp = COMPLETION_INITIALIZER(name.gp_comp),	\
 		.cb_state = 0,						\
+		.exclusive = excl,					\
 		.gp_type = type,					\
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
+#define DEFINE_RCU_BH_SYNC(name, excl)	\
+	__DEFINE_RCU_SYNC(name, RCU_BH_SYNC, excl)
 
 #endif /* _LINUX_RCUSYNC_H_ */
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index e4178c2..5a4fc5a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -51,7 +51,7 @@ static int cpu_hotplug_disabled;
 
 enum { readers_slow, readers_block };
 
-DEFINE_RCU_SCHED_SYNC(__cpuhp_rss);
+DEFINE_RCU_SCHED_SYNC(__cpuhp_rss, true);
 EXPORT_SYMBOL_GPL(__cpuhp_rss);
 
 DEFINE_PER_CPU(unsigned int, __cpuhp_refcount);
diff --git a/kernel/rcusync.c b/kernel/rcusync.c
index 8835ad1..03ddc61 100644
--- a/kernel/rcusync.c
+++ b/kernel/rcusync.c
@@ -38,7 +38,8 @@ static const struct {
 enum { GP_IDLE = 0, GP_PENDING, GP_PASSED };
 enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
 
-#define	rss_lock	gp_wait.lock
+#define	rss_lock	gp_comp.wait.lock
+#define	gp_wait		gp_comp.wait
 
 #ifdef CONFIG_PROVE_RCU
 bool __rcu_sync_is_idle(struct rcu_sync_struct *rss)
@@ -49,10 +50,12 @@ bool __rcu_sync_is_idle(struct rcu_sync_struct *rss)
 EXPORT_SYMBOL_GPL(__rcu_sync_is_idle);
 #endif
 
-void rcu_sync_init(struct rcu_sync_struct *rss, enum rcu_sync_type type)
+void rcu_sync_init(struct rcu_sync_struct *rss,
+			enum rcu_sync_type type, bool excl)
 {
 	memset(rss, 0, sizeof(*rss));
-	init_waitqueue_head(&rss->gp_wait);
+	init_completion(&rss->gp_comp);
+	rss->exclusive = excl;
 	rss->gp_type = type;
 }
 
@@ -72,9 +75,13 @@ void rcu_sync_enter(struct rcu_sync_struct *rss)
 	if (need_sync) {
 		gp_ops[rss->gp_type].sync();
 		rss->gp_state = GP_PASSED;
-		wake_up_all(&rss->gp_wait);
+		if (!rss->exclusive)
+			wake_up_all(&rss->gp_wait);
 	} else if (need_wait) {
-		wait_event(rss->gp_wait, rss->gp_state == GP_PASSED);
+		if (!rss->exclusive)
+			wait_event(rss->gp_wait, rss->gp_state == GP_PASSED);
+		else
+			wait_for_completion(&rss->gp_comp);
 	} else {
 		/*
 		 * Possible when there's a pending CB from a rcu_sync_exit().
@@ -119,6 +126,12 @@ static void rcu_sync_func(struct rcu_head *rcu)
 	spin_unlock_irqrestore(&rss->rss_lock, flags);
 }
 
+static inline void __complete_locked(struct completion *x)
+{
+	x->done++;
+	__wake_up_locked(&x->wait, TASK_NORMAL, 1);
+}
+
 void rcu_sync_exit(struct rcu_sync_struct *rss)
 {
 	spin_lock_irq(&rss->rss_lock);
@@ -129,6 +142,8 @@ void rcu_sync_exit(struct rcu_sync_struct *rss)
 		} else if (rss->cb_state == CB_PENDING) {
 			rss->cb_state = CB_REPLAY;
 		}
+	} else if (rss->exclusive) {
+		__complete_locked(&rss->gp_comp);
 	}
 	spin_unlock_irq(&rss->rss_lock);
 }
-- 
1.5.5.1

