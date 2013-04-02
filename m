Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761954Ab3DBQ3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:29:17 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:32941 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761895Ab3DBQ3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:29:15 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
        tmac@hp.com, isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, jiang.liu@huawei.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 3/3] mm: Change __remove_pages() to call release_mem_region_adjustable()
Date: Tue,  2 Apr 2013 10:17:30 -0600
Message-Id: <1364919450-8741-4-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364919450-8741-1-git-send-email-toshi.kani@hp.com>
References: <1364919450-8741-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed __remove_pages() to call release_mem_region_adjustable().
This allows a requested memory range to be released from
the iomem_resource table even if it does not match exactly to
an resource entry but still fits into.  The resource entries
initialized at bootup usually cover the whole contiguous
memory ranges and may not necessarily match with the size of
memory hot-delete requests.

If release_mem_region_adjustable() failed, __remove_pages() logs
an error message and continues to proceed as it was the case
with release_mem_region().  release_mem_region(), which is defined
to __release_region(), logs an error message and returns no error
since a void function.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 mm/memory_hotplug.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 57decb2..c916582 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -705,8 +705,10 @@ EXPORT_SYMBOL_GPL(__add_pages);
 int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
 		 unsigned long nr_pages)
 {
-	unsigned long i, ret = 0;
+	unsigned long i;
 	int sections_to_remove;
+	resource_size_t start, size;
+	int ret = 0;
 
 	/*
 	 * We can only remove entire sections
@@ -714,7 +716,12 @@ int __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
 	BUG_ON(phys_start_pfn & ~PAGE_SECTION_MASK);
 	BUG_ON(nr_pages % PAGES_PER_SECTION);
 
-	release_mem_region(phys_start_pfn << PAGE_SHIFT, nr_pages * PAGE_SIZE);
+	start = phys_start_pfn << PAGE_SHIFT;
+	size = nr_pages * PAGE_SIZE;
+	ret = release_mem_region_adjustable(&iomem_resource, start, size);
+	if (ret)
+		pr_warn("Unable to release resource <%016llx-%016llx> (%d)\n",
+				start, start + size - 1, ret);
 
 	sections_to_remove = nr_pages / PAGES_PER_SECTION;
 	for (i = 0; i < sections_to_remove; i++) {
