Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3HWRSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:18:12 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53731 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754765Ab3HWRSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:18:09 -0400
Date: Fri, 23 Aug 2013 18:16:05 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Leizhen (ThunderTown, Euler)" <thunder.leizhen@huawei.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "Liujiang (Gerry)" <jiang.liu@huawei.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huxinwei <huxinwei@huawei.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Lizefan <lizefan@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [BUG] ARM64: Create 4K page size mmu memory map at init time
 will trigger exception.
Message-ID: <20130823171605.GH10971@arm.com>
References: <BFAC7FA8F7636E45AB9ECBAC17346F3434557683@SZXEML508-MBS.china.huawei.com>
 <20130822161614.GE1352@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822161614.GE1352@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 05:16:14PM +0100, Catalin Marinas wrote:
> On Thu, Aug 22, 2013 at 04:35:29AM +0100, Leizhen (ThunderTown, Euler) wrote:
> > This problem is on ARM64. When CONFIG_ARM64_64K_PAGES is not opened, the memory
> > map size can be 2M(section) and 4K(PAGE). First, OS will create map for pgd
> > (level 1 table) and level 2 table which in swapper_pg_dir. Then, OS register
> > mem block into memblock.memory according to memory node in fdt, like memory@0,
> > and create map in setup_arch-->paging_init. If all mem block start address and
> > size is integral multiple of 2M, there is no problem, because we will create 2M
> > section size map whose entries locate in level 2 table. But if it is not
> > integral multiple of 2M, we should create level 3 table, which granule is 4K.
> > Now, current implementtion is call early_alloc-->memblock_alloc to alloc memory
> > for level 3 table. This function will find a 4K free memory which locate in
> > memblock.memory tail(high address), but paging_init is create map from low
> > address to high address, so new alloced memory is not mapped, write page talbe
> > entry to it will trigger exception.
> 
> I see how this can happen. There is a memblock_set_current_limit to
> PGDIR_SIZE (1GB, we have a pre-allocated pmd) and in my tests I had at
> least 1GB of RAM which got mapped first and didn't have this problem.
> I'll come up with a patch tomorrow.

Could you please try this patch?

-------------------------8<---------------------------------------

>From 3a35771339b7eea105925d1d573aedbeeea59ef0 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 23 Aug 2013 18:04:44 +0100
Subject: [PATCH] arm64: Fix mapping of memory banks not ending on a PMD_SIZE
 boundary

The map_mem() function limits the current memblock limit to PGDIR_SIZE
(the initial swapper_pg_dir mapping) to avoid create_mapping()
allocating memory from unmapped areas. However, if the first block is
within PGDIR_SIZE and not ending on a PMD_SIZE boundary, when 4K page
configuration is enabled, create_mapping() will try to allocate a pte
page. Such page may be returned by memblock_alloc() from the end of such
bank (or any subsequent bank within PGDIR_SIZE) which is not mapped yet.

The patch limits the current memblock limit to the aligned end of the
first bank and gradually increases it as more memory is mapped. It also
ensures that the start of the first bank is aligned to PMD_SIZE to avoid
pte page allocation for this mapping.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: "Leizhen (ThunderTown, Euler)" <thunder.leizhen@huawei.com>
---
 arch/arm64/mm/mmu.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a8d1059..49a0bc2 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -296,6 +296,7 @@ void __iomem * __init early_io_map(phys_addr_t phys, unsigned long virt)
 static void __init map_mem(void)
 {
 	struct memblock_region *reg;
+	phys_addr_t limit;
 
 	/*
 	 * Temporarily limit the memblock range. We need to do this as
@@ -303,9 +304,11 @@ static void __init map_mem(void)
 	 * memory addressable from the initial direct kernel mapping.
 	 *
 	 * The initial direct kernel mapping, located at swapper_pg_dir,
-	 * gives us PGDIR_SIZE memory starting from PHYS_OFFSET (aligned).
+	 * gives us PGDIR_SIZE memory starting from PHYS_OFFSET (which must be
+	 * aligned to 2MB as per Documentation/arm64/booting.txt).
 	 */
-	memblock_set_current_limit((PHYS_OFFSET & PGDIR_MASK) + PGDIR_SIZE);
+	limit = PHYS_OFFSET + PGDIR_SIZE;
+	memblock_set_current_limit(limit);
 
 	/* map all the memory banks */
 	for_each_memblock(memory, reg) {
@@ -315,7 +318,28 @@ static void __init map_mem(void)
 		if (start >= end)
 			break;
 
+#ifndef CONFIG_ARM64_64K_PAGES
+		/*
+		 * For the first memory bank align the start address and
+		 * current memblock limit to prevent create_mapping() from
+		 * allocating pte page tables from unmapped memory.
+		 * When 64K pages are enabled, the pte page table for the
+		 * first PGDIR_SIZE is already present in swapper_pg_dir.
+		 */
+		if (start < limit)
+			start = ALIGN(start, PMD_SIZE);
+		if (end < limit) {
+			limit = end & PMD_MASK;
+			memblock_set_current_limit(limit);
+		}
+#endif
+
 		create_mapping(start, __phys_to_virt(start), end - start);
+
+		/*
+		 * Mapping created, extend the current memblock limit.
+		 */
+		memblock_set_current_limit(end);
 	}
 
 	/* Limit no longer required. */
