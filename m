Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423199Ab3FUPIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:08:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38792 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423052Ab3FUPIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:08:10 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Kevin Hilman <khilman@linaro.org>, Tony Lindgren <tony@atomide.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC] ARM: OMAP2+: omap_device: add pinctrl handling
Date: Fri, 21 Jun 2013 18:03:10 +0300
Message-ID: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before switching to DT pinctrl states of OMAP IPs have been handled by hwmod
framework. After switching to DT-boot the pinctrl handling was dropped from
hwmod framework and, as it was recommended, OMAP IP's drivers have to be updated
to handle pinctrl states by itself using pinctrl_pm_select_xx() helpers
(see http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/173514.html)

But this is not right for OMAP2+ SoC where real IPs state is controlled
by omap_device core which enables/disables modules & clocks actually.

For example, if OMAP I2C driver will handle pinctrl state during system wide
suspend the following issue may occure:
- suspend_noirq - I2C device can be still active because of PM auto-suspend
  |-_od_suspend_noirq
     |- omap_i2c_suspend_noirq
        |- PINs state set to SLEEP
  |- pm_generic_runtime_suspend
     |- omap_i2c_runtime_suspend()
        |- PINs state set to IDLE  <--- *oops* PINs state is IDLE and not SLEEP
  |- omap_device_idle()
     |- omap_hwmod_idle()
        |- _idle()
           |- disbale module (sysc&clocks)

- resume_noirq - I2C was active before suspend
  |-_od_resume_noirq
     |- omap_hwmod_enable()
        |- _enable()
           |- enable module (sysc&clocks)
     |- pm_generic_runtime_resume
        |- omap_i2c_runtime_resume()
           |- PINs state set to DEFAULT  <--- !!!!
     |- omap_i2c_resume_noirq
        |- PINs state set to DEFAULT
        |- PINs state set to IDLE  <--- *big oops* we have active module and its
                                         PINs state is IDLE
(see https://patchwork.kernel.org/patch/2642101/)

Of course, everything can be handled by adding a tons of code in ecah driver to
check PM state of device and override default behavior of omap_device core, but
this not good.

Hence, add pinctrl handling in omap_device core:
1) on PM runtime resume
- switch pinctrl state to "default" (todo: "active")
2) on PM runtime suspend
- switch pinctrl state to "idle"
3) during system wide suspend
- switch pinctrl state to "sleep" or "idle" if omap_device core disables device
- switch pinctrl state to "sleep" if device is disabled already
4) during system wide resume
- switch pinctrl state to "default" (todo: "active") if omap_device core has
  disabled  device during suspend
- switch pinctrl state to "idle" if device was already disabled before suspend

This will enable pinctrl for all OMAP2+ IP's drivers by default -
no changes in code is needed and only DT data will need to be updated
(add "default", "active", "idle", "sleep" states).

This will enable pinctrl handling for all OMAP2+ drivers by default -
no changes in code is needed and only DT data will need to be updated
(add "default", "active", "idle", "sleep" states).

Related discussions:
- [3/3] i2c: nomadik: use pinctrl PM helpers 
 https://patchwork.kernel.org/patch/2670291/
- mmc: omap_hsmmc: Remux pins to support SDIO interrupt and PM runtime
 https://patchwork.kernel.org/patch/2690191/
- [PATCH 00/11] drivers: Add Pinctrl PM support
 https://lkml.org/lkml/2013/5/31/210

CC: Hebbar Gururaja <gururaja.hebbar@ti.com>
CC: Linus Walleij  <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org
CC: linux-omap@vger.kernel.org
CC: linux-kernel@vger.kernel.org 

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
Hi Kevin, Tony,

I've verified this patch on OMAP4 SDP board:
- PM runtime for I2C4, UART2, UART3
- suspend/resume with I2C4, UART2, UART3

seems it works and pinctrl states have been updated as expected.

TODO:
- need to be rebased when support for "active" state  will be added.
- need to be rebased when "Omap serial cleanup" patch series will be merged
  https://lkml.org/lkml/2013/4/26/503

based on top of:
 git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
849aa58 Add linux-next specific files for 20130620

Best regards
- grygorii

 arch/arm/mach-omap2/omap_device.c |   45 ++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index e37feb2..d8cf17b 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -39,6 +39,7 @@
 #include "soc.h"
 #include "omap_device.h"
 #include "omap_hwmod.h"
+#include "iomap.h"
 
 /* Private functions */
 
@@ -585,8 +586,10 @@ static int _od_runtime_suspend(struct device *dev)
 
 	ret = pm_generic_runtime_suspend(dev);
 
-	if (!ret)
+	if (!ret) {
 		omap_device_idle(pdev);
+		pinctrl_pm_select_idle_state(dev);
+	}
 
 	return ret;
 }
@@ -595,12 +598,26 @@ static int _od_runtime_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 
+	/* TODO: should be replaced to pinctrl_pm_select_active_state() */
+	pinctrl_pm_select_default_state(dev);
+
 	omap_device_enable(pdev);
 
 	return pm_generic_runtime_resume(dev);
 }
 #endif
 
+void _od_suspend_sel_pinctrl_state(struct device *dev)
+{
+	if (!dev->pins)
+		return;
+	/* try to select *deepest* pinctrl state */
+	if (IS_ERR(dev->pins->sleep_state))
+		pinctrl_pm_select_idle_state(dev);
+	else
+		pinctrl_pm_select_sleep_state(dev);
+}
+
 #ifdef CONFIG_SUSPEND
 static int _od_suspend_noirq(struct device *dev)
 {
@@ -613,12 +630,22 @@ static int _od_suspend_noirq(struct device *dev)
 		return 0;
 
 	ret = pm_generic_suspend_noirq(dev);
+	if (!ret) {
+		if (!pm_runtime_status_suspended(dev)) {
+			if (pm_generic_runtime_suspend(dev) == 0) {
+				if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND)) {
+					omap_device_idle(pdev);
+					_od_suspend_sel_pinctrl_state(dev);
+				}
+			}
 
-	if (!ret && !pm_runtime_status_suspended(dev)) {
-		if (pm_generic_runtime_suspend(dev) == 0) {
-			if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
-				omap_device_idle(pdev);
 			od->flags |= OMAP_DEVICE_SUSPENDED;
+		} else {
+			/*
+			 * "idle" pinctrl state already applied -
+			 * try to set "sleep" state
+			 */
+			pinctrl_pm_select_sleep_state(dev);
 		}
 	}
 
@@ -633,9 +660,15 @@ static int _od_resume_noirq(struct device *dev)
 	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
 	    !pm_runtime_status_suspended(dev)) {
 		od->flags &= ~OMAP_DEVICE_SUSPENDED;
-		if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
+		if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND)) {
 			omap_device_enable(pdev);
+			/* TODO: should be replaced to pinctrl_pm_select_active_state() */
+			pinctrl_pm_select_default_state(dev);
+		}
 		pm_generic_runtime_resume(dev);
+	} else if (!pm_runtime_status_suspended(dev)) {
+		/* switch back to "idle" pinctrl state */
+		pinctrl_pm_select_idle_state(dev);
 	}
 
 	return pm_generic_resume_noirq(dev);
-- 
1.7.9.5

