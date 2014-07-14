Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaGNReg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:34:36 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49364 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaGNRe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:34:27 -0400
Date: Mon, 14 Jul 2014 23:04:10 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Subject: [PATCH] Coccinelle: Script to detect incorrect argument to sizeof
Message-ID: <20140714173410.GA5387@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes an effort to find cases where the argument to sizeof is wrong
in memory allocation functions by checking the type of the allocated
memory when it is a double pointer and ensuring the sizeof argument takes
a pointer to the the memory being allocated. There are false positives
in cases the sizeof argument is not used in constructing the return value.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 scripts/coccinelle/misc/badty.cocci | 76 +++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 scripts/coccinelle/misc/badty.cocci

diff --git a/scripts/coccinelle/misc/badty.cocci b/scripts/coccinelle/misc/badty.cocci
new file mode 100644
index 0000000..2fc06fc
--- /dev/null
+++ b/scripts/coccinelle/misc/badty.cocci
@@ -0,0 +1,76 @@
+/// Use ARRAY_SIZE instead of dividing sizeof array with sizeof an element
+///
+//# This makes an effort to find cases where the argument to sizeof is wrong
+//# in memory allocation functions by checking the type of the allocated memory
+//# when it is a double pointer and ensuring the sizeof argument takes a pointer
+//# to the the memory being allocated. There are false positives in cases the
+//# sizeof argument is not used in constructing the return value. The result
+//# may need some reformatting.
+//
+// Confidence: Moderate
+// Copyright: (C) 2014 Himangi Saraogi.  GPLv2.
+// Comments:
+// Options:
+
+virtual patch
+virtual context
+virtual org
+virtual report
+
+//----------------------------------------------------------
+//  For context mode
+//----------------------------------------------------------
+
+@depends on context disable sizeof_type_expr@
+type T;
+T **x;
+@@
+
+  x =
+  <+...sizeof(
+* T
+  )...+>
+
+//----------------------------------------------------------
+//  For patch mode
+//----------------------------------------------------------
+
+@depends on patch disable sizeof_type_expr@
+type T;
+T **x;
+@@
+
+  x =
+  <+...sizeof(
+- T
++ *x
+  )...+>
+
+//----------------------------------------------------------
+//  For org and report mode
+//----------------------------------------------------------
+
+@r disable sizeof_type_expr@
+type T;
+T **x;
+position p;
+@@
+
+  x =
+  <+...sizeof(
+  T@p
+  )...+>
+
+@script:python depends on org@
+p << r.p;
+@@
+
+coccilib.org.print_todo(p[0], "WARNING sizeof argument should be pointer type, not structure type")
+
+@script:python depends on report@
+p << r.p;
+@@
+
+msg="WARNING: Use correct pointer type argument for sizeof"
+coccilib.report.print_report(p[0], msg)
+
-- 
1.9.1

