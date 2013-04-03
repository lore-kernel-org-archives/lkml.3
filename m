Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762166Ab3DCGWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:22:39 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56338 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760485Ab3DCGWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:22:38 -0400
Message-ID: <515BCA94.6050703@linux.vnet.ibm.com>
Date: Wed, 03 Apr 2013 14:22:12 +0800
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
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <515A9859.6000606@intel.com> <515B97FF.2040409@linux.vnet.ibm.com> <515B9A7A.6030807@intel.com> <515BA0B7.2090906@linux.vnet.ibm.com> <515BAFE6.1020804@intel.com>
In-Reply-To: <515BAFE6.1020804@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040306-0260-0000-0000-000002C13E89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 12:28 PM, Alex Shi wrote:
> On 04/03/2013 11:23 AM, Michael Wang wrote:
>> On 04/03/2013 10:56 AM, Alex Shi wrote:
>>> On 04/03/2013 10:46 AM, Michael Wang wrote:
[snip]
> 
> 
> From 4722a7567dccfb19aa5afbb49982ffb6d65e6ae5 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Tue, 2 Apr 2013 10:27:45 +0800
> Subject: [PATCH] sched: use instant load for burst wake up
> 
> If many tasks sleep long time, their runnable load are zero. And if they
> are waked up bursty, too light runnable load causes big imbalance among
> CPU. So such benchmark, like aim9 drop 5~7%.
> 
> With this patch the losing is covered, and even is slight better.

A fast test show the improvement disappear and the regression back
again...after applied this one as the 8th patch, it doesn't works.

Regards,
Michael Wang

> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index dbaa8ca..25ac437 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3103,12 +3103,24 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  	unsigned long weight;
>  	int balanced;
>  	int runnable_avg;
> +	int burst = 0;
> 
>  	idx	  = sd->wake_idx;
>  	this_cpu  = smp_processor_id();
>  	prev_cpu  = task_cpu(p);
> -	load	  = source_load(prev_cpu, idx);
> -	this_load = target_load(this_cpu, idx);
> +
> +	if (cpu_rq(this_cpu)->avg_idle < sysctl_sched_migration_cost ||
> +		cpu_rq(prev_cpu)->avg_idle < sysctl_sched_migration_cost)
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
> 

