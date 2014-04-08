Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbaDHC57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 22:57:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:31886 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556AbaDHC5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 22:57:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,815,1389772800"; 
   d="scan'208";a="516604507"
Date: Tue, 8 Apr 2014 10:55:55 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jet Chen <jet.chen@intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [clocksource]  INFO: possible irq lock inversion dependency
 detected
Message-ID: <20140408025555.GC16434@localhost>
References: <5342BCD1.4050202@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5342BCD1.4050202@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jet please fix the line wrapping problem. It's in a mess.

On Mon, Apr 07, 2014 at 10:57:21PM +0800, Jet Chen wrote:
> Hi Viresh,
> 
> Your patch on my testing branch in LKP system:
> git://bee.sh.intel.com/git/tchen37/linux.git timer_debug3 got the
> below dmesg.
> FYI, I applied your patch on the top of commit
> 6378cb51af5f4743db0dcb3cbcf862eac5908754 - timer: don't migrate
> pinned timers.
> 
> commit 90585a71ecf3285bc73d54e37080c3bb21583594
> Author:     Viresh Kumar <viresh.kumar@linaro.org>
> AuthorDate: Sat Apr 5 11:43:25 2014 +0530
> Commit:     Jet Chen <jet.chen@intel.com>
> CommitDate: Sat Apr 5 14:32:32 2014 +0800
> 
>      clocksource: register cpu notifier to remove timer from dying CPU
>          clocksource core is using add_timer_on() to run
> clocksource_watchdog() on all
>      CPUs one by one. But when a core is brought down, clocksource
> core doesn't
>      remove this timer from the dying CPU. And in this case timer
> core gives this
>      (Gives this only with unmerged code, anyway in the current code
> as well timer
>      core is migrating a pinned timer to other CPUs, which is also wrong:
>      http://www.gossamer-threads.com/lists/linux/kernel/1898117)
>          migrate_timer_list: can't migrate pinned timer: ffffffff81f06a60,
>      timer->function: ffffffff810d7010,deactivating it Modules linked in:
>          CPU: 0 PID: 1932 Comm: 01-cpu-hotplug Not tainted
> 3.14.0-rc1-00088-gab3c4fd #4
>      Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>       0000000000000009 ffff88001d407c38 ffffffff817237bd ffff88001d407c80
>       ffff88001d407c70 ffffffff8106a1dd 0000000000000010 ffffffff81f06a60
>       ffff88001e04d040 ffffffff81e3d4c0 ffff88001e04d030 ffff88001d407cd0
>      Call Trace:
>       [<ffffffff817237bd>] dump_stack+0x4d/0x66
>       [<ffffffff8106a1dd>] warn_slowpath_common+0x7d/0xa0
>       [<ffffffff8106a24c>] warn_slowpath_fmt+0x4c/0x50
>       [<ffffffff810761c3>] ? __internal_add_timer+0x113/0x130
>       [<ffffffff810d7010>] ? clocksource_watchdog_kthread+0x40/0x40
>       [<ffffffff8107753b>] migrate_timer_list+0xdb/0xf0
>       [<ffffffff810782dc>] timer_cpu_notify+0xfc/0x1f0
>       [<ffffffff8173046c>] notifier_call_chain+0x4c/0x70
>       [<ffffffff8109340e>] __raw_notifier_call_chain+0xe/0x10
>       [<ffffffff8106a3f3>] cpu_notify+0x23/0x50
>       [<ffffffff8106a44e>] cpu_notify_nofail+0xe/0x20
>       [<ffffffff81712a5d>] _cpu_down+0x1ad/0x2e0
>       [<ffffffff81712bc4>] cpu_down+0x34/0x50
>       [<ffffffff813fec54>] cpu_subsys_offline+0x14/0x20
>       [<ffffffff813f9f65>] device_offline+0x95/0xc0
>       [<ffffffff813fa060>] online_store+0x40/0x90
>       [<ffffffff813f75d8>] dev_attr_store+0x18/0x30
>       [<ffffffff8123309d>] sysfs_kf_write+0x3d/0x50
>          This patch tries to fix this by registering cpu notifiers
> from clocksource core,
>      only when we start clocksource-watchdog. And if on the CPU_DEAD
> notification it
>      is found that dying CPU was the CPU on which this timer is
> queued on, then it is
>      removed from that CPU and queued to next CPU.
>      Reported-by: Jet Chen <jet.chen@intel.com>
>      Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>      Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> ===================================================
> PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> ===================================================
> 
> +------------------------------------------------------------------+------------+------------+------------+
> |                                                                  |
> 6378cb51af | 90585a71ec | 3db74909a7 |
> +------------------------------------------------------------------+------------+------------+------------+
> | boot_successes                                                   |
> 24          | 0          | 0          |
> | boot_failures                                                    |
> 56          | 20         | 13         |
> | BUG:soft_lockup-CPU_stuck_for_s                                  |
> 50          |            |            |
> | EIP_is_at_insert                                                 |
> 10          |            |            |
> | Kernel_panic-not_syncing:softlockup:hung_tasks                   |
> 50          |            |            |
> | backtrace:rbtree_test_init                                       |
> 41          |            |            |
> | backtrace:kernel_init_freeable                                   |
> 49          | 20         | 13         |
> | backtrace:apic_timer_interrupt                                   |
> 44          |            |            |
> | EIP_is_at_rbtree_test_init                                       |
> 17          |            |            |
> | EIP_is_at_rb_erase                                               |
> 11          |            |            |
> | EIP_is_at_rb_insert_color                                        |
> 9         |            |            |
> | backtrace:insert                                                 |
> 4         |            |            |
> | Out_of_memory:Kill_process                                       |
> 6         | 2          | 1          |
> | Kernel_panic-not_syncing:Out_of_memory_and_no_killable_processes |
> 6         | 1          | 1          |
> | backtrace:tty_ldisc_setup                                        |
> 1         |            |            |
> | backtrace:tty_init_dev                                           |
> 1         |            |            |
> | backtrace:do_sys_open                                            |
> 1         |            |            |
> | backtrace:SyS_open                                               |
> 1         |            |            |
> | EIP_is_at__do_softirq                                            |
> 1         |            |            |
> | EIP_is_at_strcmp                                                 |
> 1         |            |            |
> | backtrace:gcov_enable_events                                     |
> 1         |            |            |
> | backtrace:gcov_fs_init                                           |
> 1         |            |            |
> | EIP_is_at__rb_erase_color                                        |
> 1         |            |            |
> | INFO:possible_irq_lock_inversion_dependency_detected             |
> 0         | 20         | 13         |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference             |
> 0         | 7          |            |
> | Oops                                                             |
> 0         | 4          |            |
> | Kernel_panic-not_syncing:Fatal_exception                         |
> 0         | 4          |            |
> | backtrace:register_cpu_notifier                                  |
> 0         | 20         | 13         |
> | backtrace:page_writeback_init                                    |
> 0         | 20         | 13         |
> | backtrace:cpu_up                                                 |
> 0         | 20         | 13         |
> | backtrace:smp_init                                               |
> 0         | 20         | 13         |
> | backtrace:kmem_cache_init                                        |
> 0         | 10         | 5          |
> | backtrace:tsc_refine_calibration_work                            |
> 0         | 20         | 13         |
> | backtrace:vfs_read                                               |
> 0         | 4          |            |
> | backtrace:SyS_read                                               |
> 0         | 4          |            |
> | backtrace:slab_sysfs_init                                        |
> 0         | 2          | 4          |
> | backtrace:kvm_guest_init                                         |
> 0         | 10         | 8          |
> | backtrace:__clocksource_register_scale                           |
> 0         | 10         | 8          |
> | backtrace:kvmclock_init                                          |
> 0         | 10         | 8          |
> | backtrace:__mm_populate                                          |
> 0         | 1          |            |
> | backtrace:SyS_mlockall                                           |
> 0         | 1          |            |
> | backtrace:__raw_spin_lock_init                                   |
> 0         | 1          |            |
> +------------------------------------------------------------------+------------+------------+------------+
> 
> [    3.650334] crc32c_combine: 8373 self tests passed
> [    3.651169] rbtree testing
> [    3.787010] =========================================================
> [    3.787976] [ INFO: possible irq lock inversion dependency detected ]
> [    3.788955] 3.14.0-rc1-00088-g90585a7 #2 Not tainted
> [    3.789772] ---------------------------------------------------------
> [    3.789969] swapper/0/1 just changed the state of lock:
> [    3.789969]  (watchdog_lock){..-...}, at: [<c1124731>]
> clocksource_watchdog+0x21/0x450
> [    3.789969] but this lock took another, SOFTIRQ-unsafe lock in the past:
> [    3.789969]  (cpu_add_remove_lock){+.+.+.}
> 
> and interrupts could create inverse lock ordering between them.
> 
> [    3.789969] [    3.789969] other info that might help us debug this:
> [    3.789969]  Possible interrupt unsafe locking scenario:
> [    3.789969] [    3.789969]        CPU0                    CPU1
> [    3.789969]        ----                    ----
> [    3.789969]   lock(cpu_add_remove_lock);
> [    3.789969]                                local_irq_disable();
> [    3.789969]                                lock(watchdog_lock);
> [    3.789969]                                lock(cpu_add_remove_lock);
> [    3.789969]   <Interrupt>
> [    3.789969]     lock(watchdog_lock);
> [    3.789969] [    3.789969]  *** DEADLOCK ***
> [    3.789969] [    3.789969] 1 lock held by swapper/0/1:
> [    3.789969]  #0:  ((&watchdog_timer)){+.-...}, at: [<c1090560>]
> call_timer_fn+0x0/0x170
> [    3.789969] [    3.789969] the shortest dependencies between 2nd
> lock and 1st lock:
> [    3.789969]  -> (cpu_add_remove_lock){+.+.+.} ops: 16 {
> [    3.789969]     HARDIRQ-ON-W at:
> [    3.789969]                       [<c10f8345>]
> __lock_acquire+0xa05/0x1880
> [    3.789969]                       [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]                       [<c2895b78>]
> mutex_lock_nested+0x98/0x790
> [    3.789969]                       [<c28708c0>]
> register_cpu_notifier+0x20/0x70
> [    3.789969]                       [<c33ad060>]
> page_writeback_init+0x2e/0x56
> [    3.789969]                       [<c337c5e8>] start_kernel+0x9f0/0xa51
> [    3.789969]                       [<c337b3c8>]
> i386_start_kernel+0x19e/0x1af
> [    3.789969]     SOFTIRQ-ON-W at:
> [    3.789969]                       [<c10f8393>]
> __lock_acquire+0xa53/0x1880
> [    3.789969]                       [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]                       [<c2895b78>]
> mutex_lock_nested+0x98/0x790
> [    3.789969]                       [<c28708c0>]
> register_cpu_notifier+0x20/0x70
> [    3.789969]                       [<c33ad060>]
> page_writeback_init+0x2e/0x56
> [    3.789969]                       [<c337c5e8>] start_kernel+0x9f0/0xa51
> [    3.789969]                       [<c337b3c8>]
> i386_start_kernel+0x19e/0x1af
> [    3.789969]     RECLAIM_FS-ON-W at:
> [    3.789969]                          [<c10f35e0>]
> mark_held_locks+0xc0/0x1e0
> [    3.789969]                          [<c10f4966>]
> lockdep_trace_alloc+0x126/0x230
> [    3.789969]                          [<c11c345f>]
> kmem_cache_alloc+0x3f/0x260
> [    3.789969]                          [<c10be745>]
> __smpboot_create_thread+0x55/0x190
> [    3.789969]                          [<c10beb6b>]
> smpboot_create_threads+0x7b/0xc0
> [    3.789969]                          [<c107f1da>] cpu_up+0x12a/0x520
> [    3.789969]                          [<c33a90dc>] smp_init+0x18b/0x1f2
> [    3.789969]                          [<c337c957>]
> kernel_init_freeable+0xec/0x3f4
> [    3.789969]                          [<c286fff9>] kernel_init+0x19/0x230
> [    3.789969]                          [<c289eef7>]
> ret_from_kernel_thread+0x1b/0x28
> [    3.789969]     INITIAL USE at:
> [    3.789969]                      [<c10f7dbc>] __lock_acquire+0x47c/0x1880
> [    3.789969]                      [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]                      [<c2895b78>]
> mutex_lock_nested+0x98/0x790
> [    3.789969]                      [<c28708c0>]
> register_cpu_notifier+0x20/0x70
> [    3.789969]                      [<c339e846>] kvm_guest_init+0x1bc/0x24d
> [    3.789969]                      [<c33820b8>] setup_arch+0x1835/0x18e2
> [    3.789969]                      [<c337bd3d>] start_kernel+0x145/0xa51
> [    3.789969]                      [<c337b3c8>]
> i386_start_kernel+0x19e/0x1af
> [    3.789969]   }
> [    3.789969]   ... key      at: [<c3080a80>] cpu_add_remove_lock+0x40/0xf0
> [    3.789969]   ... acquired at:
> [    3.789969]    [<c10f7fab>] __lock_acquire+0x66b/0x1880
> [    3.789969]    [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]    [<c2895b78>] mutex_lock_nested+0x98/0x790
> [    3.789969]    [<c28708c0>] register_cpu_notifier+0x20/0x70
> [    3.789969]    [<c112389e>] clocksource_enqueue_watchdog+0xde/0x230
> [    3.789969]    [<c11250b1>] __clocksource_register_scale+0xf1/0x140
> [    3.789969]    [<c100fe9d>] tsc_refine_calibration_work+0x1bd/0x2a0
> [    3.789969]    [<c10a5495>] process_one_work+0x265/0x740
> [    3.789969]    [<c10a612a>] worker_thread+0x28a/0x6f0
> [    3.789969]    [<c10b1b60>] kthread+0x110/0x150
> [    3.789969]    [<c289eef7>] ret_from_kernel_thread+0x1b/0x28
> [    3.789969] [    3.789969] -> (watchdog_lock){..-...} ops: 8 {
> [    3.789969]    IN-SOFTIRQ-W at:
> [    3.789969]                     [<c10f8510>] __lock_acquire+0xbd0/0x1880
> [    3.789969]                     [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]                     [<c289c6d7>] _raw_spin_lock+0x67/0x110
> [    3.789969]                     [<c1124731>]
> clocksource_watchdog+0x21/0x450
> [    3.789969]                     [<c1090607>] call_timer_fn+0xa7/0x170
> [    3.789969]                     [<c1090b76>]
> run_timer_softirq+0x206/0x380
> [    3.789969]                     [<c108614c>] __do_softirq+0x14c/0x380
> [    3.789969]    INITIAL USE at:
> [    3.789969]                    [<c10f7dbc>] __lock_acquire+0x47c/0x1880
> [    3.789969]                    [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]                    [<c289c825>]
> _raw_spin_lock_irqsave+0xa5/0x150
> [    3.789969]                    [<c11237e2>]
> clocksource_enqueue_watchdog+0x22/0x230
> [    3.789969]                    [<c11250b1>]
> __clocksource_register_scale+0xf1/0x140
> [    3.789969]                    [<c339eba6>] kvmclock_init+0x2cf/0x35b
> [    3.789969]                    [<c3381f80>] setup_arch+0x16fd/0x18e2
> [    3.789969]                    [<c337bd3d>] start_kernel+0x145/0xa51
> [    3.789969]                    [<c337b3c8>] i386_start_kernel+0x19e/0x1af
> [    3.789969]  }
> [    3.789969]  ... key      at: [<c30963d0>] watchdog_lock+0x10/0x40
> [    3.789969]  ... acquired at:
> [    3.789969]    [<c10ef619>] check_usage_forwards+0xb9/0x190
> [    3.789969]    [<c10f2fab>] mark_lock+0x69b/0xc10
> [    3.789969]    [<c10f8510>] __lock_acquire+0xbd0/0x1880
> [    3.789969]    [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]    [<c289c6d7>] _raw_spin_lock+0x67/0x110
> [    3.789969]    [<c1124731>] clocksource_watchdog+0x21/0x450
> [    3.789969]    [<c1090607>] call_timer_fn+0xa7/0x170
> [    3.789969]    [<c1090b76>] run_timer_softirq+0x206/0x380
> [    3.789969]    [<c108614c>] __do_softirq+0x14c/0x380
> [    3.789969] [    3.789969] [    3.789969] stack backtrace:
> [    3.789969] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
> 3.14.0-rc1-00088-g90585a7 #2
> [    3.789969] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    3.789969]  c3adc020 d180dd7c c287f340 d180ddd8 d180ddb8
> c10ef2b9 c2e845e0 c2e8492e
> [    3.789969]  00000001 d180ddd8 00000006 c10ef560 d180ddb8
> c10ed183 00000000 00000000
> [    3.789969]  d186054c d1860000 c10ef560 d180de04 c10ef619
> d186054c 00000001 c2e8492e
> [    3.789969] Call Trace:
> [    3.789969]  [<c287f340>] dump_stack+0xb8/0x108
> [    3.789969]  [<c10ef2b9>] print_irq_inversion_bug+0x389/0x4a0
> [    3.789969]  [<c10ef560>] ? check_usage_backwards+0x190/0x190
> [    3.789969]  [<c10ed183>] ? find_usage_forwards+0x53/0xd0
> [    3.789969]  [<c10ef560>] ? check_usage_backwards+0x190/0x190
> [    3.789969]  [<c10ef619>] check_usage_forwards+0xb9/0x190
> [    3.789969]  [<c10f2fab>] mark_lock+0x69b/0xc10
> [    3.789969]  [<c1008e7d>] ? print_context_stack+0x5d/0x160
> [    3.789969]  [<c10f8510>] __lock_acquire+0xbd0/0x1880
> [    3.789969]  [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]  [<c1124731>] ? clocksource_watchdog+0x21/0x450
> [    3.789969]  [<c289c6d7>] _raw_spin_lock+0x67/0x110
> [    3.789969]  [<c1124731>] ? clocksource_watchdog+0x21/0x450
> [    3.789969]  [<c1124710>] ? clocksource_cpu_notify+0xd0/0xd0
> [    3.789969]  [<c1124731>] clocksource_watchdog+0x21/0x450
> [    3.789969]  [<c1090560>] ? process_timeout+0x30/0x30
> [    3.789969]  [<c1124710>] ? clocksource_cpu_notify+0xd0/0xd0
> [    3.789969]  [<c1090607>] call_timer_fn+0xa7/0x170
> [    3.789969]  [<c1090560>] ? process_timeout+0x30/0x30
> [    3.789969]  [<c1090b76>] run_timer_softirq+0x206/0x380
> [    3.789969]  [<c1124710>] ? clocksource_cpu_notify+0xd0/0xd0
> [    3.789969]  [<c108614c>] __do_softirq+0x14c/0x380
> [    3.789969]  [<c1086000>] ? _local_bh_enable+0xa0/0xa0
> [    3.789969]  <IRQ>  [<c10868eb>] ? irq_exit+0xcb/0xe0
> [    3.789969]  [<c104c74b>] ? smp_apic_timer_interrupt+0x6b/0x90
> [    3.789969]  [<c289eb02>] ? apic_timer_interrupt+0x32/0x38
> [    3.789969]  [<c28800d8>] ? check+0x7e/0x52d
> [    3.789969]  [<c33c846b>] ? rbtree_test_init+0xa3/0x45f
> [    3.789969]  [<c33aaad6>] ? audit_register_class+0x29/0x10a
> [    3.789969]  [<c33c83c8>] ? test_atomic64+0xdc0/0xdc0
> [    3.789969]  [<c337c73f>] ? do_one_initcall+0xf6/0x222
> [    3.789969]  [<c10ae871>] ? parameq+0x21/0x100
> [    3.789969]  [<c337b749>] ? repair_env_string+0x32/0xd3
> [    3.789969]  [<c10aec3b>] ? parse_args+0x2eb/0x5f0
> [    3.789969]  [<c337cad7>] ? kernel_init_freeable+0x26c/0x3f4
> [    3.789969]  [<c337b717>] ? do_early_param+0x131/0x131
> [    3.789969]  [<c286fff9>] ? kernel_init+0x19/0x230
> [    3.789969]  [<c289eef7>] ? ret_from_kernel_thread+0x1b/0x28
> [    3.789969]  [<c286ffe0>] ? rest_init+0x170/0x170
> [    4.202425]  -> 13739 cycles
> [    4.252106] augmented rbtree testing -> 15602 cycles
> [    4.943124] Console: switching consoles 13-16 to MDA-2
> 
> git bisect start 3db74909a7c789e467b126d837f7e0cea4a5c165
> 455c6fdbd219161bd09b1165f11699d6d73de11c --
> git bisect  bad 1301fa9378b394d49525c4a3df8e61a64b11fd0d  # 10:34 0-
> 1  Merge 'tchen/timer_debug3' into devel-roam-i386-201404051825
> git bisect good 9fde1e2345f8ac522a84c77156d7e2b8ec4e8d94  # 10:56
> 20+    6  0day base guard for 'devel-roam-i386-201404051825'
> git bisect good b712c8dae05931a76b6c17a4254f403798e6caef  # 11:06
> 20+   11  x86: hpet: Use proper destructor for delayed work
> git bisect good 5b108727a416a790e9ef87eecd370f67773838d3  # 11:14
> 20+    7  hrtimer: remove 'base' parameter from
> hrtimer_{enqueue_}reprogram()
> git bisect good af57797fadd8c265ce34605153b75c417d3df384  # 11:20
> 20+    4  hrtimer: remove {} around a single liner 'for' loop in
> migrate_hrtimers()
> git bisect good 9ffd0897bd721352543c84041daf5dc07e60f559  # 11:27
> 20+    6  hrtimer: take lock only once for a cpu_base in
> hrtimer_run_queues()
> git bisect good 5a8530b7c3b1889861949d4e52b2da82d0aff242  # 11:38
> 20+   14  timer: track pinned timers with TIMER_PINNED flag
> git bisect  bad 90585a71ecf3285bc73d54e37080c3bb21583594  # 11:44 0-
> 3  clocksource: register cpu notifier to remove timer from dying CPU
> git bisect good 6378cb51af5f4743db0dcb3cbcf862eac5908754  # 11:50
> 20+    9  timer: don't migrate pinned timers
> # first bad commit: [90585a71ecf3285bc73d54e37080c3bb21583594]
> clocksource: register cpu notifier to remove timer from dying CPU
> git bisect good 6378cb51af5f4743db0dcb3cbcf862eac5908754  # 11:54
> 60+   56  timer: don't migrate pinned timers
> git bisect  bad 3db74909a7c789e467b126d837f7e0cea4a5c165  # 11:54 0-
> 13  0day head guard for 'devel-roam-i386-201404051825'
> git bisect good 18a1a7a1d862ae0794a0179473d08a414dd49234  # 12:15
> 60+   15  Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile
> git bisect good 4b22efdd5595f0acb48f02bf664a451ee98f9a2e  # 12:23
> 60+   29  Add linux-next specific files for 20140403
> 
> 
> This script may reproduce the error.
> 
> -----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> initrd=quantal-core-i386.cgz
> 
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd
> 
> kvm=(
> 	qemu-system-x86_64 -cpu kvm64 -enable-kvm
> 	-kernel $kernel
> 	-initrd $initrd
> 	-smp 2
> 	-m 256M
> 	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
> 	-net user,vlan=0
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-serial stdio
> 	-display none
> 	-monitor null
> )
> 
> append=(
> 	debug
> 	sched_debug
> 	apic=debug
> 	ignore_loglevel
> 	sysrq_always_enabled
> 	panic=10
> 	prompt_ramdisk=0
> 	earlyprintk=ttyS0,115200
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	root=/dev/ram0
> 	rw
> )
> 
> "${kvm[@]}" --append "${append[*]}"
> -----------------------------------------------------------------------------
> 
> Thanks,
> Jet
> 
> 

> early console in setup code
> early console in decompress_kernel
> 
> Decompressing Linux... Parsing ELF... done.
> Booting the kernel.
> [    0.000000] Linux version 3.14.0-rc1-00088-g90585a7 (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-18) ) #2 SMP Mon Apr 7 11:41:40 CST 2014
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x1000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [c00fdae0]
> [    0.000000]   mpc: fdaf0-fdbe4
> [    0.000000] initial memory mapped: [mem 0x00000000-0x047fffff]
> [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
> [    0.000000]  [mem 0x12400000-0x125fffff] page 4k
> [    0.000000] BRK [0x043e7000, 0x043e7fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x123fffff]
> [    0.000000]  [mem 0x10000000-0x123fffff] page 4k
> [    0.000000] BRK [0x043e8000, 0x043e8fff] PGTABLE
> [    0.000000] BRK [0x043e9000, 0x043e9fff] PGTABLE
> [    0.000000] BRK [0x043ea000, 0x043eafff] PGTABLE
> [    0.000000] BRK [0x043eb000, 0x043ebfff] PGTABLE
> [    0.000000] BRK [0x043ec000, 0x043ecfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12600000-0x13ffdfff]
> [    0.000000]  [mem 0x12600000-0x13ffdfff] page 4k
> [    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
> [    0.000000] ACPI: RSDP 000fd950 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 13ffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 13ffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 13ffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 13ffff40 000040
> [    0.000000] ACPI: SSDT 13fff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 13fff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 13fff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffb000 (        fee00000)
> [    0.000000] 0MB HIGHMEM available.
> [    0.000000] 319MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 13ffe000
> [    0.000000]   low ram: 0 - 13ffe000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13ffb001, boot clock
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
> [    0.000000]   HighMem  empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA zone: 40 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   Normal zone: 760 pages used for memmap
> [    0.000000]   Normal zone: 77822 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffb000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffa000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 330 pages/cpu @d1df6000 s1338944 r0 d12736 u1351680
> [    0.000000] pcpu-alloc: s1338944 r0 d12736 u1351680 alloc=330*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] kvm-clock: cpu 0, msr 0:13ffb001, primary cpu clock
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 11df8600
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 81020
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-r3-0405/linux-devel:devel-roam-i386-201404051825:90585a71ecf3285bc73d54e37080c3bb21583594:bisect-linux6/.vmlinuz-90585a71ecf3285bc73d54e37080c3bb21583594-20140407114225-1-lkp-ib04 branch=linux-devel/devel-roam-i386-201404051825 BOOT_IMAGE=/kernel/i386-randconfig-r3-0405/90585a71ecf3285bc73d54e37080c3bb21583594/vmlinuz-3.14.0-rc1-00088-g90585a7 drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (00000000:00000000)
> [    0.000000] Memory: 240504K/327280K available (25215K kernel code, 3225K rwdata, 7824K rodata, 2432K init, 14192K bss, 86776K reserved, 0K highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xffd35000 - 0xfffff000   (2856 kB)
> [    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
> [    0.000000]     vmalloc : 0xd47fe000 - 0xff9fe000   ( 690 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
> [    0.000000]       .init : 0xc337b000 - 0xc35db000   (2432 kB)
> [    0.000000]       .data : 0xc28a002e - 0xc337a440   (11113 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc28a002e   (25216 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:2304 nr_irqs:512 16
> [    0.000000] CPU 0 irqstacks, hard=d180a000 soft=d180c000
> [    0.000000] ACPI: Core revision 20131218
> [    0.000000] ACPI: All ACPI Tables successfully acquired
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] bootconsole [earlyser0] disabled
> [    0.000000] Linux version 3.14.0-rc1-00088-g90585a7 (kbuild@inn) (gcc version 4.8.2 (Debian 4.8.2-18) ) #2 SMP Mon Apr 7 11:41:40 CST 2014
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x1000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [c00fdae0]
> [    0.000000]   mpc: fdaf0-fdbe4
> [    0.000000] initial memory mapped: [mem 0x00000000-0x047fffff]
> [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
> [    0.000000]  [mem 0x12400000-0x125fffff] page 4k
> [    0.000000] BRK [0x043e7000, 0x043e7fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x123fffff]
> [    0.000000]  [mem 0x10000000-0x123fffff] page 4k
> [    0.000000] BRK [0x043e8000, 0x043e8fff] PGTABLE
> [    0.000000] BRK [0x043e9000, 0x043e9fff] PGTABLE
> [    0.000000] BRK [0x043ea000, 0x043eafff] PGTABLE
> [    0.000000] BRK [0x043eb000, 0x043ebfff] PGTABLE
> [    0.000000] BRK [0x043ec000, 0x043ecfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x12600000-0x13ffdfff]
> [    0.000000]  [mem 0x12600000-0x13ffdfff] page 4k
> [    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
> [    0.000000] ACPI: RSDP 000fd950 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 13ffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 13ffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 13ffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 13ffff40 000040
> [    0.000000] ACPI: SSDT 13fff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 13fff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 13fff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffb000 (        fee00000)
> [    0.000000] 0MB HIGHMEM available.
> [    0.000000] 319MB LOWMEM available.
> [    0.000000]   mapped low ram: 0 - 13ffe000
> [    0.000000]   low ram: 0 - 13ffe000
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13ffb001, boot clock
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
> [    0.000000]   HighMem  empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA zone: 40 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   Normal zone: 760 pages used for memmap
> [    0.000000]   Normal zone: 77822 pages, LIFO batch:15
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to         ffffb000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffa000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 330 pages/cpu @d1df6000 s1338944 r0 d12736 u1351680
> [    0.000000] pcpu-alloc: s1338944 r0 d12736 u1351680 alloc=330*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] kvm-clock: cpu 0, msr 0:13ffb001, primary cpu clock
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 11df8600
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 81020
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-r3-0405/linux-devel:devel-roam-i386-201404051825:90585a71ecf3285bc73d54e37080c3bb21583594:bisect-linux6/.vmlinuz-90585a71ecf3285bc73d54e37080c3bb21583594-20140407114225-1-lkp-ib04 branch=linux-devel/devel-roam-i386-201404051825 BOOT_IMAGE=/kernel/i386-randconfig-r3-0405/90585a71ecf3285bc73d54e37080c3bb21583594/vmlinuz-3.14.0-rc1-00088-g90585a7 drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Initializing HighMem for node 0 (00000000:00000000)
> [    0.000000] Memory: 240504K/327280K available (25215K kernel code, 3225K rwdata, 7824K rodata, 2432K init, 14192K bss, 86776K reserved, 0K highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xffd35000 - 0xfffff000   (2856 kB)
> [    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
> [    0.000000]     vmalloc : 0xd47fe000 - 0xff9fe000   ( 690 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
> [    0.000000]       .init : 0xc337b000 - 0xc35db000   (2432 kB)
> [    0.000000]       .data : 0xc28a002e - 0xc337a440   (11113 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc28a002e   (25216 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:2304 nr_irqs:512 16
> [    0.000000] CPU 0 irqstacks, hard=d180a000 soft=d180c000
> [    0.000000] ACPI: Core revision 20131218
> [    0.000000] ACPI: All ACPI Tables successfully acquired
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] bootconsole [earlyser0] disabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 3823 kB
> [    0.000000]  per task-struct memory footprint: 1920 bytes
> [    0.000000] ------------------------
> [    0.000000] | Locking API testsuite:
> [    0.000000] ----------------------------------------------------------------------------
> [    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
> [    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
> [    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
> [    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq read-recursion/123:  ok  |
> [    0.000000]       soft-irq read-recursion/123:  ok  |
> [    0.000000]       hard-irq read-recursion/132:  ok  |
> [    0.000000]       soft-irq read-recursion/132:  ok  |
> [    0.000000]       hard-irq read-recursion/213:  ok  |
> [    0.000000]       soft-irq read-recursion/213:  ok  |
> [    0.000000]       hard-irq read-recursion/231:  ok  |
> [    0.000000]       soft-irq read-recursion/231:  ok  |
> [    0.000000]       hard-irq read-recursion/312:  ok  |
> [    0.000000]       soft-irq read-recursion/312:  ok  |
> [    0.000000]       hard-irq read-recursion/321:  ok  |
> [    0.000000]       soft-irq read-recursion/321:  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]   | Wound/wait tests |
> [    0.000000]   ---------------------
> [    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
> [    0.000000]                ww contexts mixing:  ok  |  ok  |
> [    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
> [    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]            spinlock nest unlocked:  ok  |
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                                  |block | try  |context|
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                           context:  ok  |  ok  |  ok  |
> [    0.000000]                               try:  ok  |  ok  |  ok  |
> [    0.000000]                             block:  ok  |  ok  |  ok  |
> [    0.000000]                          spinlock:  ok  |  ok  |  ok  |
> [    0.000000] -------------------------------------------------------
> [    0.000000] Good, all 253 testcases passed! |
> [    0.000000] ---------------------------------
> [    0.000000] ODEBUG: 13 of 13 active objects replaced
> [    0.000000] ODEBUG: selftest passed
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2493.918 MHz processor
> [    0.006666] Calibrating delay loop (skipped) preset value.. 4989.66 BogoMIPS (lpj=8313060)
> [    0.006666] pid_max: default: 32768 minimum: 301
> [    0.006737] Security Framework initialized
> [    0.007481] Smack:  Initializing.
> [    0.008121] AppArmor: AppArmor disabled by boot time parameter
> [    0.009050] Mount-cache hash table entries: 512
> [    0.011014] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.011014] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.011014] tlb_flushall_shift: 6
> [    0.013985] debug: unmapping init [mem 0xc35db000-0xc35e5fff]
> [    0.020227] Getting VERSION: 50014
> [    0.020899] Getting VERSION: 50014
> [    0.021542] Getting ID: 0
> [    0.022115] Getting ID: f000000
> [    0.022741] Getting LVT0: 8700
> [    0.023342] Getting LVT1: 8400
> [    0.023967] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.024839] enabled ExtINT on CPU#0
> [    0.026302] ENABLING IO-APIC IRQs
> [    0.026674] init IO_APIC IRQs
> [    0.027277]  apic 0 pin 0 not connected
> [    0.028000] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.029371] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.030029] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.031391] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.033362] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.034718] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.036695] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.038059] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.039415] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.040027] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.041403] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.043361] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.044746] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.046125] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.046695] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.048067]  apic 0 pin 16 not connected
> [    0.048772]  apic 0 pin 17 not connected
> [    0.050005]  apic 0 pin 18 not connected
> [    0.052549]  apic 0 pin 19 not connected
> [    0.053339]  apic 0 pin 20 not connected
> [    0.054035]  apic 0 pin 21 not connected
> [    0.054733]  apic 0 pin 22 not connected
> [    0.055438]  apic 0 pin 23 not connected
> [    0.056818] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.057854] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
> [    0.059636] Using local APIC timer interrupts.
> [    0.059636] calibrating APIC timer ...
> [    0.063333] ... lapic delta = 6250007
> [    0.063333] ... PM-Timer delta = 357911
> [    0.063333] ... PM-Timer result ok
> [    0.063333] ..... delta 6250007
> [    0.063333] ..... mult: 268435783
> [    0.063333] ..... calibration result: 3333337
> [    0.063333] ..... CPU clock speed is 2493.3078 MHz.
> [    0.063333] ..... host bus clock speed is 1000.0337 MHz.
> [    0.063404] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
> [    0.066466] NMI watchdog: disabled (cpu0): hardware events not enabled
> [    0.067214] CPU 1 irqstacks, hard=d18a2000 soft=d18a4000
> [    0.068176] x86: Booting SMP configuration:
> [    0.068974] .... node  #0, CPUs:      #1
> [    0.003333] Initializing CPU#1
> [    0.006666] kvm-clock: cpu 1, msr 0:13ffb041, secondary cpu clock
> [    0.006666] masked ExtINT on CPU#1
> [    0.083504] x86: Booted up 1 node, 2 CPUs
> [    0.083452] KVM setup async PF for cpu 1
> [    0.083452] kvm-stealtime: cpu 1, msr 11f42600
> [    0.086675] smpboot: Total of 2 processors activated (9979.32 BogoMIPS)
> [    0.091068] devtmpfs: initialized
> [    0.092529] gcov: version magic: 0x3430382a
> [    0.097186] EVM: security.selinux
> [    0.097840] EVM: security.SMACK64
> [    0.098473] EVM: security.capability
> [    0.100392] xor: measuring software checksum speed
> [    0.133350]    pIII_sse  :   132.000 MB/sec
> [    0.166674]    prefetch64-sse:   133.200 MB/sec
> [    0.167439] xor: using function: prefetch64-sse (133.200 MB/sec)
> [    0.168361] prandom: seed boundary self test passed
> [    0.169759] prandom: 100 self tests passed
> [    0.170010] atomic64 test passed for i586+ platform with CX8 and with SSE
> [    0.171804] regulator-dummy: no parameters
> [    0.173423] NET: Registered protocol family 16
> [    0.175338] cpuidle: using governor ladder
> [    0.176793] ACPI: bus type PCI registered
> [    0.177777] PCI : PCI BIOS area is rw and x. Use pci=nobios if you want it NX.
> [    0.179054] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=0
> [    0.180006] PCI: Using configuration type 1 for base access
> [    0.208806] bio: create slab <bio-0> at 0
> [    0.266733] raid6: mmxx1      728 MB/s
> [    0.323419] raid6: mmxx2      775 MB/s
> [    0.380082] raid6: sse1x1     568 MB/s
> [    0.436728] raid6: sse1x2     735 MB/s
> [    0.493359] raid6: sse2x1    1126 MB/s
> [    0.550010] raid6: sse2x2    1469 MB/s
> [    0.550699] raid6: using algorithm sse2x2 (1469 MB/s)
> [    0.551517] raid6: using intx1 recovery algorithm
> [    0.552836] ACPI: Added _OSI(Module Device)
> [    0.553341] ACPI: Added _OSI(Processor Device)
> [    0.554104] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.554886] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.568123] ACPI: Interpreter enabled
> [    0.568829] ACPI: (supports S0 S5)
> [    0.569481] ACPI: Using IOAPIC for interrupt routing
> [    0.570086] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.591315] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.592300] acpi PNP0A03:00: _OSC: OS supports [Segments]
> [    0.593229] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    0.594037] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
> [    0.596937] PCI host bridge to bus 0000:00
> [    0.597673] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.598546] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.599484] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.600008] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.601016] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
> [    0.602105] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    0.604130] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    0.606005] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    0.609111] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
> [    0.611453] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    0.612739] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    0.613352] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    0.615047] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    0.620611] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    0.623425] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    0.630631] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    0.633424] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    0.635257] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
> [    0.637124] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    0.642214] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
> [    0.643866] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
> [    0.645285] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
> [    0.649704] pci_bus 0000:00: on NUMA node 0
> [    0.651311] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [    0.653456] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [    0.654979] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [    0.656517] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [    0.657486] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
> [    0.659648] ACPI: Enabled 16 GPEs in block 00 to 0F
> [    0.660963] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.661723] vgaarb: loaded
> [    0.662291] vgaarb: bridge control possible 0000:00:02.0
> [    0.664327] SCSI subsystem initialized
> [    0.665101] libata version 3.00 loaded.
> [    0.665957] ACPI: bus type USB registered
> [    0.666781] usbcore: registered new interface driver usbfs
> [    0.667697] usbcore: registered new interface driver hub
> [    0.671048] usbcore: registered new device driver usb
> [    0.671048] media: Linux media interface: v0.10
> [    0.671048] Linux video capture interface: v2.00
> [    0.671048] pps_core: LinuxPPS API ver. 1 registered
> [    0.671763] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    0.673361] PTP clock support registered
> [    0.677114] PCI: Using ACPI for IRQ routing
> [    0.677114] PCI: pci_cache_line_size set to 64 bytes
> [    0.677114] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    0.677756] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
> [    0.679729] irda_init()
> [    0.680129] NET: Registered protocol family 23
> [    0.680983] Bluetooth: Core ver 2.18
> [    0.681687] NET: Registered protocol family 31
> [    0.682445] Bluetooth: HCI device and connection manager initialized
> [    0.683374] Bluetooth: HCI socket layer initialized
> [    0.684191] Bluetooth: L2CAP socket layer initialized
> [    0.685077] Bluetooth: SCO socket layer initialized
> [    0.685907] NET: Registered protocol family 8
> [    0.686679] NET: Registered protocol family 20
> [    0.690674] NetLabel: Initializing
> [    0.690674] NetLabel:  domain hash size = 128
> [    0.690674] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.690674] NetLabel:  unlabeled traffic allowed by default
> [    0.691216] nfc: nfc_init: NFC Core ver 0.1
> [    0.692031] NET: Registered protocol family 39
> [    0.696690] Switched to clocksource kvm-clock
> [    0.696738] FS-Cache: Loaded
> [    0.696738] CacheFiles: Loaded
> [    0.699408] pnp: PnP ACPI init
> [    0.700097] ACPI: bus type PNP registered
> [    0.700954] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [    0.702555] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.703620] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [    0.705076] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.706129] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [    0.707621] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    0.708727] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [    0.710109] pnp 00:03: [dma 2]
> [    0.710816] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    0.711898] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [    0.713414] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    0.714500] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [    0.715978] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.717059] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:3)
> [    0.718509] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.720161] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.721560] pnp: PnP ACPI: found 8 devices
> [    0.722296] ACPI: bus type PNP unregistered
> [    0.723284] cfg80211: Calling CRDA to update world regulatory domain
> [    1.017774] mdacon: MDA with 8K of memory detected.
> [    1.017979] Console: switching consoles 13-16 to MDA-2
> [    1.054724] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    1.055621] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    1.056493] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    1.057434] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
> [    1.058462] NET: Registered protocol family 2
> [    1.059770] TCP established hash table entries: 4096 (order: 2, 16384 bytes)
> [    1.060967] TCP bind hash table entries: 4096 (order: 5, 180224 bytes)
> [    1.062451] TCP: Hash tables configured (established 4096 bind 4096)
> [    1.063503] TCP: reno registered
> [    1.065915] UDP hash table entries: 256 (order: 2, 24576 bytes)
> [    1.066903] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
> [    1.068320] NET: Registered protocol family 1
> [    1.069126] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    1.070054] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    1.070960] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    1.071951] pci 0000:00:02.0: Boot video device
> [    1.072756] PCI: CLS 0 bytes, default 64
> [    1.073956] Unpacking initramfs...
> [    2.280298] debug: unmapping init [mem 0xd27ab000-0xd3feffff]
> [    2.284336] cryptomgr_test (29) used greatest stack depth: 7212 bytes left
> [    2.285371] cryptomgr_test (30) used greatest stack depth: 7180 bytes left
> [    2.289284] PCLMULQDQ-NI instructions are not detected.
> [    2.290282] The force parameter has not been set to 1. The Iris poweroff handler will not be installed.
> [    2.293867] Initializing RT-Tester: OK
> [    2.295472] futex hash table entries: 512 (order: 3, 32768 bytes)
> [    2.296529] Initialise system trusted keyring
> [    2.297491] audit: initializing netlink subsys (disabled)
> [    2.298477] audit: type=2000 audit(1396842157.228:1): initialized
> [    3.148309] VFS: Disk quotas dquot_6.5.2
> [    3.149378] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> [    3.152054] DLM installed
> [    3.156050] squashfs: version 4.0 (2009/01/31) Phillip Lougher
> [    3.159547] NTFS driver 2.1.30 [Flags: R/O DEBUG].
> [    3.160960] ROMFS MTD (C) 2007 Red Hat, Inc.
> [    3.162310] QNX4 filesystem 0.2.3 registered.
> [    3.163361] QNX6 filesystem 1.0.0 registered.
> [    3.165138] JFS: nTxBlock = 1878, nTxLock = 15031
> [    3.168553] BeFS version: 0.9.3
> [    3.170127] ocfs2: Registered cluster interface o2cb
> [    3.171413] OCFS2 User DLM kernel interface loaded
> [    3.175944] msgmni has been set to 469
> [    3.188307] NET: Registered protocol family 38
> [    3.189121] async_tx: api initialized (async)
> [    3.189909] Key type asymmetric registered
> [    3.190702] Asymmetric key parser 'x509' registered
> [    3.191868] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    3.193209] io scheduler noop registered
> [    3.193947] io scheduler deadline registered (default)
> [    3.194794] test_string_helpers: Running tests...
> [    3.196010] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
> [    3.196863] crc32: self tests passed, processed 225944 bytes in 164412 nsec
> [    3.198074] crc32c: CRC_LE_BITS = 64
> [    3.198752] crc32c: self tests passed, processed 225944 bytes in 82338 nsec
> [    3.285693] tsc: Refined TSC clocksource calibration: 2493.977 MHz
> [    3.423948] crc32_combine: 8373 self tests passed
> [    3.650334] crc32c_combine: 8373 self tests passed
> [    3.651169] rbtree testing
> [    3.787010] =========================================================
> [    3.787976] [ INFO: possible irq lock inversion dependency detected ]
> [    3.788955] 3.14.0-rc1-00088-g90585a7 #2 Not tainted
> [    3.789772] ---------------------------------------------------------
> [    3.789969] swapper/0/1 just changed the state of lock:
> [    3.789969]  (watchdog_lock){..-...}, at: [<c1124731>] clocksource_watchdog+0x21/0x450
> [    3.789969] but this lock took another, SOFTIRQ-unsafe lock in the past:
> [    3.789969]  (cpu_add_remove_lock){+.+.+.}
> 
> and interrupts could create inverse lock ordering between them.
> 
> [    3.789969] 
> [    3.789969] other info that might help us debug this:
> [    3.789969]  Possible interrupt unsafe locking scenario:
> [    3.789969] 
> [    3.789969]        CPU0                    CPU1
> [    3.789969]        ----                    ----
> [    3.789969]   lock(cpu_add_remove_lock);
> [    3.789969]                                local_irq_disable();
> [    3.789969]                                lock(watchdog_lock);
> [    3.789969]                                lock(cpu_add_remove_lock);
> [    3.789969]   <Interrupt>
> [    3.789969]     lock(watchdog_lock);
> [    3.789969] 
> [    3.789969]  *** DEADLOCK ***
> [    3.789969] 
> [    3.789969] 1 lock held by swapper/0/1:
> [    3.789969]  #0:  ((&watchdog_timer)){+.-...}, at: [<c1090560>] call_timer_fn+0x0/0x170
> [    3.789969] 
> [    3.789969] the shortest dependencies between 2nd lock and 1st lock:
> [    3.789969]  -> (cpu_add_remove_lock){+.+.+.} ops: 16 {
> [    3.789969]     HARDIRQ-ON-W at:
> [    3.789969]                       [<c10f8345>] __lock_acquire+0xa05/0x1880
> [    3.789969]                       [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]                       [<c2895b78>] mutex_lock_nested+0x98/0x790
> [    3.789969]                       [<c28708c0>] register_cpu_notifier+0x20/0x70
> [    3.789969]                       [<c33ad060>] page_writeback_init+0x2e/0x56
> [    3.789969]                       [<c337c5e8>] start_kernel+0x9f0/0xa51
> [    3.789969]                       [<c337b3c8>] i386_start_kernel+0x19e/0x1af
> [    3.789969]     SOFTIRQ-ON-W at:
> [    3.789969]                       [<c10f8393>] __lock_acquire+0xa53/0x1880
> [    3.789969]                       [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]                       [<c2895b78>] mutex_lock_nested+0x98/0x790
> [    3.789969]                       [<c28708c0>] register_cpu_notifier+0x20/0x70
> [    3.789969]                       [<c33ad060>] page_writeback_init+0x2e/0x56
> [    3.789969]                       [<c337c5e8>] start_kernel+0x9f0/0xa51
> [    3.789969]                       [<c337b3c8>] i386_start_kernel+0x19e/0x1af
> [    3.789969]     RECLAIM_FS-ON-W at:
> [    3.789969]                          [<c10f35e0>] mark_held_locks+0xc0/0x1e0
> [    3.789969]                          [<c10f4966>] lockdep_trace_alloc+0x126/0x230
> [    3.789969]                          [<c11c345f>] kmem_cache_alloc+0x3f/0x260
> [    3.789969]                          [<c10be745>] __smpboot_create_thread+0x55/0x190
> [    3.789969]                          [<c10beb6b>] smpboot_create_threads+0x7b/0xc0
> [    3.789969]                          [<c107f1da>] cpu_up+0x12a/0x520
> [    3.789969]                          [<c33a90dc>] smp_init+0x18b/0x1f2
> [    3.789969]                          [<c337c957>] kernel_init_freeable+0xec/0x3f4
> [    3.789969]                          [<c286fff9>] kernel_init+0x19/0x230
> [    3.789969]                          [<c289eef7>] ret_from_kernel_thread+0x1b/0x28
> [    3.789969]     INITIAL USE at:
> [    3.789969]                      [<c10f7dbc>] __lock_acquire+0x47c/0x1880
> [    3.789969]                      [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]                      [<c2895b78>] mutex_lock_nested+0x98/0x790
> [    3.789969]                      [<c28708c0>] register_cpu_notifier+0x20/0x70
> [    3.789969]                      [<c339e846>] kvm_guest_init+0x1bc/0x24d
> [    3.789969]                      [<c33820b8>] setup_arch+0x1835/0x18e2
> [    3.789969]                      [<c337bd3d>] start_kernel+0x145/0xa51
> [    3.789969]                      [<c337b3c8>] i386_start_kernel+0x19e/0x1af
> [    3.789969]   }
> [    3.789969]   ... key      at: [<c3080a80>] cpu_add_remove_lock+0x40/0xf0
> [    3.789969]   ... acquired at:
> [    3.789969]    [<c10f7fab>] __lock_acquire+0x66b/0x1880
> [    3.789969]    [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]    [<c2895b78>] mutex_lock_nested+0x98/0x790
> [    3.789969]    [<c28708c0>] register_cpu_notifier+0x20/0x70
> [    3.789969]    [<c112389e>] clocksource_enqueue_watchdog+0xde/0x230
> [    3.789969]    [<c11250b1>] __clocksource_register_scale+0xf1/0x140
> [    3.789969]    [<c100fe9d>] tsc_refine_calibration_work+0x1bd/0x2a0
> [    3.789969]    [<c10a5495>] process_one_work+0x265/0x740
> [    3.789969]    [<c10a612a>] worker_thread+0x28a/0x6f0
> [    3.789969]    [<c10b1b60>] kthread+0x110/0x150
> [    3.789969]    [<c289eef7>] ret_from_kernel_thread+0x1b/0x28
> [    3.789969] 
> [    3.789969] -> (watchdog_lock){..-...} ops: 8 {
> [    3.789969]    IN-SOFTIRQ-W at:
> [    3.789969]                     [<c10f8510>] __lock_acquire+0xbd0/0x1880
> [    3.789969]                     [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]                     [<c289c6d7>] _raw_spin_lock+0x67/0x110
> [    3.789969]                     [<c1124731>] clocksource_watchdog+0x21/0x450
> [    3.789969]                     [<c1090607>] call_timer_fn+0xa7/0x170
> [    3.789969]                     [<c1090b76>] run_timer_softirq+0x206/0x380
> [    3.789969]                     [<c108614c>] __do_softirq+0x14c/0x380
> [    3.789969]    INITIAL USE at:
> [    3.789969]                    [<c10f7dbc>] __lock_acquire+0x47c/0x1880
> [    3.789969]                    [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]                    [<c289c825>] _raw_spin_lock_irqsave+0xa5/0x150
> [    3.789969]                    [<c11237e2>] clocksource_enqueue_watchdog+0x22/0x230
> [    3.789969]                    [<c11250b1>] __clocksource_register_scale+0xf1/0x140
> [    3.789969]                    [<c339eba6>] kvmclock_init+0x2cf/0x35b
> [    3.789969]                    [<c3381f80>] setup_arch+0x16fd/0x18e2
> [    3.789969]                    [<c337bd3d>] start_kernel+0x145/0xa51
> [    3.789969]                    [<c337b3c8>] i386_start_kernel+0x19e/0x1af
> [    3.789969]  }
> [    3.789969]  ... key      at: [<c30963d0>] watchdog_lock+0x10/0x40
> [    3.789969]  ... acquired at:
> [    3.789969]    [<c10ef619>] check_usage_forwards+0xb9/0x190
> [    3.789969]    [<c10f2fab>] mark_lock+0x69b/0xc10
> [    3.789969]    [<c10f8510>] __lock_acquire+0xbd0/0x1880
> [    3.789969]    [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]    [<c289c6d7>] _raw_spin_lock+0x67/0x110
> [    3.789969]    [<c1124731>] clocksource_watchdog+0x21/0x450
> [    3.789969]    [<c1090607>] call_timer_fn+0xa7/0x170
> [    3.789969]    [<c1090b76>] run_timer_softirq+0x206/0x380
> [    3.789969]    [<c108614c>] __do_softirq+0x14c/0x380
> [    3.789969] 
> [    3.789969] 
> [    3.789969] stack backtrace:
> [    3.789969] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc1-00088-g90585a7 #2
> [    3.789969] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    3.789969]  c3adc020 d180dd7c c287f340 d180ddd8 d180ddb8 c10ef2b9 c2e845e0 c2e8492e
> [    3.789969]  00000001 d180ddd8 00000006 c10ef560 d180ddb8 c10ed183 00000000 00000000
> [    3.789969]  d186054c d1860000 c10ef560 d180de04 c10ef619 d186054c 00000001 c2e8492e
> [    3.789969] Call Trace:
> [    3.789969]  [<c287f340>] dump_stack+0xb8/0x108
> [    3.789969]  [<c10ef2b9>] print_irq_inversion_bug+0x389/0x4a0
> [    3.789969]  [<c10ef560>] ? check_usage_backwards+0x190/0x190
> [    3.789969]  [<c10ed183>] ? find_usage_forwards+0x53/0xd0
> [    3.789969]  [<c10ef560>] ? check_usage_backwards+0x190/0x190
> [    3.789969]  [<c10ef619>] check_usage_forwards+0xb9/0x190
> [    3.789969]  [<c10f2fab>] mark_lock+0x69b/0xc10
> [    3.789969]  [<c1008e7d>] ? print_context_stack+0x5d/0x160
> [    3.789969]  [<c10f8510>] __lock_acquire+0xbd0/0x1880
> [    3.789969]  [<c10f9292>] lock_acquire+0xd2/0x110
> [    3.789969]  [<c1124731>] ? clocksource_watchdog+0x21/0x450
> [    3.789969]  [<c289c6d7>] _raw_spin_lock+0x67/0x110
> [    3.789969]  [<c1124731>] ? clocksource_watchdog+0x21/0x450
> [    3.789969]  [<c1124710>] ? clocksource_cpu_notify+0xd0/0xd0
> [    3.789969]  [<c1124731>] clocksource_watchdog+0x21/0x450
> [    3.789969]  [<c1090560>] ? process_timeout+0x30/0x30
> [    3.789969]  [<c1124710>] ? clocksource_cpu_notify+0xd0/0xd0
> [    3.789969]  [<c1090607>] call_timer_fn+0xa7/0x170
> [    3.789969]  [<c1090560>] ? process_timeout+0x30/0x30
> [    3.789969]  [<c1090b76>] run_timer_softirq+0x206/0x380
> [    3.789969]  [<c1124710>] ? clocksource_cpu_notify+0xd0/0xd0
> [    3.789969]  [<c108614c>] __do_softirq+0x14c/0x380
> [    3.789969]  [<c1086000>] ? _local_bh_enable+0xa0/0xa0
> [    3.789969]  <IRQ>  [<c10868eb>] ? irq_exit+0xcb/0xe0
> [    3.789969]  [<c104c74b>] ? smp_apic_timer_interrupt+0x6b/0x90
> [    3.789969]  [<c289eb02>] ? apic_timer_interrupt+0x32/0x38
> [    3.789969]  [<c28800d8>] ? check+0x7e/0x52d
> [    3.789969]  [<c33c846b>] ? rbtree_test_init+0xa3/0x45f
> [    3.789969]  [<c33aaad6>] ? audit_register_class+0x29/0x10a
> [    3.789969]  [<c33c83c8>] ? test_atomic64+0xdc0/0xdc0
> [    3.789969]  [<c337c73f>] ? do_one_initcall+0xf6/0x222
> [    3.789969]  [<c10ae871>] ? parameq+0x21/0x100
> [    3.789969]  [<c337b749>] ? repair_env_string+0x32/0xd3
> [    3.789969]  [<c10aec3b>] ? parse_args+0x2eb/0x5f0
> [    3.789969]  [<c337cad7>] ? kernel_init_freeable+0x26c/0x3f4
> [    3.789969]  [<c337b717>] ? do_early_param+0x131/0x131
> [    3.789969]  [<c286fff9>] ? kernel_init+0x19/0x230
> [    3.789969]  [<c289eef7>] ? ret_from_kernel_thread+0x1b/0x28
> [    3.789969]  [<c286ffe0>] ? rest_init+0x170/0x170
> [    4.202425]  -> 13739 cycles
> [    4.252106] augmented rbtree testing -> 15602 cycles
> [    4.943124] Console: switching consoles 13-16 to MDA-2
> [    4.944370] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    4.945686] ACPI: Power Button [PWRF]
> [    4.946681] isapnp: Scanning for PnP cards...
> [    5.307227] isapnp: No Plug & Play device found
> [    5.337254] r3964: Philips r3964 Driver $Revision: 1.10 $
> [    5.338188] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    5.361924] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    5.364116] Cyclades driver 2.6
> [    5.384958] MOXA Intellio family driver version 6.0k
> [    5.385890] RocketPort device driver module, version 2.09, 12-June-2003
> [    5.386952] No rocketport ports found; unloading driver
> [    5.387959] DoubleTalk PC - not found
> [    5.388738] Non-volatile memory driver v1.3
> [    5.389689] ppdev: user-space parallel port driver
> [    5.390561] nsc_gpio initializing
> [    5.391214] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [    5.392031] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    5.393502] Hangcheck: Using getrawmonotonic().
> [    5.394443] parport_pc 00:04: reported by Plug and Play ACPI
> [    5.395468] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
> [    5.479189] loop: module loaded
> [    5.480551] nbd: registered device at major 43
> [    5.484757] blk-mq: CPU -> queue map
> [    5.485442]   CPU 0 -> Queue 0
> [    5.486046]   CPU 1 -> Queue 0
> [    5.487221]  nullb0: unknown partition table
> [    5.488242] blk-mq: CPU -> queue map
> [    5.488920]   CPU 0 -> Queue 0
> [    5.489532]   CPU 1 -> Queue 0
> [    5.490561]  nullb1: unknown partition table
> [    5.491509] null: module loaded
> [    5.492235] lkdtm: No crash points registered, enable through debugfs
> [    5.493379] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
> [    5.494740] c2port c2port0: C2 port uc added
> [    5.495484] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
> [    5.497388] Uniform Multi-Platform E-IDE driver
> [    5.498212] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> [    5.499783] ide-gd driver 1.18
> [    5.500431] ide-cd driver 5.00
> [    5.501527] Loading iSCSI transport class v2.0-870.
> [    5.502598] rdac: device handler registered
> [    5.503498] emc: device handler registered
> [    5.504619] iscsi: registered transport (tcp)
> [    5.505782] NCR53c406a: no available ports found
> [    5.506567] qlogicfas: no cards were found, please specify I/O address and IRQ using iobase= and irq= optionsFailed initialization of WD-7000 SCSI card!
> [    5.614180] GDT-HA: Storage RAID Controller Driver. Version: 3.05
> [    5.615161] imm: Version 2.05 (for Linux 2.4.0)
> [    5.616461] osst :I: Tape driver with OnStream support version 0.99.4
> [    5.616461] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
> [    5.618486] SCSI Media Changer driver v0.25 
> [    5.629554] scsi_debug: host protection
> [    5.630283] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=8, opts=0x0
> [    5.631914] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
> [    5.633938] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    5.635361] HSI/SSI char device loaded
> [    5.637013] vcan: Virtual CAN interface driver
> [    5.637784] slcan: serial line CAN interface driver
> [    5.638586] slcan: 10 dynamic interface channels.
> [    5.639013] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.00 MiB)
> [    5.642329] sd 0:0:0:0: [sda] Write Protect is off
> [    5.643188] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
> [    5.652340] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
> [    5.678063] atp.c:v1.09=ac 2002/10/01 Donald Becker <becker@scyld.com>
> [    5.679177] usbcore: registered new interface driver stir4200
> [    5.680217] w83977af_init()
> [    5.680807] w83977af_open()
> [    5.681392] w83977af_probe()
> [    5.682045] w83977af_probe(), Wrong chip version
> [    5.682587] w83977af_probe()
> [    5.683549] w83977af_probe(), Wrong chip version
> [    5.684480] usbcore: registered new interface driver mcs7780
> [    5.685663]  sda: unknown partition table
> [    5.686538] usbcore: registered new interface driver ksdazzle-sir
> [    5.687502] parport0: no more devices allowed
> [    5.688250] plip0: parport_register failed
> [    5.688985] PPP generic driver version 2.4.2
> [    5.689921] PPP BSD Compression module registered
> [    5.690727] PPP Deflate Compression module registered
> [    5.691565] PPP MPPE Compression module registered
> [    5.692363] NET: Registered protocol family 24
> [    5.693135] Atmel at76x USB Wireless LAN Driver 0.17 loading
> [    5.694057] usbcore: registered new interface driver at76c50x-usb
> [    5.695065] Broadcom 43xx driver loaded [ Features: PNLS ]
> [    5.695964] Broadcom 43xx-legacy driver loaded [ Features: PLD ]
> [    5.697067] usbcore: registered new interface driver zd1211rw
> [    5.697988] libertas_sdio: Libertas SDIO driver
> [    5.698756] libertas_sdio: Copyright Pierre Ossman
> [    5.699044] sd 0:0:0:0: [sda] Attached SCSI disk
> [    5.700365] libertas_spi: Libertas SPI driver
> [    5.701301] usbcore: registered new interface driver p54usb
> [    5.702262] usbcore: registered new interface driver ath9k_htc
> [    5.703200] usbcore: registered new interface driver carl9170
> [    5.704142] usbcore: registered new interface driver ar5523
> [    5.705175] usbcore: registered new interface driver usb8xxx
> [    5.706132] usbcore: registered new interface driver i2400m_usb
> [    5.707456] ieee802154hardmac ieee802154hardmac: Added ieee802154 HardMAC hardware
> [    5.708788] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
> [    5.710116] usbcore: registered new interface driver pegasus
> [    5.711026] usbcore: registered new interface driver rtl8150
> [    5.711943] usbcore: registered new interface driver r8152
> [    5.712845] usbcore: registered new interface driver ax88179_178a
> [    5.713808] usbcore: registered new interface driver cdc_ether
> [    5.714739] usbcore: registered new interface driver r815x
> [    5.715646] usbcore: registered new interface driver dm9601
> [    5.716565] usbcore: registered new interface driver sr9700
> [    5.717489] usbcore: registered new interface driver smsc75xx
> [    5.718431] usbcore: registered new interface driver smsc95xx
> [    5.719354] usbcore: registered new interface driver gl620a
> [    5.720261] usbcore: registered new interface driver rndis_host
> [    5.721196] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
> [    5.722513] usbcore: registered new interface driver cdc_phonet
> [    5.723456] usbcore: registered new interface driver cx82310_eth
> [    5.724405] usbcore: registered new interface driver lg-vl600
> [    5.725329] usbcore: registered new interface driver qmi_wwan
> [    5.727229] aoe: AoE v85 initialised.
> [    5.728170] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    5.729158] ehci-pci: EHCI PCI platform driver
> [    5.731783] ehci-platform: EHCI generic platform driver
> [    5.732672] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    5.733690] ohci-pci: OHCI PCI platform driver
> [    5.734483] ohci-platform: OHCI generic platform driver
> [    5.735417] driver u132_hcd
> [    5.736272] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
> [    5.737226] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
> [    5.738713] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
> [    5.741149] usbcore: registered new interface driver cdc_acm
> [    5.742042] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
> [    5.743419] usbcore: registered new interface driver cdc_wdm
> [    5.744335] usbcore: registered new interface driver usbtmc
> [    5.745241] usbcore: registered new interface driver usb-storage
> [    5.746187] usbcore: registered new interface driver ums-alauda
> [    5.747122] usbcore: registered new interface driver ums-cypress
> [    5.748065] usbcore: registered new interface driver ums-datafab
> [    5.749015] usbcore: registered new interface driver ums_eneub6250
> [    5.749972] usbcore: registered new interface driver ums-jumpshot
> [    5.750936] usbcore: registered new interface driver ums-karma
> [    5.751863] usbcore: registered new interface driver ums-realtek
> [    5.752821] usbcore: registered new interface driver ums-sddr09
> [    5.753765] usbcore: registered new interface driver ums-usbat
> [    5.754707] usbcore: registered new interface driver microtekX6
> [    5.755658] usbcore: registered new interface driver adutux
> [    5.756702] usbcore: registered new interface driver appledisplay
> [    5.757666] usbcore: registered new interface driver cytherm
> [    5.758573] usbcore: registered new interface driver emi26 - firmware loader
> [    5.759611] driver ftdi-elan
> [    5.760564] usbcore: registered new interface driver ftdi-elan
> [    5.761505] usbcore: registered new interface driver iowarrior
> [    5.762436] usbcore: registered new interface driver isight_firmware
> [    5.763433] usbcore: registered new interface driver usblcd
> [    5.764333] usbcore: registered new interface driver usbled
> [    5.765224] usbcore: registered new interface driver legousbtower
> [    5.766185] usbcore: registered new interface driver usbtest
> [    5.767122] usbcore: registered new interface driver usb_ehset_test
> [    5.768095] usbcore: registered new interface driver uss720
> [    5.768968] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
> [    5.770470] uss720: NOTE: this is a special purpose driver to allow nonstandard
> [    5.771748] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
> [    5.773002] uss720: If you just want to connect to a printer, use usblp instead
> [    5.774335] usbcore: registered new interface driver sisusb
> [    5.775283] usbcore: registered new interface driver speedtch
> [    5.776213] usbcore: registered new interface driver ueagle-atm
> [    5.777311] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 May 2005
> [    5.778642] unable to find transceiver
> [    5.779329] dummy_hcd dummy_hcd.0: Dummy host controller
> [    5.780388] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus number 1
> [    5.781826] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    5.782843] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    5.784121] usb usb1: Product: Dummy host controller
> [    5.784939] usb usb1: Manufacturer: Linux 3.14.0-rc1-00088-g90585a7 dummy_hcd
> [    5.785981] usb usb1: SerialNumber: dummy_hcd.0
> [    5.787130] hub 1-0:1.0: USB hub found
> [    5.787849] hub 1-0:1.0: 1 port detected
> [    5.789079] userial_init: registered 4 ttyGS* devices
> [    5.789923] udc dummy_udc.0: registering UDC driver [g_acm_ms]
> [    5.791028] Number of LUNs=8
> [    5.791640] Mass Storage Function, version: 2009/09/11
> [    5.792477] LUN: removable file: (no medium)
> [    5.793242] Number of LUNs=1
> [    5.793864] no file given for LUN0
> [    5.794898] g_acm_ms dummy_udc.0: failed to start g_acm_ms: -22
> [    5.795901] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    5.798075] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    5.798918] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    5.799775] parport0: no more devices allowed
> [    5.800888] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
> [    5.802612] usbcore: registered new interface driver appletouch
> [    5.803547] usbcore: registered new interface driver bcm5974
> [    5.804485] inport.c: Didn't find InPort mouse at 0x23c
> [    5.805440] logibm.c: Didn't find Logitech busmouse at 0x23c
> [    5.806670] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    5.808264] usbcore: registered new interface driver synaptics_usb
> [    5.809490] usbcore: registered new interface driver xpad
> [    5.810411] usbcore: registered new interface driver aiptek
> [    5.811295] usbcore: registered new interface driver hanwang
> [    5.812196] usbcore: registered new interface driver kbtab
> [    5.813199] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
> [    5.814200] usbcore: registered new interface driver keyspan_remote
> [    5.815328] input: PC Speaker as /devices/platform/pcspkr/input/input2
> [    5.816347] evbug: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
> [    5.818995] evbug: Connected device: input2 (PC Speaker at isa0061/input0)
> [    5.820059] usbcore: registered new interface driver powermate
> [    5.821001] wistron_btns: System unknown
> [    5.821725] usbcore: registered new interface driver yealink
> [    5.822719] rtc_cmos 00:00: RTC can wake from S4
> [    5.823751] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
> [    5.824824] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet irqs
> [    5.826540] rtc-test rtc-test.0: rtc core: registered test as rtc1
> [    5.827605] rtc-test rtc-test.1: rtc core: registered test as rtc2
> [    5.828625] i2c /dev entries driver
> [    5.829395] usbcore: registered new interface driver i2c-diolan-u2c
> [    5.830347] i2c-parport: adapter type unspecified
> [    5.831167] usbcore: registered new interface driver i2c-tiny-usb
> [    5.832148] isa i2c-pca-isa.0: Please specify I/O base
> [    5.833859] lirc_dev: IR Remote Control driver registered, major 243 
> [    5.834836] IR RC5(x) protocol handler initialized
> [    5.835633] IR JVC protocol handler initialized
> [    5.836394] IR Sony protocol handler initialized
> [    5.837153] IR SANYO protocol handler initialized
> [    5.838028] usbcore: registered new interface driver s2255
> [    5.838942] usbcore: registered new interface driver uvcvideo
> [    5.839838] USB Video Class driver (1.1.1)
> [    5.840629] gspca_main: v2.14.0 registered
> [    5.841401] usbcore: registered new interface driver benq
> [    5.842271] usbcore: registered new interface driver etoms
> [    5.843170] usbcore: registered new interface driver finepix
> [    5.844080] usbcore: registered new interface driver jl2005bcd
> [    5.844999] usbcore: registered new interface driver konica
> [    5.845917] usbcore: registered new interface driver mr97310a
> [    5.846837] usbcore: registered new interface driver nw80x
> [    5.847737] usbcore: registered new interface driver ov519
> [    5.848617] usbcore: registered new interface driver ov534
> [    5.849528] usbcore: registered new interface driver ov534_9
> [    5.850438] usbcore: registered new interface driver pac207
> [    5.851330] usbcore: registered new interface driver gspca_pac7302
> [    5.852317] usbcore: registered new interface driver pac7311
> [    5.853223] usbcore: registered new interface driver se401
> [    5.854110] usbcore: registered new interface driver sn9c2028
> [    5.855017] usbcore: registered new interface driver gspca_sn9c20x
> [    5.855983] usbcore: registered new interface driver spca500
> [    5.856893] usbcore: registered new interface driver spca501
> [    5.857792] usbcore: registered new interface driver spca506
> [    5.858704] usbcore: registered new interface driver spca508
> [    5.859622] usbcore: registered new interface driver spca561
> [    5.860527] usbcore: registered new interface driver sq905c
> [    5.861414] usbcore: registered new interface driver sq930x
> [    5.862308] usbcore: registered new interface driver stk014
> [    5.863201] usbcore: registered new interface driver stv0680
> [    5.864102] usbcore: registered new interface driver t613
> [    5.864983] usbcore: registered new interface driver tv8532
> [    5.865887] usbcore: registered new interface driver vc032x
> [    5.866780] usbcore: registered new interface driver vicam
> [    5.867660] usbcore: registered new interface driver xirlink-cit
> [    5.868603] usbcore: registered new interface driver ALi m5602
> [    5.869526] usbcore: registered new interface driver STV06xx
> [    5.870428] usbcore: registered new interface driver gspca_gl860
> [    5.871385] usbcore: registered new interface driver Philips webcam
> [    5.872368] usbcore: registered new interface driver hdpvr
> [    5.873520] usbcore: registered new interface driver pvrusb2
> [    5.874431] pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner
> [    5.875756] pvrusb2: Debug mask is 31 (0x1f)
> [    5.876517] usbcore: registered new interface driver cx231xx
> [    5.877422] usbcore: registered new interface driver em28xx
> [    5.878292] em28xx: Registered (Em28xx Input Extension) extension
> [    5.879396] pps pps0: new PPS source ktimer
> [    5.880128] pps pps0: ktimer PPS source registered
> [    5.880925] pps_ldisc: PPS line discipline registered
> [    5.881739] pps_parport: parallel port PPS client
> [    5.882530] parport0: no more devices allowed
> [    5.883272] pps_parport: couldn't register with parport0
> [    5.884184] Driver for 1-wire Dallas network protocol.
> [    5.885084] usbcore: registered new interface driver DS9490R
> [    5.886046] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
> [    5.886787] usb usb1: dummy_bus_suspend
> [    5.889062] applesmc: supported laptop not found!
> [    5.889851] applesmc: driver init failed (ret=-19)!
> [    5.891577] pc87360: PC8736x not detected, module not inserted
> [    5.892751] md: raid0 personality registered for level 0
> [    5.893604] md: raid1 personality registered for level 1
> [    5.895059] md: raid6 personality registered for level 6
> [    5.895920] md: raid5 personality registered for level 5
> [    5.898521] md: raid4 personality registered for level 4
> [    5.899380] md: multipath personality registered for level -4
> [    5.900951] device-mapper: uevent: version 1.0.3
> [    5.902025] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
> [    5.903790] device-mapper: cache-policy-mq: version 1.2.0 loaded
> [    5.904715] Bluetooth: Virtual HCI driver ver 1.4
> [    5.905555] Bluetooth: HCI UART driver ver 2.2
> [    5.906317] Bluetooth: HCI H4 protocol initialized
> [    5.907107] Bluetooth: HCI BCSP protocol initialized
> [    5.907909] Bluetooth: HCILL protocol initialized
> [    5.908683] Bluetooth: HCI Three-wire UART (H5) protocol initialized
> [    5.909675] usbcore: registered new interface driver bpa10x
> [    5.910600] usbcore: registered new interface driver btusb
> [    5.911458] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
> [    5.912392] usbcore: registered new interface driver ath3k
> [    5.917557] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/1.1.2.3/1.1.2.2/1.1.2.2
> [    5.918880] PPP BSD Compression module registered
> [    5.919823] CAPI 2.0 started up with major 68 (middleware)
> [    5.920721] Modular ISDN core version 1.1.29
> [    5.921576] NET: Registered protocol family 34
> [    5.922343] DSP module 2.0
> [    5.922916] mISDN_dsp: DSP clocks every 80 samples. This equals 3 jiffies.
> [    5.925910] dss1_divert module successfully installed
> [    5.926742] HiSax: Linux Driver for passive ISDN cards
> [    5.927559] HiSax: Version 3.5 (kernel)
> [    5.928236] HiSax: Layer1 Revision 2.46.2.5
> [    5.928971] HiSax: Layer2 Revision 2.30.2.4
> [    5.929697] HiSax: TeiMgr Revision 2.20.2.3
> [    5.930416] HiSax: Layer3 Revision 2.22.2.3
> [    5.931132] HiSax: LinkLayer Revision 2.59.2.4
> [    5.931900] HiSax: Total 1 card defined
> [    5.932613] HiSax: Card 1 Protocol NONE Id=HiSax (0)
> [    5.933430] Gazel: Driver Revision 2.19.2.4
> [    5.934143] Gazel: ISA PnP card automatic recognition
> [    5.934960] Gazel: Card ISA R647/R648 found
> [    5.935700] Gazel: config irq:15 isac:0x8180  cfg:0xC180
> [    5.936540] Gazel: hscx A:0x180  hscx B:0x4180
> [    5.979141] Gazel: ISAC version (ff): 2085 V2.3
> [    5.979915] Gazel: HSCX version A: ???  B: ???
> [    5.980660] Gazel: wrong HSCX versions check IO address
> [    5.981514] HiSax: Card Gazel not installed !
> [    5.982255] HFC-S USB: driver module revision 2.3.2.24 date 2007/10/14 loaded, (debug=0)
> [    5.983640] usbcore: registered new interface driver hfc_usb
> [    5.984528] HFC-4S/8S: Layer 1 driver module for HFC-4S/8S isdn chips, Revision: 1.10
> [    5.985846] HFC-4S/8S: (C) 2003 Cornelius Consult, www.cornelius-consult.de
> [    5.986880] HFC-4S/8S: found 0 cards
> [    5.987543] ICN-ISDN-driver Rev 1.65.6.8 mem=0x000d0000
> [    5.988399] icn: (line0) ICN-2B, port 0x320 added
> [    5.989187] PCBIT-D device driver v 0.5-fjpc0 19991204 - Copyright (C) 1996 Universidade de Lisboa
> [    5.990624] Trying to detect board using default settings
> [    5.991519] IBM Active 2000 ISDN driver
> [    5.992273] act2000: No cards defined yet
> [    5.992991] gigaset: Driver for Gigaset 307x
> [    5.993733] gigaset: ISDN4Linux interface
> [    5.994517] lguest: mapped switcher at ffd2f000
> [    5.995435] cpufreq-nforce2: No nForce2 chipset.
> [    5.996264] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
> [    5.997374] usbcore: registered new interface driver vub300
> [    5.998569] usbcore: registered new interface driver ushc
> [    5.999871] No iBFT detected.
> [    6.001148] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldfish MMIO.
> [    6.002461] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with error -16
> [    6.003932]  fake-fmc-carrier: mezzanine 0
> [    6.004662]       Manufacturer: fake-vendor
> [    6.005382]       Product name: fake-design-for-testing
> [    6.006265] fmc fake-design-for-testing-f001: Driver has no ID: matches all
> [    6.007345] fmc_chardev fake-design-for-testing-f001: Created misc device "fake-design-for-testing-f001"
> [    6.008942] intel_rapl: driver does not support CPU family 15 model 6
> [    6.010133] NET: Registered protocol family 26
> [    6.010917] GACT probability NOT on
> [    6.011589] netem: version 1.3
> [    6.012206] u32 classifier
> [    6.012783]     Performance counters on
> [    6.013468]     Actions configured
> [    6.014164] ipip: IPv4 over IPv4 tunneling driver
> [    6.015207] IPv4 over IPSec tunneling driver
> [    6.016197] TCP: bic registered
> [    6.016823] TCP: westwood registered
> [    6.017479] TCP: highspeed registered
> [    6.018137] TCP: hybla registered
> [    6.018767] TCP: htcp registered
> [    6.019399] TCP: vegas registered
> [    6.020025] TCP: veno registered
> [    6.020642] TCP: scalable registered
> [    6.021294] TCP: yeah registered
> [    6.021916] TCP: illinois registered
> [    6.022588] Initializing XFRM netlink socket
> [    6.023334] NET: Registered protocol family 17
> [    6.024105] NET: Registered protocol family 15
> [    6.024897] NET: Registered protocol family 4
> [    6.025702] can: controller area network core (rev 20120528 abi 9)
> [    6.026682] NET: Registered protocol family 29
> [    6.027440] can: broadcast manager protocol (rev 20120528 t)
> [    6.028307] can: netlink gateway (rev 20130117) max_hops=1
> [    6.029689] IrCOMM protocol (Dag Brattli)
> [    6.032328] Bluetooth: RFCOMM socket layer initialized
> [    6.033190] Bluetooth: RFCOMM ver 1.11
> [    6.033908] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    6.034759] Bluetooth: BNEP socket layer initialized
> [    6.035560] Bluetooth: CMTP (CAPI Emulation) ver 1.0
> [    6.036383] Bluetooth: CMTP socket layer initialized
> [    6.037187] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> [    6.038096] Bluetooth: HIDP socket layer initialized
> [    6.038951] NET: Registered protocol family 33
> [    6.039712] Key type rxrpc registered
> [    6.040383] Key type rxrpc_s registered
> [    6.041352] cryptomgr_probe (129) used greatest stack depth: 7060 bytes left
> [    6.042440] RxRPC: Registered security type 2 'rxkad'
> [    6.043289] l2tp_core: L2TP core driver, V2.0
> [    6.044053] l2tp_ppp: PPPoL2TP kernel driver, V2.0
> [    6.044841] l2tp_netlink: L2TP netlink interface
> [    6.045638] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
> [    6.046570] NET: Registered protocol family 35
> [    6.047344] 8021q: 802.1Q VLAN Support v1.8
> [    6.048540] DCCP: Activated CCID 2 (TCP-like)
> [    6.049810] sctp: Hash tables configured (established 1365 bind 1489)
> [    6.051043] lib80211: common routines for IEEE802.11 drivers
> [    6.051933] lib80211_crypt: registered algorithm 'NULL'
> [    6.052780] tipc: Activated (version 2.0.0)
> [    6.054006] NET: Registered protocol family 30
> [    6.055047] tipc: Started in single node mode
> [    6.055872] 9pnet: Installing 9P2000 support
> [    6.056650] NET: Registered protocol family 37
> [    6.057426] NET: Registered protocol family 36
> [    6.058207] Key type dns_resolver registered
> [    6.058969] openvswitch: Open vSwitch switching datapath
> [    6.059870] mpls_gso: MPLS GSO support
> [    6.061263] 
> [    6.061263] printing PIC contents
> [    6.062269] ... PIC  IMR: ffff
> [    6.062292] ... PIC  IRR: 1113
> [    6.063495] ... PIC  ISR: 0000
> [    6.064099] ... PIC ELCR: 0c00
> [    6.064753] printing local APIC contents on CPU#0/0:
> [    6.065653] ... APIC ID:      00000000 (0)
> [    6.066416] ... APIC VERSION: 00050014
> [    6.066709] ... APIC TASKPRI: 00000000 (00)
> [    6.066709] ... APIC PROCPRI: 00000000
> [    6.066709] ... APIC LDR: 01000000
> [    6.066709] ... APIC DFR: ffffffff
> [    6.066709] ... APIC SPIV: 000001ff
> [    6.066709] ... APIC ISR field:
> [    6.066709] 0000000000000000000000000000000000000000000000000000000000000000
> [    6.066709] ... APIC TMR field:
> [    6.066709] 0000000002200000000000000000000000000000000000000000000000000000
> [    6.066709] ... APIC IRR field:
> [    6.066709] 0000000000000000000000000000000000000000000000000000000000008000
> [    6.066709] ... APIC ESR: 00000000
> [    6.066709] ... APIC ICR: 000008fd
> [    6.066709] ... APIC ICR2: 02000000
> [    6.066709] ... APIC LVTT: 000200ef
> [    6.066709] ... APIC LVTPC: 00010000
> [    6.066709] ... APIC LVT0: 00010700
> [    6.066709] ... APIC LVT1: 00000400
> [    6.066709] ... APIC LVTERR: 000000fe
> [    6.066709] ... APIC TMICT: 00032dcd
> [    6.066709] ... APIC TMCCT: 00027da1
> [    6.066709] ... APIC TDCR: 00000003
> [    6.066709] 
> [    6.085925] number of MP IRQ sources: 15.
> [    6.086641] number of IO-APIC #0 registers: 24.
> [    6.087400] testing the IO APIC.......................
> [    6.088230] IO APIC #0......
> [    6.088818] .... register #00: 00000000
> [    6.089508] .......    : physical APIC id: 00
> [    6.090245] .......    : Delivery Type: 0
> [    6.090946] .......    : LTS          : 0
> [    6.091650] .... register #01: 00170011
> [    6.092339] .......     : max redirection entries: 17
> [    6.093150] .......     : PRQ implemented: 0
> [    6.093879] .......     : IO APIC version: 11
> [    6.094618] .... register #02: 00000000
> [    6.095295] .......     : arbitration: 00
> [    6.097768] .... IRQ redirection table:
> [    6.098469] 1    0    0   0   0    0    0    00
> [    6.099237] 0    0    0   0   0    1    1    31
> [    6.100003] 0    0    0   0   0    1    1    30
> [    6.100768] 0    0    0   0   0    1    1    33
> [    6.101534] 1    0    0   0   0    1    1    34
> [    6.102304] 0    1    0   0   0    1    1    35
> [    6.103074] 0    0    0   0   0    1    1    36
> [    6.103842] 0    0    0   0   0    1    1    37
> [    6.104605] 0    0    0   0   0    1    1    38
> [    6.105367] 0    1    0   0   0    1    1    39
> [    6.106135] 1    1    0   0   0    1    1    3A
> [    6.106904] 1    1    0   0   0    1    1    3B
> [    6.107669] 0    0    0   0   0    1    1    3C
> [    6.108426] 0    0    0   0   0    1    1    3D
> [    6.109195] 0    0    0   0   0    1    1    3E
> [    6.109960] 0    0    0   0   0    1    1    3F
> [    6.110725] 1    0    0   0   0    0    0    00
> [    6.111488] 1    0    0   0   0    0    0    00
> [    6.112249] 1    0    0   0   0    0    0    00
> [    6.113024] 1    0    0   0   0    0    0    00
> [    6.113791] 1    0    0   0   0    0    0    00
> [    6.114557] 1    0    0   0   0    0    0    00
> [    6.115316] 1    0    0   0   0    0    0    00
> [    6.116090] 1    0    0   0   0    0    0    00
> [    6.116850] IRQ to pin mappings:
> [    6.117474] IRQ0 -> 0:2
> [    6.118135] IRQ1 -> 0:1
> [    6.118800] IRQ3 -> 0:3
> [    6.119484] IRQ4 -> 0:4
> [    6.120141] IRQ5 -> 0:5
> [    6.120805] IRQ6 -> 0:6
> [    6.121469] IRQ7 -> 0:7
> [    6.122133] IRQ8 -> 0:8
> [    6.122816] IRQ9 -> 0:9
> [    6.123478] IRQ10 -> 0:10
> [    6.124150] IRQ11 -> 0:11
> [    6.124831] IRQ12 -> 0:12
> [    6.125509] IRQ13 -> 0:13
> [    6.126202] IRQ14 -> 0:14
> [    6.126885] IRQ15 -> 0:15
> [    6.127564] .................................... done.
> [    6.128383] Using IPI Shortcut mode
> [    6.129336] Loading compiled-in X.509 certificates
> [    6.130794] cryptomgr_probe (131) used greatest stack depth: 7040 bytes left
> [    6.130843] Key type trusted registered
> [    6.132984] Key type encrypted registered
> [    6.134318] raid6test: testing the 4-disk case...
> [    6.135224] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
> [    6.136312] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(P)  OK
> [    6.137380] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(Q)  OK
> [    6.138439] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(P)  OK
> [    6.139517] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(Q)  OK
> [    6.140570] raid6test: test_disks(2, 3): faila=  2(P)  failb=  3(Q)  OK
> [    6.141633] raid6test: testing the 5-disk case...
> [    6.142528] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
> [    6.143600] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
> [    6.144662] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(P)  OK
> [    6.145726] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(Q)  OK
> [    6.146807] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
> [    6.147873] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(P)  OK
> [    6.148924] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(Q)  OK
> [    6.149995] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(P)  OK
> [    6.151058] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(Q)  OK
> [    6.152116] raid6test: test_disks(3, 4): faila=  3(P)  failb=  4(Q)  OK
> [    6.153296] raid6test: testing the 11-disk case...
> [    6.154218] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
> [    6.155324] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
> [    6.156438] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
> [    6.157548] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
> [    6.158651] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
> [    6.159768] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
> [    6.160889] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
> [    6.161985] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
> [    6.163098] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(P)  OK
> [    6.164189] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(Q)  OK
> [    6.165298] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
> [    6.166405] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
> [    6.167516] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
> [    6.168625] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
> [    6.169741] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
> [    6.170847] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
> [    6.171957] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
> [    6.173072] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(P)  OK
> [    6.174167] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(Q)  OK
> [    6.175282] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
> [    6.176412] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
> [    6.177519] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
> [    6.178620] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
> [    6.179733] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
> [    6.180839] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
> [    6.181938] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(P)  OK
> [    6.183036] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(Q)  OK
> [    6.184154] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
> [    6.185251] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
> [    6.186368] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
> [    6.187467] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
> [    6.188571] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
> [    6.189675] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(P)  OK
> [    6.190766] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(Q)  OK
> [    6.191880] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
> [    6.192995] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
> [    6.194105] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
> [    6.195210] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
> [    6.196326] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(P)  OK
> [    6.197439] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(Q)  OK
> [    6.198548] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
> [    6.199656] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
> [    6.200775] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
> [    6.201879] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(P)  OK
> [    6.202990] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(Q)  OK
> [    6.204112] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
> [    6.205218] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
> [    6.206336] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(P)  OK
> [    6.207441] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(Q)  OK
> [    6.208557] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
> [    6.209670] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(P)  OK
> [    6.210768] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(Q)  OK
> [    6.211880] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(P)  OK
> [    6.212993] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(Q)  OK
> [    6.214104] raid6test: test_disks(9, 10): faila=  9(P)  failb= 10(Q)  OK
> [    6.215293] raid6test: testing the 12-disk case...
> [    6.216229] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
> [    6.217346] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
> [    6.218457] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
> [    6.219582] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
> [    6.220697] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
> [    6.221813] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
> [    6.222939] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
> [    6.224057] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
> [    6.225168] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
> [    6.226281] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(P)  OK
> [    6.227403] raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(Q)  OK
> [    6.228518] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
> [    6.229638] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
> [    6.230754] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
> [    6.231867] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
> [    6.232988] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
> [    6.234104] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
> [    6.235217] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
> [    6.236331] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
> [    6.237461] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(P)  OK
> [    6.238570] raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(Q)  OK
> [    6.239694] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
> [    6.240804] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
> [    6.241910] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
> [    6.243027] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
> [    6.244139] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
> [    6.245237] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
> [    6.246352] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
> [    6.247460] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(P)  OK
> [    6.248556] raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(Q)  OK
> [    6.249673] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
> [    6.250786] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
> [    6.251895] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
> [    6.253013] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
> [    6.254118] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
> [    6.255223] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
> [    6.256337] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(P)  OK
> [    6.257457] raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(Q)  OK
> [    6.258579] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
> [    6.259692] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
> [    6.260811] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
> [    6.261926] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
> [    6.263045] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
> [    6.264161] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(P)  OK
> [    6.265260] raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(Q)  OK
> [    6.266387] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
> [    6.267496] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
> [    6.268594] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
> [    6.269711] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
> [    6.270824] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(P)  OK
> [    6.271926] raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(Q)  OK
> [    6.273054] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
> [    6.274161] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
> [    6.275271] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
> [    6.276392] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(P)  OK
> [    6.277498] raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(Q)  OK
> [    6.278611] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
> [    6.279729] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
> [    6.282592] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(P)  OK
> [    6.283702] raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(Q)  OK
> [    6.284819] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
> [    6.285936] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(P)  OK
> [    6.287047] raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(Q)  OK
> [    6.288164] raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(P)  OK
> [    6.289279] raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(Q)  OK
> [    6.290386] raid6test: test_disks(10, 11): faila= 10(P)  failb= 11(Q)  OK
> [    6.291819] raid6test: testing the 24-disk case...
> [    6.292831] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
> [    6.294012] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
> [    6.295192] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
> [    6.296382] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
> [    6.297560] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
> [    6.298738] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
> [    6.299922] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
> [    6.301101] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
> [    6.302280] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
> [    6.303476] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(D)  OK
> [    6.304665] raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(D)  OK
> [    6.305862] raid6test: test_disks(0, 12): faila=  0(D)  failb= 12(D)  OK
> [    6.307051] raid6test: test_disks(0, 13): faila=  0(D)  failb= 13(D)  OK
> [    6.308238] raid6test: test_disks(0, 14): faila=  0(D)  failb= 14(D)  OK
> [    6.309439] raid6test: test_disks(0, 15): faila=  0(D)  failb= 15(D)  OK
> [    6.310627] raid6test: test_disks(0, 16): faila=  0(D)  failb= 16(D)  OK
> [    6.311807] raid6test: test_disks(0, 17): faila=  0(D)  failb= 17(D)  OK
> [    6.313001] raid6test: test_disks(0, 18): faila=  0(D)  failb= 18(D)  OK
> [    6.314190] raid6test: test_disks(0, 19): faila=  0(D)  failb= 19(D)  OK
> [    6.315380] raid6test: test_disks(0, 20): faila=  0(D)  failb= 20(D)  OK
> [    6.316567] raid6test: test_disks(0, 21): faila=  0(D)  failb= 21(D)  OK
> [    6.317749] raid6test: test_disks(0, 22): faila=  0(D)  failb= 22(P)  OK
> [    6.318924] raid6test: test_disks(0, 23): faila=  0(D)  failb= 23(Q)  OK
> [    6.320118] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
> [    6.321298] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
> [    6.322495] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
> [    6.323668] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
> [    6.324838] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
> [    6.326022] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
> [    6.327208] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
> [    6.328395] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
> [    6.329578] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(D)  OK
> [    6.330773] raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(D)  OK
> [    6.331962] raid6test: test_disks(1, 12): faila=  1(D)  failb= 12(D)  OK
> [    6.333157] raid6test: test_disks(1, 13): faila=  1(D)  failb= 13(D)  OK
> [    6.334336] raid6test: test_disks(1, 14): faila=  1(D)  failb= 14(D)  OK
> [    6.335535] raid6test: test_disks(1, 15): faila=  1(D)  failb= 15(D)  OK
> [    6.336736] raid6test: test_disks(1, 16): faila=  1(D)  failb= 16(D)  OK
> [    6.337929] raid6test: test_disks(1, 17): faila=  1(D)  failb= 17(D)  OK
> [    6.339126] raid6test: test_disks(1, 18): faila=  1(D)  failb= 18(D)  OK
> [    6.340310] raid6test: test_disks(1, 19): faila=  1(D)  failb= 19(D)  OK
> [    6.341498] raid6test: test_disks(1, 20): faila=  1(D)  failb= 20(D)  OK
> [    6.342695] raid6test: test_disks(1, 21): faila=  1(D)  failb= 21(D)  OK
> [    6.343883] raid6test: test_disks(1, 22): faila=  1(D)  failb= 22(P)  OK
> [    6.345059] raid6test: test_disks(1, 23): faila=  1(D)  failb= 23(Q)  OK
> [    6.346258] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
> [    6.347445] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
> [    6.348625] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
> [    6.349813] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
> [    6.351008] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
> [    6.352183] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
> [    6.353377] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
> [    6.354560] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(D)  OK
> [    6.355756] raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(D)  OK
> [    6.356951] raid6test: test_disks(2, 12): faila=  2(D)  failb= 12(D)  OK
> [    6.358144] raid6test: test_disks(2, 13): faila=  2(D)  failb= 13(D)  OK
> [    6.359342] raid6test: test_disks(2, 14): faila=  2(D)  failb= 14(D)  OK
> [    6.360539] raid6test: test_disks(2, 15): faila=  2(D)  failb= 15(D)  OK
> [    6.361728] raid6test: test_disks(2, 16): faila=  2(D)  failb= 16(D)  OK
> [    6.362917] raid6test: test_disks(2, 17): faila=  2(D)  failb= 17(D)  OK
> [    6.364100] raid6test: test_disks(2, 18): faila=  2(D)  failb= 18(D)  OK
> [    6.365286] raid6test: test_disks(2, 19): faila=  2(D)  failb= 19(D)  OK
> [    6.366486] raid6test: test_disks(2, 20): faila=  2(D)  failb= 20(D)  OK
> [    6.367675] raid6test: test_disks(2, 21): faila=  2(D)  failb= 21(D)  OK
> [    6.368855] raid6test: test_disks(2, 22): faila=  2(D)  failb= 22(P)  OK
> [    6.370042] raid6test: test_disks(2, 23): faila=  2(D)  failb= 23(Q)  OK
> [    6.371227] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
> [    6.372424] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
> [    6.373609] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
> [    6.374784] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
> [    6.375967] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
> [    6.377146] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
> [    6.378322] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(D)  OK
> [    6.379520] raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(D)  OK
> [    6.380701] raid6test: test_disks(3, 12): faila=  3(D)  failb= 12(D)  OK
> [    6.381889] raid6test: test_disks(3, 13): faila=  3(D)  failb= 13(D)  OK
> [    6.383086] raid6test: test_disks(3, 14): faila=  3(D)  failb= 14(D)  OK
> [    6.384269] raid6test: test_disks(3, 15): faila=  3(D)  failb= 15(D)  OK
> [    6.385460] raid6test: test_disks(3, 16): faila=  3(D)  failb= 16(D)  OK
> [    6.386645] raid6test: test_disks(3, 17): faila=  3(D)  failb= 17(D)  OK
> [    6.387831] raid6test: test_disks(3, 18): faila=  3(D)  failb= 18(D)  OK
> [    6.389028] raid6test: test_disks(3, 19): faila=  3(D)  failb= 19(D)  OK
> [    6.390217] raid6test: test_disks(3, 20): faila=  3(D)  failb= 20(D)  OK
> [    6.391412] raid6test: test_disks(3, 21): faila=  3(D)  failb= 21(D)  OK
> [    6.392609] raid6test: test_disks(3, 22): faila=  3(D)  failb= 22(P)  OK
> [    6.393786] raid6test: test_disks(3, 23): faila=  3(D)  failb= 23(Q)  OK
> [    6.394973] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
> [    6.396155] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
> [    6.397326] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
> [    6.398510] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
> [    6.399703] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
> [    6.400888] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(D)  OK
> [    6.402077] raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(D)  OK
> [    6.403269] raid6test: test_disks(4, 12): faila=  4(D)  failb= 12(D)  OK
> [    6.404463] raid6test: test_disks(4, 13): faila=  4(D)  failb= 13(D)  OK
> [    6.405660] raid6test: test_disks(4, 14): faila=  4(D)  failb= 14(D)  OK
> [    6.406851] raid6test: test_disks(4, 15): faila=  4(D)  failb= 15(D)  OK
> [    6.408041] raid6test: test_disks(4, 16): faila=  4(D)  failb= 16(D)  OK
> [    6.409246] raid6test: test_disks(4, 17): faila=  4(D)  failb= 17(D)  OK
> [    6.410442] raid6test: test_disks(4, 18): faila=  4(D)  failb= 18(D)  OK
> [    6.411627] raid6test: test_disks(4, 19): faila=  4(D)  failb= 19(D)  OK
> [    6.412824] raid6test: test_disks(4, 20): faila=  4(D)  failb= 20(D)  OK
> [    6.414014] raid6test: test_disks(4, 21): faila=  4(D)  failb= 21(D)  OK
> [    6.415199] raid6test: test_disks(4, 22): faila=  4(D)  failb= 22(P)  OK
> [    6.416387] raid6test: test_disks(4, 23): faila=  4(D)  failb= 23(Q)  OK
> [    6.417572] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
> [    6.418746] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
> [    6.419933] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
> [    6.421109] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
> [    6.422283] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(D)  OK
> [    6.423484] raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(D)  OK
> [    6.424669] raid6test: test_disks(5, 12): faila=  5(D)  failb= 12(D)  OK
> [    6.425869] raid6test: test_disks(5, 13): faila=  5(D)  failb= 13(D)  OK
> [    6.427044] raid6test: test_disks(5, 14): faila=  5(D)  failb= 14(D)  OK
> [    6.428224] raid6test: test_disks(5, 15): faila=  5(D)  failb= 15(D)  OK
> [    6.429421] raid6test: test_disks(5, 16): faila=  5(D)  failb= 16(D)  OK
> [    6.430613] raid6test: test_disks(5, 17): faila=  5(D)  failb= 17(D)  OK
> [    6.431801] raid6test: test_disks(5, 18): faila=  5(D)  failb= 18(D)  OK
> [    6.433000] raid6test: test_disks(5, 19): faila=  5(D)  failb= 19(D)  OK
> [    6.434187] raid6test: test_disks(5, 20): faila=  5(D)  failb= 20(D)  OK
> [    6.435377] raid6test: test_disks(5, 21): faila=  5(D)  failb= 21(D)  OK
> [    6.436569] raid6test: test_disks(5, 22): faila=  5(D)  failb= 22(P)  OK
> [    6.437751] raid6test: test_disks(5, 23): faila=  5(D)  failb= 23(Q)  OK
> [    6.438939] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
> [    6.440116] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
> [    6.441287] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
> [    6.442478] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(D)  OK
> [    6.443671] raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(D)  OK
> [    6.444856] raid6test: test_disks(6, 12): faila=  6(D)  failb= 12(D)  OK
> [    6.446053] raid6test: test_disks(6, 13): faila=  6(D)  failb= 13(D)  OK
> [    6.447240] raid6test: test_disks(6, 14): faila=  6(D)  failb= 14(D)  OK
> [    6.448436] raid6test: test_disks(6, 15): faila=  6(D)  failb= 15(D)  OK
> [    6.449627] raid6test: test_disks(6, 16): faila=  6(D)  failb= 16(D)  OK
> [    6.450812] raid6test: test_disks(6, 17): faila=  6(D)  failb= 17(D)  OK
> [    6.452003] raid6test: test_disks(6, 18): faila=  6(D)  failb= 18(D)  OK
> [    6.453198] raid6test: test_disks(6, 19): faila=  6(D)  failb= 19(D)  OK
> [    6.454393] raid6test: test_disks(6, 20): faila=  6(D)  failb= 20(D)  OK
> [    6.455567] raid6test: test_disks(6, 21): faila=  6(D)  failb= 21(D)  OK
> [    6.456760] raid6test: test_disks(6, 22): faila=  6(D)  failb= 22(P)  OK
> [    6.457936] raid6test: test_disks(6, 23): faila=  6(D)  failb= 23(Q)  OK
> [    6.459123] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
> [    6.460300] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
> [    6.461468] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(D)  OK
> [    6.462671] raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(D)  OK
> [    6.463856] raid6test: test_disks(7, 12): faila=  7(D)  failb= 12(D)  OK
> [    6.465043] raid6test: test_disks(7, 13): faila=  7(D)  failb= 13(D)  OK
> [    6.466234] raid6test: test_disks(7, 14): faila=  7(D)  failb= 14(D)  OK
> [    6.467426] raid6test: test_disks(7, 15): faila=  7(D)  failb= 15(D)  OK
> [    6.468614] raid6test: test_disks(7, 16): faila=  7(D)  failb= 16(D)  OK
> [    6.469805] raid6test: test_disks(7, 17): faila=  7(D)  failb= 17(D)  OK
> [    6.470994] raid6test: test_disks(7, 18): faila=  7(D)  failb= 18(D)  OK
> [    6.472180] raid6test: test_disks(7, 19): faila=  7(D)  failb= 19(D)  OK
> [    6.473382] raid6test: test_disks(7, 20): faila=  7(D)  failb= 20(D)  OK
> [    6.474572] raid6test: test_disks(7, 21): faila=  7(D)  failb= 21(D)  OK
> [    6.475761] raid6test: test_disks(7, 22): faila=  7(D)  failb= 22(P)  OK
> [    6.476941] raid6test: test_disks(7, 23): faila=  7(D)  failb= 23(Q)  OK
> [    6.478127] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
> [    6.479312] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(D)  OK
> [    6.480505] raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(D)  OK
> [    6.481699] raid6test: test_disks(8, 12): faila=  8(D)  failb= 12(D)  OK
> [    6.482901] raid6test: test_disks(8, 13): faila=  8(D)  failb= 13(D)  OK
> [    6.484095] raid6test: test_disks(8, 14): faila=  8(D)  failb= 14(D)  OK
> [    6.485289] raid6test: test_disks(8, 15): faila=  8(D)  failb= 15(D)  OK
> [    6.486533] raid6test: test_disks(8, 16): faila=  8(D)  failb= 16(D)  OK
> [    6.487723] raid6test: test_disks(8, 17): faila=  8(D)  failb= 17(D)  OK
> [    6.488907] raid6test: test_disks(8, 18): faila=  8(D)  failb= 18(D)  OK
> [    6.490093] raid6test: test_disks(8, 19): faila=  8(D)  failb= 19(D)  OK
> [    6.491279] raid6test: test_disks(8, 20): faila=  8(D)  failb= 20(D)  OK
> [    6.492480] raid6test: test_disks(8, 21): faila=  8(D)  failb= 21(D)  OK
> [    6.493671] raid6test: test_disks(8, 22): faila=  8(D)  failb= 22(P)  OK
> [    6.494842] raid6test: test_disks(8, 23): faila=  8(D)  failb= 23(Q)  OK
> [    6.497793] raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(D)  OK
> [    6.498986] raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(D)  OK
> [    6.500171] raid6test: test_disks(9, 12): faila=  9(D)  failb= 12(D)  OK
> [    6.501348] raid6test: test_disks(9, 13): faila=  9(D)  failb= 13(D)  OK
> [    6.502550] raid6test: test_disks(9, 14): faila=  9(D)  failb= 14(D)  OK
> [    6.503738] raid6test: test_disks(9, 15): faila=  9(D)  failb= 15(D)  OK
> [    6.504922] raid6test: test_disks(9, 16): faila=  9(D)  failb= 16(D)  OK
> [    6.506119] raid6test: test_disks(9, 17): faila=  9(D)  failb= 17(D)  OK
> [    6.507304] raid6test: test_disks(9, 18): faila=  9(D)  failb= 18(D)  OK
> [    6.508492] raid6test: test_disks(9, 19): faila=  9(D)  failb= 19(D)  OK
> [    6.509689] raid6test: test_disks(9, 20): faila=  9(D)  failb= 20(D)  OK
> [    6.510877] raid6test: test_disks(9, 21): faila=  9(D)  failb= 21(D)  OK
> [    6.512061] raid6test: test_disks(9, 22): faila=  9(D)  failb= 22(P)  OK
> [    6.513238] raid6test: test_disks(9, 23): faila=  9(D)  failb= 23(Q)  OK
> [    6.514436] raid6test: test_disks(10, 11): faila= 10(D)  failb= 11(D)  OK
> [    6.515642] raid6test: test_disks(10, 12): faila= 10(D)  failb= 12(D)  OK
> [    6.516838] raid6test: test_disks(10, 13): faila= 10(D)  failb= 13(D)  OK
> [    6.518029] raid6test: test_disks(10, 14): faila= 10(D)  failb= 14(D)  OK
> [    6.519234] raid6test: test_disks(10, 15): faila= 10(D)  failb= 15(D)  OK
> [    6.520427] raid6test: test_disks(10, 16): faila= 10(D)  failb= 16(D)  OK
> [    6.521624] raid6test: test_disks(10, 17): faila= 10(D)  failb= 17(D)  OK
> [    6.522844] raid6test: test_disks(10, 18): faila= 10(D)  failb= 18(D)  OK
> [    6.524040] raid6test: test_disks(10, 19): faila= 10(D)  failb= 19(D)  OK
> [    6.525231] raid6test: test_disks(10, 20): faila= 10(D)  failb= 20(D)  OK
> [    6.526446] raid6test: test_disks(10, 21): faila= 10(D)  failb= 21(D)  OK
> [    6.527640] raid6test: test_disks(10, 22): faila= 10(D)  failb= 22(P)  OK
> [    6.528831] raid6test: test_disks(10, 23): faila= 10(D)  failb= 23(Q)  OK
> [    6.530024] raid6test: test_disks(11, 12): faila= 11(D)  failb= 12(D)  OK
> [    6.531220] raid6test: test_disks(11, 13): faila= 11(D)  failb= 13(D)  OK
> [    6.532423] raid6test: test_disks(11, 14): faila= 11(D)  failb= 14(D)  OK
> [    6.533612] raid6test: test_disks(11, 15): faila= 11(D)  failb= 15(D)  OK
> [    6.534801] raid6test: test_disks(11, 16): faila= 11(D)  failb= 16(D)  OK
> [    6.536008] raid6test: test_disks(11, 17): faila= 11(D)  failb= 17(D)  OK
> [    6.537202] raid6test: test_disks(11, 18): faila= 11(D)  failb= 18(D)  OK
> [    6.538397] raid6test: test_disks(11, 19): faila= 11(D)  failb= 19(D)  OK
> [    6.539603] raid6test: test_disks(11, 20): faila= 11(D)  failb= 20(D)  OK
> [    6.540800] raid6test: test_disks(11, 21): faila= 11(D)  failb= 21(D)  OK
> [    6.541989] raid6test: test_disks(11, 22): faila= 11(D)  failb= 22(P)  OK
> [    6.543172] raid6test: test_disks(11, 23): faila= 11(D)  failb= 23(Q)  OK
> [    6.544377] raid6test: test_disks(12, 13): faila= 12(D)  failb= 13(D)  OK
> [    6.545567] raid6test: test_disks(12, 14): faila= 12(D)  failb= 14(D)  OK
> [    6.546770] raid6test: test_disks(12, 15): faila= 12(D)  failb= 15(D)  OK
> [    6.547967] raid6test: test_disks(12, 16): faila= 12(D)  failb= 16(D)  OK
> [    6.549177] raid6test: test_disks(12, 17): faila= 12(D)  failb= 17(D)  OK
> [    6.550381] raid6test: test_disks(12, 18): faila= 12(D)  failb= 18(D)  OK
> [    6.551572] raid6test: test_disks(12, 19): faila= 12(D)  failb= 19(D)  OK
> [    6.552769] raid6test: test_disks(12, 20): faila= 12(D)  failb= 20(D)  OK
> [    6.553967] raid6test: test_disks(12, 21): faila= 12(D)  failb= 21(D)  OK
> [    6.555156] raid6test: test_disks(12, 22): faila= 12(D)  failb= 22(P)  OK
> [    6.556354] raid6test: test_disks(12, 23): faila= 12(D)  failb= 23(Q)  OK
> [    6.557553] raid6test: test_disks(13, 14): faila= 13(D)  failb= 14(D)  OK
> [    6.558747] raid6test: test_disks(13, 15): faila= 13(D)  failb= 15(D)  OK
> [    6.559950] raid6test: test_disks(13, 16): faila= 13(D)  failb= 16(D)  OK
> [    6.561150] raid6test: test_disks(13, 17): faila= 13(D)  failb= 17(D)  OK
> [    6.562354] raid6test: test_disks(13, 18): faila= 13(D)  failb= 18(D)  OK
> [    6.563542] raid6test: test_disks(13, 19): faila= 13(D)  failb= 19(D)  OK
> [    6.564728] raid6test: test_disks(13, 20): faila= 13(D)  failb= 20(D)  OK
> [    6.565926] raid6test: test_disks(13, 21): faila= 13(D)  failb= 21(D)  OK
> [    6.567121] raid6test: test_disks(13, 22): faila= 13(D)  failb= 22(P)  OK
> [    6.568293] raid6test: test_disks(13, 23): faila= 13(D)  failb= 23(Q)  OK
> [    6.569521] raid6test: test_disks(14, 15): faila= 14(D)  failb= 15(D)  OK
> [    6.570727] raid6test: test_disks(14, 16): faila= 14(D)  failb= 16(D)  OK
> [    6.571925] raid6test: test_disks(14, 17): faila= 14(D)  failb= 17(D)  OK
> [    6.573153] raid6test: test_disks(14, 18): faila= 14(D)  failb= 18(D)  OK
> [    6.574349] raid6test: test_disks(14, 19): faila= 14(D)  failb= 19(D)  OK
> [    6.575565] raid6test: test_disks(14, 20): faila= 14(D)  failb= 20(D)  OK
> [    6.576752] raid6test: test_disks(14, 21): faila= 14(D)  failb= 21(D)  OK
> [    6.578012] raid6test: test_disks(14, 22): faila= 14(D)  failb= 22(P)  OK
> [    6.579210] raid6test: test_disks(14, 23): faila= 14(D)  failb= 23(Q)  OK
> [    6.580386] raid6test: test_disks(15, 16): faila= 15(D)  failb= 16(D)  OK
> [    6.581606] raid6test: test_disks(15, 17): faila= 15(D)  failb= 17(D)  OK
> [    6.582862] raid6test: test_disks(15, 18): faila= 15(D)  failb= 18(D)  OK
> [    6.584048] raid6test: test_disks(15, 19): faila= 15(D)  failb= 19(D)  OK
> [    6.585239] raid6test: test_disks(15, 20): faila= 15(D)  failb= 20(D)  OK
> [    6.586463] raid6test: test_disks(15, 21): faila= 15(D)  failb= 21(D)  OK
> [    6.587658] raid6test: test_disks(15, 22): faila= 15(D)  failb= 22(P)  OK
> [    6.588829] raid6test: test_disks(15, 23): faila= 15(D)  failb= 23(Q)  OK
> [    6.590056] raid6test: test_disks(16, 17): faila= 16(D)  failb= 17(D)  OK
> [    6.591259] raid6test: test_disks(16, 18): faila= 16(D)  failb= 18(D)  OK
> [    6.592485] raid6test: test_disks(16, 19): faila= 16(D)  failb= 19(D)  OK
> [    6.593708] raid6test: test_disks(16, 20): faila= 16(D)  failb= 20(D)  OK
> [    6.594911] raid6test: test_disks(16, 21): faila= 16(D)  failb= 21(D)  OK
> [    6.596095] raid6test: test_disks(16, 22): faila= 16(D)  failb= 22(P)  OK
> [    6.597278] raid6test: test_disks(16, 23): faila= 16(D)  failb= 23(Q)  OK
> [    6.598485] raid6test: test_disks(17, 18): faila= 17(D)  failb= 18(D)  OK
> [    6.599693] raid6test: test_disks(17, 19): faila= 17(D)  failb= 19(D)  OK
> [    6.600879] raid6test: test_disks(17, 20): faila= 17(D)  failb= 20(D)  OK
> [    6.602114] raid6test: test_disks(17, 21): faila= 17(D)  failb= 21(D)  OK
> [    6.603350] raid6test: test_disks(17, 22): faila= 17(D)  failb= 22(P)  OK
> [    6.604503] raid6test: test_disks(17, 23): faila= 17(D)  failb= 23(Q)  OK
> [    6.605736] raid6test: test_disks(18, 19): faila= 18(D)  failb= 19(D)  OK
> [    6.606937] raid6test: test_disks(18, 20): faila= 18(D)  failb= 20(D)  OK
> [    6.608118] raid6test: test_disks(18, 21): faila= 18(D)  failb= 21(D)  OK
> [    6.609322] raid6test: test_disks(18, 22): faila= 18(D)  failb= 22(P)  OK
> [    6.610538] raid6test: test_disks(18, 23): faila= 18(D)  failb= 23(Q)  OK
> [    6.611734] raid6test: test_disks(19, 20): faila= 19(D)  failb= 20(D)  OK
> [    6.612982] raid6test: test_disks(19, 21): faila= 19(D)  failb= 21(D)  OK
> [    6.614212] raid6test: test_disks(19, 22): faila= 19(D)  failb= 22(P)  OK
> [    6.615414] raid6test: test_disks(19, 23): faila= 19(D)  failb= 23(Q)  OK
> [    6.616592] raid6test: test_disks(20, 21): faila= 20(D)  failb= 21(D)  OK
> [    6.617858] raid6test: test_disks(20, 22): faila= 20(D)  failb= 22(P)  OK
> [    6.619051] raid6test: test_disks(20, 23): faila= 20(D)  failb= 23(Q)  OK
> [    6.620224] raid6test: test_disks(21, 22): faila= 21(D)  failb= 22(P)  OK
> [    6.621433] raid6test: test_disks(21, 23): faila= 21(D)  failb= 23(Q)  OK
> [    6.622675] raid6test: test_disks(22, 23): faila= 22(P)  failb= 23(Q)  OK
> [    6.624868] raid6test: testing the 64-disk case...
> [    6.626131] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
> [    6.627563] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
> [    6.628978] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
> [    6.630384] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
> [    6.631820] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
> [    6.633262] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
> [    6.634693] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
> [    6.636098] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
> [    6.637526] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
> [    6.638939] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(D)  OK
> [    6.640343] raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(D)  OK
> [    6.641802] raid6test: test_disks(0, 12): faila=  0(D)  failb= 12(D)  OK
> [    6.643285] raid6test: test_disks(0, 13): faila=  0(D)  failb= 13(D)  OK
> [    6.644684] raid6test: test_disks(0, 14): faila=  0(D)  failb= 14(D)  OK
> [    6.646134] raid6test: test_disks(0, 15): faila=  0(D)  failb= 15(D)  OK
> [    6.647571] raid6test: test_disks(0, 16): faila=  0(D)  failb= 16(D)  OK
> [    6.648999] raid6test: test_disks(0, 17): faila=  0(D)  failb= 17(D)  OK
> [    6.650476] raid6test: test_disks(0, 18): faila=  0(D)  failb= 18(D)  OK
> [    6.651909] raid6test: test_disks(0, 19): faila=  0(D)  failb= 19(D)  OK
> [    6.653355] raid6test: test_disks(0, 20): faila=  0(D)  failb= 20(D)  OK
> [    6.654807] raid6test: test_disks(0, 21): faila=  0(D)  failb= 21(D)  OK
> [    6.656221] raid6test: test_disks(0, 22): faila=  0(D)  failb= 22(D)  OK
> [    6.657667] raid6test: test_disks(0, 23): faila=  0(D)  failb= 23(D)  OK
> [    6.659104] raid6test: test_disks(0, 24): faila=  0(D)  failb= 24(D)  OK
> [    6.660508] raid6test: test_disks(0, 25): faila=  0(D)  failb= 25(D)  OK
> [    6.661981] raid6test: test_disks(0, 26): faila=  0(D)  failb= 26(D)  OK
> [    6.663446] raid6test: test_disks(0, 27): faila=  0(D)  failb= 27(D)  OK
> [    6.664845] raid6test: test_disks(0, 28): faila=  0(D)  failb= 28(D)  OK
> [    6.666291] raid6test: test_disks(0, 29): faila=  0(D)  failb= 29(D)  OK
> [    6.667729] raid6test: test_disks(0, 30): faila=  0(D)  failb= 30(D)  OK
> [    6.669157] raid6test: test_disks(0, 31): faila=  0(D)  failb= 31(D)  OK
> [    6.670598] raid6test: test_disks(0, 32): faila=  0(D)  failb= 32(D)  OK
> [    6.672031] raid6test: test_disks(0, 33): faila=  0(D)  failb= 33(D)  OK
> [    6.673500] raid6test: test_disks(0, 34): faila=  0(D)  failb= 34(D)  OK
> [    6.674920] raid6test: test_disks(0, 35): faila=  0(D)  failb= 35(D)  OK
> [    6.676329] raid6test: test_disks(0, 36): faila=  0(D)  failb= 36(D)  OK
> [    6.677795] raid6test: test_disks(0, 37): faila=  0(D)  failb= 37(D)  OK
> [    6.679222] raid6test: test_disks(0, 38): faila=  0(D)  failb= 38(D)  OK
> [    6.680635] raid6test: test_disks(0, 39): faila=  0(D)  failb= 39(D)  OK
> [    6.682097] raid6test: test_disks(0, 40): faila=  0(D)  failb= 40(D)  OK
> [    6.683561] raid6test: test_disks(0, 41): faila=  0(D)  failb= 41(D)  OK
> [    6.684969] raid6test: test_disks(0, 42): faila=  0(D)  failb= 42(D)  OK
> [    6.686439] raid6test: test_disks(0, 43): faila=  0(D)  failb= 43(D)  OK
> [    6.687868] raid6test: test_disks(0, 44): faila=  0(D)  failb= 44(D)  OK
> [    6.689292] raid6test: test_disks(0, 45): faila=  0(D)  failb= 45(D)  OK
> [    6.690732] raid6test: test_disks(0, 46): faila=  0(D)  failb= 46(D)  OK
> [    6.692179] raid6test: test_disks(0, 47): faila=  0(D)  failb= 47(D)  OK
> [    6.693641] raid6test: test_disks(0, 48): faila=  0(D)  failb= 48(D)  OK
> [    6.695069] raid6test: test_disks(0, 49): faila=  0(D)  failb= 49(D)  OK
> [    6.696478] raid6test: test_disks(0, 50): faila=  0(D)  failb= 50(D)  OK
> [    6.697930] raid6test: test_disks(0, 51): faila=  0(D)  failb= 51(D)  OK
> [    6.699377] raid6test: test_disks(0, 52): faila=  0(D)  failb= 52(D)  OK
> [    6.700778] raid6test: test_disks(0, 53): faila=  0(D)  failb= 53(D)  OK
> [    6.702256] raid6test: test_disks(0, 54): faila=  0(D)  failb= 54(D)  OK
> [    6.703702] raid6test: test_disks(0, 55): faila=  0(D)  failb= 55(D)  OK
> [    6.705114] raid6test: test_disks(0, 56): faila=  0(D)  failb= 56(D)  OK
> [    6.706562] raid6test: test_disks(0, 57): faila=  0(D)  failb= 57(D)  OK
> [    6.707975] raid6test: test_disks(0, 58): faila=  0(D)  failb= 58(D)  OK
> [    6.709418] raid6test: test_disks(0, 59): faila=  0(D)  failb= 59(D)  OK
> [    6.710839] raid6test: test_disks(0, 60): faila=  0(D)  failb= 60(D)  OK
> [    6.712283] raid6test: test_disks(0, 61): faila=  0(D)  failb= 61(D)  OK
> [    6.713737] raid6test: test_disks(0, 62): faila=  0(D)  failb= 62(P)  OK
> [    6.715155] raid6test: test_disks(0, 63): faila=  0(D)  failb= 63(Q)  OK
> [    6.716577] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
> [    6.718015] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
> [    6.719453] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
> [    6.720842] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
> [    6.722358] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
> [    6.723787] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
> [    6.725188] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
> [    6.726626] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
> [    6.728030] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(D)  OK
> [    6.729479] raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(D)  OK
> [    6.730908] raid6test: test_disks(1, 12): faila=  1(D)  failb= 12(D)  OK
> [    6.734137] raid6test: test_disks(1, 13): faila=  1(D)  failb= 13(D)  OK
> [    6.735575] raid6test: test_disks(1, 14): faila=  1(D)  failb= 14(D)  OK
> [    6.737000] raid6test: test_disks(1, 15): faila=  1(D)  failb= 15(D)  OK
> [    6.738427] raid6test: test_disks(1, 16): faila=  1(D)  failb= 16(D)  OK
> [    6.739870] raid6test: test_disks(1, 17): faila=  1(D)  failb= 17(D)  OK
> [    6.741286] raid6test: test_disks(1, 18): faila=  1(D)  failb= 18(D)  OK
> [    6.742787] raid6test: test_disks(1, 19): faila=  1(D)  failb= 19(D)  OK
> [    6.744195] raid6test: test_disks(1, 20): faila=  1(D)  failb= 20(D)  OK
> [    6.745650] raid6test: test_disks(1, 21): faila=  1(D)  failb= 21(D)  OK
> [    6.747073] raid6test: test_disks(1, 22): faila=  1(D)  failb= 22(D)  OK
> [    6.748473] raid6test: test_disks(1, 23): faila=  1(D)  failb= 23(D)  OK
> [    6.749931] raid6test: test_disks(1, 24): faila=  1(D)  failb= 24(D)  OK
> [    6.751355] raid6test: test_disks(1, 25): faila=  1(D)  failb= 25(D)  OK
> [    6.752818] raid6test: test_disks(1, 26): faila=  1(D)  failb= 26(D)  OK
> [    6.754286] raid6test: test_disks(1, 27): faila=  1(D)  failb= 27(D)  OK
> [    6.755722] raid6test: test_disks(1, 28): faila=  1(D)  failb= 28(D)  OK
> [    6.757197] raid6test: test_disks(1, 29): faila=  1(D)  failb= 29(D)  OK
> [    6.758635] raid6test: test_disks(1, 30): faila=  1(D)  failb= 30(D)  OK
> [    6.760111] raid6test: test_disks(1, 31): faila=  1(D)  failb= 31(D)  OK
> [    6.761571] raid6test: test_disks(1, 32): faila=  1(D)  failb= 32(D)  OK
> [    6.763031] raid6test: test_disks(1, 33): faila=  1(D)  failb= 33(D)  OK
> [    6.764437] raid6test: test_disks(1, 34): faila=  1(D)  failb= 34(D)  OK
> [    6.765906] raid6test: test_disks(1, 35): faila=  1(D)  failb= 35(D)  OK
> [    6.767342] raid6test: test_disks(1, 36): faila=  1(D)  failb= 36(D)  OK
> [    6.768742] raid6test: test_disks(1, 37): faila=  1(D)  failb= 37(D)  OK
> [    6.770189] raid6test: test_disks(1, 38): faila=  1(D)  failb= 38(D)  OK
> [    6.771622] raid6test: test_disks(1, 39): faila=  1(D)  failb= 39(D)  OK
> [    6.773097] raid6test: test_disks(1, 40): faila=  1(D)  failb= 40(D)  OK
> [    6.774537] raid6test: test_disks(1, 41): faila=  1(D)  failb= 41(D)  OK
> [    6.775959] raid6test: test_disks(1, 42): faila=  1(D)  failb= 42(D)  OK
> [    6.777399] raid6test: test_disks(1, 43): faila=  1(D)  failb= 43(D)  OK
> [    6.778817] raid6test: test_disks(1, 44): faila=  1(D)  failb= 44(D)  OK
> [    6.780228] raid6test: test_disks(1, 45): faila=  1(D)  failb= 45(D)  OK
> [    6.781674] raid6test: test_disks(1, 46): faila=  1(D)  failb= 46(D)  OK
> [    6.783153] raid6test: test_disks(1, 47): faila=  1(D)  failb= 47(D)  OK
> [    6.784564] raid6test: test_disks(1, 48): faila=  1(D)  failb= 48(D)  OK
> [    6.786017] raid6test: test_disks(1, 49): faila=  1(D)  failb= 49(D)  OK
> [    6.787449] raid6test: test_disks(1, 50): faila=  1(D)  failb= 50(D)  OK
> [    6.788831] raid6test: test_disks(1, 51): faila=  1(D)  failb= 51(D)  OK
> [    6.790267] raid6test: test_disks(1, 52): faila=  1(D)  failb= 52(D)  OK
> [    6.791707] raid6test: test_disks(1, 53): faila=  1(D)  failb= 53(D)  OK
> [    6.793194] raid6test: test_disks(1, 54): faila=  1(D)  failb= 54(D)  OK
> [    6.794663] raid6test: test_disks(1, 55): faila=  1(D)  failb= 55(D)  OK
> [    6.796083] raid6test: test_disks(1, 56): faila=  1(D)  failb= 56(D)  OK
> [    6.797571] raid6test: test_disks(1, 57): faila=  1(D)  failb= 57(D)  OK
> [    6.799009] raid6test: test_disks(1, 58): faila=  1(D)  failb= 58(D)  OK
> [    6.800411] raid6test: test_disks(1, 59): faila=  1(D)  failb= 59(D)  OK
> [    6.801852] raid6test: test_disks(1, 60): faila=  1(D)  failb= 60(D)  OK
> [    6.803318] raid6test: test_disks(1, 61): faila=  1(D)  failb= 61(D)  OK
> [    6.804716] raid6test: test_disks(1, 62): faila=  1(D)  failb= 62(P)  OK
> [    6.806154] raid6test: test_disks(1, 63): faila=  1(D)  failb= 63(Q)  OK
> [    6.807594] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
> [    6.809012] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
> [    6.810430] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
> [    6.811864] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
> [    6.813300] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
> [    6.814739] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
> [    6.816147] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
> [    6.817579] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(D)  OK
> [    6.819017] raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(D)  OK
> [    6.820414] raid6test: test_disks(2, 12): faila=  2(D)  failb= 12(D)  OK
> [    6.821888] raid6test: test_disks(2, 13): faila=  2(D)  failb= 13(D)  OK
> [    6.823354] raid6test: test_disks(2, 14): faila=  2(D)  failb= 14(D)  OK
> [    6.824756] raid6test: test_disks(2, 15): faila=  2(D)  failb= 15(D)  OK
> [    6.826199] raid6test: test_disks(2, 16): faila=  2(D)  failb= 16(D)  OK
> [    6.827642] raid6test: test_disks(2, 17): faila=  2(D)  failb= 17(D)  OK
> [    6.829083] raid6test: test_disks(2, 18): faila=  2(D)  failb= 18(D)  OK
> [    6.830551] raid6test: test_disks(2, 19): faila=  2(D)  failb= 19(D)  OK
> [    6.831981] raid6test: test_disks(2, 20): faila=  2(D)  failb= 20(D)  OK
> [    6.833451] raid6test: test_disks(2, 21): faila=  2(D)  failb= 21(D)  OK
> [    6.834875] raid6test: test_disks(2, 22): faila=  2(D)  failb= 22(D)  OK
> [    6.836286] raid6test: test_disks(2, 23): faila=  2(D)  failb= 23(D)  OK
> [    6.837728] raid6test: test_disks(2, 24): faila=  2(D)  failb= 24(D)  OK
> [    6.839169] raid6test: test_disks(2, 25): faila=  2(D)  failb= 25(D)  OK
> [    6.840591] raid6test: test_disks(2, 26): faila=  2(D)  failb= 26(D)  OK
> [    6.842049] raid6test: test_disks(2, 27): faila=  2(D)  failb= 27(D)  OK
> [    6.843515] raid6test: test_disks(2, 28): faila=  2(D)  failb= 28(D)  OK
> [    6.844916] raid6test: test_disks(2, 29): faila=  2(D)  failb= 29(D)  OK
> [    6.846357] raid6test: test_disks(2, 30): faila=  2(D)  failb= 30(D)  OK
> [    6.847794] raid6test: test_disks(2, 31): faila=  2(D)  failb= 31(D)  OK
> [    6.849223] raid6test: test_disks(2, 32): faila=  2(D)  failb= 32(D)  OK
> [    6.850667] raid6test: test_disks(2, 33): faila=  2(D)  failb= 33(D)  OK
> [    6.852093] raid6test: test_disks(2, 34): faila=  2(D)  failb= 34(D)  OK
> [    6.853564] raid6test: test_disks(2, 35): faila=  2(D)  failb= 35(D)  OK
> [    6.854989] raid6test: test_disks(2, 36): faila=  2(D)  failb= 36(D)  OK
> [    6.856402] raid6test: test_disks(2, 37): faila=  2(D)  failb= 37(D)  OK
> [    6.857861] raid6test: test_disks(2, 38): faila=  2(D)  failb= 38(D)  OK
> [    6.859297] raid6test: test_disks(2, 39): faila=  2(D)  failb= 39(D)  OK
> [    6.860686] raid6test: test_disks(2, 40): faila=  2(D)  failb= 40(D)  OK
> [    6.862148] raid6test: test_disks(2, 41): faila=  2(D)  failb= 41(D)  OK
> [    6.863607] raid6test: test_disks(2, 42): faila=  2(D)  failb= 42(D)  OK
> [    6.865039] raid6test: test_disks(2, 43): faila=  2(D)  failb= 43(D)  OK
> [    6.866509] raid6test: test_disks(2, 44): faila=  2(D)  failb= 44(D)  OK
> [    6.867923] raid6test: test_disks(2, 45): faila=  2(D)  failb= 45(D)  OK
> [    6.869337] raid6test: test_disks(2, 46): faila=  2(D)  failb= 46(D)  OK
> [    6.870773] raid6test: test_disks(2, 47): faila=  2(D)  failb= 47(D)  OK
> [    6.872220] raid6test: test_disks(2, 48): faila=  2(D)  failb= 48(D)  OK
> [    6.873675] raid6test: test_disks(2, 49): faila=  2(D)  failb= 49(D)  OK
> [    6.875099] raid6test: test_disks(2, 50): faila=  2(D)  failb= 50(D)  OK
> [    6.876509] raid6test: test_disks(2, 51): faila=  2(D)  failb= 51(D)  OK
> [    6.877966] raid6test: test_disks(2, 52): faila=  2(D)  failb= 52(D)  OK
> [    6.879410] raid6test: test_disks(2, 53): faila=  2(D)  failb= 53(D)  OK
> [    6.880807] raid6test: test_disks(2, 54): faila=  2(D)  failb= 54(D)  OK
> [    6.882281] raid6test: test_disks(2, 55): faila=  2(D)  failb= 55(D)  OK
> [    6.883724] raid6test: test_disks(2, 56): faila=  2(D)  failb= 56(D)  OK
> [    6.885139] raid6test: test_disks(2, 57): faila=  2(D)  failb= 57(D)  OK
> [    6.886590] raid6test: test_disks(2, 58): faila=  2(D)  failb= 58(D)  OK
> [    6.888001] raid6test: test_disks(2, 59): faila=  2(D)  failb= 59(D)  OK
> [    6.889442] raid6test: test_disks(2, 60): faila=  2(D)  failb= 60(D)  OK
> [    6.890878] raid6test: test_disks(2, 61): faila=  2(D)  failb= 61(D)  OK
> [    6.892331] raid6test: test_disks(2, 62): faila=  2(D)  failb= 62(P)  OK
> [    6.893792] raid6test: test_disks(2, 63): faila=  2(D)  failb= 63(Q)  OK
> [    6.895204] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
> [    6.896618] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
> [    6.898057] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
> [    6.899497] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
> [    6.900891] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
> [    6.902387] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
> [    6.903815] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(D)  OK
> [    6.905229] raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(D)  OK
> [    6.906679] raid6test: test_disks(3, 12): faila=  3(D)  failb= 12(D)  OK
> [    6.908094] raid6test: test_disks(3, 13): faila=  3(D)  failb= 13(D)  OK
> [    6.909544] raid6test: test_disks(3, 14): faila=  3(D)  failb= 14(D)  OK
> [    6.910969] raid6test: test_disks(3, 15): faila=  3(D)  failb= 15(D)  OK
> [    6.912425] raid6test: test_disks(3, 16): faila=  3(D)  failb= 16(D)  OK
> [    6.913886] raid6test: test_disks(3, 17): faila=  3(D)  failb= 17(D)  OK
> [    6.915317] raid6test: test_disks(3, 18): faila=  3(D)  failb= 18(D)  OK
> [    6.916724] raid6test: test_disks(3, 19): faila=  3(D)  failb= 19(D)  OK
> [    6.918164] raid6test: test_disks(3, 20): faila=  3(D)  failb= 20(D)  OK
> [    6.919609] raid6test: test_disks(3, 21): faila=  3(D)  failb= 21(D)  OK
> [    6.921025] raid6test: test_disks(3, 22): faila=  3(D)  failb= 22(D)  OK
> [    6.922517] raid6test: test_disks(3, 23): faila=  3(D)  failb= 23(D)  OK
> [    6.923928] raid6test: test_disks(3, 24): faila=  3(D)  failb= 24(D)  OK
> [    6.925339] raid6test: test_disks(3, 25): faila=  3(D)  failb= 25(D)  OK
> [    6.926795] raid6test: test_disks(3, 26): faila=  3(D)  failb= 26(D)  OK
> [    6.928199] raid6test: test_disks(3, 27): faila=  3(D)  failb= 27(D)  OK
> [    6.929644] raid6test: test_disks(3, 28): faila=  3(D)  failb= 28(D)  OK
> [    6.931072] raid6test: test_disks(3, 29): faila=  3(D)  failb= 29(D)  OK
> [    6.932528] raid6test: test_disks(3, 30): faila=  3(D)  failb= 30(D)  OK
> [    6.933986] raid6test: test_disks(3, 31): faila=  3(D)  failb= 31(D)  OK
> [    6.935418] raid6test: test_disks(3, 32): faila=  3(D)  failb= 32(D)  OK
> [    6.936819] raid6test: test_disks(3, 33): faila=  3(D)  failb= 33(D)  OK
> [    6.938290] raid6test: test_disks(3, 34): faila=  3(D)  failb= 34(D)  OK
> [    6.939726] raid6test: test_disks(3, 35): faila=  3(D)  failb= 35(D)  OK
> [    6.941140] raid6test: test_disks(3, 36): faila=  3(D)  failb= 36(D)  OK
> [    6.942632] raid6test: test_disks(3, 37): faila=  3(D)  failb= 37(D)  OK
> [    6.944048] raid6test: test_disks(3, 38): faila=  3(D)  failb= 38(D)  OK
> [    6.945483] raid6test: test_disks(3, 39): faila=  3(D)  failb= 39(D)  OK
> [    6.946920] raid6test: test_disks(3, 40): faila=  3(D)  failb= 40(D)  OK
> [    6.948322] raid6test: test_disks(3, 41): faila=  3(D)  failb= 41(D)  OK
> [    6.949792] raid6test: test_disks(3, 42): faila=  3(D)  failb= 42(D)  OK
> [    6.951206] raid6test: test_disks(3, 43): faila=  3(D)  failb= 43(D)  OK
> [    6.952668] raid6test: test_disks(3, 44): faila=  3(D)  failb= 44(D)  OK
> [    6.954113] raid6test: test_disks(3, 45): faila=  3(D)  failb= 45(D)  OK
> [    6.955546] raid6test: test_disks(3, 46): faila=  3(D)  failb= 46(D)  OK
> [    6.956969] raid6test: test_disks(3, 47): faila=  3(D)  failb= 47(D)  OK
> [    6.958393] raid6test: test_disks(3, 48): faila=  3(D)  failb= 48(D)  OK
> [    6.959825] raid6test: test_disks(3, 49): faila=  3(D)  failb= 49(D)  OK
> [    6.961250] raid6test: test_disks(3, 50): faila=  3(D)  failb= 50(D)  OK
> [    6.962747] raid6test: test_disks(3, 51): faila=  3(D)  failb= 51(D)  OK
> [    6.964192] raid6test: test_disks(3, 52): faila=  3(D)  failb= 52(D)  OK
> [    6.965637] raid6test: test_disks(3, 53): faila=  3(D)  failb= 53(D)  OK
> [    6.967071] raid6test: test_disks(3, 54): faila=  3(D)  failb= 54(D)  OK
> [    6.968473] raid6test: test_disks(3, 55): faila=  3(D)  failb= 55(D)  OK
> [    6.969927] raid6test: test_disks(3, 56): faila=  3(D)  failb= 56(D)  OK
> [    6.971359] raid6test: test_disks(3, 57): faila=  3(D)  failb= 57(D)  OK
> [    6.972816] raid6test: test_disks(3, 58): faila=  3(D)  failb= 58(D)  OK
> [    6.974292] raid6test: test_disks(3, 59): faila=  3(D)  failb= 59(D)  OK
> [    6.975733] raid6test: test_disks(3, 60): faila=  3(D)  failb= 60(D)  OK
> [    6.977165] raid6test: test_disks(3, 61): faila=  3(D)  failb= 61(D)  OK
> [    6.978624] raid6test: test_disks(3, 62): faila=  3(D)  failb= 62(P)  OK
> [    6.980035] raid6test: test_disks(3, 63): faila=  3(D)  failb= 63(Q)  OK
> [    6.981477] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
> [    6.982949] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
> [    6.984329] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
> [    6.986045] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
> [    6.987525] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
> [    6.988966] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(D)  OK
> [    6.990424] raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(D)  OK
> [    6.991873] raid6test: test_disks(4, 12): faila=  4(D)  failb= 12(D)  OK
> [    6.995200] raid6test: test_disks(4, 13): faila=  4(D)  failb= 13(D)  OK
> [    6.996664] raid6test: test_disks(4, 14): faila=  4(D)  failb= 14(D)  OK
> [    6.998118] raid6test: test_disks(4, 15): faila=  4(D)  failb= 15(D)  OK
> [    6.999594] raid6test: test_disks(4, 16): faila=  4(D)  failb= 16(D)  OK
> [    7.001040] raid6test: test_disks(4, 17): faila=  4(D)  failb= 17(D)  OK
> [    7.002511] raid6test: test_disks(4, 18): faila=  4(D)  failb= 18(D)  OK
> [    7.003957] raid6test: test_disks(4, 19): faila=  4(D)  failb= 19(D)  OK
> [    7.005402] raid6test: test_disks(4, 20): faila=  4(D)  failb= 20(D)  OK
> [    7.006861] raid6test: test_disks(4, 21): faila=  4(D)  failb= 21(D)  OK
> [    7.008309] raid6test: test_disks(4, 22): faila=  4(D)  failb= 22(D)  OK
> [    7.009783] raid6test: test_disks(4, 23): faila=  4(D)  failb= 23(D)  OK
> [    7.011233] raid6test: test_disks(4, 24): faila=  4(D)  failb= 24(D)  OK
> [    7.012696] raid6test: test_disks(4, 25): faila=  4(D)  failb= 25(D)  OK
> [    7.014149] raid6test: test_disks(4, 26): faila=  4(D)  failb= 26(D)  OK
> [    7.015603] raid6test: test_disks(4, 27): faila=  4(D)  failb= 27(D)  OK
> [    7.017053] raid6test: test_disks(4, 28): faila=  4(D)  failb= 28(D)  OK
> [    7.018519] raid6test: test_disks(4, 29): faila=  4(D)  failb= 29(D)  OK
> [    7.019975] raid6test: test_disks(4, 30): faila=  4(D)  failb= 30(D)  OK
> [    7.021430] raid6test: test_disks(4, 31): faila=  4(D)  failb= 31(D)  OK
> [    7.022889] raid6test: test_disks(4, 32): faila=  4(D)  failb= 32(D)  OK
> [    7.024340] raid6test: test_disks(4, 33): faila=  4(D)  failb= 33(D)  OK
> [    7.025801] raid6test: test_disks(4, 34): faila=  4(D)  failb= 34(D)  OK
> [    7.027247] raid6test: test_disks(4, 35): faila=  4(D)  failb= 35(D)  OK
> [    7.028697] raid6test: test_disks(4, 36): faila=  4(D)  failb= 36(D)  OK
> [    7.030168] raid6test: test_disks(4, 37): faila=  4(D)  failb= 37(D)  OK
> [    7.031624] raid6test: test_disks(4, 38): faila=  4(D)  failb= 38(D)  OK
> [    7.033081] raid6test: test_disks(4, 39): faila=  4(D)  failb= 39(D)  OK
> [    7.034540] raid6test: test_disks(4, 40): faila=  4(D)  failb= 40(D)  OK
> [    7.035991] raid6test: test_disks(4, 41): faila=  4(D)  failb= 41(D)  OK
> [    7.037443] raid6test: test_disks(4, 42): faila=  4(D)  failb= 42(D)  OK
> [    7.038886] raid6test: test_disks(4, 43): faila=  4(D)  failb= 43(D)  OK
> [    7.040338] raid6test: test_disks(4, 44): faila=  4(D)  failb= 44(D)  OK
> [    7.041792] raid6test: test_disks(4, 45): faila=  4(D)  failb= 45(D)  OK
> [    7.043248] raid6test: test_disks(4, 46): faila=  4(D)  failb= 46(D)  OK
> [    7.044707] raid6test: test_disks(4, 47): faila=  4(D)  failb= 47(D)  OK
> [    7.046170] raid6test: test_disks(4, 48): faila=  4(D)  failb= 48(D)  OK
> [    7.047624] raid6test: test_disks(4, 49): faila=  4(D)  failb= 49(D)  OK
> [    7.049080] raid6test: test_disks(4, 50): faila=  4(D)  failb= 50(D)  OK
> [    7.050541] raid6test: test_disks(4, 51): faila=  4(D)  failb= 51(D)  OK
> [    7.051985] raid6test: test_disks(4, 52): faila=  4(D)  failb= 52(D)  OK
> [    7.053444] raid6test: test_disks(4, 53): faila=  4(D)  failb= 53(D)  OK
> [    7.054891] raid6test: test_disks(4, 54): faila=  4(D)  failb= 54(D)  OK
> [    7.056351] raid6test: test_disks(4, 55): faila=  4(D)  failb= 55(D)  OK
> [    7.057810] raid6test: test_disks(4, 56): faila=  4(D)  failb= 56(D)  OK
> [    7.059261] raid6test: test_disks(4, 57): faila=  4(D)  failb= 57(D)  OK
> [    7.060719] raid6test: test_disks(4, 58): faila=  4(D)  failb= 58(D)  OK
> [    7.062177] raid6test: test_disks(4, 59): faila=  4(D)  failb= 59(D)  OK
> [    7.063638] raid6test: test_disks(4, 60): faila=  4(D)  failb= 60(D)  OK
> [    7.065093] raid6test: test_disks(4, 61): faila=  4(D)  failb= 61(D)  OK
> [    7.066553] raid6test: test_disks(4, 62): faila=  4(D)  failb= 62(P)  OK
> [    7.067997] raid6test: test_disks(4, 63): faila=  4(D)  failb= 63(Q)  OK
> [    7.069459] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
> [    7.070901] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
> [    7.072350] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
> [    7.073796] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
> [    7.075239] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(D)  OK
> [    7.076696] raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(D)  OK
> [    7.078147] raid6test: test_disks(5, 12): faila=  5(D)  failb= 12(D)  OK
> [    7.079607] raid6test: test_disks(5, 13): faila=  5(D)  failb= 13(D)  OK
> [    7.081053] raid6test: test_disks(5, 14): faila=  5(D)  failb= 14(D)  OK
> [    7.082546] raid6test: test_disks(5, 15): faila=  5(D)  failb= 15(D)  OK
> [    7.083995] raid6test: test_disks(5, 16): faila=  5(D)  failb= 16(D)  OK
> [    7.085446] raid6test: test_disks(5, 17): faila=  5(D)  failb= 17(D)  OK
> [    7.086899] raid6test: test_disks(5, 18): faila=  5(D)  failb= 18(D)  OK
> [    7.088350] raid6test: test_disks(5, 19): faila=  5(D)  failb= 19(D)  OK
> [    7.089812] raid6test: test_disks(5, 20): faila=  5(D)  failb= 20(D)  OK
> [    7.091256] raid6test: test_disks(5, 21): faila=  5(D)  failb= 21(D)  OK
> [    7.092722] raid6test: test_disks(5, 22): faila=  5(D)  failb= 22(D)  OK
> [    7.094176] raid6test: test_disks(5, 23): faila=  5(D)  failb= 23(D)  OK
> [    7.095627] raid6test: test_disks(5, 24): faila=  5(D)  failb= 24(D)  OK
> [    7.097082] raid6test: test_disks(5, 25): faila=  5(D)  failb= 25(D)  OK
> [    7.098537] raid6test: test_disks(5, 26): faila=  5(D)  failb= 26(D)  OK
> [    7.099992] raid6test: test_disks(5, 27): faila=  5(D)  failb= 27(D)  OK
> [    7.101446] raid6test: test_disks(5, 28): faila=  5(D)  failb= 28(D)  OK
> [    7.102901] raid6test: test_disks(5, 29): faila=  5(D)  failb= 29(D)  OK
> [    7.104350] raid6test: test_disks(5, 30): faila=  5(D)  failb= 30(D)  OK
> [    7.105822] raid6test: test_disks(5, 31): faila=  5(D)  failb= 31(D)  OK
> [    7.107277] raid6test: test_disks(5, 32): faila=  5(D)  failb= 32(D)  OK
> [    7.108726] raid6test: test_disks(5, 33): faila=  5(D)  failb= 33(D)  OK
> [    7.110175] raid6test: test_disks(5, 34): faila=  5(D)  failb= 34(D)  OK
> [    7.111627] raid6test: test_disks(5, 35): faila=  5(D)  failb= 35(D)  OK
> [    7.113097] raid6test: test_disks(5, 36): faila=  5(D)  failb= 36(D)  OK
> [    7.114548] raid6test: test_disks(5, 37): faila=  5(D)  failb= 37(D)  OK
> [    7.116002] raid6test: test_disks(5, 38): faila=  5(D)  failb= 38(D)  OK
> [    7.117446] raid6test: test_disks(5, 39): faila=  5(D)  failb= 39(D)  OK
> [    7.118893] raid6test: test_disks(5, 40): faila=  5(D)  failb= 40(D)  OK
> [    7.120350] raid6test: test_disks(5, 41): faila=  5(D)  failb= 41(D)  OK
> [    7.121802] raid6test: test_disks(5, 42): faila=  5(D)  failb= 42(D)  OK
> [    7.123271] raid6test: test_disks(5, 43): faila=  5(D)  failb= 43(D)  OK
> [    7.124720] raid6test: test_disks(5, 44): faila=  5(D)  failb= 44(D)  OK
> [    7.126174] raid6test: test_disks(5, 45): faila=  5(D)  failb= 45(D)  OK
> [    7.127622] raid6test: test_disks(5, 46): faila=  5(D)  failb= 46(D)  OK
> [    7.129085] raid6test: test_disks(5, 47): faila=  5(D)  failb= 47(D)  OK
> [    7.130545] raid6test: test_disks(5, 48): faila=  5(D)  failb= 48(D)  OK
> [    7.131991] raid6test: test_disks(5, 49): faila=  5(D)  failb= 49(D)  OK
> [    7.133456] raid6test: test_disks(5, 50): faila=  5(D)  failb= 50(D)  OK
> [    7.134906] raid6test: test_disks(5, 51): faila=  5(D)  failb= 51(D)  OK
> [    7.136359] raid6test: test_disks(5, 52): faila=  5(D)  failb= 52(D)  OK
> [    7.137818] raid6test: test_disks(5, 53): faila=  5(D)  failb= 53(D)  OK
> [    7.139273] raid6test: test_disks(5, 54): faila=  5(D)  failb= 54(D)  OK
> [    7.140727] raid6test: test_disks(5, 55): faila=  5(D)  failb= 55(D)  OK
> [    7.142190] raid6test: test_disks(5, 56): faila=  5(D)  failb= 56(D)  OK
> [    7.143648] raid6test: test_disks(5, 57): faila=  5(D)  failb= 57(D)  OK
> [    7.145096] raid6test: test_disks(5, 58): faila=  5(D)  failb= 58(D)  OK
> [    7.146555] raid6test: test_disks(5, 59): faila=  5(D)  failb= 59(D)  OK
> [    7.148000] raid6test: test_disks(5, 60): faila=  5(D)  failb= 60(D)  OK
> [    7.149460] raid6test: test_disks(5, 61): faila=  5(D)  failb= 61(D)  OK
> [    7.150906] raid6test: test_disks(5, 62): faila=  5(D)  failb= 62(P)  OK
> [    7.152355] raid6test: test_disks(5, 63): faila=  5(D)  failb= 63(Q)  OK
> [    7.153817] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
> [    7.155255] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
> [    7.156704] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
> [    7.158145] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(D)  OK
> [    7.159605] raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(D)  OK
> [    7.161049] raid6test: test_disks(6, 12): faila=  6(D)  failb= 12(D)  OK
> [    7.162512] raid6test: test_disks(6, 13): faila=  6(D)  failb= 13(D)  OK
> [    7.163956] raid6test: test_disks(6, 14): faila=  6(D)  failb= 14(D)  OK
> [    7.165408] raid6test: test_disks(6, 15): faila=  6(D)  failb= 15(D)  OK
> [    7.166859] raid6test: test_disks(6, 16): faila=  6(D)  failb= 16(D)  OK
> [    7.168309] raid6test: test_disks(6, 17): faila=  6(D)  failb= 17(D)  OK
> [    7.169764] raid6test: test_disks(6, 18): faila=  6(D)  failb= 18(D)  OK
> [    7.171216] raid6test: test_disks(6, 19): faila=  6(D)  failb= 19(D)  OK
> [    7.172678] raid6test: test_disks(6, 20): faila=  6(D)  failb= 20(D)  OK
> [    7.174131] raid6test: test_disks(6, 21): faila=  6(D)  failb= 21(D)  OK
> [    7.175579] raid6test: test_disks(6, 22): faila=  6(D)  failb= 22(D)  OK
> [    7.177035] raid6test: test_disks(6, 23): faila=  6(D)  failb= 23(D)  OK
> [    7.178488] raid6test: test_disks(6, 24): faila=  6(D)  failb= 24(D)  OK
> [    7.179938] raid6test: test_disks(6, 25): faila=  6(D)  failb= 25(D)  OK
> [    7.181393] raid6test: test_disks(6, 26): faila=  6(D)  failb= 26(D)  OK
> [    7.182847] raid6test: test_disks(6, 27): faila=  6(D)  failb= 27(D)  OK
> [    7.184293] raid6test: test_disks(6, 28): faila=  6(D)  failb= 28(D)  OK
> [    7.185751] raid6test: test_disks(6, 29): faila=  6(D)  failb= 29(D)  OK
> [    7.187197] raid6test: test_disks(6, 30): faila=  6(D)  failb= 30(D)  OK
> [    7.188827] raid6test: test_disks(6, 31): faila=  6(D)  failb= 31(D)  OK
> [    7.190303] raid6test: test_disks(6, 32): faila=  6(D)  failb= 32(D)  OK
> [    7.191759] raid6test: test_disks(6, 33): faila=  6(D)  failb= 33(D)  OK
> [    7.193224] raid6test: test_disks(6, 34): faila=  6(D)  failb= 34(D)  OK
> [    7.194655] raid6test: test_disks(6, 35): faila=  6(D)  failb= 35(D)  OK
> [    7.196095] raid6test: test_disks(6, 36): faila=  6(D)  failb= 36(D)  OK
> [    7.197528] raid6test: test_disks(6, 37): faila=  6(D)  failb= 37(D)  OK
> [    7.198948] raid6test: test_disks(6, 38): faila=  6(D)  failb= 38(D)  OK
> [    7.200361] raid6test: test_disks(6, 39): faila=  6(D)  failb= 39(D)  OK
> [    7.201813] raid6test: test_disks(6, 40): faila=  6(D)  failb= 40(D)  OK
> [    7.203313] raid6test: test_disks(6, 41): faila=  6(D)  failb= 41(D)  OK
> [    7.204711] raid6test: test_disks(6, 42): faila=  6(D)  failb= 42(D)  OK
> [    7.206150] raid6test: test_disks(6, 43): faila=  6(D)  failb= 43(D)  OK
> [    7.207604] raid6test: test_disks(6, 44): faila=  6(D)  failb= 44(D)  OK
> [    7.209021] raid6test: test_disks(6, 45): faila=  6(D)  failb= 45(D)  OK
> [    7.210435] raid6test: test_disks(6, 46): faila=  6(D)  failb= 46(D)  OK
> [    7.211892] raid6test: test_disks(6, 47): faila=  6(D)  failb= 47(D)  OK
> [    7.213335] raid6test: test_disks(6, 48): faila=  6(D)  failb= 48(D)  OK
> [    7.214782] raid6test: test_disks(6, 49): faila=  6(D)  failb= 49(D)  OK
> [    7.216216] raid6test: test_disks(6, 50): faila=  6(D)  failb= 50(D)  OK
> [    7.217660] raid6test: test_disks(6, 51): faila=  6(D)  failb= 51(D)  OK
> [    7.219127] raid6test: test_disks(6, 52): faila=  6(D)  failb= 52(D)  OK
> [    7.220506] raid6test: test_disks(6, 53): faila=  6(D)  failb= 53(D)  OK
> [    7.221971] raid6test: test_disks(6, 54): faila=  6(D)  failb= 54(D)  OK
> [    7.223455] raid6test: test_disks(6, 55): faila=  6(D)  failb= 55(D)  OK
> [    7.224854] raid6test: test_disks(6, 56): faila=  6(D)  failb= 56(D)  OK
> [    7.226330] raid6test: test_disks(6, 57): faila=  6(D)  failb= 57(D)  OK
> [    7.227780] raid6test: test_disks(6, 58): faila=  6(D)  failb= 58(D)  OK
> [    7.229197] raid6test: test_disks(6, 59): faila=  6(D)  failb= 59(D)  OK
> [    7.230627] raid6test: test_disks(6, 60): faila=  6(D)  failb= 60(D)  OK
> [    7.232080] raid6test: test_disks(6, 61): faila=  6(D)  failb= 61(D)  OK
> [    7.233537] raid6test: test_disks(6, 62): faila=  6(D)  failb= 62(P)  OK
> [    7.234946] raid6test: test_disks(6, 63): faila=  6(D)  failb= 63(Q)  OK
> [    7.236354] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
> [    7.237804] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
> [    7.239240] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(D)  OK
> [    7.240635] raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(D)  OK
> [    7.242091] raid6test: test_disks(7, 12): faila=  7(D)  failb= 12(D)  OK
> [    7.243573] raid6test: test_disks(7, 13): faila=  7(D)  failb= 13(D)  OK
> [    7.245008] raid6test: test_disks(7, 14): faila=  7(D)  failb= 14(D)  OK
> [    7.246448] raid6test: test_disks(7, 15): faila=  7(D)  failb= 15(D)  OK
> [    7.247904] raid6test: test_disks(7, 16): faila=  7(D)  failb= 16(D)  OK
> [    7.249340] raid6test: test_disks(7, 17): faila=  7(D)  failb= 17(D)  OK
> [    7.250782] raid6test: test_disks(7, 18): faila=  7(D)  failb= 18(D)  OK
> [    7.252261] raid6test: test_disks(7, 19): faila=  7(D)  failb= 19(D)  OK
> [    7.253725] raid6test: test_disks(7, 20): faila=  7(D)  failb= 20(D)  OK
> [    7.255183] raid6test: test_disks(7, 21): faila=  7(D)  failb= 21(D)  OK
> [    7.258351] raid6test: test_disks(7, 22): faila=  7(D)  failb= 22(D)  OK
> [    7.259809] raid6test: test_disks(7, 23): faila=  7(D)  failb= 23(D)  OK
> [    7.261245] raid6test: test_disks(7, 24): faila=  7(D)  failb= 24(D)  OK
> [    7.262726] raid6test: test_disks(7, 25): faila=  7(D)  failb= 25(D)  OK
> [    7.264159] raid6test: test_disks(7, 26): faila=  7(D)  failb= 26(D)  OK
> [    7.265604] raid6test: test_disks(7, 27): faila=  7(D)  failb= 27(D)  OK
> [    7.267057] raid6test: test_disks(7, 28): faila=  7(D)  failb= 28(D)  OK
> [    7.268451] raid6test: test_disks(7, 29): faila=  7(D)  failb= 29(D)  OK
> [    7.269913] raid6test: test_disks(7, 30): faila=  7(D)  failb= 30(D)  OK
> [    7.271353] raid6test: test_disks(7, 31): faila=  7(D)  failb= 31(D)  OK
> [    7.272806] raid6test: test_disks(7, 32): faila=  7(D)  failb= 32(D)  OK
> [    7.274236] raid6test: test_disks(7, 33): faila=  7(D)  failb= 33(D)  OK
> [    7.275696] raid6test: test_disks(7, 34): faila=  7(D)  failb= 34(D)  OK
> [    7.277111] raid6test: test_disks(7, 35): faila=  7(D)  failb= 35(D)  OK
> [    7.278544] raid6test: test_disks(7, 36): faila=  7(D)  failb= 36(D)  OK
> [    7.279971] raid6test: test_disks(7, 37): faila=  7(D)  failb= 37(D)  OK
> [    7.281391] raid6test: test_disks(7, 38): faila=  7(D)  failb= 38(D)  OK
> [    7.282878] raid6test: test_disks(7, 39): faila=  7(D)  failb= 39(D)  OK
> [    7.284290] raid6test: test_disks(7, 40): faila=  7(D)  failb= 40(D)  OK
> [    7.285742] raid6test: test_disks(7, 41): faila=  7(D)  failb= 41(D)  OK
> [    7.287201] raid6test: test_disks(7, 42): faila=  7(D)  failb= 42(D)  OK
> [    7.288585] raid6test: test_disks(7, 43): faila=  7(D)  failb= 43(D)  OK
> [    7.290027] raid6test: test_disks(7, 44): faila=  7(D)  failb= 44(D)  OK
> [    7.291482] raid6test: test_disks(7, 45): faila=  7(D)  failb= 45(D)  OK
> [    7.292930] raid6test: test_disks(7, 46): faila=  7(D)  failb= 46(D)  OK
> [    7.294355] raid6test: test_disks(7, 47): faila=  7(D)  failb= 47(D)  OK
> [    7.295817] raid6test: test_disks(7, 48): faila=  7(D)  failb= 48(D)  OK
> [    7.297250] raid6test: test_disks(7, 49): faila=  7(D)  failb= 49(D)  OK
> [    7.298674] raid6test: test_disks(7, 50): faila=  7(D)  failb= 50(D)  OK
> [    7.300106] raid6test: test_disks(7, 51): faila=  7(D)  failb= 51(D)  OK
> [    7.301536] raid6test: test_disks(7, 52): faila=  7(D)  failb= 52(D)  OK
> [    7.303042] raid6test: test_disks(7, 53): faila=  7(D)  failb= 53(D)  OK
> [    7.304434] raid6test: test_disks(7, 54): faila=  7(D)  failb= 54(D)  OK
> [    7.305888] raid6test: test_disks(7, 55): faila=  7(D)  failb= 55(D)  OK
> [    7.307327] raid6test: test_disks(7, 56): faila=  7(D)  failb= 56(D)  OK
> [    7.308719] raid6test: test_disks(7, 57): faila=  7(D)  failb= 57(D)  OK
> [    7.310157] raid6test: test_disks(7, 58): faila=  7(D)  failb= 58(D)  OK
> [    7.311605] raid6test: test_disks(7, 59): faila=  7(D)  failb= 59(D)  OK
> [    7.313071] raid6test: test_disks(7, 60): faila=  7(D)  failb= 60(D)  OK
> [    7.314489] raid6test: test_disks(7, 61): faila=  7(D)  failb= 61(D)  OK
> [    7.315937] raid6test: test_disks(7, 62): faila=  7(D)  failb= 62(P)  OK
> [    7.317345] raid6test: test_disks(7, 63): faila=  7(D)  failb= 63(Q)  OK
> [    7.318782] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
> [    7.320200] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(D)  OK
> [    7.321636] raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(D)  OK
> [    7.323146] raid6test: test_disks(8, 12): faila=  8(D)  failb= 12(D)  OK
> [    7.324507] raid6test: test_disks(8, 13): faila=  8(D)  failb= 13(D)  OK
> [    7.325964] raid6test: test_disks(8, 14): faila=  8(D)  failb= 14(D)  OK
> [    7.327409] raid6test: test_disks(8, 15): faila=  8(D)  failb= 15(D)  OK
> [    7.328803] raid6test: test_disks(8, 16): faila=  8(D)  failb= 16(D)  OK
> [    7.330236] raid6test: test_disks(8, 17): faila=  8(D)  failb= 17(D)  OK
> [    7.331685] raid6test: test_disks(8, 18): faila=  8(D)  failb= 18(D)  OK
> [    7.333171] raid6test: test_disks(8, 19): faila=  8(D)  failb= 19(D)  OK
> [    7.334594] raid6test: test_disks(8, 20): faila=  8(D)  failb= 20(D)  OK
> [    7.336030] raid6test: test_disks(8, 21): faila=  8(D)  failb= 21(D)  OK
> [    7.337508] raid6test: test_disks(8, 22): faila=  8(D)  failb= 22(D)  OK
> [    7.338926] raid6test: test_disks(8, 23): faila=  8(D)  failb= 23(D)  OK
> [    7.340344] raid6test: test_disks(8, 24): faila=  8(D)  failb= 24(D)  OK
> [    7.341776] raid6test: test_disks(8, 25): faila=  8(D)  failb= 25(D)  OK
> [    7.343279] raid6test: test_disks(8, 26): faila=  8(D)  failb= 26(D)  OK
> [    7.344666] raid6test: test_disks(8, 27): faila=  8(D)  failb= 27(D)  OK
> [    7.346109] raid6test: test_disks(8, 28): faila=  8(D)  failb= 28(D)  OK
> [    7.347555] raid6test: test_disks(8, 29): faila=  8(D)  failb= 29(D)  OK
> [    7.348956] raid6test: test_disks(8, 30): faila=  8(D)  failb= 30(D)  OK
> [    7.350372] raid6test: test_disks(8, 31): faila=  8(D)  failb= 31(D)  OK
> [    7.351840] raid6test: test_disks(8, 32): faila=  8(D)  failb= 32(D)  OK
> [    7.353285] raid6test: test_disks(8, 33): faila=  8(D)  failb= 33(D)  OK
> [    7.354721] raid6test: test_disks(8, 34): faila=  8(D)  failb= 34(D)  OK
> [    7.356157] raid6test: test_disks(8, 35): faila=  8(D)  failb= 35(D)  OK
> [    7.357589] raid6test: test_disks(8, 36): faila=  8(D)  failb= 36(D)  OK
> [    7.359035] raid6test: test_disks(8, 37): faila=  8(D)  failb= 37(D)  OK
> [    7.360425] raid6test: test_disks(8, 38): faila=  8(D)  failb= 38(D)  OK
> [    7.361887] raid6test: test_disks(8, 39): faila=  8(D)  failb= 39(D)  OK
> [    7.363365] raid6test: test_disks(8, 40): faila=  8(D)  failb= 40(D)  OK
> [    7.364769] raid6test: test_disks(8, 41): faila=  8(D)  failb= 41(D)  OK
> [    7.366205] raid6test: test_disks(8, 42): faila=  8(D)  failb= 42(D)  OK
> [    7.367656] raid6test: test_disks(8, 43): faila=  8(D)  failb= 43(D)  OK
> [    7.369097] raid6test: test_disks(8, 44): faila=  8(D)  failb= 44(D)  OK
> [    7.370526] raid6test: test_disks(8, 45): faila=  8(D)  failb= 45(D)  OK
> [    7.371973] raid6test: test_disks(8, 46): faila=  8(D)  failb= 46(D)  OK
> [    7.373436] raid6test: test_disks(8, 47): faila=  8(D)  failb= 47(D)  OK
> [    7.374859] raid6test: test_disks(8, 48): faila=  8(D)  failb= 48(D)  OK
> [    7.376285] raid6test: test_disks(8, 49): faila=  8(D)  failb= 49(D)  OK
> [    7.377725] raid6test: test_disks(8, 50): faila=  8(D)  failb= 50(D)  OK
> [    7.379186] raid6test: test_disks(8, 51): faila=  8(D)  failb= 51(D)  OK
> [    7.380577] raid6test: test_disks(8, 52): faila=  8(D)  failb= 52(D)  OK
> [    7.382034] raid6test: test_disks(8, 53): faila=  8(D)  failb= 53(D)  OK
> [    7.383513] raid6test: test_disks(8, 54): faila=  8(D)  failb= 54(D)  OK
> [    7.384911] raid6test: test_disks(8, 55): faila=  8(D)  failb= 55(D)  OK
> [    7.386347] raid6test: test_disks(8, 56): faila=  8(D)  failb= 56(D)  OK
> [    7.387797] raid6test: test_disks(8, 57): faila=  8(D)  failb= 57(D)  OK
> [    7.389219] raid6test: test_disks(8, 58): faila=  8(D)  failb= 58(D)  OK
> [    7.390653] raid6test: test_disks(8, 59): faila=  8(D)  failb= 59(D)  OK
> [    7.392102] raid6test: test_disks(8, 60): faila=  8(D)  failb= 60(D)  OK
> [    7.393575] raid6test: test_disks(8, 61): faila=  8(D)  failb= 61(D)  OK
> [    7.395004] raid6test: test_disks(8, 62): faila=  8(D)  failb= 62(P)  OK
> [    7.396399] raid6test: test_disks(8, 63): faila=  8(D)  failb= 63(Q)  OK
> [    7.397840] raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(D)  OK
> [    7.399291] raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(D)  OK
> [    7.400685] raid6test: test_disks(9, 12): faila=  9(D)  failb= 12(D)  OK
> [    7.402144] raid6test: test_disks(9, 13): faila=  9(D)  failb= 13(D)  OK
> [    7.403625] raid6test: test_disks(9, 14): faila=  9(D)  failb= 14(D)  OK
> [    7.405042] raid6test: test_disks(9, 15): faila=  9(D)  failb= 15(D)  OK
> [    7.406479] raid6test: test_disks(9, 16): faila=  9(D)  failb= 16(D)  OK
> [    7.407917] raid6test: test_disks(9, 17): faila=  9(D)  failb= 17(D)  OK
> [    7.409342] raid6test: test_disks(9, 18): faila=  9(D)  failb= 18(D)  OK
> [    7.410780] raid6test: test_disks(9, 19): faila=  9(D)  failb= 19(D)  OK
> [    7.412246] raid6test: test_disks(9, 20): faila=  9(D)  failb= 20(D)  OK
> [    7.413701] raid6test: test_disks(9, 21): faila=  9(D)  failb= 21(D)  OK
> [    7.415160] raid6test: test_disks(9, 22): faila=  9(D)  failb= 22(D)  OK
> [    7.416545] raid6test: test_disks(9, 23): faila=  9(D)  failb= 23(D)  OK
> [    7.417993] raid6test: test_disks(9, 24): faila=  9(D)  failb= 24(D)  OK
> [    7.419439] raid6test: test_disks(9, 25): faila=  9(D)  failb= 25(D)  OK
> [    7.420825] raid6test: test_disks(9, 26): faila=  9(D)  failb= 26(D)  OK
> [    7.422287] raid6test: test_disks(9, 27): faila=  9(D)  failb= 27(D)  OK
> [    7.423742] raid6test: test_disks(9, 28): faila=  9(D)  failb= 28(D)  OK
> [    7.425152] raid6test: test_disks(9, 29): faila=  9(D)  failb= 29(D)  OK
> [    7.426585] raid6test: test_disks(9, 30): faila=  9(D)  failb= 30(D)  OK
> [    7.428016] raid6test: test_disks(9, 31): faila=  9(D)  failb= 31(D)  OK
> [    7.429454] raid6test: test_disks(9, 32): faila=  9(D)  failb= 32(D)  OK
> [    7.430873] raid6test: test_disks(9, 33): faila=  9(D)  failb= 33(D)  OK
> [    7.432342] raid6test: test_disks(9, 34): faila=  9(D)  failb= 34(D)  OK
> [    7.433797] raid6test: test_disks(9, 35): faila=  9(D)  failb= 35(D)  OK
> [    7.435233] raid6test: test_disks(9, 36): faila=  9(D)  failb= 36(D)  OK
> [    7.436634] raid6test: test_disks(9, 37): faila=  9(D)  failb= 37(D)  OK
> [    7.438071] raid6test: test_disks(9, 38): faila=  9(D)  failb= 38(D)  OK
> [    7.439527] raid6test: test_disks(9, 39): faila=  9(D)  failb= 39(D)  OK
> [    7.440923] raid6test: test_disks(9, 40): faila=  9(D)  failb= 40(D)  OK
> [    7.442415] raid6test: test_disks(9, 41): faila=  9(D)  failb= 41(D)  OK
> [    7.443859] raid6test: test_disks(9, 42): faila=  9(D)  failb= 42(D)  OK
> [    7.445266] raid6test: test_disks(9, 43): faila=  9(D)  failb= 43(D)  OK
> [    7.446706] raid6test: test_disks(9, 44): faila=  9(D)  failb= 44(D)  OK
> [    7.448130] raid6test: test_disks(9, 45): faila=  9(D)  failb= 45(D)  OK
> [    7.449576] raid6test: test_disks(9, 46): faila=  9(D)  failb= 46(D)  OK
> [    7.451008] raid6test: test_disks(9, 47): faila=  9(D)  failb= 47(D)  OK
> [    7.452461] raid6test: test_disks(9, 48): faila=  9(D)  failb= 48(D)  OK
> [    7.453875] raid6test: test_disks(9, 49): faila=  9(D)  failb= 49(D)  OK
> [    7.455318] raid6test: test_disks(9, 50): faila=  9(D)  failb= 50(D)  OK
> [    7.456753] raid6test: test_disks(9, 51): faila=  9(D)  failb= 51(D)  OK
> [    7.458173] raid6test: test_disks(9, 52): faila=  9(D)  failb= 52(D)  OK
> [    7.459631] raid6test: test_disks(9, 53): faila=  9(D)  failb= 53(D)  OK
> [    7.461051] raid6test: test_disks(9, 54): faila=  9(D)  failb= 54(D)  OK
> [    7.462479] raid6test: test_disks(9, 55): faila=  9(D)  failb= 55(D)  OK
> [    7.463927] raid6test: test_disks(9, 56): faila=  9(D)  failb= 56(D)  OK
> [    7.465346] raid6test: test_disks(9, 57): faila=  9(D)  failb= 57(D)  OK
> [    7.466771] raid6test: test_disks(9, 58): faila=  9(D)  failb= 58(D)  OK
> [    7.468218] raid6test: test_disks(9, 59): faila=  9(D)  failb= 59(D)  OK
> [    7.469647] raid6test: test_disks(9, 60): faila=  9(D)  failb= 60(D)  OK
> [    7.471089] raid6test: test_disks(9, 61): faila=  9(D)  failb= 61(D)  OK
> [    7.472522] raid6test: test_disks(9, 62): faila=  9(D)  failb= 62(P)  OK
> [    7.473928] raid6test: test_disks(9, 63): faila=  9(D)  failb= 63(Q)  OK
> [    7.475366] raid6test: test_disks(10, 11): faila= 10(D)  failb= 11(D)  OK
> [    7.476807] raid6test: test_disks(10, 12): faila= 10(D)  failb= 12(D)  OK
> [    7.478233] raid6test: test_disks(10, 13): faila= 10(D)  failb= 13(D)  OK
> [    7.479694] raid6test: test_disks(10, 14): faila= 10(D)  failb= 14(D)  OK
> [    7.481119] raid6test: test_disks(10, 15): faila= 10(D)  failb= 15(D)  OK
> [    7.482556] raid6test: test_disks(10, 16): faila= 10(D)  failb= 16(D)  OK
> [    7.484009] raid6test: test_disks(10, 17): faila= 10(D)  failb= 17(D)  OK
> [    7.485464] raid6test: test_disks(10, 18): faila= 10(D)  failb= 18(D)  OK
> [    7.486893] raid6test: test_disks(10, 19): faila= 10(D)  failb= 19(D)  OK
> [    7.488331] raid6test: test_disks(10, 20): faila= 10(D)  failb= 20(D)  OK
> [    7.489765] raid6test: test_disks(10, 21): faila= 10(D)  failb= 21(D)  OK
> [    7.491217] raid6test: test_disks(10, 22): faila= 10(D)  failb= 22(D)  OK
> [    7.492660] raid6test: test_disks(10, 23): faila= 10(D)  failb= 23(D)  OK
> [    7.494087] raid6test: test_disks(10, 24): faila= 10(D)  failb= 24(D)  OK
> [    7.495546] raid6test: test_disks(10, 25): faila= 10(D)  failb= 25(D)  OK
> [    7.496981] raid6test: test_disks(10, 26): faila= 10(D)  failb= 26(D)  OK
> [    7.498407] raid6test: test_disks(10, 27): faila= 10(D)  failb= 27(D)  OK
> [    7.499861] raid6test: test_disks(10, 28): faila= 10(D)  failb= 28(D)  OK
> [    7.501283] raid6test: test_disks(10, 29): faila= 10(D)  failb= 29(D)  OK
> [    7.502714] raid6test: test_disks(10, 30): faila= 10(D)  failb= 30(D)  OK
> [    7.504171] raid6test: test_disks(10, 31): faila= 10(D)  failb= 31(D)  OK
> [    7.505597] raid6test: test_disks(10, 32): faila= 10(D)  failb= 32(D)  OK
> [    7.507051] raid6test: test_disks(10, 33): faila= 10(D)  failb= 33(D)  OK
> [    7.508486] raid6test: test_disks(10, 34): faila= 10(D)  failb= 34(D)  OK
> [    7.509916] raid6test: test_disks(10, 35): faila= 10(D)  failb= 35(D)  OK
> [    7.511369] raid6test: test_disks(10, 36): faila= 10(D)  failb= 36(D)  OK
> [    7.512817] raid6test: test_disks(10, 37): faila= 10(D)  failb= 37(D)  OK
> [    7.514248] raid6test: test_disks(10, 38): faila= 10(D)  failb= 38(D)  OK
> [    7.515718] raid6test: test_disks(10, 39): faila= 10(D)  failb= 39(D)  OK
> [    7.518905] raid6test: test_disks(10, 40): faila= 10(D)  failb= 40(D)  OK
> [    7.520366] raid6test: test_disks(10, 41): faila= 10(D)  failb= 41(D)  OK
> [    7.521792] raid6test: test_disks(10, 42): faila= 10(D)  failb= 42(D)  OK
> [    7.523255] raid6test: test_disks(10, 43): faila= 10(D)  failb= 43(D)  OK
> [    7.524697] raid6test: test_disks(10, 44): faila= 10(D)  failb= 44(D)  OK
> [    7.526127] raid6test: test_disks(10, 45): faila= 10(D)  failb= 45(D)  OK
> [    7.527587] raid6test: test_disks(10, 46): faila= 10(D)  failb= 46(D)  OK
> [    7.529027] raid6test: test_disks(10, 47): faila= 10(D)  failb= 47(D)  OK
> [    7.530448] raid6test: test_disks(10, 48): faila= 10(D)  failb= 48(D)  OK
> [    7.531895] raid6test: test_disks(10, 49): faila= 10(D)  failb= 49(D)  OK
> [    7.533333] raid6test: test_disks(10, 50): faila= 10(D)  failb= 50(D)  OK
> [    7.534758] raid6test: test_disks(10, 51): faila= 10(D)  failb= 51(D)  OK
> [    7.536235] raid6test: test_disks(10, 52): faila= 10(D)  failb= 52(D)  OK
> [    7.537680] raid6test: test_disks(10, 53): faila= 10(D)  failb= 53(D)  OK
> [    7.539142] raid6test: test_disks(10, 54): faila= 10(D)  failb= 54(D)  OK
> [    7.540590] raid6test: test_disks(10, 55): faila= 10(D)  failb= 55(D)  OK
> [    7.542008] raid6test: test_disks(10, 56): faila= 10(D)  failb= 56(D)  OK
> [    7.543481] raid6test: test_disks(10, 57): faila= 10(D)  failb= 57(D)  OK
> [    7.544908] raid6test: test_disks(10, 58): faila= 10(D)  failb= 58(D)  OK
> [    7.546332] raid6test: test_disks(10, 59): faila= 10(D)  failb= 59(D)  OK
> [    7.547782] raid6test: test_disks(10, 60): faila= 10(D)  failb= 60(D)  OK
> [    7.549230] raid6test: test_disks(10, 61): faila= 10(D)  failb= 61(D)  OK
> [    7.550654] raid6test: test_disks(10, 62): faila= 10(D)  failb= 62(P)  OK
> [    7.552105] raid6test: test_disks(10, 63): faila= 10(D)  failb= 63(Q)  OK
> [    7.553548] raid6test: test_disks(11, 12): faila= 11(D)  failb= 12(D)  OK
> [    7.554981] raid6test: test_disks(11, 13): faila= 11(D)  failb= 13(D)  OK
> [    7.556428] raid6test: test_disks(11, 14): faila= 11(D)  failb= 14(D)  OK
> [    7.557852] raid6test: test_disks(11, 15): faila= 11(D)  failb= 15(D)  OK
> [    7.559303] raid6test: test_disks(11, 16): faila= 11(D)  failb= 16(D)  OK
> [    7.560733] raid6test: test_disks(11, 17): faila= 11(D)  failb= 17(D)  OK
> [    7.562149] raid6test: test_disks(11, 18): faila= 11(D)  failb= 18(D)  OK
> [    7.564016] raid6test: test_disks(11, 19): faila= 11(D)  failb= 19(D)  OK
> [    7.566346] raid6test: test_disks(11, 20): faila= 11(D)  failb= 20(D)  OK
> [    7.567825] raid6test: test_disks(11, 21): faila= 11(D)  failb= 21(D)  OK
> [    7.569262] raid6test: test_disks(11, 22): faila= 11(D)  failb= 22(D)  OK
> [    7.570688] raid6test: test_disks(11, 23): faila= 11(D)  failb= 23(D)  OK
> [    7.572108] raid6test: test_disks(11, 24): faila= 11(D)  failb= 24(D)  OK
> [    7.573548] raid6test: test_disks(11, 25): faila= 11(D)  failb= 25(D)  OK
> [    7.574971] raid6test: test_disks(11, 26): faila= 11(D)  failb= 26(D)  OK
> [    7.576404] raid6test: test_disks(11, 27): faila= 11(D)  failb= 27(D)  OK
> [    7.577824] raid6test: test_disks(11, 28): faila= 11(D)  failb= 28(D)  OK
> [    7.579255] raid6test: test_disks(11, 29): faila= 11(D)  failb= 29(D)  OK
> [    7.580676] raid6test: test_disks(11, 30): faila= 11(D)  failb= 30(D)  OK
> [    7.582094] raid6test: test_disks(11, 31): faila= 11(D)  failb= 31(D)  OK
> [    7.583533] raid6test: test_disks(11, 32): faila= 11(D)  failb= 32(D)  OK
> [    7.584952] raid6test: test_disks(11, 33): faila= 11(D)  failb= 33(D)  OK
> [    7.586379] raid6test: test_disks(11, 34): faila= 11(D)  failb= 34(D)  OK
> [    7.587804] raid6test: test_disks(11, 35): faila= 11(D)  failb= 35(D)  OK
> [    7.589241] raid6test: test_disks(11, 36): faila= 11(D)  failb= 36(D)  OK
> [    7.590671] raid6test: test_disks(11, 37): faila= 11(D)  failb= 37(D)  OK
> [    7.592088] raid6test: test_disks(11, 38): faila= 11(D)  failb= 38(D)  OK
> [    7.593527] raid6test: test_disks(11, 39): faila= 11(D)  failb= 39(D)  OK
> [    7.594953] raid6test: test_disks(11, 40): faila= 11(D)  failb= 40(D)  OK
> [    7.596384] raid6test: test_disks(11, 41): faila= 11(D)  failb= 41(D)  OK
> [    7.597805] raid6test: test_disks(11, 42): faila= 11(D)  failb= 42(D)  OK
> [    7.599244] raid6test: test_disks(11, 43): faila= 11(D)  failb= 43(D)  OK
> [    7.600675] raid6test: test_disks(11, 44): faila= 11(D)  failb= 44(D)  OK
> [    7.602094] raid6test: test_disks(11, 45): faila= 11(D)  failb= 45(D)  OK
> [    7.603530] raid6test: test_disks(11, 46): faila= 11(D)  failb= 46(D)  OK
> [    7.604951] raid6test: test_disks(11, 47): faila= 11(D)  failb= 47(D)  OK
> [    7.606386] raid6test: test_disks(11, 48): faila= 11(D)  failb= 48(D)  OK
> [    7.607816] raid6test: test_disks(11, 49): faila= 11(D)  failb= 49(D)  OK
> [    7.609255] raid6test: test_disks(11, 50): faila= 11(D)  failb= 50(D)  OK
> [    7.610682] raid6test: test_disks(11, 51): faila= 11(D)  failb= 51(D)  OK
> [    7.612117] raid6test: test_disks(11, 52): faila= 11(D)  failb= 52(D)  OK
> [    7.613558] raid6test: test_disks(11, 53): faila= 11(D)  failb= 53(D)  OK
> [    7.614982] raid6test: test_disks(11, 54): faila= 11(D)  failb= 54(D)  OK
> [    7.616419] raid6test: test_disks(11, 55): faila= 11(D)  failb= 55(D)  OK
> [    7.617843] raid6test: test_disks(11, 56): faila= 11(D)  failb= 56(D)  OK
> [    7.619276] raid6test: test_disks(11, 57): faila= 11(D)  failb= 57(D)  OK
> [    7.620707] raid6test: test_disks(11, 58): faila= 11(D)  failb= 58(D)  OK
> [    7.622127] raid6test: test_disks(11, 59): faila= 11(D)  failb= 59(D)  OK
> [    7.623560] raid6test: test_disks(11, 60): faila= 11(D)  failb= 60(D)  OK
> [    7.624986] raid6test: test_disks(11, 61): faila= 11(D)  failb= 61(D)  OK
> [    7.626421] raid6test: test_disks(11, 62): faila= 11(D)  failb= 62(P)  OK
> [    7.627842] raid6test: test_disks(11, 63): faila= 11(D)  failb= 63(Q)  OK
> [    7.629282] raid6test: test_disks(12, 13): faila= 12(D)  failb= 13(D)  OK
> [    7.630713] raid6test: test_disks(12, 14): faila= 12(D)  failb= 14(D)  OK
> [    7.632141] raid6test: test_disks(12, 15): faila= 12(D)  failb= 15(D)  OK
> [    7.633574] raid6test: test_disks(12, 16): faila= 12(D)  failb= 16(D)  OK
> [    7.634992] raid6test: test_disks(12, 17): faila= 12(D)  failb= 17(D)  OK
> [    7.636432] raid6test: test_disks(12, 18): faila= 12(D)  failb= 18(D)  OK
> [    7.637854] raid6test: test_disks(12, 19): faila= 12(D)  failb= 19(D)  OK
> [    7.639292] raid6test: test_disks(12, 20): faila= 12(D)  failb= 20(D)  OK
> [    7.640721] raid6test: test_disks(12, 21): faila= 12(D)  failb= 21(D)  OK
> [    7.642137] raid6test: test_disks(12, 22): faila= 12(D)  failb= 22(D)  OK
> [    7.643578] raid6test: test_disks(12, 23): faila= 12(D)  failb= 23(D)  OK
> [    7.645007] raid6test: test_disks(12, 24): faila= 12(D)  failb= 24(D)  OK
> [    7.646443] raid6test: test_disks(12, 25): faila= 12(D)  failb= 25(D)  OK
> [    7.647861] raid6test: test_disks(12, 26): faila= 12(D)  failb= 26(D)  OK
> [    7.649287] raid6test: test_disks(12, 27): faila= 12(D)  failb= 27(D)  OK
> [    7.650717] raid6test: test_disks(12, 28): faila= 12(D)  failb= 28(D)  OK
> [    7.652137] raid6test: test_disks(12, 29): faila= 12(D)  failb= 29(D)  OK
> [    7.653579] raid6test: test_disks(12, 30): faila= 12(D)  failb= 30(D)  OK
> [    7.655005] raid6test: test_disks(12, 31): faila= 12(D)  failb= 31(D)  OK
> [    7.656442] raid6test: test_disks(12, 32): faila= 12(D)  failb= 32(D)  OK
> [    7.657864] raid6test: test_disks(12, 33): faila= 12(D)  failb= 33(D)  OK
> [    7.659296] raid6test: test_disks(12, 34): faila= 12(D)  failb= 34(D)  OK
> [    7.660709] raid6test: test_disks(12, 35): faila= 12(D)  failb= 35(D)  OK
> [    7.662130] raid6test: test_disks(12, 36): faila= 12(D)  failb= 36(D)  OK
> [    7.663562] raid6test: test_disks(12, 37): faila= 12(D)  failb= 37(D)  OK
> [    7.664983] raid6test: test_disks(12, 38): faila= 12(D)  failb= 38(D)  OK
> [    7.666420] raid6test: test_disks(12, 39): faila= 12(D)  failb= 39(D)  OK
> [    7.667838] raid6test: test_disks(12, 40): faila= 12(D)  failb= 40(D)  OK
> [    7.669266] raid6test: test_disks(12, 41): faila= 12(D)  failb= 41(D)  OK
> [    7.670695] raid6test: test_disks(12, 42): faila= 12(D)  failb= 42(D)  OK
> [    7.672110] raid6test: test_disks(12, 43): faila= 12(D)  failb= 43(D)  OK
> [    7.673552] raid6test: test_disks(12, 44): faila= 12(D)  failb= 44(D)  OK
> [    7.674975] raid6test: test_disks(12, 45): faila= 12(D)  failb= 45(D)  OK
> [    7.676414] raid6test: test_disks(12, 46): faila= 12(D)  failb= 46(D)  OK
> [    7.677839] raid6test: test_disks(12, 47): faila= 12(D)  failb= 47(D)  OK
> [    7.679267] raid6test: test_disks(12, 48): faila= 12(D)  failb= 48(D)  OK
> [    7.680693] raid6test: test_disks(12, 49): faila= 12(D)  failb= 49(D)  OK
> [    7.682115] raid6test: test_disks(12, 50): faila= 12(D)  failb= 50(D)  OK
> [    7.683555] raid6test: test_disks(12, 51): faila= 12(D)  failb= 51(D)  OK
> [    7.684974] raid6test: test_disks(12, 52): faila= 12(D)  failb= 52(D)  OK
> [    7.686409] raid6test: test_disks(12, 53): faila= 12(D)  failb= 53(D)  OK
> [    7.687825] raid6test: test_disks(12, 54): faila= 12(D)  failb= 54(D)  OK
> [    7.689251] raid6test: test_disks(12, 55): faila= 12(D)  failb= 55(D)  OK
> [    7.690672] raid6test: test_disks(12, 56): faila= 12(D)  failb= 56(D)  OK
> [    7.692092] raid6test: test_disks(12, 57): faila= 12(D)  failb= 57(D)  OK
> [    7.693529] raid6test: test_disks(12, 58): faila= 12(D)  failb= 58(D)  OK
> [    7.694952] raid6test: test_disks(12, 59): faila= 12(D)  failb= 59(D)  OK
> [    7.696381] raid6test: test_disks(12, 60): faila= 12(D)  failb= 60(D)  OK
> [    7.697802] raid6test: test_disks(12, 61): faila= 12(D)  failb= 61(D)  OK
> [    7.699232] raid6test: test_disks(12, 62): faila= 12(D)  failb= 62(P)  OK
> [    7.700657] raid6test: test_disks(12, 63): faila= 12(D)  failb= 63(Q)  OK
> [    7.702082] raid6test: test_disks(13, 14): faila= 13(D)  failb= 14(D)  OK
> [    7.703524] raid6test: test_disks(13, 15): faila= 13(D)  failb= 15(D)  OK
> [    7.704943] raid6test: test_disks(13, 16): faila= 13(D)  failb= 16(D)  OK
> [    7.706370] raid6test: test_disks(13, 17): faila= 13(D)  failb= 17(D)  OK
> [    7.707800] raid6test: test_disks(13, 18): faila= 13(D)  failb= 18(D)  OK
> [    7.709231] raid6test: test_disks(13, 19): faila= 13(D)  failb= 19(D)  OK
> [    7.710655] raid6test: test_disks(13, 20): faila= 13(D)  failb= 20(D)  OK
> [    7.712079] raid6test: test_disks(13, 21): faila= 13(D)  failb= 21(D)  OK
> [    7.713513] raid6test: test_disks(13, 22): faila= 13(D)  failb= 22(D)  OK
> [    7.714935] raid6test: test_disks(13, 23): faila= 13(D)  failb= 23(D)  OK
> [    7.716361] raid6test: test_disks(13, 24): faila= 13(D)  failb= 24(D)  OK
> [    7.717786] raid6test: test_disks(13, 25): faila= 13(D)  failb= 25(D)  OK
> [    7.719218] raid6test: test_disks(13, 26): faila= 13(D)  failb= 26(D)  OK
> [    7.720647] raid6test: test_disks(13, 27): faila= 13(D)  failb= 27(D)  OK
> [    7.722069] raid6test: test_disks(13, 28): faila= 13(D)  failb= 28(D)  OK
> [    7.723506] raid6test: test_disks(13, 29): faila= 13(D)  failb= 29(D)  OK
> [    7.724928] raid6test: test_disks(13, 30): faila= 13(D)  failb= 30(D)  OK
> [    7.726354] raid6test: test_disks(13, 31): faila= 13(D)  failb= 31(D)  OK
> [    7.727780] raid6test: test_disks(13, 32): faila= 13(D)  failb= 32(D)  OK
> [    7.729220] raid6test: test_disks(13, 33): faila= 13(D)  failb= 33(D)  OK
> [    7.730645] raid6test: test_disks(13, 34): faila= 13(D)  failb= 34(D)  OK
> [    7.732070] raid6test: test_disks(13, 35): faila= 13(D)  failb= 35(D)  OK
> [    7.733511] raid6test: test_disks(13, 36): faila= 13(D)  failb= 36(D)  OK
> [    7.734934] raid6test: test_disks(13, 37): faila= 13(D)  failb= 37(D)  OK
> [    7.736366] raid6test: test_disks(13, 38): faila= 13(D)  failb= 38(D)  OK
> [    7.737789] raid6test: test_disks(13, 39): faila= 13(D)  failb= 39(D)  OK
> [    7.739220] raid6test: test_disks(13, 40): faila= 13(D)  failb= 40(D)  OK
> [    7.740650] raid6test: test_disks(13, 41): faila= 13(D)  failb= 41(D)  OK
> [    7.742073] raid6test: test_disks(13, 42): faila= 13(D)  failb= 42(D)  OK
> [    7.743509] raid6test: test_disks(13, 43): faila= 13(D)  failb= 43(D)  OK
> [    7.744930] raid6test: test_disks(13, 44): faila= 13(D)  failb= 44(D)  OK
> [    7.746356] raid6test: test_disks(13, 45): faila= 13(D)  failb= 45(D)  OK
> [    7.747781] raid6test: test_disks(13, 46): faila= 13(D)  failb= 46(D)  OK
> [    7.749217] raid6test: test_disks(13, 47): faila= 13(D)  failb= 47(D)  OK
> [    7.750652] raid6test: test_disks(13, 48): faila= 13(D)  failb= 48(D)  OK
> [    7.752074] raid6test: test_disks(13, 49): faila= 13(D)  failb= 49(D)  OK
> [    7.753512] raid6test: test_disks(13, 50): faila= 13(D)  failb= 50(D)  OK
> [    7.754931] raid6test: test_disks(13, 51): faila= 13(D)  failb= 51(D)  OK
> [    7.756358] raid6test: test_disks(13, 52): faila= 13(D)  failb= 52(D)  OK
> [    7.757784] raid6test: test_disks(13, 53): faila= 13(D)  failb= 53(D)  OK
> [    7.759217] raid6test: test_disks(13, 54): faila= 13(D)  failb= 54(D)  OK
> [    7.760644] raid6test: test_disks(13, 55): faila= 13(D)  failb= 55(D)  OK
> [    7.762068] raid6test: test_disks(13, 56): faila= 13(D)  failb= 56(D)  OK
> [    7.763501] raid6test: test_disks(13, 57): faila= 13(D)  failb= 57(D)  OK
> [    7.764932] raid6test: test_disks(13, 58): faila= 13(D)  failb= 58(D)  OK
> [    7.766363] raid6test: test_disks(13, 59): faila= 13(D)  failb= 59(D)  OK
> [    7.767788] raid6test: test_disks(13, 60): faila= 13(D)  failb= 60(D)  OK
> [    7.769217] raid6test: test_disks(13, 61): faila= 13(D)  failb= 61(D)  OK
> [    7.770641] raid6test: test_disks(13, 62): faila= 13(D)  failb= 62(P)  OK
> [    7.772055] raid6test: test_disks(13, 63): faila= 13(D)  failb= 63(Q)  OK
> [    7.773488] raid6test: test_disks(14, 15): faila= 14(D)  failb= 15(D)  OK
> [    7.774909] raid6test: test_disks(14, 16): faila= 14(D)  failb= 16(D)  OK
> [    7.776342] raid6test: test_disks(14, 17): faila= 14(D)  failb= 17(D)  OK
> [    7.779517] raid6test: test_disks(14, 18): faila= 14(D)  failb= 18(D)  OK
> [    7.780934] raid6test: test_disks(14, 19): faila= 14(D)  failb= 19(D)  OK
> [    7.782369] raid6test: test_disks(14, 20): faila= 14(D)  failb= 20(D)  OK
> [    7.783799] raid6test: test_disks(14, 21): faila= 14(D)  failb= 21(D)  OK
> [    7.785218] raid6test: test_disks(14, 22): faila= 14(D)  failb= 22(D)  OK
> [    7.786656] raid6test: test_disks(14, 23): faila= 14(D)  failb= 23(D)  OK
> [    7.788081] raid6test: test_disks(14, 24): faila= 14(D)  failb= 24(D)  OK
> [    7.789515] raid6test: test_disks(14, 25): faila= 14(D)  failb= 25(D)  OK
> [    7.790941] raid6test: test_disks(14, 26): faila= 14(D)  failb= 26(D)  OK
> [    7.792374] raid6test: test_disks(14, 27): faila= 14(D)  failb= 27(D)  OK
> [    7.793798] raid6test: test_disks(14, 28): faila= 14(D)  failb= 28(D)  OK
> [    7.795219] raid6test: test_disks(14, 29): faila= 14(D)  failb= 29(D)  OK
> [    7.796653] raid6test: test_disks(14, 30): faila= 14(D)  failb= 30(D)  OK
> [    7.798082] raid6test: test_disks(14, 31): faila= 14(D)  failb= 31(D)  OK
> [    7.799519] raid6test: test_disks(14, 32): faila= 14(D)  failb= 32(D)  OK
> [    7.800938] raid6test: test_disks(14, 33): faila= 14(D)  failb= 33(D)  OK
> [    7.802370] raid6test: test_disks(14, 34): faila= 14(D)  failb= 34(D)  OK
> [    7.803796] raid6test: test_disks(14, 35): faila= 14(D)  failb= 35(D)  OK
> [    7.805218] raid6test: test_disks(14, 36): faila= 14(D)  failb= 36(D)  OK
> [    7.806649] raid6test: test_disks(14, 37): faila= 14(D)  failb= 37(D)  OK
> [    7.808073] raid6test: test_disks(14, 38): faila= 14(D)  failb= 38(D)  OK
> [    7.809509] raid6test: test_disks(14, 39): faila= 14(D)  failb= 39(D)  OK
> [    7.810929] raid6test: test_disks(14, 40): faila= 14(D)  failb= 40(D)  OK
> [    7.812362] raid6test: test_disks(14, 41): faila= 14(D)  failb= 41(D)  OK
> [    7.813789] raid6test: test_disks(14, 42): faila= 14(D)  failb= 42(D)  OK
> [    7.815203] raid6test: test_disks(14, 43): faila= 14(D)  failb= 43(D)  OK
> [    7.816631] raid6test: test_disks(14, 44): faila= 14(D)  failb= 44(D)  OK
> [    7.818057] raid6test: test_disks(14, 45): faila= 14(D)  failb= 45(D)  OK
> [    7.819495] raid6test: test_disks(14, 46): faila= 14(D)  failb= 46(D)  OK
> [    7.820916] raid6test: test_disks(14, 47): faila= 14(D)  failb= 47(D)  OK
> [    7.822344] raid6test: test_disks(14, 48): faila= 14(D)  failb= 48(D)  OK
> [    7.823770] raid6test: test_disks(14, 49): faila= 14(D)  failb= 49(D)  OK
> [    7.825185] raid6test: test_disks(14, 50): faila= 14(D)  failb= 50(D)  OK
> [    7.826615] raid6test: test_disks(14, 51): faila= 14(D)  failb= 51(D)  OK
> [    7.828043] raid6test: test_disks(14, 52): faila= 14(D)  failb= 52(D)  OK
> [    7.829478] raid6test: test_disks(14, 53): faila= 14(D)  failb= 53(D)  OK
> [    7.830896] raid6test: test_disks(14, 54): faila= 14(D)  failb= 54(D)  OK
> [    7.832311] raid6test: test_disks(14, 55): faila= 14(D)  failb= 55(D)  OK
> [    7.833745] raid6test: test_disks(14, 56): faila= 14(D)  failb= 56(D)  OK
> [    7.835156] raid6test: test_disks(14, 57): faila= 14(D)  failb= 57(D)  OK
> [    7.836592] raid6test: test_disks(14, 58): faila= 14(D)  failb= 58(D)  OK
> [    7.838012] raid6test: test_disks(14, 59): faila= 14(D)  failb= 59(D)  OK
> [    7.839446] raid6test: test_disks(14, 60): faila= 14(D)  failb= 60(D)  OK
> [    7.840857] raid6test: test_disks(14, 61): faila= 14(D)  failb= 61(D)  OK
> [    7.842266] raid6test: test_disks(14, 62): faila= 14(D)  failb= 62(P)  OK
> [    7.843696] raid6test: test_disks(14, 63): faila= 14(D)  failb= 63(Q)  OK
> [    7.845121] raid6test: test_disks(15, 16): faila= 15(D)  failb= 16(D)  OK
> [    7.846556] raid6test: test_disks(15, 17): faila= 15(D)  failb= 17(D)  OK
> [    7.847982] raid6test: test_disks(15, 18): faila= 15(D)  failb= 18(D)  OK
> [    7.849417] raid6test: test_disks(15, 19): faila= 15(D)  failb= 19(D)  OK
> [    7.850839] raid6test: test_disks(15, 20): faila= 15(D)  failb= 20(D)  OK
> [    7.852259] raid6test: test_disks(15, 21): faila= 15(D)  failb= 21(D)  OK
> [    7.853696] raid6test: test_disks(15, 22): faila= 15(D)  failb= 22(D)  OK
> [    7.855121] raid6test: test_disks(15, 23): faila= 15(D)  failb= 23(D)  OK
> [    7.856548] raid6test: test_disks(15, 24): faila= 15(D)  failb= 24(D)  OK
> [    7.857963] raid6test: test_disks(15, 25): faila= 15(D)  failb= 25(D)  OK
> [    7.859395] raid6test: test_disks(15, 26): faila= 15(D)  failb= 26(D)  OK
> [    7.860818] raid6test: test_disks(15, 27): faila= 15(D)  failb= 27(D)  OK
> [    7.862236] raid6test: test_disks(15, 28): faila= 15(D)  failb= 28(D)  OK
> [    7.863669] raid6test: test_disks(15, 29): faila= 15(D)  failb= 29(D)  OK
> [    7.865088] raid6test: test_disks(15, 30): faila= 15(D)  failb= 30(D)  OK
> [    7.866521] raid6test: test_disks(15, 31): faila= 15(D)  failb= 31(D)  OK
> [    7.867940] raid6test: test_disks(15, 32): faila= 15(D)  failb= 32(D)  OK
> [    7.869362] raid6test: test_disks(15, 33): faila= 15(D)  failb= 33(D)  OK
> [    7.870788] raid6test: test_disks(15, 34): faila= 15(D)  failb= 34(D)  OK
> [    7.872206] raid6test: test_disks(15, 35): faila= 15(D)  failb= 35(D)  OK
> [    7.873637] raid6test: test_disks(15, 36): faila= 15(D)  failb= 36(D)  OK
> [    7.875050] raid6test: test_disks(15, 37): faila= 15(D)  failb= 37(D)  OK
> [    7.876484] raid6test: test_disks(15, 38): faila= 15(D)  failb= 38(D)  OK
> [    7.877906] raid6test: test_disks(15, 39): faila= 15(D)  failb= 39(D)  OK
> [    7.879332] raid6test: test_disks(15, 40): faila= 15(D)  failb= 40(D)  OK
> [    7.880755] raid6test: test_disks(15, 41): faila= 15(D)  failb= 41(D)  OK
> [    7.882172] raid6test: test_disks(15, 42): faila= 15(D)  failb= 42(D)  OK
> [    7.883608] raid6test: test_disks(15, 43): faila= 15(D)  failb= 43(D)  OK
> [    7.885025] raid6test: test_disks(15, 44): faila= 15(D)  failb= 44(D)  OK
> [    7.886455] raid6test: test_disks(15, 45): faila= 15(D)  failb= 45(D)  OK
> [    7.887883] raid6test: test_disks(15, 46): faila= 15(D)  failb= 46(D)  OK
> [    7.889319] raid6test: test_disks(15, 47): faila= 15(D)  failb= 47(D)  OK
> [    7.890742] raid6test: test_disks(15, 48): faila= 15(D)  failb= 48(D)  OK
> [    7.892165] raid6test: test_disks(15, 49): faila= 15(D)  failb= 49(D)  OK
> [    7.893606] raid6test: test_disks(15, 50): faila= 15(D)  failb= 50(D)  OK
> [    7.895029] raid6test: test_disks(15, 51): faila= 15(D)  failb= 51(D)  OK
> [    7.896465] raid6test: test_disks(15, 52): faila= 15(D)  failb= 52(D)  OK
> [    7.897880] raid6test: test_disks(15, 53): faila= 15(D)  failb= 53(D)  OK
> [    7.899306] raid6test: test_disks(15, 54): faila= 15(D)  failb= 54(D)  OK
> [    7.900732] raid6test: test_disks(15, 55): faila= 15(D)  failb= 55(D)  OK
> [    7.902151] raid6test: test_disks(15, 56): faila= 15(D)  failb= 56(D)  OK
> [    7.903586] raid6test: test_disks(15, 57): faila= 15(D)  failb= 57(D)  OK
> [    7.905011] raid6test: test_disks(15, 58): faila= 15(D)  failb= 58(D)  OK
> [    7.906451] raid6test: test_disks(15, 59): faila= 15(D)  failb= 59(D)  OK
> [    7.907877] raid6test: test_disks(15, 60): faila= 15(D)  failb= 60(D)  OK
> [    7.909311] raid6test: test_disks(15, 61): faila= 15(D)  failb= 61(D)  OK
> [    7.910724] raid6test: test_disks(15, 62): faila= 15(D)  failb= 62(P)  OK
> [    7.912136] raid6test: test_disks(15, 63): faila= 15(D)  failb= 63(Q)  OK
> [    7.913577] raid6test: test_disks(16, 17): faila= 16(D)  failb= 17(D)  OK
> [    7.914994] raid6test: test_disks(16, 18): faila= 16(D)  failb= 18(D)  OK
> [    7.916434] raid6test: test_disks(16, 19): faila= 16(D)  failb= 19(D)  OK
> [    7.917856] raid6test: test_disks(16, 20): faila= 16(D)  failb= 20(D)  OK
> [    7.919285] raid6test: test_disks(16, 21): faila= 16(D)  failb= 21(D)  OK
> [    7.920718] raid6test: test_disks(16, 22): faila= 16(D)  failb= 22(D)  OK
> [    7.922134] raid6test: test_disks(16, 23): faila= 16(D)  failb= 23(D)  OK
> [    7.923568] raid6test: test_disks(16, 24): faila= 16(D)  failb= 24(D)  OK
> [    7.924990] raid6test: test_disks(16, 25): faila= 16(D)  failb= 25(D)  OK
> [    7.926428] raid6test: test_disks(16, 26): faila= 16(D)  failb= 26(D)  OK
> [    7.927850] raid6test: test_disks(16, 27): faila= 16(D)  failb= 27(D)  OK
> [    7.929284] raid6test: test_disks(16, 28): faila= 16(D)  failb= 28(D)  OK
> [    7.930716] raid6test: test_disks(16, 29): faila= 16(D)  failb= 29(D)  OK
> [    7.932135] raid6test: test_disks(16, 30): faila= 16(D)  failb= 30(D)  OK
> [    7.933570] raid6test: test_disks(16, 31): faila= 16(D)  failb= 31(D)  OK
> [    7.934990] raid6test: test_disks(16, 32): faila= 16(D)  failb= 32(D)  OK
> [    7.936429] raid6test: test_disks(16, 33): faila= 16(D)  failb= 33(D)  OK
> [    7.937837] raid6test: test_disks(16, 34): faila= 16(D)  failb= 34(D)  OK
> [    7.939266] raid6test: test_disks(16, 35): faila= 16(D)  failb= 35(D)  OK
> [    7.940695] raid6test: test_disks(16, 36): faila= 16(D)  failb= 36(D)  OK
> [    7.942113] raid6test: test_disks(16, 37): faila= 16(D)  failb= 37(D)  OK
> [    7.943555] raid6test: test_disks(16, 38): faila= 16(D)  failb= 38(D)  OK
> [    7.944975] raid6test: test_disks(16, 39): faila= 16(D)  failb= 39(D)  OK
> [    7.946407] raid6test: test_disks(16, 40): faila= 16(D)  failb= 40(D)  OK
> [    7.947831] raid6test: test_disks(16, 41): faila= 16(D)  failb= 41(D)  OK
> [    7.949263] raid6test: test_disks(16, 42): faila= 16(D)  failb= 42(D)  OK
> [    7.950696] raid6test: test_disks(16, 43): faila= 16(D)  failb= 43(D)  OK
> [    7.952112] raid6test: test_disks(16, 44): faila= 16(D)  failb= 44(D)  OK
> [    7.953547] raid6test: test_disks(16, 45): faila= 16(D)  failb= 45(D)  OK
> [    7.954972] raid6test: test_disks(16, 46): faila= 16(D)  failb= 46(D)  OK
> [    7.956410] raid6test: test_disks(16, 47): faila= 16(D)  failb= 47(D)  OK
> [    7.957832] raid6test: test_disks(16, 48): faila= 16(D)  failb= 48(D)  OK
> [    7.959261] raid6test: test_disks(16, 49): faila= 16(D)  failb= 49(D)  OK
> [    7.960688] raid6test: test_disks(16, 50): faila= 16(D)  failb= 50(D)  OK
> [    7.962107] raid6test: test_disks(16, 51): faila= 16(D)  failb= 51(D)  OK
> [    7.963544] raid6test: test_disks(16, 52): faila= 16(D)  failb= 52(D)  OK
> [    7.964962] raid6test: test_disks(16, 53): faila= 16(D)  failb= 53(D)  OK
> [    7.966387] raid6test: test_disks(16, 54): faila= 16(D)  failb= 54(D)  OK
> [    7.967813] raid6test: test_disks(16, 55): faila= 16(D)  failb= 55(D)  OK
> [    7.969246] raid6test: test_disks(16, 56): faila= 16(D)  failb= 56(D)  OK
> [    7.970671] raid6test: test_disks(16, 57): faila= 16(D)  failb= 57(D)  OK
> [    7.972087] raid6test: test_disks(16, 58): faila= 16(D)  failb= 58(D)  OK
> [    7.973522] raid6test: test_disks(16, 59): faila= 16(D)  failb= 59(D)  OK
> [    7.974942] raid6test: test_disks(16, 60): faila= 16(D)  failb= 60(D)  OK
> [    7.976368] raid6test: test_disks(16, 61): faila= 16(D)  failb= 61(D)  OK
> [    7.977799] raid6test: test_disks(16, 62): faila= 16(D)  failb= 62(P)  OK
> [    7.979229] raid6test: test_disks(16, 63): faila= 16(D)  failb= 63(Q)  OK
> [    7.980655] raid6test: test_disks(17, 18): faila= 17(D)  failb= 18(D)  OK
> [    7.982076] raid6test: test_disks(17, 19): faila= 17(D)  failb= 19(D)  OK
> [    7.983512] raid6test: test_disks(17, 20): faila= 17(D)  failb= 20(D)  OK
> [    7.984959] raid6test: test_disks(17, 21): faila= 17(D)  failb= 21(D)  OK
> [    7.986390] raid6test: test_disks(17, 22): faila= 17(D)  failb= 22(D)  OK
> [    7.987812] raid6test: test_disks(17, 23): faila= 17(D)  failb= 23(D)  OK
> [    7.989248] raid6test: test_disks(17, 24): faila= 17(D)  failb= 24(D)  OK
> [    7.990663] raid6test: test_disks(17, 25): faila= 17(D)  failb= 25(D)  OK
> [    7.992084] raid6test: test_disks(17, 26): faila= 17(D)  failb= 26(D)  OK
> [    7.993519] raid6test: test_disks(17, 27): faila= 17(D)  failb= 27(D)  OK
> [    7.994940] raid6test: test_disks(17, 28): faila= 17(D)  failb= 28(D)  OK
> [    7.996367] raid6test: test_disks(17, 29): faila= 17(D)  failb= 29(D)  OK
> [    7.997774] raid6test: test_disks(17, 30): faila= 17(D)  failb= 30(D)  OK
> [    7.999208] raid6test: test_disks(17, 31): faila= 17(D)  failb= 31(D)  OK
> [    8.000641] raid6test: test_disks(17, 32): faila= 17(D)  failb= 32(D)  OK
> [    8.002059] raid6test: test_disks(17, 33): faila= 17(D)  failb= 33(D)  OK
> [    8.003497] raid6test: test_disks(17, 34): faila= 17(D)  failb= 34(D)  OK
> [    8.004914] raid6test: test_disks(17, 35): faila= 17(D)  failb= 35(D)  OK
> [    8.006351] raid6test: test_disks(17, 36): faila= 17(D)  failb= 36(D)  OK
> [    8.007774] raid6test: test_disks(17, 37): faila= 17(D)  failb= 37(D)  OK
> [    8.009210] raid6test: test_disks(17, 38): faila= 17(D)  failb= 38(D)  OK
> [    8.010639] raid6test: test_disks(17, 39): faila= 17(D)  failb= 39(D)  OK
> [    8.012060] raid6test: test_disks(17, 40): faila= 17(D)  failb= 40(D)  OK
> [    8.013492] raid6test: test_disks(17, 41): faila= 17(D)  failb= 41(D)  OK
> [    8.014903] raid6test: test_disks(17, 42): faila= 17(D)  failb= 42(D)  OK
> [    8.016330] raid6test: test_disks(17, 43): faila= 17(D)  failb= 43(D)  OK
> [    8.017759] raid6test: test_disks(17, 44): faila= 17(D)  failb= 44(D)  OK
> [    8.019196] raid6test: test_disks(17, 45): faila= 17(D)  failb= 45(D)  OK
> [    8.020624] raid6test: test_disks(17, 46): faila= 17(D)  failb= 46(D)  OK
> [    8.022041] raid6test: test_disks(17, 47): faila= 17(D)  failb= 47(D)  OK
> [    8.023472] raid6test: test_disks(17, 48): faila= 17(D)  failb= 48(D)  OK
> [    8.024888] raid6test: test_disks(17, 49): faila= 17(D)  failb= 49(D)  OK
> [    8.026313] raid6test: test_disks(17, 50): faila= 17(D)  failb= 50(D)  OK
> [    8.027733] raid6test: test_disks(17, 51): faila= 17(D)  failb= 51(D)  OK
> [    8.029169] raid6test: test_disks(17, 52): faila= 17(D)  failb= 52(D)  OK
> [    8.030594] raid6test: test_disks(17, 53): faila= 17(D)  failb= 53(D)  OK
> [    8.032013] raid6test: test_disks(17, 54): faila= 17(D)  failb= 54(D)  OK
> [    8.033447] raid6test: test_disks(17, 55): faila= 17(D)  failb= 55(D)  OK
> [    8.034866] raid6test: test_disks(17, 56): faila= 17(D)  failb= 56(D)  OK
> [    8.038041] raid6test: test_disks(17, 57): faila= 17(D)  failb= 57(D)  OK
> [    8.039475] raid6test: test_disks(17, 58): faila= 17(D)  failb= 58(D)  OK
> [    8.040901] raid6test: test_disks(17, 59): faila= 17(D)  failb= 59(D)  OK
> [    8.042307] raid6test: test_disks(17, 60): faila= 17(D)  failb= 60(D)  OK
> [    8.043739] raid6test: test_disks(17, 61): faila= 17(D)  failb= 61(D)  OK
> [    8.045148] raid6test: test_disks(17, 62): faila= 17(D)  failb= 62(P)  OK
> [    8.046572] raid6test: test_disks(17, 63): faila= 17(D)  failb= 63(Q)  OK
> [    8.047997] raid6test: test_disks(18, 19): faila= 18(D)  failb= 19(D)  OK
> [    8.049428] raid6test: test_disks(18, 20): faila= 18(D)  failb= 20(D)  OK
> [    8.050850] raid6test: test_disks(18, 21): faila= 18(D)  failb= 21(D)  OK
> [    8.052275] raid6test: test_disks(18, 22): faila= 18(D)  failb= 22(D)  OK
> [    8.053708] raid6test: test_disks(18, 23): faila= 18(D)  failb= 23(D)  OK
> [    8.055122] raid6test: test_disks(18, 24): faila= 18(D)  failb= 24(D)  OK
> [    8.056555] raid6test: test_disks(18, 25): faila= 18(D)  failb= 25(D)  OK
> [    8.057977] raid6test: test_disks(18, 26): faila= 18(D)  failb= 26(D)  OK
> [    8.059407] raid6test: test_disks(18, 27): faila= 18(D)  failb= 27(D)  OK
> [    8.060821] raid6test: test_disks(18, 28): faila= 18(D)  failb= 28(D)  OK
> [    8.062232] raid6test: test_disks(18, 29): faila= 18(D)  failb= 29(D)  OK
> [    8.063668] raid6test: test_disks(18, 30): faila= 18(D)  failb= 30(D)  OK
> [    8.065085] raid6test: test_disks(18, 31): faila= 18(D)  failb= 31(D)  OK
> [    8.066521] raid6test: test_disks(18, 32): faila= 18(D)  failb= 32(D)  OK
> [    8.067940] raid6test: test_disks(18, 33): faila= 18(D)  failb= 33(D)  OK
> [    8.069360] raid6test: test_disks(18, 34): faila= 18(D)  failb= 34(D)  OK
> [    8.070785] raid6test: test_disks(18, 35): faila= 18(D)  failb= 35(D)  OK
> [    8.072203] raid6test: test_disks(18, 36): faila= 18(D)  failb= 36(D)  OK
> [    8.073636] raid6test: test_disks(18, 37): faila= 18(D)  failb= 37(D)  OK
> [    8.075052] raid6test: test_disks(18, 38): faila= 18(D)  failb= 38(D)  OK
> [    8.076484] raid6test: test_disks(18, 39): faila= 18(D)  failb= 39(D)  OK
> [    8.077903] raid6test: test_disks(18, 40): faila= 18(D)  failb= 40(D)  OK
> [    8.079329] raid6test: test_disks(18, 41): faila= 18(D)  failb= 41(D)  OK
> [    8.080752] raid6test: test_disks(18, 42): faila= 18(D)  failb= 42(D)  OK
> [    8.082175] raid6test: test_disks(18, 43): faila= 18(D)  failb= 43(D)  OK
> [    8.083617] raid6test: test_disks(18, 44): faila= 18(D)  failb= 44(D)  OK
> [    8.085046] raid6test: test_disks(18, 45): faila= 18(D)  failb= 45(D)  OK
> [    8.086481] raid6test: test_disks(18, 46): faila= 18(D)  failb= 46(D)  OK
> [    8.087895] raid6test: test_disks(18, 47): faila= 18(D)  failb= 47(D)  OK
> [    8.089324] raid6test: test_disks(18, 48): faila= 18(D)  failb= 48(D)  OK
> [    8.090748] raid6test: test_disks(18, 49): faila= 18(D)  failb= 49(D)  OK
> [    8.092167] raid6test: test_disks(18, 50): faila= 18(D)  failb= 50(D)  OK
> [    8.093607] raid6test: test_disks(18, 51): faila= 18(D)  failb= 51(D)  OK
> [    8.095029] raid6test: test_disks(18, 52): faila= 18(D)  failb= 52(D)  OK
> [    8.096464] raid6test: test_disks(18, 53): faila= 18(D)  failb= 53(D)  OK
> [    8.097891] raid6test: test_disks(18, 54): faila= 18(D)  failb= 54(D)  OK
> [    8.099322] raid6test: test_disks(18, 55): faila= 18(D)  failb= 55(D)  OK
> [    8.100741] raid6test: test_disks(18, 56): faila= 18(D)  failb= 56(D)  OK
> [    8.102163] raid6test: test_disks(18, 57): faila= 18(D)  failb= 57(D)  OK
> [    8.103594] raid6test: test_disks(18, 58): faila= 18(D)  failb= 58(D)  OK
> [    8.105012] raid6test: test_disks(18, 59): faila= 18(D)  failb= 59(D)  OK
> [    8.106443] raid6test: test_disks(18, 60): faila= 18(D)  failb= 60(D)  OK
> [    8.107862] raid6test: test_disks(18, 61): faila= 18(D)  failb= 61(D)  OK
> [    8.109282] raid6test: test_disks(18, 62): faila= 18(D)  failb= 62(P)  OK
> [    8.110700] raid6test: test_disks(18, 63): faila= 18(D)  failb= 63(Q)  OK
> [    8.112123] raid6test: test_disks(19, 20): faila= 19(D)  failb= 20(D)  OK
> [    8.113554] raid6test: test_disks(19, 21): faila= 19(D)  failb= 21(D)  OK
> [    8.114976] raid6test: test_disks(19, 22): faila= 19(D)  failb= 22(D)  OK
> [    8.116414] raid6test: test_disks(19, 23): faila= 19(D)  failb= 23(D)  OK
> [    8.117829] raid6test: test_disks(19, 24): faila= 19(D)  failb= 24(D)  OK
> [    8.119257] raid6test: test_disks(19, 25): faila= 19(D)  failb= 25(D)  OK
> [    8.120683] raid6test: test_disks(19, 26): faila= 19(D)  failb= 26(D)  OK
> [    8.122108] raid6test: test_disks(19, 27): faila= 19(D)  failb= 27(D)  OK
> [    8.123542] raid6test: test_disks(19, 28): faila= 19(D)  failb= 28(D)  OK
> [    8.124962] raid6test: test_disks(19, 29): faila= 19(D)  failb= 29(D)  OK
> [    8.126395] raid6test: test_disks(19, 30): faila= 19(D)  failb= 30(D)  OK
> [    8.127819] raid6test: test_disks(19, 31): faila= 19(D)  failb= 31(D)  OK
> [    8.129256] raid6test: test_disks(19, 32): faila= 19(D)  failb= 32(D)  OK
> [    8.130687] raid6test: test_disks(19, 33): faila= 19(D)  failb= 33(D)  OK
> [    8.132104] raid6test: test_disks(19, 34): faila= 19(D)  failb= 34(D)  OK
> [    8.133542] raid6test: test_disks(19, 35): faila= 19(D)  failb= 35(D)  OK
> [    8.134965] raid6test: test_disks(19, 36): faila= 19(D)  failb= 36(D)  OK
> [    8.136394] raid6test: test_disks(19, 37): faila= 19(D)  failb= 37(D)  OK
> [    8.137821] raid6test: test_disks(19, 38): faila= 19(D)  failb= 38(D)  OK
> [    8.139252] raid6test: test_disks(19, 39): faila= 19(D)  failb= 39(D)  OK
> [    8.140677] raid6test: test_disks(19, 40): faila= 19(D)  failb= 40(D)  OK
> [    8.142097] raid6test: test_disks(19, 41): faila= 19(D)  failb= 41(D)  OK
> [    8.143536] raid6test: test_disks(19, 42): faila= 19(D)  failb= 42(D)  OK
> [    8.144957] raid6test: test_disks(19, 43): faila= 19(D)  failb= 43(D)  OK
> [    8.146382] raid6test: test_disks(19, 44): faila= 19(D)  failb= 44(D)  OK
> [    8.147813] raid6test: test_disks(19, 45): faila= 19(D)  failb= 45(D)  OK
> [    8.149243] raid6test: test_disks(19, 46): faila= 19(D)  failb= 46(D)  OK
> [    8.150668] raid6test: test_disks(19, 47): faila= 19(D)  failb= 47(D)  OK
> [    8.152083] raid6test: test_disks(19, 48): faila= 19(D)  failb= 48(D)  OK
> [    8.153518] raid6test: test_disks(19, 49): faila= 19(D)  failb= 49(D)  OK
> [    8.154937] raid6test: test_disks(19, 50): faila= 19(D)  failb= 50(D)  OK
> [    8.156365] raid6test: test_disks(19, 51): faila= 19(D)  failb= 51(D)  OK
> [    8.157793] raid6test: test_disks(19, 52): faila= 19(D)  failb= 52(D)  OK
> [    8.159228] raid6test: test_disks(19, 53): faila= 19(D)  failb= 53(D)  OK
> [    8.160656] raid6test: test_disks(19, 54): faila= 19(D)  failb= 54(D)  OK
> [    8.162076] raid6test: test_disks(19, 55): faila= 19(D)  failb= 55(D)  OK
> [    8.163510] raid6test: test_disks(19, 56): faila= 19(D)  failb= 56(D)  OK
> [    8.164928] raid6test: test_disks(19, 57): faila= 19(D)  failb= 57(D)  OK
> [    8.166358] raid6test: test_disks(19, 58): faila= 19(D)  failb= 58(D)  OK
> [    8.167786] raid6test: test_disks(19, 59): faila= 19(D)  failb= 59(D)  OK
> [    8.169219] raid6test: test_disks(19, 60): faila= 19(D)  failb= 60(D)  OK
> [    8.170641] raid6test: test_disks(19, 61): faila= 19(D)  failb= 61(D)  OK
> [    8.172056] raid6test: test_disks(19, 62): faila= 19(D)  failb= 62(P)  OK
> [    8.173490] raid6test: test_disks(19, 63): faila= 19(D)  failb= 63(Q)  OK
> [    8.174912] raid6test: test_disks(20, 21): faila= 20(D)  failb= 21(D)  OK
> [    8.176341] raid6test: test_disks(20, 22): faila= 20(D)  failb= 22(D)  OK
> [    8.177769] raid6test: test_disks(20, 23): faila= 20(D)  failb= 23(D)  OK
> [    8.179194] raid6test: test_disks(20, 24): faila= 20(D)  failb= 24(D)  OK
> [    8.180620] raid6test: test_disks(20, 25): faila= 20(D)  failb= 25(D)  OK
> [    8.182039] raid6test: test_disks(20, 26): faila= 20(D)  failb= 26(D)  OK
> [    8.183472] raid6test: test_disks(20, 27): faila= 20(D)  failb= 27(D)  OK
> [    8.184895] raid6test: test_disks(20, 28): faila= 20(D)  failb= 28(D)  OK
> [    8.186323] raid6test: test_disks(20, 29): faila= 20(D)  failb= 29(D)  OK
> [    8.187745] raid6test: test_disks(20, 30): faila= 20(D)  failb= 30(D)  OK
> [    8.189177] raid6test: test_disks(20, 31): faila= 20(D)  failb= 31(D)  OK
> [    8.190606] raid6test: test_disks(20, 32): faila= 20(D)  failb= 32(D)  OK
> [    8.192019] raid6test: test_disks(20, 33): faila= 20(D)  failb= 33(D)  OK
> [    8.193457] raid6test: test_disks(20, 34): faila= 20(D)  failb= 34(D)  OK
> [    8.194871] raid6test: test_disks(20, 35): faila= 20(D)  failb= 35(D)  OK
> [    8.196302] raid6test: test_disks(20, 36): faila= 20(D)  failb= 36(D)  OK
> [    8.197727] raid6test: test_disks(20, 37): faila= 20(D)  failb= 37(D)  OK
> [    8.199159] raid6test: test_disks(20, 38): faila= 20(D)  failb= 38(D)  OK
> [    8.200587] raid6test: test_disks(20, 39): faila= 20(D)  failb= 39(D)  OK
> [    8.202009] raid6test: test_disks(20, 40): faila= 20(D)  failb= 40(D)  OK
> [    8.203446] raid6test: test_disks(20, 41): faila= 20(D)  failb= 41(D)  OK
> [    8.204867] raid6test: test_disks(20, 42): faila= 20(D)  failb= 42(D)  OK
> [    8.206296] raid6test: test_disks(20, 43): faila= 20(D)  failb= 43(D)  OK
> [    8.207725] raid6test: test_disks(20, 44): faila= 20(D)  failb= 44(D)  OK
> [    8.209159] raid6test: test_disks(20, 45): faila= 20(D)  failb= 45(D)  OK
> [    8.210592] raid6test: test_disks(20, 46): faila= 20(D)  failb= 46(D)  OK
> [    8.212010] raid6test: test_disks(20, 47): faila= 20(D)  failb= 47(D)  OK
> [    8.213457] raid6test: test_disks(20, 48): faila= 20(D)  failb= 48(D)  OK
> [    8.214876] raid6test: test_disks(20, 49): faila= 20(D)  failb= 49(D)  OK
> [    8.216309] raid6test: test_disks(20, 50): faila= 20(D)  failb= 50(D)  OK
> [    8.217734] raid6test: test_disks(20, 51): faila= 20(D)  failb= 51(D)  OK
> [    8.219171] raid6test: test_disks(20, 52): faila= 20(D)  failb= 52(D)  OK
> [    8.220593] raid6test: test_disks(20, 53): faila= 20(D)  failb= 53(D)  OK
> [    8.222018] raid6test: test_disks(20, 54): faila= 20(D)  failb= 54(D)  OK
> [    8.223453] raid6test: test_disks(20, 55): faila= 20(D)  failb= 55(D)  OK
> [    8.224884] raid6test: test_disks(20, 56): faila= 20(D)  failb= 56(D)  OK
> [    8.226317] raid6test: test_disks(20, 57): faila= 20(D)  failb= 57(D)  OK
> [    8.227745] raid6test: test_disks(20, 58): faila= 20(D)  failb= 58(D)  OK
> [    8.229180] raid6test: test_disks(20, 59): faila= 20(D)  failb= 59(D)  OK
> [    8.230612] raid6test: test_disks(20, 60): faila= 20(D)  failb= 60(D)  OK
> [    8.232033] raid6test: test_disks(20, 61): faila= 20(D)  failb= 61(D)  OK
> [    8.233464] raid6test: test_disks(20, 62): faila= 20(D)  failb= 62(P)  OK
> [    8.234878] raid6test: test_disks(20, 63): faila= 20(D)  failb= 63(Q)  OK
> [    8.236306] raid6test: test_disks(21, 22): faila= 21(D)  failb= 22(D)  OK
> [    8.237739] raid6test: test_disks(21, 23): faila= 21(D)  failb= 23(D)  OK
> [    8.239165] raid6test: test_disks(21, 24): faila= 21(D)  failb= 24(D)  OK
> [    8.240598] raid6test: test_disks(21, 25): faila= 21(D)  failb= 25(D)  OK
> [    8.242012] raid6test: test_disks(21, 26): faila= 21(D)  failb= 26(D)  OK
> [    8.243454] raid6test: test_disks(21, 27): faila= 21(D)  failb= 27(D)  OK
> [    8.244877] raid6test: test_disks(21, 28): faila= 21(D)  failb= 28(D)  OK
> [    8.246306] raid6test: test_disks(21, 29): faila= 21(D)  failb= 29(D)  OK
> [    8.247732] raid6test: test_disks(21, 30): faila= 21(D)  failb= 30(D)  OK
> [    8.249166] raid6test: test_disks(21, 31): faila= 21(D)  failb= 31(D)  OK
> [    8.250594] raid6test: test_disks(21, 32): faila= 21(D)  failb= 32(D)  OK
> [    8.252015] raid6test: test_disks(21, 33): faila= 21(D)  failb= 33(D)  OK
> [    8.253451] raid6test: test_disks(21, 34): faila= 21(D)  failb= 34(D)  OK
> [    8.254871] raid6test: test_disks(21, 35): faila= 21(D)  failb= 35(D)  OK
> [    8.256299] raid6test: test_disks(21, 36): faila= 21(D)  failb= 36(D)  OK
> [    8.257728] raid6test: test_disks(21, 37): faila= 21(D)  failb= 37(D)  OK
> [    8.259162] raid6test: test_disks(21, 38): faila= 21(D)  failb= 38(D)  OK
> [    8.260593] raid6test: test_disks(21, 39): faila= 21(D)  failb= 39(D)  OK
> [    8.262010] raid6test: test_disks(21, 40): faila= 21(D)  failb= 40(D)  OK
> [    8.263446] raid6test: test_disks(21, 41): faila= 21(D)  failb= 41(D)  OK
> [    8.264853] raid6test: test_disks(21, 42): faila= 21(D)  failb= 42(D)  OK
> [    8.266285] raid6test: test_disks(21, 43): faila= 21(D)  failb= 43(D)  OK
> [    8.267705] raid6test: test_disks(21, 44): faila= 21(D)  failb= 44(D)  OK
> [    8.269137] raid6test: test_disks(21, 45): faila= 21(D)  failb= 45(D)  OK
> [    8.270563] raid6test: test_disks(21, 46): faila= 21(D)  failb= 46(D)  OK
> [    8.271986] raid6test: test_disks(21, 47): faila= 21(D)  failb= 47(D)  OK
> [    8.273425] raid6test: test_disks(21, 48): faila= 21(D)  failb= 48(D)  OK
> [    8.274844] raid6test: test_disks(21, 49): faila= 21(D)  failb= 49(D)  OK
> [    8.276274] raid6test: test_disks(21, 50): faila= 21(D)  failb= 50(D)  OK
> [    8.277700] raid6test: test_disks(21, 51): faila= 21(D)  failb= 51(D)  OK
> [    8.279128] raid6test: test_disks(21, 52): faila= 21(D)  failb= 52(D)  OK
> [    8.280562] raid6test: test_disks(21, 53): faila= 21(D)  failb= 53(D)  OK
> [    8.281978] raid6test: test_disks(21, 54): faila= 21(D)  failb= 54(D)  OK
> [    8.283404] raid6test: test_disks(21, 55): faila= 21(D)  failb= 55(D)  OK
> [    8.284825] raid6test: test_disks(21, 56): faila= 21(D)  failb= 56(D)  OK
> [    8.286251] raid6test: test_disks(21, 57): faila= 21(D)  failb= 57(D)  OK
> [    8.287678] raid6test: test_disks(21, 58): faila= 21(D)  failb= 58(D)  OK
> [    8.289107] raid6test: test_disks(21, 59): faila= 21(D)  failb= 59(D)  OK
> [    8.290528] raid6test: test_disks(21, 60): faila= 21(D)  failb= 60(D)  OK
> [    8.291948] raid6test: test_disks(21, 61): faila= 21(D)  failb= 61(D)  OK
> [    8.293381] raid6test: test_disks(21, 62): faila= 21(D)  failb= 62(P)  OK
> [    8.296562] raid6test: test_disks(21, 63): faila= 21(D)  failb= 63(Q)  OK
> [    8.297983] raid6test: test_disks(22, 23): faila= 22(D)  failb= 23(D)  OK
> [    8.299417] raid6test: test_disks(22, 24): faila= 22(D)  failb= 24(D)  OK
> [    8.300837] raid6test: test_disks(22, 25): faila= 22(D)  failb= 25(D)  OK
> [    8.302254] raid6test: test_disks(22, 26): faila= 22(D)  failb= 26(D)  OK
> [    8.303689] raid6test: test_disks(22, 27): faila= 22(D)  failb= 27(D)  OK
> [    8.305103] raid6test: test_disks(22, 28): faila= 22(D)  failb= 28(D)  OK
> [    8.306537] raid6test: test_disks(22, 29): faila= 22(D)  failb= 29(D)  OK
> [    8.307962] raid6test: test_disks(22, 30): faila= 22(D)  failb= 30(D)  OK
> [    8.309397] raid6test: test_disks(22, 31): faila= 22(D)  failb= 31(D)  OK
> [    8.310821] raid6test: test_disks(22, 32): faila= 22(D)  failb= 32(D)  OK
> [    8.312244] raid6test: test_disks(22, 33): faila= 22(D)  failb= 33(D)  OK
> [    8.313683] raid6test: test_disks(22, 34): faila= 22(D)  failb= 34(D)  OK
> [    8.315106] raid6test: test_disks(22, 35): faila= 22(D)  failb= 35(D)  OK
> [    8.316540] raid6test: test_disks(22, 36): faila= 22(D)  failb= 36(D)  OK
> [    8.317960] raid6test: test_disks(22, 37): faila= 22(D)  failb= 37(D)  OK
> [    8.319382] raid6test: test_disks(22, 38): faila= 22(D)  failb= 38(D)  OK
> [    8.320802] raid6test: test_disks(22, 39): faila= 22(D)  failb= 39(D)  OK
> [    8.322222] raid6test: test_disks(22, 40): faila= 22(D)  failb= 40(D)  OK
> [    8.323654] raid6test: test_disks(22, 41): faila= 22(D)  failb= 41(D)  OK
> [    8.325077] raid6test: test_disks(22, 42): faila= 22(D)  failb= 42(D)  OK
> [    8.326512] raid6test: test_disks(22, 43): faila= 22(D)  failb= 43(D)  OK
> [    8.327934] raid6test: test_disks(22, 44): faila= 22(D)  failb= 44(D)  OK
> [    8.329366] raid6test: test_disks(22, 45): faila= 22(D)  failb= 45(D)  OK
> [    8.330796] raid6test: test_disks(22, 46): faila= 22(D)  failb= 46(D)  OK
> [    8.332213] raid6test: test_disks(22, 47): faila= 22(D)  failb= 47(D)  OK
> [    8.333652] raid6test: test_disks(22, 48): faila= 22(D)  failb= 48(D)  OK
> [    8.335072] raid6test: test_disks(22, 49): faila= 22(D)  failb= 49(D)  OK
> [    8.336509] raid6test: test_disks(22, 50): faila= 22(D)  failb= 50(D)  OK
> [    8.337935] raid6test: test_disks(22, 51): faila= 22(D)  failb= 51(D)  OK
> [    8.339366] raid6test: test_disks(22, 52): faila= 22(D)  failb= 52(D)  OK
> [    8.340787] raid6test: test_disks(22, 53): faila= 22(D)  failb= 53(D)  OK
> [    8.342211] raid6test: test_disks(22, 54): faila= 22(D)  failb= 54(D)  OK
> [    8.343652] raid6test: test_disks(22, 55): faila= 22(D)  failb= 55(D)  OK
> [    8.345072] raid6test: test_disks(22, 56): faila= 22(D)  failb= 56(D)  OK
> [    8.346507] raid6test: test_disks(22, 57): faila= 22(D)  failb= 57(D)  OK
> [    8.347933] raid6test: test_disks(22, 58): faila= 22(D)  failb= 58(D)  OK
> [    8.349363] raid6test: test_disks(22, 59): faila= 22(D)  failb= 59(D)  OK
> [    8.350792] raid6test: test_disks(22, 60): faila= 22(D)  failb= 60(D)  OK
> [    8.352212] raid6test: test_disks(22, 61): faila= 22(D)  failb= 61(D)  OK
> [    8.353645] raid6test: test_disks(22, 62): faila= 22(D)  failb= 62(P)  OK
> [    8.355067] raid6test: test_disks(22, 63): faila= 22(D)  failb= 63(Q)  OK
> [    8.356495] raid6test: test_disks(23, 24): faila= 23(D)  failb= 24(D)  OK
> [    8.357918] raid6test: test_disks(23, 25): faila= 23(D)  failb= 25(D)  OK
> [    8.359350] raid6test: test_disks(23, 26): faila= 23(D)  failb= 26(D)  OK
> [    8.360775] raid6test: test_disks(23, 27): faila= 23(D)  failb= 27(D)  OK
> [    8.362196] raid6test: test_disks(23, 28): faila= 23(D)  failb= 28(D)  OK
> [    8.363630] raid6test: test_disks(23, 29): faila= 23(D)  failb= 29(D)  OK
> [    8.365047] raid6test: test_disks(23, 30): faila= 23(D)  failb= 30(D)  OK
> [    8.366482] raid6test: test_disks(23, 31): faila= 23(D)  failb= 31(D)  OK
> [    8.367903] raid6test: test_disks(23, 32): faila= 23(D)  failb= 32(D)  OK
> [    8.369330] raid6test: test_disks(23, 33): faila= 23(D)  failb= 33(D)  OK
> [    8.370750] raid6test: test_disks(23, 34): faila= 23(D)  failb= 34(D)  OK
> [    8.372172] raid6test: test_disks(23, 35): faila= 23(D)  failb= 35(D)  OK
> [    8.373618] raid6test: test_disks(23, 36): faila= 23(D)  failb= 36(D)  OK
> [    8.375045] raid6test: test_disks(23, 37): faila= 23(D)  failb= 37(D)  OK
> [    8.376478] raid6test: test_disks(23, 38): faila= 23(D)  failb= 38(D)  OK
> [    8.377900] raid6test: test_disks(23, 39): faila= 23(D)  failb= 39(D)  OK
> [    8.379337] raid6test: test_disks(23, 40): faila= 23(D)  failb= 40(D)  OK
> [    8.380767] raid6test: test_disks(23, 41): faila= 23(D)  failb= 41(D)  OK
> [    8.382188] raid6test: test_disks(23, 42): faila= 23(D)  failb= 42(D)  OK
> [    8.383623] raid6test: test_disks(23, 43): faila= 23(D)  failb= 43(D)  OK
> [    8.385046] raid6test: test_disks(23, 44): faila= 23(D)  failb= 44(D)  OK
> [    8.386486] raid6test: test_disks(23, 45): faila= 23(D)  failb= 45(D)  OK
> [    8.387912] raid6test: test_disks(23, 46): faila= 23(D)  failb= 46(D)  OK
> [    8.389345] raid6test: test_disks(23, 47): faila= 23(D)  failb= 47(D)  OK
> [    8.390768] raid6test: test_disks(23, 48): faila= 23(D)  failb= 48(D)  OK
> [    8.392185] raid6test: test_disks(23, 49): faila= 23(D)  failb= 49(D)  OK
> [    8.393621] raid6test: test_disks(23, 50): faila= 23(D)  failb= 50(D)  OK
> [    8.395038] raid6test: test_disks(23, 51): faila= 23(D)  failb= 51(D)  OK
> [    8.396474] raid6test: test_disks(23, 52): faila= 23(D)  failb= 52(D)  OK
> [    8.397894] raid6test: test_disks(23, 53): faila= 23(D)  failb= 53(D)  OK
> [    8.399318] raid6test: test_disks(23, 54): faila= 23(D)  failb= 54(D)  OK
> [    8.400742] raid6test: test_disks(23, 55): faila= 23(D)  failb= 55(D)  OK
> [    8.402157] raid6test: test_disks(23, 56): faila= 23(D)  failb= 56(D)  OK
> [    8.403592] raid6test: test_disks(23, 57): faila= 23(D)  failb= 57(D)  OK
> [    8.405018] raid6test: test_disks(23, 58): faila= 23(D)  failb= 58(D)  OK
> [    8.406455] raid6test: test_disks(23, 59): faila= 23(D)  failb= 59(D)  OK
> [    8.407871] raid6test: test_disks(23, 60): faila= 23(D)  failb= 60(D)  OK
> [    8.409302] raid6test: test_disks(23, 61): faila= 23(D)  failb= 61(D)  OK
> [    8.410722] raid6test: test_disks(23, 62): faila= 23(D)  failb= 62(P)  OK
> [    8.412137] raid6test: test_disks(23, 63): faila= 23(D)  failb= 63(Q)  OK
> [    8.413575] raid6test: test_disks(24, 25): faila= 24(D)  failb= 25(D)  OK
> [    8.414995] raid6test: test_disks(24, 26): faila= 24(D)  failb= 26(D)  OK
> [    8.416427] raid6test: test_disks(24, 27): faila= 24(D)  failb= 27(D)  OK
> [    8.417848] raid6test: test_disks(24, 28): faila= 24(D)  failb= 28(D)  OK
> [    8.419275] raid6test: test_disks(24, 29): faila= 24(D)  failb= 29(D)  OK
> [    8.420702] raid6test: test_disks(24, 30): faila= 24(D)  failb= 30(D)  OK
> [    8.422121] raid6test: test_disks(24, 31): faila= 24(D)  failb= 31(D)  OK
> [    8.423557] raid6test: test_disks(24, 32): faila= 24(D)  failb= 32(D)  OK
> [    8.424988] raid6test: test_disks(24, 33): faila= 24(D)  failb= 33(D)  OK
> [    8.426418] raid6test: test_disks(24, 34): faila= 24(D)  failb= 34(D)  OK
> [    8.427834] raid6test: test_disks(24, 35): faila= 24(D)  failb= 35(D)  OK
> [    8.429264] raid6test: test_disks(24, 36): faila= 24(D)  failb= 36(D)  OK
> [    8.430695] raid6test: test_disks(24, 37): faila= 24(D)  failb= 37(D)  OK
> [    8.432116] raid6test: test_disks(24, 38): faila= 24(D)  failb= 38(D)  OK
> [    8.433549] raid6test: test_disks(24, 39): faila= 24(D)  failb= 39(D)  OK
> [    8.434969] raid6test: test_disks(24, 40): faila= 24(D)  failb= 40(D)  OK
> [    8.436396] raid6test: test_disks(24, 41): faila= 24(D)  failb= 41(D)  OK
> [    8.437822] raid6test: test_disks(24, 42): faila= 24(D)  failb= 42(D)  OK
> [    8.439257] raid6test: test_disks(24, 43): faila= 24(D)  failb= 43(D)  OK
> [    8.440676] raid6test: test_disks(24, 44): faila= 24(D)  failb= 44(D)  OK
> [    8.442091] raid6test: test_disks(24, 45): faila= 24(D)  failb= 45(D)  OK
> [    8.443524] raid6test: test_disks(24, 46): faila= 24(D)  failb= 46(D)  OK
> [    8.444946] raid6test: test_disks(24, 47): faila= 24(D)  failb= 47(D)  OK
> [    8.446377] raid6test: test_disks(24, 48): faila= 24(D)  failb= 48(D)  OK
> [    8.447802] raid6test: test_disks(24, 49): faila= 24(D)  failb= 49(D)  OK
> [    8.449236] raid6test: test_disks(24, 50): faila= 24(D)  failb= 50(D)  OK
> [    8.450660] raid6test: test_disks(24, 51): faila= 24(D)  failb= 51(D)  OK
> [    8.452081] raid6test: test_disks(24, 52): faila= 24(D)  failb= 52(D)  OK
> [    8.453521] raid6test: test_disks(24, 53): faila= 24(D)  failb= 53(D)  OK
> [    8.454937] raid6test: test_disks(24, 54): faila= 24(D)  failb= 54(D)  OK
> [    8.456363] raid6test: test_disks(24, 55): faila= 24(D)  failb= 55(D)  OK
> [    8.457788] raid6test: test_disks(24, 56): faila= 24(D)  failb= 56(D)  OK
> [    8.459218] raid6test: test_disks(24, 57): faila= 24(D)  failb= 57(D)  OK
> [    8.460646] raid6test: test_disks(24, 58): faila= 24(D)  failb= 58(D)  OK
> [    8.462060] raid6test: test_disks(24, 59): faila= 24(D)  failb= 59(D)  OK
> [    8.463502] raid6test: test_disks(24, 60): faila= 24(D)  failb= 60(D)  OK
> [    8.464921] raid6test: test_disks(24, 61): faila= 24(D)  failb= 61(D)  OK
> [    8.466345] raid6test: test_disks(24, 62): faila= 24(D)  failb= 62(P)  OK
> [    8.467770] raid6test: test_disks(24, 63): faila= 24(D)  failb= 63(Q)  OK
> [    8.469206] raid6test: test_disks(25, 26): faila= 25(D)  failb= 26(D)  OK
> [    8.470632] raid6test: test_disks(25, 27): faila= 25(D)  failb= 27(D)  OK
> [    8.472038] raid6test: test_disks(25, 28): faila= 25(D)  failb= 28(D)  OK
> [    8.473473] raid6test: test_disks(25, 29): faila= 25(D)  failb= 29(D)  OK
> [    8.474895] raid6test: test_disks(25, 30): faila= 25(D)  failb= 30(D)  OK
> [    8.476320] raid6test: test_disks(25, 31): faila= 25(D)  failb= 31(D)  OK
> [    8.477744] raid6test: test_disks(25, 32): faila= 25(D)  failb= 32(D)  OK
> [    8.479175] raid6test: test_disks(25, 33): faila= 25(D)  failb= 33(D)  OK
> [    8.480603] raid6test: test_disks(25, 34): faila= 25(D)  failb= 34(D)  OK
> [    8.482021] raid6test: test_disks(25, 35): faila= 25(D)  failb= 35(D)  OK
> [    8.483462] raid6test: test_disks(25, 36): faila= 25(D)  failb= 36(D)  OK
> [    8.484882] raid6test: test_disks(25, 37): faila= 25(D)  failb= 37(D)  OK
> [    8.486307] raid6test: test_disks(25, 38): faila= 25(D)  failb= 38(D)  OK
> [    8.487736] raid6test: test_disks(25, 39): faila= 25(D)  failb= 39(D)  OK
> [    8.489166] raid6test: test_disks(25, 40): faila= 25(D)  failb= 40(D)  OK
> [    8.490594] raid6test: test_disks(25, 41): faila= 25(D)  failb= 41(D)  OK
> [    8.492016] raid6test: test_disks(25, 42): faila= 25(D)  failb= 42(D)  OK
> [    8.493457] raid6test: test_disks(25, 43): faila= 25(D)  failb= 43(D)  OK
> [    8.494873] raid6test: test_disks(25, 44): faila= 25(D)  failb= 44(D)  OK
> [    8.496307] raid6test: test_disks(25, 45): faila= 25(D)  failb= 45(D)  OK
> [    8.497739] raid6test: test_disks(25, 46): faila= 25(D)  failb= 46(D)  OK
> [    8.499173] raid6test: test_disks(25, 47): faila= 25(D)  failb= 47(D)  OK
> [    8.500600] raid6test: test_disks(25, 48): faila= 25(D)  failb= 48(D)  OK
> [    8.502023] raid6test: test_disks(25, 49): faila= 25(D)  failb= 49(D)  OK
> [    8.503458] raid6test: test_disks(25, 50): faila= 25(D)  failb= 50(D)  OK
> [    8.504887] raid6test: test_disks(25, 51): faila= 25(D)  failb= 51(D)  OK
> [    8.506317] raid6test: test_disks(25, 52): faila= 25(D)  failb= 52(D)  OK
> [    8.507746] raid6test: test_disks(25, 53): faila= 25(D)  failb= 53(D)  OK
> [    8.509178] raid6test: test_disks(25, 54): faila= 25(D)  failb= 54(D)  OK
> [    8.510605] raid6test: test_disks(25, 55): faila= 25(D)  failb= 55(D)  OK
> [    8.512025] raid6test: test_disks(25, 56): faila= 25(D)  failb= 56(D)  OK
> [    8.513461] raid6test: test_disks(25, 57): faila= 25(D)  failb= 57(D)  OK
> [    8.514881] raid6test: test_disks(25, 58): faila= 25(D)  failb= 58(D)  OK
> [    8.516307] raid6test: test_disks(25, 59): faila= 25(D)  failb= 59(D)  OK
> [    8.517732] raid6test: test_disks(25, 60): faila= 25(D)  failb= 60(D)  OK
> [    8.519157] raid6test: test_disks(25, 61): faila= 25(D)  failb= 61(D)  OK
> [    8.520585] raid6test: test_disks(25, 62): faila= 25(D)  failb= 62(P)  OK
> [    8.521993] raid6test: test_disks(25, 63): faila= 25(D)  failb= 63(Q)  OK
> [    8.523427] raid6test: test_disks(26, 27): faila= 26(D)  failb= 27(D)  OK
> [    8.524858] raid6test: test_disks(26, 28): faila= 26(D)  failb= 28(D)  OK
> [    8.526284] raid6test: test_disks(26, 29): faila= 26(D)  failb= 29(D)  OK
> [    8.527708] raid6test: test_disks(26, 30): faila= 26(D)  failb= 30(D)  OK
> [    8.529135] raid6test: test_disks(26, 31): faila= 26(D)  failb= 31(D)  OK
> [    8.530564] raid6test: test_disks(26, 32): faila= 26(D)  failb= 32(D)  OK
> [    8.531984] raid6test: test_disks(26, 33): faila= 26(D)  failb= 33(D)  OK
> [    8.533425] raid6test: test_disks(26, 34): faila= 26(D)  failb= 34(D)  OK
> [    8.534848] raid6test: test_disks(26, 35): faila= 26(D)  failb= 35(D)  OK
> [    8.536278] raid6test: test_disks(26, 36): faila= 26(D)  failb= 36(D)  OK
> [    8.537710] raid6test: test_disks(26, 37): faila= 26(D)  failb= 37(D)  OK
> [    8.539138] raid6test: test_disks(26, 38): faila= 26(D)  failb= 38(D)  OK
> [    8.540556] raid6test: test_disks(26, 39): faila= 26(D)  failb= 39(D)  OK
> [    8.541974] raid6test: test_disks(26, 40): faila= 26(D)  failb= 40(D)  OK
> [    8.543401] raid6test: test_disks(26, 41): faila= 26(D)  failb= 41(D)  OK
> [    8.544826] raid6test: test_disks(26, 42): faila= 26(D)  failb= 42(D)  OK
> [    8.546253] raid6test: test_disks(26, 43): faila= 26(D)  failb= 43(D)  OK
> [    8.547680] raid6test: test_disks(26, 44): faila= 26(D)  failb= 44(D)  OK
> [    8.549111] raid6test: test_disks(26, 45): faila= 26(D)  failb= 45(D)  OK
> [    8.550540] raid6test: test_disks(26, 46): faila= 26(D)  failb= 46(D)  OK
> [    8.551960] raid6test: test_disks(26, 47): faila= 26(D)  failb= 47(D)  OK
> [    8.555147] raid6test: test_disks(26, 48): faila= 26(D)  failb= 48(D)  OK
> [    8.556582] raid6test: test_disks(26, 49): faila= 26(D)  failb= 49(D)  OK
> [    8.558003] raid6test: test_disks(26, 50): faila= 26(D)  failb= 50(D)  OK
> [    8.559432] raid6test: test_disks(26, 51): faila= 26(D)  failb= 51(D)  OK
> [    8.560849] raid6test: test_disks(26, 52): faila= 26(D)  failb= 52(D)  OK
> [    8.562260] raid6test: test_disks(26, 53): faila= 26(D)  failb= 53(D)  OK
> [    8.563693] raid6test: test_disks(26, 54): faila= 26(D)  failb= 54(D)  OK
> [    8.565112] raid6test: test_disks(26, 55): faila= 26(D)  failb= 55(D)  OK
> [    8.566552] raid6test: test_disks(26, 56): faila= 26(D)  failb= 56(D)  OK
> [    8.567972] raid6test: test_disks(26, 57): faila= 26(D)  failb= 57(D)  OK
> [    8.569407] raid6test: test_disks(26, 58): faila= 26(D)  failb= 58(D)  OK
> [    8.570834] raid6test: test_disks(26, 59): faila= 26(D)  failb= 59(D)  OK
> [    8.572247] raid6test: test_disks(26, 60): faila= 26(D)  failb= 60(D)  OK
> [    8.573675] raid6test: test_disks(26, 61): faila= 26(D)  failb= 61(D)  OK
> [    8.575088] raid6test: test_disks(26, 62): faila= 26(D)  failb= 62(P)  OK
> [    8.576515] raid6test: test_disks(26, 63): faila= 26(D)  failb= 63(Q)  OK
> [    8.577934] raid6test: test_disks(27, 28): faila= 27(D)  failb= 28(D)  OK
> [    8.579360] raid6test: test_disks(27, 29): faila= 27(D)  failb= 29(D)  OK
> [    8.580789] raid6test: test_disks(27, 30): faila= 27(D)  failb= 30(D)  OK
> [    8.582212] raid6test: test_disks(27, 31): faila= 27(D)  failb= 31(D)  OK
> [    8.583649] raid6test: test_disks(27, 32): faila= 27(D)  failb= 32(D)  OK
> [    8.585072] raid6test: test_disks(27, 33): faila= 27(D)  failb= 33(D)  OK
> [    8.586506] raid6test: test_disks(27, 34): faila= 27(D)  failb= 34(D)  OK
> [    8.587925] raid6test: test_disks(27, 35): faila= 27(D)  failb= 35(D)  OK
> [    8.589357] raid6test: test_disks(27, 36): faila= 27(D)  failb= 36(D)  OK
> [    8.590784] raid6test: test_disks(27, 37): faila= 27(D)  failb= 37(D)  OK
> [    8.592205] raid6test: test_disks(27, 38): faila= 27(D)  failb= 38(D)  OK
> [    8.593642] raid6test: test_disks(27, 39): faila= 27(D)  failb= 39(D)  OK
> [    8.595061] raid6test: test_disks(27, 40): faila= 27(D)  failb= 40(D)  OK
> [    8.596501] raid6test: test_disks(27, 41): faila= 27(D)  failb= 41(D)  OK
> [    8.597921] raid6test: test_disks(27, 42): faila= 27(D)  failb= 42(D)  OK
> [    8.599351] raid6test: test_disks(27, 43): faila= 27(D)  failb= 43(D)  OK
> [    8.600774] raid6test: test_disks(27, 44): faila= 27(D)  failb= 44(D)  OK
> [    8.602195] raid6test: test_disks(27, 45): faila= 27(D)  failb= 45(D)  OK
> [    8.603634] raid6test: test_disks(27, 46): faila= 27(D)  failb= 46(D)  OK
> [    8.605052] raid6test: test_disks(27, 47): faila= 27(D)  failb= 47(D)  OK
> [    8.606484] raid6test: test_disks(27, 48): faila= 27(D)  failb= 48(D)  OK
> [    8.607908] raid6test: test_disks(27, 49): faila= 27(D)  failb= 49(D)  OK
> [    8.609336] raid6test: test_disks(27, 50): faila= 27(D)  failb= 50(D)  OK
> [    8.610757] raid6test: test_disks(27, 51): faila= 27(D)  failb= 51(D)  OK
> [    8.612178] raid6test: test_disks(27, 52): faila= 27(D)  failb= 52(D)  OK
> [    8.613618] raid6test: test_disks(27, 53): faila= 27(D)  failb= 53(D)  OK
> [    8.615041] raid6test: test_disks(27, 54): faila= 27(D)  failb= 54(D)  OK
> [    8.616464] raid6test: test_disks(27, 55): faila= 27(D)  failb= 55(D)  OK
> [    8.617892] raid6test: test_disks(27, 56): faila= 27(D)  failb= 56(D)  OK
> [    8.619325] raid6test: test_disks(27, 57): faila= 27(D)  failb= 57(D)  OK
> [    8.620742] raid6test: test_disks(27, 58): faila= 27(D)  failb= 58(D)  OK
> [    8.622158] raid6test: test_disks(27, 59): faila= 27(D)  failb= 59(D)  OK
> [    8.623595] raid6test: test_disks(27, 60): faila= 27(D)  failb= 60(D)  OK
> [    8.625024] raid6test: test_disks(27, 61): faila= 27(D)  failb= 61(D)  OK
> [    8.626452] raid6test: test_disks(27, 62): faila= 27(D)  failb= 62(P)  OK
> [    8.627871] raid6test: test_disks(27, 63): faila= 27(D)  failb= 63(Q)  OK
> [    8.629304] raid6test: test_disks(28, 29): faila= 28(D)  failb= 29(D)  OK
> [    8.630727] raid6test: test_disks(28, 30): faila= 28(D)  failb= 30(D)  OK
> [    8.632142] raid6test: test_disks(28, 31): faila= 28(D)  failb= 31(D)  OK
> [    8.633569] raid6test: test_disks(28, 32): faila= 28(D)  failb= 32(D)  OK
> [    8.634988] raid6test: test_disks(28, 33): faila= 28(D)  failb= 33(D)  OK
> [    8.636425] raid6test: test_disks(28, 34): faila= 28(D)  failb= 34(D)  OK
> [    8.637845] raid6test: test_disks(28, 35): faila= 28(D)  failb= 35(D)  OK
> [    8.639272] raid6test: test_disks(28, 36): faila= 28(D)  failb= 36(D)  OK
> [    8.640698] raid6test: test_disks(28, 37): faila= 28(D)  failb= 37(D)  OK
> [    8.642121] raid6test: test_disks(28, 38): faila= 28(D)  failb= 38(D)  OK
> [    8.643555] raid6test: test_disks(28, 39): faila= 28(D)  failb= 39(D)  OK
> [    8.644979] raid6test: test_disks(28, 40): faila= 28(D)  failb= 40(D)  OK
> [    8.646407] raid6test: test_disks(28, 41): faila= 28(D)  failb= 41(D)  OK
> [    8.647831] raid6test: test_disks(28, 42): faila= 28(D)  failb= 42(D)  OK
> [    8.649256] raid6test: test_disks(28, 43): faila= 28(D)  failb= 43(D)  OK
> [    8.650678] raid6test: test_disks(28, 44): faila= 28(D)  failb= 44(D)  OK
> [    8.652093] raid6test: test_disks(28, 45): faila= 28(D)  failb= 45(D)  OK
> [    8.653525] raid6test: test_disks(28, 46): faila= 28(D)  failb= 46(D)  OK
> [    8.654945] raid6test: test_disks(28, 47): faila= 28(D)  failb= 47(D)  OK
> [    8.656379] raid6test: test_disks(28, 48): faila= 28(D)  failb= 48(D)  OK
> [    8.657805] raid6test: test_disks(28, 49): faila= 28(D)  failb= 49(D)  OK
> [    8.659230] raid6test: test_disks(28, 50): faila= 28(D)  failb= 50(D)  OK
> [    8.660651] raid6test: test_disks(28, 51): faila= 28(D)  failb= 51(D)  OK
> [    8.662072] raid6test: test_disks(28, 52): faila= 28(D)  failb= 52(D)  OK
> [    8.663502] raid6test: test_disks(28, 53): faila= 28(D)  failb= 53(D)  OK
> [    8.664930] raid6test: test_disks(28, 54): faila= 28(D)  failb= 54(D)  OK
> [    8.666359] raid6test: test_disks(28, 55): faila= 28(D)  failb= 55(D)  OK
> [    8.667792] raid6test: test_disks(28, 56): faila= 28(D)  failb= 56(D)  OK
> [    8.669223] raid6test: test_disks(28, 57): faila= 28(D)  failb= 57(D)  OK
> [    8.670649] raid6test: test_disks(28, 58): faila= 28(D)  failb= 58(D)  OK
> [    8.672062] raid6test: test_disks(28, 59): faila= 28(D)  failb= 59(D)  OK
> [    8.673499] raid6test: test_disks(28, 60): faila= 28(D)  failb= 60(D)  OK
> [    8.674919] raid6test: test_disks(28, 61): faila= 28(D)  failb= 61(D)  OK
> [    8.676342] raid6test: test_disks(28, 62): faila= 28(D)  failb= 62(P)  OK
> [    8.677759] raid6test: test_disks(28, 63): faila= 28(D)  failb= 63(Q)  OK
> [    8.679193] raid6test: test_disks(29, 30): faila= 29(D)  failb= 30(D)  OK
> [    8.680619] raid6test: test_disks(29, 31): faila= 29(D)  failb= 31(D)  OK
> [    8.682045] raid6test: test_disks(29, 32): faila= 29(D)  failb= 32(D)  OK
> [    8.683488] raid6test: test_disks(29, 33): faila= 29(D)  failb= 33(D)  OK
> [    8.684908] raid6test: test_disks(29, 34): faila= 29(D)  failb= 34(D)  OK
> [    8.686338] raid6test: test_disks(29, 35): faila= 29(D)  failb= 35(D)  OK
> [    8.687763] raid6test: test_disks(29, 36): faila= 29(D)  failb= 36(D)  OK
> [    8.689197] raid6test: test_disks(29, 37): faila= 29(D)  failb= 37(D)  OK
> [    8.690625] raid6test: test_disks(29, 38): faila= 29(D)  failb= 38(D)  OK
> [    8.692041] raid6test: test_disks(29, 39): faila= 29(D)  failb= 39(D)  OK
> [    8.693477] raid6test: test_disks(29, 40): faila= 29(D)  failb= 40(D)  OK
> [    8.694897] raid6test: test_disks(29, 41): faila= 29(D)  failb= 41(D)  OK
> [    8.696322] raid6test: test_disks(29, 42): faila= 29(D)  failb= 42(D)  OK
> [    8.697748] raid6test: test_disks(29, 43): faila= 29(D)  failb= 43(D)  OK
> [    8.699177] raid6test: test_disks(29, 44): faila= 29(D)  failb= 44(D)  OK
> [    8.700603] raid6test: test_disks(29, 45): faila= 29(D)  failb= 45(D)  OK
> [    8.702022] raid6test: test_disks(29, 46): faila= 29(D)  failb= 46(D)  OK
> [    8.703461] raid6test: test_disks(29, 47): faila= 29(D)  failb= 47(D)  OK
> [    8.704888] raid6test: test_disks(29, 48): faila= 29(D)  failb= 48(D)  OK
> [    8.706317] raid6test: test_disks(29, 49): faila= 29(D)  failb= 49(D)  OK
> [    8.707744] raid6test: test_disks(29, 50): faila= 29(D)  failb= 50(D)  OK
> [    8.709173] raid6test: test_disks(29, 51): faila= 29(D)  failb= 51(D)  OK
> [    8.710593] raid6test: test_disks(29, 52): faila= 29(D)  failb= 52(D)  OK
> [    8.712008] raid6test: test_disks(29, 53): faila= 29(D)  failb= 53(D)  OK
> [    8.713431] raid6test: test_disks(29, 54): faila= 29(D)  failb= 54(D)  OK
> [    8.714852] raid6test: test_disks(29, 55): faila= 29(D)  failb= 55(D)  OK
> [    8.716279] raid6test: test_disks(29, 56): faila= 29(D)  failb= 56(D)  OK
> [    8.717706] raid6test: test_disks(29, 57): faila= 29(D)  failb= 57(D)  OK
> [    8.719138] raid6test: test_disks(29, 58): faila= 29(D)  failb= 58(D)  OK
> [    8.720565] raid6test: test_disks(29, 59): faila= 29(D)  failb= 59(D)  OK
> [    8.721985] raid6test: test_disks(29, 60): faila= 29(D)  failb= 60(D)  OK
> [    8.723414] raid6test: test_disks(29, 61): faila= 29(D)  failb= 61(D)  OK
> [    8.724840] raid6test: test_disks(29, 62): faila= 29(D)  failb= 62(P)  OK
> [    8.726263] raid6test: test_disks(29, 63): faila= 29(D)  failb= 63(Q)  OK
> [    8.727687] raid6test: test_disks(30, 31): faila= 30(D)  failb= 31(D)  OK
> [    8.729116] raid6test: test_disks(30, 32): faila= 30(D)  failb= 32(D)  OK
> [    8.730550] raid6test: test_disks(30, 33): faila= 30(D)  failb= 33(D)  OK
> [    8.731963] raid6test: test_disks(30, 34): faila= 30(D)  failb= 34(D)  OK
> [    8.733391] raid6test: test_disks(30, 35): faila= 30(D)  failb= 35(D)  OK
> [    8.734809] raid6test: test_disks(30, 36): faila= 30(D)  failb= 36(D)  OK
> [    8.736239] raid6test: test_disks(30, 37): faila= 30(D)  failb= 37(D)  OK
> [    8.737657] raid6test: test_disks(30, 38): faila= 30(D)  failb= 38(D)  OK
> [    8.739087] raid6test: test_disks(30, 39): faila= 30(D)  failb= 39(D)  OK
> [    8.740512] raid6test: test_disks(30, 40): faila= 30(D)  failb= 40(D)  OK
> [    8.741928] raid6test: test_disks(30, 41): faila= 30(D)  failb= 41(D)  OK
> [    8.743368] raid6test: test_disks(30, 42): faila= 30(D)  failb= 42(D)  OK
> [    8.744783] raid6test: test_disks(30, 43): faila= 30(D)  failb= 43(D)  OK
> [    8.746213] raid6test: test_disks(30, 44): faila= 30(D)  failb= 44(D)  OK
> [    8.747640] raid6test: test_disks(30, 45): faila= 30(D)  failb= 45(D)  OK
> [    8.749071] raid6test: test_disks(30, 46): faila= 30(D)  failb= 46(D)  OK
> [    8.750495] raid6test: test_disks(30, 47): faila= 30(D)  failb= 47(D)  OK
> [    8.751909] raid6test: test_disks(30, 48): faila= 30(D)  failb= 48(D)  OK
> [    8.753336] raid6test: test_disks(30, 49): faila= 30(D)  failb= 49(D)  OK
> [    8.754763] raid6test: test_disks(30, 50): faila= 30(D)  failb= 50(D)  OK
> [    8.756183] raid6test: test_disks(30, 51): faila= 30(D)  failb= 51(D)  OK
> [    8.757610] raid6test: test_disks(30, 52): faila= 30(D)  failb= 52(D)  OK
> [    8.759033] raid6test: test_disks(30, 53): faila= 30(D)  failb= 53(D)  OK
> [    8.760463] raid6test: test_disks(30, 54): faila= 30(D)  failb= 54(D)  OK
> [    8.761883] raid6test: test_disks(30, 55): faila= 30(D)  failb= 55(D)  OK
> [    8.763312] raid6test: test_disks(30, 56): faila= 30(D)  failb= 56(D)  OK
> [    8.764735] raid6test: test_disks(30, 57): faila= 30(D)  failb= 57(D)  OK
> [    8.766158] raid6test: test_disks(30, 58): faila= 30(D)  failb= 58(D)  OK
> [    8.767587] raid6test: test_disks(30, 59): faila= 30(D)  failb= 59(D)  OK
> [    8.769004] raid6test: test_disks(30, 60): faila= 30(D)  failb= 60(D)  OK
> [    8.770440] raid6test: test_disks(30, 61): faila= 30(D)  failb= 61(D)  OK
> [    8.771846] raid6test: test_disks(30, 62): faila= 30(D)  failb= 62(P)  OK
> [    8.773275] raid6test: test_disks(30, 63): faila= 30(D)  failb= 63(Q)  OK
> [    8.774701] raid6test: test_disks(31, 32): faila= 31(D)  failb= 32(D)  OK
> [    8.776130] raid6test: test_disks(31, 33): faila= 31(D)  failb= 33(D)  OK
> [    8.777560] raid6test: test_disks(31, 34): faila= 31(D)  failb= 34(D)  OK
> [    8.778976] raid6test: test_disks(31, 35): faila= 31(D)  failb= 35(D)  OK
> [    8.780389] raid6test: test_disks(31, 36): faila= 31(D)  failb= 36(D)  OK
> [    8.781814] raid6test: test_disks(31, 37): faila= 31(D)  failb= 37(D)  OK
> [    8.783241] raid6test: test_disks(31, 38): faila= 31(D)  failb= 38(D)  OK
> [    8.784667] raid6test: test_disks(31, 39): faila= 31(D)  failb= 39(D)  OK
> [    8.786095] raid6test: test_disks(31, 40): faila= 31(D)  failb= 40(D)  OK
> [    8.787522] raid6test: test_disks(31, 41): faila= 31(D)  failb= 41(D)  OK
> [    8.788939] raid6test: test_disks(31, 42): faila= 31(D)  failb= 42(D)  OK
> [    8.790364] raid6test: test_disks(31, 43): faila= 31(D)  failb= 43(D)  OK
> [    8.791797] raid6test: test_disks(31, 44): faila= 31(D)  failb= 44(D)  OK
> [    8.793222] raid6test: test_disks(31, 45): faila= 31(D)  failb= 45(D)  OK
> [    8.794648] raid6test: test_disks(31, 46): faila= 31(D)  failb= 46(D)  OK
> [    8.796073] raid6test: test_disks(31, 47): faila= 31(D)  failb= 47(D)  OK
> [    8.797499] raid6test: test_disks(31, 48): faila= 31(D)  failb= 48(D)  OK
> [    8.798918] raid6test: test_disks(31, 49): faila= 31(D)  failb= 49(D)  OK
> [    8.800342] raid6test: test_disks(31, 50): faila= 31(D)  failb= 50(D)  OK
> [    8.801771] raid6test: test_disks(31, 51): faila= 31(D)  failb= 51(D)  OK
> [    8.803197] raid6test: test_disks(31, 52): faila= 31(D)  failb= 52(D)  OK
> [    8.804628] raid6test: test_disks(31, 53): faila= 31(D)  failb= 53(D)  OK
> [    8.806056] raid6test: test_disks(31, 54): faila= 31(D)  failb= 54(D)  OK
> [    8.807485] raid6test: test_disks(31, 55): faila= 31(D)  failb= 55(D)  OK
> [    8.808902] raid6test: test_disks(31, 56): faila= 31(D)  failb= 56(D)  OK
> [    8.810330] raid6test: test_disks(31, 57): faila= 31(D)  failb= 57(D)  OK
> [    8.813587] raid6test: test_disks(31, 58): faila= 31(D)  failb= 58(D)  OK
> [    8.815009] raid6test: test_disks(31, 59): faila= 31(D)  failb= 59(D)  OK
> [    8.816436] raid6test: test_disks(31, 60): faila= 31(D)  failb= 60(D)  OK
> [    8.817850] raid6test: test_disks(31, 61): faila= 31(D)  failb= 61(D)  OK
> [    8.819273] raid6test: test_disks(31, 62): faila= 31(D)  failb= 62(P)  OK
> [    8.820695] raid6test: test_disks(31, 63): faila= 31(D)  failb= 63(Q)  OK
> [    8.822114] raid6test: test_disks(32, 33): faila= 32(D)  failb= 33(D)  OK
> [    8.823547] raid6test: test_disks(32, 34): faila= 32(D)  failb= 34(D)  OK
> [    8.824969] raid6test: test_disks(32, 35): faila= 32(D)  failb= 35(D)  OK
> [    8.826399] raid6test: test_disks(32, 36): faila= 32(D)  failb= 36(D)  OK
> [    8.827823] raid6test: test_disks(32, 37): faila= 32(D)  failb= 37(D)  OK
> [    8.829255] raid6test: test_disks(32, 38): faila= 32(D)  failb= 38(D)  OK
> [    8.830679] raid6test: test_disks(32, 39): faila= 32(D)  failb= 39(D)  OK
> [    8.832101] raid6test: test_disks(32, 40): faila= 32(D)  failb= 40(D)  OK
> [    8.833537] raid6test: test_disks(32, 41): faila= 32(D)  failb= 41(D)  OK
> [    8.834957] raid6test: test_disks(32, 42): faila= 32(D)  failb= 42(D)  OK
> [    8.836387] raid6test: test_disks(32, 43): faila= 32(D)  failb= 43(D)  OK
> [    8.837816] raid6test: test_disks(32, 44): faila= 32(D)  failb= 44(D)  OK
> [    8.839239] raid6test: test_disks(32, 45): faila= 32(D)  failb= 45(D)  OK
> [    8.840662] raid6test: test_disks(32, 46): faila= 32(D)  failb= 46(D)  OK
> [    8.842085] raid6test: test_disks(32, 47): faila= 32(D)  failb= 47(D)  OK
> [    8.843522] raid6test: test_disks(32, 48): faila= 32(D)  failb= 48(D)  OK
> [    8.844936] raid6test: test_disks(32, 49): faila= 32(D)  failb= 49(D)  OK
> [    8.846364] raid6test: test_disks(32, 50): faila= 32(D)  failb= 50(D)  OK
> [    8.847789] raid6test: test_disks(32, 51): faila= 32(D)  failb= 51(D)  OK
> [    8.849219] raid6test: test_disks(32, 52): faila= 32(D)  failb= 52(D)  OK
> [    8.850648] raid6test: test_disks(32, 53): faila= 32(D)  failb= 53(D)  OK
> [    8.852064] raid6test: test_disks(32, 54): faila= 32(D)  failb= 54(D)  OK
> [    8.853501] raid6test: test_disks(32, 55): faila= 32(D)  failb= 55(D)  OK
> [    8.854920] raid6test: test_disks(32, 56): faila= 32(D)  failb= 56(D)  OK
> [    8.856351] raid6test: test_disks(32, 57): faila= 32(D)  failb= 57(D)  OK
> [    8.857777] raid6test: test_disks(32, 58): faila= 32(D)  failb= 58(D)  OK
> [    8.859208] raid6test: test_disks(32, 59): faila= 32(D)  failb= 59(D)  OK
> [    8.860641] raid6test: test_disks(32, 60): faila= 32(D)  failb= 60(D)  OK
> [    8.862063] raid6test: test_disks(32, 61): faila= 32(D)  failb= 61(D)  OK
> [    8.863495] raid6test: test_disks(32, 62): faila= 32(D)  failb= 62(P)  OK
> [    8.864909] raid6test: test_disks(32, 63): faila= 32(D)  failb= 63(Q)  OK
> [    8.866332] raid6test: test_disks(33, 34): faila= 33(D)  failb= 34(D)  OK
> [    8.867753] raid6test: test_disks(33, 35): faila= 33(D)  failb= 35(D)  OK
> [    8.869183] raid6test: test_disks(33, 36): faila= 33(D)  failb= 36(D)  OK
> [    8.870611] raid6test: test_disks(33, 37): faila= 33(D)  failb= 37(D)  OK
> [    8.872031] raid6test: test_disks(33, 38): faila= 33(D)  failb= 38(D)  OK
> [    8.873471] raid6test: test_disks(33, 39): faila= 33(D)  failb= 39(D)  OK
> [    8.874894] raid6test: test_disks(33, 40): faila= 33(D)  failb= 40(D)  OK
> [    8.876319] raid6test: test_disks(33, 41): faila= 33(D)  failb= 41(D)  OK
> [    8.877744] raid6test: test_disks(33, 42): faila= 33(D)  failb= 42(D)  OK
> [    8.879172] raid6test: test_disks(33, 43): faila= 33(D)  failb= 43(D)  OK
> [    8.880597] raid6test: test_disks(33, 44): faila= 33(D)  failb= 44(D)  OK
> [    8.882009] raid6test: test_disks(33, 45): faila= 33(D)  failb= 45(D)  OK
> [    8.883447] raid6test: test_disks(33, 46): faila= 33(D)  failb= 46(D)  OK
> [    8.884872] raid6test: test_disks(33, 47): faila= 33(D)  failb= 47(D)  OK
> [    8.886303] raid6test: test_disks(33, 48): faila= 33(D)  failb= 48(D)  OK
> [    8.887732] raid6test: test_disks(33, 49): faila= 33(D)  failb= 49(D)  OK
> [    8.889162] raid6test: test_disks(33, 50): faila= 33(D)  failb= 50(D)  OK
> [    8.890601] raid6test: test_disks(33, 51): faila= 33(D)  failb= 51(D)  OK
> [    8.892018] raid6test: test_disks(33, 52): faila= 33(D)  failb= 52(D)  OK
> [    8.893449] raid6test: test_disks(33, 53): faila= 33(D)  failb= 53(D)  OK
> [    8.894868] raid6test: test_disks(33, 54): faila= 33(D)  failb= 54(D)  OK
> [    8.896290] raid6test: test_disks(33, 55): faila= 33(D)  failb= 55(D)  OK
> [    8.897717] raid6test: test_disks(33, 56): faila= 33(D)  failb= 56(D)  OK
> [    8.899146] raid6test: test_disks(33, 57): faila= 33(D)  failb= 57(D)  OK
> [    8.900574] raid6test: test_disks(33, 58): faila= 33(D)  failb= 58(D)  OK
> [    8.901995] raid6test: test_disks(33, 59): faila= 33(D)  failb= 59(D)  OK
> [    8.903425] raid6test: test_disks(33, 60): faila= 33(D)  failb= 60(D)  OK
> [    8.904850] raid6test: test_disks(33, 61): faila= 33(D)  failb= 61(D)  OK
> [    8.906274] raid6test: test_disks(33, 62): faila= 33(D)  failb= 62(P)  OK
> [    8.907698] raid6test: test_disks(33, 63): faila= 33(D)  failb= 63(Q)  OK
> [    8.909131] raid6test: test_disks(34, 35): faila= 34(D)  failb= 35(D)  OK
> [    8.910555] raid6test: test_disks(34, 36): faila= 34(D)  failb= 36(D)  OK
> [    8.911973] raid6test: test_disks(34, 37): faila= 34(D)  failb= 37(D)  OK
> [    8.913403] raid6test: test_disks(34, 38): faila= 34(D)  failb= 38(D)  OK
> [    8.914824] raid6test: test_disks(34, 39): faila= 34(D)  failb= 39(D)  OK
> [    8.916249] raid6test: test_disks(34, 40): faila= 34(D)  failb= 40(D)  OK
> [    8.917669] raid6test: test_disks(34, 41): faila= 34(D)  failb= 41(D)  OK
> [    8.919098] raid6test: test_disks(34, 42): faila= 34(D)  failb= 42(D)  OK
> [    8.920527] raid6test: test_disks(34, 43): faila= 34(D)  failb= 43(D)  OK
> [    8.921946] raid6test: test_disks(34, 44): faila= 34(D)  failb= 44(D)  OK
> [    8.923373] raid6test: test_disks(34, 45): faila= 34(D)  failb= 45(D)  OK
> [    8.924801] raid6test: test_disks(34, 46): faila= 34(D)  failb= 46(D)  OK
> [    8.926224] raid6test: test_disks(34, 47): faila= 34(D)  failb= 47(D)  OK
> [    8.927640] raid6test: test_disks(34, 48): faila= 34(D)  failb= 48(D)  OK
> [    8.929069] raid6test: test_disks(34, 49): faila= 34(D)  failb= 49(D)  OK
> [    8.930501] raid6test: test_disks(34, 50): faila= 34(D)  failb= 50(D)  OK
> [    8.931918] raid6test: test_disks(34, 51): faila= 34(D)  failb= 51(D)  OK
> [    8.933351] raid6test: test_disks(34, 52): faila= 34(D)  failb= 52(D)  OK
> [    8.934785] raid6test: test_disks(34, 53): faila= 34(D)  failb= 53(D)  OK
> [    8.936208] raid6test: test_disks(34, 54): faila= 34(D)  failb= 54(D)  OK
> [    8.937641] raid6test: test_disks(34, 55): faila= 34(D)  failb= 55(D)  OK
> [    8.939073] raid6test: test_disks(34, 56): faila= 34(D)  failb= 56(D)  OK
> [    8.940498] raid6test: test_disks(34, 57): faila= 34(D)  failb= 57(D)  OK
> [    8.941912] raid6test: test_disks(34, 58): faila= 34(D)  failb= 58(D)  OK
> [    8.943337] raid6test: test_disks(34, 59): faila= 34(D)  failb= 59(D)  OK
> [    8.944760] raid6test: test_disks(34, 60): faila= 34(D)  failb= 60(D)  OK
> [    8.946189] raid6test: test_disks(34, 61): faila= 34(D)  failb= 61(D)  OK
> [    8.947598] raid6test: test_disks(34, 62): faila= 34(D)  failb= 62(P)  OK
> [    8.949016] raid6test: test_disks(34, 63): faila= 34(D)  failb= 63(Q)  OK
> [    8.950446] raid6test: test_disks(35, 36): faila= 35(D)  failb= 36(D)  OK
> [    8.951866] raid6test: test_disks(35, 37): faila= 35(D)  failb= 37(D)  OK
> [    8.953294] raid6test: test_disks(35, 38): faila= 35(D)  failb= 38(D)  OK
> [    8.954729] raid6test: test_disks(35, 39): faila= 35(D)  failb= 39(D)  OK
> [    8.956156] raid6test: test_disks(35, 40): faila= 35(D)  failb= 40(D)  OK
> [    8.957589] raid6test: test_disks(35, 41): faila= 35(D)  failb= 41(D)  OK
> [    8.959005] raid6test: test_disks(35, 42): faila= 35(D)  failb= 42(D)  OK
> [    8.960444] raid6test: test_disks(35, 43): faila= 35(D)  failb= 43(D)  OK
> [    8.961864] raid6test: test_disks(35, 44): faila= 35(D)  failb= 44(D)  OK
> [    8.963296] raid6test: test_disks(35, 45): faila= 35(D)  failb= 45(D)  OK
> [    8.964713] raid6test: test_disks(35, 46): faila= 35(D)  failb= 46(D)  OK
> [    8.966142] raid6test: test_disks(35, 47): faila= 35(D)  failb= 47(D)  OK
> [    8.967569] raid6test: test_disks(35, 48): faila= 35(D)  failb= 48(D)  OK
> [    8.968987] raid6test: test_disks(35, 49): faila= 35(D)  failb= 49(D)  OK
> [    8.970412] raid6test: test_disks(35, 50): faila= 35(D)  failb= 50(D)  OK
> [    8.971833] raid6test: test_disks(35, 51): faila= 35(D)  failb= 51(D)  OK
> [    8.973269] raid6test: test_disks(35, 52): faila= 35(D)  failb= 52(D)  OK
> [    8.974694] raid6test: test_disks(35, 53): faila= 35(D)  failb= 53(D)  OK
> [    8.976122] raid6test: test_disks(35, 54): faila= 35(D)  failb= 54(D)  OK
> [    8.977544] raid6test: test_disks(35, 55): faila= 35(D)  failb= 55(D)  OK
> [    8.978963] raid6test: test_disks(35, 56): faila= 35(D)  failb= 56(D)  OK
> [    8.980393] raid6test: test_disks(35, 57): faila= 35(D)  failb= 57(D)  OK
> [    8.981816] raid6test: test_disks(35, 58): faila= 35(D)  failb= 58(D)  OK
> [    8.983248] raid6test: test_disks(35, 59): faila= 35(D)  failb= 59(D)  OK
> [    8.984675] raid6test: test_disks(35, 60): faila= 35(D)  failb= 60(D)  OK
> [    8.986104] raid6test: test_disks(35, 61): faila= 35(D)  failb= 61(D)  OK
> [    8.987532] raid6test: test_disks(35, 62): faila= 35(D)  failb= 62(P)  OK
> [    8.988937] raid6test: test_disks(35, 63): faila= 35(D)  failb= 63(Q)  OK
> [    8.990368] raid6test: test_disks(36, 37): faila= 36(D)  failb= 37(D)  OK
> [    8.991787] raid6test: test_disks(36, 38): faila= 36(D)  failb= 38(D)  OK
> [    8.993221] raid6test: test_disks(36, 39): faila= 36(D)  failb= 39(D)  OK
> [    8.994653] raid6test: test_disks(36, 40): faila= 36(D)  failb= 40(D)  OK
> [    8.996080] raid6test: test_disks(36, 41): faila= 36(D)  failb= 41(D)  OK
> [    8.997508] raid6test: test_disks(36, 42): faila= 36(D)  failb= 42(D)  OK
> [    8.998925] raid6test: test_disks(36, 43): faila= 36(D)  failb= 43(D)  OK
> [    9.000355] raid6test: test_disks(36, 44): faila= 36(D)  failb= 44(D)  OK
> [    9.001782] raid6test: test_disks(36, 45): faila= 36(D)  failb= 45(D)  OK
> [    9.003212] raid6test: test_disks(36, 46): faila= 36(D)  failb= 46(D)  OK
> [    9.004642] raid6test: test_disks(36, 47): faila= 36(D)  failb= 47(D)  OK
> [    9.006071] raid6test: test_disks(36, 48): faila= 36(D)  failb= 48(D)  OK
> [    9.007498] raid6test: test_disks(36, 49): faila= 36(D)  failb= 49(D)  OK
> [    9.008907] raid6test: test_disks(36, 50): faila= 36(D)  failb= 50(D)  OK
> [    9.010325] raid6test: test_disks(36, 51): faila= 36(D)  failb= 51(D)  OK
> [    9.011747] raid6test: test_disks(36, 52): faila= 36(D)  failb= 52(D)  OK
> [    9.013179] raid6test: test_disks(36, 53): faila= 36(D)  failb= 53(D)  OK
> [    9.014609] raid6test: test_disks(36, 54): faila= 36(D)  failb= 54(D)  OK
> [    9.016041] raid6test: test_disks(36, 55): faila= 36(D)  failb= 55(D)  OK
> [    9.017471] raid6test: test_disks(36, 56): faila= 36(D)  failb= 56(D)  OK
> [    9.018875] raid6test: test_disks(36, 57): faila= 36(D)  failb= 57(D)  OK
> [    9.020301] raid6test: test_disks(36, 58): faila= 36(D)  failb= 58(D)  OK
> [    9.021729] raid6test: test_disks(36, 59): faila= 36(D)  failb= 59(D)  OK
> [    9.023154] raid6test: test_disks(36, 60): faila= 36(D)  failb= 60(D)  OK
> [    9.024585] raid6test: test_disks(36, 61): faila= 36(D)  failb= 61(D)  OK
> [    9.026008] raid6test: test_disks(36, 62): faila= 36(D)  failb= 62(P)  OK
> [    9.027421] raid6test: test_disks(36, 63): faila= 36(D)  failb= 63(Q)  OK
> [    9.028842] raid6test: test_disks(37, 38): faila= 37(D)  failb= 38(D)  OK
> [    9.030269] raid6test: test_disks(37, 39): faila= 37(D)  failb= 39(D)  OK
> [    9.031690] raid6test: test_disks(37, 40): faila= 37(D)  failb= 40(D)  OK
> [    9.033127] raid6test: test_disks(37, 41): faila= 37(D)  failb= 41(D)  OK
> [    9.034559] raid6test: test_disks(37, 42): faila= 37(D)  failb= 42(D)  OK
> [    9.035987] raid6test: test_disks(37, 43): faila= 37(D)  failb= 43(D)  OK
> [    9.037409] raid6test: test_disks(37, 44): faila= 37(D)  failb= 44(D)  OK
> [    9.038830] raid6test: test_disks(37, 45): faila= 37(D)  failb= 45(D)  OK
> [    9.040253] raid6test: test_disks(37, 46): faila= 37(D)  failb= 46(D)  OK
> [    9.041684] raid6test: test_disks(37, 47): faila= 37(D)  failb= 47(D)  OK
> [    9.043117] raid6test: test_disks(37, 48): faila= 37(D)  failb= 48(D)  OK
> [    9.044543] raid6test: test_disks(37, 49): faila= 37(D)  failb= 49(D)  OK
> [    9.045968] raid6test: test_disks(37, 50): faila= 37(D)  failb= 50(D)  OK
> [    9.047387] raid6test: test_disks(37, 51): faila= 37(D)  failb= 51(D)  OK
> [    9.048808] raid6test: test_disks(37, 52): faila= 37(D)  failb= 52(D)  OK
> [    9.050226] raid6test: test_disks(37, 53): faila= 37(D)  failb= 53(D)  OK
> [    9.051647] raid6test: test_disks(37, 54): faila= 37(D)  failb= 54(D)  OK
> [    9.053078] raid6test: test_disks(37, 55): faila= 37(D)  failb= 55(D)  OK
> [    9.054504] raid6test: test_disks(37, 56): faila= 37(D)  failb= 56(D)  OK
> [    9.055933] raid6test: test_disks(37, 57): faila= 37(D)  failb= 57(D)  OK
> [    9.057358] raid6test: test_disks(37, 58): faila= 37(D)  failb= 58(D)  OK
> [    9.058778] raid6test: test_disks(37, 59): faila= 37(D)  failb= 59(D)  OK
> [    9.060204] raid6test: test_disks(37, 60): faila= 37(D)  failb= 60(D)  OK
> [    9.061629] raid6test: test_disks(37, 61): faila= 37(D)  failb= 61(D)  OK
> [    9.063056] raid6test: test_disks(37, 62): faila= 37(D)  failb= 62(P)  OK
> [    9.064479] raid6test: test_disks(37, 63): faila= 37(D)  failb= 63(Q)  OK
> [    9.065915] raid6test: test_disks(38, 39): faila= 38(D)  failb= 39(D)  OK
> [    9.067332] raid6test: test_disks(38, 40): faila= 38(D)  failb= 40(D)  OK
> [    9.068741] raid6test: test_disks(38, 41): faila= 38(D)  failb= 41(D)  OK
> [    9.071917] raid6test: test_disks(38, 42): faila= 38(D)  failb= 42(D)  OK
> [    9.073340] raid6test: test_disks(38, 43): faila= 38(D)  failb= 43(D)  OK
> [    9.074772] raid6test: test_disks(38, 44): faila= 38(D)  failb= 44(D)  OK
> [    9.076196] raid6test: test_disks(38, 45): faila= 38(D)  failb= 45(D)  OK
> [    9.077620] raid6test: test_disks(38, 46): faila= 38(D)  failb= 46(D)  OK
> [    9.079053] raid6test: test_disks(38, 47): faila= 38(D)  failb= 47(D)  OK
> [    9.080469] raid6test: test_disks(38, 48): faila= 38(D)  failb= 48(D)  OK
> [    9.081882] raid6test: test_disks(38, 49): faila= 38(D)  failb= 49(D)  OK
> [    9.083315] raid6test: test_disks(38, 50): faila= 38(D)  failb= 50(D)  OK
> [    9.084747] raid6test: test_disks(38, 51): faila= 38(D)  failb= 51(D)  OK
> [    9.086172] raid6test: test_disks(38, 52): faila= 38(D)  failb= 52(D)  OK
> [    9.087598] raid6test: test_disks(38, 53): faila= 38(D)  failb= 53(D)  OK
> [    9.089017] raid6test: test_disks(38, 54): faila= 38(D)  failb= 54(D)  OK
> [    9.090440] raid6test: test_disks(38, 55): faila= 38(D)  failb= 55(D)  OK
> [    9.091859] raid6test: test_disks(38, 56): faila= 38(D)  failb= 56(D)  OK
> [    9.093288] raid6test: test_disks(38, 57): faila= 38(D)  failb= 57(D)  OK
> [    9.094710] raid6test: test_disks(38, 58): faila= 38(D)  failb= 58(D)  OK
> [    9.096137] raid6test: test_disks(38, 59): faila= 38(D)  failb= 59(D)  OK
> [    9.097567] raid6test: test_disks(38, 60): faila= 38(D)  failb= 60(D)  OK
> [    9.098983] raid6test: test_disks(38, 61): faila= 38(D)  failb= 61(D)  OK
> [    9.100414] raid6test: test_disks(38, 62): faila= 38(D)  failb= 62(P)  OK
> [    9.101837] raid6test: test_disks(38, 63): faila= 38(D)  failb= 63(Q)  OK
> [    9.103272] raid6test: test_disks(39, 40): faila= 39(D)  failb= 40(D)  OK
> [    9.104698] raid6test: test_disks(39, 41): faila= 39(D)  failb= 41(D)  OK
> [    9.106123] raid6test: test_disks(39, 42): faila= 39(D)  failb= 42(D)  OK
> [    9.107552] raid6test: test_disks(39, 43): faila= 39(D)  failb= 43(D)  OK
> [    9.108978] raid6test: test_disks(39, 44): faila= 39(D)  failb= 44(D)  OK
> [    9.110405] raid6test: test_disks(39, 45): faila= 39(D)  failb= 45(D)  OK
> [    9.111834] raid6test: test_disks(39, 46): faila= 39(D)  failb= 46(D)  OK
> [    9.113272] raid6test: test_disks(39, 47): faila= 39(D)  failb= 47(D)  OK
> [    9.114699] raid6test: test_disks(39, 48): faila= 39(D)  failb= 48(D)  OK
> [    9.116127] raid6test: test_disks(39, 49): faila= 39(D)  failb= 49(D)  OK
> [    9.117555] raid6test: test_disks(39, 50): faila= 39(D)  failb= 50(D)  OK
> [    9.118973] raid6test: test_disks(39, 51): faila= 39(D)  failb= 51(D)  OK
> [    9.120400] raid6test: test_disks(39, 52): faila= 39(D)  failb= 52(D)  OK
> [    9.121823] raid6test: test_disks(39, 53): faila= 39(D)  failb= 53(D)  OK
> [    9.123252] raid6test: test_disks(39, 54): faila= 39(D)  failb= 54(D)  OK
> [    9.124673] raid6test: test_disks(39, 55): faila= 39(D)  failb= 55(D)  OK
> [    9.126102] raid6test: test_disks(39, 56): faila= 39(D)  failb= 56(D)  OK
> [    9.127526] raid6test: test_disks(39, 57): faila= 39(D)  failb= 57(D)  OK
> [    9.128945] raid6test: test_disks(39, 58): faila= 39(D)  failb= 58(D)  OK
> [    9.130374] raid6test: test_disks(39, 59): faila= 39(D)  failb= 59(D)  OK
> [    9.131796] raid6test: test_disks(39, 60): faila= 39(D)  failb= 60(D)  OK
> [    9.133232] raid6test: test_disks(39, 61): faila= 39(D)  failb= 61(D)  OK
> [    9.134655] raid6test: test_disks(39, 62): faila= 39(D)  failb= 62(P)  OK
> [    9.136078] raid6test: test_disks(39, 63): faila= 39(D)  failb= 63(Q)  OK
> [    9.137496] raid6test: test_disks(40, 41): faila= 40(D)  failb= 41(D)  OK
> [    9.138909] raid6test: test_disks(40, 42): faila= 40(D)  failb= 42(D)  OK
> [    9.140329] raid6test: test_disks(40, 43): faila= 40(D)  failb= 43(D)  OK
> [    9.141759] raid6test: test_disks(40, 44): faila= 40(D)  failb= 44(D)  OK
> [    9.143183] raid6test: test_disks(40, 45): faila= 40(D)  failb= 45(D)  OK
> [    9.144604] raid6test: test_disks(40, 46): faila= 40(D)  failb= 46(D)  OK
> [    9.146043] raid6test: test_disks(40, 47): faila= 40(D)  failb= 47(D)  OK
> [    9.147465] raid6test: test_disks(40, 48): faila= 40(D)  failb= 48(D)  OK
> [    9.148875] raid6test: test_disks(40, 49): faila= 40(D)  failb= 49(D)  OK
> [    9.150301] raid6test: test_disks(40, 50): faila= 40(D)  failb= 50(D)  OK
> [    9.151726] raid6test: test_disks(40, 51): faila= 40(D)  failb= 51(D)  OK
> [    9.153155] raid6test: test_disks(40, 52): faila= 40(D)  failb= 52(D)  OK
> [    9.154584] raid6test: test_disks(40, 53): faila= 40(D)  failb= 53(D)  OK
> [    9.156013] raid6test: test_disks(40, 54): faila= 40(D)  failb= 54(D)  OK
> [    9.157437] raid6test: test_disks(40, 55): faila= 40(D)  failb= 55(D)  OK
> [    9.158853] raid6test: test_disks(40, 56): faila= 40(D)  failb= 56(D)  OK
> [    9.160277] raid6test: test_disks(40, 57): faila= 40(D)  failb= 57(D)  OK
> [    9.161704] raid6test: test_disks(40, 58): faila= 40(D)  failb= 58(D)  OK
> [    9.163139] raid6test: test_disks(40, 59): faila= 40(D)  failb= 59(D)  OK
> [    9.164571] raid6test: test_disks(40, 60): faila= 40(D)  failb= 60(D)  OK
> [    9.165997] raid6test: test_disks(40, 61): faila= 40(D)  failb= 61(D)  OK
> [    9.167407] raid6test: test_disks(40, 62): faila= 40(D)  failb= 62(P)  OK
> [    9.168815] raid6test: test_disks(40, 63): faila= 40(D)  failb= 63(Q)  OK
> [    9.170245] raid6test: test_disks(41, 42): faila= 41(D)  failb= 42(D)  OK
> [    9.171675] raid6test: test_disks(41, 43): faila= 41(D)  failb= 43(D)  OK
> [    9.173106] raid6test: test_disks(41, 44): faila= 41(D)  failb= 44(D)  OK
> [    9.174531] raid6test: test_disks(41, 45): faila= 41(D)  failb= 45(D)  OK
> [    9.175966] raid6test: test_disks(41, 46): faila= 41(D)  failb= 46(D)  OK
> [    9.177381] raid6test: test_disks(41, 47): faila= 41(D)  failb= 47(D)  OK
> [    9.178801] raid6test: test_disks(41, 48): faila= 41(D)  failb= 48(D)  OK
> [    9.180237] raid6test: test_disks(41, 49): faila= 41(D)  failb= 49(D)  OK
> [    9.181667] raid6test: test_disks(41, 50): faila= 41(D)  failb= 50(D)  OK
> [    9.183101] raid6test: test_disks(41, 51): faila= 41(D)  failb= 51(D)  OK
> [    9.184530] raid6test: test_disks(41, 52): faila= 41(D)  failb= 52(D)  OK
> [    9.185958] raid6test: test_disks(41, 53): faila= 41(D)  failb= 53(D)  OK
> [    9.187386] raid6test: test_disks(41, 54): faila= 41(D)  failb= 54(D)  OK
> [    9.188808] raid6test: test_disks(41, 55): faila= 41(D)  failb= 55(D)  OK
> [    9.190237] raid6test: test_disks(41, 56): faila= 41(D)  failb= 56(D)  OK
> [    9.191655] raid6test: test_disks(41, 57): faila= 41(D)  failb= 57(D)  OK
> [    9.193084] raid6test: test_disks(41, 58): faila= 41(D)  failb= 58(D)  OK
> [    9.194511] raid6test: test_disks(41, 59): faila= 41(D)  failb= 59(D)  OK
> [    9.195946] raid6test: test_disks(41, 60): faila= 41(D)  failb= 60(D)  OK
> [    9.197368] raid6test: test_disks(41, 61): faila= 41(D)  failb= 61(D)  OK
> [    9.198782] raid6test: test_disks(41, 62): faila= 41(D)  failb= 62(P)  OK
> [    9.200207] raid6test: test_disks(41, 63): faila= 41(D)  failb= 63(Q)  OK
> [    9.201636] raid6test: test_disks(42, 43): faila= 42(D)  failb= 43(D)  OK
> [    9.203069] raid6test: test_disks(42, 44): faila= 42(D)  failb= 44(D)  OK
> [    9.204495] raid6test: test_disks(42, 45): faila= 42(D)  failb= 45(D)  OK
> [    9.205918] raid6test: test_disks(42, 46): faila= 42(D)  failb= 46(D)  OK
> [    9.207332] raid6test: test_disks(42, 47): faila= 42(D)  failb= 47(D)  OK
> [    9.208753] raid6test: test_disks(42, 48): faila= 42(D)  failb= 48(D)  OK
> [    9.210180] raid6test: test_disks(42, 49): faila= 42(D)  failb= 49(D)  OK
> [    9.211610] raid6test: test_disks(42, 50): faila= 42(D)  failb= 50(D)  OK
> [    9.213034] raid6test: test_disks(42, 51): faila= 42(D)  failb= 51(D)  OK
> [    9.214470] raid6test: test_disks(42, 52): faila= 42(D)  failb= 52(D)  OK
> [    9.215898] raid6test: test_disks(42, 53): faila= 42(D)  failb= 53(D)  OK
> [    9.217324] raid6test: test_disks(42, 54): faila= 42(D)  failb= 54(D)  OK
> [    9.218742] raid6test: test_disks(42, 55): faila= 42(D)  failb= 55(D)  OK
> [    9.220174] raid6test: test_disks(42, 56): faila= 42(D)  failb= 56(D)  OK
> [    9.221600] raid6test: test_disks(42, 57): faila= 42(D)  failb= 57(D)  OK
> [    9.223032] raid6test: test_disks(42, 58): faila= 42(D)  failb= 58(D)  OK
> [    9.224465] raid6test: test_disks(42, 59): faila= 42(D)  failb= 59(D)  OK
> [    9.225898] raid6test: test_disks(42, 60): faila= 42(D)  failb= 60(D)  OK
> [    9.227319] raid6test: test_disks(42, 61): faila= 42(D)  failb= 61(D)  OK
> [    9.228730] raid6test: test_disks(42, 62): faila= 42(D)  failb= 62(P)  OK
> [    9.230155] raid6test: test_disks(42, 63): faila= 42(D)  failb= 63(Q)  OK
> [    9.231589] raid6test: test_disks(43, 44): faila= 43(D)  failb= 44(D)  OK
> [    9.233021] raid6test: test_disks(43, 45): faila= 43(D)  failb= 45(D)  OK
> [    9.234452] raid6test: test_disks(43, 46): faila= 43(D)  failb= 46(D)  OK
> [    9.235878] raid6test: test_disks(43, 47): faila= 43(D)  failb= 47(D)  OK
> [    9.237300] raid6test: test_disks(43, 48): faila= 43(D)  failb= 48(D)  OK
> [    9.238721] raid6test: test_disks(43, 49): faila= 43(D)  failb= 49(D)  OK
> [    9.240152] raid6test: test_disks(43, 50): faila= 43(D)  failb= 50(D)  OK
> [    9.241577] raid6test: test_disks(43, 51): faila= 43(D)  failb= 51(D)  OK
> [    9.243013] raid6test: test_disks(43, 52): faila= 43(D)  failb= 52(D)  OK
> [    9.244443] raid6test: test_disks(43, 53): faila= 43(D)  failb= 53(D)  OK
> [    9.245870] raid6test: test_disks(43, 54): faila= 43(D)  failb= 54(D)  OK
> [    9.247295] raid6test: test_disks(43, 55): faila= 43(D)  failb= 55(D)  OK
> [    9.248714] raid6test: test_disks(43, 56): faila= 43(D)  failb= 56(D)  OK
> [    9.250138] raid6test: test_disks(43, 57): faila= 43(D)  failb= 57(D)  OK
> [    9.251570] raid6test: test_disks(43, 58): faila= 43(D)  failb= 58(D)  OK
> [    9.252998] raid6test: test_disks(43, 59): faila= 43(D)  failb= 59(D)  OK
> [    9.254418] raid6test: test_disks(43, 60): faila= 43(D)  failb= 60(D)  OK
> [    9.255845] raid6test: test_disks(43, 61): faila= 43(D)  failb= 61(D)  OK
> [    9.257261] raid6test: test_disks(43, 62): faila= 43(D)  failb= 62(P)  OK
> [    9.258682] raid6test: test_disks(43, 63): faila= 43(D)  failb= 63(Q)  OK
> [    9.260114] raid6test: test_disks(44, 45): faila= 44(D)  failb= 45(D)  OK
> [    9.261541] raid6test: test_disks(44, 46): faila= 44(D)  failb= 46(D)  OK
> [    9.262973] raid6test: test_disks(44, 47): faila= 44(D)  failb= 47(D)  OK
> [    9.264399] raid6test: test_disks(44, 48): faila= 44(D)  failb= 48(D)  OK
> [    9.265837] raid6test: test_disks(44, 49): faila= 44(D)  failb= 49(D)  OK
> [    9.267265] raid6test: test_disks(44, 50): faila= 44(D)  failb= 50(D)  OK
> [    9.268683] raid6test: test_disks(44, 51): faila= 44(D)  failb= 51(D)  OK
> [    9.270109] raid6test: test_disks(44, 52): faila= 44(D)  failb= 52(D)  OK
> [    9.271526] raid6test: test_disks(44, 53): faila= 44(D)  failb= 53(D)  OK
> [    9.272958] raid6test: test_disks(44, 54): faila= 44(D)  failb= 54(D)  OK
> [    9.274371] raid6test: test_disks(44, 55): faila= 44(D)  failb= 55(D)  OK
> [    9.275805] raid6test: test_disks(44, 56): faila= 44(D)  failb= 56(D)  OK
> [    9.277227] raid6test: test_disks(44, 57): faila= 44(D)  failb= 57(D)  OK
> [    9.278651] raid6test: test_disks(44, 58): faila= 44(D)  failb= 58(D)  OK
> [    9.280079] raid6test: test_disks(44, 59): faila= 44(D)  failb= 59(D)  OK
> [    9.281506] raid6test: test_disks(44, 60): faila= 44(D)  failb= 60(D)  OK
> [    9.282940] raid6test: test_disks(44, 61): faila= 44(D)  failb= 61(D)  OK
> [    9.284360] raid6test: test_disks(44, 62): faila= 44(D)  failb= 62(P)  OK
> [    9.285798] raid6test: test_disks(44, 63): faila= 44(D)  failb= 63(Q)  OK
> [    9.287223] raid6test: test_disks(45, 46): faila= 45(D)  failb= 46(D)  OK
> [    9.288644] raid6test: test_disks(45, 47): faila= 45(D)  failb= 47(D)  OK
> [    9.290065] raid6test: test_disks(45, 48): faila= 45(D)  failb= 48(D)  OK
> [    9.291494] raid6test: test_disks(45, 49): faila= 45(D)  failb= 49(D)  OK
> [    9.292926] raid6test: test_disks(45, 50): faila= 45(D)  failb= 50(D)  OK
> [    9.294347] raid6test: test_disks(45, 51): faila= 45(D)  failb= 51(D)  OK
> [    9.295784] raid6test: test_disks(45, 52): faila= 45(D)  failb= 52(D)  OK
> [    9.297203] raid6test: test_disks(45, 53): faila= 45(D)  failb= 53(D)  OK
> [    9.298630] raid6test: test_disks(45, 54): faila= 45(D)  failb= 54(D)  OK
> [    9.300052] raid6test: test_disks(45, 55): faila= 45(D)  failb= 55(D)  OK
> [    9.301478] raid6test: test_disks(45, 56): faila= 45(D)  failb= 56(D)  OK
> [    9.302905] raid6test: test_disks(45, 57): faila= 45(D)  failb= 57(D)  OK
> [    9.304324] raid6test: test_disks(45, 58): faila= 45(D)  failb= 58(D)  OK
> [    9.305767] raid6test: test_disks(45, 59): faila= 45(D)  failb= 59(D)  OK
> [    9.307190] raid6test: test_disks(45, 60): faila= 45(D)  failb= 60(D)  OK
> [    9.308618] raid6test: test_disks(45, 61): faila= 45(D)  failb= 61(D)  OK
> [    9.310040] raid6test: test_disks(45, 62): faila= 45(D)  failb= 62(P)  OK
> [    9.311459] raid6test: test_disks(45, 63): faila= 45(D)  failb= 63(Q)  OK
> [    9.312893] raid6test: test_disks(46, 47): faila= 46(D)  failb= 47(D)  OK
> [    9.314312] raid6test: test_disks(46, 48): faila= 46(D)  failb= 48(D)  OK
> [    9.315744] raid6test: test_disks(46, 49): faila= 46(D)  failb= 49(D)  OK
> [    9.317161] raid6test: test_disks(46, 50): faila= 46(D)  failb= 50(D)  OK
> [    9.318579] raid6test: test_disks(46, 51): faila= 46(D)  failb= 51(D)  OK
> [    9.320008] raid6test: test_disks(46, 52): faila= 46(D)  failb= 52(D)  OK
> [    9.321436] raid6test: test_disks(46, 53): faila= 46(D)  failb= 53(D)  OK
> [    9.322865] raid6test: test_disks(46, 54): faila= 46(D)  failb= 54(D)  OK
> [    9.324285] raid6test: test_disks(46, 55): faila= 46(D)  failb= 55(D)  OK
> [    9.325718] raid6test: test_disks(46, 56): faila= 46(D)  failb= 56(D)  OK
> [    9.327138] raid6test: test_disks(46, 57): faila= 46(D)  failb= 57(D)  OK
> [    9.330318] raid6test: test_disks(46, 58): faila= 46(D)  failb= 58(D)  OK
> [    9.331737] raid6test: test_disks(46, 59): faila= 46(D)  failb= 59(D)  OK
> [    9.333165] raid6test: test_disks(46, 60): faila= 46(D)  failb= 60(D)  OK
> [    9.334593] raid6test: test_disks(46, 61): faila= 46(D)  failb= 61(D)  OK
> [    9.336019] raid6test: test_disks(46, 62): faila= 46(D)  failb= 62(P)  OK
> [    9.337424] raid6test: test_disks(46, 63): faila= 46(D)  failb= 63(Q)  OK
> [    9.338849] raid6test: test_disks(47, 48): faila= 47(D)  failb= 48(D)  OK
> [    9.340278] raid6test: test_disks(47, 49): faila= 47(D)  failb= 49(D)  OK
> [    9.341707] raid6test: test_disks(47, 50): faila= 47(D)  failb= 50(D)  OK
> [    9.343141] raid6test: test_disks(47, 51): faila= 47(D)  failb= 51(D)  OK
> [    9.344572] raid6test: test_disks(47, 52): faila= 47(D)  failb= 52(D)  OK
> [    9.346002] raid6test: test_disks(47, 53): faila= 47(D)  failb= 53(D)  OK
> [    9.347415] raid6test: test_disks(47, 54): faila= 47(D)  failb= 54(D)  OK
> [    9.348844] raid6test: test_disks(47, 55): faila= 47(D)  failb= 55(D)  OK
> [    9.350273] raid6test: test_disks(47, 56): faila= 47(D)  failb= 56(D)  OK
> [    9.351700] raid6test: test_disks(47, 57): faila= 47(D)  failb= 57(D)  OK
> [    9.353136] raid6test: test_disks(47, 58): faila= 47(D)  failb= 58(D)  OK
> [    9.354566] raid6test: test_disks(47, 59): faila= 47(D)  failb= 59(D)  OK
> [    9.355997] raid6test: test_disks(47, 60): faila= 47(D)  failb= 60(D)  OK
> [    9.357421] raid6test: test_disks(47, 61): faila= 47(D)  failb= 61(D)  OK
> [    9.358847] raid6test: test_disks(47, 62): faila= 47(D)  failb= 62(P)  OK
> [    9.360274] raid6test: test_disks(47, 63): faila= 47(D)  failb= 63(Q)  OK
> [    9.361704] raid6test: test_disks(48, 49): faila= 48(D)  failb= 49(D)  OK
> [    9.363134] raid6test: test_disks(48, 50): faila= 48(D)  failb= 50(D)  OK
> [    9.364562] raid6test: test_disks(48, 51): faila= 48(D)  failb= 51(D)  OK
> [    9.365984] raid6test: test_disks(48, 52): faila= 48(D)  failb= 52(D)  OK
> [    9.367412] raid6test: test_disks(48, 53): faila= 48(D)  failb= 53(D)  OK
> [    9.368838] raid6test: test_disks(48, 54): faila= 48(D)  failb= 54(D)  OK
> [    9.370268] raid6test: test_disks(48, 55): faila= 48(D)  failb= 55(D)  OK
> [    9.371694] raid6test: test_disks(48, 56): faila= 48(D)  failb= 56(D)  OK
> [    9.373130] raid6test: test_disks(48, 57): faila= 48(D)  failb= 57(D)  OK
> [    9.374560] raid6test: test_disks(48, 58): faila= 48(D)  failb= 58(D)  OK
> [    9.375987] raid6test: test_disks(48, 59): faila= 48(D)  failb= 59(D)  OK
> [    9.377407] raid6test: test_disks(48, 60): faila= 48(D)  failb= 60(D)  OK
> [    9.378832] raid6test: test_disks(48, 61): faila= 48(D)  failb= 61(D)  OK
> [    9.380252] raid6test: test_disks(48, 62): faila= 48(D)  failb= 62(P)  OK
> [    9.381673] raid6test: test_disks(48, 63): faila= 48(D)  failb= 63(Q)  OK
> [    9.383104] raid6test: test_disks(49, 50): faila= 49(D)  failb= 50(D)  OK
> [    9.384533] raid6test: test_disks(49, 51): faila= 49(D)  failb= 51(D)  OK
> [    9.385961] raid6test: test_disks(49, 52): faila= 49(D)  failb= 52(D)  OK
> [    9.387380] raid6test: test_disks(49, 53): faila= 49(D)  failb= 53(D)  OK
> [    9.388798] raid6test: test_disks(49, 54): faila= 49(D)  failb= 54(D)  OK
> [    9.390227] raid6test: test_disks(49, 55): faila= 49(D)  failb= 55(D)  OK
> [    9.391647] raid6test: test_disks(49, 56): faila= 49(D)  failb= 56(D)  OK
> [    9.393080] raid6test: test_disks(49, 57): faila= 49(D)  failb= 57(D)  OK
> [    9.394507] raid6test: test_disks(49, 58): faila= 49(D)  failb= 58(D)  OK
> [    9.395940] raid6test: test_disks(49, 59): faila= 49(D)  failb= 59(D)  OK
> [    9.397358] raid6test: test_disks(49, 60): faila= 49(D)  failb= 60(D)  OK
> [    9.398780] raid6test: test_disks(49, 61): faila= 49(D)  failb= 61(D)  OK
> [    9.400206] raid6test: test_disks(49, 62): faila= 49(D)  failb= 62(P)  OK
> [    9.401624] raid6test: test_disks(49, 63): faila= 49(D)  failb= 63(Q)  OK
> [    9.403058] raid6test: test_disks(50, 51): faila= 50(D)  failb= 51(D)  OK
> [    9.404480] raid6test: test_disks(50, 52): faila= 50(D)  failb= 52(D)  OK
> [    9.405910] raid6test: test_disks(50, 53): faila= 50(D)  failb= 53(D)  OK
> [    9.407333] raid6test: test_disks(50, 54): faila= 50(D)  failb= 54(D)  OK
> [    9.408755] raid6test: test_disks(50, 55): faila= 50(D)  failb= 55(D)  OK
> [    9.410183] raid6test: test_disks(50, 56): faila= 50(D)  failb= 56(D)  OK
> [    9.411611] raid6test: test_disks(50, 57): faila= 50(D)  failb= 57(D)  OK
> [    9.413041] raid6test: test_disks(50, 58): faila= 50(D)  failb= 58(D)  OK
> [    9.414470] raid6test: test_disks(50, 59): faila= 50(D)  failb= 59(D)  OK
> [    9.415898] raid6test: test_disks(50, 60): faila= 50(D)  failb= 60(D)  OK
> [    9.417323] raid6test: test_disks(50, 61): faila= 50(D)  failb= 61(D)  OK
> [    9.418741] raid6test: test_disks(50, 62): faila= 50(D)  failb= 62(P)  OK
> [    9.420167] raid6test: test_disks(50, 63): faila= 50(D)  failb= 63(Q)  OK
> [    9.421595] raid6test: test_disks(51, 52): faila= 51(D)  failb= 52(D)  OK
> [    9.423025] raid6test: test_disks(51, 53): faila= 51(D)  failb= 53(D)  OK
> [    9.424452] raid6test: test_disks(51, 54): faila= 51(D)  failb= 54(D)  OK
> [    9.425872] raid6test: test_disks(51, 55): faila= 51(D)  failb= 55(D)  OK
> [    9.427294] raid6test: test_disks(51, 56): faila= 51(D)  failb= 56(D)  OK
> [    9.428716] raid6test: test_disks(51, 57): faila= 51(D)  failb= 57(D)  OK
> [    9.430145] raid6test: test_disks(51, 58): faila= 51(D)  failb= 58(D)  OK
> [    9.431573] raid6test: test_disks(51, 59): faila= 51(D)  failb= 59(D)  OK
> [    9.433001] raid6test: test_disks(51, 60): faila= 51(D)  failb= 60(D)  OK
> [    9.434421] raid6test: test_disks(51, 61): faila= 51(D)  failb= 61(D)  OK
> [    9.435848] raid6test: test_disks(51, 62): faila= 51(D)  failb= 62(P)  OK
> [    9.437272] raid6test: test_disks(51, 63): faila= 51(D)  failb= 63(Q)  OK
> [    9.438691] raid6test: test_disks(52, 53): faila= 52(D)  failb= 53(D)  OK
> [    9.440121] raid6test: test_disks(52, 54): faila= 52(D)  failb= 54(D)  OK
> [    9.441551] raid6test: test_disks(52, 55): faila= 52(D)  failb= 55(D)  OK
> [    9.442983] raid6test: test_disks(52, 56): faila= 52(D)  failb= 56(D)  OK
> [    9.444406] raid6test: test_disks(52, 57): faila= 52(D)  failb= 57(D)  OK
> [    9.445841] raid6test: test_disks(52, 58): faila= 52(D)  failb= 58(D)  OK
> [    9.447267] raid6test: test_disks(52, 59): faila= 52(D)  failb= 59(D)  OK
> [    9.448694] raid6test: test_disks(52, 60): faila= 52(D)  failb= 60(D)  OK
> [    9.450119] raid6test: test_disks(52, 61): faila= 52(D)  failb= 61(D)  OK
> [    9.451545] raid6test: test_disks(52, 62): faila= 52(D)  failb= 62(P)  OK
> [    9.452967] raid6test: test_disks(52, 63): faila= 52(D)  failb= 63(Q)  OK
> [    9.454388] raid6test: test_disks(53, 54): faila= 53(D)  failb= 54(D)  OK
> [    9.455816] raid6test: test_disks(53, 55): faila= 53(D)  failb= 55(D)  OK
> [    9.457238] raid6test: test_disks(53, 56): faila= 53(D)  failb= 56(D)  OK
> [    9.458660] raid6test: test_disks(53, 57): faila= 53(D)  failb= 57(D)  OK
> [    9.460087] raid6test: test_disks(53, 58): faila= 53(D)  failb= 58(D)  OK
> [    9.461512] raid6test: test_disks(53, 59): faila= 53(D)  failb= 59(D)  OK
> [    9.462941] raid6test: test_disks(53, 60): faila= 53(D)  failb= 60(D)  OK
> [    9.464364] raid6test: test_disks(53, 61): faila= 53(D)  failb= 61(D)  OK
> [    9.465796] raid6test: test_disks(53, 62): faila= 53(D)  failb= 62(P)  OK
> [    9.467207] raid6test: test_disks(53, 63): faila= 53(D)  failb= 63(Q)  OK
> [    9.468629] raid6test: test_disks(54, 55): faila= 54(D)  failb= 55(D)  OK
> [    9.470060] raid6test: test_disks(54, 56): faila= 54(D)  failb= 56(D)  OK
> [    9.471487] raid6test: test_disks(54, 57): faila= 54(D)  failb= 57(D)  OK
> [    9.472921] raid6test: test_disks(54, 58): faila= 54(D)  failb= 58(D)  OK
> [    9.474336] raid6test: test_disks(54, 59): faila= 54(D)  failb= 59(D)  OK
> [    9.475772] raid6test: test_disks(54, 60): faila= 54(D)  failb= 60(D)  OK
> [    9.477201] raid6test: test_disks(54, 61): faila= 54(D)  failb= 61(D)  OK
> [    9.478622] raid6test: test_disks(54, 62): faila= 54(D)  failb= 62(P)  OK
> [    9.480045] raid6test: test_disks(54, 63): faila= 54(D)  failb= 63(Q)  OK
> [    9.481472] raid6test: test_disks(55, 56): faila= 55(D)  failb= 56(D)  OK
> [    9.482902] raid6test: test_disks(55, 57): faila= 55(D)  failb= 57(D)  OK
> [    9.484325] raid6test: test_disks(55, 58): faila= 55(D)  failb= 58(D)  OK
> [    9.485763] raid6test: test_disks(55, 59): faila= 55(D)  failb= 59(D)  OK
> [    9.487182] raid6test: test_disks(55, 60): faila= 55(D)  failb= 60(D)  OK
> [    9.488601] raid6test: test_disks(55, 61): faila= 55(D)  failb= 61(D)  OK
> [    9.490024] raid6test: test_disks(55, 62): faila= 55(D)  failb= 62(P)  OK
> [    9.491446] raid6test: test_disks(55, 63): faila= 55(D)  failb= 63(Q)  OK
> [    9.492880] raid6test: test_disks(56, 57): faila= 56(D)  failb= 57(D)  OK
> [    9.494298] raid6test: test_disks(56, 58): faila= 56(D)  failb= 58(D)  OK
> [    9.495730] raid6test: test_disks(56, 59): faila= 56(D)  failb= 59(D)  OK
> [    9.497152] raid6test: test_disks(56, 60): faila= 56(D)  failb= 60(D)  OK
> [    9.498577] raid6test: test_disks(56, 61): faila= 56(D)  failb= 61(D)  OK
> [    9.499997] raid6test: test_disks(56, 62): faila= 56(D)  failb= 62(P)  OK
> [    9.501411] raid6test: test_disks(56, 63): faila= 56(D)  failb= 63(Q)  OK
> [    9.502847] raid6test: test_disks(57, 58): faila= 57(D)  failb= 58(D)  OK
> [    9.504267] raid6test: test_disks(57, 59): faila= 57(D)  failb= 59(D)  OK
> [    9.505705] raid6test: test_disks(57, 60): faila= 57(D)  failb= 60(D)  OK
> [    9.507128] raid6test: test_disks(57, 61): faila= 57(D)  failb= 61(D)  OK
> [    9.508552] raid6test: test_disks(57, 62): faila= 57(D)  failb= 62(P)  OK
> [    9.509976] raid6test: test_disks(57, 63): faila= 57(D)  failb= 63(Q)  OK
> [    9.511397] raid6test: test_disks(58, 59): faila= 58(D)  failb= 59(D)  OK
> [    9.512834] raid6test: test_disks(58, 60): faila= 58(D)  failb= 60(D)  OK
> [    9.514255] raid6test: test_disks(58, 61): faila= 58(D)  failb= 61(D)  OK
> [    9.515676] raid6test: test_disks(58, 62): faila= 58(D)  failb= 62(P)  OK
> [    9.517098] raid6test: test_disks(58, 63): faila= 58(D)  failb= 63(Q)  OK
> [    9.518522] raid6test: test_disks(59, 60): faila= 59(D)  failb= 60(D)  OK
> [    9.519950] raid6test: test_disks(59, 61): faila= 59(D)  failb= 61(D)  OK
> [    9.521365] raid6test: test_disks(59, 62): faila= 59(D)  failb= 62(P)  OK
> [    9.522795] raid6test: test_disks(59, 63): faila= 59(D)  failb= 63(Q)  OK
> [    9.524219] raid6test: test_disks(60, 61): faila= 60(D)  failb= 61(D)  OK
> [    9.525638] raid6test: test_disks(60, 62): faila= 60(D)  failb= 62(P)  OK
> [    9.527059] raid6test: test_disks(60, 63): faila= 60(D)  failb= 63(Q)  OK
> [    9.528485] raid6test: test_disks(61, 62): faila= 61(D)  failb= 62(P)  OK
> [    9.529906] raid6test: test_disks(61, 63): faila= 61(D)  failb= 63(Q)  OK
> [    9.531319] raid6test: test_disks(62, 63): faila= 62(P)  failb= 63(Q)  OK
> [    9.532310] raid6test: 
> [    9.532860] raid6test: complete (2429 tests, 0 failures)
> [    9.534650] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
> [    9.536959] debug: unmapping init [mem 0xc337b000-0xc35dafff]
> [    9.545749] random: init urandom read with 13 bits of entropy available
> [    9.554656] hostname (139) used greatest stack depth: 6764 bytes left
> [    9.590456] plymouthd (148) used greatest stack depth: 6696 bytes left
> [    9.644089] init: Failed to create pty - disabling logging for job
> [    9.645133] init: Temporary process spawn error: No space left on device
> [    9.678908] init: mounted-tmp main process (168) terminated with status 32
> [   70.950868] reboot: Restarting system
> Elapsed time: 80
> qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r3-0405/90585a71ecf3285bc73d54e37080c3bb21583594/vmlinuz-3.14.0-rc1-00088-g90585a7 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-r3-0405/linux-devel:devel-roam-i386-201404051825:90585a71ecf3285bc73d54e37080c3bb21583594:bisect-linux6/.vmlinuz-90585a71ecf3285bc73d54e37080c3bb21583594-20140407114225-1-lkp-ib04 branch=linux-devel/devel-roam-i386-201404051825 BOOT_IMAGE=/kernel/i386-randconfig-r3-0405/90585a71ecf3285bc73d54e37080c3bb21583594/vmlinuz-3.14.0-rc1-00088-g90585a7 drbd.minor_count=8'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1,hostfwd=tcp::12889-:22 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-quantal-lkp-ib04-21 -serial file:/dev/shm/kboot/serial-quantal-lkp-ib04-21 -daemonize -display none -monitor null 
> 
> 


> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 3.14.0-rc1 Kernel Configuration
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> # CONFIG_ZONE_DMA32 is not set
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_X86_32_SMP=y
> CONFIG_X86_HT=y
> CONFIG_X86_32_LAZY_GS=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_CONSTRUCTORS=y
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> # CONFIG_COMPILE_TEST is not set
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> CONFIG_KERNEL_LZMA=y
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SWAP is not set
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> # CONFIG_FHANDLE is not set
> CONFIG_AUDIT=y
> # CONFIG_AUDITSYSCALL is not set
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_IRQ_DOMAIN=y
> CONFIG_IRQ_DOMAIN_DEBUG=y
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> # CONFIG_NO_HZ is not set
> # CONFIG_HIGH_RES_TIMERS is not set
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> # CONFIG_BSD_PROCESS_ACCT is not set
> # CONFIG_TASKSTATS is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_RCU_FANOUT=32
> CONFIG_RCU_FANOUT_LEAF=16
> # CONFIG_RCU_FANOUT_EXACT is not set
> CONFIG_TREE_RCU_TRACE=y
> # CONFIG_RCU_NOCB_CPU is not set
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> # CONFIG_CGROUPS is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> # CONFIG_UTS_NS is not set
> # CONFIG_IPC_NS is not set
> CONFIG_USER_NS=y
> # CONFIG_PID_NS is not set
> CONFIG_NET_NS=y
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> # CONFIG_RELAY is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> CONFIG_RD_LZ4=y
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> # CONFIG_EXPERT is not set
> CONFIG_UID16=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_PCI_QUIRKS=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> CONFIG_COMPAT_BRK=y
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLUB_CPU_PARTIAL is not set
> CONFIG_PROFILING=y
> # CONFIG_OPROFILE is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_JUMP_LABEL is not set
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_HAVE_CC_STACKPROTECTOR=y
> # CONFIG_CC_STACKPROTECTOR is not set
> CONFIG_CC_STACKPROTECTOR_NONE=y
> # CONFIG_CC_STACKPROTECTOR_REGULAR is not set
> # CONFIG_CC_STACKPROTECTOR_STRONG is not set
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_HAVE_ARCH_SOFT_DIRTY=y
> CONFIG_MODULES_USE_ELF_REL=y
> CONFIG_CLONE_BACKWARDS=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_OLD_SIGACTION=y
> 
> #
> # GCOV-based kernel profiling
> #
> CONFIG_GCOV_KERNEL=y
> CONFIG_GCOV_PROFILE_ALL=y
> # CONFIG_GCOV_FORMAT_AUTODETECT is not set
> CONFIG_GCOV_FORMAT_3_4=y
> # CONFIG_GCOV_FORMAT_4_7 is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_SYSTEM_TRUSTED_KEYRING=y
> # CONFIG_MODULES is not set
> CONFIG_BLOCK=y
> # CONFIG_LBDAF is not set
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> CONFIG_BLK_DEV_INTEGRITY=y
> CONFIG_BLK_CMDLINE_PARSER=y
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> CONFIG_ACORN_PARTITION=y
> CONFIG_ACORN_PARTITION_CUMANA=y
> # CONFIG_ACORN_PARTITION_EESOX is not set
> # CONFIG_ACORN_PARTITION_ICS is not set
> # CONFIG_ACORN_PARTITION_ADFS is not set
> # CONFIG_ACORN_PARTITION_POWERTEC is not set
> # CONFIG_ACORN_PARTITION_RISCIX is not set
> CONFIG_AIX_PARTITION=y
> # CONFIG_OSF_PARTITION is not set
> CONFIG_AMIGA_PARTITION=y
> # CONFIG_ATARI_PARTITION is not set
> CONFIG_MAC_PARTITION=y
> # CONFIG_MSDOS_PARTITION is not set
> CONFIG_LDM_PARTITION=y
> CONFIG_LDM_DEBUG=y
> CONFIG_SGI_PARTITION=y
> CONFIG_ULTRIX_PARTITION=y
> # CONFIG_SUN_PARTITION is not set
> # CONFIG_KARMA_PARTITION is not set
> CONFIG_EFI_PARTITION=y
> CONFIG_SYSV68_PARTITION=y
> CONFIG_CMDLINE_PARTITION=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> # CONFIG_IOSCHED_CFQ is not set
> CONFIG_DEFAULT_DEADLINE=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="deadline"
> CONFIG_PADATA=y
> CONFIG_ASN1=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> # CONFIG_FREEZER is not set
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> CONFIG_SMP=y
> CONFIG_X86_MPPARSE=y
> CONFIG_X86_BIGSMP=y
> CONFIG_GOLDFISH=y
> CONFIG_X86_EXTENDED_PLATFORM=y
> CONFIG_X86_GOLDFISH=y
> # CONFIG_X86_INTEL_MID is not set
> # CONFIG_X86_INTEL_LPSS is not set
> CONFIG_X86_RDC321X=y
> CONFIG_X86_32_NON_STANDARD=y
> # CONFIG_X86_NUMAQ is not set
> # CONFIG_STA2X11 is not set
> # CONFIG_X86_SUMMIT is not set
> CONFIG_X86_ES7000=y
> CONFIG_X86_32_IRIS=y
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> # CONFIG_PARAVIRT_SPINLOCKS is not set
> # CONFIG_XEN is not set
> # CONFIG_XEN_PRIVILEGED_GUEST is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_KVM_DEBUG_FS is not set
> # CONFIG_LGUEST_GUEST is not set
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> CONFIG_MEMTEST=y
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> CONFIG_MK8=y
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MELAN is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> CONFIG_X86_GENERIC=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_CPU_SUP_TRANSMETA_32=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> CONFIG_NR_CPUS=32
> CONFIG_SCHED_SMT=y
> # CONFIG_SCHED_MC is not set
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> # CONFIG_X86_MCE is not set
> CONFIG_VM86=y
> # CONFIG_TOSHIBA is not set
> # CONFIG_I8K is not set
> CONFIG_X86_REBOOTFIXUPS=y
> CONFIG_MICROCODE=y
> # CONFIG_MICROCODE_INTEL is not set
> CONFIG_MICROCODE_AMD=y
> CONFIG_MICROCODE_OLD_INTERFACE=y
> # CONFIG_MICROCODE_INTEL_EARLY is not set
> CONFIG_MICROCODE_AMD_EARLY=y
> CONFIG_MICROCODE_EARLY=y
> CONFIG_X86_MSR=y
> # CONFIG_X86_CPUID is not set
> # CONFIG_NOHIGHMEM is not set
> # CONFIG_HIGHMEM4G is not set
> CONFIG_HIGHMEM64G=y
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> CONFIG_X86_PAE=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> # CONFIG_NUMA is not set
> CONFIG_NEED_NODE_MEMMAP_SIZE=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> # CONFIG_FLATMEM_MANUAL is not set
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> # CONFIG_MEMORY_HOTPLUG is not set
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> # CONFIG_BOUNCE is not set
> CONFIG_VIRT_TO_BUS=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_TRANSPARENT_HUGEPAGE=y
> CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
> # CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
> # CONFIG_CROSS_MEMORY_ATTACH is not set
> # CONFIG_CLEANCACHE is not set
> # CONFIG_CMA is not set
> # CONFIG_ZBUD is not set
> # CONFIG_ZSMALLOC is not set
> CONFIG_HIGHPTE=y
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW=64
> CONFIG_MATH_EMULATION=y
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> CONFIG_ARCH_RANDOM=y
> CONFIG_X86_SMAP=y
> # CONFIG_EFI is not set
> # CONFIG_SECCOMP is not set
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> CONFIG_HZ_300=y
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=300
> # CONFIG_SCHED_HRTICK is not set
> CONFIG_KEXEC=y
> # CONFIG_CRASH_DUMP is not set
> CONFIG_PHYSICAL_START=0x1000000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x1000000
> # CONFIG_HOTPLUG_CPU is not set
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> # CONFIG_SUSPEND is not set
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> CONFIG_PM_DEBUG=y
> # CONFIG_PM_ADVANCED_DEBUG is not set
> # CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
> CONFIG_ACPI=y
> # CONFIG_ACPI_PROCFS is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=y
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> # CONFIG_ACPI_CONTAINER is not set
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_APEI is not set
> # CONFIG_SFI is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> CONFIG_CPU_FREQ_STAT=y
> CONFIG_CPU_FREQ_STAT_DETAILS=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> 
> #
> # x86 CPU frequency scaling drivers
> #
> CONFIG_X86_INTEL_PSTATE=y
> # CONFIG_X86_PCC_CPUFREQ is not set
> # CONFIG_X86_ACPI_CPUFREQ is not set
> # CONFIG_X86_POWERNOW_K6 is not set
> CONFIG_X86_POWERNOW_K7=y
> CONFIG_X86_POWERNOW_K7_ACPI=y
> # CONFIG_X86_GX_SUSPMOD is not set
> CONFIG_X86_SPEEDSTEP_CENTRINO=y
> CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
> CONFIG_X86_SPEEDSTEP_ICH=y
> CONFIG_X86_SPEEDSTEP_SMI=y
> CONFIG_X86_P4_CLOCKMOD=y
> CONFIG_X86_CPUFREQ_NFORCE2=y
> CONFIG_X86_LONGRUN=y
> # CONFIG_X86_LONGHAUL is not set
> # CONFIG_X86_E_POWERSAVER is not set
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=y
> CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
> 
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> # CONFIG_CPU_IDLE_GOV_MENU is not set
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> CONFIG_INTEL_IDLE=y
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> # CONFIG_PCIEPORTBUS is not set
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> # CONFIG_PCI_STUB is not set
> CONFIG_HT_IRQ=y
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> CONFIG_ISA=y
> # CONFIG_EISA is not set
> # CONFIG_SCx200 is not set
> CONFIG_ALIX=y
> # CONFIG_NET5501 is not set
> # CONFIG_GEOS is not set
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=y
> # CONFIG_PCMCIA is not set
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> # CONFIG_YENTA is not set
> CONFIG_PCMCIA_PROBE=y
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_RAPIDIO is not set
> CONFIG_X86_SYSFB=y
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> CONFIG_BINFMT_SCRIPT=y
> CONFIG_HAVE_AOUT=y
> # CONFIG_BINFMT_AOUT is not set
> # CONFIG_BINFMT_MISC is not set
> CONFIG_COREDUMP=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_DIAG=y
> CONFIG_UNIX=y
> CONFIG_UNIX_DIAG=y
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> CONFIG_XFRM_USER=y
> # CONFIG_XFRM_SUB_POLICY is not set
> CONFIG_XFRM_MIGRATE=y
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_NET_KEY=y
> CONFIG_NET_KEY_MIGRATE=y
> CONFIG_INET=y
> # CONFIG_IP_MULTICAST is not set
> # CONFIG_IP_ADVANCED_ROUTER is not set
> CONFIG_IP_PNP=y
> CONFIG_IP_PNP_DHCP=y
> CONFIG_IP_PNP_BOOTP=y
> # CONFIG_IP_PNP_RARP is not set
> CONFIG_NET_IPIP=y
> # CONFIG_NET_IPGRE_DEMUX is not set
> CONFIG_NET_IP_TUNNEL=y
> # CONFIG_SYN_COOKIES is not set
> CONFIG_NET_IPVTI=y
> # CONFIG_INET_AH is not set
> CONFIG_INET_ESP=y
> # CONFIG_INET_IPCOMP is not set
> # CONFIG_INET_XFRM_TUNNEL is not set
> CONFIG_INET_TUNNEL=y
> # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> CONFIG_INET_XFRM_MODE_TUNNEL=y
> CONFIG_INET_XFRM_MODE_BEET=y
> CONFIG_INET_LRO=y
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> CONFIG_INET_UDP_DIAG=y
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=y
> # CONFIG_TCP_CONG_CUBIC is not set
> CONFIG_TCP_CONG_WESTWOOD=y
> CONFIG_TCP_CONG_HTCP=y
> CONFIG_TCP_CONG_HSTCP=y
> CONFIG_TCP_CONG_HYBLA=y
> CONFIG_TCP_CONG_VEGAS=y
> CONFIG_TCP_CONG_SCALABLE=y
> # CONFIG_TCP_CONG_LP is not set
> CONFIG_TCP_CONG_VENO=y
> CONFIG_TCP_CONG_YEAH=y
> CONFIG_TCP_CONG_ILLINOIS=y
> # CONFIG_DEFAULT_BIC is not set
> # CONFIG_DEFAULT_HTCP is not set
> # CONFIG_DEFAULT_HYBLA is not set
> # CONFIG_DEFAULT_VEGAS is not set
> CONFIG_DEFAULT_VENO=y
> # CONFIG_DEFAULT_WESTWOOD is not set
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="veno"
> # CONFIG_TCP_MD5SIG is not set
> # CONFIG_IPV6 is not set
> CONFIG_NETLABEL=y
> CONFIG_NETWORK_SECMARK=y
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> # CONFIG_NETFILTER is not set
> CONFIG_IP_DCCP=y
> CONFIG_INET_DCCP_DIAG=y
> 
> #
> # DCCP CCIDs Configuration
> #
> # CONFIG_IP_DCCP_CCID2_DEBUG is not set
> # CONFIG_IP_DCCP_CCID3 is not set
> 
> #
> # DCCP Kernel Hacking
> #
> # CONFIG_IP_DCCP_DEBUG is not set
> CONFIG_IP_SCTP=y
> # CONFIG_SCTP_DBG_OBJCNT is not set
> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
> CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
> # CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
> CONFIG_SCTP_COOKIE_HMAC_SHA1=y
> # CONFIG_RDS is not set
> CONFIG_TIPC=y
> CONFIG_TIPC_PORTS=8191
> CONFIG_ATM=y
> # CONFIG_ATM_CLIP is not set
> # CONFIG_ATM_LANE is not set
> CONFIG_ATM_BR2684=y
> # CONFIG_ATM_BR2684_IPFILTER is not set
> CONFIG_L2TP=y
> # CONFIG_L2TP_DEBUGFS is not set
> CONFIG_L2TP_V3=y
> # CONFIG_L2TP_IP is not set
> CONFIG_L2TP_ETH=y
> CONFIG_STP=y
> CONFIG_GARP=y
> # CONFIG_BRIDGE is not set
> CONFIG_HAVE_NET_DSA=y
> CONFIG_NET_DSA=y
> CONFIG_NET_DSA_TAG_DSA=y
> CONFIG_VLAN_8021Q=y
> CONFIG_VLAN_8021Q_GVRP=y
> # CONFIG_VLAN_8021Q_MVRP is not set
> # CONFIG_DECNET is not set
> CONFIG_LLC=y
> CONFIG_LLC2=y
> CONFIG_IPX=y
> CONFIG_IPX_INTERN=y
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> CONFIG_LAPB=y
> CONFIG_PHONET=y
> CONFIG_IEEE802154=y
> CONFIG_6LOWPAN_IPHC=y
> # CONFIG_MAC802154 is not set
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> # CONFIG_NET_SCH_CBQ is not set
> # CONFIG_NET_SCH_HTB is not set
> CONFIG_NET_SCH_HFSC=y
> # CONFIG_NET_SCH_ATM is not set
> CONFIG_NET_SCH_PRIO=y
> CONFIG_NET_SCH_MULTIQ=y
> # CONFIG_NET_SCH_RED is not set
> # CONFIG_NET_SCH_SFB is not set
> CONFIG_NET_SCH_SFQ=y
> # CONFIG_NET_SCH_TEQL is not set
> # CONFIG_NET_SCH_TBF is not set
> CONFIG_NET_SCH_GRED=y
> # CONFIG_NET_SCH_DSMARK is not set
> CONFIG_NET_SCH_NETEM=y
> # CONFIG_NET_SCH_DRR is not set
> CONFIG_NET_SCH_MQPRIO=y
> # CONFIG_NET_SCH_CHOKE is not set
> CONFIG_NET_SCH_QFQ=y
> # CONFIG_NET_SCH_CODEL is not set
> # CONFIG_NET_SCH_FQ_CODEL is not set
> CONFIG_NET_SCH_FQ=y
> # CONFIG_NET_SCH_HHF is not set
> # CONFIG_NET_SCH_PIE is not set
> CONFIG_NET_SCH_INGRESS=y
> CONFIG_NET_SCH_PLUG=y
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=y
> # CONFIG_NET_CLS_TCINDEX is not set
> # CONFIG_NET_CLS_ROUTE4 is not set
> # CONFIG_NET_CLS_FW is not set
> CONFIG_NET_CLS_U32=y
> CONFIG_CLS_U32_PERF=y
> CONFIG_CLS_U32_MARK=y
> # CONFIG_NET_CLS_RSVP is not set
> # CONFIG_NET_CLS_RSVP6 is not set
> # CONFIG_NET_CLS_FLOW is not set
> # CONFIG_NET_CLS_BPF is not set
> # CONFIG_NET_EMATCH is not set
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=y
> CONFIG_NET_ACT_GACT=y
> # CONFIG_GACT_PROB is not set
> # CONFIG_NET_ACT_MIRRED is not set
> CONFIG_NET_ACT_NAT=y
> CONFIG_NET_ACT_PEDIT=y
> # CONFIG_NET_ACT_SIMP is not set
> # CONFIG_NET_ACT_SKBEDIT is not set
> CONFIG_NET_ACT_CSUM=y
> # CONFIG_NET_CLS_IND is not set
> CONFIG_NET_SCH_FIFO=y
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=y
> # CONFIG_BATMAN_ADV is not set
> CONFIG_OPENVSWITCH=y
> CONFIG_VSOCKETS=y
> CONFIG_NETLINK_MMAP=y
> CONFIG_NETLINK_DIAG=y
> CONFIG_NET_MPLS_GSO=y
> CONFIG_HSR=y
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> CONFIG_NET_FLOW_LIMIT=y
> 
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_HAMRADIO is not set
> CONFIG_CAN=y
> # CONFIG_CAN_RAW is not set
> CONFIG_CAN_BCM=y
> CONFIG_CAN_GW=y
> 
> #
> # CAN Device Drivers
> #
> CONFIG_CAN_VCAN=y
> CONFIG_CAN_SLCAN=y
> # CONFIG_CAN_DEV is not set
> # CONFIG_CAN_DEBUG_DEVICES is not set
> CONFIG_IRDA=y
> 
> #
> # IrDA protocols
> #
> CONFIG_IRLAN=y
> CONFIG_IRNET=y
> CONFIG_IRCOMM=y
> CONFIG_IRDA_ULTRA=y
> 
> #
> # IrDA options
> #
> CONFIG_IRDA_CACHE_LAST_LSAP=y
> # CONFIG_IRDA_FAST_RR is not set
> CONFIG_IRDA_DEBUG=y
> 
> #
> # Infrared-port device drivers
> #
> 
> #
> # SIR device drivers
> #
> # CONFIG_IRTTY_SIR is not set
> 
> #
> # Dongle support
> #
> # CONFIG_KINGSUN_DONGLE is not set
> CONFIG_KSDAZZLE_DONGLE=y
> # CONFIG_KS959_DONGLE is not set
> 
> #
> # FIR device drivers
> #
> # CONFIG_USB_IRDA is not set
> CONFIG_SIGMATEL_FIR=y
> CONFIG_NSC_FIR=y
> CONFIG_WINBOND_FIR=y
> # CONFIG_TOSHIBA_FIR is not set
> CONFIG_SMC_IRCC_FIR=y
> CONFIG_ALI_FIR=y
> # CONFIG_VLSI_FIR is not set
> CONFIG_VIA_FIR=y
> CONFIG_MCS_FIR=y
> CONFIG_BT=y
> CONFIG_BT_RFCOMM=y
> # CONFIG_BT_RFCOMM_TTY is not set
> CONFIG_BT_BNEP=y
> # CONFIG_BT_BNEP_MC_FILTER is not set
> # CONFIG_BT_BNEP_PROTO_FILTER is not set
> CONFIG_BT_CMTP=y
> CONFIG_BT_HIDP=y
> 
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_HCIBTUSB=y
> CONFIG_BT_HCIBTSDIO=y
> CONFIG_BT_HCIUART=y
> CONFIG_BT_HCIUART_H4=y
> CONFIG_BT_HCIUART_BCSP=y
> # CONFIG_BT_HCIUART_ATH3K is not set
> CONFIG_BT_HCIUART_LL=y
> CONFIG_BT_HCIUART_3WIRE=y
> # CONFIG_BT_HCIBCM203X is not set
> CONFIG_BT_HCIBPA10X=y
> # CONFIG_BT_HCIBFUSB is not set
> CONFIG_BT_HCIVHCI=y
> CONFIG_BT_MRVL=y
> CONFIG_BT_MRVL_SDIO=y
> CONFIG_BT_ATH3K=y
> CONFIG_BT_WILINK=y
> CONFIG_AF_RXRPC=y
> # CONFIG_AF_RXRPC_DEBUG is not set
> CONFIG_RXKAD=y
> CONFIG_WIRELESS=y
> CONFIG_WIRELESS_EXT=y
> CONFIG_WEXT_CORE=y
> CONFIG_WEXT_PROC=y
> CONFIG_WEXT_SPY=y
> CONFIG_CFG80211=y
> # CONFIG_NL80211_TESTMODE is not set
> CONFIG_CFG80211_DEVELOPER_WARNINGS=y
> # CONFIG_CFG80211_REG_DEBUG is not set
> CONFIG_CFG80211_DEFAULT_PS=y
> CONFIG_CFG80211_DEBUGFS=y
> # CONFIG_CFG80211_INTERNAL_REGDB is not set
> # CONFIG_CFG80211_WEXT is not set
> CONFIG_LIB80211=y
> # CONFIG_LIB80211_DEBUG is not set
> CONFIG_MAC80211=y
> CONFIG_MAC80211_HAS_RC=y
> CONFIG_MAC80211_RC_MINSTREL=y
> CONFIG_MAC80211_RC_MINSTREL_HT=y
> CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
> CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
> CONFIG_MAC80211_MESH=y
> CONFIG_MAC80211_LEDS=y
> # CONFIG_MAC80211_DEBUGFS is not set
> CONFIG_MAC80211_MESSAGE_TRACING=y
> CONFIG_MAC80211_DEBUG_MENU=y
> CONFIG_MAC80211_NOINLINE=y
> # CONFIG_MAC80211_VERBOSE_DEBUG is not set
> CONFIG_MAC80211_MLME_DEBUG=y
> CONFIG_MAC80211_STA_DEBUG=y
> # CONFIG_MAC80211_HT_DEBUG is not set
> CONFIG_MAC80211_IBSS_DEBUG=y
> CONFIG_MAC80211_PS_DEBUG=y
> # CONFIG_MAC80211_MPL_DEBUG is not set
> CONFIG_MAC80211_MPATH_DEBUG=y
> # CONFIG_MAC80211_MHWMP_DEBUG is not set
> CONFIG_MAC80211_MESH_SYNC_DEBUG=y
> # CONFIG_MAC80211_MESH_CSA_DEBUG is not set
> # CONFIG_MAC80211_MESH_PS_DEBUG is not set
> CONFIG_MAC80211_TDLS_DEBUG=y
> CONFIG_WIMAX=y
> CONFIG_WIMAX_DEBUG_LEVEL=8
> CONFIG_RFKILL=y
> CONFIG_RFKILL_LEDS=y
> CONFIG_RFKILL_INPUT=y
> CONFIG_RFKILL_REGULATOR=y
> # CONFIG_RFKILL_GPIO is not set
> CONFIG_NET_9P=y
> # CONFIG_NET_9P_VIRTIO is not set
> # CONFIG_NET_9P_DEBUG is not set
> CONFIG_CAIF=y
> # CONFIG_CAIF_DEBUG is not set
> CONFIG_CAIF_NETDEV=y
> CONFIG_CAIF_USB=y
> # CONFIG_CEPH_LIB is not set
> CONFIG_NFC=y
> # CONFIG_NFC_DIGITAL is not set
> CONFIG_NFC_NCI=y
> # CONFIG_NFC_NCI_SPI is not set
> CONFIG_NFC_HCI=y
> CONFIG_NFC_SHDLC=y
> 
> #
> # Near Field Communication (NFC) devices
> #
> # CONFIG_NFC_PN533 is not set
> CONFIG_NFC_WILINK=y
> CONFIG_NFC_SIM=y
> # CONFIG_NFC_PN544 is not set
> # CONFIG_NFC_MICROREAD is not set
> # CONFIG_NFC_MRVL is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> CONFIG_DEVTMPFS_MOUNT=y
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> CONFIG_DEBUG_DEVRES=y
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_SPI=y
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> 
> #
> # Bus devices
> #
> CONFIG_CONNECTOR=y
> # CONFIG_PROC_EVENTS is not set
> # CONFIG_MTD is not set
> CONFIG_PARPORT=y
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PARPORT_PC=y
> # CONFIG_PARPORT_SERIAL is not set
> # CONFIG_PARPORT_PC_FIFO is not set
> # CONFIG_PARPORT_PC_SUPERIO is not set
> # CONFIG_PARPORT_GSC is not set
> # CONFIG_PARPORT_AX88796 is not set
> CONFIG_PARPORT_1284=y
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> CONFIG_ISAPNP=y
> # CONFIG_PNPBIOS is not set
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_NULL_BLK=y
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> # CONFIG_BLK_DEV_DRBD is not set
> CONFIG_BLK_DEV_NBD=y
> # CONFIG_BLK_DEV_NVME is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_RAM is not set
> CONFIG_CDROM_PKTCDVD=y
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> CONFIG_CDROM_PKTCDVD_WCACHE=y
> CONFIG_ATA_OVER_ETH=y
> CONFIG_VIRTIO_BLK=y
> CONFIG_BLK_DEV_HD=y
> # CONFIG_BLK_DEV_RBD is not set
> # CONFIG_BLK_DEV_RSXX is not set
> 
> #
> # Misc devices
> #
> # CONFIG_SENSORS_LIS3LV02D is not set
> CONFIG_AD525X_DPOT=y
> CONFIG_AD525X_DPOT_I2C=y
> CONFIG_AD525X_DPOT_SPI=y
> # CONFIG_DUMMY_IRQ is not set
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> CONFIG_ICS932S401=y
> CONFIG_ATMEL_SSC=y
> CONFIG_ENCLOSURE_SERVICES=y
> # CONFIG_HP_ILO is not set
> CONFIG_APDS9802ALS=y
> CONFIG_ISL29003=y
> # CONFIG_ISL29020 is not set
> CONFIG_SENSORS_TSL2550=y
> CONFIG_SENSORS_BH1780=y
> CONFIG_SENSORS_BH1770=y
> CONFIG_SENSORS_APDS990X=y
> CONFIG_HMC6352=y
> CONFIG_DS1682=y
> # CONFIG_TI_DAC7512 is not set
> CONFIG_VMWARE_BALLOON=y
> # CONFIG_BMP085_I2C is not set
> # CONFIG_BMP085_SPI is not set
> # CONFIG_PCH_PHUB is not set
> CONFIG_USB_SWITCH_FSA9480=y
> CONFIG_LATTICE_ECP3_CONFIG=y
> CONFIG_SRAM=y
> CONFIG_C2PORT=y
> CONFIG_C2PORT_DURAMAR_2150=y
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=y
> CONFIG_EEPROM_AT25=y
> # CONFIG_EEPROM_LEGACY is not set
> CONFIG_EEPROM_MAX6875=y
> CONFIG_EEPROM_93CX6=y
> CONFIG_EEPROM_93XX46=y
> # CONFIG_CB710_CORE is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> CONFIG_TI_ST=y
> # CONFIG_SENSORS_LIS3_I2C is not set
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=y
> # CONFIG_VMWARE_VMCI is not set
> 
> #
> # Intel MIC Host Driver
> #
> 
> #
> # Intel MIC Card Driver
> #
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
> 
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_XFER_MODE=y
> CONFIG_IDE_TIMINGS=y
> CONFIG_IDE_ATAPI=y
> CONFIG_IDE_LEGACY=y
> # CONFIG_BLK_DEV_IDE_SATA is not set
> CONFIG_IDE_GD=y
> CONFIG_IDE_GD_ATA=y
> # CONFIG_IDE_GD_ATAPI is not set
> # CONFIG_BLK_DEV_DELKIN is not set
> CONFIG_BLK_DEV_IDECD=y
> CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
> # CONFIG_BLK_DEV_IDETAPE is not set
> # CONFIG_BLK_DEV_IDEACPI is not set
> # CONFIG_IDE_TASK_IOCTL is not set
> CONFIG_IDE_PROC_FS=y
> 
> #
> # IDE chipset support/bugfixes
> #
> CONFIG_IDE_GENERIC=y
> CONFIG_BLK_DEV_PLATFORM=y
> # CONFIG_BLK_DEV_CMD640 is not set
> CONFIG_BLK_DEV_IDEPNP=y
> 
> #
> # PCI IDE chipsets support
> #
> # CONFIG_BLK_DEV_GENERIC is not set
> # CONFIG_BLK_DEV_OPTI621 is not set
> # CONFIG_BLK_DEV_RZ1000 is not set
> # CONFIG_BLK_DEV_AEC62XX is not set
> # CONFIG_BLK_DEV_ALI15X3 is not set
> # CONFIG_BLK_DEV_AMD74XX is not set
> # CONFIG_BLK_DEV_ATIIXP is not set
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CS5520 is not set
> # CONFIG_BLK_DEV_CS5530 is not set
> # CONFIG_BLK_DEV_CS5535 is not set
> # CONFIG_BLK_DEV_CS5536 is not set
> # CONFIG_BLK_DEV_HPT366 is not set
> # CONFIG_BLK_DEV_JMICRON is not set
> # CONFIG_BLK_DEV_SC1200 is not set
> # CONFIG_BLK_DEV_PIIX is not set
> # CONFIG_BLK_DEV_IT8172 is not set
> # CONFIG_BLK_DEV_IT8213 is not set
> # CONFIG_BLK_DEV_IT821X is not set
> # CONFIG_BLK_DEV_NS87415 is not set
> # CONFIG_BLK_DEV_PDC202XX_OLD is not set
> # CONFIG_BLK_DEV_PDC202XX_NEW is not set
> # CONFIG_BLK_DEV_SVWKS is not set
> # CONFIG_BLK_DEV_SIIMAGE is not set
> # CONFIG_BLK_DEV_SIS5513 is not set
> # CONFIG_BLK_DEV_SLC90E66 is not set
> # CONFIG_BLK_DEV_TRM290 is not set
> # CONFIG_BLK_DEV_VIA82CXXX is not set
> # CONFIG_BLK_DEV_TC86C001 is not set
> 
> #
> # Other IDE chipsets support
> #
> 
> #
> # Note: most of these also require special kernel boot parameters
> #
> # CONFIG_BLK_DEV_4DRIVES is not set
> CONFIG_BLK_DEV_ALI14XX=y
> CONFIG_BLK_DEV_DTC2278=y
> CONFIG_BLK_DEV_HT6560B=y
> CONFIG_BLK_DEV_QD65XX=y
> CONFIG_BLK_DEV_UMC8672=y
> # CONFIG_BLK_DEV_IDEDMA is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> CONFIG_RAID_ATTRS=y
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=y
> CONFIG_SCSI_NETLINK=y
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> CONFIG_CHR_DEV_OSST=y
> # CONFIG_BLK_DEV_SR is not set
> CONFIG_CHR_DEV_SG=y
> CONFIG_CHR_DEV_SCH=y
> CONFIG_SCSI_ENCLOSURE=y
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> CONFIG_SCSI_LOGGING=y
> # CONFIG_SCSI_SCAN_ASYNC is not set
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> CONFIG_SCSI_FC_ATTRS=y
> # CONFIG_SCSI_FC_TGT_ATTRS is not set
> CONFIG_SCSI_ISCSI_ATTRS=y
> CONFIG_SCSI_SAS_ATTRS=y
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_TCP=y
> CONFIG_ISCSI_BOOT_SYSFS=y
> # CONFIG_SCSI_CXGB3_ISCSI is not set
> # CONFIG_SCSI_CXGB4_ISCSI is not set
> # CONFIG_SCSI_BNX2_ISCSI is not set
> # CONFIG_SCSI_BNX2X_FCOE is not set
> # CONFIG_BE2ISCSI is not set
> # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> # CONFIG_SCSI_HPSA is not set
> # CONFIG_SCSI_3W_9XXX is not set
> # CONFIG_SCSI_3W_SAS is not set
> CONFIG_SCSI_7000FASST=y
> # CONFIG_SCSI_ACARD is not set
> # CONFIG_SCSI_AHA152X is not set
> # CONFIG_SCSI_AHA1542 is not set
> # CONFIG_SCSI_AACRAID is not set
> # CONFIG_SCSI_AIC7XXX is not set
> # CONFIG_SCSI_AIC79XX is not set
> # CONFIG_SCSI_AIC94XX is not set
> # CONFIG_SCSI_MVSAS is not set
> # CONFIG_SCSI_MVUMI is not set
> # CONFIG_SCSI_DPT_I2O is not set
> # CONFIG_SCSI_ADVANSYS is not set
> CONFIG_SCSI_IN2000=y
> # CONFIG_SCSI_ARCMSR is not set
> # CONFIG_SCSI_ESAS2R is not set
> # CONFIG_MEGARAID_NEWGEN is not set
> # CONFIG_MEGARAID_LEGACY is not set
> # CONFIG_MEGARAID_SAS is not set
> # CONFIG_SCSI_MPT2SAS is not set
> # CONFIG_SCSI_MPT3SAS is not set
> CONFIG_SCSI_UFSHCD=y
> # CONFIG_SCSI_UFSHCD_PCI is not set
> # CONFIG_SCSI_UFSHCD_PLATFORM is not set
> # CONFIG_SCSI_HPTIOP is not set
> CONFIG_SCSI_BUSLOGIC=y
> # CONFIG_SCSI_FLASHPOINT is not set
> # CONFIG_VMWARE_PVSCSI is not set
> CONFIG_LIBFC=y
> CONFIG_LIBFCOE=y
> # CONFIG_FCOE is not set
> # CONFIG_FCOE_FNIC is not set
> # CONFIG_SCSI_DMX3191D is not set
> CONFIG_SCSI_DTC3280=y
> CONFIG_SCSI_EATA=y
> CONFIG_SCSI_EATA_TAGGED_QUEUE=y
> CONFIG_SCSI_EATA_LINKED_COMMANDS=y
> CONFIG_SCSI_EATA_MAX_TAGS=16
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> CONFIG_SCSI_GDTH=y
> # CONFIG_SCSI_ISCI is not set
> CONFIG_SCSI_GENERIC_NCR5380=y
> CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
> CONFIG_SCSI_GENERIC_NCR53C400=y
> # CONFIG_SCSI_IPS is not set
> # CONFIG_SCSI_INITIO is not set
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_PPA is not set
> CONFIG_SCSI_IMM=y
> CONFIG_SCSI_IZIP_EPP16=y
> # CONFIG_SCSI_IZIP_SLOW_CTR is not set
> CONFIG_SCSI_NCR53C406A=y
> # CONFIG_SCSI_STEX is not set
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> # CONFIG_SCSI_IPR is not set
> CONFIG_SCSI_PAS16=y
> CONFIG_SCSI_QLOGIC_FAS=y
> # CONFIG_SCSI_QLOGIC_1280 is not set
> # CONFIG_SCSI_QLA_FC is not set
> # CONFIG_SCSI_QLA_ISCSI is not set
> # CONFIG_SCSI_LPFC is not set
> # CONFIG_SCSI_SYM53C416 is not set
> # CONFIG_SCSI_DC395x is not set
> # CONFIG_SCSI_DC390T is not set
> # CONFIG_SCSI_T128 is not set
> # CONFIG_SCSI_U14_34F is not set
> CONFIG_SCSI_ULTRASTOR=y
> # CONFIG_SCSI_NSP32 is not set
> CONFIG_SCSI_DEBUG=y
> # CONFIG_SCSI_PMCRAID is not set
> # CONFIG_SCSI_PM8001 is not set
> # CONFIG_SCSI_SRP is not set
> # CONFIG_SCSI_BFA_FC is not set
> CONFIG_SCSI_VIRTIO=y
> # CONFIG_SCSI_CHELSIO_FCOE is not set
> CONFIG_SCSI_DH=y
> CONFIG_SCSI_DH_RDAC=y
> # CONFIG_SCSI_DH_HP_SW is not set
> CONFIG_SCSI_DH_EMC=y
> # CONFIG_SCSI_DH_ALUA is not set
> CONFIG_SCSI_OSD_INITIATOR=y
> # CONFIG_SCSI_OSD_ULD is not set
> CONFIG_SCSI_OSD_DPRINT_SENSE=1
> # CONFIG_SCSI_OSD_DEBUG is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_ZPODD is not set
> CONFIG_SATA_PMP=y
> 
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_SATA_ACARD_AHCI is not set
> # CONFIG_SATA_SIL24 is not set
> # CONFIG_ATA_SFF is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> # CONFIG_MD_AUTODETECT is not set
> # CONFIG_MD_LINEAR is not set
> CONFIG_MD_RAID0=y
> CONFIG_MD_RAID1=y
> # CONFIG_MD_RAID10 is not set
> CONFIG_MD_RAID456=y
> CONFIG_MD_MULTIPATH=y
> # CONFIG_MD_FAULTY is not set
> CONFIG_BCACHE=y
> CONFIG_BCACHE_DEBUG=y
> # CONFIG_BCACHE_CLOSURES_DEBUG is not set
> CONFIG_BLK_DEV_DM_BUILTIN=y
> CONFIG_BLK_DEV_DM=y
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_BUFIO=y
> CONFIG_DM_BIO_PRISON=y
> CONFIG_DM_PERSISTENT_DATA=y
> CONFIG_DM_CRYPT=y
> # CONFIG_DM_SNAPSHOT is not set
> CONFIG_DM_THIN_PROVISIONING=y
> CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
> CONFIG_DM_CACHE=y
> CONFIG_DM_CACHE_MQ=y
> # CONFIG_DM_CACHE_CLEANER is not set
> CONFIG_DM_MIRROR=y
> # CONFIG_DM_LOG_USERSPACE is not set
> # CONFIG_DM_RAID is not set
> CONFIG_DM_ZERO=y
> # CONFIG_DM_MULTIPATH is not set
> # CONFIG_DM_DELAY is not set
> CONFIG_DM_UEVENT=y
> CONFIG_DM_FLAKEY=y
> CONFIG_DM_VERITY=y
> # CONFIG_DM_SWITCH is not set
> # CONFIG_TARGET_CORE is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_I2O is not set
> CONFIG_MACINTOSH_DRIVERS=y
> CONFIG_MAC_EMUMOUSEBTN=y
> CONFIG_NETDEVICES=y
> CONFIG_MII=y
> # CONFIG_NET_CORE is not set
> # CONFIG_ARCNET is not set
> # CONFIG_ATM_DRIVERS is not set
> 
> #
> # CAIF transport drivers
> #
> CONFIG_CAIF_TTY=y
> # CONFIG_CAIF_SPI_SLAVE is not set
> CONFIG_CAIF_HSI=y
> CONFIG_CAIF_VIRTIO=y
> # CONFIG_VHOST_NET is not set
> CONFIG_VHOST_RING=y
> 
> #
> # Distributed Switch Architecture drivers
> #
> CONFIG_NET_DSA_MV88E6XXX=y
> # CONFIG_NET_DSA_MV88E6060 is not set
> CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
> CONFIG_NET_DSA_MV88E6131=y
> # CONFIG_NET_DSA_MV88E6123_61_65 is not set
> CONFIG_ETHERNET=y
> CONFIG_NET_VENDOR_3COM=y
> CONFIG_EL3=y
> CONFIG_3C515=y
> # CONFIG_VORTEX is not set
> # CONFIG_TYPHOON is not set
> CONFIG_NET_VENDOR_ADAPTEC=y
> # CONFIG_ADAPTEC_STARFIRE is not set
> CONFIG_NET_VENDOR_ALTEON=y
> # CONFIG_ACENIC is not set
> # CONFIG_NET_VENDOR_AMD is not set
> CONFIG_NET_VENDOR_ARC=y
> CONFIG_NET_VENDOR_ATHEROS=y
> # CONFIG_ATL2 is not set
> # CONFIG_ATL1 is not set
> # CONFIG_ATL1E is not set
> # CONFIG_ATL1C is not set
> # CONFIG_ALX is not set
> CONFIG_NET_CADENCE=y
> CONFIG_ARM_AT91_ETHER=y
> CONFIG_MACB=y
> CONFIG_NET_VENDOR_BROADCOM=y
> CONFIG_B44=y
> CONFIG_B44_PCI_AUTOSELECT=y
> CONFIG_B44_PCICORE_AUTOSELECT=y
> CONFIG_B44_PCI=y
> # CONFIG_BNX2 is not set
> # CONFIG_CNIC is not set
> # CONFIG_TIGON3 is not set
> # CONFIG_BNX2X is not set
> CONFIG_NET_VENDOR_BROCADE=y
> # CONFIG_BNA is not set
> CONFIG_NET_CALXEDA_XGMAC=y
> CONFIG_NET_VENDOR_CHELSIO=y
> # CONFIG_CHELSIO_T1 is not set
> # CONFIG_CHELSIO_T3 is not set
> # CONFIG_CHELSIO_T4 is not set
> # CONFIG_CHELSIO_T4VF is not set
> # CONFIG_NET_VENDOR_CIRRUS is not set
> CONFIG_NET_VENDOR_CISCO=y
> # CONFIG_ENIC is not set
> CONFIG_DNET=y
> CONFIG_NET_VENDOR_DEC=y
> # CONFIG_NET_TULIP is not set
> CONFIG_NET_VENDOR_DLINK=y
> # CONFIG_DL2K is not set
> # CONFIG_SUNDANCE is not set
> CONFIG_NET_VENDOR_EMULEX=y
> # CONFIG_BE2NET is not set
> CONFIG_NET_VENDOR_EXAR=y
> # CONFIG_S2IO is not set
> # CONFIG_VXGE is not set
> CONFIG_NET_VENDOR_HP=y
> # CONFIG_HP100 is not set
> CONFIG_NET_VENDOR_INTEL=y
> # CONFIG_E100 is not set
> # CONFIG_E1000 is not set
> # CONFIG_E1000E is not set
> # CONFIG_IGB is not set
> # CONFIG_IGBVF is not set
> # CONFIG_IXGB is not set
> # CONFIG_IXGBE is not set
> # CONFIG_I40E is not set
> CONFIG_NET_VENDOR_I825XX=y
> # CONFIG_IP1000 is not set
> # CONFIG_JME is not set
> # CONFIG_NET_VENDOR_MARVELL is not set
> CONFIG_NET_VENDOR_MELLANOX=y
> # CONFIG_MLX4_EN is not set
> # CONFIG_MLX4_CORE is not set
> # CONFIG_MLX5_CORE is not set
> CONFIG_NET_VENDOR_MICREL=y
> CONFIG_KS8842=y
> CONFIG_KS8851=y
> CONFIG_KS8851_MLL=y
> # CONFIG_KSZ884X_PCI is not set
> # CONFIG_NET_VENDOR_MICROCHIP is not set
> CONFIG_NET_VENDOR_MYRI=y
> # CONFIG_MYRI10GE is not set
> # CONFIG_FEALNX is not set
> # CONFIG_NET_VENDOR_NATSEMI is not set
> CONFIG_NET_VENDOR_NVIDIA=y
> # CONFIG_FORCEDETH is not set
> CONFIG_NET_VENDOR_OKI=y
> # CONFIG_PCH_GBE is not set
> CONFIG_ETHOC=y
> CONFIG_NET_PACKET_ENGINE=y
> # CONFIG_HAMACHI is not set
> # CONFIG_YELLOWFIN is not set
> CONFIG_NET_VENDOR_QLOGIC=y
> # CONFIG_QLA3XXX is not set
> # CONFIG_QLCNIC is not set
> # CONFIG_QLGE is not set
> # CONFIG_NETXEN_NIC is not set
> CONFIG_NET_VENDOR_REALTEK=y
> CONFIG_ATP=y
> # CONFIG_8139CP is not set
> # CONFIG_8139TOO is not set
> # CONFIG_R8169 is not set
> # CONFIG_SH_ETH is not set
> CONFIG_NET_VENDOR_RDC=y
> # CONFIG_R6040 is not set
> # CONFIG_NET_VENDOR_SEEQ is not set
> CONFIG_NET_VENDOR_SILAN=y
> # CONFIG_SC92031 is not set
> CONFIG_NET_VENDOR_SIS=y
> # CONFIG_SIS900 is not set
> # CONFIG_SIS190 is not set
> # CONFIG_SFC is not set
> CONFIG_NET_VENDOR_SMSC=y
> CONFIG_SMC9194=y
> # CONFIG_EPIC100 is not set
> CONFIG_SMSC911X=y
> # CONFIG_SMSC911X_ARCH_HOOKS is not set
> # CONFIG_SMSC9420 is not set
> CONFIG_NET_VENDOR_STMICRO=y
> # CONFIG_STMMAC_ETH is not set
> CONFIG_NET_VENDOR_SUN=y
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NIU is not set
> CONFIG_NET_VENDOR_TEHUTI=y
> # CONFIG_TEHUTI is not set
> CONFIG_NET_VENDOR_TI=y
> # CONFIG_TLAN is not set
> # CONFIG_NET_VENDOR_VIA is not set
> # CONFIG_NET_VENDOR_WIZNET is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_NET_SB1000 is not set
> CONFIG_PHYLIB=y
> 
> #
> # MII PHY device drivers
> #
> CONFIG_AT803X_PHY=y
> CONFIG_AMD_PHY=y
> CONFIG_MARVELL_PHY=y
> # CONFIG_DAVICOM_PHY is not set
> CONFIG_QSEMI_PHY=y
> CONFIG_LXT_PHY=y
> CONFIG_CICADA_PHY=y
> CONFIG_VITESSE_PHY=y
> # CONFIG_SMSC_PHY is not set
> CONFIG_BROADCOM_PHY=y
> # CONFIG_BCM87XX_PHY is not set
> CONFIG_ICPLUS_PHY=y
> CONFIG_REALTEK_PHY=y
> # CONFIG_NATIONAL_PHY is not set
> CONFIG_STE10XP=y
> CONFIG_LSI_ET1011C_PHY=y
> # CONFIG_MICREL_PHY is not set
> # CONFIG_FIXED_PHY is not set
> CONFIG_MDIO_BITBANG=y
> CONFIG_MDIO_GPIO=y
> # CONFIG_MICREL_KS8995MA is not set
> CONFIG_PLIP=y
> CONFIG_PPP=y
> CONFIG_PPP_BSDCOMP=y
> CONFIG_PPP_DEFLATE=y
> CONFIG_PPP_FILTER=y
> CONFIG_PPP_MPPE=y
> CONFIG_PPP_MULTILINK=y
> # CONFIG_PPPOATM is not set
> CONFIG_PPPOE=y
> CONFIG_PPPOL2TP=y
> # CONFIG_PPP_ASYNC is not set
> CONFIG_PPP_SYNC_TTY=y
> # CONFIG_SLIP is not set
> CONFIG_SLHC=y
> 
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> CONFIG_USB_PEGASUS=y
> CONFIG_USB_RTL8150=y
> CONFIG_USB_RTL8152=y
> CONFIG_USB_USBNET=y
> # CONFIG_USB_NET_AX8817X is not set
> CONFIG_USB_NET_AX88179_178A=y
> CONFIG_USB_NET_CDCETHER=y
> # CONFIG_USB_NET_CDC_EEM is not set
> # CONFIG_USB_NET_CDC_NCM is not set
> # CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
> # CONFIG_USB_NET_CDC_MBIM is not set
> CONFIG_USB_NET_DM9601=y
> CONFIG_USB_NET_SR9700=y
> CONFIG_USB_NET_SMSC75XX=y
> CONFIG_USB_NET_SMSC95XX=y
> CONFIG_USB_NET_GL620A=y
> # CONFIG_USB_NET_NET1080 is not set
> # CONFIG_USB_NET_PLUSB is not set
> CONFIG_USB_NET_MCS7830=y
> CONFIG_USB_NET_RNDIS_HOST=y
> # CONFIG_USB_NET_CDC_SUBSET is not set
> # CONFIG_USB_NET_ZAURUS is not set
> CONFIG_USB_NET_CX82310_ETH=y
> # CONFIG_USB_NET_KALMIA is not set
> CONFIG_USB_NET_QMI_WWAN=y
> # CONFIG_USB_HSO is not set
> # CONFIG_USB_NET_INT51X1 is not set
> CONFIG_USB_CDC_PHONET=y
> # CONFIG_USB_IPHETH is not set
> # CONFIG_USB_SIERRA_NET is not set
> CONFIG_USB_VL600=y
> CONFIG_WLAN=y
> CONFIG_LIBERTAS_THINFIRM=y
> CONFIG_LIBERTAS_THINFIRM_DEBUG=y
> # CONFIG_LIBERTAS_THINFIRM_USB is not set
> # CONFIG_AIRO is not set
> # CONFIG_ATMEL is not set
> CONFIG_AT76C50X_USB=y
> # CONFIG_PRISM54 is not set
> # CONFIG_USB_ZD1201 is not set
> # CONFIG_USB_NET_RNDIS_WLAN is not set
> # CONFIG_RTL8180 is not set
> # CONFIG_RTL8187 is not set
> # CONFIG_ADM8211 is not set
> # CONFIG_MAC80211_HWSIM is not set
> # CONFIG_MWL8K is not set
> CONFIG_ATH_COMMON=y
> CONFIG_ATH_CARDS=y
> CONFIG_ATH_DEBUG=y
> # CONFIG_ATH5K is not set
> # CONFIG_ATH5K_PCI is not set
> CONFIG_ATH9K_HW=y
> CONFIG_ATH9K_COMMON=y
> CONFIG_ATH9K_BTCOEX_SUPPORT=y
> CONFIG_ATH9K=y
> CONFIG_ATH9K_PCI=y
> # CONFIG_ATH9K_AHB is not set
> # CONFIG_ATH9K_DEBUGFS is not set
> # CONFIG_ATH9K_WOW is not set
> CONFIG_ATH9K_LEGACY_RATE_CONTROL=y
> CONFIG_ATH9K_RFKILL=y
> CONFIG_ATH9K_HTC=y
> CONFIG_ATH9K_HTC_DEBUGFS=y
> CONFIG_CARL9170=y
> CONFIG_CARL9170_LEDS=y
> CONFIG_CARL9170_WPC=y
> # CONFIG_CARL9170_HWRNG is not set
> # CONFIG_ATH6KL is not set
> CONFIG_AR5523=y
> # CONFIG_WIL6210 is not set
> # CONFIG_ATH10K is not set
> CONFIG_WCN36XX=y
> # CONFIG_WCN36XX_DEBUGFS is not set
> CONFIG_B43=y
> # CONFIG_B43_BCMA is not set
> CONFIG_B43_SSB=y
> CONFIG_B43_PCI_AUTOSELECT=y
> CONFIG_B43_PCICORE_AUTOSELECT=y
> CONFIG_B43_SDIO=y
> CONFIG_B43_PIO=y
> CONFIG_B43_PHY_N=y
> CONFIG_B43_PHY_LP=y
> CONFIG_B43_LEDS=y
> CONFIG_B43_HWRNG=y
> # CONFIG_B43_DEBUG is not set
> CONFIG_B43LEGACY=y
> CONFIG_B43LEGACY_PCI_AUTOSELECT=y
> CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
> CONFIG_B43LEGACY_LEDS=y
> CONFIG_B43LEGACY_HWRNG=y
> # CONFIG_B43LEGACY_DEBUG is not set
> CONFIG_B43LEGACY_DMA=y
> # CONFIG_B43LEGACY_DMA_AND_PIO_MODE is not set
> CONFIG_B43LEGACY_DMA_MODE=y
> # CONFIG_B43LEGACY_PIO_MODE is not set
> CONFIG_BRCMUTIL=y
> CONFIG_BRCMSMAC=y
> CONFIG_BRCMFMAC=y
> # CONFIG_BRCMFMAC_SDIO is not set
> # CONFIG_BRCMFMAC_USB is not set
> # CONFIG_BRCM_TRACING is not set
> # CONFIG_BRCMDBG is not set
> # CONFIG_HOSTAP is not set
> # CONFIG_IPW2100 is not set
> # CONFIG_IWLWIFI is not set
> # CONFIG_IWL4965 is not set
> # CONFIG_IWL3945 is not set
> CONFIG_LIBERTAS=y
> # CONFIG_LIBERTAS_USB is not set
> CONFIG_LIBERTAS_SDIO=y
> CONFIG_LIBERTAS_SPI=y
> CONFIG_LIBERTAS_DEBUG=y
> CONFIG_LIBERTAS_MESH=y
> CONFIG_P54_COMMON=y
> CONFIG_P54_USB=y
> # CONFIG_P54_PCI is not set
> # CONFIG_P54_SPI is not set
> CONFIG_P54_LEDS=y
> CONFIG_RT2X00=y
> # CONFIG_RT2400PCI is not set
> # CONFIG_RT2500PCI is not set
> # CONFIG_RT61PCI is not set
> # CONFIG_RT2800PCI is not set
> # CONFIG_RT2500USB is not set
> # CONFIG_RT73USB is not set
> # CONFIG_RT2800USB is not set
> CONFIG_RTL_CARDS=y
> # CONFIG_RTL8192CE is not set
> # CONFIG_RTL8192SE is not set
> # CONFIG_RTL8192DE is not set
> # CONFIG_RTL8723AE is not set
> # CONFIG_RTL8188EE is not set
> # CONFIG_RTL8192CU is not set
> CONFIG_WL_TI=y
> CONFIG_WL1251=y
> CONFIG_WL1251_SPI=y
> # CONFIG_WL1251_SDIO is not set
> # CONFIG_WL12XX is not set
> CONFIG_WL18XX=y
> CONFIG_WLCORE=y
> CONFIG_WLCORE_SPI=y
> CONFIG_WLCORE_SDIO=y
> CONFIG_WILINK_PLATFORM_DATA=y
> CONFIG_ZD1211RW=y
> # CONFIG_ZD1211RW_DEBUG is not set
> CONFIG_MWIFIEX=y
> CONFIG_MWIFIEX_SDIO=y
> # CONFIG_MWIFIEX_PCIE is not set
> CONFIG_MWIFIEX_USB=y
> # CONFIG_CW1200 is not set
> 
> #
> # WiMAX Wireless Broadband devices
> #
> CONFIG_WIMAX_I2400M=y
> CONFIG_WIMAX_I2400M_USB=y
> CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
> # CONFIG_WAN is not set
> CONFIG_IEEE802154_DRIVERS=y
> CONFIG_IEEE802154_FAKEHARD=y
> # CONFIG_VMXNET3 is not set
> CONFIG_ISDN=y
> CONFIG_ISDN_I4L=y
> CONFIG_ISDN_PPP=y
> CONFIG_ISDN_PPP_VJ=y
> # CONFIG_ISDN_MPP is not set
> # CONFIG_IPPP_FILTER is not set
> CONFIG_ISDN_PPP_BSDCOMP=y
> CONFIG_ISDN_AUDIO=y
> CONFIG_ISDN_TTY_FAX=y
> 
> #
> # ISDN feature submodules
> #
> CONFIG_ISDN_DIVERSION=y
> 
> #
> # ISDN4Linux hardware drivers
> #
> 
> #
> # Passive cards
> #
> CONFIG_ISDN_DRV_HISAX=y
> 
> #
> # D-channel protocol features
> #
> # CONFIG_HISAX_EURO is not set
> # CONFIG_HISAX_1TR6 is not set
> # CONFIG_HISAX_NI1 is not set
> CONFIG_HISAX_MAX_CARDS=8
> 
> #
> # HiSax supported cards
> #
> CONFIG_HISAX_16_0=y
> # CONFIG_HISAX_16_3 is not set
> # CONFIG_HISAX_TELESPCI is not set
> # CONFIG_HISAX_S0BOX is not set
> # CONFIG_HISAX_AVM_A1 is not set
> CONFIG_HISAX_FRITZPCI=y
> CONFIG_HISAX_AVM_A1_PCMCIA=y
> CONFIG_HISAX_ELSA=y
> CONFIG_HISAX_IX1MICROR2=y
> CONFIG_HISAX_DIEHLDIVA=y
> CONFIG_HISAX_ASUSCOM=y
> # CONFIG_HISAX_TELEINT is not set
> # CONFIG_HISAX_HFCS is not set
> CONFIG_HISAX_SEDLBAUER=y
> # CONFIG_HISAX_SPORTSTER is not set
> CONFIG_HISAX_MIC=y
> # CONFIG_HISAX_NETJET is not set
> # CONFIG_HISAX_NETJET_U is not set
> # CONFIG_HISAX_NICCY is not set
> CONFIG_HISAX_ISURF=y
> CONFIG_HISAX_HSTSAPHIR=y
> # CONFIG_HISAX_BKM_A4T is not set
> # CONFIG_HISAX_SCT_QUADRO is not set
> CONFIG_HISAX_GAZEL=y
> # CONFIG_HISAX_HFC_PCI is not set
> # CONFIG_HISAX_W6692 is not set
> CONFIG_HISAX_HFC_SX=y
> # CONFIG_HISAX_DEBUG is not set
> 
> #
> # HiSax PCMCIA card service modules
> #
> 
> #
> # HiSax sub driver modules
> #
> # CONFIG_HISAX_ST5481 is not set
> CONFIG_HISAX_HFCUSB=y
> CONFIG_HISAX_HFC4S8S=y
> # CONFIG_HISAX_FRITZ_PCIPNP is not set
> 
> #
> # Active cards
> #
> CONFIG_ISDN_DRV_ICN=y
> CONFIG_ISDN_DRV_PCBIT=y
> # CONFIG_ISDN_DRV_SC is not set
> CONFIG_ISDN_DRV_ACT2000=y
> CONFIG_ISDN_CAPI=y
> # CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
> CONFIG_CAPI_TRACE=y
> CONFIG_ISDN_CAPI_MIDDLEWARE=y
> CONFIG_ISDN_CAPI_CAPI20=y
> CONFIG_ISDN_CAPI_CAPIDRV=y
> 
> #
> # CAPI hardware drivers
> #
> # CONFIG_CAPI_AVM is not set
> # CONFIG_CAPI_EICON is not set
> CONFIG_ISDN_DRV_GIGASET=y
> # CONFIG_GIGASET_CAPI is not set
> CONFIG_GIGASET_I4L=y
> # CONFIG_GIGASET_DUMMYLL is not set
> # CONFIG_GIGASET_BASE is not set
> # CONFIG_GIGASET_M105 is not set
> CONFIG_GIGASET_M101=y
> # CONFIG_GIGASET_DEBUG is not set
> CONFIG_MISDN=y
> CONFIG_MISDN_DSP=y
> # CONFIG_MISDN_L1OIP is not set
> 
> #
> # mISDN hardware drivers
> #
> # CONFIG_MISDN_HFCPCI is not set
> # CONFIG_MISDN_HFCMULTI is not set
> # CONFIG_MISDN_HFCUSB is not set
> # CONFIG_MISDN_AVMFRITZ is not set
> # CONFIG_MISDN_SPEEDFAX is not set
> # CONFIG_MISDN_INFINEON is not set
> # CONFIG_MISDN_W6692 is not set
> # CONFIG_MISDN_NETJET is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> CONFIG_INPUT_MATRIXKMAP=y
> 
> #
> # Userland interfaces
> #
> # CONFIG_INPUT_MOUSEDEV is not set
> # CONFIG_INPUT_JOYDEV is not set
> CONFIG_INPUT_EVDEV=y
> CONFIG_INPUT_EVBUG=y
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ADP5520=y
> CONFIG_KEYBOARD_ADP5588=y
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> CONFIG_KEYBOARD_QT1070=y
> # CONFIG_KEYBOARD_QT2160 is not set
> CONFIG_KEYBOARD_LKKBD=y
> CONFIG_KEYBOARD_GPIO=y
> CONFIG_KEYBOARD_GPIO_POLLED=y
> # CONFIG_KEYBOARD_TCA6416 is not set
> CONFIG_KEYBOARD_TCA8418=y
> CONFIG_KEYBOARD_MATRIX=y
> CONFIG_KEYBOARD_LM8323=y
> CONFIG_KEYBOARD_LM8333=y
> CONFIG_KEYBOARD_MAX7359=y
> CONFIG_KEYBOARD_MCS=y
> CONFIG_KEYBOARD_MPR121=y
> CONFIG_KEYBOARD_NEWTON=y
> CONFIG_KEYBOARD_OPENCORES=y
> CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
> CONFIG_KEYBOARD_STOWAWAY=y
> CONFIG_KEYBOARD_SUNKBD=y
> # CONFIG_KEYBOARD_STMPE is not set
> CONFIG_KEYBOARD_TC3589X=y
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_CROS_EC is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_CYPRESS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> CONFIG_MOUSE_PS2_ELANTECH=y
> # CONFIG_MOUSE_PS2_SENTELIC is not set
> CONFIG_MOUSE_PS2_TOUCHKIT=y
> CONFIG_MOUSE_SERIAL=y
> CONFIG_MOUSE_APPLETOUCH=y
> CONFIG_MOUSE_BCM5974=y
> CONFIG_MOUSE_CYAPA=y
> CONFIG_MOUSE_INPORT=y
> CONFIG_MOUSE_ATIXL=y
> CONFIG_MOUSE_LOGIBM=y
> CONFIG_MOUSE_PC110PAD=y
> CONFIG_MOUSE_VSXXXAA=y
> CONFIG_MOUSE_GPIO=y
> CONFIG_MOUSE_SYNAPTICS_I2C=y
> CONFIG_MOUSE_SYNAPTICS_USB=y
> CONFIG_INPUT_JOYSTICK=y
> # CONFIG_JOYSTICK_ANALOG is not set
> # CONFIG_JOYSTICK_A3D is not set
> CONFIG_JOYSTICK_ADI=y
> # CONFIG_JOYSTICK_COBRA is not set
> CONFIG_JOYSTICK_GF2K=y
> CONFIG_JOYSTICK_GRIP=y
> CONFIG_JOYSTICK_GRIP_MP=y
> CONFIG_JOYSTICK_GUILLEMOT=y
> # CONFIG_JOYSTICK_INTERACT is not set
> # CONFIG_JOYSTICK_SIDEWINDER is not set
> # CONFIG_JOYSTICK_TMDC is not set
> # CONFIG_JOYSTICK_IFORCE is not set
> CONFIG_JOYSTICK_WARRIOR=y
> CONFIG_JOYSTICK_MAGELLAN=y
> CONFIG_JOYSTICK_SPACEORB=y
> CONFIG_JOYSTICK_SPACEBALL=y
> # CONFIG_JOYSTICK_STINGER is not set
> # CONFIG_JOYSTICK_TWIDJOY is not set
> CONFIG_JOYSTICK_ZHENHUA=y
> CONFIG_JOYSTICK_DB9=y
> # CONFIG_JOYSTICK_GAMECON is not set
> # CONFIG_JOYSTICK_TURBOGRAFX is not set
> # CONFIG_JOYSTICK_AS5011 is not set
> CONFIG_JOYSTICK_JOYDUMP=y
> CONFIG_JOYSTICK_XPAD=y
> CONFIG_JOYSTICK_XPAD_FF=y
> CONFIG_JOYSTICK_XPAD_LEDS=y
> CONFIG_INPUT_TABLET=y
> # CONFIG_TABLET_USB_ACECAD is not set
> CONFIG_TABLET_USB_AIPTEK=y
> # CONFIG_TABLET_USB_GTCO is not set
> CONFIG_TABLET_USB_HANWANG=y
> CONFIG_TABLET_USB_KBTAB=y
> # CONFIG_TABLET_USB_WACOM is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_AD714X=y
> CONFIG_INPUT_AD714X_I2C=y
> CONFIG_INPUT_AD714X_SPI=y
> # CONFIG_INPUT_BMA150 is not set
> CONFIG_INPUT_PCSPKR=y
> CONFIG_INPUT_MC13783_PWRBUTTON=y
> CONFIG_INPUT_MMA8450=y
> CONFIG_INPUT_MPU3050=y
> CONFIG_INPUT_APANEL=y
> # CONFIG_INPUT_GP2A is not set
> CONFIG_INPUT_GPIO_TILT_POLLED=y
> CONFIG_INPUT_WISTRON_BTNS=y
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> CONFIG_INPUT_KEYSPAN_REMOTE=y
> CONFIG_INPUT_KXTJ9=y
> CONFIG_INPUT_KXTJ9_POLLED_MODE=y
> CONFIG_INPUT_POWERMATE=y
> CONFIG_INPUT_YEALINK=y
> # CONFIG_INPUT_CM109 is not set
> CONFIG_INPUT_RETU_PWRBUTTON=y
> # CONFIG_INPUT_UINPUT is not set
> CONFIG_INPUT_PCF8574=y
> # CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
> CONFIG_INPUT_DA9052_ONKEY=y
> # CONFIG_INPUT_DA9055_ONKEY is not set
> # CONFIG_INPUT_WM831X_ON is not set
> CONFIG_INPUT_ADXL34X=y
> CONFIG_INPUT_ADXL34X_I2C=y
> # CONFIG_INPUT_ADXL34X_SPI is not set
> # CONFIG_INPUT_IMS_PCU is not set
> # CONFIG_INPUT_CMA3000 is not set
> # CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> CONFIG_SERIO_CT82C710=y
> CONFIG_SERIO_PARKBD=y
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=y
> CONFIG_SERIO_ALTERA_PS2=y
> CONFIG_SERIO_PS2MULT=y
> CONFIG_SERIO_ARC_PS2=y
> CONFIG_GAMEPORT=y
> # CONFIG_GAMEPORT_NS558 is not set
> CONFIG_GAMEPORT_L4=y
> # CONFIG_GAMEPORT_EMU10K1 is not set
> # CONFIG_GAMEPORT_FM801 is not set
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> CONFIG_SERIAL_NONSTANDARD=y
> CONFIG_ROCKETPORT=y
> CONFIG_CYCLADES=y
> CONFIG_CYZ_INTR=y
> CONFIG_MOXA_INTELLIO=y
> # CONFIG_MOXA_SMARTIO is not set
> # CONFIG_SYNCLINK is not set
> # CONFIG_SYNCLINKMP is not set
> # CONFIG_SYNCLINK_GT is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_ISI is not set
> # CONFIG_N_HDLC is not set
> CONFIG_N_GSM=y
> CONFIG_TRACE_ROUTER=y
> CONFIG_TRACE_SINK=y
> CONFIG_GOLDFISH_TTY=y
> CONFIG_DEVKMEM=y
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_DMA=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> # CONFIG_SERIAL_8250_MANY_PORTS is not set
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> CONFIG_SERIAL_8250_DETECT_IRQ=y
> CONFIG_SERIAL_8250_RSA=y
> # CONFIG_SERIAL_8250_DW is not set
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_MAX3100=y
> # CONFIG_SERIAL_MAX310X is not set
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> CONFIG_SERIAL_SCCNXP=y
> CONFIG_SERIAL_SCCNXP_CONSOLE=y
> # CONFIG_SERIAL_TIMBERDALE is not set
> CONFIG_SERIAL_ALTERA_JTAGUART=y
> CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
> # CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> CONFIG_SERIAL_IFX6X60=y
> # CONFIG_SERIAL_PCH_UART is not set
> CONFIG_SERIAL_ARC=y
> # CONFIG_SERIAL_ARC_CONSOLE is not set
> CONFIG_SERIAL_ARC_NR_PORTS=1
> # CONFIG_SERIAL_RP2 is not set
> # CONFIG_SERIAL_FSL_LPUART is not set
> # CONFIG_PRINTER is not set
> CONFIG_PPDEV=y
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=y
> # CONFIG_IPMI_HANDLER is not set
> CONFIG_HW_RANDOM=y
> CONFIG_HW_RANDOM_TIMERIOMEM=y
> CONFIG_HW_RANDOM_INTEL=y
> CONFIG_HW_RANDOM_AMD=y
> CONFIG_HW_RANDOM_GEODE=y
> # CONFIG_HW_RANDOM_VIA is not set
> # CONFIG_HW_RANDOM_VIRTIO is not set
> CONFIG_HW_RANDOM_TPM=y
> CONFIG_NVRAM=y
> CONFIG_DTLK=y
> CONFIG_R3964=y
> # CONFIG_APPLICOM is not set
> # CONFIG_SONYPI is not set
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> CONFIG_NSC_GPIO=y
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> CONFIG_HANGCHECK_TIMER=y
> CONFIG_TCG_TPM=y
> CONFIG_TCG_TIS=y
> CONFIG_TCG_TIS_I2C_ATMEL=y
> CONFIG_TCG_TIS_I2C_INFINEON=y
> CONFIG_TCG_TIS_I2C_NUVOTON=y
> # CONFIG_TCG_NSC is not set
> # CONFIG_TCG_ATMEL is not set
> CONFIG_TCG_INFINEON=y
> CONFIG_TCG_ST33_I2C=y
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=y
> CONFIG_I2C_MUX=y
> 
> #
> # Multiplexer I2C Chip support
> #
> CONFIG_I2C_MUX_GPIO=y
> CONFIG_I2C_MUX_PCA9541=y
> CONFIG_I2C_MUX_PCA954x=y
> # CONFIG_I2C_HELPER_AUTO is not set
> CONFIG_I2C_SMBUS=y
> 
> #
> # I2C Algorithms
> #
> CONFIG_I2C_ALGOBIT=y
> # CONFIG_I2C_ALGOPCF is not set
> CONFIG_I2C_ALGOPCA=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> # CONFIG_I2C_I801 is not set
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_ISMT is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_I2C_SCMI is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_CBUS_GPIO=y
> # CONFIG_I2C_DESIGNWARE_PLATFORM is not set
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> # CONFIG_I2C_EG20T is not set
> # CONFIG_I2C_GPIO is not set
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> CONFIG_I2C_SIMTEC=y
> CONFIG_I2C_XILINX=y
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_DIOLAN_U2C=y
> CONFIG_I2C_PARPORT=y
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_ROBOTFUZZ_OSIF is not set
> CONFIG_I2C_TAOS_EVM=y
> CONFIG_I2C_TINY_USB=y
> 
> #
> # Other I2C/SMBus bus drivers
> #
> CONFIG_I2C_PCA_ISA=y
> # CONFIG_SCx200_ACB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> CONFIG_SPI=y
> # CONFIG_SPI_DEBUG is not set
> CONFIG_SPI_MASTER=y
> 
> #
> # SPI Master Controller Drivers
> #
> CONFIG_SPI_ALTERA=y
> CONFIG_SPI_BITBANG=y
> # CONFIG_SPI_BUTTERFLY is not set
> # CONFIG_SPI_GPIO is not set
> CONFIG_SPI_LM70_LLP=y
> CONFIG_SPI_OC_TINY=y
> # CONFIG_SPI_PXA2XX is not set
> # CONFIG_SPI_PXA2XX_PCI is not set
> CONFIG_SPI_SC18IS602=y
> # CONFIG_SPI_TOPCLIFF_PCH is not set
> CONFIG_SPI_XCOMM=y
> CONFIG_SPI_XILINX=y
> # CONFIG_SPI_DESIGNWARE is not set
> 
> #
> # SPI Protocol Masters
> #
> # CONFIG_SPI_SPIDEV is not set
> CONFIG_SPI_TLE62X0=y
> CONFIG_HSI=y
> CONFIG_HSI_BOARDINFO=y
> 
> #
> # HSI clients
> #
> CONFIG_HSI_CHAR=y
> 
> #
> # PPS support
> #
> CONFIG_PPS=y
> # CONFIG_PPS_DEBUG is not set
> CONFIG_NTP_PPS=y
> 
> #
> # PPS clients support
> #
> CONFIG_PPS_CLIENT_KTIMER=y
> CONFIG_PPS_CLIENT_LDISC=y
> CONFIG_PPS_CLIENT_PARPORT=y
> CONFIG_PPS_CLIENT_GPIO=y
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> CONFIG_PTP_1588_CLOCK=y
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> CONFIG_PTP_1588_CLOCK_PCH=y
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_GPIO_ACPI=y
> # CONFIG_DEBUG_GPIO is not set
> # CONFIG_GPIO_SYSFS is not set
> CONFIG_GPIO_GENERIC=y
> # CONFIG_GPIO_DA9052 is not set
> CONFIG_GPIO_DA9055=y
> CONFIG_GPIO_MAX730X=y
> 
> #
> # Memory mapped GPIO drivers:
> #
> CONFIG_GPIO_GENERIC_PLATFORM=y
> # CONFIG_GPIO_IT8761E is not set
> CONFIG_GPIO_F7188X=y
> # CONFIG_GPIO_SCH311X is not set
> CONFIG_GPIO_TS5500=y
> # CONFIG_GPIO_SCH is not set
> # CONFIG_GPIO_ICH is not set
> # CONFIG_GPIO_VX855 is not set
> # CONFIG_GPIO_LYNXPOINT is not set
> 
> #
> # I2C GPIO expanders:
> #
> CONFIG_GPIO_ARIZONA=y
> CONFIG_GPIO_MAX7300=y
> CONFIG_GPIO_MAX732X=y
> # CONFIG_GPIO_MAX732X_IRQ is not set
> CONFIG_GPIO_PCA953X=y
> CONFIG_GPIO_PCA953X_IRQ=y
> CONFIG_GPIO_PCF857X=y
> CONFIG_GPIO_RC5T583=y
> CONFIG_GPIO_SX150X=y
> CONFIG_GPIO_STMPE=y
> # CONFIG_GPIO_TC3589X is not set
> # CONFIG_GPIO_TPS65912 is not set
> CONFIG_GPIO_WM831X=y
> CONFIG_GPIO_ADP5520=y
> # CONFIG_GPIO_ADP5588 is not set
> 
> #
> # PCI GPIO expanders:
> #
> # CONFIG_GPIO_BT8XX is not set
> # CONFIG_GPIO_AMD8111 is not set
> # CONFIG_GPIO_INTEL_MID is not set
> # CONFIG_GPIO_PCH is not set
> # CONFIG_GPIO_ML_IOH is not set
> # CONFIG_GPIO_RDC321X is not set
> 
> #
> # SPI GPIO expanders:
> #
> CONFIG_GPIO_MAX7301=y
> CONFIG_GPIO_MC33880=y
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # LPC GPIO expanders:
> #
> 
> #
> # MODULbus GPIO expanders:
> #
> # CONFIG_GPIO_PALMAS is not set
> # CONFIG_GPIO_TPS65910 is not set
> 
> #
> # USB GPIO expanders:
> #
> CONFIG_W1=y
> CONFIG_W1_CON=y
> 
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_MATROX is not set
> CONFIG_W1_MASTER_DS2490=y
> CONFIG_W1_MASTER_DS2482=y
> # CONFIG_W1_MASTER_DS1WM is not set
> CONFIG_W1_MASTER_GPIO=y
> 
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=y
> # CONFIG_W1_SLAVE_SMEM is not set
> CONFIG_W1_SLAVE_DS2408=y
> # CONFIG_W1_SLAVE_DS2408_READBACK is not set
> CONFIG_W1_SLAVE_DS2413=y
> CONFIG_W1_SLAVE_DS2423=y
> CONFIG_W1_SLAVE_DS2431=y
> CONFIG_W1_SLAVE_DS2433=y
> CONFIG_W1_SLAVE_DS2433_CRC=y
> CONFIG_W1_SLAVE_DS2760=y
> CONFIG_W1_SLAVE_DS2780=y
> CONFIG_W1_SLAVE_DS2781=y
> CONFIG_W1_SLAVE_DS28E04=y
> CONFIG_W1_SLAVE_BQ27000=y
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> CONFIG_WM831X_BACKUP=y
> # CONFIG_WM831X_POWER is not set
> CONFIG_TEST_POWER=y
> # CONFIG_BATTERY_DS2760 is not set
> CONFIG_BATTERY_DS2780=y
> CONFIG_BATTERY_DS2781=y
> # CONFIG_BATTERY_DS2782 is not set
> CONFIG_BATTERY_SBS=y
> # CONFIG_BATTERY_BQ27x00 is not set
> CONFIG_BATTERY_DA9052=y
> CONFIG_BATTERY_MAX17040=y
> CONFIG_BATTERY_MAX17042=y
> # CONFIG_CHARGER_ISP1704 is not set
> CONFIG_CHARGER_MAX8903=y
> CONFIG_CHARGER_LP8727=y
> # CONFIG_CHARGER_GPIO is not set
> # CONFIG_CHARGER_MANAGER is not set
> CONFIG_CHARGER_MAX8998=y
> CONFIG_CHARGER_BQ2415X=y
> # CONFIG_CHARGER_BQ24190 is not set
> CONFIG_CHARGER_BQ24735=y
> CONFIG_CHARGER_SMB347=y
> CONFIG_CHARGER_TPS65090=y
> # CONFIG_BATTERY_GOLDFISH is not set
> # CONFIG_POWER_RESET is not set
> # CONFIG_POWER_AVS is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> # CONFIG_SENSORS_ABITUGURU is not set
> CONFIG_SENSORS_ABITUGURU3=y
> CONFIG_SENSORS_AD7314=y
> # CONFIG_SENSORS_AD7414 is not set
> CONFIG_SENSORS_AD7418=y
> # CONFIG_SENSORS_ADCXX is not set
> # CONFIG_SENSORS_ADM1021 is not set
> CONFIG_SENSORS_ADM1025=y
> CONFIG_SENSORS_ADM1026=y
> CONFIG_SENSORS_ADM1029=y
> CONFIG_SENSORS_ADM1031=y
> CONFIG_SENSORS_ADM9240=y
> CONFIG_SENSORS_ADT7X10=y
> CONFIG_SENSORS_ADT7310=y
> CONFIG_SENSORS_ADT7410=y
> # CONFIG_SENSORS_ADT7411 is not set
> CONFIG_SENSORS_ADT7462=y
> CONFIG_SENSORS_ADT7470=y
> # CONFIG_SENSORS_ADT7475 is not set
> CONFIG_SENSORS_ASC7621=y
> # CONFIG_SENSORS_K8TEMP is not set
> # CONFIG_SENSORS_K10TEMP is not set
> # CONFIG_SENSORS_FAM15H_POWER is not set
> CONFIG_SENSORS_ASB100=y
> CONFIG_SENSORS_ATXP1=y
> # CONFIG_SENSORS_DS620 is not set
> CONFIG_SENSORS_DS1621=y
> # CONFIG_SENSORS_DA9052_ADC is not set
> CONFIG_SENSORS_DA9055=y
> # CONFIG_SENSORS_I5K_AMB is not set
> # CONFIG_SENSORS_F71805F is not set
> CONFIG_SENSORS_F71882FG=y
> CONFIG_SENSORS_F75375S=y
> CONFIG_SENSORS_FSCHMD=y
> CONFIG_SENSORS_G760A=y
> CONFIG_SENSORS_G762=y
> # CONFIG_SENSORS_GL518SM is not set
> CONFIG_SENSORS_GL520SM=y
> CONFIG_SENSORS_GPIO_FAN=y
> CONFIG_SENSORS_HIH6130=y
> CONFIG_SENSORS_HTU21=y
> CONFIG_SENSORS_CORETEMP=y
> # CONFIG_SENSORS_IT87 is not set
> CONFIG_SENSORS_JC42=y
> CONFIG_SENSORS_LINEAGE=y
> # CONFIG_SENSORS_LM63 is not set
> CONFIG_SENSORS_LM70=y
> CONFIG_SENSORS_LM73=y
> CONFIG_SENSORS_LM75=y
> CONFIG_SENSORS_LM77=y
> CONFIG_SENSORS_LM78=y
> CONFIG_SENSORS_LM80=y
> CONFIG_SENSORS_LM83=y
> CONFIG_SENSORS_LM85=y
> CONFIG_SENSORS_LM87=y
> # CONFIG_SENSORS_LM90 is not set
> # CONFIG_SENSORS_LM92 is not set
> # CONFIG_SENSORS_LM93 is not set
> # CONFIG_SENSORS_LTC4151 is not set
> CONFIG_SENSORS_LTC4215=y
> CONFIG_SENSORS_LTC4245=y
> CONFIG_SENSORS_LTC4261=y
> # CONFIG_SENSORS_LM95234 is not set
> CONFIG_SENSORS_LM95241=y
> CONFIG_SENSORS_LM95245=y
> CONFIG_SENSORS_MAX1111=y
> # CONFIG_SENSORS_MAX16065 is not set
> # CONFIG_SENSORS_MAX1619 is not set
> CONFIG_SENSORS_MAX1668=y
> # CONFIG_SENSORS_MAX197 is not set
> CONFIG_SENSORS_MAX6639=y
> CONFIG_SENSORS_MAX6642=y
> # CONFIG_SENSORS_MAX6650 is not set
> # CONFIG_SENSORS_MAX6697 is not set
> CONFIG_SENSORS_MCP3021=y
> CONFIG_SENSORS_NCT6775=y
> CONFIG_SENSORS_NTC_THERMISTOR=y
> CONFIG_SENSORS_PC87360=y
> CONFIG_SENSORS_PC87427=y
> CONFIG_SENSORS_PCF8591=y
> # CONFIG_PMBUS is not set
> CONFIG_SENSORS_SHT15=y
> # CONFIG_SENSORS_SHT21 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> # CONFIG_SENSORS_SMM665 is not set
> CONFIG_SENSORS_DME1737=y
> # CONFIG_SENSORS_EMC1403 is not set
> CONFIG_SENSORS_EMC2103=y
> CONFIG_SENSORS_EMC6W201=y
> CONFIG_SENSORS_SMSC47M1=y
> CONFIG_SENSORS_SMSC47M192=y
> CONFIG_SENSORS_SMSC47B397=y
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> # CONFIG_SENSORS_ADS1015 is not set
> CONFIG_SENSORS_ADS7828=y
> CONFIG_SENSORS_ADS7871=y
> # CONFIG_SENSORS_AMC6821 is not set
> CONFIG_SENSORS_INA209=y
> CONFIG_SENSORS_INA2XX=y
> CONFIG_SENSORS_THMC50=y
> CONFIG_SENSORS_TMP102=y
> CONFIG_SENSORS_TMP401=y
> CONFIG_SENSORS_TMP421=y
> CONFIG_SENSORS_VIA_CPUTEMP=y
> # CONFIG_SENSORS_VIA686A is not set
> CONFIG_SENSORS_VT1211=y
> # CONFIG_SENSORS_VT8231 is not set
> CONFIG_SENSORS_W83781D=y
> CONFIG_SENSORS_W83791D=y
> CONFIG_SENSORS_W83792D=y
> # CONFIG_SENSORS_W83793 is not set
> CONFIG_SENSORS_W83795=y
> CONFIG_SENSORS_W83795_FANCTRL=y
> CONFIG_SENSORS_W83L785TS=y
> # CONFIG_SENSORS_W83L786NG is not set
> CONFIG_SENSORS_W83627HF=y
> CONFIG_SENSORS_W83627EHF=y
> # CONFIG_SENSORS_WM831X is not set
> CONFIG_SENSORS_APPLESMC=y
> CONFIG_SENSORS_MC13783_ADC=y
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> # CONFIG_THERMAL_HWMON is not set
> # CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
> CONFIG_THERMAL_GOV_FAIR_SHARE=y
> CONFIG_THERMAL_GOV_STEP_WISE=y
> CONFIG_THERMAL_GOV_USER_SPACE=y
> # CONFIG_THERMAL_EMULATION is not set
> # CONFIG_INTEL_POWERCLAMP is not set
> # CONFIG_ACPI_INT3403_THERMAL is not set
> 
> #
> # Texas Instruments thermal drivers
> #
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=y
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_BLOCKIO=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> CONFIG_SSB_B43_PCI_BRIDGE=y
> CONFIG_SSB_SDIOHOST_POSSIBLE=y
> CONFIG_SSB_SDIOHOST=y
> CONFIG_SSB_DEBUG=y
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> CONFIG_SSB_DRIVER_PCICORE=y
> CONFIG_SSB_DRIVER_GPIO=y
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> # CONFIG_BCMA_HOST_SOC is not set
> CONFIG_BCMA_DRIVER_GMAC_CMN=y
> CONFIG_BCMA_DRIVER_GPIO=y
> # CONFIG_BCMA_DEBUG is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> # CONFIG_MFD_CS5535 is not set
> CONFIG_MFD_AS3711=y
> CONFIG_PMIC_ADP5520=y
> CONFIG_MFD_AAT2870_CORE=y
> CONFIG_MFD_CROS_EC=y
> CONFIG_MFD_CROS_EC_I2C=y
> # CONFIG_PMIC_DA903X is not set
> CONFIG_PMIC_DA9052=y
> CONFIG_MFD_DA9052_SPI=y
> CONFIG_MFD_DA9052_I2C=y
> CONFIG_MFD_DA9055=y
> CONFIG_MFD_DA9063=y
> CONFIG_MFD_MC13XXX=y
> CONFIG_MFD_MC13XXX_SPI=y
> # CONFIG_MFD_MC13XXX_I2C is not set
> CONFIG_HTC_PASIC3=y
> # CONFIG_HTC_I2CPLD is not set
> # CONFIG_LPC_ICH is not set
> # CONFIG_LPC_SCH is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> # CONFIG_MFD_KEMPLD is not set
> # CONFIG_MFD_88PM800 is not set
> CONFIG_MFD_88PM805=y
> # CONFIG_MFD_88PM860X is not set
> # CONFIG_MFD_MAX14577 is not set
> # CONFIG_MFD_MAX77686 is not set
> # CONFIG_MFD_MAX77693 is not set
> CONFIG_MFD_MAX8907=y
> # CONFIG_MFD_MAX8925 is not set
> # CONFIG_MFD_MAX8997 is not set
> CONFIG_MFD_MAX8998=y
> # CONFIG_EZX_PCAP is not set
> # CONFIG_MFD_VIPERBOARD is not set
> CONFIG_MFD_RETU=y
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_RTSX_PCI is not set
> CONFIG_MFD_RC5T583=y
> # CONFIG_MFD_SEC_CORE is not set
> # CONFIG_MFD_SI476X_CORE is not set
> CONFIG_MFD_SM501=y
> CONFIG_MFD_SM501_GPIO=y
> CONFIG_MFD_SMSC=y
> CONFIG_ABX500_CORE=y
> CONFIG_AB3100_CORE=y
> CONFIG_AB3100_OTP=y
> CONFIG_MFD_STMPE=y
> 
> #
> # STMicroelectronics STMPE Interface Drivers
> #
> # CONFIG_STMPE_I2C is not set
> # CONFIG_STMPE_SPI is not set
> # CONFIG_MFD_SYSCON is not set
> CONFIG_MFD_TI_AM335X_TSCADC=y
> # CONFIG_MFD_LP3943 is not set
> # CONFIG_MFD_LP8788 is not set
> CONFIG_MFD_PALMAS=y
> CONFIG_TPS6105X=y
> # CONFIG_TPS65010 is not set
> # CONFIG_TPS6507X is not set
> CONFIG_MFD_TPS65090=y
> CONFIG_MFD_TPS65217=y
> # CONFIG_MFD_TPS6586X is not set
> CONFIG_MFD_TPS65910=y
> CONFIG_MFD_TPS65912=y
> CONFIG_MFD_TPS65912_I2C=y
> # CONFIG_MFD_TPS65912_SPI is not set
> # CONFIG_MFD_TPS80031 is not set
> # CONFIG_TWL4030_CORE is not set
> # CONFIG_TWL6040_CORE is not set
> CONFIG_MFD_WL1273_CORE=y
> # CONFIG_MFD_LM3533 is not set
> # CONFIG_MFD_TIMBERDALE is not set
> CONFIG_MFD_TC3589X=y
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=y
> CONFIG_MFD_ARIZONA_SPI=y
> # CONFIG_MFD_WM5102 is not set
> CONFIG_MFD_WM5110=y
> # CONFIG_MFD_WM8997 is not set
> CONFIG_MFD_WM8400=y
> CONFIG_MFD_WM831X=y
> CONFIG_MFD_WM831X_I2C=y
> CONFIG_MFD_WM831X_SPI=y
> # CONFIG_MFD_WM8350_I2C is not set
> # CONFIG_MFD_WM8994 is not set
> CONFIG_REGULATOR=y
> CONFIG_REGULATOR_DEBUG=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
> # CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
> # CONFIG_REGULATOR_ACT8865 is not set
> CONFIG_REGULATOR_AD5398=y
> CONFIG_REGULATOR_AAT2870=y
> # CONFIG_REGULATOR_AB3100 is not set
> CONFIG_REGULATOR_AS3711=y
> # CONFIG_REGULATOR_DA9052 is not set
> # CONFIG_REGULATOR_DA9055 is not set
> CONFIG_REGULATOR_DA9063=y
> # CONFIG_REGULATOR_DA9210 is not set
> # CONFIG_REGULATOR_FAN53555 is not set
> # CONFIG_REGULATOR_GPIO is not set
> CONFIG_REGULATOR_ISL6271A=y
> CONFIG_REGULATOR_LP3971=y
> # CONFIG_REGULATOR_LP3972 is not set
> CONFIG_REGULATOR_LP872X=y
> # CONFIG_REGULATOR_LP8755 is not set
> # CONFIG_REGULATOR_MAX1586 is not set
> # CONFIG_REGULATOR_MAX8649 is not set
> # CONFIG_REGULATOR_MAX8660 is not set
> # CONFIG_REGULATOR_MAX8907 is not set
> CONFIG_REGULATOR_MAX8952=y
> CONFIG_REGULATOR_MAX8973=y
> CONFIG_REGULATOR_MAX8998=y
> CONFIG_REGULATOR_MC13XXX_CORE=y
> CONFIG_REGULATOR_MC13783=y
> # CONFIG_REGULATOR_MC13892 is not set
> CONFIG_REGULATOR_PALMAS=y
> # CONFIG_REGULATOR_PFUZE100 is not set
> CONFIG_REGULATOR_RC5T583=y
> # CONFIG_REGULATOR_TPS51632 is not set
> # CONFIG_REGULATOR_TPS6105X is not set
> CONFIG_REGULATOR_TPS62360=y
> CONFIG_REGULATOR_TPS65023=y
> CONFIG_REGULATOR_TPS6507X=y
> CONFIG_REGULATOR_TPS65090=y
> CONFIG_REGULATOR_TPS65217=y
> CONFIG_REGULATOR_TPS6524X=y
> CONFIG_REGULATOR_TPS65910=y
> # CONFIG_REGULATOR_TPS65912 is not set
> # CONFIG_REGULATOR_WM831X is not set
> # CONFIG_REGULATOR_WM8400 is not set
> CONFIG_MEDIA_SUPPORT=y
> 
> #
> # Multimedia core support
> #
> CONFIG_MEDIA_CAMERA_SUPPORT=y
> CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
> # CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
> # CONFIG_MEDIA_RADIO_SUPPORT is not set
> CONFIG_MEDIA_RC_SUPPORT=y
> CONFIG_MEDIA_CONTROLLER=y
> CONFIG_VIDEO_DEV=y
> # CONFIG_VIDEO_V4L2_SUBDEV_API is not set
> CONFIG_VIDEO_V4L2=y
> # CONFIG_VIDEO_ADV_DEBUG is not set
> # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
> CONFIG_VIDEO_TUNER=y
> CONFIG_VIDEOBUF_GEN=y
> CONFIG_VIDEOBUF_VMALLOC=y
> CONFIG_VIDEOBUF_DMA_CONTIG=y
> CONFIG_VIDEOBUF2_CORE=y
> CONFIG_VIDEOBUF2_MEMOPS=y
> CONFIG_VIDEOBUF2_DMA_CONTIG=y
> CONFIG_VIDEOBUF2_VMALLOC=y
> # CONFIG_TTPCI_EEPROM is not set
> 
> #
> # Media drivers
> #
> CONFIG_RC_CORE=y
> CONFIG_RC_MAP=y
> CONFIG_RC_DECODERS=y
> CONFIG_LIRC=y
> # CONFIG_IR_LIRC_CODEC is not set
> # CONFIG_IR_NEC_DECODER is not set
> CONFIG_IR_RC5_DECODER=y
> # CONFIG_IR_RC6_DECODER is not set
> CONFIG_IR_JVC_DECODER=y
> CONFIG_IR_SONY_DECODER=y
> # CONFIG_IR_RC5_SZ_DECODER is not set
> CONFIG_IR_SANYO_DECODER=y
> # CONFIG_IR_MCE_KBD_DECODER is not set
> # CONFIG_RC_DEVICES is not set
> CONFIG_MEDIA_USB_SUPPORT=y
> 
> #
> # Webcam devices
> #
> CONFIG_USB_VIDEO_CLASS=y
> CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
> CONFIG_USB_GSPCA=y
> CONFIG_USB_M5602=y
> CONFIG_USB_STV06XX=y
> CONFIG_USB_GL860=y
> CONFIG_USB_GSPCA_BENQ=y
> # CONFIG_USB_GSPCA_CONEX is not set
> # CONFIG_USB_GSPCA_CPIA1 is not set
> CONFIG_USB_GSPCA_ETOMS=y
> CONFIG_USB_GSPCA_FINEPIX=y
> # CONFIG_USB_GSPCA_JEILINJ is not set
> CONFIG_USB_GSPCA_JL2005BCD=y
> # CONFIG_USB_GSPCA_KINECT is not set
> CONFIG_USB_GSPCA_KONICA=y
> # CONFIG_USB_GSPCA_MARS is not set
> CONFIG_USB_GSPCA_MR97310A=y
> CONFIG_USB_GSPCA_NW80X=y
> CONFIG_USB_GSPCA_OV519=y
> CONFIG_USB_GSPCA_OV534=y
> CONFIG_USB_GSPCA_OV534_9=y
> CONFIG_USB_GSPCA_PAC207=y
> CONFIG_USB_GSPCA_PAC7302=y
> CONFIG_USB_GSPCA_PAC7311=y
> CONFIG_USB_GSPCA_SE401=y
> CONFIG_USB_GSPCA_SN9C2028=y
> CONFIG_USB_GSPCA_SN9C20X=y
> # CONFIG_USB_GSPCA_SONIXB is not set
> # CONFIG_USB_GSPCA_SONIXJ is not set
> CONFIG_USB_GSPCA_SPCA500=y
> CONFIG_USB_GSPCA_SPCA501=y
> # CONFIG_USB_GSPCA_SPCA505 is not set
> CONFIG_USB_GSPCA_SPCA506=y
> CONFIG_USB_GSPCA_SPCA508=y
> CONFIG_USB_GSPCA_SPCA561=y
> # CONFIG_USB_GSPCA_SPCA1528 is not set
> # CONFIG_USB_GSPCA_SQ905 is not set
> CONFIG_USB_GSPCA_SQ905C=y
> CONFIG_USB_GSPCA_SQ930X=y
> CONFIG_USB_GSPCA_STK014=y
> # CONFIG_USB_GSPCA_STK1135 is not set
> CONFIG_USB_GSPCA_STV0680=y
> # CONFIG_USB_GSPCA_SUNPLUS is not set
> CONFIG_USB_GSPCA_T613=y
> # CONFIG_USB_GSPCA_TOPRO is not set
> CONFIG_USB_GSPCA_TV8532=y
> CONFIG_USB_GSPCA_VC032X=y
> CONFIG_USB_GSPCA_VICAM=y
> CONFIG_USB_GSPCA_XIRLINK_CIT=y
> # CONFIG_USB_GSPCA_ZC3XX is not set
> CONFIG_USB_PWC=y
> CONFIG_USB_PWC_DEBUG=y
> # CONFIG_USB_PWC_INPUT_EVDEV is not set
> # CONFIG_VIDEO_CPIA2 is not set
> # CONFIG_USB_ZR364XX is not set
> # CONFIG_USB_STKWEBCAM is not set
> CONFIG_USB_S2255=y
> # CONFIG_VIDEO_USBTV is not set
> 
> #
> # Analog TV USB devices
> #
> CONFIG_VIDEO_PVRUSB2=y
> # CONFIG_VIDEO_PVRUSB2_SYSFS is not set
> CONFIG_VIDEO_HDPVR=y
> # CONFIG_VIDEO_USBVISION is not set
> # CONFIG_VIDEO_STK1160_COMMON is not set
> 
> #
> # Analog/digital TV USB devices
> #
> CONFIG_VIDEO_CX231XX=y
> # CONFIG_VIDEO_CX231XX_RC is not set
> # CONFIG_VIDEO_TM6000 is not set
> 
> #
> # Webcam, TV (analog/digital) USB devices
> #
> CONFIG_VIDEO_EM28XX=y
> # CONFIG_VIDEO_EM28XX_V4L2 is not set
> CONFIG_VIDEO_EM28XX_RC=y
> # CONFIG_MEDIA_PCI_SUPPORT is not set
> CONFIG_V4L_PLATFORM_DRIVERS=y
> # CONFIG_VIDEO_CAFE_CCIC is not set
> CONFIG_VIDEO_TIMBERDALE=y
> CONFIG_SOC_CAMERA=y
> CONFIG_SOC_CAMERA_SCALE_CROP=y
> # CONFIG_SOC_CAMERA_PLATFORM is not set
> CONFIG_VIDEO_RCAR_VIN=y
> # CONFIG_V4L_MEM2MEM_DRIVERS is not set
> # CONFIG_V4L_TEST_DRIVERS is not set
> 
> #
> # Supported MMC/SDIO adapters
> #
> # CONFIG_MEDIA_PARPORT_SUPPORT is not set
> CONFIG_VIDEO_CX2341X=y
> CONFIG_VIDEO_TVEEPROM=y
> CONFIG_CYPRESS_FIRMWARE=y
> 
> #
> # Media ancillary drivers (tuners, sensors, i2c, frontends)
> #
> # CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
> CONFIG_VIDEO_IR_I2C=y
> 
> #
> # Encoders, decoders, sensors and other helper chips
> #
> 
> #
> # Audio decoders, processors and mixers
> #
> # CONFIG_VIDEO_TVAUDIO is not set
> CONFIG_VIDEO_TDA7432=y
> CONFIG_VIDEO_TDA9840=y
> CONFIG_VIDEO_TEA6415C=y
> CONFIG_VIDEO_TEA6420=y
> CONFIG_VIDEO_MSP3400=y
> # CONFIG_VIDEO_CS5345 is not set
> CONFIG_VIDEO_CS53L32A=y
> # CONFIG_VIDEO_TLV320AIC23B is not set
> # CONFIG_VIDEO_UDA1342 is not set
> CONFIG_VIDEO_WM8775=y
> # CONFIG_VIDEO_WM8739 is not set
> CONFIG_VIDEO_VP27SMPX=y
> # CONFIG_VIDEO_SONY_BTF_MPX is not set
> 
> #
> # RDS decoders
> #
> # CONFIG_VIDEO_SAA6588 is not set
> 
> #
> # Video decoders
> #
> CONFIG_VIDEO_ADV7180=y
> CONFIG_VIDEO_ADV7183=y
> CONFIG_VIDEO_BT819=y
> CONFIG_VIDEO_BT856=y
> CONFIG_VIDEO_BT866=y
> CONFIG_VIDEO_KS0127=y
> CONFIG_VIDEO_ML86V7667=y
> CONFIG_VIDEO_SAA7110=y
> CONFIG_VIDEO_SAA711X=y
> # CONFIG_VIDEO_SAA7191 is not set
> # CONFIG_VIDEO_TVP514X is not set
> # CONFIG_VIDEO_TVP5150 is not set
> CONFIG_VIDEO_TVP7002=y
> # CONFIG_VIDEO_TW2804 is not set
> CONFIG_VIDEO_TW9903=y
> CONFIG_VIDEO_TW9906=y
> # CONFIG_VIDEO_VPX3220 is not set
> 
> #
> # Video and audio decoders
> #
> CONFIG_VIDEO_SAA717X=y
> CONFIG_VIDEO_CX25840=y
> 
> #
> # Video encoders
> #
> # CONFIG_VIDEO_SAA7127 is not set
> # CONFIG_VIDEO_SAA7185 is not set
> CONFIG_VIDEO_ADV7170=y
> CONFIG_VIDEO_ADV7175=y
> CONFIG_VIDEO_ADV7343=y
> # CONFIG_VIDEO_ADV7393 is not set
> # CONFIG_VIDEO_AK881X is not set
> CONFIG_VIDEO_THS8200=y
> 
> #
> # Camera sensor devices
> #
> CONFIG_VIDEO_OV7640=y
> # CONFIG_VIDEO_OV7670 is not set
> CONFIG_VIDEO_VS6624=y
> CONFIG_VIDEO_MT9V011=y
> CONFIG_VIDEO_SR030PC30=y
> 
> #
> # Flash devices
> #
> CONFIG_VIDEO_ADP1653=y
> # CONFIG_VIDEO_AS3645A is not set
> CONFIG_VIDEO_LM3560=y
> 
> #
> # Video improvement chips
> #
> CONFIG_VIDEO_UPD64031A=y
> CONFIG_VIDEO_UPD64083=y
> 
> #
> # Audio/Video compression chips
> #
> # CONFIG_VIDEO_SAA6752HS is not set
> 
> #
> # Miscellaneous helper chips
> #
> # CONFIG_VIDEO_THS7303 is not set
> CONFIG_VIDEO_M52790=y
> 
> #
> # Sensors used on soc_camera driver
> #
> 
> #
> # soc_camera sensor drivers
> #
> CONFIG_SOC_CAMERA_IMX074=y
> CONFIG_SOC_CAMERA_MT9M001=y
> CONFIG_SOC_CAMERA_MT9M111=y
> CONFIG_SOC_CAMERA_MT9T031=y
> CONFIG_SOC_CAMERA_MT9T112=y
> CONFIG_SOC_CAMERA_MT9V022=y
> CONFIG_SOC_CAMERA_OV2640=y
> CONFIG_SOC_CAMERA_OV5642=y
> # CONFIG_SOC_CAMERA_OV6650 is not set
> CONFIG_SOC_CAMERA_OV772X=y
> # CONFIG_SOC_CAMERA_OV9640 is not set
> # CONFIG_SOC_CAMERA_OV9740 is not set
> CONFIG_SOC_CAMERA_RJ54N1=y
> CONFIG_SOC_CAMERA_TW9910=y
> CONFIG_MEDIA_TUNER=y
> 
> #
> # Customize TV tuners
> #
> CONFIG_MEDIA_TUNER_SIMPLE=y
> CONFIG_MEDIA_TUNER_TDA8290=y
> CONFIG_MEDIA_TUNER_TDA827X=y
> CONFIG_MEDIA_TUNER_TDA18271=y
> CONFIG_MEDIA_TUNER_TDA9887=y
> CONFIG_MEDIA_TUNER_TEA5761=y
> CONFIG_MEDIA_TUNER_TEA5767=y
> CONFIG_MEDIA_TUNER_MT20XX=y
> CONFIG_MEDIA_TUNER_MT2060=y
> CONFIG_MEDIA_TUNER_MT2063=y
> # CONFIG_MEDIA_TUNER_MT2266 is not set
> # CONFIG_MEDIA_TUNER_MT2131 is not set
> CONFIG_MEDIA_TUNER_QT1010=y
> CONFIG_MEDIA_TUNER_XC2028=y
> CONFIG_MEDIA_TUNER_XC5000=y
> CONFIG_MEDIA_TUNER_XC4000=y
> # CONFIG_MEDIA_TUNER_MXL5005S is not set
> # CONFIG_MEDIA_TUNER_MXL5007T is not set
> # CONFIG_MEDIA_TUNER_MC44S803 is not set
> # CONFIG_MEDIA_TUNER_MAX2165 is not set
> # CONFIG_MEDIA_TUNER_TDA18218 is not set
> # CONFIG_MEDIA_TUNER_FC0011 is not set
> CONFIG_MEDIA_TUNER_FC0012=y
> CONFIG_MEDIA_TUNER_FC0013=y
> CONFIG_MEDIA_TUNER_TDA18212=y
> # CONFIG_MEDIA_TUNER_E4000 is not set
> CONFIG_MEDIA_TUNER_FC2580=y
> CONFIG_MEDIA_TUNER_M88TS2022=y
> CONFIG_MEDIA_TUNER_TUA9001=y
> CONFIG_MEDIA_TUNER_IT913X=y
> CONFIG_MEDIA_TUNER_R820T=y
> 
> #
> # Customise DVB Frontends
> #
> CONFIG_DVB_AU8522=y
> CONFIG_DVB_AU8522_V4L=y
> CONFIG_DVB_TUNER_DIB0070=y
> CONFIG_DVB_TUNER_DIB0090=y
> 
> #
> # Tools to develop new frontends
> #
> CONFIG_DVB_DUMMY_FE=y
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> # CONFIG_DRM is not set
> # CONFIG_VGASTATE is not set
> # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> # CONFIG_FB is not set
> # CONFIG_EXYNOS_VIDEO is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> # CONFIG_LCD_CLASS_DEVICE is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> # CONFIG_BACKLIGHT_GENERIC is not set
> # CONFIG_BACKLIGHT_PWM is not set
> CONFIG_BACKLIGHT_DA9052=y
> # CONFIG_BACKLIGHT_APPLE is not set
> CONFIG_BACKLIGHT_SAHARA=y
> CONFIG_BACKLIGHT_WM831X=y
> CONFIG_BACKLIGHT_ADP5520=y
> CONFIG_BACKLIGHT_ADP8860=y
> CONFIG_BACKLIGHT_ADP8870=y
> # CONFIG_BACKLIGHT_AAT2870 is not set
> CONFIG_BACKLIGHT_LM3630A=y
> CONFIG_BACKLIGHT_LM3639=y
> CONFIG_BACKLIGHT_LP855X=y
> CONFIG_BACKLIGHT_TPS65217=y
> CONFIG_BACKLIGHT_AS3711=y
> # CONFIG_BACKLIGHT_GPIO is not set
> CONFIG_BACKLIGHT_LV5207LP=y
> CONFIG_BACKLIGHT_BD6107=y
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> CONFIG_MDA_CONSOLE=y
> CONFIG_DUMMY_CONSOLE=y
> # CONFIG_SOUND is not set
> 
> #
> # HID support
> #
> CONFIG_HID=y
> CONFIG_HID_BATTERY_STRENGTH=y
> # CONFIG_HIDRAW is not set
> # CONFIG_UHID is not set
> CONFIG_HID_GENERIC=y
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> CONFIG_HID_ACRUX=y
> # CONFIG_HID_ACRUX_FF is not set
> CONFIG_HID_APPLE=y
> CONFIG_HID_AUREAL=y
> CONFIG_HID_BELKIN=y
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> CONFIG_HID_CYPRESS=y
> CONFIG_HID_DRAGONRISE=y
> CONFIG_DRAGONRISE_FF=y
> CONFIG_HID_EMS_FF=y
> CONFIG_HID_ELECOM=y
> CONFIG_HID_EZKEY=y
> CONFIG_HID_KEYTOUCH=y
> CONFIG_HID_KYE=y
> # CONFIG_HID_UCLOGIC is not set
> CONFIG_HID_WALTOP=y
> CONFIG_HID_GYRATION=y
> CONFIG_HID_ICADE=y
> CONFIG_HID_TWINHAN=y
> CONFIG_HID_KENSINGTON=y
> # CONFIG_HID_LCPOWER is not set
> CONFIG_HID_LENOVO_TPKBD=y
> CONFIG_HID_LOGITECH=y
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> CONFIG_LOGIG940_FF=y
> # CONFIG_LOGIWHEELS_FF is not set
> # CONFIG_HID_MAGICMOUSE is not set
> CONFIG_HID_MICROSOFT=y
> CONFIG_HID_MONTEREY=y
> CONFIG_HID_MULTITOUCH=y
> CONFIG_HID_ORTEK=y
> CONFIG_HID_PANTHERLORD=y
> CONFIG_PANTHERLORD_FF=y
> # CONFIG_HID_PETALYNX is not set
> CONFIG_HID_PICOLCD=y
> CONFIG_HID_PICOLCD_BACKLIGHT=y
> CONFIG_HID_PICOLCD_LEDS=y
> CONFIG_HID_PICOLCD_CIR=y
> CONFIG_HID_PRIMAX=y
> CONFIG_HID_SAITEK=y
> CONFIG_HID_SAMSUNG=y
> CONFIG_HID_SPEEDLINK=y
> # CONFIG_HID_STEELSERIES is not set
> CONFIG_HID_SUNPLUS=y
> CONFIG_HID_GREENASIA=y
> # CONFIG_GREENASIA_FF is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> CONFIG_HID_TIVO=y
> # CONFIG_HID_TOPSEED is not set
> CONFIG_HID_THINGM=y
> CONFIG_HID_THRUSTMASTER=y
> # CONFIG_THRUSTMASTER_FF is not set
> CONFIG_HID_WACOM=y
> CONFIG_HID_WIIMOTE=y
> CONFIG_HID_XINMO=y
> CONFIG_HID_ZEROPLUS=y
> # CONFIG_ZEROPLUS_FF is not set
> # CONFIG_HID_ZYDACRON is not set
> CONFIG_HID_SENSOR_HUB=y
> 
> #
> # USB HID support
> #
> # CONFIG_USB_HID is not set
> # CONFIG_HID_PID is not set
> 
> #
> # I2C HID support
> #
> CONFIG_I2C_HID=y
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB=y
> # CONFIG_USB_DEBUG is not set
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> 
> #
> # Miscellaneous USB options
> #
> # CONFIG_USB_DEFAULT_PERSIST is not set
> # CONFIG_USB_DYNAMIC_MINORS is not set
> CONFIG_USB_OTG=y
> CONFIG_USB_OTG_WHITELIST=y
> # CONFIG_USB_OTG_BLACKLIST_HUB is not set
> CONFIG_USB_MON=y
> CONFIG_USB_WUSB_CBAF=y
> # CONFIG_USB_WUSB_CBAF_DEBUG is not set
> 
> #
> # USB Host Controller Drivers
> #
> CONFIG_USB_C67X00_HCD=y
> CONFIG_USB_XHCI_HCD=y
> CONFIG_USB_XHCI_PLATFORM=y
> CONFIG_USB_EHCI_HCD=y
> # CONFIG_USB_EHCI_ROOT_HUB_TT is not set
> # CONFIG_USB_EHCI_TT_NEWSCHED is not set
> CONFIG_USB_EHCI_PCI=y
> CONFIG_USB_EHCI_HCD_PLATFORM=y
> # CONFIG_USB_OXU210HP_HCD is not set
> # CONFIG_USB_ISP116X_HCD is not set
> CONFIG_USB_ISP1760_HCD=y
> CONFIG_USB_ISP1362_HCD=y
> CONFIG_USB_FUSBH200_HCD=y
> CONFIG_USB_FOTG210_HCD=y
> CONFIG_USB_OHCI_HCD=y
> CONFIG_USB_OHCI_HCD_PCI=y
> CONFIG_USB_OHCI_HCD_SSB=y
> CONFIG_USB_OHCI_HCD_PLATFORM=y
> # CONFIG_USB_UHCI_HCD is not set
> CONFIG_USB_U132_HCD=y
> CONFIG_USB_SL811_HCD=y
> # CONFIG_USB_SL811_HCD_ISO is not set
> CONFIG_USB_R8A66597_HCD=y
> CONFIG_USB_RENESAS_USBHS_HCD=y
> CONFIG_USB_HCD_BCMA=y
> CONFIG_USB_HCD_SSB=y
> CONFIG_USB_HCD_TEST_MODE=y
> CONFIG_USB_RENESAS_USBHS=y
> 
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=y
> # CONFIG_USB_PRINTER is not set
> CONFIG_USB_WDM=y
> CONFIG_USB_TMC=y
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=y
> CONFIG_USB_STORAGE_DEBUG=y
> CONFIG_USB_STORAGE_REALTEK=y
> # CONFIG_REALTEK_AUTOPM is not set
> CONFIG_USB_STORAGE_DATAFAB=y
> # CONFIG_USB_STORAGE_FREECOM is not set
> # CONFIG_USB_STORAGE_ISD200 is not set
> CONFIG_USB_STORAGE_USBAT=y
> CONFIG_USB_STORAGE_SDDR09=y
> # CONFIG_USB_STORAGE_SDDR55 is not set
> CONFIG_USB_STORAGE_JUMPSHOT=y
> CONFIG_USB_STORAGE_ALAUDA=y
> # CONFIG_USB_STORAGE_ONETOUCH is not set
> CONFIG_USB_STORAGE_KARMA=y
> CONFIG_USB_STORAGE_CYPRESS_ATACB=y
> CONFIG_USB_STORAGE_ENE_UB6250=y
> 
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> CONFIG_USB_MICROTEK=y
> CONFIG_USB_MUSB_HDRC=y
> # CONFIG_USB_MUSB_HOST is not set
> CONFIG_USB_MUSB_GADGET=y
> # CONFIG_USB_MUSB_DUAL_ROLE is not set
> CONFIG_USB_MUSB_TUSB6010=y
> # CONFIG_USB_MUSB_UX500 is not set
> CONFIG_MUSB_PIO_ONLY=y
> CONFIG_USB_DWC3=y
> # CONFIG_USB_DWC3_HOST is not set
> # CONFIG_USB_DWC3_GADGET is not set
> CONFIG_USB_DWC3_DUAL_ROLE=y
> 
> #
> # Platform Glue Driver Support
> #
> # CONFIG_USB_DWC3_OMAP is not set
> # CONFIG_USB_DWC3_EXYNOS is not set
> CONFIG_USB_DWC3_PCI=y
> CONFIG_USB_DWC3_KEYSTONE=y
> 
> #
> # Debugging features
> #
> CONFIG_USB_DWC3_DEBUG=y
> CONFIG_USB_DWC3_VERBOSE=y
> # CONFIG_USB_DWC2 is not set
> # CONFIG_USB_CHIPIDEA is not set
> 
> #
> # USB port drivers
> #
> CONFIG_USB_USS720=y
> # CONFIG_USB_SERIAL is not set
> 
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> CONFIG_USB_EMI26=y
> CONFIG_USB_ADUTUX=y
> # CONFIG_USB_SEVSEG is not set
> # CONFIG_USB_RIO500 is not set
> CONFIG_USB_LEGOTOWER=y
> CONFIG_USB_LCD=y
> CONFIG_USB_LED=y
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> CONFIG_USB_CYTHERM=y
> # CONFIG_USB_IDMOUSE is not set
> CONFIG_USB_FTDI_ELAN=y
> CONFIG_USB_APPLEDISPLAY=y
> CONFIG_USB_SISUSBVGA=y
> CONFIG_USB_SISUSBVGA_CON=y
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> CONFIG_USB_IOWARRIOR=y
> CONFIG_USB_TEST=y
> CONFIG_USB_EHSET_TEST_FIXTURE=y
> CONFIG_USB_ISIGHTFW=y
> # CONFIG_USB_YUREX is not set
> CONFIG_USB_EZUSB_FX2=y
> CONFIG_USB_HSIC_USB3503=y
> CONFIG_USB_ATM=y
> CONFIG_USB_SPEEDTOUCH=y
> # CONFIG_USB_CXACRU is not set
> CONFIG_USB_UEAGLEATM=y
> # CONFIG_USB_XUSBATM is not set
> 
> #
> # USB Physical Layer drivers
> #
> CONFIG_USB_PHY=y
> # CONFIG_USB_OTG_FSM is not set
> # CONFIG_NOP_USB_XCEIV is not set
> CONFIG_SAMSUNG_USBPHY=y
> CONFIG_SAMSUNG_USB2PHY=y
> # CONFIG_SAMSUNG_USB3PHY is not set
> # CONFIG_USB_GPIO_VBUS is not set
> # CONFIG_TAHVO_USB is not set
> CONFIG_USB_ISP1301=y
> CONFIG_USB_RCAR_PHY=y
> CONFIG_USB_GADGET=y
> CONFIG_USB_GADGET_DEBUG=y
> # CONFIG_USB_GADGET_VERBOSE is not set
> CONFIG_USB_GADGET_DEBUG_FILES=y
> CONFIG_USB_GADGET_DEBUG_FS=y
> CONFIG_USB_GADGET_VBUS_DRAW=2
> CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
> 
> #
> # USB Peripheral Controller
> #
> # CONFIG_USB_FOTG210_UDC is not set
> # CONFIG_USB_GR_UDC is not set
> # CONFIG_USB_R8A66597 is not set
> # CONFIG_USB_RENESAS_USBHS_UDC is not set
> # CONFIG_USB_PXA27X is not set
> CONFIG_USB_MV_UDC=y
> CONFIG_USB_MV_U3D=y
> CONFIG_USB_M66592=y
> # CONFIG_USB_AMD5536UDC is not set
> CONFIG_USB_NET2272=y
> CONFIG_USB_NET2272_DMA=y
> # CONFIG_USB_NET2280 is not set
> # CONFIG_USB_GOKU is not set
> # CONFIG_USB_EG20T is not set
> CONFIG_USB_DUMMY_HCD=y
> CONFIG_USB_LIBCOMPOSITE=y
> CONFIG_USB_F_ACM=y
> CONFIG_USB_U_SERIAL=y
> CONFIG_USB_F_MASS_STORAGE=y
> # CONFIG_USB_CONFIGFS is not set
> # CONFIG_USB_ZERO is not set
> # CONFIG_USB_ETH is not set
> # CONFIG_USB_G_NCM is not set
> # CONFIG_USB_GADGETFS is not set
> # CONFIG_USB_FUNCTIONFS is not set
> # CONFIG_USB_MASS_STORAGE is not set
> # CONFIG_USB_G_SERIAL is not set
> # CONFIG_USB_G_PRINTER is not set
> # CONFIG_USB_CDC_COMPOSITE is not set
> # CONFIG_USB_G_NOKIA is not set
> CONFIG_USB_G_ACM_MS=y
> # CONFIG_USB_G_MULTI is not set
> # CONFIG_USB_G_HID is not set
> # CONFIG_USB_G_DBGP is not set
> # CONFIG_USB_G_WEBCAM is not set
> # CONFIG_UWB is not set
> CONFIG_MMC=y
> # CONFIG_MMC_DEBUG is not set
> CONFIG_MMC_UNSAFE_RESUME=y
> # CONFIG_MMC_CLKGATE is not set
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> CONFIG_MMC_BLOCK=y
> CONFIG_MMC_BLOCK_MINORS=8
> CONFIG_MMC_BLOCK_BOUNCE=y
> CONFIG_SDIO_UART=y
> # CONFIG_MMC_TEST is not set
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> # CONFIG_MMC_SDHCI is not set
> # CONFIG_MMC_WBSD is not set
> # CONFIG_MMC_TIFM_SD is not set
> # CONFIG_MMC_GOLDFISH is not set
> # CONFIG_MMC_CB710 is not set
> # CONFIG_MMC_VIA_SDMMC is not set
> CONFIG_MMC_VUB300=y
> CONFIG_MMC_USHC=y
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> # CONFIG_LEDS_LM3530 is not set
> # CONFIG_LEDS_LM3642 is not set
> CONFIG_LEDS_PCA9532=y
> CONFIG_LEDS_PCA9532_GPIO=y
> CONFIG_LEDS_GPIO=y
> # CONFIG_LEDS_LP3944 is not set
> CONFIG_LEDS_LP55XX_COMMON=y
> CONFIG_LEDS_LP5521=y
> CONFIG_LEDS_LP5523=y
> CONFIG_LEDS_LP5562=y
> CONFIG_LEDS_LP8501=y
> CONFIG_LEDS_CLEVO_MAIL=y
> # CONFIG_LEDS_PCA955X is not set
> CONFIG_LEDS_PCA963X=y
> CONFIG_LEDS_PCA9685=y
> # CONFIG_LEDS_WM831X_STATUS is not set
> CONFIG_LEDS_DA9052=y
> # CONFIG_LEDS_DAC124S085 is not set
> # CONFIG_LEDS_PWM is not set
> CONFIG_LEDS_REGULATOR=y
> CONFIG_LEDS_BD2802=y
> # CONFIG_LEDS_INTEL_SS4200 is not set
> CONFIG_LEDS_LT3593=y
> CONFIG_LEDS_ADP5520=y
> CONFIG_LEDS_MC13783=y
> # CONFIG_LEDS_TCA6507 is not set
> # CONFIG_LEDS_LM355x is not set
> # CONFIG_LEDS_OT200 is not set
> # CONFIG_LEDS_BLINKM is not set
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> CONFIG_LEDS_TRIGGER_TIMER=y
> # CONFIG_LEDS_TRIGGER_ONESHOT is not set
> # CONFIG_LEDS_TRIGGER_IDE_DISK is not set
> # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
> CONFIG_LEDS_TRIGGER_BACKLIGHT=y
> # CONFIG_LEDS_TRIGGER_CPU is not set
> CONFIG_LEDS_TRIGGER_GPIO=y
> CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> CONFIG_LEDS_TRIGGER_TRANSIENT=y
> CONFIG_LEDS_TRIGGER_CAMERA=y
> CONFIG_ACCESSIBILITY=y
> CONFIG_A11Y_BRAILLE_CONSOLE=y
> # CONFIG_INFINIBAND is not set
> CONFIG_EDAC=y
> # CONFIG_EDAC_LEGACY_SYSFS is not set
> # CONFIG_EDAC_DEBUG is not set
> # CONFIG_EDAC_MM_EDAC is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> # CONFIG_RTC_HCTOSYS is not set
> CONFIG_RTC_SYSTOHC=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> # CONFIG_RTC_INTF_SYSFS is not set
> # CONFIG_RTC_INTF_PROC is not set
> # CONFIG_RTC_INTF_DEV is not set
> CONFIG_RTC_DRV_TEST=y
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_DS1307=y
> # CONFIG_RTC_DRV_DS1374 is not set
> # CONFIG_RTC_DRV_DS1672 is not set
> CONFIG_RTC_DRV_DS3232=y
> CONFIG_RTC_DRV_MAX6900=y
> # CONFIG_RTC_DRV_MAX8907 is not set
> CONFIG_RTC_DRV_MAX8998=y
> # CONFIG_RTC_DRV_RS5C372 is not set
> # CONFIG_RTC_DRV_ISL1208 is not set
> CONFIG_RTC_DRV_ISL12022=y
> # CONFIG_RTC_DRV_ISL12057 is not set
> # CONFIG_RTC_DRV_X1205 is not set
> CONFIG_RTC_DRV_PALMAS=y
> CONFIG_RTC_DRV_PCF2127=y
> CONFIG_RTC_DRV_PCF8523=y
> CONFIG_RTC_DRV_PCF8563=y
> # CONFIG_RTC_DRV_PCF8583 is not set
> CONFIG_RTC_DRV_M41T80=y
> # CONFIG_RTC_DRV_M41T80_WDT is not set
> CONFIG_RTC_DRV_BQ32K=y
> CONFIG_RTC_DRV_TPS65910=y
> # CONFIG_RTC_DRV_RC5T583 is not set
> CONFIG_RTC_DRV_S35390A=y
> CONFIG_RTC_DRV_FM3130=y
> CONFIG_RTC_DRV_RX8581=y
> CONFIG_RTC_DRV_RX8025=y
> CONFIG_RTC_DRV_EM3027=y
> CONFIG_RTC_DRV_RV3029C2=y
> 
> #
> # SPI RTC drivers
> #
> # CONFIG_RTC_DRV_M41T93 is not set
> # CONFIG_RTC_DRV_M41T94 is not set
> CONFIG_RTC_DRV_DS1305=y
> # CONFIG_RTC_DRV_DS1390 is not set
> CONFIG_RTC_DRV_MAX6902=y
> CONFIG_RTC_DRV_R9701=y
> CONFIG_RTC_DRV_RS5C348=y
> # CONFIG_RTC_DRV_DS3234 is not set
> CONFIG_RTC_DRV_PCF2123=y
> CONFIG_RTC_DRV_RX4581=y
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> CONFIG_RTC_DRV_DS1286=y
> CONFIG_RTC_DRV_DS1511=y
> CONFIG_RTC_DRV_DS1553=y
> CONFIG_RTC_DRV_DS1742=y
> # CONFIG_RTC_DRV_DA9052 is not set
> CONFIG_RTC_DRV_DA9055=y
> CONFIG_RTC_DRV_STK17TA8=y
> CONFIG_RTC_DRV_M48T86=y
> # CONFIG_RTC_DRV_M48T35 is not set
> CONFIG_RTC_DRV_M48T59=y
> CONFIG_RTC_DRV_MSM6242=y
> # CONFIG_RTC_DRV_BQ4802 is not set
> CONFIG_RTC_DRV_RP5C01=y
> CONFIG_RTC_DRV_V3020=y
> # CONFIG_RTC_DRV_DS2404 is not set
> CONFIG_RTC_DRV_WM831X=y
> CONFIG_RTC_DRV_AB3100=y
> 
> #
> # on-CPU RTC drivers
> #
> # CONFIG_RTC_DRV_MC13XXX is not set
> # CONFIG_RTC_DRV_MOXART is not set
> 
> #
> # HID Sensor RTC drivers
> #
> CONFIG_DMADEVICES=y
> CONFIG_DMADEVICES_DEBUG=y
> CONFIG_DMADEVICES_VDEBUG=y
> 
> #
> # DMA Devices
> #
> # CONFIG_INTEL_MID_DMAC is not set
> # CONFIG_INTEL_IOATDMA is not set
> CONFIG_DW_DMAC_CORE=y
> # CONFIG_DW_DMAC is not set
> # CONFIG_DW_DMAC_PCI is not set
> CONFIG_TIMB_DMA=y
> # CONFIG_PCH_DMA is not set
> CONFIG_DMA_ENGINE=y
> CONFIG_DMA_ACPI=y
> 
> #
> # DMA Clients
> #
> # CONFIG_ASYNC_TX_DMA is not set
> CONFIG_DMATEST=y
> CONFIG_AUXDISPLAY=y
> # CONFIG_KS0108 is not set
> CONFIG_UIO=y
> # CONFIG_UIO_CIF is not set
> CONFIG_UIO_PDRV_GENIRQ=y
> CONFIG_UIO_DMEM_GENIRQ=y
> # CONFIG_UIO_AEC is not set
> # CONFIG_UIO_SERCOS3 is not set
> # CONFIG_UIO_PCI_GENERIC is not set
> # CONFIG_UIO_NETX is not set
> # CONFIG_UIO_MF624 is not set
> # CONFIG_VIRT_DRIVERS is not set
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_BALLOON is not set
> # CONFIG_VIRTIO_MMIO is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> # CONFIG_STAGING is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACERHDF is not set
> # CONFIG_ASUS_LAPTOP is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_FUJITSU_TABLET is not set
> # CONFIG_AMILO_RFKILL is not set
> # CONFIG_HP_ACCEL is not set
> # CONFIG_HP_WIRELESS is not set
> # CONFIG_MSI_LAPTOP is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_COMPAL_LAPTOP is not set
> # CONFIG_SONY_LAPTOP is not set
> # CONFIG_IDEAPAD_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_INTEL_MENLOW is not set
> # CONFIG_ACPI_WMI is not set
> # CONFIG_TOPSTAR_LAPTOP is not set
> # CONFIG_TOSHIBA_BT_RFKILL is not set
> # CONFIG_ACPI_CMPC is not set
> # CONFIG_INTEL_IPS is not set
> # CONFIG_IBM_RTL is not set
> # CONFIG_XO15_EBOOK is not set
> # CONFIG_SAMSUNG_LAPTOP is not set
> # CONFIG_INTEL_OAKTRAIL is not set
> # CONFIG_SAMSUNG_Q10 is not set
> # CONFIG_APPLE_GMUX is not set
> # CONFIG_INTEL_RST is not set
> # CONFIG_INTEL_SMARTCONNECT is not set
> # CONFIG_PVPANIC is not set
> CONFIG_GOLDFISH_PIPE=y
> # CONFIG_CHROME_PLATFORMS is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_SH_TIMER_CMT is not set
> # CONFIG_SH_TIMER_MTU2 is not set
> # CONFIG_SH_TIMER_TMU is not set
> # CONFIG_EM_TIMER_STI is not set
> # CONFIG_MAILBOX is not set
> CONFIG_IOMMU_SUPPORT=y
> 
> #
> # Remoteproc drivers
> #
> CONFIG_REMOTEPROC=y
> CONFIG_STE_MODEM_RPROC=y
> 
> #
> # Rpmsg drivers
> #
> # CONFIG_PM_DEVFREQ is not set
> CONFIG_EXTCON=y
> 
> #
> # Extcon Device Drivers
> #
> # CONFIG_EXTCON_GPIO is not set
> CONFIG_EXTCON_PALMAS=y
> CONFIG_MEMORY=y
> # CONFIG_IIO is not set
> # CONFIG_NTB is not set
> # CONFIG_VME_BUS is not set
> CONFIG_PWM=y
> CONFIG_PWM_SYSFS=y
> CONFIG_IPACK_BUS=y
> # CONFIG_BOARD_TPCI200 is not set
> CONFIG_SERIAL_IPOCTAL=y
> CONFIG_RESET_CONTROLLER=y
> CONFIG_FMC=y
> CONFIG_FMC_FAKEDEV=y
> # CONFIG_FMC_TRIVIAL is not set
> # CONFIG_FMC_WRITE_EEPROM is not set
> CONFIG_FMC_CHARDEV=y
> 
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
> # CONFIG_BCM_KONA_USB2_PHY is not set
> CONFIG_POWERCAP=y
> CONFIG_INTEL_RAPL=y
> 
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> CONFIG_FIRMWARE_MEMMAP=y
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> # CONFIG_DMIID is not set
> CONFIG_DMI_SYSFS=y
> CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> CONFIG_ISCSI_IBFT_FIND=y
> CONFIG_ISCSI_IBFT=y
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_EXT2_FS=y
> # CONFIG_EXT2_FS_XATTR is not set
> # CONFIG_EXT2_FS_XIP is not set
> # CONFIG_EXT3_FS is not set
> CONFIG_EXT4_FS=y
> # CONFIG_EXT4_USE_FOR_EXT23 is not set
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> # CONFIG_EXT4_DEBUG is not set
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> # CONFIG_REISERFS_FS is not set
> CONFIG_JFS_FS=y
> # CONFIG_JFS_POSIX_ACL is not set
> # CONFIG_JFS_SECURITY is not set
> CONFIG_JFS_DEBUG=y
> CONFIG_JFS_STATISTICS=y
> # CONFIG_XFS_FS is not set
> CONFIG_OCFS2_FS=y
> CONFIG_OCFS2_FS_O2CB=y
> # CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
> CONFIG_OCFS2_FS_STATS=y
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> # CONFIG_OCFS2_DEBUG_FS is not set
> # CONFIG_BTRFS_FS is not set
> # CONFIG_NILFS2_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_FANOTIFY is not set
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_PRINT_QUOTA_WARNING=y
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=y
> # CONFIG_QFMT_V1 is not set
> # CONFIG_QFMT_V2 is not set
> CONFIG_QUOTACTL=y
> CONFIG_AUTOFS4_FS=y
> # CONFIG_FUSE_FS is not set
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> # CONFIG_FSCACHE_STATS is not set
> # CONFIG_FSCACHE_HISTOGRAM is not set
> # CONFIG_FSCACHE_DEBUG is not set
> CONFIG_FSCACHE_OBJECT_LIST=y
> CONFIG_CACHEFILES=y
> # CONFIG_CACHEFILES_DEBUG is not set
> # CONFIG_CACHEFILES_HISTOGRAM is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> # CONFIG_ISO9660_FS is not set
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> # CONFIG_MSDOS_FS is not set
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> CONFIG_NTFS_FS=y
> CONFIG_NTFS_DEBUG=y
> # CONFIG_NTFS_RW is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> # CONFIG_PROC_KCORE is not set
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> # CONFIG_TMPFS is not set
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_ECRYPT_FS is not set
> CONFIG_HFS_FS=y
> CONFIG_HFSPLUS_FS=y
> CONFIG_HFSPLUS_FS_POSIX_ACL=y
> CONFIG_BEFS_FS=y
> # CONFIG_BEFS_DEBUG is not set
> CONFIG_BFS_FS=y
> # CONFIG_EFS_FS is not set
> # CONFIG_LOGFS is not set
> # CONFIG_CRAMFS is not set
> CONFIG_SQUASHFS=y
> # CONFIG_SQUASHFS_FILE_CACHE is not set
> CONFIG_SQUASHFS_FILE_DIRECT=y
> # CONFIG_SQUASHFS_DECOMP_SINGLE is not set
> CONFIG_SQUASHFS_DECOMP_MULTI=y
> # CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
> CONFIG_SQUASHFS_XATTR=y
> CONFIG_SQUASHFS_ZLIB=y
> # CONFIG_SQUASHFS_LZO is not set
> # CONFIG_SQUASHFS_XZ is not set
> CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
> CONFIG_SQUASHFS_EMBEDDED=y
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> CONFIG_VXFS_FS=y
> # CONFIG_MINIX_FS is not set
> CONFIG_OMFS_FS=y
> CONFIG_HPFS_FS=y
> CONFIG_QNX4FS_FS=y
> CONFIG_QNX6FS_FS=y
> CONFIG_QNX6FS_DEBUG=y
> CONFIG_ROMFS_FS=y
> CONFIG_ROMFS_BACKED_BY_BLOCK=y
> CONFIG_ROMFS_ON_BLOCK=y
> # CONFIG_PSTORE is not set
> CONFIG_SYSV_FS=y
> # CONFIG_UFS_FS is not set
> CONFIG_F2FS_FS=y
> # CONFIG_F2FS_STAT_FS is not set
> # CONFIG_F2FS_FS_XATTR is not set
> # CONFIG_F2FS_CHECK_FS is not set
> # CONFIG_NETWORK_FILESYSTEMS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_CODEPAGE_737=y
> CONFIG_NLS_CODEPAGE_775=y
> # CONFIG_NLS_CODEPAGE_850 is not set
> CONFIG_NLS_CODEPAGE_852=y
> CONFIG_NLS_CODEPAGE_855=y
> CONFIG_NLS_CODEPAGE_857=y
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> CONFIG_NLS_CODEPAGE_863=y
> # CONFIG_NLS_CODEPAGE_864 is not set
> CONFIG_NLS_CODEPAGE_865=y
> CONFIG_NLS_CODEPAGE_866=y
> CONFIG_NLS_CODEPAGE_869=y
> CONFIG_NLS_CODEPAGE_936=y
> CONFIG_NLS_CODEPAGE_950=y
> # CONFIG_NLS_CODEPAGE_932 is not set
> CONFIG_NLS_CODEPAGE_949=y
> CONFIG_NLS_CODEPAGE_874=y
> CONFIG_NLS_ISO8859_8=y
> # CONFIG_NLS_CODEPAGE_1250 is not set
> CONFIG_NLS_CODEPAGE_1251=y
> CONFIG_NLS_ASCII=y
> # CONFIG_NLS_ISO8859_1 is not set
> CONFIG_NLS_ISO8859_2=y
> # CONFIG_NLS_ISO8859_3 is not set
> CONFIG_NLS_ISO8859_4=y
> CONFIG_NLS_ISO8859_5=y
> CONFIG_NLS_ISO8859_6=y
> CONFIG_NLS_ISO8859_7=y
> CONFIG_NLS_ISO8859_9=y
> CONFIG_NLS_ISO8859_13=y
> CONFIG_NLS_ISO8859_14=y
> CONFIG_NLS_ISO8859_15=y
> # CONFIG_NLS_KOI8_R is not set
> CONFIG_NLS_KOI8_U=y
> CONFIG_NLS_MAC_ROMAN=y
> CONFIG_NLS_MAC_CELTIC=y
> CONFIG_NLS_MAC_CENTEURO=y
> # CONFIG_NLS_MAC_CROATIAN is not set
> # CONFIG_NLS_MAC_CYRILLIC is not set
> CONFIG_NLS_MAC_GAELIC=y
> CONFIG_NLS_MAC_GREEK=y
> # CONFIG_NLS_MAC_ICELAND is not set
> # CONFIG_NLS_MAC_INUIT is not set
> CONFIG_NLS_MAC_ROMANIAN=y
> CONFIG_NLS_MAC_TURKISH=y
> CONFIG_NLS_UTF8=y
> CONFIG_DLM=y
> # CONFIG_DLM_DEBUG is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> 
> #
> # printk and dmesg options
> #
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_DEBUG_INFO is not set
> CONFIG_ENABLE_WARN_DEPRECATED=y
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_READABLE_ASM is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_WANT_PAGE_DEBUG_FLAGS=y
> CONFIG_PAGE_GUARD=y
> CONFIG_DEBUG_OBJECTS=y
> CONFIG_DEBUG_OBJECTS_SELFTEST=y
> CONFIG_DEBUG_OBJECTS_FREE=y
> CONFIG_DEBUG_OBJECTS_TIMERS=y
> CONFIG_DEBUG_OBJECTS_WORK=y
> # CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
> # CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
> # CONFIG_SLUB_DEBUG_ON is not set
> CONFIG_SLUB_STATS=y
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> CONFIG_DEBUG_STACK_USAGE=y
> CONFIG_DEBUG_VM=y
> CONFIG_DEBUG_VM_RB=y
> # CONFIG_DEBUG_VIRTUAL is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_DEBUG_PER_CPU_MAPS=y
> # CONFIG_DEBUG_HIGHMEM is not set
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> CONFIG_DEBUG_STACKOVERFLOW=y
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_KMEMCHECK is not set
> CONFIG_DEBUG_SHIRQ=y
> 
> #
> # Debug Lockups and Hangs
> #
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> # CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
> CONFIG_PANIC_ON_OOPS=y
> CONFIG_PANIC_ON_OOPS_VALUE=1
> CONFIG_PANIC_TIMEOUT=0
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> # CONFIG_TIMER_STATS is not set
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> # CONFIG_DEBUG_RT_MUTEXES is not set
> CONFIG_RT_MUTEX_TESTER=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> # CONFIG_DEBUG_KOBJECT_RELEASE is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_WRITECOUNT=y
> # CONFIG_DEBUG_LIST is not set
> CONFIG_DEBUG_SG=y
> # CONFIG_DEBUG_NOTIFIERS is not set
> CONFIG_DEBUG_CREDENTIALS=y
> 
> #
> # RCU Debugging
> #
> # CONFIG_PROVE_RCU is not set
> CONFIG_SPARSE_RCU_POINTER=y
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> CONFIG_RCU_CPU_STALL_INFO=y
> CONFIG_RCU_TRACE=y
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_LATENCYTOP=y
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACE_CLOCK=y
> CONFIG_TRACING_SUPPORT=y
> # CONFIG_FTRACE is not set
> 
> #
> # Runtime Testing
> #
> CONFIG_LKDTM=y
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_RBTREE_TEST=y
> CONFIG_ATOMIC64_SELFTEST=y
> CONFIG_ASYNC_RAID6_TEST=y
> CONFIG_TEST_STRING_HELPERS=y
> # CONFIG_TEST_KSTRTOX is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_STRICT_DEVMEM=y
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> # CONFIG_X86_PTDUMP is not set
> # CONFIG_DEBUG_RODATA is not set
> CONFIG_DOUBLEFAULT=y
> # CONFIG_DEBUG_TLBFLUSH is not set
> CONFIG_IOMMU_STRESS=y
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> CONFIG_IO_DELAY_UDELAY=y
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=2
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_OPTIMIZE_INLINING is not set
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> # CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> CONFIG_PERSISTENT_KEYRINGS=y
> CONFIG_TRUSTED_KEYS=y
> CONFIG_ENCRYPTED_KEYS=y
> CONFIG_KEYS_DEBUG_PROC_KEYS=y
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> CONFIG_SECURITY=y
> CONFIG_SECURITYFS=y
> CONFIG_SECURITY_NETWORK=y
> CONFIG_SECURITY_NETWORK_XFRM=y
> CONFIG_SECURITY_PATH=y
> CONFIG_LSM_MMAP_MIN_ADDR=65536
> CONFIG_SECURITY_SELINUX=y
> # CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
> # CONFIG_SECURITY_SELINUX_DISABLE is not set
> CONFIG_SECURITY_SELINUX_DEVELOP=y
> # CONFIG_SECURITY_SELINUX_AVC_STATS is not set
> CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
> # CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
> CONFIG_SECURITY_SMACK=y
> # CONFIG_SECURITY_TOMOYO is not set
> CONFIG_SECURITY_APPARMOR=y
> CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
> CONFIG_SECURITY_APPARMOR_HASH=y
> # CONFIG_SECURITY_YAMA is not set
> CONFIG_INTEGRITY=y
> # CONFIG_INTEGRITY_SIGNATURE is not set
> # CONFIG_INTEGRITY_AUDIT is not set
> # CONFIG_IMA is not set
> CONFIG_EVM=y
> CONFIG_EVM_HMAC_VERSION=2
> # CONFIG_DEFAULT_SECURITY_SELINUX is not set
> CONFIG_DEFAULT_SECURITY_SMACK=y
> # CONFIG_DEFAULT_SECURITY_APPARMOR is not set
> # CONFIG_DEFAULT_SECURITY_DAC is not set
> CONFIG_DEFAULT_SECURITY="smack"
> CONFIG_XOR_BLOCKS=y
> CONFIG_ASYNC_CORE=y
> CONFIG_ASYNC_MEMCPY=y
> CONFIG_ASYNC_XOR=y
> CONFIG_ASYNC_PQ=y
> CONFIG_ASYNC_RAID6_RECOV=y
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> # CONFIG_CRYPTO_USER is not set
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_PCRYPT=y
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> CONFIG_CRYPTO_ABLK_HELPER=y
> CONFIG_CRYPTO_GLUE_HELPER_X86=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> CONFIG_CRYPTO_GCM=y
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=y
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=y
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
> # CONFIG_CRYPTO_VMAC is not set
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> CONFIG_CRYPTO_CRC32=y
> CONFIG_CRYPTO_CRC32_PCLMUL=y
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_GHASH=y
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=y
> # CONFIG_CRYPTO_RMD128 is not set
> CONFIG_CRYPTO_RMD160=y
> CONFIG_CRYPTO_RMD256=y
> # CONFIG_CRYPTO_RMD320 is not set
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> # CONFIG_CRYPTO_TGR192 is not set
> CONFIG_CRYPTO_WP512=y
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=y
> CONFIG_CRYPTO_AES_NI_INTEL=y
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> CONFIG_CRYPTO_CAST_COMMON=y
> CONFIG_CRYPTO_CAST5=y
> CONFIG_CRYPTO_CAST6=y
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_FCRYPT=y
> CONFIG_CRYPTO_KHAZAD=y
> # CONFIG_CRYPTO_SALSA20 is not set
> CONFIG_CRYPTO_SALSA20_586=y
> # CONFIG_CRYPTO_SEED is not set
> CONFIG_CRYPTO_SERPENT=y
> CONFIG_CRYPTO_SERPENT_SSE2_586=y
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_586=y
> 
> #
> # Compression
> #
> # CONFIG_CRYPTO_DEFLATE is not set
> CONFIG_CRYPTO_ZLIB=y
> CONFIG_CRYPTO_LZO=y
> CONFIG_CRYPTO_LZ4=y
> CONFIG_CRYPTO_LZ4HC=y
> 
> #
> # Random Number Generation
> #
> # CONFIG_CRYPTO_ANSI_CPRNG is not set
> CONFIG_CRYPTO_USER_API=y
> # CONFIG_CRYPTO_USER_API_HASH is not set
> CONFIG_CRYPTO_USER_API_SKCIPHER=y
> CONFIG_CRYPTO_HASH_INFO=y
> CONFIG_CRYPTO_HW=y
> # CONFIG_CRYPTO_DEV_PADLOCK is not set
> # CONFIG_CRYPTO_DEV_GEODE is not set
> # CONFIG_CRYPTO_DEV_CCP is not set
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> CONFIG_PUBLIC_KEY_ALGO_RSA=y
> CONFIG_X509_CERTIFICATE_PARSER=y
> CONFIG_HAVE_KVM=y
> CONFIG_VIRTUALIZATION=y
> CONFIG_LGUEST=y
> # CONFIG_BINARY_PRINTF is not set
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=y
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC32_SELFTEST=y
> CONFIG_CRC32_SLICEBY8=y
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=y
> CONFIG_AUDIT_GENERIC=y
> CONFIG_RANDOM32_SELFTEST=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4_COMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> # CONFIG_XZ_DEC_X86 is not set
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> # CONFIG_XZ_DEC_ARM is not set
> # CONFIG_XZ_DEC_ARMTHUMB is not set
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_XZ=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_DECOMPRESS_LZ4=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_CPUMASK_OFFSTACK=y
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> CONFIG_AVERAGE=y
> CONFIG_CLZ_TAB=y
> CONFIG_CORDIC=y
> # CONFIG_DDR is not set
> CONFIG_MPILIB=y
> CONFIG_OID_REGISTRY=y
> CONFIG_FONT_SUPPORT=y
> CONFIG_FONT_8x16=y
> CONFIG_FONT_AUTOSELECT=y
> 
> 

