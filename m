Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3JHNwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:52:18 -0400
Received: from [213.199.154.209] ([213.199.154.209]:33287 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754348Ab3JHNwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:52:13 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <cjb@laptop.org>
CC: <shawn.guo@linaro.org>, <festevam@gmail.com>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] mmc: sdhci-esdhc-imx: Check the return value from clk_prepare_enable()
Date: Tue, 8 Oct 2013 10:47:28 -0300
Message-ID: <1381240048-22685-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_prepare_enable() may fail, so let's check its return value and propagate it
in the case of error.

Also, fix the sequence for disabling the clock in the probe error path and 
also in the remove function.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index b9899e9..abc9836 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -877,9 +877,17 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 
 	pltfm_host->clk = imx_data->clk_per;
 
-	clk_prepare_enable(imx_data->clk_per);
-	clk_prepare_enable(imx_data->clk_ipg);
-	clk_prepare_enable(imx_data->clk_ahb);
+	err = clk_prepare_enable(imx_data->clk_per);
+	if (err)
+		goto free_sdhci;
+
+	err = clk_prepare_enable(imx_data->clk_ipg);
+	if (err)
+		goto err_ipg;
+
+	err = clk_prepare_enable(imx_data->clk_ahb);
+	if (err)
+		goto err_ahb;
 
 	imx_data->pinctrl = devm_pinctrl_get(&pdev->dev);
 	if (IS_ERR(imx_data->pinctrl)) {
@@ -995,9 +1003,11 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	return 0;
 
 disable_clk:
-	clk_disable_unprepare(imx_data->clk_per);
-	clk_disable_unprepare(imx_data->clk_ipg);
 	clk_disable_unprepare(imx_data->clk_ahb);
+err_ahb:
+	clk_disable_unprepare(imx_data->clk_ipg);
+err_ipg:
+	clk_disable_unprepare(imx_data->clk_per);
 free_sdhci:
 	sdhci_pltfm_free(pdev);
 	return err;
@@ -1012,9 +1022,9 @@ static int sdhci_esdhc_imx_remove(struct platform_device *pdev)
 
 	sdhci_remove_host(host, dead);
 
-	clk_disable_unprepare(imx_data->clk_per);
-	clk_disable_unprepare(imx_data->clk_ipg);
 	clk_disable_unprepare(imx_data->clk_ahb);
+	clk_disable_unprepare(imx_data->clk_ipg);
+	clk_disable_unprepare(imx_data->clk_per);
 
 	sdhci_pltfm_free(pdev);
 
-- 
1.8.1.2


