Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaEBNlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:41:52 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52187 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751990AbaEBNlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:41:49 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/6] mm: Call kmemleak directly from memblock_(alloc|free)
Date: Fri,  2 May 2014 14:41:09 +0100
Message-Id: <1399038070-1540-6-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1399038070-1540-1-git-send-email-catalin.marinas@arm.com>
References: <1399038070-1540-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kmemleak could ignore memory blocks allocated via memblock_alloc()
leading to false positives during scanning. This patch adds the
corresponding callbacks and removes kmemleak_free_* calls in
mm/nobootmem.c to avoid duplication. The kmemleak_alloc() in
mm/nobootmem.c is kept since __alloc_memory_core_early() does not use
memblock_alloc() directly.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/memblock.c  | 9 ++++++++-
 mm/nobootmem.c | 2 --
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index e9d6ca9a01a9..8813a31d7fbd 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -681,6 +681,7 @@ int __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
 		     (unsigned long long)base + size - 1,
 		     (void *)_RET_IP_);
 
+	kmemleak_free_part(__va(base), size);
 	return __memblock_remove(&memblock.reserved, base, size);
 }
 
@@ -985,8 +986,14 @@ static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
 		align = SMP_CACHE_BYTES;
 
 	found = memblock_find_in_range_node(size, align, 0, max_addr, nid);
-	if (found && !memblock_reserve(found, size))
+	if (found && !memblock_reserve(found, size)) {
+		/*
+		 * The min_count is set to 0 so that memblock allocations are
+		 * never reported as leaks.
+		 */
+		kmemleak_alloc(__va(found), size, 0, 0);
 		return found;
+	}
 
 	return 0;
 }
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 04a9d94333a5..7ed58602e71b 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -197,7 +197,6 @@ unsigned long __init free_all_bootmem(void)
 void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 			      unsigned long size)
 {
-	kmemleak_free_part(__va(physaddr), size);
 	memblock_free(physaddr, size);
 }
 
@@ -212,7 +211,6 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
  */
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-	kmemleak_free_part(__va(addr), size);
 	memblock_free(addr, size);
 }
 
