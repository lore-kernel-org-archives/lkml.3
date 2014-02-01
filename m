Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbaBAUP2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 15:15:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59059 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbaBAUP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 15:15:27 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Yinghai Lu <yinghai@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ARM: mm: Fix the memblock allocation for LPAE machines
Date: Sat, 1 Feb 2014 15:14:47 -0500
Message-ID: <1391285687-20534-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ad6492b8 added much needed memblock_virt_alloc_low() and further
commit 07bacb3 {memblock, bootmem: restore goal for alloc_low} fixed the
issue with low memory limit thansk to Yinghai. But even after all these fixes,
there is still one case where the limit check done with ARCH_LOW_ADDRESS_LIMIT
for low memory fails. Russell pointed out the issue with 32 bit LPAE machines
in below thread.
	https://lkml.org/lkml/2014/1/28/364

Since on some LPAE machines where memory start address is beyond 4GB,
the low memory marker in memblock will be set to default
ARCH_LOW_ADDRESS_LIMIT which is wrong. We can fix this by letting
architectures set the ARCH_LOW_ADDRESS_LIMIT using another export
similar to memblock_set_current_limit() but am not sure whether
its worth the trouble. Tell me if you think otherwise.

Rather am just trying to fix that one broken case using memblock_virt_alloc()
in setup code since the memblock.current_limit is updated appropriately
makes it work on all ARM 32 bit machines.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Strashko, Grygorii <grygorii.strashko@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index b0df976..1e8b030 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -731,7 +731,7 @@ static void __init request_standard_resources(const struct machine_desc *mdesc)
 	kernel_data.end     = virt_to_phys(_end - 1);
 
 	for_each_memblock(memory, region) {
-		res = memblock_virt_alloc_low(sizeof(*res), 0);
+		res = memblock_virt_alloc(sizeof(*res), 0);
 		res->name  = "System RAM";
 		res->start = __pfn_to_phys(memblock_region_memory_base_pfn(region));
 		res->end = __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;
-- 
1.7.9.5

