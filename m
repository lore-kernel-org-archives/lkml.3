Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab3DSJbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:31:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51763 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S968005Ab3DSJ3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:29:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,508,1363104000"; 
   d="scan'208";a="7095294"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com, davej@redhat.com, agordeev@redhat.com,
        suresh.b.siddha@intel.com, mst@redhat.com, yinghai@kernel.org,
        penberg@kernel.org, jacob.shin@amd.com, wency@cn.fujitsu.com,
        trenn@suse.de, liwanp@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com, rientjes@google.com, tj@kernel.org,
        laijs@cn.fujitsu.com, hannes@cmpxchg.org, davem@davemloft.net,
        mgorman@suse.de, minchan@kernel.org, m.szyprowski@samsung.com,
        mina86@mina86.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v1 11/12] x86, numa, acpi, memory-hotplug: Make movablecore=acpi have higher priority.
Date: Fri, 19 Apr 2013 17:31:48 +0800
Message-Id: <1366363909-12771-12-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1366363909-12771-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1366363909-12771-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/19 17:27:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/19 17:27:29,
	Serialize complete at 2013/04/19 17:27:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arrange hotpluggable memory as ZONE_MOVABLE will cause NUMA performance decreased
because the kernel cannot use movable memory.

For users who don't use memory hotplug and who don't want to lose their NUMA
performance, they need a way to disable this functionality.

So, if users specify "movablecore=acpi" in kernel commandline, the kernel will
use SRAT to arrange ZONE_MOVABLE, and it has higher priority then original
movablecore and kernelcore boot option.

For those who don't want this, just specify nothing.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 include/linux/memblock.h |    1 +
 mm/memblock.c            |    5 +++++
 mm/page_alloc.c          |   24 +++++++++++++++++++++++-
 3 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 08c761d..5528e8f 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -69,6 +69,7 @@ int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
 int memblock_reserve_local_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_reserve_hotpluggable(phys_addr_t base, phys_addr_t size, int nid);
+bool memblock_is_hotpluggable(struct memblock_region *region);
 void memblock_free_hotpluggable(void);
 void memblock_trim_memory(phys_addr_t align);
 void memblock_mark_kernel_nodes(void);
diff --git a/mm/memblock.c b/mm/memblock.c
index 54de398..8b9a13c 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -623,6 +623,11 @@ int __init_memblock memblock_reserve_hotpluggable(phys_addr_t base,
 	return memblock_reserve_region(base, size, nid, flags);
 }
 
+bool __init_memblock memblock_is_hotpluggable(struct memblock_region *region)
+{
+	return region->flags & (1 << MEMBLK_HOTPLUGGABLE);
+}
+
 /**
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b9ea143..2fe9ebf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4793,9 +4793,31 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 	nodemask_t saved_node_state = node_states[N_MEMORY];
 	unsigned long totalpages = early_calculate_totalpages();
 	int usable_nodes = nodes_weight(node_states[N_MEMORY]);
+	struct memblock_type *reserved = &memblock.reserved;
 
 	/*
-	 * If movablecore was specified, calculate what size of
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
+			usable_startpfn = reserved->regions[i].base;
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
-- 
1.7.1

