Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaBYDji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:39:38 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60579 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaBYDjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:39:37 -0500
Message-ID: <530C0F98.4050006@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 09:05:52 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC: mingo@kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/5] idle/cpuidle: Split cpuidle_idle_call main function
 into smaller functions
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org> <20140224150004.GX27965@twins.programming.kicks-ass.net> <530B6147.6010301@linaro.org> <20140224151644.GY27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140224151644.GY27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022503-1542-0000-0000-00000697253A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter, Daniel,

On 02/24/2014 08:46 PM, Peter Zijlstra wrote:
> On Mon, Feb 24, 2014 at 04:12:07PM +0100, Daniel Lezcano wrote:
>> On 02/24/2014 04:00 PM, Peter Zijlstra wrote:
>>>
>>>
>>> None of this actually applies :/ I'm having major conflicts in
>>> driveres/cpuidle/cpuidle.c.
>>
>> Ok, except if I am missing something, the patchset is based on top of
>> tip/sched/core (commit 6990566).
> 
> Ah! So the below commit from the timers/core branch is in the way.

I had informed Daniel earlier of a possible conflict here. Anyway, I
think this patch should not move the BROADCAST_ENTER notification
out of the cpuidle_idle_call(). The reasons are:

1. Even if the patch handles the failed call to BROADCAST_ENTER in
cpuidle_enter(), you would have traced an entry into an idle state earlier
to this. If the entry into broadcast fails we should not be tracing either.

2. Moving the trace after the cpuidle_enter() call is wrong.

So I would suggest the patch at the end of this mail as the alternative
to this one so as to get around the patching conflict.

Thanks

Regards
Preeti U Murthy

> 
> Thomas, Ingo, how do we go about solving this sched/core vs timers/core
> conflict?
> 
> ---
> 
> # git log 6990566..tip/master drivers/cpuidle/
> commit 2f60b8ae0b2a006e4d3452e57ea98b59ce985d14
> Merge: 9eaf844efc23 849401b66d30
> Author: Ingo Molnar <mingo@kernel.org>
> Date:   Sat Feb 22 18:52:27 2014 +0100
> 
>     Merge branch 'timers/core'
> 
> commit ba8f20c2eb4158a443e9d6a909aee5010efa0c69
> Author: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> Date:   Fri Feb 7 13:36:52 2014 +0530
> 
>     cpuidle: Handle clockevents_notify(BROADCAST_ENTER) failure
>     
>     Some archs set the CPUIDLE_FLAG_TIMER_STOP flag for idle states in which the
>     local timers stop. The cpuidle_idle_call() currently handles such idle states
>     by calling into the broadcast framework so as to wakeup CPUs at their next
>     wakeup event. With the hrtimer mode of broadcast, the BROADCAST_ENTER call
>     into the broadcast frameowork can fail for archs that do not have an external
>     clock device to handle wakeups and the CPU in question has thus to be made
>     the stand by CPU. This patch handles such cases by failing the call into
>     cpuidle so that the arch can take some default action. The arch will certainly
>     not enter a similar idle state because a failed cpuidle call will also implicitly
>     indicate that the broadcast framework has not registered this CPU to be woken up.
>     Hence we are safe if we fail the cpuidle call.
>     
>     In the process move the functions that trace idle statistics just before and
>     after the entry and exit into idle states respectively. In other
>     scenarios where the call to cpuidle fails, we end up not tracing idle
>     entry and exit since a decision on an idle state could not be taken. Similarly
>     when the call to broadcast framework fails, we skip tracing idle statistics
>     because we are in no further position to take a decision on an alternative
>     idle state to enter into.
>     
>     Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>     Cc: deepthi@linux.vnet.ibm.com
>     Cc: paulmck@linux.vnet.ibm.com
>     Cc: fweisbec@gmail.com
>     Cc: paulus@samba.org
>     Cc: srivatsa.bhat@linux.vnet.ibm.com
>     Cc: svaidy@linux.vnet.ibm.com
>     Cc: peterz@infradead.org
>     Cc: benh@kernel.crashing.org
>     Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     Cc: linuxppc-dev@lists.ozlabs.org
>     Link: http://lkml.kernel.org/r/20140207080652.17187.66344.stgit@preeti.in.ibm.com
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle.c |   98 ++++++++++++++++++++++++++++++++++++---------
 include/linux/cpuidle.h   |   19 +++++++++
 2 files changed, 98 insertions(+), 19 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 09d05ab..a58c15b 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -65,6 +65,26 @@ int cpuidle_play_dead(void)
 }
 
 /**
+ * cpuidle_enabled - check if the cpuidle framework is ready
+ * @dev: cpuidle device for this cpu
+ * @drv: cpuidle driver for this cpu
+ *
+ * Return 0 on success, otherwise:
+ * -NODEV : the cpuidle framework is not available
+ * -EBUSY : the cpuidle framework is not initialized
+ */
+int cpuidle_enabled(struct cpuidle_driver *drv, struct cpuidle_device *dev)
+{
+	if (off || !initialized)
+		return -ENODEV;
+
+	if (!drv || !dev || !dev->enabled)
+		return -EBUSY;
+
+	return 0;
+}
+
+/**
  * cpuidle_enter_state - enter the state and update stats
  * @dev: cpuidle device for this cpu
  * @drv: cpuidle driver for this cpu
@@ -108,6 +128,56 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
 }
 
 /**
+ * cpuidle_select - ask the cpuidle framework to choose an idle state
+ *
+ * @drv: the cpuidle driver
+ * @dev: the cpuidle device
+ *
+ * Returns the index of the idle state.
+ */
+int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
+{
+	return cpuidle_curr_governor->select(drv, dev);
+}
+
+/**
+ * cpuidle_enter - enter into the specified idle state
+ *
+ * @drv:   the cpuidle driver tied with the cpu
+ * @dev:   the cpuidle device
+ * @index: the index in the idle state table
+ *
+ * Returns the index in the idle state, < 0 in case of error.
+ * The error code depends on the backend driver
+ */
+int cpuidle_enter(struct cpuidle_driver *drv, struct cpuidle_device *dev,
+		  int index)
+{
+	int entered_state;
+
+	if (cpuidle_state_is_coupled(dev, drv, index))
+		entered_state = cpuidle_enter_state_coupled(dev, drv, index);
+	else
+		entered_state = cpuidle_enter_state(dev, drv, index);
+
+	return entered_state;
+}
+
+/**
+ * cpuidle_reflect - tell the underlying governor what was the state
+ * we were in
+ *
+ * @dev  : the cpuidle device
+ * @index: the index in the idle state table
+ *
+ */
+void cpuidle_reflect(struct cpuidle_device *dev, int index)
+{
+	if (cpuidle_curr_governor->reflect)
+		cpuidle_curr_governor->reflect(dev, index);
+}
+
+/**
  * cpuidle_idle_call - the main idle loop
  *
  * NOTE: no locks or semaphores should be used here
@@ -116,26 +186,21 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
 int cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
-	struct cpuidle_driver *drv;
+	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
 	int next_state, entered_state;
 	bool broadcast;
 
-	if (off || !initialized)
-		return -ENODEV;
-
-	/* check if the device is ready */
-	if (!dev || !dev->enabled)
-		return -EBUSY;
-
-	drv = cpuidle_get_cpu_driver(dev);
+	next_state = cpuidle_enabled(drv, dev);
+	if (next_state < 0)
+		return next_state;
 
 	/* ask the governor for the next state */
