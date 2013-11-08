Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab3KHXqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:46:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53214 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932461Ab3KHXnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:43:55 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 17/24] mm/hugetlb: Use memblock apis for early memory allocations
Date: Fri, 8 Nov 2013 18:41:53 -0500
Message-ID: <1383954120-24368-18-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com>
References: <1383954120-24368-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

Switch to memblock interfaces for early memory allocator instead of
bootmem allocator. No functional change in beahvior than what it is
in current code from bootmem users points of view.

Archs already converted to NO_BOOTMEM now directly use memblock
interfaces instead of bootmem wrappers build on top of memblock. And the
archs which still uses bootmem, these new apis just fallback to exiting
bootmem APIs.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 mm/hugetlb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b49579c..3c9f965 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1282,9 +1282,9 @@ int __weak alloc_bootmem_huge_page(struct hstate *h)
 	for_each_node_mask_to_alloc(h, nr_nodes, node, &node_states[N_MEMORY]) {
 		void *addr;
 
-		addr = __alloc_bootmem_node_nopanic(NODE_DATA(node),
-				huge_page_size(h), huge_page_size(h), 0);
-
+		addr = memblock_virt_alloc_try_nid_nopanic(
+				huge_page_size(h), huge_page_size(h),
+				0, BOOTMEM_ALLOC_ACCESSIBLE, node);
 		if (addr) {
 			/*
 			 * Use the beginning of the huge page to store the
@@ -1324,8 +1324,8 @@ static void __init gather_bootmem_prealloc(void)
 
 #ifdef CONFIG_HIGHMEM
 		page = pfn_to_page(m->phys >> PAGE_SHIFT);
-		free_bootmem_late((unsigned long)m,
-				  sizeof(struct huge_bootmem_page));
+		memblock_free_late(__pa(m),
+				   sizeof(struct huge_bootmem_page));
 #else
 		page = virt_to_page(m);
 #endif
-- 
1.7.9.5

