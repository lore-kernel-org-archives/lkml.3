Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab3KBOcs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 10:32:48 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50582 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3KBOcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 10:32:46 -0400
X-Originating-IP: 50.43.14.201
Date: Sat, 2 Nov 2013 07:32:37 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr
Subject: [PATCH] coccinelle: Add a script to find and remove unnecessary ifs
 with no body
Message-ID: <20131102143236.GA18084@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script matches code like:

if (foo) {}

and either eliminates it (if foo has no side effects) or replaces it
with foo (if foo has side effects).

Works perfectly in report mode; the results of patch mode are
semantically correct but may still benefit from further simplification.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 scripts/coccinelle/misc/unnecessary-if.cocci | 40 ++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 scripts/coccinelle/misc/unnecessary-if.cocci

diff --git a/scripts/coccinelle/misc/unnecessary-if.cocci b/scripts/coccinelle/misc/unnecessary-if.cocci
new file mode 100644
index 0000000..7ed721f
--- /dev/null
+++ b/scripts/coccinelle/misc/unnecessary-if.cocci
@@ -0,0 +1,40 @@
+/// Remove unnecessary ifs with no statements.
+//
+// Confidence: High
+// Options: --no-includes --include-headers
+
+virtual patch
+virtual report
+virtual context
+
+@r1 depends on patch@
+expression E, E2, f;
+@@
+(
+- if (
+      <+... \(f(...)\|++E\|--E\|E++\|E--\|E=E2\) ...+>
+- ) {}
++ ;
+|
+- if (E) {}
+)
+
+@r2 depends on report || context@
+expression E, E2, f;
+position p;
+@@
+(
+- if@p (
+      <+... \(f(...)\|++E\|--E\|E++\|E--\|E=E2\) ...+>
+- ) {}
++ ;
+|
+- if@p (E) {}
+)
+
+@script:python depends on report@
+p << r2.p;
+@@
+
+msg = "WARNING: Unnecessary if with no body."
+coccilib.report.print_report(p[0], msg)
-- 
1.8.4.2

