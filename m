Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaFZJI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:08:57 -0400
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:44489 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaFZJIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:08:53 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <53ABE30F.7000404@jp.fujitsu.com>
Date: Thu, 26 Jun 2014 18:08:31 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 1/8] cputime, sched: record last_iowait
References: <53ABE28F.6010402@jp.fujitsu.com>
In-Reply-To: <53ABE28F.6010402@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record the timestamp when nr_iowait of idle cpu is dropped to 0 by
running cpu who pick a task which have call io_schedule() before
entering idle.

It is the time point that cpu's state have changed from "iowait"
to "idle". Following patch use it for updated idle accounting.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Not-Tested-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 kernel/sched/core.c    |   40 ++++++++++++++++++++++++++++------------
 kernel/sched/cputime.c |    2 +-
 kernel/sched/sched.h   |    4 +++-
 3 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3bdf01b..e759238 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2374,15 +2374,14 @@ unsigned long nr_iowait(void)
 	unsigned long i, sum = 0;
 
 	for_each_possible_cpu(i)
-		sum += atomic_read(&cpu_rq(i)->nr_iowait);
+		sum += cpu_rq(i)->nr_iowait;
 
 	return sum;
 }
 
 unsigned long nr_iowait_cpu(int cpu)
 {
-	struct rq *this = cpu_rq(cpu);
-	return atomic_read(&this->nr_iowait);
+	return cpu_rq(cpu)->nr_iowait;
 }
 
 #ifdef CONFIG_SMP
@@ -4305,6 +4304,24 @@ out_irq:
 }
 EXPORT_SYMBOL_GPL(yield_to);
 
+static inline void iowait_start(struct rq *rq)
+{
+	raw_spin_lock(&rq->iowait_lock);
+	rq->nr_iowait++;
+	raw_spin_unlock(&rq->iowait_lock);
+	current->in_iowait = 1;
+}
+
+static inline void iowait_stop(struct rq *rq)
+{
+	current->in_iowait = 0;
+	raw_spin_lock(&rq->iowait_lock);
+	rq->nr_iowait--;
+	if (!rq->nr_iowait && rq != this_rq())
+		rq->last_iowait = ktime_get();
+	raw_spin_unlock(&rq->iowait_lock);
+}
+
 /*
  * This task is about to go to sleep on IO. Increment rq->nr_iowait so
  * that process accounting knows that this is a task in IO wait state.
@@ -4314,12 +4331,10 @@ void __sched io_schedule(void)
 	struct rq *rq = raw_rq();
 
 	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
+	iowait_start(rq);
 	blk_flush_plug(current);
-	current->in_iowait = 1;
 	schedule();
-	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
+	iowait_stop(rq);
 	delayacct_blkio_end();
 }
 EXPORT_SYMBOL(io_schedule);
@@ -4330,12 +4345,10 @@ long __sched io_schedule_timeout(long timeout)
 	long ret;
 
 	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
+	iowait_start(rq);
 	blk_flush_plug(current);
-	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
-	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
+	iowait_stop(rq);
 	delayacct_blkio_end();
 	return ret;
 }
@@ -6994,7 +7007,10 @@ void __init sched_init(void)
 #endif
 #endif
 		init_rq_hrtick(rq);
-		atomic_set(&rq->nr_iowait, 0);
+
+		raw_spin_lock_init(&rq->iowait_lock);
+		rq->nr_iowait = 0;
+		rq->last_iowait = ktime_get();
 	}
 
 	set_load_weight(&init_task);
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 72fdf06..a028604 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -248,7 +248,7 @@ void account_idle_time(cputime_t cputime)
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	struct rq *rq = this_rq();
 
-	if (atomic_read(&rq->nr_iowait) > 0)
+	if (rq->nr_iowait > 0)
 		cpustat[CPUTIME_IOWAIT] += (__force u64) cputime;
 	else
 		cpustat[CPUTIME_IDLE] += (__force u64) cputime;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 31cc02e..4ddfddc 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -561,7 +561,9 @@ struct rq {
 	u64 clock;
 	u64 clock_task;
 
-	atomic_t nr_iowait;
+	raw_spinlock_t	iowait_lock ____cacheline_aligned;
+	unsigned int	nr_iowait;
+	ktime_t		last_iowait;
 
 #ifdef CONFIG_SMP
 	struct root_domain *rd;
-- 
1.7.1


