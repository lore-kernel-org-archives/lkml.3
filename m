Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaFPJ2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:28:51 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:10339 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbaFPJ0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:26:38 -0400
Message-ID: <539EB7E6.6020201@huawei.com>
Date: Mon, 16 Jun 2014 17:24:54 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <aquini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        "Xishi Qiu" <qiuxishi@huawei.com>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 2/8] mm: add shrink page cache core
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function shrink_page_cache(), it will call do_try_to_free_pages()
to reclaim the page cache.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 include/linux/swap.h |    2 ++
 mm/page_alloc.c      |   12 ++++++++++++
 mm/vmscan.c          |   24 ++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7e362d7..dcbe1a3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -363,6 +363,8 @@ extern int cache_limit_ratio_sysctl_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
 extern int cache_limit_mbytes_sysctl_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
+extern unsigned long page_cache_over_limit(void);
+extern void shrink_page_cache(gfp_t mask);
 
 #ifdef CONFIG_NUMA
 extern int zone_reclaim_mode;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a9cc034..00707ef 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5829,6 +5829,18 @@ int cache_limit_mbytes_sysctl_handler(struct ctl_table *table, int write,
 	return 0;
 }
 
+unsigned long page_cache_over_limit(void)
+{
+	unsigned long lru_file, limit;
+
+	limit = vm_cache_limit_mbytes * ((1024 * 1024UL) / PAGE_SIZE);
+	lru_file = global_page_state(NR_ACTIVE_FILE)
+		+ global_page_state(NR_INACTIVE_FILE);
+	if (lru_file > limit)
+		return lru_file - limit;
+	return 0;
+}
+
 #ifdef CONFIG_NUMA
 int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 37ea902..ad01ff4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3389,6 +3389,30 @@ static void shrink_page_cache_init(void)
 	vm_cache_limit_mbytes_max = totalram_pages;
 }
 
+static unsigned long __shrink_page_cache(gfp_t mask)
+{
+	struct scan_control sc = {
+		.gfp_mask = (mask = memalloc_noio_flags(mask)),
+		.may_writepage = !laptop_mode,
+		.nr_to_reclaim = SWAP_CLUSTER_MAX,
+		.may_unmap = 1,
+		.may_swap = 1,
+		.order = 0,
+		.priority = DEF_PRIORITY,
+		.target_mem_cgroup = NULL,
+		.nodemask = NULL,
+	};
+	struct zonelist *zonelist = node_zonelist(numa_node_id(), mask);
+
+	return do_try_to_free_pages(zonelist, &sc);
+}
+
+void shrink_page_cache(gfp_t mask)
+{
+	/* We reclaim the highmem zone too, it is useful for 32bit arch */
+	__shrink_page_cache(mask | __GFP_HIGHMEM);
+}
+
 /* It's optimal to keep kswapds on the same CPUs as their memory, but
    not required for correctness.  So if the last cpu in a node goes
    away, we get changed to run anywhere: as the first one comes back,
-- 
1.6.0.2


