Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab3H2X27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:28:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52595 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab3H2X2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:28:49 -0400
From: Joel Fernandes <joelf@ti.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Lokesh Vutla <lokeshvutla@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 3/3] crypto: omap-des: Add triple DES (des3_ede) support to driver
Date: Thu, 29 Aug 2013 18:27:53 -0500
Message-ID: <1377818873-21174-4-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377818873-21174-1-git-send-email-joelf@ti.com>
References: <1377818873-21174-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP DES module supports 3DES operation where 3 64-bit keys are used to
perform a DES encrypt-decrypt-encrypt (ede) operation on a buffer.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-des.c | 53 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 6a9a25f..0df60cb 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -83,7 +83,7 @@ struct omap_des_ctx {
 	struct omap_des_dev *dd;
 
 	int		keylen;
-	u32		key[DES_KEY_SIZE / sizeof(u32)];
+	u32		key[(3 * DES_KEY_SIZE) / sizeof(u32)];
 	unsigned long	flags;
 };
 
@@ -265,8 +265,10 @@ static int omap_des_write_ctrl(struct omap_des_dev *dd)
 		val |= DES_REG_CTRL_CBC;
 	if (dd->flags & FLAGS_ENCRYPT)
 		val |= DES_REG_CTRL_DIRECTION;
+	if (key32 == 6)
+		val |= DES_REG_CTRL_TDES;
 
-	mask |= DES_REG_CTRL_CBC | DES_REG_CTRL_DIRECTION;
+	mask |= DES_REG_CTRL_CBC | DES_REG_CTRL_DIRECTION | DES_REG_CTRL_TDES;
 
 	omap_des_write_mask(dd, DES_REG_CTRL(dd), val, mask);
 
@@ -725,7 +727,7 @@ static int omap_des_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 {
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 
-	if (keylen != DES_KEY_SIZE)
+	if (keylen != DES_KEY_SIZE && keylen != (3*DES_KEY_SIZE))
 		return -EINVAL;
 
 	pr_debug("enter, keylen: %d\n", keylen);
@@ -817,6 +819,51 @@ static struct crypto_alg algs_ecb_cbc[] = {
 		.encrypt	= omap_des_cbc_encrypt,
 		.decrypt	= omap_des_cbc_decrypt,
 	}
+},
+{
+	.cra_name		= "ecb(des3_ede)",
+	.cra_driver_name	= "ecb-des3-omap",
+	.cra_priority		= 100,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= DES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct omap_des_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= omap_des_cra_init,
+	.cra_exit		= omap_des_cra_exit,
+	.cra_u.ablkcipher = {
+		.min_keysize	= 3*DES_KEY_SIZE,
+		.max_keysize	= 3*DES_KEY_SIZE,
+		.setkey		= omap_des_setkey,
+		.encrypt	= omap_des_ecb_encrypt,
+		.decrypt	= omap_des_ecb_decrypt,
+	}
+},
+{
+	.cra_name		= "cbc(des3_ede)",
+	.cra_driver_name	= "cbc-des3-omap",
+	.cra_priority		= 100,
+	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_ASYNC,
+	.cra_blocksize		= DES_BLOCK_SIZE,
+	.cra_ctxsize		= sizeof(struct omap_des_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_ablkcipher_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= omap_des_cra_init,
+	.cra_exit		= omap_des_cra_exit,
+	.cra_u.ablkcipher = {
+		.min_keysize	= 3*DES_KEY_SIZE,
+		.max_keysize	= 3*DES_KEY_SIZE,
+		.ivsize		= DES_BLOCK_SIZE,
+		.setkey		= omap_des_setkey,
+		.encrypt	= omap_des_cbc_encrypt,
+		.decrypt	= omap_des_cbc_decrypt,
+	}
 }
 };
 
-- 
1.8.1.2

