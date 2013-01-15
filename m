Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab3AOCd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 21:33:26 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:36213 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab3AOCdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 21:33:24 -0500
Message-ID: <50F4BFE5.7030504@linux.vnet.ibm.com>
Date: Tue, 15 Jan 2013 10:33:09 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 1/2] sched: schedule balance map foundation
References: <50EFCA29.8020801@linux.vnet.ibm.com> <50EFCAA7.8080302@linux.vnet.ibm.com> <87libwnpa7.fsf@sejong.aot.lge.com>
In-Reply-To: <87libwnpa7.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011502-2674-0000-0000-0000077617A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Namhyung

Thanks for your reply.

On 01/14/2013 04:26 PM, Namhyung Kim wrote:
> Hi Michael,
> 

[snip]

>> +	while (sd) {
>> +		if (sd->flags & SD_LOAD_BALANCE) {
>> +			if (sd->flags & SD_BALANCE_EXEC) {
>> +				sbm->top_level[SBM_EXEC_TYPE] = sd->level;
>> +				sbm->sd[SBM_EXEC_TYPE][sd->level] = sd;
>> +			}
>> +
>> +			if (sd->flags & SD_BALANCE_FORK) {
>> +				sbm->top_level[SBM_FORK_TYPE] = sd->level;
>> +				sbm->sd[SBM_FORK_TYPE][sd->level] = sd;
>> +			}
>> +
>> +			if (sd->flags & SD_BALANCE_WAKE) {
>> +				sbm->top_level[SBM_WAKE_TYPE] = sd->level;
>> +				sbm->sd[SBM_WAKE_TYPE][sd->level] = sd;
>> +			}
>> +
>> +			if (sd->flags & SD_WAKE_AFFINE) {
>> +				for_each_cpu(i, sched_domain_span(sd)) {
>> +					if (!sbm->affine_map[i])
>> +						sbm->affine_map[i] = sd;
>> +				}
>> +			}
>> +		}
>> +		sd = sd->parent;
>> +	}
> 
> It seems that it can be done like:
> 
> 	for_each_domain(cpu, sd) {
> 		if (!(sd->flags & SD_LOAD_BALANCE))
>                 	continue;
> 
> 		if (sd->flags & SD_BALANCE_EXEC)
> 		...
> 	}
> 
> 

That's right, will correct it.

>> +
>> +	/*
>> +	 * fill the hole to get lower level sd easily.
>> +	 */
>> +	for (type = 0; type < SBM_MAX_TYPE; type++) {
>> +		level = sbm->top_level[type];
>> +		top_sd = sbm->sd[type][level];
>> +		if ((++level != SBM_MAX_LEVEL) && top_sd) {
>> +			for (; level < SBM_MAX_LEVEL; level++)
>> +				sbm->sd[type][level] = top_sd;
>> +		}
>> +	}
>> +}
> [snip]
>> +#ifdef CONFIG_SCHED_SMT
>> +#define SBM_MAX_LEVEL	4
>> +#else
>> +#ifdef CONFIG_SCHED_MC
>> +#define SBM_MAX_LEVEL	3
>> +#else
>> +#ifdef CONFIG_SCHED_BOOK
>> +#define SBM_MAX_LEVEL	2
>> +#else
>> +#define SBM_MAX_LEVEL	1
>> +#endif
>> +#endif
>> +#endif
> 
> Looks like this fixed level constants does not consider NUMA domains.
> Doesn't accessing sbm->sd[type][level] in the above while loop cause a
> problem on big NUMA machines?

Yes, that's true, this patch is based on 3.7.0-rc6 without NUMA merged,
in order to make the topic a little easier to be started, I will
consider about the NUMA thing in next version, and please let me know if
you have any suggestions.

Regards,
Michael Wang

> 
> Thanks,
> Namhyung
> 
>> +
>> +enum {
>> +	SBM_EXEC_TYPE,
>> +	SBM_FORK_TYPE,
>> +	SBM_WAKE_TYPE,
>> +	SBM_MAX_TYPE
>> +};
>> +
>> +struct sched_balance_map {
>> +	struct sched_domain *sd[SBM_MAX_TYPE][SBM_MAX_LEVEL];
>> +	int top_level[SBM_MAX_TYPE];
>> +	struct sched_domain *affine_map[NR_CPUS];
>> +};
>> +
>>  #endif /* CONFIG_SMP */
>>  
>>  /*
>> @@ -403,6 +430,7 @@ struct rq {
>>  #ifdef CONFIG_SMP
>>  	struct root_domain *rd;
>>  	struct sched_domain *sd;
>> +	struct sched_balance_map *sbm;
>>  
>>  	unsigned long cpu_power;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

