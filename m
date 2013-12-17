Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3LQSOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:14:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60871 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab3LQSOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 035/103] crypto: s390 - Fix aes-xts parameter corruption
Date: Tue, 17 Dec 2013 18:12:24 +0000
Message-Id: <1387304012-23805-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

commit 9dda2769af4f3f3093434648c409bb351120d9e8 upstream.

Some s390 crypto algorithms incorrectly use the crypto_tfm structure to
store private data. As the tfm can be shared among multiple threads, this
can result in data corruption.

This patch fixes aes-xts by moving the xts and pcc parameter blocks from
the tfm onto the stack (48 + 96 bytes).

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/crypto/aes_s390.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index a6e37d4..f3000a4 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -55,8 +55,7 @@ struct pcc_param {
 
 struct s390_xts_ctx {
 	u8 key[32];
-	u8 xts_param[16];
-	struct pcc_param pcc;
+	u8 pcc_key[32];
 	long enc;
 	long dec;
 	int key_len;
@@ -594,7 +593,7 @@ static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		xts_ctx->enc = KM_XTS_128_ENCRYPT;
 		xts_ctx->dec = KM_XTS_128_DECRYPT;
 		memcpy(xts_ctx->key + 16, in_key, 16);
-		memcpy(xts_ctx->pcc.key + 16, in_key + 16, 16);
+		memcpy(xts_ctx->pcc_key + 16, in_key + 16, 16);
 		break;
 	case 48:
 		xts_ctx->enc = 0;
@@ -605,7 +604,7 @@ static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		xts_ctx->enc = KM_XTS_256_ENCRYPT;
 		xts_ctx->dec = KM_XTS_256_DECRYPT;
 		memcpy(xts_ctx->key, in_key, 32);
-		memcpy(xts_ctx->pcc.key, in_key + 32, 32);
+		memcpy(xts_ctx->pcc_key, in_key + 32, 32);
 		break;
 	default:
 		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
@@ -624,29 +623,33 @@ static int xts_aes_crypt(struct blkcipher_desc *desc, long func,
 	unsigned int nbytes = walk->nbytes;
 	unsigned int n;
 	u8 *in, *out;
-	void *param;
+	struct pcc_param pcc_param;
+	struct {
+		u8 key[32];
+		u8 init[16];
+	} xts_param;
 
 	if (!nbytes)
 		goto out;
 
-	memset(xts_ctx->pcc.block, 0, sizeof(xts_ctx->pcc.block));
-	memset(xts_ctx->pcc.bit, 0, sizeof(xts_ctx->pcc.bit));
-	memset(xts_ctx->pcc.xts, 0, sizeof(xts_ctx->pcc.xts));
-	memcpy(xts_ctx->pcc.tweak, walk->iv, sizeof(xts_ctx->pcc.tweak));
-	param = xts_ctx->pcc.key + offset;
-	ret = crypt_s390_pcc(func, param);
+	memset(pcc_param.block, 0, sizeof(pcc_param.block));
+	memset(pcc_param.bit, 0, sizeof(pcc_param.bit));
+	memset(pcc_param.xts, 0, sizeof(pcc_param.xts));
+	memcpy(pcc_param.tweak, walk->iv, sizeof(pcc_param.tweak));
+	memcpy(pcc_param.key, xts_ctx->pcc_key, 32);
+	ret = crypt_s390_pcc(func, &pcc_param.key[offset]);
 	if (ret < 0)
 		return -EIO;
 
-	memcpy(xts_ctx->xts_param, xts_ctx->pcc.xts, 16);
-	param = xts_ctx->key + offset;
+	memcpy(xts_param.key, xts_ctx->key, 32);
+	memcpy(xts_param.init, pcc_param.xts, 16);
 	do {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 
-		ret = crypt_s390_km(func, param, out, in, n);
+		ret = crypt_s390_km(func, &xts_param.key[offset], out, in, n);
 		if (ret < 0 || ret != n)
 			return -EIO;
 
-- 
1.8.3.2

