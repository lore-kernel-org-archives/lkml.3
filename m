Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966749Ab3DQPEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:04:44 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48908 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966461Ab3DQPEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 11:04:43 -0400
Date: Wed, 17 Apr 2013 16:04:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: mmci: Allow MMCI to request channels with
 information acquired from DT
Message-ID: <20130417150437.GA3137@gmail.com>
References: <1366205534-25079-1-git-send-email-lee.jones@linaro.org>
 <201304171550.56037.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304171550.56037.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks unnecessarily complex.

That thought did cross my mind.

> Why not just do dma_request_slave_channel_compat() unconditionally here?

So how about something like this instead, as it keeps the current
semantics, and only differs in the case of DT.

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 372e921..1fd212a 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -298,14 +298,16 @@ static void mmci_init_sg(struct mmci_host *host, struct mmc_data *data)
  * no custom DMA interfaces are supported.
  */
 #ifdef CONFIG_DMA_ENGINE
-static void mmci_dma_setup(struct mmci_host *host)
+static void mmci_dma_setup(struct amba_device *dev,
+			   struct mmci_host *host)
 {
+	struct device_node *np = dev->dev.of_node;
 	struct mmci_platform_data *plat = host->plat;
 	const char *rxname, *txname;
 	dma_cap_mask_t mask;
 
-	if (!plat || !plat->dma_filter) {
-		dev_info(mmc_dev(host->mmc), "no DMA platform data\n");
+	if (!(plat && plat->dma_filter) && !np) {
+		dev_info(mmc_dev(host->mmc), "no DMA platform data or DT\n");
 		return;
 	}
 
@@ -321,19 +323,21 @@ static void mmci_dma_setup(struct mmci_host *host)
 	 * attempt to use it bidirectionally, however if it is
 	 * is specified but cannot be located, DMA will be disabled.
 	 */
-	if (plat->dma_rx_param) {
-		host->dma_rx_channel = dma_request_channel(mask,
-							   plat->dma_filter,
-							   plat->dma_rx_param);
+	if ((plat && plat->dma_rx_param) || np) {
+		host->dma_rx_channel = dma_request_slave_channel_compat(mask,
+					(plat) ? plat->dma_filter : NULL,
+					(plat) ? plat->dma_rx_param : NULL,
+					&dev->dev, "rx");
 		/* E.g if no DMA hardware is present */
 		if (!host->dma_rx_channel)
 			dev_err(mmc_dev(host->mmc), "no RX DMA channel\n");
 	}
 
-	if (plat->dma_tx_param) {
-		host->dma_tx_channel = dma_request_channel(mask,
-							   plat->dma_filter,
-							   plat->dma_tx_param);
+	if ((plat && plat->dma_tx_param) || np) {
+		host->dma_tx_channel = dma_request_slave_channel_compat(mask,
+					(plat) ? plat->dma_filter : NULL,
+					(plat) ? plat->dma_tx_param : NULL,
+					&dev->dev, "tx");
 		if (!host->dma_tx_channel)
 			dev_warn(mmc_dev(host->mmc), "no TX DMA channel\n");
 	} else {
@@ -1538,7 +1542,7 @@ static int mmci_probe(struct amba_device *dev,
 		 amba_rev(dev), (unsigned long long)dev->res.start,
 		 dev->irq[0], dev->irq[1]);
 
-	mmci_dma_setup(host);
+	mmci_dma_setup(dev, host);
 
 	pm_runtime_set_autosuspend_delay(&dev->dev, 50);
 	pm_runtime_use_autosuspend(&dev->dev);

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
