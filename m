Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3IZPCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:02:21 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:34955 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab3IZOzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:55:19 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Sekhar Nori <nsekhar@ti.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com
Subject: [PATCH 05/27] mmc: davinci_mmc: Move away from using deprecated APIs
Date: Thu, 26 Sep 2013 16:54:30 +0200
Message-Id: <1380207292-16968-6-git-send-email-ulf.hansson@linaro.org>
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

Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Manjunathappa, Prakash <prakash.pm@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/host/davinci_mmc.c |   26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index e9fa87d..d615374 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -193,7 +193,6 @@ struct mmc_davinci_host {
 #define DAVINCI_MMC_DATADIR_READ	1
 #define DAVINCI_MMC_DATADIR_WRITE	2
 	unsigned char data_dir;
-	unsigned char suspended;
 
 	/* buffer is used during PIO of one scatterlist segment, and
 	 * is updated along with buffer_bytes_left.  bytes_left applies
@@ -1435,38 +1434,23 @@ static int davinci_mmcsd_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
-	int ret;
 
-	ret = mmc_suspend_host(host->mmc);
-	if (!ret) {
-		writel(0, host->base + DAVINCI_MMCIM);
-		mmc_davinci_reset_ctrl(host, 1);
-		clk_disable(host->clk);
-		host->suspended = 1;
-	} else {
-		host->suspended = 0;
-	}
+	writel(0, host->base + DAVINCI_MMCIM);
+	mmc_davinci_reset_ctrl(host, 1);
+	clk_disable(host->clk);
 
-	return ret;
+	return 0;
 }
 
 static int davinci_mmcsd_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
-	int ret;
-
-	if (!host->suspended)
-		return 0;
 
 	clk_enable(host->clk);
-
 	mmc_davinci_reset_ctrl(host, 0);
-	ret = mmc_resume_host(host->mmc);
-	if (!ret)
-		host->suspended = 0;
 
-	return ret;
+	return 0;
 }
 
 static const struct dev_pm_ops davinci_mmcsd_pm = {
-- 
1.7.9.5

