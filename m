Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3FETbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:31:16 -0400
Received: from mail.candelatech.com ([208.74.158.172]:36406 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab3FETbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:31:14 -0400
Message-ID: <51AF91F5.6090801@candelatech.com>
Date: Wed, 05 Jun 2013 12:31:01 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: stop_machine lockup issue in 3.9.y.
References: <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com> <51ACBD6A.1030304@candelatech.com> <51ACC60B.8090504@candelatech.com> <87d2s2to4z.fsf@rustcorp.com.au> <20130604100744.7cdf8777@jlaw-desktop.mno.stratus.com> <51AE1B81.20900@candelatech.com> <51AE27D5.7050202@candelatech.com> <87sj0xry1k.fsf@rustcorp.com.au> <20130605071539.GA3429@mtj.dyndns.org> <51AF6E54.3050108@candelatech.com> <20130605184807.GD10693@mtj.dyndns.org> <51AF8D4B.4090407@candelatech.com>
In-Reply-To: <51AF8D4B.4090407@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is no longer really about the module unlink, so changing
subject.

On 06/05/2013 12:11 PM, Ben Greear wrote:
> On 06/05/2013 11:48 AM, Tejun Heo wrote:
>> Hello, Ben.
>>
>> On Wed, Jun 05, 2013 at 09:59:00AM -0700, Ben Greear wrote:
>>> One pattern I notice repeating for at least most of the hangs is that all but one
>>> CPU thread has irqs disabled and is in state 2.  But, there will be one thread
>>> in state 1 that still has IRQs enabled and it is reported to be in soft-lockup
>>> instead of hard-lockup.  In 'sysrq l' it always shows some IRQ processing,
>>> but typically that of the sysrq itself.  I added printk that would always
>>> print if the thread notices that smdata->state != curstate, and the soft-lockup
>>> thread (cpu 2 below) never shows that message.
>>
>> It sounds like one of the cpus get live-locked by IRQs.  I can't tell
>> why the situation is made worse by other CPUs being tied up.  Do you
>> ever see CPUs being live locked by IRQs during normal operation?
>
> No, I have not noticed any live locks aside from this, at least in
> the 3.9 kernels.
>
>>> I thought it might be because it was reading stale smdata->state, so I changed
>>> that to atomic_t hoping that would mitigate that.  I also tried adding smp_rmb()
>>> below the cpu_relax().  Neither had any affect, so I am left assuming that the
>>
>> I looked at the code again and the memory accesses seem properly
>> interlocked.  It's a bit tricky and should probably have used spinlock
>> instead considering it's already a hugely expensive path anyway, but
>> it does seem correct to me.
>>
>>> thread instead is stuck handling IRQs and never gets out of the IRQ handler.
>>
>> Seems that way to me too.
>>
>>> Maybe since I have 2 real cores, and 3 processes busy-spinning on their CPU cores,
>>> the remaining process can just never handle all the IRQs and get back to the
>>> cpu shutdown state machine?  The various soft-hang stacks below show at least slightly
>>> different stacks, so I assume that thread is doing at least something.
>>
>> What's the source of all those IRQs tho?  I don't think the IRQs are
>> from actual events.  The system is quiesced.  Even if it's from
>> receiving packets, it's gonna quiet down pretty quickly.  The hang
>> doesn't go away if you disconnect the network cable while hung, right?
>>
>> What could be happening is that IRQ handling is handled by a thread
>> but the IRQ handler itself doesn't clear the IRQ properly and depends
>> on the handling thread to clear the condition.  If no CPU is available
>> for scheduling, it might end up raising and re-reraising IRQs for the
>> same condition without ever being handled.  If that's the case, such
>> lockup could happen on a normally functioning UP machine or if the IRQ
>> is pinned to a single CPU which happens to be running the handling
>> thread.  At any rate, it'd be a plain live-lock bug on the driver
>> side.
>>
>> Can you please try to confirm the specific interrupt being
>> continuously raised?  Detecting the hang shouldn't be too difficult.
>> Just recording the starting jiffies and if progress hasn't been made
>> for, say, ten seconds, it can set a flag and then print the IRQs being
>> handled if the flag is set.  If it indeed is the ath device, we
>> probably wanna get the driver maintainer involved.
>
> I am not sure how to tell which IRQ is being handled.  Do the
> stack traces (showing smp_apic_timer_interrupt, for instance)
> indicate potential culprits, or is that more a symptom of just
> when the soft-lockup check is called?
>
>
> Where should I add code to print out irqs?  In the lockup state,
> the thread (probably) stuck handling irqs isn't executing any code in
> the stop_machine file as far as I can tell.
>
> Maybe I need to instrument the __do_softirq or similar method?
>
> For what it's worth, previous debugging appears to show that jiffies
> stops incrementing in many of these lockups.
>
> Also, I have been trying for 20+ minutes to reproduce the lockup
> with the ath9k module removed (and my user-space app that uses it
> stopped), and I have not reproduced it yet.  So, possibly it is
> related to ath9k, but my user-space app pokes at lots of other
> stuff and starts loads of dhcp client processes and such too,
> so not sure yet.


I re-added ath9k, turned on my app (to create 400 stations, etc),
re-started the module unload/load loop:
for i in `seq 10000`; do modprobe macvlan; rmmod macvlan; done
and hit the problem fairly quickly.

This is on stock 3.9.4, with Rusty's kobj patch, and some printk debugging
I added to the stop_machine.c file.

Perhaps interestingly, I do see an ath9k warning/error in this log as well.

Also, since lockdep is enabled, we get some irq printouts.  Does this mean
anything to you?

__stop_machine(upstream): num-threads: 4,  fn: __try_stop_module(ffffffff810f330a)  data: ffff8801c594bf28  smdata: ffff8801c594be58
set_state, cpu: 0  state: 0 newstate: 1 smdata: ffff8801c594be58  fn: ffffffff810f330a
cpu: 1 loops: 1 jiffies: 4297177162  timeout: 4297177161 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 0 loops: 1 jiffies: 4297177162  timeout: 4297177161 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 0 loops: 1 jiffies: 4297177162 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 0 ack_state jiffies: 4297177162 smdata->state: 1  thread_ack: 4 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 3 loops: 1 jiffies: 4297177162  timeout: 4297177161 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 0 ack_state end jiffies: 4297177162 smdata->state: 1  thread_ack: 3  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 2 loops: 1 jiffies: 4297177162  timeout: 4297177161 curstate: 0  smdata->state: 1  thread_ack: 3  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 3 loops: 1 jiffies: 4297177162 curstate: 0  smdata->state: 1  thread_ack: 3  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 3 ack_state jiffies: 4297177162 smdata->state: 1  thread_ack: 3 smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 2 loops: 1 jiffies: 4297177162 curstate: 0  smdata->state: 1  thread_ack: 3  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 3 ack_state end jiffies: 4297177162 smdata->state: 1  thread_ack: 2  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 2 ack_state jiffies: 4297177162 smdata->state: 1  thread_ack: 2 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 2 ack_state end jiffies: 4297177162 smdata->state: 1  thread_ack: 1  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 1 loops: 1 jiffies: 4297177313 curstate: 0  smdata->state: 1  thread_ack: 1  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 1 ack_state jiffies: 4297177326 smdata->state: 1  thread_ack: 1 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 1  increment state, smdata: ffff8801c594be58 fn: ffffffff810f330a
set_state, cpu: 1  state: 1 newstate: 2 smdata: ffff8801c594be58  fn: ffffffff810f330a
cpu: 1 ack_state end jiffies: 4297177350 smdata->state: 2  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 0 loops: 12226751 jiffies: 4297177350 curstate: 1  smdata->state: 2  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 2 loops: 12286477 jiffies: 4297177350 curstate: 1  smdata->state: 2  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 0 ack_state jiffies: 4297177350 smdata->state: 2  thread_ack: 4 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 0 ack_state end jiffies: 4297177350 smdata->state: 2  thread_ack: 3  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 3 loops: 25634226 jiffies: 4297177350 curstate: 1  smdata->state: 2  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 3 ack_state jiffies: 4297177350 smdata->state: 2  thread_ack: 3 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 3 ack_state end jiffies: 4297177350 smdata->state: 2  thread_ack: 2  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 2 ack_state jiffies: 4297177350 smdata->state: 2  thread_ack: 2 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 2 ack_state end jiffies: 4297177350 smdata->state: 2  thread_ack: 1  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 1 loops: 2 jiffies: 4297177350 curstate: 1  smdata->state: 2  thread_ack: 1  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 1 ack_state jiffies: 4297177350 smdata->state: 2  thread_ack: 1 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 1  increment state, smdata: ffff8801c594be58 fn: ffffffff810f330a
set_state, cpu: 1  state: 2 newstate: 3 smdata: ffff8801c594be58  fn: ffffffff810f330a
cpu: 1 ack_state end jiffies: 4297177350 smdata->state: 3  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 3 loops: 47817385 jiffies: 4297177350 curstate: 2  smdata->state: 3  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 2 loops: 31933478 jiffies: 4297177350 curstate: 2  smdata->state: 3  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 0 loops: 31875466 jiffies: 4297177350 curstate: 2  smdata->state: 3  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 2 ack_state jiffies: 4297177350 smdata->state: 3  thread_ack: 4 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 3 ack_state jiffies: 4297177350 smdata->state: 3  thread_ack: 4 smdata: ffff8801c594be58 fn: ffffffff810f330a
calling fn: cpu: 0 loops: 31875466 curstate: 3  smdata->state: 3  thread_ack: 4  smdata: ffff8801c594be58  fn: ffffffff810f330a
cpu: 2 ack_state end jiffies: 4297177350 smdata->state: 3  thread_ack: 3  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 0 ack_state jiffies: 4297177350 smdata->state: 3  thread_ack: 2 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 3 ack_state end jiffies: 4297177350 smdata->state: 3  thread_ack: 2  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 0 ack_state end jiffies: 4297177350 smdata->state: 3  thread_ack: 1  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 1 loops: 3 jiffies: 4297177350 curstate: 2  smdata->state: 3  thread_ack: 1  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 1 ack_state jiffies: 4297177350 smdata->state: 3  thread_ack: 1 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 1  increment state, smdata: ffff8801c594be58 fn: ffffffff810f330a
set_state, cpu: 1  state: 3 newstate: 4 smdata: ffff8801c594be58  fn: ffffffff810f330a
cpu: 1 ack_state end jiffies: 4297177350 smdata->state: 4  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 3 loops: 71662403 jiffies: 4297177350 curstate: 3  smdata->state: 4  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 2 loops: 53246516 jiffies: 4297177350 curstate: 3  smdata->state: 4  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 0 loops: 53187256 jiffies: 4297177350 curstate: 3  smdata->state: 4  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 2 ack_state jiffies: 4297177350 smdata->state: 4  thread_ack: 4 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 0 ack_state jiffies: 4297177350 smdata->state: 4  thread_ack: 4 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 2 ack_state end jiffies: 4297177350 smdata->state: 4  thread_ack: 3  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 0 ack_state end jiffies: 4297177350 smdata->state: 4  thread_ack: 2  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 3 ack_state jiffies: 4297177350 smdata->state: 4  thread_ack: 4 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 3 ack_state end jiffies: 4297177656 smdata->state: 4  thread_ack: 1  smdata: ffff8801c594be58 fn: ffffffff810f330a
state-change: cpu: 1 loops: 4 jiffies: 4297177768 curstate: 3  smdata->state: 4  thread_ack: 1  smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 1 ack_state jiffies: 4297177780 smdata->state: 4  thread_ack: 1 smdata: ffff8801c594be58 fn: ffffffff810f330a
cpu: 1  increment state, smdata: ffff8801c594be58 fn: ffffffff810f330a
set_state, cpu: 1  state: 4 newstate: 5 smdata: ffff8801c594be58  fn: ffffffff810f330a
cpu: 1 ack_state end jiffies: 4297177804 smdata->state: 5  thread_ack: 4  smdata: ffff8801c594be58 fn: ffffffff810f330a
ath: wiphy0: Failed to stop TX DMA, queues=0x005!
__stop_machine(upstream): num-threads: 4,  fn: __unlink_module(ffffffff810f2dab)  data: ffffffffa117aad0  smdata: ffff8801c594be18
set_state, cpu: 0  state: 0 newstate: 1 smdata: ffff8801c594be18  fn: ffffffff810f2dab
sta201: authenticate with 00:de:ad:1d:ea:01
cpu: 1 loops: 1 jiffies: 4297178887  timeout: 4297178886 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 2 loops: 1 jiffies: 4297178887  timeout: 4297178886 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 0 loops: 1 jiffies: 4297178887  timeout: 4297178886 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8801c594be18 fn: ffffffff810f2dab
state-change: cpu: 2 loops: 1 jiffies: 4297178887 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 3 loops: 1 jiffies: 4297178887  timeout: 4297178886 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 2 ack_state jiffies: 4297178887 smdata->state: 1  thread_ack: 4 smdata: ffff8801c594be18 fn: ffffffff810f2dab
state-change: cpu: 0 loops: 1 jiffies: 4297178887 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 2 ack_state end jiffies: 4297178887 smdata->state: 1  thread_ack: 3  smdata: ffff8801c594be18 fn: ffffffff810f2dab
state-change: cpu: 3 loops: 1 jiffies: 4297178887 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 0 ack_state jiffies: 4297178887 smdata->state: 1  thread_ack: 3 smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 3 ack_state jiffies: 4297178887 smdata->state: 1  thread_ack: 3 smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 0 ack_state end jiffies: 4297178887 smdata->state: 1  thread_ack: 2  smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 3 ack_state end jiffies: 4297178887 smdata->state: 1  thread_ack: 1  smdata: ffff8801c594be18 fn: ffffffff810f2dab
state-change: cpu: 1 loops: 1 jiffies: 4297179040 curstate: 0  smdata->state: 1  thread_ack: 1  smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 1 ack_state jiffies: 4297179054 smdata->state: 1  thread_ack: 1 smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 1  increment state, smdata: ffff8801c594be18 fn: ffffffff810f2dab
set_state, cpu: 1  state: 1 newstate: 2 smdata: ffff8801c594be18  fn: ffffffff810f2dab
cpu: 1 ack_state end jiffies: 4297179083 smdata->state: 2  thread_ack: 4  smdata: ffff8801c594be18 fn: ffffffff810f2dab
state-change: cpu: 2 loops: 25037141 jiffies: 4297179083 curstate: 1  smdata->state: 2  thread_ack: 4  smdata: ffff8801c594be18 fn: ffffffff810f2dab
state-change: cpu: 3 loops: 28970837 jiffies: 4297179083 curstate: 1  smdata->state: 2  thread_ack: 4  smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 2 ack_state jiffies: 4297179083 smdata->state: 2  thread_ack: 4 smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 3 ack_state jiffies: 4297179083 smdata->state: 2  thread_ack: 4 smdata: ffff8801c594be18 fn: ffffffff810f2dab
state-change: cpu: 0 loops: 25898133 jiffies: 4297179083 curstate: 1  smdata->state: 2  thread_ack: 4  smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 2 ack_state end jiffies: 4297179083 smdata->state: 2  thread_ack: 3  smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 0 ack_state jiffies: 4297179083 smdata->state: 2  thread_ack: 2 smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 3 ack_state end jiffies: 4297179083 smdata->state: 2  thread_ack: 2  smdata: ffff8801c594be18 fn: ffffffff810f2dab
cpu: 0 ack_state end jiffies: 4297179083 smdata->state: 2  thread_ack: 1  smdata: ffff8801c594be18 fn: ffffffff810f2dab
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-2.6.linus/kernel/watchdog.c:245 watchdog_overflow_callback+0x9c/0xa7()
Hardware name: To be filled by O.E.M.
Watchdog detected hard LOCKUP on cpu 2
Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nfsv4 auth_rpcgss nfs fscache nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc pktgen lockd 
sunrpc]
Pid: 23, comm: migration/2 Tainted: G         C   3.9.4+ #11
Call Trace:
  <NMI>  [<ffffffff810977f1>] warn_slowpath_common+0x85/0x9f
  [<ffffffff810978ae>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff8110f42d>] watchdog_overflow_callback+0x9c/0xa7
  [<ffffffff8113feb6>] __perf_event_overflow+0x137/0x1cb
  [<ffffffff8101dff6>] ? x86_perf_event_set_period+0x103/0x10f
  [<ffffffff811403fa>] perf_event_overflow+0x14/0x16
  [<ffffffff81023730>] intel_pmu_handle_irq+0x2dc/0x359
  [<ffffffff815eee05>] perf_event_nmi_handler+0x19/0x1b
  [<ffffffff815ee5f3>] nmi_handle+0x7f/0xc2
  [<ffffffff815ee574>] ? oops_begin+0xa9/0xa9
  [<ffffffff815ee6f2>] do_nmi+0xbc/0x304
  [<ffffffff815edd81>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff81099fce>] ? vprintk_emit+0x40a/0x444
  [<ffffffff81104ef8>] ? stop_machine_cpu_stop+0xd8/0x274
  [<ffffffff81104ef8>] ? stop_machine_cpu_stop+0xd8/0x274
  [<ffffffff81104ef8>] ? stop_machine_cpu_stop+0xd8/0x274
  <<EOE>>  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff81104e20>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff81104b8d>] cpu_stopper_thread+0xae/0x162
  [<ffffffff815ebb1f>] ? __schedule+0x5ef/0x637
  [<ffffffff815ecf38>] ? _raw_spin_unlock_irqrestore+0x47/0x7e
  [<ffffffff810e92cc>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e9310>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ecf61>] ? _raw_spin_unlock_irqrestore+0x70/0x7e
  [<ffffffff810bef34>] smpboot_thread_fn+0x258/0x260
  [<ffffffff810becdc>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b7c22>] kthread+0xc7/0xcf
  [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f3b6c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
---[ end trace 4947dfa9b0a4cec3 ]---
BUG: soft lockup - CPU#1 stuck for 22s! [migration/1:17]
Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nfsv4 auth_rpcgss nfs fscache nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc pktgen lockd 
sunrpc]
irq event stamp: 835637905
hardirqs last  enabled at (835637904): [<ffffffff8109f4c1>] __do_softirq+0x9f/0x257
hardirqs last disabled at (835637905): [<ffffffff815f48ad>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5654720): [<ffffffff8109f621>] __do_softirq+0x1ff/0x257
softirqs last disabled at (5654725): [<ffffffff8109f743>] irq_exit+0x5f/0xbb
CPU 1
Pid: 17, comm: migration/1 Tainted: G        WC   3.9.4+ #11 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109ee72>]  [<ffffffff8109ee72>] tasklet_hi_action+0xf0/0xf0
RSP: 0018:ffff88022bc83ef0  EFLAGS: 00000212
RAX: 0000000000000006 RBX: ffff880217deb710 RCX: 0000000000000006
RDX: 0000000000000006 RSI: 0000000000000000 RDI: ffffffff81a050b0
RBP: ffff88022bc83f78 R08: ffffffff81a050b0 R09: ffff88022bc83cc8
R10: 00000000000005f2 R11: ffff8802203aaf50 R12: ffff88022bc83e68
R13: ffffffff815f48b2 R14: ffff88022bc83f78 R15: ffff88022230e000
FS:  0000000000000000(0000) GS:ffff88022bc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000430070 CR3: 00000001cbc5d000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/1 (pid: 17, threadinfo ffff88022230e000, task ffff8802223142c0)
Stack:
  ffffffff8109f539 ffff88022bc83f08 ffff88022230e010 042080402bc83f88
  000000010021bfcd 000000012bc83fa8 ffff88022230e000 ffff88022230ffd8
  0000000000000030 ffff880200000006 00000248d8cdab1c 1304da35fe841722
