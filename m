Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934544Ab3EGCnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:43:21 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52541 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934528Ab3EGCnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:43:17 -0400
Message-ID: <51886A39.2090708@linux.vnet.ibm.com>
Date: Tue, 07 May 2013 10:43:05 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v5 7/7] sched: consider runnable load average in effective_load
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-8-git-send-email-alex.shi@intel.com> <518724D1.9040006@linux.vnet.ibm.com> <51874229.8050202@intel.com> <5187609C.5050209@linux.vnet.ibm.com> <518763B0.30200@intel.com> <51876AFE.80906@linux.vnet.ibm.com> <CAPM31RK-N=Cnt3cBo1f6er6TewQJKY+fgdj9QHvKziHe+TxTxw@mail.gmail.com> <51877970.8010303@intel.com> <51877EF8.20504@linux.vnet.ibm.com>
In-Reply-To: <51877EF8.20504@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050702-2674-0000-0000-000008DBB65C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 05:59 PM, Preeti U Murthy wrote:
> On 05/06/2013 03:05 PM, Alex Shi wrote:
>> On 05/06/2013 05:06 PM, Paul Turner wrote:
>>> I don't think this is a good idea:
>>>
>>> The problem with not using the instantaneous weight here is that you
>>> potentially penalize the latency of interactive tasks (similarly,
>>> potentially important background threads -- e.g. garbage collection).
>>>
>>> Counter-intuitively we actually want such tasks on the least loaded
>>> cpus to minimize their latency.  If the load they contribute ever
>>> becomes more substantial we trust that periodic balance will start
>>> taking notice of them.
>>
>> Sounds reasonable. Many thanks for your input, Paul!
>>
>> So, will use the seconds try. :)
>>>
>>> [ This is similar to why we have to use the instantaneous weight in
>>> calc_cfs_shares. ]
>>>
>>
>>
> 
> Yes thank you very much for the inputs Paul :)
> 
> So Alex, Michael looks like this is what happened.
> 
> 1. The effective_load() as it is, uses instantaneous loads to calculate
> the CPU shares before and after a new task can be woken up on the given cpu.
> 
> 2. With my patch, I modified it to use runnable load average while
> calculating the CPU share *after* a new task could be woken up and
> retained instantaneous load to calculate the CPU share before a new task
> could be woken up.
> 
> 3. With the first patch of Alex, he has used runnable load average while
> calculating the CPU share both before and after a new task could be
> woken up on the given CPU.
> 
> 4.The suggestions that Alex gave:
> 
> Suggestion1: Would change the CPU share calculation to use runnable load
> average all the time.
> 
> Suggestion2: Did opposite of point 2 above,it used runnable load average
> while calculating the CPU share *before* a new task has been woken up
> while it retaining the instantaneous weight to calculate the CPU share
> after a new task could be woken up.
> 
> So since there was no uniformity in the calculation of CPU shares in
> approaches 2 and 3, I think it caused a regression. However I still
> don't understand how approach 4-Suggestion2 made that go away although
> there was non-uniformity in the CPU shares calculation.
> 
> But as Paul says we could retain the usage of instantaneous loads
> wherever there is calculation of CPU shares for the reason he mentioned
> and leave effective_load() and calc_cfs_shares() untouched.
> 
> This also brings forth another question,should we modify wake_affine()
> to pass the runnable load average of the waking up task to effective_load().
> 
> What do you think?

I would suggest we don't touch that dark corner...unless it damaged some
benchmark, AFAIK, pgbench is the only one could be influenced, and all
those approach won't make things better than patch 1~6 only...

Regards,
Michael Wang

> 
> 
> Thanks
> 
> Regards
> Preeti U Murthy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

