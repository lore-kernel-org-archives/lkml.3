Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3LSMvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:51:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44760 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab3LSL5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:57:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 072/208] ARM: fix booting low-vectors machines
Date: Thu, 19 Dec 2013 11:52:50 +0000
Message-Id: <1387454106-19326-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit d8aa712c30148ba26fd89a5dc14de95d4c375184 upstream.

Commit f6f91b0d9fd9 (ARM: allow kuser helpers to be removed from the
vector page) required two pages for the vectors code.  Although the
code setting up the initial page tables was updated, the code which
allocates page tables for new processes wasn't, neither was the code
which tears down the mappings.  Fix this.

Fixes: f6f91b0d9fd9 ("ARM: allow kuser helpers to be removed from the vector page")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/include/asm/pgtable.h | 2 +-
 arch/arm/mm/mmap.c             | 2 +-
 arch/arm/mm/pgd.c              | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 04aeb02..3b5753b 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -61,7 +61,7 @@ extern void __pgd_error(const char *file, int line, pgd_t);
  * mapping to be mapped at.  This is particularly important for
  * non-high vector CPUs.
  */
-#define FIRST_USER_ADDRESS	PAGE_SIZE
+#define FIRST_USER_ADDRESS	(PAGE_SIZE * 2)
 
 /*
  * Use TASK_SIZE as the ceiling argument for free_pgtables() and
diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index 0c63562..304661d 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -146,7 +146,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = PAGE_SIZE;
+	info.low_limit = FIRST_USER_ADDRESS;
 	info.high_limit = mm->mmap_base;
 	info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
diff --git a/arch/arm/mm/pgd.c b/arch/arm/mm/pgd.c
index 0acb089..1046b37 100644
--- a/arch/arm/mm/pgd.c
+++ b/arch/arm/mm/pgd.c
@@ -87,7 +87,8 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 		init_pud = pud_offset(init_pgd, 0);
 		init_pmd = pmd_offset(init_pud, 0);
 		init_pte = pte_offset_map(init_pmd, 0);
-		set_pte_ext(new_pte, *init_pte, 0);
+		set_pte_ext(new_pte + 0, init_pte[0], 0);
+		set_pte_ext(new_pte + 1, init_pte[1], 0);
 		pte_unmap(init_pte);
 		pte_unmap(new_pte);
 	}
-- 
1.8.3.2

