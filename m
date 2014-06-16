Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaFPJ1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:27:13 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:20962 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbaFPJ1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:27:11 -0400
Message-ID: <539EB7F1.7080302@huawei.com>
Date: Mon, 16 Jun 2014 17:25:05 +0800
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
Subject: [PATCH 5/8] mm: implement page cache reclaim in circles
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a work on each online cpu, and schedule it in circles to reclaim
page cache.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/vmscan.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 61cedfc..d7f866e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -140,6 +140,7 @@ unsigned long vm_cache_limit_mbytes_max;
 unsigned long vm_cache_reclaim_s __read_mostly;
 unsigned long vm_cache_reclaim_s_min;
 
+static DEFINE_PER_CPU(struct delayed_work, vmscan_work);
 static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
 
@@ -3384,8 +3385,23 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
 }
 #endif /* CONFIG_HIBERNATION */
 
+static void shrink_page_cache_work(struct work_struct *w)
+{
+	struct delayed_work *work = to_delayed_work(w);
+
+	if (vm_cache_reclaim_s == 0) {
+		schedule_delayed_work(work, round_jiffies_relative(120 * HZ));
+		return;
+	}
+
+	shrink_page_cache(GFP_KERNEL);
+	schedule_delayed_work(work, round_jiffies_relative(vm_cache_reclaim_s * HZ));
+}
+
 static void shrink_page_cache_init(void)
 {
+	int cpu;
+
 	vm_cache_limit_ratio = 0;
 	vm_cache_limit_ratio_min = 0;
 	vm_cache_limit_ratio_max = 100;
@@ -3394,6 +3410,13 @@ static void shrink_page_cache_init(void)
 	vm_cache_limit_mbytes_max = totalram_pages;
 	vm_cache_reclaim_s = 0;
 	vm_cache_reclaim_s_min = 0;
+
+	for_each_online_cpu(cpu) {
+		struct delayed_work *work = &per_cpu(vmscan_work, cpu);
+		INIT_DEFERRABLE_WORK(work, shrink_page_cache_work);
+		schedule_delayed_work_on(cpu, work,
+			__round_jiffies_relative(vm_cache_reclaim_s * HZ, cpu));
+	}
 }
 
 static unsigned long __shrink_page_cache(gfp_t mask)
@@ -3428,6 +3451,8 @@ static int cpu_callback(struct notifier_block *nfb, unsigned long action,
 			void *hcpu)
 {
 	int nid;
+	long cpu = (long)hcpu;
+	struct delayed_work *work = &per_cpu(vmscan_work, cpu);
 
 	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN) {
 		for_each_node_state(nid, N_MEMORY) {
@@ -3441,6 +3466,22 @@ static int cpu_callback(struct notifier_block *nfb, unsigned long action,
 				set_cpus_allowed_ptr(pgdat->kswapd, mask);
 		}
 	}
+
+	switch (action) {
+	case CPU_ONLINE:
+		if (work->work.func == NULL)
+			INIT_DEFERRABLE_WORK(work, shrink_page_cache_work);
+		schedule_delayed_work_on(cpu, work,
+			__round_jiffies_relative(vm_cache_reclaim_s * HZ, cpu));
+		break;
+	case CPU_DOWN_PREPARE:
+		cancel_delayed_work_sync(work);
+		work->work.func = NULL;
+		break;
+	default:
+		break;
+	}
+
 	return NOTIFY_OK;
 }
 
-- 
1.6.0.2


