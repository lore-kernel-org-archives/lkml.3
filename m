Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbaCEWzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:55:55 -0500
Received: from mout.web.de ([212.227.15.3]:49906 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbaCEWzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:55:53 -0500
Message-ID: <5317AB75.4000601@users.sourceforge.net>
Date: Wed, 05 Mar 2014 23:55:49 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Coccinelle <cocci@systeme.lip6.fr>, kernel-janitors@vger.kernel.org
Subject: Re: [coccicheck Linux 3.14-rc5 PATCH 4 of 5] Deletion of unnecessary
 checks before specific function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Pbp80UXLZKpkpLlcShEVlGmQ+uaSrav/TBoTBtp6IH5VGjUr74F
 vMLDcNHXGquXjpuDJAaXmerTQH7szzYuDBSL5UxAbhmy+PIC5g80d/pduEPsff/20WeCi7J
 v34NwBZUh04RfwIkQIoN82rQs1NkqAM36vYLDf3oKoEubM/0HKcOGF/VEUP6L9ISfoIL3Fk
 5I/SUTiwlVLGBJF3vsiXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If you are convinced that dropping the null tests is a good idea, then you 
>> can submit the patch that makes the change to the relevant maintainers and 
>> mailing lists.

>From e6a21b920fcca2f6f01c9528909dc036a9b3bc41 Mon Sep 17 00:00:00 2001
From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Mar 2014 19:10:32 +0100
Subject: [PATCH 4/5] Addition of a semantic patch file for listing of
 unnecessary checks before a few known functions

This semantic patch pattern tries to find source code places where a check
is performed for an expression that is passed to a function (like "kfree")
which checks this single parameter itself for usability.
Redundant value or pointer checks can be avoided here.

The pattern contains a special comment in a regular expression for a SmPL
constraint which supports extensions.

It uses Python statements to write information about the found places in
a data format that is a variant of a CSV text file.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 ...nctions_with_unnecessary_checks_template1.cocci | 59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644
scripts/coccinelle/deletions/list_functions_with_unnecessary_checks_template1.cocci

diff --git
a/scripts/coccinelle/deletions/list_functions_with_unnecessary_checks_template1.cocci
b/scripts/coccinelle/deletions/list_functions_with_unnecessary_checks_template1.cocci
new file mode 100644
index 0000000..d2637e8
--- /dev/null
+++
b/scripts/coccinelle/deletions/list_functions_with_unnecessary_checks_template1.cocci
@@ -0,0 +1,59 @@
+@initialize:python@
+@@
+import sys
+result = []
+mark = ['"', '', '"']
+delimiter = '|'
+
+def store_positions(fun, point, places):
+    """Add source code positions to an internal list."""
+    for place in places:
+        fields = []
+        fields.append(fun)
+
+        fields.append(point)
+
+        mark[1] = place.file.replace('"', '""')
+        fields.append(''.join(mark))
+
+        fields.append(place.line)
+        fields.append(str(int(place.column) + 1))
+        result.append(delimiter.join(fields))
+
+@is_unnecessary_check@
+expression data;
+identifier work;
+identifier release =~ "^(?x)
+(?:
+   (?:kz?|slob_)free
+|
+   (?:
+# Alternation placeholder
+   )
+)$";
+position pos;
+type t;
+@@
+ t work@pos(...)
+ {
+  ... when any
+( if (data) release(data);
+| if (likely(data)) release(data);
+)
+  ... when any
+ }
+
+@script:python collection depends on is_unnecessary_check@
+fun << is_unnecessary_check.work;
+point << is_unnecessary_check.data;
+places << is_unnecessary_check.pos;
+@@
+store_positions(fun, point, places)
+
+@finalize:python@
+@@
+if result:
+   result.insert(0, delimiter.join(("function", '"parameter"', '"source file"',
"line", "column")))
+   print("\r\n".join(result))
+else:
+   sys.stderr.write("No result for this analysis!\n")
-- 
1.9.0

