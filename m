Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaIURzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 13:55:36 -0400
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:54018 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751559AbaIURzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 13:55:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3353:3865:3867:3870:3871:4321:4605:5007:6119:6261:8556:8603:8660:9592:10004:10026:10848:11026:11657:11658:11914:12043:12296:12438:12517:12519:12555:12683:13148:13230:14093:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jewel82_105a5ae2c3855
X-Filterd-Recvd-Size: 3514
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 2/2] powerpc: pci-ioda: Use a single function to emit logging messages
Date: Sun, 21 Sep 2014 10:55:06 -0700
Message-Id: <39e19ff7a164c674d94c31ce2650374f0b191ff3.1411320262.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1411320262.git.joe@perches.com>
References: <cover.1411320262.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for 3 functions when a single one will do.

Modify the function declaring macros to call the single function.

Reduces object code size a little:

$ size arch/powerpc/platforms/powernv/pci-ioda.o*
   text	   data	    bss	    dec	    hex	filename
  22303	   1073	   6680	  30056	   7568	arch/powerpc/platforms/powernv/pci-ioda.o.new
  22840	   1121	   6776	  30737	   7811	arch/powerpc/platforms/powernv/pci-ioda.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 58 ++++++++++++++++---------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 16bb93f..b0d31083 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -41,34 +41,36 @@
 #include "powernv.h"
 #include "pci.h"
 
-#define define_pe_printk_level(func, kern_level)		\
-static void func(const struct pnv_ioda_pe *pe, const char *fmt, ...)	\
-{								\
-	struct va_format vaf;					\
-	va_list args;						\
-	char pfix[32];						\
-								\
-	va_start(args, fmt);					\
-								\
-	vaf.fmt = fmt;						\
-	vaf.va = &args;						\
-								\
-	if (pe->pdev)						\
-		strlcpy(pfix, dev_name(&pe->pdev->dev),		\
-			sizeof(pfix));				\
-	else							\
-		sprintf(pfix, "%04x:%02x     ",			\
-			pci_domain_nr(pe->pbus),		\
-			pe->pbus->number);			\
-	printk(kern_level "pci %s: [PE# %.3d] %pV",		\
-	       pfix, pe->pe_number, &vaf);			\
-								\
-	va_end(args);						\
-}								\
-
-define_pe_printk_level(pe_err, KERN_ERR);
-define_pe_printk_level(pe_warn, KERN_WARNING);
-define_pe_printk_level(pe_info, KERN_INFO);
+static void pe_level_printk(const struct pnv_ioda_pe *pe, const char *level,
+			    const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	char pfix[32];
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (pe->pdev)
+		strlcpy(pfix, dev_name(&pe->pdev->dev), sizeof(pfix));
+	else
+		sprintf(pfix, "%04x:%02x     ",
+			pci_domain_nr(pe->pbus), pe->pbus->number);
+
+	printk("%spci %s: [PE# %.3d] %pV",
+	       level, pfix, pe->pe_number, &vaf);
+
+	va_end(args);
+}
+
+#define pe_err(pe, fmt, ...)					\
+	pe_level_printk(pe, KERN_ERR, fmt, ##__VA_ARGS__)
+#define pe_warn(pe, fmt, ...)					\
+	pe_level_printk(pe, KERN_WARNING, fmt, ##__VA_ARGS__)
+#define pe_info(pe, fmt, ...)					\
+	pe_level_printk(pe, KERN_INFO, fmt, ##__VA_ARGS__)
 
 /*
  * stdcix is only supposed to be used in hypervisor real mode as per
-- 
1.8.1.2.459.gbcd45b4.dirty

