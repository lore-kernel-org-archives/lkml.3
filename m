Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaKIVOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 16:14:52 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:64532 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaKIVOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 16:14:51 -0500
From: Alexey Charkov <alchark@gmail.com>
To: Tony Prisk <linux@prisktech.co.nz>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Helmut Stengele <lautriv@coldplug.net>, Alexey Charkov <alchark@gmail.com>
Subject: [PATCH] mmc: wmt-sdmmc: fix unmatched release_mem_region
Date: Mon, 10 Nov 2014 00:12:51 +0300
Message-Id: <1415567571-6144-1-git-send-email-alchark@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Helmut Stengele <lautriv@coldplug.net>

Current code calls release_mem_region upon module unload
without requesting the region first. This patch fixes it
by moving to a devres-based ioremap implementation, which
handles requesting and releasing memory region internally.

This also makes the error/unload paths a bit simpler.

Signed-off-by: Helmut Stengele <lautriv@coldplug.net>
(edited commit message)
Signed-off-by: Alexey Charkov <alchark@gmail.com>
---
Dear Chris, Ulf,

This is a pretty trivial fix to a bug in wmt-sdmmc.c that is only
visible upon module unload. Is there any chance to get it merged to
the current fixes tree?

I think I'd also like to convert other resource requests here to devres,
but that would probably be a separate patch to go into -next. That's why
we didn't rename the failX: labels, for example (as most of them could be
dropped altogether if the respective requesting functions are converted to
devres infrastructure).

Thanks a lot,
Alexey

 drivers/mmc/host/wmt-sdmmc.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/wmt-sdmmc.c b/drivers/mmc/host/wmt-sdmmc.c
index 54181b4..02b5e6b 100644
--- a/drivers/mmc/host/wmt-sdmmc.c
+++ b/drivers/mmc/host/wmt-sdmmc.c
@@ -759,6 +759,7 @@ static int wmt_mci_probe(struct platform_device *pdev)
 	const struct wmt_mci_caps *wmt_caps;
 	int ret;
 	int regular_irq, dma_irq;
+	struct resource *res;
 
 	if (!of_id || !of_id->data) {
 		dev_err(&pdev->dev, "Controller capabilities data missing\n");
@@ -781,6 +782,11 @@ static int wmt_mci_probe(struct platform_device *pdev)
 		goto fail1;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		ret = -ENODEV;
+		goto fail1;
+	}
 	mmc = mmc_alloc_host(sizeof(struct wmt_mci_priv), &pdev->dev);
 	if (!mmc) {
 		dev_err(&pdev->dev, "Failed to allocate mmc_host\n");
@@ -813,7 +819,7 @@ static int wmt_mci_probe(struct platform_device *pdev)
 	if (of_get_property(np, "cd-inverted", NULL))
 		priv->cd_inverted = 1;
 
-	priv->sdmmc_base = of_iomap(np, 0);
+	priv->sdmmc_base = devm_ioremap_resource(&pdev->dev, res);
 	if (!priv->sdmmc_base) {
 		dev_err(&pdev->dev, "Failed to map IO space\n");
 		ret = -ENOMEM;
@@ -826,7 +832,7 @@ static int wmt_mci_probe(struct platform_device *pdev)
 	ret = request_irq(regular_irq, wmt_mci_regular_isr, 0, "sdmmc", priv);
 	if (ret) {
 		dev_err(&pdev->dev, "Register regular IRQ fail\n");
-		goto fail3;
+		goto fail2;
 	}
 
 	ret = request_irq(dma_irq, wmt_mci_dma_isr, 0, "sdmmc", priv);
@@ -869,8 +875,6 @@ fail5:
 	free_irq(dma_irq, priv);
 fail4:
 	free_irq(regular_irq, priv);
-fail3:
-	iounmap(priv->sdmmc_base);
 fail2:
 	mmc_free_host(mmc);
 fail1:
@@ -881,7 +885,6 @@ static int wmt_mci_remove(struct platform_device *pdev)
 {
 	struct mmc_host *mmc;
 	struct wmt_mci_priv *priv;
-	struct resource *res;
 	u32 reg_tmp;
 
 	mmc = platform_get_drvdata(pdev);
@@ -904,14 +907,9 @@ static int wmt_mci_remove(struct platform_device *pdev)
 	free_irq(priv->irq_regular, priv);
 	free_irq(priv->irq_dma, priv);
 
-	iounmap(priv->sdmmc_base);
-
 	clk_disable_unprepare(priv->clk_sdmmc);
 	clk_put(priv->clk_sdmmc);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
 	mmc_free_host(mmc);
 
 	dev_info(&pdev->dev, "WMT MCI device removed\n");
-- 
2.1.0

