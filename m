Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaBEUIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:08:39 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48668 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaBEUIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:31 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kent Yoder <key@linux.vnet.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 212/213] crypto: sha512 - Fix byte counter overflow in SHA-512
Date: Wed, 5 Feb 2014 15:02:47 -0500
Message-ID: <1391630568-49251-213-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Yoder <key@linux.vnet.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 25c3d30c918207556ae1d6e663150ebdf902186b upstream.

The current code only increments the upper 64 bits of the SHA-512 byte
counter when the number of bytes hashed happens to hit 2^64 exactly.

This patch increments the upper 64 bits whenever the lower 64 bits
overflows.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 crypto/sha512_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 9ed9f60316e5..899b2fa24e50 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -177,7 +177,7 @@ sha512_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 	index = sctx->count[0] & 0x7f;
 
 	/* Update number of bytes */
-	if (!(sctx->count[0] += len))
+	if ((sctx->count[0] += len) < len)
 		sctx->count[1]++;
 
         part_len = 128 - index;
-- 
1.8.5.2

