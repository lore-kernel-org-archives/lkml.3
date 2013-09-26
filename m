Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3IZO50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:57:26 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:40541 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3IZO4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:56:20 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 26/27] mmc: mmci: Move away from using deprecated APIs
Date: Thu, 26 Sep 2013 16:54:51 +0200
Message-Id: <1380207292-16968-27-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend and resume of cards are being handled from the protocol layer
and consequently the mmc_suspend|resume_host APIs are deprecated.

This means we can simplify the suspend|resume callbacks by removing the
use of the deprecated APIs.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/mmci.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index c3785ed..9e8a482 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -1725,37 +1725,28 @@ static int mmci_suspend(struct device *dev)
 {
 	struct amba_device *adev = to_amba_device(dev);
 	struct mmc_host *mmc = amba_get_drvdata(adev);
-	int ret = 0;
 
 	if (mmc) {
 		struct mmci_host *host = mmc_priv(mmc);
-
-		ret = mmc_suspend_host(mmc);
-		if (ret == 0) {
-			pm_runtime_get_sync(dev);
-			writel(0, host->base + MMCIMASK0);
-		}
+		pm_runtime_get_sync(dev);
+		writel(0, host->base + MMCIMASK0);
 	}
 
-	return ret;
+	return 0;
 }
 
 static int mmci_resume(struct device *dev)
 {
 	struct amba_device *adev = to_amba_device(dev);
 	struct mmc_host *mmc = amba_get_drvdata(adev);
-	int ret = 0;
 
 	if (mmc) {
 		struct mmci_host *host = mmc_priv(mmc);
-
 		writel(MCI_IRQENABLE, host->base + MMCIMASK0);
 		pm_runtime_put(dev);
-
-		ret = mmc_resume_host(mmc);
 	}
 
-	return ret;
+	return 0;
 }
 #endif
 
-- 
1.7.9.5

