Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbaIXPHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:07:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59592 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaIXO4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:56:04 -0400
Date: Wed, 24 Sep 2014 07:55:23 -0700
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-442bf3aaf55a91ebfec71da46a4ee10a3c905bcc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, nico@linaro.org,
        tglx@linutronix.de, rjw@rjwysocki.net, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, nico@linaro.org,
        tglx@linutronix.de, rjw@rjwysocki.net, daniel.lezcano@linaro.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Let the scheduler see CPU idle states
Git-Commit-ID: 442bf3aaf55a91ebfec71da46a4ee10a3c905bcc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  442bf3aaf55a91ebfec71da46a4ee10a3c905bcc
Gitweb:     http://git.kernel.org/tip/442bf3aaf55a91ebfec71da46a4ee10a3c905bcc
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Thu, 4 Sep 2014 11:32:09 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:46:58 +0200

sched: Let the scheduler see CPU idle states

When the cpu enters idle, it stores the cpuidle state pointer in its
struct rq instance which in turn could be used to make a better decision
when balancing tasks.

As soon as the cpu exits its idle state, the struct rq reference is
cleared.

There are a couple of situations where the idle state pointer could be changed
while it is being consulted:

1. For x86/acpi with dynamic c-states, when a laptop switches from battery
   to AC that could result on removing the deeper idle state. The acpi driver
   triggers:
	'acpi_processor_cst_has_changed'
		'cpuidle_pause_and_lock'
			'cpuidle_uninstall_idle_handler'
				'kick_all_cpus_sync'.

All cpus will exit their idle state and the pointed object will be set to
NULL.

2. The cpuidle driver is unloaded. Logically that could happen but not
in practice because the drivers are always compiled in and 95% of them are
not coded to unregister themselves.  In any case, the unloading code must
call 'cpuidle_unregister_device', that calls 'cpuidle_pause_and_lock'
leading to 'kick_all_cpus_sync' as mentioned above.

A race can happen if we use the pointer and then one of these two scenarios
occurs at the same moment.

In order to be safe, the idle state pointer stored in the rq must be
used inside a rcu_read_lock section where we are protected with the
'rcu_barrier' in the 'cpuidle_uninstall_idle_handler' function. The
idle_get_state() and idle_put_state() accessors should be used to that
effect.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-pm@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/cpuidle/cpuidle.c |  6 ++++++
 kernel/sched/idle.c       |  6 ++++++
 kernel/sched/sched.h      | 30 ++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index d31e04c..125150d 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -225,6 +225,12 @@ void cpuidle_uninstall_idle_handler(void)
 		initialized = 0;
 		wake_up_all_idle_cpus();
 	}
+
+	/*
+	 * Make sure external observers (such as the scheduler)
+	 * are done looking at pointed idle states.
+	 */
+	synchronize_rcu();
 }
 
 /**
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 11e7bc4..c47fce7 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -147,6 +147,9 @@ use_default:
 	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
 		goto use_default;
 
+	/* Take note of the planned idle state. */
+	idle_set_state(this_rq(), &drv->states[next_state]);
+
 	/*
 	 * Enter the idle state previously returned by the governor decision.
 	 * This function will block until an interrupt occurs and will take
@@ -154,6 +157,9 @@ use_default:
 	 */
 	entered_state = cpuidle_enter(drv, dev, next_state);
 
+	/* The cpu is no longer idle or about to enter idle. */
+	idle_set_state(this_rq(), NULL);
+
 	if (broadcast)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 76f3a38..16e1ca9 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -14,6 +14,7 @@
 #include "cpuacct.h"
 
 struct rq;
+struct cpuidle_state;
 
 /* task_struct::on_rq states: */
 #define TASK_ON_RQ_QUEUED	1
@@ -643,6 +644,11 @@ struct rq {
 #ifdef CONFIG_SMP
 	struct llist_head wake_list;
 #endif
+
+#ifdef CONFIG_CPU_IDLE
+	/* Must be inspected within a rcu lock section */
+	struct cpuidle_state *idle_state;
+#endif
 };
 
 static inline int cpu_of(struct rq *rq)
@@ -1196,6 +1202,30 @@ static inline void idle_exit_fair(struct rq *rq) { }
 
 #endif
 
+#ifdef CONFIG_CPU_IDLE
+static inline void idle_set_state(struct rq *rq,
+				  struct cpuidle_state *idle_state)
+{
+	rq->idle_state = idle_state;
+}
+
+static inline struct cpuidle_state *idle_get_state(struct rq *rq)
+{
+	WARN_ON(!rcu_read_lock_held());
+	return rq->idle_state;
+}
+#else
+static inline void idle_set_state(struct rq *rq,
+				  struct cpuidle_state *idle_state)
+{
+}
+
+static inline struct cpuidle_state *idle_get_state(struct rq *rq)
+{
+	return NULL;
+}
+#endif
+
 extern void sysrq_sched_debug_show(void);
 extern void sched_init_granularity(void);
 extern void update_max_interval(void);
