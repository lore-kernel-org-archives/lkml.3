Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaIPLOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:14:21 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:54420 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753365AbaIPLOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:14:19 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 1/5] mmc: msm_sdcc: Switch to using managed resources
Date: Tue, 16 Sep 2014 16:47:44 +0530
Message-Id: <1410866268-15185-2-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410866268-15185-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1410866268-15185-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes changes to use managed version of ioremap, clk_get,
request_irq etc for clean unloading of modules. This does away with
lables to release these resources.

Cc: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
CC: Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc@vger.kernel.org
CC: linux-arm-msm@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/mmc/host/msm_sdcc.c |   43 +++++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 9405ecd..2b8ac9c 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1224,7 +1224,7 @@ msmsdcc_probe(struct platform_device *pdev)
 
 	host->cmdpoll = 1;
 
-	host->base = ioremap(memres->start, PAGE_SIZE);
+	host->base = devm_ioremap(&pdev->dev, memres->start, PAGE_SIZE);
 	if (!host->base) {
 		ret = -ENOMEM;
 		goto host_free;
@@ -1244,33 +1244,33 @@ msmsdcc_probe(struct platform_device *pdev)
 	if (host->dmares) {
 		ret = msmsdcc_init_dma(host);
 		if (ret)
-			goto ioremap_free;
+			goto tasklet_kill;
 	} else {
 		host->dma.channel = -1;
 	}
 
 	/* Get our clocks */
-	host->pclk = clk_get(&pdev->dev, "sdc_pclk");
+	host->pclk = devm_clk_get(&pdev->dev, "sdc_pclk");
 	if (IS_ERR(host->pclk)) {
 		ret = PTR_ERR(host->pclk);
 		goto dma_free;
 	}
 
-	host->clk = clk_get(&pdev->dev, "sdc_clk");
+	host->clk = devm_clk_get(&pdev->dev, "sdc_clk");
 	if (IS_ERR(host->clk)) {
 		ret = PTR_ERR(host->clk);
-		goto pclk_put;
+		goto dma_free;
 	}
 
 	ret = clk_set_rate(host->clk, msmsdcc_fmin);
 	if (ret) {
 		pr_err("%s: Clock rate set failed (%d)\n", __func__, ret);
-		goto clk_put;
+		goto dma_free;
 	}
 
 	ret = clk_prepare(host->pclk);
 	if (ret)
-		goto clk_put;
+		goto dma_free;
 
 	ret = clk_prepare(host->clk);
 	if (ret)
@@ -1322,7 +1322,7 @@ msmsdcc_probe(struct platform_device *pdev)
 			(stat_irqres->flags & IRQF_TRIGGER_MASK);
 
 		host->stat_irq = stat_irqres->start;
-		ret = request_irq(host->stat_irq,
+		ret = devm_request_irq(&pdev->dev, host->stat_irq,
 				  msmsdcc_platform_status_irq,
 				  irqflags,
 				  DRIVER_NAME " (slot)",
@@ -1350,15 +1350,15 @@ msmsdcc_probe(struct platform_device *pdev)
 		host->eject = !host->oldstat;
 	}
 
-	ret = request_irq(cmd_irqres->start, msmsdcc_irq, IRQF_SHARED,
-			  DRIVER_NAME " (cmd)", host);
+	ret = devm_request_irq(&pdev->dev, cmd_irqres->start, msmsdcc_irq,
+			       IRQF_SHARED, DRIVER_NAME " (cmd)", host);
 	if (ret)
-		goto stat_irq_free;
+		goto clk_disable;
 
-	ret = request_irq(cmd_irqres->start, msmsdcc_pio_irq, IRQF_SHARED,
-			  DRIVER_NAME " (pio)", host);
+	ret = devm_request_irq(&pdev->dev, cmd_irqres->start, msmsdcc_pio_irq,
+			       IRQF_SHARED, DRIVER_NAME " (pio)", host);
 	if (ret)
-		goto cmd_irq_free;
+		goto clk_disable;
 
 	mmc_set_drvdata(pdev, mmc);
 	mmc_add_host(mmc);
@@ -1387,28 +1387,19 @@ msmsdcc_probe(struct platform_device *pdev)
 		pr_info("%s: Polling status mode enabled\n", mmc_hostname(mmc));
 
 	return 0;
- cmd_irq_free:
-	free_irq(cmd_irqres->start, host);
- stat_irq_free:
-	if (host->stat_irq)
-		free_irq(host->stat_irq, host);
+
  clk_disable:
 	msmsdcc_disable_clocks(host, 0);
  clk_unprepare:
 	clk_unprepare(host->clk);
  clk_unprepare_p:
 	clk_unprepare(host->pclk);
- clk_put:
-	clk_put(host->clk);
- pclk_put:
-	clk_put(host->pclk);
-dma_free:
+ dma_free:
 	if (host->dmares)
 		dma_free_coherent(NULL, sizeof(struct msmsdcc_nc_dmadata),
 					host->dma.nc, host->dma.nc_busaddr);
-ioremap_free:
+ tasklet_kill:
 	tasklet_kill(&host->dma_tlet);
-	iounmap(host->base);
  host_free:
 	mmc_free_host(mmc);
  out:
-- 
1.7.9.5

