Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3GXSod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:44:33 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:42497 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXSob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:44:31 -0400
Message-ID: <51F02083.7040700@linux.vnet.ibm.com>
Date: Wed, 24 Jul 2013 13:44:19 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6/8] Update the powerpc arch specific memory add/remove handlers
References: <51F01E06.6090800@linux.vnet.ibm.com>
In-Reply-To: <51F01E06.6090800@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072418-8256-0000-0000-0000087D5521
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to properly hot add and remove memory for powerpc the arch
specific callouts need to now complete all of the required work to
fully add or remove the memory.

With this update we can also remove the handler for memory node add
because the powerpc arch specific memory add handler will do all the
work needed. We do still need the memory node remove handler because
systems with memory specified in the memory@XXX nodes in the device tree
we have to use the removal of the node to trigger memory hot remove.

For systems on newer firmware with memory specified in the
ibm,dynamic-reconfiguration-memory node of the device tree this is not an
issue.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---
 arch/powerpc/mm/mem.c                           |   33 +++++++++++++++++++---
 arch/powerpc/platforms/pseries/hotplug-memory.c |   35 ------------------------
 2 files changed, 29 insertions(+), 39 deletions(-)

Index: linux/arch/powerpc/mm/mem.c
===================================================================
--- linux.orig/arch/powerpc/mm/mem.c
+++ linux/arch/powerpc/mm/mem.c
@@ -35,6 +35,7 @@
 #include <linux/memblock.h>
 #include <linux/hugetlb.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 
 #include <asm/pgalloc.h>
 #include <asm/prom.h>
@@ -120,17 +121,24 @@ int arch_add_memory(int nid, u64 start,
 	struct zone *zone;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
+	u64 va_start;
+	int ret;
 
 	pgdata = NODE_DATA(nid);
 
-	start = (unsigned long)__va(start);
-	if (create_section_mapping(start, start + size))
+	va_start = (unsigned long)__va(start);
+	if (create_section_mapping(va_start, va_start + size))
 		return -EINVAL;
 
 	/* this should work for most non-highmem platforms */
 	zone = pgdata->node_zones;
 
-	return __add_pages(nid, zone, start_pfn, nr_pages);
+	ret = __add_pages(nid, zone, start_pfn, nr_pages);
+	if (ret)
+		return ret;
+
+	ret = memblock_add(start, size);
+	return ret;
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
@@ -138,10 +146,27 @@ int arch_remove_memory(u64 start, u64 si
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
+	unsigned long va_addr;
 	struct zone *zone;
+	int ret;
 
 	zone = page_zone(pfn_to_page(start_pfn));
-	return __remove_pages(zone, start_pfn, nr_pages);
+	ret = __remove_pages(zone, start_pfn, nr_pages);
+	if (ret)
+		return ret;
+
+	memblock_remove(start, size);
+
+	/* remove htab bolted mappings */
+	va_addr = (unsigned long)__va(start);
+	ret = remove_section_mapping(va_addr, va_addr + size);
+
+	/* Ensure all vmalloc mappings are flushed in case they also
+	 * hit that section of memory.
+	 */
+	vm_unmap_aliases();
+
+	return ret;
 }
 #endif
 #endif /* CONFIG_MEMORY_HOTPLUG */
Index: linux/arch/powerpc/platforms/pseries/hotplug-memory.c
===================================================================
--- linux.orig/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ linux/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -166,38 +166,6 @@ static inline int pseries_remove_memory(
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
-static int pseries_add_memory(struct device_node *np)
-{
-	const char *type;
-	const unsigned int *regs;
-	unsigned long base;
-	unsigned int lmb_size;
-	int ret = -EINVAL;
-
-	/*
-	 * Check to see if we are actually adding memory
-	 */
-	type = of_get_property(np, "device_type", NULL);
-	if (type == NULL || strcmp(type, "memory") != 0)
-		return 0;
-
-	/*
-	 * Find the base and size of the memblock
-	 */
-	regs = of_get_property(np, "reg", NULL);
-	if (!regs)
-		return ret;
-
-	base = *(unsigned long *)regs;
-	lmb_size = regs[3];
-
-	/*
-	 * Update memory region to represent the memory add
-	 */
-	ret = memblock_add(base, lmb_size);
-	return (ret < 0) ? -EINVAL : 0;
-}
-
 static int pseries_update_drconf_memory(struct of_prop_reconfig *pr)
 {
 	struct of_drconf_cell *new_drmem, *old_drmem;
@@ -251,9 +219,6 @@ static int pseries_memory_notifier(struc
 	int err = 0;
 
 	switch (action) {
-	case OF_RECONFIG_ATTACH_NODE:
-		err = pseries_add_memory(node);
-		break;
 	case OF_RECONFIG_DETACH_NODE:
 		err = pseries_remove_memory(node);
 		break;

