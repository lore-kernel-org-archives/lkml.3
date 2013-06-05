Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab3FEQ7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:59:21 -0400
Received: from mail.candelatech.com ([208.74.158.172]:50658 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab3FEQ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:59:18 -0400
Message-ID: <51AF6E54.3050108@candelatech.com>
Date: Wed, 05 Jun 2013 09:59:00 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: Please add to stable:  module: don't unlink the module until
 we've removed all exposure.
References: <alpine.DEB.2.02.1306022212200.10003@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306030724230.19647@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com> <51ACBD6A.1030304@candelatech.com> <51ACC60B.8090504@candelatech.com> <87d2s2to4z.fsf@rustcorp.com.au> <20130604100744.7cdf8777@jlaw-desktop.mno.stratus.com> <51AE1B81.20900@candelatech.com> <51AE27D5.7050202@candelatech.com> <87sj0xry1k.fsf@rustcorp.com.au> <20130605071539.GA3429@mtj.dyndns.org>
In-Reply-To: <20130605071539.GA3429@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 12:15 AM, Tejun Heo wrote:
> Hello,
>
> On Wed, Jun 05, 2013 at 01:47:43PM +0930, Rusty Russell wrote:
>>> I have some printk debugging in (see bottom of email) and was using a serial console, so things
>>> were probably running a bit slower than on most systems.  Here is trace
>>> from my kernel with local patches and not so much debugging enabled
>>> (this is NOT a clean upstream kernel, though I reproduced the same thing
>>> with a clean upstream 3.9.4 kernel plus your module unlink patch yesterday).
>>
>> Tejun CC'd.  We can't be running two stop machines in parallel, since
>> there's a mutex (and there's also one in the module code).
>>
>>> __stop_machine, num-threads: 4, fn: __try_stop_module  data: ffff8801c6ae7f28
>>> cpu: 0 loops: 1 jiffies: 4299011449  timeout: 4299011448 curstate: 0  smdata->state: 1  thread_ack: 4
>>> cpu: 1 loops: 1 jiffies: 4299011449  timeout: 4299011448 curstate: 0  smdata->state: 1  thread_ack: 4
>>> cpu: 2 loops: 1 jiffies: 4299011449  timeout: 4299011448 curstate: 0  smdata->state: 1  thread_ack: 3
>>> cpu: 3 loops: 1 jiffies: 4299011449  timeout: 4299011448 curstate: 0  smdata->state: 1  thread_ack: 2
>>> __stop_machine, num-threads: 4, fn: __unlink_module  data: ffffffffa0aeeab0
>>> cpu: 0 loops: 1 jiffies: 4299011501  timeout: 4299011500 curstate: 0  smdata->state: 1  thread_ack: 4
>>> cpu: 1 loops: 1 jiffies: 4299011501  timeout: 4299011500 curstate: 0  smdata->state: 1  thread_ack: 4
>>> cpu: 3 loops: 1 jiffies: 4299011501  timeout: 4299011500 curstate: 0  smdata->state: 1  thread_ack: 3
>>> ath: wiphy0: Failed to stop TX DMA, queues=0x005!
>>> cpu: 2 loops: 1 jiffies: 4299011501  timeout: 4299011500 curstate: 0  smdata->state: 1  thread_ack: 2
>
> A bit confused.  I looked at the code again and it still seems
> properly interlocked.  Can't see how the above scenario could happen.
> Actually, I'm not even sure, what I'm looking at.  Is the above from
> the lockup?  It'd be helpful if we can get more traces from the locked
> up state.  Shouldn't be hard to detect.  Dumb timeout based detection
> should work fine.  How easily can you reproduce the issue?

I can easily reproduce the problem.  First, my machine info:

dual-core i7, 4 cpu threads total.
8 GB RAM
64-bit kernel, Fedora-17 64-bit OS
2 ath9k NICs, each with 200 virtual stations configured.
   I don't think the virtual stations matter to much, as we reproduce easily
   enough with fewer, but I think that maybe the extra IRQ load helps trigger
   the bug.
I added lots of printk debugging, which makes it easier to hit the
lockup.

There is an 'ath' message in the log above, but most traces have nothing related
to ath in them, so I think that thing above is not related.  (That is a common
ath error message for years, and at least on my hardware, does not appear to cause any
serious problems).

Here below is another trace with even more debugging printouts.  After a while,
it stopped even printing out cpu-hung messages..not sure if that is an important clue or
not.


One pattern I notice repeating for at least most of the hangs is that all but one
CPU thread has irqs disabled and is in state 2.  But, there will be one thread
in state 1 that still has IRQs enabled and it is reported to be in soft-lockup
instead of hard-lockup.  In 'sysrq l' it always shows some IRQ processing,
but typically that of the sysrq itself.  I added printk that would always
print if the thread notices that smdata->state != curstate, and the soft-lockup
thread (cpu 2 below) never shows that message.

I thought it might be because it was reading stale smdata->state, so I changed
that to atomic_t hoping that would mitigate that.  I also tried adding smp_rmb()
below the cpu_relax().  Neither had any affect, so I am left assuming that the
thread instead is stuck handling IRQs and never gets out of the IRQ handler.

Maybe since I have 2 real cores, and 3 processes busy-spinning on their CPU cores,
the remaining process can just never handle all the IRQs and get back to the
cpu shutdown state machine?  The various soft-hang stacks below show at least slightly
different stacks, so I assume that thread is doing at least something.


