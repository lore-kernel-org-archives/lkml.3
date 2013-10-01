Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3JAJtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:49:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:29821 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab3JAJtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:49:42 -0400
X-IronPort-AV: E=Sophos;i="4.90,1013,1371052800"; 
   d="scan'208";a="8662831"
Message-ID: <524A9A7D.6000900@cn.fujitsu.com>
Date: Tue, 01 Oct 2013 17:48:45 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: robert.moore@intel.com, lv.zheng@intel.com,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        "mina86@mina86.com" <mina86@mina86.com>, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, Rik van Riel <riel@redhat.com>,
        prarit@redhat.com, Toshi Kani <toshi.kani@hp.com>
CC: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>, imtangchen@gmail.com,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: [PATCH -mm 3/8] memblock, mem_hotplug: Introduce MEMBLOCK_HOTPLUG
 flag to mark hotpluggable regions
References: <524A991D.3050005@cn.fujitsu.com>
In-Reply-To: <524A991D.3050005@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/01 17:47:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/01 17:47:47,
	Serialize complete at 2013/10/01 17:47:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Chen <tangchen@cn.fujitsu.com>

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
 include/linux/memblock.h |   17 +++++++++++++++
 mm/memblock.c            |   52 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 894d59e..10fa75b 100644
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
@@ -60,6 +63,8 @@ int memblock_remove(phys_addr_t base, phys_addr_t size);
 int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
 void memblock_trim_memory(phys_addr_t align);
+int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
+int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
@@ -122,6 +127,18 @@ void __next_free_mem_range_rev(u64 *idx, int nid, phys_addr_t *out_start,
 	     i != (u64)ULLONG_MAX;					\
 	     __next_free_mem_range_rev(&i, nid, p_start, p_end, p_nid))
 
+static inline void memblock_set_region_flags(struct memblock_region *r,
+					     unsigned long flags)
+{
+	r->flags |= flags;
+}
+
+static inline void memblock_clear_region_flags(struct memblock_region *r,
+					       unsigned long flags)
+{
+	r->flags &= ~flags;
+}
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int memblock_set_node(phys_addr_t base, phys_addr_t size, int nid);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 3ec8aef..bd26ce8 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -683,6 +683,58 @@ int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
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
+ * memblock_clear_hotplug - Clear flag MEMBLOCK_HOTPLUG for a specified region.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * This function isolates region [@base, @base + @size), and clear flag
+ * MEMBLOCK_HOTPLUG for the isolated regions.
+ *
+ * Return 0 on succees, -errno on failure.
+ */
+int __init_memblock memblock_clear_hotplug(phys_addr_t base, phys_addr_t size)
+{
+	struct memblock_type *type = &memblock.memory;
+	int i, ret, start_rgn, end_rgn;
+
+	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
+	if (ret)
+		return ret;
+
+	for (i = start_rgn; i < end_rgn; i++)
+		memblock_clear_region_flags(&type->regions[i], MEMBLOCK_HOTPLUG);
+
+	memblock_merge_regions(type);
+	return 0;
+}
+
+/**
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
  * @nid: node selector, %MAX_NUMNODES for all nodes
-- 
1.7.1
