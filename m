Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaHAB1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:27:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:38372 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbaHAB1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:27:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,776,1400050800"; 
   d="log'?scan'208";a="570249413"
Date: Fri, 1 Aug 2014 09:26:38 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [printk] INFO: possible circular locking dependency detected
Message-ID: <20140801012638.GB8729@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
commit 939f04bec1a4ef6ba4370b0f34b01decc844b1b1
Author:     Jan Kara <jack@suse.cz>
AuthorDate: Wed Jun 4 16:11:37 2014 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Wed Jun 4 16:54:17 2014 -0700

    printk: enable interrupts before calling console_trylock_for_printk()
    
    We need interrupts disabled when calling console_trylock_for_printk()
    only so that cpu id we pass to can_use_console() remains valid (for
    other things console_sem provides all the exclusion we need and
    deadlocks on console_sem due to interrupts are impossible because we use
    down_trylock()).  However if we are rescheduled, we are guaranteed to
    run on an online cpu so we can easily just get the cpu id in
    can_use_console().
    
    We can lose a bit of performance when we enable interrupts in
    vprintk_emit() and then disable them again in console_unlock() but OTOH
    it can somewhat reduce interrupt latency caused by console_unlock()
    especially since later in the patch series we will want to spin on
    console_sem in console_trylock_for_printk().
    
    Signed-off-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

+----------------------------------------------------+------------+------------+------------+
|                                                    | bd8d7cf5b8 | 939f04bec1 | fb3ec67942 |
+----------------------------------------------------+------------+------------+------------+
| boot_successes                                     | 1159       | 280        | 41         |
| boot_failures                                      | 41         | 20         | 5          |
| BUG:kernel_boot_hang                               | 41         | 13         | 3          |
| INFO:possible_circular_locking_dependency_detected | 0          | 7          | 2          |
| backtrace:do_fork                                  | 0          | 7          | 2          |
| backtrace:vfs_write                                | 0          | 7          | 2          |
| backtrace:SyS_write                                | 0          | 7          | 2          |
| backtrace:event_create_dir                         | 0          | 2          | 1          |
| backtrace:event_trace_init                         | 0          | 2          | 1          |
| backtrace:kernel_init_freeable                     | 0          | 3          | 1          |
| backtrace:SYSC_perf_event_open                     | 0          | 7          | 2          |
| backtrace:SyS_perf_event_open                      | 0          | 7          | 2          |
| backtrace:trace_create_cpu_file                    | 0          | 1          |            |
| backtrace:init_tracer_debugfs                      | 0          | 1          |            |
| backtrace:tracer_init_debugfs                      | 0          | 1          |            |
+----------------------------------------------------+------------+------------+------------+

[   29.644027] CE: hpet increased min_delta_ns to 25312 nsec
[   29.644027] 
[   29.644027] ======================================================
[   29.644027] [ INFO: possible circular locking dependency detected ]
[   29.644027] 3.15.0-rc8-06195-g939f04b #2 Not tainted
[   29.644027] -------------------------------------------------------
[   29.644027] trinity-main/74 is trying to acquire lock:
[   29.644027]  (&port_lock_key){-.....}, at: [<811c60be>] serial8250_console_write+0x8c/0x10c
[   29.644027] 
[   29.644027] but task is already holding lock:
[   29.644027]  (hrtimer_bases.lock){-.-...}, at: [<8103caeb>] hrtimer_try_to_cancel+0x13/0x66
[   29.644027] 
[   29.644027] which lock already depends on the new lock.
[   29.644027] 
[   29.644027] 
[   29.644027] the existing dependency chain (in reverse order) is:
[   29.644027] 
[   29.644027] -> #5 (hrtimer_bases.lock){-.-...}:
[   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
[   29.644027]        [<8103c918>] __hrtimer_start_range_ns+0x1c/0x197
[   29.644027]        [<8107ec20>] perf_swevent_start_hrtimer.part.41+0x7a/0x85
[   29.644027]        [<81080792>] task_clock_event_start+0x3a/0x3f
[   29.644027]        [<810807a4>] task_clock_event_add+0xd/0x14
[   29.644027]        [<8108259a>] event_sched_in+0xb6/0x17a
[   29.644027]        [<810826a2>] group_sched_in+0x44/0x122
[   29.644027]        [<81082885>] ctx_sched_in.isra.67+0x105/0x11f
[   29.644027]        [<810828e6>] perf_event_sched_in.isra.70+0x47/0x4b
[   29.644027]        [<81082bf6>] __perf_install_in_context+0x8b/0xa3
[   29.644027]        [<8107eb8e>] remote_function+0x12/0x2a
[   29.644027]        [<8105f5af>] smp_call_function_single+0x2d/0x53
[   29.644027]        [<8107e17d>] task_function_call+0x30/0x36
[   29.644027]        [<8107fb82>] perf_install_in_context+0x87/0xbb
[   29.644027]        [<810852c9>] SYSC_perf_event_open+0x5c6/0x701
[   29.644027]        [<810856f9>] SyS_perf_event_open+0x17/0x19
[   29.644027]        [<8142f8ee>] syscall_call+0x7/0xb
[   29.644027] 
[   29.644027] -> #4 (&ctx->lock){......}:
[   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]        [<8142f04c>] _raw_spin_lock+0x21/0x30
[   29.644027]        [<81081df3>] __perf_event_task_sched_out+0x1dc/0x34f
[   29.644027]        [<8142cacc>] __schedule+0x4c6/0x4cb
[   29.644027]        [<8142cae0>] schedule+0xf/0x11
[   29.644027]        [<8142f9a6>] work_resched+0x5/0x30
[   29.644027] 
[   29.644027] -> #3 (&rq->lock){-.-.-.}:
[   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]        [<8142f04c>] _raw_spin_lock+0x21/0x30
[   29.644027]        [<81040873>] __task_rq_lock+0x33/0x3a
[   29.644027]        [<8104184c>] wake_up_new_task+0x25/0xc2
[   29.644027]        [<8102474b>] do_fork+0x15c/0x2a0
[   29.644027]        [<810248a9>] kernel_thread+0x1a/0x1f
[   29.644027]        [<814232a2>] rest_init+0x1a/0x10e
[   29.644027]        [<817af949>] start_kernel+0x303/0x308
[   29.644027]        [<817af2ab>] i386_start_kernel+0x79/0x7d
[   29.644027] 
[   29.644027] -> #2 (&p->pi_lock){-.-...}:
[   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
[   29.644027]        [<810413dd>] try_to_wake_up+0x1d/0xd6
[   29.644027]        [<810414cd>] default_wake_function+0xb/0xd
[   29.644027]        [<810461f3>] __wake_up_common+0x39/0x59
[   29.644027]        [<81046346>] __wake_up+0x29/0x3b
[   29.644027]        [<811b8733>] tty_wakeup+0x49/0x51
[   29.644027]        [<811c3568>] uart_write_wakeup+0x17/0x19
[   29.644027]        [<811c5dc1>] serial8250_tx_chars+0xbc/0xfb
[   29.644027]        [<811c5f28>] serial8250_handle_irq+0x54/0x6a
[   29.644027]        [<811c5f57>] serial8250_default_handle_irq+0x19/0x1c
[   29.644027]        [<811c56d8>] serial8250_interrupt+0x38/0x9e
[   29.644027]        [<810510e7>] handle_irq_event_percpu+0x5f/0x1e2
[   29.644027]        [<81051296>] handle_irq_event+0x2c/0x43
[   29.644027]        [<81052cee>] handle_level_irq+0x57/0x80
[   29.644027]        [<81002a72>] handle_irq+0x46/0x5c
[   29.644027]        [<810027df>] do_IRQ+0x32/0x89
[   29.644027]        [<8143036e>] common_interrupt+0x2e/0x33
[   29.644027]        [<8142f23c>] _raw_spin_unlock_irqrestore+0x3f/0x49
[   29.644027]        [<811c25a4>] uart_start+0x2d/0x32
[   29.644027]        [<811c2c04>] uart_write+0xc7/0xd6
[   29.644027]        [<811bc6f6>] n_tty_write+0xb8/0x35e
[   29.644027]        [<811b9beb>] tty_write+0x163/0x1e4
[   29.644027]        [<811b9cd9>] redirected_tty_write+0x6d/0x75
[   29.644027]        [<810b6ed6>] vfs_write+0x75/0xb0
[   29.644027]        [<810b7265>] SyS_write+0x44/0x77
[   29.644027]        [<8142f8ee>] syscall_call+0x7/0xb
[   29.644027] 
[   29.644027] -> #1 (&tty->write_wait){-.....}:
[   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
[   29.644027]        [<81046332>] __wake_up+0x15/0x3b
[   29.644027]        [<811b8733>] tty_wakeup+0x49/0x51
[   29.644027]        [<811c3568>] uart_write_wakeup+0x17/0x19
[   29.644027]        [<811c5dc1>] serial8250_tx_chars+0xbc/0xfb
[   29.644027]        [<811c5f28>] serial8250_handle_irq+0x54/0x6a
[   29.644027]        [<811c5f57>] serial8250_default_handle_irq+0x19/0x1c
[   29.644027]        [<811c56d8>] serial8250_interrupt+0x38/0x9e
[   29.644027]        [<810510e7>] handle_irq_event_percpu+0x5f/0x1e2
[   29.644027]        [<81051296>] handle_irq_event+0x2c/0x43
[   29.644027]        [<81052cee>] handle_level_irq+0x57/0x80
[   29.644027]        [<81002a72>] handle_irq+0x46/0x5c
[   29.644027]        [<810027df>] do_IRQ+0x32/0x89
[   29.644027]        [<8143036e>] common_interrupt+0x2e/0x33
[   29.644027]        [<8142f23c>] _raw_spin_unlock_irqrestore+0x3f/0x49
[   29.644027]        [<811c25a4>] uart_start+0x2d/0x32
[   29.644027]        [<811c2c04>] uart_write+0xc7/0xd6
[   29.644027]        [<811bc6f6>] n_tty_write+0xb8/0x35e
[   29.644027]        [<811b9beb>] tty_write+0x163/0x1e4
[   29.644027]        [<811b9cd9>] redirected_tty_write+0x6d/0x75
[   29.644027]        [<810b6ed6>] vfs_write+0x75/0xb0
[   29.644027]        [<810b7265>] SyS_write+0x44/0x77
[   29.644027]        [<8142f8ee>] syscall_call+0x7/0xb
[   29.644027] 
[   29.644027] -> #0 (&port_lock_key){-.....}:
[   29.644027]        [<8104a62d>] __lock_acquire+0x9ea/0xc6d
[   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
[   29.644027]        [<811c60be>] serial8250_console_write+0x8c/0x10c
[   29.644027]        [<8104e402>] call_console_drivers.constprop.31+0x87/0x118
[   29.644027]        [<8104f5d5>] console_unlock+0x1d7/0x398
[   29.644027]        [<8104fb70>] vprintk_emit+0x3da/0x3e4
[   29.644027]        [<81425f76>] printk+0x17/0x19
[   29.644027]        [<8105bfa0>] clockevents_program_min_delta+0x104/0x116
[   29.644027]        [<8105c548>] clockevents_program_event+0xe7/0xf3
[   29.644027]        [<8105cc1c>] tick_program_event+0x1e/0x23
[   29.644027]        [<8103c43c>] hrtimer_force_reprogram+0x88/0x8f
[   29.644027]        [<8103c49e>] __remove_hrtimer+0x5b/0x79
[   29.644027]        [<8103cb21>] hrtimer_try_to_cancel+0x49/0x66
[   29.644027]        [<8103cb4b>] hrtimer_cancel+0xd/0x18
[   29.644027]        [<8107f102>] perf_swevent_cancel_hrtimer.part.60+0x2b/0x30
[   29.644027]        [<81080705>] task_clock_event_stop+0x20/0x64
[   29.644027]        [<81080756>] task_clock_event_del+0xd/0xf
[   29.644027]        [<81081350>] event_sched_out+0xab/0x11e
[   29.644027]        [<810813e0>] group_sched_out+0x1d/0x66
[   29.644027]        [<81081682>] ctx_sched_out+0xaf/0xbf
[   29.644027]        [<81081e04>] __perf_event_task_sched_out+0x1ed/0x34f
[   29.644027]        [<8142cacc>] __schedule+0x4c6/0x4cb
[   29.644027]        [<8142cae0>] schedule+0xf/0x11
[   29.644027]        [<8142f9a6>] work_resched+0x5/0x30
[   29.644027] 
[   29.644027] other info that might help us debug this:
[   29.644027] 
[   29.644027] Chain exists of:
[   29.644027]   &port_lock_key --> &ctx->lock --> hrtimer_bases.lock
[   29.644027] 
[   29.644027]  Possible unsafe locking scenario:
[   29.644027] 
[   29.644027]        CPU0                    CPU1
[   29.644027]        ----                    ----
[   29.644027]   lock(hrtimer_bases.lock);
[   29.644027]                                lock(&ctx->lock);
[   29.644027]                                lock(hrtimer_bases.lock);
[   29.644027]   lock(&port_lock_key);
[   29.644027] 
[   29.644027]  *** DEADLOCK ***
[   29.644027] 
[   29.644027] 4 locks held by trinity-main/74:
[   29.644027]  #0:  (&rq->lock){-.-.-.}, at: [<8142c6f3>] __schedule+0xed/0x4cb
[   29.644027]  #1:  (&ctx->lock){......}, at: [<81081df3>] __perf_event_task_sched_out+0x1dc/0x34f
[   29.644027]  #2:  (hrtimer_bases.lock){-.-...}, at: [<8103caeb>] hrtimer_try_to_cancel+0x13/0x66
[   29.644027]  #3:  (console_lock){+.+...}, at: [<8104fb5d>] vprintk_emit+0x3c7/0x3e4
[   29.644027] 
[   29.644027] stack backtrace:
[   29.644027] CPU: 0 PID: 74 Comm: trinity-main Not tainted 3.15.0-rc8-06195-g939f04b #2
[   29.644027]  00000000 81c3a310 8b995c14 81426f69 8b995c44 81425a99 8161f671 8161f570
[   29.644027]  8161f538 8161f559 8161f538 8b995c78 8b142bb0 00000004 8b142fdc 8b142bb0
[   29.644027]  8b995ca8 8104a62d 8b142fac 000016f2 81c3a310 00000001 00000001 00000003
[   29.644027] Call Trace:
[   29.644027]  [<81426f69>] dump_stack+0x16/0x18
[   29.644027]  [<81425a99>] print_circular_bug+0x18f/0x19c
[   29.644027]  [<8104a62d>] __lock_acquire+0x9ea/0xc6d
[   29.644027]  [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]  [<811c60be>] ? serial8250_console_write+0x8c/0x10c
[   29.644027]  [<811c6032>] ? wait_for_xmitr+0x76/0x76
[   29.644027]  [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
[   29.644027]  [<811c60be>] ? serial8250_console_write+0x8c/0x10c
[   29.644027]  [<811c60be>] serial8250_console_write+0x8c/0x10c
[   29.644027]  [<8104af87>] ? lock_release+0x191/0x223
[   29.644027]  [<811c6032>] ? wait_for_xmitr+0x76/0x76
[   29.644027]  [<8104e402>] call_console_drivers.constprop.31+0x87/0x118
[   29.644027]  [<8104f5d5>] console_unlock+0x1d7/0x398
[   29.644027]  [<8104fb70>] vprintk_emit+0x3da/0x3e4
[   29.644027]  [<81425f76>] printk+0x17/0x19
[   29.644027]  [<8105bfa0>] clockevents_program_min_delta+0x104/0x116
[   29.644027]  [<8105c548>] clockevents_program_event+0xe7/0xf3
[   29.644027]  [<8105cc1c>] tick_program_event+0x1e/0x23
[   29.644027]  [<8103c43c>] hrtimer_force_reprogram+0x88/0x8f
[   29.644027]  [<8103c49e>] __remove_hrtimer+0x5b/0x79
[   29.644027]  [<8103cb21>] hrtimer_try_to_cancel+0x49/0x66
[   29.644027]  [<8103cb4b>] hrtimer_cancel+0xd/0x18
[   29.644027]  [<8107f102>] perf_swevent_cancel_hrtimer.part.60+0x2b/0x30
[   29.644027]  [<81080705>] task_clock_event_stop+0x20/0x64
[   29.644027]  [<81080756>] task_clock_event_del+0xd/0xf
[   29.644027]  [<81081350>] event_sched_out+0xab/0x11e
[   29.644027]  [<810813e0>] group_sched_out+0x1d/0x66
[   29.644027]  [<81081682>] ctx_sched_out+0xaf/0xbf
[   29.644027]  [<81081e04>] __perf_event_task_sched_out+0x1ed/0x34f
[   29.644027]  [<8104416d>] ? __dequeue_entity+0x23/0x27
[   29.644027]  [<81044505>] ? pick_next_task_fair+0xb1/0x120
[   29.644027]  [<8142cacc>] __schedule+0x4c6/0x4cb
[   29.644027]  [<81047574>] ? trace_hardirqs_off_caller+0xd7/0x108
[   29.644027]  [<810475b0>] ? trace_hardirqs_off+0xb/0xd
[   29.644027]  [<81056346>] ? rcu_irq_exit+0x64/0x77

git bisect start 9f6226a762c7ae02f6a23a3d4fc552dafa57ea23 v3.15 --
git bisect  bad 71998d1be4ae70e7d320cdd21595c1a02a29c61e  # 01:13     79-      5  Merge branch 'x86-irq-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 9ee4d7a6538308a7681b638d2f35f2a301420355  # 01:24      3-      1  Merge branch 'akpm' (patches from Andrew Morton)
git bisect  bad 9894e6d9c020b754dd962960e9f7eac18282f69f  # 01:58    128-      5  Merge tag 'fbdev-omap-dt-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux
git bisect  bad 963649d735c8b6eb0f97e82c54f02426ff3f1f45  # 02:06     48-      3  Merge tag 'for-linus-3.16-merge-window' of git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs
git bisect  bad b20dcab9d4589ef9918a13c888c5493945adfc13  # 02:13     35-      1  Merge tag 'llvmlinux-for-v3.16' of git://git.linuxfoundation.org/llvmlinux/kernel
git bisect  bad 3f17ea6dea8ba5668873afa54628a91aaa3fb1c0  # 02:19     58-      4  Merge branch 'next' (accumulated 3.16 merge window patches) into master
git bisect good 49eb7b0750d9483c74e9c14ae6ea1e9d62481c3c  # 02:35    300+      7  Merge tag 'tty-3.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty into next
git bisect good 15b588303155b22edd559672905db8e59a44ef9a  # 02:51    300+      0  Merge tag 'fbdev-omap-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux into next
git bisect good d09cc3659db494aca4b3bb2393c533fb4946b794  # 03:19    300+      1  Merge branch 'irq-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into next
git bisect  bad cc07aabc53978ae09a1d539237189f7c9841060a  # 03:37     66-      2  Merge tag 'arm64-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux into next
git bisect  bad 8091b895b76f690aa2f6689b6ed602f07525a938  # 04:55    103-      1  fs/ncpfs/getopt.c: replace simple_strtoul by kstrtoul
git bisect good d53aea3d46d64e95da9952887969f7533b9ab25e  # 05:59    300+     19  mm, compaction: return failed migration target pages back to freelist
git bisect good 72d09633c9afa02bea317d65eb8b8a4ce7659a2a  # 06:31    300+     10  mm/zswap: NUMA aware allocation for zswap_dstmem
git bisect  bad 0046dd9fed0c9313cbb4fb860324476cd298dc9f  # 06:35     42-      1  lib/string.c: use the name "C-string" in comments
git bisect good 0a581694ab7a5bc083d710df8a552a6a055b005f  # 06:54    300+     15  printk: split code for making free space in the log buffer
git bisect  bad 939f04bec1a4ef6ba4370b0f34b01decc844b1b1  # 06:58     46-      2  printk: enable interrupts before calling console_trylock_for_printk()
git bisect good 034633ccb24d675850f99bf85c1c5880c831e4b6  # 07:16    300+     28  printk: return really stored message length
git bisect good 608873cacb9d0d2811586fcc79a38b64eabd6d32  # 07:29    300+     22  printk: release lockbuf_lock before calling console_trylock_for_printk()
git bisect good bd8d7cf5b8410fe98eba06a9aaa90efe88815d8a  # 07:42    300+      7  printk: fix lockdep instrumentation of console_sem
# first bad commit: [939f04bec1a4ef6ba4370b0f34b01decc844b1b1] printk: enable interrupts before calling console_trylock_for_printk()
git bisect good bd8d7cf5b8410fe98eba06a9aaa90efe88815d8a  # 08:21    900+     41  printk: fix lockdep instrumentation of console_sem
git bisect  bad fb3ec67942e92e5713e05b7691b277d0a0c0575d  # 08:21      0-      5  KVM: arm64: GICv3: mandate page-aligned GICV region
git bisect good 6f0928036bcbd8dd2ebee9201580da8bcc0a81af  # 08:49    900+     87  Merge tag 'pm+acpi-3.16-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 2
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=10
	softlockup_panic=1
	nmi_watchdog=panic
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-kbuild-20:20140801065622:i386-randconfig-ha2-0731:3.15.0-rc8-06195-g939f04b:2"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Linux version 3.15.0-rc8-06195-g939f04b (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #2 Fri Aug 1 14:56:13 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
[    0.000000]  [mem 0x12400000-0x125fffff] page 4k
[    0.000000] BRK [0x01fcb000, 0x01fcbfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x123fffff]
[    0.000000]  [mem 0x10000000-0x123fffff] page 4k
[    0.000000] BRK [0x01fcc000, 0x01fccfff] PGTABLE
[    0.000000] BRK [0x01fcd000, 0x01fcdfff] PGTABLE
[    0.000000] BRK [0x01fce000, 0x01fcefff] PGTABLE
[    0.000000] BRK [0x01fcf000, 0x01fcffff] PGTABLE
[    0.000000] BRK [0x01fd0000, 0x01fd0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12600000-0x13ffdfff]
[    0.000000]  [mem 0x12600000-0x13ffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 13ffe000)
[    0.000000] cma: dma_contiguous_reserve: reserving 16 MiB for global area
[    0.000000] cma: dma_contiguous_reserve_area(size 1000000, base 00000000=
, limit 13ffe000)
[    0.000000] cma: CMA: reserved 16 MiB at 11400000
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 817985e0, node_mem_map 91=
130024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1704a80
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ha2-0731/kvmarm:nex=
t:939f04bec1a4ef6ba4370b0f34b01decc844b1b1:bisect-linux-2/.vmlinuz-939f04be=
c1a4ef6ba4370b0f34b01decc844b1b1-20140801145621-157-kbuild branch=3Dkvmarm/=
next BOOT_IMAGE=3D/kernel/i386-randconfig-ha2-0731/939f04bec1a4ef6ba4370b0f=
34b01decc844b1b1/vmlinuz-3.15.0-rc8-06195-g939f04b drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 265892K/327280K available (4289K kernel code, 782K r=
wdata, 2784K rodata, 296K init, 7928K bss, 61388K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xffbfe000   (1716 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x817af000 - 0x817f9000   ( 296 kB)
[    0.000000]       .data : 0x81430af4 - 0x817ad880   (3571 kB)
[    0.000000]       .text : 0x81000000 - 0x81430af4   (4290 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D90c08000 soft=3D90c0a000
[    0.000000] Linux version 3.15.0-rc8-06195-g939f04b (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #2 Fri Aug 1 14:56:13 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
[    0.000000]  [mem 0x12400000-0x125fffff] page 4k
[    0.000000] BRK [0x01fcb000, 0x01fcbfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x123fffff]
[    0.000000]  [mem 0x10000000-0x123fffff] page 4k
[    0.000000] BRK [0x01fcc000, 0x01fccfff] PGTABLE
[    0.000000] BRK [0x01fcd000, 0x01fcdfff] PGTABLE
[    0.000000] BRK [0x01fce000, 0x01fcefff] PGTABLE
[    0.000000] BRK [0x01fcf000, 0x01fcffff] PGTABLE
[    0.000000] BRK [0x01fd0000, 0x01fd0fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12600000-0x13ffdfff]
[    0.000000]  [mem 0x12600000-0x13ffdfff] page 4k
[    0.000000] cma: dma_contiguous_reserve(limit 13ffe000)
[    0.000000] cma: dma_contiguous_reserve: reserving 16 MiB for global area
[    0.000000] cma: dma_contiguous_reserve_area(size 1000000, base 00000000=
, limit 13ffe000)
[    0.000000] cma: CMA: reserved 16 MiB at 11400000
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 817985e0, node_mem_map 91=
130024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1704a80
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ha2-0731/kvmarm:nex=
t:939f04bec1a4ef6ba4370b0f34b01decc844b1b1:bisect-linux-2/.vmlinuz-939f04be=
c1a4ef6ba4370b0f34b01decc844b1b1-20140801145621-157-kbuild branch=3Dkvmarm/=
next BOOT_IMAGE=3D/kernel/i386-randconfig-ha2-0731/939f04bec1a4ef6ba4370b0f=
34b01decc844b1b1/vmlinuz-3.15.0-rc8-06195-g939f04b drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 265892K/327280K available (4289K kernel code, 782K r=
wdata, 2784K rodata, 296K init, 7928K bss, 61388K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xffbfe000   (1716 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x817af000 - 0x817f9000   ( 296 kB)
[    0.000000]       .data : 0x81430af4 - 0x817ad880   (3571 kB)
[    0.000000]       .text : 0x81000000 - 0x81430af4   (4290 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D90c08000 soft=3D90c0a000
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 4911 kB
[    0.000000]  memory used by lock dependency info: 4911 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.332 MHz processor
[    0.000000] tsc: Detected 2693.332 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value..=20
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.66 Bogo=
MIPS (lpj=3D10773328)
5386.66 BogoMIPS (lpj=3D10773328)
[    0.008000] pid_max: default: 4096 minimum: 301
[    0.008000] pid_max: default: 4096 minimum: 301
[    0.008049] ACPI: Core revision 20140424
[    0.008049] ACPI: Core revision 20140424
[    0.012497] ACPI:=20
[    0.012497] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.013684] ACPI: setting ELCR to 0200 (from 0c00)
[    0.013684] ACPI: setting ELCR to 0200 (from 0c00)
[    0.014784] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.014784] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.015972] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.015972] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.016362] Initializing cgroup subsys freezer
[    0.016362] Initializing cgroup subsys freezer
[    0.017247] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.017247] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.017247] tlb_flushall_shift: 6
[    0.017247] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.017247] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.017247] tlb_flushall_shift: 6
[    0.020007] CPU:=20
[    0.020007] CPU: Intel Core Processor (Haswell)Intel Core Processor (Has=
well) (fam: 06, model: 3c (fam: 06, model: 3c, stepping: 01)
, stepping: 01)
[    0.024187] Performance Events:=20
[    0.024187] Performance Events: unsupported p6 CPU model 60 unsupported =
p6 CPU model 60 no PMU driver, software events only.
no PMU driver, software events only.
[    0.028337] pinctrl core: initialized pinctrl subsystem
[    0.028337] pinctrl core: initialized pinctrl subsystem
[    0.029823] regulator-dummy: no parameters
[    0.029823] regulator-dummy: no parameters
[    0.031198] NET: Registered protocol family 16
[    0.031198] NET: Registered protocol family 16
[    0.032529] cpuidle: using governor ladder
[    0.032529] cpuidle: using governor ladder
[    0.033610] ACPI: bus type PCI registered
[    0.033610] ACPI: bus type PCI registered
[    0.034554] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.034554] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.036009] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.036009] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.037277] PCI: Using configuration type 1 for base access
[    0.037277] PCI: Using configuration type 1 for base access
[    0.046947] ACPI: Added _OSI(Module Device)
[    0.046947] ACPI: Added _OSI(Module Device)
[    0.047682] ACPI: Added _OSI(Processor Device)
[    0.047682] ACPI: Added _OSI(Processor Device)
[    0.048008] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.048008] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.049003] ACPI: Added _OSI(Processor Aggregator Device)
[    0.049003] ACPI: Added _OSI(Processor Aggregator Device)
[    0.056111] ACPI: Interpreter enabled
[    0.056111] ACPI: Interpreter enabled
[    0.056787] ACPI Exception: AE_NOT_FOUND,=20
[    0.056787] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
 (20140424/hwxface-580)
[    0.058640] ACPI Exception: AE_NOT_FOUND,=20
[    0.058640] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
 (20140424/hwxface-580)
[    0.060036] ACPI: (supports S0 S3 S5)
[    0.060036] ACPI: (supports S0 S3 S5)
[    0.060748] ACPI: Using PIC for interrupt routing
[    0.060748] ACPI: Using PIC for interrupt routing
[    0.061720] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.061720] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.073313] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.073313] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.074632] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.074632] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.075669] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.075669] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.076442] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.076442] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.081045] PCI host bridge to bus 0000:00
[    0.081045] PCI host bridge to bus 0000:00
[    0.081837] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.081837] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.083047] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.083047] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.084014] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.084014] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.085381] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.085381] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.086647] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.086647] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.088111] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.088111] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.089845] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.089845] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.092124] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.092124] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.095873] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.095873] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.096920] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.096920] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.098247] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.098247] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.100008] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.100008] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.101310] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.101310] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.104183] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.104183] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.105619] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.105619] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.106914] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.106914] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.108410] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.108410] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.111714] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.111714] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.113258] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.113258] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.121410] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.121410] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.123247] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.123247] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.124904] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.124904] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.127144] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.127144] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.132820] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.132820] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.134524] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.134524] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.136479] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.136479] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.140733] pci_bus 0000:00: on NUMA node 0
[    0.140733] pci_bus 0000:00: on NUMA node 0
[    0.142499] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.142499] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.144147] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.144147] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.145855] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.145855] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.147102] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.147102] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.148272] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.148272] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.150360] ACPI: bus type USB registered
[    0.150360] ACPI: bus type USB registered
[    0.151190] usbcore: registered new interface driver usbfs
[    0.151190] usbcore: registered new interface driver usbfs
[    0.152042] usbcore: registered new interface driver hub
[    0.152042] usbcore: registered new interface driver hub
[    0.153146] usbcore: registered new device driver usb
[    0.153146] usbcore: registered new device driver usb
[    0.154196] media: Linux media interface: v0.10
[    0.154196] media: Linux media interface: v0.10
[    0.155048] Linux video capture interface: v2.00
[    0.155048] Linux video capture interface: v2.00
[    0.156107] pps_core: LinuxPPS API ver. 1 registered
[    0.156107] pps_core: LinuxPPS API ver. 1 registered
[    0.157545] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.157545] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.160170] wmi: Mapper loaded
[    0.160170] wmi: Mapper loaded
[    0.161347] PCI: Using ACPI for IRQ routing
[    0.161347] PCI: Using ACPI for IRQ routing
[    0.162582] PCI: pci_cache_line_size set to 64 bytes
[    0.162582] PCI: pci_cache_line_size set to 64 bytes
[    0.164179] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.164179] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.165923] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.165923] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.169435] Switched to clocksource kvm-clock
[    0.169435] Switched to clocksource kvm-clock
[    0.188860] pnp: PnP ACPI init
[    0.188860] pnp: PnP ACPI init
[    0.189672] ACPI: bus type PNP registered
[    0.189672] ACPI: bus type PNP registered
[    0.190832] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.190832] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.192825] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.192825] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.194691] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.194691] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.196608] pnp 00:03: [dma 2]
[    0.196608] pnp 00:03: [dma 2]
[    0.197590] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.197590] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.200140] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.200140] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.202446] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.202446] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.204791] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.204791] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.207516] pnp: PnP ACPI: found 7 devices
[    0.207516] pnp: PnP ACPI: found 7 devices
[    0.208893] ACPI: bus type PNP unregistered
[    0.208893] ACPI: bus type PNP unregistered
[    0.246183] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.246183] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.247794] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.247794] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.249493] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.249493] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.251300] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.251300] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.253184] NET: Registered protocol family 1
[    0.253184] NET: Registered protocol family 1
[    0.254456] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.254456] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.256301] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.256301] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.257980] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.257980] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.259864] pci 0000:00:02.0: Boot video device
[    0.259864] pci 0000:00:02.0: Boot video device
[    0.261250] PCI: CLS 0 bytes, default 64
[    0.261250] PCI: CLS 0 bytes, default 64
[    0.262857] Unpacking initramfs...
[    0.262857] Unpacking initramfs...
[    1.254242] debug: unmapping init [mem 0x927ab000-0x93feffff]
[    1.254242] debug: unmapping init [mem 0x927ab000-0x93feffff]
[    1.270604] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.270604] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.273399] spin_lock-torture: Creating torture_shuffle task
[    1.273399] spin_lock-torture: Creating torture_shuffle task
[    1.274467] spin_lock-torture: Creating torture_stutter task
[    1.274467] spin_lock-torture: Creating torture_stutter task
[    1.275514] spin_lock-torture: torture_shuffle task started
[    1.275514] spin_lock-torture: torture_shuffle task started
[    1.276531] spin_lock-torture: Creating lock_torture_writer task
[    1.276531] spin_lock-torture: Creating lock_torture_writer task
[    1.277753] spin_lock-torture: torture_stutter task started
[    1.277753] spin_lock-torture: torture_stutter task started
[    1.278808] spin_lock-torture: Creating lock_torture_writer task
[    1.278808] spin_lock-torture: Creating lock_torture_writer task
[    1.279915] spin_lock-torture: lock_torture_writer task started
[    1.279915] spin_lock-torture: lock_torture_writer task started
[    1.281022] spin_lock-torture: Creating lock_torture_stats task
[    1.281022] spin_lock-torture: Creating lock_torture_stats task
[    1.282109] spin_lock-torture: lock_torture_writer task started
[    1.282109] spin_lock-torture: lock_torture_writer task started
[    1.283538] futex hash table entries: 16 (order: -3, 704 bytes)
[    1.283538] futex hash table entries: 16 (order: -3, 704 bytes)
[    1.284609] Initialise system trusted keyring
[    1.284609] Initialise system trusted keyring
[    1.285845] spin_lock-torture: lock_torture_stats task started
[    1.285845] spin_lock-torture: lock_torture_stats task started
[    1.286982] VFS: Disk quotas dquot_6.5.2
[    1.286982] VFS: Disk quotas dquot_6.5.2
[    1.287739] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.287739] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.289068] fuse init (API version 7.23)
[    1.289068] fuse init (API version 7.23)
[    1.290738] Key type asymmetric registered
[    1.290738] Key type asymmetric registered
[    1.291514] Asymmetric key parser 'x509' registered
[    1.291514] Asymmetric key parser 'x509' registered
[    1.292448] test_string_helpers: Running tests...
[    1.292448] test_string_helpers: Running tests...
[    1.293645] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.293645] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.294815] crc32: self tests passed, processed 225944 bytes in 155219 n=
sec
[    1.294815] crc32: self tests passed, processed 225944 bytes in 155219 n=
sec
[    1.296271] crc32c: CRC_LE_BITS =3D 64
[    1.296271] crc32c: CRC_LE_BITS =3D 64
[    1.296901] crc32c: self tests passed, processed 225944 bytes in 77624 n=
sec
[    1.296901] crc32c: self tests passed, processed 225944 bytes in 77624 n=
sec
[    1.533409] crc32_combine: 8373 self tests passed
[    1.533409] crc32_combine: 8373 self tests passed
[    1.840521] crc32c_combine: 8373 self tests passed
[    1.840521] crc32c_combine: 8373 self tests passed
[    1.842143] xz_dec_test: module loaded
[    1.842143] xz_dec_test: module loaded
[    1.843018] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    1.843018] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    1.845454] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.845454] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.847149] vmlfb: initializing
[    1.847149] vmlfb: initializing
[    1.848126] intel_idle: does not run on family 6 model 60
[    1.848126] intel_idle: does not run on family 6 model 60
[    1.849399] ipmi message handler version 39.2
[    1.849399] ipmi message handler version 39.2
[    1.850414] ipmi device interface
[    1.850414] ipmi device interface
[    1.851297] IPMI System Interface driver.
[    1.851297] IPMI System Interface driver.
[    1.852567] ipmi_si: Unable to find any System Interface(s)
[    1.852567] ipmi_si: Unable to find any System Interface(s)
[    1.853878] IPMI Watchdog: driver initialized
[    1.853878] IPMI Watchdog: driver initialized
[    1.854890] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    1.854890] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    1.897400] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.897400] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.922332] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.922332] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.925597] Non-volatile memory driver v1.3
[    1.925597] Non-volatile memory driver v1.3
[    1.926635] nsc_gpio initializing
[    1.926635] nsc_gpio initializing
[    1.927417] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.927417] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.928615] Linux agpgart interface v0.103
[    1.928615] Linux agpgart interface v0.103
[    1.929716] [drm] Initialized drm 1.1.0 20060810
[    1.929716] [drm] Initialized drm 1.1.0 20060810
[    1.932291] [TTM] Zone  kernel: Available graphics memory: 141138 kiB
[    1.932291] [TTM] Zone  kernel: Available graphics memory: 141138 kiB
[    1.933796] [TTM] Initializing pool allocator
[    1.933796] [TTM] Initializing pool allocator
[    1.936815] [drm] fb mappable at 0xFC000000
[    1.936815] [drm] fb mappable at 0xFC000000
[    1.937801] [drm] vram aper at 0xFC000000
[    1.937801] [drm] vram aper at 0xFC000000
[    1.938748] [drm] size 4194304
[    1.938748] [drm] size 4194304
[    1.939458] [drm] fb depth is 24
[    1.939458] [drm] fb depth is 24
[    1.940267] [drm]    pitch is 3072
[    1.940267] [drm]    pitch is 3072
[    1.941512] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    1.941512] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    1.943029] cirrus 0000:00:02.0: registered panic notifier
[    1.943029] cirrus 0000:00:02.0: registered panic notifier
[    1.944354] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    1.944354] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    1.946316] usbcore: registered new interface driver udl
[    1.946316] usbcore: registered new interface driver udl
[    1.947868] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    1.947868] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    1.949582] Phantom Linux Driver, version n0.9.8, init OK
[    1.949582] Phantom Linux Driver, version n0.9.8, init OK
[    1.950989] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    1.950989] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    1.953048] Guest personality initialized and is inactive
[    1.953048] Guest personality initialized and is inactive
[    1.954514] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D63)
[    1.954514] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D63)
[    1.956656] Initialized host personality
[    1.956656] Initialized host personality
[    1.957702] usbcore: registered new interface driver rtsx_usb
[    1.957702] usbcore: registered new interface driver rtsx_usb
[    1.959492] uhci_hcd: USB Universal Host Controller Interface driver
[    1.959492] uhci_hcd: USB Universal Host Controller Interface driver
[    1.961130] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    1.961130] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    1.962531] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    1.962531] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    1.964749] usbcore: registered new interface driver usblp
[    1.964749] usbcore: registered new interface driver usblp
[    1.966161] usbcore: registered new interface driver usbtmc
[    1.966161] usbcore: registered new interface driver usbtmc
[    1.967575] usbcore: registered new interface driver mdc800
[    1.967575] usbcore: registered new interface driver mdc800
[    1.968940] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    1.968940] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    1.970816] usbcore: registered new interface driver idmouse
[    1.970816] usbcore: registered new interface driver idmouse
[    1.972316] usbcore: registered new interface driver iowarrior
[    1.972316] usbcore: registered new interface driver iowarrior
[    1.973834] usbcore: registered new interface driver usblcd
[    1.973834] usbcore: registered new interface driver usblcd
[    1.975229] usbcore: registered new interface driver ldusb
[    1.975229] usbcore: registered new interface driver ldusb
[    1.977066] usbcore: registered new interface driver rio500
[    1.977066] usbcore: registered new interface driver rio500
[    1.978702] usbcore: registered new interface driver usbtest
[    1.978702] usbcore: registered new interface driver usbtest
[    1.980228] usbcore: registered new interface driver usb_ehset_test
[    1.980228] usbcore: registered new interface driver usb_ehset_test
[    1.982000] usbcore: registered new interface driver trancevibrator
[    1.982000] usbcore: registered new interface driver trancevibrator
[    1.983571] usbcore: registered new interface driver yurex
[    1.983571] usbcore: registered new interface driver yurex
[    1.985357] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    1.985357] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    1.987093] dummy_hcd dummy_hcd.0: Dummy host controller
[    1.987093] dummy_hcd dummy_hcd.0: Dummy host controller
[    1.988459] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    1.988459] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    1.990574] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.990574] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.992299] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.992299] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.994194] usb usb1: Product: Dummy host controller
[    1.994194] usb usb1: Product: Dummy host controller
[    1.995418] usb usb1: Manufacturer: Linux 3.15.0-rc8-06195-g939f04b dumm=
y_hcd
[    1.995418] usb usb1: Manufacturer: Linux 3.15.0-rc8-06195-g939f04b dumm=
y_hcd
[    1.997210] usb usb1: SerialNumber: dummy_hcd.0
[    1.997210] usb usb1: SerialNumber: dummy_hcd.0
[    1.999106] hub 1-0:1.0: USB hub found
[    1.999106] hub 1-0:1.0: USB hub found
[    2.000163] hub 1-0:1.0: 1 port detected
[    2.000163] hub 1-0:1.0: 1 port detected
[    2.002906] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.002906] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.005686] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.005686] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.007004] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.007004] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.076268] usbcore: registered new interface driver ims_pcu
[    2.076268] usbcore: registered new interface driver ims_pcu
[    2.078960] i2c /dev entries driver
[    2.078960] i2c /dev entries driver
[    2.080229] i2c-parport-light: adapter type unspecified
[    2.080229] i2c-parport-light: adapter type unspecified
[    2.082632] saa7146: register extension 'Multimedia eXtension Board'
[    2.082632] saa7146: register extension 'Multimedia eXtension Board'
[    2.084502] saa7146: register extension 'hexium gemini'
[    2.084502] saa7146: register extension 'hexium gemini'
[    2.085809] Zoran MJPEG board driver version 0.10.1
[    2.085809] Zoran MJPEG board driver version 0.10.1
[    2.087034] Linux video codec intermediate layer: v0.2
[    2.087034] Linux video codec intermediate layer: v0.2
[    2.088322] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[    2.088322] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[    2.089936] Driver for 1-wire Dallas network protocol.
[    2.089936] Driver for 1-wire Dallas network protocol.
[    2.091284] usbcore: registered new interface driver DS9490R
[    2.091284] usbcore: registered new interface driver DS9490R
[    2.092761] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    2.092761] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    2.095334] f71882fg: Not a Fintek device
[    2.095334] f71882fg: Not a Fintek device
[    2.096623] f71882fg: Not a Fintek device
[    2.096623] f71882fg: Not a Fintek device
[    2.098477] pc87360: PC8736x not detected, module not inserted
[    2.098477] pc87360: PC8736x not detected, module not inserted
[    2.100565] sch56xx_common: Unsupported device id: 0xff
[    2.100565] sch56xx_common: Unsupported device id: 0xff
[    2.102289] sch56xx_common: Unsupported device id: 0xff
[    2.102289] sch56xx_common: Unsupported device id: 0xff
[    2.104354] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    2.104354] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    2.106926] acquirewdt: I/O address 0x0043 already in use
[    2.106926] acquirewdt: I/O address 0x0043 already in use
[    2.108784] acquirewdt: probe of acquirewdt failed with error -5
[    2.108784] acquirewdt: probe of acquirewdt failed with error -5
[    2.111090] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    2.111090] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    2.113500] i6300esb: initialized (0x94b50000). heartbeat=3D30 sec (nowa=
yout=3D0)
[    2.113500] i6300esb: initialized (0x94b50000). heartbeat=3D30 sec (nowa=
yout=3D0)
[    2.115864] pc87413_wdt: Version 1.1 at io 0x2E
[    2.115864] pc87413_wdt: Version 1.1 at io 0x2E
[    2.117382] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    2.117382] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    2.119555] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    2.119555] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    2.121626] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    2.121626] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    2.124386] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    2.124386] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    2.126373] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    2.126373] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    2.128331] ledtrig-cpu: registered to indicate activity on CPUs
[    2.128331] ledtrig-cpu: registered to indicate activity on CPUs
[    2.130730] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    2.130730] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    2.132615] evbug: Connected device: input0 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.132615] evbug: Connected device: input0 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.135329] ashmem: initialized
[    2.135329] ashmem: initialized
[    2.136248] logger: created 256K log 'log_main'
[    2.136248] logger: created 256K log 'log_main'
[    2.137357] logger: created 256K log 'log_events'
[    2.137357] logger: created 256K log 'log_events'
[    2.138369] logger: created 256K log 'log_radio'
[    2.138369] logger: created 256K log 'log_radio'
[    2.139363] logger: created 256K log 'log_system'
[    2.139363] logger: created 256K log 'log_system'
[    2.140278] asus_wmi: Asus Management GUID not found
[    2.140278] asus_wmi: Asus Management GUID not found
[    2.141194] Initializing HPQ6001 module
[    2.141194] Initializing HPQ6001 module
[    2.141935] hdaps: supported laptop not found!
[    2.141935] hdaps: supported laptop not found!
[    2.142746] hdaps: driver init failed (ret=3D-19)!
[    2.142746] hdaps: driver init failed (ret=3D-19)!
[    2.143614] toshiba_acpi: Unable to create proc dir toshiba
[    2.143614] toshiba_acpi: Unable to create proc dir toshiba
[    2.144675] alienware_wmi: alienware-wmi: No known WMI GUID found
[    2.144675] alienware_wmi: alienware-wmi: No known WMI GUID found
[    2.146237]  fake-fmc-carrier: mezzanine 0
[    2.146237]  fake-fmc-carrier: mezzanine 0
[    2.146977]       Manufacturer: fake-vendor
[    2.146977]       Manufacturer: fake-vendor
[    2.147741]       Product name: fake-design-for-testing
[    2.147741]       Product name: fake-design-for-testing
[    2.148827] oprofile: using timer interrupt.
[    2.148827] oprofile: using timer interrupt.
[    2.150107] bootconsole [earlyser0] disabled
[    2.150107] bootconsole [earlyser0] disabled
[    2.151010] Loading compiled-in X.509 certificates
[    2.154140] Loaded X.509 cert 'Magrathea: Glacier signing key: a6ff38ead=
18bceb4007eef3b5ec8c1ad9e06c549'
[    2.156486] debug: unmapping init [mem 0x817af000-0x817f8fff]
[    2.164798] random: init urandom read with 8 bits of entropy available
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[    2.268177] tsc: Refined TSC clocksource calibration: 2693.506 MHz
[   12.432117] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
[   13.568076] hrtimer: interrupt took 82693 ns
[   13.628359] random: nonblocking pool is initialized
[   29.294589] CE: hpet increased min_delta_ns to 5000 nsec
[   29.295393] CE: hpet increased min_delta_ns to 7500 nsec
[   29.296028] CE: hpet increased min_delta_ns to 11250 nsec
[   29.296028] CE: hpet increased min_delta_ns to 16875 nsec
[   29.644027] CE: hpet increased min_delta_ns to 25312 nsec
[   29.644027]=20
[   29.644027] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   29.644027] [ INFO: possible circular locking dependency detected ]
[   29.644027] 3.15.0-rc8-06195-g939f04b #2 Not tainted
[   29.644027] -------------------------------------------------------
[   29.644027] trinity-main/74 is trying to acquire lock:
[   29.644027]  (&port_lock_key){-.....}, at: [<811c60be>] serial8250_conso=
le_write+0x8c/0x10c
[   29.644027]=20
[   29.644027] but task is already holding lock:
[   29.644027]  (hrtimer_bases.lock){-.-...}, at: [<8103caeb>] hrtimer_try_=
to_cancel+0x13/0x66
[   29.644027]=20
[   29.644027] which lock already depends on the new lock.
[   29.644027]=20
[   29.644027]=20
[   29.644027] the existing dependency chain (in reverse order) is:
[   29.644027]=20
[   29.644027] -> #5 (hrtimer_bases.lock){-.-...}:
[   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
[   29.644027]        [<8103c918>] __hrtimer_start_range_ns+0x1c/0x197
[   29.644027]        [<8107ec20>] perf_swevent_start_hrtimer.part.41+0x7a/=
0x85
[   29.644027]        [<81080792>] task_clock_event_start+0x3a/0x3f
[   29.644027]        [<810807a4>] task_clock_event_add+0xd/0x14
[   29.644027]        [<8108259a>] event_sched_in+0xb6/0x17a
[   29.644027]        [<810826a2>] group_sched_in+0x44/0x122
[   29.644027]        [<81082885>] ctx_sched_in.isra.67+0x105/0x11f
[   29.644027]        [<810828e6>] perf_event_sched_in.isra.70+0x47/0x4b
[   29.644027]        [<81082bf6>] __perf_install_in_context+0x8b/0xa3
[   29.644027]        [<8107eb8e>] remote_function+0x12/0x2a
[   29.644027]        [<8105f5af>] smp_call_function_single+0x2d/0x53
[   29.644027]        [<8107e17d>] task_function_call+0x30/0x36
[   29.644027]        [<8107fb82>] perf_install_in_context+0x87/0xbb
[   29.644027]        [<810852c9>] SYSC_perf_event_open+0x5c6/0x701
[   29.644027]        [<810856f9>] SyS_perf_event_open+0x17/0x19
[   29.644027]        [<8142f8ee>] syscall_call+0x7/0xb
[   29.644027]=20
[   29.644027] -> #4 (&ctx->lock){......}:
[   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]        [<8142f04c>] _raw_spin_lock+0x21/0x30
[   29.644027]        [<81081df3>] __perf_event_task_sched_out+0x1dc/0x34f
[   29.644027]        [<8142cacc>] __schedule+0x4c6/0x4cb
[   29.644027]        [<8142cae0>] schedule+0xf/0x11
[   29.644027]        [<8142f9a6>] work_resched+0x5/0x30
[   29.644027]=20
[   29.644027] -> #3 (&rq->lock){-.-.-.}:
[   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]        [<8142f04c>] _raw_spin_lock+0x21/0x30
[   29.644027]        [<81040873>] __task_rq_lock+0x33/0x3a
[   29.644027]        [<8104184c>] wake_up_new_task+0x25/0xc2
[   29.644027]        [<8102474b>] do_fork+0x15c/0x2a0
[   29.644027]        [<810248a9>] kernel_thread+0x1a/0x1f
[   29.644027]        [<814232a2>] rest_init+0x1a/0x10e
[   29.644027]        [<817af949>] start_kernel+0x303/0x308
[   29.644027]        [<817af2ab>] i386_start_kernel+0x79/0x7d
[   29.644027]=20
[   29.644027] -> #2 (&p->pi_lock){-.-...}:
[   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
[   29.644027]        [<810413dd>] try_to_wake_up+0x1d/0xd6
[   29.644027]        [<810414cd>] default_wake_function+0xb/0xd
[   29.644027]        [<810461f3>] __wake_up_common+0x39/0x59
[   29.644027]        [<81046346>] __wake_up+0x29/0x3b
[   29.644027]        [<811b8733>] tty_wakeup+0x49/0x51
[   29.644027]        [<811c3568>] uart_write_wakeup+0x17/0x19
[   29.644027]        [<811c5dc1>] serial8250_tx_chars+0xbc/0xfb
[   29.644027]        [<811c5f28>] serial8250_handle_irq+0x54/0x6a
[   29.644027]        [<811c5f57>] serial8250_default_handle_irq+0x19/0x1c
[   29.644027]        [<811c56d8>] serial8250_interrupt+0x38/0x9e
[   29.644027]        [<810510e7>] handle_irq_event_percpu+0x5f/0x1e2
[   29.644027]        [<81051296>] handle_irq_event+0x2c/0x43
[   29.644027]        [<81052cee>] handle_level_irq+0x57/0x80
[   29.644027]        [<81002a72>] handle_irq+0x46/0x5c
[   29.644027]        [<810027df>] do_IRQ+0x32/0x89
[   29.644027]        [<8143036e>] common_interrupt+0x2e/0x33
[   29.644027]        [<8142f23c>] _raw_spin_unlock_irqrestore+0x3f/0x49
[   29.644027]        [<811c25a4>] uart_start+0x2d/0x32
[   29.644027]        [<811c2c04>] uart_write+0xc7/0xd6
[   29.644027]        [<811bc6f6>] n_tty_write+0xb8/0x35e
[   29.644027]        [<811b9beb>] tty_write+0x163/0x1e4
[   29.644027]        [<811b9cd9>] redirected_tty_write+0x6d/0x75
[   29.644027]        [<810b6ed6>] vfs_write+0x75/0xb0
[   29.644027]        [<810b7265>] SyS_write+0x44/0x77
[   29.644027]        [<8142f8ee>] syscall_call+0x7/0xb
[   29.644027]=20
[   29.644027] -> #1 (&tty->write_wait){-.....}:
[   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
[   29.644027]        [<81046332>] __wake_up+0x15/0x3b
[   29.644027]        [<811b8733>] tty_wakeup+0x49/0x51
[   29.644027]        [<811c3568>] uart_write_wakeup+0x17/0x19
[   29.644027]        [<811c5dc1>] serial8250_tx_chars+0xbc/0xfb
[   29.644027]        [<811c5f28>] serial8250_handle_irq+0x54/0x6a
[   29.644027]        [<811c5f57>] serial8250_default_handle_irq+0x19/0x1c
[   29.644027]        [<811c56d8>] serial8250_interrupt+0x38/0x9e
[   29.644027]        [<810510e7>] handle_irq_event_percpu+0x5f/0x1e2
[   29.644027]        [<81051296>] handle_irq_event+0x2c/0x43
[   29.644027]        [<81052cee>] handle_level_irq+0x57/0x80
[   29.644027]        [<81002a72>] handle_irq+0x46/0x5c
[   29.644027]        [<810027df>] do_IRQ+0x32/0x89
[   29.644027]        [<8143036e>] common_interrupt+0x2e/0x33
[   29.644027]        [<8142f23c>] _raw_spin_unlock_irqrestore+0x3f/0x49
[   29.644027]        [<811c25a4>] uart_start+0x2d/0x32
[   29.644027]        [<811c2c04>] uart_write+0xc7/0xd6
[   29.644027]        [<811bc6f6>] n_tty_write+0xb8/0x35e
[   29.644027]        [<811b9beb>] tty_write+0x163/0x1e4
[   29.644027]        [<811b9cd9>] redirected_tty_write+0x6d/0x75
[   29.644027]        [<810b6ed6>] vfs_write+0x75/0xb0
[   29.644027]        [<810b7265>] SyS_write+0x44/0x77
[   29.644027]        [<8142f8ee>] syscall_call+0x7/0xb
[   29.644027]=20
[   29.644027] -> #0 (&port_lock_key){-.....}:
[   29.644027]        [<8104a62d>] __lock_acquire+0x9ea/0xc6d
[   29.644027]        [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]        [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
[   29.644027]        [<811c60be>] serial8250_console_write+0x8c/0x10c
[   29.644027]        [<8104e402>] call_console_drivers.constprop.31+0x87/0=
x118
[   29.644027]        [<8104f5d5>] console_unlock+0x1d7/0x398
[   29.644027]        [<8104fb70>] vprintk_emit+0x3da/0x3e4
[   29.644027]        [<81425f76>] printk+0x17/0x19
[   29.644027]        [<8105bfa0>] clockevents_program_min_delta+0x104/0x116
[   29.644027]        [<8105c548>] clockevents_program_event+0xe7/0xf3
[   29.644027]        [<8105cc1c>] tick_program_event+0x1e/0x23
[   29.644027]        [<8103c43c>] hrtimer_force_reprogram+0x88/0x8f
[   29.644027]        [<8103c49e>] __remove_hrtimer+0x5b/0x79
[   29.644027]        [<8103cb21>] hrtimer_try_to_cancel+0x49/0x66
[   29.644027]        [<8103cb4b>] hrtimer_cancel+0xd/0x18
[   29.644027]        [<8107f102>] perf_swevent_cancel_hrtimer.part.60+0x2b=
/0x30
[   29.644027]        [<81080705>] task_clock_event_stop+0x20/0x64
[   29.644027]        [<81080756>] task_clock_event_del+0xd/0xf
[   29.644027]        [<81081350>] event_sched_out+0xab/0x11e
[   29.644027]        [<810813e0>] group_sched_out+0x1d/0x66
[   29.644027]        [<81081682>] ctx_sched_out+0xaf/0xbf
[   29.644027]        [<81081e04>] __perf_event_task_sched_out+0x1ed/0x34f
[   29.644027]        [<8142cacc>] __schedule+0x4c6/0x4cb
[   29.644027]        [<8142cae0>] schedule+0xf/0x11
[   29.644027]        [<8142f9a6>] work_resched+0x5/0x30
[   29.644027]=20
[   29.644027] other info that might help us debug this:
[   29.644027]=20
[   29.644027] Chain exists of:
[   29.644027]   &port_lock_key --> &ctx->lock --> hrtimer_bases.lock
[   29.644027]=20
[   29.644027]  Possible unsafe locking scenario:
[   29.644027]=20
[   29.644027]        CPU0                    CPU1
[   29.644027]        ----                    ----
[   29.644027]   lock(hrtimer_bases.lock);
[   29.644027]                                lock(&ctx->lock);
[   29.644027]                                lock(hrtimer_bases.lock);
[   29.644027]   lock(&port_lock_key);
[   29.644027]=20
[   29.644027]  *** DEADLOCK ***
[   29.644027]=20
[   29.644027] 4 locks held by trinity-main/74:
[   29.644027]  #0:  (&rq->lock){-.-.-.}, at: [<8142c6f3>] __schedule+0xed/=
0x4cb
[   29.644027]  #1:  (&ctx->lock){......}, at: [<81081df3>] __perf_event_ta=
sk_sched_out+0x1dc/0x34f
[   29.644027]  #2:  (hrtimer_bases.lock){-.-...}, at: [<8103caeb>] hrtimer=
_try_to_cancel+0x13/0x66
[   29.644027]  #3:  (console_lock){+.+...}, at: [<8104fb5d>] vprintk_emit+=
0x3c7/0x3e4
[   29.644027]=20
[   29.644027] stack backtrace:
[   29.644027] CPU: 0 PID: 74 Comm: trinity-main Not tainted 3.15.0-rc8-061=
95-g939f04b #2
[   29.644027]  00000000 81c3a310 8b995c14 81426f69 8b995c44 81425a99 8161f=
671 8161f570
[   29.644027]  8161f538 8161f559 8161f538 8b995c78 8b142bb0 00000004 8b142=
fdc 8b142bb0
[   29.644027]  8b995ca8 8104a62d 8b142fac 000016f2 81c3a310 00000001 00000=
001 00000003
[   29.644027] Call Trace:
[   29.644027]  [<81426f69>] dump_stack+0x16/0x18
[   29.644027]  [<81425a99>] print_circular_bug+0x18f/0x19c
[   29.644027]  [<8104a62d>] __lock_acquire+0x9ea/0xc6d
[   29.644027]  [<8104a942>] lock_acquire+0x92/0x101
[   29.644027]  [<811c60be>] ? serial8250_console_write+0x8c/0x10c
[   29.644027]  [<811c6032>] ? wait_for_xmitr+0x76/0x76
[   29.644027]  [<8142f11d>] _raw_spin_lock_irqsave+0x2e/0x3e
[   29.644027]  [<811c60be>] ? serial8250_console_write+0x8c/0x10c
[   29.644027]  [<811c60be>] serial8250_console_write+0x8c/0x10c
[   29.644027]  [<8104af87>] ? lock_release+0x191/0x223
[   29.644027]  [<811c6032>] ? wait_for_xmitr+0x76/0x76
[   29.644027]  [<8104e402>] call_console_drivers.constprop.31+0x87/0x118
[   29.644027]  [<8104f5d5>] console_unlock+0x1d7/0x398
[   29.644027]  [<8104fb70>] vprintk_emit+0x3da/0x3e4
[   29.644027]  [<81425f76>] printk+0x17/0x19
[   29.644027]  [<8105bfa0>] clockevents_program_min_delta+0x104/0x116
[   29.644027]  [<8105c548>] clockevents_program_event+0xe7/0xf3
[   29.644027]  [<8105cc1c>] tick_program_event+0x1e/0x23
[   29.644027]  [<8103c43c>] hrtimer_force_reprogram+0x88/0x8f
[   29.644027]  [<8103c49e>] __remove_hrtimer+0x5b/0x79
[   29.644027]  [<8103cb21>] hrtimer_try_to_cancel+0x49/0x66
[   29.644027]  [<8103cb4b>] hrtimer_cancel+0xd/0x18
[   29.644027]  [<8107f102>] perf_swevent_cancel_hrtimer.part.60+0x2b/0x30
[   29.644027]  [<81080705>] task_clock_event_stop+0x20/0x64
[   29.644027]  [<81080756>] task_clock_event_del+0xd/0xf
[   29.644027]  [<81081350>] event_sched_out+0xab/0x11e
[   29.644027]  [<810813e0>] group_sched_out+0x1d/0x66
[   29.644027]  [<81081682>] ctx_sched_out+0xaf/0xbf
[   29.644027]  [<81081e04>] __perf_event_task_sched_out+0x1ed/0x34f
[   29.644027]  [<8104416d>] ? __dequeue_entity+0x23/0x27
[   29.644027]  [<81044505>] ? pick_next_task_fair+0xb1/0x120
[   29.644027]  [<8142cacc>] __schedule+0x4c6/0x4cb
[   29.644027]  [<81047574>] ? trace_hardirqs_off_caller+0xd7/0x108
[   29.644027]  [<810475b0>] ? trace_hardirqs_off+0xb/0xd
[   29.644027]  [<81056346>] ? rcu_irq_exit+0x64/0x77
[   29.644027]  [<81047574>] ? trace_hardirqs_off_caller+0xd7/0x108
[   29.644027]  [<8142cae0>] schedule+0xf/0x11
[   29.644027]  [<8142f9a6>] work_resched+0x5/0x30
[   29.644027]  [<81420000>] ? unix_find_other.isra.34+0xd0/0x156
[   31.801763] CE: hpet increased min_delta_ns to 37968 nsec
[   61.284075] spin_lock-torture: Writes:  Total: 2  Max/Min: 0/0   Fail: 0=
=20
plymouth-upstart-bridge: ply-event-loop.c:497: ply_event_loop_new: Assertio=
n `loop->epoll_fd >=3D 0' failed.
/etc/lsb-base-logging.sh: line 5:  3845 Aborted                 plymouth --=
ping > /dev/null 2>&1
/etc/lsb-base-logging.sh: line 5:  3852 Aborted                 plymouth --=
ping > /dev/null 2>&1
mount: proc has wrong device number or fs type proc not supported
/etc/lsb-base-logging.sh: line 5:  3870 Aborted                 plymouth --=
ping > /dev/null 2>&1
/etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
umount: /var/run: not mounted
umount: /var/lock: not mounted
umount: /dev/shm: not mounted
mount: / is busy
 * Will now restart
[   67.800790] Unregister pv shared memory for cpu 0
[   67.801240] spin_lock-torture: Unscheduled system shutdown detected
[   67.802208] reboot: Restarting system
[   67.802527] reboot: machine restart
Elapsed time: 70
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/i38=
6-randconfig-ha2-0731/939f04bec1a4ef6ba4370b0f34b01decc844b1b1/vmlinuz-3.15=
=2E0-rc8-06195-g939f04b -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,11=
5200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ha2-0731/kvmarm:next:9=
39f04bec1a4ef6ba4370b0f34b01decc844b1b1:bisect-linux-2/.vmlinuz-939f04bec1a=
4ef6ba4370b0f34b01decc844b1b1-20140801145621-157-kbuild branch=3Dkvmarm/nex=
t BOOT_IMAGE=3D/kernel/i386-randconfig-ha2-0731/939f04bec1a4ef6ba4370b0f34b=
01decc844b1b1/vmlinuz-3.15.0-rc8-06195-g939f04b drbd.minor_count=3D8'  -ini=
trd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog=
 i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-kbuild-=
20 -serial file:/dev/shm/kboot/serial-quantal-kbuild-20 -daemonize -display=
 none -monitor null=20

--b5gNqxB1S1yM7hjW
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-ha2-0731-fb3ec67942e92e5713e05b7691b277d0a0c0575d-INFO:-possible-circular-locking-dependency-detected-99818.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgZmIzZWM2Ny4uLiBLVk06IGFybTY0OiBHSUN2MzogbWFuZGF0ZSBw
YWdlLWFsaWduZWQgR0lDViByZWdpb24KZ2l0IGNoZWNrb3V0IDlmNjIyNmE3NjJjN2FlMDJm
NmEyM2EzZDRmYzU1MmRhZmE1N2VhMjMKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS9rdm1hcm06bmV4dDo5ZjYyMjZhNzYyYzdh
ZTAyZjZhMjNhM2Q0ZmM1NTJkYWZhNTdlYTIzOmJpc2VjdC1saW51eC0yCgoyMDE0LTA3LTMx
LTIzOjM2OjM2IDlmNjIyNmE3NjJjN2FlMDJmNmEyM2EzZDRmYzU1MmRhZmE1N2VhMjMgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
aTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLTlmNjIyNmE3NjJjN2FlMDJmNmEyM2EzZDRmYzU1
MmRhZmE1N2VhMjMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1oYTItMDczMS85ZjYyMjZhNzYyYzdhZTAyZjZhMjNhM2Q0ZmM1NTJkYWZhNTdlYTIzCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWctaGEyLTA3MzEtOWY2MjI2YTc2MmM3YWUwMmY2YTIzYTNkNGZjNTUyZGFm
YTU3ZWEyMwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvbGtwLWhzeDAxLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS05ZjYy
MjZhNzYyYzdhZTAyZjZhMjNhM2Q0ZmM1NTJkYWZhNTdlYTIzCmtlcm5lbDogL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaGEyLTA3MzEvOWY2MjI2YTc2MmM3YWUwMmY2YTIzYTNkNGZjNTUy
ZGFmYTU3ZWEyMy92bWxpbnV6LTMuMTYuMC1yYzEtMDAwODItZzlmNjIyNmEKCjIwMTQtMDct
MzEtMjM6Mzk6MzYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkzCTE1CTE3CTIxCTMwIFRFU1Qg
RkFJTFVSRQpbICAgMTQuMTQzOTIwXSBzb2NrOiBwcm9jZXNzIGB0cmluaXR5LW1haW4nIGlz
IHVzaW5nIG9ic29sZXRlIHNldHNvY2tvcHQgU09fQlNEQ09NUEFUClsgICAxNS45ODk4NDJd
IApbICAgMTUuOTkwMTEyXSA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KWyAgIDE1Ljk5MTE5Nl0gWyBJTkZPOiBwb3NzaWJsZSBjaXJj
dWxhciBsb2NraW5nIGRlcGVuZGVuY3kgZGV0ZWN0ZWQgXQpbICAgMTUuOTkyMDk3XSAzLjE2
LjAtcmMxLTAwMDgyLWc5ZjYyMjZhICMxIE5vdCB0YWludGVkClsgICAxNS45OTIwOTddIC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0K
WyAgIDE1Ljk5MjA5N10gdHJpbml0eS1tYWluLzc0IGlzIHRyeWluZyB0byBhY3F1aXJlIGxv
Y2s6ClsgICAxNS45OTIwOTddICAoaHJ0aW1lcl9iYXNlcy5sb2NrKXstLi0uLi59LCBhdDog
Wzw4MTAzY2NmZD5dIF9faHJ0aW1lcl9zdGFydF9yYW5nZV9ucysweDFjLzB4MTk3ClsgICAx
NS45OTIwOTddIApbICAgMTUuOTkyMDk3XSBidXQgdGFzayBpcyBhbHJlYWR5IGhvbGRpbmcg
bG9jazoKWyAgIDE1Ljk5MjA5N10gICgmY3R4LT5sb2NrKXsuLi4uLi59LCBhdDogWzw4MTA3
ZjlhMz5dIHBlcmZfY3R4X2xvY2srMHgxYS8weDFkClsgICAxNS45OTIwOTddIApbICAgMTUu
OTkyMDk3XSB3aGljaCBsb2NrIGFscmVhZHkgZGVwZW5kcyBvbiB0aGUgbmV3IGxvY2suClsg
ICAxNS45OTIwOTddIApbICAgMTUuOTkyMDk3XSAKWyAgIDE1Ljk5MjA5N10gdGhlIGV4aXN0
aW5nIGRlcGVuZGVuY3kgY2hhaW4gKGluIHJldmVyc2Ugb3JkZXIpIGlzOgpbICAgMTUuOTky
MDk3XSAKLT4gIzUgKCZjdHgtPmxvY2spey4uLi4uLn06ClsgICAxNS45OTIwOTddICAgICAg
ICBbPDgxMDRhZTBiPl0gbG9ja19hY3F1aXJlKzB4OTIvMHgxMDEKWyAgIDE1Ljk5MjA5N10g
ICAgICAgIFs8ODE0MzkwM2M+XSBfcmF3X3NwaW5fbG9jaysweDIxLzB4MzAKWyAgIDE1Ljk5
MjA5N10gICAgICAgIFs8ODEwODM3NGQ+XSBfX3BlcmZfZXZlbnRfdGFza19zY2hlZF9vdXQr
MHgxZGMvMHgzNGYKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODE0MzZhYjQ+XSBfX3NjaGVk
dWxlKzB4NGM2LzB4NGNiClsgICAxNS45OTIwOTddICAgICAgICBbPDgxNDM2YWM4Pl0gc2No
ZWR1bGUrMHhmLzB4MTEKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODE0MzlhODY+XSB3b3Jr
X3Jlc2NoZWQrMHg1LzB4MmMKWyAgIDE1Ljk5MjA5N10gCi0+ICM0ICgmcnEtPmxvY2spey0u
LS4tLn06ClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMDRhZTBiPl0gbG9ja19hY3F1aXJl
KzB4OTIvMHgxMDEKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODE0MzkwM2M+XSBfcmF3X3Nw
aW5fbG9jaysweDIxLzB4MzAKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEwNDBkMzE+XSBf
X3Rhc2tfcnFfbG9jaysweDMzLzB4M2EKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEwNDFk
MGE+XSB3YWtlX3VwX25ld190YXNrKzB4MjUvMHhjMgpbICAgMTUuOTkyMDk3XSAgICAgICAg
Wzw4MTAyNGQxNj5dIGRvX2ZvcmsrMHgxNTQvMHgyNjUKWyAgIDE1Ljk5MjA5N10gICAgICAg
IFs8ODEwMjRlNDE+XSBrZXJuZWxfdGhyZWFkKzB4MWEvMHgxZgpbICAgMTUuOTkyMDk3XSAg
ICAgICAgWzw4MTQyZDMzYj5dIHJlc3RfaW5pdCsweDFhLzB4MTBlClsgICAxNS45OTIwOTdd
ICAgICAgICBbPDgxN2MyYTRiPl0gc3RhcnRfa2VybmVsKzB4MzIzLzB4MzI4ClsgICAxNS45
OTIwOTddICAgICAgICBbPDgxN2MyMmFiPl0gaTM4Nl9zdGFydF9rZXJuZWwrMHg3OS8weDdk
ClsgICAxNS45OTIwOTddIAotPiAjMyAoJnAtPnBpX2xvY2spey0uLS4uLn06ClsgICAxNS45
OTIwOTddICAgICAgICBbPDgxMDRhZTBiPl0gbG9ja19hY3F1aXJlKzB4OTIvMHgxMDEKWyAg
IDE1Ljk5MjA5N10gICAgICAgIFs8ODE0MzkxMGQ+XSBfcmF3X3NwaW5fbG9ja19pcnFzYXZl
KzB4MmUvMHgzZQpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTA0MTg5Yj5dIHRyeV90b193
YWtlX3VwKzB4MWQvMHhkNgpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTA0MTk4Yj5dIGRl
ZmF1bHRfd2FrZV9mdW5jdGlvbisweGIvMHhkClsgICAxNS45OTIwOTddICAgICAgICBbPDgx
MDQ2NmFmPl0gX193YWtlX3VwX2NvbW1vbisweDM5LzB4NTkKWyAgIDE1Ljk5MjA5N10gICAg
ICAgIFs8ODEwNDY4MDI+XSBfX3dha2VfdXArMHgyOS8weDNiClsgICAxNS45OTIwOTddICAg
ICAgICBbPDgxMWJhZDVkPl0gdHR5X3dha2V1cCsweDQ5LzB4NTEKWyAgIDE1Ljk5MjA5N10g
ICAgICAgIFs8ODExYzVjNTg+XSB1YXJ0X3dyaXRlX3dha2V1cCsweDE3LzB4MTkKWyAgIDE1
Ljk5MjA5N10gICAgICAgIFs8ODExYzg0YjE+XSBzZXJpYWw4MjUwX3R4X2NoYXJzKzB4YmMv
MHhmYgpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTFjODYxOD5dIHNlcmlhbDgyNTBfaGFu
ZGxlX2lycSsweDU0LzB4NmEKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODExYzg2NDc+XSBz
ZXJpYWw4MjUwX2RlZmF1bHRfaGFuZGxlX2lycSsweDE5LzB4MWMKWyAgIDE1Ljk5MjA5N10g
ICAgICAgIFs8ODExYzdkYzg+XSBzZXJpYWw4MjUwX2ludGVycnVwdCsweDM4LzB4OWUKWyAg
IDE1Ljk5MjA5N10gICAgICAgIFs8ODEwNTE2OWE+XSBoYW5kbGVfaXJxX2V2ZW50X3BlcmNw
dSsweDVmLzB4MWUyClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMDUxODQ5Pl0gaGFuZGxl
X2lycV9ldmVudCsweDJjLzB4NDMKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEwNTMyZDA+
XSBoYW5kbGVfbGV2ZWxfaXJxKzB4NTcvMHg4MwpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4
MTAwMmFlYz5dIGhhbmRsZV9pcnErMHg0Ni8weDVjClsgICAxNS45OTIwOTddICAgICAgICBb
PDgxMDAyODU5Pl0gZG9fSVJRKzB4MzIvMHg4OQpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4
MTQzOWZhZT5dIGNvbW1vbl9pbnRlcnJ1cHQrMHgyZS8weDM0ClsgICAxNS45OTIwOTddICAg
ICAgICBbPDgxNDM5MjJjPl0gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4M2YvMHg0
OQpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTFjNGM5ND5dIHVhcnRfc3RhcnQrMHgyZC8w
eDMyClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMWM1MmY0Pl0gdWFydF93cml0ZSsweGM3
LzB4ZDYKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODExYmVkMjA+XSBuX3R0eV93cml0ZSsw
eGI4LzB4MzVlClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMWJjMjE1Pl0gdHR5X3dyaXRl
KzB4MTYzLzB4MWU0ClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMWJjMzAzPl0gcmVkaXJl
Y3RlZF90dHlfd3JpdGUrMHg2ZC8weDc1ClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMGI5
MTNjPl0gdmZzX3dyaXRlKzB4NzYvMHhjNQpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTBi
OTRlZD5dIFN5U193cml0ZSsweDQ0LzB4NzcKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODE0
MzlhMmU+XSBzeXNjYWxsX2NhbGwrMHg3LzB4YgpbICAgMTUuOTkyMDk3XSAKLT4gIzIgKCZ0
dHktPndyaXRlX3dhaXQpey0uLi4uLn06ClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMDRh
ZTBiPl0gbG9ja19hY3F1aXJlKzB4OTIvMHgxMDEKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8
ODE0MzkxMGQ+XSBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4MmUvMHgzZQpbICAgMTUuOTky
MDk3XSAgICAgICAgWzw4MTA0NjdlZT5dIF9fd2FrZV91cCsweDE1LzB4M2IKWyAgIDE1Ljk5
MjA5N10gICAgICAgIFs8ODExYmFkNWQ+XSB0dHlfd2FrZXVwKzB4NDkvMHg1MQpbICAgMTUu
OTkyMDk3XSAgICAgICAgWzw4MTFjNWM1OD5dIHVhcnRfd3JpdGVfd2FrZXVwKzB4MTcvMHgx
OQpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTFjODRiMT5dIHNlcmlhbDgyNTBfdHhfY2hh
cnMrMHhiYy8weGZiClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMWM4NjE4Pl0gc2VyaWFs
ODI1MF9oYW5kbGVfaXJxKzB4NTQvMHg2YQpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTFj
ODY0Nz5dIHNlcmlhbDgyNTBfZGVmYXVsdF9oYW5kbGVfaXJxKzB4MTkvMHgxYwpbICAgMTUu
OTkyMDk3XSAgICAgICAgWzw4MTFjN2RjOD5dIHNlcmlhbDgyNTBfaW50ZXJydXB0KzB4Mzgv
MHg5ZQpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTA1MTY5YT5dIGhhbmRsZV9pcnFfZXZl
bnRfcGVyY3B1KzB4NWYvMHgxZTIKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEwNTE4NDk+
XSBoYW5kbGVfaXJxX2V2ZW50KzB4MmMvMHg0MwpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4
MTA1MzJkMD5dIGhhbmRsZV9sZXZlbF9pcnErMHg1Ny8weDgzClsgICAxNS45OTIwOTddICAg
ICAgICBbPDgxMDAyYWVjPl0gaGFuZGxlX2lycSsweDQ2LzB4NWMKWyAgIDE1Ljk5MjA5N10g
ICAgICAgIFs8ODEwMDI4NTk+XSBkb19JUlErMHgzMi8weDg5ClsgICAxNS45OTIwOTddICAg
ICAgICBbPDgxNDM5ZmFlPl0gY29tbW9uX2ludGVycnVwdCsweDJlLzB4MzQKWyAgIDE1Ljk5
MjA5N10gICAgICAgIFs8ODE0MzkyMmM+XSBfcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUr
MHgzZi8weDQ5ClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMWM0Yzk0Pl0gdWFydF9zdGFy
dCsweDJkLzB4MzIKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODExYzUyZjQ+XSB1YXJ0X3dy
aXRlKzB4YzcvMHhkNgpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTFiZWQyMD5dIG5fdHR5
X3dyaXRlKzB4YjgvMHgzNWUKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODExYmMyMTU+XSB0
dHlfd3JpdGUrMHgxNjMvMHgxZTQKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODExYmMzMDM+
XSByZWRpcmVjdGVkX3R0eV93cml0ZSsweDZkLzB4NzUKWyAgIDE1Ljk5MjA5N10gICAgICAg
IFs8ODEwYjkxM2M+XSB2ZnNfd3JpdGUrMHg3Ni8weGM1ClsgICAxNS45OTIwOTddICAgICAg
ICBbPDgxMGI5NGVkPl0gU3lTX3dyaXRlKzB4NDQvMHg3NwpbICAgMTUuOTkyMDk3XSAgICAg
ICAgWzw4MTQzOWEyZT5dIHN5c2NhbGxfY2FsbCsweDcvMHhiClsgICAxNS45OTIwOTddIAot
PiAjMSAoJnBvcnRfbG9ja19rZXkpey0uLS4uLn06ClsgICAxNS45OTIwOTddICAgICAgICBb
PDgxMDRhZTBiPl0gbG9ja19hY3F1aXJlKzB4OTIvMHgxMDEKWyAgIDE1Ljk5MjA5N10gICAg
ICAgIFs8ODE0MzkxMGQ+XSBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4MmUvMHgzZQpbICAg
MTUuOTkyMDk3XSAgICAgICAgWzw4MTA0NzA5OT5dIGRvd25fdHJ5bG9jaysweGMvMHgyNwpb
ICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTA0ZjgwND5dIGNvbnNvbGVfdHJ5bG9jaysweDEy
LzB4ODAKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEwNTAyMGE+XSB2cHJpbnRrX2VtaXQr
MHg0MDQvMHg0MjEKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODE0MzAwMTg+XSBwcmludGsr
MHgxNy8weDE5ClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMDVjNTg4Pl0gY2xvY2tldmVu
dHNfcHJvZ3JhbV9taW5fZGVsdGErMHgxMDQvMHgxMTYKWyAgIDE1Ljk5MjA5N10gICAgICAg
IFs8ODEwNWNiMzA+XSBjbG9ja2V2ZW50c19wcm9ncmFtX2V2ZW50KzB4ZTcvMHhmMwpbICAg
MTUuOTkyMDk3XSAgICAgICAgWzw4MTA1ZDIwND5dIHRpY2tfcHJvZ3JhbV9ldmVudCsweDFl
LzB4MjMKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEwM2M4MjE+XSBocnRpbWVyX2ZvcmNl
X3JlcHJvZ3JhbSsweDg4LzB4OGYKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEwM2NjZDU+
XSByZXRyaWdnZXJfbmV4dF9ldmVudCsweDM2LzB4NDIKWyAgIDE1Ljk5MjA5N10gICAgICAg
IFs8ODEwM2Q0Yjg+XSBocnRpbWVyX3J1bl9wZW5kaW5nKzB4ZTQvMHgxMDgKWyAgIDE1Ljk5
MjA5N10gICAgICAgIFs8ODEwMmNiZjY+XSBydW5fdGltZXJfc29mdGlycSsweDE0LzB4MTlj
ClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMDI4NmMzPl0gX19kb19zb2Z0aXJxKzB4MTEx
LzB4MmM0ClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMDAyYWEwPl0gZG9fc29mdGlycV9v
d25fc3RhY2srMHgxYy8weDIyClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMDI4YTU3Pl0g
aXJxX2V4aXQrMHg0NC8weDVkClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMDAyODlkPl0g
ZG9fSVJRKzB4NzYvMHg4OQpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTQzOWZhZT5dIGNv
bW1vbl9pbnRlcnJ1cHQrMHgyZS8weDM0ClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMDQ5
MzUyPl0gZGVidWdfY2hlY2tfbm9fbG9ja3NfZnJlZWQrMHgxMGEvMHgxMWQKWyAgIDE1Ljk5
MjA5N10gICAgICAgIFs8ODEwNDc3NDY+XSBkZWJ1Z19tdXRleF9pbml0KzB4MTcvMHgzMQpb
ICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTA0NmZjMj5dIF9fbXV0ZXhfaW5pdCsweDNmLzB4
NDQKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEwYzkzYTY+XSBhZGRyZXNzX3NwYWNlX2lu
aXRfb25jZSsweDNkLzB4NzgKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEwYzk0MzQ+XSBp
bm9kZV9pbml0X29uY2UrMHg1My8weDYxClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMGM5
NDRhPl0gaW5pdF9vbmNlKzB4OC8weGEKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEwYjFj
ZWM+XSBfX19fY2FjaGVfYWxsb2MrMHgzYjYvMHg0MDkKWyAgIDE1Ljk5MjA5N10gICAgICAg
IFs8ODEwYjFmMmE+XSBrbWVtX2NhY2hlX2FsbG9jKzB4NTQvMHgxMjIKWyAgIDE1Ljk5MjA5
N10gICAgICAgIFs8ODEwYzk3YjA+XSBhbGxvY19pbm9kZSsweDI1LzB4NWYKWyAgIDE1Ljk5
MjA5N10gICAgICAgIFs8ODEwY2FhODQ+XSBuZXdfaW5vZGVfcHNldWRvKzB4YS8weDQwClsg
ICAxNS45OTIwOTddICAgICAgICBbPDgxMGNhYWNjPl0gbmV3X2lub2RlKzB4MTIvMHgyMgpb
ICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTBmNTJmZT5dIGRlYnVnZnNfbWtub2QucGFydC44
LmNvbnN0cHJvcC4xNysweDEzLzB4Y2EKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEwZjU1
N2Y+XSBfX2NyZWF0ZV9maWxlKzB4MTQ2LzB4MWFhClsgICAxNS45OTIwOTddICAgICAgICBb
PDgxMGY1NjA5Pl0gZGVidWdmc19jcmVhdGVfZmlsZSsweDI2LzB4MmIKWyAgIDE1Ljk5MjA5
N10gICAgICAgIFs8ODEwNzJhMmU+XSB0cmFjZV9jcmVhdGVfZmlsZSsweDE1LzB4MzMKWyAg
IDE1Ljk5MjA5N10gICAgICAgIFs8ODEwNzc3YTY+XSBldmVudF9jcmVhdGVfZGlyKzB4MmU3
LzB4MzZlClsgICAxNS45OTIwOTddICAgICAgICBbPDgxN2QzN2E3Pl0gZXZlbnRfdHJhY2Vf
aW5pdCsweDEyZC8weDE5MApbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTAwMDQ4Yj5dIGRv
X29uZV9pbml0Y2FsbCsweGU4LzB4MTY4ClsgICAxNS45OTIwOTddICAgICAgICBbPDgxN2My
YjFjPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhjYy8weDE0NApbICAgMTUuOTkyMDk3XSAg
ICAgICAgWzw4MTQyZDQzNz5dIGtlcm5lbF9pbml0KzB4OC8weGIzClsgICAxNS45OTIwOTdd
ICAgICAgICBbPDgxNDM5OGMwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAK
WyAgIDE1Ljk5MjA5N10gCi0+ICMwIChocnRpbWVyX2Jhc2VzLmxvY2spey0uLS4uLn06Clsg
ICAxNS45OTIwOTddICAgICAgICBbPDgxMDRhYWY2Pl0gX19sb2NrX2FjcXVpcmUrMHg5ZWEv
MHhjNmQKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEwNGFlMGI+XSBsb2NrX2FjcXVpcmUr
MHg5Mi8weDEwMQpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTQzOTEwZD5dIF9yYXdfc3Bp
bl9sb2NrX2lycXNhdmUrMHgyZS8weDNlClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMDNj
Y2ZkPl0gX19ocnRpbWVyX3N0YXJ0X3JhbmdlX25zKzB4MWMvMHgxOTcKWyAgIDE1Ljk5MjA5
N10gICAgICAgIFs8ODEwODA1N2E+XSBwZXJmX3N3ZXZlbnRfc3RhcnRfaHJ0aW1lci5wYXJ0
LjQxKzB4N2EvMHg4NQpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTA4MjBlYz5dIHRhc2tf
Y2xvY2tfZXZlbnRfc3RhcnQrMHgzYS8weDNmClsgICAxNS45OTIwOTddICAgICAgICBbPDgx
MDgyMGZlPl0gdGFza19jbG9ja19ldmVudF9hZGQrMHhkLzB4MTQKWyAgIDE1Ljk5MjA5N10g
ICAgICAgIFs8ODEwODNlZjQ+XSBldmVudF9zY2hlZF9pbisweGI2LzB4MTdhClsgICAxNS45
OTIwOTddICAgICAgICBbPDgxMDgzZmZjPl0gZ3JvdXBfc2NoZWRfaW4rMHg0NC8weDEyMgpb
ICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTA4NDE3Nz5dIGN0eF9zY2hlZF9pbi5pc3JhLjY3
KzB4OWQvMHgxMWYKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEwODQyMjA+XSBwZXJmX2V2
ZW50X3NjaGVkX2luLmlzcmEuNzArMHgyNy8weDRiClsgICAxNS45OTIwOTddICAgICAgICBb
PDgxMDg0NjQwPl0gX19wZXJmX2luc3RhbGxfaW5fY29udGV4dCsweDhiLzB4YTMKWyAgIDE1
Ljk5MjA5N10gICAgICAgIFs8ODEwODA0ZTg+XSByZW1vdGVfZnVuY3Rpb24rMHgxMi8weDJh
ClsgICAxNS45OTIwOTddICAgICAgICBbPDgxMDVmYzI0Pl0gc21wX2NhbGxfZnVuY3Rpb25f
c2luZ2xlKzB4MmQvMHg1MwpbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTA3ZmFkNz5dIHRh
c2tfZnVuY3Rpb25fY2FsbCsweDMwLzB4MzYKWyAgIDE1Ljk5MjA5N10gICAgICAgIFs8ODEw
ODE0ZGM+XSBwZXJmX2luc3RhbGxfaW5fY29udGV4dCsweDg3LzB4YmIKWyAgIDE1Ljk5MjA5
N10gICAgICAgIFs8ODEwODZjNzY+XSBTWVNDX3BlcmZfZXZlbnRfb3BlbisweDVmNi8weDcz
OApbICAgMTUuOTkyMDk3XSAgICAgICAgWzw4MTA4NzBhZD5dIFN5U19wZXJmX2V2ZW50X29w
ZW4rMHgxNy8weDE5ClsgICAxNS45OTIwOTddICAgICAgICBbPDgxNDM5YTJlPl0gc3lzY2Fs
bF9jYWxsKzB4Ny8weGIKWyAgIDE1Ljk5MjA5N10gClsgICAxNS45OTIwOTddIG90aGVyIGlu
Zm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6ClsgICAxNS45OTIwOTddIApbICAg
MTUuOTkyMDk3XSBDaGFpbiBleGlzdHMgb2Y6CiAgaHJ0aW1lcl9iYXNlcy5sb2NrIC0tPiAm
cnEtPmxvY2sgLS0+ICZjdHgtPmxvY2sKClsgICAxNS45OTIwOTddICBQb3NzaWJsZSB1bnNh
ZmUgbG9ja2luZyBzY2VuYXJpbzoKWyAgIDE1Ljk5MjA5N10gClsgICAxNS45OTIwOTddICAg
ICAgICBDUFUwICAgICAgICAgICAgICAgICAgICBDUFUxClsgICAxNS45OTIwOTddICAgICAg
ICAtLS0tICAgICAgICAgICAgICAgICAgICAtLS0tClsgICAxNS45OTIwOTddICAgbG9jaygm
Y3R4LT5sb2NrKTsKWyAgIDE1Ljk5MjA5N10gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGxvY2soJnJxLT5sb2NrKTsKWyAgIDE1Ljk5MjA5N10gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGxvY2soJmN0eC0+bG9jayk7ClsgICAxNS45OTIwOTddICAgbG9jayho
cnRpbWVyX2Jhc2VzLmxvY2spOwpbICAgMTUuOTkyMDk3XSAKWyAgIDE1Ljk5MjA5N10gICoq
KiBERUFETE9DSyAqKioKWyAgIDE1Ljk5MjA5N10gClsgICAxNS45OTIwOTddIDMgbG9ja3Mg
aGVsZCBieSB0cmluaXR5LW1haW4vNzQ6ClsgICAxNS45OTIwOTddICAjMDogICgmY3R4LT5t
dXRleCl7Ky4rLi4ufSwgYXQ6IFs8ODEwODZjNTg+XSBTWVNDX3BlcmZfZXZlbnRfb3Blbisw
eDVkOC8weDczOApbICAgMTUuOTkyMDk3XSAgIzE6ICAoJmNwdWN0eF9sb2NrKXsuLi4uLi59
LCBhdDogWzw4MTA3Zjk5Nz5dIHBlcmZfY3R4X2xvY2srMHhlLzB4MWQKWyAgIDE1Ljk5MjA5
N10gICMyOiAgKCZjdHgtPmxvY2spey4uLi4uLn0sIGF0OiBbPDgxMDdmOWEzPl0gcGVyZl9j
dHhfbG9jaysweDFhLzB4MWQKWyAgIDE1Ljk5MjA5N10gClsgICAxNS45OTIwOTddIHN0YWNr
IGJhY2t0cmFjZToKWyAgIDE1Ljk5MjA5N10gQ1BVOiAwIFBJRDogNzQgQ29tbTogdHJpbml0
eS1tYWluIE5vdCB0YWludGVkIDMuMTYuMC1yYzEtMDAwODItZzlmNjIyNmEgIzEKWyAgIDE1
Ljk5MjA5N10gIDAwMDAwMDAwIDgxYzU5NDg4IDhiOWEzY2MwIDgxNDMwZjhlIDhiOWEzY2Yw
IDgxNDJmYjNiIDgxNjMwMGRmIDgxNjJmZmRlClsgICAxNS45OTIwOTddICA4MTYyZmZhNiA4
MTYyZmZjNyA4MTYyZmZhNiA4YjlhM2QyNCA4YjE1MTRkMCAwMDAwMDAwMyA4YjE1MThlNCA4
YjE1MTRkMApbICAgMTUuOTkyMDk3XSAgOGI5YTNkNTQgODEwNGFhZjYgOGIxNTE4Y2MgMDAw
MDE2ODEgMDAwMDAwMDIgMDAwMDAwMDAgODFjNmFlMTggMDAwMDAwMDMKWyAgIDE1Ljk5MjA5
N10gQ2FsbCBUcmFjZToKWyAgIDE1Ljk5MjA5N10gIFs8ODE0MzBmOGU+XSBkdW1wX3N0YWNr
KzB4MTYvMHgxOApbICAgMTUuOTkyMDk3XSAgWzw4MTQyZmIzYj5dIHByaW50X2NpcmN1bGFy
X2J1ZysweDE4Zi8weDE5YwpbICAgMTUuOTkyMDk3XSAgWzw4MTA0YWFmNj5dIF9fbG9ja19h
Y3F1aXJlKzB4OWVhLzB4YzZkClsgICAxNS45OTIwOTddICBbPDgxMDg3OTg4Pl0gPyBwZXJm
X291dHB1dF9iZWdpbisweDI0OC8weDI1NQpbICAgMTUuOTkyMDk3XSAgWzw4MTA0YWUwYj5d
IGxvY2tfYWNxdWlyZSsweDkyLzB4MTAxClsgICAxNS45OTIwOTddICBbPDgxMDNjY2ZkPl0g
PyBfX2hydGltZXJfc3RhcnRfcmFuZ2VfbnMrMHgxYy8weDE5NwpbICAgMTUuOTkyMDk3XSAg
Wzw4MTQzOTEwZD5dIF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHgyZS8weDNlClsgICAxNS45
OTIwOTddICBbPDgxMDNjY2ZkPl0gPyBfX2hydGltZXJfc3RhcnRfcmFuZ2VfbnMrMHgxYy8w
eDE5NwpbICAgMTUuOTkyMDk3XSAgWzw4MTAzY2NmZD5dIF9faHJ0aW1lcl9zdGFydF9yYW5n
ZV9ucysweDFjLzB4MTk3ClsgICAxNS45OTIwOTddICBbPDgxMDgwNTdhPl0gcGVyZl9zd2V2
ZW50X3N0YXJ0X2hydGltZXIucGFydC40MSsweDdhLzB4ODUKWyAgIDE1Ljk5MjA5N10gIFs8
ODEwODIwZWM+XSB0YXNrX2Nsb2NrX2V2ZW50X3N0YXJ0KzB4M2EvMHgzZgpbICAgMTUuOTky
MDk3XSAgWzw4MTA4MjBmZT5dIHRhc2tfY2xvY2tfZXZlbnRfYWRkKzB4ZC8weDE0ClsgICAx
NS45OTIwOTddICBbPDgxMDgzZWY0Pl0gZXZlbnRfc2NoZWRfaW4rMHhiNi8weDE3YQpbICAg
MTUuOTkyMDk3XSAgWzw4MTA4M2ZmYz5dIGdyb3VwX3NjaGVkX2luKzB4NDQvMHgxMjIKWyAg
IDE1Ljk5MjA5N10gIFs8ODEwODQxNzc+XSBjdHhfc2NoZWRfaW4uaXNyYS42NysweDlkLzB4
MTFmClsgICAxNS45OTIwOTddICBbPDgxMDg0MjIwPl0gcGVyZl9ldmVudF9zY2hlZF9pbi5p
c3JhLjcwKzB4MjcvMHg0YgpbICAgMTUuOTkyMDk3XSAgWzw4MTA4NDY0MD5dIF9fcGVyZl9p
bnN0YWxsX2luX2NvbnRleHQrMHg4Yi8weGEzClsgICAxNS45OTIwOTddICBbPDgxMDgwNGQ2
Pl0gPyBwZXJmX21tYXBfZmF1bHQrMHhlMi8weGUyClsgICAxNS45OTIwOTddICBbPDgxMDgw
NGU4Pl0gcmVtb3RlX2Z1bmN0aW9uKzB4MTIvMHgyYQpbICAgMTUuOTkyMDk3XSAgWzw4MTA1
ZmMyND5dIHNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZSsweDJkLzB4NTMKWyAgIDE1Ljk5MjA5
N10gIFs8ODEwN2ZhZDc+XSB0YXNrX2Z1bmN0aW9uX2NhbGwrMHgzMC8weDM2Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLzlmNjIyNmE3NjJjN2FlMDJmNmEyM2EzZDRmYzU1
MmRhZmE1N2VhMjMvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjA6MjAxNDA3MzEyMzQwNTM6aTM4
Ni1yYW5kY29uZmlnLWhhMi0wNzMxOjMuMTYuMC1yYzEtMDAwODItZzlmNjIyNmE6MQoyNzox
OjQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDctMzEgMjM6NDM6
MTIgUkVQRUFUIENPVU5UOiAzMDAgICMgL2MvYm9vdC1iaXNlY3QvbGludXgtMi9vYmotYmlz
ZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgOWY2MjI2YTc2MmM3YWUwMmY2
YTIzYTNkNGZjNTUyZGFmYTU3ZWEyMwpnaXQgY2hlY2tvdXQgdjMuMTUKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS9rdm1hcm06
bmV4dDoxODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkOmJpc2VjdC1s
aW51eC0yCgoyMDE0LTA3LTMxLTIzOjUxOjUwIDE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThh
ZWRkZmZlNWFmZDlkMGQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLTE4NjBlMzc5ODc1
ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4
YWVkZGZmZTVhZmQ5ZDBkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEtMTg2MGUzNzk4NzVkZmU3
MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAxLWNvbnN1bWVyL2kzODYtcmFuZGNv
bmZpZy1oYTItMDczMS0xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBk
Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvMTg2MGUzNzk4NzVk
ZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZC92bWxpbnV6LTMuMTUuMAoKMjAxNC0wNy0z
MS0yMzo1NTo1MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkxCTUJNi4uCTcJMTEJMTUJMTgu
CTIxCTIzCTI1CTI4CTMyCTM1CTM2CTM5CTQzCTQ1Li4JNTAJNTIJNTgJNjQJNzAJNzQJNzgJ
OTEJMTAzCTExMgkxMjcJMTM4CTE0MwkxNTgJMTczCTE4NwkxOTkJMjE4CTIyNAkyNDYJMjYy
CTI3MAkyOTUJMzAwIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgdjMuMTUKZ2l0IGJp
c2VjdCBzdGFydCA5ZjYyMjZhNzYyYzdhZTAyZjZhMjNhM2Q0ZmM1NTJkYWZhNTdlYTIzIHYz
LjE1IC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgIjlmNjIyNmE3
NjJjN2FlMDJmNmEyM2EzZDRmYzU1MmRhZmE1N2VhMjMiLCAiLWciLCAidjMuMTUiLCAiL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIvYy9ib290LWJp
c2VjdC9saW51eC0yL29iai1iaXNlY3QiXQpCaXNlY3Rpbmc6IDEyMTE4IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxNCBzdGVwcykKWzcxOTk4ZDFiZTRh
ZTcwZTdkMzIwY2RkMjE1OTVjMWEwMmEyOWM2MWVdIE1lcmdlIGJyYW5jaCAneDg2LWlycS1m
b3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC90aXAvdGlwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0yL29iai1iaXNlY3QKbHMgLWEgL2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS9rdm1h
cm06bmV4dDo3MTk5OGQxYmU0YWU3MGU3ZDMyMGNkZDIxNTk1YzFhMDJhMjljNjFlOmJpc2Vj
dC1saW51eC0yCgoyMDE0LTA4LTAxLTAwOjE5OjU5IDcxOTk4ZDFiZTRhZTcwZTdkMzIwY2Rk
MjE1OTVjMWEwMmEyOWM2MWUgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLTcxOTk4ZDFi
ZTRhZTcwZTdkMzIwY2RkMjE1OTVjMWEwMmEyOWM2MWUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS83MTk5OGQxYmU0YWU3MGU3ZDMyMGNk
ZDIxNTk1YzFhMDJhMjljNjFlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEtNzE5OThkMWJlNGFl
NzBlN2QzMjBjZGQyMTU5NWMxYTAyYTI5YzYxZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAxLWkzODYvaTM4Ni1yYW5kY29u
ZmlnLWhhMi0wNzMxLTcxOTk4ZDFiZTRhZTcwZTdkMzIwY2RkMjE1OTVjMWEwMmEyOWM2MWUK
a2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS83MTk5OGQxYmU0YWU3
MGU3ZDMyMGNkZDIxNTk1YzFhMDJhMjljNjFlL3ZtbGludXotMy4xNS4wLTExNzM4LWc3MTk5
OGQxCgoyMDE0LTA4LTAxLTAxOjA1OjU5IGRldGVjdGluZyBib290IHN0YXRlIC4JMwkxMgkx
OAkyMgkyOQkzMwk0MAk0NAk1MQk1Mwk2MAk2Mwk3Mgk3OSBURVNUIEZBSUxVUkUKWyAgICAy
LjYzMjI1M10gdHNjOiBSZWZpbmVkIFRTQyBjbG9ja3NvdXJjZSBjYWxpYnJhdGlvbjogMjY5
My41MDQgTUh6ClsgICAxMi43NjExNzldIHNvY2s6IHByb2Nlc3MgYHRyaW5pdHktbWFpbicg
aXMgdXNpbmcgb2Jzb2xldGUgc2V0c29ja29wdCBTT19CU0RDT01QQVQKCkJVRzoga2VybmVs
IGJvb3QgaGFuZwpFbGFwc2VkIHRpbWU6IDM1CnFlbXUtc3lzdGVtLXg4Nl82NCAtZW5hYmxl
LWt2bSAtY3B1IEhhc3dlbGwsK3NtZXAsK3NtYXAgLWtlcm5lbCAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1oYTItMDczMS83MTk5OGQxYmU0YWU3MGU3ZDMyMGNkZDIxNTk1YzFhMDJhMjlj
NjFlL3ZtbGludXotMy4xNS4wLTExNzM4LWc3MTk5OGQxIC1hcHBlbmQgJ2h1bmdfdGFza19w
YW5pYz0xIGVhcmx5cHJpbnRrPXR0eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3Jx
X2Fsd2F5c19lbmFibGVkIHJjdXBkYXRlLnJjdV9jcHVfc3RhbGxfdGltZW91dD0xMDAgcGFu
aWM9MTAgc29mdGxvY2t1cF9wYW5pYz0xIG5taV93YXRjaGRvZz1wYW5pYyAgcHJvbXB0X3Jh
bWRpc2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAg
cm9vdD0vZGV2L3JhbTAgcncgbGluaz0va2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLWhhMi0wNzMxL2t2bWFybTpuZXh0OjcxOTk4ZDFiZTRhZTcwZTdkMzIw
Y2RkMjE1OTVjMWEwMmEyOWM2MWU6YmlzZWN0LWxpbnV4LTIvLnZtbGludXotNzE5OThkMWJl
NGFlNzBlN2QzMjBjZGQyMTU5NWMxYTAyYTI5YzYxZS0yMDE0MDgwMTA5MDYwMi0xMTgta2J1
aWxkIGJyYW5jaD1rdm1hcm0vbmV4dCBCT09UX0lNQUdFPS9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWhhMi0wNzMxLzcxOTk4ZDFiZTRhZTcwZTdkMzIwY2RkMjE1OTVjMWEwMmEyOWM2MWUv
dm1saW51ei0zLjE1LjAtMTE3MzgtZzcxOTk4ZDEgZHJiZC5taW5vcl9jb3VudD04JyAgLWlu
aXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNvcmUtaTM4Ni5jZ3ogLW0gMzIw
IC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSAt
Ym9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRjIGJhc2U9
bG9jYWx0aW1lIC1waWRmaWxlIC9kZXYvc2htL2tib290L3BpZC1xdWFudGFsLWtidWlsZC0x
NyAtc2VyaWFsIGZpbGU6L2Rldi9zaG0va2Jvb3Qvc2VyaWFsLXF1YW50YWwta2J1aWxkLTE3
IC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRvciBudWxsIAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1oYTItMDczMS83MTk5OGQxYmU0YWU3MGU3ZDMyMGNkZDIxNTk1YzFhMDJh
MjljNjFlL2RtZXNnLXlvY3RvLWtidWlsZC0zOjIwMTQwODAxMDExMTAzOmkzODYtcmFuZGNv
bmZpZy1oYTItMDczMTozLjE1LjAtMTE3MzgtZzcxOTk4ZDE6MQo3NToxOjUgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDgtMDEgMDE6MTM6MjkgUkVQRUFUIENP
VU5UOiAzMDAgICMgL2MvYm9vdC1iaXNlY3QvbGludXgtMi9vYmotYmlzZWN0Ly5yZXBlYXQb
WzBtCgpCaXNlY3Rpbmc6IDExNzM4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxNCBzdGVwcykKWzllZTRkN2E2NTM4MzA4YTc2ODFiNjM4ZDJmMzVmMmEz
MDE0MjAzNTVdIE1lcmdlIGJyYW5jaCAnYWtwbScgKHBhdGNoZXMgZnJvbSBBbmRyZXcgTW9y
dG9uKQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEva3ZtYXJtOm5leHQ6
OWVlNGQ3YTY1MzgzMDhhNzY4MWI2MzhkMmYzNWYyYTMwMTQyMDM1NTpiaXNlY3QtbGludXgt
MgoKMjAxNC0wOC0wMS0wMToxMzozMSA5ZWU0ZDdhNjUzODMwOGE3NjgxYjYzOGQyZjM1ZjJh
MzAxNDIwMzU1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS05ZWU0ZDdhNjUzODMwOGE3
NjgxYjYzOGQyZjM1ZjJhMzAxNDIwMzU1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaGEyLTA3MzEvOWVlNGQ3YTY1MzgzMDhhNzY4MWI2MzhkMmYzNWYy
YTMwMTQyMDM1NQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLTllZTRkN2E2NTM4MzA4YTc2ODFi
NjM4ZDJmMzVmMmEzMDE0MjAzNTUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1pMzg2L2kzODYtcmFuZGNvbmZpZy1oYTIt
MDczMS05ZWU0ZDdhNjUzODMwOGE3NjgxYjYzOGQyZjM1ZjJhMzAxNDIwMzU1Cmtlcm5lbDog
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvOWVlNGQ3YTY1MzgzMDhhNzY4MWI2
MzhkMmYzNWYyYTMwMTQyMDM1NS92bWxpbnV6LTMuMTUuMC0wODM1MS1nOWVlNGQ3YQoKMjAx
NC0wOC0wMS0wMToyMTozMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMQkzIFRFU1QgRkFJ
TFVSRQpbICAgMTEuNzYxMTg3XSBzb2NrOiBwcm9jZXNzIGB0cmluaXR5LW1haW4nIGlzIHVz
aW5nIG9ic29sZXRlIHNldHNvY2tvcHQgU09fQlNEQ09NUEFUClsgICAxMi42NjEzOTddIApb
ICAgMTIuNjYxNTYwXSA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT0KWyAgIDEyLjY2MjA5NF0gWyBJTkZPOiBwb3NzaWJsZSBjaXJjdWxh
ciBsb2NraW5nIGRlcGVuZGVuY3kgZGV0ZWN0ZWQgXQpbICAgMTIuNjYyNjI2XSAzLjE1LjAt
MDgzNTEtZzllZTRkN2EgIzIgTm90IHRhaW50ZWQKWyAgIDEyLjY2MzAyNl0gLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpbICAgMTIu
NjYzNTU3XSB0cmluaXR5LW1haW4vNzQgaXMgdHJ5aW5nIHRvIGFjcXVpcmUgbG9jazoKWyAg
IDEyLjY2NDAwMV0gIChocnRpbWVyX2Jhc2VzLmxvY2spey0uLS4uLn0sIGF0OiBbPDgxMDNj
ZTU5Pl0gX19ocnRpbWVyX3N0YXJ0X3JhbmdlX25zKzB4MWMvMHgxOTcKWyAgIDEyLjY2NDA0
MV0gClsgICAxMi42NjQwNDFdIGJ1dCB0YXNrIGlzIGFscmVhZHkgaG9sZGluZyBsb2NrOgpb
ICAgMTIuNjY0MDQxXSAgKCZjdHgtPmxvY2spey4uLi4uLn0sIGF0OiBbPDgxMDdmNjc5Pl0g
cGVyZl9jdHhfbG9jaysweDFhLzB4MWQKWyAgIDEyLjY2NDA0MV0gClsgICAxMi42NjQwNDFd
IHdoaWNoIGxvY2sgYWxyZWFkeSBkZXBlbmRzIG9uIHRoZSBuZXcgbG9jay4KWyAgIDEyLjY2
NDA0MV0gClsgICAxMi42NjQwNDFdIApbICAgMTIuNjY0MDQxXSB0aGUgZXhpc3RpbmcgZGVw
ZW5kZW5jeSBjaGFpbiAoaW4gcmV2ZXJzZSBvcmRlcikgaXM6ClsgICAxMi42NjQwNDFdIAot
PiAjNSAoJmN0eC0+bG9jayl7Li4uLi4ufToKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEw
NGFlODE+XSBsb2NrX2FjcXVpcmUrMHg5Mi8weDEwMQpbICAgMTIuNjY0MDQxXSAgICAgICAg
Wzw4MTQzMzE1Yz5dIF9yYXdfc3Bpbl9sb2NrKzB4MjEvMHgzMApbICAgMTIuNjY0MDQxXSAg
ICAgICAgWzw4MTA4MzQyMz5dIF9fcGVyZl9ldmVudF90YXNrX3NjaGVkX291dCsweDFkYy8w
eDM0ZgpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTQzMGJkYz5dIF9fc2NoZWR1bGUrMHg0
YzYvMHg0Y2IKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODE0MzBiZjA+XSBzY2hlZHVsZSsw
eGYvMHgxMQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTQzM2E1Nj5dIHdvcmtfcmVzY2hl
ZCsweDUvMHgyYwpbICAgMTIuNjY0MDQxXSAKLT4gIzQgKCZycS0+bG9jayl7LS4tLi0ufToK
WyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwNGFlODE+XSBsb2NrX2FjcXVpcmUrMHg5Mi8w
eDEwMQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTQzMzE1Yz5dIF9yYXdfc3Bpbl9sb2Nr
KzB4MjEvMHgzMApbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTA0MGRiND5dIF9fdGFza19y
cV9sb2NrKzB4MzMvMHgzYQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTA0MWQ4ZD5dIHdh
a2VfdXBfbmV3X3Rhc2srMHgyNS8weGMyClsgICAxMi42NjQwNDFdICAgICAgICBbPDgxMDI0
ZWFlPl0gZG9fZm9yaysweDE1NC8weDI2NQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTAy
NGZkOT5dIGtlcm5lbF90aHJlYWQrMHgxYS8weDFmClsgICAxMi42NjQwNDFdICAgICAgICBb
PDgxNDI3M2M3Pl0gcmVzdF9pbml0KzB4MWEvMHgxMGUKWyAgIDEyLjY2NDA0MV0gICAgICAg
IFs8ODE3YjY5ZTI+XSBzdGFydF9rZXJuZWwrMHgzMDMvMHgzMDgKWyAgIDEyLjY2NDA0MV0g
ICAgICAgIFs8ODE3YjYyYWI+XSBpMzg2X3N0YXJ0X2tlcm5lbCsweDc5LzB4N2QKWyAgIDEy
LjY2NDA0MV0gCi0+ICMzICgmcC0+cGlfbG9jayl7LS4tLi4ufToKWyAgIDEyLjY2NDA0MV0g
ICAgICAgIFs8ODEwNGFlODE+XSBsb2NrX2FjcXVpcmUrMHg5Mi8weDEwMQpbICAgMTIuNjY0
MDQxXSAgICAgICAgWzw4MTQzMzIyZD5dIF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHgyZS8w
eDNlClsgICAxMi42NjQwNDFdICAgICAgICBbPDgxMDQxOTFlPl0gdHJ5X3RvX3dha2VfdXAr
MHgxZC8weGQ2ClsgICAxMi42NjQwNDFdICAgICAgICBbPDgxMDQxYTBlPl0gZGVmYXVsdF93
YWtlX2Z1bmN0aW9uKzB4Yi8weGQKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwNDY3MzI+
XSBfX3dha2VfdXBfY29tbW9uKzB4MzkvMHg1OQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4
MTA0Njg4NT5dIF9fd2FrZV91cCsweDI5LzB4M2IKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8
ODExYjlmM2Y+XSB0dHlfd2FrZXVwKzB4NDkvMHg1MQpbICAgMTIuNjY0MDQxXSAgICAgICAg
Wzw4MTFjNGUzYT5dIHVhcnRfd3JpdGVfd2FrZXVwKzB4MTcvMHgxOQpbICAgMTIuNjY0MDQx
XSAgICAgICAgWzw4MTFjNzY5Mz5dIHNlcmlhbDgyNTBfdHhfY2hhcnMrMHhiYy8weGZiClsg
ICAxMi42NjQwNDFdICAgICAgICBbPDgxMWM3N2ZhPl0gc2VyaWFsODI1MF9oYW5kbGVfaXJx
KzB4NTQvMHg2YQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTFjNzgyOT5dIHNlcmlhbDgy
NTBfZGVmYXVsdF9oYW5kbGVfaXJxKzB4MTkvMHgxYwpbICAgMTIuNjY0MDQxXSAgICAgICAg
Wzw4MTFjNmZhYT5dIHNlcmlhbDgyNTBfaW50ZXJydXB0KzB4MzgvMHg5ZQpbICAgMTIuNjY0
MDQxXSAgICAgICAgWzw4MTA1MTU5OT5dIGhhbmRsZV9pcnFfZXZlbnRfcGVyY3B1KzB4NWYv
MHgxZTIKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwNTE3NDg+XSBoYW5kbGVfaXJxX2V2
ZW50KzB4MmMvMHg0MwpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTA1MzFjZj5dIGhhbmRs
ZV9sZXZlbF9pcnErMHg1Ny8weDgzClsgICAxMi42NjQwNDFdICAgICAgICBbPDgxMDAyY2Nl
Pl0gaGFuZGxlX2lycSsweDQ2LzB4NWMKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwMDJh
M2I+XSBkb19JUlErMHgzMi8weDg5ClsgICAxMi42NjQwNDFdICAgICAgICBbPDgxNDM0MzZl
Pl0gY29tbW9uX2ludGVycnVwdCsweDJlLzB4MzMKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8
ODE0MzMzNGM+XSBfcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUrMHgzZi8weDQ5ClsgICAx
Mi42NjQwNDFdICAgICAgICBbPDgxMWMzZTc2Pl0gdWFydF9zdGFydCsweDJkLzB4MzIKWyAg
IDEyLjY2NDA0MV0gICAgICAgIFs8ODExYzQ0ZDY+XSB1YXJ0X3dyaXRlKzB4YzcvMHhkNgpb
ICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTFiZGYwMj5dIG5fdHR5X3dyaXRlKzB4YjgvMHgz
NWUKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODExYmIzZjc+XSB0dHlfd3JpdGUrMHgxNjMv
MHgxZTQKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODExYmI0ZTU+XSByZWRpcmVjdGVkX3R0
eV93cml0ZSsweDZkLzB4NzUKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwYjg1YTM+XSB2
ZnNfd3JpdGUrMHg3NS8weGIwClsgICAxMi42NjQwNDFdICAgICAgICBbPDgxMGI4OTMyPl0g
U3lTX3dyaXRlKzB4NDQvMHg3NwpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTQzMzlmZT5d
IHN5c2NhbGxfY2FsbCsweDcvMHhiClsgICAxMi42NjQwNDFdIAotPiAjMiAoJnR0eS0+d3Jp
dGVfd2FpdCl7LS4uLi4ufToKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwNGFlODE+XSBs
b2NrX2FjcXVpcmUrMHg5Mi8weDEwMQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTQzMzIy
ZD5dIF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHgyZS8weDNlClsgICAxMi42NjQwNDFdICAg
ICAgICBbPDgxMDQ2ODcxPl0gX193YWtlX3VwKzB4MTUvMHgzYgpbICAgMTIuNjY0MDQxXSAg
ICAgICAgWzw4MTFiOWYzZj5dIHR0eV93YWtldXArMHg0OS8weDUxClsgICAxMi42NjQwNDFd
ICAgICAgICBbPDgxMWM0ZTNhPl0gdWFydF93cml0ZV93YWtldXArMHgxNy8weDE5ClsgICAx
Mi42NjQwNDFdICAgICAgICBbPDgxMWM3NjkzPl0gc2VyaWFsODI1MF90eF9jaGFycysweGJj
LzB4ZmIKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODExYzc3ZmE+XSBzZXJpYWw4MjUwX2hh
bmRsZV9pcnErMHg1NC8weDZhClsgICAxMi42NjQwNDFdICAgICAgICBbPDgxMWM3ODI5Pl0g
c2VyaWFsODI1MF9kZWZhdWx0X2hhbmRsZV9pcnErMHgxOS8weDFjClsgICAxMi42NjQwNDFd
ICAgICAgICBbPDgxMWM2ZmFhPl0gc2VyaWFsODI1MF9pbnRlcnJ1cHQrMHgzOC8weDllClsg
ICAxMi42NjQwNDFdICAgICAgICBbPDgxMDUxNTk5Pl0gaGFuZGxlX2lycV9ldmVudF9wZXJj
cHUrMHg1Zi8weDFlMgpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTA1MTc0OD5dIGhhbmRs
ZV9pcnFfZXZlbnQrMHgyYy8weDQzClsgICAxMi42NjQwNDFdICAgICAgICBbPDgxMDUzMWNm
Pl0gaGFuZGxlX2xldmVsX2lycSsweDU3LzB4ODMKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8
ODEwMDJjY2U+XSBoYW5kbGVfaXJxKzB4NDYvMHg1YwpbICAgMTIuNjY0MDQxXSAgICAgICAg
Wzw4MTAwMmEzYj5dIGRvX0lSUSsweDMyLzB4ODkKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8
ODE0MzQzNmU+XSBjb21tb25faW50ZXJydXB0KzB4MmUvMHgzMwpbICAgMTIuNjY0MDQxXSAg
ICAgICAgWzw4MTQzMzM0Yz5dIF9yYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSsweDNmLzB4
NDkKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODExYzNlNzY+XSB1YXJ0X3N0YXJ0KzB4MmQv
MHgzMgpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTFjNDRkNj5dIHVhcnRfd3JpdGUrMHhj
Ny8weGQ2ClsgICAxMi42NjQwNDFdICAgICAgICBbPDgxMWJkZjAyPl0gbl90dHlfd3JpdGUr
MHhiOC8weDM1ZQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTFiYjNmNz5dIHR0eV93cml0
ZSsweDE2My8weDFlNApbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTFiYjRlNT5dIHJlZGly
ZWN0ZWRfdHR5X3dyaXRlKzB4NmQvMHg3NQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTBi
ODVhMz5dIHZmc193cml0ZSsweDc1LzB4YjAKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEw
Yjg5MzI+XSBTeVNfd3JpdGUrMHg0NC8weDc3ClsgICAxMi42NjQwNDFdICAgICAgICBbPDgx
NDMzOWZlPl0gc3lzY2FsbF9jYWxsKzB4Ny8weGIKWyAgIDEyLjY2NDA0MV0gCi0+ICMxICgm
cG9ydF9sb2NrX2tleSl7LS4tLi4ufToKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwNGFl
ODE+XSBsb2NrX2FjcXVpcmUrMHg5Mi8weDEwMQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4
MTQzMzIyZD5dIF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHgyZS8weDNlClsgICAxMi42NjQw
NDFdICAgICAgICBbPDgxMDQ3MTBmPl0gZG93bl90cnlsb2NrKzB4Yy8weDI3ClsgICAxMi42
NjQwNDFdICAgICAgICBbPDgxMDRmNzAzPl0gY29uc29sZV90cnlsb2NrKzB4MTIvMHg4MApb
ICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTA1MDEwOT5dIHZwcmludGtfZW1pdCsweDQwNC8w
eDQyMQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTQyYTBhYj5dIHByaW50aysweDE3LzB4
MTkKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwNWM0ODc+XSBjbG9ja2V2ZW50c19wcm9n
cmFtX21pbl9kZWx0YSsweDEwNC8weDExNgpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTA1
Y2EyZj5dIGNsb2NrZXZlbnRzX3Byb2dyYW1fZXZlbnQrMHhlNy8weGYzClsgICAxMi42NjQw
NDFdICAgICAgICBbPDgxMDVkMTAzPl0gdGlja19wcm9ncmFtX2V2ZW50KzB4MWUvMHgyMwpb
ICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTAzYzk3ZD5dIGhydGltZXJfZm9yY2VfcmVwcm9n
cmFtKzB4ODgvMHg4ZgpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTAzY2UzMT5dIHJldHJp
Z2dlcl9uZXh0X2V2ZW50KzB4MzYvMHg0MgpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTAz
ZDYxND5dIGhydGltZXJfcnVuX3BlbmRpbmcrMHhlNC8weDEwOApbICAgMTIuNjY0MDQxXSAg
ICAgICAgWzw4MTAyY2Q4ZT5dIHJ1bl90aW1lcl9zb2Z0aXJxKzB4MTQvMHgxOWMKWyAgIDEy
LjY2NDA0MV0gICAgICAgIFs8ODEwMjg4NWI+XSBfX2RvX3NvZnRpcnErMHgxMTEvMHgyYzQK
WyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwMDJjODI+XSBkb19zb2Z0aXJxX293bl9zdGFj
aysweDFjLzB4MjIKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwMjhiZWY+XSBpcnFfZXhp
dCsweDQ0LzB4NWQKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwMDJhN2Y+XSBkb19JUlEr
MHg3Ni8weDg5ClsgICAxMi42NjQwNDFdICAgICAgICBbPDgxNDM0MzZlPl0gY29tbW9uX2lu
dGVycnVwdCsweDJlLzB4MzMKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwYmU4OTc+XSBf
X2xvb2t1cF9oYXNoKzB4MmEvMHgzMQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTBjMDcy
Mj5dIGxvb2t1cF9vbmVfbGVuKzB4YWYvMHhiZQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4
MTBmNGI5Nj5dIF9fY3JlYXRlX2ZpbGUrMHg5NC8weDFhYQpbICAgMTIuNjY0MDQxXSAgICAg
ICAgWzw4MTBmNGNkMj5dIGRlYnVnZnNfY3JlYXRlX2ZpbGUrMHgyNi8weDJiClsgICAxMi42
NjQwNDFdICAgICAgICBbPDgxMDcyOTE5Pl0gdHJhY2VfY3JlYXRlX2ZpbGUrMHgxNS8weDMz
ClsgICAxMi42NjQwNDFdICAgICAgICBbPDgxMDc3NmZjPl0gZXZlbnRfY3JlYXRlX2Rpcisw
eDM1YS8weDM2ZQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTdjNzZjYT5dIGV2ZW50X3Ry
YWNlX2luaXQrMHgxMmQvMHgxOTAKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwMDA0OGI+
XSBkb19vbmVfaW5pdGNhbGwrMHhlOC8weDE2OApbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4
MTdiNmFiMz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4Y2MvMHgxNDQKWyAgIDEyLjY2NDA0
MV0gICAgICAgIFs8ODE0Mjc0YzM+XSBrZXJuZWxfaW5pdCsweDgvMHhiMwpbICAgMTIuNjY0
MDQxXSAgICAgICAgWzw4MTQzM2U0MD5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMC8w
eDMwClsgICAxMi42NjQwNDFdIAotPiAjMCAoaHJ0aW1lcl9iYXNlcy5sb2NrKXstLi0uLi59
OgpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTA0YWI2Yz5dIF9fbG9ja19hY3F1aXJlKzB4
OWVhLzB4YzZkClsgICAxMi42NjQwNDFdICAgICAgICBbPDgxMDRhZTgxPl0gbG9ja19hY3F1
aXJlKzB4OTIvMHgxMDEKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODE0MzMyMmQ+XSBfcmF3
X3NwaW5fbG9ja19pcnFzYXZlKzB4MmUvMHgzZQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4
MTAzY2U1OT5dIF9faHJ0aW1lcl9zdGFydF9yYW5nZV9ucysweDFjLzB4MTk3ClsgICAxMi42
NjQwNDFdICAgICAgICBbPDgxMDgwMjUwPl0gcGVyZl9zd2V2ZW50X3N0YXJ0X2hydGltZXIu
cGFydC40MSsweDdhLzB4ODUKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwODFkYzI+XSB0
YXNrX2Nsb2NrX2V2ZW50X3N0YXJ0KzB4M2EvMHgzZgpbICAgMTIuNjY0MDQxXSAgICAgICAg
Wzw4MTA4MWRkND5dIHRhc2tfY2xvY2tfZXZlbnRfYWRkKzB4ZC8weDE0ClsgICAxMi42NjQw
NDFdICAgICAgICBbPDgxMDgzYmNhPl0gZXZlbnRfc2NoZWRfaW4rMHhiNi8weDE3YQpbICAg
MTIuNjY0MDQxXSAgICAgICAgWzw4MTA4M2NkMj5dIGdyb3VwX3NjaGVkX2luKzB4NDQvMHgx
MjIKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwODNlNGQ+XSBjdHhfc2NoZWRfaW4uaXNy
YS42NysweDlkLzB4MTFmClsgICAxMi42NjQwNDFdICAgICAgICBbPDgxMDgzZWY2Pl0gcGVy
Zl9ldmVudF9zY2hlZF9pbi5pc3JhLjcwKzB4MjcvMHg0YgpbICAgMTIuNjY0MDQxXSAgICAg
ICAgWzw4MTA4NDIyNj5dIF9fcGVyZl9pbnN0YWxsX2luX2NvbnRleHQrMHg4Yi8weGEzClsg
ICAxMi42NjQwNDFdICAgICAgICBbPDgxMDgwMWJlPl0gcmVtb3RlX2Z1bmN0aW9uKzB4MTIv
MHgyYQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTA1ZmIyMz5dIHNtcF9jYWxsX2Z1bmN0
aW9uX3NpbmdsZSsweDJkLzB4NTMKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwN2Y3YWQ+
XSB0YXNrX2Z1bmN0aW9uX2NhbGwrMHgzMC8weDM2ClsgICAxMi42NjQwNDFdICAgICAgICBb
PDgxMDgxMWIyPl0gcGVyZl9pbnN0YWxsX2luX2NvbnRleHQrMHg4Ny8weGJiClsgICAxMi42
NjQwNDFdICAgICAgICBbPDgxMDg2OGY2Pl0gU1lTQ19wZXJmX2V2ZW50X29wZW4rMHg1YzYv
MHg3MDEKWyAgIDEyLjY2NDA0MV0gICAgICAgIFs8ODEwODZkMjY+XSBTeVNfcGVyZl9ldmVu
dF9vcGVuKzB4MTcvMHgxOQpbICAgMTIuNjY0MDQxXSAgICAgICAgWzw4MTQzMzlmZT5dIHN5
c2NhbGxfY2FsbCsweDcvMHhiClsgICAxMi42NjQwNDFdIApbICAgMTIuNjY0MDQxXSBvdGhl
ciBpbmZvIHRoYXQgbWlnaHQgaGVscCB1cyBkZWJ1ZyB0aGlzOgpbICAgMTIuNjY0MDQxXSAK
WyAgIDEyLjY2NDA0MV0gQ2hhaW4gZXhpc3RzIG9mOgogIGhydGltZXJfYmFzZXMubG9jayAt
LT4gJnJxLT5sb2NrIC0tPiAmY3R4LT5sb2NrCgpbICAgMTIuNjY0MDQxXSAgUG9zc2libGUg
dW5zYWZlIGxvY2tpbmcgc2NlbmFyaW86ClsgICAxMi42NjQwNDFdIApbICAgMTIuNjY0MDQx
XSAgICAgICAgQ1BVMCAgICAgICAgICAgICAgICAgICAgQ1BVMQpbICAgMTIuNjY0MDQxXSAg
ICAgICAgLS0tLSAgICAgICAgICAgICAgICAgICAgLS0tLQpbICAgMTIuNjY0MDQxXSAgIGxv
Y2soJmN0eC0+bG9jayk7ClsgICAxMi42NjQwNDFdICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBsb2NrKCZycS0+bG9jayk7ClsgICAxMi42NjQwNDFdICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBsb2NrKCZjdHgtPmxvY2spOwpbICAgMTIuNjY0MDQxXSAgIGxv
Y2soaHJ0aW1lcl9iYXNlcy5sb2NrKTsKWyAgIDEyLjY2NDA0MV0gClsgICAxMi42NjQwNDFd
ICAqKiogREVBRExPQ0sgKioqClsgICAxMi42NjQwNDFdIApbICAgMTIuNjY0MDQxXSAzIGxv
Y2tzIGhlbGQgYnkgdHJpbml0eS1tYWluLzc0OgpbICAgMTIuNjY0MDQxXSAgIzA6ICAoJmN0
eC0+bXV0ZXgpeysuKy4uLn0sIGF0OiBbPDgxMDg2OGQ4Pl0gU1lTQ19wZXJmX2V2ZW50X29w
ZW4rMHg1YTgvMHg3MDEKWyAgIDEyLjY2NDA0MV0gICMxOiAgKCZjcHVjdHhfbG9jayl7Li4u
Li4ufSwgYXQ6IFs8ODEwN2Y2NmQ+XSBwZXJmX2N0eF9sb2NrKzB4ZS8weDFkClsgICAxMi42
NjQwNDFdICAjMjogICgmY3R4LT5sb2NrKXsuLi4uLi59LCBhdDogWzw4MTA3ZjY3OT5dIHBl
cmZfY3R4X2xvY2srMHgxYS8weDFkClsgICAxMi42NjQwNDFdIApbICAgMTIuNjY0MDQxXSBz
dGFjayBiYWNrdHJhY2U6ClsgICAxMi42NjQwNDFdIENQVTogMCBQSUQ6IDc0IENvbW06IHRy
aW5pdHktbWFpbiBOb3QgdGFpbnRlZCAzLjE1LjAtMDgzNTEtZzllZTRkN2EgIzIKWyAgIDEy
LjY2NDA0MV0gIDAwMDAwMDAwIDgxYzRjNDg4IDhiOWEzY2MwIDgxNDJiMDc0IDhiOWEzY2Yw
IDgxNDI5YmNlIDgxNjI1YTkxIDgxNjI1OTkwClsgICAxMi42NjQwNDFdICA4MTYyNTk1OCA4
MTYyNTk3OSA4MTYyNTk1OCA4YjlhM2QyNCA4YjExYWIzMCAwMDAwMDAwMyA4YjExYWY0NCA4
YjExYWIzMApbICAgMTIuNjY0MDQxXSAgOGI5YTNkNTQgODEwNGFiNmMgOGIxMWFmMmMgMDAw
MDE2OTkgMDAwMDAwMDIgMDAwMDAwMDAgODFjNWRkMDggMDAwMDAwMDMKWyAgIDEyLjY2NDA0
MV0gQ2FsbCBUcmFjZToKWyAgIDEyLjY2NDA0MV0gIFs8ODE0MmIwNzQ+XSBkdW1wX3N0YWNr
KzB4MTYvMHgxOApbICAgMTIuNjY0MDQxXSAgWzw4MTQyOWJjZT5dIHByaW50X2NpcmN1bGFy
X2J1ZysweDE4Zi8weDE5YwpbICAgMTIuNjY0MDQxXSAgWzw4MTA0YWI2Yz5dIF9fbG9ja19h
Y3F1aXJlKzB4OWVhLzB4YzZkClsgICAxMi42NjQwNDFdICBbPDgxMDRhZTgxPl0gbG9ja19h
Y3F1aXJlKzB4OTIvMHgxMDEKWyAgIDEyLjY2NDA0MV0gIFs8ODEwM2NlNTk+XSA/IF9faHJ0
aW1lcl9zdGFydF9yYW5nZV9ucysweDFjLzB4MTk3ClsgICAxMi42NjQwNDFdICBbPDgxNDMz
MjJkPl0gX3Jhd19zcGluX2xvY2tfaXJxc2F2ZSsweDJlLzB4M2UKWyAgIDEyLjY2NDA0MV0g
IFs8ODEwM2NlNTk+XSA/IF9faHJ0aW1lcl9zdGFydF9yYW5nZV9ucysweDFjLzB4MTk3Clsg
ICAxMi42NjQwNDFdICBbPDgxMDNjZTU5Pl0gX19ocnRpbWVyX3N0YXJ0X3JhbmdlX25zKzB4
MWMvMHgxOTcKWyAgIDEyLjY2NDA0MV0gIFs8ODEwNDlmMTc+XSA/IF9fbG9ja19pc19oZWxk
KzB4MmQvMHg0MwpbICAgMTIuNjY0MDQxXSAgWzw4MTA4MDI1MD5dIHBlcmZfc3dldmVudF9z
dGFydF9ocnRpbWVyLnBhcnQuNDErMHg3YS8weDg1ClsgICAxMi42NjQwNDFdICBbPDgxMDgx
ZGMyPl0gdGFza19jbG9ja19ldmVudF9zdGFydCsweDNhLzB4M2YKWyAgIDEyLjY2NDA0MV0g
IFs8ODEwODFkZDQ+XSB0YXNrX2Nsb2NrX2V2ZW50X2FkZCsweGQvMHgxNApbICAgMTIuNjY0
MDQxXSAgWzw4MTA4M2JjYT5dIGV2ZW50X3NjaGVkX2luKzB4YjYvMHgxN2EKWyAgIDEyLjY2
NDA0MV0gIFs8ODEwODNjZDI+XSBncm91cF9zY2hlZF9pbisweDQ0LzB4MTIyClsgICAxMi42
NjQwNDFdICBbPDgxMDgzZTRkPl0gY3R4X3NjaGVkX2luLmlzcmEuNjcrMHg5ZC8weDExZgpb
ICAgMTIuNjY0MDQxXSAgWzw4MTA4M2VmNj5dIHBlcmZfZXZlbnRfc2NoZWRfaW4uaXNyYS43
MCsweDI3LzB4NGIKWyAgIDEyLjY2NDA0MV0gIFs8ODEwODQyMjY+XSBfX3BlcmZfaW5zdGFs
bF9pbl9jb250ZXh0KzB4OGIvMHhhMwpbICAgMTIuNjY0MDQxXSAgWzw4MTA4MDFhYz5dID8g
cGVyZl9tbWFwX2ZhdWx0KzB4ZTIvMHhlMgpbICAgMTIuNjY0MDQxXSAgWzw4MTA4MDFiZT5d
IHJlbW90ZV9mdW5jdGlvbisweDEyLzB4MmEKWyAgIDEyLjY2NDA0MV0gIFs8ODEwNWZiMjM+
XSBzbXBfY2FsbF9mdW5jdGlvbl9zaW5nbGUrMHgyZC8weDUzClsgICAxMi42NjQwNDFdICBb
PDgxMDdmN2FkPl0gdGFza19mdW5jdGlvbl9jYWxsKzB4MzAvMHgzNgpbICAgMTIuNjY0MDQx
XSAgWzw4MTA4NDE5Yj5dID8gcGVyZl9jcHVfaHJ0aW1lcl9oYW5kbGVyKzB4MTBlLzB4MTBl
ClsgICAxMi42NjQwNDFdICBbPDgxMDgxMWIyPl0gcGVyZl9pbnN0YWxsX2luX2NvbnRleHQr
MHg4Ny8weGJiClsgICAxMi42NjQwNDFdICBbPDgxMDg2OGY2Pl0gU1lTQ19wZXJmX2V2ZW50
X29wZW4rMHg1YzYvMHg3MDEKWyAgIDEyLjY2NDA0MV0gIFs8ODEwMWIzMDA+XSA/IF9fZG9f
cGFnZV9mYXVsdCsweDFlZS8weDMxNApbICAgMTIuNjY0MDQxXSAgWzw4MTA4NmQyNj5dIFN5
U19wZXJmX2V2ZW50X29wZW4rMHgxNy8weDE5ClsgICAxMi42NjQwNDFdICBbPDgxNDMzOWZl
Pl0gc3lzY2FsbF9jYWxsKzB4Ny8weGIKWyAgIDEyLjY2NDA0MV0gIFs8ODE0MzAwMDA+XSA/
IGFzdXNfcmVnaXN0ZXJfcmZraWxsX25vdGlmaWVyKzB4NDgvMHg0ZgpbICAgMzIuODAwMDY2
XSByYW5kb206IG5vbmJsb2NraW5nIHBvb2wgaXMgaW5pdGlhbGl6ZWQKWyAgIDYxLjAxNjEz
MV0gc3Bpbl9sb2NrLXRvcnR1cmU6IFdyaXRlczogIFRvdGFsOiAyICBNYXgvTWluOiAwLzAg
ICBGYWlsOiAwIApwbHltb3V0aC11cHN0YXJ0LWJyaWRnZTogcGx5LWV2ZW50LWxvb3AuYzo0
OTc6IHBseV9ldmVudF9sb29wX25ldzogQXNzZXJ0aW9uIGBsb29wLT5lcG9sbF9mZCA+PSAw
JyBmYWlsZWQuCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLzllZTRkN2E2NTM4
MzA4YTc2ODFiNjM4ZDJmMzVmMmEzMDE0MjAzNTUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtOToy
MDE0MDgwMTAxMjEzMjppMzg2LXJhbmRjb25maWctaGEyLTA3MzE6My4xNS4wLTA4MzUxLWc5
ZWU0ZDdhOjIKMzoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzog
ODM1MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTQgc3Rl
cHMpCls5ODk0ZTZkOWMwMjBiNzU0ZGQ5NjI5NjBlOWY3ZWFjMTgyODJmNjlmXSBNZXJnZSB0
YWcgJ2ZiZGV2LW9tYXAtZHQtMy4xNicgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L3RvbWJhL2xpbnV4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0yL29i
ai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1oYTItMDczMS9rdm1hcm06bmV4dDo5ODk0ZTZkOWMwMjBiNzU0ZGQ5NjI5NjBlOWY3
ZWFjMTgyODJmNjlmOmJpc2VjdC1saW51eC0yCgoyMDE0LTA4LTAxLTAxOjI0OjAzIDk4OTRl
NmQ5YzAyMGI3NTRkZDk2Mjk2MGU5ZjdlYWMxODI4MmY2OWYgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmln
LWhhMi0wNzMxLTk4OTRlNmQ5YzAyMGI3NTRkZDk2Mjk2MGU5ZjdlYWMxODI4MmY2OWYKQ2hl
Y2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS85ODk0
ZTZkOWMwMjBiNzU0ZGQ5NjI5NjBlOWY3ZWFjMTgyODJmNjlmCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEy
LTA3MzEtOTg5NGU2ZDljMDIwYjc1NGRkOTYyOTYwZTlmN2VhYzE4MjgyZjY5Zgp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvamFrZXRvd24t
Y29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLTk4OTRlNmQ5YzAyMGI3NTRkZDk2
Mjk2MGU5ZjdlYWMxODI4MmY2OWYKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1o
YTItMDczMS85ODk0ZTZkOWMwMjBiNzU0ZGQ5NjI5NjBlOWY3ZWFjMTgyODJmNjlmL3ZtbGlu
dXotMy4xNS4wLTA3OTg0LWc5ODk0ZTZkCgoyMDE0LTA4LTAxLTAxOjUzOjAzIGRldGVjdGlu
ZyBib290IHN0YXRlIC4uCTMJMzQJMzgJNjMJNzcJODEJMTAwCTEyOCBURVNUIEZBSUxVUkUK
L2Jpbi9zaDogL3Byb2Mvc2VsZi9mZC85OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Clsg
ICAxMy42MDE5NTddIHNvY2s6IHByb2Nlc3MgYHRyaW5pdHktbWFpbicgaXMgdXNpbmcgb2Jz
b2xldGUgc2V0c29ja29wdCBTT19CU0RDT01QQVQKCkJVRzoga2VybmVsIGJvb3QgaGFuZwpF
bGFwc2VkIHRpbWU6IDM1CnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUt
a3ZtIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvOTg5NGU2ZDlj
MDIwYjc1NGRkOTYyOTYwZTlmN2VhYzE4MjgyZjY5Zi92bWxpbnV6LTMuMTUuMC0wNzk4NC1n
OTg5NGU2ZCAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwx
MTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCByY3VwZGF0ZS5y
Y3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBu
bWlfd2F0Y2hkb2c9cGFuaWMgbG9hZF9yYW1kaXNrPTIgcHJvbXB0X3JhbWRpc2s9MCBjb25z
b2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9vdD0vZGV2L3Jh
bTAgcncgbGluaz0va2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LWhhMi0wNzMxL2t2bWFybTpuZXh0Ojk4OTRlNmQ5YzAyMGI3NTRkZDk2Mjk2MGU5ZjdlYWMx
ODI4MmY2OWY6YmlzZWN0LWxpbnV4LTIvLnZtbGludXotOTg5NGU2ZDljMDIwYjc1NGRkOTYy
OTYwZTlmN2VhYzE4MjgyZjY5Zi0yMDE0MDgwMTAxNTI1My0xOTctaXZiNDQgYnJhbmNoPWt2
bWFybS9uZXh0IEJPT1RfSU1BR0U9L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEv
OTg5NGU2ZDljMDIwYjc1NGRkOTYyOTYwZTlmN2VhYzE4MjgyZjY5Zi92bWxpbnV6LTMuMTUu
MC0wNzk4NC1nOTg5NGU2ZCBkcmJkLm1pbm9yX2NvdW50PTgnICAtaW5pdHJkIC9rZXJuZWwt
dGVzdHMvaW5pdHJkL3F1YW50YWwtY29yZS1pMzg2LmNneiAtbSAzMjAgLXNtcCAyIC1uZXQg
bmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxhbj0xIC1ib290IG9yZGVyPW5j
IC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBp
ZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwtaXZiNDQtODAgLXNlcmlhbCBmaWxl
Oi9kZXYvc2htL2tib290L3NlcmlhbC1xdWFudGFsLWl2YjQ0LTgwIC1kYWVtb25pemUgLWRp
c3BsYXkgbm9uZSAtbW9uaXRvciBudWxsIAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTIt
MDczMS85ODk0ZTZkOWMwMjBiNzU0ZGQ5NjI5NjBlOWY3ZWFjMTgyODJmNjlmL2RtZXNnLXlv
Y3RvLWl2YjQzLTEwOjIwMTQwODAxMDIwNjU2OmkzODYtcmFuZGNvbmZpZy1oYTItMDczMTo6
CjEyNDoxOjUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDgtMDEg
MDE6NTg6NTggUkVQRUFUIENPVU5UOiAzMDAgICMgL2MvYm9vdC1iaXNlY3QvbGludXgtMi9v
YmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDc2MjQgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbOTYzNjQ5ZDczNWM4YjZl
YjBmOTdlODJjNTRmMDI0MjZmZjNmMWY0NV0gTWVyZ2UgdGFnICdmb3ItbGludXMtMy4xNi1t
ZXJnZS13aW5kb3cnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9lcmljdmgvdjlmcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMi9vYmotYmlzZWN0Cmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEyLTA3
MzEva3ZtYXJtOm5leHQ6OTYzNjQ5ZDczNWM4YjZlYjBmOTdlODJjNTRmMDI0MjZmZjNmMWY0
NTpiaXNlY3QtbGludXgtMgoKMjAxNC0wOC0wMS0wMTo1OToyNCA5NjM2NDlkNzM1YzhiNmVi
MGY5N2U4MmM1NGYwMjQyNmZmM2YxZjQ1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS05
NjM2NDlkNzM1YzhiNmViMGY5N2U4MmM1NGYwMjQyNmZmM2YxZjQ1CkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvOTYzNjQ5ZDczNWM4YjZl
YjBmOTdlODJjNTRmMDI0MjZmZjNmMWY0NQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLTk2MzY0
OWQ3MzVjOGI2ZWIwZjk3ZTgyYzU0ZjAyNDI2ZmYzZjFmNDUKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1jb25zdW1lci9p
Mzg2LXJhbmRjb25maWctaGEyLTA3MzEtOTYzNjQ5ZDczNWM4YjZlYjBmOTdlODJjNTRmMDI0
MjZmZjNmMWY0NQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLzk2
MzY0OWQ3MzVjOGI2ZWIwZjk3ZTgyYzU0ZjAyNDI2ZmYzZjFmNDUvdm1saW51ei0zLjE1LjAt
MDcyNTctZzk2MzY0OWQKCjIwMTQtMDgtMDEtMDI6MDQ6MjQgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgLi4JMjAJMzEJNDggVEVTVCBGQUlMVVJFClsgICAgMi41MzYyMDddIHRzYzogUmVmaW5l
ZCBUU0MgY2xvY2tzb3VyY2UgY2FsaWJyYXRpb246IDI2OTMuNTA1IE1IegpbICAgMTIuODA5
MDQ2XSBzb2NrOiBwcm9jZXNzIGB0cmluaXR5LW1haW4nIGlzIHVzaW5nIG9ic29sZXRlIHNl
dHNvY2tvcHQgU09fQlNEQ09NUEFUCgpCVUc6IGtlcm5lbCBib290IGhhbmcKRWxhcHNlZCB0
aW1lOiAzNQpxZW11LXN5c3RlbS14ODZfNjQgLWNwdSBrdm02NCAtZW5hYmxlLWt2bSAta2Vy
bmVsIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLzk2MzY0OWQ3MzVjOGI2ZWIw
Zjk3ZTgyYzU0ZjAyNDI2ZmYzZjFmNDUvdm1saW51ei0zLjE1LjAtMDcyNTctZzk2MzY0OWQg
LWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRl
YnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9z
dGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNo
ZG9nPXBhbmljIGxvYWRfcmFtZGlzaz0yIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlT
MCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxp
bms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTItMDcz
MS9rdm1hcm06bmV4dDo5NjM2NDlkNzM1YzhiNmViMGY5N2U4MmM1NGYwMjQyNmZmM2YxZjQ1
OmJpc2VjdC1saW51eC0yLy52bWxpbnV6LTk2MzY0OWQ3MzVjOGI2ZWIwZjk3ZTgyYzU0ZjAy
NDI2ZmYzZjFmNDUtMjAxNDA4MDExMDA0NDQtMTMyLWl2YjQ0IGJyYW5jaD1rdm1hcm0vbmV4
dCBCT09UX0lNQUdFPS9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLzk2MzY0OWQ3
MzVjOGI2ZWIwZjk3ZTgyYzU0ZjAyNDI2ZmYzZjFmNDUvdm1saW51ei0zLjE1LjAtMDcyNTct
Zzk2MzY0OWQgZHJiZC5taW5vcl9jb3VudD04JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2lu
aXRyZC9xdWFudGFsLWNvcmUtaTM4Ni5jZ3ogLW0gMzIwIC1zbXAgMiAtbmV0IG5pYyx2bGFu
PTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSAtYm9vdCBvcmRlcj1uYyAtbm8tcmVi
b290IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1waWRmaWxlIC9k
ZXYvc2htL2tib290L3BpZC1xdWFudGFsLWl2YjQ0LTExIC1zZXJpYWwgZmlsZTovZGV2L3No
bS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1pdmI0NC0xMSAtZGFlbW9uaXplIC1kaXNwbGF5IG5v
bmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvOTYz
NjQ5ZDczNWM4YjZlYjBmOTdlODJjNTRmMDI0MjZmZjNmMWY0NS9kbWVzZy1xdWFudGFsLWl2
YjQ0LTMwOjIwMTQwODAxMDE1ODE0OmkzODYtcmFuZGNvbmZpZy1oYTItMDczMTo6CjQ2OjE6
MyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wOC0wMSAwMjowNjo1
NCBSRVBFQVQgQ09VTlQ6IDMwMCAgIyAvYy9ib290LWJpc2VjdC9saW51eC0yL29iai1iaXNl
Y3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogNzI1NyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMTMgc3RlcHMpCltiMjBkY2FiOWQ0NTg5ZWY5OTE4YTEz
Yzg4OGM1NDkzOTQ1YWRmYzEzXSBNZXJnZSB0YWcgJ2xsdm1saW51eC1mb3ItdjMuMTYnIG9m
IGdpdDovL2dpdC5saW51eGZvdW5kYXRpb24ub3JnL2xsdm1saW51eC9rZXJuZWwKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3Qt
YmlzZWN0L2xpbnV4LTIvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxL2t2bWFybTpuZXh0OmIyMGRjYWI5ZDQ1
ODllZjk5MThhMTNjODg4YzU0OTM5NDVhZGZjMTM6YmlzZWN0LWxpbnV4LTIKCjIwMTQtMDgt
MDEtMDI6MDY6NTUgYjIwZGNhYjlkNDU4OWVmOTkxOGExM2M4ODhjNTQ5Mzk0NWFkZmMxMyBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEtYjIwZGNhYjlkNDU4OWVmOTkxOGExM2M4ODhj
NTQ5Mzk0NWFkZmMxMwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWhhMi0wNzMxL2IyMGRjYWI5ZDQ1ODllZjk5MThhMTNjODg4YzU0OTM5NDVhZGZjMTMK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kz
ODYtcmFuZGNvbmZpZy1oYTItMDczMS1iMjBkY2FiOWQ0NTg5ZWY5OTE4YTEzYzg4OGM1NDkz
OTQ1YWRmYzEzCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvYjIw
ZGNhYjlkNDU4OWVmOTkxOGExM2M4ODhjNTQ5Mzk0NWFkZmMxMy92bWxpbnV6LTMuMTUuMC0w
NzIyNi1nYjIwZGNhYgoKMjAxNC0wOC0wMS0wMjowOTo1NSBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLgkyCTE1CTE3LgkyNgkzNSBURVNUIEZBSUxVUkUKWyAgIDEyLjg1Mzc0OF0gc29jazog
cHJvY2VzcyBgdHJpbml0eS1tYWluJyBpcyB1c2luZyBvYnNvbGV0ZSBzZXRzb2Nrb3B0IFNP
X0JTRENPTVBBVApbICAgMTQuMjk3MDg2XSAKWyAgIDE0LjI5NzMwOF0gPT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09ClsgICAxNC4yOTgx
NDFdIFsgSU5GTzogcG9zc2libGUgY2lyY3VsYXIgbG9ja2luZyBkZXBlbmRlbmN5IGRldGVj
dGVkIF0KWyAgIDE0LjI5ODk5OV0gMy4xNS4wLTA3MjI2LWdiMjBkY2FiICMyMSBOb3QgdGFp
bnRlZApbICAgMTQuMjk5NTk1XSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAxNC4zMDAwNTBdIHRyaW5pdHktbWFpbi83NCBp
cyB0cnlpbmcgdG8gYWNxdWlyZSBsb2NrOgpbICAgMTQuMzAwMDUwXSAgKGhydGltZXJfYmFz
ZXMubG9jayl7LS4tLi4ufSwgYXQ6IFs8ODEwM2QwN2Y+XSBfX2hydGltZXJfc3RhcnRfcmFu
Z2VfbnMrMHgxYy8weDE5NwpbICAgMTQuMzAwMDUwXSAKWyAgIDE0LjMwMDA1MF0gYnV0IHRh
c2sgaXMgYWxyZWFkeSBob2xkaW5nIGxvY2s6ClsgICAxNC4zMDAwNTBdICAoJmN0eC0+bG9j
ayl7Li4uLi4ufSwgYXQ6IFs8ODEwN2U3ZTA+XSBwZXJmX2N0eF9sb2NrKzB4MWEvMHgxZApb
ICAgMTQuMzAwMDUwXSAKWyAgIDE0LjMwMDA1MF0gd2hpY2ggbG9jayBhbHJlYWR5IGRlcGVu
ZHMgb24gdGhlIG5ldyBsb2NrLgpbICAgMTQuMzAwMDUwXSAKWyAgIDE0LjMwMDA1MF0gClsg
ICAxNC4zMDAwNTBdIHRoZSBleGlzdGluZyBkZXBlbmRlbmN5IGNoYWluIChpbiByZXZlcnNl
IG9yZGVyKSBpczoKWyAgIDE0LjMwMDA1MF0gCi0+ICM1ICgmY3R4LT5sb2NrKXsuLi4uLi59
OgpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTA0YjBhNz5dIGxvY2tfYWNxdWlyZSsweDky
LzB4MTAxClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxNDMxYTk0Pl0gX3Jhd19zcGluX2xv
Y2srMHgyMS8weDMwClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMDgyNThhPl0gX19wZXJm
X2V2ZW50X3Rhc2tfc2NoZWRfb3V0KzB4MWRjLzB4MzRmClsgICAxNC4zMDAwNTBdICAgICAg
ICBbPDgxNDJmNTE0Pl0gX19zY2hlZHVsZSsweDRjNi8weDRjYgpbICAgMTQuMzAwMDUwXSAg
ICAgICAgWzw4MTQyZjUyOD5dIHNjaGVkdWxlKzB4Zi8weDExClsgICAxNC4zMDAwNTBdICAg
ICAgICBbPDgxNDMyMzhlPl0gd29ya19yZXNjaGVkKzB4NS8weDJjClsgICAxNC4zMDAwNTBd
IAotPiAjNCAoJnJxLT5sb2NrKXstLi0uLS59OgpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4
MTA0YjBhNz5dIGxvY2tfYWNxdWlyZSsweDkyLzB4MTAxClsgICAxNC4zMDAwNTBdICAgICAg
ICBbPDgxNDMxYTk0Pl0gX3Jhd19zcGluX2xvY2srMHgyMS8weDMwClsgICAxNC4zMDAwNTBd
ICAgICAgICBbPDgxMDQwZmRhPl0gX190YXNrX3JxX2xvY2srMHgzMy8weDNhClsgICAxNC4z
MDAwNTBdICAgICAgICBbPDgxMDQxZmIzPl0gd2FrZV91cF9uZXdfdGFzaysweDI1LzB4YzIK
WyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODEwMjRlYWU+XSBkb19mb3JrKzB4MTU0LzB4MjY1
ClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMDI0ZmQ5Pl0ga2VybmVsX3RocmVhZCsweDFh
LzB4MWYKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODE0MjVkMDI+XSByZXN0X2luaXQrMHgx
YS8weDEwZQpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTdiMzllMj5dIHN0YXJ0X2tlcm5l
bCsweDMwMy8weDMwOApbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTdiMzJhYj5dIGkzODZf
c3RhcnRfa2VybmVsKzB4NzkvMHg3ZApbICAgMTQuMzAwMDUwXSAKLT4gIzMgKCZwLT5waV9s
b2NrKXstLi0uLi59OgpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTA0YjBhNz5dIGxvY2tf
YWNxdWlyZSsweDkyLzB4MTAxClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxNDMxYjY1Pl0g
X3Jhd19zcGluX2xvY2tfaXJxc2F2ZSsweDJlLzB4M2UKWyAgIDE0LjMwMDA1MF0gICAgICAg
IFs8ODEwNDFiNDQ+XSB0cnlfdG9fd2FrZV91cCsweDFkLzB4ZDYKWyAgIDE0LjMwMDA1MF0g
ICAgICAgIFs8ODEwNDFjMzQ+XSBkZWZhdWx0X3dha2VfZnVuY3Rpb24rMHhiLzB4ZApbICAg
MTQuMzAwMDUwXSAgICAgICAgWzw4MTA0Njk1OD5dIF9fd2FrZV91cF9jb21tb24rMHgzOS8w
eDU5ClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMDQ2YWFiPl0gX193YWtlX3VwKzB4Mjkv
MHgzYgpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTFiOTA5Zj5dIHR0eV93YWtldXArMHg0
OS8weDUxClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMWMzZjlhPl0gdWFydF93cml0ZV93
YWtldXArMHgxNy8weDE5ClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMWM2N2YzPl0gc2Vy
aWFsODI1MF90eF9jaGFycysweGJjLzB4ZmIKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODEx
YzY5NWE+XSBzZXJpYWw4MjUwX2hhbmRsZV9pcnErMHg1NC8weDZhClsgICAxNC4zMDAwNTBd
ICAgICAgICBbPDgxMWM2OTg5Pl0gc2VyaWFsODI1MF9kZWZhdWx0X2hhbmRsZV9pcnErMHgx
OS8weDFjClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMWM2MTBhPl0gc2VyaWFsODI1MF9p
bnRlcnJ1cHQrMHgzOC8weDllClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMDUxN2JmPl0g
aGFuZGxlX2lycV9ldmVudF9wZXJjcHUrMHg1Zi8weDFlMgpbICAgMTQuMzAwMDUwXSAgICAg
ICAgWzw4MTA1MTk2ZT5dIGhhbmRsZV9pcnFfZXZlbnQrMHgyYy8weDQzClsgICAxNC4zMDAw
NTBdICAgICAgICBbPDgxMDUzM2Y1Pl0gaGFuZGxlX2xldmVsX2lycSsweDU3LzB4ODMKWyAg
IDE0LjMwMDA1MF0gICAgICAgIFs8ODEwMDJjY2U+XSBoYW5kbGVfaXJxKzB4NDYvMHg1Ywpb
ICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTAwMmEzYj5dIGRvX0lSUSsweDMyLzB4ODkKWyAg
IDE0LjMwMDA1MF0gICAgICAgIFs8ODE0MzJjYWU+XSBjb21tb25faW50ZXJydXB0KzB4MmUv
MHgzMwpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTQzMWM4ND5dIF9yYXdfc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZSsweDNmLzB4NDkKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODExYzJm
ZDY+XSB1YXJ0X3N0YXJ0KzB4MmQvMHgzMgpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTFj
MzYzNj5dIHVhcnRfd3JpdGUrMHhjNy8weGQ2ClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgx
MWJkMDYyPl0gbl90dHlfd3JpdGUrMHhiOC8weDM1ZQpbICAgMTQuMzAwMDUwXSAgICAgICAg
Wzw4MTFiYTU1Nz5dIHR0eV93cml0ZSsweDE2My8weDFlNApbICAgMTQuMzAwMDUwXSAgICAg
ICAgWzw4MTFiYTY0NT5dIHJlZGlyZWN0ZWRfdHR5X3dyaXRlKzB4NmQvMHg3NQpbICAgMTQu
MzAwMDUwXSAgICAgICAgWzw4MTBiNzcwNz5dIHZmc193cml0ZSsweDc1LzB4YjAKWyAgIDE0
LjMwMDA1MF0gICAgICAgIFs8ODEwYjdhOTY+XSBTeVNfd3JpdGUrMHg0NC8weDc3ClsgICAx
NC4zMDAwNTBdICAgICAgICBbPDgxNDMyMzM2Pl0gc3lzY2FsbF9jYWxsKzB4Ny8weGIKWyAg
IDE0LjMwMDA1MF0gCi0+ICMyICgmdHR5LT53cml0ZV93YWl0KXstLi4uLi59OgpbICAgMTQu
MzAwMDUwXSAgICAgICAgWzw4MTA0YjBhNz5dIGxvY2tfYWNxdWlyZSsweDkyLzB4MTAxClsg
ICAxNC4zMDAwNTBdICAgICAgICBbPDgxNDMxYjY1Pl0gX3Jhd19zcGluX2xvY2tfaXJxc2F2
ZSsweDJlLzB4M2UKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODEwNDZhOTc+XSBfX3dha2Vf
dXArMHgxNS8weDNiClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMWI5MDlmPl0gdHR5X3dh
a2V1cCsweDQ5LzB4NTEKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODExYzNmOWE+XSB1YXJ0
X3dyaXRlX3dha2V1cCsweDE3LzB4MTkKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODExYzY3
ZjM+XSBzZXJpYWw4MjUwX3R4X2NoYXJzKzB4YmMvMHhmYgpbICAgMTQuMzAwMDUwXSAgICAg
ICAgWzw4MTFjNjk1YT5dIHNlcmlhbDgyNTBfaGFuZGxlX2lycSsweDU0LzB4NmEKWyAgIDE0
LjMwMDA1MF0gICAgICAgIFs8ODExYzY5ODk+XSBzZXJpYWw4MjUwX2RlZmF1bHRfaGFuZGxl
X2lycSsweDE5LzB4MWMKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODExYzYxMGE+XSBzZXJp
YWw4MjUwX2ludGVycnVwdCsweDM4LzB4OWUKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODEw
NTE3YmY+XSBoYW5kbGVfaXJxX2V2ZW50X3BlcmNwdSsweDVmLzB4MWUyClsgICAxNC4zMDAw
NTBdICAgICAgICBbPDgxMDUxOTZlPl0gaGFuZGxlX2lycV9ldmVudCsweDJjLzB4NDMKWyAg
IDE0LjMwMDA1MF0gICAgICAgIFs8ODEwNTMzZjU+XSBoYW5kbGVfbGV2ZWxfaXJxKzB4NTcv
MHg4MwpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTAwMmNjZT5dIGhhbmRsZV9pcnErMHg0
Ni8weDVjClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMDAyYTNiPl0gZG9fSVJRKzB4MzIv
MHg4OQpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTQzMmNhZT5dIGNvbW1vbl9pbnRlcnJ1
cHQrMHgyZS8weDMzClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxNDMxYzg0Pl0gX3Jhd19z
cGluX3VubG9ja19pcnFyZXN0b3JlKzB4M2YvMHg0OQpbICAgMTQuMzAwMDUwXSAgICAgICAg
Wzw4MTFjMmZkNj5dIHVhcnRfc3RhcnQrMHgyZC8weDMyClsgICAxNC4zMDAwNTBdICAgICAg
ICBbPDgxMWMzNjM2Pl0gdWFydF93cml0ZSsweGM3LzB4ZDYKWyAgIDE0LjMwMDA1MF0gICAg
ICAgIFs8ODExYmQwNjI+XSBuX3R0eV93cml0ZSsweGI4LzB4MzVlClsgICAxNC4zMDAwNTBd
ICAgICAgICBbPDgxMWJhNTU3Pl0gdHR5X3dyaXRlKzB4MTYzLzB4MWU0ClsgICAxNC4zMDAw
NTBdICAgICAgICBbPDgxMWJhNjQ1Pl0gcmVkaXJlY3RlZF90dHlfd3JpdGUrMHg2ZC8weDc1
ClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMGI3NzA3Pl0gdmZzX3dyaXRlKzB4NzUvMHhi
MApbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTBiN2E5Nj5dIFN5U193cml0ZSsweDQ0LzB4
NzcKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODE0MzIzMzY+XSBzeXNjYWxsX2NhbGwrMHg3
LzB4YgpbICAgMTQuMzAwMDUwXSAKLT4gIzEgKCZwb3J0X2xvY2tfa2V5KXstLi0uLi59Ogpb
ICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTA0YjBhNz5dIGxvY2tfYWNxdWlyZSsweDkyLzB4
MTAxClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxNDMxYjY1Pl0gX3Jhd19zcGluX2xvY2tf
aXJxc2F2ZSsweDJlLzB4M2UKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODEwNDczMzU+XSBk
b3duX3RyeWxvY2srMHhjLzB4MjcKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODEwNGY5Mjk+
XSBjb25zb2xlX3RyeWxvY2srMHgxMi8weDgwClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgx
MDUwMzJmPl0gdnByaW50a19lbWl0KzB4NDA0LzB4NDIxClsgICAxNC4zMDAwNTBdICAgICAg
ICBbPDgxNDI4OWU2Pl0gcHJpbnRrKzB4MTcvMHgxOQpbICAgMTQuMzAwMDUwXSAgICAgICAg
Wzw4MTA1YzZhZD5dIGNsb2NrZXZlbnRzX3Byb2dyYW1fbWluX2RlbHRhKzB4MTA0LzB4MTE2
ClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMDVjYzU1Pl0gY2xvY2tldmVudHNfcHJvZ3Jh
bV9ldmVudCsweGU3LzB4ZjMKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODEwNWQzMjk+XSB0
aWNrX3Byb2dyYW1fZXZlbnQrMHgxZS8weDIzClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgx
MDNjYmEzPl0gaHJ0aW1lcl9mb3JjZV9yZXByb2dyYW0rMHg4OC8weDhmClsgICAxNC4zMDAw
NTBdICAgICAgICBbPDgxMDNkMDU3Pl0gcmV0cmlnZ2VyX25leHRfZXZlbnQrMHgzNi8weDQy
ClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMDNkODNhPl0gaHJ0aW1lcl9ydW5fcGVuZGlu
ZysweGU0LzB4MTA4ClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMDJjZDhlPl0gcnVuX3Rp
bWVyX3NvZnRpcnErMHgxNC8weDE5YwpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTAyODg1
Yj5dIF9fZG9fc29mdGlycSsweDExMS8weDJjNApbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4
MTAwMmM4Mj5dIGRvX3NvZnRpcnFfb3duX3N0YWNrKzB4MWMvMHgyMgpbICAgMTQuMzAwMDUw
XSAgICAgICAgWzw4MTAyOGJlZj5dIGlycV9leGl0KzB4NDQvMHg1ZApbICAgMTQuMzAwMDUw
XSAgICAgICAgWzw4MTAwMmE3Zj5dIGRvX0lSUSsweDc2LzB4ODkKWyAgIDE0LjMwMDA1MF0g
ICAgICAgIFs8ODE0MzJjYWU+XSBjb21tb25faW50ZXJydXB0KzB4MmUvMHgzMwpbICAgMTQu
MzAwMDUwXSAgICAgICAgWzw4MTA0OTVlZT5dIGRlYnVnX2NoZWNrX25vX2xvY2tzX2ZyZWVk
KzB4MTBhLzB4MTFkClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMDRjMThhPl0gX19yYXdf
c3Bpbl9sb2NrX2luaXQrMHgxNy8weDQ5ClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMDQ3
MjQzPl0gX19tdXRleF9pbml0KzB4MjQvMHg0NApbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4
MTBjNzk4ZD5dIGlub2RlX2luaXRfYWx3YXlzKzB4MTFhLzB4MWNhClsgICAxNC4zMDAwNTBd
ICAgICAgICBbPDgxMGM3ZTkzPl0gYWxsb2NfaW5vZGUrMHgzNC8weDVmClsgICAxNC4zMDAw
NTBdICAgICAgICBbPDgxMGM5MTU1Pl0gbmV3X2lub2RlX3BzZXVkbysweGEvMHg0MApbICAg
MTQuMzAwMDUwXSAgICAgICAgWzw4MTBjOTE5ZD5dIG5ld19pbm9kZSsweDEyLzB4MjIKWyAg
IDE0LjMwMDA1MF0gICAgICAgIFs8ODEwZjNiMjQ+XSBkZWJ1Z2ZzX21rbm9kLnBhcnQuOC5j
b25zdHByb3AuMTcrMHgxMy8weGNhClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMGYzZGE1
Pl0gX19jcmVhdGVfZmlsZSsweDE0Ni8weDFhYQpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4
MTBmM2UyZj5dIGRlYnVnZnNfY3JlYXRlX2ZpbGUrMHgyNi8weDJiClsgICAxNC4zMDAwNTBd
ICAgICAgICBbPDgxMDcyMWQ1Pl0gdHJhY2VfY3JlYXRlX2ZpbGUrMHgxNS8weDMzClsgICAx
NC4zMDAwNTBdICAgICAgICBbPDgxMDc2ZjFmPl0gZXZlbnRfY3JlYXRlX2RpcisweDM1YS8w
eDM2ZQpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTdjNDYxND5dIGV2ZW50X3RyYWNlX2lu
aXQrMHgxMjUvMHgxODEKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODEwMDA0OGI+XSBkb19v
bmVfaW5pdGNhbGwrMHhlOC8weDE2OApbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTdiM2Fi
Mz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4Y2MvMHgxNDQKWyAgIDE0LjMwMDA1MF0gICAg
ICAgIFs8ODE0MjVkZmU+XSBrZXJuZWxfaW5pdCsweDgvMHhiMwpbICAgMTQuMzAwMDUwXSAg
ICAgICAgWzw4MTQzMjc4MD5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMC8weDMwClsg
ICAxNC4zMDAwNTBdIAotPiAjMCAoaHJ0aW1lcl9iYXNlcy5sb2NrKXstLi0uLi59OgpbICAg
MTQuMzAwMDUwXSAgICAgICAgWzw4MTA0YWQ5Mj5dIF9fbG9ja19hY3F1aXJlKzB4OWVhLzB4
YzZkClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMDRiMGE3Pl0gbG9ja19hY3F1aXJlKzB4
OTIvMHgxMDEKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODE0MzFiNjU+XSBfcmF3X3NwaW5f
bG9ja19pcnFzYXZlKzB4MmUvMHgzZQpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTAzZDA3
Zj5dIF9faHJ0aW1lcl9zdGFydF9yYW5nZV9ucysweDFjLzB4MTk3ClsgICAxNC4zMDAwNTBd
ICAgICAgICBbPDgxMDdmM2I3Pl0gcGVyZl9zd2V2ZW50X3N0YXJ0X2hydGltZXIucGFydC40
MSsweDdhLzB4ODUKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODEwODBmMjk+XSB0YXNrX2Ns
b2NrX2V2ZW50X3N0YXJ0KzB4M2EvMHgzZgpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTA4
MGYzYj5dIHRhc2tfY2xvY2tfZXZlbnRfYWRkKzB4ZC8weDE0ClsgICAxNC4zMDAwNTBdICAg
ICAgICBbPDgxMDgyZDMxPl0gZXZlbnRfc2NoZWRfaW4rMHhiNi8weDE3YQpbICAgMTQuMzAw
MDUwXSAgICAgICAgWzw4MTA4MmUzOT5dIGdyb3VwX3NjaGVkX2luKzB4NDQvMHgxMjIKWyAg
IDE0LjMwMDA1MF0gICAgICAgIFs8ODEwODMwMWM+XSBjdHhfc2NoZWRfaW4uaXNyYS42Nysw
eDEwNS8weDExZgpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTA4MzA3ZD5dIHBlcmZfZXZl
bnRfc2NoZWRfaW4uaXNyYS43MCsweDQ3LzB4NGIKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8
ODEwODMzOGQ+XSBfX3BlcmZfaW5zdGFsbF9pbl9jb250ZXh0KzB4OGIvMHhhMwpbICAgMTQu
MzAwMDUwXSAgICAgICAgWzw4MTA3ZjMyNT5dIHJlbW90ZV9mdW5jdGlvbisweDEyLzB4MmEK
WyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODEwNWZkNDk+XSBzbXBfY2FsbF9mdW5jdGlvbl9z
aW5nbGUrMHgyZC8weDUzClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMDdlOTE0Pl0gdGFz
a19mdW5jdGlvbl9jYWxsKzB4MzAvMHgzNgpbICAgMTQuMzAwMDUwXSAgICAgICAgWzw4MTA4
MDMxOT5dIHBlcmZfaW5zdGFsbF9pbl9jb250ZXh0KzB4ODcvMHhiYgpbICAgMTQuMzAwMDUw
XSAgICAgICAgWzw4MTA4NWE1ZD5dIFNZU0NfcGVyZl9ldmVudF9vcGVuKzB4NWM2LzB4NzAx
ClsgICAxNC4zMDAwNTBdICAgICAgICBbPDgxMDg1ZThkPl0gU3lTX3BlcmZfZXZlbnRfb3Bl
bisweDE3LzB4MTkKWyAgIDE0LjMwMDA1MF0gICAgICAgIFs8ODE0MzIzMzY+XSBzeXNjYWxs
X2NhbGwrMHg3LzB4YgpbICAgMTQuMzAwMDUwXSAKWyAgIDE0LjMwMDA1MF0gb3RoZXIgaW5m
byB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhpczoKWyAgIDE0LjMwMDA1MF0gClsgICAx
NC4zMDAwNTBdIENoYWluIGV4aXN0cyBvZjoKICBocnRpbWVyX2Jhc2VzLmxvY2sgLS0+ICZy
cS0+bG9jayAtLT4gJmN0eC0+bG9jawoKWyAgIDE0LjMwMDA1MF0gIFBvc3NpYmxlIHVuc2Fm
ZSBsb2NraW5nIHNjZW5hcmlvOgpbICAgMTQuMzAwMDUwXSAKWyAgIDE0LjMwMDA1MF0gICAg
ICAgIENQVTAgICAgICAgICAgICAgICAgICAgIENQVTEKWyAgIDE0LjMwMDA1MF0gICAgICAg
IC0tLS0gICAgICAgICAgICAgICAgICAgIC0tLS0KWyAgIDE0LjMwMDA1MF0gICBsb2NrKCZj
dHgtPmxvY2spOwpbICAgMTQuMzAwMDUwXSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgbG9jaygmcnEtPmxvY2spOwpbICAgMTQuMzAwMDUwXSAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgbG9jaygmY3R4LT5sb2NrKTsKWyAgIDE0LjMwMDA1MF0gICBsb2NrKGhy
dGltZXJfYmFzZXMubG9jayk7ClsgICAxNC4zMDAwNTBdIApbICAgMTQuMzAwMDUwXSAgKioq
IERFQURMT0NLICoqKgpbICAgMTQuMzAwMDUwXSAKWyAgIDE0LjMwMDA1MF0gMyBsb2NrcyBo
ZWxkIGJ5IHRyaW5pdHktbWFpbi83NDoKWyAgIDE0LjMwMDA1MF0gICMwOiAgKCZjdHgtPm11
dGV4KXsrLisuLi59LCBhdDogWzw4MTA4NWEzZj5dIFNZU0NfcGVyZl9ldmVudF9vcGVuKzB4
NWE4LzB4NzAxClsgICAxNC4zMDAwNTBdICAjMTogICgmY3B1Y3R4X2xvY2spey4uLi4uLn0s
IGF0OiBbPDgxMDdlN2Q0Pl0gcGVyZl9jdHhfbG9jaysweGUvMHgxZApbICAgMTQuMzAwMDUw
XSAgIzI6ICAoJmN0eC0+bG9jayl7Li4uLi4ufSwgYXQ6IFs8ODEwN2U3ZTA+XSBwZXJmX2N0
eF9sb2NrKzB4MWEvMHgxZApbICAgMTQuMzAwMDUwXSAKWyAgIDE0LjMwMDA1MF0gc3RhY2sg
YmFja3RyYWNlOgpbICAgMTQuMzAwMDUwXSBDUFU6IDAgUElEOiA3NCBDb21tOiB0cmluaXR5
LW1haW4gTm90IHRhaW50ZWQgMy4xNS4wLTA3MjI2LWdiMjBkY2FiICMyMQpbICAgMTQuMzAw
MDUwXSAgMDAwMDAwMDAgODFjNDk1OTggODAxMDdjYzAgODE0Mjk5YWYgODAxMDdjZjAgODE0
Mjg1MDkgODE2MjQ0MWMgODE2MjQzMWIKWyAgIDE0LjMwMDA1MF0gIDgxNjI0MmUzIDgxNjI0
MzA0IDgxNjI0MmUzIDgwMTA3ZDI0IDgwMDRjOWIwIDAwMDAwMDAzIDgwMDRjZGM0IDgwMDRj
OWIwClsgICAxNC4zMDAwNTBdICA4MDEwN2Q1NCA4MTA0YWQ5MiA4MDA0Y2RhYyAwMDAwMTZi
NyAwMDAwMDAwMiAwMDAwMDAwMCA4MWM1YWQwOCAwMDAwMDAwMwpbICAgMTQuMzAwMDUwXSBD
YWxsIFRyYWNlOgpbICAgMTQuMzAwMDUwXSAgWzw4MTQyOTlhZj5dIGR1bXBfc3RhY2srMHgx
Ni8weDE4ClsgICAxNC4zMDAwNTBdICBbPDgxNDI4NTA5Pl0gcHJpbnRfY2lyY3VsYXJfYnVn
KzB4MThmLzB4MTljClsgICAxNC4zMDAwNTBdICBbPDgxMDRhZDkyPl0gX19sb2NrX2FjcXVp
cmUrMHg5ZWEvMHhjNmQKWyAgIDE0LjMwMDA1MF0gIFs8ODEwNGIwYTc+XSBsb2NrX2FjcXVp
cmUrMHg5Mi8weDEwMQpbICAgMTQuMzAwMDUwXSAgWzw4MTAzZDA3Zj5dID8gX19ocnRpbWVy
X3N0YXJ0X3JhbmdlX25zKzB4MWMvMHgxOTcKWyAgIDE0LjMwMDA1MF0gIFs8ODE0MzFiNjU+
XSBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4MmUvMHgzZQpbICAgMTQuMzAwMDUwXSAgWzw4
MTAzZDA3Zj5dID8gX19ocnRpbWVyX3N0YXJ0X3JhbmdlX25zKzB4MWMvMHgxOTcKWyAgIDE0
LjMwMDA1MF0gIFs8ODEwM2QwN2Y+XSBfX2hydGltZXJfc3RhcnRfcmFuZ2VfbnMrMHgxYy8w
eDE5NwpbICAgMTQuMzAwMDUwXSAgWzw4MTA3ZjNiNz5dIHBlcmZfc3dldmVudF9zdGFydF9o
cnRpbWVyLnBhcnQuNDErMHg3YS8weDg1ClsgICAxNC4zMDAwNTBdICBbPDgxMDgwZjI5Pl0g
dGFza19jbG9ja19ldmVudF9zdGFydCsweDNhLzB4M2YKWyAgIDE0LjMwMDA1MF0gIFs8ODEw
ODBmM2I+XSB0YXNrX2Nsb2NrX2V2ZW50X2FkZCsweGQvMHgxNApbICAgMTQuMzAwMDUwXSAg
Wzw4MTA4MmQzMT5dIGV2ZW50X3NjaGVkX2luKzB4YjYvMHgxN2EKWyAgIDE0LjMwMDA1MF0g
IFs8ODEwODJlMzk+XSBncm91cF9zY2hlZF9pbisweDQ0LzB4MTIyClsgICAxNC4zMDAwNTBd
ICBbPDgxMDgzMDFjPl0gY3R4X3NjaGVkX2luLmlzcmEuNjcrMHgxMDUvMHgxMWYKWyAgIDE0
LjMwMDA1MF0gIFs8ODEwODMwN2Q+XSBwZXJmX2V2ZW50X3NjaGVkX2luLmlzcmEuNzArMHg0
Ny8weDRiClsgICAxNC4zMDAwNTBdICBbPDgxMDgzMzhkPl0gX19wZXJmX2luc3RhbGxfaW5f
Y29udGV4dCsweDhiLzB4YTMKWyAgIDE0LjMwMDA1MF0gIFs8ODEwN2YzMTM+XSA/IHBlcmZf
bW1hcF9mYXVsdCsweGUyLzB4ZTIKWyAgIDE0LjMwMDA1MF0gIFs8ODEwN2YzMjU+XSByZW1v
dGVfZnVuY3Rpb24rMHgxMi8weDJhClsgICAxNC4zMDAwNTBdICBbPDgxMDVmZDQ5Pl0gc21w
X2NhbGxfZnVuY3Rpb25fc2luZ2xlKzB4MmQvMHg1MwpbICAgMTQuMzAwMDUwXSAgWzw4MTA3
ZTkxND5dIHRhc2tfZnVuY3Rpb25fY2FsbCsweDMwLzB4MzYKWyAgIDE0LjMwMDA1MF0gIFs8
ODEwODMzMDI+XSA/IHBlcmZfY3B1X2hydGltZXJfaGFuZGxlcisweDEwZS8weDEwZQpbICAg
MTQuMzAwMDUwXSAgWzw4MTA4MDMxOT5dIHBlcmZfaW5zdGFsbF9pbl9jb250ZXh0KzB4ODcv
MHhiYgpbICAgMTQuMzAwMDUwXSAgWzw4MTA4NWE1ZD5dIFNZU0NfcGVyZl9ldmVudF9vcGVu
KzB4NWM2LzB4NzAxClsgICAxNC4zMDAwNTBdICBbPDgxMDFiMzAwPl0gPyBfX2RvX3BhZ2Vf
ZmF1bHQrMHgxZWUvMHgzMTQKWyAgIDE0LjMwMDA1MF0gIFs8ODEwODVlOGQ+XSBTeVNfcGVy
Zl9ldmVudF9vcGVuKzB4MTcvMHgxOQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTItMDcz
MS9iMjBkY2FiOWQ0NTg5ZWY5OTE4YTEzYzg4OGM1NDkzOTQ1YWRmYzEzL2RtZXNnLXF1YW50
YWwtaXZiNDMtMjE6MjAxNDA4MDEwMjIxNDI6aTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxOjoK
MzU6MToxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA4LTAxIDAy
OjEzOjU2IFJFUEVBVCBDT1VOVDogMzAwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2Jq
LWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA3MjI2IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMyBzdGVwcykKWzNmMTdlYTZkZWE4YmE1NjY4
ODczYWZhNTQ2MjhhOTFhYWEzZmIxYzBdIE1lcmdlIGJyYW5jaCAnbmV4dCcgKGFjY3VtdWxh
dGVkIDMuMTYgbWVyZ2Ugd2luZG93IHBhdGNoZXMpIGludG8gbWFzdGVyCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2Vj
dC9saW51eC0yL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS9rdm1hcm06bmV4dDozZjE3ZWE2ZGVhOGJhNTY2
ODg3M2FmYTU0NjI4YTkxYWFhM2ZiMWMwOmJpc2VjdC1saW51eC0yCgoyMDE0LTA4LTAxLTAy
OjEzOjU3IDNmMTdlYTZkZWE4YmE1NjY4ODczYWZhNTQ2MjhhOTFhYWEzZmIxYzAgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLWhhMi0wNzMxLTNmMTdlYTZkZWE4YmE1NjY4ODczYWZhNTQ2MjhhOTFh
YWEzZmIxYzAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1o
YTItMDczMS8zZjE3ZWE2ZGVhOGJhNTY2ODg3M2FmYTU0NjI4YTkxYWFhM2ZiMWMwCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJh
bmRjb25maWctaGEyLTA3MzEtM2YxN2VhNmRlYThiYTU2Njg4NzNhZmE1NDYyOGE5MWFhYTNm
YjFjMAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLzNmMTdlYTZk
ZWE4YmE1NjY4ODczYWZhNTQ2MjhhOTFhYWEzZmIxYzAvdm1saW51ei0zLjE1LjAtMDcyMTgt
ZzNmMTdlYTYKCjIwMTQtMDgtMDEtMDI6MTY6MDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEJ
MTgJMjcJMzEJNDIJNDgJNTggVEVTVCBGQUlMVVJFClsgICAgMi40ODM4MDBdIHRzYzogUmVm
aW5lZCBUU0MgY2xvY2tzb3VyY2UgY2FsaWJyYXRpb246IDI2OTMuNTA5IE1IegpbICAgMTIu
Nzc4ODY2XSBzb2NrOiBwcm9jZXNzIGB0cmluaXR5LW1haW4nIGlzIHVzaW5nIG9ic29sZXRl
IHNldHNvY2tvcHQgU09fQlNEQ09NUEFUCgpCVUc6IGtlcm5lbCBib290IGhhbmcKRWxhcHNl
ZCB0aW1lOiAzNQpxZW11LXN5c3RlbS14ODZfNjQgLWVuYWJsZS1rdm0gLWNwdSBIYXN3ZWxs
LCtzbWVwLCtzbWFwIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEv
M2YxN2VhNmRlYThiYTU2Njg4NzNhZmE1NDYyOGE5MWFhYTNmYjFjMC92bWxpbnV6LTMuMTUu
MC0wNzIxOC1nM2YxN2VhNiAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50
az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCBy
Y3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2NrdXBf
cGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10
dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3
IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTIt
MDczMS9rdm1hcm06bmV4dDozZjE3ZWE2ZGVhOGJhNTY2ODg3M2FmYTU0NjI4YTkxYWFhM2Zi
MWMwOmJpc2VjdC1saW51eC0yLy52bWxpbnV6LTNmMTdlYTZkZWE4YmE1NjY4ODczYWZhNTQ2
MjhhOTFhYWEzZmIxYzAtMjAxNDA4MDExMDE1MzAtMTIta2J1aWxkIGJyYW5jaD1rdm1hcm0v
bmV4dCBCT09UX0lNQUdFPS9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLzNmMTdl
YTZkZWE4YmE1NjY4ODczYWZhNTQ2MjhhOTFhYWEzZmIxYzAvdm1saW51ei0zLjE1LjAtMDcy
MTgtZzNmMTdlYTYgZHJiZC5taW5vcl9jb3VudD04JyAgLWluaXRyZCAva2VybmVsLXRlc3Rz
L2luaXRyZC9xdWFudGFsLWNvcmUtaTM4Ni5jZ3ogLW0gMzIwIC1zbXAgMiAtbmV0IG5pYyx2
bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSAtYm9vdCBvcmRlcj1uYyAtbm8t
cmVib290IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1waWRmaWxl
IC9kZXYvc2htL2tib290L3BpZC1xdWFudGFsLWtidWlsZC0xOCAtc2VyaWFsIGZpbGU6L2Rl
di9zaG0va2Jvb3Qvc2VyaWFsLXF1YW50YWwta2J1aWxkLTE4IC1kYWVtb25pemUgLWRpc3Bs
YXkgbm9uZSAtbW9uaXRvciBudWxsIAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTItMDcz
MS8zZjE3ZWE2ZGVhOGJhNTY2ODg3M2FmYTU0NjI4YTkxYWFhM2ZiMWMwL2RtZXNnLXlvY3Rv
LWtidWlsZC0xOToyMDE0MDgwMTAyMTcyNzppMzg2LXJhbmRjb25maWctaGEyLTA3MzE6My4x
NS4wLTA3MjE4LWczZjE3ZWE2OjIKNTU6MTo0IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
ChtbMTszNW0yMDE0LTA4LTAxIDAyOjE5OjQ1IFJFUEVBVCBDT1VOVDogMzAwICAjIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4LTIvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKbGluZWFyLWJpc2Vj
dDogYmFkIGJyYW5jaCBtYXkgYmUgYnJhbmNoICduZXh0JyAoYWNjdW11bGF0ZWQgMy4xNiBt
ZXJnZSB3aW5kb3cgcGF0Y2hlcykKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0
IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IDNmMTdlYTZkZWE4YmE1
NjY4ODczYWZhNTQ2MjhhOTFhYWEzZmIxYzAgMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFl
ZGRmZmU1YWZkOWQwZCAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAzZjE3ZWE2Li4u
IE1lcmdlIGJyYW5jaCAnbmV4dCcgKGFjY3VtdWxhdGVkIDMuMTYgbWVyZ2Ugd2luZG93IHBh
dGNoZXMpIGludG8gbWFzdGVyCkhFQUQgaXMgbm93IGF0IDNmM2EwMTkuLi4gTWVyZ2UgYnJh
bmNoICdha3BtL21hc3RlcicKQmlzZWN0aW5nOiAzNjM0IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMiBzdGVwcykKWzQ5ZWI3YjA3NTBkOTQ4M2M3NGU5
YzE0YWU2ZWExZTlkNjI0ODFjM2NdIE1lcmdlIHRhZyAndHR5LTMuMTYtcmMxJyBvZiBnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZ3JlZ2toL3R0eSBp
bnRvIG5leHQKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0yL29i
ai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2JqLWJpc2VjdApscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxL2t2bWFybTpu
ZXh0OjQ5ZWI3YjA3NTBkOTQ4M2M3NGU5YzE0YWU2ZWExZTlkNjI0ODFjM2M6YmlzZWN0LWxp
bnV4LTIKCjIwMTQtMDgtMDEtMDI6MjA6MDAgNDllYjdiMDc1MGQ5NDgzYzc0ZTljMTRhZTZl
YTFlOWQ2MjQ4MWMzYyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEtNDllYjdiMDc1MGQ5
NDgzYzc0ZTljMTRhZTZlYTFlOWQ2MjQ4MWMzYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLzQ5ZWI3YjA3NTBkOTQ4M2M3NGU5YzE0YWU2
ZWExZTlkNjI0ODFjM2MKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS00OWViN2IwNzUwZDk0ODNj
NzRlOWMxNGFlNmVhMWU5ZDYyNDgxYzNjCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaGEyLTA3MzEvNDllYjdiMDc1MGQ5NDgzYzc0ZTljMTRhZTZlYTFlOWQ2MjQ4MWMzYy92
bWxpbnV6LTMuMTUuMC1yYzgtMDM1ODMtZzQ5ZWI3YjAKCjIwMTQtMDgtMDEtMDI6MjI6MDAg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEJMTcJMzEJMzMJNDAJNTEJNTYuCTY4CTcxCTgxCTkw
CTk3CTEwMwkxMDkJMTE0Li4JMTcyCTE3OAkyMDUJMjI4CTI0MwkyNjkuCTI4OAkzMDAgU1VD
Q0VTUwoKQmlzZWN0aW5nOiAyMDYwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxMSBzdGVwcykKWzE1YjU4ODMwMzE1NWIyMmVkZDU1OTY3MjkwNWRiOGU1
OWE0NGVmOWFdIE1lcmdlIHRhZyAnZmJkZXYtb21hcC0zLjE2JyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9tYmEvbGludXggaW50byBuZXh0
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
Yy9ib290LWJpc2VjdC9saW51eC0yL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS9rdm1hcm06bmV4dDoxNWI1
ODgzMDMxNTViMjJlZGQ1NTk2NzI5MDVkYjhlNTlhNDRlZjlhOmJpc2VjdC1saW51eC0yCgoy
MDE0LTA4LTAxLTAyOjM1OjMyIDE1YjU4ODMwMzE1NWIyMmVkZDU1OTY3MjkwNWRiOGU1OWE0
NGVmOWEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLTE1YjU4ODMwMzE1NWIyMmVkZDU1
OTY3MjkwNWRiOGU1OWE0NGVmOWEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1oYTItMDczMS8xNWI1ODgzMDMxNTViMjJlZGQ1NTk2NzI5MDVkYjhlNTlh
NDRlZjlhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEtMTViNTg4MzAzMTU1YjIyZWRkNTU5Njcy
OTA1ZGI4ZTU5YTQ0ZWY5YQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvbGtwLWhzeDAxLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1oYTIt
MDczMS0xNWI1ODgzMDMxNTViMjJlZGQ1NTk2NzI5MDVkYjhlNTlhNDRlZjlhCmtlcm5lbDog
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvMTViNTg4MzAzMTU1YjIyZWRkNTU5
NjcyOTA1ZGI4ZTU5YTQ0ZWY5YS92bWxpbnV6LTMuMTUuMC1yYzgtMDUxNjEtZzE1YjU4ODMK
CjIwMTQtMDgtMDEtMDI6NDc6MzIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMTA1CTE2OAkx
NzUuCTI3NQkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMDk1IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKW2QwOWNjMzY1OWRiNDk0YWNh
NGIzYmIyMzkzYzUzM2ZiNDk0NmI3OTRdIE1lcmdlIGJyYW5jaCAnaXJxLWNvcmUtZm9yLWxp
bnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQv
dGlwL3RpcCBpbnRvIG5leHQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2JqLWJpc2VjdApscyAt
YSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMx
L2t2bWFybTpuZXh0OmQwOWNjMzY1OWRiNDk0YWNhNGIzYmIyMzkzYzUzM2ZiNDk0NmI3OTQ6
YmlzZWN0LWxpbnV4LTIKCjIwMTQtMDgtMDEtMDI6NTE6MzkgZDA5Y2MzNjU5ZGI0OTRhY2E0
YjNiYjIzOTNjNTMzZmI0OTQ2Yjc5NCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEtZDA5
Y2MzNjU5ZGI0OTRhY2E0YjNiYjIzOTNjNTMzZmI0OTQ2Yjc5NApDaGVjayBmb3Iga2VybmVs
IGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxL2QwOWNjMzY1OWRiNDk0YWNh
NGIzYmIyMzkzYzUzM2ZiNDk0NmI3OTQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS1kMDljYzM2
NTlkYjQ5NGFjYTRiM2JiMjM5M2M1MzNmYjQ5NDZiNzk0CndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIvaTM4
Ni1yYW5kY29uZmlnLWhhMi0wNzMxLWQwOWNjMzY1OWRiNDk0YWNhNGIzYmIyMzkzYzUzM2Zi
NDk0NmI3OTQKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS9kMDlj
YzM2NTlkYjQ5NGFjYTRiM2JiMjM5M2M1MzNmYjQ5NDZiNzk0L3ZtbGludXotMy4xNS4wLXJj
OC0wNjEyOS1nZDA5Y2MzNgoKMjAxNC0wOC0wMS0wMzowMjozOSBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuCTEJMTAJMTMJMzYJMzgJNDEJNDkJNTgJNjcJNzUJNzcJOTAJMTAzCTExMQkxMjUu
CTEyOQkxNDYJMTUxCTE3OQkxODMJMjAyCTIxMwkyMTUJMjM1LgkyMzgJMjQ5CTI2MQkyNzQJ
Mjg0CTI5NgkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA1NDQgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpCltjYzA3YWFiYzUzOTc4YWUwOWEx
ZDUzOTIzNzE4OWY3Yzk4NDEwNjBhXSBNZXJnZSB0YWcgJ2FybTY0LXVwc3RyZWFtJyBvZiBn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYXJtNjQvbGlu
dXggaW50byBuZXh0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0yL29iai1iaXNlY3QKbHMgLWEgL2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS9rdm1h
cm06bmV4dDpjYzA3YWFiYzUzOTc4YWUwOWExZDUzOTIzNzE4OWY3Yzk4NDEwNjBhOmJpc2Vj
dC1saW51eC0yCgoyMDE0LTA4LTAxLTAzOjIwOjAwIGNjMDdhYWJjNTM5NzhhZTA5YTFkNTM5
MjM3MTg5ZjdjOTg0MTA2MGEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLWNjMDdhYWJj
NTM5NzhhZTA5YTFkNTM5MjM3MTg5ZjdjOTg0MTA2MGEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS9jYzA3YWFiYzUzOTc4YWUwOWExZDUz
OTIzNzE4OWY3Yzk4NDEwNjBhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEtY2MwN2FhYmM1Mzk3
OGFlMDlhMWQ1MzkyMzcxODlmN2M5ODQxMDYwYQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWhhMi0wNzMxL2NjMDdhYWJjNTM5NzhhZTA5YTFkNTM5MjM3MTg5ZjdjOTg0MTA2
MGEvdm1saW51ei0zLjE1LjAtcmM4LTA2NjE1LWdjYzA3YWFiCgoyMDE0LTA4LTAxLTAzOjI4
OjAwIGRldGVjdGluZyBib290IHN0YXRlIC4uCTIJMTQJMTYJMjEJMjguCTM0CTQ2CTQ4CTUx
CTYyCTYzCTY1CTY2Li4gVEVTVCBGQUlMVVJFClsgICAxOC41MTQzNzhdIENFOiBocGV0IGlu
Y3JlYXNlZCBtaW5fZGVsdGFfbnMgdG8gNTAwMCBuc2VjClsgICAxOC41MTQzNzhdIApbICAg
MTguNTE0Mzc4XSA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0KWyAgIDE4LjUxNDM3OF0gWyBJTkZPOiBwb3NzaWJsZSBjaXJjdWxhciBs
b2NraW5nIGRlcGVuZGVuY3kgZGV0ZWN0ZWQgXQpbICAgMTguNTE0Mzc4XSAzLjE1LjAtcmM4
LTA2NjE1LWdjYzA3YWFiICM0MyBOb3QgdGFpbnRlZApbICAgMTguNTE0Mzc4XSAtLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAx
OC41MTQzNzhdIHRyaW5pdHktbWFpbi83NCBpcyB0cnlpbmcgdG8gYWNxdWlyZSBsb2NrOgpb
ICAgMTguNTE0Mzc4XSAgKCZwb3J0X2xvY2tfa2V5KXstLi4uLi59LCBhdDogWzw4MTFjNjc2
ZD5dIHNlcmlhbDgyNTBfY29uc29sZV93cml0ZSsweDhjLzB4MTBjClsgICAxOC41MTQzNzhd
IApbICAgMTguNTE0Mzc4XSBidXQgdGFzayBpcyBhbHJlYWR5IGhvbGRpbmcgbG9jazoKWyAg
IDE4LjUxNDM3OF0gIChocnRpbWVyX2Jhc2VzLmxvY2spey0uLS4uLn0sIGF0OiBbPDgxMDNk
MGUzPl0gaHJ0aW1lcl90cnlfdG9fY2FuY2VsKzB4MTMvMHg2NgpbICAgMTguNTE0Mzc4XSAK
WyAgIDE4LjUxNDM3OF0gd2hpY2ggbG9jayBhbHJlYWR5IGRlcGVuZHMgb24gdGhlIG5ldyBs
b2NrLgpbICAgMTguNTE0Mzc4XSAKWyAgIDE4LjUxNDM3OF0gClsgICAxOC41MTQzNzhdIHRo
ZSBleGlzdGluZyBkZXBlbmRlbmN5IGNoYWluIChpbiByZXZlcnNlIG9yZGVyKSBpczoKWyAg
IDE4LjUxNDM3OF0gClsgICAxOC41MTQzNzhdIC0+ICM1IChocnRpbWVyX2Jhc2VzLmxvY2sp
ey0uLS4uLn06ClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMDRhZjNhPl0gbG9ja19hY3F1
aXJlKzB4OTIvMHgxMDEKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODE0MzExOGQ+XSBfcmF3
X3NwaW5fbG9ja19pcnFzYXZlKzB4MmUvMHgzZQpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4
MTAzY2YxMD5dIF9faHJ0aW1lcl9zdGFydF9yYW5nZV9ucysweDFjLzB4MTk3ClsgICAxOC41
MTQzNzhdICAgICAgICBbPDgxMDdmMWMwPl0gcGVyZl9zd2V2ZW50X3N0YXJ0X2hydGltZXIu
cGFydC40MSsweDdhLzB4ODUKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODEwN2YxZmM+XSBj
cHVfY2xvY2tfZXZlbnRfc3RhcnQrMHgzMS8weDM2ClsgICAxOC41MTQzNzhdICAgICAgICBb
PDgxMDdmMjBlPl0gY3B1X2Nsb2NrX2V2ZW50X2FkZCsweGQvMHgxNApbICAgMTguNTE0Mzc4
XSAgICAgICAgWzw4MTA4MmIzYT5dIGV2ZW50X3NjaGVkX2luKzB4YjYvMHgxN2EKWyAgIDE4
LjUxNDM3OF0gICAgICAgIFs8ODEwODJjNDI+XSBncm91cF9zY2hlZF9pbisweDQ0LzB4MTIy
ClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMDgyZTI1Pl0gY3R4X3NjaGVkX2luLmlzcmEu
NjcrMHgxMDUvMHgxMWYKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODEwODJlODY+XSBwZXJm
X2V2ZW50X3NjaGVkX2luLmlzcmEuNzArMHg0Ny8weDRiClsgICAxOC41MTQzNzhdICAgICAg
ICBbPDgxMDgzMTk2Pl0gX19wZXJmX2luc3RhbGxfaW5fY29udGV4dCsweDhiLzB4YTMKWyAg
IDE4LjUxNDM3OF0gICAgICAgIFs8ODEwN2YxMmU+XSByZW1vdGVfZnVuY3Rpb24rMHgxMi8w
eDJhClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMDVmYjRmPl0gc21wX2NhbGxfZnVuY3Rp
b25fc2luZ2xlKzB4MmQvMHg1MwpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTA3ZTcxZD5d
IHRhc2tfZnVuY3Rpb25fY2FsbCsweDMwLzB4MzYKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8
ODEwODAxMjI+XSBwZXJmX2luc3RhbGxfaW5fY29udGV4dCsweDg3LzB4YmIKWyAgIDE4LjUx
NDM3OF0gICAgICAgIFs8ODEwODU4Njk+XSBTWVNDX3BlcmZfZXZlbnRfb3BlbisweDVjNi8w
eDcwMQpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTA4NWM5OT5dIFN5U19wZXJmX2V2ZW50
X29wZW4rMHgxNy8weDE5ClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxNDMxOTVlPl0gc3lz
Y2FsbF9jYWxsKzB4Ny8weGIKWyAgIDE4LjUxNDM3OF0gClsgICAxOC41MTQzNzhdIC0+ICM0
ICgmY3R4LT5sb2NrKXsuLi4uLi59OgpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTA0YWYz
YT5dIGxvY2tfYWNxdWlyZSsweDkyLzB4MTAxClsgICAxOC41MTQzNzhdICAgICAgICBbPDgx
NDMxMGJjPl0gX3Jhd19zcGluX2xvY2srMHgyMS8weDMwClsgICAxOC41MTQzNzhdICAgICAg
ICBbPDgxMDgyMzkzPl0gX19wZXJmX2V2ZW50X3Rhc2tfc2NoZWRfb3V0KzB4MWRjLzB4MzRm
ClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxNDJlYjNjPl0gX19zY2hlZHVsZSsweDRjNi8w
eDRjYgpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTQyZWI1MD5dIHNjaGVkdWxlKzB4Zi8w
eDExClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxNDMxOWI2Pl0gd29ya19yZXNjaGVkKzB4
NS8weDJjClsgICAxOC41MTQzNzhdIApbICAgMTguNTE0Mzc4XSAtPiAjMyAoJnJxLT5sb2Nr
KXstLi0uLS59OgpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTA0YWYzYT5dIGxvY2tfYWNx
dWlyZSsweDkyLzB4MTAxClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxNDMxMGJjPl0gX3Jh
d19zcGluX2xvY2srMHgyMS8weDMwClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMDQwZTZi
Pl0gX190YXNrX3JxX2xvY2srMHgzMy8weDNhClsgICAxOC41MTQzNzhdICAgICAgICBbPDgx
MDQxZTQ0Pl0gd2FrZV91cF9uZXdfdGFzaysweDI1LzB4YzIKWyAgIDE4LjUxNDM3OF0gICAg
ICAgIFs8ODEwMjRkNDM+XSBkb19mb3JrKzB4MTVjLzB4MmEwClsgICAxOC41MTQzNzhdICAg
ICAgICBbPDgxMDI0ZWExPl0ga2VybmVsX3RocmVhZCsweDFhLzB4MWYKWyAgIDE4LjUxNDM3
OF0gICAgICAgIFs8ODE0MjUzMzg+XSByZXN0X2luaXQrMHgxYS8weDEwZQpbICAgMTguNTE0
Mzc4XSAgICAgICAgWzw4MTdiNDllMj5dIHN0YXJ0X2tlcm5lbCsweDMwMy8weDMwOApbICAg
MTguNTE0Mzc4XSAgICAgICAgWzw4MTdiNDJhYj5dIGkzODZfc3RhcnRfa2VybmVsKzB4Nzkv
MHg3ZApbICAgMTguNTE0Mzc4XSAKWyAgIDE4LjUxNDM3OF0gLT4gIzIgKCZwLT5waV9sb2Nr
KXstLi0uLi59OgpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTA0YWYzYT5dIGxvY2tfYWNx
dWlyZSsweDkyLzB4MTAxClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxNDMxMThkPl0gX3Jh
d19zcGluX2xvY2tfaXJxc2F2ZSsweDJlLzB4M2UKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8
ODEwNDE5ZDU+XSB0cnlfdG9fd2FrZV91cCsweDFkLzB4ZDYKWyAgIDE4LjUxNDM3OF0gICAg
ICAgIFs8ODEwNDFhYzU+XSBkZWZhdWx0X3dha2VfZnVuY3Rpb24rMHhiLzB4ZApbICAgMTgu
NTE0Mzc4XSAgICAgICAgWzw4MTA0NjdlYj5dIF9fd2FrZV91cF9jb21tb24rMHgzOS8weDU5
ClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMDQ2OTNlPl0gX193YWtlX3VwKzB4MjkvMHgz
YgpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTFiOGRlMj5dIHR0eV93YWtldXArMHg0OS8w
eDUxClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMWMzYzE3Pl0gdWFydF93cml0ZV93YWtl
dXArMHgxNy8weDE5ClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMWM2NDcwPl0gc2VyaWFs
ODI1MF90eF9jaGFycysweGJjLzB4ZmIKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODExYzY1
ZDc+XSBzZXJpYWw4MjUwX2hhbmRsZV9pcnErMHg1NC8weDZhClsgICAxOC41MTQzNzhdICAg
ICAgICBbPDgxMWM2NjA2Pl0gc2VyaWFsODI1MF9kZWZhdWx0X2hhbmRsZV9pcnErMHgxOS8w
eDFjClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMWM1ZDg3Pl0gc2VyaWFsODI1MF9pbnRl
cnJ1cHQrMHgzOC8weDllClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMDUxNjUyPl0gaGFu
ZGxlX2lycV9ldmVudF9wZXJjcHUrMHg1Zi8weDFlMgpbICAgMTguNTE0Mzc4XSAgICAgICAg
Wzw4MTA1MTgwMT5dIGhhbmRsZV9pcnFfZXZlbnQrMHgyYy8weDQzClsgICAxOC41MTQzNzhd
ICAgICAgICBbPDgxMDUzMjg4Pl0gaGFuZGxlX2xldmVsX2lycSsweDU3LzB4ODMKWyAgIDE4
LjUxNDM3OF0gICAgICAgIFs8ODEwMDJjY2U+XSBoYW5kbGVfaXJxKzB4NDYvMHg1YwpbICAg
MTguNTE0Mzc4XSAgICAgICAgWzw4MTAwMmEzYj5dIGRvX0lSUSsweDMyLzB4ODkKWyAgIDE4
LjUxNDM3OF0gICAgICAgIFs8ODE0MzIyYWU+XSBjb21tb25faW50ZXJydXB0KzB4MmUvMHgz
MwpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTQzMTJhYz5dIF9yYXdfc3Bpbl91bmxvY2tf
aXJxcmVzdG9yZSsweDNmLzB4NDkKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODExYzJjNTM+
XSB1YXJ0X3N0YXJ0KzB4MmQvMHgzMgpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTFjMzJi
Mz5dIHVhcnRfd3JpdGUrMHhjNy8weGQ2ClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMWJj
ZGE1Pl0gbl90dHlfd3JpdGUrMHhiOC8weDM1ZQpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4
MTFiYTI5YT5dIHR0eV93cml0ZSsweDE2My8weDFlNApbICAgMTguNTE0Mzc4XSAgICAgICAg
Wzw4MTFiYTM4OD5dIHJlZGlyZWN0ZWRfdHR5X3dyaXRlKzB4NmQvMHg3NQpbICAgMTguNTE0
Mzc4XSAgICAgICAgWzw4MTBiNzRiMj5dIHZmc193cml0ZSsweDc1LzB4YjAKWyAgIDE4LjUx
NDM3OF0gICAgICAgIFs8ODEwYjc4NDE+XSBTeVNfd3JpdGUrMHg0NC8weDc3ClsgICAxOC41
MTQzNzhdICAgICAgICBbPDgxNDMxOTVlPl0gc3lzY2FsbF9jYWxsKzB4Ny8weGIKWyAgIDE4
LjUxNDM3OF0gClsgICAxOC41MTQzNzhdIC0+ICMxICgmdHR5LT53cml0ZV93YWl0KXstLi4u
Li59OgpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTA0YWYzYT5dIGxvY2tfYWNxdWlyZSsw
eDkyLzB4MTAxClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxNDMxMThkPl0gX3Jhd19zcGlu
X2xvY2tfaXJxc2F2ZSsweDJlLzB4M2UKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODEwNDY5
MmE+XSBfX3dha2VfdXArMHgxNS8weDNiClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMWI4
ZGUyPl0gdHR5X3dha2V1cCsweDQ5LzB4NTEKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODEx
YzNjMTc+XSB1YXJ0X3dyaXRlX3dha2V1cCsweDE3LzB4MTkKWyAgIDE4LjUxNDM3OF0gICAg
ICAgIFs8ODExYzY0NzA+XSBzZXJpYWw4MjUwX3R4X2NoYXJzKzB4YmMvMHhmYgpbICAgMTgu
NTE0Mzc4XSAgICAgICAgWzw4MTFjNjVkNz5dIHNlcmlhbDgyNTBfaGFuZGxlX2lycSsweDU0
LzB4NmEKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODExYzY2MDY+XSBzZXJpYWw4MjUwX2Rl
ZmF1bHRfaGFuZGxlX2lycSsweDE5LzB4MWMKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODEx
YzVkODc+XSBzZXJpYWw4MjUwX2ludGVycnVwdCsweDM4LzB4OWUKWyAgIDE4LjUxNDM3OF0g
ICAgICAgIFs8ODEwNTE2NTI+XSBoYW5kbGVfaXJxX2V2ZW50X3BlcmNwdSsweDVmLzB4MWUy
ClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMDUxODAxPl0gaGFuZGxlX2lycV9ldmVudCsw
eDJjLzB4NDMKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODEwNTMyODg+XSBoYW5kbGVfbGV2
ZWxfaXJxKzB4NTcvMHg4MwpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTAwMmNjZT5dIGhh
bmRsZV9pcnErMHg0Ni8weDVjClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMDAyYTNiPl0g
ZG9fSVJRKzB4MzIvMHg4OQpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTQzMjJhZT5dIGNv
bW1vbl9pbnRlcnJ1cHQrMHgyZS8weDMzClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxNDMx
MmFjPl0gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4M2YvMHg0OQpbICAgMTguNTE0
Mzc4XSAgICAgICAgWzw4MTFjMmM1Mz5dIHVhcnRfc3RhcnQrMHgyZC8weDMyClsgICAxOC41
MTQzNzhdICAgICAgICBbPDgxMWMzMmIzPl0gdWFydF93cml0ZSsweGM3LzB4ZDYKWyAgIDE4
LjUxNDM3OF0gICAgICAgIFs8ODExYmNkYTU+XSBuX3R0eV93cml0ZSsweGI4LzB4MzVlClsg
ICAxOC41MTQzNzhdICAgICAgICBbPDgxMWJhMjlhPl0gdHR5X3dyaXRlKzB4MTYzLzB4MWU0
ClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMWJhMzg4Pl0gcmVkaXJlY3RlZF90dHlfd3Jp
dGUrMHg2ZC8weDc1ClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMGI3NGIyPl0gdmZzX3dy
aXRlKzB4NzUvMHhiMApbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTBiNzg0MT5dIFN5U193
cml0ZSsweDQ0LzB4NzcKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODE0MzE5NWU+XSBzeXNj
YWxsX2NhbGwrMHg3LzB4YgpbICAgMTguNTE0Mzc4XSAKWyAgIDE4LjUxNDM3OF0gLT4gIzAg
KCZwb3J0X2xvY2tfa2V5KXstLi4uLi59OgpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTA0
YWMyNT5dIF9fbG9ja19hY3F1aXJlKzB4OWVhLzB4YzZkClsgICAxOC41MTQzNzhdICAgICAg
ICBbPDgxMDRhZjNhPl0gbG9ja19hY3F1aXJlKzB4OTIvMHgxMDEKWyAgIDE4LjUxNDM3OF0g
ICAgICAgIFs8ODE0MzExOGQ+XSBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4MmUvMHgzZQpb
ICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTFjNjc2ZD5dIHNlcmlhbDgyNTBfY29uc29sZV93
cml0ZSsweDhjLzB4MTBjClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMDRlOWVmPl0gY2Fs
bF9jb25zb2xlX2RyaXZlcnMuY29uc3Rwcm9wLjMxKzB4ODcvMHgxMTgKWyAgIDE4LjUxNDM3
OF0gICAgICAgIFs8ODEwNGZiY2M+XSBjb25zb2xlX3VubG9jaysweDFlMS8weDNkMwpbICAg
MTguNTE0Mzc4XSAgICAgICAgWzw4MTA1MDFkNT5dIHZwcmludGtfZW1pdCsweDQxNy8weDQy
MQpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTQyODAwYz5dIHByaW50aysweDE3LzB4MTkK
WyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODEwNWM1NDA+XSBjbG9ja2V2ZW50c19wcm9ncmFt
X21pbl9kZWx0YSsweDEwNC8weDExNgpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTA1Y2Fl
OD5dIGNsb2NrZXZlbnRzX3Byb2dyYW1fZXZlbnQrMHhlNy8weGYzClsgICAxOC41MTQzNzhd
ICAgICAgICBbPDgxMDVkMWJjPl0gdGlja19wcm9ncmFtX2V2ZW50KzB4MWUvMHgyMwpbICAg
MTguNTE0Mzc4XSAgICAgICAgWzw4MTAzY2EzND5dIGhydGltZXJfZm9yY2VfcmVwcm9ncmFt
KzB4ODgvMHg4ZgpbICAgMTguNTE0Mzc4XSAgICAgICAgWzw4MTAzY2E5Nj5dIF9fcmVtb3Zl
X2hydGltZXIrMHg1Yi8weDc5ClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMDNkMTE5Pl0g
aHJ0aW1lcl90cnlfdG9fY2FuY2VsKzB4NDkvMHg2NgpbICAgMTguNTE0Mzc4XSAgICAgICAg
Wzw4MTAzZDE0Mz5dIGhydGltZXJfY2FuY2VsKzB4ZC8weDE4ClsgICAxOC41MTQzNzhdICAg
ICAgICBbPDgxMDdmNmEyPl0gcGVyZl9zd2V2ZW50X2NhbmNlbF9ocnRpbWVyLnBhcnQuNjAr
MHgyYi8weDMwClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMDdmNmM3Pl0gY3B1X2Nsb2Nr
X2V2ZW50X3N0b3ArMHgyMC8weDU3ClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxMDdmNzA2
Pl0gY3B1X2Nsb2NrX2V2ZW50X2RlbCsweDgvMHhhClsgICAxOC41MTQzNzhdICAgICAgICBb
PDgxMDgxOGYwPl0gZXZlbnRfc2NoZWRfb3V0KzB4YWIvMHgxMWUKWyAgIDE4LjUxNDM3OF0g
ICAgICAgIFs8ODEwODE5ODA+XSBncm91cF9zY2hlZF9vdXQrMHgxZC8weDY2ClsgICAxOC41
MTQzNzhdICAgICAgICBbPDgxMDgxYzIyPl0gY3R4X3NjaGVkX291dCsweGFmLzB4YmYKWyAg
IDE4LjUxNDM3OF0gICAgICAgIFs8ODEwODIzYTQ+XSBfX3BlcmZfZXZlbnRfdGFza19zY2hl
ZF9vdXQrMHgxZWQvMHgzNGYKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODE0MmViM2M+XSBf
X3NjaGVkdWxlKzB4NGM2LzB4NGNiClsgICAxOC41MTQzNzhdICAgICAgICBbPDgxNDJlYjUw
Pl0gc2NoZWR1bGUrMHhmLzB4MTEKWyAgIDE4LjUxNDM3OF0gICAgICAgIFs8ODE0MzE5YjY+
XSB3b3JrX3Jlc2NoZWQrMHg1LzB4MmMKWyAgIDE4LjUxNDM3OF0gClsgICAxOC41MTQzNzhd
IG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxwIHVzIGRlYnVnIHRoaXM6ClsgICAxOC41MTQz
NzhdIApbICAgMTguNTE0Mzc4XSBDaGFpbiBleGlzdHMgb2Y6ClsgICAxOC41MTQzNzhdICAg
JnBvcnRfbG9ja19rZXkgLS0+ICZjdHgtPmxvY2sgLS0+IGhydGltZXJfYmFzZXMubG9jawpb
ICAgMTguNTE0Mzc4XSAKWyAgIDE4LjUxNDM3OF0gIFBvc3NpYmxlIHVuc2FmZSBsb2NraW5n
IHNjZW5hcmlvOgpbICAgMTguNTE0Mzc4XSAKWyAgIDE4LjUxNDM3OF0gICAgICAgIENQVTAg
ICAgICAgICAgICAgICAgICAgIENQVTEKWyAgIDE4LjUxNDM3OF0gICAgICAgIC0tLS0gICAg
ICAgICAgICAgICAgICAgIC0tLS0KWyAgIDE4LjUxNDM3OF0gICBsb2NrKGhydGltZXJfYmFz
ZXMubG9jayk7ClsgICAxOC41MTQzNzhdICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBsb2NrKCZjdHgtPmxvY2spOwpbICAgMTguNTE0Mzc4XSAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgbG9jayhocnRpbWVyX2Jhc2VzLmxvY2spOwpbICAgMTguNTE0Mzc4XSAg
IGxvY2soJnBvcnRfbG9ja19rZXkpOwpbICAgMTguNTE0Mzc4XSAKWyAgIDE4LjUxNDM3OF0g
ICoqKiBERUFETE9DSyAqKioKWyAgIDE4LjUxNDM3OF0gClsgICAxOC41MTQzNzhdIDQgbG9j
a3MgaGVsZCBieSB0cmluaXR5LW1haW4vNzQ6ClsgICAxOC41MTQzNzhdICAjMDogICgmcnEt
PmxvY2spey0uLS4tLn0sIGF0OiBbPDgxNDJlNzYzPl0gX19zY2hlZHVsZSsweGVkLzB4NGNi
ClsgICAxOC41MTQzNzhdICAjMTogICgmY3R4LT5sb2NrKXsuLi4uLi59LCBhdDogWzw4MTA4
MjM5Mz5dIF9fcGVyZl9ldmVudF90YXNrX3NjaGVkX291dCsweDFkYy8weDM0ZgpbICAgMTgu
NTE0Mzc4XSAgIzI6ICAoaHJ0aW1lcl9iYXNlcy5sb2NrKXstLi0uLi59LCBhdDogWzw4MTAz
ZDBlMz5dIGhydGltZXJfdHJ5X3RvX2NhbmNlbCsweDEzLzB4NjYKWyAgIDE4LjUxNDM3OF0g
ICMzOiAgKGNvbnNvbGVfbG9jayl7Ky4rLi4ufSwgYXQ6IFs8ODEwNTAxYzI+XSB2cHJpbnRr
X2VtaXQrMHg0MDQvMHg0MjEKWyAgIDE4LjUxNDM3OF0gClsgICAxOC41MTQzNzhdIHN0YWNr
IGJhY2t0cmFjZToKWyAgIDE4LjUxNDM3OF0gQ1BVOiAwIFBJRDogNzQgQ29tbTogdHJpbml0
eS1tYWluIE5vdCB0YWludGVkIDMuMTUuMC1yYzgtMDY2MTUtZ2NjMDdhYWIgIzQzClsgICAx
OC41MTQzNzhdICAwMDAwMDAwMCA4MWM0MDFmOCA4Yjk5NWMwOCA4MTQyOGZkNSA4Yjk5NWMz
OCA4MTQyN2IyZiA4MTYyMjhkNCA4MTYyMjdkMwpbICAgMTguNTE0Mzc4XSAgODE2MjI3OWIg
ODE2MjI3YmMgODE2MjI3OWIgOGI5OTVjNmMgOGIxMGMyMTAgMDAwMDAwMDQgOGIxMGM2M2Mg
OGIxMGMyMTAKWyAgIDE4LjUxNDM3OF0gIDhiOTk1YzljIDgxMDRhYzI1IDhiMTBjNjBjIDAw
MDAxNmE2IDgxYzQwMWY4IDAwMDAwMDAxIDAwMDAwMDAxIDAwMDAwMDAzClsgICAxOC41MTQz
NzhdIENhbGwgVHJhY2U6ClsgICAxOC41MTQzNzhdICBbPDgxNDI4ZmQ1Pl0gZHVtcF9zdGFj
aysweDE2LzB4MTgKWyAgIDE4LjUxNDM3OF0gIFs8ODE0MjdiMmY+XSBwcmludF9jaXJjdWxh
cl9idWcrMHgxOGYvMHgxOWMKWyAgIDE4LjUxNDM3OF0gIFs8ODEwNGFjMjU+XSBfX2xvY2tf
YWNxdWlyZSsweDllYS8weGM2ZApbICAgMTguNTE0Mzc4XSAgWzw4MTA0YWYzYT5dIGxvY2tf
YWNxdWlyZSsweDkyLzB4MTAxClsgICAxOC41MTQzNzhdICBbPDgxMWM2NzZkPl0gPyBzZXJp
YWw4MjUwX2NvbnNvbGVfd3JpdGUrMHg4Yy8weDEwYwpbICAgMTguNTE0Mzc4XSAgWzw4MTFj
NjZlMT5dID8gd2FpdF9mb3JfeG1pdHIrMHg3Ni8weDc2ClsgICAxOC41MTQzNzhdICBbPDgx
NDMxMThkPl0gX3Jhd19zcGluX2xvY2tfaXJxc2F2ZSsweDJlLzB4M2UKWyAgIDE4LjUxNDM3
OF0gIFs8ODExYzY3NmQ+XSA/IHNlcmlhbDgyNTBfY29uc29sZV93cml0ZSsweDhjLzB4MTBj
ClsgICAxOC41MTQzNzhdICBbPDgxMWM2NzZkPl0gc2VyaWFsODI1MF9jb25zb2xlX3dyaXRl
KzB4OGMvMHgxMGMKWyAgIDE4LjUxNDM3OF0gIFs8ODEwNGI1N2Y+XSA/IGxvY2tfcmVsZWFz
ZSsweDE5MS8weDIyMwpbICAgMTguNTE0Mzc4XSAgWzw4MTFjNjZlMT5dID8gd2FpdF9mb3Jf
eG1pdHIrMHg3Ni8weDc2ClsgICAxOC41MTQzNzhdICBbPDgxMDRlOWVmPl0gY2FsbF9jb25z
b2xlX2RyaXZlcnMuY29uc3Rwcm9wLjMxKzB4ODcvMHgxMTgKWyAgIDE4LjUxNDM3OF0gIFs8
ODEwNGZiY2M+XSBjb25zb2xlX3VubG9jaysweDFlMS8weDNkMwpbICAgMTguNTE0Mzc4XSAg
Wzw4MTA1MDFkNT5dIHZwcmludGtfZW1pdCsweDQxNy8weDQyMQpbICAgMTguNTE0Mzc4XSAg
Wzw4MTQyODAwYz5dIHByaW50aysweDE3LzB4MTkKWyAgIDE4LjUxNDM3OF0gIFs8ODEwNWM1
NDA+XSBjbG9ja2V2ZW50c19wcm9ncmFtX21pbl9kZWx0YSsweDEwNC8weDExNgpbICAgMTgu
NTE0Mzc4XSAgWzw4MTA1Y2FlOD5dIGNsb2NrZXZlbnRzX3Byb2dyYW1fZXZlbnQrMHhlNy8w
eGYzClsgICAxOC41MTQzNzhdICBbPDgxMDVkMWJjPl0gdGlja19wcm9ncmFtX2V2ZW50KzB4
MWUvMHgyMwpbICAgMTguNTE0Mzc4XSAgWzw4MTAzY2EzND5dIGhydGltZXJfZm9yY2VfcmVw
cm9ncmFtKzB4ODgvMHg4ZgpbICAgMTguNTE0Mzc4XSAgWzw4MTAzY2E5Nj5dIF9fcmVtb3Zl
X2hydGltZXIrMHg1Yi8weDc5ClsgICAxOC41MTQzNzhdICBbPDgxMDNkMTE5Pl0gaHJ0aW1l
cl90cnlfdG9fY2FuY2VsKzB4NDkvMHg2NgpbICAgMTguNTE0Mzc4XSAgWzw4MTAzZDE0Mz5d
IGhydGltZXJfY2FuY2VsKzB4ZC8weDE4ClsgICAxOC41MTQzNzhdICBbPDgxMDdmNmEyPl0g
cGVyZl9zd2V2ZW50X2NhbmNlbF9ocnRpbWVyLnBhcnQuNjArMHgyYi8weDMwClsgICAxOC41
MTQzNzhdICBbPDgxMDdmNmM3Pl0gY3B1X2Nsb2NrX2V2ZW50X3N0b3ArMHgyMC8weDU3Clsg
ICAxOC41MTQzNzhdICBbPDgxMDdmNzA2Pl0gY3B1X2Nsb2NrX2V2ZW50X2RlbCsweDgvMHhh
ClsgICAxOC41MTQzNzhdICBbPDgxMDgxOGYwPl0gZXZlbnRfc2NoZWRfb3V0KzB4YWIvMHgx
MWUKWyAgIDE4LjUxNDM3OF0gIFs8ODEwODE5ODA+XSBncm91cF9zY2hlZF9vdXQrMHgxZC8w
eDY2ClsgICAxOC41MTQzNzhdICBbPDgxMDgxYzIyPl0gY3R4X3NjaGVkX291dCsweGFmLzB4
YmYKWyAgIDE4LjUxNDM3OF0gIFs8ODEwODIzYTQ+XSBfX3BlcmZfZXZlbnRfdGFza19zY2hl
ZF9vdXQrMHgxZWQvMHgzNGYKWyAgIDE4LjUxNDM3OF0gIFs8ODEwNDQ3NjU+XSA/IF9fZGVx
dWV1ZV9lbnRpdHkrMHgyMy8weDI3ClsgICAxOC41MTQzNzhdICBbPDgxMDQ0YWZkPl0gPyBw
aWNrX25leHRfdGFza19mYWlyKzB4YjEvMHgxMjAKWyAgIDE4LjUxNDM3OF0gIFs8ODE0MmVi
M2M+XSBfX3NjaGVkdWxlKzB4NGM2LzB4NGNiClsgICAxOC41MTQzNzhdICBbPDgxMDQ3YjZj
Pl0gPyB0cmFjZV9oYXJkaXJxc19vZmZfY2FsbGVyKzB4ZDcvMHgxMDgKWyAgIDE4LjUxNDM3
OF0gIFs8ODEwNDdiYTg+XSA/IHRyYWNlX2hhcmRpcnFzX29mZisweGIvMHhkClsgICAxOC41
MTQzNzhdICBbPDgxMDU2OGU2Pl0gPyByY3VfaXJxX2V4aXQrMHg2NC8weDc3Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxL2NjMDdhYWJjNTM5NzhhZTA5YTFkNTM5MjM3MTg5
ZjdjOTg0MTA2MGEvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTI6MjAxNDA4MDEwMzM0Mjc6aTM4
Ni1yYW5kY29uZmlnLWhhMi0wNzMxOjMuMTUuMC1yYzgtMDY2MTUtZ2NjMDdhYWI6NDMKNjU6
MToyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA4LTAxIDAzOjM3
OjAxIFJFUEVBVCBDT1VOVDogMzAwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2JqLWJp
c2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAyNzUgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCls4MDkxYjg5NWI3NmY2OTBhYTJmNjY4
OWI2ZWQ2MDJmMDc1MjVhOTM4XSBmcy9uY3Bmcy9nZXRvcHQuYzogcmVwbGFjZSBzaW1wbGVf
c3RydG91bCBieSBrc3RydG91bApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMi9vYmotYmlzZWN0Cmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEyLTA3
MzEva3ZtYXJtOm5leHQ6ODA5MWI4OTViNzZmNjkwYWEyZjY2ODliNmVkNjAyZjA3NTI1YTkz
ODpiaXNlY3QtbGludXgtMgoKMjAxNC0wOC0wMS0wMzozNzowMiA4MDkxYjg5NWI3NmY2OTBh
YTJmNjY4OWI2ZWQ2MDJmMDc1MjVhOTM4IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS04
MDkxYjg5NWI3NmY2OTBhYTJmNjY4OWI2ZWQ2MDJmMDc1MjVhOTM4CkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvODA5MWI4OTViNzZmNjkw
YWEyZjY2ODliNmVkNjAyZjA3NTI1YTkzOAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLTgwOTFi
ODk1Yjc2ZjY5MGFhMmY2Njg5YjZlZDYwMmYwNzUyNWE5MzgKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1pMzg2L2kzODYt
cmFuZGNvbmZpZy1oYTItMDczMS04MDkxYjg5NWI3NmY2OTBhYTJmNjY4OWI2ZWQ2MDJmMDc1
MjVhOTM4Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvODA5MWI4
OTViNzZmNjkwYWEyZjY2ODliNmVkNjAyZjA3NTI1YTkzOC92bWxpbnV6LTMuMTUuMC1yYzgt
MDU5NjgtZzgwOTFiODkKCjIwMTQtMDgtMDEtMDM6NDQ6MDIgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgLi4uLi4uCTIJMwk4CTkJMTIuCTEzCTE0CTE1CTE2CTE4CTIwLi4uLi4JMjIJMjMuLgky
NQkyNwkyOC4uLi4JMjkuCTMwLi4uCTMyCTM0CTM2Li4JMzgJNDAJNDIuLi4uLgk0NAk0NS4u
Li4uLi4uLi4JNDYuCTQ4Li4JNDkJNTEuCTU1Li4JNTYuCTU4Li4uCTYwLgk2Mgk2NAk2NS4J
NjYuCTY3CTY5Li4uLi4uLi4uLi4uLgk3MC4JNzIJNzQJNzUuCTc2Lgk3OAk3OQk4MC4JODIJ
ODMuCTg1Li4uCTg3CTkwLi4uLi4JOTIuLi4JOTMJOTUuCTk3CTk4CTEwMC4JMTAzIFRFU1Qg
RkFJTFVSRQpbbWFpbl0gMzc1IHNvY2tldHMgY3JlYXRlZCBiYXNlZCBvbiBpbmZvIGZyb20g
c29ja2V0IGNhY2hlZmlsZS4KWyAgIDEyLjM4NTIwN10gClsgICAxMi4zODUzNDhdID09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQpbICAg
MTIuMzg1ODY2XSBbIElORk86IHBvc3NpYmxlIGNpcmN1bGFyIGxvY2tpbmcgZGVwZW5kZW5j
eSBkZXRlY3RlZCBdClsgICAxMi4zODYzNzRdIDMuMTUuMC1yYzgtMDU5NjgtZzgwOTFiODkg
IzQ2IE5vdCB0YWludGVkClsgICAxMi4zODY3NzldIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KWyAgIDEyLjM4NzMxMl0gdHJpbml0
eS1tYWluLzE3MSBpcyB0cnlpbmcgdG8gYWNxdWlyZSBsb2NrOgpbICAgMTIuMzg3NzUzXSAg
KGhydGltZXJfYmFzZXMubG9jayl7LS4tLi4ufSwgYXQ6IFs8ODEwM2M5Njg+XSBfX2hydGlt
ZXJfc3RhcnRfcmFuZ2VfbnMrMHgxYy8weDE5NwpbICAgMTIuMzg4MDM1XSAKWyAgIDEyLjM4
ODAzNV0gYnV0IHRhc2sgaXMgYWxyZWFkeSBob2xkaW5nIGxvY2s6ClsgICAxMi4zODgwMzVd
ICAoJmN0eC0+bG9jayl7Li4uLi4ufSwgYXQ6IFs8ODEwN2UxMDM+XSBwZXJmX2N0eF9sb2Nr
KzB4MWEvMHgxZApbICAgMTIuMzg4MDM1XSAKWyAgIDEyLjM4ODAzNV0gd2hpY2ggbG9jayBh
bHJlYWR5IGRlcGVuZHMgb24gdGhlIG5ldyBsb2NrLgpbICAgMTIuMzg4MDM1XSAKWyAgIDEy
LjM4ODAzNV0gClsgICAxMi4zODgwMzVdIHRoZSBleGlzdGluZyBkZXBlbmRlbmN5IGNoYWlu
IChpbiByZXZlcnNlIG9yZGVyKSBpczoKWyAgIDEyLjM4ODAzNV0gCi0+ICM1ICgmY3R4LT5s
b2NrKXsuLi4uLi59OgpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTA0YTk5Mj5dIGxvY2tf
YWNxdWlyZSsweDkyLzB4MTAxClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxNDJmMTg0Pl0g
X3Jhd19zcGluX2xvY2srMHgyMS8weDMwClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDgx
ZWFkPl0gX19wZXJmX2V2ZW50X3Rhc2tfc2NoZWRfb3V0KzB4MWRjLzB4MzRmClsgICAxMi4z
ODgwMzVdICAgICAgICBbPDgxNDJjYzA0Pl0gX19zY2hlZHVsZSsweDRjNi8weDRjYgpbICAg
MTIuMzg4MDM1XSAgICAgICAgWzw4MTQyY2MxOD5dIHNjaGVkdWxlKzB4Zi8weDExClsgICAx
Mi4zODgwMzVdICAgICAgICBbPDgxNDJmYWRlPl0gd29ya19yZXNjaGVkKzB4NS8weDMwClsg
ICAxMi4zODgwMzVdIAotPiAjNCAoJnJxLT5sb2NrKXstLi0uLS59OgpbICAgMTIuMzg4MDM1
XSAgICAgICAgWzw4MTA0YTk5Mj5dIGxvY2tfYWNxdWlyZSsweDkyLzB4MTAxClsgICAxMi4z
ODgwMzVdICAgICAgICBbPDgxNDJmMTg0Pl0gX3Jhd19zcGluX2xvY2srMHgyMS8weDMwClsg
ICAxMi4zODgwMzVdICAgICAgICBbPDgxMDQwOGMzPl0gX190YXNrX3JxX2xvY2srMHgzMy8w
eDNhClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDQxODljPl0gd2FrZV91cF9uZXdfdGFz
aysweDI1LzB4YzIKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODEwMjQ3OWI+XSBkb19mb3Jr
KzB4MTVjLzB4MmEwClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDI0OGY5Pl0ga2VybmVs
X3RocmVhZCsweDFhLzB4MWYKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODE0MjM0MDI+XSBy
ZXN0X2luaXQrMHgxYS8weDEwZQpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTdhZjllMj5d
IHN0YXJ0X2tlcm5lbCsweDMwMy8weDMwOApbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTdh
ZjJhYj5dIGkzODZfc3RhcnRfa2VybmVsKzB4NzkvMHg3ZApbICAgMTIuMzg4MDM1XSAKLT4g
IzMgKCZwLT5waV9sb2NrKXstLi0uLi59OgpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTA0
YTk5Mj5dIGxvY2tfYWNxdWlyZSsweDkyLzB4MTAxClsgICAxMi4zODgwMzVdICAgICAgICBb
PDgxNDJmMjU1Pl0gX3Jhd19zcGluX2xvY2tfaXJxc2F2ZSsweDJlLzB4M2UKWyAgIDEyLjM4
ODAzNV0gICAgICAgIFs8ODEwNDE0MmQ+XSB0cnlfdG9fd2FrZV91cCsweDFkLzB4ZDYKWyAg
IDEyLjM4ODAzNV0gICAgICAgIFs8ODEwNDE1MWQ+XSBkZWZhdWx0X3dha2VfZnVuY3Rpb24r
MHhiLzB4ZApbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTA0NjI0Mz5dIF9fd2FrZV91cF9j
b21tb24rMHgzOS8weDU5ClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDQ2Mzk2Pl0gX193
YWtlX3VwKzB4MjkvMHgzYgpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTFiODg5Mz5dIHR0
eV93YWtldXArMHg0OS8weDUxClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMWMzNmM4Pl0g
dWFydF93cml0ZV93YWtldXArMHgxNy8weDE5ClsgICAxMi4zODgwMzVdICAgICAgICBbPDgx
MWM1ZjIxPl0gc2VyaWFsODI1MF90eF9jaGFycysweGJjLzB4ZmIKWyAgIDEyLjM4ODAzNV0g
ICAgICAgIFs8ODExYzYwODg+XSBzZXJpYWw4MjUwX2hhbmRsZV9pcnErMHg1NC8weDZhClsg
ICAxMi4zODgwMzVdICAgICAgICBbPDgxMWM2MGI3Pl0gc2VyaWFsODI1MF9kZWZhdWx0X2hh
bmRsZV9pcnErMHgxOS8weDFjClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMWM1ODM4Pl0g
c2VyaWFsODI1MF9pbnRlcnJ1cHQrMHgzOC8weDllClsgICAxMi4zODgwMzVdICAgICAgICBb
PDgxMDUxMWExPl0gaGFuZGxlX2lycV9ldmVudF9wZXJjcHUrMHg1Zi8weDFlMgpbICAgMTIu
Mzg4MDM1XSAgICAgICAgWzw4MTA1MTM1MD5dIGhhbmRsZV9pcnFfZXZlbnQrMHgyYy8weDQz
ClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDUyZGE4Pl0gaGFuZGxlX2xldmVsX2lycSsw
eDU3LzB4ODAKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODEwMDJhYzI+XSBoYW5kbGVfaXJx
KzB4NDYvMHg1YwpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTAwMjgyZj5dIGRvX0lSUSsw
eDMyLzB4ODkKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODE0MzA0NmU+XSBjb21tb25faW50
ZXJydXB0KzB4MmUvMHgzMwpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTQyZjM3ND5dIF9y
YXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSsweDNmLzB4NDkKWyAgIDEyLjM4ODAzNV0gICAg
ICAgIFs8ODExYzI3MDQ+XSB1YXJ0X3N0YXJ0KzB4MmQvMHgzMgpbICAgMTIuMzg4MDM1XSAg
ICAgICAgWzw4MTFjMmQ2ND5dIHVhcnRfd3JpdGUrMHhjNy8weGQ2ClsgICAxMi4zODgwMzVd
ICAgICAgICBbPDgxMWJjODU2Pl0gbl90dHlfd3JpdGUrMHhiOC8weDM1ZQpbICAgMTIuMzg4
MDM1XSAgICAgICAgWzw4MTFiOWQ0Yj5dIHR0eV93cml0ZSsweDE2My8weDFlNApbICAgMTIu
Mzg4MDM1XSAgICAgICAgWzw4MTFiOWUzOT5dIHJlZGlyZWN0ZWRfdHR5X3dyaXRlKzB4NmQv
MHg3NQpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTBiNmY5MD5dIHZmc193cml0ZSsweDc1
LzB4YjAKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODEwYjczMWY+XSBTeVNfd3JpdGUrMHg0
NC8weDc3ClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxNDJmYTI2Pl0gc3lzY2FsbF9jYWxs
KzB4Ny8weGIKWyAgIDEyLjM4ODAzNV0gCi0+ICMyICgmdHR5LT53cml0ZV93YWl0KXstLi0u
Li59OgpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTA0YTk5Mj5dIGxvY2tfYWNxdWlyZSsw
eDkyLzB4MTAxClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxNDJmMjU1Pl0gX3Jhd19zcGlu
X2xvY2tfaXJxc2F2ZSsweDJlLzB4M2UKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODEwNDYz
ODI+XSBfX3dha2VfdXArMHgxNS8weDNiClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMWI4
ODkzPl0gdHR5X3dha2V1cCsweDQ5LzB4NTEKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODEx
YzM2Yzg+XSB1YXJ0X3dyaXRlX3dha2V1cCsweDE3LzB4MTkKWyAgIDEyLjM4ODAzNV0gICAg
ICAgIFs8ODExYzVmMjE+XSBzZXJpYWw4MjUwX3R4X2NoYXJzKzB4YmMvMHhmYgpbICAgMTIu
Mzg4MDM1XSAgICAgICAgWzw4MTFjNjA4OD5dIHNlcmlhbDgyNTBfaGFuZGxlX2lycSsweDU0
LzB4NmEKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODExYzYwYjc+XSBzZXJpYWw4MjUwX2Rl
ZmF1bHRfaGFuZGxlX2lycSsweDE5LzB4MWMKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODEx
YzU4Mzg+XSBzZXJpYWw4MjUwX2ludGVycnVwdCsweDM4LzB4OWUKWyAgIDEyLjM4ODAzNV0g
ICAgICAgIFs8ODEwNTExYTE+XSBoYW5kbGVfaXJxX2V2ZW50X3BlcmNwdSsweDVmLzB4MWUy
ClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDUxMzUwPl0gaGFuZGxlX2lycV9ldmVudCsw
eDJjLzB4NDMKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODEwNTJkYTg+XSBoYW5kbGVfbGV2
ZWxfaXJxKzB4NTcvMHg4MApbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTAwMmFjMj5dIGhh
bmRsZV9pcnErMHg0Ni8weDVjClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDAyODJmPl0g
ZG9fSVJRKzB4MzIvMHg4OQpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTQzMDQ2ZT5dIGNv
bW1vbl9pbnRlcnJ1cHQrMHgyZS8weDMzClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxNDJm
Mzc0Pl0gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4M2YvMHg0OQpbICAgMTIuMzg4
MDM1XSAgICAgICAgWzw4MTFjMjcwND5dIHVhcnRfc3RhcnQrMHgyZC8weDMyClsgICAxMi4z
ODgwMzVdICAgICAgICBbPDgxMWMyZDY0Pl0gdWFydF93cml0ZSsweGM3LzB4ZDYKWyAgIDEy
LjM4ODAzNV0gICAgICAgIFs8ODExYmM4NTY+XSBuX3R0eV93cml0ZSsweGI4LzB4MzVlClsg
ICAxMi4zODgwMzVdICAgICAgICBbPDgxMWI5ZDRiPl0gdHR5X3dyaXRlKzB4MTYzLzB4MWU0
ClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMWI5ZTM5Pl0gcmVkaXJlY3RlZF90dHlfd3Jp
dGUrMHg2ZC8weDc1ClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMGI2ZjkwPl0gdmZzX3dy
aXRlKzB4NzUvMHhiMApbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTBiNzMxZj5dIFN5U193
cml0ZSsweDQ0LzB4NzcKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODE0MmZhMjY+XSBzeXNj
YWxsX2NhbGwrMHg3LzB4YgpbICAgMTIuMzg4MDM1XSAKLT4gIzEgKCZwb3J0X2xvY2tfa2V5
KXstLi0uLi59OgpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTA0YTk5Mj5dIGxvY2tfYWNx
dWlyZSsweDkyLzB4MTAxClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxNDJmMjU1Pl0gX3Jh
d19zcGluX2xvY2tfaXJxc2F2ZSsweDJlLzB4M2UKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8
ODEwNDZjMjA+XSBkb3duX3RyeWxvY2srMHhjLzB4MjcKWyAgIDEyLjM4ODAzNV0gICAgICAg
IFs8ODEwNGYyMTQ+XSBjb25zb2xlX3RyeWxvY2srMHgxMi8weDgwClsgICAxMi4zODgwMzVd
ICAgICAgICBbPDgxMDRmYzFhPl0gdnByaW50a19lbWl0KzB4NDA0LzB4NDIxClsgICAxMi4z
ODgwMzVdICAgICAgICBbPDgxNDI2MGQ2Pl0gcHJpbnRrKzB4MTcvMHgxOQpbICAgMTIuMzg4
MDM1XSAgICAgICAgWzw4MTA1YzA1YT5dIGNsb2NrZXZlbnRzX3Byb2dyYW1fbWluX2RlbHRh
KzB4MTA0LzB4MTE2ClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDVjNjAyPl0gY2xvY2tl
dmVudHNfcHJvZ3JhbV9ldmVudCsweGU3LzB4ZjMKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8
ODEwNWNjZDY+XSB0aWNrX3Byb2dyYW1fZXZlbnQrMHgxZS8weDIzClsgICAxMi4zODgwMzVd
ICAgICAgICBbPDgxMDNjNDhjPl0gaHJ0aW1lcl9mb3JjZV9yZXByb2dyYW0rMHg4OC8weDhm
ClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDNjOTQwPl0gcmV0cmlnZ2VyX25leHRfZXZl
bnQrMHgzNi8weDQyClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDNkMTIzPl0gaHJ0aW1l
cl9ydW5fcGVuZGluZysweGU0LzB4MTA4ClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDJj
NzVmPl0gcnVuX3RpbWVyX3NvZnRpcnErMHgxNC8weDE5YwpbICAgMTIuMzg4MDM1XSAgICAg
ICAgWzw4MTAyODIyYz5dIF9fZG9fc29mdGlycSsweDExMS8weDJjNApbICAgMTIuMzg4MDM1
XSAgICAgICAgWzw4MTAwMmE3Nj5dIGRvX3NvZnRpcnFfb3duX3N0YWNrKzB4MWMvMHgyMgpb
ICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTAyODVjMD5dIGlycV9leGl0KzB4NDQvMHg1ZApb
ICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTAwMjg3Mz5dIGRvX0lSUSsweDc2LzB4ODkKWyAg
IDEyLjM4ODAzNV0gICAgICAgIFs8ODE0MzA0NmU+XSBjb21tb25faW50ZXJydXB0KzB4MmUv
MHgzMwpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTA0OGVkOT5dIGRlYnVnX2NoZWNrX25v
X2xvY2tzX2ZyZWVkKzB4MTBhLzB4MTFkClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDRi
YTc1Pl0gX19yYXdfc3Bpbl9sb2NrX2luaXQrMHgxNy8weDQ5ClsgICAxMi4zODgwMzVdICAg
ICAgICBbPDgxMDQ2YjJlPl0gX19tdXRleF9pbml0KzB4MjQvMHg0NApbICAgMTIuMzg4MDM1
XSAgICAgICAgWzw4MTBjNzMwMz5dIGFkZHJlc3Nfc3BhY2VfaW5pdF9vbmNlKzB4M2QvMHg3
OApbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTBjNzM5MT5dIGlub2RlX2luaXRfb25jZSsw
eDUzLzB4NjEKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODEwYzczYTc+XSBpbml0X29uY2Ur
MHg4LzB4YQpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTBhZmQwMz5dIF9fX19jYWNoZV9h
bGxvYysweDNiNi8weDQwOQpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTBhZmY0MT5dIGtt
ZW1fY2FjaGVfYWxsb2MrMHg1NC8weDEyMgpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTBj
NzcwZD5dIGFsbG9jX2lub2RlKzB4MjUvMHg1ZgpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4
MTBjODlkZT5dIG5ld19pbm9kZV9wc2V1ZG8rMHhhLzB4NDAKWyAgIDEyLjM4ODAzNV0gICAg
ICAgIFs8ODEwYzhhMjY+XSBuZXdfaW5vZGUrMHgxMi8weDIyClsgICAxMi4zODgwMzVdICAg
ICAgICBbPDgxMGYzMzkwPl0gZGVidWdmc19ta25vZC5wYXJ0LjguY29uc3Rwcm9wLjE3KzB4
MTMvMHhjYQpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTBmMzYxMT5dIF9fY3JlYXRlX2Zp
bGUrMHgxNDYvMHgxYWEKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODEwZjM2OWI+XSBkZWJ1
Z2ZzX2NyZWF0ZV9maWxlKzB4MjYvMHgyYgpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTA3
MWFmOD5dIHRyYWNlX2NyZWF0ZV9maWxlKzB4MTUvMHgzMwpbICAgMTIuMzg4MDM1XSAgICAg
ICAgWzw4MTA3Njg0Mj5dIGV2ZW50X2NyZWF0ZV9kaXIrMHgzNWEvMHgzNmUKWyAgIDEyLjM4
ODAzNV0gICAgICAgIFs8ODE3YzA2NmM+XSBldmVudF90cmFjZV9pbml0KzB4MTI1LzB4MTgx
ClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDAwNDhiPl0gZG9fb25lX2luaXRjYWxsKzB4
ZTgvMHgxNjgKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODE3YWZhYjM+XSBrZXJuZWxfaW5p
dF9mcmVlYWJsZSsweGNjLzB4MTQ0ClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxNDIzNGZl
Pl0ga2VybmVsX2luaXQrMHg4LzB4YjMKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODE0MmZm
NDA+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjAvMHgzMApbICAgMTIuMzg4MDM1XSAK
LT4gIzAgKGhydGltZXJfYmFzZXMubG9jayl7LS4tLi4ufToKWyAgIDEyLjM4ODAzNV0gICAg
ICAgIFs8ODEwNGE2N2Q+XSBfX2xvY2tfYWNxdWlyZSsweDllYS8weGM2ZApbICAgMTIuMzg4
MDM1XSAgICAgICAgWzw4MTA0YTk5Mj5dIGxvY2tfYWNxdWlyZSsweDkyLzB4MTAxClsgICAx
Mi4zODgwMzVdICAgICAgICBbPDgxNDJmMjU1Pl0gX3Jhd19zcGluX2xvY2tfaXJxc2F2ZSsw
eDJlLzB4M2UKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODEwM2M5Njg+XSBfX2hydGltZXJf
c3RhcnRfcmFuZ2VfbnMrMHgxYy8weDE5NwpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTA3
ZWNkYT5dIHBlcmZfc3dldmVudF9zdGFydF9ocnRpbWVyLnBhcnQuNDErMHg3YS8weDg1Clsg
ICAxMi4zODgwMzVdICAgICAgICBbPDgxMDdlZDE2Pl0gY3B1X2Nsb2NrX2V2ZW50X3N0YXJ0
KzB4MzEvMHgzNgpbICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTA3ZWQyOD5dIGNwdV9jbG9j
a19ldmVudF9hZGQrMHhkLzB4MTQKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODEwODI2NTQ+
XSBldmVudF9zY2hlZF9pbisweGI2LzB4MTdhClsgICAxMi4zODgwMzVdICAgICAgICBbPDgx
MDgyNzVjPl0gZ3JvdXBfc2NoZWRfaW4rMHg0NC8weDEyMgpbICAgMTIuMzg4MDM1XSAgICAg
ICAgWzw4MTA4MjhkNz5dIGN0eF9zY2hlZF9pbi5pc3JhLjY3KzB4OWQvMHgxMWYKWyAgIDEy
LjM4ODAzNV0gICAgICAgIFs8ODEwODI5ODA+XSBwZXJmX2V2ZW50X3NjaGVkX2luLmlzcmEu
NzArMHgyNy8weDRiClsgICAxMi4zODgwMzVdICAgICAgICBbPDgxMDgyY2IwPl0gX19wZXJm
X2luc3RhbGxfaW5fY29udGV4dCsweDhiLzB4YTMKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8
ODEwN2VjNDg+XSByZW1vdGVfZnVuY3Rpb24rMHgxMi8weDJhClsgICAxMi4zODgwMzVdICAg
ICAgICBbPDgxMDVmNjY5Pl0gc21wX2NhbGxfZnVuY3Rpb25fc2luZ2xlKzB4MmQvMHg1Mwpb
ICAgMTIuMzg4MDM1XSAgICAgICAgWzw4MTA3ZTIzNz5dIHRhc2tfZnVuY3Rpb25fY2FsbCsw
eDMwLzB4MzYKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODEwN2ZjM2M+XSBwZXJmX2luc3Rh
bGxfaW5fY29udGV4dCsweDg3LzB4YmIKWyAgIDEyLjM4ODAzNV0gICAgICAgIFs8ODEwODUz
ODM+XSBTWVNDX3BlcmZfZXZlbnRfb3BlbisweDVjNi8weDcwMQpbICAgMTIuMzg4MDM1XSAg
ICAgICAgWzw4MTA4NTdiMz5dIFN5U19wZXJmX2V2ZW50X29wZW4rMHgxNy8weDE5ClsgICAx
Mi4zODgwMzVdICAgICAgICBbPDgxNDJmYTI2Pl0gc3lzY2FsbF9jYWxsKzB4Ny8weGIKWyAg
IDEyLjM4ODAzNV0gClsgICAxMi4zODgwMzVdIG90aGVyIGluZm8gdGhhdCBtaWdodCBoZWxw
IHVzIGRlYnVnIHRoaXM6ClsgICAxMi4zODgwMzVdIApbICAgMTIuMzg4MDM1XSBDaGFpbiBl
eGlzdHMgb2Y6CiAgaHJ0aW1lcl9iYXNlcy5sb2NrIC0tPiAmcnEtPmxvY2sgLS0+ICZjdHgt
PmxvY2sKClsgICAxMi4zODgwMzVdICBQb3NzaWJsZSB1bnNhZmUgbG9ja2luZyBzY2VuYXJp
bzoKWyAgIDEyLjM4ODAzNV0gClsgICAxMi4zODgwMzVdICAgICAgICBDUFUwICAgICAgICAg
ICAgICAgICAgICBDUFUxClsgICAxMi4zODgwMzVdICAgICAgICAtLS0tICAgICAgICAgICAg
ICAgICAgICAtLS0tClsgICAxMi4zODgwMzVdICAgbG9jaygmY3R4LT5sb2NrKTsKWyAgIDEy
LjM4ODAzNV0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxvY2soJnJxLT5sb2Nr
KTsKWyAgIDEyLjM4ODAzNV0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxvY2so
JmN0eC0+bG9jayk7ClsgICAxMi4zODgwMzVdICAgbG9jayhocnRpbWVyX2Jhc2VzLmxvY2sp
OwpbICAgMTIuMzg4MDM1XSAKWyAgIDEyLjM4ODAzNV0gICoqKiBERUFETE9DSyAqKioKWyAg
IDEyLjM4ODAzNV0gClsgICAxMi4zODgwMzVdIDMgbG9ja3MgaGVsZCBieSB0cmluaXR5LW1h
aW4vMTcxOgpbICAgMTIuMzg4MDM1XSAgIzA6ICAoJmN0eC0+bXV0ZXgpeysuKy4uLn0sIGF0
OiBbPDgxMDg1MzY1Pl0gU1lTQ19wZXJmX2V2ZW50X29wZW4rMHg1YTgvMHg3MDEKWyAgIDEy
LjM4ODAzNV0gICMxOiAgKCZjcHVjdHhfbG9jayl7Li4uLi4ufSwgYXQ6IFs8ODEwN2UwZjc+
XSBwZXJmX2N0eF9sb2NrKzB4ZS8weDFkClsgICAxMi4zODgwMzVdICAjMjogICgmY3R4LT5s
b2NrKXsuLi4uLi59LCBhdDogWzw4MTA3ZTEwMz5dIHBlcmZfY3R4X2xvY2srMHgxYS8weDFk
ClsgICAxMi4zODgwMzVdIApbICAgMTIuMzg4MDM1XSBzdGFjayBiYWNrdHJhY2U6ClsgICAx
Mi4zODgwMzVdIENQVTogMCBQSUQ6IDE3MSBDb21tOiB0cmluaXR5LW1haW4gTm90IHRhaW50
ZWQgMy4xNS4wLXJjOC0wNTk2OC1nODA5MWI4OSAjNDYKWyAgIDEyLjM4ODAzNV0gIDAwMDAw
MDAwIDgxYzQ1NTk4IDgwNmJiY2MwIDgxNDI3MDlmIDgwNmJiY2YwIDgxNDI1YmY5IDgxNjFm
NTgwIDgxNjFmNDdmClsgICAxMi4zODgwMzVdICA4MTYxZjQ0NyA4MTYxZjQ2OCA4MTYxZjQ0
NyA4MDZiYmQyNCA4MDkxMDExMCAwMDAwMDAwMyA4MDkxMDUyNCA4MDkxMDExMApbICAgMTIu
Mzg4MDM1XSAgODA2YmJkNTQgODEwNGE2N2QgODA5MTA1MGMgMDAwMDE3NTkgMDAwMDAwMDIg
MDAwMDAwMDAgODFjNTY2YTggMDAwMDAwMDMKWyAgIDEyLjM4ODAzNV0gQ2FsbCBUcmFjZToK
WyAgIDEyLjM4ODAzNV0gIFs8ODE0MjcwOWY+XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApbICAg
MTIuMzg4MDM1XSAgWzw4MTQyNWJmOT5dIHByaW50X2NpcmN1bGFyX2J1ZysweDE4Zi8weDE5
YwpbICAgMTIuMzg4MDM1XSAgWzw4MTA0YTY3ZD5dIF9fbG9ja19hY3F1aXJlKzB4OWVhLzB4
YzZkClsgICAxMi4zODgwMzVdICBbPDgxMDRhOTkyPl0gbG9ja19hY3F1aXJlKzB4OTIvMHgx
MDEKWyAgIDEyLjM4ODAzNV0gIFs8ODEwM2M5Njg+XSA/IF9faHJ0aW1lcl9zdGFydF9yYW5n
ZV9ucysweDFjLzB4MTk3ClsgICAxMi4zODgwMzVdICBbPDgxNDJmMjU1Pl0gX3Jhd19zcGlu
X2xvY2tfaXJxc2F2ZSsweDJlLzB4M2UKWyAgIDEyLjM4ODAzNV0gIFs8ODEwM2M5Njg+XSA/
IF9faHJ0aW1lcl9zdGFydF9yYW5nZV9ucysweDFjLzB4MTk3ClsgICAxMi4zODgwMzVdICBb
PDgxMDNjOTY4Pl0gX19ocnRpbWVyX3N0YXJ0X3JhbmdlX25zKzB4MWMvMHgxOTcKWyAgIDEy
LjM4ODAzNV0gIFs8ODEwN2VjZGE+XSBwZXJmX3N3ZXZlbnRfc3RhcnRfaHJ0aW1lci5wYXJ0
LjQxKzB4N2EvMHg4NQpbICAgMTIuMzg4MDM1XSAgWzw4MTA3ZWQxNj5dIGNwdV9jbG9ja19l
dmVudF9zdGFydCsweDMxLzB4MzYKWyAgIDEyLjM4ODAzNV0gIFs8ODEwN2VkMjg+XSBjcHVf
Y2xvY2tfZXZlbnRfYWRkKzB4ZC8weDE0ClsgICAxMi4zODgwMzVdICBbPDgxMDgyNjU0Pl0g
ZXZlbnRfc2NoZWRfaW4rMHhiNi8weDE3YQpbICAgMTIuMzg4MDM1XSAgWzw4MTA4Mjc1Yz5d
IGdyb3VwX3NjaGVkX2luKzB4NDQvMHgxMjIKWyAgIDEyLjM4ODAzNV0gIFs8ODEwODI4ZDc+
XSBjdHhfc2NoZWRfaW4uaXNyYS42NysweDlkLzB4MTFmClsgICAxMi4zODgwMzVdICBbPDgx
MDgyOTgwPl0gcGVyZl9ldmVudF9zY2hlZF9pbi5pc3JhLjcwKzB4MjcvMHg0YgpbICAgMTIu
Mzg4MDM1XSAgWzw4MTA4MmNiMD5dIF9fcGVyZl9pbnN0YWxsX2luX2NvbnRleHQrMHg4Yi8w
eGEzClsgICAxMi4zODgwMzVdICBbPDgxMDdlYzM2Pl0gPyBwZXJmX21tYXBfZmF1bHQrMHhl
Mi8weGUyClsgICAxMi4zODgwMzVdICBbPDgxMDdlYzQ4Pl0gcmVtb3RlX2Z1bmN0aW9uKzB4
MTIvMHgyYQpbICAgMTIuMzg4MDM1XSAgWzw4MTA1ZjY2OT5dIHNtcF9jYWxsX2Z1bmN0aW9u
X3NpbmdsZSsweDJkLzB4NTMKWyAgIDEyLjM4ODAzNV0gIFs8ODEwN2UyMzc+XSB0YXNrX2Z1
bmN0aW9uX2NhbGwrMHgzMC8weDM2ClsgICAxMi4zODgwMzVdICBbPDgxMDgyYzI1Pl0gPyBw
ZXJmX2NwdV9ocnRpbWVyX2hhbmRsZXIrMHgxMGUvMHgxMGUKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaGEyLTA3MzEvODA5MWI4OTViNzZmNjkwYWEyZjY2ODliNmVkNjAyZjA3NTI1YTkz
OC9kbWVzZy15b2N0by12cC01ODoyMDE0MDgwMTA0NTYxMjppMzg2LXJhbmRjb25maWctaGEy
LTA3MzE6My4xNS4wLXJjOC0wNTk2OC1nODA5MWI4OTo0NgoxMDM6MToxIGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA4LTAxIDA0OjU1OjUwIFJFUEVBVCBDT1VO
VDogMzAwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2JqLWJpc2VjdC8ucmVwZWF0G1sw
bQoKQmlzZWN0aW5nOiAxMzcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDcgc3RlcHMpCltkNTNhZWEzZDQ2ZDY0ZTk1ZGE5OTUyODg3OTY5Zjc1MzNiOWFi
MjVlXSBtbSwgY29tcGFjdGlvbjogcmV0dXJuIGZhaWxlZCBtaWdyYXRpb24gdGFyZ2V0IHBh
Z2VzIGJhY2sgdG8gZnJlZWxpc3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWhhMi0w
NzMxL2t2bWFybTpuZXh0OmQ1M2FlYTNkNDZkNjRlOTVkYTk5NTI4ODc5NjlmNzUzM2I5YWIy
NWU6YmlzZWN0LWxpbnV4LTIKCjIwMTQtMDgtMDEtMDQ6NTU6NTEgZDUzYWVhM2Q0NmQ2NGU5
NWRhOTk1Mjg4Nzk2OWY3NTMzYjlhYjI1ZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEt
ZDUzYWVhM2Q0NmQ2NGU5NWRhOTk1Mjg4Nzk2OWY3NTMzYjlhYjI1ZQpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxL2Q1M2FlYTNkNDZkNjRl
OTVkYTk5NTI4ODc5NjlmNzUzM2I5YWIyNWUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS1kNTNh
ZWEzZDQ2ZDY0ZTk1ZGE5OTUyODg3OTY5Zjc1MzNiOWFiMjVlCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci9p
Mzg2LXJhbmRjb25maWctaGEyLTA3MzEtZDUzYWVhM2Q0NmQ2NGU5NWRhOTk1Mjg4Nzk2OWY3
NTMzYjlhYjI1ZQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxL2Q1
M2FlYTNkNDZkNjRlOTVkYTk5NTI4ODc5NjlmNzUzM2I5YWIyNWUvdm1saW51ei0zLjE1LjAt
cmM4LTA1NjcwLWdkNTNhZWEzCgoyMDE0LTA4LTAxLTA1OjIzOjUxIGRldGVjdGluZyBib290
IHN0YXRlIC4uLgk2CTcJMTIJMTgJMjAJMjQJMzkJNDIJNTEuCTU0CTU4CTYyCTY3CTcxCTc0
CTc3CTgyCTgzCTkyCTk4CTEwMAkxMDUJMTA3CTExNwkxMjMJMTMxCTEzOAkxNDAJMTQyLi4J
MTQ3CTE1MAkxNTIuCTE1My4uCTE1NgkxNjIJMTY0CTE2NwkxNzYJMTc4LgkxNzkJMTkyCTE5
NQkxOTkJMjA0CTIwNQkyMDcJMjA4CTIxMgkyMjUJMjI5CTIzMgkyNDAJMjU1CTI2MQkyNjcJ
MjgxCTI4MwkyODgJMjk3CTMwMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDY4IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbNzJkMDk2MzNjOWFm
YTAyYmVhMzE3ZDY1ZWI4YjhhNGNlNzY1OWEyYV0gbW0venN3YXA6IE5VTUEgYXdhcmUgYWxs
b2NhdGlvbiBmb3IgenN3YXBfZHN0bWVtCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0yL29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1o
YTItMDczMS9rdm1hcm06bmV4dDo3MmQwOTYzM2M5YWZhMDJiZWEzMTdkNjVlYjhiOGE0Y2U3
NjU5YTJhOmJpc2VjdC1saW51eC0yCgoyMDE0LTA4LTAxLTA1OjU5OjAzIDcyZDA5NjMzYzlh
ZmEwMmJlYTMxN2Q2NWViOGI4YTRjZTc2NTlhMmEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMi0w
NzMxLTcyZDA5NjMzYzlhZmEwMmJlYTMxN2Q2NWViOGI4YTRjZTc2NTlhMmEKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS83MmQwOTYzM2M5
YWZhMDJiZWEzMTdkNjVlYjhiOGE0Y2U3NjU5YTJhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEt
NzJkMDk2MzNjOWFmYTAyYmVhMzE3ZDY1ZWI4YjhhNGNlNzY1OWEyYQprZXJuZWw6IC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLzcyZDA5NjMzYzlhZmEwMmJlYTMxN2Q2NWVi
OGI4YTRjZTc2NTlhMmEvdm1saW51ei0zLjE1LjAtcmM4LTA2MTcwLWc3MmQwOTYzCgoyMDE0
LTA4LTAxLTA2OjAxOjAzIGRldGVjdGluZyBib290IHN0YXRlIC4JNgk4CTE2CTIwCTI4CTMx
CTM5CTQyCTQ3Lgk2Mgk2OAk3Mwk3Ngk4MAk5MAk5NQkxMDIuCTEwOQkxMjIJMTI0CTEyNgkx
MzMJMTM2CTEzOQkxNDQJMTQ5CTE1NQkxNjAJMTY2CTE2OAkxNzUJMTkyLgkxOTgJMjA3CTIx
MC4JMjIwCTIyMwkyMjcJMjI4CTIzMy4uCTIzOQkyNDcJMjQ4LgkyNTEJMjU2CTI1OAkyNzEJ
Mjc4CTI4MAkyOTMJMjk1CTMwMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDM0IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbMDA0NmRkOWZlZDBj
OTMxM2NiYjRmYjg2MDMyNDQ3NmNkMjk4ZGM5Zl0gbGliL3N0cmluZy5jOiB1c2UgdGhlIG5h
bWUgIkMtc3RyaW5nIiBpbiBjb21tZW50cwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtMi9vYmotYmlz
ZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
aGEyLTA3MzEva3ZtYXJtOm5leHQ6MDA0NmRkOWZlZDBjOTMxM2NiYjRmYjg2MDMyNDQ3NmNk
Mjk4ZGM5ZjpiaXNlY3QtbGludXgtMgoKMjAxNC0wOC0wMS0wNjozMTowNiAwMDQ2ZGQ5ZmVk
MGM5MzEzY2JiNGZiODYwMzI0NDc2Y2QyOThkYzlmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTIt
MDczMS0wMDQ2ZGQ5ZmVkMGM5MzEzY2JiNGZiODYwMzI0NDc2Y2QyOThkYzlmCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvMDA0NmRkOWZl
ZDBjOTMxM2NiYjRmYjg2MDMyNDQ3NmNkMjk4ZGM5Zgp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMx
LTAwNDZkZDlmZWQwYzkzMTNjYmI0ZmI4NjAzMjQ0NzZjZDI5OGRjOWYKa2VybmVsOiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS8wMDQ2ZGQ5ZmVkMGM5MzEzY2JiNGZiODYw
MzI0NDc2Y2QyOThkYzlmL3ZtbGludXotMy4xNS4wLXJjOC0wNjIwNC1nMDA0NmRkOQoKMjAx
NC0wOC0wMS0wNjozMzowNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTEwCTI4CTM3CTQyIFRF
U1QgRkFJTFVSRQpbbWFpbl0gMzc1IHNvY2tldHMgY3JlYXRlZCBiYXNlZCBvbiBpbmZvIGZy
b20gc29ja2V0IGNhY2hlZmlsZS4KWyAgIDE0LjAwNjE5MV0gClsgICAxNC4wMDY0MTVdID09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQpb
ICAgMTQuMDA3MTk5XSBbIElORk86IHBvc3NpYmxlIGNpcmN1bGFyIGxvY2tpbmcgZGVwZW5k
ZW5jeSBkZXRlY3RlZCBdClsgICAxNC4wMDc5ODZdIDMuMTUuMC1yYzgtMDYyMDQtZzAwNDZk
ZDkgIzEyNiBOb3QgdGFpbnRlZApbICAgMTQuMDA4MDUwXSAtLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAxNC4wMDgwNTBdIHRy
aW5pdHktbWFpbi8xNzYgaXMgdHJ5aW5nIHRvIGFjcXVpcmUgbG9jazoKWyAgIDE0LjAwODA1
MF0gIChocnRpbWVyX2Jhc2VzLmxvY2spey0uLS4uLn0sIGF0OiBbPDgxMDNjOTE4Pl0gX19o
cnRpbWVyX3N0YXJ0X3JhbmdlX25zKzB4MWMvMHgxOTcKWyAgIDE0LjAwODA1MF0gClsgICAx
NC4wMDgwNTBdIGJ1dCB0YXNrIGlzIGFscmVhZHkgaG9sZGluZyBsb2NrOgpbICAgMTQuMDA4
MDUwXSAgKCZjdHgtPmxvY2spey4uLi4uLn0sIGF0OiBbPDgxMDdlMGIzPl0gcGVyZl9jdHhf
bG9jaysweDFhLzB4MWQKWyAgIDE0LjAwODA1MF0gClsgICAxNC4wMDgwNTBdIHdoaWNoIGxv
Y2sgYWxyZWFkeSBkZXBlbmRzIG9uIHRoZSBuZXcgbG9jay4KWyAgIDE0LjAwODA1MF0gClsg
ICAxNC4wMDgwNTBdIApbICAgMTQuMDA4MDUwXSB0aGUgZXhpc3RpbmcgZGVwZW5kZW5jeSBj
aGFpbiAoaW4gcmV2ZXJzZSBvcmRlcikgaXM6ClsgICAxNC4wMDgwNTBdIAotPiAjNSAoJmN0
eC0+bG9jayl7Li4uLi4ufToKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODEwNGE5NDI+XSBs
b2NrX2FjcXVpcmUrMHg5Mi8weDEwMQpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTQyZjA4
ND5dIF9yYXdfc3Bpbl9sb2NrKzB4MjEvMHgzMApbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4
MTA4MWU1ZD5dIF9fcGVyZl9ldmVudF90YXNrX3NjaGVkX291dCsweDFkYy8weDM0ZgpbICAg
MTQuMDA4MDUwXSAgICAgICAgWzw4MTQyY2IwND5dIF9fc2NoZWR1bGUrMHg0YzYvMHg0Y2IK
WyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODE0MmNiMTg+XSBzY2hlZHVsZSsweGYvMHgxMQpb
ICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTQyZjlkZT5dIHdvcmtfcmVzY2hlZCsweDUvMHgz
MApbICAgMTQuMDA4MDUwXSAKLT4gIzQgKCZycS0+bG9jayl7LS4tLi0ufToKWyAgIDE0LjAw
ODA1MF0gICAgICAgIFs8ODEwNGE5NDI+XSBsb2NrX2FjcXVpcmUrMHg5Mi8weDEwMQpbICAg
MTQuMDA4MDUwXSAgICAgICAgWzw4MTQyZjA4ND5dIF9yYXdfc3Bpbl9sb2NrKzB4MjEvMHgz
MApbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTA0MDg3Mz5dIF9fdGFza19ycV9sb2NrKzB4
MzMvMHgzYQpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTA0MTg0Yz5dIHdha2VfdXBfbmV3
X3Rhc2srMHgyNS8weGMyClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgxMDI0NzRiPl0gZG9f
Zm9yaysweDE1Yy8weDJhMApbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTAyNDhhOT5dIGtl
cm5lbF90aHJlYWQrMHgxYS8weDFmClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgxNDIzMzAy
Pl0gcmVzdF9pbml0KzB4MWEvMHgxMGUKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODE3YWY5
NDk+XSBzdGFydF9rZXJuZWwrMHgzMDMvMHgzMDgKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8
ODE3YWYyYWI+XSBpMzg2X3N0YXJ0X2tlcm5lbCsweDc5LzB4N2QKWyAgIDE0LjAwODA1MF0g
Ci0+ICMzICgmcC0+cGlfbG9jayl7LS4tLi4ufToKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8
ODEwNGE5NDI+XSBsb2NrX2FjcXVpcmUrMHg5Mi8weDEwMQpbICAgMTQuMDA4MDUwXSAgICAg
ICAgWzw4MTQyZjE1NT5dIF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHgyZS8weDNlClsgICAx
NC4wMDgwNTBdICAgICAgICBbPDgxMDQxM2RkPl0gdHJ5X3RvX3dha2VfdXArMHgxZC8weGQ2
ClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgxMDQxNGNkPl0gZGVmYXVsdF93YWtlX2Z1bmN0
aW9uKzB4Yi8weGQKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODEwNDYxZjM+XSBfX3dha2Vf
dXBfY29tbW9uKzB4MzkvMHg1OQpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTA0NjM0Nj5d
IF9fd2FrZV91cCsweDI5LzB4M2IKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODExYjg3OTM+
XSB0dHlfd2FrZXVwKzB4NDkvMHg1MQpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTFjMzVj
OD5dIHVhcnRfd3JpdGVfd2FrZXVwKzB4MTcvMHgxOQpbICAgMTQuMDA4MDUwXSAgICAgICAg
Wzw4MTFjNWUyMT5dIHNlcmlhbDgyNTBfdHhfY2hhcnMrMHhiYy8weGZiClsgICAxNC4wMDgw
NTBdICAgICAgICBbPDgxMWM1Zjg4Pl0gc2VyaWFsODI1MF9oYW5kbGVfaXJxKzB4NTQvMHg2
YQpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTFjNWZiNz5dIHNlcmlhbDgyNTBfZGVmYXVs
dF9oYW5kbGVfaXJxKzB4MTkvMHgxYwpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTFjNTcz
OD5dIHNlcmlhbDgyNTBfaW50ZXJydXB0KzB4MzgvMHg5ZQpbICAgMTQuMDA4MDUwXSAgICAg
ICAgWzw4MTA1MTE1MT5dIGhhbmRsZV9pcnFfZXZlbnRfcGVyY3B1KzB4NWYvMHgxZTIKWyAg
IDE0LjAwODA1MF0gICAgICAgIFs8ODEwNTEzMDA+XSBoYW5kbGVfaXJxX2V2ZW50KzB4MmMv
MHg0MwpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTA1MmQ1OD5dIGhhbmRsZV9sZXZlbF9p
cnErMHg1Ny8weDgwClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgxMDAyYTcyPl0gaGFuZGxl
X2lycSsweDQ2LzB4NWMKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODEwMDI3ZGY+XSBkb19J
UlErMHgzMi8weDg5ClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgxNDMwMzZlPl0gY29tbW9u
X2ludGVycnVwdCsweDJlLzB4MzMKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODE0MmYyNzQ+
XSBfcmF3X3NwaW5fdW5sb2NrX2lycXJlc3RvcmUrMHgzZi8weDQ5ClsgICAxNC4wMDgwNTBd
ICAgICAgICBbPDgxMWMyNjA0Pl0gdWFydF9zdGFydCsweDJkLzB4MzIKWyAgIDE0LjAwODA1
MF0gICAgICAgIFs8ODExYzJjNjQ+XSB1YXJ0X3dyaXRlKzB4YzcvMHhkNgpbICAgMTQuMDA4
MDUwXSAgICAgICAgWzw4MTFiYzc1Nj5dIG5fdHR5X3dyaXRlKzB4YjgvMHgzNWUKWyAgIDE0
LjAwODA1MF0gICAgICAgIFs8ODExYjljNGI+XSB0dHlfd3JpdGUrMHgxNjMvMHgxZTQKWyAg
IDE0LjAwODA1MF0gICAgICAgIFs8ODExYjlkMzk+XSByZWRpcmVjdGVkX3R0eV93cml0ZSsw
eDZkLzB4NzUKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODEwYjZmNDA+XSB2ZnNfd3JpdGUr
MHg3NS8weGIwClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgxMGI3MmNmPl0gU3lTX3dyaXRl
KzB4NDQvMHg3NwpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTQyZjkyNj5dIHN5c2NhbGxf
Y2FsbCsweDcvMHhiClsgICAxNC4wMDgwNTBdIAotPiAjMiAoJnR0eS0+d3JpdGVfd2FpdCl7
LS4tLi4ufToKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODEwNGE5NDI+XSBsb2NrX2FjcXVp
cmUrMHg5Mi8weDEwMQpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTQyZjE1NT5dIF9yYXdf
c3Bpbl9sb2NrX2lycXNhdmUrMHgyZS8weDNlClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgx
MDQ2MzMyPl0gX193YWtlX3VwKzB4MTUvMHgzYgpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4
MTFiODc5Mz5dIHR0eV93YWtldXArMHg0OS8weDUxClsgICAxNC4wMDgwNTBdICAgICAgICBb
PDgxMWMzNWM4Pl0gdWFydF93cml0ZV93YWtldXArMHgxNy8weDE5ClsgICAxNC4wMDgwNTBd
ICAgICAgICBbPDgxMWM1ZTIxPl0gc2VyaWFsODI1MF90eF9jaGFycysweGJjLzB4ZmIKWyAg
IDE0LjAwODA1MF0gICAgICAgIFs8ODExYzVmODg+XSBzZXJpYWw4MjUwX2hhbmRsZV9pcnEr
MHg1NC8weDZhClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgxMWM1ZmI3Pl0gc2VyaWFsODI1
MF9kZWZhdWx0X2hhbmRsZV9pcnErMHgxOS8weDFjClsgICAxNC4wMDgwNTBdICAgICAgICBb
PDgxMWM1NzM4Pl0gc2VyaWFsODI1MF9pbnRlcnJ1cHQrMHgzOC8weDllClsgICAxNC4wMDgw
NTBdICAgICAgICBbPDgxMDUxMTUxPl0gaGFuZGxlX2lycV9ldmVudF9wZXJjcHUrMHg1Zi8w
eDFlMgpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTA1MTMwMD5dIGhhbmRsZV9pcnFfZXZl
bnQrMHgyYy8weDQzClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgxMDUyZDU4Pl0gaGFuZGxl
X2xldmVsX2lycSsweDU3LzB4ODAKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODEwMDJhNzI+
XSBoYW5kbGVfaXJxKzB4NDYvMHg1YwpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTAwMjdk
Zj5dIGRvX0lSUSsweDMyLzB4ODkKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODE0MzAzNmU+
XSBjb21tb25faW50ZXJydXB0KzB4MmUvMHgzMwpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4
MTQyZjI3ND5dIF9yYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSsweDNmLzB4NDkKWyAgIDE0
LjAwODA1MF0gICAgICAgIFs8ODExYzI2MDQ+XSB1YXJ0X3N0YXJ0KzB4MmQvMHgzMgpbICAg
MTQuMDA4MDUwXSAgICAgICAgWzw4MTFjMmM2ND5dIHVhcnRfd3JpdGUrMHhjNy8weGQ2Clsg
ICAxNC4wMDgwNTBdICAgICAgICBbPDgxMWJjNzU2Pl0gbl90dHlfd3JpdGUrMHhiOC8weDM1
ZQpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTFiOWM0Yj5dIHR0eV93cml0ZSsweDE2My8w
eDFlNApbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTFiOWQzOT5dIHJlZGlyZWN0ZWRfdHR5
X3dyaXRlKzB4NmQvMHg3NQpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTBiNmY0MD5dIHZm
c193cml0ZSsweDc1LzB4YjAKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODEwYjcyY2Y+XSBT
eVNfd3JpdGUrMHg0NC8weDc3ClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgxNDJmOTI2Pl0g
c3lzY2FsbF9jYWxsKzB4Ny8weGIKWyAgIDE0LjAwODA1MF0gCi0+ICMxICgmcG9ydF9sb2Nr
X2tleSl7LS4tLi4ufToKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODEwNGE5NDI+XSBsb2Nr
X2FjcXVpcmUrMHg5Mi8weDEwMQpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTQyZjE1NT5d
IF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHgyZS8weDNlClsgICAxNC4wMDgwNTBdICAgICAg
ICBbPDgxMDQ2YmQwPl0gZG93bl90cnlsb2NrKzB4Yy8weDI3ClsgICAxNC4wMDgwNTBdICAg
ICAgICBbPDgxMDRmMWM0Pl0gY29uc29sZV90cnlsb2NrKzB4MTIvMHg4MApbICAgMTQuMDA4
MDUwXSAgICAgICAgWzw4MTA0ZmJjYT5dIHZwcmludGtfZW1pdCsweDQwNC8weDQyMQpbICAg
MTQuMDA4MDUwXSAgICAgICAgWzw4MTQyNWZkNj5dIHByaW50aysweDE3LzB4MTkKWyAgIDE0
LjAwODA1MF0gICAgICAgIFs8ODEwNWMwMGE+XSBjbG9ja2V2ZW50c19wcm9ncmFtX21pbl9k
ZWx0YSsweDEwNC8weDExNgpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTA1YzViMj5dIGNs
b2NrZXZlbnRzX3Byb2dyYW1fZXZlbnQrMHhlNy8weGYzClsgICAxNC4wMDgwNTBdICAgICAg
ICBbPDgxMDVjYzg2Pl0gdGlja19wcm9ncmFtX2V2ZW50KzB4MWUvMHgyMwpbICAgMTQuMDA4
MDUwXSAgICAgICAgWzw4MTAzYzQzYz5dIGhydGltZXJfZm9yY2VfcmVwcm9ncmFtKzB4ODgv
MHg4ZgpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTAzYzhmMD5dIHJldHJpZ2dlcl9uZXh0
X2V2ZW50KzB4MzYvMHg0MgpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTAzZDBkMz5dIGhy
dGltZXJfcnVuX3BlbmRpbmcrMHhlNC8weDEwOApbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4
MTAyYzcwZj5dIHJ1bl90aW1lcl9zb2Z0aXJxKzB4MTQvMHgxOWMKWyAgIDE0LjAwODA1MF0g
ICAgICAgIFs8ODEwMjgxZGM+XSBfX2RvX3NvZnRpcnErMHgxMTEvMHgyYzQKWyAgIDE0LjAw
ODA1MF0gICAgICAgIFs8ODEwMDJhMjY+XSBkb19zb2Z0aXJxX293bl9zdGFjaysweDFjLzB4
MjIKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODEwMjg1NzA+XSBpcnFfZXhpdCsweDQ0LzB4
NWQKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODEwMDI4MjM+XSBkb19JUlErMHg3Ni8weDg5
ClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgxNDMwMzZlPl0gY29tbW9uX2ludGVycnVwdCsw
eDJlLzB4MzMKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODE0MmQ1NjI+XSBtdXRleF9sb2Nr
X25lc3RlZCsweDI2ZS8weDJjYwpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTBmMzRmZD5d
IF9fY3JlYXRlX2ZpbGUrMHg4Mi8weDFhYQpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTBm
MzY0Yj5dIGRlYnVnZnNfY3JlYXRlX2ZpbGUrMHgyNi8weDJiClsgICAxNC4wMDgwNTBdICAg
ICAgICBbPDgxMDcxYWE4Pl0gdHJhY2VfY3JlYXRlX2ZpbGUrMHgxNS8weDMzClsgICAxNC4w
MDgwNTBdICAgICAgICBbPDgxMDc2NzU1Pl0gZXZlbnRfY3JlYXRlX2RpcisweDJiZC8weDM2
ZQpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTdjMDVkMz5dIGV2ZW50X3RyYWNlX2luaXQr
MHgxMjUvMHgxODEKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODEwMDA0Mzk+XSBkb19vbmVf
aW5pdGNhbGwrMHg5Ni8weDExNgpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTdhZmExYT5d
IGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4Y2MvMHgxNDQKWyAgIDE0LjAwODA1MF0gICAgICAg
IFs8ODE0MjMzZmU+XSBrZXJuZWxfaW5pdCsweDgvMHhiMwpbICAgMTQuMDA4MDUwXSAgICAg
ICAgWzw4MTQyZmU0MD5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMC8weDMwClsgICAx
NC4wMDgwNTBdIAotPiAjMCAoaHJ0aW1lcl9iYXNlcy5sb2NrKXstLi0uLi59OgpbICAgMTQu
MDA4MDUwXSAgICAgICAgWzw4MTA0YTYyZD5dIF9fbG9ja19hY3F1aXJlKzB4OWVhLzB4YzZk
ClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgxMDRhOTQyPl0gbG9ja19hY3F1aXJlKzB4OTIv
MHgxMDEKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODE0MmYxNTU+XSBfcmF3X3NwaW5fbG9j
a19pcnFzYXZlKzB4MmUvMHgzZQpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTAzYzkxOD5d
IF9faHJ0aW1lcl9zdGFydF9yYW5nZV9ucysweDFjLzB4MTk3ClsgICAxNC4wMDgwNTBdICAg
ICAgICBbPDgxMDdlYzhhPl0gcGVyZl9zd2V2ZW50X3N0YXJ0X2hydGltZXIucGFydC40MSsw
eDdhLzB4ODUKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODEwN2VjYzY+XSBjcHVfY2xvY2tf
ZXZlbnRfc3RhcnQrMHgzMS8weDM2ClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgxMDdlY2Q4
Pl0gY3B1X2Nsb2NrX2V2ZW50X2FkZCsweGQvMHgxNApbICAgMTQuMDA4MDUwXSAgICAgICAg
Wzw4MTA4MjYwND5dIGV2ZW50X3NjaGVkX2luKzB4YjYvMHgxN2EKWyAgIDE0LjAwODA1MF0g
ICAgICAgIFs8ODEwODI3MGM+XSBncm91cF9zY2hlZF9pbisweDQ0LzB4MTIyClsgICAxNC4w
MDgwNTBdICAgICAgICBbPDgxMDgyODg3Pl0gY3R4X3NjaGVkX2luLmlzcmEuNjcrMHg5ZC8w
eDExZgpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTA4MjkzMD5dIHBlcmZfZXZlbnRfc2No
ZWRfaW4uaXNyYS43MCsweDI3LzB4NGIKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODEwODJj
NjA+XSBfX3BlcmZfaW5zdGFsbF9pbl9jb250ZXh0KzB4OGIvMHhhMwpbICAgMTQuMDA4MDUw
XSAgICAgICAgWzw4MTA3ZWJmOD5dIHJlbW90ZV9mdW5jdGlvbisweDEyLzB4MmEKWyAgIDE0
LjAwODA1MF0gICAgICAgIFs8ODEwNWY2MTk+XSBzbXBfY2FsbF9mdW5jdGlvbl9zaW5nbGUr
MHgyZC8weDUzClsgICAxNC4wMDgwNTBdICAgICAgICBbPDgxMDdlMWU3Pl0gdGFza19mdW5j
dGlvbl9jYWxsKzB4MzAvMHgzNgpbICAgMTQuMDA4MDUwXSAgICAgICAgWzw4MTA3ZmJlYz5d
IHBlcmZfaW5zdGFsbF9pbl9jb250ZXh0KzB4ODcvMHhiYgpbICAgMTQuMDA4MDUwXSAgICAg
ICAgWzw4MTA4NTMzMz5dIFNZU0NfcGVyZl9ldmVudF9vcGVuKzB4NWM2LzB4NzAxClsgICAx
NC4wMDgwNTBdICAgICAgICBbPDgxMDg1NzYzPl0gU3lTX3BlcmZfZXZlbnRfb3BlbisweDE3
LzB4MTkKWyAgIDE0LjAwODA1MF0gICAgICAgIFs8ODE0MmY5MjY+XSBzeXNjYWxsX2NhbGwr
MHg3LzB4YgpbICAgMTQuMDA4MDUwXSAKWyAgIDE0LjAwODA1MF0gb3RoZXIgaW5mbyB0aGF0
IG1pZ2h0IGhlbHAgdXMgZGVidWcgdGhpczoKWyAgIDE0LjAwODA1MF0gClsgICAxNC4wMDgw
NTBdIENoYWluIGV4aXN0cyBvZjoKICBocnRpbWVyX2Jhc2VzLmxvY2sgLS0+ICZycS0+bG9j
ayAtLT4gJmN0eC0+bG9jawoKWyAgIDE0LjAwODA1MF0gIFBvc3NpYmxlIHVuc2FmZSBsb2Nr
aW5nIHNjZW5hcmlvOgpbICAgMTQuMDA4MDUwXSAKWyAgIDE0LjAwODA1MF0gICAgICAgIENQ
VTAgICAgICAgICAgICAgICAgICAgIENQVTEKWyAgIDE0LjAwODA1MF0gICAgICAgIC0tLS0g
ICAgICAgICAgICAgICAgICAgIC0tLS0KWyAgIDE0LjAwODA1MF0gICBsb2NrKCZjdHgtPmxv
Y2spOwpbICAgMTQuMDA4MDUwXSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbG9j
aygmcnEtPmxvY2spOwpbICAgMTQuMDA4MDUwXSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgbG9jaygmY3R4LT5sb2NrKTsKWyAgIDE0LjAwODA1MF0gICBsb2NrKGhydGltZXJf
YmFzZXMubG9jayk7ClsgICAxNC4wMDgwNTBdIApbICAgMTQuMDA4MDUwXSAgKioqIERFQURM
T0NLICoqKgpbICAgMTQuMDA4MDUwXSAKWyAgIDE0LjAwODA1MF0gMyBsb2NrcyBoZWxkIGJ5
IHRyaW5pdHktbWFpbi8xNzY6ClsgICAxNC4wMDgwNTBdICAjMDogICgmY3R4LT5tdXRleCl7
Ky4rLi4ufSwgYXQ6IFs8ODEwODUzMTU+XSBTWVNDX3BlcmZfZXZlbnRfb3BlbisweDVhOC8w
eDcwMQpbICAgMTQuMDA4MDUwXSAgIzE6ICAoJmNwdWN0eF9sb2NrKXsuLi4uLi59LCBhdDog
Wzw4MTA3ZTBhNz5dIHBlcmZfY3R4X2xvY2srMHhlLzB4MWQKWyAgIDE0LjAwODA1MF0gICMy
OiAgKCZjdHgtPmxvY2spey4uLi4uLn0sIGF0OiBbPDgxMDdlMGIzPl0gcGVyZl9jdHhfbG9j
aysweDFhLzB4MWQKWyAgIDE0LjAwODA1MF0gClsgICAxNC4wMDgwNTBdIHN0YWNrIGJhY2t0
cmFjZToKWyAgIDE0LjAwODA1MF0gQ1BVOiAwIFBJRDogMTc2IENvbW06IHRyaW5pdHktbWFp
biBOb3QgdGFpbnRlZCAzLjE1LjAtcmM4LTA2MjA0LWcwMDQ2ZGQ5ICMxMjYKWyAgIDE0LjAw
ODA1MF0gIDAwMDAwMDAwIDgxYzQ0NmE4IDkyNTMzY2MwIDgxNDI2ZjlmIDkyNTMzY2YwIDgx
NDI1YWY5IDgxNjFmNDdkIDgxNjFmMzdjClsgICAxNC4wMDgwNTBdICA4MTYxZjM0NCA4MTYx
ZjM2NSA4MTYxZjM0NCA5MjUzM2QyNCA5MTBmYjI1MCAwMDAwMDAwMyA5MTBmYjY2NCA5MTBm
YjI1MApbICAgMTQuMDA4MDUwXSAgOTI1MzNkNTQgODEwNGE2MmQgOTEwZmI2NGMgMDAwMDE3
MTYgMDAwMDAwMDIgMDAwMDAwMDAgODFjNTU4YzggMDAwMDAwMDMKWyAgIDE0LjAwODA1MF0g
Q2FsbCBUcmFjZToKWyAgIDE0LjAwODA1MF0gIFs8ODE0MjZmOWY+XSBkdW1wX3N0YWNrKzB4
MTYvMHgxOApbICAgMTQuMDA4MDUwXSAgWzw4MTQyNWFmOT5dIHByaW50X2NpcmN1bGFyX2J1
ZysweDE4Zi8weDE5YwpbICAgMTQuMDA4MDUwXSAgWzw4MTA0YTYyZD5dIF9fbG9ja19hY3F1
aXJlKzB4OWVhLzB4YzZkClsgICAxNC4wMDgwNTBdICBbPDgxMDYyZmRkPl0gPyBpc19tb2R1
bGVfdGV4dF9hZGRyZXNzKzB4ZS8weDFiClsgICAxNC4wMDgwNTBdICBbPDgxMDRhOTQyPl0g
bG9ja19hY3F1aXJlKzB4OTIvMHgxMDEKWyAgIDE0LjAwODA1MF0gIFs8ODEwM2M5MTg+XSA/
IF9faHJ0aW1lcl9zdGFydF9yYW5nZV9ucysweDFjLzB4MTk3ClsgICAxNC4wMDgwNTBdICBb
PDgxNDJmMTU1Pl0gX3Jhd19zcGluX2xvY2tfaXJxc2F2ZSsweDJlLzB4M2UKWyAgIDE0LjAw
ODA1MF0gIFs8ODEwM2M5MTg+XSA/IF9faHJ0aW1lcl9zdGFydF9yYW5nZV9ucysweDFjLzB4
MTk3ClsgICAxNC4wMDgwNTBdICBbPDgxMDNjOTE4Pl0gX19ocnRpbWVyX3N0YXJ0X3Jhbmdl
X25zKzB4MWMvMHgxOTcKWyAgIDE0LjAwODA1MF0gIFs8ODEwN2VjOGE+XSBwZXJmX3N3ZXZl
bnRfc3RhcnRfaHJ0aW1lci5wYXJ0LjQxKzB4N2EvMHg4NQpbICAgMTQuMDA4MDUwXSAgWzw4
MTA3ZWNjNj5dIGNwdV9jbG9ja19ldmVudF9zdGFydCsweDMxLzB4MzYKWyAgIDE0LjAwODA1
MF0gIFs8ODEwN2VjZDg+XSBjcHVfY2xvY2tfZXZlbnRfYWRkKzB4ZC8weDE0ClsgICAxNC4w
MDgwNTBdICBbPDgxMDgyNjA0Pl0gZXZlbnRfc2NoZWRfaW4rMHhiNi8weDE3YQpbICAgMTQu
MDA4MDUwXSAgWzw4MTA4MjcwYz5dIGdyb3VwX3NjaGVkX2luKzB4NDQvMHgxMjIKWyAgIDE0
LjAwODA1MF0gIFs8ODEwODI4ODc+XSBjdHhfc2NoZWRfaW4uaXNyYS42NysweDlkLzB4MTFm
ClsgICAxNC4wMDgwNTBdICBbPDgxMDgyOTMwPl0gcGVyZl9ldmVudF9zY2hlZF9pbi5pc3Jh
LjcwKzB4MjcvMHg0YgpbICAgMTQuMDA4MDUwXSAgWzw4MTA4MmM2MD5dIF9fcGVyZl9pbnN0
YWxsX2luX2NvbnRleHQrMHg4Yi8weGEzClsgICAxNC4wMDgwNTBdICBbPDgxMDdlYmU2Pl0g
PyBwZXJmX21tYXBfZmF1bHQrMHhlMi8weGUyClsgICAxNC4wMDgwNTBdICBbPDgxMDdlYmY4
Pl0gcmVtb3RlX2Z1bmN0aW9uKzB4MTIvMHgyYQpbICAgMTQuMDA4MDUwXSAgWzw4MTA1ZjYx
OT5dIHNtcF9jYWxsX2Z1bmN0aW9uX3NpbmdsZSsweDJkLzB4NTMKWyAgIDE0LjAwODA1MF0g
IFs8ODEwN2UxZTc+XSB0YXNrX2Z1bmN0aW9uX2NhbGwrMHgzMC8weDM2ClsgICAxNC4wMDgw
NTBdICBbPDgxMDgyYmQ1Pl0gPyBwZXJmX2NwdV9ocnRpbWVyX2hhbmRsZXIrMHgxMGUvMHgx
MGUKWyAgIDE0LjAwODA1MF0gIFs8ODEwN2ZiZWM+XSBwZXJmX2luc3RhbGxfaW5fY29udGV4
dCsweDg3LzB4YmIKWyAgIDE0LjAwODA1MF0gIFs8ODEwODUzMzM+XSBTWVNDX3BlcmZfZXZl
bnRfb3BlbisweDVjNi8weDcwMQpbICAgMTQuMDA4MDUwXSAgWzw4MTAxYWUwMD5dID8gX19k
b19wYWdlX2ZhdWx0KzB4MjFlLzB4MzE0ClsgICAxNC4wMDgwNTBdICBbPDgxMDg1NzYzPl0g
U3lTX3BlcmZfZXZlbnRfb3BlbisweDE3LzB4MTkKWyAgIDE0LjAwODA1MF0gIFs8ODE0MmY5
MjY+XSBzeXNjYWxsX2NhbGwrMHg3LzB4YgpbICAgMjIuNzMxMjk4XSByYW5kb206IG5vbmJs
b2NraW5nIHBvb2wgaXMgaW5pdGlhbGl6ZWQKWyAgIDYwLjU4ODA5OF0gc3Bpbl9sb2NrLXRv
cnR1cmU6IFdyaXRlczogIFRvdGFsOiAyICBNYXgvTWluOiAwLzAgICBGYWlsOiAwIApsc21v
ZDogY2FuJ3Qgb3BlbiAnL3Byb2MvbW9kdWxlcyc6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3Rv
cnkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvMDA0NmRkOWZlZDBjOTMxM2Ni
YjRmYjg2MDMyNDQ3NmNkMjk4ZGM5Zi9kbWVzZy15b2N0by1pdmI0NC0xMTE6MjAxNDA4MDEw
NjI3MjA6aTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxOjoKNDI6MToxIGFsbF9nb29kOmJhZDph
bGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA4LTAxIDA2OjM1OjM3IFJFUEVBVCBDT1VOVDog
MzAwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoK
QmlzZWN0aW5nOiAxNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgNCBzdGVwcykKWzBhNTgxNjk0YWI3YTViYzA4M2Q3MTBkZjhhNTUyYTZhMDU1YjAwNWZd
IHByaW50azogc3BsaXQgY29kZSBmb3IgbWFraW5nIGZyZWUgc3BhY2UgaW4gdGhlIGxvZyBi
dWZmZXIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxL2t2bWFybTpuZXh0
OjBhNTgxNjk0YWI3YTViYzA4M2Q3MTBkZjhhNTUyYTZhMDU1YjAwNWY6YmlzZWN0LWxpbnV4
LTIKCjIwMTQtMDgtMDEtMDY6MzU6MzggMGE1ODE2OTRhYjdhNWJjMDgzZDcxMGRmOGE1NTJh
NmEwNTViMDA1ZiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEtMGE1ODE2OTRhYjdhNWJj
MDgzZDcxMGRmOGE1NTJhNmEwNTViMDA1ZgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLzBhNTgxNjk0YWI3YTViYzA4M2Q3MTBkZjhhNTUy
YTZhMDU1YjAwNWYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS0wYTU4MTY5NGFiN2E1YmMwODNk
NzEwZGY4YTU1MmE2YTA1NWIwMDVmCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aGEyLTA3MzEvMGE1ODE2OTRhYjdhNWJjMDgzZDcxMGRmOGE1NTJhNmEwNTViMDA1Zi92bWxp
bnV6LTMuMTUuMC1yYzgtMDYxODctZzBhNTgxNjkKCjIwMTQtMDgtMDEtMDY6Mzc6MzggZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMS4JMTQJMTYuCTE3CTE4CTI5CTQwCTQ5CTU3CTY2CTY5
CTg3CTk3CTEwOAkxMjIJMTM1CTE1NAkxNjYJMTc0CTE4NgkyMDUJMjE0CTIyMAkyMzMJMjQ4
CTI1NgkyODkJMjk5CTMwMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDggcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCls5MzlmMDRiZWMxYTRlZjZi
YTQzNzBiMGYzNGIwMWRlY2M4NDRiMWIxXSBwcmludGs6IGVuYWJsZSBpbnRlcnJ1cHRzIGJl
Zm9yZSBjYWxsaW5nIGNvbnNvbGVfdHJ5bG9ja19mb3JfcHJpbnRrKCkKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4LTIvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxL2t2bWFybTpuZXh0OjkzOWYwNGJlYzFhNGVmNmJh
NDM3MGIwZjM0YjAxZGVjYzg0NGIxYjE6YmlzZWN0LWxpbnV4LTIKCjIwMTQtMDgtMDEtMDY6
NTQ6NDYgOTM5ZjA0YmVjMWE0ZWY2YmE0MzcwYjBmMzRiMDFkZWNjODQ0YjFiMSBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWctaGEyLTA3MzEtOTM5ZjA0YmVjMWE0ZWY2YmE0MzcwYjBmMzRiMDFkZWNj
ODQ0YjFiMQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhh
Mi0wNzMxLzkzOWYwNGJlYzFhNGVmNmJhNDM3MGIwZjM0YjAxZGVjYzg0NGIxYjEKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFu
ZGNvbmZpZy1oYTItMDczMS05MzlmMDRiZWMxYTRlZjZiYTQzNzBiMGYzNGIwMWRlY2M4NDRi
MWIxCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvOTM5ZjA0YmVj
MWE0ZWY2YmE0MzcwYjBmMzRiMDFkZWNjODQ0YjFiMS92bWxpbnV6LTMuMTUuMC1yYzgtMDYx
OTUtZzkzOWYwNGIKCjIwMTQtMDgtMDEtMDY6NTY6NDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
CTYJMTIJMjUJNDYgVEVTVCBGQUlMVVJFClsgICAgMi4xNjgyMjldIHRzYzogUmVmaW5lZCBU
U0MgY2xvY2tzb3VyY2UgY2FsaWJyYXRpb246IDI2OTMuNTA4IE1IegpbICAgMTIuMjQyNTU0
XSBzb2NrOiBwcm9jZXNzIGB0cmluaXR5LW1haW4nIGlzIHVzaW5nIG9ic29sZXRlIHNldHNv
Y2tvcHQgU09fQlNEQ09NUEFUCgpCVUc6IGtlcm5lbCBib290IGhhbmcKRWxhcHNlZCB0aW1l
OiAzNQpxZW11LXN5c3RlbS14ODZfNjQgLWNwdSBrdm02NCAtZW5hYmxlLWt2bSAta2VybmVs
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLzkzOWYwNGJlYzFhNGVmNmJhNDM3
MGIwZjM0YjAxZGVjYzg0NGIxYjEvdm1saW51ei0zLjE1LjAtcmM4LTA2MTk1LWc5MzlmMDRi
IC1hcHBlbmQgJ2h1bmdfdGFza19wYW5pYz0xIGVhcmx5cHJpbnRrPXR0eVMwLDExNTIwMCBk
ZWJ1ZyBhcGljPWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFibGVkIHJjdXBkYXRlLnJjdV9jcHVf
c3RhbGxfdGltZW91dD0xMDAgcGFuaWM9MTAgc29mdGxvY2t1cF9wYW5pYz0xIG5taV93YXRj
aGRvZz1wYW5pYyBsb2FkX3JhbWRpc2s9MiBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5
UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBs
aW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEyLTA3
MzEva3ZtYXJtOm5leHQ6OTM5ZjA0YmVjMWE0ZWY2YmE0MzcwYjBmMzRiMDFkZWNjODQ0YjFi
MTpiaXNlY3QtbGludXgtMi8udm1saW51ei05MzlmMDRiZWMxYTRlZjZiYTQzNzBiMGYzNGIw
MWRlY2M4NDRiMWIxLTIwMTQwODAxMTQ1NjIxLTEyNi1pdmI0NCBicmFuY2g9a3ZtYXJtL25l
eHQgQk9PVF9JTUFHRT0va2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS85MzlmMDRi
ZWMxYTRlZjZiYTQzNzBiMGYzNGIwMWRlY2M4NDRiMWIxL3ZtbGludXotMy4xNS4wLXJjOC0w
NjE5NS1nOTM5ZjA0YiBkcmJkLm1pbm9yX2NvdW50PTgnICAtaW5pdHJkIC9rZXJuZWwtdGVz
dHMvaW5pdHJkL3F1YW50YWwtY29yZS1pMzg2LmNneiAtbSAzMjAgLXNtcCAyIC1uZXQgbmlj
LHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxhbj0xIC1ib290IG9yZGVyPW5jIC1u
by1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBpZGZp
bGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwtaXZiNDQtMyAtc2VyaWFsIGZpbGU6L2Rl
di9zaG0va2Jvb3Qvc2VyaWFsLXF1YW50YWwtaXZiNDQtMyAtZGFlbW9uaXplIC1kaXNwbGF5
IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEv
OTM5ZjA0YmVjMWE0ZWY2YmE0MzcwYjBmMzRiMDFkZWNjODQ0YjFiMS9kbWVzZy1xdWFudGFs
LWtidWlsZC0yMDoyMDE0MDgwMTA2NTYyMjppMzg2LXJhbmRjb25maWctaGEyLTA3MzE6My4x
NS4wLXJjOC0wNjE5NS1nOTM5ZjA0YjoyCjQ1OjE6MiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBi
b290cwobWzE7MzVtMjAxNC0wOC0wMSAwNjo1ODo0NyBSRVBFQVQgQ09VTlQ6IDMwMCAgIyAv
Yy9ib290LWJpc2VjdC9saW51eC0yL29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGlu
ZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVw
cykKWzAzNDYzM2NjYjI0ZDY3NTg1MGY5OWJmODVjMWM1ODgwYzgzMWU0YjZdIHByaW50azog
cmV0dXJuIHJlYWxseSBzdG9yZWQgbWVzc2FnZSBsZW5ndGgKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
LTIvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWhhMi0wNzMxL2t2bWFybTpuZXh0OjAzNDYzM2NjYjI0ZDY3NTg1MGY5OWJm
ODVjMWM1ODgwYzgzMWU0YjY6YmlzZWN0LWxpbnV4LTIKCjIwMTQtMDgtMDEtMDY6NTg6NDcg
MDM0NjMzY2NiMjRkNjc1ODUwZjk5YmY4NWMxYzU4ODBjODMxZTRiNiBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctaGEyLTA3MzEtMDM0NjMzY2NiMjRkNjc1ODUwZjk5YmY4NWMxYzU4ODBjODMxZTRi
NgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMx
LzAzNDYzM2NjYjI0ZDY3NTg1MGY5OWJmODVjMWM1ODgwYzgzMWU0YjYKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1oYTItMDczMS0wMzQ2MzNjY2IyNGQ2NzU4NTBmOTliZjg1YzFjNTg4MGM4MzFlNGI2Cndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtl
dG93bi1jb25zdW1lci9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEtMDM0NjMzY2NiMjRkNjc1
ODUwZjk5YmY4NWMxYzU4ODBjODMxZTRiNgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWhhMi0wNzMxLzAzNDYzM2NjYjI0ZDY3NTg1MGY5OWJmODVjMWM1ODgwYzgzMWU0YjYv
dm1saW51ei0zLjE1LjAtcmM4LTA1NzYwLWcwMzQ2MzNjCgoyMDE0LTA4LTAxLTA3OjAzOjQ3
IGRldGVjdGluZyBib290IHN0YXRlIC4JMgk4CTE1CTIwCTQwCTQ3CTQ5CTY2CTg3CTg4CTEw
MAkxMDkJMTE4CTEyNQkxNTIJMTY4CTE3OQkxOTAJMjEwCTIyOAkyNTkJMjY1CTI4MQkyOTUJ
MzAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSAxIHN0ZXApCls2MDg4NzNjYWNiOWQwZDI4MTE1ODZmY2M3OWEzOGI2
NGVhYmQ2ZDMyXSBwcmludGs6IHJlbGVhc2UgbG9ja2J1Zl9sb2NrIGJlZm9yZSBjYWxsaW5n
IGNvbnNvbGVfdHJ5bG9ja19mb3JfcHJpbnRrKCkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2Jq
LWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWhhMi0wNzMxL2t2bWFybTpuZXh0OjYwODg3M2NhY2I5ZDBkMjgxMTU4NmZjYzc5YTM4
YjY0ZWFiZDZkMzI6YmlzZWN0LWxpbnV4LTIKCjIwMTQtMDgtMDEtMDc6MTY6NTAgNjA4ODcz
Y2FjYjlkMGQyODExNTg2ZmNjNzlhMzhiNjRlYWJkNmQzMiBjb21waWxpbmcKUXVldWVkIGJ1
aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
aGEyLTA3MzEtNjA4ODczY2FjYjlkMGQyODExNTg2ZmNjNzlhMzhiNjRlYWJkNmQzMgpDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLzYwODg3
M2NhY2I5ZDBkMjgxMTU4NmZjYzc5YTM4YjY0ZWFiZDZkMzIKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTIt
MDczMS02MDg4NzNjYWNiOWQwZDI4MTE1ODZmY2M3OWEzOGI2NGVhYmQ2ZDMyCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEt
Y29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLTYwODg3M2NhY2I5ZDBkMjgxMTU4
NmZjYzc5YTM4YjY0ZWFiZDZkMzIKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1o
YTItMDczMS82MDg4NzNjYWNiOWQwZDI4MTE1ODZmY2M3OWEzOGI2NGVhYmQ2ZDMyL3ZtbGlu
dXotMy4xNS4wLXJjOC0wNjE5My1nNjA4ODczYwoKMjAxNC0wOC0wMS0wNzoyMjo1MCBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLgk3CTE4CTUzCTEwMwkxMTgJMTQ0CTE5MAkyMzcJMjQ1CTI1
OAkyOTkJMzAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykKW2JkOGQ3Y2Y1Yjg0MTBmZTk4ZWJhMDZh
OWFhYTkwZWZlODg4MTVkOGFdIHByaW50azogZml4IGxvY2tkZXAgaW5zdHJ1bWVudGF0aW9u
IG9mIGNvbnNvbGVfc2VtCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0yL29iai1iaXNlY3QKbHMgLWEg
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS9r
dm1hcm06bmV4dDpiZDhkN2NmNWI4NDEwZmU5OGViYTA2YTlhYWE5MGVmZTg4ODE1ZDhhOmJp
c2VjdC1saW51eC0yCgoyMDE0LTA4LTAxLTA3OjI5OjUxIGJkOGQ3Y2Y1Yjg0MTBmZTk4ZWJh
MDZhOWFhYTkwZWZlODg4MTVkOGEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLWJkOGQ3
Y2Y1Yjg0MTBmZTk4ZWJhMDZhOWFhYTkwZWZlODg4MTVkOGEKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS9iZDhkN2NmNWI4NDEwZmU5OGVi
YTA2YTlhYWE5MGVmZTg4ODE1ZDhhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEtYmQ4ZDdjZjVi
ODQxMGZlOThlYmEwNmE5YWFhOTBlZmU4ODgxNWQ4YQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWhhMi0wNzMxL2JkOGQ3Y2Y1Yjg0MTBmZTk4ZWJhMDZhOWFhYTkwZWZlODg4
MTVkOGEvdm1saW51ei0zLjE1LjAtcmM4LTA2MTk0LWdiZDhkN2NmCgoyMDE0LTA4LTAxLTA3
OjMyOjUxIGRldGVjdGluZyBib290IHN0YXRlIC4JMgkyOAkzOAk0Nwk2OQk3OQk4OAkxMDEJ
MTIyCTEzNwkxNDgJMTY3CTE3OAkyMDcJMjMxCTI0MAkyNjYJMjkwCTMwMCBTVUNDRVNTCgo5
MzlmMDRiZWMxYTRlZjZiYTQzNzBiMGYzNGIwMWRlY2M4NDRiMWIxIGlzIHRoZSBmaXJzdCBi
YWQgY29tbWl0CmNvbW1pdCA5MzlmMDRiZWMxYTRlZjZiYTQzNzBiMGYzNGIwMWRlY2M4NDRi
MWIxCkF1dGhvcjogSmFuIEthcmEgPGphY2tAc3VzZS5jej4KRGF0ZTogICBXZWQgSnVuIDQg
MTY6MTE6MzcgMjAxNCAtMDcwMAoKICAgIHByaW50azogZW5hYmxlIGludGVycnVwdHMgYmVm
b3JlIGNhbGxpbmcgY29uc29sZV90cnlsb2NrX2Zvcl9wcmludGsoKQogICAgCiAgICBXZSBu
ZWVkIGludGVycnVwdHMgZGlzYWJsZWQgd2hlbiBjYWxsaW5nIGNvbnNvbGVfdHJ5bG9ja19m
b3JfcHJpbnRrKCkKICAgIG9ubHkgc28gdGhhdCBjcHUgaWQgd2UgcGFzcyB0byBjYW5fdXNl
X2NvbnNvbGUoKSByZW1haW5zIHZhbGlkIChmb3IKICAgIG90aGVyIHRoaW5ncyBjb25zb2xl
X3NlbSBwcm92aWRlcyBhbGwgdGhlIGV4Y2x1c2lvbiB3ZSBuZWVkIGFuZAogICAgZGVhZGxv
Y2tzIG9uIGNvbnNvbGVfc2VtIGR1ZSB0byBpbnRlcnJ1cHRzIGFyZSBpbXBvc3NpYmxlIGJl
Y2F1c2Ugd2UgdXNlCiAgICBkb3duX3RyeWxvY2soKSkuICBIb3dldmVyIGlmIHdlIGFyZSBy
ZXNjaGVkdWxlZCwgd2UgYXJlIGd1YXJhbnRlZWQgdG8KICAgIHJ1biBvbiBhbiBvbmxpbmUg
Y3B1IHNvIHdlIGNhbiBlYXNpbHkganVzdCBnZXQgdGhlIGNwdSBpZCBpbgogICAgY2FuX3Vz
ZV9jb25zb2xlKCkuCiAgICAKICAgIFdlIGNhbiBsb3NlIGEgYml0IG9mIHBlcmZvcm1hbmNl
IHdoZW4gd2UgZW5hYmxlIGludGVycnVwdHMgaW4KICAgIHZwcmludGtfZW1pdCgpIGFuZCB0
aGVuIGRpc2FibGUgdGhlbSBhZ2FpbiBpbiBjb25zb2xlX3VubG9jaygpIGJ1dCBPVE9ICiAg
ICBpdCBjYW4gc29tZXdoYXQgcmVkdWNlIGludGVycnVwdCBsYXRlbmN5IGNhdXNlZCBieSBj
b25zb2xlX3VubG9jaygpCiAgICBlc3BlY2lhbGx5IHNpbmNlIGxhdGVyIGluIHRoZSBwYXRj
aCBzZXJpZXMgd2Ugd2lsbCB3YW50IHRvIHNwaW4gb24KICAgIGNvbnNvbGVfc2VtIGluIGNv
bnNvbGVfdHJ5bG9ja19mb3JfcHJpbnRrKCkuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IEph
biBLYXJhIDxqYWNrQHN1c2UuY3o+CiAgICBTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgTW9ydG9u
IDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPgogICAgU2lnbmVkLW9mZi1ieTogTGludXMg
VG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPgoKOjA0MDAwMCAwNDAw
MDAgMmY4ZTE5NTMzZTQyZGRmMTg5ODIxNWExZjc5MDkyNTE2Yjg5ODkxNCA4ZDc4MWRkYjhi
M2Y4NTkzMDkxMWE0ZmFkMDk2ZDhjZDU0MDg5ODZmIE0Ja2VybmVsCmJpc2VjdCBydW4gc3Vj
Y2VzcwpIRUFEIGlzIG5vdyBhdCBiZDhkN2NmLi4uIHByaW50azogZml4IGxvY2tkZXAgaW5z
dHJ1bWVudGF0aW9uIG9mIGNvbnNvbGVfc2VtCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEva3ZtYXJtOm5leHQ6YmQ4ZDdjZjVi
ODQxMGZlOThlYmEwNmE5YWFhOTBlZmU4ODgxNWQ4YTpiaXNlY3QtbGludXgtMgoKMjAxNC0w
OC0wMS0wNzo0MzoxOSBiZDhkN2NmNWI4NDEwZmU5OGViYTA2YTlhYWE5MGVmZTg4ODE1ZDhh
IHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxL2JkOGQ3Y2Y1Yjg0MTBm
ZTk4ZWJhMDZhOWFhYTkwZWZlODg4MTVkOGEvdm1saW51ei0zLjE1LjAtcmM4LTA2MTk0LWdi
ZDhkN2NmCgoyMDE0LTA4LTAxLTA3OjQzOjIwIGRldGVjdGluZyBib290IHN0YXRlIC4uCTYJ
MjMJMzAJNTMJODIJMTAzCTExMwkxMzgJMTcwCTE3MgkxODUJMjAwCTIwOAkyMTcJMjI3CTI0
MAkyNTEJMjYwCTI3MAkyNzkJMjg4CTMwMwkzMjUJMzM2CTM0NgkzNTYJMzY2CTM3MgkzNzkJ
Mzg0CTM4OQkzOTYJNDA4CTQxNwk0MjIJNDM1CTQ0NAk0NTEJNDcxCTQ5OAk1MTAJNTIxCTUz
Mwk1NDQJNTU5CTU3NAk1OTQJNjA0CTYxNQk2MjQJNjQ3CTY1NAk2NzIJNjgwCTY5NAk3MDUJ
NzEzCTczNQk3NTYJNzYzCTc3MAk3ODcJNzk4CTgwNwk4MjMJODM1CTg0NQk4NTUJODY5CTg3
Nwk4ODMJODk2CTkwMCBTVUNDRVNTCgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBiZDhk
N2NmLi4uIHByaW50azogZml4IGxvY2tkZXAgaW5zdHJ1bWVudGF0aW9uIG9mIGNvbnNvbGVf
c2VtCkhFQUQgaXMgbm93IGF0IGZiM2VjNjcuLi4gS1ZNOiBhcm02NDogR0lDdjM6IG1hbmRh
dGUgcGFnZS1hbGlnbmVkIEdJQ1YgcmVnaW9uCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEva3ZtYXJtOm5leHQ6ZmIzZWM2Nzk0
MmU5MmU1NzEzZTA1Yjc2OTFiMjc3ZDBhMGMwNTc1ZDpiaXNlY3QtbGludXgtMgogVEVTVCBG
QUlMVVJFCi9iaW4vc2g6IC9wcm9jL3NlbGYvZmQvOTogTm8gc3VjaCBmaWxlIG9yIGRpcmVj
dG9yeQpbICAgMTMuMzQxOTMyXSBzb2NrOiBwcm9jZXNzIGB0cmluaXR5LW1haW4nIGlzIHVz
aW5nIG9ic29sZXRlIHNldHNvY2tvcHQgU09fQlNEQ09NUEFUCgpCVUc6IGtlcm5lbCBib290
IGhhbmcKRWxhcHNlZCB0aW1lOiAzNQpxZW11LXN5c3RlbS14ODZfNjQgLWVuYWJsZS1rdm0g
LWNwdSBIYXN3ZWxsLCtzbWVwLCtzbWFwIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaGEyLTA3MzEvZmIzZWM2Nzk0MmU5MmU1NzEzZTA1Yjc2OTFiMjc3ZDBhMGMwNTc1ZC92
bWxpbnV6LTMuMTYuMC1yYzEtMDAxMzMtZ2ZiM2VjNjcgLWFwcGVuZCAnaHVuZ190YXNrX3Bh
bmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFf
YWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5p
Yz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFt
ZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICBy
b290PS9kZXYvcmFtMCBydyBsaW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctaGEyLTA3MzEva3ZtYXJtOm5leHQ6ZmIzZWM2Nzk0MmU5MmU1NzEzZTA1
Yjc2OTFiMjc3ZDBhMGMwNTc1ZDpiaXNlY3QtbGludXgtMi8udm1saW51ei1mYjNlYzY3OTQy
ZTkyZTU3MTNlMDViNzY5MWIyNzdkMGEwYzA1NzVkLTIwMTQwNzMxMjMyODQ4LTQta2J1aWxk
IGJyYW5jaD1rdm1hcm0vbmV4dCBCT09UX0lNQUdFPS9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWhhMi0wNzMxL2ZiM2VjNjc5NDJlOTJlNTcxM2UwNWI3NjkxYjI3N2QwYTBjMDU3NWQvdm1s
aW51ei0zLjE2LjAtcmMxLTAwMTMzLWdmYjNlYzY3IGRyYmQubWlub3JfY291bnQ9OCcgIC1p
bml0cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLWkzODYuY2d6IC1tIDMy
MCAtc21wIDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEg
LWJvb3Qgb3JkZXI9bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXJ0YyBiYXNl
PWxvY2FsdGltZSAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQtcXVhbnRhbC1rYnVpbGQt
MjIgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1xdWFudGFsLWtidWlsZC0y
MiAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaGEyLTA3MzEvZmIzZWM2Nzk0MmU5MmU1NzEzZTA1Yjc2OTFiMjc3ZDBh
MGMwNTc1ZC9kbWVzZy1xdWFudGFsLWtidWlsZC0yMzoyMDE0MDczMTIzMzQxMTppMzg2LXJh
bmRjb25maWctaGEyLTA3MzE6My4xNi4wLXJjMS0wMDEzMy1nZmIzZWM2NzoyNDEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvZmIzZWM2Nzk0MmU5MmU1NzEzZTA1Yjc2OTFi
Mjc3ZDBhMGMwNTc1ZC9kbWVzZy12bS1rYnVpbGQteW9jdG8taTM4Ni00NzoyMDE0MDczMTIz
MTkyNDppMzg2LXJhbmRjb25maWctaGEyLTA3MzE6My4xNi4wLXJjMS0wMDEzMy1nZmIzZWM2
NzoyNDEKNDE6Mjo1IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpIRUFEIGlzIG5vdyBh
dCBmYjNlYzY3IEtWTTogYXJtNjQ6IEdJQ3YzOiBtYW5kYXRlIHBhZ2UtYWxpZ25lZCBHSUNW
IHJlZ2lvbgoKPT09PT09PT09IGxpbnVzL21hc3RlciA9PT09PT09PT0KRnJvbSBnaXQ6Ly9n
aXRtaXJyb3IvbGludXMKICAgM2ExMTIyZC4uNmYwOTI4MCAgbWFzdGVyICAgICAtPiBsaW51
cy9tYXN0ZXIKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZmIzZWM2Ny4uLiBLVk06IGFy
bTY0OiBHSUN2MzogbWFuZGF0ZSBwYWdlLWFsaWduZWQgR0lDViByZWdpb24KSEVBRCBpcyBu
b3cgYXQgNmYwOTI4MC4uLiBNZXJnZSB0YWcgJ3BtK2FjcGktMy4xNi1yYzgnIG9mIGdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9yYWZhZWwvbGludXgt
cG0KbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1o
YTItMDczMS9saW51czptYXN0ZXI6NmYwOTI4MDM2YmNiZDhkZDJlYmVlOTIwMTU4MGRhOGJj
YzBhODFhZjpiaXNlY3QtbGludXgtMgoKMjAxNC0wOC0wMS0wODoyMToyMCA2ZjA5MjgwMzZi
Y2JkOGRkMmViZWU5MjAxNTgwZGE4YmNjMGE4MWFmIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWhhMi0wNzMxLzZmMDkyODAzNmJjYmQ4ZGQyZWJlZTkyMDE1ODBkYThiY2MwYTgx
YWYvdm1saW51ei0zLjE2LjAtcmM3LTAwMDgzLWc2ZjA5MjgwCgoyMDE0LTA4LTAxLTA4OjIx
OjIxIGRldGVjdGluZyBib290IHN0YXRlIC4uCTEyCTI0CTI3CTUyCTU5CTc2CTg2CTEwNQkx
MTIJMTMxCTE0MQkxNjMJMTgyCTIwMAkyMTYJMjQ1CTI1NgkyODUJMzAwCTMxOQkzMjkJMzQ4
CTM2MwkzNzUJMzk3Lgk0MjEJNDQwCTQ0OQk0NjQJNDg0CTQ5Ngk1MTcJNTMxCTU2OAk1ODQJ
NjEyCTY0MQk2NjkJNzAyCTcwNwk3NDUJNzg4CTgwNgk4MzAJODU5CTg4Mgk4OTIJODk1CTg5
Ni4JOTAwIFNVQ0NFU1MKCgo9PT09PT09PT0gbmV4dC9tYXN0ZXIgPT09PT09PT09ClByZXZp
b3VzIEhFQUQgcG9zaXRpb24gd2FzIDZmMDkyODAuLi4gTWVyZ2UgdGFnICdwbSthY3BpLTMu
MTYtcmM4JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvcmFmYWVsL2xpbnV4LXBtCkhFQUQgaXMgbm93IGF0IDVjMTU5NzguLi4gQWRkIGxpbnV4
LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwNzMxCmxzIC1hIC9rYnVpbGQtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEyLTA3MzEvbmV4dDptYXN0ZXI6NWMx
NTk3ODNlODA4NjY0NWRkN2FhNDJlMzVjNTMxYWQwZThkZDE2ZDpiaXNlY3QtbGludXgtMgoK
MjAxNC0wOC0wMS0wODo1MDoyMCA1YzE1OTc4M2U4MDg2NjQ1ZGQ3YWE0MmUzNWM1MzFhZDBl
OGRkMTZkIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS01YzE1OTc4M2U4MDg2NjQ1ZGQ3
YWE0MmUzNWM1MzFhZDBlOGRkMTZkCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaGEyLTA3MzEvNWMxNTk3ODNlODA4NjY0NWRkN2FhNDJlMzVjNTMxYWQw
ZThkZDE2ZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMi0wNzMxLTVjMTU5NzgzZTgwODY2NDVkZDdhYTQy
ZTM1YzUzMWFkMGU4ZGQxNmQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1oYTIt
MDczMS01YzE1OTc4M2U4MDg2NjQ1ZGQ3YWE0MmUzNWM1MzFhZDBlOGRkMTZkCnN0YXR1czog
RkFJTDogYnVpbGQgZXJyb3IKG1sxOzM1bTIwMTQtMDgtMDEgMDg6NTQ6MjAgS2VybmVsIGJ1
aWxkIGZhaWwgb3IgdGltZW91dBtbMG0KMjAxNC0wOC0wMS0wODo1NDoyMCA1YzE1OTc4M2U4
MDg2NjQ1ZGQ3YWE0MmUzNWM1MzFhZDBlOGRkMTZkIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNr
IC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL2kzODYtcmFuZGNvbmZpZy1oYTItMDczMS01
YzE1OTc4M2U4MDg2NjQ1ZGQ3YWE0MmUzNWM1MzFhZDBlOGRkMTZkCg==

--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.15.0-rc8-06195-g939f04b"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.15.0-rc8 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_SCHED is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
# CONFIG_MODULE_SIG_ALL is not set

#
# Do not forget to sign required modules with scripts/sign-file
#
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
CONFIG_MODULE_SIG_SHA512=y
CONFIG_MODULE_SIG_HASH="sha512"
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
CONFIG_MPENTIUMM=y
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=m
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
# CONFIG_ACPI_THERMAL is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_REDUCED_HARDWARE_ONLY=y
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=m
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=m
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
CONFIG_X86_E_POWERSAVER=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_CPU_IDLE_GOV_MENU is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=m
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
CONFIG_RAPIDIO=m
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=m

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=m
# CONFIG_RAPIDIO_TSI568 is not set
# CONFIG_RAPIDIO_CPS_GEN2 is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=m
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
CONFIG_CMA_SIZE_SEL_MIN=y
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=m
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=y
CONFIG_ISL29020=m
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=m
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_SRAM=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_NOSY=m
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
# CONFIG_I2O_BUS is not set
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_88PM860X is not set
CONFIG_TOUCHSCREEN_AD7879=m
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_WM831X is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_MC13783=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
# CONFIG_TOUCHSCREEN_USB_ETURBO is not set
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
CONFIG_TOUCHSCREEN_USB_E2I=y
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
# CONFIG_TOUCHSCREEN_USB_EASYTOUCH is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_W90X900 is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_TOUCHSCREEN_ZFORCE=y
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM860X_ONKEY is not set
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=m
CONFIG_INPUT_BMA150=m
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=m
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=m
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_PWM_BEEPER=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
CONFIG_INPUT_IMS_PCU=y
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=m
CONFIG_INPUT_IDEAPAD_SLIDEBAR=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_ATMEL is not set
CONFIG_HW_RANDOM_GEODE=m
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_HW_RANDOM_EXYNOS is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=m
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=m
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=m
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
CONFIG_SCx200_ACB=m
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_PINCTRL=y

#
# Pin controllers
#
# CONFIG_PINMUX is not set
# CONFIG_PINCONF is not set
CONFIG_DEBUG_PINCTRL=y
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=m
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=m
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TWL6040=m
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=m
CONFIG_GPIO_WM8994=m
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
CONFIG_GPIO_BT8XX=m
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
# CONFIG_GPIO_KEMPLD is not set

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
# CONFIG_GPIO_PALMAS is not set
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_MAX8925_POWER=m
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=m
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=m
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_LP8788 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=m
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=m
CONFIG_CHARGER_TPS65090=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_MC13783_ADC is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=m
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4222=m
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=m
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_NCT6683=m
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
# CONFIG_SENSORS_WM8350 is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_WM8350_WATCHDOG=m
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=m
# CONFIG_RETU_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=m
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=m
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_KEMPLD_WDT is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
CONFIG_60XX_WDT=m
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=m
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=m
CONFIG_VIA_WDT=m
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=m
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=m
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=m
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=m
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=m
CONFIG_MFD_RTSX_USB=y
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS65218 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=m
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=m
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ACT8865=m
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_ANATOP=m
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_DA9063=m
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=m
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_LTC3589 is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX77686=m
CONFIG_REGULATOR_MAX77693=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_PALMAS=y
# CONFIG_REGULATOR_PFUZE100 is not set
CONFIG_REGULATOR_TPS51632=m
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65090=m
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS6586X=m
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_TPS80031=m
CONFIG_REGULATOR_WM831X=m
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_REGULATOR_WM8400=y
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=m
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_USB_SUPPORT is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_ZORAN=y
# CONFIG_VIDEO_ZORAN_DC30 is not set
CONFIG_VIDEO_ZORAN_ZR36060=y
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_LML33=m
# CONFIG_VIDEO_ZORAN_LML33R10 is not set
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_HEXIUM_GEMINI=y
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_MXB=y

#
# Media capture/analog/hybrid TV support
#
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_MPEG=m
# CONFIG_VIDEO_BT848 is not set
CONFIG_VIDEO_SAA7134=y
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=m
CONFIG_VIDEO_VIA_CAMERA=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_SCALE_CROP=m
CONFIG_SOC_CAMERA_PLATFORM=m
# CONFIG_VIDEO_RCAR_VIN is not set
# CONFIG_VIDEO_SH_MOBILE_CSI2 is not set
CONFIG_VIDEO_SH_MOBILE_CEU=m
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_TVEEPROM=y
# CONFIG_CYPRESS_FIRMWARE is not set
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=m
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_TLV320AIC23B=m
CONFIG_VIDEO_UDA1342=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=m
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_ADV7604=y
CONFIG_VIDEO_ADV7842=y
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA7191=y
CONFIG_VIDEO_TVP514X=y
# CONFIG_VIDEO_TVP5150 is not set
CONFIG_VIDEO_TVP7002=m
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=y
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=m
CONFIG_VIDEO_ADV7511=y
# CONFIG_VIDEO_AD9389B is not set
CONFIG_VIDEO_AK881X=m
CONFIG_VIDEO_THS8200=m

#
# Camera sensor devices
#
CONFIG_VIDEO_APTINA_PLL=y
# CONFIG_VIDEO_OV7640 is not set
CONFIG_VIDEO_OV7670=y
CONFIG_VIDEO_OV9650=y
# CONFIG_VIDEO_VS6624 is not set
CONFIG_VIDEO_MT9M032=y
# CONFIG_VIDEO_MT9P031 is not set
CONFIG_VIDEO_MT9T001=y
# CONFIG_VIDEO_MT9V011 is not set
CONFIG_VIDEO_MT9V032=m
CONFIG_VIDEO_SR030PC30=m
CONFIG_VIDEO_NOON010PC30=m
CONFIG_VIDEO_M5MOLS=y
CONFIG_VIDEO_S5K6AA=m
# CONFIG_VIDEO_S5K6A3 is not set
CONFIG_VIDEO_S5K4ECGX=y
# CONFIG_VIDEO_S5K5BAF is not set
# CONFIG_VIDEO_SMIAPP is not set

#
# Flash devices
#
CONFIG_VIDEO_ADP1653=m
# CONFIG_VIDEO_AS3645A is not set
CONFIG_VIDEO_LM3560=y
# CONFIG_VIDEO_LM3646 is not set

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=m
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#

#
# soc_camera sensor drivers
#
CONFIG_SOC_CAMERA_IMX074=m
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9M111=m
# CONFIG_SOC_CAMERA_MT9T031 is not set
CONFIG_SOC_CAMERA_MT9T112=m
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_SOC_CAMERA_OV2640=m
CONFIG_SOC_CAMERA_OV5642=m
CONFIG_SOC_CAMERA_OV6650=m
# CONFIG_SOC_CAMERA_OV772X is not set
CONFIG_SOC_CAMERA_OV9640=m
# CONFIG_SOC_CAMERA_OV9740 is not set
CONFIG_SOC_CAMERA_RJ54N1=m
# CONFIG_SOC_CAMERA_TW9910 is not set
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=m
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=m
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
# CONFIG_MEDIA_TUNER_E4000 is not set
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_M88TS2022=y
CONFIG_MEDIA_TUNER_TUA9001=y
# CONFIG_MEDIA_TUNER_IT913X is not set
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_V4L=y
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=y

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=m
CONFIG_AGP_INTEL=m
CONFIG_AGP_NVIDIA=m
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=m
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
CONFIG_INTEL_GTT=m
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=m
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=m
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_I810=m
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=m
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=m
CONFIG_DRM_VMWGFX=m
# CONFIG_DRM_VMWGFX_FBCON is not set
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
CONFIG_DRM_UDL=y
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=y
CONFIG_DRM_PTN3460=m

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
CONFIG_FB_N411=m
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=m
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_I740=y
# CONFIG_FB_I810 is not set
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
# CONFIG_FB_S3_DDC is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=m
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=m
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_MAX8925=m
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_AAT2870=y
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_LP8788=m
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_GPIO=m
CONFIG_BACKLIGHT_LV5207LP=m
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
CONFIG_HDMI=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
# CONFIG_USB_MOUSE is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_OTG_FSM=m
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=m
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_HCD_PCI=m
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=m
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_R8A66597_HCD=m
CONFIG_USB_RENESAS_USBHS_HCD=m
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=m
CONFIG_USB_HCD_BCMA=m
CONFIG_USB_HCD_SSB=m
# CONFIG_USB_HCD_TEST_MODE is not set
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DUAL_ROLE is not set

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=m

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_UDC is not set
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=y
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
CONFIG_USB_GPIO_VBUS=m
CONFIG_TAHVO_USB=m
# CONFIG_TAHVO_USB_HOST_BY_DEFAULT is not set
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
CONFIG_USB_GR_UDC=m
CONFIG_USB_R8A66597=y
# CONFIG_USB_RENESAS_USBHS_UDC is not set
CONFIG_USB_PXA27X=m
CONFIG_USB_MV_UDC=m
CONFIG_USB_MV_U3D=m
CONFIG_USB_M66592=m
CONFIG_USB_AMD5536UDC=m
CONFIG_USB_NET2272=y
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
CONFIG_USB_GOKU=m
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_CONFIGFS=m
# CONFIG_USB_CONFIGFS_SERIAL is not set
# CONFIG_USB_CONFIGFS_ACM is not set
# CONFIG_USB_CONFIGFS_OBEX is not set
# CONFIG_USB_CONFIGFS_NCM is not set
# CONFIG_USB_CONFIGFS_ECM is not set
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
# CONFIG_USB_CONFIGFS_RNDIS is not set
# CONFIG_USB_CONFIGFS_EEM is not set
# CONFIG_USB_CONFIGFS_F_LB_SS is not set
# CONFIG_USB_CONFIGFS_F_FS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
CONFIG_USB_GADGETFS=m
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_G_SERIAL is not set
CONFIG_USB_G_PRINTER=m
# CONFIG_USB_CDC_COMPOSITE is not set
CONFIG_USB_G_HID=m
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
# CONFIG_UWB_I1480U is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_MEMSTICK_R592=m
# CONFIG_MEMSTICK_REALTEK_PCI is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_NET48XX=m
CONFIG_LEDS_WRAP=m
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_DELL_NETBOOKS=y
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_LP8788 is not set
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8925 is not set
# CONFIG_RTC_DRV_MAX77686 is not set
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=m
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PALMAS=y
CONFIG_RTC_DRV_PCF2127=m
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TPS6586X is not set
CONFIG_RTC_DRV_TPS65910=m
CONFIG_RTC_DRV_TPS80031=m
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
CONFIG_COMEDI_KCOMEDILIB=m
# CONFIG_COMEDI_BOND is not set
CONFIG_COMEDI_TEST=m
CONFIG_COMEDI_PARPORT=m
# CONFIG_COMEDI_SERIAL2002 is not set
# CONFIG_COMEDI_SKEL is not set
CONFIG_COMEDI_SSV_DNP=m
# CONFIG_COMEDI_ISA_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_USB_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
# CONFIG_TRANZPORT is not set
CONFIG_DX_SEP=y

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=m

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_TSL2583=y
CONFIG_TSL2x7x=m

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y

#
# Active energy metering IC
#
CONFIG_ADE7854=m
# CONFIG_ADE7854_I2C is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
# CONFIG_IIO_PERIODIC_RTC_TRIGGER is not set
CONFIG_IIO_DUMMY_EVGEN=m
CONFIG_IIO_SIMPLE_DUMMY=m
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_CRYSTALHD is not set
CONFIG_FB_XGI=m
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y
CONFIG_VIDEO_DT3155=y
CONFIG_DT3155_CCIR=y
# CONFIG_DT3155_STREAMING is not set
CONFIG_VIDEO_V4L2_INT_DEVICE=y
CONFIG_VIDEO_TCM825X=y

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_BINDER_IPC_32BIT=y
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_ANDROID_INTF_ALARM_DEV is not set
# CONFIG_SYNC is not set
CONFIG_ION=y
# CONFIG_ION_TEST is not set
# CONFIG_ION_DUMMY is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_LTE_GDM724X is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
# CONFIG_GS_FPGABOOT is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
# CONFIG_ACERHDF is not set
CONFIG_ALIENWARE_WMI=y
CONFIG_ASUS_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_AIO=m
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=y
CONFIG_TC1100_WMI=m
CONFIG_HP_ACCEL=y
CONFIG_HP_WIRELESS=y
CONFIG_HP_WMI=m
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
# CONFIG_THINKPAD_ACPI_VIDEO is not set
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=y
# CONFIG_EEEPC_LAPTOP is not set
CONFIG_ASUS_WMI=y
CONFIG_ASUS_NB_WMI=m
# CONFIG_EEEPC_WMI is not set
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=m
# CONFIG_TOPSTAR_LAPTOP is not set
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=m
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
CONFIG_INTEL_SMARTCONNECT=m
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_WM831X=y
CONFIG_COMMON_CLK_MAX77686=y
# CONFIG_COMMON_CLK_SI5351 is not set
CONFIG_CLK_TWL6040=m

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_ADC_JACK=m
CONFIG_EXTCON_MAX77693=m
CONFIG_EXTCON_PALMAS=m
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=m
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
CONFIG_MMA8452=y

#
# Analog to digital converters
#
# CONFIG_AD799X is not set
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=m
CONFIG_MCP3422=m
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m
CONFIG_TI_AM335X_ADC=m

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5380=y
CONFIG_AD5446=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_ITG3200=y

#
# Humidity sensors
#
# CONFIG_DHT11 is not set
CONFIG_SI7005=m

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=y
CONFIG_CM32181=m
CONFIG_CM36651=m
CONFIG_GP2AP020A00F=y
CONFIG_LTR501=m
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL4531=m
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
# CONFIG_MAG3110 is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_MPL115=y
CONFIG_MPL3115=m
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m

#
# Lightning sensors
#

#
# Temperature sensors
#
CONFIG_MLX90614=y
# CONFIG_TMP006 is not set
CONFIG_NTB=m
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
# CONFIG_VME_USER is not set
# CONFIG_VME_PIO2 is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LPSS is not set
CONFIG_IPACK_BUS=m
CONFIG_BOARD_TPCI200=m
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_PHY_SAMSUNG_USB2=m
# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_RUNTIME_MAP=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=m

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ECRYPT_FS is not set
# CONFIG_PSTORE is not set
CONFIG_EFIVAR_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=m
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
# CONFIG_TEST_USER_COPY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_EFI is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_BIG_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
# CONFIG_CRYPTO_HMAC is not set
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=m
# CONFIG_CRYPTO_CRCT10DIF is not set
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=m
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=m
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_GEODE=m
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y

--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--b5gNqxB1S1yM7hjW--
