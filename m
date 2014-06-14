Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbaFNPpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 11:45:54 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:46232 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbaFNPpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 11:45:49 -0400
Date: Sat, 14 Jun 2014 21:15:41 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Subject: [PATCH] Coccinelle : Script to detect cast after memory allocation
Message-ID: <20140614154541.GA4179@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script detects cases of use of cast for the value returned by
kmalloc, kzalloc, kcalloc, kmem_cache_alloc, kmem_cache_zalloc,
kmem_cache_alloc_node, kmalloc_node and kzalloc_node and removes
the cast as it is not useful. This Coccinelle script replaces
drop_kmalloc_cast.cocci as it removes the casting in more limited
cases of kmalloc, kzalloc and kcalloc.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 scripts/coccinelle/api/alloc/alloc_cast.cocci      | 72 ++++++++++++++++++++++
 .../coccinelle/api/alloc/drop_kmalloc_cast.cocci   | 67 --------------------
 2 files changed, 72 insertions(+), 67 deletions(-)
 create mode 100644 scripts/coccinelle/api/alloc/alloc_cast.cocci
 delete mode 100644 scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci

diff --git a/scripts/coccinelle/api/alloc/alloc_cast.cocci b/scripts/coccinelle/api/alloc/alloc_cast.cocci
new file mode 100644
index 0000000..6c308ee
--- /dev/null
+++ b/scripts/coccinelle/api/alloc/alloc_cast.cocci
@@ -0,0 +1,72 @@
+/// Remove casting the values returned by memory allocation functions
+/// like kmalloc, kzalloc, kmem_cache_alloc, kmem_cache_zalloc etc.
+///
+//# This makes an effort to find cases of casting of values returned by
+//# kmalloc, kzalloc, kcalloc, kmem_cache_alloc, kmem_cache_zalloc,
+//# kmem_cache_alloc_node, kmalloc_node and kzalloc_node and removes
+//# the casting as it is not required. The result in the patch case may
+//#need some reformatting.
+//
+// Confidence: High
+// Copyright: 2014, Himangi Saraogi  GPLv2.
+// Comments:
+// Options: --no-includes --include-headers
+//
+
+virtual context
+virtual patch
+virtual org
+virtual report
+
+//----------------------------------------------------------
+//  For context mode
+//----------------------------------------------------------
+
+@depends on context@
+type T;
+@@
+
+* (T *)
+  \(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
+   kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\)(...)
+
+//----------------------------------------------------------
+//  For patch mode
+//----------------------------------------------------------
+
+@depends on patch@
+type T;
+@@
+
+- (T *)
+  (\(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
+   kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\)(...))
+
+//----------------------------------------------------------
+//  For org and report mode
+//----------------------------------------------------------
+
+@r depends on org || report@
+type T;
+position p;
+@@
+
+ (T@p *)\(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
+   kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\)(...)
+
+@script:python depends on org@
+p << r.p;
+t << r.T;
+@@
+
+coccilib.org.print_safe_todo(p[0], t)
+
+@script:python depends on report@
+p << r.p;
+t << r.T;
+@@
+
+msg="WARNING: casting value returned by memory allocation function to (%s *) is useless." % (t)
+coccilib.report.print_report(p[0], msg)
+
+
diff --git a/scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci b/scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci
deleted file mode 100644
index bd5d08b..0000000
--- a/scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci
+++ /dev/null
@@ -1,67 +0,0 @@
-///
-/// Casting (void *) value returned by kmalloc is useless
-/// as mentioned in Documentation/CodingStyle, Chap 14.
-///
-// Confidence: High
-// Copyright: 2009,2010 Nicolas Palix, DIKU.  GPLv2.
-// URL: http://coccinelle.lip6.fr/
-// Options: --no-includes --include-headers
-//
-// Keywords: kmalloc, kzalloc, kcalloc
-// Version min: < 2.6.12 kmalloc
-// Version min: < 2.6.12 kcalloc
-// Version min:   2.6.14 kzalloc
-//
-
-virtual context
-virtual patch
-virtual org
-virtual report
-
-//----------------------------------------------------------
-//  For context mode
-//----------------------------------------------------------
-
-@depends on context@
-type T;
-@@
-
-* (T *)
-  \(kmalloc\|kzalloc\|kcalloc\)(...)
-
-//----------------------------------------------------------
-//  For patch mode
-//----------------------------------------------------------
-
-@depends on patch@
-type T;
-@@
-
-- (T *)
-  \(kmalloc\|kzalloc\|kcalloc\)(...)
-
-//----------------------------------------------------------
-//  For org and report mode
-//----------------------------------------------------------
-
-@r depends on org || report@
-type T;
-position p;
-@@
-
- (T@p *)\(kmalloc\|kzalloc\|kcalloc\)(...)
-
-@script:python depends on org@
-p << r.p;
-t << r.T;
-@@
-
-coccilib.org.print_safe_todo(p[0], t)
-
-@script:python depends on report@
-p << r.p;
-t << r.T;
-@@
-
-msg="WARNING: casting value returned by k[cmz]alloc to (%s *) is useless." % (t)
-coccilib.report.print_report(p[0], msg)
-- 
1.9.1

