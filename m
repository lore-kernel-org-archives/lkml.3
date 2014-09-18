Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbaISPKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:10:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038AbaISPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:10:12 -0400
Date: Fri, 19 Sep 2014 01:46:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 2/2] sched/fair: leverage the idle state info when
 choosing the "idlest" cpu
Message-ID: <20140918234628.GQ2848@worktop.localdomain>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org>
 <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409844730-12273-3-git-send-email-nicolas.pitre@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 11:32:10AM -0400, Nicolas Pitre wrote:
> The code in find_idlest_cpu() looks for the CPU with the smallest load.
> However, if multiple CPUs are idle, the first idle CPU is selected
> irrespective of the depth of its idle state.
> 
> Among the idle CPUs we should pick the one with with the shallowest idle
> state, or the latest to have gone idle if all idle CPUs are in the same
> state.  The later applies even when cpuidle is configured out.
> 
> This patch doesn't cover the following issues:
> 
> - The idle exit latency of a CPU might be larger than the time needed
>   to migrate the waking task to an already running CPU with sufficient
>   capacity, and therefore performance would benefit from task packing
>   in such case (in most cases task packing is about power saving).
> 
> - Some idle states have a non negligible and non abortable entry latency
>   which needs to run to completion before the exit latency can start.
>   A concurrent patch series is making this info available to the cpuidle
>   core.  Once available, the entry latency with the idle timestamp could
>   determine when the exit latency may be effective.
> 
> Those issues will be handled in due course.  In the mean time, what
> is implemented here should improve things already compared to the current
> state of affairs.
> 
> Based on an initial patch from Daniel Lezcano.
> 
> Signed-off-by: Nicolas Pitre <nico@linaro.org>
> ---
>  kernel/sched/fair.c | 43 ++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 36 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bfa3c86d0d..416329e1a6 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -23,6 +23,7 @@
>  #include <linux/latencytop.h>
>  #include <linux/sched.h>
>  #include <linux/cpumask.h>
> +#include <linux/cpuidle.h>
>  #include <linux/slab.h>
>  #include <linux/profile.h>
>  #include <linux/interrupt.h>
> @@ -4428,20 +4429,48 @@ static int
>  find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)

Ah, now I see, you use it in find_idlest_cpu(), that does not indeed
hold rq->lock, but it does already hold rcu_read_lock(), so in that
regard sync_rcu() should be the right primitive.

I suppose we want the same kind of logic in select_idle_sibling() and
that too already has rcu_read_lock().

So I'll replace the kick_all_cpus_sync() with sync_rcu() and add a
WARN_ON(!rcu_read_lock_held()) to idle_get_state(), like the below.

I however do think we need a few word on why we don't need
rcu_assign_pointer() and rcu_dereference() for rq->idle_state -- and I
do indeed think we do not because the idle state data is static.

---
Subject: sched: let the scheduler see CPU idle states
From: Daniel Lezcano <daniel.lezcano@linaro.org>
Date: Thu, 04 Sep 2014 11:32:09 -0400

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

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Nicolas Pitre <nico@linaro.org>
---
 drivers/cpuidle/cpuidle.c |    6 ++++++
 kernel/sched/idle.c       |    6 ++++++
 kernel/sched/sched.h      |   30 ++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -225,6 +225,12 @@ void cpuidle_uninstall_idle_handler(void
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
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -147,6 +147,9 @@ static void cpuidle_idle_call(void)
 	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
 		goto use_default;
 
+	/* Take note of the planned idle state. */
+	idle_set_state(this_rq(), &drv->states[next_state]);
+
 	/*
 	 * Enter the idle state previously returned by the governor decision.
 	 * This function will block until an interrupt occurs and will take
@@ -154,6 +157,9 @@ static void cpuidle_idle_call(void)
 	 */
 	entered_state = cpuidle_enter(drv, dev, next_state);
 
+	/* The cpu is no longer idle or about to enter idle. */
+	idle_set_state(this_rq(), NULL);
+
 	if (broadcast)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
 
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -14,6 +14,7 @@
 #include "cpuacct.h"
 
 struct rq;
+struct cpuidle_state;
 
 /* task_struct::on_rq states: */
 #define TASK_ON_RQ_QUEUED	1
@@ -640,6 +641,11 @@ struct rq {
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
@@ -1193,6 +1199,30 @@ static inline void idle_exit_fair(struct
 
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
