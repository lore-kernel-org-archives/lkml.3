Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3FXJIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:08:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:60618 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab3FXJIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:08:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,927,1363158000"; 
   d="scan'208";a="259247293"
Message-ID: <51C80C33.4050606@intel.com>
Date: Mon, 24 Jun 2013 17:06:59 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [Resend patch v8 06/13] sched: compute runnable load avg in cpu_load
 and cpu_avg_load_per_task
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com> <1371694737-29336-7-git-send-email-alex.shi@intel.com>
In-Reply-To: <1371694737-29336-7-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 10:18 AM, Alex Shi wrote:
> They are the base values in load balance, update them with rq runnable
> load average, then the load balance will consider runnable load avg
> naturally.
> 
> We also try to include the blocked_load_avg as cpu load in balancing,
> but that cause kbuild performance drop 6% on every Intel machine, and
> aim7/oltp drop on some of 4 CPU sockets machines.
> Or only add blocked_load_avg into get_rq_runable_load, hackbench still
> drop a little on NHM EX.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>


I am sorry for still having some swing on cfs and rt task load consideration. 
So give extra RFC patch to consider RT load in balance.
With or without this patch, my test result has no change, since there is no 
much RT tasks in my testing.

I am not familiar with RT scheduler, just rely on PeterZ who is experts on this. :)

---

>From b9ed5363b0a579a87256b589278c8c66500c7db3 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 24 Jun 2013 16:12:29 +0800
Subject: [PATCH 08/16] sched: recover to whole rq load include rt tasks'

patch 'sched: compute runnable load avg in cpu_load and
cpu_avg_load_per_task' weight rq's load on cfs.runnable_load_avg instead
of rq->load.weight. That is fine when system has no much RT load.

But if there are lots of RT load on rq, that code will just
weight the cfs tasks in load balance without consideration of RT, that
may cause load imbalance if much RT load isn't imbalanced among cpu.
Using rq->avg.load_avg_contrib can resolve this problem and keep the 
advantages from runnable load balance.

BTW, this patch may increase the balance failed times, if move_tasks can
not balance loads between CPUs, like there is only RT load in CPUs.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 4 ++--
 kernel/sched/proc.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 37a5720..6979906 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2968,7 +2968,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->cfs.runnable_load_avg;
+	return cpu_rq(cpu)->avg.load_avg_contrib;
 }
 
 /*
@@ -3013,7 +3013,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
-	unsigned long load_avg = rq->cfs.runnable_load_avg;
+	unsigned long load_avg = rq->avg.load_avg_contrib;
 
 	if (nr_running)
 		return load_avg / nr_running;
diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index ce5cd48..4f2490c 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -504,7 +504,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 #ifdef CONFIG_SMP
 unsigned long get_rq_runnable_load(struct rq *rq)
 {
-	return rq->cfs.runnable_load_avg;
+	return rq->avg.load_avg_contrib;
 }
 #else
 unsigned long get_rq_runnable_load(struct rq *rq)
-- 
1.7.12


