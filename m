Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaK3RFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:05:31 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:6028 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbaK3RF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:05:28 -0500
X-IronPort-AV: E=Sophos;i="5.07,488,1413237600"; 
   d="scan'208";a="91114602"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dborkman@redhat.com, herbert@gondor.apana.org.au,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia@diku.dk>
Subject: [PATCH 2/8] sparc64: replace memset by memzero_explicit
Date: Sun, 30 Nov 2014 17:59:28 +0100
Message-Id: <1417366774-32412-3-git-send-email-Julia.Lawall@lip6.fr>
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

I was not able to compile test these.

 arch/sparc/crypto/sha256_glue.c |    2 +-
 arch/sparc/crypto/sha512_glue.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/crypto/sha512_glue.c b/arch/sparc/crypto/sha512_glue.c
index 9fff885..11eb36c 100644
--- a/arch/sparc/crypto/sha512_glue.c
+++ b/arch/sparc/crypto/sha512_glue.c
@@ -139,7 +139,7 @@ static int sha384_sparc64_final(struct shash_desc *desc, u8 *hash)
 	sha512_sparc64_final(desc, D);
 
 	memcpy(hash, D, 48);
-	memset(D, 0, 64);
+	memzero_explicit(D, 64);
 
 	return 0;
 }
diff --git a/arch/sparc/crypto/sha256_glue.c b/arch/sparc/crypto/sha256_glue.c
index 41f27cc..285268c 100644
--- a/arch/sparc/crypto/sha256_glue.c
+++ b/arch/sparc/crypto/sha256_glue.c
@@ -135,7 +135,7 @@ static int sha224_sparc64_final(struct shash_desc *desc, u8 *hash)
 	sha256_sparc64_final(desc, D);
 
 	memcpy(hash, D, SHA224_DIGEST_SIZE);
-	memset(D, 0, SHA256_DIGEST_SIZE);
+	memzero_explicit(D, SHA256_DIGEST_SIZE);
 
 	return 0;
 }

