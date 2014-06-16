Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbaFPJ1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:27:36 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:20666 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbaFPJ0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:26:47 -0400
Message-ID: <539EB7EE.3050502@huawei.com>
Date: Mon, 16 Jun 2014 17:25:02 +0800
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
Subject: [PATCH 4/8] mm: introduce cache_reclaim_s
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a parameters cache_reclaim_s. It is used to reclaim
page cache in circles.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 include/linux/swap.h |    2 ++
 kernel/sysctl.c      |    8 ++++++++
 mm/vmscan.c          |    4 ++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index dcbe1a3..bd85493 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -359,6 +359,8 @@ extern unsigned long vm_cache_limit_ratio_max;
 extern unsigned long vm_cache_limit_mbytes;
 extern unsigned long vm_cache_limit_mbytes_min;
 extern unsigned long vm_cache_limit_mbytes_max;
+extern unsigned long vm_cache_reclaim_s;
+extern unsigned long vm_cache_reclaim_s_min;
 extern int cache_limit_ratio_sysctl_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
 extern int cache_limit_mbytes_sysctl_handler(struct ctl_table *table, int write,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9bb6f38..a8a09c4 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1290,6 +1290,14 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &vm_cache_limit_mbytes_min,
 		.extra2		= &vm_cache_limit_mbytes_max,
 	},
+	{
+		.procname	= "cache_reclaim_s",
+		.data		= &vm_cache_reclaim_s,
+		.maxlen		= sizeof(vm_cache_reclaim_s),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &vm_cache_reclaim_s_min,
+	},
 #ifdef CONFIG_COMPACTION
 	{
 		.procname	= "compact_memory",
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 707d3e3..61cedfc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -137,6 +137,8 @@ unsigned long vm_cache_limit_ratio_max;
 unsigned long vm_cache_limit_mbytes __read_mostly;
 unsigned long vm_cache_limit_mbytes_min;
 unsigned long vm_cache_limit_mbytes_max;
+unsigned long vm_cache_reclaim_s __read_mostly;
+unsigned long vm_cache_reclaim_s_min;
 
 static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
@@ -3390,6 +3392,8 @@ static void shrink_page_cache_init(void)
 	vm_cache_limit_mbytes = 0;
 	vm_cache_limit_mbytes_min = 0;
 	vm_cache_limit_mbytes_max = totalram_pages;
+	vm_cache_reclaim_s = 0;
+	vm_cache_reclaim_s_min = 0;
 }
 
 static unsigned long __shrink_page_cache(gfp_t mask)
-- 
1.6.0.2


