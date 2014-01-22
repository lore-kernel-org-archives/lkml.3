Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbaAVL2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:28:52 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:44543 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbaAVL2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:28:43 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <kexec@lists.infradead.org>
CC: Eric Biederman <ebiederm@xmission.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geng Hui <hui.geng@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Wang Nan <wangnan0@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH 3/3] ARM: allow kernel to be loaded in middle of phymem
Date: Wed, 22 Jan 2014 19:25:16 +0800
Message-ID: <1390389916-8711-4-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1390389916-8711-1-git-send-email-wangnan0@huawei.com>
References: <1390389916-8711-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the kernel to be loaded at the middle of kernel awared
physical memory. Before this patch, users must use mem= or device tree to cheat
kernel about the start address of physical memory.

This feature is useful in some special cases, for example, building a crash
dump kernel. Without it, kernel command line, atag and devicetree must be
adjusted carefully, sometimes is impossible.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: <stable@vger.kernel.org> # 3.4+
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geng Hui <hui.geng@huawei.com>
---
 arch/arm/mm/init.c | 21 ++++++++++++++++++++-
 arch/arm/mm/mmu.c  | 13 +++++++++++++
 mm/page_alloc.c    |  7 +++++--
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 3e8f106..4952726 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -334,9 +334,28 @@ void __init arm_memblock_init(struct meminfo *mi,
 {
 	int i;
 
-	for (i = 0; i < mi->nr_banks; i++)
+	for (i = 0; i < mi->nr_banks; i++) {
 		memblock_add(mi->bank[i].start, mi->bank[i].size);
 
+		/*
+		 * In some special case, for example, building a crushdump
+		 * kernel, we want the kernel to be loaded in the middle of
+		 * physical memory. In such case, the physical memory before
+		 * PHYS_OFFSET is awkward: it can't get directly mapped
+		 * (because its address will be smaller than PAGE_OFFSET,
+		 * disturbs user address space) also can't be mapped as
+		 * HighMem. We reserve such pages here. The only way to access
+		 * those pages is ioremap.
+		 */
+		if (mi->bank[i].start < PHYS_OFFSET) {
+			unsigned long reserv_size = PHYS_OFFSET -
+						    mi->bank[i].start;
+			if (reserv_size > mi->bank[i].size)
+				reserv_size = mi->bank[i].size;
+			memblock_reserve(mi->bank[i].start, reserv_size);
+		}
+	}
+
 	/* Register the kernel text, kernel data and initrd with memblock. */
 #ifdef CONFIG_XIP_KERNEL
 	memblock_reserve(__pa(_sdata), _end - _sdata);
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 580ef2d..2a17c24 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1308,6 +1308,19 @@ static void __init map_lowmem(void)
 		if (start >= end)
 			break;
 
+		/*
+		 * If this memblock contain memory before PAGE_OFFSET, memory
+		 * before PAGE_OFFSET should't get directly mapped, see code
+		 * in create_mapping(). However, memory after PAGE_OFFSET is
+		 * occupyed by kernel and still need to be mapped.
+		 */
+		if (__phys_to_virt(start) < PAGE_OFFSET) {
+			if (__phys_to_virt(end) > PAGE_OFFSET)
+				start = __virt_to_phys(PAGE_OFFSET);
+			else
+				break;
+		}
+
 		map.pfn = __phys_to_pfn(start);
 		map.virtual = __phys_to_virt(start);
 		map.length = end - start;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5248fe0..d2959e3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4840,10 +4840,13 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
 	 */
 	if (pgdat == NODE_DATA(0)) {
 		mem_map = NODE_DATA(0)->node_mem_map;
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+		/*
+		 * In case of CONFIG_HAVE_MEMBLOCK_NODE_MAP or when kernel
+		 * loaded at the middle of physical memory, mem_map should
+		 * be adjusted.
+		 */
 		if (page_to_pfn(mem_map) != pgdat->node_start_pfn)
 			mem_map -= (pgdat->node_start_pfn - ARCH_PFN_OFFSET);
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 	}
 #endif
 #endif /* CONFIG_FLAT_NODE_MEM_MAP */
-- 
1.8.4

