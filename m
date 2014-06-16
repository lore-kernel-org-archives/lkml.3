Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaFPJ1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:27:00 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:20658 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbaFPJ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:26:48 -0400
Message-ID: <539EB7E2.9060805@huawei.com>
Date: Mon, 16 Jun 2014 17:24:50 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <aquini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 1/8] mm: introduce cache_limit_ratio and cache_limit_mbytes
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces two parameters cache_limit_ratio and cache_limit_mbytes.
They are used to limit page cache amount.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 include/linux/swap.h |   10 ++++++++++
 kernel/sysctl.c      |   18 ++++++++++++++++++
 mm/page_alloc.c      |   39 +++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c          |   17 +++++++++++++++++
 4 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3507115..7e362d7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -353,6 +353,16 @@ extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
 extern int remove_mapping(struct address_space *mapping, struct page *page);
 extern unsigned long vm_total_pages;
+extern unsigned long vm_cache_limit_ratio;
+extern unsigned long vm_cache_limit_ratio_min;
+extern unsigned long vm_cache_limit_ratio_max;
+extern unsigned long vm_cache_limit_mbytes;
+extern unsigned long vm_cache_limit_mbytes_min;
+extern unsigned long vm_cache_limit_mbytes_max;
+extern int cache_limit_ratio_sysctl_handler(struct ctl_table *table, int write,
+			void __user *buffer, size_t *length, loff_t *ppos);
+extern int cache_limit_mbytes_sysctl_handler(struct ctl_table *table, int write,
+			void __user *buffer, size_t *length, loff_t *ppos);
 
 #ifdef CONFIG_NUMA
 extern int zone_reclaim_mode;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 74f5b58..9bb6f38 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1272,6 +1272,24 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &one,
 		.extra2		= &four,
 	},
+	{
+		.procname	= "cache_limit_ratio",
+		.data		= &vm_cache_limit_ratio,
+		.maxlen		= sizeof(vm_cache_limit_ratio),
+		.mode		= 0644,
+		.proc_handler	= cache_limit_ratio_sysctl_handler,
+		.extra1		= &vm_cache_limit_ratio_min,
+		.extra2		= &vm_cache_limit_ratio_max,
+	},
+	{
+		.procname	= "cache_limit_mbytes",
+		.data		= &vm_cache_limit_mbytes,
+		.maxlen		= sizeof(vm_cache_limit_mbytes),
+		.mode		= 0644,
+		.proc_handler	= cache_limit_mbytes_sysctl_handler,
+		.extra1		= &vm_cache_limit_mbytes_min,
+		.extra2		= &vm_cache_limit_mbytes_max,
+	},
 #ifdef CONFIG_COMPACTION
 	{
 		.procname	= "compact_memory",
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5dba293..a9cc034 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5790,6 +5790,45 @@ int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
 	return 0;
 }
 
+int cache_limit_ratio_sysctl_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	if (ret)
+		return ret;
+	if (write) {
+		vm_cache_limit_mbytes = totalram_pages
+			* vm_cache_limit_ratio / 100
+			* PAGE_SIZE / (1024 * 1024UL);
+		if (vm_cache_limit_ratio)
+			printk(KERN_WARNING "cache limit set to %ld%\n",
+				vm_cache_limit_ratio);
+	}
+	return 0;
+}
+
+int cache_limit_mbytes_sysctl_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	if (ret)
+		return ret;
+	if (write) {
+		vm_cache_limit_ratio = (vm_cache_limit_mbytes
+			* ((1024 * 1024UL) / PAGE_SIZE)
+			+ totalram_pages / 200)
+			* 100 / totalram_pages;
+		if (vm_cache_limit_mbytes)
+			printk(KERN_WARNING "cache limit set to %ldMB\n",
+				vm_cache_limit_mbytes);
+	}
+	return 0;
+}
+
 #ifdef CONFIG_NUMA
 int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 32c661d..37ea902 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -131,6 +131,12 @@ struct scan_control {
  */
 int vm_swappiness = 60;
 unsigned long vm_total_pages;	/* The total number of pages which the VM controls */
+unsigned long vm_cache_limit_ratio;
+unsigned long vm_cache_limit_ratio_min;
+unsigned long vm_cache_limit_ratio_max;
+unsigned long vm_cache_limit_mbytes __read_mostly;
+unsigned long vm_cache_limit_mbytes_min;
+unsigned long vm_cache_limit_mbytes_max;
 
 static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
@@ -3373,6 +3379,16 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
 }
 #endif /* CONFIG_HIBERNATION */
 
+static void shrink_page_cache_init(void)
+{
+	vm_cache_limit_ratio = 0;
+	vm_cache_limit_ratio_min = 0;
+	vm_cache_limit_ratio_max = 100;
+	vm_cache_limit_mbytes = 0;
+	vm_cache_limit_mbytes_min = 0;
+	vm_cache_limit_mbytes_max = totalram_pages;
+}
+
 /* It's optimal to keep kswapds on the same CPUs as their memory, but
    not required for correctness.  So if the last cpu in a node goes
    away, we get changed to run anywhere: as the first one comes back,
@@ -3442,6 +3458,7 @@ static int __init kswapd_init(void)
 	for_each_node_state(nid, N_MEMORY)
  		kswapd_run(nid);
 	hotcpu_notifier(cpu_callback, 0);
+	shrink_page_cache_init();
 	return 0;
 }
 
-- 
1.6.0.2


