Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab3CDGQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 01:16:13 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:40271 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3CDGQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 01:16:11 -0500
MIME-Version: 1.0
In-Reply-To: <CA+Bv8XY1Qr_zD1guQzeWVPCLw6JP=y5taJMwPUEO1AxPckgsjQ@mail.gmail.com>
References: <CA+Bv8XZM7yO-=vrGZg5LFLik8YkQiMC9ppCgQbyi1yuLiKstJQ@mail.gmail.com>
	<20130302194923.GE4503@ZenIV.linux.org.uk>
	<CA+Bv8XY1Qr_zD1guQzeWVPCLw6JP=y5taJMwPUEO1AxPckgsjQ@mail.gmail.com>
Date: Sun, 3 Mar 2013 22:16:10 -0800
Message-ID: <CA+Bv8XaEBZz3RWh5=y-kLoEMdjxwNFBUBBxUKdq-NuV6iZ=QRg@mail.gmail.com>
Subject: Re: fasync race in fs/fcntl.c
From: Russ Dill <russ.dill@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 4:09 PM, Russ Dill <russ.dill@gmail.com> wrote:
> On Sat, Mar 2, 2013 at 11:49 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Sat, Mar 02, 2013 at 03:00:28AM -0800, Russ Dill wrote:
>>> I'm seeing a race in fs/fcntl.c. I'm not sure exactly how the race is
>>> occurring, but the following is my best guess. A kernel log is
>>> attached.
>>
>> [snip the analysis - it's a different lock anyway]
>>
>> The traces below are essentially sys_execve() getting to get_random_bytes(),
>> to kill_fasync(), to send_sigio(), which spins on tasklist_lock.
>>
>> Could you rebuild it with lockdep enabled and try to reproduce that?
>> I very much doubt that this execve() is a part of deadlock - it's
>> getting caught on one, but it shouldn't be holding any locks that
>> nest inside tasklist_lock at that point, so even it hadn't been there,
>> the process holding tasklist_lock probably wouldn't have progressed any
>> further...
>
> ok, I did screw up the analysis quite badly, luckily, lockdep got it right away.
>

So lockdep gives some clues, but seems a bit confused, so here's what happened.

mix_pool_bytes /* takes nonblocking_pool.lock */
add_device_randomness
posix_cpu_timers_exit
__exit_signal
release_task /* takes write lock on tasklist_lock */
do_exit
__module_put_and_exit
cryptomgr_test

send_sigio /* takes read lock on tasklist_lock */
kill_fasync_rcu
kill_fasync
account /* takes nonblocking_pool.lock */
extract_entropy
get_random_bytes
create_elf_tables
load_elf_binary
load_elf_library
search_binary_handler

This would mark the culprit as 613370549 'random: Mix cputime from
each thread that exits to the pool'.  So long as I'm not as crazy on
the last analysis as this one, may I suggest a revert of this commit
for 3.8.3?

> [  199.411236]
> [  199.411261] ======================================================
> [  199.411268] [ INFO: possible circular locking dependency detected ]
> [  199.411277] 3.8.0-9-generic #18 Not tainted
> [  199.411283] -------------------------------------------------------
> [  199.411290] slirp-wrapper.s/5574 is trying to acquire lock:
> [  199.411296]  (&(&new->fa_lock)->rlock){-.-...}, at:
> [<ffffffff811b3fc9>] kill_fasync+0x69/0xe0
> [  199.411332]
> [  199.411332] but task is already holding lock:
> [  199.411338]  (&nonblocking_pool.lock){......}, at:
> [<ffffffff81456789>] account+0x39/0x1d0
> [  199.411364]
> [  199.411364] which lock already depends on the new lock.
> [  199.411364]
> [  199.411371]
> [  199.411371] the existing dependency chain (in reverse order) is:
> [  199.411379]
> [  199.411379] -> #2 (&nonblocking_pool.lock){......}:
> [  199.411400]        [<ffffffff810bdd58>] lock_acquire+0x98/0x120
> [  199.411416]        [<ffffffff816f8b1e>] _raw_spin_lock_irqsave+0x4e/0x70
> [  199.411430]        [<ffffffff81456543>] mix_pool_bytes.constprop.20+0x43/0xb0
> [  199.411442]        [<ffffffff81456724>] add_device_randomness+0x64/0x90
> [  199.411454]        [<ffffffff81081e0e>] posix_cpu_timers_exit+0x1e/0x50
> [  199.411469]        [<ffffffff8105d0b2>] release_task+0xe2/0x470
> [  199.411484]        [<ffffffff8105eb77>] do_exit+0x5d7/0x9c0
> [  199.411495]        [<ffffffff810c6b4a>] __module_put_and_exit+0x1a/0x20
> [  199.411509]        [<ffffffff8132b725>] cryptomgr_test+0x25/0x30
> [  199.411526]        [<ffffffff8107f5ea>] kthread+0xea/0xf0
> [  199.411537]        [<ffffffff8170146c>] ret_from_fork+0x7c/0xb0
> [  199.411550]
> [  199.411550] -> #1 (&(&sighand->siglock)->rlock){-.-...}:
> [  199.411689]        [<ffffffff810bdd58>] lock_acquire+0x98/0x120
> [  199.411702]        [<ffffffff816f8b1e>] _raw_spin_lock_irqsave+0x4e/0x70
> [  199.411713]        [<ffffffffa0008200>] vblank_disable_fn+0x60/0xd0 [drm]
> [  199.411768]        [<ffffffff810695da>] call_timer_fn+0x7a/0x180
> [  199.411781]        [<ffffffff8106aa2c>] run_timer_softirq+0x1fc/0x2a0
> [  199.411794]        [<ffffffff81061580>] __do_softirq+0xe0/0x220
> [  199.411807]        [<ffffffff81702a3c>] call_softirq+0x1c/0x30
> [  199.411819]        [<ffffffff81016685>] do_softirq+0xa5/0xe0
> [  199.411833]        [<ffffffff81061855>] irq_exit+0xb5/0xc0
> [  199.411846]        [<ffffffff817033de>] smp_apic_timer_interrupt+0x6e/0x99
> [  199.411859]        [<ffffffff817022f2>] apic_timer_interrupt+0x72/0x80
> [  199.411871]        [<ffffffff8158e3c0>] cpuidle_enter_tk+0x10/0x20
> [  199.411885]        [<ffffffff8158df95>] cpuidle_idle_call+0xa5/0x270
> [  199.411897]        [<ffffffff8101d865>] cpu_idle+0xb5/0x120
> [  199.411910]        [<ffffffff816d4d64>] rest_init+0xb4/0xc0
> [  199.411924]        [<ffffffff81d22c07>] start_kernel+0x3ea/0x3f6
> [  199.411939]        [<ffffffff81d22355>] x86_64_start_reservations+0x130/0x133
> [  199.411952]        [<ffffffff81d22458>] x86_64_start_kernel+0x100/0x10f
> [  199.411966]
> [  199.411966] -> #0 (&(&new->fa_lock)->rlock){-.-...}:
> [  199.411984]        [<ffffffff810bcfc9>] __lock_acquire+0x1279/0x1aa0
> [  199.411997]        [<ffffffff810bdd58>] lock_acquire+0x98/0x120
> [  199.412103]        [<ffffffff816f8b1e>] _raw_spin_lock_irqsave+0x4e/0x70
> [  199.412115]        [<ffffffff811b3fc9>] kill_fasync+0x69/0xe0
> [  199.412127]        [<ffffffff81456863>] account+0x113/0x1d0
> [  199.412138]        [<ffffffff81456e15>] extract_entropy+0x65/0x140
> [  199.412149]        [<ffffffff81457120>] get_random_bytes+0x20/0x30
> [  199.412159]        [<ffffffff816ee9b2>] create_elf_tables+0xaa/0x615
> [  199.412172]        [<ffffffff811f9a94>] load_elf_binary+0xae4/0xe00
> [  199.412185]        [<ffffffff811a9081>] search_binary_handler+0x171/0x390
> [  199.412197]        [<ffffffff811f7515>] load_script+0x265/0x2b0
> [  199.412208]        [<ffffffff811a9081>] search_binary_handler+0x171/0x390
> [  199.412219]        [<ffffffff811aa305>] do_execve_common.isra.23+0x405/0x4c0
> [  199.412230]        [<ffffffff811aa3d8>] do_execve+0x18/0x20
> [  199.412240]        [<ffffffff811aa67d>] sys_execve+0x3d/0x60
> [  199.412251]        [<ffffffff81701b19>] stub_execve+0x69/0xc0
> [  199.412263]
> [  199.412263] other info that might help us debug this:
> [  199.412263]
> [  199.412271] Chain exists of:
> [  199.412271]   &(&new->fa_lock)->rlock -->
> &(&sighand->siglock)->rlock --> &nonblocking_pool.lock
> [  199.412271]
> [  199.412298]  Possible unsafe locking scenario:
> [  199.412298]
> [  199.412305]        CPU0                    CPU1
> [  199.412310]        ----                    ----
> [  199.412316]   lock(&nonblocking_pool.lock);
> [  199.412328]                                lock(&(&sighand->siglock)->rlock);
> [  199.412339]                                lock(&nonblocking_pool.lock);
> [  199.412452]   lock(&(&new->fa_lock)->rlock);
> [  199.412464]
> [  199.412464]  *** DEADLOCK ***
> [  199.412464]
> [  199.412473] 2 locks held by slirp-wrapper.s/5574:
> [  199.412478]  #0:  (&nonblocking_pool.lock){......}, at:
> [<ffffffff81456789>] account+0x39/0x1d0
> [  199.412504]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811b3f81>]
> kill_fasync+0x21/0xe0
> [  199.412531]
> [  199.412531] stack backtrace:
> [  199.412540] Pid: 5574, comm: slirp-wrapper.s Not tainted 3.8.0-9-generic #18
> [  199.412546] Call Trace:
> [  199.412560]  [<ffffffff816eb393>] print_circular_bug+0x1f9/0x208
> [  199.412572]  [<ffffffff810bcfc9>] __lock_acquire+0x1279/0x1aa0
> [  199.412584]  [<ffffffff810bdd58>] lock_acquire+0x98/0x120
> [  199.412596]  [<ffffffff811b3fc9>] ? kill_fasync+0x69/0xe0
> [  199.412606]  [<ffffffff816f8b1e>] _raw_spin_lock_irqsave+0x4e/0x70
> [  199.412618]  [<ffffffff811b3fc9>] ? kill_fasync+0x69/0xe0
> [  199.412628]  [<ffffffff811b3fc9>] kill_fasync+0x69/0xe0
> [  199.412639]  [<ffffffff811b3f81>] ? kill_fasync+0x21/0xe0
> [  199.412649]  [<ffffffff81456863>] account+0x113/0x1d0
> [  199.412658]  [<ffffffff81456e15>] extract_entropy+0x65/0x140
> [  199.412668]  [<ffffffff81457120>] get_random_bytes+0x20/0x30
> [  199.412678]  [<ffffffff816ee9b2>] create_elf_tables+0xaa/0x615
> [  199.412689]  [<ffffffff811f9a94>] load_elf_binary+0xae4/0xe00
> [  199.412700]  [<ffffffff811f8fb0>] ? load_elf_library+0x240/0x240
> [  199.412710]  [<ffffffff811a9081>] search_binary_handler+0x171/0x390
> [  199.412720]  [<ffffffff811a8f8f>] ? search_binary_handler+0x7f/0x390
> [  199.412730]  [<ffffffff811f72b0>] ? compat_sys_ioctl+0x320/0x320
> [  199.412740]  [<ffffffff811f7515>] load_script+0x265/0x2b0
> [  199.412750]  [<ffffffff811a909f>] ? search_binary_handler+0x18f/0x390
> [  199.412760]  [<ffffffff811f72b0>] ? compat_sys_ioctl+0x320/0x320
> [  199.412770]  [<ffffffff811a9081>] search_binary_handler+0x171/0x390
> [  199.412779]  [<ffffffff811a8f8f>] ? search_binary_handler+0x7f/0x390
> [  199.412789]  [<ffffffff811aa305>] do_execve_common.isra.23+0x405/0x4c0
> [  199.412799]  [<ffffffff811aa014>] ? do_execve_common.isra.23+0x114/0x4c0
> [  199.412809]  [<ffffffff811aa3d8>] do_execve+0x18/0x20
> [  199.412922]  [<ffffffff811aa67d>] sys_execve+0x3d/0x60
> [  199.412933]  [<ffffffff81701b19>] stub_execve+0x69/0xc0
