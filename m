Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935687Ab3FTCVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:21:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:16182 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935671Ab3FTCVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:21:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,901,1363158000"; 
   d="scan'208";a="319759524"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [Resend patch v8 09/13] sched: change cfs_rq load avg to unsigned long
Date: Thu, 20 Jun 2013 10:18:53 +0800
Message-Id: <1371694737-29336-10-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the 'u64 runnable_load_avg, blocked_load_avg' in cfs_rq struct are
smaller than 'unsigned long' cfs_rq->load.weight. We don't need u64
vaiables to describe them. unsigned long is more efficient and convenience.

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

