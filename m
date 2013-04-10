Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937250Ab3DJXh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:37:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:2913 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937209Ab3DJXh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:37:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="284529140"
Subject: [PATCH 4/5] break up slow_virt_to_phys()
To: bp@alien8.de
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 10 Apr 2013 16:32:54 -0700
References: <20130410233249.7FFCB63B@viggo.jf.intel.com>
In-Reply-To: <20130410233249.7FFCB63B@viggo.jf.intel.com>
Message-Id: <20130410233254.EF273179@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I need to use slow_virt_to_phys()'s functionality for addresses
which might not be valid.  So, I need a copy which can cleanly
return errors instead of doing a BUG_ON().

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/arch/x86/mm/pageattr.c |   40 +++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff -puN arch/x86/mm/pageattr.c~break-up-slow-virt_to_phys arch/x86/mm/pageattr.c
--- linux.git/arch/x86/mm/pageattr.c~break-up-slow-virt_to_phys	2013-04-10 16:23:45.571087500 -0700
+++ linux.git-davehans/arch/x86/mm/pageattr.c	2013-04-10 16:23:45.574087504 -0700
@@ -363,18 +363,7 @@ pte_t *lookup_address(unsigned long addr
 }
 EXPORT_SYMBOL_GPL(lookup_address);
 
-/*
- * This is necessary because __pa() does not work on some
- * kinds of memory, like vmalloc() or the alloc_remap()
- * areas on 32-bit NUMA systems.  The percpu areas can
- * end up in this kind of memory, for instance.
- *
- * This could be optimized, but it is only intended to be
- * used at inititalization time, and keeping it
- * unoptimized should increase the testing coverage for
- * the more obscure platforms.
- */
-phys_addr_t slow_virt_to_phys(void *__virt_addr)
+int kernel_lookup_vaddr(void *__virt_addr, phys_addr_t *result)
 {
 	unsigned long virt_addr = (unsigned long)__virt_addr;
 	phys_addr_t phys_addr;
@@ -385,12 +374,35 @@ phys_addr_t slow_virt_to_phys(void *__vi
 	pte_t *pte;
 
 	pte = lookup_address(virt_addr, &level);
-	BUG_ON(!pte);
+	if (!pte)
+		return -EFAULT;
 	psize = page_level_size(level);
 	pmask = page_level_mask(level);
 	offset = virt_addr & ~pmask;
 	phys_addr = pte_pfn(*pte) << PAGE_SHIFT;
-	return (phys_addr | offset);
+	*result = (phys_addr | offset);
+	return 0;
+}
+
+/*
+ * This is necessary because __pa() does not work on some
+ * kinds of memory, like vmalloc() or the alloc_remap()
+ * areas on 32-bit NUMA systems.  The percpu areas can
+ * end up in this kind of memory, for instance.
+ *
+ * This could be optimized, but it is only intended to be
+ * used at inititalization time, and keeping it
+ * unoptimized should increase the testing coverage for
+ * the more obscure platforms.
+ */
+phys_addr_t slow_virt_to_phys(void *virt_addr)
+{
+	phys_addr_t result;
+	int ret;
+
+	ret = kernel_lookup_vaddr(virt_addr, &result);
+	BUG_ON(ret);
+	return result;
 }
 EXPORT_SYMBOL_GPL(slow_virt_to_phys);
 
_
