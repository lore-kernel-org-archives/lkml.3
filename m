Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965498Ab3GSIBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:01:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1706 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759776Ab3GSIA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:00:57 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947444"
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
Subject: [PATCH 20/21] x86, numa, acpi, memory-hotplug: Make movablecore=acpi have higher priority.
Date: Fri, 19 Jul 2013 15:59:33 +0800
Message-Id: <1374220774-29974-21-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:49,
	Serialize complete at 2013/07/19 15:58:49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arrange hotpluggable memory as ZONE_MOVABLE will cause NUMA performance down
because the kernel cannot use movable memory. For users who don't use memory
hotplug and who don't want to lose their NUMA performance, they need a way to
disable this functionality. So we improved movablecore boot option.

If users specify the original movablecore=nn@ss boot option, the kernel will
arrange [ss, ss+nn) as ZONE_MOVABLE. The kernelcore=nn@ss boot option is similar
except it specifies ZONE_NORMAL ranges.

Now, if users specify "movablecore=acpi" in kernel commandline, the kernel will
arrange hotpluggable memory in SRAT as ZONE_MOVABLE. And if users do this, all
the other movablecore=nn@ss and kernelcore=nn@ss options should be ignored.

For those who don't want this, just specify nothing. The kernel will act as
before.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 include/linux/memblock.h |    1 +
 mm/memblock.c            |    5 +++++
 mm/page_alloc.c          |   31 +++++++++++++++++++++++++++++--
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d520015..28ba511 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -64,6 +64,7 @@ int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
 int memblock_reserve_hotpluggable(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_reserve_node(phys_addr_t base, phys_addr_t size, int nid);
+bool memblock_is_hotpluggable(struct memblock_region *region);
 void memblock_free_hotpluggable(void);
 void memblock_trim_memory(phys_addr_t align);
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 1f5dc12..fd3ded8 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -616,6 +616,11 @@ int __init_memblock memblock_reserve_hotpluggable(phys_addr_t base,
 	return memblock_reserve_region(base, size, nid, MEMBLK_HOTPLUGGABLE);
 }
 
+bool __init_memblock memblock_is_hotpluggable(struct memblock_region *region)
+{
+	return region->flags & MEMBLK_HOTPLUGGABLE;
+}
+
 /**
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6271c36..cdb7919 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4880,9 +4880,37 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 	nodemask_t saved_node_state = node_states[N_MEMORY];
 	unsigned long totalpages = early_calculate_totalpages();
 	int usable_nodes = nodes_weight(node_states[N_MEMORY]);
+	struct memblock_type *reserved = &memblock.reserved;
 
 	/*
-	 * If movablecore was specified, calculate what size of
+	 * Need to find movable_zone earlier in case movablecore=acpi is
+	 * specified.
+	 */
+	find_usable_zone_for_movable();
+
+	/*
+	 * If movablecore=acpi was specified, then zone_movable_pfn[] has been
+	 * initialized, and no more work needs to do.
+	 * NOTE: In this case, we ignore kernelcore option.
+	 */
+	if (movablecore_enable_srat) {
+		for (i = 0; i < reserved->cnt; i++) {
+			if (!memblock_is_hotpluggable(&reserved->regions[i]))
+				continue;
+
+			nid = reserved->regions[i].nid;
+
+			usable_startpfn = PFN_DOWN(reserved->regions[i].base);
+			zone_movable_pfn[nid] = zone_movable_pfn[nid] ?
+				min(usable_startpfn, zone_movable_pfn[nid]) :
+				usable_startpfn;
+		}
+
+		goto out;
+	}
+
+	/*
+	 * If movablecore=nn[KMG] was specified, calculate what size of
 	 * kernelcore that corresponds so that memory usable for
 	 * any allocation type is evenly spread. If both kernelcore
 	 * and movablecore are specified, then the value of kernelcore
@@ -4908,7 +4936,6 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 		goto out;
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
-	find_usable_zone_for_movable();
 	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
 
 restart:
-- 
1.7.1

