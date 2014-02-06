Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaBFRrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 12:47:08 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:39681 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaBFRrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 12:47:04 -0500
Message-ID: <52F3C9BE.4050203@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 23:13:26 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: deepthi@linux.vnet.ibm.com, daniel.lezcano@linaro.org,
        linux-pm@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        paulus@samba.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        mingo@kernel.org
Subject: Re: [PATCH V3 2/3] tick/cpuidle: Initialize hrtimer mode of broadcast
References: <20140206054158.4595.17827.stgit@preeti> <20140206055012.4595.55692.stgit@preeti> <alpine.DEB.2.02.1402061655560.21991@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402061655560.21991@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020617-2000-0000-0000-00000F9B818E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 02/06/2014 09:33 PM, Thomas Gleixner wrote:
> On Thu, 6 Feb 2014, Preeti U Murthy wrote:
> 
> Compiler warnings are not so important, right?
> 
> kernel/time/tick-broadcast.c: In function ‘tick_broadcast_oneshot_control’:
> kernel/time/tick-broadcast.c:700:3: warning: ‘return’ with no value, in function returning non-void [-Wreturn-type]
> kernel/time/tick-broadcast.c:711:3: warning: ‘return’ with no value, in function returning non-void [-Wreturn-type]

My apologies for this, will make sure this will not repeat. On compilation I
did not receive any warnings with the additional compile time flags too.I
compiled it on powerpc. Let me look into why the warnings did not show up.
Nevertheless I should have taken care of this even by simply looking at the
code.

> 
>> +		/*
>> +		 * If the current CPU owns the hrtimer broadcast
>> +		 * mechanism, it cannot go deep idle.
>> +		 */
>> +		ret = broadcast_needs_cpu(bc, cpu);
> 
> So we leave the CPU in the broadcast mask, just to force another call
> to the notify code right away to remove it again. Wouldn't it be more
> clever to clear the flag right away? That would make the changes to
> the cpuidle code simpler. Delta patch below.

You are right.
> 
> Thanks,
> 
> 	tglx
> ---
> 
> --- tip.orig/kernel/time/tick-broadcast.c
> +++ tip/kernel/time/tick-broadcast.c
> @@ -697,7 +697,7 @@ int tick_broadcast_oneshot_control(unsig
>  	 * states
>  	 */
>  	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
> -		return;
> +		return 0;
> 
>  	/*
>  	 * We are called with preemtion disabled from the depth of the
> @@ -708,7 +708,7 @@ int tick_broadcast_oneshot_control(unsig
>  	dev = td->evtdev;
> 
>  	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
> -		return;
> +		return 0;
> 
>  	bc = tick_broadcast_device.evtdev;
> 
> @@ -731,9 +731,14 @@ int tick_broadcast_oneshot_control(unsig
>  		}
>  		/*
>  		 * If the current CPU owns the hrtimer broadcast
> -		 * mechanism, it cannot go deep idle.
> +		 * mechanism, it cannot go deep idle and we remove the
> +		 * CPU from the broadcast mask. We don't have to go
> +		 * through the EXIT path as the local timer is not
> +		 * shutdown.
>  		 */
>  		ret = broadcast_needs_cpu(bc, cpu);
> +		if (ret)
> +			cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
>  	} else {
>  		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
>  			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
> 
> 

The cpuidle patch then is below. The trace_cpu_idle_rcuidle() functions have
been moved around so that the broadcast CPU does not trace any idle event
and that the symmetry between the trace functions and the call to the
broadcast framework is  maintained. Wow, it does become very simple :)


time/cpuidle:Handle failed call to BROADCAST_ENTER on archs with CPUIDLE_FLAG_TIMER_STOP set

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Some archs set the CPUIDLE_FLAG_TIMER_STOP flag for idle states in which the
local timers stop. The cpuidle_idle_call() currently handles such idle states
by calling into the broadcast framework so as to wakeup CPUs at their next
wakeup event. With the hrtimer mode of broadcast, the BROADCAST_ENTER call
into the broadcast frameowork can fail for archs that do not have an external
clock device to handle wakeups and the CPU in question has to thus be made
the stand by CPU. This patch handles such cases by failing the call into
cpuidle so that the arch can take some default action. The arch will certainly
not enter a similar idle state because a failed cpuidle call will also implicitly
indicate that the broadcast framework has not registered this CPU to be woken up.
Hence we are safe if we fail the cpuidle call.

In the process move the functions that trace idle statistics just before and
after the entry and exit into idle states respectively. In other
scenarios where the call to cpuidle fails, we end up not tracing idle
entry and exit since a decision on an idle state could not be taken. Similarly
when the call to broadcast framework fails, we skip tracing idle statistics
because we are in no further position to take a decision on an alternative
idle state to enter into.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index a55e68f..8beb0f02 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -140,12 +140,14 @@ int cpuidle_idle_call(void)
 		return 0;
 	}
 
-	trace_cpu_idle_rcuidle(next_state, dev->cpu);
-
 	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
 
-	if (broadcast)
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
+	if (broadcast &&
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
+		return -EBUSY;
+
+
+	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
 	if (cpuidle_state_is_coupled(dev, drv, next_state))
 		entered_state = cpuidle_enter_state_coupled(dev, drv,
@@ -153,11 +155,11 @@ int cpuidle_idle_call(void)
 	else
 		entered_state = cpuidle_enter_state(dev, drv, next_state);
 
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+
 	if (broadcast)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
 
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
-
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev, entered_state);



Thank you

Regards
Preeti U Murthy