__stop_machine, num-threads: 4, fn: __try_stop_module(ffffffff810e86da)  data: ffff8802202abf28  smdata: ffff8802202abe58
set_state, cpu: 3  state: 0 newstate: 1 smdata: ffff8802202abe58  fn: ffffffff810e86da
cpu: 1 loops: 1 jiffies: 4294739830  timeout: 4294739829 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 3 loops: 1 jiffies: 4294739830  timeout: 4294739829 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 3 loops: 1 jiffies: 4294739830 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 2 loops: 1 jiffies: 4294739830  timeout: 4294739829 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 0 loops: 1 jiffies: 4294739830  timeout: 4294739829 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 3 ack_state jiffies: 4294739830 smdata->state: 1  thread_ack: 4 smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 2 loops: 1 jiffies: 4294739830 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 0 loops: 1 jiffies: 4294739830 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 3 ack_state end jiffies: 4294739830 smdata->state: 1  thread_ack: 3  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 2 ack_state jiffies: 4294739830 smdata->state: 1  thread_ack: 3 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 0 ack_state jiffies: 4294739830 smdata->state: 1  thread_ack: 3 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 2 ack_state end jiffies: 4294739830 smdata->state: 1  thread_ack: 2  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 0 ack_state end jiffies: 4294739830 smdata->state: 1  thread_ack: 1  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 1 loops: 1 jiffies: 4294739981 curstate: 0  smdata->state: 1  thread_ack: 1  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 1 ack_state jiffies: 4294739993 smdata->state: 1  thread_ack: 1 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 1  increment state, smdata: ffff8802202abe58 fn: ffffffff810e86da
set_state, cpu: 1  state: 1 newstate: 2 smdata: ffff8802202abe58  fn: ffffffff810e86da
cpu: 1 ack_state end jiffies: 4294740017 smdata->state: 2  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 3 loops: 24479339 jiffies: 4294740017 curstate: 1  smdata->state: 2  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 0 loops: 23433125 jiffies: 4294740017 curstate: 1  smdata->state: 2  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 2 loops: 23440505 jiffies: 4294740017 curstate: 1  smdata->state: 2  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 3 ack_state jiffies: 4294740017 smdata->state: 2  thread_ack: 4 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 0 ack_state jiffies: 4294740017 smdata->state: 2  thread_ack: 4 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 2 ack_state jiffies: 4294740017 smdata->state: 2  thread_ack: 4 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 3 ack_state end jiffies: 4294740017 smdata->state: 2  thread_ack: 3  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 0 ack_state end jiffies: 4294740017 smdata->state: 2  thread_ack: 2  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 2 ack_state end jiffies: 4294740017 smdata->state: 2  thread_ack: 1  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 1 loops: 2 jiffies: 4294740017 curstate: 1  smdata->state: 2  thread_ack: 1  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 1 ack_state jiffies: 4294740017 smdata->state: 2  thread_ack: 1 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 1  increment state, smdata: ffff8802202abe58 fn: ffffffff810e86da
set_state, cpu: 1  state: 2 newstate: 3 smdata: ffff8802202abe58  fn: ffffffff810e86da
cpu: 1 ack_state end jiffies: 4294740017 smdata->state: 3  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 0 loops: 42466689 jiffies: 4294740017 curstate: 2  smdata->state: 3  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 2 loops: 42473881 jiffies: 4294740017 curstate: 2  smdata->state: 3  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 3 loops: 43825073 jiffies: 4294740017 curstate: 2  smdata->state: 3  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
calling fn: cpu: 0 loops: 42466689 curstate: 3  smdata->state: 3  thread_ack: 4  smdata: ffff8802202abe58  fn: ffffffff810e86da
cpu: 2 ack_state jiffies: 4294740017 smdata->state: 3  thread_ack: 4 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 3 ack_state jiffies: 4294740017 smdata->state: 3  thread_ack: 4 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 0 ack_state jiffies: 4294740017 smdata->state: 3  thread_ack: 4 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 2 ack_state end jiffies: 4294740017 smdata->state: 3  thread_ack: 3  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 3 ack_state end jiffies: 4294740017 smdata->state: 3  thread_ack: 2  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 0 ack_state end jiffies: 4294740017 smdata->state: 3  thread_ack: 1  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 1 loops: 3 jiffies: 4294740017 curstate: 2  smdata->state: 3  thread_ack: 1  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 1 ack_state jiffies: 4294740017 smdata->state: 3  thread_ack: 1 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 1  increment state, smdata: ffff8802202abe58 fn: ffffffff810e86da
set_state, cpu: 1  state: 3 newstate: 4 smdata: ffff8802202abe58  fn: ffffffff810e86da
cpu: 1 ack_state end jiffies: 4294740017 smdata->state: 4  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 2 loops: 62146520 jiffies: 4294740017 curstate: 3  smdata->state: 4  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 0 loops: 62138953 jiffies: 4294740017 curstate: 3  smdata->state: 4  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 3 loops: 64625424 jiffies: 4294740017 curstate: 3  smdata->state: 4  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 2 ack_state jiffies: 4294740017 smdata->state: 4  thread_ack: 4 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 0 ack_state jiffies: 4294740017 smdata->state: 4  thread_ack: 4 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 3 ack_state jiffies: 4294740017 smdata->state: 4  thread_ack: 4 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 2 ack_state end jiffies: 4294740017 smdata->state: 4  thread_ack: 3  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 0 ack_state end jiffies: 4294740017 smdata->state: 4  thread_ack: 2  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 3 ack_state end jiffies: 4294740017 smdata->state: 4  thread_ack: 1  smdata: ffff8802202abe58 fn: ffffffff810e86da
state-change: cpu: 1 loops: 4 jiffies: 4294740435 curstate: 3  smdata->state: 4  thread_ack: 1  smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 1 ack_state jiffies: 4294740447 smdata->state: 4  thread_ack: 1 smdata: ffff8802202abe58 fn: ffffffff810e86da
cpu: 1  increment state, smdata: ffff8802202abe58 fn: ffffffff810e86da
set_state, cpu: 1  state: 4 newstate: 5 smdata: ffff8802202abe58  fn: ffffffff810e86da
cpu: 1 ack_state end jiffies: 4294740471 smdata->state: 5  thread_ack: 4  smdata: ffff8802202abe58 fn: ffffffff810e86da
__stop_machine, num-threads: 4, fn: __unlink_module(ffffffff810e817b)  data: ffffffffa0ac5ab0  smdata: ffff8802202abe18
set_state, cpu: 0  state: 0 newstate: 1 smdata: ffff8802202abe18  fn: ffffffff810e817b
cpu: 0 loops: 1 jiffies: 4294740500  timeout: 4294740499 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 3 loops: 1 jiffies: 4294740500  timeout: 4294740499 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 1 loops: 1 jiffies: 4294740500  timeout: 4294740499 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8802202abe18 fn: ffffffff810e817b
state-change: cpu: 3 loops: 1 jiffies: 4294740500 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8802202abe18 fn: ffffffff810e817b
state-change: cpu: 1 loops: 1 jiffies: 4294740500 curstate: 0  smdata->state: 1  thread_ack: 4  smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 3 ack_state jiffies: 4294740500 smdata->state: 1  thread_ack: 4 smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 1 ack_state jiffies: 4294740500 smdata->state: 1  thread_ack: 4 smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 3 ack_state end jiffies: 4294740500 smdata->state: 1  thread_ack: 3  smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 1 ack_state end jiffies: 4294740500 smdata->state: 1  thread_ack: 2  smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 2 loops: 1 jiffies: 4294740501  timeout: 4294740500 curstate: 0  smdata->state: 1  thread_ack: 2  smdata: ffff8802202abe18 fn: ffffffff810e817b
state-change: cpu: 2 loops: 1 jiffies: 4294740501 curstate: 0  smdata->state: 1  thread_ack: 2  smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 2 ack_state jiffies: 4294740501 smdata->state: 1  thread_ack: 2 smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 2 ack_state end jiffies: 4294740501 smdata->state: 1  thread_ack: 1  smdata: ffff8802202abe18 fn: ffffffff810e817b
state-change: cpu: 0 loops: 1 jiffies: 4294740651 curstate: 0  smdata->state: 1  thread_ack: 1  smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 0 ack_state jiffies: 4294740664 smdata->state: 1  thread_ack: 1 smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 0  increment state, smdata: ffff8802202abe18 fn: ffffffff810e817b
set_state, cpu: 0  state: 1 newstate: 2 smdata: ffff8802202abe18  fn: ffffffff810e817b
cpu: 0 ack_state end jiffies: 4294740688 smdata->state: 2  thread_ack: 4  smdata: ffff8802202abe18 fn: ffffffff810e817b
state-change: cpu: 3 loops: 23659570 jiffies: 4294740688 curstate: 1  smdata->state: 2  thread_ack: 4  smdata: ffff8802202abe18 fn: ffffffff810e817b
state-change: cpu: 1 loops: 23670374 jiffies: 4294740688 curstate: 1  smdata->state: 2  thread_ack: 4  smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 3 ack_state jiffies: 4294740688 smdata->state: 2  thread_ack: 4 smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 1 ack_state jiffies: 4294740688 smdata->state: 2  thread_ack: 4 smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 3 ack_state end jiffies: 4294740688 smdata->state: 2  thread_ack: 3  smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 1 ack_state end jiffies: 4294740688 smdata->state: 2  thread_ack: 2  smdata: ffff8802202abe18 fn: ffffffff810e817b
state-change: cpu: 0 loops: 2 jiffies: 4294740688 curstate: 1  smdata->state: 2  thread_ack: 2  smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 0 ack_state jiffies: 4294740688 smdata->state: 2  thread_ack: 2 smdata: ffff8802202abe18 fn: ffffffff810e817b
cpu: 0 ack_state end jiffies: 4294740688 smdata->state: 2  thread_ack: 1  smdata: ffff8802202abe18 fn: ffffffff810e817b
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.9.dev.y/kernel/watchdog.c:245 watchdog_overflow_callback+0x9b/0xa6()
Hardware name: To be filled by O.E.M.
Watchdog detected hard LOCKUP on cpu 0
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
Pid: 8, comm: migration/0 Tainted: G         C O 3.9.4+ #70
Call Trace:
  <NMI>  [<ffffffff810963e1>] warn_slowpath_common+0x85/0x9f
  [<ffffffff8109649e>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff810c4dfb>] ? sched_clock_cpu+0x44/0xce
  [<ffffffff81103cec>] watchdog_overflow_callback+0x9b/0xa6
  [<ffffffff811336cb>] __perf_event_overflow+0x137/0x1cb
  [<ffffffff8101db3f>] ? x86_perf_event_set_period+0x107/0x113
  [<ffffffff81133c1a>] perf_event_overflow+0x14/0x16
  [<ffffffff810230dc>] intel_pmu_handle_irq+0x2b0/0x32d
  [<ffffffff815cbdd1>] perf_event_nmi_handler+0x19/0x1b
  [<ffffffff815cb64a>] nmi_handle+0x55/0x7e
  [<ffffffff815cb71b>] do_nmi+0xa8/0x2db
  [<ffffffff815cadb1>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff810f9945>] ? stop_machine_cpu_stop+0x88/0x267
  [<ffffffff810f9945>] ? stop_machine_cpu_stop+0x88/0x267
  [<ffffffff810f9945>] ? stop_machine_cpu_stop+0x88/0x267
  <<EOE>>  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
