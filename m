Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab3CJGqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:46:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48157 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3CJGqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:46:52 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 09/20] x86, mm, numa: Move two functions calling on successful path later
Date: Sat,  9 Mar 2013 22:44:36 -0800
Message-Id: <1362897887-30808-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to have numa info ready before init_mem_mapping, so we
can call init_mem_mapping per nodes also can trim node mem range to
big alignment.

Current numa parsing need to allocate some buffer and need to be
called after init_mem_mapping.

So try to split parsing numa info to two stages, and early one will be
before init_mem_mapping, and it should not need allocate buffers.

At last we will have early_initmem_init() and initmem_init().

This one is first one for separation.

setup_node_data() and numa_init_array() are only called for successful
path, so we can move calling to x86_numa_init(). That will also make
numa_init() small and readable.

-v2: remove online_node_map clear in numa_init(), as it is only
     set in setup_node_data() at last in successful path.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/numa.c |   69 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 30 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 72fe01e..d545638 100644
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
 
@@ -562,7 +544,6 @@ static int __init numa_init(int (*init_func)(void))
 
 	nodes_clear(numa_nodes_parsed);
 	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 	WARN_ON(memblock_set_node(0, ULLONG_MAX, MAX_NUMNODES));
 	numa_reset_distance();
@@ -580,15 +561,6 @@ static int __init numa_init(int (*init_func)(void))
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
 
@@ -621,7 +593,7 @@ static int __init dummy_numa_init(void)
  * last fallback is dummy single node config encomapssing whole memory and
  * never fails.
  */
-void __init x86_numa_init(void)
+static void __init early_x86_numa_init(void)
 {
 	if (!numa_off) {
 #ifdef CONFIG_X86_NUMAQ
@@ -641,6 +613,43 @@ void __init x86_numa_init(void)
 	numa_init(dummy_numa_init);
 }
 
+void __init x86_numa_init(void)
+{
+	int i, nid;
+	struct numa_meminfo *mi = &numa_meminfo;
+
+	early_x86_numa_init();
+
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
+			setup_node_data(nid, start, end); /* online is set */
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
+}
+
 static __init int find_near_online_node(int node)
 {
 	int n, val;
-- 
1.7.10.4

