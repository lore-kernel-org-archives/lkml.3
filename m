Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3FEF1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 01:27:06 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:33044 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3FEF1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 01:27:03 -0400
Message-ID: <51AECC1A.9060400@linux.vnet.ibm.com>
Date: Wed, 05 Jun 2013 13:26:50 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: mingo@redhat.com, peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 1/2] sched: Optimize build_sched_domains() for saving
 first SD node for a cpu
References: <d226c91fed3dfa2dca644d14c88b1d1ff9d2e722.1370344689.git.viresh.kumar@linaro.org> <51AEC1C3.1040804@linux.vnet.ibm.com> <CAKohpokGrgFOtOT6Y3e4MOJBUQWT4FG4Mk-F6_M0V-pEEf3KYw@mail.gmail.com>
In-Reply-To: <CAKohpokGrgFOtOT6Y3e4MOJBUQWT4FG4Mk-F6_M0V-pEEf3KYw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060516-3568-0000-0000-000003B8B73F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 01:07 PM, Viresh Kumar wrote:
> On 5 June 2013 10:12, Michael Wang <wangyun@linux.vnet.ibm.com> wrote:
>> Hi, Viresh
>>
>> On 06/04/2013 07:20 PM, Viresh Kumar wrote:
>> [snip]
>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>> index 58453b8..638f6cb 100644
>>> --- a/kernel/sched/core.c
>>> +++ b/kernel/sched/core.c
>>> @@ -6533,16 +6533,13 @@ static int build_sched_domains(const struct cpumask *cpu_map,
>>>               sd = NULL;
>>>               for (tl = sched_domain_topology; tl->init; tl++) {
>>>                       sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
>>> +                     if (!*per_cpu_ptr(d.sd, i))
>>
>> What about:
>>                         if (tl == sched_domain_topology)
>>
>> It cost less than per_cpu_ptr(), isn't it?
> 
> How can I miss it.. Obviously its better :)
> 
> See if below one looks better (Attached too in case gmail screws up
> my mail)..

Looks good to me :)

Regards,
Michael Wang

> 
> --------x-------------x------------------
> 
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Tue, 4 Jun 2013 15:41:15 +0530
> Subject: [PATCH] sched: Optimize build_sched_domains() for saving first SD
>  node for a cpu
> 
> We are saving first scheduling domain for a cpu in build_sched_domains() by
> iterating over the nested sd->child list. We don't actually need to do it this
> way.
> 
> tl will be equal to sched_domain_topology for the first iteration and so we can
> set *per_cpu_ptr(d.sd, i) based on that.  So, save pointer to first SD while
> running the iteration loop over tl's.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/sched/core.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 58453b8..08a27be 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6533,16 +6533,13 @@ static int build_sched_domains(const struct
> cpumask *cpu_map,
>  		sd = NULL;
>  		for (tl = sched_domain_topology; tl->init; tl++) {
>  			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
> +			if (tl == sched_domain_topology)
> +				*per_cpu_ptr(d.sd, i) = sd;
>  			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
>  				sd->flags |= SD_OVERLAP;
>  			if (cpumask_equal(cpu_map, sched_domain_span(sd)))
>  				break;
>  		}
> -
> -		while (sd->child)
> -			sd = sd->child;
> -
> -		*per_cpu_ptr(d.sd, i) = sd;
>  	}
> 
>  	/* Build the groups for the domains */
> 