---[ end trace 9767454fd3f66a7f ]---
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109daab>]  [<ffffffff8109daab>] __do_softirq+0x93/0x23c
RSP: 0018:ffff88022bd03ef8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffff88022bd0e506
RDX: ffff880222218010 RSI: ffff88022bd0e4f0 RDI: 0000000000000002
RBP: ffff88022bd03f78 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e68
R13: ffffffff815d15dd R14: ffff88022bd03f78 R15: ffff880222218000
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000038
  ffff880200000006 000000111671cb12 000000111671cb12 ffff88022bd0db00
Call Trace:
  <IRQ>
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 89 45 90 49 8d 44 24 10 4c 89 65 b0 65 8b 14 25 20 b0 00 00 48 89 45 88 89 55 ac 65 c7 04 25 40 13 01 00 00 00 00 00 fb 66 66 90 <66> 66 90 48 c7 c3 80 50 
a0 8
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.9.dev.y/kernel/watchdog.c:245 watchdog_overflow_callback+0x9b/0xa6()
Hardware name: To be filled by O.E.M.
Watchdog detected hard LOCKUP on cpu 3
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #70
Call Trace:
  <NMI>  [<ffffffff810963e1>] warn_slowpath_common+0x85/0x9f
  [<ffffffff8109649e>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff810c4dfb>] ? sched_clock_cpu+0x44/0xce
  [<ffffffff81103cec>] watchdog_overflow_callback+0x9b/0xa6
  [<ffffffff811336cb>] __perf_event_overflow+0x137/0x1cb
  [<ffffffff8101db3f>] ? x86_perf_event_set_period+0x107/0x113
  [<ffffffff81133c1a>] perf_event_overflow+0x14/0x16
  [<ffffffff810230dc>] intel_pmu_handle_irq+0x2b0/0x32d
  [<ffffffff815cbdd1>] perf_event_nmi_handler+0x19/0x1b
  [<ffffffff815cb64a>] nmi_handle+0x55/0x7e
  [<ffffffff815cb71b>] do_nmi+0xa8/0x2db
  [<ffffffff815cadb1>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  <<EOE>>  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
---[ end trace 9767454fd3f66a80 ]---
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109d6b7>]  [<ffffffff8109d6b7>] tasklet_action+0x61/0xcc
RSP: 0018:ffff88022bd03ed8  EFLAGS: 00000246
RAX: 0000000000000001 RBX: ffff880222185dc0 RCX: ffff88022bd0e506
RDX: ffff8802186f2fa8 RSI: ffff88022bd0e4f0 RDI: ffffffff81a050b0
RBP: ffff88022bd03ee8 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e48
R13: ffffffff815d15dd R14: ffff88022bd03ee8 R15: ffff8802186f2fb0
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffffffff81a050b0 ffff880222218000 ffff88022bd03f78 ffffffff8109db1f
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000030
Call Trace:
  <IRQ>
  [<ffffffff8109db1f>] __do_softirq+0x107/0x23c
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: da 00 00 65 48 89 04 25 88 e0 00 00 fb 66 66 90 66 66 90 eb 77 48 8b 1a 4c 8d 62 08 f0 0f ba 6a 08 01 19 c0 85 c0 75 2d 8b 42 10 <85> c0 75 20 f0 41 0f ba 
34 2
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.9.dev.y/kernel/watchdog.c:245 watchdog_overflow_callback+0x9b/0xa6()
Hardware name: To be filled by O.E.M.
Watchdog detected hard LOCKUP on cpu 1
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
Pid: 17, comm: migration/1 Tainted: G        WC O 3.9.4+ #70
Call Trace:
  <NMI>  [<ffffffff810963e1>] warn_slowpath_common+0x85/0x9f
  [<ffffffff8109649e>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff810c4dfb>] ? sched_clock_cpu+0x44/0xce
  [<ffffffff81103cec>] watchdog_overflow_callback+0x9b/0xa6
  [<ffffffff811336cb>] __perf_event_overflow+0x137/0x1cb
  [<ffffffff8101db3f>] ? x86_perf_event_set_period+0x107/0x113
  [<ffffffff81133c1a>] perf_event_overflow+0x14/0x16
  [<ffffffff810230dc>] intel_pmu_handle_irq+0x2b0/0x32d
  [<ffffffff815cbdd1>] perf_event_nmi_handler+0x19/0x1b
  [<ffffffff815cb64a>] nmi_handle+0x55/0x7e
  [<ffffffff815cb71b>] do_nmi+0xa8/0x2db
  [<ffffffff815cadb1>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff810f99a8>] ? stop_machine_cpu_stop+0xeb/0x267
  [<ffffffff810f99a8>] ? stop_machine_cpu_stop+0xeb/0x267
  [<ffffffff810f99a8>] ? stop_machine_cpu_stop+0xeb/0x267
  <<EOE>>  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff815ca1f4>] ? _raw_spin_unlock_irq+0x10/0x36
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
---[ end trace 9767454fd3f66a81 ]---
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109daab>]  [<ffffffff8109daab>] __do_softirq+0x93/0x23c
RSP: 0018:ffff88022bd03ef8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffff88022bd0e506
RDX: ffff880222218010 RSI: ffff88022bd0e4f0 RDI: 0000000000000002
RBP: ffff88022bd03f78 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e68
R13: ffffffff815d15dd R14: ffff88022bd03f78 R15: ffff880222218000
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000038
  ffff880200000006 000000111671cb12 000000111671cb12 ffff88022bd0db00
