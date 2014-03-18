Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbaCRVL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:11:57 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:38755 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbaCRVLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:11:55 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Julia.Lawall@lip6.fr, Gilles.Muller@lip6.fr, nicolas.palix@imag.fr,
        mmarek@suse.cz, peter.senna@gmail.com, linux-kernel@vger.kernel.org,
        cocci@systeme.lip6.fr, gregkh@linuxfoundation.org,
        bernat.ada@gmail.com, elezegarcia@gmail.com,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] Coccicheck: Remove memcpy to struct assignment test
Date: Tue, 18 Mar 2014 22:11:32 +0100
Message-Id: <1395177092-3023-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Coccinelle script scripts/coccinelle/misc/memcpy-assign.cocci look
for opportunities to replace a call to memcpy by a struct assignment.
This patch removes memcpy-assign.cocci as it is not clear that this
convention has an impact on the generated code.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 scripts/coccinelle/misc/memcpy-assign.cocci | 103 ----------------------------
 1 file changed, 103 deletions(-)
 delete mode 100644 scripts/coccinelle/misc/memcpy-assign.cocci

diff --git a/scripts/coccinelle/misc/memcpy-assign.cocci b/scripts/coccinelle/misc/memcpy-assign.cocci
deleted file mode 100644
index afd058b..0000000
--- a/scripts/coccinelle/misc/memcpy-assign.cocci
+++ /dev/null
@@ -1,103 +0,0 @@
-//
-// Replace memcpy with struct assignment.
-//
-// Confidence: High
-// Copyright: (C) 2012 Peter Senna Tschudin, INRIA/LIP6.  GPLv2.
-// URL: http://coccinelle.lip6.fr/
-// Comments:
-// Options: --no-includes --include-headers
-
-virtual patch
-virtual report
-virtual context
-virtual org
-
-@r1 depends on !patch@
-identifier struct_name;
-struct struct_name to;
-struct struct_name from;
-struct struct_name *top;
-struct struct_name *fromp;
-position p;
-@@
-memcpy@p(\(&(to)\|top\), \(&(from)\|fromp\), \(sizeof(to)\|sizeof(from)\|sizeof(struct struct_name)\|sizeof(*top)\|sizeof(*fromp)\))
-
-@script:python depends on report@
-p << r1.p;
-@@
-coccilib.report.print_report(p[0],"Replace memcpy with struct assignment")
-
-@depends on context@
-position r1.p;
-@@
-*memcpy@p(...);
-
-@script:python depends on org@
-p << r1.p;
-@@
-cocci.print_main("Replace memcpy with struct assignment",p)
-
-@depends on patch@
-identifier struct_name;
-struct struct_name to;
-struct struct_name from;
-@@
-(
--memcpy(&(to), &(from), sizeof(to));
-+to = from;
-|
--memcpy(&(to), &(from), sizeof(from));
-+to = from;
-|
--memcpy(&(to), &(from), sizeof(struct struct_name));
-+to = from;
-)
-
-@depends on patch@
-identifier struct_name;
-struct struct_name to;
-struct struct_name *from;
-@@
-(
--memcpy(&(to), from, sizeof(to));
-+to = *from;
-|
--memcpy(&(to), from, sizeof(*from));
-+to = *from;
-|
--memcpy(&(to), from, sizeof(struct struct_name));
-+to = *from;
-)
-
-@depends on patch@
-identifier struct_name;
-struct struct_name *to;
-struct struct_name from;
-@@
-(
--memcpy(to, &(from), sizeof(*to));
-+ *to = from;
-|
--memcpy(to, &(from), sizeof(from));
-+ *to = from;
-|
--memcpy(to, &(from), sizeof(struct struct_name));
-+ *to = from;
-)
-
-@depends on patch@
-identifier struct_name;
-struct struct_name *to;
-struct struct_name *from;
-@@
-(
--memcpy(to, from, sizeof(*to));
-+ *to = *from;
-|
--memcpy(to, from, sizeof(*from));
-+ *to = *from;
-|
--memcpy(to, from, sizeof(struct struct_name));
-+ *to = *from;
-)
-
-- 
1.8.3.1

