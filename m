Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab3LQShU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:37:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60867 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3LQSO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Glauber <jang@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 034/103] s390/crypto: Don't panic after crypto instruction failures
Date: Tue, 17 Dec 2013 18:12:23 +0000
Message-Id: <1387304012-23805-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Glauber <jang@linux.vnet.ibm.com>

commit 36eb2caa7bace31b7868a57f77cb148e58d1c9f9 upstream.

Remove the BUG_ON's that check for failure or incomplete
results of the s390 hardware crypto instructions.
Rather report the errors as -EIO to the crypto layer.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
[ luis: 3.5.y prereq for:
  - 9dda276 crypto: s390 - Fix aes-xts parameter corruption ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/crypto/aes_s390.c   | 18 ++++++++++++------
 arch/s390/crypto/des_s390.c   | 12 ++++++++----
 arch/s390/crypto/ghash_s390.c | 21 +++++++++++++--------
 arch/s390/crypto/sha_common.c |  9 ++++++---
 4 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 6522bb7..a6e37d4 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -325,7 +325,8 @@ static int ecb_aes_crypt(struct blkcipher_desc *desc, long func, void *param,
 		u8 *in = walk->src.virt.addr;
 
 		ret = crypt_s390_km(func, param, out, in, n);
-		BUG_ON((ret < 0) || (ret != n));
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= AES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -464,7 +465,8 @@ static int cbc_aes_crypt(struct blkcipher_desc *desc, long func,
 		u8 *in = walk->src.virt.addr;
 
 		ret = crypt_s390_kmc(func, &param, out, in, n);
-		BUG_ON((ret < 0) || (ret != n));
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= AES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -633,7 +635,8 @@ static int xts_aes_crypt(struct blkcipher_desc *desc, long func,
 	memcpy(xts_ctx->pcc.tweak, walk->iv, sizeof(xts_ctx->pcc.tweak));
 	param = xts_ctx->pcc.key + offset;
 	ret = crypt_s390_pcc(func, param);
-	BUG_ON(ret < 0);
+	if (ret < 0)
+		return -EIO;
 
 	memcpy(xts_ctx->xts_param, xts_ctx->pcc.xts, 16);
 	param = xts_ctx->key + offset;
@@ -644,7 +647,8 @@ static int xts_aes_crypt(struct blkcipher_desc *desc, long func,
 		in = walk->src.virt.addr;
 
 		ret = crypt_s390_km(func, param, out, in, n);
-		BUG_ON(ret < 0 || ret != n);
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= AES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -778,7 +782,8 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 				crypto_inc(ctrblk + i, AES_BLOCK_SIZE);
 			}
 			ret = crypt_s390_kmctr(func, sctx->key, out, in, n, ctrblk);
-			BUG_ON(ret < 0 || ret != n);
+			if (ret < 0 || ret != n)
+				return -EIO;
 			if (n > AES_BLOCK_SIZE)
 				memcpy(ctrblk, ctrblk + n - AES_BLOCK_SIZE,
 				       AES_BLOCK_SIZE);
@@ -797,7 +802,8 @@ static int ctr_aes_crypt(struct blkcipher_desc *desc, long func,
 		in = walk->src.virt.addr;
 		ret = crypt_s390_kmctr(func, sctx->key, buf, in,
 				       AES_BLOCK_SIZE, ctrblk);
-		BUG_ON(ret < 0 || ret != AES_BLOCK_SIZE);
+		if (ret < 0 || ret != AES_BLOCK_SIZE)
+			return -EIO;
 		memcpy(out, buf, nbytes);
 		crypto_inc(ctrblk, AES_BLOCK_SIZE);
 		ret = blkcipher_walk_done(desc, walk, 0);
diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index a52bfd1..00d649c 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -95,7 +95,8 @@ static int ecb_desall_crypt(struct blkcipher_desc *desc, long func,
 		u8 *in = walk->src.virt.addr;
 
 		ret = crypt_s390_km(func, key, out, in, n);
-		BUG_ON((ret < 0) || (ret != n));
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= DES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -121,7 +122,8 @@ static int cbc_desall_crypt(struct blkcipher_desc *desc, long func,
 		u8 *in = walk->src.virt.addr;
 
 		ret = crypt_s390_kmc(func, iv, out, in, n);
-		BUG_ON((ret < 0) || (ret != n));
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= DES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -394,7 +396,8 @@ static int ctr_desall_crypt(struct blkcipher_desc *desc, long func,
 				crypto_inc(ctrblk + i, DES_BLOCK_SIZE);
 			}
 			ret = crypt_s390_kmctr(func, ctx->key, out, in, n, ctrblk);
-			BUG_ON((ret < 0) || (ret != n));
+			if (ret < 0 || ret != n)
+				return -EIO;
 			if (n > DES_BLOCK_SIZE)
 				memcpy(ctrblk, ctrblk + n - DES_BLOCK_SIZE,
 				       DES_BLOCK_SIZE);
@@ -412,7 +415,8 @@ static int ctr_desall_crypt(struct blkcipher_desc *desc, long func,
 		in = walk->src.virt.addr;
 		ret = crypt_s390_kmctr(func, ctx->key, buf, in,
 				       DES_BLOCK_SIZE, ctrblk);
-		BUG_ON(ret < 0 || ret != DES_BLOCK_SIZE);
+		if (ret < 0 || ret != DES_BLOCK_SIZE)
+			return -EIO;
 		memcpy(out, buf, nbytes);
 		crypto_inc(ctrblk, DES_BLOCK_SIZE);
 		ret = blkcipher_walk_done(desc, walk, 0);
diff --git a/arch/s390/crypto/ghash_s390.c b/arch/s390/crypto/ghash_s390.c
index b1bd170..f6373f0 100644
--- a/arch/s390/crypto/ghash_s390.c
+++ b/arch/s390/crypto/ghash_s390.c
@@ -72,14 +72,16 @@ static int ghash_update(struct shash_desc *desc,
 		if (!dctx->bytes) {
 			ret = crypt_s390_kimd(KIMD_GHASH, ctx, buf,
 					      GHASH_BLOCK_SIZE);
-			BUG_ON(ret != GHASH_BLOCK_SIZE);
+			if (ret != GHASH_BLOCK_SIZE)
+				return -EIO;
 		}
 	}
 
 	n = srclen & ~(GHASH_BLOCK_SIZE - 1);
 	if (n) {
 		ret = crypt_s390_kimd(KIMD_GHASH, ctx, src, n);
-		BUG_ON(ret != n);
+		if (ret != n)
+			return -EIO;
 		src += n;
 		srclen -= n;
 	}
@@ -92,7 +94,7 @@ static int ghash_update(struct shash_desc *desc,
 	return 0;
 }
 
-static void ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
+static int ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
 {
 	u8 *buf = dctx->buffer;
 	int ret;
@@ -103,21 +105,24 @@ static void ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
 		memset(pos, 0, dctx->bytes);
 
 		ret = crypt_s390_kimd(KIMD_GHASH, ctx, buf, GHASH_BLOCK_SIZE);
-		BUG_ON(ret != GHASH_BLOCK_SIZE);
+		if (ret != GHASH_BLOCK_SIZE)
+			return -EIO;
 	}
 
 	dctx->bytes = 0;
+	return 0;
 }
 
 static int ghash_final(struct shash_desc *desc, u8 *dst)
 {
 	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	int ret;
 
-	ghash_flush(ctx, dctx);
-	memcpy(dst, ctx->icv, GHASH_BLOCK_SIZE);
-
-	return 0;
+	ret = ghash_flush(ctx, dctx);
+	if (!ret)
+		memcpy(dst, ctx->icv, GHASH_BLOCK_SIZE);
+	return ret;
 }
 
 static struct shash_alg ghash_alg = {
diff --git a/arch/s390/crypto/sha_common.c b/arch/s390/crypto/sha_common.c
index bd37d09..8620b0e 100644
--- a/arch/s390/crypto/sha_common.c
+++ b/arch/s390/crypto/sha_common.c
@@ -36,7 +36,8 @@ int s390_sha_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 	if (index) {
 		memcpy(ctx->buf + index, data, bsize - index);
 		ret = crypt_s390_kimd(ctx->func, ctx->state, ctx->buf, bsize);
-		BUG_ON(ret != bsize);
+		if (ret != bsize)
+			return -EIO;
 		data += bsize - index;
 		len -= bsize - index;
 		index = 0;
@@ -46,7 +47,8 @@ int s390_sha_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 	if (len >= bsize) {
 		ret = crypt_s390_kimd(ctx->func, ctx->state, data,
 				      len & ~(bsize - 1));
-		BUG_ON(ret != (len & ~(bsize - 1)));
+		if (ret != (len & ~(bsize - 1)))
+			return -EIO;
 		data += ret;
 		len -= ret;
 	}
@@ -88,7 +90,8 @@ int s390_sha_final(struct shash_desc *desc, u8 *out)
 	memcpy(ctx->buf + end - 8, &bits, sizeof(bits));
 
 	ret = crypt_s390_kimd(ctx->func, ctx->state, ctx->buf, end);
-	BUG_ON(ret != end);
+	if (ret != end)
+		return -EIO;
 
 	/* copy digest to out */
 	memcpy(out, ctx->state, crypto_shash_digestsize(desc->tfm));
-- 
1.8.3.2

