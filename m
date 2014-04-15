Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaDOOlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:41:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57072 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaDOOlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:41:21 -0400
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] mm: use paravirt friendly ops for NUMA hinting ptes
Date: Tue, 15 Apr 2014 15:41:14 +0100
Message-Id: <1397572876-1610-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1397572876-1610-1-git-send-email-mgorman@suse.de>
References: <1397572876-1610-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Vrabel identified a regression when using automatic NUMA balancing
under Xen whereby page table entries were getting corrupted due to the
use of native PTE operations. Quoting him

	Xen PV guest page tables require that their entries use machine
	addresses if the preset bit (_PAGE_PRESENT) is set, and (for
	successful migration) non-present PTEs must use pseudo-physical
	addresses.  This is because on migration MFNs in present PTEs are
	translated to PFNs (canonicalised) so they may be translated back
	to the new MFN in the destination domain (uncanonicalised).

	pte_mknonnuma(), pmd_mknonnuma(), pte_mknuma() and pmd_mknuma()
	set and clear the _PAGE_PRESENT bit using pte_set_flags(),
	pte_clear_flags(), etc.

	In a Xen PV guest, these functions must translate MFNs to PFNs
	when clearing _PAGE_PRESENT and translate PFNs to MFNs when setting
	_PAGE_PRESENT.

His suggested fix converted p[te|md]_[set|clear]_flags to using
paravirt-friendly ops but this is overkill. He suggested an alternative of
using p[te|md]_modify in the NUMA page table operations but this is does
more work than necessary and would require looking up a VMA for protections.

This patch modifies the NUMA page table operations to use paravirt friendly
operations to set/clear the flags of interest. Unfortunately this will take
a performance hit when updating the PTEs on CONFIG_PARAVIRT but I do not
see a way around it that does not break Xen.

Cc: stable@vger.kernel.org
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Vrabel <david.vrabel@citrix.com>
Tested-by: David Vrabel <david.vrabel@citrix.com>
---
 include/asm-generic/pgtable.h | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 34c7bdc..38a7437 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -680,24 +680,35 @@ static inline int pmd_numa(pmd_t pmd)
 #ifndef pte_mknonnuma
 static inline pte_t pte_mknonnuma(pte_t pte)
 {
-	pte = pte_clear_flags(pte, _PAGE_NUMA);
-	return pte_set_flags(pte, _PAGE_PRESENT|_PAGE_ACCESSED);
+	pteval_t val = pte_val(pte);
+
+	val &= ~_PAGE_NUMA;
+	val |= (_PAGE_PRESENT|_PAGE_ACCESSED);
+	return __pte(val);
 }
 #endif
 
 #ifndef pmd_mknonnuma
 static inline pmd_t pmd_mknonnuma(pmd_t pmd)
 {
-	pmd = pmd_clear_flags(pmd, _PAGE_NUMA);
-	return pmd_set_flags(pmd, _PAGE_PRESENT|_PAGE_ACCESSED);
+	pmdval_t val = pmd_val(pmd);
+
+	val &= ~_PAGE_NUMA;
+	val |= (_PAGE_PRESENT|_PAGE_ACCESSED);
+
+	return __pmd(val);
 }
 #endif
 
 #ifndef pte_mknuma
 static inline pte_t pte_mknuma(pte_t pte)
 {
-	pte = pte_set_flags(pte, _PAGE_NUMA);
-	return pte_clear_flags(pte, _PAGE_PRESENT);
+	pteval_t val = pte_val(pte);
+
+	val &= ~_PAGE_PRESENT;
+	val |= _PAGE_NUMA;
+
+	return __pte(val);
 }
 #endif
 
@@ -716,8 +727,12 @@ static inline void ptep_set_numa(struct mm_struct *mm, unsigned long addr,
 #ifndef pmd_mknuma
 static inline pmd_t pmd_mknuma(pmd_t pmd)
 {
-	pmd = pmd_set_flags(pmd, _PAGE_NUMA);
-	return pmd_clear_flags(pmd, _PAGE_PRESENT);
+	pmdval_t val = pmd_val(pmd);
+
+	val &= ~_PAGE_PRESENT;
+	val |= _PAGE_NUMA;
+
+	return __pmd(val);
 }
 #endif
 
-- 
1.8.4.5

