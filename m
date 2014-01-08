Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbaAHOSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:18:52 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63197 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbaAHOSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:18:47 -0500
Message-ID: <52CD5D9A.30604@linaro.org>
Date: Wed, 08 Jan 2014 22:15:54 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "pjt@google.com" <pjt@google.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "jason.low2@hp.com" <jason.low2@hp.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] sched: bias to target cpu load to reduce task moving
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org> <1386061556-28233-5-git-send-email-alex.shi@linaro.org> <20131217141012.GG10134@e103034-lin> <20131217153809.GP21999@twins.programming.kicks-ass.net> <52B2F5D0.2050707@linaro.org> <20131220111926.GA11605@e103034-lin> <52BAF292.1070404@linaro.org> <20140102160404.GA3000@e103034-lin> <52CAB12B.4090701@linaro.org> <20140107125518.GE2936@e103034-lin> <20140107125930.GW31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140107125930.GW31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 08:59 PM, Peter Zijlstra wrote:
> On Tue, Jan 07, 2014 at 12:55:18PM +0000, Morten Rasmussen wrote:
>> My understanding is that should_we_balance() decides which cpu is
>> eligible for doing the load balancing for a given domain (and the
>> domains above). That is, only one cpu in a group is allowed to load
>> balance between the local group and other groups. That cpu would
>> therefore be reponsible for pulling enough load that the groups are
>> balanced even if it means temporarily overloading itself. The other cpus
>> in the group will take care of load balancing the extra load within the
>> local group later.

Thanks for both of you comments and explanations! :)

I know this patch's change is arguable and my attempt doesn't tune well. But I believe I am in a correct way. :) let me explain a bit for this patch again.

First cpu_load includes the history load info, so repeatedly decay and use the history load is kind of non-sense. and the old source/target_load randomly select history load or current load just according to max/min, it also owe a well explanation.
Second, we consider the bias in source/target_load already. but still use imbalance_pct as last check in idlest/busiest group finding. It is also a kind of redundant job. If we can consider the source/target bias, we'd better not use imbalance_pct again.
And last, imbalance pct overused with quickly core number increasing cpu. Like in find_busiset_group:
Assume a 2 groups domain, each group has 8 cores cpus.
    The target group will bias 8 * (imbalance_pct -100) 
				= 8 * (125 - 100) = 200.
     Since each of cpu bias .25 times load, for 8 cpus, totally bias 2 times average cpu load between groups. That is a too much. But if there only 2 cores in cpu group(common case when the code introduced). the bias is just 2 * 25 / 100 = 0.5 times average cpu load.

Now this patchset remove the cpu_load array avoid repeated history decay; reorganize the imbalance_pct usage to avoid redundant balance bias. and reduce the bias value between cpu groups -- maybe it isn't tune well. :)

> 
> Correct.
> 
>> I may have missed something, but I don't understand the reason for the
>> performance improvements that you are reporting. I see better numbers
>> for a few benchmarks, but I still don't understand why the code makes
>> sense after the cleanup. If we don't understand why it works, we cannot
>> be sure that it doesn't harm other benchmarks. There is always a chance
>> that we miss something but, IMHO, not having any idea to begin with
>> increases the chances for problems later significantly. So why not get
>> to the bottom of the problem of cleaning up cpu_load?
>>
>> Have you done more extensive benchmarking? Have you seen any regressions
>> in other benchmarks?
> 
> I only remember hackbench numbers and that generally fares well with a
> more aggressive balancer since it has no actual work to speak of the
> migration penalty is very low and because there's a metric ton of tasks
> the aggressive leveling makes for more coherent 'throughput'.

I just tested hackbench on arm. and with more testing times plus rebase to .13-rc6, the variation increased, then the benefit become unclear. anyway still no regression find on both perf-stat cpu-migration times and real execute time.

On 0day performance testing should tested kbuild, hackbench, aim7, dbench, tbench, sysbench, netperf etc. etc. No regression found.

The 0day performance testing also catch a cpu migration reduced on kvm guest.
https://lkml.org/lkml/2013/12/21/135 

and another benchmark get benefit on the old patchset:
like the testing results show on 0day performance testing: 

https://lkml.org/lkml/2013/12/4/102

Hi Alex,

We obsevered 150% performance gain with vm-scalability/300s-mmap-pread-seq
testcase with this patch applied. Here is a list of changes we got so far:

testbox : brickland
testcase: vm-scalability/300s-mmap-pread-seq


    f1b6442c7dd12802e622      d70495ef86f397816d73  
       (parent commit)            (this commit)
------------------------  ------------------------  
             26393249.80      +150.9%  66223933.60  vm-scalability.throughput

                  225.12       -49.9%       112.75  time.elapsed_time
                36333.40       -90.7%      3392.20  vmstat.system.cs
                    2.40      +375.0%        11.40  vmstat.cpu.id
              3770081.60       -97.7%     87673.40  time.major_page_faults
              3975276.20       -97.0%    117409.60  time.voluntary_context_switches
                    3.05      +301.7%        12.24  iostat.cpu.idle
                21118.41       -70.3%      6277.19  time.system_time
                   18.40      +130.4%        42.40  vmstat.cpu.us
                   77.00       -41.3%        45.20  vmstat.cpu.sy
                47459.60       -31.3%     32592.20  vmstat.system.in
                82435.40       -12.1%     72443.60  time.involuntary_context_switches
                 5128.13       +14.0%      5848.30  time.user_time
                11656.20        -7.8%     10745.60  time.percent_of_cpu_this_job_got
           1069997484.80        +0.3% 1073679919.00 time.minor_page_faults

Btw, the latest patchset include more clean up.
	git@github.com:alexshi/power-scheduling.git noload
Guess fengguang's 0day performance is doing test on it.

-- 
Thanks
    Alex
