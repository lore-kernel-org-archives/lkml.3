Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaDCQXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:23:12 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56198 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbaDCQXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:23:07 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 6/9] crypto: qce: Adds infrastructure to setup the crypto block
Date: Thu,  3 Apr 2014 19:18:03 +0300
Message-Id: <1396541886-10966-7-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are functions used to setup/prepare hardware registers for
all algorithms supported by the crypto block. It also exports
few helper functions needed by algorithms:
	- to check hardware status
	- to start crypto hardware
	- to translate data stream to big endian form

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/crypto/qce/common.c | 424 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/qce/common.h | 111 ++++++++++++
 2 files changed, 535 insertions(+)
 create mode 100644 drivers/crypto/qce/common.c
 create mode 100644 drivers/crypto/qce/common.h

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
new file mode 100644
index 000000000000..d9f32d6fc23b
--- /dev/null
+++ b/drivers/crypto/qce/common.c
@@ -0,0 +1,424 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/types.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha.h>
+
+#include "dma.h"
+#include "core.h"
+#include "common.h"
+#include "regs-v5.h"
+#include "sha.h"
+#include "cipher.h"
+
+#define QCE_SECTOR_SIZE		512
+
+static inline u32 qce_read(struct qce_device *qce, u32 offset)
+{
+	return readl(qce->base + offset);
+}
+
+static inline void qce_write(struct qce_device *qce, u32 offset, u32 val)
+{
+	writel(val, qce->base + offset);
+}
+
+static inline void qce_write_array(struct qce_device *qce, u32 offset,
+				   const u32 *val, unsigned int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++)
+		qce_write(qce, offset + i * sizeof(u32), val[i]);
+}
+
+static inline void
+qce_clear_array(struct qce_device *qce, u32 offset, unsigned int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++)
+		qce_write(qce, offset + i * sizeof(u32), 0);
+}
+
+static u32 qce_encr_cfg(u32 flags, u32 aes_key_size)
+{
+	u32 cfg = 0;
+
+	if (IS_AES(flags)) {
+		if (aes_key_size == AES_KEYSIZE_128)
+			cfg |= ENCR_KEY_SZ_AES128 << ENCR_KEY_SZ;
+		else if (aes_key_size == AES_KEYSIZE_256)
+			cfg |= ENCR_KEY_SZ_AES256 << ENCR_KEY_SZ;
+	}
+
+	if (IS_AES(flags))
+		cfg |= ENCR_ALG_AES << ENCR_ALG;
+	else if (IS_DES(flags) || IS_3DES(flags))
+		cfg |= ENCR_ALG_DES << ENCR_ALG;
+
+	if (IS_DES(flags))
+		cfg |= ENCR_KEY_SZ_DES << ENCR_KEY_SZ;
+
+	if (IS_3DES(flags))
+		cfg |= ENCR_KEY_SZ_3DES << ENCR_KEY_SZ;
+
+	switch (flags & QCE_MODE_MASK) {
+	case QCE_MODE_ECB:
+		cfg |= ENCR_MODE_ECB << ENCR_MODE;
+		break;
+	case QCE_MODE_CBC:
+		cfg |= ENCR_MODE_CBC << ENCR_MODE;
+		break;
+	case QCE_MODE_CTR:
+		cfg |= ENCR_MODE_CTR << ENCR_MODE;
+		break;
+	case QCE_MODE_XTS:
+		cfg |= ENCR_MODE_XTS << ENCR_MODE;
+		break;
+	case QCE_MODE_CCM:
+		cfg |= ENCR_MODE_CCM << ENCR_MODE;
+		cfg |= LAST_CCM_XFR << LAST_CCM;
+		break;
+	default:
+		return ~0;
+	}
+
+	return cfg;
+}
+
+static u32 qce_auth_cfg(u32 flags, u32 key_size)
+{
+	u32 cfg = 0;
+
+	if (IS_AES(flags) && (IS_CCM(flags) || IS_CMAC(flags)))
+		cfg |= AUTH_ALG_AES << AUTH_ALG;
+	else
+		cfg |= AUTH_ALG_SHA << AUTH_ALG;
+
+	if (IS_CCM(flags) || IS_CMAC(flags)) {
+		if (key_size == AES_KEYSIZE_128)
+			cfg |= AUTH_KEY_SZ_AES128 << AUTH_KEY_SIZE;
+		else if (key_size == AES_KEYSIZE_256)
+			cfg |= AUTH_KEY_SZ_AES256 << AUTH_KEY_SIZE;
+	}
+
+	if (IS_SHA1(flags) || IS_SHA1_HMAC(flags))
+		cfg |= AUTH_SIZE_SHA1 << AUTH_SIZE;
+	else if (IS_SHA256(flags) || IS_SHA256_HMAC(flags))
+		cfg |= AUTH_SIZE_SHA256 << AUTH_SIZE;
+	else if (IS_CMAC(flags))
+		cfg |= AUTH_SIZE_ENUM_16_BYTES << AUTH_SIZE;
+
+	if (IS_SHA1(flags) || IS_SHA256(flags))
+		cfg |= AUTH_MODE_HASH << AUTH_MODE;
+	else if (IS_SHA1_HMAC(flags) || IS_SHA256_HMAC(flags) ||
+		 IS_CBC(flags) || IS_CTR(flags))
+		cfg |= AUTH_MODE_HMAC << AUTH_MODE;
+	else if (IS_AES(flags) && IS_CCM(flags))
+		cfg |= AUTH_MODE_CCM << AUTH_MODE;
+	else if (IS_AES(flags) && IS_CMAC(flags))
+		cfg |= AUTH_MODE_CMAC << AUTH_MODE;
+
+	if (IS_SHA(flags) || IS_SHA_HMAC(flags))
+		cfg |= AUTH_POS_BEFORE << AUTH_POS;
+
+	if (IS_CCM(flags))
+		cfg |= QCE_MAX_NONCE_WORDS << AUTH_NONCE_NUM_WORDS;
+
+	if (IS_CBC(flags) || IS_CTR(flags) || IS_CCM(flags) ||
+	    IS_CMAC(flags))
+		cfg |= BIT(AUTH_LAST) | BIT(AUTH_FIRST);
+
+	return cfg;
+}
+
+static u32 qce_config_reg(struct qce_device *qce, int little)
+{
+	u32 beats = (qce->burst_size >> 3) - 1;
+	u32 pipe_pair = qce->pipe_pair_index;
+	u32 config;
+
+	config = beats << REQ_SIZE | BIT(MASK_DOUT_INTR) | BIT(MASK_DIN_INTR) |
+		 BIT(MASK_OP_DONE_INTR) | BIT(MASK_ERR_INTR) |
+		 pipe_pair << PIPE_SET_SELECT;
+	config &= ~HIGH_SPD_EN_N;
+
+	if (little)
+		config |= LITTLE_ENDIAN_MASK;
+
+	return config;
+}
+
+void qce_cpu_to_be32p_array(__be32 *dst, const u8 *src, unsigned int len)
+{
+	__be32 *d = dst;
+	const u8 *s = src;
+	unsigned int n;
+
+	n = len / sizeof(u32);
+	for (; n > 0; n--) {
+		*d = cpu_to_be32p((const __u32 *) s);
+		s += sizeof(__u32);
+		d++;
+	}
+}
+
+static void qce_xts_swapiv(u32 *dst, u8 *src, unsigned int ivsize)
+{
+	u8 swap[QCE_AES_IV_LENGTH];
+	u32 i, j;
+
+	if (ivsize > QCE_AES_IV_LENGTH)
+		return;
+
+	memset(swap, 0, QCE_AES_IV_LENGTH);
+
+	for (i = (QCE_AES_IV_LENGTH - ivsize), j = ivsize - 1;
+	     i < QCE_AES_IV_LENGTH; i++, j--)
+		swap[i] = src[j];
+
+	qce_cpu_to_be32p_array(dst, swap, QCE_AES_IV_LENGTH);
+}
+
+static void qce_xtskey(struct qce_device *qce, const u8 *enckey,
+		       unsigned int enckeylen, unsigned int cryptlen)
+{
+	u32 xtskey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(u32)] = {0};
+	unsigned int xtsklen = enckeylen / (2 * sizeof(u32));
+	unsigned int xtsdusize;
+
+	qce_cpu_to_be32p_array(xtskey, enckey + enckeylen / 2, enckeylen / 2);
+	qce_write_array(qce, REG_ENCR_XTS_KEY0, xtskey, xtsklen);
+
+	/* xts du size 512B */
+	xtsdusize = min_t(u32, QCE_SECTOR_SIZE, cryptlen);
+	qce_write(qce, REG_ENCR_XTS_DU_SIZE, xtsdusize);
+}
+
+static void qce_setup_config(struct qce_device *qce)
+{
+	u32 config;
+
+	/* get big endianness */
+	config = qce_config_reg(qce, 0);
+
+	/* clear status */
+	qce_write(qce, REG_STATUS, 0);
+	qce_write(qce, REG_CONFIG, config);
+}
+
+static inline void qce_crypto_go(struct qce_device *qce)
+{
+	/* issue GO to crypto */
+	qce_write(qce, REG_GOPROC, BIT(GO) | BIT(RESULTS_DUMP));
+}
+
+static int qce_setup_regs_ahash(struct crypto_async_request *async_req,
+				u32 totallen, u32 offset)
+{
+	struct ahash_request *req = ahash_request_cast(async_req);
+	struct crypto_ahash *ahash = __crypto_ahash_cast(req->base.tfm);
+	struct qce_sha_reqctx *rctx = ahash_request_ctx(req);
+	struct qce_alg_template *tmpl = to_ahash_tmpl(async_req->tfm);
+	struct qce_device *qce = tmpl->qce;
+	unsigned int digestsize = crypto_ahash_digestsize(ahash);
+	u32 auth[SHA256_DIGEST_SIZE / sizeof(u32)] = {0};
+	u32 mackey[QCE_SHA_HMAC_KEY_SIZE / sizeof(u32)] = {0};
+	u32 auth_cfg = 0, config;
+	unsigned int iv_words;
+
+	qce_setup_config(qce);
+
+	if (IS_CMAC(rctx->flags)) {
+		qce_write(qce, REG_AUTH_SEG_CFG, 0);
+		qce_write(qce, REG_ENCR_SEG_CFG, 0);
+		qce_write(qce, REG_ENCR_SEG_SIZE, 0);
+		qce_clear_array(qce, REG_AUTH_IV0, 16);
+		qce_clear_array(qce, REG_AUTH_KEY0, 16);
+		qce_clear_array(qce, REG_AUTH_BYTECNT0, 4);
+
+		auth_cfg = qce_auth_cfg(rctx->flags, rctx->authklen);
+	}
+
+	if (IS_SHA_HMAC(rctx->flags) || IS_CMAC(rctx->flags)) {
+		u32 authkey_words = rctx->authklen / sizeof(u32);
+
+		qce_cpu_to_be32p_array(mackey, rctx->authkey, rctx->authklen);
+		qce_write_array(qce, REG_AUTH_KEY0, mackey, authkey_words);
+	}
+
+	if (IS_CMAC(rctx->flags))
+		goto go_proc;
+
+	/* if not the last, the size has to be on the block boundary */
+	if (rctx->last_blk == false && (req->nbytes % SHA256_BLOCK_SIZE))
+		return -EINVAL;
+
+	/* write 20/32 bytes, 5/8 words into auth_iv for SHA1/SHA256 */
+	if (rctx->first_blk)
+		memcpy(auth, rctx->digest, digestsize);
+	else
+		qce_cpu_to_be32p_array(auth, rctx->digest, digestsize);
+
+	iv_words = (IS_SHA1(rctx->flags) || IS_SHA1_HMAC(rctx->flags)) ? 5 : 8;
+	qce_write_array(qce, REG_AUTH_IV0, auth, iv_words);
+
+	/* write AUTH_BYTECNT 0/1, start with 0 */
+	qce_write_array(qce, REG_AUTH_BYTECNT0, rctx->byte_count, 2);
+
+	auth_cfg = qce_auth_cfg(rctx->flags, 0);
+
+	/* set/reset last bit in AUTH_SEG_CFG register */
+	if (rctx->last_blk)
+		auth_cfg |= BIT(AUTH_LAST);
+	else
+		auth_cfg &= ~BIT(AUTH_LAST);
+
+	if (rctx->first_blk)
+		auth_cfg |= BIT(AUTH_FIRST);
+	else
+		auth_cfg &= ~BIT(AUTH_FIRST);
+
+go_proc:
+	/* get little endianness */
+	config = qce_config_reg(qce, 1);
+
+	qce_write(qce, REG_AUTH_SEG_CFG, auth_cfg);
+	qce_write(qce, REG_AUTH_SEG_SIZE, req->nbytes);
+	qce_write(qce, REG_AUTH_SEG_START, 0);
+	qce_write(qce, REG_ENCR_SEG_CFG, 0);
+	qce_write(qce, REG_SEG_SIZE, req->nbytes);
+	qce_write(qce, REG_CONFIG, config);
+
+	qce_crypto_go(qce);
+
+	return 0;
+}
+
+static int qce_setup_regs_ablkcipher(struct crypto_async_request *async_req,
+				     u32 totallen, u32 offset)
+{
+	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
+	struct qce_cipher_reqctx *rctx = ablkcipher_request_ctx(req);
+	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
+	struct qce_alg_template *tmpl = to_cipher_tmpl(async_req->tfm);
+	struct qce_device *qce = tmpl->qce;
+	u32 enckey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(u32)] = {0};
+	u32 enciv[QCE_MAX_IV_SIZE / sizeof(u32)] = {0};
+	unsigned int enckey_words, enciv_words;
+	unsigned int keylen;
+	u32 encr_cfg = 0, auth_cfg = 0, config;
+	unsigned int ivsize = rctx->ivsize;
+	u32 flags = rctx->flags;
+
+	qce_setup_config(qce);
+
+	if (IS_XTS(flags))
+		keylen = ctx->enc_keylen / 2;
+	else
+		keylen = ctx->enc_keylen;
+
+	qce_cpu_to_be32p_array(enckey, ctx->enc_key, keylen);
+	enckey_words = keylen / sizeof(u32);
+
+	qce_write(qce, REG_AUTH_SEG_CFG, auth_cfg);
+
+	encr_cfg = qce_encr_cfg(flags, keylen);
+
+	if (IS_DES(flags)) {
+		enciv_words = 2;
+		enckey_words = 2;
+	} else if (IS_3DES(flags)) {
+		enciv_words = 2;
+		enckey_words = 6;
+	} else if (IS_AES(flags)) {
+		if (IS_XTS(flags))
+			qce_xtskey(qce, ctx->enc_key, ctx->enc_keylen,
+				   rctx->cryptlen);
+		enciv_words = 4;
+	} else {
+		return -EINVAL;
+	}
+
+	qce_write_array(qce, REG_ENCR_KEY0, enckey, enckey_words);
+
+	if (!IS_ECB(flags)) {
+		if (IS_XTS(flags))
+			qce_xts_swapiv(enciv, rctx->iv, ivsize);
+		else
+			qce_cpu_to_be32p_array(enciv, rctx->iv, ivsize);
+
+		qce_write_array(qce, REG_CNTR0_IV0, enciv, enciv_words);
+	}
+
+	if (IS_ENCRYPT(flags))
+		encr_cfg |= BIT(ENCODE);
+
+	qce_write(qce, REG_ENCR_SEG_CFG, encr_cfg);
+	qce_write(qce, REG_ENCR_SEG_SIZE, rctx->cryptlen);
+
+	/* get little endianness */
+	config = qce_config_reg(qce, 1);
+
+	qce_write(qce, REG_ENCR_SEG_START, offset & 0xffff);
+	qce_write(qce, REG_CNTR_MASK, 0xffffffff);
+	qce_write(qce, REG_SEG_SIZE, totallen);
+	qce_write(qce, REG_CONFIG, config);
+
+	qce_crypto_go(qce);
+
+	return 0;
+}
+
+int qce_start(struct crypto_async_request *async_req, u32 type, u32 totallen,
+	      u32 offset)
+{
+	int rc;
+
+	switch (type) {
+	case CRYPTO_ALG_TYPE_ABLKCIPHER:
+		rc = qce_setup_regs_ablkcipher(async_req, totallen, offset);
+		break;
+	case CRYPTO_ALG_TYPE_AHASH:
+		rc = qce_setup_regs_ahash(async_req, totallen, offset);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return rc;
+}
+
+#define STATUS_ERRORS	(BIT(SW_ERR) | BIT(AXI_ERR) | BIT(HSD_ERR))
+
+int qce_check_status(struct qce_device *qce, u32 *status)
+{
+	int rc = 0;
+
+	*status = qce_read(qce, REG_STATUS);
+
+	/*
+	 * Don't use result dump status. The operation may not be complete.
+	 * Instead, use the status we just read from device. In case, we need to
+	 * use result_status from result dump the result_status needs to be byte
+	 * swapped, since we set the device to little endian.
+	 */
+	if (*status & STATUS_ERRORS || !(*status & BIT(OPERATION_DONE)))
+		rc = -ENXIO;
+
+	return rc;
+}
diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
new file mode 100644
index 000000000000..69ab21d02c6e
--- /dev/null
+++ b/drivers/crypto/qce/common.h
@@ -0,0 +1,111 @@
+/*
+ * Copyright (c) 2010-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _COMMON_H_
+#define _COMMON_H_
+
+#include <linux/crypto.h>
+#include <linux/types.h>
+#include <crypto/aes.h>
+#include <crypto/des.h>
+#include <crypto/hash.h>
+
+/* key size in bytes */
+#define QCE_SHA_HMAC_KEY_SIZE		64
+#define QCE_DES_KEY_SIZE		DES_KEY_SIZE
+#define QCE_MAX_CIPHER_KEY_SIZE		AES_KEYSIZE_256
+#define QCE_MAX_KEY_SIZE		64
+
+/* IV length in bytes */
+#define QCE_AES_IV_LENGTH		AES_BLOCK_SIZE
+/* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
+#define QCE_MAX_IV_SIZE			AES_BLOCK_SIZE
+
+/* maximum nonce bytes  */
+#define QCE_MAX_NONCE			16
+#define QCE_MAX_NONCE_WORDS		(QCE_MAX_NONCE / sizeof(u32))
+
+/* burst size alignment requirement */
+#define QCE_MAX_ALIGN_SIZE		64
+
+/* maximum data transfer block size between BAM and CE */
+#define QCE_BAM_BURST_SIZE		64
+
+/* cipher algorithms */
+#define QCE_ALG_DES			BIT(0)
+#define QCE_ALG_3DES			BIT(1)
+#define QCE_ALG_AES			BIT(2)
+
+/* hash and hmac algorithms */
+#define QCE_HASH_SHA1			BIT(3)
+#define QCE_HASH_SHA256			BIT(4)
+#define QCE_HASH_SHA1_HMAC		BIT(5)
+#define QCE_HASH_SHA256_HMAC		BIT(6)
+#define QCE_HASH_AES_CMAC		BIT(7)
+
+/* cipher modes */
+#define QCE_MODE_CBC			BIT(8)
+#define QCE_MODE_ECB			BIT(9)
+#define QCE_MODE_CTR			BIT(10)
+#define QCE_MODE_XTS			BIT(11)
+#define QCE_MODE_CCM			BIT(12)
+#define QCE_MODE_MASK			0x1f00
+
+/* cipher encryption/decryption operations */
+#define QCE_ENCRYPT			BIT(13)
+#define QCE_DECRYPT			BIT(14)
+
+#define IS_DES(flags)			(flags & QCE_ALG_DES)
+#define IS_3DES(flags)			(flags & QCE_ALG_3DES)
+#define IS_AES(flags)			(flags & QCE_ALG_AES)
+
+#define IS_SHA1(flags)			(flags & QCE_HASH_SHA1)
+#define IS_SHA256(flags)		(flags & QCE_HASH_SHA256)
+#define IS_SHA1_HMAC(flags)		(flags & QCE_HASH_SHA1_HMAC)
+#define IS_SHA256_HMAC(flags)		(flags & QCE_HASH_SHA256_HMAC)
+#define IS_CMAC(flags)			(flags & QCE_HASH_AES_CMAC)
+#define IS_SHA(flags)			(IS_SHA1(flags) || IS_SHA256(flags))
+#define IS_SHA_HMAC(flags)		\
+		(IS_SHA1_HMAC(flags) || IS_SHA256_HMAC(flags))
+
+#define IS_CBC(mode)			(mode & QCE_MODE_CBC)
+#define IS_ECB(mode)			(mode & QCE_MODE_ECB)
+#define IS_CTR(mode)			(mode & QCE_MODE_CTR)
+#define IS_XTS(mode)			(mode & QCE_MODE_XTS)
+#define IS_CCM(mode)			(mode & QCE_MODE_CCM)
+
+#define IS_ENCRYPT(dir)			(dir & QCE_ENCRYPT)
+#define IS_DECRYPT(dir)			(dir & QCE_DECRYPT)
+
+struct qce_alg_template {
+	struct list_head entry;
+	u32 crypto_alg_type;
+	u32 alg_flags;
+	const __be32 *std_iv;
+	union {
+		struct crypto_alg crypto;
+		struct ahash_alg ahash;
+	} alg;
+	struct qce_device *qce;
+
+	int (*async_req_queue)(struct qce_device *qce,
+			       struct crypto_async_request *req);
+	void (*async_req_done)(struct qce_device *qce, int ret);
+};
+
+void qce_cpu_to_be32p_array(__be32 *dst, const u8 *src, unsigned int len);
+int qce_check_status(struct qce_device *qce, u32 *status);
+int qce_start(struct crypto_async_request *async_req, u32 type, u32 totallen,
+	      u32 offset);
+
+#endif /* _COMMON_H_ */
-- 
1.8.4.4

