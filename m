Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3FNVcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:32:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3FNVcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:32:53 -0400
Date: Fri, 14 Jun 2013 14:32:41 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-052b6965a153de6c46203c574c5ad3161e829898@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1371128589-8953-14-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-14-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm, numa:
  Use numa_meminfo to check node_map_pfn alignment
Git-Commit-ID: 052b6965a153de6c46203c574c5ad3161e829898
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:32:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  052b6965a153de6c46203c574c5ad3161e829898
Gitweb:     http://git.kernel.org/tip/052b6965a153de6c46203c574c5ad3161e829898
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:03:00 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:05:00 -0700

x86, mm, numa: Use numa_meminfo to check node_map_pfn alignment

We could use numa_meminfo directly instead of memblock nid in
node_map_pfn_alignment().

So we could do setting memblock nid later and only do it once
for successful path.

-v2: according to tj, separate moving to another patch.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-14-git-send-email-tangchen@cn.fujitsu.com
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
