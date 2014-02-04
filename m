Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaBDP7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:59:38 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:61321 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaBDP7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:59:32 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 05/17] mmc: mmci: Put the device into low power state at system suspend
Date: Tue,  4 Feb 2014 16:58:46 +0100
Message-Id: <1391529538-21685-6-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the available runtime PM callbacks, we are now able to put our
device into low power state at system suspend.

Earlier we could not accomplish this without trusting a power domain
for the device to take care of it. Now we are able to cope with
scenarios both with and without a power domain.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/mmci.c |   45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index c88da1c..074e0cb 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1723,33 +1723,38 @@ static int mmci_remove(struct amba_device *dev)
 	return 0;
 }
 
-#ifdef CONFIG_SUSPEND
-static int mmci_suspend(struct device *dev)
+#ifdef CONFIG_PM_SLEEP
+static int mmci_suspend_late(struct device *dev)
 {
-	struct amba_device *adev = to_amba_device(dev);
-	struct mmc_host *mmc = amba_get_drvdata(adev);
+	int ret = 0;
 
-	if (mmc) {
-		struct mmci_host *host = mmc_priv(mmc);
-		pm_runtime_get_sync(dev);
-		writel(0, host->base + MMCIMASK0);
-	}
+	if (pm_runtime_status_suspended(dev))
+		return 0;
 
-	return 0;
+	if (dev->pm_domain && dev->pm_domain->ops.runtime_suspend)
+		ret = dev->pm_domain->ops.runtime_suspend(dev);
+	else
+		ret = dev->bus->pm->runtime_suspend(dev);
+
+	if (!ret)
+		pm_runtime_set_suspended(dev);
+
+	return ret;
 }
 
-static int mmci_resume(struct device *dev)
+static int mmci_resume_early(struct device *dev)
 {
-	struct amba_device *adev = to_amba_device(dev);
-	struct mmc_host *mmc = amba_get_drvdata(adev);
+	int ret = 0;
 
-	if (mmc) {
-		struct mmci_host *host = mmc_priv(mmc);
-		writel(MCI_IRQENABLE, host->base + MMCIMASK0);
-		pm_runtime_put(dev);
-	}
+	if (pm_runtime_status_suspended(dev))
+		return 0;
 
-	return 0;
+	if (dev->pm_domain && dev->pm_domain->ops.runtime_resume)
+		ret = dev->pm_domain->ops.runtime_resume(dev);
+	else
+		ret = dev->bus->pm->runtime_resume(dev);
+
+	return ret;
 }
 #endif
 
@@ -1820,7 +1825,7 @@ static int mmci_runtime_resume(struct device *dev)
 #endif
 
 static const struct dev_pm_ops mmci_dev_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(mmci_suspend, mmci_resume)
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(mmci_suspend_late, mmci_resume_early)
 	SET_PM_RUNTIME_PM_OPS(mmci_runtime_suspend, mmci_runtime_resume, NULL)
 };
 
-- 
1.7.9.5

