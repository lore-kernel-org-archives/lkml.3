Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaBXHsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:48:09 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:54589 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaBXHsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:48:06 -0500
Message-ID: <530AF7E4.5080806@linux.vnet.ibm.com>
Date: Mon, 24 Feb 2014 13:12:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] cpufreq: Set policy to non-NULL only after all hotplug
 online work is done
References: <1393225072-3997-1-git-send-email-skannan@codeaurora.org>
In-Reply-To: <1393225072-3997-1-git-send-email-skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022407-2674-0000-0000-00000CDCC004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 12:27 PM, Saravana Kannan wrote:
> The existing code sets the per CPU policy to a non-NULL value before all
> the steps performed during the hotplug online path is done. Specifically,
> this is done before the policy min/max, governors, etc are initialized for
> the policy.  This in turn means that calls to cpufreq_cpu_get() return a
> non-NULL policy before the policy/CPU is ready to be used.
> 
> To fix this, move the update of per CPU policy to a valid value after all
> the initialization steps for the policy are completed.
> 
> Example kernel panic without this fix:
> [  512.146185] Unable to handle kernel NULL pointer dereference at virtual address 00000020
> [  512.146195] pgd = c0003000
> [  512.146213] [00000020] *pgd=80000000004003, *pmd=00000000
> [  512.146228] Internal error: Oops: 206 [#1] PREEMPT SMP ARM
> <snip>
> [  512.146297] PC is at __cpufreq_governor+0x10/0x1ac
> [  512.146312] LR is at cpufreq_update_policy+0x114/0x150
> <snip>
> [  512.149740] ---[ end trace f23a8defea6cd706 ]---
> [  512.149761] Kernel panic - not syncing: Fatal exception
> [  513.152016] CPU0: stopping
> [  513.154710] CPU: 0 PID: 7136 Comm: mpdecision Tainted: G      D W    3.10.0-gd727407-00074-g979ede8 #396
> <snip>
> [  513.317224] [<c0afe180>] (notifier_call_chain+0x40/0x68) from [<c02a23ac>] (__blocking_notifier_call_chain+0x40/0x58)
> [  513.327809] [<c02a23ac>] (__blocking_notifier_call_chain+0x40/0x58) from [<c02a23d8>] (blocking_notifier_call_chain+0x14/0x1c)
> [  513.339182] [<c02a23d8>] (blocking_notifier_call_chain+0x14/0x1c) from [<c0803c68>] (cpufreq_set_policy+0xd4/0x2b8)
> [  513.349594] [<c0803c68>] (cpufreq_set_policy+0xd4/0x2b8) from [<c0803e7c>] (cpufreq_init_policy+0x30/0x98)
> [  513.359231] [<c0803e7c>] (cpufreq_init_policy+0x30/0x98) from [<c0805a18>] (__cpufreq_add_dev.isra.17+0x4dc/0x7a4)
> [  513.369560] [<c0805a18>] (__cpufreq_add_dev.isra.17+0x4dc/0x7a4) from [<c0805d38>] (cpufreq_cpu_callback+0x58/0x84)
> [  513.379978] [<c0805d38>] (cpufreq_cpu_callback+0x58/0x84) from [<c0afe180>] (notifier_call_chain+0x40/0x68)
> [  513.389704] [<c0afe180>] (notifier_call_chain+0x40/0x68) from [<c02812dc>] (__cpu_notify+0x28/0x44)
> [  513.398728] [<c02812dc>] (__cpu_notify+0x28/0x44) from [<c0aeed90>] (_cpu_up+0xf4/0x1dc)
> [  513.406797] [<c0aeed90>] (_cpu_up+0xf4/0x1dc) from [<c0aeeed4>] (cpu_up+0x5c/0x78)
> [  513.414357] [<c0aeeed4>] (cpu_up+0x5c/0x78) from [<c0aec808>] (store_online+0x44/0x74)
> [  513.422253] [<c0aec808>] (store_online+0x44/0x74) from [<c03a40f4>] (sysfs_write_file+0x108/0x14c)
> [  513.431195] [<c03a40f4>] (sysfs_write_file+0x108/0x14c) from [<c03517d4>] (vfs_write+0xd0/0x180)
> [  513.439958] [<c03517d4>] (vfs_write+0xd0/0x180) from [<c0351ca8>] (SyS_write+0x38/0x68)
> [  513.447947] [<c0351ca8>] (SyS_write+0x38/0x68) from [<c0205de0>] (ret_fast_syscall+0x0/0x30)
> 
> In this specific case, CPU0 set's CPU1's policy->governor in
> cpufreq_init_policy() to NULL while CPU1 is using the policy->governor in
> __cpufreq_governor().
> 

Whoa! That's horrible! Can you please explain how exactly you
triggered this? I'm curious...

> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>  drivers/cpufreq/cpufreq.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index cb003a6..d5ceb43 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1109,11 +1109,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>  		goto err_set_policy_cpu;
>  	}
> 
> -	write_lock_irqsave(&cpufreq_driver_lock, flags);
> -	for_each_cpu(j, policy->cpus)
> -		per_cpu(cpufreq_cpu_data, j) = policy;
> -	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> -
>  	if (cpufreq_driver->get) {
>  		policy->cur = cpufreq_driver->get(policy->cpu);

If you move the per-cpu init further down, then what happens to the
cpufreq_generic_get() that gets invoked here by some of the drivers?
It will almost always fail (because policy will be NULL) and hence
CPU online will be unsuccessful (though you wont observe it because
the error code is not bubbled up to the CPU hotplug core; perhaps we
should).


IMHO, we should fix the synchronization in cpufreq_init_policy().
I notice cpufreq_update_policy() as well as __cpufreq_governor() in
your stack trace, which means cpufreq_set_policy() was involved.
cpufreq_update_policy() takes the policy->rwsem for write, whereas
cpufreq_init_policy() doesn't take that lock at all, which is clearly
wrong.

My guess is that, if we fix that locking, everything will be fine and
you won't hit the bug. Would you like to give that a shot?

Regards,
Srivatsa S. Bhat

>  		if (!policy->cur) {
> @@ -1207,6 +1202,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>  		policy->user_policy.governor = policy->governor;
>  	}
> 
> +	write_lock_irqsave(&cpufreq_driver_lock, flags);
> +	for_each_cpu(j, policy->cpus)
> +		per_cpu(cpufreq_cpu_data, j) = policy;
> +	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +
>  	kobject_uevent(&policy->kobj, KOBJ_ADD);
>  	up_read(&cpufreq_rwsem);
> 