Call Trace:
  <IRQ>
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 89 45 90 49 8d 44 24 10 4c 89 65 b0 65 8b 14 25 20 b0 00 00 48 89 45 88 89 55 ac 65 c7 04 25 40 13 01 00 00 00 00 00 fb 66 66 90 <66> 66 90 48 c7 c3 80 50 
a0 8
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109d712>]  [<ffffffff8109d712>] tasklet_action+0xbc/0xcc
RSP: 0018:ffff88022bd03ed8  EFLAGS: 00000202
RAX: 0000000000000040 RBX: ffff880222185dc0 RCX: ffff88022bd0e506
RDX: ffff8802186f2fa8 RSI: ffff88022bd0e4f0 RDI: 0000000000000006
RBP: ffff88022bd03ee8 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e48
R13: ffffffff815d15dd R14: ffff88022bd03ee8 R15: ffff8802186f2fb0
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffffffff81a050b0 ffff880222218000 ffff88022bd03f78 ffffffff8109db1f
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000030
Call Trace:
  <IRQ>
  [<ffffffff8109db1f>] __do_softirq+0x107/0x23c
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 90 bf 06 00 00 00 48 c7 02 00 00 00 00 65 48 8b 04 25 88 e0 00 00 48 89 10 65 48 89 14 25 88 e0 00 00 e8 1c fe ff ff fb 66 66 90 <66> 66 90 48 89 da 48 85 
d2 7
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109d6e1>]  [<ffffffff8109d6e1>] tasklet_action+0x8b/0xcc
RSP: 0018:ffff88022bd03ed8  EFLAGS: 00000202
RAX: 0000000000000001 RBX: ffff880222185dc0 RCX: ffff88022bd0e506
RDX: ffff8802186f2fa8 RSI: ffff88022bd0e4f0 RDI: ffffffff81a050b0
RBP: ffff88022bd03ee8 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e48
R13: ffffffff815d15dd R14: ffff88022bd03ee8 R15: ffff8802186f2fb0
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffffffff81a050b0 ffff880222218000 ffff88022bd03f78 ffffffff8109db1f
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000030
Call Trace:
  <IRQ>
  [<ffffffff8109db1f>] __do_softirq+0x107/0x23c
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 10 85 c0 75 20 f0 41 0f ba 34 24 00 19 c0 85 c0 75 04 0f 0b eb fe 48 8b 7a 20 ff 52 18 f0 41 80 24 24 fd eb 3a f0 41 80 24 24 fd <fa> 66 66 90 66 66 90 bf 
06 0
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109d6e1>]  [<ffffffff8109d6e1>] tasklet_action+0x8b/0xcc
RSP: 0018:ffff88022bd03ed8  EFLAGS: 00000202
RAX: 0000000000000001 RBX: ffff880222185dc0 RCX: ffff88022bd0e506
RDX: ffff8802186f2fa8 RSI: ffff88022bd0e4f0 RDI: ffffffff81a050b0
RBP: ffff88022bd03ee8 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e48
R13: ffffffff815d15dd R14: ffff88022bd03ee8 R15: ffff8802186f2fb0
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffffffff81a050b0 ffff880222218000 ffff88022bd03f78 ffffffff8109db1f
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000030
Call Trace:
  <IRQ>
  [<ffffffff8109db1f>] __do_softirq+0x107/0x23c
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 10 85 c0 75 20 f0 41 0f ba 34 24 00 19 c0 85 c0 75 04 0f 0b eb fe 48 8b 7a 20 ff 52 18 f0 41 80 24 24 fd eb 3a f0 41 80 24 24 fd <fa> 66 66 90 66 66 90 bf 
06 0
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109dac6>]  [<ffffffff8109dac6>] __do_softirq+0xae/0x23c
RSP: 0018:ffff88022bd03ef8  EFLAGS: 00000282
RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffff88022bd0e506
RDX: ffff880222218010 RSI: ffff88022bd0e4f0 RDI: 0000000000000002
RBP: ffff88022bd03f78 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e68
R13: ffffffff815d15dd R14: ffff88022bd03f78 R15: ffff880222218000
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000028
  ffff880200000006 000000111671cb12 000000111671cb12 ffff88022bd0db00
