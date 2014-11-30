Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaK3RJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:09:28 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:38159 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbaK3RJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:09:26 -0500
X-IronPort-AV: E=Sophos;i="5.07,488,1413237600"; 
   d="scan'208";a="110322839"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8 v2] crypto: replace memset by memzero_explicit
Date: Sun, 30 Nov 2014 18:03:48 +0100
Message-Id: <1417367029-32762-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417367029-32762-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417367029-32762-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Memset on a local variable may be removed when it is called just before the
variable goes out of scope.  Using memzero_explicit defeats this
optimization.  A simplified version of the semantic patch that makes this
change is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
type T;
@@

{
... when any
T x[...];
... when any
    when exists
- memset
+ memzero_explicit
  (x,
-0,
  ...)
... when != x
    when strict
}
// </smpl>

This change was suggested by Daniel Borkmann <dborkman@redhat.com>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Daniel Borkmann suggested that these patches could go through Herbert Xu's
cryptodev tree.

I was not able to compile this one.

v2: fixed email address

 arch/arm/crypto/sha512_neon_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/sha512_neon_glue.c b/arch/arm/crypto/sha512_neon_glue.c
index f3452c6..b124dce 100644
--- a/arch/arm/crypto/sha512_neon_glue.c
+++ b/arch/arm/crypto/sha512_neon_glue.c
@@ -241,7 +241,7 @@ static int sha384_neon_final(struct shash_desc *desc, u8 *hash)
 	sha512_neon_final(desc, D);
 
 	memcpy(hash, D, SHA384_DIGEST_SIZE);
-	memset(D, 0, SHA512_DIGEST_SIZE);
+	memzero_explicit(D, SHA512_DIGEST_SIZE);
 
 	return 0;
 }

