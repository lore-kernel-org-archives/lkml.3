Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765558Ab3DDXs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:48:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43438 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765498Ab3DDXsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:48:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v3 22/22] x86, mm, numa: Put pagetable on local node ram for 64bit
Date: Thu,  4 Apr 2013 16:46:26 -0700
Message-Id: <1365119186-23487-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If node with ram is hotplugable, local node mem for page table and vmemmap
should be on that node ram.

This patch is some kind of refreshment of
| commit 1411e0ec3123ae4c4ead6bfc9fe3ee5a3ae5c327
| Date:   Mon Dec 27 16:48:17 2010 -0800
|
|    x86-64, numa: Put pgtable to local node memory
That was reverted before.

We have reason to reintroduce it to make memory hotplug work.

Calling init_mem_mapping in early_initmem_init for every node.
alloc_low_pages will alloc page table in following order:
	BRK, local node, low range
So page table will be on low range or local nodes.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/numa.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index d3eb0c9..11acdf6 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -673,7 +673,39 @@ static void __init early_x86_numa_init(void)
 #ifdef CONFIG_X86_64
 static void __init early_x86_numa_init_mapping(void)
 {
-	init_mem_mapping(0, max_pfn << PAGE_SHIFT);
+	unsigned long last_start = 0, last_end = 0;
+	struct numa_meminfo *mi = &numa_meminfo;
+	unsigned long start, end;
+	int last_nid = -1;
+	int i, nid;
+
+	for (i = 0; i < mi->nr_blks; i++) {
+		nid   = mi->blk[i].nid;
+		start = mi->blk[i].start;
+		end   = mi->blk[i].end;
+
+		if (last_nid == nid) {
+			last_end = end;
+			continue;
+		}
+
+		/* other nid now */
+		if (last_nid >= 0) {
+			printk(KERN_DEBUG "Node %d: [mem %#016lx-%#016lx]\n",
+					last_nid, last_start, last_end - 1);
+			init_mem_mapping(last_start, last_end);
+		}
+
+		/* for next nid */
+		last_nid   = nid;
+		last_start = start;
+		last_end   = end;
+	}
+	/* last one */
+	printk(KERN_DEBUG "Node %d: [mem %#016lx-%#016lx]\n",
+			last_nid, last_start, last_end - 1);
+	init_mem_mapping(last_start, last_end);
+
 	if (max_pfn > max_low_pfn)
 		max_low_pfn = max_pfn;
 }
-- 
1.8.1.4

