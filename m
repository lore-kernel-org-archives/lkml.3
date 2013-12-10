Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3LJIB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:01:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab3LJIBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:01:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.12 12/62] ARM: fix booting low-vectors machines
Date: Tue, 10 Dec 2013 00:00:43 -0800
Message-Id: <20131210080058.307536328@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/pgtable.h |    2 +-
 arch/arm/mm/mmap.c             |    2 +-
 arch/arm/mm/pgd.c              |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -61,7 +61,7 @@ extern void __pgd_error(const char *file
  * mapping to be mapped at.  This is particularly important for
  * non-high vector CPUs.
  */
-#define FIRST_USER_ADDRESS	PAGE_SIZE
+#define FIRST_USER_ADDRESS	(PAGE_SIZE * 2)
 
 /*
  * Use TASK_SIZE as the ceiling argument for free_pgtables() and
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -146,7 +146,7 @@ arch_get_unmapped_area_topdown(struct fi
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = PAGE_SIZE;
+	info.low_limit = FIRST_USER_ADDRESS;
 	info.high_limit = mm->mmap_base;
 	info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
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


