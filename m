Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3CEJCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:02:46 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:37013 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3CEJCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:02:42 -0500
Message-ID: <5135B4AD.5030609@numascale-asia.com>
Date: Tue, 05 Mar 2013 17:02:37 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130227 Thunderbird/17.0.3
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Steffen Persvold <sp@numascale.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: False-positive RCU stall warnings on large systems...
References: <5123A984.4000704@numascale-asia.com> <20130219181624.GG3093@linux.vnet.ibm.com> <5124449D.3060808@numascale-asia.com> <20130225163225.GA3302@linux.vnet.ibm.com>
In-Reply-To: <20130225163225.GA3302@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2013 12:32 AM, Paul E. McKenney wrote:
> On Wed, Feb 20, 2013 at 11:35:57AM +0800, Daniel J Blueman wrote:
>> On 20/02/2013 02:16, Paul E. McKenney wrote:
>>> On Wed, Feb 20, 2013 at 12:34:12AM +0800, Daniel J Blueman wrote:
>>>> Hi Paul,
>>>>
>>>> On some of our larger servers with many hundreds of cores and when
>>>> under high duress, we can see scheduler RCU stall warnings [1], so
>>>> find we have to increase the hardcoded RCU_STALL_RAT_DELAY up from 2
>>>> and RCU_JIFFIES_TILL_FORCE_QS up from 3.
>
> Disabling RCU_FAST_NO_HZ will likely remove the need to adjust
> RCU_JIFFIES_TILL_FORCE_QS.  Changes in my -rcu tree will likely remove the
> need to adjust these two in 3.10 or 3.11, depending on how testing goes.
>
>>>> Is there a more sustainable way to account for this to avoid it
>>>> being hard-coded, such as making it and dependent timeouts a
>>>> fraction of CONFIG_RCU_CPU_STALL_TIMEOUT?
>
> Maybe...  But what this means is that your system is so heavily loaded
> that the CPU in question is failing to make it to RCU's softirq handler
> in two jiffies worth of time.  This is a function of workload rather
> than of the number of CPUs.
>
>>>> On the other hand, perhaps this is just caused by clock jitter (eg
>>>> due to distance from a contended clock source)? So increasing these
>>>> a bit may just be adequate in general...
>>>
>>> Hmmm...  What version of the kernel are you running?
>>
>> The example below occurs with v3.8, but we see the same with
>> previous kernels eg v3.5.
>
> There is always the rcutree.rcu_cpu_stall_timeout parameter that sets
> the stall timeout in seconds.  This may be specified at boot time or
> via sysfs at runtime.  The default is now 21 seconds.
>
>> Of course, when using the local TSC, you'd see no jitter relative to
>> coherent transactions (eg memory writes), but when the HPET is used
>> across a large system, coherent transactions to distant cores are
>> just so much faster, as there's massive congestion to the shared
>> HPET behind various HT and PCIe bridges. This could be where the
>> jitter arises from, if I'm guessing jitter is the problem here.
>
> Agreed, timing jitter could cause problems.  That said, the code uses
> the jiffies counter to compute these timings.  Are you seeing similar
> memory contention on the jiffies counter itself?

The contention we see in general are when cores contend for a spinlock 
and when there are lots of concurrent HPET reads (Opterons allow only 4 
outstanding reads to the IO hub).

It's probably possible to reproduce rcu_sched stalls on a quad-socket 
box with 64 cores and the right workload with the TSC disabled.

In 3.9-rc1 with RCU_FAST_NO_HZ disabled, we've seen stalls of 4 jiffies 
[2], but without the "Stall ended" message. This is with a workload 
which allocates ~256GB of memory over 192 cores.

Thanks,
   Daniel

>>>> --- [1]
>>>>
>>>> [ 3939.010085] INFO: rcu_sched detected stalls on CPUs/tasks: {}
>>>> (detected by 1, t=29662 jiffies, g=3053, c=3052, q=598)
>>>> [ 3939.020008] INFO: Stall ended before state dump start

--- [2]

[10660.110620] INFO: rcu_sched self-detected stall on CPU { 39}  (t=4 
jiffies g=1169 c=1168 q=8)
[10660.110620] Pid: 11747, comm: sp.B Not tainted 3.9.0-rc1-advanced #6
[10660.110620] Call Trace:
[10660.110620]  <IRQ>  [<ffffffff810b2a42>] ? 
rcu_check_callbacks+0x2d2/0x5f0
[10660.110620]  [<ffffffff8107d94a>] ? run_posix_cpu_timers+0x3a/0x790
[10660.110620]  [<ffffffff8106c86f>] ? update_process_times+0x3f/0x80
[10660.110620]  [<ffffffff81098280>] ? tick_sched_handle.isra.8+0x30/0x40
[10660.110620]  [<ffffffff810983b2>] ? tick_sched_timer+0x42/0x70
[10660.110620]  [<ffffffff8107e66a>] ? __run_hrtimer.isra.30+0x4a/0xe0
[10660.110620]  [<ffffffff8107ef45>] ? hrtimer_interrupt+0xe5/0x220
[10660.110620]  [<ffffffff8104c5a3>] ? smp_apic_timer_interrupt+0x63/0xa0
[10660.110620]  [<ffffffff8186e887>] ? apic_timer_interrupt+0x67/0x70
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia
