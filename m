Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039Ab3BZX5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:57:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759833Ab3BZX5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [ 003/150] x86-32, mm: Remove reference to alloc_remap()
Date: Tue, 26 Feb 2013 15:54:20 -0800
Message-Id: <20130226235524.351159148@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 07f4207a305c834f528d08428df4531744e25678 upstream.

We have removed the remap allocator for x86-32, and x86-64 never had
it (and doesn't need it).  Remove residual reference to it.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/CAE9FiQVn6_QZi3fNQ-JHYiR-7jeDJ5hT0SyT_%2BzVvfOj=PzF3w@mail.gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/numa.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -193,7 +193,6 @@ int __init numa_add_memblk(int nid, u64
 static void __init setup_node_data(int nid, u64 start, u64 end)
 {
 	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
-	bool remapped = false;
 	u64 nd_pa;
 	void *nd;
 	int tnid;
@@ -211,28 +210,22 @@ static void __init setup_node_data(int n
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


