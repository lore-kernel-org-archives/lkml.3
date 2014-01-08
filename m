Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbaAHNm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:42:26 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:42525 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbaAHNmW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:42:22 -0500
Date: Wed, 8 Jan 2014 14:42:13 +0100
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: Jianguo Wu <wujianguo@huawei.com>
Cc: <akpm@linux-foundation.org>, <jiang.liu@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <iamjoonsoo.kim@lge.com>, <hannes@cmpxchg.org>,
        <tangchen@cn.fujitsu.com>, <tj@kernel.org>, <toshi.kani@hp.com>
Subject: Re: [PATCH 2/2] mm: free memblock.memory in free_all_bootmem
Message-ID: <20140108144213.4c1995b2@lilie>
In-Reply-To: <52CCCF24.4080300@huawei.com>
References: <1389107774-54978-1-git-send-email-phacht@linux.vnet.ibm.com>
	<1389107774-54978-3-git-send-email-phacht@linux.vnet.ibm.com>
	<52CCCF24.4080300@huawei.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010813-8372-0000-0000-000008465E17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wed, 8 Jan 2014 12:08:04 +0800
schrieb Jianguo Wu <wujianguo@huawei.com>:

> For some archs, like arm64, would use memblock.memory after system
> booting, so we can not simply released to the buddy allocator, maybe
> need !defined(CONFIG_ARCH_DISCARD_MEMBLOCK).

Oh, I see. I have added some ifdefs to prevent memblock.memory from
being freed when CONFIG_ARCH_DISCARD_MEMBLOCK is not set.

Here is a replacement for the patch.

Kind regards

Philipp

>From aca95bcb9d79388b68bf18e7bae4353259b6758f Mon Sep 17 00:00:00 2001
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Date: Thu, 19 Dec 2013 15:53:46 +0100
Subject: [PATCH 2/2] mm: free memblock.memory in free_all_bootmem

When calling free_all_bootmem() the free areas under memblock's
control are released to the buddy allocator. Additionally the
reserved list is freed if it was reallocated by memblock.
The same should apply for the memory list.

Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
---
 include/linux/memblock.h |  1 +
 mm/memblock.c            | 16 ++++++++++++++++
 mm/nobootmem.c           | 10 +++++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 77c60e5..d174922 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,7 @@ phys_addr_t memblock_find_in_range_node(phys_addr_t start, phys_addr_t end,
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
 phys_addr_t get_allocated_memblock_reserved_regions_info(phys_addr_t *addr);
+phys_addr_t get_allocated_memblock_memory_regions_info(phys_addr_t *addr);
 void memblock_allow_resize(void);
 int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_add(phys_addr_t base, phys_addr_t size);
diff --git a/mm/memblock.c b/mm/memblock.c
index 53e477b..a78b2e9 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -271,6 +271,22 @@ phys_addr_t __init_memblock get_allocated_memblock_reserved_regions_info(
 			  memblock.reserved.max);
 }
 
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+
+phys_addr_t __init_memblock get_allocated_memblock_memory_regions_info(
+					phys_addr_t *addr)
+{
+	if (memblock.memory.regions == memblock_memory_init_regions)
+		return 0;
+
+	*addr = __pa(memblock.memory.regions);
+
+	return PAGE_ALIGN(sizeof(struct memblock_region) *
+			  memblock.memory.max);
+}
+
+#endif
+
 /**
  * memblock_double_array - double the size of the memblock regions array
  * @type: memblock type of the regions array being doubled
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 3a7e14d..63ff3f6 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -122,11 +122,19 @@ static unsigned long __init free_low_memory_core_early(void)
 	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
-	/* free range that is used for reserved array if we allocate it */
+	/* Free memblock.reserved array if it was allocated */
 	size = get_allocated_memblock_reserved_regions_info(&start);
 	if (size)
 		count += __free_memory_core(start, start + size);
 
+#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
+
+	/* Free memblock.memory array if it was allocated */
+	size = get_allocated_memblock_memory_regions_info(&start);
+	if (size)
+		count += __free_memory_core(start, start + size);
+#endif
+
 	return count;
 }
 
-- 
1.8.4.5

