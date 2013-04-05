Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161656Ab3DEJjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 05:39:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12694 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1161336Ab3DEJhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 05:37:20 -0400
X-IronPort-AV: E=Sophos;i="4.87,413,1363104000"; 
   d="scan'208";a="7001886"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org, wency@cn.fujitsu.com,
        trenn@suse.de, liwanp@linux.vnet.ibm.com, mgorman@suse.de,
        walken@google.com, riel@redhat.com, khlebnikov@openvz.org,
        tj@kernel.org, minchan@kernel.org, m.szyprowski@samsung.com,
        mina86@mina86.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linfeng@cn.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, jiang.liu@huawei.com,
        guz.fnst@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 04/11] x86, numa, acpi, memory-hotplug: Introduce hotplug info into struct numa_meminfo.
Date: Fri, 5 Apr 2013 17:39:54 +0800
Message-Id: <1365154801-473-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1365154801-473-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1365154801-473-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/05 17:36:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/05 17:36:11,
	Serialize complete at 2013/04/05 17:36:11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we are using struct numa_meminfo to store SRAT info, and sanitize
movablemem_map.map[], we need hotplug info in struct numa_meminfo.

This patch introduces a "bool hotpluggable" member into struct
numa_meminfo.

And modifies the following APIs' prototypes to support it:
   - numa_add_memblk()
   - numa_add_memblk_to()

And the following callers:
   - numaq_register_node()
   - dummy_numa_init()
   - amd_numa_init()
   - acpi_numa_memory_affinity_init() in x86

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/include/asm/numa.h     |    3 ++-
 arch/x86/kernel/apic/numaq_32.c |    2 +-
 arch/x86/mm/amdtopology.c       |    3 ++-
 arch/x86/mm/numa.c              |   10 +++++++---
 arch/x86/mm/numa_internal.h     |    1 +
 arch/x86/mm/srat.c              |    2 +-
 6 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 1b99ee5..73096b2 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -31,7 +31,8 @@ extern int numa_off;
 extern s16 __apicid_to_node[MAX_LOCAL_APIC];
 extern nodemask_t numa_nodes_parsed __initdata;
 
-extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
+extern int __init numa_add_memblk(int nodeid, u64 start, u64 end,
+				  bool hotpluggable);
 extern void __init numa_set_distance(int from, int to, int distance);
 
 static inline void set_apicid_to_node(int apicid, s16 node)
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index d661ee9..7a9c542 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -82,7 +82,7 @@ static inline void numaq_register_node(int node, struct sys_cfg_data *scd)
 	int ret;
 
 	node_set(node, numa_nodes_parsed);
-	ret = numa_add_memblk(node, start, end);
+	ret = numa_add_memblk(node, start, end, false);
 	BUG_ON(ret < 0);
 }
 
diff --git a/arch/x86/mm/amdtopology.c b/arch/x86/mm/amdtopology.c
index 5247d01..d521471 100644
--- a/arch/x86/mm/amdtopology.c
+++ b/arch/x86/mm/amdtopology.c
@@ -167,7 +167,8 @@ int __init amd_numa_init(void)
 			nodeid, base, limit);
 
 		prevbase = base;
-		numa_add_memblk(nodeid, base, limit);
+		/* Do not support memory hotplug for AMD cpu. */
+		numa_add_memblk(nodeid, base, limit, false);
 		node_set(nodeid, numa_nodes_parsed);
 	}
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 4f754e6..ecf37fd 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -134,6 +134,7 @@ void __init setup_node_to_cpumask_map(void)
 }
 
 static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
+				     bool hotpluggable,
 				     struct numa_meminfo *mi)
 {
 	/* ignore zero length blks */
@@ -155,6 +156,7 @@ static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
 	mi->blk[mi->nr_blks].start = start;
 	mi->blk[mi->nr_blks].end = end;
 	mi->blk[mi->nr_blks].nid = nid;
+	mi->blk[mi->nr_blks].hotpluggable = hotpluggable;
 	mi->nr_blks++;
 	return 0;
 }
@@ -179,15 +181,17 @@ void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi)
  * @nid: NUMA node ID of the new memblk
  * @start: Start address of the new memblk
  * @end: End address of the new memblk
+ * @hotpluggable: True if memblk is hotpluggable
  *
  * Add a new memblk to the default numa_meminfo.
  *
  * RETURNS:
  * 0 on success, -errno on failure.
  */
-int __init numa_add_memblk(int nid, u64 start, u64 end)
+int __init numa_add_memblk(int nid, u64 start, u64 end,
+			   bool hotpluggable)
 {
-	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
+	return numa_add_memblk_to(nid, start, end, hotpluggable, &numa_meminfo);
 }
 
 /* Initialize NODE_DATA for a node on the local memory */
@@ -631,7 +635,7 @@ static int __init dummy_numa_init(void)
 	       0LLU, PFN_PHYS(max_pfn) - 1);
 
 	node_set(0, numa_nodes_parsed);
-	numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
+	numa_add_memblk(0, 0, PFN_PHYS(max_pfn), false);
 
 	return 0;
 }
diff --git a/arch/x86/mm/numa_internal.h b/arch/x86/mm/numa_internal.h
index bb2fbcc..1ce4e6b 100644
--- a/arch/x86/mm/numa_internal.h
+++ b/arch/x86/mm/numa_internal.h
@@ -8,6 +8,7 @@ struct numa_memblk {
 	u64			start;
 	u64			end;
 	int			nid;
+	bool			hotpluggable;
 };
 
 struct numa_meminfo {
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 5055fa7..f7f6fd4 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -171,7 +171,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		goto out_err_bad_srat;
 	}
 
-	if (numa_add_memblk(node, start, end) < 0)
+	if (numa_add_memblk(node, start, end, hotpluggable) < 0)
 		goto out_err_bad_srat;
 
 	node_set(node, numa_nodes_parsed);
-- 
1.7.1

