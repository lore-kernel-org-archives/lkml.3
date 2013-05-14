Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab3ENSVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:21:53 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:57833 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab3ENSUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:20:51 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: bob.liu@oracle.com, dan.magenheimer@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/9] xen/tmem: Remove the boot options and fold them in the tmem.X parameters.
Date: Tue, 14 May 2013 14:09:23 -0400
Message-Id: <1368554966-30469-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1368554966-30469-1-git-send-email-konrad.wilk@oracle.com>
References: <1368554966-30469-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If tmem is built-in or a module, the user has the option on
the command line to influence it by doing: tmem.<some option>
instead of having a variety of "nocleancache", and
"nofrontswap". The others: "noselfballooning" and "selfballooning";
and "noselfshrink" are in a different driver xen-selfballoon.c
and the patches:

 xen/tmem: Remove the usage of 'noselfshrink' and use 'tmem.selfshrink' bool instead.
 xen/tmem: Remove the usage of 'noselfballoon','selfballoon' and use 'tmem.selfballon' bool instead.

removes them.

Also add documentation.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 Documentation/kernel-parameters.txt |   20 ++++++++++++++++++++
 drivers/xen/tmem.c                  |   28 ++++------------------------
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c3bfacb..3de01ed 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3005,6 +3005,26 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Force threading of all interrupt handlers except those
 			marked explicitly IRQF_NO_THREAD.
 
+	tmem		[KNL,XEN]
+			Enable the Transcendent memory driver if built-in.
+
+	tmem.cleancache=0|1 [KNL, XEN]
+			Default is on (1). Disable the usage of the cleancache
+			API to send anonymous pages to the hypervisor.
+
+	tmem.frontswap=0|1 [KNL, XEN]
+			Default is on (1). Disable the usage of the frontswap
+			API to send swap pages to the hypervisor.
+
+	tmem.selfballooning=0|1 [KNL, XEN]
+			Default is on (1). Disable the driving of swap pages
+			to the hypervisor.
+
+	tmem.selfshrinking=0|1 [KNL, XEN]
+			Default is on (1). Partial swapoff that immediately
+			transfers pages from Xen hypervisor back to the
+			kernel based on different criteria.
+
 	topology=	[S390]
 			Format: {off | on}
 			Specify if the kernel should make use of the cpu
diff --git a/drivers/xen/tmem.c b/drivers/xen/tmem.c
index 411c7e3..c1df0ff 100644
--- a/drivers/xen/tmem.c
+++ b/drivers/xen/tmem.c
@@ -33,39 +33,19 @@ __setup("tmem", enable_tmem);
 
 #ifdef CONFIG_CLEANCACHE
 static bool cleancache __read_mostly = true;
-static bool selfballooning __read_mostly = true;
-#ifdef CONFIG_XEN_TMEM_MODULE
 module_param(cleancache, bool, S_IRUGO);
+static bool selfballooning __read_mostly = true;
 module_param(selfballooning, bool, S_IRUGO);
-#else
-static int __init no_cleancache(char *s)
-{
-	cleancache = false;
-	return 1;
-}
-__setup("nocleancache", no_cleancache);
-#endif
 #endif /* CONFIG_CLEANCACHE */
 
 #ifdef CONFIG_FRONTSWAP
 static bool frontswap __read_mostly = true;
-#ifdef CONFIG_XEN_TMEM_MODULE
 module_param(frontswap, bool, S_IRUGO);
-#else
-static int __init no_frontswap(char *s)
-{
-	frontswap = false;
-	return 1;
-}
-__setup("nofrontswap", no_frontswap);
-#endif
 #endif /* CONFIG_FRONTSWAP */
 
 #ifdef CONFIG_XEN_SELFBALLOONING
-static bool frontswap_selfshrinking __read_mostly = true;
-#ifdef CONFIG_XEN_TMEM_MODULE
-module_param(frontswap_selfshrinking, bool, S_IRUGO);
-#endif
+static bool selfshrinking __read_mostly = true;
+module_param(selfshrinking, bool, S_IRUGO);
 #endif /* CONFIG_XEN_SELFBALLOONING */
 
 #define TMEM_CONTROL               0
@@ -423,7 +403,7 @@ static int xen_tmem_init(void)
 	}
 #endif
 #ifdef CONFIG_XEN_SELFBALLOONING
-	xen_selfballoon_init(selfballooning, frontswap_selfshrinking);
+	xen_selfballoon_init(selfballooning, selfshrinking);
 #endif
 	return 0;
 }
-- 
1.7.7.6

