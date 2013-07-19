Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914Ab3GSIIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:08:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1854 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759800Ab3GSIA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:00:59 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947431"
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
Subject: [PATCH 03/21] x86, acpi, numa, mem-hotplug: Introduce MEMBLK_HOTPLUGGABLE to reserve hotpluggable memory.
Date: Fri, 19 Jul 2013 15:59:16 +0800
Message-Id: <1374220774-29974-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:44,
	Serialize complete at 2013/07/19 15:58:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pages used by the kernel cannot be migrated. As a result, hotpluggable
memory used by the kernel cannot be hot-removed. So for memory
hotplug users, the kernel should not use hotpluggable memory.

Since now we have flags in memblock, we introduce a MEMBLK_HOTPLUGGABLE
flag to mark hotpluggable memory. At the early time, we use memblock to
reserve hotpluggable memory, and mark it with MEMBLK_HOTPLUGGABLE flag.
When the system is up, we free these memory with MEMBLK_HOTPLUGGABLE
flag to the buddy, and arrange them into ZONE_MOVABLE. In this way, the
kernel won't be able to use it.

This patch introduces MEMBLK_HOTPLUGGABLE flag, and an API to reserve
memory with MEMBLK_HOTPLUGGABLE flag. This is a preparation for the
coming patches.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 include/linux/memblock.h |    2 ++
 mm/memblock.c            |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 93f3453..90b49ee 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -21,6 +21,7 @@
 
 /* Definition of memblock flags. */
 #define MEMBLK_FLAGS_DEFAULT	0x0	/* default flag */
+#define MEMBLK_HOTPLUGGABLE	0x1	/* hotpluggable region */
 
 struct memblock_region {
 	phys_addr_t base;
@@ -61,6 +62,7 @@ int memblock_add(phys_addr_t base, phys_addr_t size);
 int memblock_remove(phys_addr_t base, phys_addr_t size);
 int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
+int memblock_reserve_hotpluggable(phys_addr_t base, phys_addr_t size, int nid);
 void memblock_trim_memory(phys_addr_t align);
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
diff --git a/mm/memblock.c b/mm/memblock.c
index 9e871e9..73fe62d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -586,6 +586,12 @@ int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 				       MEMBLK_FLAGS_DEFAULT);
 }
 
+int __init_memblock memblock_reserve_hotpluggable(phys_addr_t base,
+						  phys_addr_t size, int nid)
+{
+	return memblock_reserve_region(base, size, nid, MEMBLK_HOTPLUGGABLE);
+}
+
 /**
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
-- 
1.7.1

