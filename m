Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaFEEZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:25:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaFEEWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 206/214] crypto: s390 - Fix aes-cbc IV corruption
Date: Wed,  4 Jun 2014 21:19:29 -0700
Message-Id: <20140605041707.141538378@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
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
@@ -442,29 +441,35 @@ static int cbc_aes_set_key(struct crypto
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
 		BUG_ON((ret < 0) || (ret != n));
 
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


