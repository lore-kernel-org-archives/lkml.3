Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbaISPN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:13:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:41854 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370AbaISPKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:10:10 -0400
Date: Fri, 19 Sep 2014 01:28:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 1/2] sched: let the scheduler see CPU idle states
Message-ID: <20140918232832.GC3037@worktop.localdomain>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org>
 <1409844730-12273-2-git-send-email-nicolas.pitre@linaro.org>
 <20140918173733.GQ4723@linux.vnet.ibm.com>
 <alpine.LFD.2.11.1409181425080.8647@knanqh.ubzr>
 <20140918231715.GO2848@worktop.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918231715.GO2848@worktop.localdomain>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 01:17:15AM +0200, Peter Zijlstra wrote:
> On Thu, Sep 18, 2014 at 02:32:25PM -0400, Nicolas Pitre wrote:
> > On Thu, 18 Sep 2014, Paul E. McKenney wrote:
> 
> > > So what is it that you really need to do here?
> > 
> > In short, we don't want the cpufreq data to go away (see the 2 scenarios 
> > above) while the scheduler is looking at it.  The scheduler uses the 
> > provided accessors (see patch 2/2) so we can put any protection 
> > mechanism we want in them.  A simple spinlock could do just as well 
> > which should be good enough.
> 
> rq->lock disables interrupts so on that something like
> kick_all_cpus_sync() will guarantee what you need --
> wake_up_all_idle_cpus() will not.

Something like so then?

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
 kernel/sched/sched.h      |   29 +++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

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
+	kick_all_cpus_sync();
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
@@ -1193,6 +1199,29 @@ static inline void idle_exit_fair(struct
 
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
