Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281Ab3EXJhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:37:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14209 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760096Ab3EXJh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:37:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,734,1363104000"; 
   d="scan'208";a="7355217"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, tj@kernel.org,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v3 11/13] x86, memblock, mem-hotplug: Free hotpluggable memory reserved by memblock.
Date: Fri, 24 May 2013 17:29:20 +0800
Message-Id: <1369387762-17865-12-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1369387762-17865-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1369387762-17865-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 17:25:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/24 17:36:00,
	Serialize complete at 2013/05/24 17:36:00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We reserved hotpluggable memory in memblock. And when memory initialization
is done, we have to free it to buddy system.

This patch free memory reserved by memblock with flag MEMBLK_HOTPLUGGABLE.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 include/linux/memblock.h |    1 +
 mm/memblock.c            |   20 ++++++++++++++++++++
 mm/nobootmem.c           |    3 +++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 0f01930..08c761d 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -69,6 +69,7 @@ int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
 int memblock_reserve_local_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_reserve_hotpluggable(phys_addr_t base, phys_addr_t size, int nid);
+void memblock_free_hotpluggable(void);
 void memblock_trim_memory(phys_addr_t align);
 void memblock_mark_kernel_nodes(void);
 bool memblock_is_kernel_node(int nid);
diff --git a/mm/memblock.c b/mm/memblock.c
index 0c55588..54de398 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -568,6 +568,26 @@ int __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
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
+	unsigned long flags = 1 << MEMBLK_HOTPLUGGABLE;
+
+	memblock_dbg("memblock: free all hotpluggable memory");
+
+	memblock_free_flags(flags);
+}
+
 static int __init_memblock memblock_reserve_region(phys_addr_t base,
 						   phys_addr_t size,
 						   int nid,
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 5e07d36..cd85604 100644
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

