Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3JBPIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:08:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48611 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab3JBPIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:08:30 -0400
Message-Id: <20131002150518.675931976@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Oct 2013 16:56:57 +0200
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
Subject: [PATCH 2/3] rcu: Create rcu_sync infrastructure
References: <20131002145655.361606532@infradead.org>
Content-Disposition: inline; filename=oleg-sync_sched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

It is functionally equivalent to

        struct xxx_struct {
                atomic_t counter;
        };

        static inline bool xxx_is_idle(struct xxx_struct *xxx)
        {
                return atomic_read(&xxx->counter) == 0;
        }

        static inline void xxx_enter(struct xxx_struct *xxx)
        {
                atomic_inc(&xxx->counter);
                synchronize_sched();
        }

        static inline void xxx_enter(struct xxx_struct *xxx)
        {
                synchronize_sched();
                atomic_dec(&xxx->counter);
        }

except: it records the state and synchronize_sched() is only called by
xxx_enter() and only if necessary.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130929183634.GA15563@redhat.com
---
 include/linux/rcusync.h |   64 ++++++++++++++++++++++++++++
 kernel/Makefile         |    3 -
 kernel/rcusync.c        |  108 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 174 insertions(+), 1 deletion(-)

--- /dev/null
+++ b/include/linux/rcusync.h
@@ -0,0 +1,64 @@
+#ifndef _LINUX_RCUSYNC_H_
+#define _LINUX_RCUSYNC_H_
+
+#include <linux/wait.h>
+#include <linux/rcupdate.h>
+
+struct rcu_sync_struct {
+	int			gp_state;
+	int			gp_count;
+	wait_queue_head_t	gp_wait;
+
+	int			cb_state;
+	struct rcu_head		cb_head;
+
+	void (*sync)(void);
+	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
+};
+
+#define ___RCU_SYNC_INIT(name)						\
+	.gp_state = 0,							\
+	.gp_count = 0,							\
+	.gp_wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.gp_wait),		\
+	.cb_state = 0
+
+#define __RCU_SCHED_SYNC_INIT(name) {					\
+	___RCU_SYNC_INIT(name),						\
+	.sync = synchronize_sched,					\
+	.call = call_rcu_sched,						\
+}
+
+#define __RCU_BH_SYNC_INIT(name) {					\
+	___RCU_SYNC_INIT(name),						\
+	.sync = synchronize_rcu_bh,					\
+	.call = call_rcu_bh,						\
+}
+
+#define __RCU_SYNC_INIT(name) {						\
+	___RCU_SYNC_INIT(name),						\
+	.sync = synchronize_rcu,					\
+	.call = call_rcu,						\
+}
+
+#define DEFINE_RCU_SCHED_SYNC(name)					\
+	struct rcu_sync_struct name = __RCU_SCHED_SYNC_INIT(name)
+
+#define DEFINE_RCU_BH_SYNC(name)					\
+	struct rcu_sync_struct name = __RCU_BH_SYNC_INIT(name)
+
+#define DEFINE_RCU_SYNC(name)						\
+	struct rcu_sync_struct name = __RCU_SYNC_INIT(name)
+
+static inline bool rcu_sync_is_idle(struct rcu_sync_struct *rss)
+{
+	return !rss->gp_state; /* GP_IDLE */
+}
+
+enum rcu_sync_type { RCU_SYNC, RCU_SCHED_SYNC, RCU_BH_SYNC };
+
+extern void rcu_sync_init(struct rcu_sync_struct *, enum rcu_sync_type);
+extern void rcu_sync_enter(struct rcu_sync_struct *);
+extern void rcu_sync_exit(struct rcu_sync_struct *);
+
+#endif /* _LINUX_RCUSYNC_H_ */
+
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,8 @@ obj-y     = fork.o exec_domain.o panic.o
 	    kthread.o wait.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
