Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaK3RGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:06:38 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:13407
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473AbaK3RFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:05:30 -0500
X-IronPort-AV: E=Sophos;i="5.07,488,1413237600"; 
   d="scan'208";a="91114606"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dborkman@redhat.com, herbert@gondor.apana.org.au,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Julia Lawall <julia@diku.dk>
Subject: [PATCH 6/8] crypto: replace memset by memzero_explicit
Date: Sun, 30 Nov 2014 17:59:32 +0100
Message-Id: <1417366774-32412-7-git-send-email-Julia.Lawall@lip6.fr>
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

 arch/powerpc/crypto/sha1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/sha1.c b/arch/powerpc/crypto/sha1.c
index 0f88c7b..d3feba5 100644
--- a/arch/powerpc/crypto/sha1.c
+++ b/arch/powerpc/crypto/sha1.c
@@ -66,7 +66,7 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 			src = data + done;
 		} while (done + 63 < len);
 
-		memset(temp, 0, sizeof(temp));
+		memzero_explicit(temp, sizeof(temp));
 		partial = 0;
 	}
 	memcpy(sctx->buffer + partial, src, len - done);

