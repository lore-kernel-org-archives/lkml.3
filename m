Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbaJVHwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:52:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44491 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaJVHwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:52:15 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <54476215.3010006@jp.fujitsu.com>
Date: Wed, 22 Oct 2014 16:51:49 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <akpm@linux-foundation.org>, <toshi.kani@hp.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
CC: <zhenzhang.zhang@huawei.com>, <wangnan0@huawei.com>,
        <tangchen@cn.fujitsu.com>, <dave.hansen@intel.com>,
        <rientjes@google.com>
Subject: [PATCH v2] memory-hotplug: Clear pgdat which is allocated by bootmem
 in try_offline_node()
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hot adding the same memory after hot removing a memory,
the following messages are shown:

WARNING: CPU: 20 PID: 6 at mm/page_alloc.c:4968 free_area_init_node+0x3fe/0x426()
...
Call Trace:
 [<...>] dump_stack+0x46/0x58
 [<...>] warn_slowpath_common+0x81/0xa0
 [<...>] warn_slowpath_null+0x1a/0x20
 [<...>] free_area_init_node+0x3fe/0x426
 [<...>] ? up+0x32/0x50
 [<...>] hotadd_new_pgdat+0x90/0x110
 [<...>] add_memory+0xd4/0x200
 [<...>] acpi_memory_device_add+0x1aa/0x289
 [<...>] acpi_bus_attach+0xfd/0x204
 [<...>] ? device_register+0x1e/0x30
 [<...>] acpi_bus_attach+0x178/0x204
 [<...>] acpi_bus_scan+0x6a/0x90
 [<...>] ? acpi_bus_get_status+0x2d/0x5f
 [<...>] acpi_device_hotplug+0xe8/0x418
 [<...>] acpi_hotplug_work_fn+0x1f/0x2b
 [<...>] process_one_work+0x14e/0x3f0
 [<...>] worker_thread+0x11b/0x510
 [<...>] ? rescuer_thread+0x350/0x350
 [<...>] kthread+0xe1/0x100
 [<...>] ? kthread_create_on_node+0x1b0/0x1b0
 [<...>] ret_from_fork+0x7c/0xb0
 [<...>] ? kthread_create_on_node+0x1b0/0x1b0

The detaled explanation is as follows:

When hot removing memory, pgdat is set to 0 in try_offline_node().
But if the pgdat is allocated by bootmem allocator, the clearing
step is skipped. And when hot adding the same memory, the uninitialized
pgdat is reused. But free_area_init_node() checks wether pgdat is set
to zero. As a result, free_area_init_node() hits WARN_ON().

This patch clears pgdat which is allocated by bootmem allocator
in try_offline_node().

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Zhang Zhen <zhenzhang.zhang@huawei.com>
CC: Wang Nan <wangnan0@huawei.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>
CC: Toshi Kani <toshi.kani@hp.com>
CC: Dave Hansen <dave.hansen@intel.com>
CC: David Rientjes <rientjes@google.com>
---
v2: remove check of pgdat_page

 mm/memory_hotplug.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 29d8693..252e1db 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1912,7 +1912,6 @@ void try_offline_node(int nid)
 	unsigned long start_pfn = pgdat->node_start_pfn;
 	unsigned long end_pfn = start_pfn + pgdat->node_spanned_pages;
 	unsigned long pfn;
-	struct page *pgdat_page = virt_to_page(pgdat);
 	int i;

 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
@@ -1941,10 +1940,6 @@ void try_offline_node(int nid)
 	node_set_offline(nid);
 	unregister_one_node(nid);

-	if (!PageSlab(pgdat_page) && !PageCompound(pgdat_page))
-		/* node data is allocated from boot memory */
-		return;
-
 	/* free waittable in each zone */
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		struct zone *zone = pgdat->node_zones + i;
-- 
1.8.3.1


