Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab3FMNcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:32:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54674 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758213Ab3FMN2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:28:10 -0400
X-IronPort-AV: E=Sophos;i="4.87,858,1363104000"; 
   d="scan'208";a="7537703"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [Part1 PATCH v5 22/22] x86, mm, numa: Put pagetable on local node ram for 64bit
Date: Thu, 13 Jun 2013 21:03:09 +0800
Message-Id: <1371128589-8953-23-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:32,
	Serialize complete at 2013/06/13 20:58:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

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
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

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
-- 
1.7.1

