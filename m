Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbaFPJ1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:27:38 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:20653 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbaFPJ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:26:47 -0400
Message-ID: <539EB7F5.9090201@huawei.com>
Date: Mon, 16 Jun 2014 17:25:09 +0800
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
Subject: [PATCH 6/8] mm: introduce cache_reclaim_weight
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a parameters cache_reclaim_weight. It is used to
speed up page cache reclaim.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 include/linux/swap.h |    3 +++
 kernel/sysctl.c      |    9 +++++++++
 mm/vmscan.c          |    6 ++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index bd85493..db912b2 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -361,6 +361,9 @@ extern unsigned long vm_cache_limit_mbytes_min;
 extern unsigned long vm_cache_limit_mbytes_max;
 extern unsigned long vm_cache_reclaim_s;
 extern unsigned long vm_cache_reclaim_s_min;
+extern unsigned long vm_cache_reclaim_weight;
+extern unsigned long vm_cache_reclaim_weight_min;
+extern unsigned long vm_cache_reclaim_weight_max;
 extern int cache_limit_ratio_sysctl_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
 extern int cache_limit_mbytes_sysctl_handler(struct ctl_table *table, int write,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index a8a09c4..452e0d3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1298,6 +1298,15 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= proc_doulongvec_minmax,
 		.extra1		= &vm_cache_reclaim_s_min,
 	},
+	{
+		.procname	= "cache_reclaim_weight",
+		.data		= &vm_cache_reclaim_weight,
+		.maxlen		= sizeof(vm_cache_reclaim_weight),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &vm_cache_reclaim_weight_min,
+		.extra2		= &vm_cache_reclaim_weight_max,
+	},
 #ifdef CONFIG_COMPACTION
 	{
 		.procname	= "compact_memory",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d7f866e..d179be6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -139,6 +139,9 @@ unsigned long vm_cache_limit_mbytes_min;
 unsigned long vm_cache_limit_mbytes_max;
 unsigned long vm_cache_reclaim_s __read_mostly;
 unsigned long vm_cache_reclaim_s_min;
+unsigned long vm_cache_reclaim_weight __read_mostly;
+unsigned long vm_cache_reclaim_weight_min;
+unsigned long vm_cache_reclaim_weight_max;
 
 static DEFINE_PER_CPU(struct delayed_work, vmscan_work);
 static LIST_HEAD(shrinker_list);
@@ -3410,6 +3413,9 @@ static void shrink_page_cache_init(void)
 	vm_cache_limit_mbytes_max = totalram_pages;
 	vm_cache_reclaim_s = 0;
 	vm_cache_reclaim_s_min = 0;
+	vm_cache_reclaim_weight = 1;
+	vm_cache_reclaim_weight_min = 1;
+	vm_cache_reclaim_weight_max = 100;
 
 	for_each_online_cpu(cpu) {
 		struct delayed_work *work = &per_cpu(vmscan_work, cpu);
-- 
1.6.0.2


