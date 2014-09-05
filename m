Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaIEW75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:59:57 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33356 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaIEW7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:59:55 -0400
From: behanw@converseincode.com
To: davem@davemloft.net, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>
Subject: [PATCH] crypto: LLVMLinux: Remove VLAIS from crypto/mv_cesa.c
Date: Fri,  5 Sep 2014 15:59:41 -0700
Message-Id: <1409957981-31166-1-git-send-email-behanw@converseincode.com>
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
 drivers/crypto/mv_cesa.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 29d0ee5..0d92c85 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -402,26 +402,25 @@ static int mv_hash_final_fallback(struct ahash_request *req)
 {
 	const struct mv_tfm_hash_ctx *tfm_ctx = crypto_tfm_ctx(req->base.tfm);
 	struct mv_req_hash_ctx *req_ctx = ahash_request_ctx(req);
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(tfm_ctx->fallback)];
-	} desc;
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(tfm_ctx->fallback)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash = (struct shash_desc *)desc;
 	int rc;
 
-	desc.shash.tfm = tfm_ctx->fallback;
-	desc.shash.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	shash->tfm = tfm_ctx->fallback;
+	shash->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	if (unlikely(req_ctx->first_hash)) {
-		crypto_shash_init(&desc.shash);
-		crypto_shash_update(&desc.shash, req_ctx->buffer,
+		crypto_shash_init(shash);
+		crypto_shash_update(shash, req_ctx->buffer,
 				    req_ctx->extra_bytes);
 	} else {
 		/* only SHA1 for now....
 		 */
-		rc = mv_hash_import_sha1_ctx(req_ctx, &desc.shash);
+		rc = mv_hash_import_sha1_ctx(req_ctx, shash);
 		if (rc)
 			goto out;
 	}
-	rc = crypto_shash_final(&desc.shash, req->result);
+	rc = crypto_shash_final(shash, req->result);
 out:
 	return rc;
 }
@@ -794,23 +793,24 @@ static int mv_hash_setkey(struct crypto_ahash *tfm, const u8 * key,
 	ss = crypto_shash_statesize(ctx->base_hash);
 
 	{
-		struct {
-			struct shash_desc shash;
-			char ctx[crypto_shash_descsize(ctx->base_hash)];
-		} desc;
+		char desc[sizeof(struct shash_desc) +
+			crypto_shash_descsize(ctx->base_hash)]
+			CRYPTO_MINALIGN_ATTR;
+		struct shash_desc *shash = (struct shash_desc *)desc;
+
 		unsigned int i;
 		char ipad[ss];
 		char opad[ss];
 
-		desc.shash.tfm = ctx->base_hash;
-		desc.shash.flags = crypto_shash_get_flags(ctx->base_hash) &
+		shash->tfm = ctx->base_hash;
+		shash->flags = crypto_shash_get_flags(ctx->base_hash) &
 		    CRYPTO_TFM_REQ_MAY_SLEEP;
 
 		if (keylen > bs) {
 			int err;
 
 			err =
-			    crypto_shash_digest(&desc.shash, key, keylen, ipad);
+			    crypto_shash_digest(shash, key, keylen, ipad);
 			if (err)
 				return err;
 
@@ -826,12 +826,12 @@ static int mv_hash_setkey(struct crypto_ahash *tfm, const u8 * key,
 			opad[i] ^= 0x5c;
 		}
 
-		rc = crypto_shash_init(&desc.shash) ? :
-		    crypto_shash_update(&desc.shash, ipad, bs) ? :
-		    crypto_shash_export(&desc.shash, ipad) ? :
-		    crypto_shash_init(&desc.shash) ? :
-		    crypto_shash_update(&desc.shash, opad, bs) ? :
-		    crypto_shash_export(&desc.shash, opad);
+		rc = crypto_shash_init(shash) ? :
+		    crypto_shash_update(shash, ipad, bs) ? :
+		    crypto_shash_export(shash, ipad) ? :
+		    crypto_shash_init(shash) ? :
+		    crypto_shash_update(shash, opad, bs) ? :
+		    crypto_shash_export(shash, opad);
 
 		if (rc == 0)
 			mv_hash_init_ivs(ctx, ipad, opad);
-- 
1.9.1

