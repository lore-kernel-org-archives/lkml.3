Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab3FNVeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:34:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34554 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3FNVeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:34:16 -0400
Date: Fri, 14 Jun 2013 14:34:00 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-5f02a5e6ca366be44064463f25b6f4cc4468a197@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, yinghai@kernel.org, penberg@kernel.org,
        tangchen@cn.fujitsu.com, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, konrad.wilk@oracle.com, penberg@kernel.org,
        tangchen@cn.fujitsu.com, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1371128589-8953-23-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-23-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm, numa:
  Put pagetable on local node ram for 64bit
Git-Commit-ID: 5f02a5e6ca366be44064463f25b6f4cc4468a197
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:34:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f02a5e6ca366be44064463f25b6f4cc4468a197
Gitweb:     http://git.kernel.org/tip/5f02a5e6ca366be44064463f25b6f4cc4468a197
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:03:09 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:05:49 -0700

x86, mm, numa: Put pagetable on local node ram for 64bit

If node with ram is hotplugable, memory for local node page
table and vmemmap should be on the local node ram.

This patch is some kind of refreshment of
| commit 1411e0ec3123ae4c4ead6bfc9fe3ee5a3ae5c327
| Date:   Mon Dec 27 16:48:17 2010 -0800
|
|    x86-64, numa: Put pgtable to local node memory
That was reverted before.

We have reason to reintroduce it to improve performance when
using memory hotplug.

Calling init_mem_mapping() in early_initmem_init() for each
node. alloc_low_pages() will allocate page table in following
order:
	BRK, local node, low range

So page table will be on low range or local nodes.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-23-git-send-email-tangchen@cn.fujitsu.com
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 9b18ee8..5adf803 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -670,7 +670,39 @@ static void __init early_x86_numa_init(void)
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
