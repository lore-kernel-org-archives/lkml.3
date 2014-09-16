Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaIPLOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:14:24 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:50454 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753674AbaIPLOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:14:22 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 2/5] mmc: msm_sdcc: Add support for platform_driver remove function
Date: Tue, 16 Sep 2014 16:47:45 +0530
Message-Id: <1410866268-15185-3-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410866268-15185-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1410866268-15185-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds remove function in platform_driver to clean unloading

Cc: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
CC: Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc@vger.kernel.org
CC: linux-arm-msm@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/mmc/host/msm_sdcc.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 2b8ac9c..3e0536d 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1360,6 +1360,7 @@ msmsdcc_probe(struct platform_device *pdev)
 	if (ret)
 		goto clk_disable;
 
+	platform_set_drvdata(pdev, host);
 	mmc_set_drvdata(pdev, mmc);
 	mmc_add_host(mmc);
 
@@ -1406,6 +1407,22 @@ msmsdcc_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static int msmsdcc_remove(struct platform_device *pdev)
+{
+	struct msmsdcc_host *host = platform_get_drvdata(pdev);
+
+	msmsdcc_disable_clocks(host, 0);
+	clk_unprepare(host->clk);
+	clk_unprepare(host->pclk);
+	if (host->dmares)
+		dma_free_coherent(NULL, sizeof(struct msmsdcc_nc_dmadata),
+				  host->dma.nc, host->dma.nc_busaddr);
+	tasklet_kill(&host->dma_tlet);
+	mmc_free_host(host->mmc);
+
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static int
 msmsdcc_suspend(struct platform_device *dev, pm_message_t state)
@@ -1452,6 +1469,7 @@ msmsdcc_resume(struct platform_device *dev)
 
 static struct platform_driver msmsdcc_driver = {
 	.probe		= msmsdcc_probe,
+	.remove		= msmsdcc_remove,
 	.suspend	= msmsdcc_suspend,
 	.resume		= msmsdcc_resume,
 	.driver		= {
-- 
1.7.9.5

