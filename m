Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbbABKEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 05:04:43 -0500
Received: from www.osadl.org ([62.245.132.105]:41272 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbbABKEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 05:04:37 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH 3/3 RFC] Coccinelle: incorrect use of multiple init_completion
Date: Fri,  2 Jan 2015 04:59:12 -0500
Message-Id: <1420192752-4889-4-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420192752-4889-1-git-send-email-der.herr@hofr.at>
References: <1420192752-4889-1-git-send-email-der.herr@hofr.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Andreas Platschek <platschek@ict.tuwien.ac.at>
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 scripts/coccinelle/api/false_init_compltion.cocci |   74 +++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 scripts/coccinelle/api/false_init_compltion.cocci

diff --git a/scripts/coccinelle/api/false_init_compltion.cocci b/scripts/coccinelle/api/false_init_compltion.cocci
new file mode 100644
index 0000000..a97dfcf
--- /dev/null
+++ b/scripts/coccinelle/api/false_init_compltion.cocci
@@ -0,0 +1,74 @@
+/* check for incorrect use of multiple init_completion on the
+ * same struct completion and switch the reinitializations to use
+ * reinit_completion()
+ *
+ * Options: --no-includes --include-headers
+ */
+virtual context
+virtual patch
+virtual org
+virtual report
+
+/* mark first call to init_completion */
+@c@
+expression cmp;
+position p;
+@@
+
+ init_completion@p(cmp)
+
+/* flag incorrect reinitializations */
+@d depends on patch && !(context || org || report)@
+expression E,c.cmp;
+identifier f;
+position c.p,p1;
+@@
+
+  init_completion@p(cmp)
+  <+...
+(
+  E = cmp
+|
+  E = &cmp
+|
+  f(..., cmp,...)
+|
+  f(..., &cmp,...)
+)
+  ...+>
+- init_completion@p1(cmp)
++ reinit_completion1(cmp)
+
+@dp depends on !patch && (context || org || report)@
+identifier f;
+expression E,c.cmp;
+position c.p,p1;
+@@
+
+  init_completion@p(cmp)
+  <+...
+(
+  E = cmp
+|
+  E = &cmp
+|
+  f(..., cmp,...)
+|
+  f(..., &cmp,...)
+)
+  ...+>
+  init_completion@p1(cmp)
+
+@script:python depends on org@
+p << dp.p1;
+@@
+
+msg="WARNING: possible reinit by init_completion"
+coccilib.org.print_todo(p[0], msg)
+
+@script:python depends on report@
+p << dp.p1;
+@@
+
+msg="WARNING: possible reinit by init_completion"
+coccilib.report.print_report(p[0], msg)
-- 
1.7.10.4

