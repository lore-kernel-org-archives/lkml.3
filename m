Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab3DAJwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:52:35 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40767 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab3DAJwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:52:34 -0400
Message-ID: <51595876.7030502@linux.vnet.ibm.com>
Date: Mon, 01 Apr 2013 15:20:46 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v6 12/21] sched: add power aware scheduling in fork/exec/wake
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com> <1364654108-16307-13-git-send-email-alex.shi@intel.com>
In-Reply-To: <1364654108-16307-13-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040109-5490-0000-0000-00000334A97B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

The below patch has an issue in the select_task_rq_fair(), which I have mentioned in 
the fix for it below.

On 03/30/2013 08:04 PM, Alex Shi wrote:
> This patch add power aware scheduling in fork/exec/wake. It try to
> select cpu from the busiest while still has utilization group. That's
> will save power since it leaves more groups idle in system.
> 
> The trade off is adding a power aware statistics collection in group
> seeking. But since the collection just happened in power scheduling
> eligible condition, the worst case of hackbench testing just drops
> about 2% with powersaving policy. No clear change for performance
> policy.
> 
> The main function in this patch is get_cpu_for_power_policy(), that
> will try to get a idlest cpu from the busiest while still has
> utilization group, if the system is using power aware policy and
> has such group.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 109 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 103 insertions(+), 6 deletions(-)
+/*
> + * select_task_rq_fair: balance the current task (running on cpu) in domains
>   * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
>   * SD_BALANCE_EXEC.
>   *
> - * Balance, ie. select the least loaded group.
> - *
>   * Returns the target CPU number, or the same CPU if no balancing is needed.
>   *
>   * preempt must be disabled.
>   */
>  static int
> -select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
> +select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
>  {
>  	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
>  	int cpu = smp_processor_id();
>  	int prev_cpu = task_cpu(p);
>  	int new_cpu = cpu;
>  	int want_affine = 0;
> -	int sync = wake_flags & WF_SYNC;
> +	int sync = flags & WF_SYNC;
> +	struct sd_lb_stats sds;
> 
>  	if (p->nr_cpus_allowed == 1)
>  		return prev_cpu;
> @@ -3412,11 +3500,20 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  			break;
>  		}
> 
> -		if (tmp->flags & sd_flag)
> +		if (tmp->flags & sd_flag) {
>  			sd = tmp;
> +
> +			new_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds);
> +			if (new_cpu != -1)
> +				goto unlock;
> +		}
>  	}
> 
>  	if (affine_sd) {
> +		new_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds);
> +		if (new_cpu != -1)
> +			goto unlock;
> +
>  		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
>  			prev_cpu = cpu;
> 


sched: Fix power aware scheduling in fork/wake/exec

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Problem:

select_task_rq_fair() returns a target CPU/ waking CPU if no balancing is
required. However with the current power aware scheduling in this path, an
invalid CPU might be returned.

If get_cpu_for_power_policy() fails to find a new_cpu for the forked task,
then there is a possibility that the new_cpu could continue to be -1, till
the end of the select_task_rq_fair() if the search for a new cpu ahead in
this function also fails. Since this scenario is unexpected by
the callers of  select_task_rq_fair(),this needs to be fixed.

Fix:

Do not intermix the variables meant to reflect the target CPU of power save
and performance policies. If the target CPU of powersave is successful in being
found, return it. Else allow the performance policy to take a call on the
target CPU.

The above scenario was caught when a kernel crash resulted with a bad data access
interrupt, during a kernbench run on a 2 socket,16 core machine,with each core
having SMT-4
---
 kernel/sched/fair.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 56b96a7..54d4400 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3532,6 +3532,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
+	int new_cpu_for_power = -1;
 	int want_affine = 0;
 	int sync = flags & WF_SYNC;
 	struct sd_lb_stats sds;
@@ -3563,16 +3564,16 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 		if (tmp->flags & sd_flag) {
 			sd = tmp;
 
-			new_cpu = get_cpu_for_power_policy(sd, cpu, p, &sds,
+			new_cpu_for_power = get_cpu_for_power_policy(sd, cpu, p, &sds,
 						flags & SD_BALANCE_FORK);
-			if (new_cpu != -1)
+			if (new_cpu_for_power != -1)
 				goto unlock;
 		}
 	}
 
 	if (affine_sd) {
-		new_cpu = get_cpu_for_power_policy(affine_sd, cpu, p, &sds, 0);
-		if (new_cpu != -1)
+		new_cpu_for_power = get_cpu_for_power_policy(affine_sd, cpu, p, &sds, 0);
+		if (new_cpu_for_power != -1)
 			goto unlock;
 
 		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
@@ -3622,8 +3623,10 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 	}
 unlock:
 	rcu_read_unlock();
+	if (new_cpu_for_power == -1)
+                return new_cpu;
 
-	return new_cpu;
+	return new_cpu_for_power;
 }
 
 /*

Regards
Preeti U Murthy

