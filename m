Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbbABKEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 05:04:40 -0500
Received: from www.osadl.org ([62.245.132.105]:41270 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbbABKEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 05:04:34 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH 2/3 RFC] Coccinelle: check for incorrect DECLARE_COMPLETION use
Date: Fri,  2 Jan 2015 04:59:11 -0500
Message-Id: <1420192752-4889-3-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420192752-4889-1-git-send-email-der.herr@hofr.at>
References: <1420192752-4889-1-git-send-email-der.herr@hofr.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Andreas Platschek <platschek@ict.tuwien.ac.at>
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 .../coccinelle/api/false_declare_completion.cocci  |   50 ++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 scripts/coccinelle/api/false_declare_completion.cocci

diff --git a/scripts/coccinelle/api/false_declare_completion.cocci b/scripts/coccinelle/api/false_declare_completion.cocci
new file mode 100644
index 0000000..a0e3d6c
--- /dev/null
+++ b/scripts/coccinelle/api/false_declare_completion.cocci
@@ -0,0 +1,50 @@
+/* check for incorrect DECLARE_COMPLETION use within a function
+ *
+ * Options:  --no-includes --include-headers
+ */
+virtual context
+virtual patch
+virtual org
+virtual report
+
+/* flag incorrect initializer*/
+@e depends on patch && !(context || org || report)@
+expression cmp;
+identifier f;
+declarer name DECLARE_COMPLETION;
+position p;
+@@
+
+f(...) {
+  <...
+- DECLARE_COMPLETION@p(cmp);
++ DECLARE_COMPLETION_ONSTACK(cmp);
+  ...>
+}
+
+@ep depends on !patch && (context || org || report)@
+expression cmp;
+identifier f;
+position p;
+@@
+
+f(...) {
+  <...
+* DECLARE_COMPLETION@p(cmp);
+  ...>
+}
+
+@script:python depends on org@
+p << ep.p;
+@@
+
+msg="WARNING: possible incorrect use of DECLARE_COMPLETION"
+coccilib.org.print_todo(p[0], msg)
+
+@script:python depends on report@
+p << ep.p;
+@@
+
+msg="WARNING: possible incorrect use of DECLARE_COMPLETION"
+coccilib.report.print_report(p[0], msg)
+
-- 
1.7.10.4

