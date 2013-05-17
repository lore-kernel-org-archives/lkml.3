Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3EQIIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:08:35 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39591 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3EQII0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:08:26 -0400
Message-ID: <5195E4F9.60908@linux.vnet.ibm.com>
Date: Fri, 17 May 2013 13:36:17 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Ingo Molnar <mingo@kernel.org>, Len Brown <lenb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Alex Shi <alex.shi@intel.com>,
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
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com> <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com> <20130412162348.GE2368@pd.tnic>	 <1365785311.5814.36.camel@marge.simpson.net> <516F19EE.5060309@kernel.org>	 <1366989087.30242.11.camel@marge.simpson.net> <1367298972.4616.41.camel@marge.simpson.net> <1367310625.4616.71.camel@marge.simpson.net> <20130430084135.GA21473@gmail.com> <1367314539.4616.88.camel@marge.simpson.net> <1367315380.4616.91.camel@marge.simpson.net> <1367315763.4616.93.camel@marge.simpson.net>
In-Reply-To: <1367315763.4616.93.camel@marge.simpson.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051708-7014-0000-0000-000003096194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2013 03:26 PM, Mike Galbraith wrote:
> On Tue, 2013-04-30 at 11:49 +0200, Mike Galbraith wrote: 
>> On Tue, 2013-04-30 at 11:35 +0200, Mike Galbraith wrote: 
>>> On Tue, 2013-04-30 at 10:41 +0200, Ingo Molnar wrote: 
>>
>>>> Which are the workloads where 'powersaving' mode hurts workload 
>>>> performance measurably?

I ran ebizzy on a 2 socket, 16 core, SMT 4 Power machine.
The power efficiency drops significantly with the powersaving policy of
this patch,over the power efficiency of the scheduler without this patch.

The below parameters are measured relative to the default scheduler
behaviour.

A: Drop in power efficiency with the patch+powersaving policy
B: Drop in performance with the patch+powersaving policy
C: Decrease in power consumption with the patch+powersaving policy

NumThreads      A            B         C
-----------------------------------------
2               33%         36%       4%
4               31%         33%       3%
8               28%         30%       3%
16              31%         33%       4%

Each of the above run is for 30s.

On investigating socket utilization,I found that only 1 socket was being
used during all the above threaded runs. As can be guessed this is due
to the group_weight being considered for the threshold metric.
This stacks up tasks on a core and further on a socket, thus throttling
them, as observed by Mike below.

I therefore think we must switch to group_capacity as the metric for
threshold and use only (rq->utils*nr_running) for group_utils
calculation during non-bursty wakeup scenarios.
This way we are comparing right; the utilization of the runqueue by the
fair tasks and the cpu capacity available for them after being consumed
by the rt tasks.

After I made the above modification,all the above three parameters came
to be nearly null. However, I am observing the load balancing of the
scheduler with the patch and powersavings policy enabled. It is behaving
very close to the default scheduler (spreading tasks across sockets).
That also explains why there is no performance drop or gain with the
patch+powersavings policy enabled. I will look into this observation and
revert.

>>>
>>> Well, it'll lose throughput any time there's parallel execution
>>> potential but it's serialized instead.. using average will inevitably
>>> stack tasks sometimes, but that's its goal.  Hackbench shows it.
>>
>> (but that consolidation can be a winner too, and I bet a nickle it would
>> be for a socket sized pgbench run)
> 
> (belay that, was thinking of keeping all tasks on a single node, but
> it'll likely stack the whole thing on a CPU or two, if so, it'll hurt)

At this point, I would like to raise one issue.
*Is the goal of the power aware scheduler improving power efficiency of
the scheduler or a compromise on the power efficiency but definitely a
decrease in power consumption, since it is the user who has decided to
prioritise lower power consumption over performance* ?

> 

Regards
Preeti U Murthy

