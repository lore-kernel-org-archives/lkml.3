Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaHFRxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:53:21 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:41460 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbaHFRxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:53:18 -0400
Date: Wed, 6 Aug 2014 13:30:40 -0400
From: Peter Feiner <pfeiner@google.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jerome Marchand <jmarchan@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH -mm v6 06/13] pagemap: use walk->vma instead of calling
 find_vma()
Message-ID: <20140806173040.GA28526@google.com>
References: <1406920849-25908-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1406920849-25908-7-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406920849-25908-7-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 03:20:42PM -0400, Naoya Horiguchi wrote:
> Page table walker has the information of the current vma in mm_walk, so
> we don't have to call find_vma() in each pagemap_hugetlb_range() call.

You could also get rid of a bunch of code in pagemap_pte_range:

---
 fs/proc/task_mmu.c | 33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 9b30bdd..e9af130 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1035,16 +1035,14 @@ static inline void thp_pmd_to_pagemap_entry(pagemap_entry_t *pme, struct pagemap
 static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			     struct mm_walk *walk)
 {
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = walk->vma
 	struct pagemapread *pm = walk->private;
 	spinlock_t *ptl;
 	pte_t *pte;
 	int err = 0;
-	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
+	pagemap_entry_t pme;
 
-	/* find the first VMA at or above 'addr' */
-	vma = find_vma(walk->mm, addr);
-	if (vma && pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		int pmd_flags2;
 
 		if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(*pmd))
@@ -1069,28 +1067,9 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	if (pmd_trans_unstable(pmd))
 		return 0;
 	for (; addr != end; addr += PAGE_SIZE) {
-		int flags2;
-
-		/* check to see if we've left 'vma' behind
-		 * and need a new, higher one */
-		if (vma && (addr >= vma->vm_end)) {
-			vma = find_vma(walk->mm, addr);
-			if (vma && (vma->vm_flags & VM_SOFTDIRTY))
-				flags2 = __PM_SOFT_DIRTY;
-			else
-				flags2 = 0;
-			pme = make_pme(PM_NOT_PRESENT(pm->v2) | PM_STATUS2(pm->v2, flags2));
-		}
-
-		/* check that 'vma' actually covers this address,
-		 * and that it isn't a huge page vma */
-		if (vma && (vma->vm_start <= addr) &&
-		    !is_vm_hugetlb_page(vma)) {
-			pte = pte_offset_map(pmd, addr);
-			pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
-			/* unmap before userspace copy */
-			pte_unmap(pte);
-		}
+		pte = pte_offset_map(pmd, addr);
+		pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
+		pte_unmap(pte);
 		err = add_to_pagemap(addr, &pme, pm);
 		if (err)
 			return err;
-- 
2.0.0.526.g5318336

