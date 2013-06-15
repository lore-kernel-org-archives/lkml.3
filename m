Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3FOBAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 21:00:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17645 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3FOA5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 20:57:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 15/22] x86, mm, numa: Move node_possible_map setting later
Date: Fri, 14 Jun 2013 17:56:33 -0700
Message-Id: <1371257800-11720-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371257800-11720-1-git-send-email-yinghai@kernel.org>
References: <1371257800-11720-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move node_possible_map handling out of numa_check_memblks to avoid side
changing in numa_check_memblks().

Only set once for successful path instead of resetting in numa_init()
every time.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/numa.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index e448b6f..da2ebab 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -536,12 +536,13 @@ static unsigned long __init node_map_pfn_alignment(struct numa_meminfo *mi)
 
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
@@ -593,7 +594,6 @@ static int __init numa_init(int (*init_func)(void))
 		set_apicid_to_node(i, NUMA_NO_NODE);
 
 	nodes_clear(numa_nodes_parsed);
-	nodes_clear(node_possible_map);
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 	numa_reset_distance();
 
@@ -669,6 +669,9 @@ void __init x86_numa_init(void)
 
 	early_x86_numa_init();
 
+	node_possible_map = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&node_possible_map, mi);
+
 	for (i = 0; i < mi->nr_blks; i++) {
 		struct numa_memblk *mb = &mi->blk[i];
 		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
-- 
1.8.1.4

