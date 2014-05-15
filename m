Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaEOJfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:35:37 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57246 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbaEOJff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:35:35 -0400
Message-ID: <53748A5D.6070605@linux.vnet.ibm.com>
Date: Thu, 15 May 2014 17:35:25 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <537192D3.5030907@linux.vnet.ibm.com> <20140513094737.GU30445@twins.programming.kicks-ass.net> <53721FD4.6060300@redhat.com> <20140513142328.GE2485@laptop.programming.kicks-ass.net> <53731D12.7040804@linux.vnet.ibm.com> <20140514094426.GF30445@twins.programming.kicks-ass.net> <5374387E.4080802@linux.vnet.ibm.com> <20140515083531.GE30445@twins.programming.kicks-ass.net> <53747EE4.3020605@linux.vnet.ibm.com> <20140515090638.GI30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140515090638.GI30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051509-7014-0000-0000-000004E480EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 05:06 PM, Peter Zijlstra wrote:
[snip]
>> However, when the group level is too deep, that doesn't works any more...
>>
>> I'm not sure but seems like 'deep group level' and 'vruntime bonus for
>> sleeper' is the keep points here, will try to list the root cause after
>> more investigation, thanks for the hints and suggestions, really helpful ;-)
> 
> How deep is deep? You run into numerical problems quite quickly, esp.
> when you've got lots of CPUs. We've only got 64bit to play with, that
> said there were some patches...

It's like:

	/cgroup/cpu/l1/l2/l3/l4/l5/l6/A

about level 7, the issue can not be solved any more.

> 
> What happens if you do the below, Google has been running with that, and
> nobody was ever able to reproduce the report that got it disabled.
> 
> 
> 
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index b2cbe81308af..e40819d39c69 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -40,7 +40,7 @@ extern void update_cpu_load_active(struct rq *this_rq);
>   * when BITS_PER_LONG <= 32 are pretty high and the returns do not justify the
>   * increased costs.
>   */
> -#if 0 /* BITS_PER_LONG > 32 -- currently broken: it increases power usage under light load  */
> +#if 1 /* BITS_PER_LONG > 32 -- currently broken: it increases power usage under light load  */

That is trying to solve the load overflow issue, correct?

I'm not sure which account will turns to be huge when group get deeper,
the load accumulation will suffer discount when passing up, isn't it?

Anyway, will give it a try and see what happened :)

Regards,
Michael Wang

>  # define SCHED_LOAD_RESOLUTION	10
>  # define scale_load(w)		((w) << SCHED_LOAD_RESOLUTION)
>  # define scale_load_down(w)	((w) >> SCHED_LOAD_RESOLUTION)
> 