Call Trace:
  <IRQ>
  [<ffffffff8109f539>] ? __do_softirq+0x117/0x257
  [<ffffffff8109f743>] irq_exit+0x5f/0xbb
  [<ffffffff815f59fd>] smp_apic_timer_interrupt+0x8a/0x98
  [<ffffffff815f48b2>] apic_timer_interrupt+0x72/0x80
  <EOI>
  [<ffffffff81099fdb>] ? vprintk_emit+0x417/0x444
  [<ffffffff815e9fc0>] printk+0x4d/0x4f
  [<ffffffff81104b36>] ? cpu_stopper_thread+0x57/0x162
  [<ffffffff8110504c>] stop_machine_cpu_stop+0x22c/0x274
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff81104e20>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff81104b8d>] cpu_stopper_thread+0xae/0x162
  [<ffffffff815ebb1f>] ? __schedule+0x5ef/0x637
  [<ffffffff815ecf38>] ? _raw_spin_unlock_irqrestore+0x47/0x7e
  [<ffffffff810e92cc>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e9310>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ecf61>] ? _raw_spin_unlock_irqrestore+0x70/0x7e
  [<ffffffff810bef34>] smpboot_thread_fn+0x258/0x260
  [<ffffffff810becdc>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b7c22>] kthread+0xc7/0xcf
  [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f3b6c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
Code: 1c 25 18 e2 00 00 e8 cd fe ff ff e8 ac a4 04 00 fb 66 66 90 66 66 90 4c 89 e3 48 85 db 0f 85 79 ff ff ff 5f 5b 41 5c 41 5d c9 c3 <55> 48 89 e5 41 55 41 54 
53 4
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-2.6.linus/kernel/watchdog.c:245 watchdog_overflow_callback+0x9c/0xa7()
Hardware name: To be filled by O.E.M.
Watchdog detected hard LOCKUP on cpu 0
Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nfsv4 auth_rpcgss nfs fscache nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc pktgen lockd 
sunrpc]
Pid: 8, comm: migration/0 Tainted: G        WC   3.9.4+ #11
Call Trace:
  <NMI>  [<ffffffff810977f1>] warn_slowpath_common+0x85/0x9f
  [<ffffffff810978ae>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff8110f42d>] watchdog_overflow_callback+0x9c/0xa7
  [<ffffffff8113feb6>] __perf_event_overflow+0x137/0x1cb
  [<ffffffff8101dff6>] ? x86_perf_event_set_period+0x103/0x10f
  [<ffffffff811403fa>] perf_event_overflow+0x14/0x16
  [<ffffffff81023730>] intel_pmu_handle_irq+0x2dc/0x359
  [<ffffffff815eee05>] perf_event_nmi_handler+0x19/0x1b
  [<ffffffff815ee5f3>] nmi_handle+0x7f/0xc2
  [<ffffffff815ee574>] ? oops_begin+0xa9/0xa9
  [<ffffffff815ee6f2>] do_nmi+0xbc/0x304
  [<ffffffff815edd81>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff81099fce>] ? vprintk_emit+0x40a/0x444
  [<ffffffff81104efa>] ? stop_machine_cpu_stop+0xda/0x274
  [<ffffffff81104efa>] ? stop_machine_cpu_stop+0xda/0x274
  [<ffffffff81104efa>] ? stop_machine_cpu_stop+0xda/0x274
  <<EOE>>  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff81104e20>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff81104b8d>] cpu_stopper_thread+0xae/0x162
  [<ffffffff815ebb1f>] ? __schedule+0x5ef/0x637
  [<ffffffff815ecf38>] ? _raw_spin_unlock_irqrestore+0x47/0x7e
  [<ffffffff810e92cc>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e9310>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ecf61>] ? _raw_spin_unlock_irqrestore+0x70/0x7e
  [<ffffffff810bef34>] smpboot_thread_fn+0x258/0x260
  [<ffffffff810becdc>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b7c22>] kthread+0xc7/0xcf
  [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f3b6c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
---[ end trace 4947dfa9b0a4cec4 ]---
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-2.6.linus/kernel/watchdog.c:245 watchdog_overflow_callback+0x9c/0xa7()
Hardware name: To be filled by O.E.M.
Watchdog detected hard LOCKUP on cpu 3
Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nfsv4 auth_rpcgss nfs fscache nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc pktgen lockd 
sunrpc]
Pid: 29, comm: migration/3 Tainted: G        WC   3.9.4+ #11
Call Trace:
  <NMI>  [<ffffffff810977f1>] warn_slowpath_common+0x85/0x9f
  [<ffffffff810978ae>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff8110f42d>] watchdog_overflow_callback+0x9c/0xa7
  [<ffffffff8113feb6>] __perf_event_overflow+0x137/0x1cb
  [<ffffffff8101dff6>] ? x86_perf_event_set_period+0x103/0x10f
  [<ffffffff811403fa>] perf_event_overflow+0x14/0x16
  [<ffffffff81023730>] intel_pmu_handle_irq+0x2dc/0x359
  [<ffffffff815eee05>] perf_event_nmi_handler+0x19/0x1b
  [<ffffffff815ee5f3>] nmi_handle+0x7f/0xc2
  [<ffffffff815ee574>] ? oops_begin+0xa9/0xa9
  [<ffffffff815ee6f2>] do_nmi+0xbc/0x304
  [<ffffffff815edd81>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff81099fce>] ? vprintk_emit+0x40a/0x444
  [<ffffffff81104efa>] ? stop_machine_cpu_stop+0xda/0x274
  [<ffffffff81104efa>] ? stop_machine_cpu_stop+0xda/0x274
  [<ffffffff81104efa>] ? stop_machine_cpu_stop+0xda/0x274
  <<EOE>>  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff81104e20>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff81104b8d>] cpu_stopper_thread+0xae/0x162
  [<ffffffff815ebb1f>] ? __schedule+0x5ef/0x637
  [<ffffffff815ecf38>] ? _raw_spin_unlock_irqrestore+0x47/0x7e
  [<ffffffff810e92cc>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e9310>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ecf61>] ? _raw_spin_unlock_irqrestore+0x70/0x7e
  [<ffffffff810bef34>] smpboot_thread_fn+0x258/0x260
  [<ffffffff810becdc>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b7c22>] kthread+0xc7/0xcf
  [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f3b6c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
---[ end trace 4947dfa9b0a4cec5 ]---
BUG: soft lockup - CPU#1 stuck for 22s! [migration/1:17]
Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nfsv4 auth_rpcgss nfs fscache nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc pktgen lockd 
sunrpc]
irq event stamp: 1774512131
hardirqs last  enabled at (1774512130): [<ffffffff8109f4c1>] __do_softirq+0x9f/0x257
hardirqs last disabled at (1774512131): [<ffffffff815f48ad>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5654720): [<ffffffff8109f621>] __do_softirq+0x1ff/0x257
softirqs last disabled at (5654725): [<ffffffff8109f743>] irq_exit+0x5f/0xbb
CPU 1
Pid: 17, comm: migration/1 Tainted: G        WC   3.9.4+ #11 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109f4c5>]  [<ffffffff8109f4c5>] __do_softirq+0xa3/0x257
RSP: 0018:ffff88022bc83ef8  EFLAGS: 00000202
RAX: ffff8802223142c0 RBX: ffff880217deb710 RCX: 0000000000000006
RDX: ffff88022230e010 RSI: 0000000000000000 RDI: ffff8802223142c0
RBP: ffff88022bc83f78 R08: ffffffff81a050b0 R09: ffff88022bc83cc8
R10: 00000000000005f2 R11: ffff8802203aaf50 R12: ffff88022bc83e68
R13: ffffffff815f48b2 R14: ffff88022bc83f78 R15: ffff88022230e000
FS:  0000000000000000(0000) GS:ffff88022bc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000430070 CR3: 00000001cbc5d000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/1 (pid: 17, threadinfo ffff88022230e000, task ffff8802223142c0)
Stack:
  ffff88022bc83f08 ffff88022230e010 042080402bc83f88 000000010021bfcd
  000000012bc83fa8 ffff88022230e000 ffff88022230ffd8 0000000000000038
  ffff880200000006 00000248d8cdab1c 1304da35fe841722 ffff88022bc8dc80
