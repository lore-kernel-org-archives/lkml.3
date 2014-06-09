Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbaFIK73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:59:29 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60685 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbaFIK7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:59:22 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 1/4] crypto: Add Allwinner Security System crypto accelerator
Date: Mon,  9 Jun 2014 12:59:08 +0200
Message-Id: <1402311551-19564-2-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1402311551-19564-1-git-send-email-clabbe.montjoie@gmail.com>
References: <1402311551-19564-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Security System included in Allwinner SoC A20.
The Security System is a hardware cryptographic accelerator that support AES/MD5/SHA1/DES/3DES/PRNG algorithms.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/sunxi-ss/Makefile               |  16 ++
 drivers/crypto/sunxi-ss/sunxi-ss-cipher-3des.c | 118 ++++++++
 drivers/crypto/sunxi-ss/sunxi-ss-cipher-aes.c  | 130 +++++++++
 drivers/crypto/sunxi-ss/sunxi-ss-cipher-des.c  | 118 ++++++++
 drivers/crypto/sunxi-ss/sunxi-ss-cipher.c      | 362 +++++++++++++++++++++++++
 drivers/crypto/sunxi-ss/sunxi-ss-cipher.h      |   8 +
 drivers/crypto/sunxi-ss/sunxi-ss-hash-md5.c    |  69 +++++
 drivers/crypto/sunxi-ss/sunxi-ss-hash-sha1.c   |  69 +++++
 drivers/crypto/sunxi-ss/sunxi-ss-hash.c        | 228 ++++++++++++++++
 drivers/crypto/sunxi-ss/sunxi-ss-hash.h        |   9 +
 drivers/crypto/sunxi-ss/sunxi-ss-rng.c         | 115 ++++++++
 drivers/crypto/sunxi-ss/sunxi-ss.c             | 190 +++++++++++++
 drivers/crypto/sunxi-ss/sunxi-ss.h             | 161 +++++++++++
 13 files changed, 1593 insertions(+)
 create mode 100644 drivers/crypto/sunxi-ss/Makefile
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-cipher-3des.c
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-cipher-aes.c
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-cipher-des.c
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-cipher.h
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-hash-md5.c
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-hash-sha1.c
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-hash.c
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-hash.h
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss-rng.c
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss.c
 create mode 100644 drivers/crypto/sunxi-ss/sunxi-ss.h

