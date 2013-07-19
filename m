Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750899Ab3GSIGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:06:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759847Ab3GSIBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:01:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947441"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH 18/21] x86, numa: Synchronize nid info in memblock.reserve with numa_meminfo.
Date: Fri, 19 Jul 2013 15:59:31 +0800
Message-Id: <1374220774-29974-19-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:48,
	Serialize complete at 2013/07/19 15:58:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasilis Liaskovitis found that before we parse SRAT and fulfill numa_meminfo,
the nids of all the regions in memblock.reserve[] are MAX_NUMNODES. That is
because nids have not been mapped at that time.

When we arrange ZONE_MOVABLE in each node later, we need nid in memblock. So
after we parse SRAT and fulfill nume_meminfo, synchronize the nid info to
memblock.reserve[] immediately.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
---
 arch/x86/mm/numa.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 5013583..f2a3984 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -548,6 +548,48 @@ static void __init numa_init_array(void)
 	}
 }
 
+/*
+ * early_numa_find_range_nid - Find nid for a memory range at early time.
+ * @start: start address of the memory range (physaddr)
+ * @size: size of the memory range
+ *
+ * Return nid of the memory range, or MAX_NUMNODES if it failed to find the nid.
+ *
+ * NOTE: This function uses numa_meminfo to find the range's nid, so it should
+ *       be called after numa_meminfo has been initialized.
+ */
+int __init early_numa_find_range_nid(u64 start, u64 size)
+{
+	int i;
+	struct numa_meminfo *mi = &numa_meminfo;
+
+	for (i = 0; i < mi->nr_blks; i++)
+		if (start >= mi->blk[i].start &&
+		    (start + size - 1) <= mi->blk[i].end)
+			return mi->blk[i].nid;
+
+	return MAX_NUMNODES;
+}
+
+/*
+ * numa_sync_memblock_nid - Synchronize nid info in memblock.reserve[] to
+ *                          numa_meminfo.
+ *
+ * This function will synchronize the nid fields of regions in
+ * memblock.reserve[] to numa_meminfo.
+ */
+static void __init numa_sync_memblock_nid()
+{
+	int i, nid;
+	struct memblock_type *res = &memblock.reserved;
+
+	for (i = 0; i < res->cnt; i++) {
+		nid = early_numa_find_range_nid(res->regions[i].base,
+						res->regions[i].size);
+		memblock_set_region_node(&res->regions[i], nid);
+	}
+}
+
 static int __init numa_init(int (*init_func)(void))
 {
 	int i;
@@ -585,6 +627,14 @@ static int __init numa_init(int (*init_func)(void))
 			numa_clear_node(i);
 	}
 	numa_init_array();
+
+	/*
+	 * Before fulfilling numa_meminfo, all regions allocated by memblock
+	 * are reserved with nid MAX_NUMNODES because there is no numa node
+	 * info at such an early time. Now, fill the correct nid into memblock.
+	 */
+	numa_sync_memblock_nid();
+
 	return 0;
 }
 
-- 
1.7.1

