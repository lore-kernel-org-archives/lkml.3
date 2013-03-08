Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab3CHFCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:02:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51019 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760181Ab3CHE7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:59:47 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/14] x86, mm, numa: Move successful path handling code later
Date: Thu,  7 Mar 2013 20:58:32 -0800
Message-Id: <1362718720-27048-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could move setup_node_data() and numa_init_array() calling out
numa_init() to make numa_init() small.

Those functions only need to be called for success path, and only
call them one time in x86_numa_init().

So later we could split parse numa info to two stages.
early one will be before init_mem_mapping.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
---
 arch/x86/mm/numa.c |   68 ++++++++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 72fe01e..24c20f0 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -480,7 +480,7 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
 	unsigned long uninitialized_var(pfn_align);
-	int i, nid;
+	int i;
 
 	/* Account for nodes with cpus and no memory */
 	node_possible_map = numa_nodes_parsed;
@@ -509,24 +509,6 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	if (!numa_meminfo_cover_memory(mi))
 		return -EINVAL;
 
-	/* Finally register nodes. */
-	for_each_node_mask(nid, node_possible_map) {
-		u64 start = PFN_PHYS(max_pfn);
-		u64 end = 0;
-
-		for (i = 0; i < mi->nr_blks; i++) {
-			if (nid != mi->blk[i].nid)
-				continue;
-			start = min(mi->blk[i].start, start);
-			end = max(mi->blk[i].end, end);
-		}
-
-		if (start < end)
-			setup_node_data(nid, start, end);
-	}
-
-	/* Dump memblock with node info and return. */
-	memblock_dump_all();
 	return 0;
 }
 
@@ -580,15 +562,6 @@ static int __init numa_init(int (*init_func)(void))
 	if (ret < 0)
 		return ret;
 
-	for (i = 0; i < nr_cpu_ids; i++) {
-		int nid = early_cpu_to_node(i);
-
-		if (nid == NUMA_NO_NODE)
-			continue;
-		if (!node_online(nid))
-			numa_clear_node(i);
-	}
-	numa_init_array();
 	return 0;
 }
 
@@ -623,22 +596,55 @@ static int __init dummy_numa_init(void)
  */
 void __init x86_numa_init(void)
 {
+	int i, nid;
+	struct numa_meminfo *mi = &numa_meminfo;
+
 	if (!numa_off) {
 #ifdef CONFIG_X86_NUMAQ
 		if (!numa_init(numaq_numa_init))
-			return;
+			goto out;
 #endif
 #ifdef CONFIG_ACPI_NUMA
 		if (!numa_init(x86_acpi_numa_init))
-			return;
+			goto out;
 #endif
 #ifdef CONFIG_AMD_NUMA
 		if (!numa_init(amd_numa_init))
-			return;
+			goto out;
 #endif
 	}
 
 	numa_init(dummy_numa_init);
+
+out:
+	/* Finally register nodes. */
+	for_each_node_mask(nid, node_possible_map) {
+		u64 start = PFN_PHYS(max_pfn);
+		u64 end = 0;
+
+		for (i = 0; i < mi->nr_blks; i++) {
+			if (nid != mi->blk[i].nid)
+				continue;
+			start = min(mi->blk[i].start, start);
+			end = max(mi->blk[i].end, end);
+		}
+
+		if (start < end)
+			setup_node_data(nid, start, end);
+	}
+
+	/* Dump memblock with node info */
+	memblock_dump_all();
+
+	for (i = 0; i < nr_cpu_ids; i++) {
+		int nid = early_cpu_to_node(i);
+
+		if (nid == NUMA_NO_NODE)
+			continue;
+		if (!node_online(nid))
+			numa_clear_node(i);
+	}
+	numa_init_array();
 }
 
 static __init int find_near_online_node(int node)
-- 
1.7.10.4

