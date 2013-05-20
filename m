Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3ETBCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 21:02:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:59808 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab3ETBCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 21:02:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,704,1363158000"; 
   d="scan'208";a="304906452"
Message-ID: <519975F5.20400@intel.com>
Date: Mon, 20 May 2013 09:01:41 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com> <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com> <20130412162348.GE2368@pd.tnic>	 <1365785311.5814.36.camel@marge.simpson.net> <516F19EE.5060309@kernel.org>	 <1366989087.30242.11.camel@marge.simpson.net> <1367298972.4616.41.camel@marge.simpson.net> <1367310625.4616.71.camel@marge.simpson.net> <20130430084135.GA21473@gmail.com> <1367314539.4616.88.camel@marge.simpson.net> <1367315380.4616.91.camel@marge.simpson.net> <1367315763.4616.93.camel@marge.simpson.net> <5195E4F9.60908@linux.vnet.ibm.com>
In-Reply-To: <5195E4F9.60908@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>>> Which are the workloads where 'powersaving' mode hurts workload 
>>>>> performance measurably?
> 
> I ran ebizzy on a 2 socket, 16 core, SMT 4 Power machine.

Is this a 2 * 16 * 4 LCPUs PowerPC machine?
> The power efficiency drops significantly with the powersaving policy of
> this patch,over the power efficiency of the scheduler without this patch.
> 
> The below parameters are measured relative to the default scheduler
> behaviour.
> 
> A: Drop in power efficiency with the patch+powersaving policy
> B: Drop in performance with the patch+powersaving policy
> C: Decrease in power consumption with the patch+powersaving policy
> 
> NumThreads      A            B         C
> -----------------------------------------
> 2               33%         36%       4%
> 4               31%         33%       3%
> 8               28%         30%       3%
> 16              31%         33%       4%
> 
> Each of the above run is for 30s.
> 
> On investigating socket utilization,I found that only 1 socket was being
> used during all the above threaded runs. As can be guessed this is due
> to the group_weight being considered for the threshold metric.
> This stacks up tasks on a core and further on a socket, thus throttling
> them, as observed by Mike below.
> 
> I therefore think we must switch to group_capacity as the metric for
> threshold and use only (rq->utils*nr_running) for group_utils
> calculation during non-bursty wakeup scenarios.
> This way we are comparing right; the utilization of the runqueue by the
> fair tasks and the cpu capacity available for them after being consumed
> by the rt tasks.
> 
> After I made the above modification,all the above three parameters came
> to be nearly null. However, I am observing the load balancing of the
> scheduler with the patch and powersavings policy enabled. It is behaving
> very close to the default scheduler (spreading tasks across sockets).
> That also explains why there is no performance drop or gain with the
> patch+powersavings policy enabled. I will look into this observation and
> revert.

Thanks a lot for the great testings!
Seem tasks per SMT cpu isn't power efficient.
And I got the similar result last week. I tested the fspin testing(do
endless calculation, in linux-next tree.). when I bind task per SMT cpu,
the power efficiency really dropped with most every threads number. but
when bind task per core, it has better power efficiency on all threads.
Beside to move task depend on group_capacity, another choice is balance
task according cpu_power. I did the transfer in code. but need to go
through a internal open source process before public them.
> 
>>>>
>>>> Well, it'll lose throughput any time there's parallel execution
>>>> potential but it's serialized instead.. using average will inevitably
>>>> stack tasks sometimes, but that's its goal.  Hackbench shows it.
>>>
>>> (but that consolidation can be a winner too, and I bet a nickle it would
>>> be for a socket sized pgbench run)
>>
>> (belay that, was thinking of keeping all tasks on a single node, but
>> it'll likely stack the whole thing on a CPU or two, if so, it'll hurt)
> 
> At this point, I would like to raise one issue.
> *Is the goal of the power aware scheduler improving power efficiency of
> the scheduler or a compromise on the power efficiency but definitely a
> decrease in power consumption, since it is the user who has decided to
> prioritise lower power consumption over performance* ?
> 

It could be one of reason for this feather, but I could like to
make it has better efficiency, like packing tasks according to cpu_power
not current group_weight.
>>
> 
> Regards
> Preeti U Murthy
> 


-- 
Thanks
    Alex
