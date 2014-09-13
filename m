Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaIMJDl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 05:03:41 -0400
Received: from numascale.com ([213.162.240.84]:57501 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbaIMJDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 05:03:39 -0400
Message-ID: <54140852.8090803@numascale.com>
Date: Sat, 13 Sep 2014 17:03:14 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Hillf Danton <dhillf@gmail.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
        Steffen Persvold <sp@numascale.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [3.14] core onlining/hotplug regression
References: <53D20C2E.3070902@numascale.com> <alpine.DEB.2.10.1407251059130.23352@nanos>
In-Reply-To: <alpine.DEB.2.10.1407251059130.23352@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 05:05 PM, Thomas Gleixner wrote:
> On Fri, 25 Jul 2014, Daniel J Blueman wrote:
>> On a larger x86 system with 1728 cores, 3.15(.6) asserts on
>> smpboot_thread_fn's td->cpu != smp_processor_id() consistently after ~1500
>> cores are online.
>>
>> Reverting the only directly related changes I could find [1,2] doesn't help.
>> Debugging indicates there is a race where the created thread is quickly
>> migrated to core 0 when this occurs, since smp_processor_id returns 0 in these
>> cases. Thomas introduced a thread parked state to fix related issues a year
>> back. Linux 3.14(.13) boots just nice.
>
> Weird. Commits [1,2] are definitely not the culprits.
>
>> Full boot output is at:
>> https://resources.numascale.com/linux-315-thread-mig.txt
>
> Not really helpful, as we don't see what causes it. We just see the
> wreckage.
>
>> Any theories so far? I'll start bisecting when I have full access to the
>> system again in a week and I'll do some more debugging with intermittent
>> access before then.
>
> One thing you could try is enabling tracing.
>
>      "ftrace=function ftrace_dump_on_oops"
>
> It'll take a looooong time to spill out the traces, but that should
> give us the root cause precisely.

It turns out that bisecting led to Lai's patch "Fix hotplug vs. 
set_cpus_allowed_ptr()" [1]. Reverting it prevents the smpboot.c 
BUG_ON(td->cpu != smp_processor_id()) in smpboot_thread_fn from tripping.

-- [1]

commit 6acbfb96976fc3350e30d964acb1dbbdf876d55e
Author: Lai Jiangshan <laijs@cn.fujitsu.com>
Date:   Fri May 16 11:50:42 2014 +0800

     sched: Fix hotplug vs. set_cpus_allowed_ptr()

     Lai found that:

       WARNING: CPU: 1 PID: 13 at arch/x86/kernel/smp.c:124 
native_smp_send_reschedule+0x2d/0x4b()
       ...
       migration_cpu_stop+0x1d/0x22

     was caused by set_cpus_allowed_ptr() assuming that cpu_active_mask is
     always a sub-set of cpu_online_mask.

     This isn't true since 5fbd036b552f ("sched: Cleanup cpu_active 
madness").

     So set active and online at the same time to avoid this particular
     problem.

     Fixes: 5fbd036b552f ("sched: Cleanup cpu_active madness")
     Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
     Cc: Andrew Morton <akpm@linux-foundation.org>
     Cc: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
     Cc: Linus Torvalds <torvalds@linux-foundation.org>
     Cc: Michael wang <wangyun@linux.vnet.ibm.com>
     Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
     Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
     Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
     Cc: Toshi Kani <toshi.kani@hp.com>
     Link: http://lkml.kernel.org/r/53758B12.8060609@cn.fujitsu.com
     Signed-off-by: Ingo Molnar <mingo@kernel.org>
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
