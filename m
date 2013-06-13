Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab3FMNja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:39:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63792 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758014Ab3FMN17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:27:59 -0400
X-IronPort-AV: E=Sophos;i="4.87,858,1363104000"; 
   d="scan'208";a="7537680"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [Part2 PATCH v4 13/15] x86, memblock, mem-hotplug: Free hotpluggable memory reserved by memblock.
Date: Thu, 13 Jun 2013 21:03:37 +0800
Message-Id: <1371128619-8987-14-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371128619-8987-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128619-8987-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:59:03,
	Serialize complete at 2013/06/13 20:59:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We reserved hotpluggable memory in memblock. And when memory initialization
is done, we have to free it to buddy system.

This patch free memory reserved by memblock with flag MEMBLK_HOTPLUGGABLE.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 include/linux/memblock.h |    1 +
 mm/memblock.c            |   17 +++++++++++++++++
 mm/nobootmem.c           |    3 +++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index ce315b2..d113175 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -66,6 +66,7 @@ int memblock_reserve(phys_addr_t base, phys_addr_t size);
 int memblock_reserve_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_reserve_local_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_reserve_hotpluggable(phys_addr_t base, phys_addr_t size, int nid);
+void memblock_free_hotpluggable(void);
 void memblock_trim_memory(phys_addr_t align);
 void memblock_mark_kernel_nodes(void);
 bool memblock_is_kernel_node(int nid);
diff --git a/mm/memblock.c b/mm/memblock.c
index 51f0264..9df0b5f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -568,6 +568,23 @@ int __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
 	return __memblock_remove(&memblock.reserved, base, size);
 }
 
+static void __init_memblock memblock_free_flags(unsigned long flags)
+{
+	int i;
+	struct memblock_type *reserved = &memblock.reserved;
+
+	for (i = 0; i < reserved->cnt; i++) {
+		if (reserved->regions[i].flags == flags)
+			memblock_remove_region(reserved, i);
+	}
+}
+
+void __init_memblock memblock_free_hotpluggable()
+{
+	memblock_dbg("memblock: free all hotpluggable memory");
+	memblock_free_flags(MEMBLK_HOTPLUGGABLE);
+}
+
 static int __init_memblock memblock_reserve_region(phys_addr_t base,
 						   phys_addr_t size,
 						   int nid,
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index bdd3fa2..dbfbcb9 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -165,6 +165,9 @@ unsigned long __init free_all_bootmem(void)
 	for_each_online_pgdat(pgdat)
 		reset_node_lowmem_managed_pages(pgdat);
 
+	/* Hotpluggable memory reserved by memblock should also be freed. */
+	memblock_free_hotpluggable();
+
 	/*
 	 * We need to use MAX_NUMNODES instead of NODE_DATA(0)->node_id
 	 *  because in some case like Node0 doesn't have RAM installed
-- 
1.7.1

