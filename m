Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaILJ0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:26:36 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:65375 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaILJ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:26:30 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 3/6] Coccinelle: Semantic patch for replacing seq_printf calls with equivalent but simpler functions
Date: Fri, 12 Sep 2014 11:25:51 +0200
Message-Id: <1410513954-28909-4-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using seq_printf to print a simple string is a lot more expensive than
it needs to be, since seq_puts exists [1]. This semantic patch
purposely also matches non-literals, since in that case it is also
safer to use puts.

We also handle the cases where the format string is exactly "%s" or
"%c" and replace with puts/putc.

[1] printf must push all the, in this case non-existent, varargs into
a va_arg structure on the stack, then vprintf takes over and calls
vsnprintf, ...

seq_{printf,puts,putc} all return -1 on error, 0 on success.

trace_seq_{printf,puts,putc} all return 0 on failure, but printf and
putc return 1 on success, puts returns the length of the
string. Therefore, we only do the printf->puts conversion where the
return value of trace_seq_printf is either unused or used as a
boolean; the printf->putc conversion can safely be done anywhere.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 scripts/coccinelle/api/seq_printf.cocci | 156 ++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)
 create mode 100644 scripts/coccinelle/api/seq_printf.cocci

diff --git a/scripts/coccinelle/api/seq_printf.cocci b/scripts/coccinelle/api/seq_printf.cocci
new file mode 100644
index 0000000..c5525bf
--- /dev/null
+++ b/scripts/coccinelle/api/seq_printf.cocci
@@ -0,0 +1,156 @@
+/// Using seq_printf to print a simple string is a lot more expensive
+/// than it needs to be, since seq_puts exists [1]. This semantic
+/// patch purposely also matches non-literals, since in that case it
+/// is also safer to use puts.
+///
+/// We also handle the cases where the format string is exactly "%s"
+/// or "%c" and replace with puts/putc.
+///
+/// [1] printf must push all the, in this case non-existent, varargs
+/// into a va_arg structure on the stack, then vprintf takes over and
+/// calls vsnprintf, ...
+///
+/// seq_{printf,puts,putc} all return -1 on error, 0 on success.
+///
+/// trace_seq_{printf,puts,putc} all return 0 on failure, but printf
+/// and putc return 1 on success, puts returns the length of the
+/// string. Therefore, we only do the printf->puts conversion where
+/// the return value of trace_seq_printf is either unused or used as a
+/// boolean; the printf->putc conversion can safely be done anywhere.
+///
+//
+// Confidence: High
+// Options: --no-includes --include-headers
+//
+
+virtual patch
+virtual context
+virtual org
+virtual report
+
+
+// In order to DTRT when the format string contains %%, we need to
+// process it with python. If t is actually an expression and not just
+// a string literal, it is very unlikely to contain two adjacent %
+// characters. But note that this does not handle the case where t is
+// either a macro or a const char* which happens to point to a string
+// containing two %%. git grep 'define.*%%' shows that macros
+// containing %% are usually used in inline asm, and register
+// specifiers tend to be unusable as format specifiers.
+@p1a depends on patch@
+expression s;
+expression t;
+position p;
+@@
+  seq_printf@p(s, t)
+
+@script:python p1b@
+t << p1a.t;
+tt;
+@@
+import re
+coccinelle.tt = re.sub('%%', '%', t)
+
+@p1c depends on p1a@
+expression p1a.s;
+expression p1a.t;
+position p1a.p;
+identifier p1b.tt;
+@@
+- seq_printf@p(s, t)
++ seq_puts(s, tt)
+
+// Using the string literal "%s" seems to be broken with my version of
+// coccinelle (it matches any format string containing a single format
+// specifier), so use a slightly uglier method.
+@p2 depends on patch@
+expression s;
+expression t;
+format f =~ "^s$";
+@@
+- seq_printf(s, "%@f@", t)
++ seq_puts(s, t)
+
+@p3 depends on patch@
+expression s;
+expression t;
+format f =~ "^c$";
+@@
+- seq_printf(s, "%@f@", t)
++ seq_putc(s, t)
+
+
+
+
+@tp1a depends on patch@
+expression s;
+expression t;
+position p;
+@@
+  trace_seq_printf@p(s, t);
+
+@script:python tp1b@
+t << tp1a.t;
+tt;
+@@
+import re
+coccinelle.tt = re.sub('%%', '%', t)
+
+@tp1c depends on tp1a@
+expression tp1a.s;
+expression tp1a.t;
+position tp1a.p;
+identifier tp1b.tt;
+@@
+- trace_seq_printf@p(s, t);
++ trace_seq_puts(s, tt);
+
+@tp2 depends on patch@
+expression s;
+expression t;
+format f =~ "^s$";
+@@
+- trace_seq_printf(s, "%@f@", t);
++ trace_seq_puts(s, t);
+
+
+@tp3a depends on patch@
+expression s;
+expression t;
+position p;
+@@
+  !trace_seq_printf@p(s, t)
+
+@script:python tp3b@
+t << tp3a.t;
+tt;
+@@
+import re
+coccinelle.tt = re.sub('%%', '%', t)
+
+@tp3c depends on tp3a@
+expression tp3a.s;
+expression tp3a.t;
+position tp3a.p;
+identifier tp3b.tt;
+@@
+- !trace_seq_printf@p(s, t)
++ !trace_seq_puts(s, tt)
+
+@tp4 depends on patch@
+expression s;
+expression t;
+format f =~ "^s$";
+@@
+- !trace_seq_printf(s, "%@f@", t)
++ !trace_seq_puts(s, t)
+
+
+@tp5 depends on patch@
+expression s;
+expression t;
+format f =~ "^c$";
+@@
+- trace_seq_printf(s, "%@f@", t)
++ trace_seq_putc(s, t)
+
-- 
2.0.4

