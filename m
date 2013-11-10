Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3KJSil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 13:38:41 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:54536 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3KJSiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 13:38:06 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH RESEND] crypto: make sure *blkcipher_walk_init properly initialises walk
Date: Sun, 10 Nov 2013 19:38:01 +0100
Message-Id: <1384108681-23519-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

blkcipher_walk_init and ablkcipher_walk_init functions are called
to initialise a walk structure allocated on stack, which is not
initialised by the caller.  This means, that the fields of the
structure contain garbage when *_init is run.

The *_init functions do not initialise all of the fields though,
and in particular leave flags field as is.  This results in field
containing unspecified value.

Zeroing the whole structure makes sure that all of the fields
are initialised to the same value regardless of the values stored
on the stack prior to the call to the *_init function.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 crypto/blkcipher.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index a79e7e9..3fb99d8 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -305,7 +305,7 @@ static inline int blkcipher_copy_iv(struct blkcipher_walk *walk,
 int blkcipher_walk_virt(struct blkcipher_desc *desc,
 			struct blkcipher_walk *walk)
 {
-	walk->flags &= ~BLKCIPHER_WALK_PHYS;
+	walk->flags = 0;
 	walk->blocksize = crypto_blkcipher_blocksize(desc->tfm);
 	return blkcipher_walk_first(desc, walk);
 }
@@ -314,7 +314,7 @@ EXPORT_SYMBOL_GPL(blkcipher_walk_virt);
 int blkcipher_walk_phys(struct blkcipher_desc *desc,
 			struct blkcipher_walk *walk)
 {
-	walk->flags |= BLKCIPHER_WALK_PHYS;
+	walk->flags = BLKCIPHER_WALK_PHYS;
 	walk->blocksize = crypto_blkcipher_blocksize(desc->tfm);
 	return blkcipher_walk_first(desc, walk);
 }
@@ -352,7 +352,7 @@ int blkcipher_walk_virt_block(struct blkcipher_desc *desc,
 			      struct blkcipher_walk *walk,
 			      unsigned int blocksize)
 {
-	walk->flags &= ~BLKCIPHER_WALK_PHYS;
+	walk->flags = 0;
 	walk->blocksize = blocksize;
 	return blkcipher_walk_first(desc, walk);
 }
-- 
1.8.3.2

