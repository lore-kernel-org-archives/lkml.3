Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab3GJQBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:01:50 -0400
Received: from sauhun.de ([89.238.76.85]:44309 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab3GJP7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:59:21 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Nicolas Pitre <nico@fluxnic.net>,
        Chris Ball <cjb@laptop.org>, Balaji T K <balajitk@ti.com>,
        Barry Song <baohua.song@csr.com>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Jingoo Han <jg1.han@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>, Marek Vasut <marex@denx.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/12] drivers/mmc/host: don't use devm_pinctrl_get_select_default() in probe
Date: Wed, 10 Jul 2013 16:57:39 +0100
Message-Id: <1373471889-18107-4-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
we can rely on device core for setting the default pins. Compile tested only.

Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/mmc/host/mvsdio.c          |    6 ------
 drivers/mmc/host/mxs-mmc.c         |    8 --------
 drivers/mmc/host/omap_hsmmc.c      |    7 -------
 drivers/mmc/host/sdhci-esdhc-imx.c |    8 --------
 drivers/mmc/host/sdhci-sirf.c      |    8 --------
 5 files changed, 37 deletions(-)

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 8960fc8..ed5edc2 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -25,7 +25,6 @@
 #include <linux/of_irq.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/slot-gpio.h>
-#include <linux/pinctrl/consumer.h>
 
 #include <asm/sizes.h>
 #include <asm/unaligned.h>
@@ -686,7 +685,6 @@ static int __init mvsd_probe(struct platform_device *pdev)
 	struct resource *r;
 	int ret, irq;
 	int gpio_card_detect, gpio_write_protect;
-	struct pinctrl *pinctrl;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
@@ -703,10 +701,6 @@ static int __init mvsd_probe(struct platform_device *pdev)
 	host->mmc = mmc;
 	host->dev = &pdev->dev;
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "no pins associated\n");
-
 	/*
 	 * Some non-DT platforms do not pass a clock, and the clock
 	 * frequency is passed through platform_data. On DT platforms,
diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 4278a17..1eb3224 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -41,7 +41,6 @@
 #include <linux/gpio.h>
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/stmp_device.h>
 #include <linux/spi/mxs-spi.h>
 
@@ -580,7 +579,6 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 	struct mxs_mmc_host *host;
 	struct mmc_host *mmc;
 	struct resource *iores;
-	struct pinctrl *pinctrl;
 	int ret = 0, irq_err;
 	struct regulator *reg_vmmc;
 	enum of_gpio_flags flags;
@@ -620,12 +618,6 @@ static int mxs_mmc_probe(struct platform_device *pdev)
 		}
 	}
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl)) {
-		ret = PTR_ERR(pinctrl);
-		goto out_mmc_free;
-	}
-
 	ssp->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(ssp->clk)) {
 		ret = PTR_ERR(ssp->clk);
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index eccedc7..332ce51 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -37,7 +37,6 @@
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/regulator/consumer.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/pm_runtime.h>
 #include <linux/platform_data/mmc-omap.h>
 
@@ -1776,7 +1775,6 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	const struct of_device_id *match;
 	dma_cap_mask_t mask;
 	unsigned tx_req, rx_req;
-	struct pinctrl *pinctrl;
 
 	match = of_match_device(of_match_ptr(omap_mmc_of_match), &pdev->dev);
 	if (match) {
@@ -1995,11 +1993,6 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 
 	omap_hsmmc_disable_irq(host);
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev,
-			"pins are not configured from the driver\n");
-
 	omap_hsmmc_protect_card(host);
 
 	mmc_add_host(mmc);
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index d5f0d59..0880e3a 100644
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
@@ -544,12 +542,6 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
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
diff --git a/drivers/mmc/host/sdhci-sirf.c b/drivers/mmc/host/sdhci-sirf.c
index 09805af..ccf12dd 100644
--- a/drivers/mmc/host/sdhci-sirf.c
+++ b/drivers/mmc/host/sdhci-sirf.c
@@ -13,7 +13,6 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/mmc/slot-gpio.h>
-#include <linux/pinctrl/consumer.h>
 #include "sdhci-pltfm.h"
 
 struct sdhci_sirf_priv {
@@ -46,15 +45,8 @@ static int sdhci_sirf_probe(struct platform_device *pdev)
 	struct sdhci_host *host;
 	struct sdhci_pltfm_host *pltfm_host;
 	struct sdhci_sirf_priv *priv;
-	struct pinctrl *pinctrl;
 	int ret;
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl)) {
-		dev_err(&pdev->dev, "unable to get pinmux");
-		return PTR_ERR(pinctrl);
-	}
-
 	priv = devm_kzalloc(&pdev->dev, sizeof(struct sdhci_sirf_priv),
 		GFP_KERNEL);
 	if (!priv) {
-- 
1.7.10.4

