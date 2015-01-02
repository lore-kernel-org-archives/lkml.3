Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168AbbABKEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 05:04:36 -0500
Received: from www.osadl.org ([62.245.132.105]:41268 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbbABKEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 05:04:33 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH 1/3 RFC] Coccinelle: drop unecessary duplicated init_compltion calls
Date: Fri,  2 Jan 2015 04:59:10 -0500
Message-Id: <1420192752-4889-2-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420192752-4889-1-git-send-email-der.herr@hofr.at>
References: <1420192752-4889-1-git-send-email-der.herr@hofr.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Andreas Platschek <platschek@ict.tuwien.ac.at>
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 .../coccinelle/api/duplicate_init_completion.cocci |   59 ++++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 scripts/coccinelle/api/duplicate_init_completion.cocci

diff --git a/scripts/coccinelle/api/duplicate_init_completion.cocci b/scripts/coccinelle/api/duplicate_init_completion.cocci
new file mode 100644
index 0000000..889715a
--- /dev/null
+++ b/scripts/coccinelle/api/duplicate_init_completion.cocci
@@ -0,0 +1,59 @@
+/* drop unnecessary duplicated init_compltion calls
+ * in patch mode one must be check that it is actually
+ * the second init_completion that can be removed and not
+ * the first.
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
+/* flag duplicate initializations */
+@d depends on patch && !(context || org || report)@
+expression E,c.cmp;
+identifier f;
+position c.p,p1;
+@@
+
+  init_completion@p(cmp)
+  ... when != E = cmp
+      when != E = &cmp
+      when != f(..., cmp, ...)
+      when != f(..., &cmp, ...)
+- init_completion@p1(cmp);
+
+@dp depends on !patch && (context || org || report)@
+identifier f;
+expression E,c.cmp;
+position c.p,p1;
+@@
+
+  init_completion@p(cmp)
+  ... when != E = cmp
+      when != E = &cmp
+      when != f(..., cmp, ...)
+      when != f(..., &cmp, ...)
+  init_completion@p1(cmp);
+
+@script:python depends on org@
+p << dp.p1;
+@@
+
+msg="WARNING: possible duplicate init_completion"
+coccilib.org.print_todo(p[0], msg)
+
+@script:python depends on report@
+p << dp.p1;
+@@
+
+msg="WARNING: possible duplicate init_completion"
+coccilib.report.print_report(p[0], msg)
-- 
1.7.10.4

