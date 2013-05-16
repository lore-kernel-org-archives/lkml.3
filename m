Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3EPLrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:47:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32714 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab3EPLrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:47:36 -0400
X-IronPort-AV: E=Sophos;i="4.87,683,1363104000"; 
   d="scan'208";a="7286064"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: yinghai@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        penberg@kernel.org, jacob.shin@amd.com, akpm@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] numa, mm, memory-hotplug: Do not allocate pagetable to local node with MEMORY_HOTREMOVE enabled.
Date: Thu, 16 May 2013 19:50:21 +0800
Message-Id: <1368705021-24396-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/16 19:46:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/16 19:46:17,
	Serialize complete at 2013/05/16 19:46:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch-set allocated pagetables to local node.
https://lkml.org/lkml/2013/4/11/829

Doing this will break memory hot-remove.

Before removing memory, the kernel offlines memory. If offlining
memory fails, the memory cannot be removed. The pagetables are
used by the kernel, so they cannot be offlined. Furthermore, they
cannot be removed.

Of course, we can free pagetable pages because the pagetables of
the to be removed memory are useless. But offlining memory doesn't
mean removing memory. If users only want to offline memory, the
pagetables should not be freed.

The minimum unit of memory online/offline is block. And by default,
one block contains one section, which by default is 128MB. There is
possiblity that half of the block is pagetable, and the other half
is movable memory.

When we offline this kind of block, the status of the block is
uncertain. We cannot simply free the pagetables in this block because
they may be used by other online blocks. But when doing memory
hot-remove, the failure of offlining blocks will break the memory
hot-remove logic.


In order to fix it, we have three solutions:

1. Reserve the whole block (128MB), making no user can use the rest
   parts of the block. And skip them when offlining memory.
   When all the other blocks are offlined, free the pagetable, and remove
   all the memory.

   But we may lose some memory for this purpose. 128MB is a little big
   to waste.


2. Keep this block online. Although the offline operation fails, it is
   OK to remove memory.

   But the offline operation will always fail. And generally speaking,
   there are a lot of reasons of offline failing, it is difficult to
   detect if it is OK to remove memory. So we don't suggest this way.


3. Migrate user pages and make this block offline. Offlining memory won't
   stop the kernel using the pagetables stored in them, so it will be OK.

   But this will change the semantics of "offline". I'm not sure if we
   can do it in this way.


So before we fix this problem, I think we should not allocate pagetables
to local node when CONFIG_MEMORY_HOTREMOVE is enabled. And recover it when
we confirm the direction and fix the problem.

This patch is based on
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm

Any other solution for this problem is welcome.


Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/init.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8d0007a..8cd8a2d 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -55,18 +55,23 @@ __ref void *alloc_low_pages(unsigned int num)
 
 	if ((pgt_buf_end + num) > pgt_buf_top || !can_use_brk_pgt) {
 		unsigned long ret;
-		if (local_min_pfn_mapped >= local_max_pfn_mapped) {
+#ifndef CONFIG_MEMORY_HOTPLUG
+		if (local_max_pfn_mapped > local_min_pfn_mapped) {
+			ret = memblock_find_in_range(
+					local_min_pfn_mapped << PAGE_SHIFT,
+					local_max_pfn_mapped << PAGE_SHIFT,
+					PAGE_SIZE * num , PAGE_SIZE);
+		} else
+#endif
+		{
 			if (low_min_pfn_mapped >= low_max_pfn_mapped)
 				panic("alloc_low_page: ran out of memory");
 			ret = memblock_find_in_range(
 					low_min_pfn_mapped << PAGE_SHIFT,
 					low_max_pfn_mapped << PAGE_SHIFT,
 					PAGE_SIZE * num , PAGE_SIZE);
-		} else
-			ret = memblock_find_in_range(
-					local_min_pfn_mapped << PAGE_SHIFT,
-					local_max_pfn_mapped << PAGE_SHIFT,
-					PAGE_SIZE * num , PAGE_SIZE);
+		}
+
 		if (!ret)
 			panic("alloc_low_page: can not alloc memory");
 		memblock_reserve(ret, PAGE_SIZE * num);
@@ -443,6 +448,11 @@ void __init init_mem_mapping(unsigned long begin, unsigned long end)
 		if (new_mapped_ram_size > mapped_ram_size)
 			step_size <<= STEP_SIZE_SHIFT;
 		mapped_ram_size += new_mapped_ram_size;
+
+		if (is_low) {
+			low_min_pfn_mapped = local_min_pfn_mapped;
+			low_max_pfn_mapped = local_max_pfn_mapped;
+		}
 	}
 
 	if (real_end < end) {
@@ -450,11 +460,6 @@ void __init init_mem_mapping(unsigned long begin, unsigned long end)
 		if ((end >> PAGE_SHIFT) > local_max_pfn_mapped)
 			local_max_pfn_mapped = end >> PAGE_SHIFT;
 	}
-
-	if (is_low) {
-		low_min_pfn_mapped = local_min_pfn_mapped;
-		low_max_pfn_mapped = local_max_pfn_mapped;
-	}
 }
 
 #ifndef CONFIG_NUMA
-- 
1.7.1

