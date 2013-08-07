Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab3HGLPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:15:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46626 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab3HGLNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:13:41 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8144303"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
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
Subject: [PATCH v3 23/25] memblock, mem_hotplug: Make memblock skip hotpluggable regions by default.
Date: Wed, 7 Aug 2013 18:52:14 +0800
Message-Id: <1375872736-4822-24-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375872736-4822-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375872736-4822-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:52:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:52:19,
	Serialize complete at 2013/08/07 18:52:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index ecd8568..3ea4301 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -695,6 +695,10 @@ void __init_memblock __next_free_mem_range(u64 *idx, int nid,
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
@@ -719,6 +723,10 @@ void __init_memblock __next_free_mem_range_rev(u64 *idx, int nid,
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

