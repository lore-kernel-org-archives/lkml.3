Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3GXSfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:35:21 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:32800 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3GXSfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:35:19 -0400
Message-ID: <51F01E5F.80307@linux.vnet.ibm.com>
Date: Wed, 24 Jul 2013 13:35:11 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        isimatu.yasuaki@jp.fujitsu.com
Subject: [PATCH 1/8] register bootmem pages for powerpc when sparse vmemmap
 is not defined
References: <51F01E06.6090800@linux.vnet.ibm.com>
In-Reply-To: <51F01E06.6090800@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072418-0260-0000-0000-0000035D0DB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous commit 46723bfa540... introduced a new config option
HAVE_BOOTMEM_INFO_NODE that ended up breaking memory hot-remove for powerpc
when sparse vmemmap is not defined.

This patch defines HAVE_BOOTMEM_INFO_NODE for powerpc and adds the call to
register_page_bootmem_info_node. Without this patch we get a BUG_ON for memory
hot remove in put_page_bootmem().

This also adds a stub for register_page_bootmem_memmap to allow powerpc to
build with sparse vmemmap defined.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---

---
 arch/powerpc/mm/init_64.c |    6 ++++++
 arch/powerpc/mm/mem.c     |    9 +++++++++
 mm/Kconfig                |    2 +-
 3 files changed, 16 insertions(+), 1 deletion(-)

Index: linux/arch/powerpc/mm/init_64.c
===================================================================
--- linux.orig/arch/powerpc/mm/init_64.c
+++ linux/arch/powerpc/mm/init_64.c
@@ -300,5 +300,11 @@ void vmemmap_free(unsigned long start, u
 {
 }
 
+void register_page_bootmem_memmap(unsigned long section_nr,
+				  struct page *start_page, unsigned long size)
+{
+	WARN_ONCE(1, KERN_INFO
+		  "Sparse Vmemmap not fully supported for bootmem info nodes\n");
+}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
Index: linux/arch/powerpc/mm/mem.c
===================================================================
--- linux.orig/arch/powerpc/mm/mem.c
+++ linux/arch/powerpc/mm/mem.c
@@ -297,12 +297,21 @@ void __init paging_init(void)
 }
 #endif /* ! CONFIG_NEED_MULTIPLE_NODES */
 
+static void __init register_page_bootmem_info(void)
+{
+	int i;
+
+	for_each_online_node(i)
+		register_page_bootmem_info_node(NODE_DATA(i));
+}
+
 void __init mem_init(void)
 {
 #ifdef CONFIG_SWIOTLB
 	swiotlb_init(0);
 #endif
 
+	register_page_bootmem_info();
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
 	set_max_mapnr(max_pfn);
 	free_all_bootmem();
Index: linux/mm/Kconfig
===================================================================
--- linux.orig/mm/Kconfig
+++ linux/mm/Kconfig
@@ -183,7 +183,7 @@ config MEMORY_HOTPLUG_SPARSE
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
 	select MEMORY_ISOLATION
-	select HAVE_BOOTMEM_INFO_NODE if X86_64
+	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 


