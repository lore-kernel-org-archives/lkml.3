Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997Ab3GPVGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:06:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34816 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933477Ab3GPVGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:06:50 -0400
Message-ID: <1374008808.1949.37.camel@joe-AO722>
Subject: crypto: ux500: Fix logging, make arrays const, neatening
From: Joe Perches <joe@perches.com>
To: Masanari Iida <standby24x7@gmail.com>,
        Andreas Westin <andreas.westin@stericsson.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 16 Jul 2013 14:06:48 -0700
In-Reply-To: <1374003464-32302-1-git-send-email-standby24x7@gmail.com>
References: <1373896210-21316-1-git-send-email-standby24x7@gmail.com>
	 <1374003464-32302-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logging messages without newlines are possibly interleaved
with other messages.  Add terminating newlines to avoid
this.

Other miscellaneous changes:

Make arrays const to reduce data size
Add pr_fmt to prefix pr_<level>, remove now unused DEV_DBG_NAME
Coalesce formats, align arguments
Remove unnecessary OOM messages as dump_stack is already done
Remove unnecessary cast of void *
Change kzalloc(sizeof(struct)...) to kzalloc(sizeof(*var), ...)
Reduce indents in struct definitions

Signed-off-by: Joe Perches <joe@perches.com>
---

On top of Masanari Iida's patch:
https://patchwork.kernel.org/patch/2828273/

 drivers/crypto/ux500/hash/hash_core.c | 586 ++++++++++++++++------------------
 1 file changed, 279 insertions(+), 307 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 496ae6a..4cbc962 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -11,6 +11,8 @@
  * License terms: GNU General Public License (GPL) version 2
  */
 
+#define pr_fmt(fmt) "hashX hashX: " fmt
+
 #include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -35,8 +37,6 @@
 
 #include "hash_alg.h"
 
-#define DEV_DBG_NAME "hashX hashX:"
-
 static int hash_mode;
 module_param(hash_mode, int, 0);
 MODULE_PARM_DESC(hash_mode, "CPU or DMA mode. CPU = 0 (default), DMA = 1");
@@ -44,13 +44,13 @@ MODULE_PARM_DESC(hash_mode, "CPU or DMA mode. CPU = 0 (default), DMA = 1");
 /**
  * Pre-calculated empty message digests.
  */
