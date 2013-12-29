Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3L2Ca2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:30:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55387 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715Ab3L2CKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:50 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Herbert Xu" <herbert@gondor.apana.org.au>,
        "Gerald Schaefer" <gerald.schaefer@de.ibm.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.846943219@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 106/185] crypto: s390 - Fix aes-xts parameter corruption
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/crypto/aes_s390.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

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
@@ -592,7 +591,7 @@ static int xts_aes_set_key(struct crypto
 		xts_ctx->enc = KM_XTS_128_ENCRYPT;
 		xts_ctx->dec = KM_XTS_128_DECRYPT;
 		memcpy(xts_ctx->key + 16, in_key, 16);
-		memcpy(xts_ctx->pcc.key + 16, in_key + 16, 16);
+		memcpy(xts_ctx->pcc_key + 16, in_key + 16, 16);
 		break;
 	case 48:
 		xts_ctx->enc = 0;
@@ -603,7 +602,7 @@ static int xts_aes_set_key(struct crypto
 		xts_ctx->enc = KM_XTS_256_ENCRYPT;
 		xts_ctx->dec = KM_XTS_256_DECRYPT;
 		memcpy(xts_ctx->key, in_key, 32);
-		memcpy(xts_ctx->pcc.key, in_key + 32, 32);
+		memcpy(xts_ctx->pcc_key, in_key + 32, 32);
 		break;
 	default:
 		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
@@ -622,28 +621,32 @@ static int xts_aes_crypt(struct blkciphe
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
 	BUG_ON(ret < 0);
 
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
 		BUG_ON(ret < 0 || ret != n);
 
 		nbytes &= AES_BLOCK_SIZE - 1;

