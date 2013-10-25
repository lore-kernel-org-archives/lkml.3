Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3JYL2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:28:17 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:42258 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3JYL2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:28:15 -0400
From: Michal Nazarewicz <mpn@google.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] crypto: blkcipher: do not read unutialised walk->flags
Date: Fri, 25 Oct 2013 12:27:35 +0100
Message-Id: <b83903fdfd4b274d401b2417ca960ab7ff8e0273.1382699979.git.mina86@mina86.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

blkcipher_walk_virt, blkcipher_walk_virt_block and
blkcipher_walk_phys functions modify the walk->flags by using
a binary “&=” or “|=” operator.  This translate to read followed by
a write.  However, the walk->flags is usually not initialised so the
read returns garbage.

At the same time, those functions call blkcipher_walk_first which
then calls blkcipher_walk_next function which zeroes all flags
except for BLKCIPHER_WALK_PHYS.  This means, that the read done in
the virt, virt_block and phys functions is completely meaningless.

Dropping the read and changing “&=”/“|=” with a plain assignment
clears the confusion without changing any functionality of the API.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---

 Admittedly, I'm not familiar with the crypto API, but I believe
 this to be a valid change.  This has actually been prompted by
 Coverity scan which detects the read of initialised data.

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
1.8.4

