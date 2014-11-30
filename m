Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaK3RJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 12:09:24 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:16438 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154AbaK3RJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 12:09:22 -0500
X-IronPort-AV: E=Sophos;i="5.07,488,1413237600"; 
   d="scan'208";a="110322833"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel-janitors@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8 v2] purgatory/sha256: replace memset by memzero_explicit
Date: Sun, 30 Nov 2014 18:03:42 +0100
Message-Id: <1417367029-32762-2-git-send-email-Julia.Lawall@lip6.fr>
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

 arch/x86/purgatory/sha256.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/purgatory/sha256.c b/arch/x86/purgatory/sha256.c
index 548ca67..8271ca5 100644
--- a/arch/x86/purgatory/sha256.c
+++ b/arch/x86/purgatory/sha256.c
@@ -205,7 +205,7 @@ static void sha256_transform(u32 *state, const u8 *input)
 
 	/* clear any sensitive info... */
 	a = b = c = d = e = f = g = h = t1 = t2 = 0;
-	memset(W, 0, 64 * sizeof(u32));
+	memzero_explicit(W, 64 * sizeof(u32));
 }
 
 int sha256_init(struct sha256_state *sctx)

