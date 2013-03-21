Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab3CUJSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:18:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45098 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758052Ab3CUJSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:18:44 -0400
X-IronPort-AV: E=Sophos;i="4.84,884,1355068800"; 
   d="scan'208";a="6917176"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org, wency@cn.fujitsu.com,
        trenn@suse.de, liwanp@linux.vnet.ibm.com, mgorman@suse.de,
        walken@google.com, riel@redhat.com, khlebnikov@openvz.org,
        tj@kernel.org, minchan@kernel.org, m.szyprowski@samsung.com,
        mina86@mina86.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linfeng@cn.fujitsu.com,
        jiang.liu@huawei.com, kosaki.motohiro@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH part2 1/4] x86, mm, numa, acpi: Introduce numa_meminfo_all to store all the numa meminfo.
Date: Thu, 21 Mar 2013 17:21:13 +0800
Message-Id: <1363857676-30694-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1363857676-30694-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1363857676-30694-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/21 17:17:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/21 17:17:11,
	Serialize complete at 2013/03/21 17:17:11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, Yinghai has tried to allocate pagetables and vmemmap pages in local
node. If we limit memblock allocation in movablemem_map.map[], we have to
exclude the pagetables and vmemmap pages.

So we need the following sequence:
1) Parse SRAT, store numa_meminfo.
2) Initialize memory mapping, allocate pagetables and vmemmap pages in local
   node. And reserve these memory with memblock.
3) Sanitize movablemem_map.map[], exclude the pagetables and vmemmap pages.

When parsing SRAT, we added memory ranges into numa_meminfo. But in
numa_cleanup_meminfo(), it removed all the unused memory from numa_meminfo.

         const u64 low = 0;
         const u64 high = PFN_PHYS(max_pfn);

         /* first, trim all entries */
         for (i = 0; i < mi->nr_blks; i++) {
                 struct numa_memblk *bi = &mi->blk[i];

                 /* make sure all blocks are inside the limits */
                 bi->start = max(bi->start, low);
                 bi->end = min(bi->end, high);

                 /* and there's no empty block */
                 if (bi->start >= bi->end)
                         numa_remove_memblk_from(i--, mi);
         }

So numa_meminfo doesn't have the whole memory info.

In order to sanitize movablemem_map.map[] after memory mapping initialziation,
we need the whole SRAT info.

So this patch introduces global variable numa_meminfo_all to store the whole
numa memory info.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 4f754e6..4cf3b49 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -28,12 +28,20 @@ nodemask_t numa_nodes_parsed __initdata;
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
+/*e820 mapped memory info */
 static struct numa_meminfo numa_meminfo
 #ifndef CONFIG_MEMORY_HOTPLUG
 __initdata
 #endif
 ;
 
+/* All memory info */
+static struct numa_meminfo numa_meminfo_all
+#ifndef CONFIG_MEMORY_HOTPLUG
+__initdata
+#endif
+;
+
 static int numa_distance_cnt;
 static u8 *numa_distance;
 
@@ -599,10 +607,15 @@ static int __init numa_init(int (*init_func)(void))
 
 	nodes_clear(numa_nodes_parsed);
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
+	memset(&numa_meminfo_all, 0, sizeof(numa_meminfo));
 
 	ret = init_func();
 	if (ret < 0)
 		return ret;
+
+	/* Store the whole memory info before cleanup numa_meminfo. */
+	memcpy(&numa_meminfo_all, &numa_meminfo, sizeof(numa_meminfo));
+
 	ret = numa_cleanup_meminfo(&numa_meminfo);
 	if (ret < 0)
 		return ret;
-- 
1.7.1

