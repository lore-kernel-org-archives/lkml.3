Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433Ab3HIQQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:16:04 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56071 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934417Ab3HIQP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:15:57 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH/RFC] coccinelle: replace 0/1 with false/true in functions returning bool
Date: Fri,  9 Aug 2013 16:15:46 +0000
Message-Id: <1376064946-20232-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This semantic patch replaces "return {0,1};" with "return
{false,true};" in functions returning bool. There doesn't seem to be
any false positives, but some whitespace mangling is happening, for
example:

diff -u -p a/block/blk-throttle.c b/block/blk-throttle.c
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -734,9 +734,7 @@ static inline void throtl_extend_slice(s
 static bool throtl_slice_used(struct throtl_grp *tg, bool rw)
 {
 	if (time_in_range(jiffies, tg->slice_start[rw], tg->slice_end[rw]))
-		return 0;
-
-	return 1;
+		return false;return true;
 }

Is there a way to prevent this, or is this the kind of thing which
must be handled in post-processing?

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 scripts/coccinelle/misc/boolreturn.cocci |   51 ++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 scripts/coccinelle/misc/boolreturn.cocci

diff --git a/scripts/coccinelle/misc/boolreturn.cocci b/scripts/coccinelle/misc/boolreturn.cocci
new file mode 100644
index 0000000..e6ece0d
--- /dev/null
+++ b/scripts/coccinelle/misc/boolreturn.cocci
@@ -0,0 +1,51 @@
+/// Return statements in functions returning bool should use
+/// true/false instead of 1/0.
+//
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
+(
+-	return 0;
++	return false;
+|
+-	return 1;
++	return true;
+)
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
+(
+*	return 0@p ;
+|
+*	return 1@p ;
+)
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

