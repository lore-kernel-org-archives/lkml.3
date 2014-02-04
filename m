Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbaBDP7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:59:44 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:50132 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbaBDP7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:59:38 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 07/17] spi: pl022: Don't ignore power domain and amba bus at system suspend
Date: Tue,  4 Feb 2014 16:58:48 +0100
Message-Id: <1391529538-21685-8-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
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
 drivers/spi/spi-pl022.c |   74 +++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 70fa907..db829a1 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2288,35 +2288,7 @@ pl022_remove(struct amba_device *adev)
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
-	clk_disable(pl022->clk);
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
-	clk_enable(pl022->clk);
-}
-#endif
-
-#ifdef CONFIG_SUSPEND
+#ifdef CONFIG_PM_SLEEP
 static int pl022_suspend(struct device *dev)
 {
 	struct pl022 *pl022 = dev_get_drvdata(dev);
@@ -2328,8 +2300,23 @@ static int pl022_suspend(struct device *dev)
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
@@ -2338,10 +2325,19 @@ static int pl022_suspend(struct device *dev)
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
@@ -2352,14 +2348,16 @@ static int pl022_resume(struct device *dev)
 
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
 
@@ -2367,7 +2365,9 @@ static int pl022_runtime_resume(struct device *dev)
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

