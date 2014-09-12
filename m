Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaILJ1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:27:00 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:61347 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaILJ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:26:30 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 1/6] Coccinelle: Semantic patch for replacing puts with putc
Date: Fri, 12 Sep 2014 11:25:49 +0200
Message-Id: <1410513954-28909-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using seq_puts to write a one-character string is suboptimal,
since puts has to call strlen(). Replace those instances with
putc. This also tends to give a tiny code size reduction at the
call site.

seq_put[sc] return -1 on error, 0 on success.
trace_seq_put[sc] return how much was written, which is either 0 or 1.

In both cases, _putc is a drop-in replacement for _puts when the
argument is a one-character string.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 scripts/coccinelle/api/seq_putsc.cocci | 61 ++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 scripts/coccinelle/api/seq_putsc.cocci

diff --git a/scripts/coccinelle/api/seq_putsc.cocci b/scripts/coccinelle/api/seq_putsc.cocci
new file mode 100644
index 0000000..bb11097
--- /dev/null
+++ b/scripts/coccinelle/api/seq_putsc.cocci
@@ -0,0 +1,61 @@
+/// Using seq_puts to write a one-character string is suboptimal,
+/// since puts has to call strlen(). Replace those instances with
+/// putc. This also tends to give a tiny code size reduction at the
+/// call site.
+///
+/// seq_put[sc] return -1 on error, 0 on success.
+/// trace_seq_put[sc] return how much was written, which is either 0 or 1.
+///
+/// In both cases, _putc is a drop-in replacement for _puts when the
+/// argument is a one-character string.
+///
+//
+// Confidence: High
+// Options: --no-includes --include-headers
+//
+// Since the changes to any given line should consist of changing an s
+// to a c and two " to ', the generated patches should be easy to
+// proofread.
+
+virtual patch
+virtual context
+virtual org
+virtual report
+
+@putc1 depends on patch@
+position p;
+expression s;
+constant c;
+@@
+  \(trace_seq_puts@p\|seq_puts@p\)(s, c)
+
+// Use python to check whether the string constant consists of a
+// single character, and if so, create an "identifier" containing that
+// single character as a C literal.
+@script:python putc2@
+s << putc1.s;
+c << putc1.c;
+ch;
+@@
+import re
+import sys
+
+m = re.match("^\"(.|\\\\.)\"$", c)
+if not m:
+    cocci.include_match(False)
+else:
+    coccinelle.ch = "'" + m.group(1) + "'"
+
+@putc3 depends on patch@
+position putc1.p;
+expression putc1.s;
+constant putc1.c;
+identifier putc2.ch;
+@@
+(
+- seq_puts@p(s, c)
++ seq_putc(s, ch)
+|
+- trace_seq_puts@p(s, c)
++ trace_seq_putc(s, ch)
+)
-- 
2.0.4