Call Trace:
  <IRQ>
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 65 c7 04 25 40 13 01 00 00 00 00 00 fb 66 66 90 66 66 90 48 c7 c3 80 50 a0 81 48 c7 45 b8 00 00 00 00 65 4c 8b 2c 25 48 c6 00 00 <41> f6 c7 01 0f 84 ba 00 
00 0
BUG: soft lockup - CPU#2 stuck for 23s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109d69c>]  [<ffffffff8109d69c>] tasklet_action+0x46/0xcc
RSP: 0018:ffff88022bd03ed8  EFLAGS: 00000282
RAX: ffff88022bd0e080 RBX: ffff880222185dc0 RCX: ffff88022bd0e506
RDX: ffff8802186f2fa8 RSI: ffff88022bd0e4f0 RDI: ffffffff81a050b0
RBP: ffff88022bd03ee8 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e48
R13: ffffffff815d15dd R14: ffff88022bd03ee8 R15: ffff880222218000
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffffffff81a050b0 ffff880222218000 ffff88022bd03f78 ffffffff8109db1f
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000030
Call Trace:
  <IRQ>
  [<ffffffff8109db1f>] __do_softirq+0x107/0x23c
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 48 8b 14 25 80 e0 00 00 65 48 c7 04 25 80 e0 00 00 00 00 00 00 65 48 03 04 25 d8 da 00 00 65 48 89 04 25 88 e0 00 00 fb 66 66 90 <66> 66 90 eb 77 48 8b 1a 
4c 8
BUG: soft lockup - CPU#2 stuck for 23s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109d712>]  [<ffffffff8109d712>] tasklet_action+0xbc/0xcc
RSP: 0018:ffff88022bd03ed8  EFLAGS: 00000202
RAX: 0000000000000040 RBX: ffff880222185dc0 RCX: ffff88022bd0e506
RDX: ffff8802186f2fa8 RSI: ffff88022bd0e4f0 RDI: 0000000000000006
RBP: ffff88022bd03ee8 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e48
R13: ffffffff815d15dd R14: ffff88022bd03ee8 R15: ffff8802186f2fb0
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffffffff81a050b0 ffff880222218000 ffff88022bd03f78 ffffffff8109db1f
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000030
Call Trace:
  <IRQ>
  [<ffffffff8109db1f>] __do_softirq+0x107/0x23c
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 90 bf 06 00 00 00 48 c7 02 00 00 00 00 65 48 8b 04 25 88 e0 00 00 48 89 10 65 48 89 14 25 88 e0 00 00 e8 1c fe ff ff fb 66 66 90 <66> 66 90 48 89 da 48 85 
d2 7
BUG: soft lockup - CPU#2 stuck for 23s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109d712>]  [<ffffffff8109d712>] tasklet_action+0xbc/0xcc
RSP: 0018:ffff88022bd03ed8  EFLAGS: 00000202
RAX: 0000000000000040 RBX: ffff880222185dc0 RCX: ffff88022bd0e506
RDX: ffff8802186f2fa8 RSI: ffff88022bd0e4f0 RDI: 0000000000000006
RBP: ffff88022bd03ee8 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e48
R13: ffffffff815d15dd R14: ffff88022bd03ee8 R15: ffff8802186f2fb0
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffffffff81a050b0 ffff880222218000 ffff88022bd03f78 ffffffff8109db1f
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000030
Call Trace:
  <IRQ>
  [<ffffffff8109db1f>] __do_softirq+0x107/0x23c
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 90 bf 06 00 00 00 48 c7 02 00 00 00 00 65 48 8b 04 25 88 e0 00 00 48 89 10 65 48 89 14 25 88 e0 00 00 e8 1c fe ff ff fb 66 66 90 <66> 66 90 48 89 da 48 85 
d2 7
BUG: soft lockup - CPU#2 stuck for 23s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109d6ae>]  [<ffffffff8109d6ae>] tasklet_action+0x58/0xcc
RSP: 0018:ffff88022bd03ed8  EFLAGS: 00000282
RAX: ffff88022bd0e080 RBX: ffff880222185dc0 RCX: ffff88022bd0e506
RDX: ffff8802186f2fa8 RSI: ffff88022bd0e4f0 RDI: ffffffff81a050b0
RBP: ffff88022bd03ee8 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e48
R13: ffffffff815d15dd R14: ffff88022bd03ee8 R15: ffff8802186f2fb0
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffffffff81a050b0 ffff880222218000 ffff88022bd03f78 ffffffff8109db1f
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000030
Call Trace:
  <IRQ>
  [<ffffffff8109db1f>] __do_softirq+0x107/0x23c
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 00 00 00 65 48 03 04 25 d8 da 00 00 65 48 89 04 25 88 e0 00 00 fb 66 66 90 66 66 90 eb 77 48 8b 1a 4c 8d 62 08 f0 0f ba 6a 08 01 <19> c0 85 c0 75 2d 8b 42 
10 8
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8110a66f>]  [<ffffffff8110a66f>] rcu_bh_qs+0x9/0x22
RSP: 0018:ffff88022bd03ee8  EFLAGS: 00000246
RAX: 0000000000000040 RBX: 0000000000000246 RCX: ffff88022bd0e506
RDX: 0000000000000000 RSI: ffff88022bd0e4f0 RDI: 0000000000000002
RBP: ffff88022bd03ee8 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e58
R13: ffffffff815d15dd R14: ffff88022bd03ee8 R15: ffff880222218000
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffff88022bd03f78 ffffffff8109db8a ffff88022bd03f08 ffff880222218010
  ffff880222219fd8 04208040810b79ef 00000000fffc8ad1 000000022bd0e150
  ffff880222218000 0000000000000030 ffff880200000006 000000111671cb12
