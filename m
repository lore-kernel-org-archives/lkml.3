Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaC0KSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 06:18:35 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58500 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaC0KSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 06:18:33 -0400
Message-ID: <5333FA02.3090402@linux.vnet.ibm.com>
Date: Thu, 27 Mar 2014 15:44:26 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, tglx@linutronix.de
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, rjw@rjwysocki.net, paulmck@linux.vnet.ibm.com,
        davem@davemloft.net
Subject: Re: [PATCH] tick, broadcast: Prevent false alarm when force mask
 contains offline cpus
References: <20140326035648.21736.85740.stgit@preeti.in.ibm.com> <5332B833.2030701@linux.vnet.ibm.com> <533394C7.1000702@linux.vnet.ibm.com> <5333C521.10901@linux.vnet.ibm.com>
In-Reply-To: <5333C521.10901@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032710-9332-0000-0000-0000003CBCE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 11:58 AM, Srivatsa S. Bhat wrote:
> 
> Actually, my suggestion was to remove the dying CPU from the force_mask alone,
> in the CPU_DYING notifier. The rest of the cleanup (removing it from the other
> masks, moving the broadcast duty to someone else etc can still be done at
> the CPU_DEAD stage). Also, note that the CPU which is set in force_mask is
> definitely not the one doing the broadcast.
> 
> Basically, my reasoning was this:
> 
> If we look at how the 3 broadcast masks (oneshot, pending and force) are
> set and cleared during idle entry/exit, we see this pattern:
> 
> oneshot_mask: This is set at BROADCAST_ENTER and cleared at EXIT.
> pending_mask: This is set at tick_handle_oneshot_broadcast and cleared at
>               EXIT.
> force_mask:   This is set at EXIT and cleared at the next call to
>               tick_handle_oneshot_broadcast. (Also, if the CPU is set in this
>               mask, the CPU doesn't enter deep idle states in subsequent
>               idle durations, and keeps polling instead, until it gets the
>               broadcast interrupt).
> 
> What we can derive from this is that force_mask is the only mask that can
> remain set across an idle ENTER/EXIT sequence. Both of the other 2 masks
> can never remain set across a full idle ENTER/EXIT sequence. And a CPU going
> offline certainly goes through EXIT if it had gone through ENTER, before
> entering stop_machine().
> 
> That means, force_mask is the only odd one out here, which can remain set
> when entering stop_machine() for CPU offline. So that's the only mask that
> needs to be cleared separately. The other 2 masks take care of themselves
> automatically. So, we can have a CPU_DYING callback which just clears the
> dying CPU from the force_mask (and does nothing more). That should work, no?

Yep I think this will work. Find the modified patch below:

Thanks.

Regards
Preeti U Murthy


tick,broadcast:Clear hotplugged cpu in broadcast masks during CPU_DYING notification

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Its possible that the tick_broadcast_force_mask contains cpus which are not
in cpu_online_mask when a broadcast tick occurs. This could happen under the
following circumstance assuming CPU1 is among the CPUs waiting for broadcast.

CPU0					CPU1

Run CPU_DOWN_PREPARE notifiers

Start stop_machine			Gets woken up by IPI to run
					stop_machine, sets itself in
					tick_broadcast_force_mask if the
					time of broadcast interrupt is around
					the same time as this IPI.

					Start stop_machine
					  set_cpu_online(cpu1, false)
End stop_machine			End stop_machine

Broadcast interrupt
  Finds that cpu1 in
  tick_broadcast_force_mask is offline
  and triggers the WARN_ON in
  tick_handle_oneshot_broadcast()

Clears all broadcast masks
in CPU_DEAD stage.

While the hotplugged cpu clears its bit in the tick_broadcast_oneshot_mask
and tick_broadcast_pending mask during BROADCAST_EXIT, it *sets* its bit
in the tick_broadcast_force_mask if the broadcast interrupt is found to be
around the same time as the present time. Today we clear all the broadcast
masks and shutdown tick devices in the CPU_DEAD stage. But as shown above
the broadcast interrupt could occur before this stage is reached and the
WARN_ON() gets triggered when it is found that the tick_broadcast_force_mask
contains an offline cpu.

This WARN_ON was added to capture scenarios where the broadcast mask, be it
oneshot/pending/force_mask contain offline cpus whose tick devices have been
removed. But here is a case where we trigger the WARN_ON() when the tick
device of the hotplugged cpu is still around but we are delaying the clearing
of the broadcast masks. This has not been a problem for
tick_broadcastoneshot_mask and tick_broadcast_pending_mask since they get
cleared on exit from broadcast.
   But since the force_mask gets set at the same time on certain occasions
it is necessary to move the clearing of masks to a stage during cpu hotplug
before the hotplugged cpu clears itself in the online_mask.

Hence move the clearing of broadcast masks to the CPU_DYING notification stage
so that they remain consistent with the cpu_online_mask at the time of
broadcast delivery at all times.

Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/time/clockevents.c    |    1 +
 kernel/time/tick-broadcast.c |   20 +++++++++++++++-----
 kernel/time/tick-internal.h  |    3 +++
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index ad362c2..d33d808 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -566,6 +566,7 @@ int clockevents_notify(unsigned long reason, void *arg)
 
 	case CLOCK_EVT_NOTIFY_CPU_DYING:
 		tick_handover_do_timer(arg);
+		tick_broadcast_clear_masks(arg);
 		break;
 
 	case CLOCK_EVT_NOTIFY_SUSPEND:
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 63c7b2d..4e5a7a6 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -893,9 +893,10 @@ void tick_broadcast_switch_to_oneshot(void)
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
-
 /*
- * Remove a dead CPU from broadcasting
+ * Move the broadcasting function away from a dead CPU
+ * if it is used for broadcasting in the hrtimer mode of
+ * broadcast.
  */
 void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 {
@@ -904,6 +905,18 @@ void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
+	broadcast_move_bc(cpu);
+
+	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+}
+
+void tick_broadcast_clear_masks(unsigned int *cpup)
+{
+	unsigned long flags;
+	unsigned int cpu = *cpup;
+
+	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
+
 	/*
 	 * Clear the broadcast masks for the dead cpu, but do not stop
 	 * the broadcast device!
@@ -912,11 +925,8 @@ void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
 	cpumask_clear_cpu(cpu, tick_broadcast_pending_mask);
 	cpumask_clear_cpu(cpu, tick_broadcast_force_mask);
 
-	broadcast_move_bc(cpu);
-
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
-
 /*
  * Check, whether the broadcast device is in one shot mode
  */
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 7ab92b1..259c74d 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -49,6 +49,7 @@ extern void tick_broadcast_setup_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_control(unsigned long reason);
 extern void tick_broadcast_switch_to_oneshot(void);
 extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
+extern void tick_broadcast_clear_masks(unsigned int *cpup);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_active(void);
 extern void tick_check_oneshot_broadcast_this_cpu(void);
@@ -61,6 +62,7 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 static inline int tick_broadcast_oneshot_control(unsigned long reason) { return 0; }
 static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
+static inline void tick_broadcast_clear_masks(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
 static inline void tick_check_oneshot_broadcast_this_cpu(void) { }
 static inline bool tick_broadcast_oneshot_available(void) { return true; }
@@ -89,6 +91,7 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 }
 static inline int tick_broadcast_oneshot_control(unsigned long reason) { return 0; }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
+static inline void tick_broadcast_clear_masks(unsigned int *cpup) { }
 static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
 	return 0;

