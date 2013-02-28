Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616Ab3B1PUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:20:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41949 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab3B1Oqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 022/139] x86-32, mm: Remove reference to alloc_remap()
Date: Thu, 28 Feb 2013 14:42:52 +0000
Message-Id: <1362062689-2567-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 07f4207a305c834f528d08428df4531744e25678 upstream.

We have removed the remap allocator for x86-32, and x86-64 never had
it (and doesn't need it).  Remove residual reference to it.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/CAE9FiQVn6_QZi3fNQ-JHYiR-7jeDJ5hT0SyT_%2BzVvfOj=PzF3w@mail.gmail.com
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/mm/numa.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 02b7678..8504f36 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -193,7 +193,6 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
 static void __init setup_node_data(int nid, u64 start, u64 end)
 {
 	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
-	bool remapped = false;
 	u64 nd_pa;
 	void *nd;
 	int tnid;
@@ -211,28 +210,22 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	       nid, start, end - 1);
 
 	/*
-	 * Allocate node data.  Try remap allocator first, node-local
-	 * memory and then any node.  Never allocate in DMA zone.
+	 * Allocate node data.  Try node-local memory and then any node.
+	 * Never allocate in DMA zone.
 	 */
-	nd = alloc_remap(nid, nd_size);
-	if (nd) {
-		nd_pa = __pa(nd);
-		remapped = true;
-	} else {
-		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
-		if (!nd_pa) {
-			pr_err("Cannot find %zu bytes in node %d\n",
-			       nd_size, nid);
-			return;
-		}
-		nd = __va(nd_pa);
+	nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
+	if (!nd_pa) {
+		pr_err("Cannot find %zu bytes in node %d\n",
+		       nd_size, nid);
+		return;
 	}
+	nd = __va(nd_pa);
 
 	/* report and initialize */
-	printk(KERN_INFO "  NODE_DATA [mem %#010Lx-%#010Lx]%s\n",
-	       nd_pa, nd_pa + nd_size - 1, remapped ? " (remapped)" : "");
+	printk(KERN_INFO "  NODE_DATA [mem %#010Lx-%#010Lx]\n",
+	       nd_pa, nd_pa + nd_size - 1);
 	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
-	if (!remapped && tnid != nid)
+	if (tnid != nid)
 		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nid, tnid);
 
 	node_data[nid] = nd;
-- 
1.8.1.2

