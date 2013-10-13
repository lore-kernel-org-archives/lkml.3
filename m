Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab3JMQSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 12:18:46 -0400
Received: from sauhun.de ([89.238.76.85]:56494 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810Ab3JMQSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 12:18:25 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Nicolas Pitre <nico@fluxnic.net>,
        Chris Ball <cjb@laptop.org>, Balaji T K <balajitk@ti.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 2/4] drivers/mmc/host: don't use devm_pinctrl_get_select_default() in probe
Date: Sun, 13 Oct 2013 18:17:48 +0200
Message-Id: <1381681071-6021-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
References: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
we can rely on device core for setting the default pins. Compile tested only.

Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/mmc/host/mvsdio.c          | 7 +------
 drivers/mmc/host/omap_hsmmc.c      | 7 -------
 drivers/mmc/host/sdhci-esdhc-imx.c | 8 --------
 3 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 06c5b0b..8c9f448 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -25,7 +25,6 @@
 #include <linux/of_irq.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/slot-gpio.h>
-#include <linux/pinctrl/consumer.h>
 
 #include <asm/sizes.h>
 #include <asm/unaligned.h>
@@ -685,7 +684,7 @@ static int __init mvsd_probe(struct platform_device *pdev)
 	const struct mbus_dram_target_info *dram;
 	struct resource *r;
 	int ret, irq;
-	struct pinctrl *pinctrl;
+	int gpio_card_detect, gpio_write_protect;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
@@ -702,10 +701,6 @@ static int __init mvsd_probe(struct platform_device *pdev)
 	host->mmc = mmc;
 	host->dev = &pdev->dev;
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "no pins associated\n");
-
 	/*
 	 * Some non-DT platforms do not pass a clock, and the clock
 	 * frequency is passed through platform_data. On DT platforms,
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 6ac63df..f6606cf 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -38,7 +38,6 @@
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/regulator/consumer.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/pm_runtime.h>
 #include <linux/platform_data/mmc-omap.h>
 
@@ -1777,7 +1776,6 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	const struct of_device_id *match;
 	dma_cap_mask_t mask;
 	unsigned tx_req, rx_req;
-	struct pinctrl *pinctrl;
 
 	match = of_match_device(of_match_ptr(omap_mmc_of_match), &pdev->dev);
 	if (match) {
@@ -1996,11 +1994,6 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 
 	omap_hsmmc_disable_irq(host);
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev,
-			"pins are not configured from the driver\n");
-
 	omap_hsmmc_protect_card(host);
 
 	mmc_add_host(mmc);
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index abc8cf0..0ac8b1a 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -25,7 +25,6 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/platform_data/mmc-esdhc-imx.h>
 #include "sdhci-pltfm.h"
 #include "sdhci-esdhc.h"
@@ -80,7 +79,6 @@ struct pltfm_imx_data {
 	int flags;
 	u32 scratchpad;
 	enum imx_esdhc_type devtype;
-	struct pinctrl *pinctrl;
 	struct esdhc_platform_data boarddata;
 	struct clk *clk_ipg;
 	struct clk *clk_ahb;
@@ -568,12 +566,6 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	clk_prepare_enable(imx_data->clk_ipg);
 	clk_prepare_enable(imx_data->clk_ahb);
 
-	imx_data->pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(imx_data->pinctrl)) {
-		err = PTR_ERR(imx_data->pinctrl);
-		goto disable_clk;
-	}
-
 	host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 
 	if (is_imx25_esdhc(imx_data) || is_imx35_esdhc(imx_data))
-- 
1.8.4.rc3

