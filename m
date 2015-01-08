Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbbAHStD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:49:03 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55184 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbbAHSs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:48:57 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: leif.lindholm@linaro.org, roy.franz@linaro.org, matt.fleming@intel.com,
        will.deacon@arm.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        bp@alien8.de, msalter@redhat.com, geoff.levand@linaro.org,
        dyoung@redhat.com, mark.rutland@arm.com, linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 1/8] arm64/mm: add explicit struct_mm argument to __create_mapping()
Date: Thu,  8 Jan 2015 18:48:27 +0000
Message-Id: <1420742914-2404-2-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, swapper_pg_dir and idmap_pg_dir share the init_mm mm_struct
instance. To allow the introduction of other pg_dir instances, for instance,
for UEFI's mapping of Runtime Services, make the struct_mm instance an
explicit argument that gets passed down to the pmd and pte instantiation
functions. Note that the consumers (pmd_populate/pgd_populate) of the
mm_struct argument don't actually inspect it, but let's fix it for
correctness' sake.

Acked-by: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6032f3e3056a..7d5dfe2d3de0 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -156,9 +156,9 @@ static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
 
-static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
-				  unsigned long end, phys_addr_t phys,
-				  int map_io)
+static void __init alloc_init_pmd(struct mm_struct *mm, pud_t *pud,
+				  unsigned long addr, unsigned long end,
+				  phys_addr_t phys, int map_io)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -178,7 +178,7 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 	 */
 	if (pud_none(*pud) || pud_bad(*pud)) {
 		pmd = early_alloc(PTRS_PER_PMD * sizeof(pmd_t));
-		pud_populate(&init_mm, pud, pmd);
+		pud_populate(mm, pud, pmd);
 	}
 
 	pmd = pmd_offset(pud, addr);
@@ -202,16 +202,16 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 	} while (pmd++, addr = next, addr != end);
 }
 
-static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
-				  unsigned long end, phys_addr_t phys,
-				  int map_io)
+static void __init alloc_init_pud(struct mm_struct *mm, pgd_t *pgd,
+				  unsigned long addr, unsigned long end,
+				  phys_addr_t phys, int map_io)
 {
 	pud_t *pud;
 	unsigned long next;
 
 	if (pgd_none(*pgd)) {
 		pud = early_alloc(PTRS_PER_PUD * sizeof(pud_t));
-		pgd_populate(&init_mm, pgd, pud);
+		pgd_populate(mm, pgd, pud);
 	}
 	BUG_ON(pgd_bad(*pgd));
 
@@ -240,7 +240,7 @@ static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
 				flush_tlb_all();
 			}
 		} else {
-			alloc_init_pmd(pud, addr, next, phys, map_io);
+			alloc_init_pmd(mm, pud, addr, next, phys, map_io);
 		}
 		phys += next - addr;
 	} while (pud++, addr = next, addr != end);
@@ -250,9 +250,9 @@ static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
  * Create the page directory entries and any necessary page tables for the
  * mapping specified by 'md'.
  */
-static void __init __create_mapping(pgd_t *pgd, phys_addr_t phys,
-				    unsigned long virt, phys_addr_t size,
-				    int map_io)
+static void __init __create_mapping(struct mm_struct *mm, pgd_t *pgd,
+				    phys_addr_t phys, unsigned long virt,
+				    phys_addr_t size, int map_io)
 {
 	unsigned long addr, length, end, next;
 
@@ -262,7 +262,7 @@ static void __init __create_mapping(pgd_t *pgd, phys_addr_t phys,
 	end = addr + length;
 	do {
 		next = pgd_addr_end(addr, end);
-		alloc_init_pud(pgd, addr, next, phys, map_io);
+		alloc_init_pud(mm, pgd, addr, next, phys, map_io);
 		phys += next - addr;
 	} while (pgd++, addr = next, addr != end);
 }
@@ -275,7 +275,8 @@ static void __init create_mapping(phys_addr_t phys, unsigned long virt,
 			&phys, virt);
 		return;
 	}
-	__create_mapping(pgd_offset_k(virt & PAGE_MASK), phys, virt, size, 0);
+	__create_mapping(&init_mm, pgd_offset_k(virt & PAGE_MASK), phys, virt,
+			 size, 0);
 }
 
 void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
@@ -284,7 +285,7 @@ void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
 		pr_warn("BUG: not creating id mapping for %pa\n", &addr);
 		return;
 	}
-	__create_mapping(&idmap_pg_dir[pgd_index(addr)],
+	__create_mapping(&init_mm, &idmap_pg_dir[pgd_index(addr)],
 			 addr, addr, size, map_io);
 }
 
-- 
1.8.3.2

