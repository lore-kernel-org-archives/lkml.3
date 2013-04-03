Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980Ab3DCHTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:19:11 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38427 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762967Ab3DCHTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:19:09 -0400
Message-ID: <515BD7DB.6020602@linux.vnet.ibm.com>
Date: Wed, 03 Apr 2013 15:18:51 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
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
Subject: Re: [patch v3 0/8] sched: use runnable avg in load balance
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <515A9859.6000606@intel.com> <515B97FF.2040409@linux.vnet.ibm.com> <515B9A7A.6030807@intel.com> <515BA0B7.2090906@linux.vnet.ibm.com> <515BAFE6.1020804@intel.com> <515BCA94.6050703@linux.vnet.ibm.com> <515BD1FE.7030901@intel.com>
In-Reply-To: <515BD1FE.7030901@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040307-0260-0000-0000-000002C14E79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 02:53 PM, Alex Shi wrote:
> On 04/03/2013 02:22 PM, Michael Wang wrote:
>>>>
>>>> If many tasks sleep long time, their runnable load are zero. And if they
>>>> are waked up bursty, too light runnable load causes big imbalance among
>>>> CPU. So such benchmark, like aim9 drop 5~7%.
>>>>
>>>> With this patch the losing is covered, and even is slight better.
>> A fast test show the improvement disappear and the regression back
>> again...after applied this one as the 8th patch, it doesn't works.
> 
> It always is good for on benchmark and bad for another. :)

That's right :)

> 
> the following patch include the renamed knob, and you can tune it under 
> /proc/sys/kernel/... to see detailed impact degree.

Could I make the conclusion that the improvement on pgbench was caused
by the new weighted_cpuload()?

The burst branch seems to just adopt the load in old world, if reduce
the rate to enter that branch could regain the benefit, then I could
confirm my supposition.

> 
> +	if (cpu_rq(this_cpu)->avg_idle < sysctl_sched_migration_cost ||
> +		cpu_rq(prev_cpu)->avg_idle < sysctl_sched_migration_cost)

It should be 'sysctl_sched_burst_threshold' here, isn't it? anyway, I
will take a try with different rate.

Regards,
Michael Wang


> +		burst= 1;
> +
> +	/* use instant load for bursty waking up */
> +	if (!burst) {
> +		load = source_load(prev_cpu, idx);
> +		this_load = target_load(this_cpu, idx);
> +	} else {
> +		load = cpu_rq(prev_cpu)->load.weight;
> +		this_load = cpu_rq(this_cpu)->load.weight;
> +	}
> 
>  	/*
>  	 * If sync wakeup then subtract the (maximum possible)
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index afc1dc6..1f23457 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -327,6 +327,13 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= proc_dointvec,
>  	},
>  	{
> +		.procname	= "sched_burst_threshold_ns",
> +		.data		= &sysctl_sched_burst_threshold,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},
> +	{
>  		.procname	= "sched_nr_migrate",
>  		.data		= &sysctl_sched_nr_migrate,
>  		.maxlen		= sizeof(unsigned int),
> 

