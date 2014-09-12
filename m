Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaILJ0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:26:30 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:47430 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbaILJ0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:26:25 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 2/6] Coccinelle: Semantic patch for joining seq_puts calls
Date: Fri, 12 Sep 2014 11:25:50 +0200
Message-Id: <1410513954-28909-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consecutive calls of seq_puts with literal strings, where the return
value is not checked, might as well be replaced by a single call with
the combined string. This gives smaller generated code (less function
calls), a slight .rodata reduction, since nul and padding bytes are
eliminated, and hits fewer cache lines (nothing guarantees that the
linker places string literals which are used together close together
in the final image).

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 scripts/coccinelle/api/seq_puts_concat.cocci | 71 ++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100644 scripts/coccinelle/api/seq_puts_concat.cocci

diff --git a/scripts/coccinelle/api/seq_puts_concat.cocci b/scripts/coccinelle/api/seq_puts_concat.cocci
new file mode 100644
index 0000000..0e7afc3
--- /dev/null
+++ b/scripts/coccinelle/api/seq_puts_concat.cocci
@@ -0,0 +1,71 @@
+/// Consecutive calls of seq_puts with literal strings, where the
+/// return value is not checked, might as well be replaced by a single
+/// call with the combined string. This gives smaller generated code
+/// (less function calls), a slight .rodata reduction, since nul and
+/// padding bytes are eliminated, and hits fewer cache lines (nothing
+/// guarantees that the linker places string literals which are used
+/// together close together in the final image).
+///
+/// Two small, but in practice irrelevant, issues:
+///
+/// (1) If one of the strings is also used elsewhere, this reduces the
+/// possiblity for the linker to do string merging (thus increasing
+/// .rodata), but these multiple seq_puts calls are mostly to print
+/// multi-line headers in various /proc or /sys files.
+///
+/// (2) seq_puts is all-or-nothing, so if there is not room for the
+/// entire string, one would previously get some of the strings
+/// printed, but not all; combining the strings means nothing is
+/// printed. So this formally changes the semantics of the
+/// code. However, usually there is room.
+///
+///
+//
+// Run and apply repeatedly until no furter patches are generated,
+// then fix up the whitespace.
+//
+// Confidence: High
+// Options: --no-includes --include-headers
+
+
+virtual patch
+virtual context
+virtual org
+virtual report
+
+// Prevent "token already tagged" error
+@r@
+position p;
+@@
+  seq_puts(...);
+  seq_puts(...);
+  seq_puts@p(...);
+
+
+@concat1 depends on patch@
+expression s;
+constant c1, c2;
+position p1 != r.p, p2 != r.p;
+@@
+  seq_puts@p1(s, c1);
+  seq_puts@p2(s, c2);
+
+@script:python concat2@
+c1 << concat1.c1;
+c2 << concat1.c2;
+c3;
+@@
+
+// The indentation probably needs to be fixed manually
+coccinelle.c3 = c1 + "\n\t" + c2
+
+@concat3 depends on patch@
+identifier concat2.c3;
+expression concat1.s;
+constant concat1.c1, concat1.c2;
+position concat1.p1, concat1.p2;
+@@
+- seq_puts@p1(s, c1);
+- seq_puts@p2(s, c2);
++ seq_puts(s, c3);
+
-- 
2.0.4