-static u8 zero_message_hash_sha1[SHA1_DIGEST_SIZE] = {
+static const u8 zero_message_hash_sha1[SHA1_DIGEST_SIZE] = {
 	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d,
 	0x32, 0x55, 0xbf, 0xef, 0x95, 0x60, 0x18, 0x90,
 	0xaf, 0xd8, 0x07, 0x09
 };
 
-static u8 zero_message_hash_sha256[SHA256_DIGEST_SIZE] = {
+static const u8 zero_message_hash_sha256[SHA256_DIGEST_SIZE] = {
 	0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14,
 	0x9a, 0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24,
 	0x27, 0xae, 0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c,
@@ -58,14 +58,14 @@ static u8 zero_message_hash_sha256[SHA256_DIGEST_SIZE] = {
 };
 
 /* HMAC-SHA1, no key */
-static u8 zero_message_hmac_sha1[SHA1_DIGEST_SIZE] = {
+static const u8 zero_message_hmac_sha1[SHA1_DIGEST_SIZE] = {
 	0xfb, 0xdb, 0x1d, 0x1b, 0x18, 0xaa, 0x6c, 0x08,
 	0x32, 0x4b, 0x7d, 0x64, 0xb7, 0x1f, 0xb7, 0x63,
 	0x70, 0x69, 0x0e, 0x1d
 };
 
 /* HMAC-SHA256, no key */
-static u8 zero_message_hmac_sha256[SHA256_DIGEST_SIZE] = {
+static const u8 zero_message_hmac_sha256[SHA256_DIGEST_SIZE] = {
 	0xb6, 0x13, 0x67, 0x9a, 0x08, 0x14, 0xd9, 0xec,
 	0x77, 0x2f, 0x95, 0xd7, 0x78, 0xc3, 0x5f, 0xc5,
 	0xff, 0x16, 0x97, 0xc4, 0x93, 0x71, 0x56, 0x53,
@@ -97,7 +97,7 @@ static struct hash_driver_data	driver_data;
  *
  */
 static void hash_messagepad(struct hash_device_data *device_data,
-		const u32 *message, u8 index_bytes);
+			    const u32 *message, u8 index_bytes);
 
 /**
  * release_hash_device - Releases a previously allocated hash device.
@@ -119,7 +119,7 @@ static void release_hash_device(struct hash_device_data *device_data)
 }
 
 static void hash_dma_setup_channel(struct hash_device_data *device_data,
-				struct device *dev)
+				   struct device *dev)
 {
 	struct hash_platform_data *platform_data = dev->platform_data;
 	struct dma_slave_config conf = {
@@ -127,7 +127,7 @@ static void hash_dma_setup_channel(struct hash_device_data *device_data,
 		.dst_addr = device_data->phybase + HASH_DMA_FIFO,
 		.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES,
 		.dst_maxburst = 16,
-        };
+	};
 
 	dma_cap_zero(device_data->dma.mask);
 	dma_cap_set(DMA_SLAVE, device_data->dma.mask);
@@ -135,8 +135,8 @@ static void hash_dma_setup_channel(struct hash_device_data *device_data,
 	device_data->dma.cfg_mem2hash = platform_data->mem_to_engine;
 	device_data->dma.chan_mem2hash =
 		dma_request_channel(device_data->dma.mask,
-				platform_data->dma_filter,
-				device_data->dma.cfg_mem2hash);
+				    platform_data->dma_filter,
+				    device_data->dma.cfg_mem2hash);
 
 	dmaengine_slave_config(device_data->dma.chan_mem2hash, &conf);
 
@@ -145,21 +145,21 @@ static void hash_dma_setup_channel(struct hash_device_data *device_data,
 
 static void hash_dma_callback(void *data)
 {
-	struct hash_ctx *ctx = (struct hash_ctx *) data;
+	struct hash_ctx *ctx = data;
 
 	complete(&ctx->device->dma.complete);
 }
 
 static int hash_set_dma_transfer(struct hash_ctx *ctx, struct scatterlist *sg,
-		int len, enum dma_data_direction direction)
+				 int len, enum dma_data_direction direction)
 {
 	struct dma_async_tx_descriptor *desc = NULL;
 	struct dma_chan *channel = NULL;
 	dma_cookie_t cookie;
 
 	if (direction != DMA_TO_DEVICE) {
-		dev_err(ctx->device->dev, "[%s] Invalid DMA direction",
-				__func__);
+		dev_err(ctx->device->dev, "%s: Invalid DMA direction\n",
+			__func__);
 		return -EFAULT;
 	}
 
@@ -172,20 +172,19 @@ static int hash_set_dma_transfer(struct hash_ctx *ctx, struct scatterlist *sg,
 			direction);
 
 	if (!ctx->device->dma.sg_len) {
-		dev_err(ctx->device->dev,
-				"[%s]: Could not map the sg list (TO_DEVICE)",
-				__func__);
+		dev_err(ctx->device->dev, "%s: Could not map the sg list (TO_DEVICE)\n",
+			__func__);
 		return -EFAULT;
 	}
 
-	dev_dbg(ctx->device->dev, "[%s]: Setting up DMA for buffer "
-			"(TO_DEVICE)", __func__);
+	dev_dbg(ctx->device->dev, "%s: Setting up DMA for buffer (TO_DEVICE)\n",
+		__func__);
 	desc = dmaengine_prep_slave_sg(channel,
 			ctx->device->dma.sg, ctx->device->dma.sg_len,
 			direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
 	if (!desc) {
 		dev_err(ctx->device->dev,
-			"[%s]: device_prep_slave_sg() failed!", __func__);
+			"%s: device_prep_slave_sg() failed!\n", __func__);
 		return -EFAULT;
 	}
 
@@ -205,17 +204,16 @@ static void hash_dma_done(struct hash_ctx *ctx)
 	chan = ctx->device->dma.chan_mem2hash;
 	dmaengine_device_control(chan, DMA_TERMINATE_ALL, 0);
 	dma_unmap_sg(chan->device->dev, ctx->device->dma.sg,
-			ctx->device->dma.sg_len, DMA_TO_DEVICE);
-
+		     ctx->device->dma.sg_len, DMA_TO_DEVICE);
 }
 
 static int hash_dma_write(struct hash_ctx *ctx,
-		struct scatterlist *sg, int len)
+			  struct scatterlist *sg, int len)
 {
 	int error = hash_set_dma_transfer(ctx, sg, len, DMA_TO_DEVICE);
 	if (error) {
-		dev_dbg(ctx->device->dev, "[%s]: hash_set_dma_transfer() "
-			"failed", __func__);
+		dev_dbg(ctx->device->dev,
+			"%s: hash_set_dma_transfer() failed\n", __func__);
 		return error;
 	}
 
@@ -245,19 +243,18 @@ static int get_empty_message_digest(
 	if (HASH_OPER_MODE_HASH == ctx->config.oper_mode) {
 		if (HASH_ALGO_SHA1 == ctx->config.algorithm) {
 			memcpy(zero_hash, &zero_message_hash_sha1[0],
-					SHA1_DIGEST_SIZE);
+			       SHA1_DIGEST_SIZE);
 			*zero_hash_size = SHA1_DIGEST_SIZE;
 			*zero_digest = true;
 		} else if (HASH_ALGO_SHA256 ==
 				ctx->config.algorithm) {
 			memcpy(zero_hash, &zero_message_hash_sha256[0],
-					SHA256_DIGEST_SIZE);
+			       SHA256_DIGEST_SIZE);
 			*zero_hash_size = SHA256_DIGEST_SIZE;
 			*zero_digest = true;
 		} else {
-			dev_err(device_data->dev, "[%s] "
-					"Incorrect algorithm!"
-					, __func__);
+			dev_err(device_data->dev, "%s: Incorrect algorithm!\n",
+				__func__);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -265,25 +262,24 @@ static int get_empty_message_digest(
 		if (!ctx->keylen) {
 			if (HASH_ALGO_SHA1 == ctx->config.algorithm) {
 				memcpy(zero_hash, &zero_message_hmac_sha1[0],
-						SHA1_DIGEST_SIZE);
+				       SHA1_DIGEST_SIZE);
 				*zero_hash_size = SHA1_DIGEST_SIZE;
 				*zero_digest = true;
 			} else if (HASH_ALGO_SHA256 == ctx->config.algorithm) {
 				memcpy(zero_hash, &zero_message_hmac_sha256[0],
-						SHA256_DIGEST_SIZE);
+				       SHA256_DIGEST_SIZE);
 				*zero_hash_size = SHA256_DIGEST_SIZE;
 				*zero_digest = true;
 			} else {
-				dev_err(device_data->dev, "[%s] "
-						"Incorrect algorithm!"
-						, __func__);
+				dev_err(device_data->dev, "%s: Incorrect algorithm!\n",
+					__func__);
 				ret = -EINVAL;
 				goto out;
 			}
 		} else {
-			dev_dbg(device_data->dev, "[%s] Continue hash "
-					"calculation, since hmac key available",
-					__func__);
+			dev_dbg(device_data->dev,
+				"%s: Continue hash calculation, since hmac key available\n",
+				__func__);
 		}
 	}
 out:
@@ -299,9 +295,8 @@ out:
  * This function request for disabling power (regulator) and clock,
  * and could also save current hw state.
  */
-static int hash_disable_power(
-		struct hash_device_data *device_data,
-		bool			save_device_state)
+static int hash_disable_power(struct hash_device_data *device_data,
+			      bool save_device_state)
 {
 	int ret = 0;
 	struct device *dev = device_data->dev;
@@ -319,7 +314,7 @@ static int hash_disable_power(
 	clk_disable(device_data->clk);
 	ret = regulator_disable(device_data->regulator);
 	if (ret)
-		dev_err(dev, "[%s] regulator_disable() failed!", __func__);
+		dev_err(dev, "%s: regulator_disable() failed!\n", __func__);
 
 	device_data->power_state = false;
 
@@ -337,9 +332,8 @@ out:
  * This function request for enabling power (regulator) and clock,
  * and could also restore a previously saved hw state.
  */
-static int hash_enable_power(
-		struct hash_device_data *device_data,
-		bool			restore_device_state)
+static int hash_enable_power(struct hash_device_data *device_data,
+			     bool restore_device_state)
 {
 	int ret = 0;
 	struct device *dev = device_data->dev;
@@ -348,14 +342,13 @@ static int hash_enable_power(
 	if (!device_data->power_state) {
 		ret = regulator_enable(device_data->regulator);
 		if (ret) {
-			dev_err(dev, "[%s]: regulator_enable() failed!",
-					__func__);
+			dev_err(dev, "%s: regulator_enable() failed!\n",
+				__func__);
 			goto out;
 		}
 		ret = clk_enable(device_data->clk);
 		if (ret) {
-			dev_err(dev, "[%s]: clk_enable() failed!",
-					__func__);
+			dev_err(dev, "%s: clk_enable() failed!\n", __func__);
 			ret = regulator_disable(
 					device_data->regulator);
 			goto out;
@@ -366,8 +359,7 @@ static int hash_enable_power(
 	if (device_data->restore_dev_state) {
 		if (restore_device_state) {
 			device_data->restore_dev_state = false;
-			hash_resume_state(device_data,
-				&device_data->state);
+			hash_resume_state(device_data, &device_data->state);
 		}
 	}
 out:
@@ -447,7 +439,7 @@ static int hash_get_device_data(struct hash_ctx *ctx,
  * spec or due to a bug in the hw.
  */
 static void hash_hw_write_key(struct hash_device_data *device_data,
-		const u8 *key, unsigned int keylen)
+			      const u8 *key, unsigned int keylen)
 {
 	u32 word = 0;
 	int nwords = 1;
@@ -491,14 +483,14 @@ static void hash_hw_write_key(struct hash_device_data *device_data,
  * calculation.
  */
 static int init_hash_hw(struct hash_device_data *device_data,
-		struct hash_ctx *ctx)
+			struct hash_ctx *ctx)
 {
 	int ret = 0;
 
 	ret = hash_setconfiguration(device_data, &ctx->config);
 	if (ret) {
-		dev_err(device_data->dev, "[%s] hash_setconfiguration() "
-				"failed!", __func__);
+		dev_err(device_data->dev, "%s: hash_setconfiguration() failed!\n",
+			__func__);
 		return ret;
 	}
 
@@ -528,9 +520,8 @@ static int hash_get_nents(struct scatterlist *sg, int size, bool *aligned)
 		size -= sg->length;
 
 		/* hash_set_dma_transfer will align last nent */
-		if ((aligned && !IS_ALIGNED(sg->offset, HASH_DMA_ALIGN_SIZE))
-			|| (!IS_ALIGNED(sg->length, HASH_DMA_ALIGN_SIZE) &&
-				size > 0))
+		if ((aligned && !IS_ALIGNED(sg->offset, HASH_DMA_ALIGN_SIZE)) ||
+		    (!IS_ALIGNED(sg->length, HASH_DMA_ALIGN_SIZE) && size > 0))
 			aligned_data = false;
 
 		sg = sg_next(sg);
@@ -585,21 +576,17 @@ static int hash_init(struct ahash_request *req)
 		if (req->nbytes < HASH_DMA_ALIGN_SIZE) {
 			req_ctx->dma_mode = false; /* Don't use DMA */
 
-			pr_debug(DEV_DBG_NAME " [%s] DMA mode, but direct "
-					"to CPU mode for data size < %d",
-					__func__, HASH_DMA_ALIGN_SIZE);
+			pr_debug("%s: DMA mode, but direct to CPU mode for data size < %d\n",
+				 __func__, HASH_DMA_ALIGN_SIZE);
 		} else {
 			if (req->nbytes >= HASH_DMA_PERFORMANCE_MIN_SIZE &&
-					hash_dma_valid_data(req->src,
-						req->nbytes)) {
+			    hash_dma_valid_data(req->src, req->nbytes)) {
 				req_ctx->dma_mode = true;
 			} else {
 				req_ctx->dma_mode = false;
-				pr_debug(DEV_DBG_NAME " [%s] DMA mode, but use"
-						" CPU mode for datalength < %d"
-						" or non-aligned data, except "
-						"in last nent", __func__,
-						HASH_DMA_PERFORMANCE_MIN_SIZE);
+				pr_debug("%s: DMA mode, but use CPU mode for datalength < %d or non-aligned data, except in last nent\n",
+					 __func__,
+					 HASH_DMA_PERFORMANCE_MIN_SIZE);
 			}
 		}
 	}
@@ -614,9 +601,8 @@ static int hash_init(struct ahash_request *req)
  *			the HASH hardware.
  *
  */
-static void hash_processblock(
-		struct hash_device_data *device_data,
-		const u32 *message, int length)
+static void hash_processblock(struct hash_device_data *device_data,
+			      const u32 *message, int length)
 {
 	int len = length / HASH_BYTES_PER_WORD;
 	/*
@@ -641,7 +627,7 @@ static void hash_processblock(
  *
  */
 static void hash_messagepad(struct hash_device_data *device_data,
-		const u32 *message, u8 index_bytes)
+			    const u32 *message, u8 index_bytes)
 {
 	int nwords = 1;
 
@@ -666,15 +652,13 @@ static void hash_messagepad(struct hash_device_data *device_data,
 
 	/* num_of_bytes == 0 => NBLW <- 0 (32 bits valid in DATAIN) */
 	HASH_SET_NBLW(index_bytes * 8);
-	dev_dbg(device_data->dev, "[%s] DIN=0x%08x NBLW=%d", __func__,
-			readl_relaxed(&device_data->base->din),
-			(int)(readl_relaxed(&device_data->base->str) &
-				HASH_STR_NBLW_MASK));
+	dev_dbg(device_data->dev, "%s: DIN=0x%08x NBLW=%lu\n",
+		__func__, readl_relaxed(&device_data->base->din),
+		readl_relaxed(&device_data->base->str) & HASH_STR_NBLW_MASK);
 	HASH_SET_DCAL;
-	dev_dbg(device_data->dev, "[%s] after dcal -> DIN=0x%08x NBLW=%d",
-			__func__, readl_relaxed(&device_data->base->din),
-			(int)(readl_relaxed(&device_data->base->str) &
-				HASH_STR_NBLW_MASK));
+	dev_dbg(device_data->dev, "%s: after dcal -> DIN=0x%08x NBLW=%lu\n",
+		__func__, readl_relaxed(&device_data->base->din),
+		readl_relaxed(&device_data->base->str) & HASH_STR_NBLW_MASK);
 
 	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
 		cpu_relax();
@@ -704,7 +688,7 @@ static void hash_incrementlength(struct hash_req_ctx *ctx, u32 incr)
  * @config:		Pointer to a configuration structure.
  */
 int hash_setconfiguration(struct hash_device_data *device_data,
-		struct hash_config *config)
+			  struct hash_config *config)
 {
 	int ret = 0;
 
@@ -731,8 +715,8 @@ int hash_setconfiguration(struct hash_device_data *device_data,
 		break;
 
 	default:
-		dev_err(device_data->dev, "[%s] Incorrect algorithm.",
-				__func__);
+		dev_err(device_data->dev, "%s: Incorrect algorithm\n",
+			__func__);
 		return -EPERM;
 	}
 
@@ -744,23 +728,22 @@ int hash_setconfiguration(struct hash_device_data *device_data,
 		HASH_CLEAR_BITS(&device_data->base->cr,
 				HASH_CR_MODE_MASK);
 	else if (HASH_OPER_MODE_HMAC == config->oper_mode) {
-		HASH_SET_BITS(&device_data->base->cr,
-				HASH_CR_MODE_MASK);
+		HASH_SET_BITS(&device_data->base->cr, HASH_CR_MODE_MASK);
 		if (device_data->current_ctx->keylen > HASH_BLOCK_SIZE) {
 			/* Truncate key to blocksize */
-			dev_dbg(device_data->dev, "[%s] LKEY set", __func__);
+			dev_dbg(device_data->dev, "%s: LKEY set\n", __func__);
 			HASH_SET_BITS(&device_data->base->cr,
-					HASH_CR_LKEY_MASK);
+				      HASH_CR_LKEY_MASK);
 		} else {
-			dev_dbg(device_data->dev, "[%s] LKEY cleared",
-					__func__);
+			dev_dbg(device_data->dev, "%s: LKEY cleared\n",
+				__func__);
 			HASH_CLEAR_BITS(&device_data->base->cr,
 					HASH_CR_LKEY_MASK);
 		}
 	} else {	/* Wrong hash mode */
 		ret = -EPERM;
-		dev_err(device_data->dev, "[%s] HASH_INVALID_PARAMETER!",
-				__func__);
+		dev_err(device_data->dev, "%s: HASH_INVALID_PARAMETER!\n",
+			__func__);
 	}
 	return ret;
 }
@@ -793,8 +776,9 @@ void hash_begin(struct hash_device_data *device_data, struct hash_ctx *ctx)
 }
 
 static int hash_process_data(struct hash_device_data *device_data,
-		struct hash_ctx *ctx, struct hash_req_ctx *req_ctx,
-		int msg_length, u8 *data_buffer, u8 *buffer, u8 *index)
+			     struct hash_ctx *ctx, struct hash_req_ctx *req_ctx,
+			     int msg_length, u8 *data_buffer, u8 *buffer,
+			     u8 *index)
 {
 	int ret = 0;
 	u32 count;
@@ -809,24 +793,23 @@ static int hash_process_data(struct hash_device_data *device_data,
 			msg_length = 0;
 		} else {
 			if (req_ctx->updated) {
-
 				ret = hash_resume_state(device_data,
 						&device_data->state);
 				memmove(req_ctx->state.buffer,
-						device_data->state.buffer,
-						HASH_BLOCK_SIZE / sizeof(u32));
+					device_data->state.buffer,
+					HASH_BLOCK_SIZE / sizeof(u32));
 				if (ret) {
-					dev_err(device_data->dev, "[%s] "
-							"hash_resume_state()"
-							" failed!", __func__);
+					dev_err(device_data->dev,
+						"%s: hash_resume_state() failed!\n",
+						__func__);
 					goto out;
 				}
 			} else {
 				ret = init_hash_hw(device_data, ctx);
 				if (ret) {
-					dev_err(device_data->dev, "[%s] "
-							"init_hash_hw()"
-							" failed!", __func__);
+					dev_err(device_data->dev,
+						"%s: init_hash_hw() failed!\n",
+						__func__);
 					goto out;
 				}
 				req_ctx->updated = 1;
@@ -838,22 +821,21 @@ static int hash_process_data(struct hash_device_data *device_data,
 			 * HW peripheral, otherwise we first copy data
 			 * to a local buffer
 			 */
-			if ((0 == (((u32)data_buffer) % 4))
-					&& (0 == *index))
+			if ((0 == (((u32)data_buffer) % 4)) &&
+			    (0 == *index))
 				hash_processblock(device_data,
-						(const u32 *)
-						data_buffer, HASH_BLOCK_SIZE);
+						  (const u32 *)data_buffer,
+						  HASH_BLOCK_SIZE);
 			else {
-				for (count = 0; count <
-						(u32)(HASH_BLOCK_SIZE -
-							*index);
-						count++) {
+				for (count = 0;
+				     count < (u32)(HASH_BLOCK_SIZE - *index);
+				     count++) {
 					buffer[*index + count] =
 						*(data_buffer + count);
 				}
 				hash_processblock(device_data,
-						(const u32 *)buffer,
-						HASH_BLOCK_SIZE);
+						  (const u32 *)buffer,
+						  HASH_BLOCK_SIZE);
 			}
 			hash_incrementlength(req_ctx, HASH_BLOCK_SIZE);
 			data_buffer += (HASH_BLOCK_SIZE - *index);
@@ -865,12 +847,11 @@ static int hash_process_data(struct hash_device_data *device_data,
 					&device_data->state);
 
 			memmove(device_data->state.buffer,
-					req_ctx->state.buffer,
-					HASH_BLOCK_SIZE / sizeof(u32));
+				req_ctx->state.buffer,
+				HASH_BLOCK_SIZE / sizeof(u32));
 			if (ret) {
-				dev_err(device_data->dev, "[%s] "
-						"hash_save_state()"
-						" failed!", __func__);
+				dev_err(device_data->dev, "%s: hash_save_state() failed!\n",
+					__func__);
 				goto out;
 			}
 		}
@@ -898,25 +879,24 @@ static int hash_dma_final(struct ahash_request *req)
 	if (ret)
 		return ret;
 
-	dev_dbg(device_data->dev, "[%s] (ctx=0x%x)!", __func__, (u32) ctx);
+	dev_dbg(device_data->dev, "%s: (ctx=0x%x)!\n", __func__, (u32) ctx);
 
 	if (req_ctx->updated) {
 		ret = hash_resume_state(device_data, &device_data->state);
 
 		if (ret) {
-			dev_err(device_data->dev, "[%s] hash_resume_state() "
-					"failed!", __func__);
+			dev_err(device_data->dev, "%s: hash_resume_state() failed!\n",
+				__func__);
 			goto out;
 		}
-
 	}
 
 	if (!req_ctx->updated) {
 		ret = hash_setconfiguration(device_data, &ctx->config);
 		if (ret) {
-			dev_err(device_data->dev, "[%s] "
-					"hash_setconfiguration() failed!",
-					__func__);
+			dev_err(device_data->dev,
+				"%s: hash_setconfiguration() failed!\n",
+				__func__);
 			goto out;
 		}
 
@@ -926,9 +906,9 @@ static int hash_dma_final(struct ahash_request *req)
 					HASH_CR_DMAE_MASK);
 		} else {
 			HASH_SET_BITS(&device_data->base->cr,
-					HASH_CR_DMAE_MASK);
+				      HASH_CR_DMAE_MASK);
 			HASH_SET_BITS(&device_data->base->cr,
-					HASH_CR_PRIVN_MASK);
+				      HASH_CR_PRIVN_MASK);
 		}
 
 		HASH_INITIALIZE;
@@ -944,16 +924,16 @@ static int hash_dma_final(struct ahash_request *req)
 	/* Store the nents in the dma struct. */
 	ctx->device->dma.nents = hash_get_nents(req->src, req->nbytes, NULL);
 	if (!ctx->device->dma.nents) {
-		dev_err(device_data->dev, "[%s] "
-				"ctx->device->dma.nents = 0", __func__);
+		dev_err(device_data->dev, "%s: ctx->device->dma.nents = 0\n",
+			__func__);
 		ret = ctx->device->dma.nents;
 		goto out;
 	}
 
 	bytes_written = hash_dma_write(ctx, req->src, req->nbytes);
 	if (bytes_written != req->nbytes) {
-		dev_err(device_data->dev, "[%s] "
-				"hash_dma_write() failed!", __func__);
+		dev_err(device_data->dev, "%s: hash_dma_write() failed!\n",
+			__func__);
 		ret = bytes_written;
 		goto out;
 	}
@@ -968,8 +948,8 @@ static int hash_dma_final(struct ahash_request *req)
 		unsigned int keylen = ctx->keylen;
 		u8 *key = ctx->key;
 
-		dev_dbg(device_data->dev, "[%s] keylen: %d", __func__,
-				ctx->keylen);
+		dev_dbg(device_data->dev, "%s: keylen: %d\n",
+			__func__, ctx->keylen);
 		hash_hw_write_key(device_data, key, keylen);
 	}
 
@@ -1004,14 +984,14 @@ static int hash_hw_final(struct ahash_request *req)
 	if (ret)
 		return ret;
 
-	dev_dbg(device_data->dev, "[%s] (ctx=0x%x)!", __func__, (u32) ctx);
+	dev_dbg(device_data->dev, "%s: (ctx=0x%x)!\n", __func__, (u32) ctx);
 
 	if (req_ctx->updated) {
 		ret = hash_resume_state(device_data, &device_data->state);
 
 		if (ret) {
-			dev_err(device_data->dev, "[%s] hash_resume_state() "
-					"failed!", __func__);
+			dev_err(device_data->dev,
+				"%s: hash_resume_state() failed!\n", __func__);
 			goto out;
 		}
 	} else if (req->nbytes == 0 && ctx->keylen == 0) {
@@ -1025,31 +1005,33 @@ static int hash_hw_final(struct ahash_request *req)
 		ret = get_empty_message_digest(device_data, &zero_hash[0],
 				&zero_hash_size, &zero_digest);
 		if (!ret && likely(zero_hash_size == ctx->digestsize) &&
-				zero_digest) {
+		    zero_digest) {
 			memcpy(req->result, &zero_hash[0], ctx->digestsize);
 			goto out;
 		} else if (!ret && !zero_digest) {
-			dev_dbg(device_data->dev, "[%s] HMAC zero msg with "
-					"key, continue...", __func__);
+			dev_dbg(device_data->dev,
+				"%s: HMAC zero msg with key, continue...\n",
+				__func__);
 		} else {
-			dev_err(device_data->dev, "[%s] ret=%d, or wrong "
-					"digest size? %s", __func__, ret,
-					(zero_hash_size == ctx->digestsize) ?
-					"true" : "false");
+			dev_err(device_data->dev,
+				"%s: ret=%d, or wrong digest size? %s\n",
+				__func__, ret,
+				zero_hash_size == ctx->digestsize ?
+				"true" : "false");
 			/* Return error */
 			goto out;
 		}
 	} else if (req->nbytes == 0 && ctx->keylen > 0) {
-		dev_err(device_data->dev, "[%s] Empty message with "
-				"keylength > 0, NOT supported.", __func__);
+		dev_err(device_data->dev, "%s: Empty message with keylength > 0, NOT supported\n",
+			__func__);
 		goto out;
 	}
 
 	if (!req_ctx->updated) {
 		ret = init_hash_hw(device_data, ctx);
 		if (ret) {
-			dev_err(device_data->dev, "[%s] init_hash_hw() "
-					"failed!", __func__);
+			dev_err(device_data->dev,
+				"%s: init_hash_hw() failed!\n", __func__);
 			goto out;
 		}
 	}
@@ -1067,8 +1049,8 @@ static int hash_hw_final(struct ahash_request *req)
 		unsigned int keylen = ctx->keylen;
 		u8 *key = ctx->key;
 
-		dev_dbg(device_data->dev, "[%s] keylen: %d", __func__,
-				ctx->keylen);
+		dev_dbg(device_data->dev, "%s: keylen: %d\n",
+			__func__, ctx->keylen);
 		hash_hw_write_key(device_data, key, keylen);
 	}
 
@@ -1115,10 +1097,8 @@ int hash_hw_update(struct ahash_request *req)
 	/* Check if ctx->state.length + msg_length
 	   overflows */
 	if (msg_length > (req_ctx->state.length.low_word + msg_length) &&
-			HASH_HIGH_WORD_MAX_VAL ==
-			req_ctx->state.length.high_word) {
-		pr_err(DEV_DBG_NAME " [%s] HASH_MSG_LENGTH_OVERFLOW!",
-				__func__);
+	    HASH_HIGH_WORD_MAX_VAL == req_ctx->state.length.high_word) {
+		pr_err("%s: HASH_MSG_LENGTH_OVERFLOW!\n", __func__);
 		return -EPERM;
 	}
 
@@ -1133,8 +1113,8 @@ int hash_hw_update(struct ahash_request *req)
 				data_buffer, buffer, &index);
 
 		if (ret) {
-			dev_err(device_data->dev, "[%s] hash_internal_hw_"
-					"update() failed!", __func__);
+			dev_err(device_data->dev, "%s: hash_internal_hw_update() failed!\n",
+				__func__);
 			goto out;
 		}
 
@@ -1142,9 +1122,8 @@ int hash_hw_update(struct ahash_request *req)
 	}
 
 	req_ctx->state.index = index;
-	dev_dbg(device_data->dev, "[%s] indata length=%d, bin=%d))",
-			__func__, req_ctx->state.index,
-			req_ctx->state.bit_index);
+	dev_dbg(device_data->dev, "%s: indata length=%d, bin=%d\n",
+		__func__, req_ctx->state.index, req_ctx->state.bit_index);
 
 out:
 	release_hash_device(device_data);
@@ -1158,23 +1137,23 @@ out:
  * @device_state:	The state to be restored in the hash hardware
  */
 int hash_resume_state(struct hash_device_data *device_data,
-		const struct hash_state *device_state)
+		      const struct hash_state *device_state)
 {
 	u32 temp_cr;
 	s32 count;
 	int hash_mode = HASH_OPER_MODE_HASH;
 
 	if (NULL == device_state) {
-		dev_err(device_data->dev, "[%s] HASH_INVALID_PARAMETER!",
-				__func__);
+		dev_err(device_data->dev, "%s: HASH_INVALID_PARAMETER!\n",
+			__func__);
 		return -EPERM;
 	}
 
 	/* Check correctness of index and length members */
-	if (device_state->index > HASH_BLOCK_SIZE
-	    || (device_state->length.low_word % HASH_BLOCK_SIZE) != 0) {
-		dev_err(device_data->dev, "[%s] HASH_INVALID_PARAMETER!",
-				__func__);
+	if (device_state->index > HASH_BLOCK_SIZE ||
+	    (device_state->length.low_word % HASH_BLOCK_SIZE) != 0) {
+		dev_err(device_data->dev, "%s: HASH_INVALID_PARAMETER!\n",
+			__func__);
 		return -EPERM;
 	}
 
@@ -1198,7 +1177,7 @@ int hash_resume_state(struct hash_device_data *device_data,
 			break;
 
 		writel_relaxed(device_state->csr[count],
-				&device_data->base->csrx[count]);
+			       &device_data->base->csrx[count]);
 	}
 
 	writel_relaxed(device_state->csfull, &device_data->base->csfull);
@@ -1216,15 +1195,15 @@ int hash_resume_state(struct hash_device_data *device_data,
  * @device_state:	The strucure where the hardware state should be saved.
  */
 int hash_save_state(struct hash_device_data *device_data,
-		struct hash_state *device_state)
+		    struct hash_state *device_state)
 {
 	u32 temp_cr;
 	u32 count;
 	int hash_mode = HASH_OPER_MODE_HASH;
 
 	if (NULL == device_state) {
-		dev_err(device_data->dev, "[%s] HASH_INVALID_PARAMETER!",
-				__func__);
+		dev_err(device_data->dev, "%s: HASH_INVALID_PARAMETER!\n",
+			__func__);
 		return -ENOTSUPP;
 	}
 
@@ -1270,20 +1249,18 @@ int hash_save_state(struct hash_device_data *device_data,
 int hash_check_hw(struct hash_device_data *device_data)
 {
 	/* Checking Peripheral Ids  */
-	if (HASH_P_ID0 == readl_relaxed(&device_data->base->periphid0)
-		&& HASH_P_ID1 == readl_relaxed(&device_data->base->periphid1)
-		&& HASH_P_ID2 == readl_relaxed(&device_data->base->periphid2)
-		&& HASH_P_ID3 == readl_relaxed(&device_data->base->periphid3)
-		&& HASH_CELL_ID0 == readl_relaxed(&device_data->base->cellid0)
-		&& HASH_CELL_ID1 == readl_relaxed(&device_data->base->cellid1)
-		&& HASH_CELL_ID2 == readl_relaxed(&device_data->base->cellid2)
-		&& HASH_CELL_ID3 == readl_relaxed(&device_data->base->cellid3)
-	   ) {
+	if (HASH_P_ID0 == readl_relaxed(&device_data->base->periphid0) &&
+	    HASH_P_ID1 == readl_relaxed(&device_data->base->periphid1) &&
+	    HASH_P_ID2 == readl_relaxed(&device_data->base->periphid2) &&
+	    HASH_P_ID3 == readl_relaxed(&device_data->base->periphid3) &&
+	    HASH_CELL_ID0 == readl_relaxed(&device_data->base->cellid0) &&
+	    HASH_CELL_ID1 == readl_relaxed(&device_data->base->cellid1) &&
+	    HASH_CELL_ID2 == readl_relaxed(&device_data->base->cellid2) &&
+	    HASH_CELL_ID3 == readl_relaxed(&device_data->base->cellid3)) {
 		return 0;
 	}
 
-	dev_err(device_data->dev, "[%s] HASH_UNSUPPORTED_HW!",
-			__func__);
+	dev_err(device_data->dev, "%s: HASH_UNSUPPORTED_HW!\n", __func__);
 	return -ENOTSUPP;
 }
 
@@ -1294,14 +1271,14 @@ int hash_check_hw(struct hash_device_data *device_data)
  * @algorithm:		The algorithm in use.
  */
 void hash_get_digest(struct hash_device_data *device_data,
-		u8 *digest, int algorithm)
+		     u8 *digest, int algorithm)
 {
 	u32 temp_hx_val, count;
 	int loop_ctr;
 
 	if (algorithm != HASH_ALGO_SHA1 && algorithm != HASH_ALGO_SHA256) {
-		dev_err(device_data->dev, "[%s] Incorrect algorithm %d",
-				__func__, algorithm);
+		dev_err(device_data->dev, "%s: Incorrect algorithm %d\n",
+			__func__, algorithm);
 		return;
 	}
 
@@ -1310,8 +1287,8 @@ void hash_get_digest(struct hash_device_data *device_data,
 	else
 		loop_ctr = SHA256_DIGEST_SIZE / sizeof(u32);
 
-	dev_dbg(device_data->dev, "[%s] digest array:(0x%x)",
-			__func__, (u32) digest);
+	dev_dbg(device_data->dev, "%s: digest array:(0x%x)\n",
+		__func__, (u32) digest);
 
 	/* Copy result into digest array */
 	for (count = 0; count < loop_ctr; count++) {
@@ -1337,8 +1314,7 @@ static int ahash_update(struct ahash_request *req)
 	/* Skip update for DMA, all data will be passed to DMA in final */
 
 	if (ret) {
-		pr_err(DEV_DBG_NAME " [%s] hash_hw_update() failed!",
-				__func__);
+		pr_err("%s: hash_hw_update() failed!\n", __func__);
 	}
 
 	return ret;
@@ -1353,7 +1329,7 @@ static int ahash_final(struct ahash_request *req)
 	int ret = 0;
 	struct hash_req_ctx *req_ctx = ahash_request_ctx(req);
 
-	pr_debug(DEV_DBG_NAME " [%s] data size: %d", __func__, req->nbytes);
+	pr_debug("%s: data size: %d\n", __func__, req->nbytes);
 
 	if ((hash_mode == HASH_MODE_DMA) && req_ctx->dma_mode)
 		ret = hash_dma_final(req);
@@ -1361,15 +1337,14 @@ static int ahash_final(struct ahash_request *req)
 		ret = hash_hw_final(req);
 
 	if (ret) {
-		pr_err(DEV_DBG_NAME " [%s] hash_hw/dma_final() failed",
-				__func__);
+		pr_err("%s: hash_hw/dma_final() failed\n", __func__);
 	}
 
 	return ret;
 }
 
 static int hash_setkey(struct crypto_ahash *tfm,
-		const u8 *key, unsigned int keylen, int alg)
+		       const u8 *key, unsigned int keylen, int alg)
 {
 	int ret = 0;
 	struct hash_ctx *ctx = crypto_ahash_ctx(tfm);
@@ -1379,8 +1354,8 @@ static int hash_setkey(struct crypto_ahash *tfm,
 	 */
 	ctx->key = kmemdup(key, keylen, GFP_KERNEL);
 	if (!ctx->key) {
-		pr_err(DEV_DBG_NAME " [%s] Failed to allocate ctx->key "
-		       "for %d\n", __func__, alg);
+		pr_err("%s: Failed to allocate ctx->key for %d\n",
+		       __func__, alg);
 		return -ENOMEM;
 	}
 	ctx->keylen = keylen;
@@ -1501,13 +1476,13 @@ out:
 }
 
 static int hmac_sha1_setkey(struct crypto_ahash *tfm,
-		const u8 *key, unsigned int keylen)
+			    const u8 *key, unsigned int keylen)
 {
 	return hash_setkey(tfm, key, keylen, HASH_ALGO_SHA1);
 }
 
 static int hmac_sha256_setkey(struct crypto_ahash *tfm,
-		const u8 *key, unsigned int keylen)
+			      const u8 *key, unsigned int keylen)
 {
 	return hash_setkey(tfm, key, keylen, HASH_ALGO_SHA256);
 }
@@ -1528,7 +1503,7 @@ static int hash_cra_init(struct crypto_tfm *tfm)
 			hash);
 
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-			sizeof(struct hash_req_ctx));
+				 sizeof(struct hash_req_ctx));
 
 	ctx->config.data_format = HASH_DATA_8_BITS;
 	ctx->config.algorithm = hash_alg->conf.algorithm;
@@ -1541,98 +1516,97 @@ static int hash_cra_init(struct crypto_tfm *tfm)
 
 static struct hash_algo_template hash_algs[] = {
 	{
-			.conf.algorithm	= HASH_ALGO_SHA1,
-			.conf.oper_mode	= HASH_OPER_MODE_HASH,
-			.hash = {
-				.init = hash_init,
-				.update = ahash_update,
-				.final = ahash_final,
-				.digest = ahash_sha1_digest,
-				.halg.digestsize = SHA1_DIGEST_SIZE,
-				.halg.statesize = sizeof(struct hash_ctx),
-				.halg.base = {
-					.cra_name = "sha1",
-					.cra_driver_name = "sha1-ux500",
-					.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-							CRYPTO_ALG_ASYNC,
-					.cra_blocksize = SHA1_BLOCK_SIZE,
-					.cra_ctxsize = sizeof(struct hash_ctx),
-					.cra_init = hash_cra_init,
-					.cra_module = THIS_MODULE,
+		.conf.algorithm = HASH_ALGO_SHA1,
+		.conf.oper_mode = HASH_OPER_MODE_HASH,
+		.hash = {
+			.init = hash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.digest = ahash_sha1_digest,
+			.halg.digestsize = SHA1_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct hash_ctx),
+			.halg.base = {
+				.cra_name = "sha1",
+				.cra_driver_name = "sha1-ux500",
+				.cra_flags = (CRYPTO_ALG_TYPE_AHASH |
+					      CRYPTO_ALG_ASYNC),
+				.cra_blocksize = SHA1_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct hash_ctx),
+				.cra_init = hash_cra_init,
+				.cra_module = THIS_MODULE,
 			}
 		}
 	},
 	{
-			.conf.algorithm		= HASH_ALGO_SHA256,
-			.conf.oper_mode		= HASH_OPER_MODE_HASH,
-			.hash = {
-				.init = hash_init,
-				.update	= ahash_update,
-				.final = ahash_final,
-				.digest = ahash_sha256_digest,
-				.halg.digestsize = SHA256_DIGEST_SIZE,
-				.halg.statesize = sizeof(struct hash_ctx),
-				.halg.base = {
-					.cra_name = "sha256",
-					.cra_driver_name = "sha256-ux500",
-					.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-							CRYPTO_ALG_ASYNC,
-					.cra_blocksize = SHA256_BLOCK_SIZE,
-					.cra_ctxsize = sizeof(struct hash_ctx),
-					.cra_type = &crypto_ahash_type,
-					.cra_init = hash_cra_init,
-					.cra_module = THIS_MODULE,
-				}
+		.conf.algorithm	= HASH_ALGO_SHA256,
+		.conf.oper_mode	= HASH_OPER_MODE_HASH,
+		.hash = {
+			.init = hash_init,
+			.update	= ahash_update,
+			.final = ahash_final,
+			.digest = ahash_sha256_digest,
+			.halg.digestsize = SHA256_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct hash_ctx),
+			.halg.base = {
+				.cra_name = "sha256",
+				.cra_driver_name = "sha256-ux500",
+				.cra_flags = (CRYPTO_ALG_TYPE_AHASH |
+					      CRYPTO_ALG_ASYNC),
+				.cra_blocksize = SHA256_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct hash_ctx),
+				.cra_type = &crypto_ahash_type,
+				.cra_init = hash_cra_init,
+				.cra_module = THIS_MODULE,
 			}
-
+		}
 	},
 	{
-			.conf.algorithm		= HASH_ALGO_SHA1,
-			.conf.oper_mode		= HASH_OPER_MODE_HMAC,
+		.conf.algorithm = HASH_ALGO_SHA1,
+		.conf.oper_mode = HASH_OPER_MODE_HMAC,
 			.hash = {
-				.init = hash_init,
-				.update = ahash_update,
-				.final = ahash_final,
-				.digest = hmac_sha1_digest,
-				.setkey = hmac_sha1_setkey,
-				.halg.digestsize = SHA1_DIGEST_SIZE,
-				.halg.statesize = sizeof(struct hash_ctx),
-				.halg.base = {
-					.cra_name = "hmac(sha1)",
-					.cra_driver_name = "hmac-sha1-ux500",
-					.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-							CRYPTO_ALG_ASYNC,
-					.cra_blocksize = SHA1_BLOCK_SIZE,
-					.cra_ctxsize = sizeof(struct hash_ctx),
-					.cra_type = &crypto_ahash_type,
-					.cra_init = hash_cra_init,
-					.cra_module = THIS_MODULE,
-				}
+			.init = hash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.digest = hmac_sha1_digest,
+			.setkey = hmac_sha1_setkey,
+			.halg.digestsize = SHA1_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct hash_ctx),
+			.halg.base = {
+				.cra_name = "hmac(sha1)",
+				.cra_driver_name = "hmac-sha1-ux500",
+				.cra_flags = (CRYPTO_ALG_TYPE_AHASH |
+					      CRYPTO_ALG_ASYNC),
+				.cra_blocksize = SHA1_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct hash_ctx),
+				.cra_type = &crypto_ahash_type,
+				.cra_init = hash_cra_init,
+				.cra_module = THIS_MODULE,
 			}
+		}
 	},
 	{
-			.conf.algorithm		= HASH_ALGO_SHA256,
-			.conf.oper_mode		= HASH_OPER_MODE_HMAC,
-			.hash = {
-				.init = hash_init,
-				.update = ahash_update,
-				.final = ahash_final,
-				.digest = hmac_sha256_digest,
-				.setkey = hmac_sha256_setkey,
-				.halg.digestsize = SHA256_DIGEST_SIZE,
-				.halg.statesize = sizeof(struct hash_ctx),
-				.halg.base = {
-					.cra_name = "hmac(sha256)",
-					.cra_driver_name = "hmac-sha256-ux500",
-					.cra_flags = CRYPTO_ALG_TYPE_AHASH |
-							CRYPTO_ALG_ASYNC,
-					.cra_blocksize = SHA256_BLOCK_SIZE,
-					.cra_ctxsize = sizeof(struct hash_ctx),
-					.cra_type = &crypto_ahash_type,
-					.cra_init = hash_cra_init,
-					.cra_module = THIS_MODULE,
-				}
+		.conf.algorithm = HASH_ALGO_SHA256,
+		.conf.oper_mode = HASH_OPER_MODE_HMAC,
+		.hash = {
+			.init = hash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.digest = hmac_sha256_digest,
+			.setkey = hmac_sha256_setkey,
+			.halg.digestsize = SHA256_DIGEST_SIZE,
+			.halg.statesize = sizeof(struct hash_ctx),
+			.halg.base = {
+				.cra_name = "hmac(sha256)",
+				.cra_driver_name = "hmac-sha256-ux500",
+				.cra_flags = (CRYPTO_ALG_TYPE_AHASH |
+					      CRYPTO_ALG_ASYNC),
+				.cra_blocksize = SHA256_BLOCK_SIZE,
+				.cra_ctxsize = sizeof(struct hash_ctx),
+				.cra_type = &crypto_ahash_type,
+				.cra_init = hash_cra_init,
+				.cra_module = THIS_MODULE,
 			}
+		}
 	}
 };
 
@@ -1649,7 +1623,7 @@ static int ahash_algs_register_all(struct hash_device_data *device_data)
 		ret = crypto_register_ahash(&hash_algs[i].hash);
 		if (ret) {
 			count = i;
-			dev_err(device_data->dev, "[%s] alg registration failed",
+			dev_err(device_data->dev, "%s: alg registration failed\n",
 				hash_algs[i].hash.halg.base.cra_driver_name);
 			goto unreg;
 		}
@@ -1683,9 +1657,8 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	struct hash_device_data *device_data;
 	struct device		*dev = &pdev->dev;
 
-	device_data = kzalloc(sizeof(struct hash_device_data), GFP_ATOMIC);
+	device_data = kzalloc(sizeof(*device_data), GFP_ATOMIC);
 	if (!device_data) {
-		dev_dbg(dev, "[%s] kzalloc() failed!", __func__);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1695,14 +1668,14 @@ static int ux500_hash_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
-		dev_dbg(dev, "[%s] platform_get_resource() failed!", __func__);
+		dev_dbg(dev, "%s: platform_get_resource() failed!\n", __func__);
 		ret = -ENODEV;
 		goto out_kfree;
 	}
 
 	res = request_mem_region(res->start, resource_size(res), pdev->name);
 	if (res == NULL) {
-		dev_dbg(dev, "[%s] request_mem_region() failed!", __func__);
+		dev_dbg(dev, "%s: request_mem_region() failed!\n", __func__);
 		ret = -EBUSY;
 		goto out_kfree;
 	}
@@ -1710,8 +1683,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	device_data->phybase = res->start;
 	device_data->base = ioremap(res->start, resource_size(res));
 	if (!device_data->base) {
-		dev_err(dev, "[%s] ioremap() failed!",
-				__func__);
+		dev_err(dev, "%s: ioremap() failed!\n", __func__);
 		ret = -ENOMEM;
 		goto out_free_mem;
 	}
@@ -1721,7 +1693,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	/* Enable power for HASH1 hardware block */
 	device_data->regulator = regulator_get(dev, "v-ape");
 	if (IS_ERR(device_data->regulator)) {
-		dev_err(dev, "[%s] regulator_get() failed!", __func__);
+		dev_err(dev, "%s: regulator_get() failed!\n", __func__);
 		ret = PTR_ERR(device_data->regulator);
 		device_data->regulator = NULL;
 		goto out_unmap;
@@ -1730,27 +1702,27 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	/* Enable the clock for HASH1 hardware block */
 	device_data->clk = clk_get(dev, NULL);
 	if (IS_ERR(device_data->clk)) {
-		dev_err(dev, "[%s] clk_get() failed!", __func__);
+		dev_err(dev, "%s: clk_get() failed!\n", __func__);
 		ret = PTR_ERR(device_data->clk);
 		goto out_regulator;
 	}
 
 	ret = clk_prepare(device_data->clk);
 	if (ret) {
-		dev_err(dev, "[%s] clk_prepare() failed!", __func__);
+		dev_err(dev, "%s: clk_prepare() failed!\n", __func__);
 		goto out_clk;
 	}
 
 	/* Enable device power (and clock) */
 	ret = hash_enable_power(device_data, false);
 	if (ret) {
-		dev_err(dev, "[%s]: hash_enable_power() failed!", __func__);
+		dev_err(dev, "%s: hash_enable_power() failed!\n", __func__);
 		goto out_clk_unprepare;
 	}
 
 	ret = hash_check_hw(device_data);
 	if (ret) {
-		dev_err(dev, "[%s] hash_check_hw() failed!", __func__);
+		dev_err(dev, "%s: hash_check_hw() failed!\n", __func__);
 		goto out_power;
 	}
 
@@ -1766,8 +1738,8 @@ static int ux500_hash_probe(struct platform_device *pdev)
 
 	ret = ahash_algs_register_all(device_data);
 	if (ret) {
-		dev_err(dev, "[%s] ahash_algs_register_all() "
-				"failed!", __func__);
+		dev_err(dev, "%s: ahash_algs_register_all() failed!\n",
+			__func__);
 		goto out_power;
 	}
 
@@ -1810,8 +1782,7 @@ static int ux500_hash_remove(struct platform_device *pdev)
 
 	device_data = platform_get_drvdata(pdev);
 	if (!device_data) {
-		dev_err(dev, "[%s]: platform_get_drvdata() failed!",
-			__func__);
+		dev_err(dev, "%s: platform_get_drvdata() failed!\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -1841,7 +1812,7 @@ static int ux500_hash_remove(struct platform_device *pdev)
 		ahash_algs_unregister_all(device_data);
 
 	if (hash_disable_power(device_data, false))
-		dev_err(dev, "[%s]: hash_disable_power() failed",
+		dev_err(dev, "%s: hash_disable_power() failed\n",
 			__func__);
 
 	clk_unprepare(device_data->clk);
@@ -1870,8 +1841,8 @@ static void ux500_hash_shutdown(struct platform_device *pdev)
 
 	device_data = platform_get_drvdata(pdev);
 	if (!device_data) {
-		dev_err(&pdev->dev, "[%s] platform_get_drvdata() failed!",
-				__func__);
+		dev_err(&pdev->dev, "%s: platform_get_drvdata() failed!\n",
+			__func__);
 		return;
 	}
 
@@ -1880,8 +1851,8 @@ static void ux500_hash_shutdown(struct platform_device *pdev)
 	/* current_ctx allocates a device, NULL = unallocated */
 	if (!device_data->current_ctx) {
 		if (down_trylock(&driver_data.device_allocation))
-			dev_dbg(&pdev->dev, "[%s]: Cryp still in use!"
-				"Shutting down anyway...", __func__);
+			dev_dbg(&pdev->dev, "%s: Cryp still in use! Shutting down anyway...\n",
+				__func__);
 		/**
 		 * (Allocate the device)
 		 * Need to set this to non-null (dummy) value,
@@ -1906,8 +1877,8 @@ static void ux500_hash_shutdown(struct platform_device *pdev)
 		release_mem_region(res->start, resource_size(res));
 
 	if (hash_disable_power(device_data, false))
-		dev_err(&pdev->dev, "[%s] hash_disable_power() failed",
-				__func__);
+		dev_err(&pdev->dev, "%s: hash_disable_power() failed\n",
+			__func__);
 }
 
 /**
@@ -1922,7 +1893,7 @@ static int ux500_hash_suspend(struct device *dev)
 
 	device_data = dev_get_drvdata(dev);
 	if (!device_data) {
-		dev_err(dev, "[%s] platform_get_drvdata() failed!", __func__);
+		dev_err(dev, "%s: platform_get_drvdata() failed!\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -1933,15 +1904,16 @@ static int ux500_hash_suspend(struct device *dev)
 
 	if (device_data->current_ctx == ++temp_ctx) {
 		if (down_interruptible(&driver_data.device_allocation))
-			dev_dbg(dev, "[%s]: down_interruptible() failed",
+			dev_dbg(dev, "%s: down_interruptible() failed\n",
 				__func__);
 		ret = hash_disable_power(device_data, false);
 
-	} else
+	} else {
 		ret = hash_disable_power(device_data, true);
+	}
 
 	if (ret)
-		dev_err(dev, "[%s]: hash_disable_power()", __func__);
+		dev_err(dev, "%s: hash_disable_power()\n", __func__);
 
 	return ret;
 }
@@ -1958,7 +1930,7 @@ static int ux500_hash_resume(struct device *dev)
 
 	device_data = dev_get_drvdata(dev);
 	if (!device_data) {
-		dev_err(dev, "[%s] platform_get_drvdata() failed!", __func__);
+		dev_err(dev, "%s: platform_get_drvdata() failed!\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -1973,7 +1945,7 @@ static int ux500_hash_resume(struct device *dev)
 		ret = hash_enable_power(device_data, true);
 
 	if (ret)
-		dev_err(dev, "[%s]: hash_enable_power() failed!", __func__);
+		dev_err(dev, "%s: hash_enable_power() failed!\n", __func__);
 
 	return ret;
 }
@@ -1981,8 +1953,8 @@ static int ux500_hash_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(ux500_hash_pm, ux500_hash_suspend, ux500_hash_resume);
 
 static const struct of_device_id ux500_hash_match[] = {
-        { .compatible = "stericsson,ux500-hash" },
-        { },
+	{ .compatible = "stericsson,ux500-hash" },
+	{ },
 };
 
 static struct platform_driver hash_driver = {


