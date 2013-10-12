Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3JLGKS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 02:10:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:37919 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab3JLGKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 02:10:15 -0400
X-IronPort-AV: E=Sophos;i="4.93,480,1378828800"; 
   d="scan'208";a="8731003"
Message-ID: <5258E77E.4020608@cn.fujitsu.com>
Date: Sat, 12 Oct 2013 14:09:02 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Chen Tang <imtangchen@gmail.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: [PATCH part2 v2 7/8] memblock, mem_hotplug: Make memblock skip hotpluggable
 regions if needed
References: <5258E560.5050506@cn.fujitsu.com>
In-Reply-To: <5258E560.5050506@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/12 14:08:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/12 14:08:02,
	Serialize complete at 2013/10/12 14:08:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Chen <tangchen@cn.fujitsu.com>

Linux kernel cannot migrate pages used by the kernel. As a result, hotpluggable
memory used by the kernel won't be able to be hot-removed. To solve this
problem, the basic idea is to prevent memblock from allocating hotpluggable
memory for the kernel at early time, and arrange all hotpluggable memory in
ACPI SRAT(System Resource Affinity Table) as ZONE_MOVABLE when initializing
zones.

In the previous patches, we have marked hotpluggable memory regions with
MEMBLOCK_HOTPLUG flag in memblock.memory.

In this patch, we make memblock skip these hotpluggable memory regions in
the default top-down allocation function if movable_node boot option is
specified.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 include/linux/memblock.h |   18 ++++++++++++++++++
 mm/memblock.c            |   12 ++++++++++++
 mm/memory_hotplug.c      |    1 +
 3 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 97480d3..bfc1dba 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -47,6 +47,10 @@ struct memblock {
 
 extern struct memblock memblock;
 extern int memblock_debug;
+#ifdef CONFIG_MOVABLE_NODE
+/* If movable_node boot option specified */
+extern bool movable_node_enabled;
+#endif /* CONFIG_MOVABLE_NODE */
 
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
@@ -65,6 +69,20 @@ int memblock_reserve(phys_addr_t base, phys_addr_t size);
 void memblock_trim_memory(phys_addr_t align);
 int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
 int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
+#ifdef CONFIG_MOVABLE_NODE
+static inline bool memblock_is_hotpluggable(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_HOTPLUG;
+}
+
+static inline bool movable_node_is_enabled(void)
+{
+	return movable_node_enabled;
+}
+#else
+static inline bool memblock_is_hotpluggable(struct memblock_region *m){ return false; }
+static inline bool movable_node_is_enabled(void) { return false; }
+#endif
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
diff --git a/mm/memblock.c b/mm/memblock.c
index 7de9c76..7f69012 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -39,6 +39,9 @@ struct memblock memblock __initdata_memblock = {
 };
 
 int memblock_debug __initdata_memblock;
+#ifdef CONFIG_MOVABLE_NODE
+bool movable_node_enabled __initdata_memblock = false;
+#endif
 static int memblock_can_resize __initdata_memblock;
 static int memblock_memory_in_slab __initdata_memblock = 0;
 static int memblock_reserved_in_slab __initdata_memblock = 0;
@@ -819,6 +822,11 @@ void __init_memblock __next_free_mem_range(u64 *idx, int nid,
  * @out_nid: ptr to int for nid of the range, can be %NULL
  *
  * Reverse of __next_free_mem_range().
+ *
+ * Linux kernel cannot migrate pages used by itself. Memory hotplug users won't
+ * be able to hot-remove hotpluggable memory used by the kernel. So this
+ * function skip hotpluggable regions if needed when allocating memory for the
+ * kernel.
  */
 void __init_memblock __next_free_mem_range_rev(u64 *idx, int nid,
 					   phys_addr_t *out_start,
@@ -843,6 +851,10 @@ void __init_memblock __next_free_mem_range_rev(u64 *idx, int nid,
 		if (nid != MAX_NUMNODES && nid != memblock_get_region_node(m))
 			continue;
 
+		/* skip hotpluggable memory regions if needed */
+		if (movable_node_is_enabled() && memblock_is_hotpluggable(m))
+			continue;
+
 		/* scan areas before each reservation for intersection */
 		for ( ; ri >= 0; ri--) {
 			struct memblock_region *r = &rsv->regions[ri];
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8c91d0a..729a2d8 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1436,6 +1436,7 @@ static int __init cmdline_parse_movable_node(char *p)
 	 * the kernel away from hotpluggable memory.
 	 */
 	memblock_set_bottom_up(true);
+	movable_node_enabled = true;
 #else
 	pr_warn("movable_node option not supported\n");
 #endif
-- 
1.7.1
