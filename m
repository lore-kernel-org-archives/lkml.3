Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3FRE5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 00:57:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:38703 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab3FRE5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:57:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,886,1363158000"; 
   d="scan'208";a="355149949"
Message-ID: <51BFE868.9010008@intel.com>
Date: Tue, 18 Jun 2013 12:56:08 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [RFC patch 1/4] sched: change cfs_rq load avg to unsigned long
References: <1370590169-24804-1-git-send-email-alex.shi@intel.com> <1370590169-24804-2-git-send-email-alex.shi@intel.com>
In-Reply-To: <1370590169-24804-2-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 03:29 PM, Alex Shi wrote:
> Since the 'u64 runnable_load_avg, blocked_load_avg' in cfs_rq struct are
> smaller than 'unsigned long' cfs_rq->load.weight. We don't need u64
> vaiables to describe them. unsigned long is more efficient and convenience.
> 

update with a a bit clean up in tg_load_down()
---

>From e78ccc55dff1a5ef406a100f6453d0b8c86ca310 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Thu, 6 Jun 2013 20:12:36 +0800
Subject: [PATCH 1/5] sched: change cfs_rq load avg to unsigned long

Since the 'u64 runnable_load_avg, blocked_load_avg' in cfs_rq struct are
smaller than 'unsigned long' cfs_rq->load.weight. We don't need u64
variables to describe them. unsigned long is more efficient and convenience.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Paul Turner <pjt@google.com>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/debug.c | 4 ++--
 kernel/sched/fair.c  | 7 ++-----
 kernel/sched/sched.h | 2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 75024a6..160afdc 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -211,9 +211,9 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
-	SEQ_printf(m, "  .%-30s: %lld\n", "runnable_load_avg",
+	SEQ_printf(m, "  .%-30s: %ld\n", "runnable_load_avg",
 			cfs_rq->runnable_load_avg);
-	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
+	SEQ_printf(m, "  .%-30s: %ld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
 	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_avg",
 			(unsigned long long)atomic64_read(&cfs_rq->tg->load_avg));
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 395f57c..39a5bae 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4186,12 +4186,9 @@ static int tg_load_down(struct task_group *tg, void *data)
 	if (!tg->parent) {
 		load = cpu_rq(cpu)->avg.load_avg_contrib;
 	} else {
-		unsigned long tmp_rla;
-		tmp_rla = tg->parent->cfs_rq[cpu]->runnable_load_avg + 1;
-
 		load = tg->parent->cfs_rq[cpu]->h_load;
-		load *= tg->se[cpu]->avg.load_avg_contrib;
-		load /= tmp_rla;
+		load = div64_ul(load * tg->se[cpu]->avg.load_avg_contrib,
+				tg->parent->cfs_rq[cpu]->runnable_load_avg + 1);
 	}
 
 	tg->cfs_rq[cpu]->h_load = load;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0684c26..762fa63 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -277,7 +277,7 @@ struct cfs_rq {
 	 * This allows for the description of both thread and group usage (in
 	 * the FAIR_GROUP_SCHED case).
 	 */
-	u64 runnable_load_avg, blocked_load_avg;
+	unsigned long runnable_load_avg, blocked_load_avg;
 	atomic64_t decay_counter, removed_load;
 	u64 last_decay;
 
-- 
1.7.12

