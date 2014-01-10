Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbaAJWaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 17:30:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757474AbaAJW37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 17:29:59 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, matt.fleming@intel.com,
        Leif Lindholm <leif.lindholm@linaro.org>, roy.franz@linaro.org,
        patches@linaro.org, Grant Likely <grant.likely@secretlab.ca>,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH 2/6] arm64: Add function to create identity mappings
Date: Fri, 10 Jan 2014 17:29:06 -0500
Message-Id: <1389392950-22457-3-git-send-email-msalter@redhat.com>
In-Reply-To: <1389392950-22457-1-git-send-email-msalter@redhat.com>
References: <1389392950-22457-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At boot time, UEFI runtime support needs to call into the UEFI firmware
to switch to a virtual address map. This call must be made with UEFI
memory regions identity mapped. The exisitng early boot code creates
an identity map of kernel text/data but this is not sufficient for UEFI.
This patch adds a create_id_mapping() function which reuses the core
code of create_mapping() used to create the kernel RAM mappings.

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: linux-arm-kernel@lists.infradead.org
---
 arch/arm64/include/asm/mmu.h |  1 +
 arch/arm64/mm/mmu.c          | 34 ++++++++++++++++++++++++----------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index f600d40..9ad4dd4 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -28,5 +28,6 @@ extern void paging_init(void);
 extern void setup_mm_for_reboot(void);
 extern void __iomem *early_io_map(phys_addr_t phys, unsigned long virt);
 extern void init_mem_pgprot(void);
+extern void create_id_mapping(phys_addr_t addr, phys_addr_t size);
 
 #endif
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 7b345e3..ccfca44 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -228,22 +228,14 @@ static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
  * Create the page directory entries and any necessary page tables for the
  * mapping specified by 'md'.
  */
-static void __init create_mapping(phys_addr_t phys, unsigned long virt,
-				  phys_addr_t size)
+static void __init __create_mapping(pgd_t *pgd, phys_addr_t phys,
+				    unsigned long virt, phys_addr_t size)
 {
 	unsigned long addr, length, end, next;
-	pgd_t *pgd;
-
-	if (virt < VMALLOC_START) {
-		pr_warning("BUG: not creating mapping for 0x%016llx at 0x%016lx - outside kernel range\n",
-			   phys, virt);
-		return;
-	}
 
 	addr = virt & PAGE_MASK;
 	length = PAGE_ALIGN(size + (virt & ~PAGE_MASK));
 
-	pgd = pgd_offset_k(addr);
 	end = addr + length;
 	do {
 		next = pgd_addr_end(addr, end);
@@ -252,6 +244,28 @@ static void __init create_mapping(phys_addr_t phys, unsigned long virt,
 	} while (pgd++, addr = next, addr != end);
 }
 
+static void __init create_mapping(phys_addr_t phys, unsigned long virt,
+				  phys_addr_t size)
+{
+	if (virt < VMALLOC_START) {
+		pr_warn("BUG: not creating mapping for 0x%016llx at 0x%016lx - outside kernel range\n",
+			phys, virt);
+		return;
+	}
+	__create_mapping(pgd_offset_k(virt & PAGE_MASK), phys, virt, size);
+}
+
+void __init create_id_mapping(phys_addr_t addr, phys_addr_t size)
+{
+	pgd_t *pgd = &idmap_pg_dir[pgd_index(addr)];
+
+	if (pgd >= &idmap_pg_dir[ARRAY_SIZE(idmap_pg_dir)]) {
+		pr_warn("BUG: not creating id mapping for 0x%016llx\n", addr);
+		return;
+	}
+	__create_mapping(pgd, addr, addr, size);
+}
+
 static void __init map_mem(void)
 {
 	struct memblock_region *reg;
-- 
1.8.3.1

