Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaIYP3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:29:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60726 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbaIYP3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:29:20 -0400
Date: Thu, 25 Sep 2014 16:28:26 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: will.deacon@arm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Perf lockups / stack overflows on v3.17-rc6, x86_64, arm, arm64
Message-ID: <20140925152825.GA6531@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've been running Vince's fuzzer (latest HEAD, 8338ecf4a6fb6892) to test some
local perf patches, and in doing so I've encountered a number of lockups on
vanilla v3.17-rc6, on arm, arm64, and x86_64 (I've not tested 32-bit x86).

The two x86_64 logs below show the typical lockup case and a rare stack
overflow that may or may not be related, both recorded from a Core 2 system.
I'm able to trigger lockups on a Haswell system, but as that's my development
machine acquiring logs is a little tricky. Both are possible to trigger within
a minute or two.

On arm64 I'm able to trigger lockups after a number (10+ usually) of minutes,
and I'm able to dump the stack on the RCU stalling CPU so long as it isn't
CPU0. From a prior dump I spotted that the stalled CPU was somewhere in
do_softirq_ownstack, and my hacked in softirq accounting shows it doesn't seem
to be making any progress with softirqs. I haven't yet figured out what it's
doing.

Has anyone seen anything like this, or does anyone have any ideas as to what
might be going on? I didn't spot anything in tip/perf/urgent so I assume these
aren't known issues.

Thanks,
Mark.

Log 1, x86_64 lockup
---->8----
*** perf_fuzzer 0.29-pre *** by Vince Weaver

        Linux version 3.17.0-rc6hark-perf-lockup+ x86_64
        Processor: Intel 6/23/10

        Seeding random number generator with 1411655463
        /proc/sys/kernel/perf_event_max_sample_rate currently: 100000/s
        /proc/sys/kernel/perf_event_paranoid currently: 1
        Logging perf_event_open() failures: no
        Running fsync after every syscall: no
        To reproduce, try: ./perf_fuzzer -r 1411655463

Pid=2723, sleeping 1s
==================================================
Fuzzing the following syscalls:
        mmap perf_event_open close read write ioctl fork prctl poll
*NOT* Fuzzing the following syscalls:

Also attempting the following:
        signal-handler-on-overflow busy-instruction-loop accessing-perf-proc-and-sys-files trashing-the-mmap-page
*NOT* attempting the following:

==================================================

... userspace output removed ...

[  157.280682] NOHZ: local_softirq_pending 100
[  223.007005] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 3, t=21006 jiffies, g=25497, c=25496, q=3)
[  223.007005] Task dump for CPU 1:
[  223.007005] accounts-daemon R  running task    13712  2237      1 0x10000000
[  223.007005]  ffff8801ae8d3a60 0000000000000082 ffff8800e3df08d0 ffff8801ae8d3fd8
[  223.007005]  0000000000012900 0000000000012900 ffff8801b64d4f50 ffff8800e3df08d0
[  223.007005]  ffff8801ae8d3b98 00000000003cf95e 0000000000000000 ffff8801ae8d3bc4
[  223.007005] Call Trace:
[  223.007005]  [<ffffffff81911f34>] schedule+0x24/0x70
[  223.007005]  [<ffffffff81914ebc>] schedule_hrtimeout_range_clock+0xfc/0x140
[  223.007005]  [<ffffffff8109cc40>] ? hrtimer_get_res+0x40/0x40
[  223.007005]  [<ffffffff81914e52>] ? schedule_hrtimeout_range_clock+0x92/0x140
[  223.007005]  [<ffffffff81914f0e>] schedule_hrtimeout_range+0xe/0x10
[  223.007005]  [<ffffffff81168794>] poll_schedule_timeout+0x44/0x60
[  223.007005]  [<ffffffff81169d22>] do_sys_poll+0x422/0x540
[  223.007005]  [<ffffffff8180e6b6>] ? unix_stream_sendmsg+0x3e6/0x420
[  223.007005]  [<ffffffff812908fb>] ? selinux_inode_permission+0x9b/0x150
[  223.007005]  [<ffffffff81168910>] ? poll_select_copy_remaining+0x130/0x130
[  223.007005]  [<ffffffff81168910>] ? poll_select_copy_remaining+0x130/0x130
[  223.007005]  [<ffffffff81168910>] ? poll_select_copy_remaining+0x130/0x130
[  223.007005]  [<ffffffff811600ea>] ? getname_flags+0x4a/0x1a0
[  223.007005]  [<ffffffff8116007d>] ? final_putname+0x1d/0x40
[  223.007005]  [<ffffffff811602f4>] ? putname+0x24/0x40
[  223.007005]  [<ffffffff8116581a>] ? user_path_at_empty+0x5a/0x90
[  223.007005]  [<ffffffff810701c0>] ? wake_up_state+0x10/0x10
[  223.007005]  [<ffffffff81198078>] ? eventfd_read+0x38/0x60
[  223.007005]  [<ffffffff810a1e75>] ? ktime_get_ts64+0x45/0xf0
[  223.007005]  [<ffffffff81169f00>] SyS_poll+0x60/0xf0
[  223.007005]  [<ffffffff81915bd2>] system_call_fastpath+0x16/0x1b
[  286.012004] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 3, t=84007 jiffies, g=25497, c=25496, q=2003)
[  286.012004] Task dump for CPU 1:
[  286.012004] accounts-daemon R  running task    13712  2237      1 0x10000000
[  286.012004]  ffff8801ae8d3a60 0000000000000082 ffff8800e3df08d0 ffff8801ae8d3fd8
[  286.012004]  0000000000012900 0000000000012900 ffff8801b64d4f50 ffff8800e3df08d0
[  286.012004]  ffff8801ae8d3b98 00000000003cf95e 0000000000000000 ffff8801ae8d3bc4
[  286.012004] Call Trace:
[  286.012004]  [<ffffffff81911f34>] schedule+0x24/0x70
[  286.012004]  [<ffffffff81914ebc>] schedule_hrtimeout_range_clock+0xfc/0x140
[  286.012004]  [<ffffffff8109cc40>] ? hrtimer_get_res+0x40/0x40
[  286.012004]  [<ffffffff81914e52>] ? schedule_hrtimeout_range_clock+0x92/0x140
[  286.012004]  [<ffffffff81914f0e>] schedule_hrtimeout_range+0xe/0x10
[  286.012004]  [<ffffffff81168794>] poll_schedule_timeout+0x44/0x60
[  286.012004]  [<ffffffff81169d22>] do_sys_poll+0x422/0x540
[  286.012004]  [<ffffffff8180e6b6>] ? unix_stream_sendmsg+0x3e6/0x420
[  286.012004]  [<ffffffff812908fb>] ? selinux_inode_permission+0x9b/0x150
[  286.012004]  [<ffffffff81168910>] ? poll_select_copy_remaining+0x130/0x130
[  286.012004]  [<ffffffff81168910>] ? poll_select_copy_remaining+0x130/0x130
[  286.012004]  [<ffffffff81168910>] ? poll_select_copy_remaining+0x130/0x130
[  286.012004]  [<ffffffff811600ea>] ? getname_flags+0x4a/0x1a0
[  286.012004]  [<ffffffff8116007d>] ? final_putname+0x1d/0x40
[  286.012004]  [<ffffffff811602f4>] ? putname+0x24/0x40
[  286.012004]  [<ffffffff8116581a>] ? user_path_at_empty+0x5a/0x90
[  286.012004]  [<ffffffff810701c0>] ? wake_up_state+0x10/0x10
[  286.012004]  [<ffffffff81198078>] ? eventfd_read+0x38/0x60
[  286.012004]  [<ffffffff810a1e75>] ? ktime_get_ts64+0x45/0xf0
[  286.012004]  [<ffffffff81169f00>] SyS_poll+0x60/0xf0
[  286.012004]  [<ffffffff81915bd2>] system_call_fastpath+0x16/0x1b
----8<----


