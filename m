Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaIZKHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:07:40 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:39760 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843AbaIZKHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:07:37 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Subject: [PATCH] mmc: davinci: Fix and simplify probe failure path
Date: Fri, 26 Sep 2014 15:41:08 +0530
Message-Id: <1411726268-12605-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sequence of resource release in probe failure path in this
driver was wrong and needed fixes to cleanly unload the driver.
This changes does the same by switching to managed resources and
fixes return path to release resource in proper sequence.

Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

---
 drivers/mmc/host/davinci_mmc.c |   91 +++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 58 deletions(-)

diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
index 5d4c5e0..160b7e8 100644
--- a/drivers/mmc/host/davinci_mmc.c
+++ b/drivers/mmc/host/davinci_mmc.c
@@ -1242,22 +1242,20 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	ret = -ENODEV;
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
 	if (!r || irq == NO_IRQ)
-		goto out;
+		return -ENODEV;
 
-	ret = -EBUSY;
 	mem_size = resource_size(r);
-	mem = request_mem_region(r->start, mem_size, pdev->name);
+	mem = devm_request_mem_region(&pdev->dev, r->start, mem_size,
+				      pdev->name);
 	if (!mem)
-		goto out;
+		return -EBUSY;
 
-	ret = -ENOMEM;
 	mmc = mmc_alloc_host(sizeof(struct mmc_davinci_host), &pdev->dev);
 	if (!mmc)
-		goto out;
+		return -ENOMEM;
 
 	host = mmc_priv(mmc);
 	host->mmc = mmc;	/* Important */
@@ -1275,15 +1273,16 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 		host->txdma = r->start;
 
 	host->mem_res = mem;
-	host->base = ioremap(mem->start, mem_size);
-	if (!host->base)
-		goto out;
+	host->base = devm_ioremap(&pdev->dev, mem->start, mem_size);
+	if (IS_ERR(host->base)) {
+		ret = PTR_ERR(host->base);
+		goto err_ioremap;
+	}
 
-	ret = -ENXIO;
-	host->clk = clk_get(&pdev->dev, "MMCSDCLK");
+	host->clk = devm_clk_get(&pdev->dev, "MMCSDCLK");
 	if (IS_ERR(host->clk)) {
 		ret = PTR_ERR(host->clk);
-		goto out;
+		goto err_ioremap;
 	}
 	clk_enable(host->clk);
 	host->mmc_input_clk = clk_get_rate(host->clk);
@@ -1350,20 +1349,22 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 	ret = mmc_davinci_cpufreq_register(host);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register cpufreq\n");
-		goto cpu_freq_fail;
+		goto err_cpu_freq;
 	}
 
 	ret = mmc_add_host(mmc);
 	if (ret < 0)
-		goto out;
+		goto err_mmc_add;
 
-	ret = request_irq(irq, mmc_davinci_irq, 0, mmc_hostname(mmc), host);
+	ret = devm_request_irq(&pdev->dev, irq, mmc_davinci_irq, 0,
+			       mmc_hostname(mmc), host);
 	if (ret)
-		goto out;
+		goto err_request_irq;
 
 	if (host->sdio_irq >= 0) {
-		ret = request_irq(host->sdio_irq, mmc_davinci_sdio_irq, 0,
-				  mmc_hostname(mmc), host);
+		ret = devm_request_irq(&pdev->dev, host->sdio_irq,
+				       mmc_davinci_sdio_irq, 0,
+				       mmc_hostname(mmc), host);
 		if (!ret)
 			mmc->caps |= MMC_CAP_SDIO_IRQ;
 	}
@@ -1376,27 +1377,15 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
 
 	return 0;
 
-out:
+err_request_irq:
+	mmc_free_host(mmc);
+err_mmc_add:
 	mmc_davinci_cpufreq_deregister(host);
-cpu_freq_fail:
-	if (host) {
-		davinci_release_dma_channels(host);
-
-		if (host->clk) {
-			clk_disable(host->clk);
-			clk_put(host->clk);
-		}
-
-		if (host->base)
-			iounmap(host->base);
-	}
-
-	if (mmc)
-		mmc_free_host(mmc);
-
-	if (mem)
-		release_resource(mem);
-
+err_cpu_freq:
+	davinci_release_dma_channels(host);
+	clk_disable(host->clk);
+err_ioremap:
+	mmc_remove_host(mmc);
 	dev_dbg(&pdev->dev, "probe err %d\n", ret);
 
 	return ret;
@@ -1406,25 +1395,11 @@ static int __exit davinci_mmcsd_remove(struct platform_device *pdev)
 {
 	struct mmc_davinci_host *host = platform_get_drvdata(pdev);
 
-	if (host) {
-		mmc_davinci_cpufreq_deregister(host);
-
-		mmc_remove_host(host->mmc);
-		free_irq(host->mmc_irq, host);
-		if (host->mmc->caps & MMC_CAP_SDIO_IRQ)
-			free_irq(host->sdio_irq, host);
-
-		davinci_release_dma_channels(host);
-
-		clk_disable(host->clk);
-		clk_put(host->clk);
-
-		iounmap(host->base);
-
-		release_resource(host->mem_res);
-
-		mmc_free_host(host->mmc);
-	}
+	mmc_free_host(host->mmc);
+	mmc_davinci_cpufreq_deregister(host);
+	davinci_release_dma_channels(host);
+	clk_disable(host->clk);
+	mmc_remove_host(host->mmc);
 
 	return 0;
 }
-- 
1.7.9.5

