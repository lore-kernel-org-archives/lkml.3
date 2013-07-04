Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3GDE46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:56:58 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:58731 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab3GDE45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:56:57 -0400
Message-ID: <51D5008E.6030102@linux.vnet.ibm.com>
Date: Thu, 04 Jul 2013 12:56:46 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH v3 2/2] sched: reduce the overhead of obtain factor
References: <51D50024.10902@linux.vnet.ibm.com>
In-Reply-To: <51D50024.10902@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070404-5564-0000-0000-000008A5DED3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Smart wake-affine is using node-size as the factor, but the overhead of
mask operation is high.

Thus, this patch introduce the 'sd_llc_size', which will record the highest
cache-share domain size, and make it to be the new factor, in order to
reduce the overhead and make more reasonable.

And we suppose it will benefit a lot when facing a huge platform.

Test:
	Tested with 12 cpu X86 server and tip 3.10.0-rc7.

	pgbench		    base	smart + optimization

	| db_size | clients |  tps  |	|  tps  |
	+---------+---------+-------+   +-------+
	| 22 MB   |       1 | 10598 |   | 10781 |
	| 22 MB   |       2 | 21257 |   | 21328 |
	| 22 MB   |       4 | 41386 |   | 41622 |
	| 22 MB   |       8 | 51253 |   | 60351 |
	| 22 MB   |      12 | 48570 |   | 54255 |
	| 22 MB   |      16 | 46748 |   | 55534 | +18.79%
	| 22 MB   |      24 | 44346 |   | 55976 | +26.23%
	| 22 MB   |      32 | 43460 |   | 55279 | +27.20%
	| 7484 MB |       1 |  8951 |   |  9054 |
	| 7484 MB |       2 | 19233 |   | 19252 |
	| 7484 MB |       4 | 37239 |   | 37354 |
	| 7484 MB |       8 | 46087 |   | 51218 |
	| 7484 MB |      12 | 42054 |   | 49510 |
	| 7484 MB |      16 | 40765 |   | 52151 | +27.93%
	| 7484 MB |      24 | 37651 |   | 52720 | +40.02%
	| 7484 MB |      32 | 37056 |   | 51094 | +37.88%
	| 15 GB   |       1 |  8845 |   |  9139 |
	| 15 GB   |       2 | 19094 |   | 19379 |
	| 15 GB   |       4 | 36979 |   | 37077 |
	| 15 GB   |       8 | 46087 |   | 50490 |
	| 15 GB   |      12 | 41901 |   | 48235 |
	| 15 GB   |      16 | 40147 |   | 51878 | +29.22%
	| 15 GB   |      24 | 37250 |   | 52676 | +41.41%
	| 15 GB   |      32 | 36470 |   | 50198 | +37.64%

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/core.c  |    7 ++++++-
 kernel/sched/fair.c  |    2 +-
 kernel/sched/sched.h |    1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e8b3350..8fcca57 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5648,18 +5648,23 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
  * two cpus are in the same cache domain, see cpus_share_cache().
  */
 DEFINE_PER_CPU(struct sched_domain *, sd_llc);
+DEFINE_PER_CPU(int, sd_llc_size);
 DEFINE_PER_CPU(int, sd_llc_id);
 
 static void update_top_cache_domain(int cpu)
 {
 	struct sched_domain *sd;
 	int id = cpu;
+	int size = 1;
 
 	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
-	if (sd)
+	if (sd) {
 		id = cpumask_first(sched_domain_span(sd));
+		size = cpumask_weight(sched_domain_span(sd));
+	}
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
+	per_cpu(sd_llc_size, cpu) = size;
 	per_cpu(sd_llc_id, cpu) = id;
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a4ddbf5..86c4b86 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3129,7 +3129,7 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 
 static int wake_wide(struct task_struct *p)
 {
-	int factor = nr_cpus_node(cpu_to_node(smp_processor_id()));
+	int factor = this_cpu_read(sd_llc_size);
 
 	/*
 	 * Yeah, it's the switching-frequency, could means many wakee or
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ce39224..3227948 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -582,6 +582,7 @@ static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
 }
 
 DECLARE_PER_CPU(struct sched_domain *, sd_llc);
+DECLARE_PER_CPU(int, sd_llc_size);
 DECLARE_PER_CPU(int, sd_llc_id);
 
 struct sched_group_power {
-- 
1.7.4.1

