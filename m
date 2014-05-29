Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609AbaE2Fck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:32:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbaE2EfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, David Vrabel <david.vrabel@citrix.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3.14 036/140] mm: use paravirt friendly ops for NUMA hinting ptes
Date: Wed, 28 May 2014 21:32:55 -0700
Message-Id: <20140529043054.035717121@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 29c7787075c92ca8af353acd5301481e6f37082f upstream.

David Vrabel identified a regression when using automatic NUMA balancing
under Xen whereby page table entries were getting corrupted due to the
use of native PTE operations.  Quoting him

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
paravirt-friendly ops but this is overkill.  He suggested an alternative
of using p[te|md]_modify in the NUMA page table operations but this is
does more work than necessary and would require looking up a VMA for
protections.

This patch modifies the NUMA page table operations to use paravirt
friendly operations to set/clear the flags of interest.  Unfortunately
this will take a performance hit when updating the PTEs on
CONFIG_PARAVIRT but I do not see a way around it that does not break
Xen.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Vrabel <david.vrabel@citrix.com>
Tested-by: David Vrabel <david.vrabel@citrix.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Anvin <hpa@zytor.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Noonan <steven@uplinklabs.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/asm-generic/pgtable.h |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

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
 
@@ -716,8 +727,12 @@ static inline void ptep_set_numa(struct
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
 


