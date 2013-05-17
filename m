Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3EQPrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:47:47 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52885 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab3EQPrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:47:09 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7, part3 15/16] mm: report available pages as "MemTotal" for each NUMA node
Date: Fri, 17 May 2013 23:45:17 +0800
Message-Id: <1368805518-2634-16-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368805518-2634-1-git-send-email-jiang.liu@huawei.com>
References: <1368805518-2634-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by https://bugzilla.kernel.org/show_bug.cgi?id=53501,
"MemTotal" from /proc/meminfo means memory pages managed by the buddy
system (managed_pages), but "MemTotal" from /sys/.../node/nodex/meminfo
means physical pages present (present_pages) within the NUMA node.
There's a difference between managed_pages and present_pages due to
bootmem allocator and reserved pages.

And Documentation/filesystems/proc.txt says
    MemTotal: Total usable ram (i.e. physical ram minus a few reserved
              bits and the kernel binary code)

So change /sys/.../node/nodex/meminfo to report available pages within
the node as "MemTotal".

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Reported-by: sworddragon2@aol.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/page_alloc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 56b0097..e7a517d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2924,9 +2924,13 @@ EXPORT_SYMBOL(si_meminfo);
 #ifdef CONFIG_NUMA
 void si_meminfo_node(struct sysinfo *val, int nid)
 {
+	int zone_type;		/* needs to be signed */
+	unsigned long managed_pages = 0;
 	pg_data_t *pgdat = NODE_DATA(nid);
 
-	val->totalram = pgdat->node_present_pages;
+	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++)
+		managed_pages += pgdat->node_zones[zone_type].managed_pages;
+	val->totalram = managed_pages;
 	val->freeram = node_page_state(nid, NR_FREE_PAGES);
 #ifdef CONFIG_HIGHMEM
 	val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].managed_pages;
-- 
1.8.1.2

