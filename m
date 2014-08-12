Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaHLKsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 06:48:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaHLKsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 06:48:02 -0400
Date: Tue, 12 Aug 2014 11:47:58 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] x86,mm: fix pte_special versus pte_numa
Message-ID: <20140812104758.GE7970@suse.de>
References: <53DD5F20.8010507@oracle.com>
 <alpine.LSU.2.11.1408040418500.3406@eggly.anvils>
 <20140805144439.GW10819@suse.de>
 <alpine.LSU.2.11.1408051649330.6591@eggly.anvils>
 <53E17F06.30401@oracle.com>
 <53E989FB.5000904@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <53E989FB.5000904@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin has shown oopses on ffffea0003480048 and ffffea0003480008
at mm/memory.c:1132, running Trinity on different 3.16-rc-next kernels:
where zap_pte_range() checks page->mapping to see if PageAnon(page).

Those addresses fit struct pages for pfns d2001 and d2000, and in each
dump a register or a stack slot showed d2001730 or d2000730: pte flags
0x730 are PCD ACCESSED PROTNONE SPECIAL IOMAP; and Sasha's e820 map has
a hole between cfffffff and 100000000, which would need special access.

Commit c46a7c817e66 ("x86: define _PAGE_NUMA by reusing software bits on
the PMD and PTE levels") has broken vm_normal_page(): a PROTNONE SPECIAL
pte no longer passes the pte_special() test, so zap_pte_range() goes on
to try to access a non-existent struct page.

Fix this by refining pte_special() (SPECIAL with PRESENT or PROTNONE)
to complement pte_numa() (SPECIAL with neither PRESENT nor PROTNONE).
A hint that this was a problem was that c46a7c817e66 added pte_numa()
test to vm_normal_page(), and moved its is_zero_pfn() test from slow to
fast path: This was papering over a pte_special() snag when the zero page
was encountered during zap. This patch reverts vm_normal_page() to how it
was before, relying on pte_special().

It still appears that this patch may be incomplete: aren't there other
places which need to be handling PROTNONE along with PRESENT?  For example,
pte_mknuma() clears _PAGE_PRESENT and sets _PAGE_NUMA, but on a PROT_NONE
area, that would make it pte_special(). This is side-stepped by the fact
that NUMA hinting faults skipped PROT_NONE VMAs and there are no grounds
where a NUMA hinting fault on a PROT_NONE VMA would be interesting.

Fixes: c46a7c817e66 ("x86: define _PAGE_NUMA by reusing software bits on the PMD and PTE levels")
Reported-and-tested-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: stable@vger.kernel.org [3.16]
---
 arch/x86/include/asm/pgtable.h | 9 +++++++--
 mm/memory.c                    | 7 +++----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 0ec0560..aa97a07 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -131,8 +131,13 @@ static inline int pte_exec(pte_t pte)
 
 static inline int pte_special(pte_t pte)
 {
-	return (pte_flags(pte) & (_PAGE_PRESENT|_PAGE_SPECIAL)) ==
-				 (_PAGE_PRESENT|_PAGE_SPECIAL);
+	/*
+	 * See CONFIG_NUMA_BALANCING pte_numa in include/asm-generic/pgtable.h.
+	 * On x86 we have _PAGE_BIT_NUMA == _PAGE_BIT_GLOBAL+1 ==
+	 * __PAGE_BIT_SOFTW1 == _PAGE_BIT_SPECIAL.
+	 */
+	return (pte_flags(pte) & _PAGE_SPECIAL) &&
+		(pte_flags(pte) & (_PAGE_PRESENT|_PAGE_PROTNONE));
 }
 
 static inline unsigned long pte_pfn(pte_t pte)
diff --git a/mm/memory.c b/mm/memory.c
index 8b44f76..0a21f3d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -751,7 +751,7 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 	unsigned long pfn = pte_pfn(pte);
 
 	if (HAVE_PTE_SPECIAL) {
-		if (likely(!pte_special(pte) || pte_numa(pte)))
+		if (likely(!pte_special(pte)))
 			goto check_pfn;
 		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 			return NULL;
@@ -777,15 +777,14 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 		}
 	}
 
+	if (is_zero_pfn(pfn))
+		return NULL;
 check_pfn:
 	if (unlikely(pfn > highest_memmap_pfn)) {
 		print_bad_pte(vma, addr, pte, NULL);
 		return NULL;
 	}
 
-	if (is_zero_pfn(pfn))
-		return NULL;
-
 	/*
 	 * NOTE! We still have PageReserved() pages in the page tables.
 	 * eg. VDSO mappings can cause them to exist.
