Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaLBQrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:47:35 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:60740 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbaLBQre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:47:34 -0500
From: Stefan Agner <stefan@agner.ch>
To: chris@printf.net, ulf.hansson@linaro.org, anton@enomsg.org
Cc: rmk+kernel@arm.linux.org.uk, b29396@freescale.com, shawn.guo@linaro.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 2/2] mmc: sdhci-esdhc-imx: enable IPG clock for sdio interrupts
Date: Tue,  2 Dec 2014 17:47:25 +0100
Message-Id: <1417538845-10867-2-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417538845-10867-1-git-send-email-stefan@agner.ch>
References: <1417538845-10867-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable IPG clock for sdio interrupts while runtime PM, since this
clock is needed for register access. The need of this clock has been
verified on Vybrid, but this is probably true for i.MX53 and maybe
others. The need for bus access during runtime suspend has been
introduced with be138554a792 ("mmc: sdhci: allow sdio interrupts
while sdhci runtime suspended").

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/mmc/host/sdhci-esdhc-imx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 587ee0e..b7e9ad1 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1193,10 +1193,10 @@ static int sdhci_esdhc_runtime_suspend(struct device *dev)
 
 	ret = sdhci_runtime_suspend_host(host);
 
-	if (!sdhci_sdio_irq_enabled(host)) {
+	if (!sdhci_sdio_irq_enabled(host))
 		clk_disable_unprepare(imx_data->clk_per);
-		clk_disable_unprepare(imx_data->clk_ipg);
-	}
+
+	clk_disable_unprepare(imx_data->clk_ipg);
 	clk_disable_unprepare(imx_data->clk_ahb);
 
 	return ret;
@@ -1208,10 +1208,10 @@ static int sdhci_esdhc_runtime_resume(struct device *dev)
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct pltfm_imx_data *imx_data = pltfm_host->priv;
 
-	if (!sdhci_sdio_irq_enabled(host)) {
+	if (!sdhci_sdio_irq_enabled(host))
 		clk_prepare_enable(imx_data->clk_per);
-		clk_prepare_enable(imx_data->clk_ipg);
-	}
+
+	clk_prepare_enable(imx_data->clk_ipg);
 	clk_prepare_enable(imx_data->clk_ahb);
 
 	return sdhci_runtime_resume_host(host);
-- 
2.1.3

