Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab3AaWlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:41:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45088 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab3AaWlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:41:52 -0500
Date: Thu, 31 Jan 2013 14:41:39 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-07f4207a305c834f528d08428df4531744e25678@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, dave@linux.vnet.ibm.com, stable@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, dave@linux.vnet.ibm.com, tglx@linutronix.de,
        stable@vger.kernel.org, hpa@linux.intel.com
In-Reply-To: <CAE9FiQVn6_QZi3fNQ-JHYiR-7jeDJ5hT0SyT_+zVvfOj=PzF3w@mail.gmail.com>
References: <CAE9FiQVn6_QZi3fNQ-JHYiR-7jeDJ5hT0SyT_+zVvfOj=PzF3w@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-32, mm: Remove reference to alloc_remap()
Git-Commit-ID: 07f4207a305c834f528d08428df4531744e25678
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 14:41:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07f4207a305c834f528d08428df4531744e25678
Gitweb:     http://git.kernel.org/tip/07f4207a305c834f528d08428df4531744e25678
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 31 Jan 2013 14:00:48 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jan 2013 14:12:30 -0800

x86-32, mm: Remove reference to alloc_remap()

We have removed the remap allocator for x86-32, and x86-64 never had
it (and doesn't need it).  Remove residual reference to it.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/CAE9FiQVn6_QZi3fNQ-JHYiR-7jeDJ5hT0SyT_%2BzVvfOj=PzF3w@mail.gmail.com
---
 arch/x86/mm/numa.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 61c2b6f..8504f36 100644
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
-		nd_pa = __pa_nodebug(nd);
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
