Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765659Ab3DDXxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:53:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32194 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764880Ab3DDXrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:47:55 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 14/22] x86, mm, numa: Set memblock nid later
Date: Thu,  4 Apr 2013 16:46:18 -0700
Message-Id: <1365119186-23487-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the separation, we need to set memblock nid later, as it
could change memblock array, and possible doube memblock.memory
array that will need to allocate buffer.

Only set memblock nid one time for successful path.

Also rename numa_register_memblks to numa_check_memblks()
after move out code for setting memblock nid.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/numa.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index fcaeba9..e2ddcbd 100644
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
 
@@ -604,7 +598,6 @@ static int __init numa_init(int (*init_func)(void))
 	nodes_clear(numa_nodes_parsed);
 	nodes_clear(node_possible_map);
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
-	WARN_ON(memblock_set_node(0, ULLONG_MAX, MAX_NUMNODES));
 	numa_reset_distance();
 
 	ret = init_func();
@@ -616,7 +609,7 @@ static int __init numa_init(int (*init_func)(void))
 
 	numa_emulation(&numa_meminfo, numa_distance_cnt);
 
-	ret = numa_register_memblks(&numa_meminfo);
+	ret = numa_check_memblks(&numa_meminfo);
 	if (ret < 0)
 		return ret;
 
@@ -679,6 +672,11 @@ void __init x86_numa_init(void)
 
 	early_x86_numa_init();
 
+	for (i = 0; i < mi->nr_blks; i++) {
+		struct numa_memblk *mb = &mi->blk[i];
+		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
+	}
+
 	/* Finally register nodes. */
 	for_each_node_mask(nid, node_possible_map) {
 		u64 start = PFN_PHYS(max_pfn);
-- 
1.8.1.4

