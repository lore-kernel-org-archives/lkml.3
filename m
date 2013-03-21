Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab3CUJVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:21:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46389 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757346Ab3CUJSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:18:23 -0400
X-IronPort-AV: E=Sophos;i="4.84,884,1355068800"; 
   d="scan'208";a="6917162"
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
Subject: [RESEND PATCH part1 4/9] x86, mm, numa, acpi: Introduce zone_movable_limit[] to store start pfn of ZONE_MOVABLE.
Date: Thu, 21 Mar 2013 17:20:50 +0800
Message-Id: <1363857655-30658-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1363857655-30658-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1363857655-30658-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/21 17:16:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/21 17:16:50,
	Serialize complete at 2013/03/21 17:16:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since node info in SRAT may not be in increasing order, we may meet
a lower range after we handled a higher range. So we need to keep
the lowest movable pfn each time we parse a SRAT memory entry, and
update it when we get a lower one.

This patch introduces a new array zone_movable_limit[], which is used
to store the start pfn of each node's ZONE_MOVABLE.

We update it each time we parsed a SRAT memory entry if necessary.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/srat.c |   29 +++++++++++++++++++++++++++++
 include/linux/mm.h |    9 +++++++++
 mm/page_alloc.c    |   35 +++++++++++++++++++++++++++++++++--
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 5055fa7..6cd4d33 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -141,6 +141,33 @@ static inline int save_add_info(void) {return 1;}
 static inline int save_add_info(void) {return 0;}
 #endif
 
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+static void __init sanitize_movablemem_map(int nid, u64 start, u64 end)
+{
+	int overlap;
+	unsigned long start_pfn, end_pfn;
+
+	start_pfn = PFN_DOWN(start);
+	end_pfn = PFN_UP(end);
+
+	overlap = movablemem_map_overlap(start_pfn, end_pfn);
+	if (overlap >= 0) {
+		start_pfn = max(start_pfn,
+				movablemem_map.map[overlap].start_pfn);
+
+		if (zone_movable_limit[nid])
+			zone_movable_limit[nid] = min(zone_movable_limit[nid],
+						      start_pfn);
+		else
+			zone_movable_limit[nid] = start_pfn;
+	}
+}
+#else		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+static inline void sanitize_movablemem_map(int nid, u64 start, u64 end)
+{
+}
+#endif		/* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
+
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
 int __init
 acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
@@ -181,6 +208,8 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	       (unsigned long long) start, (unsigned long long) end - 1,
 	       hotpluggable ? "Hot Pluggable" : "");
 
+	sanitize_movablemem_map(node, start, end);
+
 	return 0;
 out_err_bad_srat:
 	bad_srat();
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9c068d5..d2c5fec 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1343,6 +1343,15 @@ struct movablemem_map {
 	struct movablemem_entry map[MOVABLEMEM_MAP_MAX];
 };
 
+extern struct movablemem_map movablemem_map;
+
+extern void __init insert_movablemem_map(unsigned long start_pfn,
+					 unsigned long end_pfn);
+extern int __init movablemem_map_overlap(unsigned long start_pfn,
+					 unsigned long end_pfn);
+
+extern unsigned long __meminitdata zone_movable_limit[MAX_NUMNODES];
+
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 #if !defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP) && \
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 27fcd29..f451ded 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -210,6 +210,7 @@ static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __initdata required_kernelcore;
 static unsigned long __initdata required_movablecore;
 static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
+unsigned long __meminitdata zone_movable_limit[MAX_NUMNODES];
 
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
@@ -5065,6 +5066,36 @@ early_param("kernelcore", cmdline_parse_kernelcore);
 early_param("movablecore", cmdline_parse_movablecore);
 
 /**
+ * movablemem_map_overlap() - Check if a range overlaps movablemem_map.map[].
+ * @start_pfn: start pfn of the range to be checked
+ * @end_pfn:   end pfn of the range to be checked (exclusive)
+ *
+ * This function checks if a given memory range [start_pfn, end_pfn) overlaps
+ * the movablemem_map.map[] array.
+ *
+ * Return: index of the first overlapped element in movablemem_map.map[]
+ *         or -1 if they don't overlap each other.
+ */
+int __init movablemem_map_overlap(unsigned long start_pfn,
+				  unsigned long end_pfn)
+{
+	int overlap;
+
+	if (!movablemem_map.nr_map)
+		return -1;
+
+	for (overlap = 0; overlap < movablemem_map.nr_map; overlap++)
+		if (start_pfn < movablemem_map.map[overlap].end_pfn)
+			break;
+
+	if (overlap == movablemem_map.nr_map ||
+	    end_pfn <= movablemem_map.map[overlap].start_pfn)
+		return -1;
+
+	return overlap;
+}
+
+/**
  * insert_movablemem_map - Insert a memory range in to movablemem_map.map.
  * @start_pfn:	start pfn of the range
  * @end_pfn:	end pfn of the range
@@ -5072,8 +5103,8 @@ early_param("movablecore", cmdline_parse_movablecore);
  * This function will also merge the overlapped ranges, and sort the array
  * by start_pfn in monotonic increasing order.
  */
-static void __init insert_movablemem_map(unsigned long start_pfn,
-					  unsigned long end_pfn)
+void __init insert_movablemem_map(unsigned long start_pfn,
+				  unsigned long end_pfn)
 {
 	int pos, overlap;
 
-- 
1.7.1

