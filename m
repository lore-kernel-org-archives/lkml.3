Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaF2HQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 03:16:14 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55074 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaF2HQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 03:16:12 -0400
Date: Sun, 29 Jun 2014 12:46:04 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Subject: [PATCH] Coccinelle: Script to use ARRAY_SIZE instead of division of
 two sizeofs
Message-ID: <20140629071604.GA16162@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script detects cases where ARRAY_SIZE can be used such as
where there is a division of sizeof the array by the sizeof its first
element or by any indexed element or the element type. It replaces the
division of the two sizeofs by ARRAY_SIZE.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 scripts/coccinelle/misc/array_size.cocci | 87 ++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 scripts/coccinelle/misc/array_size.cocci

diff --git a/scripts/coccinelle/misc/array_size.cocci b/scripts/coccinelle/misc/array_size.cocci
new file mode 100644
index 0000000..81e279c
--- /dev/null
+++ b/scripts/coccinelle/misc/array_size.cocci
@@ -0,0 +1,87 @@
+/// Use ARRAY_SIZE instead of dividing sizeof array with sizeof an element
+///
+//# This makes an effort to find cases where ARRAY_SIZE can be used such as
+//# where there is a division of sizeof the array by the sizeof its first
+//# element or by any indexed element or the element type. It replaces the
+//# division of the two sizeofs by ARRAY_SIZE.
+//
+// Confidence: High
+// Copyright: (C) 2014 Himangi Saraogi.  GPLv2.
+// Comments:
+// Options: --no-includes --include-headers
+
+virtual patch
+virtual context
+virtual org
+virtual report
+
+@i@
+@@
+
+#include <linux/kernel.h>
+
+//----------------------------------------------------------
+//  For context mode
+//----------------------------------------------------------
+
+@depends on i&&context@
+type T;
+T[] E;
+@@
+(
+* (sizeof(E)/sizeof(*E))
+|
+* (sizeof(E)/sizeof(E[...]))
+|
+* (sizeof(E)/sizeof(T))
+)
+
+//----------------------------------------------------------
+//  For patch mode
+//----------------------------------------------------------
+
+@depends on i&&patch@
+type T;
+T[] E;
+@@
+(
+- (sizeof(E)/sizeof(*E))
++ ARRAY_SIZE(E)
+|
+- (sizeof(E)/sizeof(E[...]))
++ ARRAY_SIZE(E)
+|
+- (sizeof(E)/sizeof(T))
++ ARRAY_SIZE(E)
+)
+
+//----------------------------------------------------------
+//  For org and report mode
+//----------------------------------------------------------
+
+@r@
+type T;
+T[] E;
+position p;
+@@
+(
+ (sizeof(E)@p /sizeof(*E))
+|
+ (sizeof(E)@p /sizeof(E[...]))
+|
+ (sizeof(E)@p /sizeof(T))
+)
+
+@script:python depends on i&&org@
+p << r.p;
+@@
+
+coccilib.org.print_todo(p[0], "WARNING should use ARRAY_SIZE")
+
+@script:python depends on i&&report@
+p << r.p;
+@@
+
+msg="WARNING: Use ARRAY_SIZE"
+coccilib.report.print_report(p[0], msg)
+
-- 
1.9.1