Call Trace:
  <IRQ>
  [<ffffffff8109db8a>] __do_softirq+0x172/0x23c
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 55 48 89 e5 66 66 66 66 90 48 c7 c0 f0 e4 00 00 48 63 ff 48 8b 14 fd 50 b5 ad 81 c6 44 10 10 01 c9 c3 55 48 89 e5 66 66 66 66 90 <48> c7 c0 30 e6 00 00 48 
63 f
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109dac6>]  [<ffffffff8109dac6>] __do_softirq+0xae/0x23c
RSP: 0018:ffff88022bd03ef8  EFLAGS: 00000296
RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffff88022bd0e506
RDX: ffff880222218010 RSI: ffff88022bd0e4f0 RDI: 0000000000000002
RBP: ffff88022bd03f78 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e68
R13: ffffffff815d15dd R14: ffff88022bd03f78 R15: ffff880222218000
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000020
  ffff880200000006 000000111671cb12 000000111671cb12 ffff88022bd0db00
Call Trace:
  <IRQ>
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 65 c7 04 25 40 13 01 00 00 00 00 00 fb 66 66 90 66 66 90 48 c7 c3 80 50 a0 81 48 c7 45 b8 00 00 00 00 65 4c 8b 2c 25 48 c6 00 00 <41> f6 c7 01 0f 84 ba 00 
00 0
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8110a66f>]  [<ffffffff8110a66f>] rcu_bh_qs+0x9/0x22
RSP: 0018:ffff88022bd03ee8  EFLAGS: 00000246
RAX: 0000000000000040 RBX: 0000000000000246 RCX: ffff88022bd0e506
RDX: 0000000000000000 RSI: ffff88022bd0e4f0 RDI: 0000000000000002
RBP: ffff88022bd03ee8 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e58
R13: ffffffff815d15dd R14: ffff88022bd03ee8 R15: ffff880222218000
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffff88022bd03f78 ffffffff8109db8a ffff88022bd03f08 ffff880222218010
  ffff880222219fd8 04208040810b79ef 00000000fffc8ad1 000000022bd0e150
  ffff880222218000 0000000000000030 ffff880200000006 000000111671cb12
