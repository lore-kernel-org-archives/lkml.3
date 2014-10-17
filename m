Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbaJQOKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:10:16 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:36992 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaJQOKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:10:11 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Bob Liu <lliubbo@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Gleb Natapov <gleb@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jianyu Zhan <nasa4836@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konstantin Weitz <konstantin.weitz@gmail.com>, kvm@vger.kernel.org,
        linux390@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH 2/4] mm: introduce new VM_NOZEROPAGE flag
Date: Fri, 17 Oct 2014 16:09:48 +0200
Message-Id: <1413554990-48512-3-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1413554990-48512-1-git-send-email-dingel@linux.vnet.ibm.com>
References: <1413554990-48512-1-git-send-email-dingel@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101714-0029-0000-0000-0000013DF88D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new vma flag to allow an architecture to disable the backing
of non-present, anonymous pages with the read-only empty zero page.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 include/linux/mm.h | 13 +++++++++++--
 mm/huge_memory.c   |  2 +-
 mm/memory.c        |  2 +-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cd33ae2..8f09c91 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -113,7 +113,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_GROWSDOWN	0x00000100	/* general info on the segment */
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
 #define VM_DENYWRITE	0x00000800	/* ETXTBSY on write attempts.. */
-
+#define VM_NOZEROPAGE	0x00001000	/* forbid new zero page mappings */
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000	/* Memory mapped I/O or similar */
 
@@ -179,7 +179,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
 
 /* This mask defines which mm->def_flags a process can inherit its parent */
-#define VM_INIT_DEF_MASK	VM_NOHUGEPAGE
+#define VM_INIT_DEF_MASK	(VM_NOHUGEPAGE | VM_NOZEROPAGE)
 
 /*
  * mapping from the currently active vm_flags protection bits (the
@@ -1293,6 +1293,15 @@ static inline int stack_guard_page_end(struct vm_area_struct *vma,
 		!vma_growsup(vma->vm_next, addr);
 }
 
+static inline int vma_forbids_zeropage(struct vm_area_struct *vma)
+{
+#ifdef CONFIG_NOZEROPAGE
+	return vma->vm_flags & VM_NOZEROPAGE;
+#else
+	return 0;
+#endif
+}
+
 extern struct task_struct *task_of_stack(struct task_struct *task,
 				struct vm_area_struct *vma, bool in_group);
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index de98415..c271265 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -805,7 +805,7 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		return VM_FAULT_OOM;
 	if (unlikely(khugepaged_enter(vma, vma->vm_flags)))
 		return VM_FAULT_OOM;
-	if (!(flags & FAULT_FLAG_WRITE) &&
+	if (!(flags & FAULT_FLAG_WRITE) && !vma_forbids_zeropage(vma) &&
 			transparent_hugepage_use_zero_page()) {
 		spinlock_t *ptl;
 		pgtable_t pgtable;
diff --git a/mm/memory.c b/mm/memory.c
index 64f82aa..1859b2b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2640,7 +2640,7 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		return VM_FAULT_SIGBUS;
 
 	/* Use the zero-page for reads */
-	if (!(flags & FAULT_FLAG_WRITE)) {
+	if (!(flags & FAULT_FLAG_WRITE) && !vma_forbids_zeropage(vma)) {
 		entry = pte_mkspecial(pfn_pte(my_zero_pfn(address),
 						vma->vm_page_prot));
 		page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
-- 
1.8.5.5

