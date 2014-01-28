Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaA1Kwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:52:47 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:54035 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbaA1Kwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:52:45 -0500
Message-ID: <52E78B1F.80409@linux.vnet.ibm.com>
Date: Tue, 28 Jan 2014 16:19:03 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: daniel.lezcano@linaro.org, peterz@infradead.org, fweisbec@gmail.com,
        galak@kernel.crashing.org, paul.gortmaker@windriver.com,
        paulus@samba.org, mingo@kernel.org, mikey@neuling.org,
        shangw@linux.vnet.ibm.com, rafael.j.wysocki@intel.com, agraf@suse.de,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, anton@samba.org, tglx@linutronix.de,
        chenhui.zhao@freescale.com, deepthi@linux.vnet.ibm.com,
        r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V2 0/2] time/cpuidle: Support in tick broadcast framework
 in absence of external clock device
References: <20140124065501.17564.39363.stgit@preeti.in.ibm.com>
In-Reply-To: <20140124065501.17564.39363.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012810-0928-0000-0000-000006059261
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

I realized that the below patch is also required for this patchset.

This patch apart, I noticed that there is also one corner case which we will
need to handle. The BROADCAST_ON notifications in periodic mode
(oneshot mode is a nop).
  We will need to fail the BROADCAST_ON notification too in this case if the
CPU in question is made the stand by CPU. 

Thanks

Regards
Preeti U Murthy

---------------------------------------------------------------------------------

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
 drivers/cpuidle/cpuidle.c |   38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index a55e68f..8f42033 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -117,15 +117,19 @@ int cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv;
-	int next_state, entered_state;
-	bool broadcast;
+	int next_state, entered_state, ret = 0;
+	bool broadcast = false;
 
-	if (off || !initialized)
-		return -ENODEV;
+	if (off || !initialized) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	/* check if the device is ready */
-	if (!dev || !dev->enabled)
-		return -EBUSY;
+	if (!dev || !dev->enabled) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	drv = cpuidle_get_cpu_driver(dev);
 
@@ -137,15 +141,18 @@ int cpuidle_idle_call(void)
 		if (cpuidle_curr_governor->reflect)
 			cpuidle_curr_governor->reflect(dev, next_state);
 		local_irq_enable();
-		return 0;
+		goto out;
 	}
 
-	trace_cpu_idle_rcuidle(next_state, dev->cpu);
-
 	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
 
-	if (broadcast)
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
+	if (broadcast) {
+		ret = clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
+		if (ret)
+			goto out;
+	}
+
+	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
 	if (cpuidle_state_is_coupled(dev, drv, next_state))
 		entered_state = cpuidle_enter_state_coupled(dev, drv,
@@ -153,16 +160,17 @@ int cpuidle_idle_call(void)
 	else
 		entered_state = cpuidle_enter_state(dev, drv, next_state);
 
-	if (broadcast)
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
-
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
 
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev, entered_state);
 
-	return 0;
+out:	if (broadcast)
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
+
+
+	return ret;
 }
 
 /**

