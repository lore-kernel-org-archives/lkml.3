Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaIEXAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:00:18 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45047 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaIEXAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:00:15 -0400
From: behanw@converseincode.com
To: davem@davemloft.net, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>
Subject: [PATCH] crypto: LLVMLinux: Remove VLAIS from crypto/n2_core.c
Date: Fri,  5 Sep 2014 16:00:08 -0700
Message-Id: <1409958008-32119-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

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

Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 drivers/crypto/n2_core.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 7263c10..ed142d1 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -445,10 +445,9 @@ static int n2_hmac_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 	struct n2_hmac_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct crypto_shash *child_shash = ctx->child_shash;
 	struct crypto_ahash *fallback_tfm;
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(child_shash)];
-	} desc;
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(child_shash)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash = (struct shash_desc *)desc;
 	int err, bs, ds;
 
 	fallback_tfm = ctx->base.fallback_tfm;
@@ -456,15 +455,15 @@ static int n2_hmac_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 	if (err)
 		return err;
 
-	desc.shash.tfm = child_shash;
-	desc.shash.flags = crypto_ahash_get_flags(tfm) &
+	shash->tfm = child_shash;
+	shash->flags = crypto_ahash_get_flags(tfm) &
 		CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	bs = crypto_shash_blocksize(child_shash);
 	ds = crypto_shash_digestsize(child_shash);
 	BUG_ON(ds > N2_HASH_KEY_MAX);
 	if (keylen > bs) {
-		err = crypto_shash_digest(&desc.shash, key, keylen,
+		err = crypto_shash_digest(shash, key, keylen,
 					  ctx->hash_key);
 		if (err)
 			return err;
-- 
1.9.1