-	next_state = cpuidle_curr_governor->select(drv, dev);
+	next_state = cpuidle_select(drv, dev);
+
 	if (need_resched()) {
 		dev->last_residency = 0;
 		/* give the governor an opportunity to reflect on the outcome */
-		if (cpuidle_curr_governor->reflect)
-			cpuidle_curr_governor->reflect(dev, next_state);
+		cpuidle_reflect(dev, next_state);
 		local_irq_enable();
 		return 0;
 	}
@@ -149,11 +214,7 @@ int cpuidle_idle_call(void)
 
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
-	if (cpuidle_state_is_coupled(dev, drv, next_state))
-		entered_state = cpuidle_enter_state_coupled(dev, drv,
-							    next_state);
-	else
-		entered_state = cpuidle_enter_state(dev, drv, next_state);
+	entered_state = cpuidle_enter(drv, dev, next_state);
 
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
 
@@ -161,8 +222,7 @@ int cpuidle_idle_call(void)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
 
 	/* give the governor an opportunity to reflect on the outcome */
-	if (cpuidle_curr_governor->reflect)
-		cpuidle_curr_governor->reflect(dev, entered_state);
+	cpuidle_reflect(dev, entered_state);
 
 	return 0;
 }
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 50fcbb0..accc2dd 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -119,6 +119,15 @@ struct cpuidle_driver {
 
 #ifdef CONFIG_CPU_IDLE
 extern void disable_cpuidle(void);
+
+extern int cpuidle_enabled(struct cpuidle_driver *drv,
+			  struct cpuidle_device *dev);
+extern int cpuidle_select(struct cpuidle_driver *drv,
+			  struct cpuidle_device *dev);
+extern int cpuidle_enter(struct cpuidle_driver *drv,
+			 struct cpuidle_device *dev, int index);
+extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
+
 extern int cpuidle_idle_call(void);
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
 extern struct cpuidle_driver *cpuidle_get_driver(void);
@@ -141,6 +150,16 @@ extern int cpuidle_play_dead(void);
 extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev);
 #else
 static inline void disable_cpuidle(void) { }
+static inline int cpuidle_enabled(struct cpuidle_driver *drv,
+				  struct cpuidle_device *dev)
+{return -ENODEV; }
+static inline int cpuidle_select(struct cpuidle_driver *drv,
+				 struct cpuidle_device *dev)
+{return -ENODEV; }
+static inline int cpuidle_enter(struct cpuidle_driver *drv,
+				struct cpuidle_device *dev, int index)
+{return -ENODEV; }
+static inline void cpuidle_reflect(struct cpuidle_device *dev, int index) { }
 static inline int cpuidle_idle_call(void) { return -ENODEV; }
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return -ENODEV; }

