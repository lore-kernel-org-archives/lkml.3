Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaEHJ2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:28:45 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:49351 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbaEHJ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:28:32 -0400
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        ak@linux.intel.com, peterz@infradead.org, mingo@kernel.org,
        dave.hansen@intel.com, Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Subject: [PATCH V4 1/2] mm: move FAULT_AROUND_ORDER to arch/
Date: Thu,  8 May 2014 14:58:15 +0530
Message-Id: <1399541296-18810-2-git-send-email-maddy@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399541296-18810-1-git-send-email-maddy@linux.vnet.ibm.com>
References: <1399541296-18810-1-git-send-email-maddy@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050809-2674-0000-0000-00000E2C5DE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov with 8c6e50b029 commit introduced
vm_ops->map_pages() for mapping easy accessible pages around
fault address in hope to reduce number of minor page faults.

This patch creates infrastructure to modify the FAULT_AROUND_ORDER
value using mm/Kconfig. This will enable architecture maintainers
to decide on suitable FAULT_AROUND_ORDER value based on
performance data for that architecture. Patch also defaults
FAULT_AROUND_ORDER Kconfig element to 4.

Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
---
 mm/Kconfig  |    8 ++++++++
 mm/memory.c |   25 ++++++-------------------
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index ebe5880..c7fc4f1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -176,6 +176,14 @@ config MOVABLE_NODE
 config HAVE_BOOTMEM_INFO_NODE
 	def_bool n
 
+#
+# Fault around order is a control knob to decide the fault around pages.
+# Default value is set to 4 , but the arch can override it as desired.
+#
+config FAULT_AROUND_ORDER
+	int
+	default	4
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
diff --git a/mm/memory.c b/mm/memory.c
index 037b812..e3931ef 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3402,11 +3402,9 @@ void do_set_pte(struct vm_area_struct *vma, unsigned long address,
 	update_mmu_cache(vma, address, pte);
 }
 
-#define FAULT_AROUND_ORDER 4
+unsigned int fault_around_order __read_mostly = CONFIG_FAULT_AROUND_ORDER;
 
 #ifdef CONFIG_DEBUG_FS
-static unsigned int fault_around_order = FAULT_AROUND_ORDER;
-
 static int fault_around_order_get(void *data, u64 *val)
 {
 	*val = fault_around_order;
@@ -3415,7 +3413,6 @@ static int fault_around_order_get(void *data, u64 *val)
 
 static int fault_around_order_set(void *data, u64 val)
 {
-	BUILD_BUG_ON((1UL << FAULT_AROUND_ORDER) > PTRS_PER_PTE);
 	if (1UL << val > PTRS_PER_PTE)
 		return -EINVAL;
 	fault_around_order = val;
@@ -3435,31 +3432,21 @@ static int __init fault_around_debugfs(void)
 	return 0;
 }
 late_initcall(fault_around_debugfs);
+#endif
 
 static inline unsigned long fault_around_pages(void)
 {
-	return 1UL << fault_around_order;
-}
-
-static inline unsigned long fault_around_mask(void)
-{
-	return ~((1UL << (PAGE_SHIFT + fault_around_order)) - 1);
-}
-#else
-static inline unsigned long fault_around_pages(void)
-{
 	unsigned long nr_pages;
 
-	nr_pages = 1UL << FAULT_AROUND_ORDER;
-	BUILD_BUG_ON(nr_pages > PTRS_PER_PTE);
+	nr_pages = 1UL << fault_around_order;
+	VM_BUG_ON(nr_pages > PTRS_PER_PTE);
 	return nr_pages;
 }
 
 static inline unsigned long fault_around_mask(void)
 {
-	return ~((1UL << (PAGE_SHIFT + FAULT_AROUND_ORDER)) - 1);
+	return ~((1UL << (PAGE_SHIFT + fault_around_order)) - 1);
 }
-#endif
 
 static void do_fault_around(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, pgoff_t pgoff, unsigned int flags)
@@ -3515,7 +3502,7 @@ static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * if page by the offset is not ready to be mapped (cold cache or
 	 * something).
 	 */
-	if (vma->vm_ops->map_pages) {
+	if ((vma->vm_ops->map_pages) && fault_around_order) {
 		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 		do_fault_around(vma, address, pte, pgoff, flags);
 		if (!pte_same(*pte, orig_pte))
-- 
1.7.10.4

