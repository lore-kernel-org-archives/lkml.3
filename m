Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3JAJ4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:56:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:37565 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752995Ab3JAJ4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:56:12 -0400
X-IronPort-AV: E=Sophos;i="4.90,1013,1371052800"; 
   d="scan'208";a="8662845"
Message-ID: <524A9C03.1090006@cn.fujitsu.com>
Date: Tue, 01 Oct 2013 17:55:15 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: robert.moore@intel.com, lv.zheng@intel.com,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        "mina86@mina86.com" <mina86@mina86.com>, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, Rik van Riel <riel@redhat.com>,
        prarit@redhat.com, Toshi Kani <toshi.kani@hp.com>
CC: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>, imtangchen@gmail.com,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: [PATCH -mm 7/8] memblock, mem_hotplug: Make memblock skip hotpluggable
 regions by default
References: <524A991D.3050005@cn.fujitsu.com>
In-Reply-To: <524A991D.3050005@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/01 17:54:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/01 17:54:17,
	Serialize complete at 2013/10/01 17:54:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Chen <tangchen@cn.fujitsu.com>

Linux kernel cannot migrate pages used by the kernel. As a result, hotpluggable
memory used by the kernel won't be able to be hot-removed. To solve this
problem, the basic idea is to prevent memblock from allocating hotpluggable
memory for the kernel at early time, and arrange all hotpluggable memory in
ACPI SRAT(System Resource Affinity Table) as ZONE_MOVABLE when initializing
zones.

In the previous patches, we have marked hotpluggable memory regions with
MEMBLOCK_HOTPLUG flag in memblock.memory.

In this patch, we make memblock skip these hotpluggable memory regions in
the default allocate function.

memblock_find_in_range_node()
  |-->for_each_free_mem_range_reverse()
        |-->__next_free_mem_range_rev()

The above is the only place where __next_free_mem_range_rev() is used. So
skip hotpluggable memory regions when iterating memblock.memory to find
free memory.

In the later patches, a boot option named "movablenode" will be introduced
to enable/disable using SRAT to arrange ZONE_MOVABLE.

NOTE: This check will always be done. It is OK because if users didn't specify
      movablenode option, the hotpluggable memory won't be marked. So this
      check won't skip any memory, which means the kernel will act as before.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 mm/memblock.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index d8a9420..9bdebfb 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -819,6 +819,10 @@ void __init_memblock __next_free_mem_range(u64 *idx, int nid,
  * @out_nid: ptr to int for nid of the range, can be %NULL
  *
  * Reverse of __next_free_mem_range().
+ *
+ * Linux kernel cannot migrate pages used by itself. Memory hotplug users won't
+ * be able to hot-remove hotpluggable memory used by the kernel. So this
+ * function skip hotpluggable regions when allocating memory for the kernel.
  */
 void __init_memblock __next_free_mem_range_rev(u64 *idx, int nid,
 					   phys_addr_t *out_start,
@@ -843,6 +847,10 @@ void __init_memblock __next_free_mem_range_rev(u64 *idx, int nid,
 		if (nid != MAX_NUMNODES && nid != memblock_get_region_node(m))
 			continue;
 
+		/* skip hotpluggable memory regions */
+		if (m->flags & MEMBLOCK_HOTPLUG)
+			continue;
+
 		/* scan areas before each reservation for intersection */
 		for ( ; ri >= 0; ri--) {
 			struct memblock_region *r = &rsv->regions[ri];
-- 
1.7.1
