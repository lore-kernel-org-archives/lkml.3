Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaBSOdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:33:55 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35754 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaBSOdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:33:54 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH V2 07/17] spi: pl022: Don't ignore power domain and amba bus at system suspend
Date: Wed, 19 Feb 2014 15:33:38 +0100
Message-Id: <1392820418-6972-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the available runtime PM callbacks for CONFIG_PM, we are now
able to put the device into complete low power state at system suspend.

Previously only the resources controlled by the driver were put into
low power state at system suspend. Both the amba bus and a potential
power domain were ignored, which now isn't the case any more.

Moreover, putting the device into low power state couldn't be done
without first bringing it back to full power. This constraint don't
exists any more.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---

Changes in v2:
	Rebased on top of latest spi-pl022 patches.

	Note, currently this patch shall not be applied since first we want
	to sort out the result from another patch to the PM core.
	http://marc.info/?l=linux-pm&m=139228211505423&w=2

---
 drivers/spi/spi-pl022.c |   74 +++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 6dfcabf..7b016a2 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2277,35 +2277,7 @@ pl022_remove(struct amba_device *adev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-/*
- * These two functions are used from both suspend/resume and
- * the runtime counterparts to handle external resources like
- * clocks, pins and regulators when going to sleep.
- */
-static void pl022_suspend_resources(struct pl022 *pl022, bool runtime)
-{
-	clk_disable_unprepare(pl022->clk);
-
-	if (runtime)
-		pinctrl_pm_select_idle_state(&pl022->adev->dev);
-	else
-		pinctrl_pm_select_sleep_state(&pl022->adev->dev);
-}
-
-static void pl022_resume_resources(struct pl022 *pl022, bool runtime)
-{
-	/* First go to the default state */
-	pinctrl_pm_select_default_state(&pl022->adev->dev);
-	if (!runtime)
-		/* Then let's idle the pins until the next transfer happens */
-		pinctrl_pm_select_idle_state(&pl022->adev->dev);
-
-	clk_prepare_enable(pl022->clk);
-}
-#endif
-
-#ifdef CONFIG_SUSPEND
+#ifdef CONFIG_PM_SLEEP
 static int pl022_suspend(struct device *dev)
 {
 	struct pl022 *pl022 = dev_get_drvdata(dev);
@@ -2317,8 +2289,23 @@ static int pl022_suspend(struct device *dev)
 		return ret;
 	}
 
-	pm_runtime_get_sync(dev);
-	pl022_suspend_resources(pl022, false);
+	pm_runtime_disable(dev);
+
+	if (!pm_runtime_status_suspended(dev)) {
+		if (dev->pm_domain && dev->pm_domain->ops.runtime_suspend)
+			ret = dev->pm_domain->ops.runtime_suspend(dev);
+		else
+			ret = dev->bus->pm->runtime_suspend(dev);
+
+		if (ret) {
+			pm_runtime_enable(dev);
+			return ret;
+		}
+
+		pm_runtime_set_suspended(dev);
+	}
+
+	pinctrl_pm_select_sleep_state(dev);
 
 	dev_dbg(dev, "suspended\n");
 	return 0;
@@ -2327,10 +2314,19 @@ static int pl022_suspend(struct device *dev)
 static int pl022_resume(struct device *dev)
 {
 	struct pl022 *pl022 = dev_get_drvdata(dev);
-	int ret;
+	int ret = 0;
 
-	pl022_resume_resources(pl022, false);
-	pm_runtime_put(dev);
+	if (dev->pm_domain && dev->pm_domain->ops.runtime_resume)
+		ret = dev->pm_domain->ops.runtime_resume(dev);
+	else
+		ret = dev->bus->pm->runtime_resume(dev);
+
+	if (ret)
+		dev_err(dev, "problem resuming\n");
+	else
+		pm_runtime_set_active(dev);
+
+	pm_runtime_enable(dev);
 
 	/* Start the queue running */
 	ret = spi_master_resume(pl022->master);
@@ -2341,14 +2337,16 @@ static int pl022_resume(struct device *dev)
 
 	return ret;
 }
-#endif	/* CONFIG_PM */
+#endif
 
 #ifdef CONFIG_PM
 static int pl022_runtime_suspend(struct device *dev)
 {
 	struct pl022 *pl022 = dev_get_drvdata(dev);
 
-	pl022_suspend_resources(pl022, true);
+	clk_disable(pl022->clk);
+	pinctrl_pm_select_idle_state(dev);
+
 	return 0;
 }
 
@@ -2356,7 +2354,9 @@ static int pl022_runtime_resume(struct device *dev)
 {
 	struct pl022 *pl022 = dev_get_drvdata(dev);
 
-	pl022_resume_resources(pl022, true);
+	pinctrl_pm_select_default_state(dev);
+	clk_enable(pl022->clk);
+
 	return 0;
 }
 #endif
-- 
1.7.9.5

