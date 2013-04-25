Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab3DYAOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 20:14:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41438 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758495Ab3DYAOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 20:14:12 -0400
Message-ID: <5178754E.2020709@gmail.com>
Date: Thu, 25 Apr 2013 08:14:06 +0800
From: Will Huck <will.huckk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mgorman@suse.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a sysctl for numa_balancing.
References: <1366847784-29386-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1366847784-29386-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 07:56 AM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> As discussed earlier, this adds a working sysctl to enable/disable
> automatic numa memory balancing at runtime.
>
> This was possible earlier through debugfs, but only with special
> debugging options set. Also fix the boot message.

One offline question.

If I configure uma to fake numa, is there benefit or downside?

>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>   Documentation/sysctl/kernel.txt |   10 ++++++++++
>   include/linux/sched/sysctl.h    |    4 ++++
>   kernel/sched/core.c             |   24 +++++++++++++++++++++++-
>   kernel/sysctl.c                 |   11 +++++++++++
>   mm/mempolicy.c                  |    2 +-
>   5 files changed, 49 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index ccd4258..17a7004 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -354,6 +354,16 @@ utilize.
>   
>   ==============================================================
>   
> +numa_balancing
> +
> +Enables/disables automatic page fault based NUMA memory
> +balancing. Memory is moved automatically to nodes
> +that access it often.
> +
> +TBD someone document the other numa_balancing tunables
> +
> +==============================================================
> +
>   osrelease, ostype & version:
>   
>   # cat osrelease
> diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
> index bf8086b..e228a1b 100644
> --- a/include/linux/sched/sysctl.h
> +++ b/include/linux/sched/sysctl.h
> @@ -101,4 +101,8 @@ extern int sched_rt_handler(struct ctl_table *table, int write,
>   		void __user *buffer, size_t *lenp,
>   		loff_t *ppos);
>   
> +extern int sched_numa_balancing(struct ctl_table *table, int write,
> +				 void __user *buffer, size_t *lenp,
> +				 loff_t *ppos);
> +
>   #endif /* _SCHED_SYSCTL_H */
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 67d0465..679be74 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1614,7 +1614,29 @@ void set_numabalancing_state(bool enabled)
>   	numabalancing_enabled = enabled;
>   }
>   #endif /* CONFIG_SCHED_DEBUG */
> -#endif /* CONFIG_NUMA_BALANCING */
> +
> +#ifdef CONFIG_PROC_SYSCTL
> +int sched_numa_balancing(struct ctl_table *table, int write,
> +			 void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct ctl_table t;
> +	int err;
> +	int state = numabalancing_enabled;
> +
> +	if (write && !capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	t = *table;
> +	t.data = &state;
> +	err = proc_dointvec_minmax(&t, write, buffer, lenp, ppos);
> +	if (err < 0)
> +		return err;
> +	if (write)
> +		set_numabalancing_state(state);
> +	return err;
> +}
> +#endif
> +#endif
>   
>   /*
>    * fork()/clone()-time setup:
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index afc1dc6..94164ac 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -393,6 +393,17 @@ static struct ctl_table kern_table[] = {
>   		.mode		= 0644,
>   		.proc_handler	= proc_dointvec,
>   	},
> +	{
> +		.procname	= "numa_balancing",
> +		.data		= NULL, /* filled in by handler */
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= sched_numa_balancing,
> +		.extra1		= &zero,
> +		.extra2		= &one,
> +	},
> +
> +
>   #endif /* CONFIG_NUMA_BALANCING */
>   #endif /* CONFIG_SCHED_DEBUG */
>   	{
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 7431001..7eee646 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2531,7 +2531,7 @@ static void __init check_numabalancing_enable(void)
>   
>   	if (nr_node_ids > 1 && !numabalancing_override) {
>   		printk(KERN_INFO "Enabling automatic NUMA balancing. "
> -			"Configure with numa_balancing= or sysctl");
> +			"Configure with numa_balancing= or the kernel.numa_balancing sysctl");
>   		set_numabalancing_state(numabalancing_default);
>   	}
>   }