Call Trace:
  <IRQ>
  [<ffffffff8109f743>] irq_exit+0x5f/0xbb
  [<ffffffff815f59fd>] smp_apic_timer_interrupt+0x8a/0x98
  [<ffffffff815f48b2>] apic_timer_interrupt+0x72/0x80
  <EOI>
  [<ffffffff81099fdb>] ? vprintk_emit+0x417/0x444
  [<ffffffff815e9fc0>] printk+0x4d/0x4f
  [<ffffffff81104b36>] ? cpu_stopper_thread+0x57/0x162
  [<ffffffff8110504c>] stop_machine_cpu_stop+0x22c/0x274
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff81104e20>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff81104b8d>] cpu_stopper_thread+0xae/0x162
  [<ffffffff815ebb1f>] ? __schedule+0x5ef/0x637
  [<ffffffff815ecf38>] ? _raw_spin_unlock_irqrestore+0x47/0x7e
  [<ffffffff810e92cc>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e9310>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ecf61>] ? _raw_spin_unlock_irqrestore+0x70/0x7e
  [<ffffffff810bef34>] smpboot_thread_fn+0x258/0x260
  [<ffffffff810becdc>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b7c22>] kthread+0xc7/0xcf
  [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f3b6c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
Code: 55 b0 49 81 ec d8 1f 00 00 49 8d 44 24 10 4c 89 65 a8 48 89 45 88 65 c7 04 25 80 1b 01 00 00 00 00 00 e8 42 9e 04 00 fb 66 66 90 <66> 66 90 48 c7 c3 80 50 
a0 8
BUG: soft lockup - CPU#1 stuck for 22s! [migration/1:17]
Modules linked in: ath9k ath9k_common ath9k_hw ath mac80211 cfg80211 nfsv4 auth_rpcgss nfs fscache nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc pktgen lockd 
sunrpc]
irq event stamp: 2713027507
hardirqs last  enabled at (2713027506): [<ffffffff8109f4c1>] __do_softirq+0x9f/0x257
hardirqs last disabled at (2713027507): [<ffffffff815f48ad>] apic_timer_interrupt+0x6d/0x80
softirqs last  enabled at (5654720): [<ffffffff8109f621>] __do_softirq+0x1ff/0x257
softirqs last disabled at (5654725): [<ffffffff8109f743>] irq_exit+0x5f/0xbb
CPU 1
Pid: 17, comm: migration/1 Tainted: G        WC   3.9.4+ #11 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109f4c5>]  [<ffffffff8109f4c5>] __do_softirq+0xa3/0x257
RSP: 0018:ffff88022bc83ef8  EFLAGS: 00000286
RAX: ffff8802223142c0 RBX: ffff880217deb710 RCX: 0000000000000006
RDX: ffff88022230e010 RSI: 0000000000000000 RDI: ffff8802223142c0
RBP: ffff88022bc83f78 R08: ffffffff81a050b0 R09: ffff88022bc83cc8
R10: 00000000000005f2 R11: ffff88022bc83c38 R12: ffff88022bc83e68
R13: ffffffff815f48b2 R14: ffff88022bc83f78 R15: ffff88022230e000
FS:  0000000000000000(0000) GS:ffff88022bc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000430070 CR3: 00000001cbc5d000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/1 (pid: 17, threadinfo ffff88022230e000, task ffff8802223142c0)
Stack:
  ffff88022bc83f08 ffff88022230e010 042080402bc83f88 000000010021bfcd
  000000012bc83fa8 ffff88022230e000 ffff88022230ffd8 0000000000000038
  ffff880200000006 00000248d8cdab1c 1304da35fe841722 ffff88022bc8dc80
Call Trace:
  <IRQ>
  [<ffffffff8109f743>] irq_exit+0x5f/0xbb
  [<ffffffff815f59fd>] smp_apic_timer_interrupt+0x8a/0x98
  [<ffffffff815f48b2>] apic_timer_interrupt+0x72/0x80
  <EOI>
  [<ffffffff81099fdb>] ? vprintk_emit+0x417/0x444
  [<ffffffff815e9fc0>] printk+0x4d/0x4f
  [<ffffffff81104b36>] ? cpu_stopper_thread+0x57/0x162
  [<ffffffff8110504c>] stop_machine_cpu_stop+0x22c/0x274
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f2dab>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff81104e20>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff81104b8d>] cpu_stopper_thread+0xae/0x162
  [<ffffffff815ebb1f>] ? __schedule+0x5ef/0x637
  [<ffffffff815ecf38>] ? _raw_spin_unlock_irqrestore+0x47/0x7e
  [<ffffffff810e92cc>] ? trace_hardirqs_on_caller+0x123/0x15a
  [<ffffffff810e9310>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff815ecf61>] ? _raw_spin_unlock_irqrestore+0x70/0x7e
  [<ffffffff810bef34>] smpboot_thread_fn+0x258/0x260
  [<ffffffff810becdc>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b7c22>] kthread+0xc7/0xcf
  [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
  [<ffffffff815f3b6c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b7b5b>] ? __init_kthread_worker+0x5b/0x5b
Code: 55 b0 49 81 ec d8 1f 00 00 49 8d 44 24 10 4c 89 65 a8 48 89 45 88 65 c7 04 25 80 1b 01 00 00 00 00 00 e8 42 9e 04 00 fb 66 66 90 <66> 66 90 48 c7 c3 80 50 
a0 8

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

