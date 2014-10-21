Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbaJUJYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:24:33 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54365 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaJUJW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:22:58 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 06/12] mmc: sdhci-pxav3: Move I/O clock to private data
Date: Tue, 21 Oct 2014 11:22:38 +0200
Message-Id: <1413883364-681-7-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we are using references to the I/O clock throughout the driver,
move it to the private data. Also, in preparation for core clock,
rename it to clk_io.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: linux-mmc@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mmc/host/sdhci-pxav3.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index e52bbbb09d88..a34a589670e6 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -59,6 +59,7 @@
 #define SDCE_MISC_INT_EN	(1<<1)
 
 struct sdhci_pxa {
+	struct clk *clk_io;
 	u8	power_mode;
 };
 
@@ -288,9 +289,7 @@ static int sdhci_pxav3_probe(struct platform_device *pdev)
 	struct sdhci_host *host = NULL;
 	struct sdhci_pxa *pxa = NULL;
 	const struct of_device_id *match;
-
 	int ret;
-	struct clk *clk;
 
 	pxa = devm_kzalloc(&pdev->dev, sizeof(struct sdhci_pxa), GFP_KERNEL);
 	if (!pxa)
@@ -310,14 +309,14 @@ static int sdhci_pxav3_probe(struct platform_device *pdev)
 	pltfm_host = sdhci_priv(host);
 	pltfm_host->priv = pxa;
 
-	clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(clk)) {
+	pxa->clk_io = devm_clk_get(dev, NULL);
+	if (IS_ERR(pxa->clk_io)) {
 		dev_err(dev, "failed to get io clock\n");
-		ret = PTR_ERR(clk);
+		ret = PTR_ERR(pxa->clk_io);
 		goto err_clk_get;
 	}
-	pltfm_host->clk = clk;
-	clk_prepare_enable(clk);
+	pltfm_host->clk = pxa->clk_io;
+	clk_prepare_enable(pxa->clk_io);
 
 	/* enable 1/8V DDR capable */
 	host->mmc->caps |= MMC_CAP_1_8V_DDR;
@@ -390,7 +389,7 @@ err_add_host:
 	pm_runtime_disable(&pdev->dev);
 err_of_parse:
 err_cd_req:
-	clk_disable_unprepare(clk);
+	clk_disable_unprepare(pxa->clk_io);
 err_clk_get:
 err_mbus_win:
 	sdhci_pltfm_free(pdev);
@@ -401,12 +400,13 @@ static int sdhci_pxav3_remove(struct platform_device *pdev)
 {
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_pxa *pxa = pltfm_host->priv;
 
 	pm_runtime_get_sync(&pdev->dev);
 	sdhci_remove_host(host, 1);
 	pm_runtime_disable(&pdev->dev);
 
-	clk_disable_unprepare(pltfm_host->clk);
+	clk_disable_unprepare(pxa->clk_io);
 
 	sdhci_pltfm_free(pdev);
 
@@ -446,13 +446,14 @@ static int sdhci_pxav3_runtime_suspend(struct device *dev)
 {
 	struct sdhci_host *host = dev_get_drvdata(dev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_pxa *pxa = pltfm_host->priv;
 	unsigned long flags;
 
 	spin_lock_irqsave(&host->lock, flags);
 	host->runtime_suspended = true;
 	spin_unlock_irqrestore(&host->lock, flags);
 
-	clk_disable_unprepare(pltfm_host->clk);
+	clk_disable_unprepare(pxa->clk_io);
 
 	return 0;
 }
@@ -461,9 +462,10 @@ static int sdhci_pxav3_runtime_resume(struct device *dev)
 {
 	struct sdhci_host *host = dev_get_drvdata(dev);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_pxa *pxa = pltfm_host->priv;
 	unsigned long flags;
 
-	clk_prepare_enable(pltfm_host->clk);
+	clk_prepare_enable(pxa->clk_io);
 
 	spin_lock_irqsave(&host->lock, flags);
 	host->runtime_suspended = false;
-- 
2.1.1

