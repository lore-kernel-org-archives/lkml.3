Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbaAJWYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 17:24:41 -0500
Received: from smtp-69.nebula.fi ([83.145.220.69]:45708 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751263AbaAJWYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 17:24:13 -0500
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: jonas@southpole.se,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH] openrisc: fix PTRS_PER_PGD define
Date: Sat, 11 Jan 2014 00:23:16 +0200
Message-Id: <1389392596-14666-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OpenRISC, with its 8k pages, PAGE_SHIFT is defined to be 13.
That makes the expression (1UL << (PAGE_SHIFT-2)) evaluate
to 2048.
The correct value for PTRS_PER_PGD should be 256.

Correcting the PTRS_PER_PGD define unveiled a bug in map_ram(),
where PTRS_PER_PGD was used when the intent was to iterate
over a set of page table entries.
This patch corrects that issue as well.

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
 arch/openrisc/include/asm/pgtable.h | 2 +-
 arch/openrisc/mm/init.c             | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/openrisc/include/asm/pgtable.h b/arch/openrisc/include/asm/pgtable.h
index 37bf6a3..5630d03 100644
--- a/arch/openrisc/include/asm/pgtable.h
+++ b/arch/openrisc/include/asm/pgtable.h
@@ -69,7 +69,7 @@ extern void paging_init(void);
  */
 #define PTRS_PER_PTE	(1UL << (PAGE_SHIFT-2))
 
-#define PTRS_PER_PGD	(1UL << (PAGE_SHIFT-2))
+#define PTRS_PER_PGD	(1UL << (32-PGDIR_SHIFT))
 
 /* calculate how many PGD entries a user-level program can use
  * the first mappable virtual address is 0
diff --git a/arch/openrisc/mm/init.c b/arch/openrisc/mm/init.c
index 7f94652..b782ce9 100644
--- a/arch/openrisc/mm/init.c
+++ b/arch/openrisc/mm/init.c
@@ -110,7 +110,7 @@ static void __init map_ram(void)
 			set_pmd(pme, __pmd(_KERNPG_TABLE + __pa(pte)));
 
 			/* Fill the newly allocated page with PTE'S */
-			for (j = 0; p < e && j < PTRS_PER_PGD;
+			for (j = 0; p < e && j < PTRS_PER_PTE;
 			     v += PAGE_SIZE, p += PAGE_SIZE, j++, pte++) {
 				if (v >= (u32) _e_kernel_ro ||
 				    v < (u32) _s_kernel_ro)
-- 
1.8.3.2

