Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab3EOJwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:52:50 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56020 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3EOJwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:52:36 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Andreas Westin <andreas.westin@stericsson.com>
Subject: [PATCH 13/39] crypto: ux500/hash - Set DMA configuration though dma_slave_config()
Date: Wed, 15 May 2013 10:51:36 +0100
Message-Id: <1368611522-9984-14-git-send-email-lee.jones@linaro.org>
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
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/crypto/ux500/hash/hash_alg.h  |    5 ++++-
 drivers/crypto/ux500/hash/hash_core.c |   10 ++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index cd9351c..be6eb54 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -11,6 +11,7 @@
 #include <linux/bitops.h>
 
 #define HASH_BLOCK_SIZE			64
+#define HASH_DMA_FIFO			4
 #define HASH_DMA_ALIGN_SIZE		4
 #define HASH_DMA_PERFORMANCE_MIN_SIZE	1024
 #define HASH_BYTES_PER_WORD		4
@@ -347,7 +348,8 @@ struct hash_req_ctx {
 
 /**
  * struct hash_device_data - structure for a hash device.
- * @base:		Pointer to the hardware base address.
+ * @base:		Pointer to virtual base address of the hash device.
+ * @phybase:		Pointer to physical memory location of the hash device.
  * @list_node:		For inclusion in klist.
  * @dev:		Pointer to the device dev structure.
  * @ctx_lock:		Spinlock for current_ctx.
@@ -361,6 +363,7 @@ struct hash_req_ctx {
  */
 struct hash_device_data {
 	struct hash_register __iomem	*base;
+	phys_addr_t             phybase;
 	struct klist_node	list_node;
 	struct device		*dev;
 	struct spinlock		ctx_lock;
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 4b02428..6269576 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -122,6 +122,13 @@ static void hash_dma_setup_channel(struct hash_device_data *device_data,
 				struct device *dev)
 {
 	struct hash_platform_data *platform_data = dev->platform_data;
+	struct dma_slave_config conf = {
+		.direction = DMA_MEM_TO_DEV,
+		.dst_addr = device_data->phybase + HASH_DMA_FIFO,
+		.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES,
+		.dst_maxburst = 16,
+        };
+
 	dma_cap_zero(device_data->dma.mask);
 	dma_cap_set(DMA_SLAVE, device_data->dma.mask);
 
@@ -131,6 +138,8 @@ static void hash_dma_setup_channel(struct hash_device_data *device_data,
 				platform_data->dma_filter,
 				device_data->dma.cfg_mem2hash);
 
+	dmaengine_slave_config(device_data->dma.chan_mem2hash, &conf);
+
 	init_completion(&device_data->dma.complete);
 }
 
@@ -1699,6 +1708,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 		goto out_kfree;
 	}
 
+	device_data->phybase = res->start;
 	device_data->base = ioremap(res->start, resource_size(res));
 	if (!device_data->base) {
 		dev_err(dev, "[%s] ioremap() failed!",
-- 
1.7.10.4

