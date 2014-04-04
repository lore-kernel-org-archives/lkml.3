Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaDDG1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:27:38 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42666 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaDDG13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:27:29 -0400
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        ak@linux.intel.com, peterz@infradead.org, mingo@kernel.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Subject: [PATCH V2 1/2] mm: move FAULT_AROUND_ORDER to arch/
Date: Fri,  4 Apr 2014 11:57:14 +0530
Message-Id: <1396592835-24767-2-git-send-email-maddy@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396592835-24767-1-git-send-email-maddy@linux.vnet.ibm.com>
References: <1396592835-24767-1-git-send-email-maddy@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040406-2000-0000-0000-0000107FD412
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov with faultaround patchset introduced
vm_ops->map_pages() for mapping easy accessible pages around
fault address in hope to reduce number of minor page faults.

This patch creates infrastructure to move the FAULT_AROUND_ORDER
to arch/ using Kconfig. This will enable architecture maintainers
to decide on suitable FAULT_AROUND_ORDER value based on
performance data for that architecture. Patch also adds
FAULT_AROUND_ORDER Kconfig element in arch/X86.

Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
---
 arch/x86/Kconfig   |    4 ++++
 include/linux/mm.h |    9 +++++++++
 mm/memory.c        |   12 +++++-------
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9c0a657..5833f22 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1177,6 +1177,10 @@ config DIRECT_GBPAGES
 	  support it. This can improve the kernel's performance a tiny bit by
 	  reducing TLB pressure. If in doubt, say "Y".
 
+config FAULT_AROUND_ORDER
+	int
+	default "4"
+
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0bd4359..b93c1c3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -26,6 +26,15 @@ struct file_ra_state;
 struct user_struct;
 struct writeback_control;
 
+/*
+ * Fault around order is a control knob to decide the fault around pages.
+ * Default value is set to 0UL (disabled), but the arch can override it as
+ * desired.
+ */
+#ifndef CONFIG_FAULT_AROUND_ORDER
+#define CONFIG_FAULT_AROUND_ORDER 0
+#endif
+
 #ifndef CONFIG_NEED_MULTIPLE_NODES	/* Don't use mapnrs, do it properly */
 extern unsigned long max_mapnr;
 
diff --git a/mm/memory.c b/mm/memory.c
index b02c584..22a4a89 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3358,10 +3358,8 @@ void do_set_pte(struct vm_area_struct *vma, unsigned long address,
 	update_mmu_cache(vma, address, pte);
 }
 
-#define FAULT_AROUND_ORDER 4
-
 #ifdef CONFIG_DEBUG_FS
-static unsigned int fault_around_order = FAULT_AROUND_ORDER;
+static unsigned int fault_around_order = CONFIG_FAULT_AROUND_ORDER;
 
 static int fault_around_order_get(void *data, u64 *val)
 {
@@ -3371,7 +3369,7 @@ static int fault_around_order_get(void *data, u64 *val)
 
 static int fault_around_order_set(void *data, u64 val)
 {
-	BUILD_BUG_ON((1UL << FAULT_AROUND_ORDER) > PTRS_PER_PTE);
+	BUILD_BUG_ON((1UL << CONFIG_FAULT_AROUND_ORDER) > PTRS_PER_PTE);
 	if (1UL << val > PTRS_PER_PTE)
 		return -EINVAL;
 	fault_around_order = val;
@@ -3406,14 +3404,14 @@ static inline unsigned long fault_around_pages(void)
 {
 	unsigned long nr_pages;
 
-	nr_pages = 1UL << FAULT_AROUND_ORDER;
+	nr_pages = 1UL << CONFIG_FAULT_AROUND_ORDER;
 	BUILD_BUG_ON(nr_pages > PTRS_PER_PTE);
 	return nr_pages;
 }
 
 static inline unsigned long fault_around_mask(void)
 {
-	return ~((1UL << (PAGE_SHIFT + FAULT_AROUND_ORDER)) - 1);
+	return ~((1UL << (PAGE_SHIFT + CONFIG_FAULT_AROUND_ORDER)) - 1);
 }
 #endif
 
@@ -3471,7 +3469,7 @@ static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * if page by the offset is not ready to be mapped (cold cache or
 	 * something).
 	 */
-	if (vma->vm_ops->map_pages) {
+	if ((vma->vm_ops->map_pages) && (fault_around_pages() > 1)) {
 		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 		do_fault_around(vma, address, pte, pgoff, flags);
 		if (!pte_same(*pte, orig_pte))
-- 
1.7.10.4

