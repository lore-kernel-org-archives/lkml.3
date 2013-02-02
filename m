Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab3BBQUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 11:20:09 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:6601 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757778Ab3BBQUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 11:20:05 -0500
X-IronPort-AV: E=Sophos;i="4.84,591,1355094000"; 
   d="scan'208";a="1116347"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Julia.Lawall@lip6.fr, Gilles.Muller@lip6.fr, nicolas.palix@imag.fr,
        cocci@systeme.lip6.fr, mmarek@suse.cz, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH] scripts/coccinelle: find constant additions that could be bit ors
Date: Sat,  2 Feb 2013 17:19:55 +0100
Message-Id: <1359821995-27910-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Semantic patch (http://coccinelle.lip6.fr/) to check for constants that are
added but are used elsewhere as bitmasks.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 scripts/coccinelle/misc/orplus.cocci |   55 +++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/scripts/coccinelle/misc/orplus.cocci b/scripts/coccinelle/misc/orplus.cocci
new file mode 100644
index 0000000..4a28cef
--- /dev/null
+++ b/scripts/coccinelle/misc/orplus.cocci
@@ -0,0 +1,55 @@
+/// Check for constants that are added but are used elsewhere as bitmasks
+/// The results should be checked manually to ensure that the nonzero
+/// bits in the two constants are actually disjoint.
+///
+// Confidence: Moderate
+// Copyright: (C) 2013 Julia Lawall, INRIA/LIP6.  GPLv2.
+// Copyright: (C) 2013 Gilles Muller, INRIA/LIP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual org
+virtual report
+virtual context
+
+@r@
+constant c;
+identifier i;
+expression e;
+@@
+
+(
+e | c@i
+|
+e & c@i
+|
+e |= c@i
+|
+e &= c@i
+)
+
+@s@
+constant r.c,c1;
+identifier i1;
+position p;
+@@
+
+(
+ c1 + c - 1
+|
+*c1@i1 +@p c
+)
+
+@script:python depends on org@
+p << s.p;
+@@
+
+cocci.print_main("sum of probable bitmasks, consider |",p)
+
+@script:python depends on report@
+p << s.p;
+@@
+
+msg = "WARNING: sum of probable bitmasks, consider |"
+coccilib.report.print_report(p[0],msg)

