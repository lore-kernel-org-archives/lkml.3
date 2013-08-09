Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab3HISAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:00:52 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:57858 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547Ab3HISAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:00:38 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2] coccinelle: replace 0/1 with false/true in functions returning bool
Date: Fri,  9 Aug 2013 17:59:53 +0000
Message-Id: <1376071193-21146-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376064946-20232-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1376064946-20232-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This semantic patch replaces "return {0,1};" with "return
{false,true};" in functions returning bool.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
v2: Simplified script, and eliminate whitespace mangling at the same
time. Thanks to Julia Lawall.

 scripts/coccinelle/misc/boolreturn.cocci |   56 ++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 scripts/coccinelle/misc/boolreturn.cocci

diff --git a/scripts/coccinelle/misc/boolreturn.cocci b/scripts/coccinelle/misc/boolreturn.cocci
new file mode 100644
index 0000000..c8d494c
--- /dev/null
+++ b/scripts/coccinelle/misc/boolreturn.cocci
@@ -0,0 +1,56 @@
+/// Return statements in functions returning bool should use
+/// true/false instead of 1/0.
+//
+// Confidence: High
+
+virtual patch
+virtual report
+
+
+@r1 depends on patch@
+identifier fn;
+typedef bool;
+symbol false;
+symbol true;
+@@
+
+bool fn ( ... )
+{
+...
+return
+(
+- 0
++ false
+|
+- 1
++ true
+)
+  ;
+...
+}
+
+@r2 depends on !patch@
+identifier fn;
+position p;
+@@
+
+bool fn ( ... )
+{
+	...
+return
+(
+* 0@p
+|
+* 1@p
+)
+  ;
+	...
+}
+
+
+@script:python depends on report@
+p << r2.p;
+fn << r2.fn;
+@@
+
+coccilib.report.print_report(p[0], "WARNING: return of 0/1 in function '%s' with return type bool" % fn)
-- 
1.7.9.5

