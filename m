Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbaBUMtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:49:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46715 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbaBUMtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Harald Freudenberger <freude@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 005/121] crypto: s390 - fix des and des3_ede cbc concurrency issue
Date: Fri, 21 Feb 2014 12:47:09 +0000
Message-Id: <1392986945-9693-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.vnet.ibm.com>

commit adc3fcf1552b6e406d172fd9690bbd1395053d13 upstream.

In s390 des and des3_ede cbc mode the iv value is not protected
against concurrency access and modifications from another running
en/decrypt operation which is using the very same tfm struct
instance. This fix copies the iv to the local stack before
the crypto operation and stores the value back when done.

Signed-off-by: Harald Freudenberger <freude@linux.vnet.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/crypto/des_s390.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index bcca01c..4b28089 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -105,29 +105,35 @@ static int ecb_desall_crypt(struct blkcipher_desc *desc, long func,
 }
 
 static int cbc_desall_crypt(struct blkcipher_desc *desc, long func,
-			    u8 *iv, struct blkcipher_walk *walk)
+			    struct blkcipher_walk *walk)
 {
+	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	int ret = blkcipher_walk_virt(desc, walk);
 	unsigned int nbytes = walk->nbytes;
+	struct {
+		u8 iv[DES_BLOCK_SIZE];
+		u8 key[DES3_KEY_SIZE];
+	} param;
 
 	if (!nbytes)
 		goto out;
 
-	memcpy(iv, walk->iv, DES_BLOCK_SIZE);
+	memcpy(param.iv, walk->iv, DES_BLOCK_SIZE);
+	memcpy(param.key, ctx->key, DES3_KEY_SIZE);
 	do {
 		/* only use complete blocks */
 		unsigned int n = nbytes & ~(DES_BLOCK_SIZE - 1);
 		u8 *out = walk->dst.virt.addr;
 		u8 *in = walk->src.virt.addr;
 
-		ret = crypt_s390_kmc(func, iv, out, in, n);
+		ret = crypt_s390_kmc(func, &param, out, in, n);
 		if (ret < 0 || ret != n)
 			return -EIO;
 
 		nbytes &= DES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
 	} while ((nbytes = walk->nbytes));
-	memcpy(walk->iv, iv, DES_BLOCK_SIZE);
+	memcpy(walk->iv, param.iv, DES_BLOCK_SIZE);
 
 out:
 	return ret;
@@ -179,22 +185,20 @@ static int cbc_des_encrypt(struct blkcipher_desc *desc,
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_DEA_ENCRYPT, ctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_DEA_ENCRYPT, &walk);
 }
 
 static int cbc_des_decrypt(struct blkcipher_desc *desc,
 			   struct scatterlist *dst, struct scatterlist *src,
 			   unsigned int nbytes)
 {
-	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_DEA_DECRYPT, ctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_DEA_DECRYPT, &walk);
 }
 
 static struct crypto_alg cbc_des_alg = {
@@ -327,22 +331,20 @@ static int cbc_des3_encrypt(struct blkcipher_desc *desc,
 			    struct scatterlist *dst, struct scatterlist *src,
 			    unsigned int nbytes)
 {
-	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_TDEA_192_ENCRYPT, ctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_TDEA_192_ENCRYPT, &walk);
 }
 
 static int cbc_des3_decrypt(struct blkcipher_desc *desc,
 			    struct scatterlist *dst, struct scatterlist *src,
 			    unsigned int nbytes)
 {
-	struct s390_des_ctx *ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_desall_crypt(desc, KMC_TDEA_192_DECRYPT, ctx->iv, &walk);
+	return cbc_desall_crypt(desc, KMC_TDEA_192_DECRYPT, &walk);
 }
 
 static struct crypto_alg cbc_des3_alg = {
-- 
1.9.0

