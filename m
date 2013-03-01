Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab3CACTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 21:19:03 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:41500 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab3CACTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 21:19:00 -0500
Message-ID: <5130100A.1090400@linux.vnet.ibm.com>
Date: Fri, 01 Mar 2013 10:18:50 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] sched: wakeup buddy
References: <512EFB4B.5040204@linux.vnet.ibm.com> <87hakwssc9.fsf@sejong.aot.lge.com>
In-Reply-To: <87hakwssc9.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030102-1396-0000-0000-0000029B51E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Namhyung

Thanks for your reply.

On 02/28/2013 05:25 PM, Namhyung Kim wrote:
[snip]
>> Thus, if B is also the wakeup buddy of A, which means no other task has
>> destroyed their relationship, then A is likely to benefit from the cached
>> data of B, make them running closely is likely to gain benefit.
> 
> Not sure if it should require bidirectional relationship.  Looks like
> just for benchmarks.  Isn't there a one-way relationship that could get
> a benefit from this?  I don't know ;-)

That's one point :)

Actually I have tried the one-way case at very beginning, the
performance is not good.

I think it was caused by that if A lost interesting on B and walking
with C, then make A and B closely won't gain so many benefit, since the
cached data of A is likely to benefit C not B now.

> 
> Few nitpicks below..
> 
>>
>> This patch add the feature wakeup buddy, reorganized the logical of
>> wake_affine() stuff with the new feature, by doing these, pgbench and
>> 'perf bench sched pipe' perform better.
>>
>> Highlight:
>> 	Default value of sysctl_sched_wakeup_buddy_ref is 8 temporarily,
>> 	please let me know if some number perform better on your system,
>> 	I'd like to make it bigger to make the decision more carefully,
>> 	so we could provide the solution when it is really needed.
>>
>> 	Comments are very welcomed.
>>
>> Test:
>> 	Test with a 12 cpu X86 server and tip 3.8.0-rc7.
>>
>> 	'perf bench sched pipe' show nearly double improvement.
>>
>> 	pgbench result:
>> 					prev	post
>>
>>                 | db_size | clients |  tps  |   |  tps  |
>>                 +---------+---------+-------+   +-------+
>>                 | 22 MB   |       1 | 10794 |   | 10820 |
>>                 | 22 MB   |       2 | 21567 |   | 21915 |
>>                 | 22 MB   |       4 | 41621 |   | 42766 |
>>                 | 22 MB   |       8 | 53883 |   | 60511 |       +12.30%
>>                 | 22 MB   |      12 | 50818 |   | 57129 |       +12.42%
>>                 | 22 MB   |      16 | 50463 |   | 59345 |       +17.60%
>>                 | 22 MB   |      24 | 46698 |   | 63787 |       +36.59%
>>                 | 22 MB   |      32 | 43404 |   | 62643 |       +44.33%
>>
>>                 | 7484 MB |       1 |  7974 |   |  8014 |
>>                 | 7484 MB |       2 | 19341 |   | 19534 |
>>                 | 7484 MB |       4 | 36808 |   | 38092 |
>>                 | 7484 MB |       8 | 47821 |   | 51968 |       +8.67%
>>                 | 7484 MB |      12 | 45913 |   | 52284 |       +13.88%
>>                 | 7484 MB |      16 | 46478 |   | 54418 |       +17.08%
>>                 | 7484 MB |      24 | 42793 |   | 56375 |       +31.74%
>>                 | 7484 MB |      32 | 36329 |   | 55783 |       +53.55%
>>                 
>>                 | 15 GB   |       1 |  7636 |   |  7880 |       
>>                 | 15 GB   |       2 | 19195 |   | 19477 |
>>                 | 15 GB   |       4 | 35975 |   | 37962 |
>>                 | 15 GB   |       8 | 47919 |   | 51558 |       +7.59%
>>                 | 15 GB   |      12 | 45397 |   | 51163 |       +12.70%
>>                 | 15 GB   |      16 | 45926 |   | 53912 |       +17.39%
>>                 | 15 GB   |      24 | 42184 |   | 55343 |       +31.19%
>>                 | 15 GB   |      32 | 35983 |   | 55358 |       +53.84%
>>
>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
>> ---
> [SNIP]
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 81fa536..d5acfd8 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -3173,6 +3173,75 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>>  }
>>  
>>  /*
>> + * Reduce sysctl_sched_wakeup_buddy_ref will reduce the preparation time
>> + * to active the wakeup buddy feature, and make it agile, however, this
>> + * will increase the risk of misidentify.
>> + *
>> + * Check wakeup_buddy() for the usage.
>> + */
>> +unsigned int sysctl_sched_wakeup_buddy_ref = 8UL;
> 
> It seems that just 8U (or even 8) is enough.

I will correct it.

> 
>> +
>> +/*
>> + * wakeup_buddy() help to check whether p1 is the wakeup buddy of p2.
>> + *
>> + * Return 1 for yes, 0 for no.
>> +*/
>> +static inline int wakeup_buddy(struct task_struct *p1, struct task_struct *p2)
>> +{
>> +	if (p1->waker != p2 || p1->wakee != p2)
>> +		return 0;
>> +
>> +	if (p1->waker_ref < sysctl_sched_wakeup_buddy_ref)
>> +		return 0;
>> +
>> +	if (p1->wakee_ref < sysctl_sched_wakeup_buddy_ref)
>> +		return 0;
>> +
>> +	return 1;
>> +}
> [SNIP]
>> @@ -3399,6 +3490,8 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>>  unlock:
>>  	rcu_read_unlock();
>>  
>> +	wakeup_ref(p);
>> +
> 
> Why did you call it here?  Shouldn't it be on somewhere in the ttwu?

I'd like to put the changes closely, just another 'bad' habit ;-)

But you notified me that I should add a check on WAKEUP flag, will
correct it.

Regards,
Michael Wang

> 
> 
>>  	return new_cpu;
>>  }
>>  
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index c88878d..6845d24 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -424,6 +424,16 @@ static struct ctl_table kern_table[] = {
>>  		.extra1		= &one,
>>  	},
>>  #endif
>> +#ifdef CONFIG_SMP
>> +	{
>> +		.procname	= "sched_wakeup_buddy_ref",
>> +		.data		= &sysctl_sched_wakeup_buddy_ref,
>> +		.maxlen		= sizeof(unsigned int),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec_minmax,
>> +		.extra1		= &one,
>> +	},
>> +#endif
>>  #ifdef CONFIG_PROVE_LOCKING
>>  	{
>>  		.procname	= "prove_locking",
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

