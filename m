Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab3APFww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 00:52:52 -0500
Received: from mga14.intel.com ([143.182.124.37]:28634 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab3APFwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 00:52:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,476,1355126400"; 
   d="scan'208";a="191644929"
Message-ID: <50F6406E.6000506@intel.com>
Date: Wed, 16 Jan 2013 13:53:50 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 15/22] sched: log the cpu utilization at rq
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-16-git-send-email-alex.shi@intel.com> <20130110114044.GE2046@e103034-lin> <50EF8756.6050309@intel.com> <20130114135912.GA8502@e103034-lin>
In-Reply-To: <20130114135912.GA8502@e103034-lin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 09:59 PM, Morten Rasmussen wrote:
> On Fri, Jan 11, 2013 at 03:30:30AM +0000, Alex Shi wrote:
>> On 01/10/2013 07:40 PM, Morten Rasmussen wrote:
>>>>>  #undef P64
>>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>>> index ee015b8..7bfbd69 100644
>>>>> --- a/kernel/sched/fair.c
>>>>> +++ b/kernel/sched/fair.c
>>>>> @@ -1495,8 +1495,12 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
>>>>>  
>>>>>  static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
>>>>>  {
>>>>> +	u32 period;
>>>>>  	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
>>>>>  	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
>>>>> +
>>>>> +	period = rq->avg.runnable_avg_period ? rq->avg.runnable_avg_period : 1;
>>>>> +	rq->util = rq->avg.runnable_avg_sum * 100 / period;
>>> The existing tg->runnable_avg and cfs_rq->tg_runnable_contrib variables
>>> both holds
>>> rq->avg.runnable_avg_sum / rq->avg.runnable_avg_period scaled by
>>> NICE_0_LOAD (1024). Why not use one of the existing variables instead of
>>> introducing a new one?
>>
>> we want to a rq variable that reflect the utilization of the cpu, not of
>> the tg
> 
> It is the same thing for the root tg. You use exactly the same variables
> for calculating rq->util as is used to calculate both tg->runnable_avg and
> cfs_rq->tg_runnable_contrib in __update_tg_runnable_avg(). The only
> difference is that you scale by 100 while __update_tg_runnable_avg()
> scale by NICE_0_LOAD.

yes, the root tg->runnable_avg has same meaningful, but normal tg not,
and more important it is hidden by CONFIG_FAIR_GROUP_SCHED,
