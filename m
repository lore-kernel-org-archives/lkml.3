Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaBGMB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:01:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42450 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041AbaBGLw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 208/233] powerpc: thp: Fix crash on mremap
Date: Fri,  7 Feb 2014 11:47:07 +0000
Message-Id: <1391773652-25214-209-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[ aneesh: variant of upstream SHA1: b3084f4db3aeb991c507ca774337c7e7893ed04f
  for 3.11 stable series ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/Kconfig                           |  3 +++
 arch/powerpc/platforms/Kconfig.cputype |  1 +
 mm/huge_memory.c                       | 12 ++++++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 1feb169..c5863b3 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -368,6 +368,9 @@ config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 config HAVE_ARCH_SOFT_DIRTY
 	bool
 
+config ARCH_THP_MOVE_PMD_ALWAYS_WITHDRAW
+	bool
+
 config HAVE_MOD_ARCH_SPECIFIC
 	bool
 	help
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 47d9a03..d11a34b 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -71,6 +71,7 @@ config PPC_BOOK3S_64
 	select PPC_FPU
 	select PPC_HAVE_PMU_SUPPORT
 	select SYS_SUPPORTS_HUGETLBFS
+	select ARCH_THP_MOVE_PMD_ALWAYS_WITHDRAW
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if PPC_64K_PAGES
 
 config PPC_BOOK3E_64
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5e91a87..46a02bf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1486,8 +1486,20 @@ int move_huge_pmd(struct vm_area_struct *vma, struct vm_area_struct *new_vma,
 
 	ret = __pmd_trans_huge_lock(old_pmd, vma);
 	if (ret == 1) {
+#ifdef CONFIG_ARCH_THP_MOVE_PMD_ALWAYS_WITHDRAW
+		pgtable_t pgtable;
+#endif
 		pmd = pmdp_get_and_clear(mm, old_addr, old_pmd);
 		VM_BUG_ON(!pmd_none(*new_pmd));
+#ifdef CONFIG_ARCH_THP_MOVE_PMD_ALWAYS_WITHDRAW
+		/*
+		 * Archs like ppc64 use pgtable to store per pmd
+		 * specific information. So when we switch the pmd,
+		 * we should also withdraw and deposit the pgtable
+		 */
+		pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
+		pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
+#endif
 		set_pmd_at(mm, new_addr, new_pmd, pmd_mksoft_dirty(pmd));
 		spin_unlock(&mm->page_table_lock);
 	}
-- 
1.8.3.2

