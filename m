Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaIEW7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:59:17 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46423 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaIEW7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:59:15 -0400
From: behanw@converseincode.com
To: davem@davemloft.net, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.lendacky@amd.com,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] crypto: LLVMLinux: Remove VLAIS from crypto/ccp/ccp-crypto-sha.c
Date: Fri,  5 Sep 2014 15:59:04 -0700
Message-Id: <1409957944-30173-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
compliant equivalent. This patch allocates the appropriate amount of memory
using an char array.

The new code can be compiled with both gcc and clang.

struct shash_desc contains a flexible array member member ctx declared with
CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginning
of the array declared after struct shash_desc with long long.

No trailing padding is required because it is not a struct type that can
be used in an array.

The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with long long
as would be the case for a struct containing a member with
CRYPTO_MINALIGN_ATTR.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 drivers/crypto/ccp/ccp-crypto-sha.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 873f234..29f9fda 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -198,10 +198,11 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
 	struct crypto_shash *shash = ctx->u.sha.hmac_tfm;
-	struct {
-		struct shash_desc sdesc;
-		char ctx[crypto_shash_descsize(shash)];
-	} desc;
+
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(shash)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *sdesc = (struct shash_desc *)desc;
+
 	unsigned int block_size = crypto_shash_blocksize(shash);
 	unsigned int digest_size = crypto_shash_digestsize(shash);
 	int i, ret;
@@ -216,11 +217,11 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 
 	if (key_len > block_size) {
 		/* Must hash the input key */
-		desc.sdesc.tfm = shash;
-		desc.sdesc.flags = crypto_ahash_get_flags(tfm) &
+		sdesc->tfm = shash;
+		sdesc->flags = crypto_ahash_get_flags(tfm) &
 			CRYPTO_TFM_REQ_MAY_SLEEP;
 
-		ret = crypto_shash_digest(&desc.sdesc, key, key_len,
+		ret = crypto_shash_digest(sdesc, key, key_len,
 					  ctx->u.sha.key);
 		if (ret) {
 			crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
-- 
1.9.1