Log 2, x86_64 stack overflow
---->8----
[mark@trouble-every-day:~/src/perf_event_tests/fuzzer]% ./perf_fuzzer

*** perf_fuzzer 0.29-pre *** by Vince Weaver

        Linux version 3.17.0-rc6hark-perf-lockup+ x86_64
        Processor: Intel 6/23/10

        Seeding random number generator with 1411654897
        /proc/sys/kernel/perf_event_max_sample_rate currently: 100000/s
        /proc/sys/kernel/perf_event_paranoid currently: 1
        Logging perf_event_open() failures: no
        Running fsync after every syscall: no
        To reproduce, try: ./perf_fuzzer -r 1411654897

Pid=4076, sleeping 1s
==================================================
Fuzzing the following syscalls:
        mmap perf_event_open close read write ioctl fork prctl poll
*NOT* Fuzzing the following syscalls:

Also attempting the following:
        signal-handler-on-overflow busy-instruction-loop accessing-perf-proc-and-sys-files trashing-the-mmap-page
*NOT* attempting the following:

==================================================

... userspace output removed ...

[  317.153501] NOHZ: local_softirq_pending 100
[  317.174346] hrtimer: interrupt took 16623 ns
[  333.608592] NOHZ: local_softirq_pending 100
[  337.204944] NOHZ: local_softirq_pending 100
[  346.641345] divide error: 0000 [#1] SMP
[  346.642010] Modules linked in:
[  346.642010] CPU: 0 PID: 4076 Comm: perf_fuzzer Not tainted 3.17.0-rc6hark-perf-lockup+ #1
[  346.642010] Hardware name: LENOVO 7484A3G/LENOVO, BIOS 5CKT54AUS 09/07/2009
[  346.642010] task: ffff8801ac449a70 ti: ffff8801ac574000 task.ti: ffff8801ac574000
[  346.642010] RIP: 0010:[<ffffffff81078bce>]  [<ffffffff81078bce>] find_busiest_group+0x28e/0x8a0
[  346.642010] RSP: 0018:ffff8801ac577760  EFLAGS: 00010006
[  346.642010] RAX: 00000000000003ff RBX: 0000000000000000 RCX: 00000000ffff8801
[  346.642010] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
[  346.642010] RBP: ffff8801ac577890 R08: 0000000000000000 R09: 0000000000000000
[  346.704010] ------------[ cut here ]------------
[  346.704017] WARNING: CPU: 2 PID: 5 at arch/x86/kernel/irq_64.c:70 handle_irq+0x141/0x150()
[  346.704019] do_IRQ():  has overflown the kernel stack (cur:1,sp:ffff8801b653fe88,irq stk top-bottom:ffff8801bed00080-ffff8801bed03fc0,exception stk top-bottom:ffff8801bed04080-ffff8801bed0a000)
[  346.704021] Modules linked in:
[  346.704023] CPU: 2 PID: 5 Comm:  Not tainted 3.17.0-rc6hark-perf-lockup+ #1
[  346.704023] Hardware name: LENOVO 7484A3G/LENOVO, BIOS 5CKT54AUS 09/07/2009
[  346.704033]  0000000000000009 ffff8801bed03ea0 ffffffff8190b255 ffff8801bed03ee8
[  346.704035]  ffff8801bed03ed8 ffffffff8104ac28 000000000000001a 000000000000001a
[  346.704036]  0000000000000061 0000000000000061 0000000000000000 ffff8801bed03f38
[  346.704037]
----8<----

Log 3, arm64 lockup
---->8----
root@localhost:~/src/perf_event_tests/fuzzer# ./perf_fuzzer -r 1411488270
Using user-specified random seed of 1411488270

*** perf_fuzzer 0.29-pre *** by Vince Weaver

        Linux version 3.17.0-rc6+ aarch64
        Processor: UNKNOWN  0/0/0

        Seeding random number generator with 1411488270
        /proc/sys/kernel/perf_event_max_sample_rate currently: 285518974/s
        /proc/sys/kernel/perf_event_paranoid currently: 1142898651
        Logging perf_event_open() failures: no
        Running fsync after every syscall: no
        To reproduce, try: ./perf_fuzzer -r 1411488270

Pid=18435, sleeping 1s
==================================================
Fuzzing the following syscalls:
        mmap perf_event_open close read write ioctl fork prctl poll
*NOT* Fuzzing the following syscalls:

Also attempting the following:
        signal-handler-on-overflow busy-instruction-loop accessing-perf-proc-and-sys-files trashing-the-mmap-page
*NOT* attempting the following:

==================================================

... userspace output removed ...

INFO: rcu_preempt self-detected stall on CPU { 3}  (t=2100 jiffies g=73728 c=73727 q=90)
Task dump for CPU 3:
swapper/3       R  running task        0     0      1 0x00000002
Call trace:
[<ffffffc000088110>] dump_backtrace+0x0/0x130
[<ffffffc000088250>] show_stack+0x10/0x1c
[<ffffffc0000cf57c>] sched_show_task+0xe0/0x134
[<ffffffc0000d2654>] dump_cpu_task+0x3c/0x4c
[<ffffffc0000f3414>] rcu_dump_cpu_stacks+0x98/0xe8
[<ffffffc0000f68a0>] rcu_check_callbacks+0x4b0/0x8c4
[<ffffffc0000fa43c>] update_process_times+0x48/0x78
[<ffffffc000108b80>] tick_sched_handle.isra.18+0x1c/0x68
[<ffffffc000108c18>] tick_sched_timer+0x4c/0x78
[<ffffffc0000fab44>] __run_hrtimer.isra.33+0x48/0x104
[<ffffffc0000fb210>] hrtimer_interrupt+0x104/0x29c
[<ffffffc00040b0bc>] arch_timer_handler_phys+0x28/0x38
[<ffffffc0000efd5c>] handle_percpu_devid_irq+0x90/0xb8
[<ffffffc0000ebe20>] generic_handle_irq+0x30/0x4c
[<ffffffc0000848b8>] handle_IRQ+0x68/0xe0
[<ffffffc000081290>] gic_handle_irq+0x3c/0x80
Exception stack(0xffffffc975d67bf0 to 0xffffffc975d67d10)
7be0:                                     75d64000 ffffffc9 006d9dd8 ffffffc0
7c00: 75d67d30 ffffffc9 000af0b8 ffffffc0 000000c0 00000000 0073be00 ffffffc0
7c20: 75d67ce0 ffffffc9 00000101 00000000 0040b168 ffffffc0 00000020 00000000
7c40: 0ccccccd 00000000 006d8a28 ffffffc0 006d8a20 ffffffc0 00000001 00000000
7c60: 00000000 00000000 75d59340 ffffffc9 00000001 00000000 00000068 00000000
7c80: 0000004c 00000000 00000033 00000000 00000019 00000000 00000001 00000000
7ca0: 0000000e 00000000 75d64000 ffffffc9 006d9dd8 ffffffc0 75d64000 ffffffc9
7cc0: 006e2000 ffffffc0 0000001e 00000000 00000000 00000000 00000001 00000000
7ce0: 006d8a28 ffffffc0 00000002 00000000 006d8a20 ffffffc0 75d67d30 ffffffc9
7d00: 000af0a4 ffffffc0 75d67d30 ffffffc9
[<ffffffc000083da0>] el1_irq+0x60/0xd0
[<ffffffc0000af4f4>] irq_exit+0x8c/0xc0
[<ffffffc0000848bc>] handle_IRQ+0x6c/0xe0
[<ffffffc000081290>] gic_handle_irq+0x3c/0x80
Exception stack(0xffffffc975d67e30 to 0xffffffc975d67f50)
7e20:                                     75d64000 ffffffc9 0073d448 ffffffc0
7e40: 75d67f70 ffffffc9 000852d0 ffffffc0 00000000 00000000 006309d0 ffffffc0
7e60: 75d67f00 ffffffc9 00000001 00000000 00000008 00000000 00000001 00000000
7e80: 000fb068 ffffffc0 00000000 00000000 75d59d08 ffffffc9 00000001 00000000
7ea0: 00000000 00000000 75d59340 ffffffc9 00000001 00000000 00000004 00000000
7ec0: 00000000 00000000 963875a0 0000007f 001aa6c4 ffffffc0 962ff50c 0000007f
7ee0: ebb9a680 0000007f 75d64000 ffffffc9 0073d448 ffffffc0 00508000 ffffffc0
7f00: 0066bc18 ffffffc0 00738387 ffffffc0 00621fa8 ffffffc0 00000001 00000000
7f20: 81172000 00000000 00080330 ffffffc0 80000000 00000040 75d67f70 ffffffc9
7f40: 000852cc ffffffc0 75d67f70 ffffffc9
[<ffffffc000083da0>] el1_irq+0x60/0xd0
[<ffffffc0000debac>] cpu_startup_entry+0xfc/0x154
[<ffffffc00008f814>] secondary_start_kernel+0x110/0x120
NMI watchdog: BUG: soft lockup - CPU#3 stuck for 23s! [swapper/3:0]
Modules linked in:

CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.17.0-rc6+ #82
task: ffffffc975d59340 ti: ffffffc975d64000 task.ti: ffffffc975d64000
PC is at __do_softirq+0xac/0x27c
LR is at __do_softirq+0x98/0x27c
pc : [<ffffffc0000af0b8>] lr : [<ffffffc0000af0a4>] pstate: 80000145
sp : ffffffc975d67d30
x29: ffffffc975d67d30 x28: ffffffc0006d8a20
x27: 0000000000000002 x26: ffffffc0006d8a28
x25: 0000000000000001 x24: 0000000000000000
x23: 000000000000001e x22: ffffffc0006e2000
x21: ffffffc975d64000 x20: ffffffc0006d9dd8
x19: ffffffc975d64000 x18: 000000000000000e
x17: 0000000000000001 x16: 0000000000000019
x15: 0000000000000033 x14: 000000000000004c
x13: 0000000000000068 x12: 0000000000000001
x11: ffffffc975d59340 x10: 0000000000000000
x9 : 0000000000000001 x8 : ffffffc0006d8a20
x7 : ffffffc0006d8a28 x6 : 000000000ccccccd
x5 : 0000000000000020 x4 : ffffffc00040b168
x3 : 0000000000000101 x2 : ffffffc975d67ce0
x1 : ffffffc00073be00 x0 : 00000000000000c0


SysRq : Show backtrace of all active CPUs
CPU0:

CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.17.0-rc6+ #82
task: ffffffc0006e8a20 ti: ffffffc0006dc000 task.ti: ffffffc0006dc000
PC is at arch_cpu_idle+0x10/0x18
LR is at arch_cpu_idle+0xc/0x18
pc : [<ffffffc0000852d0>] lr : [<ffffffc0000852cc>] pstate: 60000145
sp : ffffffc0006dff20
x29: ffffffc0006dff20 x28: 0000004080000000
x27: ffffffc000080578 x26: 0000000081172000
x25: 0000000000000001 x24: ffffffc000621fa8
x23: ffffffc000738387 x22: ffffffc00066bc18
x21: ffffffc000508000 x20: ffffffc00073d448
x19: ffffffc0006dc000 x18: 000000000000000d
x17: 0000007fb48d47a0 x16: ffffffc0001975ec
x15: ffffffffffffffed x14: 000000000000000d
x13: fffffffffffffe09 x12: 0000000000000001
x11: ffffffc0006e8a20 x10: 0000000000000000
x9 : 0000000000000001 x8 : ffffffc0006e93e8
x7 : 0000000000000000 x6 : ffffffc000108b2c
x5 : 0000000000000000 x4 : ffffffc0006f7700
x3 : 0000000000000001 x2 : ffffffc0006dfeb0
x1 : ffffffc0006309d0 x0 : 0000000000000000

CPU3:
Processed 0 softirqs recently, 143066 total
Call trace:
[<ffffffc000088110>] dump_backtrace+0x0/0x130
[<ffffffc000088250>] show_stack+0x10/0x1c
[<ffffffc00033d360>] showacpu+0xe4/0x11c
[<ffffffc00010db48>] flush_smp_call_function_queue+0x90/0x180
[<ffffffc00010dd04>] generic_smp_call_function_single_interrupt+0xc/0x18
[<ffffffc00008fc9c>] handle_IPI+0xe4/0x174
[<ffffffc0000812cc>] gic_handle_irq+0x78/0x80
Exception stack(0xffffffc975d67bf0 to 0xffffffc975d67d10)
7be0:                                     75d64000 ffffffc9 006d9dd8 ffffffc0
7c00: 75d67d30 ffffffc9 000af0b8 ffffffc0 000000c0 00000000 0073be00 ffffffc0
7c20: 75d67ce0 ffffffc9 00000101 00000000 0040b168 ffffffc0 00000020 00000000
7c40: 0ccccccd 00000000 006d8a28 ffffffc0 006d8a20 ffffffc0 00000001 00000000
7c60: 00000000 00000000 75d59340 ffffffc9 00000001 00000000 00000068 00000000
7c80: 0000004c 00000000 00000033 00000000 00000019 00000000 00000001 00000000
7ca0: 0000000e 00000000 75d64000 ffffffc9 006d9dd8 ffffffc0 75d64000 ffffffc9
7cc0: 006e2000 ffffffc0 0000001e 00000000 00000000 00000000 00000001 00000000
7ce0: 006d8a28 ffffffc0 00000002 00000000 006d8a20 ffffffc0 75d67d30 ffffffc9
7d00: 000af0a4 ffffffc0 75d67d30 ffffffc9
[<ffffffc000083da0>] el1_irq+0x60/0xd0
[<ffffffc0000af4f4>] irq_exit+0x8c/0xc0
[<ffffffc0000848bc>] handle_IRQ+0x6c/0xe0
[<ffffffc000081290>] gic_handle_irq+0x3c/0x80
Exception stack(0xffffffc975d67e30 to 0xffffffc975d67f50)
7e20:                                     75d64000 ffffffc9 0073d448 ffffffc0
7e40: 75d67f70 ffffffc9 000852d0 ffffffc0 00000000 00000000 006309d0 ffffffc0
7e60: 75d67f00 ffffffc9 00000001 00000000 00000008 00000000 00000001 00000000
7e80: 000fb068 ffffffc0 00000000 00000000 75d59d08 ffffffc9 00000001 00000000
7ea0: 00000000 00000000 75d59340 ffffffc9 00000001 00000000 00000004 00000000
7ec0: 00000000 00000000 963875a0 0000007f 001aa6c4 ffffffc0 962ff50c 0000007f
7ee0: ebb9a680 0000007f 75d64000 ffffffc9 0073d448 ffffffc0 00508000 ffffffc0
7f00: 0066bc18 ffffffc0 00738387 ffffffc0 00621fa8 ffffffc0 00000001 00000000
7f20: 81172000 00000000 00080330 ffffffc0 80000000 00000040 75d67f70 ffffffc9
7f40: 000852cc ffffffc0 75d67f70 ffffffc9
[<ffffffc000083da0>] el1_irq+0x60/0xd0
[<ffffffc0000debac>] cpu_startup_entry+0xfc/0x154
[<ffffffc00008f814>] secondary_start_kernel+0x110/0x120
----8<----
