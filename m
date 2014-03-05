Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbaCEWuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:50:13 -0500
Received: from mout.web.de ([212.227.17.12]:56218 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbaCEWuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:50:12 -0500
Message-ID: <5317AA20.1080402@users.sourceforge.net>
Date: Wed, 05 Mar 2014 23:50:08 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Coccinelle <cocci@systeme.lip6.fr>, kernel-janitors@vger.kernel.org
Subject: Re: [coccicheck Linux 3.14-rc5 PATCH 2 of 5] Deletion of unnecessary
 checks before specific function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:LYSVznvcWgWIx1F6lxJKlbj6NgPMKw28Dkpq7IDlWUvEPUZLpKu
 EOkELfCwQ4VkVSDNu2i2a9rz+g+IrkH46dOLcQWX01DGGls39cjWl4r1kHus1MMtw81Ur57
 NDGUn3buXbXXL046ZZTb54V0Vhtf9GZmgXDbXkWZx2no61Wa14fCGGRha0/c7cEmJJYWckW
 Ss7HvjFtMaVrbQ5CCr39w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If you are convinced that dropping the null tests is a good idea, then you 
>> can submit the patch that makes the change to the relevant maintainers and 
>> mailing lists.

>From 1d2de3c3cfa43cc3c78a91200c41cef438b26a8f Mon Sep 17 00:00:00 2001
From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Mar 2014 18:38:43 +0100
Subject: [PATCH 2/5] Addition of a semantic patch file for listing of
 functions that check their single parameter

This semantic patch pattern tries to find functions that check their single
parameter for usability.

Example:
Null pointer checks are often performed as input parameter validation.

It uses Python statements to write information about the found source code
places in a data format that is a variant of a CSV text file.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 .../list_input_parameter_validation1.cocci         | 55 ++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644
scripts/coccinelle/deletions/list_input_parameter_validation1.cocci

diff --git a/scripts/coccinelle/deletions/list_input_parameter_validation1.cocci
b/scripts/coccinelle/deletions/list_input_parameter_validation1.cocci
new file mode 100644
index 0000000..b0a5a52
--- /dev/null
+++ b/scripts/coccinelle/deletions/list_input_parameter_validation1.cocci
@@ -0,0 +1,55 @@
+@initialize:python@
+@@
+import sys
+result = []
+mark = ['"', '', '"']
+delimiter = '|'
+
+def store_positions(fun, typ, point, places):
+    """Add source code positions to an internal list."""
+    for place in places:
+        fields = []
+        fields.append(fun)
+
+        mark[1] = typ
+        fields.append(''.join(mark))
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
+@safety_check@
+identifier work, input;
+type data_type;
+position pos;
+statement is, es;
+@@
+ void work@pos(data_type input)
+ {
+  ... when any
+( if (input) is else es
+| if (likely(input)) is else es
+)
+  ... when any
+ }
+
+@script:python collection depends on safety_check@
+typ << safety_check.data_type;
+fun << safety_check.work;
+point << safety_check.input;
+places << safety_check.pos;
+@@
+store_positions(fun, typ, point, places)
+
+@finalize:python@
+@@
+if result:
+   result.insert(0, delimiter.join(("function", '"data type"', '"parameter"',
'"source file"', "line", "column")))
+   print("\r\n".join(result))
+else:
+   sys.stderr.write("No result for this analysis!\n")
-- 
1.9.0


