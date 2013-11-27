Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704Ab3K0B1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:27:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758664Ab3K0A65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3.12 009/116] crypto: s390 - Fix aes-cbc IV corruption
Date: Tue, 26 Nov 2013 16:56:22 -0800
Message-Id: <20131127005737.566781982@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit f262f0f5cad0c9eca61d1d383e3b67b57dcbe5ea upstream.

The cbc-aes-s390 algorithm incorrectly places the IV in the tfm
data structure.  As the tfm is shared between multiple threads,
this introduces a possibility of data corruption.

This patch fixes this by moving the parameter block containing
the IV and key onto the stack (the block is 48 bytes long).

The same bug exists elsewhere in the s390 crypto system and they
will be fixed in subsequent patches.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/crypto/aes_s390.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -35,7 +35,6 @@ static u8 *ctrblk;
 static char keylen_flag;
 
 struct s390_aes_ctx {
-	u8 iv[AES_BLOCK_SIZE];
 	u8 key[AES_MAX_KEY_SIZE];
 	long enc;
 	long dec;
@@ -441,30 +440,36 @@ static int cbc_aes_set_key(struct crypto
 	return aes_set_key(tfm, in_key, key_len);
 }
 
-static int cbc_aes_crypt(struct blkcipher_desc *desc, long func, void *param,
+static int cbc_aes_crypt(struct blkcipher_desc *desc, long func,
 			 struct blkcipher_walk *walk)
 {
+	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
 	int ret = blkcipher_walk_virt(desc, walk);
 	unsigned int nbytes = walk->nbytes;
+	struct {
+		u8 iv[AES_BLOCK_SIZE];
+		u8 key[AES_MAX_KEY_SIZE];
+	} param;
 
 	if (!nbytes)
 		goto out;
 
-	memcpy(param, walk->iv, AES_BLOCK_SIZE);
+	memcpy(param.iv, walk->iv, AES_BLOCK_SIZE);
+	memcpy(param.key, sctx->key, sctx->key_len);
 	do {
 		/* only use complete blocks */
 		unsigned int n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		u8 *out = walk->dst.virt.addr;
 		u8 *in = walk->src.virt.addr;
 
-		ret = crypt_s390_kmc(func, param, out, in, n);
+		ret = crypt_s390_kmc(func, &param, out, in, n);
 		if (ret < 0 || ret != n)
 			return -EIO;
 
 		nbytes &= AES_BLOCK_SIZE - 1;
 		ret = blkcipher_walk_done(desc, walk, nbytes);
 	} while ((nbytes = walk->nbytes));
-	memcpy(walk->iv, param, AES_BLOCK_SIZE);
+	memcpy(walk->iv, param.iv, AES_BLOCK_SIZE);
 
 out:
 	return ret;
@@ -481,7 +486,7 @@ static int cbc_aes_encrypt(struct blkcip
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_aes_crypt(desc, sctx->enc, sctx->iv, &walk);
+	return cbc_aes_crypt(desc, sctx->enc, &walk);
 }
 
 static int cbc_aes_decrypt(struct blkcipher_desc *desc,
@@ -495,7 +500,7 @@ static int cbc_aes_decrypt(struct blkcip
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-	return cbc_aes_crypt(desc, sctx->dec, sctx->iv, &walk);
+	return cbc_aes_crypt(desc, sctx->dec, &walk);
 }
 
 static struct crypto_alg cbc_aes_alg = {


