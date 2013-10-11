Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab3JKT7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:59:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627Ab3JKTll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 069/135] powerpc: Fix memory hotplug with sparse vmemmap
Date: Fri, 11 Oct 2013 12:39:10 -0700
Message-Id: <20131011193952.786691435@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Fontenot <nfont@linux.vnet.ibm.com>

commit f7e3334a6bcb42e7295a9bd9cb36ca4e6e4e66b4 upstream.

Previous commit 46723bfa540... introduced a new config option
HAVE_BOOTMEM_INFO_NODE that ended up breaking memory hot-remove for ppc
when sparse vmemmap is not defined.

This patch defines HAVE_BOOTMEM_INFO_NODE for ppc and adds the call to
register_page_bootmem_info_node. Without this we get a BUG_ON for memory
hot remove in put_page_bootmem().

This also adds a stub for register_page_bootmem_memmap to allow ppc to build
with sparse vmemmap defined. Leaving this as a stub is fine since the same
vmemmap addresses are also handled in vmemmap_populate and as such are
properly mapped.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/init_64.c |    4 ++++
 arch/powerpc/mm/mem.c     |    9 +++++++++
 mm/Kconfig                |    2 +-
 3 files changed, 14 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -300,5 +300,9 @@ void vmemmap_free(unsigned long start, u
 {
 }
 
+void register_page_bootmem_memmap(unsigned long section_nr,
+				  struct page *start_page, unsigned long size)
+{
+}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
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
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -183,7 +183,7 @@ config MEMORY_HOTPLUG_SPARSE
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
 	select MEMORY_ISOLATION
-	select HAVE_BOOTMEM_INFO_NODE if X86_64
+	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 


