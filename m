Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab3CUJVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:21:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56413 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757700Ab3CUJSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:18:24 -0400
X-IronPort-AV: E=Sophos;i="4.84,884,1355068800"; 
   d="scan'208";a="6917165"
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
Subject: [RESEND PATCH part1 9/9] x86, mm, numa, acpi: Memblock limit with movablemem_map
Date: Thu, 21 Mar 2013 17:20:55 +0800
Message-Id: <1363857655-30658-10-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1363857655-30658-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1363857655-30658-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/21 17:16:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/21 17:16:52,
	Serialize complete at 2013/03/21 17:16:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure memblock will not allocate memory from areas that may be
ZONE_MOVABLE. The map info is from movablemem_map boot option.

The following problem was reported by Stephen Rothwell:
The definition of struct movablecore_map is protected by
CONFIG_HAVE_MEMBLOCK_NODE_MAP but its use in memblock_overlaps_region()
is not. So add CONFIG_HAVE_MEMBLOCK_NODE_MAP to protect the use of
movablecore_map in memblock_overlaps_region().

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/memblock.h |    2 +
 mm/memblock.c            |   50 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index f388203..3e5ecb2 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -42,6 +42,7 @@ struct memblock {
 
 extern struct memblock memblock;
 extern int memblock_debug;
+extern struct movablemem_map movablemem_map;
 
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
@@ -60,6 +61,7 @@ int memblock_reserve(phys_addr_t base, phys_addr_t size);
 void memblock_trim_memory(phys_addr_t align);
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
 			  unsigned long *out_end_pfn, int *out_nid);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index b8d9147..1bcd9b9 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -92,9 +92,58 @@ static long __init_memblock memblock_overlaps_region(struct memblock_type *type,
  *
  * Find @size free area aligned to @align in the specified range and node.
  *
+ * If we have CONFIG_HAVE_MEMBLOCK_NODE_MAP defined, we need to check if the
+ * memory we found if not in hotpluggable ranges.
+ *
  * RETURNS:
  * Found address on success, %0 on failure.
  */
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
+					phys_addr_t end, phys_addr_t size,
+					phys_addr_t align, int nid)
+{
+	phys_addr_t this_start, this_end, cand;
+	u64 i;
+	int curr = movablemem_map.nr_map - 1;
+
+	/* pump up @end */
+	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
+		end = memblock.current_limit;
+
+	/* avoid allocating the first page */
+	start = max_t(phys_addr_t, start, PAGE_SIZE);
+	end = max(start, end);
+
+	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
+		this_start = clamp(this_start, start, end);
+		this_end = clamp(this_end, start, end);
+
+restart:
+		if (this_end <= this_start || this_end < size)
+			continue;
+
+		for (; curr >= 0; curr--) {
+			if ((movablemem_map.map[curr].start_pfn << PAGE_SHIFT)
+			    < this_end)
+				break;
+		}
+
+		cand = round_down(this_end - size, align);
+		if (curr >= 0 &&
+		    cand < movablemem_map.map[curr].end_pfn << PAGE_SHIFT) {
+			this_end = movablemem_map.map[curr].start_pfn
+				   << PAGE_SHIFT;
+			goto restart;
+		}
+
+		if (cand >= this_start)
+			return cand;
+	}
+
+	return 0;
+}
+#else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 					phys_addr_t end, phys_addr_t size,
 					phys_addr_t align, int nid)
@@ -123,6 +172,7 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 	}
 	return 0;
 }
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 /**
  * memblock_find_in_range - find free area in given range
-- 
1.7.1

