Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaF0UDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:03:42 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:56168 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbaF0UDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:03:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUHAIzNrVNXQCoO/2dsb2JhbABagw2rbwUBAQEBAQEFAW0BmQKBDRd1hGAjgRo3iEYBxEwXhWSJIR2ELQWPeopjk3uDRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH V2] scripts/coccinelle/free: add NULL test before freeing functions
Date: Fri, 27 Jun 2014 22:02:15 +0200
Message-Id: <1403899335-3867-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warns on NULL check before the following functions:

kfree
usb_free_urb
debugfs_remove
debugfs_remove_recursive

Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2:
   -Add 3 more functions to kfree (suggested by Joe Perches)
   -Update warning message to involve code analysis (suggested by Julia Lawall)

 scripts/coccinelle/free/ifnullfree.cocci | 34 ++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 scripts/coccinelle/free/ifnullfree.cocci

diff --git a/scripts/coccinelle/free/ifnullfree.cocci b/scripts/coccinelle/free/ifnullfree.cocci
new file mode 100644
index 0000000..626309c
--- /dev/null
+++ b/scripts/coccinelle/free/ifnullfree.cocci
@@ -0,0 +1,34 @@
+/// NULL check before some freeing functions is not needed.
+///
+/// Based on checkpatch warning
+/// "kfree(NULL) is safe this check is probably not required"
+/// and kfreeaddr.cocci by Julia Lawall.
+///
+/// Comments: -
+/// Options: --no-includes --include-headers
+
+virtual org
+virtual report
+virtual context
+
+@r depends on context || report || org @
+expression E;
+position p;
+@@
+
+* if (E)
+*	\(kfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|usb_free_urb\)(E);
+
+@script:python depends on org@
+p << r.p;
+@@
+
+cocci.print_main("freeing", p)
+
+@script:python depends on report@
+p << r.p;
+@@
+
+msg = "WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values."
+coccilib.report.print_report(p[0], msg)
+
-- 
1.8.4.5

