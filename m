Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaKQPOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:14:25 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17544 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaKQPOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:14:23 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-7c-546a10cd79e1
Subject: [PATCH 1/2] scripts/coccinelle: catch freeing cryptographic structures
 via kfree
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>
Cc: Michal Marek <mmarek@suse.cz>, Herbert Xu <herbert@gondor.apana.org.au>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Julia Lawall <Julia.Lawall@lip6.fr>, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 17 Nov 2014 18:14:20 +0400
Message-id: <20141117151420.10739.16342.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xq7pnBbJCDBYsZ7aYc76FxeL/thZ2
	i9k/LzFZdL+SsVj24DSjxY+dvawWu09/ZbK4f+8nk8XlXXPYLFr2XWCyOPZyOZMDt8eWlTeZ
	PLYdUPU4dqyV2WPvliyPzUvqPfq2rGL0OLPgCLvH501yHlMOtbMEcEZx2aSk5mSWpRbp2yVw
	ZUxbdYq14Bt3xeVrk1kaGJu4uhg5OCQETCTuX9LtYuQEMsUkLtxbz9bFyMUhJLCUUeL44p8s
	IAkhgUYmibO7wkHqhQWiJV5vjAAJswmYSWzbd5sRxBYRSJVYsOgIM0gvs0A3k8SqVy+YQBIs
	AqoSD27+ZQexeQWMJeZPfskMYosKyEmsvNzCChEXlPgx+R4LyHxmAXWJKVNyQcLMAvISm9e8
	ZZ7AyDcLSdUshKpZSKoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJ+687GJceszrE
	KMDBqMTDe6AoM0SINbGsuDL3EKMEB7OSCG/MRaAQb0piZVVqUX58UWlOavEhRiYOTqkGxmsv
	Pl3vsGpo6fRl8my7abtd4VGRC8uMQ8J/BeexBz5mavvYu+NKjKGcyJ/JBQ8fWObm6BTO6vj1
	xm8jnzLjhMLFR/TffzSseRXfk9jKw9t2sJFLatH11qpvX3umt5VfsYo/NHuH9J2NC8xcZZK7
	J7Iknujvankkr+Xx5n5704cFNsfW1DnfVGIpzkg01GIuKk4EAAb289xZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structures allocated by crypto_alloc_* must be freed using crypto_free_*.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 scripts/coccinelle/free/crypto_free.cocci |   45 +++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 scripts/coccinelle/free/crypto_free.cocci

diff --git a/scripts/coccinelle/free/crypto_free.cocci b/scripts/coccinelle/free/crypto_free.cocci
new file mode 100644
index 0000000..0799b70
--- /dev/null
+++ b/scripts/coccinelle/free/crypto_free.cocci
@@ -0,0 +1,45 @@
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
+identifier crypto_alloc =~ "^crypto_alloc_";
+@@
+
+(
+ x = crypto_alloc(...)
+)
+
+@pb@
+expression r.x;
+position p;
+@@
+
+(
+* kfree@p(x)
+)
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

