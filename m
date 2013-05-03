Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762677Ab3ECHka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 03:40:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:17348 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762512Ab3ECHk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 03:40:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,602,1363158000"; 
   d="scan'208";a="296971082"
Message-ID: <518369B4.9030200@intel.com>
Date: Fri, 03 May 2013 15:39:32 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [PATCH v4 6/6] sched: consider runnable load average in effective_load
References: <1367040344-14485-1-git-send-email-alex.shi@intel.com> <1367040344-14485-7-git-send-email-alex.shi@intel.com> <20130502131954.GH13837@dyad.programming.kicks-ass.net>
In-Reply-To: <20130502131954.GH13837@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 09:19 PM, Peter Zijlstra wrote:
> 
> I'm fairly sure this is wrong; but I haven't bothered to take pencil to paper.
> 
> I think you'll need to insert the runnable avg load and make sure
> effective_load() uses the right sums itself.

Thanks for comment! 
I changed it to the following patch for further review. 
a quick testing show hackbench still keep the improvement.

Will resent a new version to include all changes. :)

---

>From 2f6491807226a30e01b9afa21d80e42e7cbb5678 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Fri, 3 May 2013 13:29:04 +0800
Subject: [PATCH 7/8] sched: consider runnable load average in effective_load

effective_load calculates the load change as seen from the
root_task_group. It needs to engage the runnable average
of changed task.

Thanks for Morten Rasmussen and PeterZ's reminder of this.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 790e23d..6f4f14b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2976,15 +2976,15 @@ static void task_waking_fair(struct task_struct *p)
 
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
@@ -2998,7 +2998,7 @@ static void task_waking_fair(struct task_struct *p)
  *   rw_i = {   2,   4,   1,   0 }
  *   s_i  = { 2/7, 4/7, 1/7,   0 }
  *
- * As per wake_affine() we're interested in the load of two CPUs (the CPU the
+ * As per wake_affine() we're interested in load avg of two CPUs (the CPU the
  * task used to run on and the CPU the waker is running on), we need to
  * compute the effect of waking a task on either CPU and, in case of a sync
  * wakeup, compute the effect of the current task going to sleep.
@@ -3008,20 +3008,20 @@ static void task_waking_fair(struct task_struct *p)
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
@@ -3045,7 +3045,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		/*
 		 * w = rw_i + @wl
 		 */
-		w = se->my_q->load.weight + wl;
+		w = se->my_q->tg_load_contrib + wl;
 
 		/*
 		 * wl = S * s'_i; see (2)
@@ -3066,7 +3066,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		/*
 		 * wl = dw_i = S * (s'_i - s_i); see (3)
 		 */
-		wl -= se->load.weight;
+		wl -= se->avg.load_avg_contrib;
 
 		/*
 		 * Recursively apply this logic to all parent groups to compute
@@ -3112,14 +3112,14 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
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
