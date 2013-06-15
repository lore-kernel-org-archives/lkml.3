Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3FOXPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 19:15:14 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:60819 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab3FOXPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 19:15:12 -0400
From: Grant Likely <grant.likely@linaro.org>
To: Nicolas Pitre <nico@linaro.org>, Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC] arm: Remove sa1111 special case from mm setup code
Date: Sun, 16 Jun 2013 00:15:08 +0100
Message-Id: <1371338108-26354-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this special case is needed anymore. From what I can tell,
setup_dma_zone() takes care of marking the region to be reserved for
DMA, and that happens before arm_memblock_init() which calls
arm_mm_memblock_reserve(). Therefore the mm setup should already know
about the reserved region and it won't need to be explicitly reserved
and then freed. That means the special case can be dropped from the
common code.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Hi Russell and Nicolas,

I really don't know if this is correct. The MM code is not my strong
area. Please take a look.

Thanks,
g.

 arch/arm/mm/init.c | 5 -----
 arch/arm/mm/mmu.c  | 8 --------
 2 files changed, 13 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 9a5cdc0..73212fe 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -598,11 +598,6 @@ void __init mem_init(void)
 
 	totalram_pages += free_all_bootmem();
 
-#ifdef CONFIG_SA1111
-	/* now that our DMA memory is actually so designated, we can free it */
-	free_reserved_area(__va(PHYS_PFN_OFFSET), swapper_pg_dir, 0, NULL);
-#endif
-
 	free_highpages();
 
 	reserved_pages = free_pages = 0;
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index e0d8565..f281a24 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1147,14 +1147,6 @@ void __init arm_mm_memblock_reserve(void)
 	 * and can only be in node 0.
 	 */
 	memblock_reserve(__pa(swapper_pg_dir), SWAPPER_PG_DIR_SIZE);
-
-#ifdef CONFIG_SA1111
-	/*
-	 * Because of the SA1111 DMA bug, we want to preserve our
-	 * precious DMA-able memory...
-	 */
-	memblock_reserve(PHYS_OFFSET, __pa(swapper_pg_dir) - PHYS_OFFSET);
-#endif
 }
 
 /*
-- 
1.8.1.2

