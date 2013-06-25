Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3FYIzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:55:39 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56560 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3FYIzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:55:32 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 1/6] crypto: ux500/hash: use readl on iomem addresses
Date: Tue, 25 Jun 2013 10:54:44 +0200
Message-Id: <1372150489-25594-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
References: <1372150489-25594-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always use readl when reading memory mapped registers.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/crypto/ux500/hash/hash_core.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index f89fe8a..154f437 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -473,12 +473,12 @@ static void hash_hw_write_key(struct hash_device_data *device_data,
 		HASH_SET_DIN(&word, nwords);
 	}
 
-	while (device_data->base->str & HASH_STR_DCAL_MASK)
+	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
 		cpu_relax();
 
 	HASH_SET_DCAL;
 
-	while (device_data->base->str & HASH_STR_DCAL_MASK)
+	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
 		cpu_relax();
 }
 
@@ -661,7 +661,7 @@ static void hash_messagepad(struct hash_device_data *device_data,
 	if (index_bytes)
 		HASH_SET_DIN(message, nwords);
 
-	while (device_data->base->str & HASH_STR_DCAL_MASK)
+	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
 		cpu_relax();
 
 	/* num_of_bytes == 0 => NBLW <- 0 (32 bits valid in DATAIN) */
@@ -676,7 +676,7 @@ static void hash_messagepad(struct hash_device_data *device_data,
 			(int)(readl_relaxed(&device_data->base->str) &
 				HASH_STR_NBLW_MASK));
 
-	while (device_data->base->str & HASH_STR_DCAL_MASK)
+	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
 		cpu_relax();
 }
 
@@ -776,7 +776,7 @@ void hash_begin(struct hash_device_data *device_data, struct hash_ctx *ctx)
 	/* HW and SW initializations */
 	/* Note: there is no need to initialize buffer and digest members */
 
-	while (device_data->base->str & HASH_STR_DCAL_MASK)
+	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
 		cpu_relax();
 
 	/*
@@ -962,7 +962,7 @@ static int hash_dma_final(struct ahash_request *req)
 	wait_for_completion(&ctx->device->dma.complete);
 	hash_dma_done(ctx);
 
-	while (device_data->base->str & HASH_STR_DCAL_MASK)
+	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
 		cpu_relax();
 
 	if (ctx->config.oper_mode == HASH_OPER_MODE_HMAC && ctx->key) {
@@ -1060,7 +1060,7 @@ int hash_hw_final(struct ahash_request *req)
 				req_ctx->state.index);
 	} else {
 		HASH_SET_DCAL;
-		while (device_data->base->str & HASH_STR_DCAL_MASK)
+		while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
 			cpu_relax();
 	}
 
@@ -1189,7 +1189,7 @@ int hash_resume_state(struct hash_device_data *device_data,
 	temp_cr = device_state->temp_cr;
 	writel_relaxed(temp_cr & HASH_CR_RESUME_MASK, &device_data->base->cr);
 
-	if (device_data->base->cr & HASH_CR_MODE_MASK)
+	if (readl(&device_data->base->cr) & HASH_CR_MODE_MASK)
 		hash_mode = HASH_OPER_MODE_HMAC;
 	else
 		hash_mode = HASH_OPER_MODE_HASH;
@@ -1233,7 +1233,7 @@ int hash_save_state(struct hash_device_data *device_data,
 	 * actually makes sure that there isn't any ongoing calculation in the
 	 * hardware.
 	 */
-	while (device_data->base->str & HASH_STR_DCAL_MASK)
+	while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
 		cpu_relax();
 
 	temp_cr = readl_relaxed(&device_data->base->cr);
@@ -1242,7 +1242,7 @@ int hash_save_state(struct hash_device_data *device_data,
 
 	device_state->din_reg = readl_relaxed(&device_data->base->din);
 
-	if (device_data->base->cr & HASH_CR_MODE_MASK)
+	if (readl(&device_data->base->cr) & HASH_CR_MODE_MASK)
 		hash_mode = HASH_OPER_MODE_HMAC;
 	else
 		hash_mode = HASH_OPER_MODE_HASH;
-- 
1.8.2

