Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaJVIcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:32:42 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:49037 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbaJVIat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:30:49 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>
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
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH 2/4] mm: introduce mm_forbids_zeropage function
Date: Wed, 22 Oct 2014 10:30:22 +0200
Message-Id: <1413966624-12447-3-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1413966624-12447-1-git-send-email-dingel@linux.vnet.ibm.com>
References: <1413966624-12447-1-git-send-email-dingel@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102208-0021-0000-0000-0000017DB44D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function stub to allow architectures to disable for
an mm_structthe backing of non-present, anonymous pages with
read-only empty zero pages.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
---
 include/linux/mm.h | 4 ++++
 mm/huge_memory.c   | 2 +-
 mm/memory.c        | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cd33ae2..0a2022e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -56,6 +56,10 @@ extern int sysctl_legacy_va_layout;
 #define __pa_symbol(x)  __pa(RELOC_HIDE((unsigned long)(x), 0))
 #endif
 
+#ifndef mm_forbids_zeropage
+#define mm_forbids_zeropage(X)  (0)
+#endif
+
 extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index de98415..357a381 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -805,7 +805,7 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		return VM_FAULT_OOM;
 	if (unlikely(khugepaged_enter(vma, vma->vm_flags)))
 		return VM_FAULT_OOM;
-	if (!(flags & FAULT_FLAG_WRITE) &&
+	if (!(flags & FAULT_FLAG_WRITE) && !mm_forbids_zeropage(mm) &&
 			transparent_hugepage_use_zero_page()) {
 		spinlock_t *ptl;
 		pgtable_t pgtable;
diff --git a/mm/memory.c b/mm/memory.c
index 64f82aa..f275a9d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2640,7 +2640,7 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		return VM_FAULT_SIGBUS;
 
 	/* Use the zero-page for reads */
-	if (!(flags & FAULT_FLAG_WRITE)) {
+	if (!(flags & FAULT_FLAG_WRITE) && !mm_forbids_zeropage(mm)) {
 		entry = pte_mkspecial(pfn_pte(my_zero_pfn(address),
 						vma->vm_page_prot));
 		page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
-- 
1.8.5.5

