Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab3EOKBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 06:01:05 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64936 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3EOJwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:52:41 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Andreas Westin <andreas.westin@stericsson.com>
Subject: [PATCH 16/39] crypto: ux500/cryp - Set DMA configuration though dma_slave_config()
Date: Wed, 15 May 2013 10:51:39 +0100
Message-Id: <1368611522-9984-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA controller currently takes configuration information from
information passed though dma_channel_request(), but it shouldn't.
Using the API, the DMA channel should only be configured during
a dma_slave_config() call.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andreas Westin <andreas.westin@stericsson.com>
Cc: linux-crypto@vger.kernel.org
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/ux500/cryp/cryp.h      |    7 ++++++-
 drivers/crypto/ux500/cryp/cryp_core.c |   17 +++++++++++++++++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ux500/cryp/cryp.h b/drivers/crypto/ux500/cryp/cryp.h
index 14cfd05..d1d6606 100644
--- a/drivers/crypto/ux500/cryp/cryp.h
+++ b/drivers/crypto/ux500/cryp/cryp.h
@@ -114,6 +114,9 @@ enum cryp_status_id {
 };
 
 /* Cryp DMA interface */
+#define CRYP_DMA_TX_FIFO	0x08
+#define CRYP_DMA_RX_FIFO	0x10
+
 enum cryp_dma_req_type {
 	CRYP_DMA_DISABLE_BOTH,
 	CRYP_DMA_ENABLE_IN_DATA,
@@ -217,7 +220,8 @@ struct cryp_dma {
 
 /**
  * struct cryp_device_data - structure for a cryp device.
- * @base: Pointer to the hardware base address.
+ * @base: Pointer to virtual base address of the cryp device.
+ * @phybase: Pointer to physical memory location of the cryp device.
  * @dev: Pointer to the devices dev structure.
  * @clk: Pointer to the device's clock control.
  * @pwr_regulator: Pointer to the device's power control.
@@ -232,6 +236,7 @@ struct cryp_dma {
  */
 struct cryp_device_data {
 	struct cryp_register __iomem *base;
+	phys_addr_t phybase;
 	struct device *dev;
 	struct clk *clk;
 	struct regulator *pwr_regulator;
diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index ccdf173..d9c863d 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -475,6 +475,19 @@ static int cryp_get_device_data(struct cryp_ctx *ctx,
 static void cryp_dma_setup_channel(struct cryp_device_data *device_data,
 				   struct device *dev)
 {
+	struct dma_slave_config mem2cryp = {
+		.direction = DMA_MEM_TO_DEV,
+		.dst_addr = device_data->phybase + CRYP_DMA_TX_FIFO,
+		.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES,
+		.dst_maxburst = 4,
+        };
+	struct dma_slave_config cryp2mem = {
+		.direction = DMA_DEV_TO_MEM,
+		.src_addr = device_data->phybase + CRYP_DMA_RX_FIFO,
+		.src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES,
+		.src_maxburst = 4,
+        };
+
 	dma_cap_zero(device_data->dma.mask);
 	dma_cap_set(DMA_SLAVE, device_data->dma.mask);
 
@@ -490,6 +503,9 @@ static void cryp_dma_setup_channel(struct cryp_device_data *device_data,
 				    stedma40_filter,
 				    device_data->dma.cfg_cryp2mem);
 
+	dmaengine_slave_config(device_data->dma.chan_mem2cryp, &mem2cryp);
+	dmaengine_slave_config(device_data->dma.chan_cryp2mem, &cryp2mem);
+
 	init_completion(&device_data->dma.cryp_dma_complete);
 }
 
@@ -1431,6 +1447,7 @@ static int ux500_cryp_probe(struct platform_device *pdev)
 		goto out_kfree;
 	}
 
+	device_data->phybase = res->start;
 	device_data->base = ioremap(res->start, resource_size(res));
 	if (!device_data->base) {
 		dev_err(dev, "[%s]: ioremap failed!", __func__);
-- 
1.7.10.4

