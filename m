Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab3EGFoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:44:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:54240 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab3EGFoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:44:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,625,1363158000"; 
   d="scan'208";a="309358215"
Message-ID: <51889498.8090409@intel.com>
Date: Tue, 07 May 2013 13:43:52 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Paul Turner <pjt@google.com>, Michael Wang <wangyun@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v5 7/7] sched: consider runnable load average in effective_load
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-8-git-send-email-alex.shi@intel.com> <518724D1.9040006@linux.vnet.ibm.com> <51874229.8050202@intel.com> <5187609C.5050209@linux.vnet.ibm.com> <518763B0.30200@intel.com> <51876AFE.80906@linux.vnet.ibm.com> <CAPM31RK-N=Cnt3cBo1f6er6TewQJKY+fgdj9QHvKziHe+TxTxw@mail.gmail.com> <51877970.8010303@intel.com> <51877EF8.20504@linux.vnet.ibm.com>
In-Reply-To: <51877EF8.20504@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 05:59 PM, Preeti U Murthy wrote:
> Suggestion1: Would change the CPU share calculation to use runnable load
> average all the time.
> 
> Suggestion2: Did opposite of point 2 above,it used runnable load average
> while calculating the CPU share *before* a new task has been woken up
> while it retaining the instantaneous weight to calculate the CPU share
> after a new task could be woken up.
> 
> So since there was no uniformity in the calculation of CPU shares in
> approaches 2 and 3, I think it caused a regression. However I still
> don't understand how approach 4-Suggestion2 made that go away although
> there was non-uniformity in the CPU shares calculation.
> 
> But as Paul says we could retain the usage of instantaneous loads
> wherever there is calculation of CPU shares for the reason he mentioned
> and leave effective_load() and calc_cfs_shares() untouched.
> 
> This also brings forth another question,should we modify wake_affine()
> to pass the runnable load average of the waking up task to effective_load().
> 
> What do you think?

I am not Paul. :)

The acceptable patch of pgbench attached. In fact, since effective_load is mixed 
with direct load and tg's runnable load. the patch looks no much sense.
So, I am going to agree to drop it if there is no performance benefit on my benchmarks.

---

>From f58519a8de3cebb7a865c9911c00dce5f1dd87f2 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Fri, 3 May 2013 13:29:04 +0800
Subject: [PATCH 7/7] sched: consider runnable load average in effective_load

effective_load calculates the load change as seen from the
root_task_group. It needs to engage the runnable average
of changed task.

Thanks for Morten Rasmussen and PeterZ's reminder of this.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ca0e051..b683909 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2980,15 +2980,15 @@ static void task_waking_fair(struct task_struct *p)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /*
- * effective_load() calculates the load change as seen from the root_task_group
+ * effective_load() calculates load avg change as seen from the root_task_group
  *
  * Adding load to a group doesn't make a group heavier, but can cause movement
  * of group shares between cpus. Assuming the shares were perfectly aligned one
  * can calculate the shift in shares.
  *
- * Calculate the effective load difference if @wl is added (subtracted) to @tg
- * on this @cpu and results in a total addition (subtraction) of @wg to the
- * total group weight.
+ * Calculate the effective load avg difference if @wl is added (subtracted) to
+ * @tg on this @cpu and results in a total addition (subtraction) of @wg to the
+ * total group load avg.
  *
  * Given a runqueue weight distribution (rw_i) we can compute a shares
  * distribution (s_i) using:
@@ -3002,7 +3002,7 @@ static void task_waking_fair(struct task_struct *p)
  *   rw_i = {   2,   4,   1,   0 }
  *   s_i  = { 2/7, 4/7, 1/7,   0 }
  *
- * As per wake_affine() we're interested in the load of two CPUs (the CPU the
+ * As per wake_affine() we're interested in load avg of two CPUs (the CPU the
  * task used to run on and the CPU the waker is running on), we need to
  * compute the effect of waking a task on either CPU and, in case of a sync
  * wakeup, compute the effect of the current task going to sleep.
@@ -3012,20 +3012,20 @@ static void task_waking_fair(struct task_struct *p)
  *
  *   s'_i = (rw_i + @wl) / (@wg + \Sum rw_j)				(2)
  *
- * Suppose we're interested in CPUs 0 and 1, and want to compute the load
+ * Suppose we're interested in CPUs 0 and 1, and want to compute the load avg
  * differences in waking a task to CPU 0. The additional task changes the
  * weight and shares distributions like:
  *
  *   rw'_i = {   3,   4,   1,   0 }
  *   s'_i  = { 3/8, 4/8, 1/8,   0 }
  *
- * We can then compute the difference in effective weight by using:
+ * We can then compute the difference in effective load avg by using:
  *
  *   dw_i = S * (s'_i - s_i)						(3)
  *
  * Where 'S' is the group weight as seen by its parent.
  *
- * Therefore the effective change in loads on CPU 0 would be 5/56 (3/8 - 2/7)
+ * Therefore the effective change in load avg on CPU 0 would be 5/56 (3/8 - 2/7)
  * times the weight of the group. The effect on CPU 1 would be -4/56 (4/8 -
  * 4/7) times the weight of the group.
  */
@@ -3070,7 +3070,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		/*
 		 * wl = dw_i = S * (s'_i - s_i); see (3)
 		 */
-		wl -= se->load.weight;
+		wl -= se->avg.load_avg_contrib;
 
 		/*
 		 * Recursively apply this logic to all parent groups to compute
@@ -3116,14 +3116,14 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 */
 	if (sync) {
 		tg = task_group(current);
-		weight = current->se.load.weight;
+		weight = current->se.avg.load_avg_contrib;
 
 		this_load += effective_load(tg, this_cpu, -weight, -weight);
 		load += effective_load(tg, prev_cpu, 0, -weight);
 	}
 
 	tg = task_group(p);
-	weight = p->se.load.weight;
+	weight = p->se.avg.load_avg_contrib;
 
 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
-- 
1.7.12

-- 
Thanks
    Alex
