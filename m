Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966332Ab3DQNcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:32:25 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:57066 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966219Ab3DQNcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:32:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH] mmc: mmci: Allow MMCI to request channels with information acquired from DT
Date: Wed, 17 Apr 2013 14:32:14 +0100
Message-Id: <1366205534-25079-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if DMA information isn't passed from platform data, then DMA
will not be used. This patch allows DMA information obtained though Device
Tree to be used as well.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mmc/host/mmci.c |   43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 372e921..42e8fec 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -298,15 +298,32 @@ static void mmci_init_sg(struct mmci_host *host, struct mmc_data *data)
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
+	const char *chan_name;
+	int count, i;
+	bool do_tx = false, do_rx = false;
 
 	if (!plat || !plat->dma_filter) {
-		dev_info(mmc_dev(host->mmc), "no DMA platform data\n");
-		return;
+		if (np) {
+			count = of_property_count_strings(np, "dma-names");
+			for (i = 0; i < count; i++) {
+				of_property_read_string_index(np, "dma-names",
+							      i, &chan_name);
+				if (strcmp(chan_name, "tx"))
+					do_tx = true;
+				else if (strcmp(chan_name, "rx"))
+					do_rx = true;
+			}
+		} else {
+			dev_info(mmc_dev(host->mmc), "no DMA platform data\n");
+			return;
+		}
 	}
 
 	/* initialize pre request cookie */
@@ -321,19 +338,21 @@ static void mmci_dma_setup(struct mmci_host *host)
 	 * attempt to use it bidirectionally, however if it is
 	 * is specified but cannot be located, DMA will be disabled.
 	 */
-	if (plat->dma_rx_param) {
-		host->dma_rx_channel = dma_request_channel(mask,
-							   plat->dma_filter,
-							   plat->dma_rx_param);
+	if (plat->dma_rx_param || do_rx) {
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
+	if (plat->dma_tx_param || do_tx) {
+		host->dma_tx_channel = dma_request_slave_channel_compat(mask,
+					(plat) ? plat->dma_filter : NULL,
+					(plat) ? plat->dma_tx_param : NULL,
+					&dev->dev, "tx");
 		if (!host->dma_tx_channel)
 			dev_warn(mmc_dev(host->mmc), "no TX DMA channel\n");
 	} else {
@@ -1538,7 +1557,7 @@ static int mmci_probe(struct amba_device *dev,
 		 amba_rev(dev), (unsigned long long)dev->res.start,
 		 dev->irq[0], dev->irq[1]);
 
-	mmci_dma_setup(host);
+	mmci_dma_setup(dev, host);
 
 	pm_runtime_set_autosuspend_delay(&dev->dev, 50);
 	pm_runtime_use_autosuspend(&dev->dev);
-- 
1.7.10.4