diff --git a/drivers/crypto/sunxi-ss/Makefile b/drivers/crypto/sunxi-ss/Makefile
new file mode 100644
index 0000000..de4556b
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/Makefile
@@ -0,0 +1,16 @@
+obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS) += sunxi-ss.o
+
+obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS_PRNG) += sunxi-ss-rng.o
+
+obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS_DES) += sunxi-ss-des.o
+sunxi-ss-des-y += sunxi-ss-cipher-des.o sunxi-ss-cipher.o
+obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS_3DES) += sunxi-ss-3des.o
+sunxi-ss-3des-y += sunxi-ss-cipher-3des.o sunxi-ss-cipher.o
+
+obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS_AES) += sunxi-ss-aes.o
+sunxi-ss-aes-y += sunxi-ss-cipher-aes.o sunxi-ss-cipher.o
+
+obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS_MD5) += sunxi-ss-md5.o
+sunxi-ss-md5-y += sunxi-ss-hash.o sunxi-ss-hash-md5.o
+obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS_SHA1) += sunxi-ss-sha1.o
+sunxi-ss-sha1-y += sunxi-ss-hash.o sunxi-ss-hash-sha1.o
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-cipher-3des.c b/drivers/crypto/sunxi-ss/sunxi-ss-cipher-3des.c
new file mode 100644
index 0000000..fcdc8a4
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher-3des.c
@@ -0,0 +1,118 @@
+/*
+ * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A20 SoC
+ *
+ * Copyright (C) 2013-2014 Corentin LABBE <clabbe.montjoie@gmail.com>
+ *
+ * Support AES cipher with 128,192,256 bits keysize.
+ * Support MD5 and SHA1 hash algorithms.
+ * Support DES and 3DES
+ * Support PRNG
+ *
+ * You could find the datasheet at
+ * http://dl.linux-sunxi.org/A20/A20%20User%20Manual%202013-03-22.pdf
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License
+ */
+#include "sunxi-ss-cipher.h"
+
+/* check and set the 3DES key, prepare the mode to be used */
+static int sunxi_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+		unsigned int keylen)
+{
+	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
+	if (keylen != 3 * DES_KEY_SIZE) {
+		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
+		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	op->keylen = keylen;
+	memcpy(op->key, key, keylen);
+	return 0;
+}
+
+static int sunxi_des3_cbc_encrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
+
+	if (areq->info == NULL) {
+		dev_info(ss->dev, "Empty IV\n");
+		return -EINVAL;
+	}
+
+	op->mode |= SS_ENCRYPTION;
+	op->mode |= SS_OP_3DES;
+	op->mode |= SS_CBC;
+
+	return sunxi_des_poll(areq);
+}
+
+static int sunxi_des3_cbc_decrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
+
+	if (areq->info == NULL) {
+		dev_info(ss->dev, "Empty IV\n");
+		return -EINVAL;
+	}
+
+	op->mode |= SS_DECRYPTION;
+	op->mode |= SS_OP_3DES;
+	op->mode |= SS_CBC;
+
+	return sunxi_des_poll(areq);
+}
+
+static struct crypto_alg sunxi_des3_alg = {
+	.cra_name = "cbc(des3_ede)",
+	.cra_driver_name = "cbc-des3-sunxi-ss",
+	.cra_priority = 300,
+	.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	.cra_ctxsize = sizeof(struct sunxi_req_ctx),
+	.cra_module = THIS_MODULE,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_init = sunxi_cipher_init,
+	.cra_exit = sunxi_cipher_exit,
+	.cra_alignmask = 3,
+	.cra_u.ablkcipher = {
+		.min_keysize    = DES3_EDE_KEY_SIZE,
+		.max_keysize    = DES3_EDE_KEY_SIZE,
+		.ivsize         = DES3_EDE_BLOCK_SIZE,
+		.setkey         = sunxi_des3_setkey,
+		.encrypt        = sunxi_des3_cbc_encrypt,
+		.decrypt        = sunxi_des3_cbc_decrypt,
+	}
+};
+
+static int sunxi_ss_3des_init(void)
+{
+	int err = 0;
+	if (ss == NULL) {
+		pr_err("Cannot get Security System structure\n");
+		return -ENODEV;
+	}
+	err = crypto_register_alg(&sunxi_des3_alg);
+	if (err)
+		dev_err(ss->dev, "crypto_register_alg error for DES3\n");
+	else
+		dev_dbg(ss->dev, "Registred DES3\n");
+	return err;
+}
+
+static void __exit sunxi_ss_3des_exit(void)
+{
+	crypto_unregister_alg(&sunxi_des3_alg);
+}
+
+module_init(sunxi_ss_3des_init);
+module_exit(sunxi_ss_3des_exit);
+
+MODULE_DESCRIPTION("Allwinner Security System crypto accelerator DES3 module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie@gmail.com>");
+MODULE_ALIAS("3des");
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-cipher-aes.c b/drivers/crypto/sunxi-ss/sunxi-ss-cipher-aes.c
new file mode 100644
index 0000000..eb52209
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher-aes.c
@@ -0,0 +1,130 @@
+/*
+ * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A20 SoC
+ *
+ * Copyright (C) 2013-2014 Corentin LABBE <clabbe.montjoie@gmail.com>
+ *
+ * Support AES cipher with 128,192,256 bits keysize.
+ * Support MD5 and SHA1 hash algorithms.
+ * Support DES and 3DES
+ * Support PRNG
+ *
+ * You could find the datasheet at
+ * http://dl.linux-sunxi.org/A20/A20%20User%20Manual%202013-03-22.pdf
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License
+ */
+#include "sunxi-ss-cipher.h"
+
+static int sunxi_aes_cbc_encrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
+
+	if (areq->info == NULL) {
+		dev_err(ss->dev, "Empty IV\n");
+		return -EINVAL;
+	}
+
+	op->mode |= SS_ENCRYPTION;
+	op->mode |= SS_OP_AES;
+	op->mode |= SS_CBC;
+
+	return sunxi_aes_poll(areq);
+}
+
+static int sunxi_aes_cbc_decrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
+
+	if (areq->info == NULL) {
+		dev_err(ss->dev, "Empty IV\n");
+		return -EINVAL;
+	}
+
+	op->mode |= SS_DECRYPTION;
+	op->mode |= SS_OP_AES;
+	op->mode |= SS_CBC;
+
+	return sunxi_aes_poll(areq);
+}
+
+/* check and set the AES key, prepare the mode to be used */
+static int sunxi_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+		unsigned int keylen)
+{
+	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
+	switch (keylen) {
+	case 128 / 8:
+		op->mode = SS_AES_128BITS;
+		break;
+	case 192 / 8:
+		op->mode = SS_AES_192BITS;
+		break;
+	case 256 / 8:
+		op->mode = SS_AES_256BITS;
+		break;
+	default:
+		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
+		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	op->keylen = keylen;
+	memcpy(op->key, key, keylen);
+	return 0;
+}
+
+static struct crypto_alg sunxi_aes_alg = {
+	.cra_name = "cbc(aes)",
+	.cra_driver_name = "cbc-aes-sunxi-ss",
+	.cra_priority = 300,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+	.cra_blocksize   = AES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct sunxi_req_ctx),
+	.cra_module = THIS_MODULE,
+	.cra_alignmask = 3,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_init = sunxi_cipher_init,
+	.cra_exit = sunxi_cipher_exit,
+	.cra_u = {
+		.ablkcipher = {
+			.min_keysize    = AES_MIN_KEY_SIZE,
+			.max_keysize    = AES_MAX_KEY_SIZE,
+			.ivsize         = AES_BLOCK_SIZE,
+			.setkey         = sunxi_aes_setkey,
+			.encrypt        = sunxi_aes_cbc_encrypt,
+			.decrypt        = sunxi_aes_cbc_decrypt,
+		}
+	}
+};
+
+int sunxi_ss_aes_init(void)
+{
+	int err = 0;
+	if (ss == NULL) {
+		pr_err("Cannot get Security System structure\n");
+		return -ENODEV;
+	}
+	err = crypto_register_alg(&sunxi_aes_alg);
+	if (err)
+		dev_err(ss->dev, "crypto_register_alg error for AES\n");
+	else
+		dev_dbg(ss->dev, "Registred AES\n");
+	return err;
+}
+
+static void __exit sunxi_ss_aes_exit(void)
+{
+	crypto_unregister_alg(&sunxi_aes_alg);
+}
+
+module_init(sunxi_ss_aes_init);
+module_exit(sunxi_ss_aes_exit);
+
+MODULE_DESCRIPTION("Allwinner Security System crypto accelerator AES module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie@gmail.com>");
+MODULE_ALIAS("aes");
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-cipher-des.c b/drivers/crypto/sunxi-ss/sunxi-ss-cipher-des.c
new file mode 100644
index 0000000..be4cd4b
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher-des.c
@@ -0,0 +1,118 @@
+/*
+ * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A20 SoC
+ *
+ * Copyright (C) 2013-2014 Corentin LABBE <clabbe.montjoie@gmail.com>
+ *
+ * Support AES cipher with 128,192,256 bits keysize.
+ * Support MD5 and SHA1 hash algorithms.
+ * Support DES and 3DES
+ * Support PRNG
+ *
+ * You could find the datasheet at
+ * http://dl.linux-sunxi.org/A20/A20%20User%20Manual%202013-03-22.pdf
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License
+ */
+#include "sunxi-ss-cipher.h"
+
+/* check and set the DES key, prepare the mode to be used */
+static int sunxi_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+		unsigned int keylen)
+{
+	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
+	if (keylen != DES_KEY_SIZE) {
+		dev_err(ss->dev, "Invalid keylen %u\n", keylen);
+		crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	op->keylen = keylen;
+	memcpy(op->key, key, keylen);
+	return 0;
+}
+
+static int sunxi_des_cbc_encrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
+
+	if (areq->info == NULL) {
+		dev_info(ss->dev, "Empty IV\n");
+		return -EINVAL;
+	}
+
+	op->mode |= SS_ENCRYPTION;
+	op->mode |= SS_OP_DES;
+	op->mode |= SS_CBC;
+
+	return sunxi_des_poll(areq);
+}
+
+static int sunxi_des_cbc_decrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
+
+	if (areq->info == NULL) {
+		dev_info(ss->dev, "Empty IV\n");
+		return -EINVAL;
+	}
+
+	op->mode |= SS_DECRYPTION;
+	op->mode |= SS_OP_DES;
+	op->mode |= SS_CBC;
+
+	return sunxi_des_poll(areq);
+}
+
+static struct crypto_alg sunxi_des_alg = {
+	.cra_name = "cbc(des)",
+	.cra_driver_name = "cbc-des-sunxi-ss",
+	.cra_priority = 300,
+	.cra_blocksize = DES_BLOCK_SIZE,
+	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER,
+	.cra_ctxsize = sizeof(struct sunxi_req_ctx),
+	.cra_module = THIS_MODULE,
+	.cra_type = &crypto_ablkcipher_type,
+	.cra_init = sunxi_cipher_init,
+	.cra_exit = sunxi_cipher_exit,
+	.cra_alignmask = 3,
+	.cra_u.ablkcipher = {
+		.min_keysize    = DES_KEY_SIZE,
+		.max_keysize    = DES_KEY_SIZE,
+		.ivsize         = DES_BLOCK_SIZE,
+		.setkey         = sunxi_des_setkey,
+		.encrypt        = sunxi_des_cbc_encrypt,
+		.decrypt        = sunxi_des_cbc_decrypt,
+	}
+};
+
+static int sunxi_ss_des_init(void)
+{
+	int err = 0;
+	if (ss == NULL) {
+		pr_err("Cannot get Security System structure\n");
+		return -ENODEV;
+	}
+	err = crypto_register_alg(&sunxi_des_alg);
+	if (err)
+		dev_err(ss->dev, "crypto_register_alg error for DES\n");
+	else
+		dev_dbg(ss->dev, "Registred DES\n");
+	return err;
+}
+
+static void __exit sunxi_ss_des_exit(void)
+{
+	crypto_unregister_alg(&sunxi_des_alg);
+}
+
+module_init(sunxi_ss_des_init);
+module_exit(sunxi_ss_des_exit);
+
+MODULE_DESCRIPTION("Allwinner Security System crypto accelerator DES module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie@gmail.com>");
+MODULE_ALIAS("des");
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
new file mode 100644
index 0000000..6c5edc4
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.c
@@ -0,0 +1,362 @@
+/*
+ * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A20 SoC
+ *
+ * Copyright (C) 2013-2014 Corentin LABBE <clabbe.montjoie@gmail.com>
+ *
+ * Support AES cipher with 128,192,256 bits keysize.
+ * Support MD5 and SHA1 hash algorithms.
+ * Support DES and 3DES
+ * Support PRNG
+ *
+ * You could find the datasheet at
+ * http://dl.linux-sunxi.org/A20/A20%20User%20Manual%202013-03-22.pdf
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License
+ */
+#include "sunxi-ss-cipher.h"
+
+int sunxi_cipher_init(struct crypto_tfm *tfm)
+{
+	struct sunxi_req_ctx *op = crypto_tfm_ctx(tfm);
+	memset(op, 0, sizeof(struct sunxi_req_ctx));
+	return 0;
+}
+
+void sunxi_cipher_exit(struct crypto_tfm *tfm)
+{
+}
+
+int sunxi_aes_poll(struct ablkcipher_request *areq)
+{
+	u32 tmp;
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
+	/* when activating SS, the default FIFO space is 32 */
+	u32 rx_cnt = 32;
+	u32 tx_cnt = 0;
+	u32 v;
+	int i;
+	struct scatterlist *in_sg;
+	struct scatterlist *out_sg;
+	void *src_addr;
+	void *dst_addr;
+	unsigned int ileft = areq->nbytes;
+	unsigned int oleft = areq->nbytes;
+	unsigned int sgileft = areq->src->length;
+	unsigned int sgoleft = areq->dst->length;
+	unsigned int todo;
+	u32 *src32;
+	u32 *dst32;
+
+	tmp = op->mode;
+	tmp |= SS_ENABLED;
+
+	in_sg = areq->src;
+	out_sg = areq->dst;
+	if (areq->src == NULL || areq->dst == NULL) {
+		dev_err(ss->dev, "ERROR: Some SGs are NULL %u\n", areq->nbytes);
+		return -1;
+	}
+	mutex_lock(&ss->lock);
+	if (areq->info != NULL) {
+		for (i = 0; i < op->keylen; i += 4) {
+			v = *(u32 *)(op->key + i);
+			writel(v, ss->base + SS_KEY0 + i);
+		}
+		for (i = 0; i < 4 && i < ivsize / 4; i++) {
+			v = *(u32 *)(areq->info + i * 4);
+			writel(v, ss->base + SS_IV0 + i * 4);
+		}
+	}
+	writel(tmp, ss->base + SS_CTL);
+
+	/* If we have only one SG, we can use kmap_atomic */
+	if (sg_next(in_sg) == NULL && sg_next(out_sg) == NULL) {
+		src_addr = kmap_atomic(sg_page(in_sg)) + in_sg->offset;
+		if (src_addr == NULL) {
+			dev_err(ss->dev, "kmap_atomic error for src SG\n");
+			writel(0, ss->base + SS_CTL);
+			mutex_unlock(&ss->lock);
+			return -1;
+		}
+		dst_addr = kmap_atomic(sg_page(out_sg)) + out_sg->offset;
+		if (dst_addr == NULL) {
+			dev_err(ss->dev, "kmap_atomic error for dst SG\n");
+			writel(0, ss->base + SS_CTL);
+			mutex_unlock(&ss->lock);
+			kunmap_atomic(src_addr);
+			return -1;
+		}
+		src32 = (u32 *)src_addr;
+		dst32 = (u32 *)dst_addr;
+		ileft = areq->nbytes / 4;
+		oleft = areq->nbytes / 4;
+		do {
+			if (ileft > 0 && rx_cnt > 0) {
+				todo = min(rx_cnt, ileft);
+				ileft -= todo;
+				do {
+					writel_relaxed(*src32++,
+						       ss->base +
+						       SS_RXFIFO);
+					todo--;
+				} while (todo > 0);
+			}
+			if (tx_cnt > 0) {
+				todo = min(tx_cnt, oleft);
+				oleft -= todo;
+				do {
+					*dst32++ = readl_relaxed(ss->base +
+								SS_TXFIFO);
+					todo--;
+				} while (todo > 0);
+			}
+			tmp = readl_relaxed(ss->base + SS_FCSR);
+			rx_cnt = SS_RXFIFO_SPACES(tmp);
+			tx_cnt = SS_TXFIFO_SPACES(tmp);
+		} while (oleft > 0);
+		writel(0, ss->base + SS_CTL);
+		mutex_unlock(&ss->lock);
+		kunmap_atomic(src_addr);
+		kunmap_atomic(dst_addr);
+		return 0;
+	}
+
+	/* If we have more than one SG, we cannot use kmap_atomic since
+	 * we hold the mapping too long*/
+	src_addr = kmap(sg_page(in_sg)) + in_sg->offset;
+	if (src_addr == NULL) {
+		dev_err(ss->dev, "KMAP error for src SG\n");
+		return -1;
+	}
+	dst_addr = kmap(sg_page(out_sg)) + out_sg->offset;
+	if (dst_addr == NULL) {
+		kunmap(sg_page(in_sg));
+		dev_err(ss->dev, "KMAP error for dst SG\n");
+		return -1;
+	}
+	src32 = (u32 *)src_addr;
+	dst32 = (u32 *)dst_addr;
+	ileft = areq->nbytes / 4;
+	oleft = areq->nbytes / 4;
+	sgileft = in_sg->length / 4;
+	sgoleft = out_sg->length / 4;
+	do {
+		tmp = readl_relaxed(ss->base + SS_FCSR);
+		rx_cnt = SS_RXFIFO_SPACES(tmp);
+		tx_cnt = SS_TXFIFO_SPACES(tmp);
+		todo = min3(rx_cnt, ileft, sgileft);
+		if (todo > 0) {
+			ileft -= todo;
+			sgileft -= todo;
+		}
+		while (todo > 0) {
+			writel_relaxed(*src32++, ss->base + SS_RXFIFO);
+			todo--;
+		}
+		if (in_sg != NULL && sgileft == 0 && ileft > 0) {
+			kunmap(sg_page(in_sg));
+			in_sg = sg_next(in_sg);
+			if (in_sg != NULL && in_sg->length == 0)
+				in_sg = sg_next(in_sg);
+			if (in_sg != NULL && in_sg->length == 0)
+				in_sg = sg_next(in_sg);
+			if (in_sg != NULL && ileft > 0) {
+				src_addr = kmap(sg_page(in_sg)) + in_sg->offset;
+				if (src_addr == NULL) {
+					dev_err(ss->dev, "KMAP error for src SG\n");
+					return -1;
+				}
+				src32 = src_addr;
+				sgileft = in_sg->length / 4;
+			}
+		}
+		/* do not test oleft since when oleft == 0 we have finished */
+		todo = min3(tx_cnt, oleft, sgoleft);
+		if (todo > 0) {
+			oleft -= todo;
+			sgoleft -= todo;
+		}
+		while (todo > 0) {
+			*dst32++ = readl_relaxed(ss->base + SS_TXFIFO);
+			todo--;
+		}
+		if (out_sg != NULL && sgoleft == 0 && oleft >= 0) {
+			kunmap(sg_page(out_sg));
+			out_sg = sg_next(out_sg);
+			if (out_sg != NULL && out_sg->length == 0)
+				out_sg = sg_next(out_sg);
+			if (out_sg != NULL && oleft > 0) {
+				dst_addr = kmap(sg_page(out_sg)) +
+					out_sg->offset;
+				if (dst_addr == NULL) {
+					dev_err(ss->dev, "KMAP error\n");
+					return -1;
+				}
+				dst32 = dst_addr;
+				sgoleft = out_sg->length / 4;
+			}
+		}
+	} while (oleft > 0);
+
+	writel(0, ss->base + SS_CTL);
+	mutex_unlock(&ss->lock);
+	return 0;
+}
+
+/* Pure CPU way of doing DES/3DES with SS
+ * Since DES and 3DES SGs could be smaller than 4 bytes, I use sg_copy_to_buffer
+ * for "linearize" them.
+ * The problem with that is that I alloc (2 x areq->nbytes) for buf_in/buf_out
+ * TODO: change this system
+ * SGsrc -> buf_in -> SS -> buf_out -> SGdst */
+int sunxi_des_poll(struct ablkcipher_request *areq)
+{
+	u32 tmp, value;
+	size_t nb_in_sg_tx, nb_in_sg_rx;
+	size_t ir, it;
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
+	struct sunxi_req_ctx *op = crypto_ablkcipher_ctx(tfm);
+	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
+	u32 tx_cnt = 0;
+	u32 rx_cnt = 0;
+	u32 v;
+	int i;
+	int no_chunk = 1;
+
+	/* if we have only SGs with size multiple of 4,
+	 * we can use the SS AES function */
+	struct scatterlist *in_sg;
+	struct scatterlist *out_sg;
+	in_sg = areq->src;
+	out_sg = areq->dst;
+
+	while (in_sg != NULL && no_chunk == 1) {
+		if ((in_sg->length % 4) != 0)
+			no_chunk = 0;
+		in_sg = sg_next(in_sg);
+	}
+	while (out_sg != NULL && no_chunk == 1) {
+		if ((out_sg->length % 4) != 0)
+			no_chunk = 0;
+		out_sg = sg_next(out_sg);
+	}
+
+	if (no_chunk == 1)
+		return sunxi_aes_poll(areq);
+	in_sg = areq->src;
+	out_sg = areq->dst;
+
+	tmp = op->mode;
+	tmp |= SS_ENABLED;
+
+	nb_in_sg_rx = sg_nents(in_sg);
+	nb_in_sg_tx = sg_nents(out_sg);
+
+	mutex_lock(&ss->bufin_lock);
+	if (ss->buf_in == NULL) {
+		ss->buf_in = kmalloc(areq->nbytes, GFP_KERNEL);
+		ss->buf_in_size = areq->nbytes;
+	} else {
+		if (areq->nbytes > ss->buf_in_size) {
+			kfree(ss->buf_in);
+			ss->buf_in = kmalloc(areq->nbytes, GFP_KERNEL);
+			ss->buf_in_size = areq->nbytes;
+		}
+	}
+	if (ss->buf_in == NULL) {
+		ss->buf_in_size = 0;
+		mutex_unlock(&ss->bufin_lock);
+		dev_err(ss->dev, "Unable to allocate pages.\n");
+		return -ENOMEM;
+	}
+	if (ss->buf_out == NULL) {
+		mutex_lock(&ss->bufout_lock);
+		ss->buf_out = kmalloc(areq->nbytes, GFP_KERNEL);
+		if (ss->buf_out == NULL) {
+			ss->buf_out_size = 0;
+			mutex_unlock(&ss->bufout_lock);
+			dev_err(ss->dev, "Unable to allocate pages.\n");
+			return -ENOMEM;
+		}
+		ss->buf_out_size = areq->nbytes;
+		mutex_unlock(&ss->bufout_lock);
+	} else {
+		if (areq->nbytes > ss->buf_out_size) {
+			mutex_lock(&ss->bufout_lock);
+			kfree(ss->buf_out);
+			ss->buf_out = kmalloc(areq->nbytes, GFP_KERNEL);
+			if (ss->buf_out == NULL) {
+				ss->buf_out_size = 0;
+				mutex_unlock(&ss->bufout_lock);
+				dev_err(ss->dev, "Unable to allocate pages.\n");
+				return -ENOMEM;
+			}
+			ss->buf_out_size = areq->nbytes;
+			mutex_unlock(&ss->bufout_lock);
+		}
+	}
+
+	sg_copy_to_buffer(areq->src, nb_in_sg_rx, ss->buf_in, areq->nbytes);
+
+	ir = 0;
+	it = 0;
+	mutex_lock(&ss->lock);
+	if (areq->info != NULL) {
+		for (i = 0; i < op->keylen; i += 4) {
+			v = *(u32 *)(op->key + i);
+			writel(v, ss->base + SS_KEY0 + i);
+		}
+		for (i = 0; i < 4 && i < ivsize / 4; i++) {
+			v = *(u32 *)(areq->info + i * 4);
+			writel(v, ss->base + SS_IV0 + i * 4);
+		}
+	}
+	writel(tmp, ss->base + SS_CTL);
+
+	do {
+		if (rx_cnt == 0 || tx_cnt == 0) {
+			tmp = readl(ss->base + SS_FCSR);
+			rx_cnt = SS_RXFIFO_SPACES(tmp);
+			tx_cnt = SS_TXFIFO_SPACES(tmp);
+		}
+		if (rx_cnt > 0 && ir < areq->nbytes) {
+			do {
+				value = *(u32 *)(ss->buf_in + ir);
+				writel(value, ss->base + SS_RXFIFO);
+				ir += 4;
+				rx_cnt--;
+			} while (rx_cnt > 0 && ir < areq->nbytes);
+		}
+		if (tx_cnt > 0 && it < areq->nbytes) {
+			do {
+				if (ir <= it)
+					dev_warn(ss->dev, "ANORMAL %u %u\n",
+							ir, it);
+				value = readl(ss->base + SS_TXFIFO);
+				*(u32 *)(ss->buf_out + it) = value;
+				it += 4;
+				tx_cnt--;
+			} while (tx_cnt > 0 && it < areq->nbytes);
+		}
+		if (ir == areq->nbytes) {
+			mutex_unlock(&ss->bufin_lock);
+			ir++;
+		}
+	} while (it < areq->nbytes);
+
+	writel(0, ss->base + SS_CTL);
+	mutex_unlock(&ss->lock);
+
+	/* a simple optimization, since we dont need the hardware for this copy
+	 * we release the lock and do the copy. With that we gain 5/10% perf */
+	mutex_lock(&ss->bufout_lock);
+	sg_copy_from_buffer(areq->dst, nb_in_sg_tx, ss->buf_out, areq->nbytes);
+
+	mutex_unlock(&ss->bufout_lock);
+	return 0;
+}
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-cipher.h b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.h
new file mode 100644
index 0000000..ecfbf9c
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss-cipher.h
@@ -0,0 +1,8 @@
+#include "sunxi-ss.h"
+
+extern struct sunxi_ss_ctx *ss;
+
+int sunxi_aes_poll(struct ablkcipher_request *areq);
+int sunxi_des_poll(struct ablkcipher_request *areq);
+int sunxi_cipher_init(struct crypto_tfm *tfm);
+void sunxi_cipher_exit(struct crypto_tfm *tfm);
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-hash-md5.c b/drivers/crypto/sunxi-ss/sunxi-ss-hash-md5.c
new file mode 100644
index 0000000..1cadd44
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss-hash-md5.c
@@ -0,0 +1,69 @@
+/*
+ * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A20 SoC
+ *
+ * Copyright (C) 2013-2014 Corentin LABBE <clabbe.montjoie@gmail.com>
+ *
+ * Support AES cipher with 128,192,256 bits keysize.
+ * Support MD5 and SHA1 hash algorithms.
+ * Support DES and 3DES
+ * Support PRNG
+ *
+ * You could find the datasheet at
+ * http://dl.linux-sunxi.org/A20/A20%20User%20Manual%202013-03-22.pdf
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License
+ */
+#include "sunxi-ss-hash.h"
+
+static struct ahash_alg sunxi_md5_alg = {
+	.init = sunxi_hash_init,
+	.update = sunxi_hash_update,
+	.final = sunxi_hash_final,
+	.finup = sunxi_hash_finup,
+	.digest = sunxi_hash_digest,
+	.halg = {
+		.digestsize = MD5_DIGEST_SIZE,
+		.base = {
+			.cra_name = "md5",
+			.cra_driver_name = "md5-sunxi-ss",
+			.cra_priority = 300,
+			.cra_alignmask = 3,
+			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sunxi_req_ctx),
+			.cra_module = THIS_MODULE,
+			.cra_type = &crypto_ahash_type
+		}
+	}
+};
+
+static int sunxi_ss_md5_init(void)
+{
+	int err = 0;
+	if (ss == NULL) {
+		pr_err("Cannot get Security System structure\n");
+		return -ENODEV;
+	}
+	err = crypto_register_ahash(&sunxi_md5_alg);
+	if (err)
+		dev_err(ss->dev, "crypto_register_alg error for MD5\n");
+	else
+		dev_dbg(ss->dev, "Registred MD5\n");
+	return err;
+}
+
+static void __exit sunxi_ss_md5_exit(void)
+{
+	crypto_unregister_ahash(&sunxi_md5_alg);
+}
+
+module_init(sunxi_ss_md5_init);
+module_exit(sunxi_ss_md5_exit);
+
+MODULE_DESCRIPTION("Allwinner Security System crypto accelerator MD5 module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie@gmail.com>");
+MODULE_ALIAS("md5");
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-hash-sha1.c b/drivers/crypto/sunxi-ss/sunxi-ss-hash-sha1.c
new file mode 100644
index 0000000..c509436
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss-hash-sha1.c
@@ -0,0 +1,69 @@
+/*
+ * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A20 SoC
+ *
+ * Copyright (C) 2013-2014 Corentin LABBE <clabbe.montjoie@gmail.com>
+ *
+ * Support AES cipher with 128,192,256 bits keysize.
+ * Support MD5 and SHA1 hash algorithms.
+ * Support DES and 3DES
+ * Support PRNG
+ *
+ * You could find the datasheet at
+ * http://dl.linux-sunxi.org/A20/A20%20User%20Manual%202013-03-22.pdf
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License
+ */
+#include "sunxi-ss-hash.h"
+
+static struct ahash_alg sunxi_sha1_alg = {
+	.init = sunxi_hash_init,
+	.update = sunxi_hash_update,
+	.final = sunxi_hash_final,
+	.finup = sunxi_hash_finup,
+	.digest = sunxi_hash_digest,
+	.halg = {
+		.digestsize = SHA1_DIGEST_SIZE,
+		.base = {
+			.cra_name = "sha1",
+			.cra_driver_name = "sha1-sunxi-ss",
+			.cra_priority = 300,
+			.cra_alignmask = 3,
+			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+			.cra_blocksize = SHA1_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sunxi_req_ctx),
+			.cra_module = THIS_MODULE,
+			.cra_type = &crypto_ahash_type
+		}
+	}
+};
+
+static int sunxi_ss_sha1_init(void)
+{
+	int err = 0;
+	if (ss == NULL) {
+		pr_err("Cannot get Security System structure\n");
+		return -ENODEV;
+	}
+	err = crypto_register_ahash(&sunxi_sha1_alg);
+	if (err)
+		dev_err(ss->dev, "crypto_register_alg error for SHA1\n");
+	else
+		dev_dbg(ss->dev, "Registred SHA1\n");
+	return err;
+}
+
+static void __exit sunxi_ss_sha1_exit(void)
+{
+	crypto_unregister_ahash(&sunxi_sha1_alg);
+}
+
+module_init(sunxi_ss_sha1_init);
+module_exit(sunxi_ss_sha1_exit);
+
+MODULE_DESCRIPTION("Allwinner Security System crypto accelerator SHA1 module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie@gmail.com>");
+MODULE_ALIAS("sha1");
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-hash.c b/drivers/crypto/sunxi-ss/sunxi-ss-hash.c
new file mode 100644
index 0000000..e229365
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss-hash.c
@@ -0,0 +1,228 @@
+#include "sunxi-ss-hash.h"
+
+/* sunxi_hash_init: initialize request context
+ * Activate the SS, and configure it for MD5 or SHA1
+ */
+int sunxi_hash_init(struct ahash_request *areq)
+{
+	const char *hash_type;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sunxi_req_ctx *op = crypto_ahash_ctx(tfm);
+	u32 tmp = SS_ENABLED;
+
+	mutex_lock(&ss->lock);
+
+	hash_type = crypto_tfm_alg_name(areq->base.tfm);
+
+	op->byte_count = 0;
+	op->nbwait = 0;
+	op->waitbuf = 0;
+
+	/* Enable and configure SS for MD5 or SHA1 */
+	if (strcmp(hash_type, "sha1") == 0) {
+		tmp |= SS_OP_SHA1;
+		op->mode = SS_OP_SHA1;
+	} else {
+		tmp |= SS_OP_MD5;
+		op->mode = SS_OP_MD5;
+	}
+
+	writel(tmp, ss->base + SS_CTL);
+	return 0;
+}
+
+/*
+ * sunxi_hash_update: update hash engine
+ *
+ * Could be used for both SHA1 and MD5
+ * Write data by step of 32bits and put then in the SS.
+ * The remaining data is stored (nbwait bytes) in op->waitbuf
+ * As an optimisation, we do not check RXFIFO_SPACES, since SS handle
+ * the FIFO faster than our writes
+ */
+int sunxi_hash_update(struct ahash_request *areq)
+{
+	u32 v;
+	unsigned int i = 0;/* bytes read, to be compared to areq->nbytes */
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sunxi_req_ctx *op = crypto_ahash_ctx(tfm);
+	struct scatterlist *in_sg;
+	unsigned int in_i = 0;/* advancement in the current SG */
+	void *src_addr;
+
+	u8 *waitbuf = (u8 *)(&op->waitbuf);
+
+	if (areq->nbytes == 0)
+		return 0;
+
+	in_sg = areq->src;
+	do {
+		src_addr = kmap(sg_page(in_sg)) + in_sg->offset;
+		/* step 1, if some bytes remains from last SG,
+		 * try to complete them to 4 and sent its */
+		if (op->nbwait > 0) {
+			while (op->nbwait < 4 && i < areq->nbytes &&
+					in_i < in_sg->length) {
+				waitbuf[op->nbwait] = *(u8 *)(src_addr + in_i);
+				i++;
+				in_i++;
+				op->nbwait++;
+			}
+			if (op->nbwait == 4) {
+				writel(op->waitbuf, ss->base + SS_RXFIFO);
+				op->byte_count += 4;
+				op->nbwait = 0;
+				op->waitbuf = 0;
+			}
+		}
+		/* step 2, main loop, read data 4bytes at a time */
+		while (i < areq->nbytes && areq->nbytes - i >= 4 &&
+				in_i < in_sg->length &&
+				in_sg->length - in_i >= 4) {
+			v = *(u32 *)(src_addr + in_i);
+			writel_relaxed(v, ss->base + SS_RXFIFO);
+			i += 4;
+			op->byte_count += 4;
+			in_i += 4;
+		}
+		/* step 3, if we have less than 4 bytes, copy them in waitbuf
+		 * no need to check for op->nbwait < 4 since we cannot have
+		 * more than 4 bytes remaining */
+		if (in_i < in_sg->length && in_sg->length - in_i < 4 &&
+				i < areq->nbytes) {
+			do {
+				waitbuf[op->nbwait] = *(u8 *)(src_addr + in_i);
+				op->nbwait++;
+				in_i++;
+				i++;
+			} while (in_i < in_sg->length && i < areq->nbytes);
+		}
+		/* we have finished the current SG, try next one */
+		kunmap(sg_page(in_sg));
+		in_sg = sg_next(in_sg);
+		in_i = 0;
+	} while (in_sg != NULL && i < areq->nbytes);
+	return 0;
+}
+
+/*
+ * sunxi_hash_final: finalize hashing operation
+ *
+ * If we have some remaining bytes, send it.
+ * Then ask the SS for finalizing the hash
+ */
+int sunxi_hash_final(struct ahash_request *areq)
+{
+	u32 v;
+	unsigned int i;
+	int zeros;
+	unsigned int index, padlen;
+	__be64 bits;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sunxi_req_ctx *op = crypto_ahash_ctx(tfm);
+
+	if (op->nbwait > 0) {
+		op->waitbuf |= ((1 << 7) << (op->nbwait * 8));
+		writel(op->waitbuf, ss->base + SS_RXFIFO);
+	} else {
+		writel((1 << 7), ss->base + SS_RXFIFO);
+	}
+
+	/* number of space to pad to obtain 64o minus 8(size) minus 4 (final 1)
+	 * example len=0
+	 * example len=56
+	 * */
+
+	/* we have already send 4 more byte of which nbwait data */
+	if (op->mode == SS_OP_MD5) {
+		index = (op->byte_count + 4) & 0x3f;
+		op->byte_count += op->nbwait;
+		if (index > 56)
+			zeros = (120 - index) / 4;
+		else
+			zeros = (56 - index) / 4;
+	} else {
+		op->byte_count += op->nbwait;
+		index = op->byte_count & 0x3f;
+		padlen = (index < 56) ? (56 - index) : ((64+56) - index);
+		zeros = (padlen - 1) / 4;
+	}
+	for (i = 0; i < zeros; i++)
+		writel(0, ss->base + SS_RXFIFO);
+
+	/* write the lenght */
+	if (op->mode == SS_OP_SHA1) {
+		bits = cpu_to_be64(op->byte_count << 3);
+		writel(bits & 0xffffffff, ss->base + SS_RXFIFO);
+		writel((bits >> 32) & 0xffffffff, ss->base + SS_RXFIFO);
+	} else {
+		writel((op->byte_count << 3) & 0xffffffff,
+				ss->base + SS_RXFIFO);
+		writel((op->byte_count >> 29) & 0xffffffff,
+				ss->base + SS_RXFIFO);
+	}
+
+	/* stop the hashing */
+	v = readl(ss->base + SS_CTL);
+	v |= SS_DATA_END;
+	writel(v, ss->base + SS_CTL);
+
+	/* check the end */
+	/* The timeout could happend only in case of bad overcloking */
+#define SS_TIMEOUT 100
+	i = 0;
+	do {
+		v = readl(ss->base + SS_CTL);
+		i++;
+	} while (i < SS_TIMEOUT && (v & SS_DATA_END) > 0);
+	if (i >= SS_TIMEOUT) {
+		dev_err(ss->dev, "ERROR: hash end timeout %d>%d\n",
+				i, SS_TIMEOUT);
+		writel(0, ss->base + SS_CTL);
+		mutex_unlock(&ss->lock);
+		return -1;
+	}
+
+	if (op->mode == SS_OP_SHA1) {
+		for (i = 0; i < 5; i++) {
+			v = cpu_to_be32(readl(ss->base + SS_MD0 + i * 4));
+			memcpy(areq->result + i * 4, &v, 4);
+		}
+	} else {
+		for (i = 0; i < 4; i++) {
+			v = readl(ss->base + SS_MD0 + i * 4);
+			memcpy(areq->result + i * 4, &v, 4);
+		}
+	}
+	writel(0, ss->base + SS_CTL);
+	mutex_unlock(&ss->lock);
+	return 0;
+}
+
+/* sunxi_hash_finup: finalize hashing operation after an update */
+int sunxi_hash_finup(struct ahash_request *areq)
+{
+	int err;
+
+	err = sunxi_hash_update(areq);
+	if (err != 0)
+		return err;
+
+	return sunxi_hash_final(areq);
+}
+
+/* combo of init/update/final functions */
+int sunxi_hash_digest(struct ahash_request *areq)
+{
+	int err;
+
+	err = sunxi_hash_init(areq);
+	if (err != 0)
+		return err;
+
+	err = sunxi_hash_update(areq);
+	if (err != 0)
+		return err;
+
+	return sunxi_hash_final(areq);
+}
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-hash.h b/drivers/crypto/sunxi-ss/sunxi-ss-hash.h
new file mode 100644
index 0000000..7fae093
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss-hash.h
@@ -0,0 +1,9 @@
+#include "sunxi-ss.h"
+
+extern struct sunxi_ss_ctx *ss;
+
+int sunxi_hash_init(struct ahash_request *areq);
+int sunxi_hash_update(struct ahash_request *areq);
+int sunxi_hash_final(struct ahash_request *areq);
+int sunxi_hash_finup(struct ahash_request *areq);
+int sunxi_hash_digest(struct ahash_request *areq);
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-rng.c b/drivers/crypto/sunxi-ss/sunxi-ss-rng.c
new file mode 100644
index 0000000..0af20ab
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss-rng.c
@@ -0,0 +1,115 @@
+#include "sunxi-ss.h"
+#include <crypto/internal/rng.h>
+
+#define SS_SEED_LEN (192/8)
+#define SS_DATA_LEN (160/8)
+
+struct prng_context {
+	u32 seed[SS_SEED_LEN/4];
+	unsigned int slen;
+};
+
+extern struct sunxi_ss_ctx *ss;
+
+static int sunxi_ss_rng_get_random(struct crypto_rng *tfm, u8 *rdata,
+		unsigned int dlen)
+{
+	struct prng_context *ctx = crypto_rng_ctx(tfm);
+	int i;
+	u32 mode = 0;
+	u32 v;
+
+	if (rdata == NULL)
+		return -EINVAL;
+
+	mode |= SS_OP_PRNG | SS_PRNG_ONESHOT | SS_ENABLED;
+
+	mutex_lock(&ss->lock);
+	writel(mode, ss->base + SS_CTL);
+
+	for (i = 0; i < ctx->slen && i < SS_SEED_LEN; i += 4) {
+		v = *(u32 *)(ctx->seed + i);
+		writel(v, ss->base + SS_KEY0 + i);
+	}
+
+	writel(mode | SS_PRNG_START, ss->base + SS_CTL);
+	i = 0;
+	do {
+		v = readl(ss->base + SS_CTL);
+		i++;
+	} while (v != mode && i < 10);
+	for (i = 0; i < dlen && i < SS_DATA_LEN; i += 4) {
+		v = readl(ss->base + SS_MD0 + i);
+		*(u32 *)(rdata + i) = v;
+	}
+
+	writel(0, ss->base + SS_CTL);
+	mutex_unlock(&ss->lock);
+	return dlen;
+}
+
+static int sunxi_ss_rng_reset(struct crypto_rng *tfm, u8 *seed,
+		unsigned int slen)
+{
+	struct prng_context *ctx = crypto_rng_ctx(tfm);
+	unsigned int i;
+
+	if (slen == 0) {
+		ctx->slen = 0;
+		return 0;
+	}
+	if (slen > SS_SEED_LEN) {
+		dev_err(ss->dev, "Requested seedlen %u exceed %u\n",
+				slen, SS_SEED_LEN);
+		return -EINVAL;
+	}
+	for (i = 0; i < SS_SEED_LEN && i < slen; i++)
+		ctx->seed[i] = seed[i];
+	ctx->slen = slen;
+	return 0;
+}
+
+static struct crypto_alg sunxi_ss_prng = {
+	.cra_name = "stdrng",
+	.cra_driver_name = "rng-sunxi-ss",
+	.cra_priority = 300,
+	.cra_flags = CRYPTO_ALG_TYPE_RNG,
+	.cra_ctxsize = sizeof(struct prng_context),
+	.cra_module = THIS_MODULE,
+	.cra_type = &crypto_rng_type,
+	.cra_u.rng = {
+		.rng_make_random = sunxi_ss_rng_get_random,
+		.rng_reset = sunxi_ss_rng_reset,
+		.seedsize = SS_SEED_LEN
+	}
+};
+
+
+static int sunxi_ss_rng_init(void)
+{
+	int err = 0;
+	if (ss == NULL) {
+		pr_err("Cannot get SUNXI SS\n");
+		return 0;
+	}
+
+	err = crypto_register_alg(&sunxi_ss_prng);
+	if (err)
+		dev_err(ss->dev, "crypto_register_alg error\n");
+	else
+		dev_info(ss->dev, "Registred PRNG\n");
+	return err;
+}
+
+static void __exit sunxi_ss_rng_exit(void)
+{
+	crypto_unregister_alg(&sunxi_ss_prng);
+}
+
+
+module_init(sunxi_ss_rng_init);
+module_exit(sunxi_ss_rng_exit);
+
+MODULE_DESCRIPTION("Allwinner Security System crypto accelerator RNG module");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie@gmail.com>");
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss.c b/drivers/crypto/sunxi-ss/sunxi-ss.c
new file mode 100644
index 0000000..9287af2
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss.c
@@ -0,0 +1,190 @@
+/*
+ * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A20 SoC
+ *
+ * Copyright (C) 2013-2014 Corentin LABBE <clabbe.montjoie@gmail.com>
+ *
+ * Support AES cipher with 128,192,256 bits keysize.
+ * Support MD5 and SHA1 hash algorithms.
+ * Support DES and 3DES
+ * Support PRNG
+ *
+ * You could find the datasheet at
+ * http://dl.linux-sunxi.org/A20/A20%20User%20Manual%202013-03-22.pdf
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License
+ */
+#include "sunxi-ss.h"
+
+#include <linux/clk.h>
+#include <linux/crypto.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <crypto/scatterwalk.h>
+#include <linux/scatterlist.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+
+/* General notes:
+ * I cannot use a key/IV cache because each time one of these change ALL stuff
+ * need to be re-writed (rewrite SS_KEYX ans SS_IVX).
+ * And for example, with dm-crypt IV changes on each request.
+ *
+ * After each request the device must be disabled with a write of 0 in SS_CTL
+ *
+ * For performance reason, we use writel_relaxed/read_relaxed for all
+ * operations on RX and TX FIFO and also SS_FCSR.
+ * For all other registers, we use writel/readl.
+ * See http://permalink.gmane.org/gmane.linux.ports.arm.kernel/117644
+ * and http://permalink.gmane.org/gmane.linux.ports.arm.kernel/117640
+ * */
+
+static int ss_is_init;
+struct sunxi_ss_ctx *ss;
+EXPORT_SYMBOL_GPL(ss);
+
+static int sunxi_ss_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	u32 v;
+	int err;
+	unsigned long cr;
+	const unsigned long cr_ahb = 24 * 1000 * 1000;
+	const unsigned long cr_mod = 150 * 1000 * 1000;
+
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	if (ss_is_init == 1) {
+		dev_err(&pdev->dev, "Device already initialized\n");
+		return -ENODEV;
+	}
+
+	ss = devm_kzalloc(&pdev->dev, sizeof(*ss), GFP_KERNEL);
+	if (ss == NULL)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ss->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ss->base)) {
+		dev_err(&pdev->dev, "Cannot request MMIO\n");
+		return PTR_ERR(ss->base);
+	}
+
+	ss->ssclk = devm_clk_get(&pdev->dev, "mod");
+	if (IS_ERR(ss->ssclk)) {
+		err = PTR_ERR(ss->ssclk);
+		dev_err(&pdev->dev, "Cannot get SS clock err=%d\n", err);
+		return err;
+	}
+	dev_dbg(&pdev->dev, "clock ss acquired\n");
+
+	ss->busclk = devm_clk_get(&pdev->dev, "ahb");
+	if (IS_ERR(ss->busclk)) {
+		err = PTR_ERR(ss->busclk);
+		dev_err(&pdev->dev, "Cannot get AHB SS clock err=%d\n", err);
+		return err;
+	}
+	dev_dbg(&pdev->dev, "clock ahb_ss acquired\n");
+
+	/* Enable the clocks */
+	err = clk_prepare_enable(ss->busclk);
+	if (err != 0) {
+		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
+		return err;
+	}
+	err = clk_prepare_enable(ss->ssclk);
+	if (err != 0) {
+		dev_err(&pdev->dev, "Cannot prepare_enable ssclk\n");
+		clk_disable_unprepare(ss->busclk);
+		return err;
+	}
+
+	/* Check that clock have the correct rates gived in the datasheet */
+	/* Try to set the clock to the maximum allowed */
+	err = clk_set_rate(ss->ssclk, cr_mod);
+	if (err != 0) {
+		dev_err(&pdev->dev, "Cannot set clock rate to ssclk\n");
+		clk_disable_unprepare(ss->ssclk);
+		clk_disable_unprepare(ss->busclk);
+		return err;
+	}
+	cr = clk_get_rate(ss->busclk);
+	if (cr >= cr_ahb)
+		dev_dbg(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >= %lu)\n",
+				cr, cr / 1000000, cr_ahb);
+	else
+		dev_warn(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >= %lu)\n",
+				cr, cr / 1000000, cr_ahb);
+	cr = clk_get_rate(ss->ssclk);
+	if (cr == cr_mod)
+		dev_dbg(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <= %lu)\n",
+				cr, cr / 1000000, cr_mod);
+	else {
+		dev_warn(&pdev->dev, "Clock ss is at %lu (%lu MHz) (must be <= %lu)\n",
+				cr, cr / 1000000, cr_mod);
+	}
+
+	/* TODO Does this information could be usefull ? */
+	writel(SS_ENABLED, ss->base + SS_CTL);
+	v = readl(ss->base + SS_CTL);
+	v >>= 16;
+	v &= 0x07;
+	dev_info(&pdev->dev, "Die ID %d\n", v);
+	writel(0, ss->base + SS_CTL);
+
+	ss->dev = &pdev->dev;
+
+	mutex_init(&ss->lock);
+	mutex_init(&ss->bufin_lock);
+	mutex_init(&ss->bufout_lock);
+	ss_is_init = 1;
+	return 0;
+}
+
+/* No need to check is some sub module is loaded,
+ * since they need the ss structure symbol */
+static int __exit sunxi_ss_remove(struct platform_device *pdev)
+{
+	if (!pdev->dev.of_node)
+		return 0;
+
+	if (ss->buf_in != NULL)
+		kfree(ss->buf_in);
+	if (ss->buf_out != NULL)
+		kfree(ss->buf_out);
+
+	writel(0, ss->base + SS_CTL);
+	clk_disable_unprepare(ss->busclk);
+	clk_disable_unprepare(ss->ssclk);
+	ss_is_init = 0;
+	return 0;
+}
+
+/*============================================================================*/
+/*============================================================================*/
+static const struct of_device_id a20ss_crypto_of_match_table[] = {
+	{ .compatible = "allwinner,sun7i-a20-crypto" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, a20ss_crypto_of_match_table);
+
+static struct platform_driver sunxi_ss_driver = {
+	.probe          = sunxi_ss_probe,
+	.remove         = __exit_p(sunxi_ss_remove),
+	.driver         = {
+		.owner          = THIS_MODULE,
+		.name           = "sunxi-ss",
+		.of_match_table	= a20ss_crypto_of_match_table,
+	},
+};
+
+module_platform_driver(sunxi_ss_driver);
+
+MODULE_DESCRIPTION("Allwinner Security System cryptographic accelerator");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie@gmail.com>");
diff --git a/drivers/crypto/sunxi-ss/sunxi-ss.h b/drivers/crypto/sunxi-ss/sunxi-ss.h
new file mode 100644
index 0000000..cac6560
--- /dev/null
+++ b/drivers/crypto/sunxi-ss/sunxi-ss.h
@@ -0,0 +1,161 @@
+/*
+ * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A20 SoC
+ *
+ * Copyright (C) 2013-2014 Corentin LABBE <clabbe.montjoie@gmail.com>
+ *
+ * Support AES cipher with 128,192,256 bits keysize.
+ * Support MD5 and SHA1 hash algorithms.
+ * Support DES and 3DES
+ * Support PRNG
+ *
+ * You could find the datasheet at
+ * http://dl.linux-sunxi.org/A20/A20%20User%20Manual%202013-03-22.pdf
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License
+ */
+
+#include <linux/clk.h>
+#include <linux/crypto.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <crypto/scatterwalk.h>
+#include <linux/scatterlist.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <crypto/md5.h>
+#include <crypto/sha.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include <crypto/aes.h>
+#include <crypto/des.h>
+
+#define SS_CTL            0x00
+#define SS_KEY0           0x04
+#define SS_KEY1           0x08
+#define SS_KEY2           0x0C
+#define SS_KEY3           0x10
+#define SS_KEY4           0x14
+#define SS_KEY5           0x18
+#define SS_KEY6           0x1C
+#define SS_KEY7           0x20
+
+#define SS_IV0            0x24
+#define SS_IV1            0x28
+#define SS_IV2            0x2C
+#define SS_IV3            0x30
+
+#define SS_CNT0           0x34
+#define SS_CNT1           0x38
+#define SS_CNT2           0x3C
+#define SS_CNT3           0x40
+
+#define SS_FCSR           0x44
+#define SS_ICSR           0x48
+
+#define SS_MD0            0x4C
+#define SS_MD1            0x50
+#define SS_MD2            0x54
+#define SS_MD3            0x58
+#define SS_MD4            0x5C
+
+#define SS_RXFIFO         0x200
+#define SS_TXFIFO         0x204
+
+/* SS_CTL configuration values */
+
+/* PRNG generator mode - bit 15 */
+#define SS_PRNG_ONESHOT		(0 << 15)
+#define SS_PRNG_CONTINUE	(1 << 15)
+
+/* SS operation mode - bits 12-13 */
+#define SS_ECB			(0 << 12)
+#define SS_CBC			(1 << 12)
+#define SS_CNT			(2 << 12)
+
+/* Counter width for CNT mode - bits 10-11 */
+#define SS_CNT_16BITS		(0 << 10)
+#define SS_CNT_32BITS		(1 << 10)
+#define SS_CNT_64BITS		(2 << 10)
+
+/* Key size for AES - bits 8-9 */
+#define SS_AES_128BITS		(0 << 8)
+#define SS_AES_192BITS		(1 << 8)
+#define SS_AES_256BITS		(2 << 8)
+
+/* Operation direction - bit 7 */
+#define SS_ENCRYPTION		(0 << 7)
+#define SS_DECRYPTION		(1 << 7)
+
+/* SS Method - bits 4-6 */
+#define SS_OP_AES		(0 << 4)
+#define SS_OP_DES		(1 << 4)
+#define SS_OP_3DES		(2 << 4)
+#define SS_OP_SHA1		(3 << 4)
+#define SS_OP_MD5		(4 << 4)
+#define SS_OP_PRNG		(5 << 4)
+
+/* Data end bit - bit 2 */
+#define SS_DATA_END		(1 << 2)
+
+/* PRNG start bit - bit 1 */
+#define SS_PRNG_START		(1 << 1)
+
+/* SS Enable bit - bit 0 */
+#define SS_DISABLED		(0 << 0)
+#define SS_ENABLED		(1 << 0)
+
+/* SS_FCSR configuration values */
+/* RX FIFO status - bit 30 */
+#define SS_RXFIFO_FREE		(1 << 30)
+
+/* RX FIFO empty spaces - bits 24-29 */
+#define SS_RXFIFO_SPACES(val)	(((val) >> 24) & 0x3f)
+
+/* TX FIFO status - bit 22 */
+#define SS_TXFIFO_AVAILABLE	(1 << 22)
+
+/* TX FIFO available spaces - bits 16-21 */
+#define SS_TXFIFO_SPACES(val)	(((val) >> 16) & 0x3f)
+
+#define SS_RXFIFO_EMP_INT_PENDING	(1 << 10)
+#define SS_TXFIFO_AVA_INT_PENDING	(1 << 8)
+#define SS_RXFIFO_EMP_INT_ENABLE	(1 << 2)
+#define SS_TXFIFO_AVA_INT_ENABLE	(1 << 0)
+
+/* SS_ICSR configuration values */
+#define SS_ICS_DRQ_ENABLE		(1 << 4)
+
+struct sunxi_ss_ctx {
+	void __iomem *base;
+	int irq;
+	struct clk *busclk;
+	struct clk *ssclk;
+	struct device *dev;
+	struct resource *res;
+	void *buf_in; /* pointer to data to be uploaded to the device */
+	size_t buf_in_size; /* size of buf_in */
+	void *buf_out;
+	size_t buf_out_size;
+	struct mutex lock; /* control the use of the device */
+	struct mutex bufout_lock; /* control the use of buf_out*/
+	struct mutex bufin_lock; /* control the sue of buf_in*/
+};
+
+struct sunxi_req_ctx {
+	u8 key[AES_MAX_KEY_SIZE * 8];
+	u32 keylen;
+	u32 mode;
+	u64 byte_count; /* number of bytes "uploaded" to the device */
+	u32 waitbuf; /* a partial word waiting to be completed and
+			uploaded to the device */
+	/* number of bytes to be uploaded in the waitbuf word */
+	unsigned int nbwait;
+};
+
+int sunxi_ss_aes_init(void);
+
-- 
1.8.5.5

