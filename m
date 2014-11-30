Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaK3RFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:05:32 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:6030 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbaK3RF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:05:29 -0500
X-IronPort-AV: E=Sophos;i="5.07,488,1413237600"; 
   d="scan'208";a="91114607"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dborkman@redhat.com, herbert@gondor.apana.org.au,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia@diku.dk>
Subject: [PATCH 7/8] crypto: replace memset by memzero_explicit
Date: Sun, 30 Nov 2014 17:59:33 +0100
Message-Id: <1417366774-32412-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417366774-32412-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417366774-32412-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

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

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Daniel Borkmann suggested that these patches could go through Herbert Xu's
cryptodev tree.

I was not able to compile test this one.

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

