Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbaCaAWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:22:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36287 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929AbaC3XZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jan Glauber" <jang@linux.vnet.ibm.com>,
        "Martin Schwidefsky" <schwidefsky@de.ibm.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.47127075@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 064/200] s390/crypto: Don't panic after crypto
 instruction failures
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Glauber <jang@linux.vnet.ibm.com>

commit 36eb2caa7bace31b7868a57f77cb148e58d1c9f9 upstream.

Remove the BUG_ON's that check for failure or incomplete
results of the s390 hardware crypto instructions.
Rather report the errors as -EIO to the crypto layer.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/crypto/aes_s390.c   | 18 ++++++++++++------
 arch/s390/crypto/des_s390.c   | 12 ++++++++----
 arch/s390/crypto/ghash_s390.c | 21 +++++++++++++--------
 arch/s390/crypto/sha_common.c |  9 ++++++---
 4 files changed, 39 insertions(+), 21 deletions(-)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -324,7 +324,8 @@ static int ecb_aes_crypt(struct blkciphe
 		u8 *in = walk->src.virt.addr;
 
 		ret = crypt_s390_km(func, param, out, in, n);
-		BUG_ON((ret < 0) || (ret != n));
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= AES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -463,7 +464,8 @@ static int cbc_aes_crypt(struct blkciphe
 		u8 *in = walk->src.virt.addr;
 
 		ret = crypt_s390_kmc(func, &param, out, in, n);
-		BUG_ON((ret < 0) || (ret != n));
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= AES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -636,7 +638,8 @@ static int xts_aes_crypt(struct blkciphe
 	memcpy(pcc_param.tweak, walk->iv, sizeof(pcc_param.tweak));
 	memcpy(pcc_param.key, xts_ctx->pcc_key, 32);
 	ret = crypt_s390_pcc(func, &pcc_param.key[offset]);
-	BUG_ON(ret < 0);
+	if (ret < 0)
+		return -EIO;
 
 	memcpy(xts_param.key, xts_ctx->key, 32);
 	memcpy(xts_param.init, pcc_param.xts, 16);
@@ -647,7 +650,8 @@ static int xts_aes_crypt(struct blkciphe
 		in = walk->src.virt.addr;
 
 		ret = crypt_s390_km(func, &xts_param.key[offset], out, in, n);
-		BUG_ON(ret < 0 || ret != n);
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= AES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -781,7 +785,8 @@ static int ctr_aes_crypt(struct blkciphe
 				crypto_inc(ctrblk + i, AES_BLOCK_SIZE);
 			}
 			ret = crypt_s390_kmctr(func, sctx->key, out, in, n, ctrblk);
-			BUG_ON(ret < 0 || ret != n);
+			if (ret < 0 || ret != n)
+				return -EIO;
 			if (n > AES_BLOCK_SIZE)
 				memcpy(ctrblk, ctrblk + n - AES_BLOCK_SIZE,
 				       AES_BLOCK_SIZE);
@@ -800,7 +805,8 @@ static int ctr_aes_crypt(struct blkciphe
 		in = walk->src.virt.addr;
 		ret = crypt_s390_kmctr(func, sctx->key, buf, in,
 				       AES_BLOCK_SIZE, ctrblk);
-		BUG_ON(ret < 0 || ret != AES_BLOCK_SIZE);
+		if (ret < 0 || ret != AES_BLOCK_SIZE)
+			return -EIO;
 		memcpy(out, buf, nbytes);
 		crypto_inc(ctrblk, AES_BLOCK_SIZE);
 		ret = blkcipher_walk_done(desc, walk, 0);
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -95,7 +95,8 @@ static int ecb_desall_crypt(struct blkci
 		u8 *in = walk->src.virt.addr;
 
 		ret = crypt_s390_km(func, key, out, in, n);
-		BUG_ON((ret < 0) || (ret != n));
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= DES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -121,7 +122,8 @@ static int cbc_desall_crypt(struct blkci
 		u8 *in = walk->src.virt.addr;
 
 		ret = crypt_s390_kmc(func, iv, out, in, n);
-		BUG_ON((ret < 0) || (ret != n));
+		if (ret < 0 || ret != n)
+			return -EIO;
 
 		nbytes &= DES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
@@ -394,7 +396,8 @@ static int ctr_desall_crypt(struct blkci
 				crypto_inc(ctrblk + i, DES_BLOCK_SIZE);
 			}
 			ret = crypt_s390_kmctr(func, ctx->key, out, in, n, ctrblk);
-			BUG_ON((ret < 0) || (ret != n));
+			if (ret < 0 || ret != n)
+				return -EIO;
 			if (n > DES_BLOCK_SIZE)
 				memcpy(ctrblk, ctrblk + n - DES_BLOCK_SIZE,
 				       DES_BLOCK_SIZE);
@@ -412,7 +415,8 @@ static int ctr_desall_crypt(struct blkci
 		in = walk->src.virt.addr;
 		ret = crypt_s390_kmctr(func, ctx->key, buf, in,
 				       DES_BLOCK_SIZE, ctrblk);
-		BUG_ON(ret < 0 || ret != DES_BLOCK_SIZE);
+		if (ret < 0 || ret != DES_BLOCK_SIZE)
+			return -EIO;
 		memcpy(out, buf, nbytes);
 		crypto_inc(ctrblk, DES_BLOCK_SIZE);
 		ret = blkcipher_walk_done(desc, walk, 0);
--- a/arch/s390/crypto/ghash_s390.c
+++ b/arch/s390/crypto/ghash_s390.c
@@ -72,14 +72,16 @@ static int ghash_update(struct shash_des
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
@@ -92,7 +94,7 @@ static int ghash_update(struct shash_des
 	return 0;
 }
 
-static void ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
+static int ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
 {
 	u8 *buf = dctx->buffer;
 	int ret;
@@ -103,21 +105,24 @@ static void ghash_flush(struct ghash_ctx
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
--- a/arch/s390/crypto/sha_common.c
+++ b/arch/s390/crypto/sha_common.c
@@ -36,7 +36,8 @@ int s390_sha_update(struct shash_desc *d
 	if (index) {
 		memcpy(ctx->buf + index, data, bsize - index);
 		ret = crypt_s390_kimd(ctx->func, ctx->state, ctx->buf, bsize);
-		BUG_ON(ret != bsize);
+		if (ret != bsize)
+			return -EIO;
 		data += bsize - index;
 		len -= bsize - index;
 		index = 0;
@@ -46,7 +47,8 @@ int s390_sha_update(struct shash_desc *d
 	if (len >= bsize) {
 		ret = crypt_s390_kimd(ctx->func, ctx->state, data,
 				      len & ~(bsize - 1));
-		BUG_ON(ret != (len & ~(bsize - 1)));
+		if (ret != (len & ~(bsize - 1)))
+			return -EIO;
 		data += ret;
 		len -= ret;
 	}
@@ -88,7 +90,8 @@ int s390_sha_final(struct shash_desc *de
 	memcpy(ctx->buf + end - 8, &bits, sizeof(bits));
 
 	ret = crypt_s390_kimd(ctx->func, ctx->state, ctx->buf, end);
-	BUG_ON(ret != end);
+	if (ret != end)
+		return -EIO;
 
 	/* copy digest to out */
 	memcpy(out, ctx->state, crypto_shash_digestsize(desc->tfm));

