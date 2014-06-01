Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaFARrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 13:47:45 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:46385 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaFARrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 13:47:43 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Julia.Lawall@lip6.fr, Gilles.Muller@lip6.fr, nicolas.palix@imag.fr,
        mmarek@suse.cz, linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH] coccicheck: Add unneeded return variable test
Date: Sun,  1 Jun 2014 14:47:26 -0300
Message-Id: <1401644846-11962-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This semantic patch looks for variables that are initialized with a
constant, are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

There are 8 patches accepted reported by this semantic patch and more
than 300 fixes to be applied.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 scripts/coccinelle/misc/returnvar.cocci | 66 +++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100644 scripts/coccinelle/misc/returnvar.cocci

diff --git a/scripts/coccinelle/misc/returnvar.cocci b/scripts/coccinelle/misc/returnvar.cocci
new file mode 100644
index 0000000..605955a
--- /dev/null
+++ b/scripts/coccinelle/misc/returnvar.cocci
@@ -0,0 +1,66 @@
+///
+/// Removes unneeded variable used to store return value.
+///
+// Confidence: Moderate
+// Copyright: (C) 2012 Peter Senna Tschudin, INRIA/LIP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments: Comments on code can be deleted if near code that is removed.
+//           "when strict" can be removed to get more hits, but adds false
+//           positives
+// Options: --no-includes --include-headers
+
+virtual patch
+virtual report
+virtual context
+virtual org
+
+@depends on patch@
+type T;
+constant C;
+identifier ret;
+@@
+- T ret = C;
+... when != ret
+    when strict
+return
+- ret
++ C
+;
+
+@depends on context@
+type T;
+constant C;
+identifier ret;
+@@
+* T ret = C;
+... when != ret
+    when strict
+* return ret;
+
+@r1 depends on report || org@
+type T;
+constant C;
+identifier ret;
+position p1, p2;
+@@
+T ret@p1 = C;
+... when != ret
+    when strict
+return ret@p2;
+
+@script:python depends on report@
+p1 << r1.p1;
+p2 << r1.p2;
+C << r1.C;
+ret << r1.ret;
+@@
+coccilib.report.print_report(p1[0], "Unneeded variable: \"" + ret + "\". Return \"" + C + "\" on line " + p2[0].line)
+
+@script:python depends on org@
+p1 << r1.p1;
+p2 << r1.p2;
+C << r1.C;
+ret << r1.ret;
+@@
+cocci.print_main("unneeded \"" + ret + "\" variable", p1)
+cocci.print_sec("return " + C + " here", p2)
-- 
1.8.3.1

