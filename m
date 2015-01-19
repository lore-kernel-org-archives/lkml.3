Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbbASMss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:48:48 -0500
Received: from www.osadl.org ([62.245.132.105]:44779 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbbASMsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:48:46 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] Coccinelle: catch useless conditions comparing two identical constants
Date: Mon, 19 Jan 2015 13:40:02 +0100
Message-Id: <1421671202-9452-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

catch useless conditionals like (1 == 1) or (1 != 0) - it seems like some
code generators like this "style"

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

After stumbling across this code in drivers/media/dvb-frontends/dib7000p.c

<snip>
        value = 0;
        if (1 != 0)
                value |= (1 << 6);
        if (ch->hierarchy == 1)
                value |= (1 << 4);
        if (1 == 1)                                                                                                                                  
                value |= 1;
        switch ((ch->hierarchy == 0 || 1 == 1) ? ch->code_rate_HP :
ch->code_rate_LP) {
        case FEC_2_3:
<snip>

It might be good to have a test for such conditions. If they can 
not be avoided they at least need to be commented as intentional

This semantic patch only provides report mode as it is not generally
possible to deduce a sound fix for such code.

Tested with spatch version 1.0.0-rc23 on linux-3.19.0-rc4 which 
resulted in 12 findings in 6 files - none of which were false
positives.

 scripts/coccinelle/tests/uselesscondition.cocci |   39 +++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 scripts/coccinelle/tests/uselesscondition.cocci

diff --git a/scripts/coccinelle/tests/uselesscondition.cocci b/scripts/coccinelle/tests/uselesscondition.cocci
new file mode 100644
index 0000000..50cff3a
--- /dev/null
+++ b/scripts/coccinelle/tests/uselesscondition.cocci
@@ -0,0 +1,39 @@
+// Find conditions comparing two identical constants
+// e.g 1 == 1 or 1 != 0
+//
+// Some of these code sequences are due to code generators.
+// Never the less they should be flagged and if not removed
+// atleast commented.
+virtual context
+virtual org
+virtual report
+
+@condeq@
+constant C;
+position p;
+@@
+
+<+...
+(
+* C@p == C
+|
+* C@p != C
+|
+* C@p <= C
+|
+* C@p < C
+)
+...+>
+
+@script:python depends on org@
+p << condeq.p;
+@@
+
+cocci.print_main("bad/useless conditional",p)
+
+@script:python depends on report@
+p << condeq.p;
+@@
+
+msg = "bad/useless conditional line %s" % (p[0].line)
+coccilib.report.print_report(p[0],msg)
-- 
1.7.10.4

