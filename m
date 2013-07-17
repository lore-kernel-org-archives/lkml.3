Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3GQLo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:44:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42713 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab3GQLni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:43:38 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 2/3] ARM: OMAP2+: omap_device: add pinctrl handling
Date: Wed, 17 Jul 2013 14:41:51 +0300
Message-ID: <1374061312-25469-3-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com>
References: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com>
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

Hence, add pinctrl handling in omap_device core as shown below:
                                         +
                                         |
                                         |  .probe()
                                         |
                                   +-----v--------+
                                   |              |
                                   |  default     |
                                   |              |
                                   +----+--+------+
                                        |  |
                        pm_runtime_get()|  | pm_runtime_put()
                       +----------------+  +------------+
                       |                                |
                +------v------+ pm_runtime_put()+-------v-----+
                |             +----------------->             |
    +----------->  Active     |pm_runtime_get() |   Idle      <----------+
    |           |             <-----------------+             |          |
    |           +-------+-----+                 +-------+-----+          |
    |                   |.suspend_noirq()               |.suspend_noirq()|
    |                   |                               |                |
    |                   |                               |                |
    |                   |                               |                |
    |                   |                               |                |
    |           +-------v-----+                 +-------v-----+          |
    |           |             |                 |             |          |
    +-----------+  Sleep      ------+           |  Sleep      +----------+
.resume_noirq() |             |     |           |             |.resume_noirq()
                +-------|-----+     |           +-------------+
                        |  Idle     |
                        +-----------+
1) on PM runtime resume
- switch pinctrl state to "active"
2) on PM runtime suspend
- switch pinctrl state to "idle"
3) during system wide suspend
- switch pinctrl state to "sleep" or "idle" if omap_device core disables device
- switch pinctrl state to "sleep" if device has been disabled already
4) during system wide resume
- switch pinctrl state to "active" if omap_device core has
  disabled device during suspend
- switch pinctrl state to "idle" if device was already disabled before suspend

This will enable pinctrl for all OMAP2+ IP's drivers by default -
no changes in code is needed and only DT data will need to be updated
(add "default", "active", "idle", "sleep" states).

Related discussions:
- [3/3] i2c: nomadik: use pinctrl PM helpers
 https://patchwork.kernel.org/patch/2670291/
- mmc: omap_hsmmc: Remux pins to support SDIO interrupt and PM runtime
 https://patchwork.kernel.org/patch/2690191/
- [PATCH 00/11] drivers: Add Pinctrl PM support
 https://lkml.org/lkml/2013/5/31/210

CC: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/mach-omap2/omap_device.c |   40 +++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index 5cc9287..4ebdbd7 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -39,6 +39,7 @@
 #include "soc.h"
 #include "omap_device.h"
 #include "omap_hwmod.h"
+#include "iomap.h"
 
 /* Private functions */
 
@@ -582,8 +583,10 @@ static int _od_runtime_suspend(struct device *dev)
 
 	ret = pm_generic_runtime_suspend(dev);
 
-	if (!ret)
+	if (!ret) {
 		omap_device_idle(pdev);
+		pinctrl_pm_select_idle_state(dev);
+	}
 
 	return ret;
 }
@@ -592,12 +595,25 @@ static int _od_runtime_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 
+	pinctrl_pm_select_active_state(dev);
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
@@ -610,11 +626,19 @@ static int _od_suspend_noirq(struct device *dev)
 		return 0;
 
 	ret = pm_generic_suspend_noirq(dev);
-
-	if (!ret && !pm_runtime_status_suspended(dev)) {
-		if (pm_generic_runtime_suspend(dev) == 0) {
-			omap_device_idle(pdev);
-			od->flags |= OMAP_DEVICE_SUSPENDED;
+	if (!ret) {
+		if (!pm_runtime_status_suspended(dev)) {
+			if (pm_generic_runtime_suspend(dev) == 0) {
+				omap_device_idle(pdev);
+				od->flags |= OMAP_DEVICE_SUSPENDED;
+				_od_suspend_sel_pinctrl_state(dev);
+			}
+		} else {
+			/*
+			 * "idle" pinctrl state already applied -
+			 * try to set "sleep" state
+			 */
+			pinctrl_pm_select_sleep_state(dev);
 		}
 	}
 
@@ -630,7 +654,11 @@ static int _od_resume_noirq(struct device *dev)
 	    !pm_runtime_status_suspended(dev)) {
 		od->flags &= ~OMAP_DEVICE_SUSPENDED;
 		omap_device_enable(pdev);
+		pinctrl_pm_select_active_state(dev);
 		pm_generic_runtime_resume(dev);
+	} else if (pm_runtime_status_suspended(dev)) {
+		/* switch back to "idle" pinctrl state */
+		pinctrl_pm_select_idle_state(dev);
 	}
 
 	return pm_generic_resume_noirq(dev);
-- 
1.7.9.5

