Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3F0JDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:03:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46060 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3F0JDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:03:03 -0400
Date: Thu, 27 Jun 2013 02:02:32 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-72a4cf20cb71a327c636c7042fdacc25abffc87c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, pjt@google.com, alex.shi@intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, peterz@infradead.org, alex.shi@intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1371694737-29336-10-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-10-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Change cfs_rq load avg to unsigned long
Git-Commit-ID: 72a4cf20cb71a327c636c7042fdacc25abffc87c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:02:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72a4cf20cb71a327c636c7042fdacc25abffc87c
Gitweb:     http://git.kernel.org/tip/72a4cf20cb71a327c636c7042fdacc25abffc87c
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 20 Jun 2013 10:18:53 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:07:38 +0200

sched: Change cfs_rq load avg to unsigned long

Since the 'u64 runnable_load_avg, blocked_load_avg' in cfs_rq struct are
smaller than 'unsigned long' cfs_rq->load.weight. We don't need u64
vaiables to describe them. unsigned long is more efficient and convenience.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Paul Turner <pjt@google.com>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371694737-29336-10-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index 7948bb8..f19772d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4181,12 +4181,9 @@ static int tg_load_down(struct task_group *tg, void *data)
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
index 9c65d46..9eb12d9 100644
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
 
