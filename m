Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3KLRqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:46:55 -0500
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:56628
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755238Ab3KLRqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:46:49 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h1155h)
X-WSS-ID: 0MW5W02-08-5GB-02
X-M-MSG: 
Subject: [PATCH 07/10] crypto: CCP XTS-AES crypto API support
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <herbert@gondor.hengli.com.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 11:46:40 -0600
Message-ID: <20131112174639.19746.17835.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
References: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These routines provide crypto API support for the XTS-AES mode of AES
on the AMD CCP.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c |  285 +++++++++++++++++++++++++++++++
 1 file changed, 285 insertions(+)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-xts.c

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
new file mode 100644
index 0000000..d100b48
--- /dev/null
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -0,0 +1,285 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) AES XTS crypto API support
+ *
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/scatterlist.h>
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/scatterwalk.h>
+
+#include "ccp-crypto.h"
+
+
+struct ccp_aes_xts_def {
+	const char *name;
+	const char *drv_name;
+};
+
+static struct ccp_aes_xts_def aes_xts_algs[] = {
+	{
+		.name		= "xts(aes)",
+		.drv_name	= "xts-aes-ccp",
+	},
+};
+
+struct ccp_unit_size_map {
+	unsigned int size;
+	u32 value;
+};
+
+static struct ccp_unit_size_map unit_size_map[] = {
+	{
+		.size	= 4096,
+		.value	= CCP_XTS_AES_UNIT_SIZE_4096,
+	},
+	{
+		.size	= 2048,
+		.value	= CCP_XTS_AES_UNIT_SIZE_2048,
+	},
+	{
+		.size	= 1024,
+		.value	= CCP_XTS_AES_UNIT_SIZE_1024,
+	},
+	{
+		.size	= 512,
+		.value	= CCP_XTS_AES_UNIT_SIZE_512,
+	},
+	{
+		.size	= 256,
+		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
+	},
+	{
+		.size	= 128,
+		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
+	},
+	{
+		.size	= 64,
+		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
+	},
+	{
+		.size	= 32,
+		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
+	},
+	{
+		.size	= 16,
+		.value	= CCP_XTS_AES_UNIT_SIZE_16,
+	},
+	{
+		.size	= 1,
+		.value	= CCP_XTS_AES_UNIT_SIZE__LAST,
+	},
+};
+
+static int ccp_aes_xts_complete(struct crypto_async_request *async_req, int ret)
+{
+	struct ablkcipher_request *req = ablkcipher_request_cast(async_req);
+	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
+
+	if (ret)
+		return ret;
+
+	memcpy(req->info, rctx->iv, AES_BLOCK_SIZE);
+
+	return 0;
+}
+
+static int ccp_aes_xts_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+			      unsigned int key_len)
+{
+	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ablkcipher_tfm(tfm));
+
+	/* Only support 128-bit AES key with a 128-bit Tweak key,
+	 * otherwise use the fallback
+	 */
+	switch (key_len) {
+	case AES_KEYSIZE_128 * 2:
+		memcpy(ctx->u.aes.key, key, key_len);
+		break;
+	}
+	ctx->u.aes.key_len = key_len / 2;
+	sg_init_one(&ctx->u.aes.key_sg, ctx->u.aes.key, key_len);
+
+	return crypto_ablkcipher_setkey(ctx->u.aes.tfm_ablkcipher, key,
+					key_len);
+}
+
+static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
+			     unsigned int encrypt)
+{
+	struct crypto_tfm *tfm =
+		crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
+	struct ccp_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct ccp_aes_req_ctx *rctx = ablkcipher_request_ctx(req);
+	unsigned int unit;
+	int ret;
+
+	if (!ctx->u.aes.key_len) {
+		pr_err("AES key not set\n");
+		return -EINVAL;
+	}
+
+	if (req->nbytes & (AES_BLOCK_SIZE - 1)) {
+		pr_err("AES request size is not a multiple of the block size\n");
+		return -EINVAL;
+	}
+
+	if (!req->info) {
+		pr_err("AES IV not supplied");
+		return -EINVAL;
+	}
+
+	for (unit = 0; unit < ARRAY_SIZE(unit_size_map); unit++)
+		if (!(req->nbytes & (unit_size_map[unit].size - 1)))
+			break;
+
+	if ((unit_size_map[unit].value == CCP_XTS_AES_UNIT_SIZE__LAST) ||
+	    (ctx->u.aes.key_len != AES_KEYSIZE_128)) {
+		/* Use the fallback to process the request for any
+		 * unsupported unit sizes or key sizes
+		 */
+		ablkcipher_request_set_tfm(req, ctx->u.aes.tfm_ablkcipher);
+		ret = (encrypt) ? crypto_ablkcipher_encrypt(req) :
+				  crypto_ablkcipher_decrypt(req);
+		ablkcipher_request_set_tfm(req, __crypto_ablkcipher_cast(tfm));
+
+		return ret;
+	}
+
+	memcpy(rctx->iv, req->info, AES_BLOCK_SIZE);
+	sg_init_one(&rctx->iv_sg, rctx->iv, AES_BLOCK_SIZE);
+
+	memset(&rctx->cmd, 0, sizeof(rctx->cmd));
+	INIT_LIST_HEAD(&rctx->cmd.entry);
+	rctx->cmd.engine = CCP_ENGINE_XTS_AES_128;
+	rctx->cmd.u.xts.action = (encrypt) ? CCP_AES_ACTION_ENCRYPT
+					   : CCP_AES_ACTION_DECRYPT;
+	rctx->cmd.u.xts.unit_size = unit_size_map[unit].value;
+	rctx->cmd.u.xts.key = &ctx->u.aes.key_sg;
+	rctx->cmd.u.xts.key_len = ctx->u.aes.key_len;
+	rctx->cmd.u.xts.iv = &rctx->iv_sg;
+	rctx->cmd.u.xts.iv_len = AES_BLOCK_SIZE;
+	rctx->cmd.u.xts.src = req->src;
+	rctx->cmd.u.xts.src_len = req->nbytes;
+	rctx->cmd.u.xts.dst = req->dst;
+
+	ret = ccp_crypto_enqueue_request(&req->base, &rctx->cmd);
+
+	return ret;
+}
+
+static int ccp_aes_xts_encrypt(struct ablkcipher_request *req)
+{
+	return ccp_aes_xts_crypt(req, 1);
+}
+
+static int ccp_aes_xts_decrypt(struct ablkcipher_request *req)
+{
+	return ccp_aes_xts_crypt(req, 0);
+}
+
+static int ccp_aes_xts_cra_init(struct crypto_tfm *tfm)
+{
+	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_ablkcipher *fallback_tfm;
+
+	ctx->complete = ccp_aes_xts_complete;
+	ctx->u.aes.key_len = 0;
+
+	fallback_tfm = crypto_alloc_ablkcipher(tfm->__crt_alg->cra_name, 0,
+					       CRYPTO_ALG_ASYNC |
+					       CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(fallback_tfm)) {
+		pr_warn("could not load fallback driver %s\n",
+			tfm->__crt_alg->cra_name);
+		return PTR_ERR(fallback_tfm);
+	}
+	ctx->u.aes.tfm_ablkcipher = fallback_tfm;
+
+	tfm->crt_ablkcipher.reqsize = sizeof(struct ccp_aes_req_ctx) +
+				      fallback_tfm->base.crt_ablkcipher.reqsize;
+
+	return 0;
+}
+
+static void ccp_aes_xts_cra_exit(struct crypto_tfm *tfm)
+{
+	struct ccp_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (ctx->u.aes.tfm_ablkcipher)
+		crypto_free_ablkcipher(ctx->u.aes.tfm_ablkcipher);
+	ctx->u.aes.tfm_ablkcipher = NULL;
+}
+
+
+static int ccp_register_aes_xts_alg(struct list_head *head,
+				    const struct ccp_aes_xts_def *def)
+{
+	struct ccp_crypto_ablkcipher_alg *ccp_alg;
+	struct crypto_alg *alg;
+	int ret;
+
+	ccp_alg = kzalloc(sizeof(*ccp_alg), GFP_KERNEL);
+	if (!ccp_alg)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&ccp_alg->entry);
+
+	alg = &ccp_alg->alg;
+
+	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", def->name);
+	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
+		 def->drv_name);
+	alg->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC |
+			 CRYPTO_ALG_KERN_DRIVER_ONLY |
+			 CRYPTO_ALG_NEED_FALLBACK;
+	alg->cra_blocksize = AES_BLOCK_SIZE;
+	alg->cra_ctxsize = sizeof(struct ccp_ctx);
+	alg->cra_priority = CCP_CRA_PRIORITY;
+	alg->cra_type = &crypto_ablkcipher_type;
+	alg->cra_ablkcipher.setkey = ccp_aes_xts_setkey;
+	alg->cra_ablkcipher.encrypt = ccp_aes_xts_encrypt;
+	alg->cra_ablkcipher.decrypt = ccp_aes_xts_decrypt;
+	alg->cra_ablkcipher.min_keysize = AES_MIN_KEY_SIZE * 2;
+	alg->cra_ablkcipher.max_keysize = AES_MAX_KEY_SIZE * 2;
+	alg->cra_ablkcipher.ivsize = AES_BLOCK_SIZE;
+	alg->cra_init = ccp_aes_xts_cra_init;
+	alg->cra_exit = ccp_aes_xts_cra_exit;
+	alg->cra_module = THIS_MODULE;
+
+	ret = crypto_register_alg(alg);
+	if (ret) {
+		pr_err("%s ablkcipher algorithm registration error (%d)\n",
+			alg->cra_name, ret);
+		kfree(ccp_alg);
+		return ret;
+	}
+
+	list_add(&ccp_alg->entry, head);
+
+	return 0;
+}
+
+int ccp_register_aes_xts_algs(struct list_head *head)
+{
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(aes_xts_algs); i++) {
+		ret = ccp_register_aes_xts_alg(head, &aes_xts_algs[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}


