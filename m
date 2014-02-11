Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaBKUif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:38:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaBKTGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.13 110/120] powerpc/thp: Fix crash on mremap
Date: Tue, 11 Feb 2014 11:05:51 -0800
Message-Id: <20140211184826.770819750@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit b3084f4db3aeb991c507ca774337c7e7893ed04f upstream.

This patch fix the below crash

NIP [c00000000004cee4] .__hash_page_thp+0x2a4/0x440
LR [c0000000000439ac] .hash_page+0x18c/0x5e0
...
Call Trace:
[c000000736103c40] [00001ffffb000000] 0x1ffffb000000(unreliable)
[437908.479693] [c000000736103d50] [c0000000000439ac] .hash_page+0x18c/0x5e0
[437908.479699] [c000000736103e30] [c00000000000924c] .do_hash_page+0x4c/0x58

On ppc64 we use the pgtable for storing the hpte slot information and
store address to the pgtable at a constant offset (PTRS_PER_PMD) from
pmd. On mremap, when we switch the pmd, we need to withdraw and deposit
the pgtable again, so that we find the pgtable at PTRS_PER_PMD offset
from new pmd.

We also want to move the withdraw and deposit before the set_pmd so
that, when page fault find the pmd as trans huge we can be sure that
pgtable can be located at the offset.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/pgtable-ppc64.h |   14 ++++++++++++++
 include/asm-generic/pgtable.h            |   12 ++++++++++++
 mm/huge_memory.c                         |   14 +++++---------
 3 files changed, 31 insertions(+), 9 deletions(-)

--- a/arch/powerpc/include/asm/pgtable-ppc64.h
+++ b/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -558,5 +558,19 @@ extern pgtable_t pgtable_trans_huge_with
 #define __HAVE_ARCH_PMDP_INVALIDATE
 extern void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 			    pmd_t *pmdp);
+
+#define pmd_move_must_withdraw pmd_move_must_withdraw
+typedef struct spinlock spinlock_t;
+static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
+					 spinlock_t *old_pmd_ptl)
+{
+	/*
+	 * Archs like ppc64 use pgtable to store per pmd
+	 * specific information. So when we switch the pmd,
+	 * we should also withdraw and deposit the pgtable
+	 */
+	return true;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_POWERPC_PGTABLE_PPC64_H_ */
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -558,6 +558,18 @@ static inline pmd_t pmd_read_atomic(pmd_
 }
 #endif
 
+#ifndef pmd_move_must_withdraw
+static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
+					 spinlock_t *old_pmd_ptl)
+{
+	/*
+	 * With split pmd lock we also need to move preallocated
+	 * PTE page table if new_pmd is on different PMD page table.
+	 */
+	return new_pmd_ptl != old_pmd_ptl;
+}
+#endif
+
 /*
  * This function is meant to be used by sites walking pagetables with
  * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1502,19 +1502,15 @@ int move_huge_pmd(struct vm_area_struct
 			spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 		pmd = pmdp_get_and_clear(mm, old_addr, old_pmd);
 		VM_BUG_ON(!pmd_none(*new_pmd));
-		set_pmd_at(mm, new_addr, new_pmd, pmd_mksoft_dirty(pmd));
-		if (new_ptl != old_ptl) {
-			pgtable_t pgtable;
 
-			/*
-			 * Move preallocated PTE page table if new_pmd is on
-			 * different PMD page table.
-			 */
+		if (pmd_move_must_withdraw(new_ptl, old_ptl)) {
+			pgtable_t pgtable;
 			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
-
-			spin_unlock(new_ptl);
 		}
+		set_pmd_at(mm, new_addr, new_pmd, pmd_mksoft_dirty(pmd));
+		if (new_ptl != old_ptl)
+			spin_unlock(new_ptl);
 		spin_unlock(old_ptl);
 	}
 out:


