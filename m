Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab3IPQ1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:27:10 -0400
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:40234 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab3IPQ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:27:09 -0400
Message-ID: <1379348823.3422.42.camel@linaro1.home>
Subject: Re: [PATCH 1/2] cpufreq: unlock correct rwsem while updating
 policy->cpu
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Mon, 16 Sep 2013 17:27:03 +0100
In-Reply-To: <075032be4fd288074b8f699d4f4ba0179518df6f.1379344038.git.viresh.kumar@linaro.org>
References: <075032be4fd288074b8f699d4f4ba0179518df6f.1379344038.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 20:40 +0530, Viresh Kumar wrote:
> Current code looks like this:
> 
>         WARN_ON(lock_policy_rwsem_write(cpu));
>         update_policy_cpu(policy, new_cpu);
>         unlock_policy_rwsem_write(cpu);
> 
> {lock|unlock}_policy_rwsem_write(cpu) takes/releases policy->cpu's rwsem.
> Because cpu is changing with the call to update_policy_cpu(), the
> unlock_policy_rwsem_write() will release the incorrect lock.
> 
> The right solution would be to take rwsem lock/unlock for both old and new cpu.

I thought possibly something like that, then wondered if threads could
take the locks in different orders at the same time, leading to
deadlock? So as I wasn't familiar with cpufreq I thought I'd leave it to
the experts to worry about :-)

This patch contains a bug, see inline comment below. Even with that
fixed it still doesn't work for me. I get a lockdep warning (below). I
have verified the cpu and locks are different locks, and it's not a
harmless false positive because I later get the message 'cpufreq:
__cpufreq_remove_dev_prepare: Failed to stop governor'.

=============================================
[ INFO: possible recursive locking detected ]
3.11.0+ #4 Not tainted
---------------------------------------------
swapper/0/1 is trying to acquire lock:
  (&per_cpu(cpu_policy_rwsem, cpu)){+.+...}, at: [<c0293c03>] update_policy_cpu+0x53/0xa4

but task is already holding lock:
  (&per_cpu(cpu_policy_rwsem, cpu)){+.+...}, at: [<c0293bef>] update_policy_cpu+0x3f/0xa4
other info that might help us debug this:
  Possible unsafe locking scenario:
        CPU0
        ----
   lock(&per_cpu(cpu_policy_rwsem, cpu));
   lock(&per_cpu(cpu_policy_rwsem, cpu));

*** DEADLOCK ***

  May be due to missing lock nesting notation
4 locks held by swapper/0/1:
 #0:  (bL_switcher_activation_lock){+.+.+.}, at: [<c0019b03>] bL_switcher_enable+0x17/0x2d8
 #1:  ((bL_activation_notifier).rwsem){.+.+.+}, at: [<c00370bd>] __blocking_notifier_call_chain+0x1d/0x40
 #2:  (subsys mutex#6){+.+.+.}, at: [<c023279d>] subsys_interface_unregister+0x1d/0x68
 #3:  (&per_cpu(cpu_policy_rwsem, cpu)){+.+...}, at: [<c0293bef>] update_policy_cpu+0x3f/0xa4

> This patch fixes this bug by taking both locks directly instead of calling
> lock_policy_rwsem_write().
> 
> Reported-by: Jon Medhurst<tixy@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Hi Rafael,
> 
> Probably we can get this patch in for 3.12? The second one can go in 3.13.
> 
> These are compile tested only at my end. Tixy reported these and probably can
> give his tested-by once he is done testing them.
> 
>  drivers/cpufreq/cpufreq.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
If I take mainline code and just change the line above to:
   up_write(&per_cpu(cpu_policy_rwsem, (per_cpu(cpufreq_cpu_data,
cpu))->last_cpu));
then the big_little cpufreq driver works for me.

> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 43c24aa..c18bf7b 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -952,9 +952,16 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
>  	if (cpu == policy->cpu)
>  		return;
>  
> +	/* take direct locks as lock_policy_rwsem_write wouldn't work here */
> +	down_write(&per_cpu(cpu_policy_rwsem, policy->cpu));
> +	down_write(&per_cpu(cpu_policy_rwsem, cpu));
> +
>  	policy->last_cpu = policy->cpu;
>  	policy->cpu = cpu;
>  
> +	up_write(&per_cpu(cpu_policy_rwsem, cpu));
> +	up_write(&per_cpu(cpu_policy_rwsem, policy->cpu));

You've just overwritten policy->cpu with cpu. I tried using
policy->last_cpu to fix that, but it still doesn't work for me (giving
the lockdep warning I mentioned.) If I change the code to just lock the
original policy->cpu lock only, then all is fine.

Also, this locking is now just happening around policy->cpu update,
whereas before this change, it was locked for the whole of
update_policy_cpu, i.e. cpufreq_frequency_table_update_policy_cpu and
the notifier callbacks. Is that change of lock coverage OK?

> +
>  #ifdef CONFIG_CPU_FREQ_TABLE
>  	cpufreq_frequency_table_update_policy_cpu(policy);
>  #endif
> @@ -1203,9 +1210,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>  
>  		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu, frozen);
>  		if (new_cpu >= 0) {
> -			WARN_ON(lock_policy_rwsem_write(cpu));
>  			update_policy_cpu(policy, new_cpu);
> -			unlock_policy_rwsem_write(cpu);
>  
>  			if (!frozen) {
>  				pr_debug("%s: policy Kobject moved to cpu: %d "

-- 
Tixy

