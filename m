Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab3FMNia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:38:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63792 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758094Ab3FMN2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:28:01 -0400
X-IronPort-AV: E=Sophos;i="4.87,858,1363104000"; 
   d="scan'208";a="7537684"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [Part2 PATCH v4 11/15] x86, numa, memblock: Introduce MEMBLK_LOCAL_NODE to mark and reserve node-life-cycle data.
Date: Thu, 13 Jun 2013 21:03:35 +0800
Message-Id: <1371128619-8987-12-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371128619-8987-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128619-8987-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:59:20,
	Serialize complete at 2013/06/13 20:59:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

node-life-cycle data (whose life cycle is the same as a node)
allocated by memblock should be marked so that when we free usable
memory to buddy system, we can skip them.

This patch introduces a flag MEMBLK_LOCAL_NODE for memblock to reserve
node-life-cycle data. For now, it is only kernel direct mapping pagetable
pages, based on Yinghai's patch.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/init.c       |   16 ++++++++++++----
 include/linux/memblock.h |    2 ++
 mm/memblock.c            |    6 ++++++
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 9ff71ff..63abb46 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -62,14 +62,22 @@ __ref void *alloc_low_pages(unsigned int num)
 					low_min_pfn_mapped << PAGE_SHIFT,
 					low_max_pfn_mapped << PAGE_SHIFT,
 					PAGE_SIZE * num , PAGE_SIZE);
-		} else
+			if (!ret)
+				panic("alloc_low_page: can not alloc memory");
+
+			memblock_reserve(ret, PAGE_SIZE * num);
+		} else {
 			ret = memblock_find_in_range(
 					local_min_pfn_mapped << PAGE_SHIFT,
 					local_max_pfn_mapped << PAGE_SHIFT,
 					PAGE_SIZE * num , PAGE_SIZE);
-		if (!ret)
-			panic("alloc_low_page: can not alloc memory");
-		memblock_reserve(ret, PAGE_SIZE * num);
+			if (!ret)
+				panic("alloc_low_page: can not alloc memory");
+
+			memblock_reserve_local_node(ret, PAGE_SIZE * num,
+					memory_add_physaddr_to_nid(ret));
+		}
+
 		pfn = ret >> PAGE_SHIFT;
 	} else {
 		pfn = pgt_buf_end;
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 5a52f37..517c027 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -21,6 +21,7 @@
 
 /* Definition of memblock flags. */
 #define MEMBLK_FLAGS_DEFAULT	0x0	/* default flag */
+#define	MEMBLK_LOCAL_NODE	0x1	/* node-life-cycle data */
 
 struct memblock_region {
 	phys_addr_t base;
@@ -62,6 +63,7 @@ int memblock_remove(phys_addr_t base, phys_addr_t size);
 int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
 int memblock_reserve_node(phys_addr_t base, phys_addr_t size, int nid);
+int memblock_reserve_local_node(phys_addr_t base, phys_addr_t size, int nid);
 void memblock_trim_memory(phys_addr_t align);
 void memblock_mark_kernel_nodes(void);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index bb53c54..e747bc6 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -597,6 +597,12 @@ int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 				       MEMBLK_FLAGS_DEFAULT);
 }
 
+int __init_memblock memblock_reserve_local_node(phys_addr_t base,
+					phys_addr_t size, int nid)
+{
+	return memblock_reserve_region(base, size, nid, MEMBLK_LOCAL_NODE);
+}
+
 /**
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
-- 
1.7.1

