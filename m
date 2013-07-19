Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935247Ab3GSIEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:04:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1706 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965421Ab3GSIBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:01:05 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947442"
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
Subject: [PATCH 16/21] x86, memblock, mem-hotplug: Free hotpluggable memory reserved by memblock.
Date: Fri, 19 Jul 2013 15:59:29 +0800
Message-Id: <1374220774-29974-17-git-send-email-tangchen@cn.fujitsu.com>
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

We reserved hotpluggable memory in memblock at early time. And when memory
initialization is done, we have to free it to buddy system.

This patch free memory reserved by memblock with flag MEMBLK_HOTPLUGGABLE.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 include/linux/memblock.h |    1 +
 mm/memblock.c            |   17 +++++++++++++++++
 mm/nobootmem.c           |    3 +++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 90b49ee..8d71795 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -63,6 +63,7 @@ int memblock_remove(phys_addr_t base, phys_addr_t size);
 int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
 int memblock_reserve_hotpluggable(phys_addr_t base, phys_addr_t size, int nid);
+void memblock_free_hotpluggable(void);
 void memblock_trim_memory(phys_addr_t align);
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
diff --git a/mm/memblock.c b/mm/memblock.c
index 73fe62d..631b727 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -565,6 +565,23 @@ int __init_memblock memblock_free(phys_addr_t base, phys_addr_t size)
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

