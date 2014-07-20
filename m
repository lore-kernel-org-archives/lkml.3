Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaGTVg6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:36:58 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41889 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaGTVg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:36:57 -0400
Date: Mon, 21 Jul 2014 03:06:35 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Subject: [PATCH] Coccinelle: Script to replace if and BUG with BUG_ON
Message-ID: <20140720213635.GA12365@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script detects cases where BUG() follows an if condition on an
expression and replaces the if condition and BUG() with a BUG_ON having
the conditional expression of the if statement as argument.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 scripts/coccinelle/misc/bugon.cocci | 62 +++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100644 scripts/coccinelle/misc/bugon.cocci

diff --git a/scripts/coccinelle/misc/bugon.cocci b/scripts/coccinelle/misc/bugon.cocci
new file mode 100644
index 0000000..556456c
--- /dev/null
+++ b/scripts/coccinelle/misc/bugon.cocci
@@ -0,0 +1,62 @@
+/// Use BUG_ON instead of a if condition followed by BUG.
+///
+//# This makes an effort to find cases where BUG() follows an if
+//# condition on an expression and replaces the if condition and BUG()
+//# with a BUG_ON having the conditional expression of the if statement
+//# as argument.
+//
+// Confidence: High
+// Copyright: (C) 2014 Himangi Saraogi.  GPLv2.
+// Comments:
+// Options: --no-includes, --include-headers
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
+@depends on context@
+expression e;
+@@
+
+*if (e) BUG();
+
+//----------------------------------------------------------
+//  For patch mode
+//----------------------------------------------------------
+
+@depends on patch@
+expression e;
+@@
+
+-if (e) BUG();
++BUG_ON(e);
+
+//----------------------------------------------------------
+//  For org and report mode
+//----------------------------------------------------------
+
+@r@
+expression e;
+position p;
+@@
+
+ if (e) BUG@p ();
+
+@script:python depends on org@
+p << r.p;
+@@
+
+coccilib.org.print_todo(p[0], "WARNING use BUG_ON")
+
+@script:python depends on report@
+p << r.p;
+@@
+
+msg="WARNING: Use BUG_ON"
+coccilib.report.print_report(p[0], msg)
+
-- 
1.9.1

