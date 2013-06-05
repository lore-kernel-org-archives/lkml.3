Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3FEEqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 00:46:54 -0400
Received: from ozlabs.org ([203.10.76.45]:57287 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab3FEEq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 00:46:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Greear <greearb@candelatech.com>,
        Joe Lawrence <joe.lawrence@stratus.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: Please add to stable:  module: don't unlink the module until we've removed all exposure.
In-Reply-To: <51AE27D5.7050202@candelatech.com>
References: <51A8E884.1080009@candelatech.com> <87ehclumhr.fsf@rustcorp.com.au> <alpine.DEB.2.02.1306022212200.10003@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306030724230.19647@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com> <51ACBD6A.1030304@candelatech.com> <51ACC60B.8090504@candelatech.com> <87d2s2to4z.fsf@rustcorp.com.au> <20130604100744.7cdf8777@jlaw-desktop.mno.stratus.com> <51AE1B81.20900@candelatech.com> <51AE27D5.7050202@candelatech.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 05 Jun 2013 13:47:43 +0930
Message-ID: <87sj0xry1k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear <greearb@candelatech.com> writes:
> On 06/04/2013 09:53 AM, Ben Greear wrote:
>> On 06/04/2013 07:07 AM, Joe Lawrence wrote:
>>> On Tue, 04 Jun 2013 15:26:28 +0930
>>> Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>
>>>> Do you have a backtrace of the 3.9.4 crash?  You can add "CFLAGS_module.o
>>>> = -O0" to get a clearer backtrace if you want...
>>>
>>> Hi Rusty,
>>>
>>> See my 3.9 stack traces below, which may or may not be what Ben had
>>> been seeing.  If you like, I can try a similar loop as the one you were
>>> testing in the other email.
>>
>> My stack traces are similar.  I had better luck reproducing the problem
>> once I enabled lots of debugging (slub memory poisoning, lockdep,
>> object debugging, etc).
>>
>> I'm using Fedora 17 on 2-core core-i7 (4 CPU threads total) for most of this
>> testing.  We reproduced on dual-core Atom system as well
>> (32-bit Fedora 14 and Fedora 17).  Relatively standard hardware as far
>> as I know.
>>
>> I'll run the insmod/rmmod stress test on my patched systems
>> and see if I can reproduce with the patch in the title applied.
>>
>> Rusty:  I'm also seeing lockups related to migration on stock 3.9.4+
>> (with and without the 'don't unlink the module...' patch.  Much harder
>> to reproduce.  But, that code appears to be mostly called during
>> module load/unload, so it's possible it is related.  The first
>> traces are from a system with local patches, applied, but a later
>> post by me has traces from clean upstream kernel.
>>
>> Further debugging showed that this could be a race, because it seems
>> that all migration/ threads think they are done with their state machine,
>> but the atomic thread counter sits at 1, so no progress is ever made.
>>
>> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg443471.html
>
> I reproduced the migration deadlock after a while (loading and unloading
> the macvlan module with this command:
>
> for i in `seq 10000`; do modprobe macvlan; rmmod macvlan; done
>
> I did not see the kobj crash, but this kernel was running your patch
> that makes the problem go away for me, for whatever reason.
>
> I have some printk debugging in (see bottom of email) and was using a serial console, so things
> were probably running a bit slower than on most systems.  Here is trace
> from my kernel with local patches and not so much debugging enabled
> (this is NOT a clean upstream kernel, though I reproduced the same thing
> with a clean upstream 3.9.4 kernel plus your module unlink patch yesterday).

Tejun CC'd.  We can't be running two stop machines in parallel, since
there's a mutex (and there's also one in the module code).

> __stop_machine, num-threads: 4, fn: __try_stop_module  data: ffff8801c6ae7f28
> cpu: 0 loops: 1 jiffies: 4299011449  timeout: 4299011448 curstate: 0  smdata->state: 1  thread_ack: 4
> cpu: 1 loops: 1 jiffies: 4299011449  timeout: 4299011448 curstate: 0  smdata->state: 1  thread_ack: 4
> cpu: 2 loops: 1 jiffies: 4299011449  timeout: 4299011448 curstate: 0  smdata->state: 1  thread_ack: 3
> cpu: 3 loops: 1 jiffies: 4299011449  timeout: 4299011448 curstate: 0  smdata->state: 1  thread_ack: 2
> __stop_machine, num-threads: 4, fn: __unlink_module  data: ffffffffa0aeeab0
> cpu: 0 loops: 1 jiffies: 4299011501  timeout: 4299011500 curstate: 0  smdata->state: 1  thread_ack: 4
> cpu: 1 loops: 1 jiffies: 4299011501  timeout: 4299011500 curstate: 0  smdata->state: 1  thread_ack: 4
> cpu: 3 loops: 1 jiffies: 4299011501  timeout: 4299011500 curstate: 0  smdata->state: 1  thread_ack: 3
> ath: wiphy0: Failed to stop TX DMA, queues=0x005!
> cpu: 2 loops: 1 jiffies: 4299011501  timeout: 4299011500 curstate: 0  smdata->state: 1  thread_ack: 2

What's the ath driver doing here?  Or is that failure normal?

Your patch was mangled (unfinished?) but this doesn't show any timeouts
happening.  I guess you hit STOPMACHINE_DISABLE_IRQ and turned
interrupts off, so no jiffies increment.

Try using the loop counter, with some value big enough that it doesn't
trip normally.


> BUG: soft lockup - CPU#3 stuck for 23s! [migration/3:29]
> Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_po]
> CPU 3
> Pid: 29, comm: migration/3 Tainted: G         C O 3.9.4+ #60 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.
> RIP: 0010:[<ffffffff8109d69c>]  [<ffffffff8109d69c>] tasklet_action+0x46/0xcc
> RSP: 0000:ffff88022bd83ed8  EFLAGS: 00000282
> RAX: ffff88022bd8e080 RBX: ffff8802222a4000 RCX: ffffffff81a90f06
> RDX: ffff88021f48afa8 RSI: 0000000000000000 RDI: ffffffff81a050b0
> RBP: ffff88022bd83ee8 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000000005f2 R11: 00000000fd010018 R12: ffff88022bd83e48
> R13: ffffffff815d145d R14: ffff88022bd83ee8 R15: ffff880222282000
> FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007fa8a06d5000 CR3: 00000002007ea000 CR4: 00000000000007e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process migration/3 (pid: 29, threadinfo ffff880222282000, task ffff880222279770)
> Stack:
>   ffffffff81a050b0 ffff880222282000 ffff88022bd83f78 ffffffff8109db1f
>   ffff88022bd83f08 ffff880222282010 ffff880222283fd8 04208040810b79ef
>   00000001003db5d8 000000032bd8e150 ffff880222282000 0000000000000030
> Call Trace:
>   <IRQ>
>   [<ffffffff8109db1f>] __do_softirq+0x107/0x23c
>   [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
>   [<ffffffff815d257f>] smp_apic_timer_interrupt+0x8b/0x99
>   [<ffffffff815d145d>] apic_timer_interrupt+0x6d/0x80
>   <EOI>
>   [<ffffffff810f9984>] ? stop_machine_cpu_stop+0xc7/0x145
>   [<ffffffff810f9974>] ? stop_machine_cpu_stop+0xb7/0x145
>   [<ffffffff81016445>] ? sched_clock+0x9/0xd
>   [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
>   [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
>   [<ffffffff815c9065>] ? __schedule+0x59f/0x5e7
>   [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
>   [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
>   [<ffffffff810b4a09>] kthread+0xb5/0xbd
>   [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
>   [<ffffffff815d07ac>] ret_from_fork+0x7c/0xb0
>   [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
> Code: 48 8b 14 25 80 e0 00 00 65 48 c7 04 25 80 e0 00 00 00 00 00 00 65 48 03 04 25 d8 da 00 00 65 48 89 04 25 88 e0 00 00 fb
> ------------[ cut here ]------------
> WARNING: at /home/greearb/git/linux-3.9.dev.y/kernel/watchdog.c:245 watchdog_overflow_callback+0x9b/0xa6()
> Hardware name: To be filled by O.E.M.
> Watchdog detected hard LOCKUP on cpu 1
> Modules linked in: nf_nat_ipv4 nf_nat veth 8021q garp stp mrp llc wanlink(O) pktgen lockd sunrpc coretemp hwmon mperf intel_po]
> Pid: 17, comm: migration/1 Tainted: G         C O 3.9.4+ #60
> Call Trace:
>   <NMI>  [<ffffffff810963e1>] warn_slowpath_common+0x85/0x9f
>   [<ffffffff8109649e>] warn_slowpath_fmt+0x46/0x48
>   [<ffffffff810c4dfb>] ? sched_clock_cpu+0x44/0xce
>   [<ffffffff81103b70>] watchdog_overflow_callback+0x9b/0xa6
>   [<ffffffff8113354f>] __perf_event_overflow+0x137/0x1cb
>   [<ffffffff8101db3f>] ? x86_perf_event_set_period+0x107/0x113
>   [<ffffffff81133a9e>] perf_event_overflow+0x14/0x16
>   [<ffffffff810230dc>] intel_pmu_handle_irq+0x2b0/0x32d
>   [<ffffffff815cbc51>] perf_event_nmi_handler+0x19/0x1b
>   [<ffffffff815cb4ca>] nmi_handle+0x55/0x7e
>   [<ffffffff815cb59b>] do_nmi+0xa8/0x2db
>   [<ffffffff815cac31>] end_repeat_nmi+0x1e/0x2e
>   [<ffffffff810f9942>] ? stop_machine_cpu_stop+0x85/0x145
>   [<ffffffff810f9942>] ? stop_machine_cpu_stop+0x85/0x145
>   [<ffffffff810f9942>] ? stop_machine_cpu_stop+0x85/0x145
>   <<EOE>>  [<ffffffff810c6b1c>] ? set_next_entity+0x28/0x7e
>   [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
>   [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
>   [<ffffffff815c9065>] ? __schedule+0x59f/0x5e7
>   [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
>   [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
>   [<ffffffff810b4a09>] kthread+0xb5/0xbd
>   [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
>   [<ffffffff815d07ac>] ret_from_fork+0x7c/0xb0
>   [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
> ---[ end trace dcd772d6fdf499cf ]---
>
> ...
>
>
> SysRq : Show backtrace of all active CPUs
> sending NMI to all CPUs:
> NMI backtrace for cpu 2
> CPU 2
> Pid: 23, comm: migration/2 Tainted: G        WC O 3.9.4+ #60 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.
> RIP: 0010:[<ffffffff810f9987>]  [<ffffffff810f9987>] stop_machine_cpu_stop+0xca/0x145
> RSP: 0018:ffff880222219cf8  EFLAGS: 00000012
> RAX: 00000001003db5d7 RBX: ffff8801c6ae7e18 RCX: 0000000000000097
> RDX: 0000000000000002 RSI: 0000000000000006 RDI: 0000000000000246
> RBP: ffff880222219d68 R08: 00000001003dc935 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801c6ae7e3c
> R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000002
> FS:  0000000000000000(0000) GS:ffff88022bd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000027e2178 CR3: 000000021955d000 CR4: 00000000000007e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process migration/2 (pid: 23, threadinfo ffff880222218000, task ffff880222210000)
> Stack:
>   ffff880200000001 ffff880200000002 ffff880222219d28 ffffffff810c6b1c
>   ffff880222219d88 00ffffff8100f8a4 000000051058262e 0000000000000292
>   ffff880222219d58 ffff88022bd0e400 ffff8801c6ae7d08 ffff880222218000
> Call Trace:
>   [<ffffffff810c6b1c>] ? set_next_entity+0x28/0x7e
>   [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
>   [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
>   [<ffffffff815c9065>] ? __schedule+0x59f/0x5e7
>   [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
>   [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
>   [<ffffffff810b4a09>] kthread+0xb5/0xbd
>   [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
>   [<ffffffff815d07ac>] ret_from_fork+0x7c/0xb0
>   [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
> Code: 48 c7 c7 24 fa 80 81 89 44 24 08 8b 43 20 89 04 24 31 c0 e8 7a e1 4c 00 4c 8b 05 85 c6 9e 00 49 81 c0 88 13 00 00 f3 90
> NMI backtrace for cpu 0
> CPU 0
> Pid: 8, comm: migration/0 Tainted: G        WC O 3.9.4+ #60 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E..
> RIP: 0010:[<ffffffff810f9984>]  [<ffffffff810f9984>] stop_machine_cpu_stop+0xc7/0x145
> RSP: 0000:ffff880222145cf8  EFLAGS: 00000006
> RAX: 00000001003db5d7 RBX: ffff8801c6ae7e18 RCX: 0000000000000004
> RDX: 0000000000000002 RSI: ffff88022bc0de68 RDI: 0000000000000246
> RBP: ffff880222145d68 R08: 00000001003dc95f R09: 0000000000000001
> R10: ffff880222145bf8 R11: 0000000000000000 R12: ffff8801c6ae7e3c
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000002
> FS:  0000000000000000(0000) GS:ffff88022bc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000006fb9a8 CR3: 000000021af43000 CR4: 00000000000007f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process migration/0 (pid: 8, threadinfo ffff880222144000, task ffff88022213aee0)
> Stack:
>   ffff880200000001 ffff880200000004 ffff880222145d28 ffffffff810c6b1c
>   ffff880222145d88 01ffffff8100f8a4 000000051023ce2c 0000000000000292
>   ffff880222145d98 ffff88022bc0e400 ffff8801c6ae7d08 ffff880222144000
> Call Trace:
>   [<ffffffff810c6b1c>] ? set_next_entity+0x28/0x7e
>   [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
>   [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
>   [<ffffffff815c9065>] ? __schedule+0x59f/0x5e7
>   [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
>   [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
>   [<ffffffff810b4a09>] kthread+0xb5/0xbd
>   [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
>   [<ffffffff815d07ac>] ret_from_fork+0x7c/0xb0
>   [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
> Code: 44 89 f6 48 c7 c7 24 fa 80 81 89 44 24 08 8b 43 20 89 04 24 31 c0 e8 7a e1 4c 00 4c 8b 05 85 c6 9e 00 49 81 c0 88 13 00
> NMI backtrace for cpu 1
> CPU 1
> Pid: 17, comm: migration/1 Tainted: G        WC O 3.9.4+ #60 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.
> RIP: 0010:[<ffffffff810f9984>]  [<ffffffff810f9984>] stop_machine_cpu_stop+0xc7/0x145
> RSP: 0000:ffff88022217dcf8  EFLAGS: 00000012
> RAX: 00000001003db5d7 RBX: ffff8801c6ae7e18 RCX: 0000000000000094
> RDX: 0000000000000002 RSI: 0000000000000006 RDI: 0000000000000246
> RBP: ffff88022217dd68 R08: 00000001003dc935 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801c6ae7e3c
> R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000002
> FS:  0000000000000000(0000) GS:ffff88022bc80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007fbe801fd000 CR3: 00000001be9bb000 CR4: 00000000000007e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process migration/1 (pid: 17, threadinfo ffff88022217c000, task ffff88022216ddc0)
> Stack:
>   ffff880200000001 ffff880200000004 ffff88022217dd28 ffffffff810c6b1c
>   ffff88022217dd88 00ffffff8100f8a4 00000004c3cbfc0c 0000000000000292
>   ffff88022217dd58 ffff88022bc8e400 ffff8801c6ae7d08 ffff88022217c000
> Call Trace:
>   [<ffffffff810c6b1c>] ? set_next_entity+0x28/0x7e
>   [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
>   [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
>   [<ffffffff815c9065>] ? __schedule+0x59f/0x5e7
>   [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
>   [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
>   [<ffffffff810b4a09>] kthread+0xb5/0xbd
>   [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
>   [<ffffffff815d07ac>] ret_from_fork+0x7c/0xb0
>   [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
> Code: 44 89 f6 48 c7 c7 24 fa 80 81 89 44 24 08 8b 43 20 89 04 24 31 c0 e8 7a e1 4c 00 4c 8b 05 85 c6 9e 00 49 81 c0 88 13 00
> NMI backtrace for cpu 3
> CPU 3
> Pid: 29, comm: migration/3 Tainted: G        WC O 3.9.4+ #60 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.
> RIP: 0010:[<ffffffff812f6975>]  [<ffffffff812f6975>] delay_tsc+0x83/0xee
> RSP: 0000:ffff88022bd83b60  EFLAGS: 00000046
> RAX: 00000b04f0fdf718 RBX: ffff880222282000 RCX: ffff880222282010
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000289672
> RBP: ffff88022bd83bb0 R08: 0000000000000040 R09: 0000000000000001
> R10: ffff88022bd83ad0 R11: 0000000000000000 R12: 00000000f0fdf6e8
> R13: 0000000000000003 R14: ffff880222282000 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff88022bd80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007fa8a06d5000 CR3: 00000002007ea000 CR4: 00000000000007e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process migration/3 (pid: 29, threadinfo ffff880222282000, task ffff880222279770)
> Stack:
>   000000000000000f 0000000000000002 ffff880222282010 0028967200000082
>   ffff88022bd83b90 0000000000000001 000000000000006c 0000000000000007
>   0000000000000086 0000000000000001 ffff88022bd83bc0 ffffffff812f68c5
> Call Trace:
>   <IRQ>
>   [<ffffffff812f68c5>] __const_udelay+0x28/0x2a
>   [<ffffffff8102ff25>] arch_trigger_all_cpu_backtrace+0x66/0x7d
>   [<ffffffff813ae154>] sysrq_handle_showallcpus+0xe/0x10
>   [<ffffffff813ae46b>] __handle_sysrq+0xbf/0x15b
>   [<ffffffff813ae80e>] handle_sysrq+0x2c/0x2e
>   [<ffffffff813c25a2>] serial8250_rx_chars+0x13c/0x1b9
>   [<ffffffff813c2691>] serial8250_handle_irq+0x72/0xa8
>   [<ffffffff813c2752>] serial8250_default_handle_irq+0x23/0x28
>   [<ffffffff813c148c>] serial8250_interrupt+0x4d/0xc6
>   [<ffffffff811046b8>] handle_irq_event_percpu+0x7a/0x1e5
>   [<ffffffff81104864>] handle_irq_event+0x41/0x61
>   [<ffffffff81107028>] handle_edge_irq+0xa6/0xcb
>   [<ffffffff81011d9f>] handle_irq+0x24/0x2d
>   [<ffffffff815d248d>] do_IRQ+0x4d/0xb4
>   [<ffffffff815ca5ad>] common_interrupt+0x6d/0x6d
>   [<ffffffff810a47ee>] ? run_timer_softirq+0x24/0x1df
>   [<ffffffff8109dabd>] ? __do_softirq+0xa5/0x23c
>   [<ffffffff8109db8a>] ? __do_softirq+0x172/0x23c
>   [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
>   [<ffffffff815d257f>] smp_apic_timer_interrupt+0x8b/0x99
>   [<ffffffff815d145d>] apic_timer_interrupt+0x6d/0x80
>   <EOI>
>   [<ffffffff810f9984>] ? stop_machine_cpu_stop+0xc7/0x145
>   [<ffffffff810f9974>] ? stop_machine_cpu_stop+0xb7/0x145
>   [<ffffffff81016445>] ? sched_clock+0x9/0xd
>   [<ffffffff810f98bd>] ? stop_one_cpu_nowait+0x30/0x30
>   [<ffffffff810f9624>] cpu_stopper_thread+0xbd/0x176
>   [<ffffffff815c9065>] ? __schedule+0x59f/0x5e7
>   [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
>   [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
>   [<ffffffff810b4a09>] kthread+0xb5/0xbd
>   [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
>   [<ffffffff815d07ac>] ret_from_fork+0x7c/0xb0
>   [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
> Code: fa d1 ff 66 90 89 c2 44 29 e2 3b 55 cc 73 4a ff 4b 1c 48 8b 4d c0 48 8b 11 80 e2 08 74 0b 89 45 b8 e8 08 28 2d 00 8b 45

So everyone's doing stop_machine, but noone's making progress.  I'd like
to know why...

Cheers,
Rusty.
