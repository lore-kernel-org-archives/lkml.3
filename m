Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab3CUJUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:20:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46389 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757138Ab3CUJS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:18:26 -0400
X-IronPort-AV: E=Sophos;i="4.84,884,1355068800"; 
   d="scan'208";a="6917166"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org, wency@cn.fujitsu.com,
        trenn@suse.de, liwanp@linux.vnet.ibm.com, mgorman@suse.de,
        walken@google.com, riel@redhat.com, khlebnikov@openvz.org,
        tj@kernel.org, minchan@kernel.org, m.szyprowski@samsung.com,
        mina86@mina86.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linfeng@cn.fujitsu.com,
        jiang.liu@huawei.com, kosaki.motohiro@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RESEND PATCH part1 6/9] x86, mm, numa, acpi: Support getting hotplug info from SRAT.
Date: Thu, 21 Mar 2013 17:20:52 +0800
Message-Id: <1363857655-30658-7-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1363857655-30658-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1363857655-30658-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/21 17:16:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/21 17:16:52,
	Serialize complete at 2013/03/21 17:16:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now provide an option for users who don't want to specify physical
memory address in kernel commandline.

        /*
         * For movablemem_map=acpi:
         *
         * SRAT:                |_____| |_____| |_________| |_________| ......
         * node id:                0       1         1           2
         * hotpluggable:           n       y         y           n
         * movablemem_map:              |_____| |_________|
         *
         * Using movablemem_map, we can prevent memblock from allocating memory
         * on ZONE_MOVABLE at boot time.
         */

So user just specify movablemem_map=acpi, and the kernel will use hotpluggable
info in SRAT to determine which memory ranges should be set as ZONE_MOVABLE.

NOTE: Using this way will cause NUMA performance down because the whole node
      will be set as ZONE_MOVABLE, and kernel cannot use memory on it.
      If users don't want to lose NUMA performance, just don't use it.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |   15 +++++++
 arch/x86/mm/srat.c                  |   74 +++++++++++++++++++++++++++++++++--
 include/linux/mm.h                  |    2 +
 mm/page_alloc.c                     |   22 ++++++++++-
 4 files changed, 108 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index dd3a36a..40387a2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1649,6 +1649,17 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			that the amount of memory usable for all allocations
 			is not too small.
 
+	movablemem_map=acpi
+			[KNL,X86,IA-64,PPC] This parameter is similar to
+			memmap except it specifies the memory map of
+			ZONE_MOVABLE.
+			This option inform the kernel to use Hot Pluggable bit
+			in flags from SRAT from ACPI BIOS to determine which
+			memory devices could be hotplugged. The corresponding
+			memory ranges will be set as ZONE_MOVABLE.
+			NOTE: Whatever node the kernel resides in will always
+			      be un-hotpluggable.
+
 	movablemem_map=nn[KMG]@ss[KMG]
 			[KNL,X86,IA-64,PPC] This parameter is similar to
 			memmap except it specifies the memory map of
@@ -1669,6 +1680,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			satisfied. So the administrator should be careful that
 			the amount of movablemem_map areas are not too large.
 			Otherwise kernel won't have enough memory to start.
