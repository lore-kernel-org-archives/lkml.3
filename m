Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab3KLXJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:09:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55743 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab3KLXI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:08:58 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, <paul@pwsan.com>
CC: <rnayak@ti.com>, <khilman@linaro.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2] ARM: OMAP2+: omap_device: maintain sane runtime pm status around suspend/resume
Date: Tue, 12 Nov 2013 17:08:30 -0600
Message-ID: <1384297710-29694-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Acked-by: Kevin Hilman <khilman@linaro.org>
---
Changes in V2 (resend):
	- dropped the unnecessary flag for runtime status restore
	- picked up kevin's ack from https://patchwork.kernel.org/patch/3168371/

v1: https://patchwork.kernel.org/patch/3154501/

patch baseline: V3.12 tag (also applies on linux-next next-20131107 tag)

Logs from 3.12 based vendor kernel:
Before: http://pastebin.com/m5KxnB7a
After: http://pastebin.com/8AfX4e7r
The discussion on cpufreq side of the story which triggered this scenario:
http://marc.info/?l=linux-pm&m=138263811321921&w=2

Tested on TI vendor kernel (with dt boot):
AM335x: evm, BBB, sk, BBW
OMAP5uEVM, DRA7-evm

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

