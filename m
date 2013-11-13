Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116Ab3KMR1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:27:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52953 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758871Ab3KMR04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:26:56 -0500
Date: Wed, 13 Nov 2013 09:26:10 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-90d3839b90fe379557dae4a44735a6af78f42885@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        axboe@kernel.dk, peterz@infradead.org, vgoyal@redhat.com,
        john.stultz@linaro.org, tglx@linutronix.de, fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, peterz@infradead.org, vgoyal@redhat.com,
        john.stultz@linaro.org, tglx@linutronix.de, fengguang.wu@intel.com
In-Reply-To: <1384314134-6895-1-git-send-email-john.stultz@linaro.org>
References: <1384314134-6895-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] block: Use u64_stats_init()
  to initialize seqcounts
Git-Commit-ID: 90d3839b90fe379557dae4a44735a6af78f42885
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 13 Nov 2013 09:26:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90d3839b90fe379557dae4a44735a6af78f42885
Gitweb:     http://git.kernel.org/tip/90d3839b90fe379557dae4a44735a6af78f42885
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 12 Nov 2013 19:42:14 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Nov 2013 13:54:08 +0100

block: Use u64_stats_init() to initialize seqcounts

Now that seqcounts are lockdep enabled objects, we need to explicitly
initialize runtime allocated seqcounts so that lockdep can track them.

Without this patch, Fengguang was seeing:

  [    4.127282] INFO: trying to register non-static key.
  [    4.128027] the code is fine but needs lockdep annotation.
  [    4.128027] turning off the locking correctness validator.
  [    4.128027] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-next-20131108-10601-gbad570d #2
  [    4.128027] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  [    ...     ]
  [    4.128027] Call Trace:
  [    4.128027]  [<7908e744>] ? console_unlock+0x353/0x380
  [    4.128027]  [<79dc7cf2>] dump_stack+0x48/0x60
  [    4.128027]  [<7908953e>] __lock_acquire.isra.26+0x7e3/0xceb
  [    4.128027]  [<7908a1c5>] lock_acquire+0x71/0x9a
  [    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
  [    4.128027]  [<7940658b>] throtl_update_dispatch_stats+0x7c/0x153
  [    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
  [    4.128027]  [<794079aa>] blk_throtl_bio+0x1c3/0x485
  ...

Use u64_stats_init() for all affected data structures, which initializes
the seqcount.

Reported-and-Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
[ Folded in another fix from the mailing list as well as a fix to that fix. Tweaked commit message. ]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1384314134-6895-1-git-send-email-john.stultz@linaro.org
[ So I actually think that the two SOBs from PeterZ are the right depiction of the patch route. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 block/blk-cgroup.h   | 10 ++++++++++
 block/blk-throttle.c | 10 ++++++++++
 block/cfq-iosched.c  | 25 +++++++++++++++++++++++++
 3 files changed, 45 insertions(+)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index ae6969a..1610b22 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -402,6 +402,11 @@ struct request_list *__blk_queue_next_rl(struct request_list *rl,
 #define blk_queue_for_each_rl(rl, q)	\
 	for ((rl) = &(q)->root_rl; (rl); (rl) = __blk_queue_next_rl((rl), (q)))
 
+static inline void blkg_stat_init(struct blkg_stat *stat)
+{
+	u64_stats_init(&stat->syncp);
+}
+
 /**
  * blkg_stat_add - add a value to a blkg_stat
  * @stat: target blkg_stat
@@ -458,6 +463,11 @@ static inline void blkg_stat_merge(struct blkg_stat *to, struct blkg_stat *from)
 	blkg_stat_add(to, blkg_stat_read(from));
 }
 
+static inline void blkg_rwstat_init(struct blkg_rwstat *rwstat)
+{
+	u64_stats_init(&rwstat->syncp);
+}
+
 /**
  * blkg_rwstat_add - add a value to a blkg_rwstat
  * @rwstat: target blkg_rwstat
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8331aba..0653404 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -256,6 +256,12 @@ static struct throtl_data *sq_to_td(struct throtl_service_queue *sq)
 	}								\
 } while (0)
 
+static void tg_stats_init(struct tg_stats_cpu *tg_stats)
+{
+	blkg_rwstat_init(&tg_stats->service_bytes);
+	blkg_rwstat_init(&tg_stats->serviced);
+}
+
 /*
  * Worker for allocating per cpu stat for tgs. This is scheduled on the
  * system_wq once there are some groups on the alloc_list waiting for
@@ -269,12 +275,16 @@ static void tg_stats_alloc_fn(struct work_struct *work)
 
 alloc_stats:
 	if (!stats_cpu) {
+		int cpu;
+
 		stats_cpu = alloc_percpu(struct tg_stats_cpu);
 		if (!stats_cpu) {
 			/* allocation failed, try again after some time */
 			schedule_delayed_work(dwork, msecs_to_jiffies(10));
 			return;
 		}
+		for_each_possible_cpu(cpu)
+			tg_stats_init(per_cpu_ptr(stats_cpu, cpu));
 	}
 
 	spin_lock_irq(&tg_stats_alloc_lock);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 434944c..4d5cec1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1508,6 +1508,29 @@ static void cfq_init_cfqg_base(struct cfq_group *cfqg)
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
+static void cfqg_stats_init(struct cfqg_stats *stats)
+{
+	blkg_rwstat_init(&stats->service_bytes);
+	blkg_rwstat_init(&stats->serviced);
+	blkg_rwstat_init(&stats->merged);
+	blkg_rwstat_init(&stats->service_time);
+	blkg_rwstat_init(&stats->wait_time);
+	blkg_rwstat_init(&stats->queued);
+
+	blkg_stat_init(&stats->sectors);
+	blkg_stat_init(&stats->time);
+
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+	blkg_stat_init(&stats->unaccounted_time);
+	blkg_stat_init(&stats->avg_queue_size_sum);
+	blkg_stat_init(&stats->avg_queue_size_samples);
+	blkg_stat_init(&stats->dequeue);
+	blkg_stat_init(&stats->group_wait_time);
+	blkg_stat_init(&stats->idle_time);
+	blkg_stat_init(&stats->empty_time);
+#endif
+}
+
 static void cfq_pd_init(struct blkcg_gq *blkg)
 {
 	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
@@ -1515,6 +1538,8 @@ static void cfq_pd_init(struct blkcg_gq *blkg)
 	cfq_init_cfqg_base(cfqg);
 	cfqg->weight = blkg->blkcg->cfq_weight;
 	cfqg->leaf_weight = blkg->blkcg->cfq_leaf_weight;
+	cfqg_stats_init(&cfqg->stats);
+	cfqg_stats_init(&cfqg->dead_stats);
 }
 
 static void cfq_pd_offline(struct blkcg_gq *blkg)
