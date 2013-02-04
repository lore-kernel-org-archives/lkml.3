Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab3BDS0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:26:14 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:64026 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab3BDS0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:26:10 -0500
Date: Mon, 4 Feb 2013 19:26:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20130204182604.GA12964@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: cff3c124a7e82ca0ea1d6864b27ef18c403c0773 sched/debug: Fix format string for 32-bit platforms

Three small fixlets.

 Thanks,

	Ingo

------------------>
Arnd Bergmann (2):
      sched: Fix warning in kernel/sched/fair.c
      sched/debug: Fix format string for 32-bit platforms

Shawn Bohrer (1):
      sched/rt: Use root_domain of rt_rq not current processor


 kernel/sched/debug.c | 4 ++--
 kernel/sched/fair.c  | 2 +-
 kernel/sched/rt.c    | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 2cd3c1b..7ae4c4c 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -222,8 +222,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			cfs_rq->runnable_load_avg);
 	SEQ_printf(m, "  .%-30s: %lld\n", "blocked_load_avg",
 			cfs_rq->blocked_load_avg);
-	SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
-			atomic64_read(&cfs_rq->tg->load_avg));
+	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_avg",
+			(unsigned long long)atomic64_read(&cfs_rq->tg->load_avg));
 	SEQ_printf(m, "  .%-30s: %lld\n", "tg_load_contrib",
 			cfs_rq->tg_load_contrib);
 	SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..81fa536 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2663,7 +2663,7 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
 
-static void unthrottle_offline_cfs_rqs(struct rq *rq)
+static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 {
 	struct cfs_rq *cfs_rq;
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..4f02b28 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -566,7 +566,7 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 static int do_balance_runtime(struct rt_rq *rt_rq)
 {
 	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
+	struct root_domain *rd = rq_of_rt_rq(rt_rq)->rd;
 	int i, weight, more = 0;
 	u64 rt_period;
 
