Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3IXKJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 06:09:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23399 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab3IXKJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:09:16 -0400
X-IronPort-AV: E=Sophos;i="4.90,969,1371052800"; 
   d="scan'208";a="8606675"
Message-ID: <5241649B.3090302@cn.fujitsu.com>
Date: Tue, 24 Sep 2013 18:08:27 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, Rik van Riel <riel@redhat.com>,
        jweiner@redhat.com, prarit@redhat.com
CC: "x86@kernel.org" <x86@kernel.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        imtangchen@gmail.com, Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: [PATCH 4/6] x86/mem-hotplug: Support initialize page tables bottom
 up
References: <524162DA.30004@cn.fujitsu.com>
In-Reply-To: <524162DA.30004@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/24 18:07:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/24 18:07:33,
	Serialize complete at 2013/09/24 18:07:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Chen <tangchen@cn.fujitsu.com>

The Linux kernel cannot migrate pages used by the kernel. As a
result, kernel pages cannot be hot-removed. So we cannot allocate
hotpluggable memory for the kernel.

In a memory hotplug system, any numa node the kernel resides in
should be unhotpluggable. And for a modern server, each node could
have at least 16GB memory. So memory around the kernel image is
highly likely unhotpluggable.

ACPI SRAT (System Resource Affinity Table) contains the memory
hotplug info. But before SRAT is parsed, memblock has already
started to allocate memory for the kernel. So we need to prevent
memblock from doing this.

So direct memory mapping page tables setup is the case. init_mem_mapping()
is called before SRAT is parsed. To prevent page tables being allocated
within hotpluggable memory, we will use bottom-up direction to allocate
page tables from the end of kernel image to the higher memory.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/mm/init.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 73e79e6..7441865 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -451,6 +451,50 @@ static void __init memory_map_top_down(unsigned long map_start,
 		init_range_memory_mapping(real_end, map_end);
 }
 
+
+#ifdef CONFIG_MOVABLE_NODE
+/**
+ * memory_map_bottom_up - Map [map_start, map_end) bottom up
+ * @map_start: start address of the target memory range
+ * @map_end: end address of the target memory range
+ *
+ * This function will setup direct mapping for memory range [map_start, map_end)
+ * in a heuristic way. In the beginning, step_size is small. The more memory we
+ * map memory in the next loop.
+ */
+static void __init memory_map_bottom_up(unsigned long map_start,
+					unsigned long map_end)
+{
+	unsigned long next, new_mapped_ram_size, start;
+	unsigned long mapped_ram_size = 0;
+	/* step_size need to be small so pgt_buf from BRK could cover it */
+	unsigned long step_size = PMD_SIZE;
+	start = map_start;
+
+	while (start < map_end) {
+		if (map_end - start > step_size) {
+			next = round_up(start + 1, step_size);
+			if (next > map_end)
+				next = map_end;
+		} else
+			next = map_end;
+
+		new_mapped_ram_size = init_range_memory_mapping(start, next);
+		min_pfn_mapped = start >> PAGE_SHIFT;
+		start = next;
+
+		if (new_mapped_ram_size > mapped_ram_size)
+			step_size <<= STEP_SIZE_SHIFT;
+		mapped_ram_size += new_mapped_ram_size;
+	}
+}
+#else
+static void __init memory_map_bottom_up(unsigned long map_start,
+					unsigned long map_end)
+{
+}
+#endif /* CONFIG_MOVABLE_NODE */
+
 void __init init_mem_mapping(void)
 {
 	unsigned long end;
@@ -467,12 +511,23 @@ void __init init_mem_mapping(void)
 	init_memory_mapping(0, ISA_END_ADDRESS);
 
 	/*
-	 * We start from the top (end of memory) and go to the bottom.
-	 * The memblock_find_in_range() gets us a block of RAM from the
-	 * end of RAM in [min_pfn_mapped, max_pfn_mapped) used as new pages
-	 * for page table.
+	 * If the allocation is in bottom-up direction, we start from the
+	 * bottom and go to the top: first [kernel_end, end) and then
+	 * [ISA_END_ADDRESS, kernel_end). Otherwise, we start from the top
+	 * (end of memory) and go to the bottom.
+	 *
+	 * The memblock_find_in_range() gets us a block of RAM in
+	 * [min_pfn_mapped, max_pfn_mapped) used as new pages for page table.
 	 */
-	memory_map_top_down(ISA_END_ADDRESS, end);
+	if (memblock_bottom_up()) {
+		unsigned long kernel_end;
+
+		kernel_end = round_up(__pa_symbol(_end), PMD_SIZE);
+		memory_map_bottom_up(kernel_end, end);
+		memory_map_bottom_up(ISA_END_ADDRESS, kernel_end);
+	} else {
+		memory_map_top_down(ISA_END_ADDRESS, end);
+	}
 
 #ifdef CONFIG_X86_64
 	if (max_pfn > max_low_pfn) {
-- 
1.7.1
