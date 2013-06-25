Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab3FYNN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:13:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:31178 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab3FYNNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:13:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,936,1363158000"; 
   d="scan'208";a="322276687"
Message-ID: <51C9976B.7060602@intel.com>
Date: Tue, 25 Jun 2013 21:13:15 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz,
        Clark Williams <clark.williams@gmail.com>, tony.luck@intel.com,
        keescook@chromium.org, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [Resend patch v8 0/13] use runnable load in schedule balance
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com> <51C7B9B8.6090309@intel.com> <CAPM31RKq4sVR2_mU8PWx8dK+STQDj3Geyi8dVg3MnL=ymjfV6Q@mail.gmail.com> <51C867CF.70908@intel.com>
In-Reply-To: <51C867CF.70908@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 11:37 PM, Alex Shi wrote:
> On 06/24/2013 06:40 PM, Paul Turner wrote:
>>>> Ingo & Peter,
>>>>
>>>> This patchset was discussed spread and deeply.
>>>>
>>>> Now just 6th/8th patch has some arguments on them, Paul think it is
>>>> better to consider blocked_load_avg in balance, since it is helpful on
>>>> some scenarios, but I think on most of scenarios, the blocked_load_avg
>>>> just cause load imbalance among cpus. and plus testing show with
>>>> blocked_load_avg the performance is just worse on some benchmarks. So, I
>>>> still prefer to keep it out of balance.
>> I think you have perhaps misunderstood what I was trying to explain.
>>
>> I have no problems with not including blocked load in load-balance, in
>> fact, I encouraged not accumulating it in an average of averages in
>> CPU load.
>>
> 
> Many thanks for re-clarification!
>> The problem is that your current approach has removed it both from
>> load-balance _and_ from shares distribution; isolation matters as much
>> as performance in the cgroup case (otherwise you would just not use
>> cgroups).  I would expect the latter to have quite negative effects on
>> fairness, this is my primary concern.
>>
> 
> So the argument is just on patch 'sched/tg: remove blocked_load_avg in balance'. :)
> 
> I understand your correctness concern. but blocked_load_avg still will be decayed to zero in few hundreds ms. So such correctness needs just in few hundreds ms. (and cause performance drop)
> The blocked_load_avg is decayed on same degree as runnable load, it is a bit overweight since task slept. since it may will be waken up on other cpu. So to relieve this overweight, could we use the half or a quarter weight of blocked_load_avg? like following:
> 

Ping to Paul!

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index ddbc19f..395f57c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1358,7 +1358,7 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
>  	struct task_group *tg = cfs_rq->tg;
>  	s64 tg_contrib;
>  
> -	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
> +	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg / 2;
>  	tg_contrib -= cfs_rq->tg_load_contrib;
>  
>  	if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
> 
>>>>
>>>> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg455196.html
>>>>
>>>> Is it the time to do the decision or give more comments? Thanks!
> 
> 


-- 
Thanks
    Alex
