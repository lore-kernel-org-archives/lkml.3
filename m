Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbaGRIJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:09:24 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:27090 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaGRIJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:09:10 -0400
From: Wang Nan <wangnan0@huawei.com>
To: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        "Mel Gorman" <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Pei Feiyue <peifeiyue@huawei.com>, <linux-mm@kvack.org>, <x86@kernel.org>,
        <linux-ia64@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-sh@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] memory-hotplug: sh: suitable memory should go to ZONE_MOVABLE
Date: Fri, 18 Jul 2014 15:56:02 +0800
Message-ID: <1405670163-53747-5-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1405670163-53747-1-git-send-email-wangnan0@huawei.com>
References: <1405670163-53747-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add new memory to ZONE_MOVABLE if movable zone is setup
and lower than newly added memory for sh.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/sh/mm/init.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 2d089fe..ff9decc 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -487,16 +487,19 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 #ifdef CONFIG_MEMORY_HOTPLUG
 int arch_add_memory(int nid, u64 start, u64 size)
 {
-	pg_data_t *pgdat;
+	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
+	struct zone *zone = pgdat->node_zones + ZONE_NORMAL;
+	struct zone *movable_zone = pgdat->node_zones + ZONE_MOVABLE;
 	int ret;
 
-	pgdat = NODE_DATA(nid);
+	if (!zone_is_empty(movable_zone))
+		if (zone_spans_pfn(movable_zone, start_pfn) ||
+				(zone_end_pfn(movable_zone) <= start_pfn))
+			zone = movable_zone;
 
-	/* We only have ZONE_NORMAL, so this is easy.. */
-	ret = __add_pages(nid, pgdat->node_zones + ZONE_NORMAL,
-				start_pfn, nr_pages);
+	ret = __add_pages(nid, zone, start_pfn, nr_pages);
 	if (unlikely(ret))
 		printk("%s: Failed, __add_pages() == %d\n", __func__, ret);
 
-- 
1.8.4

