Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaK3RJZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:09:25 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:16438 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752563AbaK3RJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:09:24 -0500
X-IronPort-AV: E=Sophos;i="5.07,488,1413237600"; 
   d="scan'208";a="110322835"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8 v2] crypto: replace memset by memzero_explicit
Date: Sun, 30 Nov 2014 18:03:44 +0100
Message-Id: <1417367029-32762-4-git-send-email-Julia.Lawall@lip6.fr>
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

v2: fixed email address

 arch/x86/crypto/sha256_ssse3_glue.c |    2 +-
 arch/x86/crypto/sha512_ssse3_glue.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 26a5898..0b6af26 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -219,7 +219,7 @@ static int sha384_ssse3_final(struct shash_desc *desc, u8 *hash)
 	sha512_ssse3_final(desc, D);
 
 	memcpy(hash, D, SHA384_DIGEST_SIZE);
-	memset(D, 0, SHA512_DIGEST_SIZE);
+	memzero_explicit(D, SHA512_DIGEST_SIZE);
 
 	return 0;
 }
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 4dc100d..8fad72f 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -211,7 +211,7 @@ static int sha224_ssse3_final(struct shash_desc *desc, u8 *hash)
 	sha256_ssse3_final(desc, D);
 
 	memcpy(hash, D, SHA224_DIGEST_SIZE);
-	memset(D, 0, SHA256_DIGEST_SIZE);
+	memzero_explicit(D, SHA256_DIGEST_SIZE);
 
 	return 0;
 }

