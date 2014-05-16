Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaEPEYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 00:24:44 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:35813 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaEPEYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 00:24:43 -0400
Message-ID: <53759303.40409@linux.vnet.ibm.com>
Date: Fri, 16 May 2014 12:24:35 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
References: <20140513094737.GU30445@twins.programming.kicks-ass.net> <53721FD4.6060300@redhat.com> <20140513142328.GE2485@laptop.programming.kicks-ass.net> <53731D12.7040804@linux.vnet.ibm.com> <20140514094426.GF30445@twins.programming.kicks-ass.net> <5374387E.4080802@linux.vnet.ibm.com> <20140515083531.GE30445@twins.programming.kicks-ass.net> <53747EE4.3020605@linux.vnet.ibm.com> <20140515090638.GI30445@twins.programming.kicks-ass.net> <53748A5D.6070605@linux.vnet.ibm.com> <20140515115751.GK30445@twins.programming.kicks-ass.net> <5375768F.1010000@linux.vnet.ibm.com> <1400208690.7133.11.camel@marge.simpson.net>
In-Reply-To: <1400208690.7133.11.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051604-5564-0000-0000-00000DB5C1F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Mike :)

On 05/16/2014 10:51 AM, Mike Galbraith wrote:
> On Fri, 2014-05-16 at 10:23 +0800, Michael wang wrote:
> 
>> But we found that one difference when group get deeper is the tasks of
>> that group become to gathered on CPU more often, some time all the
>> dbench instances was running on the same CPU, this won't happen for l1
>> group, may could explain why dbench could not get CPU more than 100% any
>> more.
> 
> Right.  I played a little (sane groups), saw load balancing as well.

Yeah, now we found that even l2 groups will face the same issue, allow
me to re-list the details here:

Firstly do workaround (10 times latency):
	echo 240000000 > /proc/sys/kernel/sched_latency_ns
        echo NO_GENTLE_FAIR_SLEEPERS > /sys/kernel/debug/sched_features

This workaround may related to another issue about vruntime bonus for
sleeper, but let's put it down currently and focus on the gather issue.

Create groups like:
	mkdir /sys/fs/cgroup/cpu/A
	mkdir /sys/fs/cgroup/cpu/B
	mkdir /sys/fs/cgroup/cpu/C

	mkdir /sys/fs/cgroup/cpu/l1
	mkdir /sys/fs/cgroup/cpu/l1/A
	mkdir /sys/fs/cgroup/cpu/l1/B
	mkdir /sys/fs/cgroup/cpu/l1/C

Run workload like (6 is half of the CPUS on my box):
	echo $$ > /sys/fs/cgroup/cpu/A/tasks ; dbench 6
	echo $$ > /sys/fs/cgroup/cpu/B/tasks ; stress 6
	echo $$ > /sys/fs/cgroup/cpu/C/tasks ; stress 6

Check top, each dbench instance got around 45%, totally around 270%,
this is close to the case when only dbench running (300%) since we use
the workaround, otherwise we will see it to be around 100%, but that's
another issue...

By sample /proc/sched_debug, rarely see more than 2 dbench instances on
same rq.

Now re-run workload like:
	echo $$ > /sys/fs/cgroup/cpu/l1/A/tasks ; dbench 6
	echo $$ > /sys/fs/cgroup/cpu/l1/B/tasks ; stress 6
	echo $$ > /sys/fs/cgroup/cpu/l1/C/tasks ; stress 6

Check top, each dbench instance got around 20%, totally around 120%,
sometime dropped under 100%, and dbench throughput dropped.

By sample /proc/sched_debug, frequently see 4 or 5 dbench instances on
same rq.

So just one level deeper from l1 to l2 and such a big difference, and
groups with same shares not equally share the resources...

BTW, by bind each dbench instances to different CPU, dbench in l2 groups
will regain all the CPU% which is 300%.

I'll keep investigation and try to figure out why l2 group's tasks
starting to gather, please let me know if there are any suggestions ;-)

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

