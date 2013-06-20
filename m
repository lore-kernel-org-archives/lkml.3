Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935431Ab3FTAek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 20:34:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:35246 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934835Ab3FTAej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 20:34:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,900,1363158000"; 
   d="scan'208";a="332445298"
Message-ID: <51C24DE8.1010102@intel.com>
Date: Thu, 20 Jun 2013 08:33:44 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [patch v8 6/9] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-7-git-send-email-alex.shi@intel.com> <CAPM31RKwNUh+nNcsEftD4pyP+gdwXhRK7wCRNWa8Y0sE0hf-DQ@mail.gmail.com> <CAPM31R+DBFt1wr10GCGEHDW_J_-79imdTCYEBF7YiKdFc1V7iQ@mail.gmail.com> <51BF15C4.1090906@intel.com> <CAPM31RKHtEYsNV+kzxFpH=55dLaFn1jcQcWD4qYAdHrW_xN+8A@mail.gmail.com> <51BFD787.5020708@intel.com> <51C02C03.8090501@intel.com> <51C168BA.8090403@intel.com>
In-Reply-To: <51C168BA.8090403@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 04:15 PM, Alex Shi wrote:
> On 06/18/2013 05:44 PM, Alex Shi wrote:
>>
>>>
>>> Paul, could I summary your point here:
>>> keep current weighted_cpu_load, but add blocked load avg in
>>> get_rq_runnable_load?
>>>
>>> I will test this change.
>>
>> Current testing(kbuild, oltp, aim7) don't show clear different on my NHM EP box
>> between the following and the origin patch, 
>> the only different is get_rq_runnable_load added blocked_load_avg. in SMP
>> will test more cases and more box.
> 
> I tested the tip/sched/core, tip/sched/core with old patchset and
> tip/schec/core with the blocked_load_avg on Core2 2S, NHM EP, IVB EP,
> SNB EP 2S and SNB EP 4S box, with benchmark kbuild, sysbench oltp,
> hackbench, tbench, dbench.
> 
> blocked_load_avg VS origin patchset, oltp has suspicious 5% and
> hackbench has 3% drop on NHM EX; dbench has suspicious 6% drop on NHM
> EP. other benchmarks has no clear change on all other machines.
> 
> origin patchset VS sched/core, hackbench rise 20% on NHM EX, 60% on SNB
> EP 4S, and 30% on IVB EP. others no clear changes.
> 

>> +#ifdef CONFIG_SMP
>> +unsigned long get_rq_runnable_load(struct rq *rq)
>> +{
>> +	return rq->cfs.runnable_load_avg + rq->cfs.blocked_load_avg;

According to above testing result, with blocked_load_avg is still a
slight worse than without it.

when the blocked_load_avg added here, it will impact nohz idle balance
and periodic balance in update_sg_lb_stats() when the idx is not 0.
As to nohz idle balance, blocked_load_avg should be too small to have
big effect.
As to in update_sg_lb_stats(), since it only works when _idx is not 0,
that means the blocked_load_avg was decay again in update_cpu_load. That
reduce its impact.

So, could I say, at least in above testing, blocked_load_avg should be
keep away from balance?


-- 
Thanks
    Alex
