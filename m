Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3BGKEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:04:11 -0500
Received: from service87.mimecast.com ([91.220.42.44]:37212 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3BGKEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:04:08 -0500
Date: Thu, 7 Feb 2013 10:04:03 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv3 4/4] arm: Add generic timer broadcast support
Message-ID: <20130207100403.GD16987@e106331-lin.cambridge.arm.com>
References: <1358183124-28461-1-git-send-email-mark.rutland@arm.com>
 <1358183124-28461-5-git-send-email-mark.rutland@arm.com>
 <5112C25F.6000508@wwwdotorg.org>
MIME-Version: 1.0
In-Reply-To: <5112C25F.6000508@wwwdotorg.org>
Thread-Topic: [PATCHv3 4/4] arm: Add generic timer broadcast support
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Feb 2013 10:04:04.0045 (UTC) FILETIME=[75971FD0:01CE051A]
X-MC-Unique: 113020710040507001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Sorry about this; I'm to blame for the bug.

On Wed, Feb 06, 2013 at 08:51:43PM +0000, Stephen Warren wrote:
> On 01/14/2013 10:05 AM, Mark Rutland wrote:
> > Implement timer_broadcast for the arm architecture, allowing for the use
> > of clock_event_device_drivers decoupled from the timer tick broadcast
> > mechanism.
> 
> Mark, this patch is now in next-20130206 and causes a crash during boot
> on Tegra. The reason appears to be because of:
> 
> > diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> 
> > @@ -524,7 +524,6 @@ static void __cpuinit percpu_timer_setup(void)
> >  	struct clock_event_device *evt = &per_cpu(percpu_clockevent, cpu);
> >  
> >  	evt->cpumask = cpumask_of(cpu);
> > -	evt->broadcast = smp_timer_broadcast;
> 
> After that change, evt->broadcast is never assigned, and hence is NULL.
> Yet elsewhere in kernel/time/tick-broadcast.c it's used unconditionally:
> 
> static void tick_do_broadcast(struct cpumask *mask)
> ...
> 	if (!cpumask_empty(mask)) {
> ...
> 		td = &per_cpu(tick_cpu_device, cpumask_first(mask));
> 		td->evtdev->broadcast(mask);
> 
> Now perhaps the Tegra timer driver simply isn't being set up correctly,
> so the bug is there... But the only other place I can find where
> ->broadcast is assigned is in tick_device_uses_broadcast() which only
> does it for "non-functional" timers, which doesn't apply to Tegra's timer.
> 

The intent of 12ad100046: "clockevents: Add generic timer broadcast function"
was to setup the broadcast function both for non-functional/dummy timers and
those that stop in low-power states (CLOCK_EVT_FEAT_C3STOP). I missed the
CLOCK_EVT_FEAT_C3STOP case.

I believe the patch below will fix this for Tegra and any other platforms where
broadcast is required in low power states.

Stephen, could you test this for Tegra?

Thanks,
Mark.

---->8----
>From a93b7fa8b23464a69d0fb88dce0528ab1abd276d Mon Sep 17 00:00:00 2001
From: Mark Rutland <mark.rutland@arm.com>
Date: Thu, 7 Feb 2013 09:35:29 +0000
Subject: [PATCH] clockevents: fix generic broadcast for FEAT_C3STOP

Commit 12ad100046: "clockevents: Add generic timer broadcast function"
made tick_device_uses_broadcast set up the generic broadcast function
for dummy devices (where !tick_device_is_functional(dev)), but neglected
to set up the broadcast function for devices that stop in low power
states (with the CLOCK_EVT_FEAT_C3STOP flag).

When these devices enter low power states they will not have the generic
broadcast function assigned, and will bring down the system when an
attempt is made to broadcast to them.

This patch ensures that the broadcast function is also assigned for
devices which require broadcast in low power states.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 kernel/time/tick-broadcast.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f726537..2fb8cb8 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -92,6 +92,17 @@ static void err_broadcast(const struct cpumask *mask)
 	pr_crit_once("Failed to broadcast timer tick. Some CPUs may be unresponsive.\n");
 }
 
+static void tick_device_setup_broadcast_func(struct clock_event_device *dev)
+{
+	if (!dev->broadcast)
+		dev->broadcast = tick_broadcast;
+	if (!dev->broadcast) {
+		pr_warn_once("%s depends on broadcast, but no broadcast function available\n",
+			     dev->name);
+		dev->broadcast = err_broadcast;
+	}
+}
+
 /*
  * Check, if the device is disfunctional and a place holder, which
  * needs to be handled by the broadcast device.
@@ -111,13 +122,7 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 	 */
 	if (!tick_device_is_functional(dev)) {
 		dev->event_handler = tick_handle_periodic;
-		if (!dev->broadcast)
-			dev->broadcast = tick_broadcast;
-		if (!dev->broadcast) {
-			pr_warn_once("%s depends on broadcast, but no broadcast function available\n",
-				     dev->name);
-			dev->broadcast = err_broadcast;
-		}
+		tick_device_setup_broadcast_func(dev);
 		cpumask_set_cpu(cpu, tick_get_broadcast_mask());
 		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
 		ret = 1;
@@ -129,9 +134,10 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 		 */
 		if (!(dev->features & CLOCK_EVT_FEAT_C3STOP)) {
 			int cpu = smp_processor_id();
-
 			cpumask_clear_cpu(cpu, tick_get_broadcast_mask());
 			tick_broadcast_clear_oneshot(cpu);
+		} else {
+			tick_device_setup_broadcast_func(dev);
 		}
 	}
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
-- 
1.8.1.1


