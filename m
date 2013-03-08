Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375Ab3CHE7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:59:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43471 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab3CHE7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:59:46 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/14] x86, mm, numa: set memblock nid later
Date: Thu,  7 Mar 2013 20:58:35 -0800
Message-Id: <1362718720-27048-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only set memblock nid one time.

Also rename numa_register_memblks to numa_check_memblks()
after move set memblock nid out.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
---
 arch/x86/mm/numa.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index b8cc248..e875c2b 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -537,10 +537,9 @@ static unsigned long __init node_map_pfn_alignment(struct numa_meminfo *mi)
 }
 #endif
 
-static int __init numa_register_memblks(struct numa_meminfo *mi)
+static int __init numa_check_memblks(struct numa_meminfo *mi)
 {
 	unsigned long pfn_align;
-	int i;
 
 	/* Account for nodes with cpus and no memory */
 	node_possible_map = numa_nodes_parsed;
@@ -563,11 +562,6 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 		return -EINVAL;
 	}
 
-	for (i = 0; i < mi->nr_blks; i++) {
-		struct numa_memblk *mb = &mi->blk[i];
-		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
-	}
-
 	return 0;
 }
 
@@ -605,7 +599,6 @@ static int __init numa_init(int (*init_func)(void))
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
-	WARN_ON(memblock_set_node(0, ULLONG_MAX, MAX_NUMNODES));
 	numa_reset_distance();
 
 	ret = init_func();
@@ -617,7 +610,7 @@ static int __init numa_init(int (*init_func)(void))
 
 	numa_emulation(&numa_meminfo, numa_distance_cnt);
 
-	ret = numa_register_memblks(&numa_meminfo);
+	ret = numa_check_memblks(&numa_meminfo);
 	if (ret < 0)
 		return ret;
 
@@ -676,6 +669,11 @@ void __init x86_numa_init(void)
 	numa_init(dummy_numa_init);
 
 out:
+	for (i = 0; i < mi->nr_blks; i++) {
+		struct numa_memblk *mb = &mi->blk[i];
+		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
+	}
+
 	/* Finally register nodes. */
 	for_each_node_mask(nid, node_possible_map) {
 		u64 start = PFN_PHYS(max_pfn);
-- 
1.7.10.4

