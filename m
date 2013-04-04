Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765574Ab3DDXt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:49:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32246 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765457Ab3DDXsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:48:03 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 13/22] x86, mm, numa: Use numa_meminfo to check node_map_pfn alignment
Date: Thu,  4 Apr 2013 16:46:17 -0700
Message-Id: <1365119186-23487-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could use numa_meminfo directly instead of memblock nid.

So we could move down set memblock nid and only do it one time
for successful path.

-v2: according to tj, separate moving to another patch.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/numa.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 24155b2..fcaeba9 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -496,14 +496,18 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
  * Returns the determined alignment in pfn's.  0 if there is no alignment
  * requirement (single node).
  */
-unsigned long __init node_map_pfn_alignment(void)
+#ifdef NODE_NOT_IN_PAGE_FLAGS
+static unsigned long __init node_map_pfn_alignment(struct numa_meminfo *mi)
 {
 	unsigned long accl_mask = 0, last_end = 0;
 	unsigned long start, end, mask;
 	int last_nid = -1;
 	int i, nid;
 
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid) {
+	for (i = 0; i < mi->nr_blks; i++) {
+		start = mi->blk[i].start >> PAGE_SHIFT;
+		end = mi->blk[i].end >> PAGE_SHIFT;
+		nid = mi->blk[i].nid;
 		if (!start || last_nid < 0 || last_nid == nid) {
 			last_nid = nid;
 			last_end = end;
@@ -526,10 +530,16 @@ unsigned long __init node_map_pfn_alignment(void)
 	/* convert mask to number of pages */
 	return ~accl_mask + 1;
 }
+#else
+static unsigned long __init node_map_pfn_alignment(struct numa_meminfo *mi)
+{
+	return 0;
+}
+#endif
 
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
-	unsigned long uninitialized_var(pfn_align);
+	unsigned long pfn_align;
 	int i;
 
 	/* Account for nodes with cpus and no memory */
@@ -541,24 +551,22 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	if (!numa_meminfo_cover_memory(mi))
 		return -EINVAL;
 
-	for (i = 0; i < mi->nr_blks; i++) {
-		struct numa_memblk *mb = &mi->blk[i];
-		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
-	}
-
 	/*
 	 * If sections array is gonna be used for pfn -> nid mapping, check
 	 * whether its granularity is fine enough.
 	 */
-#ifdef NODE_NOT_IN_PAGE_FLAGS
-	pfn_align = node_map_pfn_alignment();
+	pfn_align = node_map_pfn_alignment(mi);
 	if (pfn_align && pfn_align < PAGES_PER_SECTION) {
 		printk(KERN_WARNING "Node alignment %LuMB < min %LuMB, rejecting NUMA config\n",
 		       PFN_PHYS(pfn_align) >> 20,
 		       PFN_PHYS(PAGES_PER_SECTION) >> 20);
 		return -EINVAL;
 	}
-#endif
+
+	for (i = 0; i < mi->nr_blks; i++) {
+		struct numa_memblk *mb = &mi->blk[i];
+		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
+	}
 
 	return 0;
 }
-- 
1.8.1.4

