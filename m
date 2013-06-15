Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3FOA5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 20:57:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47595 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3FOA5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 20:57:03 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 13/22] x86, mm, numa: Use numa_meminfo to check node_map_pfn alignment
Date: Fri, 14 Jun 2013 17:56:31 -0700
Message-Id: <1371257800-11720-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371257800-11720-1-git-send-email-yinghai@kernel.org>
References: <1371257800-11720-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could use numa_meminfo directly instead of memblock nid.

So we could move down set memblock nid and only do it one time
for successful path.

-v2: according to tj, separate moving to another patch.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/numa.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 10c6240..cff565a 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -493,14 +493,18 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
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
@@ -523,10 +527,16 @@ unsigned long __init node_map_pfn_alignment(void)
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
@@ -538,24 +548,22 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
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

