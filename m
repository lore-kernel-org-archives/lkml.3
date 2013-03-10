Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3CJGrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 01:47:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19138 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3CJGrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 01:47:32 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 14/20] x86, mm, numa: Move node_possible_map setting later
Date: Sat,  9 Mar 2013 22:44:41 -0800
Message-Id: <1362897887-30808-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move node_possible_map handling out of numa_check_memblks to avoid side
changing in numa_check_memblks().

Only set once for successful path instead of resetting in numa_init()
every time.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/numa.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index e2ddcbd..1d5fa08 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -539,12 +539,13 @@ static unsigned long __init node_map_pfn_alignment(struct numa_meminfo *mi)
 
 static int __init numa_check_memblks(struct numa_meminfo *mi)
 {
+	nodemask_t nodes_parsed;
 	unsigned long pfn_align;
 
 	/* Account for nodes with cpus and no memory */
-	node_possible_map = numa_nodes_parsed;
-	numa_nodemask_from_meminfo(&node_possible_map, mi);
-	if (WARN_ON(nodes_empty(node_possible_map)))
+	nodes_parsed = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&nodes_parsed, mi);
+	if (WARN_ON(nodes_empty(nodes_parsed)))
 		return -EINVAL;
 
 	if (!numa_meminfo_cover_memory(mi))
@@ -596,7 +597,6 @@ static int __init numa_init(int (*init_func)(void))
 		set_apicid_to_node(i, NUMA_NO_NODE);
 
 	nodes_clear(numa_nodes_parsed);
-	nodes_clear(node_possible_map);
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 	numa_reset_distance();
 
@@ -672,6 +672,9 @@ void __init x86_numa_init(void)
 
 	early_x86_numa_init();
 
+	node_possible_map = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&node_possible_map, mi);
+
 	for (i = 0; i < mi->nr_blks; i++) {
 		struct numa_memblk *mb = &mi->blk[i];
 		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
-- 
1.7.10.4