-	    async.o range.o groups.o lglock.o smpboot.o
+	    async.o range.o groups.o lglock.o smpboot.o \
+	    rcusync.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
--- /dev/null
+++ b/kernel/rcusync.c
@@ -0,0 +1,108 @@
+
+#include <linux/rcusync.h>
+#include <linux/sched.h>
+
+enum { GP_IDLE = 0, GP_PENDING, GP_PASSED };
+enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
+
+#define	rss_lock	gp_wait.lock
+
+void rcu_sync_init(struct rcu_sync_struct *rss, enum rcu_sync_type type)
+{
+	memset(rss, 0, sizeof(*rss));
+	init_waitqueue_head(&rss->gp_wait);
+
+	switch (type) {
+	case RCU_SYNC:
+		rss->sync = synchronize_rcu;
+		rss->call = call_rcu;
+		break;
+
+	case RCU_SCHED_SYNC:
+		rss->sync = synchronize_sched;
+		rss->call = call_rcu_sched;
+		break;
+
+	case RCU_BH_SYNC:
+		rss->sync = synchronize_rcu_bh;
+		rss->call = call_rcu_bh;
+		break;
+	}
+}
+
+void rcu_sync_enter(struct rcu_sync_struct *rss)
+{
+	bool need_wait, need_sync;
+
+	spin_lock_irq(&rss->rss_lock);
+	need_wait = rss->gp_count++;
+	need_sync = rss->gp_state == GP_IDLE;
+	if (need_sync)
+		rss->gp_state = GP_PENDING;
+	spin_unlock_irq(&rss->rss_lock);
+
+	BUG_ON(need_wait && need_sync);
+
+	if (need_sync) {
+		rss->sync();
+		rss->gp_state = GP_PASSED;
+		wake_up_all(&rss->gp_wait);
+	} else if (need_wait) {
+		wait_event(rss->gp_wait, rss->gp_state == GP_PASSED);
+	} else {
+		/*
+		 * Possible when there's a pending CB from a rcu_sync_exit().
+		 * Nobody has yet been allowed the 'fast' path and thus we can
+		 * avoid doing any sync(). The callback will get 'dropped'.
+		 */
+		BUG_ON(rss->gp_state != GP_PASSED);
+	}
+}
+
+static void rcu_sync_func(struct rcu_head *rcu)
+{
+	struct rcu_sync_struct *rss =
+		container_of(rcu, struct rcu_sync_struct, cb_head);
+	unsigned long flags;
+
+
+	BUG_ON(rss->gp_state != GP_PASSED);
+	BUG_ON(rss->cb_state == CB_IDLE);
+
+	spin_lock_irqsave(&rss->rss_lock, flags);
+	if (rss->gp_count) {
+		/*
+		 * A new rcu_sync_begin() has happened; drop the callback.
+		 */
+		rss->cb_state = CB_IDLE;
+	} else if (rss->cb_state == CB_REPLAY) {
+		/*
+		 * A new rcu_sync_exit() has happened; requeue the callback
+		 * to catch a later GP.
+		 */
+		rss->cb_state = CB_PENDING;
+		rss->call(&rss->cb_head, rcu_sync_func);
+	} else {
+		/*
+		 * We're at least a GP after rcu_sync_exit(); eveybody will now
+		 * have observed the write side critical section. Let 'em rip!.
+		 */
+		rss->cb_state = CB_IDLE;
+		rss->gp_state = GP_IDLE;
+	}
+	spin_unlock_irqrestore(&rss->rss_lock, flags);
+}
+
+void rcu_sync_exit(struct rcu_sync_struct *rss)
+{
+	spin_lock_irq(&rss->rss_lock);
+	if (!--rss->gp_count) {
+		if (rss->cb_state == CB_IDLE) {
+			rss->cb_state = CB_PENDING;
+			rss->call(&rss->cb_head, rcu_sync_func);
+		} else if (rss->cb_state == CB_PENDING) {
+			rss->cb_state = CB_REPLAY;
+		}
+	}
+	spin_unlock_irq(&rss->rss_lock);
+}