Call Trace:
  <IRQ>
  [<ffffffff8109db8a>] __do_softirq+0x172/0x23c
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 55 48 89 e5 66 66 66 66 90 48 c7 c0 f0 e4 00 00 48 63 ff 48 8b 14 fd 50 b5 ad 81 c6 44 10 10 01 c9 c3 55 48 89 e5 66 66 66 66 90 <48> c7 c0 30 e6 00 00 48 
63 f
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109d6ae>]  [<ffffffff8109d6ae>] tasklet_action+0x58/0xcc
RSP: 0018:ffff88022bd03ed8  EFLAGS: 00000282
RAX: ffff88022bd0e080 RBX: ffff880222185dc0 RCX: ffff88022bd0e506
RDX: ffff8802186f2fa8 RSI: ffff88022bd0e4f0 RDI: ffffffff81a050b0
RBP: ffff88022bd03ee8 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e48
R13: ffffffff815d15dd R14: ffff88022bd03ee8 R15: ffff8802186f2fb0
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffffffff81a050b0 ffff880222218000 ffff88022bd03f78 ffffffff8109db1f
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000030
Call Trace:
  <IRQ>
  [<ffffffff8109db1f>] __do_softirq+0x107/0x23c
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 00 00 00 65 48 03 04 25 d8 da 00 00 65 48 89 04 25 88 e0 00 00 fb 66 66 90 66 66 90 eb 77 48 8b 1a 4c 8d 62 08 f0 0f ba 6a 08 01 <19> c0 85 c0 75 2d 8b 42 
10 8
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109daab>]  [<ffffffff8109daab>] __do_softirq+0x93/0x23c
RSP: 0018:ffff88022bd03ef8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffff88022bd0e506
RDX: ffff880222218010 RSI: ffff88022bd0e4f0 RDI: 0000000000000002
RBP: ffff88022bd03f78 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e68
R13: ffffffff815d15dd R14: ffff88022bd03f78 R15: ffff880222218000
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000038
  ffff880200000006 000000111671cb12 000000111671cb12 ffff88022bd0db00
