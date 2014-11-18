Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaKRLuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:50:09 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16287 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaKRLuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:50:07 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-71-546b326b2fbd
Subject: [PATCH 1/2 v2] scripts/coccinelle: catch freeing cryptographic
 structures via kfree
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>
Cc: Michal Marek <mmarek@suse.cz>, Herbert Xu <herbert@gondor.apana.org.au>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Julia Lawall <Julia.Lawall@lip6.fr>, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date: Tue, 18 Nov 2014 14:50:03 +0400
Message-id: <20141118114920.13498.73584.stgit@buzz>
In-reply-to: <20141117151420.10739.16342.stgit@buzz>
References: <20141117151420.10739.16342.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xy7rZRtkhBvu+W1jMOd/CYvF/Wwu7
	xeyfl5gsul/JWCx7cJrR4sfOXlaL3ae/Mlncv/eTyeLyrjlsFi37LjBZHHu5nMmB22PLyptM
	HtsOqHocO9bK7LF3S5bH5iX1Hn1bVjF6nFlwhN3j8yY5jymH2lkCOKO4bFJSczLLUov07RK4
	Mub8PcFacJavYsbc54wNjFN5uhg5OSQETCTuL1jGCmGLSVy4t54NxBYSWMoo0bbHvIuRC8hu
	ZJL4fO43WJGwQJxE25eDYDabgJnEtn23GUFsEYFUiQWLjjCDNDALdDNJrHr1ggkkwSKgKjHr
	3WT2LkYODl4BY4n252C9nECLu2dtZYVYZiyxp2sLmC0qICex8nILmM0rICjxY/I9FpBWZgF1
	iSlTckHCzALyEpvXvGWewCgwC0nVLISqWUiqFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P
	3cQIiZQvOxgXH7M6xCjAwajEw9uwMStEiDWxrLgy9xCjBAezkgjvuW6gEG9KYmVValF+fFFp
	TmrxIUYmDk6pBsbmW963ty1/WWs8i32zrnzdlqub16xTu1Um88rlguK9Kw2BVV8D9hSHzf00
	209CnNH1jOl3RS/f5lVHMiM/msjY/9BbH/CLLU2mtqu+uepnwnazVWpBt37N+HY4VcKmf69X
	vA1vpOaTvXrv097+fWzwYarC+ucbJtUt/6Q9q1Xg6/qAm8nXT89QYinOSDTUYi4qTgQAmP5p
	SXICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structures allocated by crypto_alloc_* must be freed using crypto_free_*.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 scripts/coccinelle/free/crypto_free.cocci |   64 +++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 scripts/coccinelle/free/crypto_free.cocci

diff --git a/scripts/coccinelle/free/crypto_free.cocci b/scripts/coccinelle/free/crypto_free.cocci
new file mode 100644
index 0000000..a717070
--- /dev/null
+++ b/scripts/coccinelle/free/crypto_free.cocci
@@ -0,0 +1,64 @@
+///
+/// Structures allocated by crypto_alloc_* must be freed using crypto_free_*.
+/// This finds freeing them by kfree.
+///
+// Confidence: Moderate
+// Copyright: (C) 2014 Konstantin Khlebnikov,  GPLv2.
+// Comments: There are false positives in crypto/ where they are actually freed.
+// Keywords: crypto, kfree
+// Options: --no-includes --include-headers
+
+virtual org
+virtual report
+virtual context
+
+@r depends on context || org || report@
+expression x;
+@@
+
+(
+ x = crypto_alloc_base(...)
+|
+ x = crypto_alloc_cipher(...)
+|
+ x = crypto_alloc_ablkcipher(...)
+|
+ x = crypto_alloc_aead(...)
+|
+ x = crypto_alloc_instance(...)
+|
+ x = crypto_alloc_instance2(...)
+|
+ x = crypto_alloc_comp(...)
+|
+ x = crypto_alloc_pcomp(...)
+|
+ x = crypto_alloc_hash(...)
+|
+ x = crypto_alloc_ahash(...)
+|
+ x = crypto_alloc_shash(...)
+|
+ x = crypto_alloc_rng(...)
+)
+
+@pb@
+expression r.x;
+position p;
+@@
+
+* kfree@p(x)
+
+@script:python depends on org@
+p << pb.p;
+@@
+
+msg="WARNING: invalid free of crypto_alloc_* allocated data"
+coccilib.org.print_todo(p[0], msg)
+
+@script:python depends on report@
+p << pb.p;
+@@
+
+msg="WARNING: invalid free of crypto_alloc_* allocated data"
+coccilib.report.print_report(p[0], msg)

