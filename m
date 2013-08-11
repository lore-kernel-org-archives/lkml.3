Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab3HKVFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 17:05:43 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:40074 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab3HKVFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 17:05:42 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v3] coccinelle: replace 0/1 with false/true in functions returning bool
Date: Sun, 11 Aug 2013 21:05:12 +0000
Message-Id: <1376255112-22787-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376071193-21146-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1376071193-21146-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This semantic patch replaces "return {0,1};" with "return
{false,true};" in functions returning bool.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
v2: Simplified script, and eliminate whitespace mangling at the same
time. Thanks to Julia Lawall.

v3: Further improvements from Julia. In particular, it now also does
header files.

 scripts/coccinelle/misc/boolreturn.cocci |   58 ++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)
 create mode 100644 scripts/coccinelle/misc/boolreturn.cocci

diff --git a/scripts/coccinelle/misc/boolreturn.cocci b/scripts/coccinelle/misc/boolreturn.cocci
new file mode 100644
index 0000000..a43c7b0
--- /dev/null
+++ b/scripts/coccinelle/misc/boolreturn.cocci
@@ -0,0 +1,58 @@
+/// Return statements in functions returning bool should use
+/// true/false instead of 1/0.
+//
+// Confidence: High
+// Options: --no-includes --include-headers
+
+virtual patch
+virtual report
+virtual context
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
+<...
+return
+(
+- 0
++ false
+|
+- 1
++ true
+)
+  ;
+...>
+}
+
+@r2 depends on report || context@
+identifier fn;
+position p;
+@@
+
+bool fn ( ... )
+{
+<...
+return
+(
+* 0@p
+|
+* 1@p
+)
+  ;
+...>
+}
+
+
+@script:python depends on report@
+p << r2.p;
+fn << r2.fn;
+@@
+
+msg = "WARNING: return of 0/1 in function '%s' with return type bool" % fn
+coccilib.report.print_report(p[0], msg)
-- 
1.7.9.5

