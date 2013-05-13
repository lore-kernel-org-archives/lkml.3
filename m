Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3EMKnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:43:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:9080 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab3EMKnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:43:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,660,1363158000"; 
   d="scan'208";a="240707383"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/3] spi/pxa2xx: convert to dma_request_slave_channel_compat()
Date: Mon, 13 May 2013 13:45:10 +0300
Message-Id: <1368441911-6562-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368441911-6562-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1368441911-6562-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have these nice DMA API helper functions we can take advantage
of those instead of open-coding the channel/request line extraction from
ACPI. Use the _compat version which still allows passing the
channel/request line from platform data.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx-dma.c |   11 ++++++-----
 drivers/spi/spi-pxa2xx.c     |   34 ++--------------------------------
 2 files changed, 8 insertions(+), 37 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx-dma.c b/drivers/spi/spi-pxa2xx-dma.c
index c735c5a..f4cb744 100644
--- a/drivers/spi/spi-pxa2xx-dma.c
+++ b/drivers/spi/spi-pxa2xx-dma.c
@@ -327,22 +327,23 @@ void pxa2xx_spi_dma_start(struct driver_data *drv_data)
 int pxa2xx_spi_dma_setup(struct driver_data *drv_data)
 {
 	struct pxa2xx_spi_master *pdata = drv_data->master_info;
+	struct device *dev = &drv_data->pdev->dev;
 	dma_cap_mask_t mask;
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	drv_data->dummy = devm_kzalloc(&drv_data->pdev->dev, SZ_2K, GFP_KERNEL);
+	drv_data->dummy = devm_kzalloc(dev, SZ_2K, GFP_KERNEL);
 	if (!drv_data->dummy)
 		return -ENOMEM;
 
-	drv_data->tx_chan = dma_request_channel(mask, pxa2xx_spi_dma_filter,
-						pdata);
+	drv_data->tx_chan = dma_request_slave_channel_compat(mask,
+				pxa2xx_spi_dma_filter, pdata, dev, "tx");
 	if (!drv_data->tx_chan)
 		return -ENODEV;
 
-	drv_data->rx_chan = dma_request_channel(mask, pxa2xx_spi_dma_filter,
-						pdata);
+	drv_data->rx_chan = dma_request_slave_channel_compat(mask,
+				pxa2xx_spi_dma_filter, pdata, dev, "rx");
 	if (!drv_data->rx_chan) {
 		dma_release_channel(drv_data->tx_chan);
 		drv_data->tx_chan = NULL;
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index e5d7823..d20b31a 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1040,32 +1040,10 @@ static void cleanup(struct spi_device *spi)
 }
 
 #ifdef CONFIG_ACPI
-static int pxa2xx_spi_acpi_add_dma(struct acpi_resource *res, void *data)
-{
-	struct pxa2xx_spi_master *pdata = data;
-
-	if (res->type == ACPI_RESOURCE_TYPE_FIXED_DMA) {
-		const struct acpi_resource_fixed_dma *dma;
-
-		dma = &res->data.fixed_dma;
-		if (pdata->tx_slave_id < 0) {
-			pdata->tx_slave_id = dma->request_lines;
-			pdata->tx_chan_id = dma->channels;
-		} else if (pdata->rx_slave_id < 0) {
-			pdata->rx_slave_id = dma->request_lines;
-			pdata->rx_chan_id = dma->channels;
-		}
-	}
-
-	/* Tell the ACPI core to skip this resource */
-	return 1;
-}
-
 static struct pxa2xx_spi_master *
 pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
 {
 	struct pxa2xx_spi_master *pdata;
-	struct list_head resource_list;
 	struct acpi_device *adev;
 	struct ssp_device *ssp;
 	struct resource *res;
@@ -1103,15 +1081,7 @@ pxa2xx_spi_acpi_get_pdata(struct platform_device *pdev)
 		ssp->port_id = devid;
 
 	pdata->num_chipselect = 1;
-	pdata->rx_slave_id = -1;
-	pdata->tx_slave_id = -1;
-
-	INIT_LIST_HEAD(&resource_list);
-	acpi_dev_get_resources(adev, &resource_list, pxa2xx_spi_acpi_add_dma,
-			       pdata);
-	acpi_dev_free_resource_list(&resource_list);
-
-	pdata->enable_dma = pdata->rx_slave_id >= 0 && pdata->tx_slave_id >= 0;
+	pdata->enable_dma = true;
 
 	return pdata;
 }
@@ -1214,7 +1184,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	if (platform_info->enable_dma) {
 		status = pxa2xx_spi_dma_setup(drv_data);
 		if (status) {
-			dev_warn(dev, "failed to setup DMA, using PIO\n");
+			dev_dbg(dev, "no DMA channels available, using PIO\n");
 			platform_info->enable_dma = false;
 		}
 	}
-- 
1.7.10.4

