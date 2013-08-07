Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab3HGKy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:54:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61307 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab3HGKxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:53:53 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8144159"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH v3 22/25] memblock, mem_hotplug: Introduce MEMBLOCK_HOTPLUG flag to mark hotpluggable regions.
Date: Wed, 7 Aug 2013 18:52:13 +0800
Message-Id: <1375872736-4822-23-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375872736-4822-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375872736-4822-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:52:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:52:19,
	Serialize complete at 2013/08/07 18:52:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In find_hotpluggable_memory, once we find out a memory region which is
hotpluggable, we want to mark them in memblock.memory. So that we could
control memblock allocator not to allocte hotpluggable memory for the kernel
later.

To achieve this goal, we introduce MEMBLOCK_HOTPLUG flag to indicate the
hotpluggable memory regions in memblock and a function memblock_mark_hotplug()
to mark hotpluggable memory if we find one.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 include/linux/memblock.h |   11 +++++++++++
 mm/memblock.c            |   26 ++++++++++++++++++++++++++
 mm/memory_hotplug.c      |    3 ++-
 3 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index e89e0cd..c0bd31c 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -19,6 +19,9 @@
 
 #define INIT_MEMBLOCK_REGIONS	128
 
+/* Definition of memblock flags. */
+#define MEMBLOCK_HOTPLUG	0x1	/* hotpluggable region */
+
 struct memblock_region {
 	phys_addr_t base;
 	phys_addr_t size;
@@ -60,6 +63,8 @@ int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
 void memblock_trim_memory(phys_addr_t align);
 
+int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
 			  unsigned long *out_end_pfn, int *out_nid);
@@ -119,6 +124,12 @@ void __next_free_mem_range_rev(u64 *idx, int nid, phys_addr_t *out_start,
 	     i != (u64)ULLONG_MAX;					\
 	     __next_free_mem_range_rev(&i, nid, p_start, p_end, p_nid))
 
+static inline void memblock_set_region_flags(struct memblock_region *r,
+					     unsigned long flags)
+{
+	r->flags = flags;
+}
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int memblock_set_node(phys_addr_t base, phys_addr_t size, int nid);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 0841a6e..ecd8568 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -585,6 +585,32 @@ int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 }
 
 /**
+ * memblock_mark_hotplug - Mark hotpluggable memory with flag MEMBLOCK_HOTPLUG.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * This function isolates region [@base, @base + @size), and mark it with flag
+ * MEMBLOCK_HOTPLUG.
+ *
+ * Return 0 on succees, -errno on failure.
+ */
+int __init_memblock memblock_mark_hotplug(phys_addr_t base, phys_addr_t size)
+{
+	struct memblock_type *type = &memblock.memory;
+	int i, ret, start_rgn, end_rgn;
+
+	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
+	if (ret)
+		return ret;
+
+	for (i = start_rgn; i < end_rgn; i++)
+		memblock_set_region_flags(&type->regions[i], MEMBLOCK_HOTPLUG);
+
+	memblock_merge_regions(type);
+	return 0;
+}
+
+/**
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
  * @nid: node selector, %MAX_NUMNODES for all nodes
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 3d760fc..0a69ceb 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -174,7 +174,8 @@ void __init find_hotpluggable_memory(void)
 		if (kernel_resides_in_region(base, size))
 			continue;
 
-		/* Will mark hotpluggable memory regions here */
+		/* Mark hotpluggable memory regions in memblock.memory */
+		memblock_mark_hotplug(base, size);
 	}
 
 	early_iounmap(srat_vaddr, length);
-- 
1.7.1

