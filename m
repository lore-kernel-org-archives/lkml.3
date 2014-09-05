Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaIEXBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:01:18 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36355 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaIEXBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:01:16 -0400
From: behanw@converseincode.com
To: davem@davemloft.net, herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org,
        Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <charlebm@gmail.com>,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>
Subject: [PATCH] crypto: LLVMLinux: Remove VLAIS from crypto/omap_sham.c
Date: Fri,  5 Sep 2014 16:01:04 -0700
Message-Id: <1409958064-753-1-git-send-email-behanw@converseincode.com>
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
 drivers/crypto/omap-sham.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 710d863..dcbfd35 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -949,17 +949,16 @@ static int omap_sham_finish_hmac(struct ahash_request *req)
 	struct omap_sham_hmac_ctx *bctx = tctx->base;
 	int bs = crypto_shash_blocksize(bctx->shash);
 	int ds = crypto_shash_digestsize(bctx->shash);
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(bctx->shash)];
-	} desc;
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(bctx->shash)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash = (struct shash_desc *)desc;
 
-	desc.shash.tfm = bctx->shash;
-	desc.shash.flags = 0; /* not CRYPTO_TFM_REQ_MAY_SLEEP */
+	shash->tfm = bctx->shash;
+	shash->flags = 0; /* not CRYPTO_TFM_REQ_MAY_SLEEP */
 
-	return crypto_shash_init(&desc.shash) ?:
-	       crypto_shash_update(&desc.shash, bctx->opad, bs) ?:
-	       crypto_shash_finup(&desc.shash, req->result, ds, req->result);
+	return crypto_shash_init(shash) ?:
+	       crypto_shash_update(shash, bctx->opad, bs) ?:
+	       crypto_shash_finup(shash, req->result, ds, req->result);
 }
 
 static int omap_sham_finish(struct ahash_request *req)
@@ -1118,18 +1117,17 @@ static int omap_sham_update(struct ahash_request *req)
 	return omap_sham_enqueue(req, OP_UPDATE);
 }
 
-static int omap_sham_shash_digest(struct crypto_shash *shash, u32 flags,
+static int omap_sham_shash_digest(struct crypto_shash *tfm, u32 flags,
 				  const u8 *data, unsigned int len, u8 *out)
 {
-	struct {
-		struct shash_desc shash;
-		char ctx[crypto_shash_descsize(shash)];
-	} desc;
+	char desc[sizeof(struct shash_desc) +
+		crypto_shash_descsize(shash)] CRYPTO_MINALIGN_ATTR;
+	struct shash_desc *shash = (struct shash_desc *)desc;
 
-	desc.shash.tfm = shash;
-	desc.shash.flags = flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	shash->tfm = tfm;
+	shash->flags = flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	return crypto_shash_digest(&desc.shash, data, len, out);
+	return crypto_shash_digest(shash, data, len, out);
 }
 
 static int omap_sham_final_shash(struct ahash_request *req)
-- 
1.9.1

