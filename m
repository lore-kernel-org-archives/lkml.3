Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578Ab3LFXSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:18:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48792 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3LFXSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:18:51 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 127/152] ARM: OMAP2+: omap_device: maintain sane runtime pm status around suspend/resume
Date: Fri,  6 Dec 2013 15:10:51 -0800
Message-Id: <1386371476-2477-128-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

commit 3522bf7bfa248b99eafa2f4872190699a808c7d9 upstream.

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
status exactly as we suspended with. These operations are not expected
to fail as we update the states after the core runtime framework has
suspended itself and restore before the core runtime framework has
resumed.

Reported-by: J Keerthy <j-keerthy@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Rajendra Nayak <rnayak@ti.com>
Acked-by: Kevin Hilman <khilman@linaro.org>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
[ kamal: backport to 3.8 (keep OMAP_DEVICE_NO_IDLE_ON_SUSPEND handling) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-omap2/omap_device.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index e065daa..3550708 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -836,8 +836,10 @@ static int _od_suspend_noirq(struct device *dev)
 
 	if (!ret && !pm_runtime_status_suspended(dev)) {
 		if (pm_generic_runtime_suspend(dev) == 0) {
-			if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
+			if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND)) {
+				pm_runtime_set_suspended(dev);
 				omap_device_idle(pdev);
+			}
 			od->flags |= OMAP_DEVICE_SUSPENDED;
 		}
 	}
@@ -850,11 +852,20 @@ static int _od_resume_noirq(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct omap_device *od = to_omap_device(pdev);
 
-	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
-	    !pm_runtime_status_suspended(dev)) {
+	if (od->flags & OMAP_DEVICE_SUSPENDED) {
 		od->flags &= ~OMAP_DEVICE_SUSPENDED;
-		if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
+		if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND)) {
 			omap_device_enable(pdev);
+			/*
+			 * XXX: we run before core runtime pm has resumed itself. At
+			 * this point in time, we just restore the runtime pm state and
+			 * considering symmetric operations in resume, we donot expect
+			 * to fail. If we failed, something changed in core runtime_pm
+			 * framework OR some device driver messed things up, hence, WARN
+			 */
+			WARN(pm_runtime_set_active(dev),
+			     "Could not set %s runtime state active\n", dev_name(dev));
+		}
 		pm_generic_runtime_resume(dev);
 	}
 
-- 
1.8.3.2

