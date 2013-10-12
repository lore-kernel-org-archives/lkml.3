Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3JLWC0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 18:02:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43580 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3JLWAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 18:00:10 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <yinghai@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [RFC 16/23] mm/hugetlb: Use memblock apis for early memory allocations
Date: Sat, 12 Oct 2013 17:58:59 -0400
Message-ID: <1381615146-20342-17-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
References: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

Switch to memblock interfaces for early memory allocator

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 mm/hugetlb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b49579c..fe0cab4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1282,9 +1282,9 @@ int __weak alloc_bootmem_huge_page(struct hstate *h)
 	for_each_node_mask_to_alloc(h, nr_nodes, node, &node_states[N_MEMORY]) {
 		void *addr;
 
-		addr = __alloc_bootmem_node_nopanic(NODE_DATA(node),
-				huge_page_size(h), huge_page_size(h), 0);
-
+		addr = memblock_early_alloc_try_nid_nopanic(node,
+				huge_page_size(h), huge_page_size(h),
+				0, BOOTMEM_ALLOC_ACCESSIBLE);
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

