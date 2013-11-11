Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab3KKQYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:24:37 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43852 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710Ab3KKQYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:24:25 -0500
Date: Mon, 11 Nov 2013 10:23:58 -0600
From: Nishanth Menon <nm@ti.com>
To: Kevin Hilman <khilman@linaro.org>
CC: Tony Lindgren <tony@atomide.com>, <paul@pwsan.com>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP2+: omap_device: maintain sane runtime pm
 status around suspend/resume
Message-ID: <20131111162358.GA6451@kahuna>
References: <1383857942-23630-1-git-send-email-nm@ti.com>
 <87iow3rd3y.fsf@linaro.org>
 <527C2B78.2070201@ti.com>
 <874n7npw1e.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <874n7npw1e.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:38-20131107, Kevin Hilman wrote:
[...]
> That's debatable I guess.  The ideal world is that runtime PM hides all
> of this, but I'm not sure it's achievable in all cases.
> 
Agreed. some drivers like edma need to save and restore context around
suspend.
[...]

> No, that sysfs knob is for disabling runtime PM.  We still want the
> device to hit low-power state in system suspend.  Solving that problem
> is half the reason we have this omap_device noirq mess in the first
> place.
> 
> You need to test this by disabling runtime PM from userspace and ensure
> that the low power state is still hit during suspend.
> 
Done and it still does work, makes sense since it just ensures that
runtime PM's dev->power.runtime_status is set to RPM_SUSPENDED instead
of RPM_ACTIVE for devices that depend on autosuspend.

Logs (based on vendor kernel which has relevant out of tree patches to
enable suspend resume - still in the works):
AM335x-BBB: http://pastie.org/8472182
OMAP5-uEVM: http://pastie.org/8472183

> >>
> >>> +				/* NOTE: *might* indicate driver race */
> >>
> >> Yes, a driver race which should then be fixed in the driver.
> >
> > true if this is a non-autosuspend device, in auto suspend devices,
> > this could be a regular phenomenon if timeout is pretty large.. but
> > atleast that should allow debug.
> 
> Agreed.  I wasn't thinking about the autosuspend case.  Thanks for
> clarifying.
> 
> >>
> >>> +				dev_dbg(dev, "%s: Force suspending\n",
> >>> +					__func__);
> >>> +				pm_runtime_set_suspended(dev);
> >>> +				od->flags |= OMAP_DEVICE_SUSPEND_FORCED;
> >>
> >> Not sure why you need an additonal flag.  Why not just always do this
> >> and use the existin OMAP_DEVICE_SUSPENDED flag.
> >
> > restore of runtime data structure state is only needed for specific
> > devices - not all..
> 
> The question is why do you a flag in addition to OMAP_DEVICE_SUSPEND.
> Whenever that flag is set, omap_device has gone behind your back, and
> the runtime PM status should be kept in sync.

Yes, you are right, originally, I had intended this to indicate devices
that needed to be runtime_status updated, but then, now I realize that
it is true for all devices that have OMAP_DEVICE_SUSPEND set. It can be
applied without an additional flag. Do see if the updated patch is more
sensible:
-- >8 --
>From 96b5a7b89fef4ba55bca48bae83e5536d697c6c4 Mon Sep 17 00:00:00 2001
From: Nishanth Menon <nm@ti.com>
Date: Thu, 24 Oct 2013 09:12:42 -0500
Subject: [PATCH V2] ARM: OMAP2+: omap_device: maintain sane runtime pm status
 around suspend/resume

OMAP device hooks around suspend|resume_noirq ensures that hwmod
devices are forced to idle using omap_device_idle/enable as part of
the last stage of suspend activity.

For a device such as i2c who uses autosuspend, it is possible to enter
the suspend path with dev->power.runtime_status = RPM_ACTIVE.

As part of the suspend flow, the generic runtime logic would increment
it's dev->power.disable_depth to 1. This should prevent further
pm_runtime_get_sync from succeeding once the runtime_status has been
set to RPM_SUSPENDED.

Now, as part of the suspend_noirq handler in omap_device, we force the
following: if the device status is !suspended, we force the device
to idle using omap_device_idle (clocks are cut etc..). This ensures
that from a hardware perspective, the device is "suspended". However,
runtime_status is left to be active.

*if* an operation is attempted after this point to
pm_runtime_get_sync, runtime framework depends on runtime_status to
indicate accurately the device status, and since it sees it to be
ACTIVE, it assumes the module is functional and returns a non-error
value. As a result the user will see pm_runtime_get succeed, however a
register access will crash due to the lack of clocks.

To prevent this from happening, we should ensure that runtime_status
exactly indicates the device status. As a result of this change
any further calls to pm_runtime_get* would return -EACCES (since
disable_depth is 1). On resume, we restore the clocks and runtime
status exactly as we suspended with.

Reported-by: J Keerthy <j-keerthy@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Rajendra Nayak <rnayak@ti.com>
---
 arch/arm/mach-omap2/omap_device.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index b69dd9a..f97b34b 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -621,6 +621,7 @@ static int _od_suspend_noirq(struct device *dev)
 
 	if (!ret && !pm_runtime_status_suspended(dev)) {
 		if (pm_generic_runtime_suspend(dev) == 0) {
+			pm_runtime_set_suspended(dev);
 			omap_device_idle(pdev);
 			od->flags |= OMAP_DEVICE_SUSPENDED;
 		}
@@ -634,10 +635,10 @@ static int _od_resume_noirq(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_device *od = to_omap_device(pdev);
 
-	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
-	    !pm_runtime_status_suspended(dev)) {
+	if (od->flags & OMAP_DEVICE_SUSPENDED) {
 		od->flags &= ~OMAP_DEVICE_SUSPENDED;
 		omap_device_enable(pdev);
+		pm_runtime_set_active(dev);
 		pm_generic_runtime_resume(dev);
 	}
 
-- 
1.7.9.5

-- 
Regards,
Nishanth Menon