Call Trace:
  <IRQ>
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 89 45 90 49 8d 44 24 10 4c 89 65 b0 65 8b 14 25 20 b0 00 00 48 89 45 88 89 55 ac 65 c7 04 25 40 13 01 00 00 00 00 00 fb 66 66 90 <66> 66 90 48 c7 c3 80 50 
a0 8
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109d6e1>]  [<ffffffff8109d6e1>] tasklet_action+0x8b/0xcc
RSP: 0018:ffff88022bd03ed8  EFLAGS: 00000202
RAX: 0000000000000001 RBX: ffff880222185dc0 RCX: ffff88022bd0e506
RDX: ffff8802186f2fa8 RSI: ffff88022bd0e4f0 RDI: ffffffff81a050b0
RBP: ffff88022bd03ee8 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e48
R13: ffffffff815d15dd R14: ffff88022bd03ee8 R15: ffff8802186f2fb0
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffffffff81a050b0 ffff880222218000 ffff88022bd03f78 ffffffff8109db1f
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000030
Call Trace:
  <IRQ>
  [<ffffffff8109db1f>] __do_softirq+0x107/0x23c
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 10 85 c0 75 20 f0 41 0f ba 34 24 00 19 c0 85 c0 75 04 0f 0b eb fe 48 8b 7a 20 ff 52 18 f0 41 80 24 24 fd eb 3a f0 41 80 24 24 fd <fa> 66 66 90 66 66 90 bf 
06 0
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109d712>]  [<ffffffff8109d712>] tasklet_action+0xbc/0xcc
RSP: 0018:ffff88022bd03ed8  EFLAGS: 00000202
RAX: 0000000000000040 RBX: ffff880222185dc0 RCX: ffff88022bd0e506
RDX: ffff8802186f2fa8 RSI: ffff88022bd0e4f0 RDI: 0000000000000006
RBP: ffff88022bd03ee8 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e48
R13: ffffffff815d15dd R14: ffff88022bd03ee8 R15: ffff8802186f2fb0
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffffffff81a050b0 ffff880222218000 ffff88022bd03f78 ffffffff8109db1f
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000030
Call Trace:
  <IRQ>
  [<ffffffff8109db1f>] __do_softirq+0x107/0x23c
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 90 bf 06 00 00 00 48 c7 02 00 00 00 00 65 48 8b 04 25 88 e0 00 00 48 89 10 65 48 89 14 25 88 e0 00 00 e8 1c fe ff ff fb 66 66 90 <66> 66 90 48 89 da 48 85 
d2 7
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:23]
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
CPU 2
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109daab>]  [<ffffffff8109daab>] __do_softirq+0x93/0x23c
RSP: 0018:ffff88022bd03ef8  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffff88022bd0e506
RDX: ffff880222218010 RSI: ffff88022bd0e4f0 RDI: 0000000000000002
RBP: ffff88022bd03f78 R08: ffff88022bd0e770 R09: 0000000000000001
R10: ffff88022bd13de0 R11: 0000000000000002 R12: ffff88022bd03e68
R13: ffffffff815d15dd R14: ffff88022bd03f78 R15: ffff880222218000
FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f22cc3e7000 CR3: 0000000001a0c000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
Stack:
  ffff88022bd03f08 ffff880222218010 ffff880222219fd8 04208040810b79ef
  00000000fffc8ad1 000000022bd0e150 ffff880222218000 0000000000000038
  ffff880200000006 000000111671cb12 000000111671cb12 ffff88022bd0db00
Call Trace:
  <IRQ>
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 89 45 90 49 8d 44 24 10 4c 89 65 b0 65 8b 14 25 20 b0 00 00 48 89 45 88 89 55 ac 65 c7 04 25 40 13 01 00 00 00 00 00 fb 66 66 90 <66> 66 90 48 c7 c3 80 50 
a0 8
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux-3.9.dev.y/kernel/watchdog.c:245 watchdog_overflow_callback+0x9b/0xa6()
Hardware name: To be filled by O.E.M.
Watchdog detected hard LOCKUP on cpu 2
Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_powerclamp snd_hda_codec_realtek kvm 
gpio]
Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #70
Call Trace:
  <NMI>  [<ffffffff810963e1>] warn_slowpath_common+0x85/0x9f
  [<ffffffff8109649e>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff810c4dfb>] ? sched_clock_cpu+0x44/0xce
  [<ffffffff81103cec>] watchdog_overflow_callback+0x9b/0xa6
  [<ffffffff811336cb>] __perf_event_overflow+0x137/0x1cb
  [<ffffffff8101db3f>] ? x86_perf_event_set_period+0x107/0x113
  [<ffffffff81133c1a>] perf_event_overflow+0x14/0x16
  [<ffffffff810230dc>] intel_pmu_handle_irq+0x2b0/0x32d
  [<ffffffff815cbdd1>] perf_event_nmi_handler+0x19/0x1b
  [<ffffffff815cb64a>] nmi_handle+0x55/0x7e
  [<ffffffff815cb71b>] do_nmi+0xa8/0x2db
  [<ffffffff815cadb1>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff8109dad4>] ? __do_softirq+0xbc/0x23c
  [<ffffffff8109dad4>] ? __do_softirq+0xbc/0x23c
  [<ffffffff8109dad4>] ? __do_softirq+0xbc/0x23c
  <<EOE>>  <IRQ>  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d26ff>] smp_apic_timer_interrupt+0x8b/0x99
  [<ffffffff815d15dd>] apic_timer_interrupt+0x6d/0x80
  <EOI>  [<ffffffff810f99a4>] ? stop_machine_cpu_stop+0xe7/0x267
  [<ffffffff810f9afd>] ? stop_machine_cpu_stop+0x240/0x267
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810e817b>] ? copy_module_from_fd+0xe7/0xe7
  [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c91e5>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d092c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
---[ end trace 9767454fd3f66a82 ]---

  CTRL-A Z for help |115200 8N1 | NOR | Minicom 2.5    | VT102 | Online 15:23 




>
> Thanks.
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