+			NOTE: We don't stop users specifying the node the
+			      kernel resides in as hotpluggable so that this
+			      option can be used as a workaround of firmware
+			      bugs.
 
 	MTD_Partition=	[MTD]
 			Format: <name>,<region-number>,<size>,<offset>
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 44a9b9b..4f443de 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -142,15 +142,78 @@ static inline int save_add_info(void) {return 0;}
 #endif
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-static void __init sanitize_movablemem_map(int nid, u64 start, u64 end)
+static void __init sanitize_movablemem_map(int nid, u64 start, u64 end,
+					   bool hotpluggable)
 {
-	int overlap;
+	int overlap, i;
 	unsigned long start_pfn, end_pfn;
 
 	start_pfn = PFN_DOWN(start);
 	end_pfn = PFN_UP(end);
 
 	/*
+	 * For movablemem_map=acpi:
+	 *
+	 * SRAT:                |_____| |_____| |_________| |_________| ......
+	 * node id:                0       1         1           2
+	 * hotpluggable:           n       y         y           n
+	 * movablemem_map:              |_____| |_________|
+	 *
+	 * Using movablemem_map, we can prevent memblock from allocating memory
+	 * on ZONE_MOVABLE at boot time.
+	 *
+	 * Before parsing SRAT, memblock has already reserve some memory ranges
+	 * for other purposes, such as for kernel image. We cannot prevent
+	 * kernel from using these memory, so we need to exclude these memory
+	 * even if it is hotpluggable.
+	 * Furthermore, to ensure the kernel has enough memory to boot, we make
+	 * all the memory on the node which the kernel resides in should be
+	 * un-hotpluggable.
+	 */
+	if (hotpluggable && movablemem_map.acpi) {
+		/* Exclude ranges reserved by memblock. */
+		struct memblock_type *rgn = &memblock.reserved;
+
+		for (i = 0; i < rgn->cnt; i++) {
+			if (end <= rgn->regions[i].base ||
+			    start >= rgn->regions[i].base +
+			    rgn->regions[i].size)
+				continue;
+
+			/*
+			 * If the memory range overlaps the memory reserved by
+			 * memblock, then the kernel resides in this node.
+			 */
+			node_set(nid, movablemem_map.numa_nodes_kernel);
+			zone_movable_limit[nid] = 0;
+
+			return;
+		}
+
+		/*
+		 * If the kernel resides in this node, then the whole node
+		 * should not be hotpluggable.
+		 */
+		if (node_isset(nid, movablemem_map.numa_nodes_kernel)) {
+			zone_movable_limit[nid] = 0;
+			return;
+		}
+
+		/*
+		 * Otherwise, if the range is hotpluggable, and the kernel is
+		 * not on this node, insert it into movablemem_map.
+		 */
+		insert_movablemem_map(start_pfn, end_pfn);
+		if (zone_movable_limit[nid])
+			zone_movable_limit[nid] = min(zone_movable_limit[nid],
+						      start_pfn);
+		else
+			zone_movable_limit[nid] = start_pfn;
+
+		return;
+	}
+
+	/*
 	 * For movablemem_map=nn[KMG]@ss[KMG]:
 	 *
 	 * SRAT:                |_____| |_____| |_________| |_________| ......
@@ -160,6 +223,8 @@ static void __init sanitize_movablemem_map(int nid, u64 start, u64 end)
 	 *
 	 * Using movablemem_map, we can prevent memblock from allocating memory
 	 * on ZONE_MOVABLE at boot time.
+	 *
+	 * NOTE: In this case, SRAT info will be ingored.
 	 */
 	overlap = movablemem_map_overlap(start_pfn, end_pfn);
 	if (overlap >= 0) {
@@ -189,7 +254,8 @@ static void __init sanitize_movablemem_map(int nid, u64 start, u64 end)
 	}
 }
 #else		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
-static inline void sanitize_movablemem_map(int nid, u64 start, u64 end)
+static inline void sanitize_movablemem_map(int nid, u64 start, u64 end,
+					   bool hotpluggable)
 {
 }
 #endif		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
@@ -234,7 +300,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	       (unsigned long long) start, (unsigned long long) end - 1,
 	       hotpluggable ? "Hot Pluggable" : "");
 
-	sanitize_movablemem_map(node, start, end);
+	sanitize_movablemem_map(node, start, end, hotpluggable);
 
 	return 0;
 out_err_bad_srat:
diff --git a/include/linux/mm.h b/include/linux/mm.h
index d2c5fec..37cf1d7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1339,8 +1339,10 @@ struct movablemem_entry {
 };
 
 struct movablemem_map {
+	bool acpi;	/* True if using SRAT info. */
 	int nr_map;
 	struct movablemem_entry map[MOVABLEMEM_MAP_MAX];
+	nodemask_t numa_nodes_kernel;   /* on which nodes kernel resides in */
 };
 
 extern struct movablemem_map movablemem_map;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f451ded..31d27af 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -203,7 +203,10 @@ static unsigned long __meminitdata dma_reserve;
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 /* Movable memory ranges, will also be used by memblock subsystem. */
-struct movablemem_map movablemem_map;
+struct movablemem_map movablemem_map = {
+	.acpi = false,
+	.nr_map = 0,
+};
 
 static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
@@ -5204,6 +5207,23 @@ static int __init cmdline_parse_movablemem_map(char *p)
 	if (!p)
 		goto err;
 
+	if (!strcmp(p, "acpi"))
+		movablemem_map.acpi = true;
+
+	/*
+	 * If user decide to use info from BIOS, all the other user specified
+	 * ranges will be ingored.
+	 */
+	if (movablemem_map.acpi) {
+		if (movablemem_map.nr_map) {
+			memset(movablemem_map.map, 0,
+			       sizeof(struct movablemem_entry) *
+			       movablemem_map.nr_map);
+			movablemem_map.nr_map = 0;
+		}
+		return 0;
+	}
+
 	oldp = p;
 	mem_size = memparse(p, &p);
 	if (p == oldp)
-- 
1.7.1

