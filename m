Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaE1HhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:37:11 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:51061 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094AbaE1HhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:37:08 -0400
Date: Wed, 28 May 2014 10:36:58 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: sparc64: hugetlb-related possible irq lock inversion dependency
 detected
Message-ID: <alpine.SOC.1.00.1405281033170.8409@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I revived my V240 and tried 3.15.0-rc7 on it. Works but got this lockdep 
warning during debian update:

[  427.942320] 
[  427.961785] =========================================================
[  428.046421] [ INFO: possible irq lock inversion dependency detected ]
[  428.131065] 3.15.0-rc7 #2 Not tainted
[  428.179091] ---------------------------------------------------------
[  428.263738] dpkg-deb/3253 just changed the state of lock:
[  428.334652]  (ctx_alloc_lock){+.....}, at: [<00000000004503e4>] hugetlb_setup+0xc4/0x120
[  428.441023] but this lock was taken by another, HARDIRQ-safe lock in the past:
[  428.535963]  (&rq->lock){-.-.-.}
[  428.535963] 
[  428.535963] and interrupts could create inverse lock ordering between them.
[  428.535963] 
[  428.657213] 
[  428.657213] other info that might help us debug this:
[  428.743092] Chain exists of:
[  428.743092]   &rq->lock --> &(&mm->context.lock)->rlock --> ctx_alloc_lock
[  428.743092] 
[  428.856308]  Possible interrupt unsafe locking scenario:
[  428.856308] 
[  428.945538]        CPU0                    CPU1
[  429.005005]        ----                    ----
[  429.064480]   lock(ctx_alloc_lock);
[  429.110222]                                local_irq_disable();
[  429.188012]                                lock(&rq->lock);
[  429.261199]                                lock(&(&mm->context.lock)->rlock);
[  429.354991]   <Interrupt>
[  429.389308]     lock(&rq->lock);
[  429.431622] 
[  429.431622]  *** DEADLOCK ***
[  429.431622] 
[  429.509426] no locks held by dpkg-deb/3253.
[  429.564311] 
[  429.564311] the shortest dependencies between 2nd lock and 1st lock:
[  429.667267]   -> (&rq->lock){-.-.-.} ops: 1524679030341632 {
[  429.741588]      IN-HARDIRQ-W at:
[  429.785053]                         [<00000000004ad234>] __lock_acquire+0x6d4/0x960
[  429.885718]                         [<00000000004ada6c>] lock_acquire+0x4c/0x80
[  429.981795]                         [<000000000083f628>] _raw_spin_lock+0x28/0x40
[  430.080160]                         [<000000000048fbec>] scheduler_tick+0x2c/0xc0
[  430.178523]                         [<000000000046a748>] update_process_times+0x48/0x60
[  430.283752]                         [<00000000004cf65c>] tick_periodic+0xbc/0xe0
[  430.380971]                         [<00000000004cf68c>] tick_handle_periodic+0xc/0x80
[  430.485058]                         [<000000000042fbf4>] timer_interrupt+0x94/0xc0
[  430.584564]                         [<0000000000426b84>] valid_addr_bitmap_patch+0xbc/0x238
[  430.694368]                         [<00000000004bbc48>] console_unlock+0x2a8/0x360
[  430.795020]                         [<0000000000a2dd4c>] con_init+0x2a0/0x2c0
[  430.888802]                         [<0000000000a2d328>] console_init+0x1c/0x38
[  430.984885]                         [<0000000000a167d8>] start_kernel+0x268/0x370
[  431.083252]                         [<000000000082c50c>] tlb_fixup_done+0xa0/0xb4
[  431.181616]                         [<          (null)>]           (null)
[  431.270826]      IN-SOFTIRQ-W at:
[  431.314281]                         [<00000000004ad234>] __lock_acquire+0x6d4/0x960
[  431.414947]                         [<00000000004ada6c>] lock_acquire+0x4c/0x80
[  431.511025]                         [<000000000083f700>] _raw_spin_lock_irqsave+0x40/0x60
[  431.618542]                         [<00000000004978e4>] update_blocked_averages+0x24/0x180
[  431.728344]                         [<000000000049dba4>] rebalance_domains+0x24/0x3a0
[  431.831283]                         [<000000000049e0e0>] run_rebalance_domains+0x20/0x40
[  431.937654]                         [<0000000000462950>] __do_softirq+0xf0/0x240
[  432.034875]                         [<000000000042bc0c>] do_softirq_own_stack+0x2c/0x40
[  432.140102]                         [<0000000000462d8c>] irq_exit+0x4c/0xc0
[  432.231597]                         [<000000000042fbfc>] timer_interrupt+0x9c/0xc0
[  432.331113]                         [<0000000000426b84>] valid_addr_bitmap_patch+0xbc/0x238
[  432.440917]                         [<000000000042c60c>] arch_cpu_idle+0x2c/0xe0
[  432.538137]                         [<00000000004a5c88>] cpuidle_idle_call+0x48/0xc0
[  432.639934]                         [<00000000004a5e10>] cpu_idle_loop+0x110/0x160
[  432.739442]                         [<00000000004a5e78>] cpu_startup_entry+0x18/0x40
[  432.841239]                         [<000000000082c698>] rest_init+0x178/0x1a0
[  432.936171]                         [<0000000000a168d0>] start_kernel+0x360/0x370
[  433.034536]                         [<000000000082c50c>] tlb_fixup_done+0xa0/0xb4
[  433.132901]                         [<          (null)>]           (null)
[  433.222109]      IN-RECLAIM_FS-W at:
[  433.268997]                            [<00000000004ad234>] __lock_acquire+0x6d4/0x960
[  433.373094]                            [<00000000004ada6c>] lock_acquire+0x4c/0x80
[  433.472604]                            [<000000000083f628>] _raw_spin_lock+0x28/0x40
[  433.574399]                            [<000000000048ade0>] task_rq_lock+0x40/0xa0
[  433.673906]                            [<0000000000492c08>] set_cpus_allowed_ptr+0x8/0x140
[  433.782568]                            [<0000000000515630>] kswapd+0x30/0x1c0
[  433.876350]                            [<0000000000482610>] kthread+0xb0/0xe0
[  433.970138]                            [<00000000004060c4>] ret_from_fork+0x1c/0x2c
[  434.070800]                            [<          (null)>]           (null)
[  434.163436]      INITIAL USE at:
[  434.205750]                        [<00000000004ada6c>] lock_acquire+0x4c/0x80
[  434.300698]                        [<000000000083f700>] _raw_spin_lock_irqsave+0x40/0x60
[  434.407072]                        [<000000000048bd64>] rq_attach_root+0x4/0x1e0
[  434.504290]                        [<0000000000a1ef6c>] sched_init+0x2f4/0x460
[  434.599223]                        [<0000000000a166f4>] start_kernel+0x184/0x370
[  434.696444]                        [<000000000082c50c>] tlb_fixup_done+0xa0/0xb4
[  434.793666]                        [<          (null)>]           (null)
[  434.881730]    }
[  434.905746]    ... key      at: [<0000000001081bac>] __key.43057+0x0/0xc
[  434.993822]    ... acquired at:
[  435.034994]    [<00000000004ac230>] validate_chain.isra.14+0x4d0/0x5e0
[  435.120782]    [<00000000004ad408>] __lock_acquire+0x8a8/0x960
[  435.197413]    [<00000000004ada6c>] lock_acquire+0x4c/0x80
[  435.269469]    [<000000000083f700>] _raw_spin_lock_irqsave+0x40/0x60
[  435.352967]    [<000000000083b604>] __schedule+0x4e4/0x700
[  435.425025]    [<000000000083b9c0>] schedule+0x60/0x80
[  435.492507]    [<0000000000489c5c>] smpboot_thread_fn+0x21c/0x260
[  435.572573]    [<0000000000482610>] kthread+0xb0/0xe0
[  435.638909]    [<00000000004060c4>] ret_from_fork+0x1c/0x2c
[  435.712114]    [<          (null)>]           (null)
[  435.777307] 
[  435.796748]  -> (&(&mm->context.lock)->rlock){......} ops: 5660234320183296 {
[  435.890535]     INITIAL USE at:
[  435.931710]                      [<00000000004ada6c>] lock_acquire+0x4c/0x80
[  436.024365]                      [<000000000083f700>] _raw_spin_lock_irqsave+0x40/0x60
[  436.128456]                      [<000000000044dfb4>] tsb_grow+0xf4/0x240
[  436.217662]                      [<000000000044e140>] init_new_context+0x40/0x80
[  436.314890]                      [<000000000056311c>] do_execve_common.isra.20+0xfc/0x2e0
[  436.422406]                      [<0000000000563314>] do_execve+0x14/0x40
[  436.511613]                      [<0000000000426d20>] run_init_process+0x20/0x40
[  436.608841]                      [<0000000000426d44>] try_to_run_init_process+0x4/0x60
[  436.712925]                      [<000000000082c754>] kernel_init+0x94/0x100
[  436.805565]                      [<00000000004060c4>] ret_from_fork+0x1c/0x2c
[  436.899354]                      [<          (null)>]           (null)
[  436.985137]   }
[  437.008008]   ... key      at: [<0000000000a5a528>] __key.23586+0x0/0x8
[  437.094940]   ... acquired at:
[  437.134970]    [<00000000004ac230>] validate_chain.isra.14+0x4d0/0x5e0
[  437.220759]    [<00000000004ad408>] __lock_acquire+0x8a8/0x960
[  437.297389]    [<00000000004ada6c>] lock_acquire+0x4c/0x80
[  437.369446]    [<000000000083f628>] _raw_spin_lock+0x28/0x40
[  437.443793]    [<000000000044fc30>] get_new_mmu_context+0x10/0x160
[  437.525000]    [<0000000000562410>] exec_mmap+0x90/0x260
[  437.594770]    [<0000000000562610>] flush_old_exec+0x30/0xa0
[  437.669117]    [<00000000005b3a10>] load_elf_binary+0x350/0xae0
[  437.746895]    [<0000000000561d4c>] search_binary_handler+0x8c/0x220
[  437.830391]    [<00000000008336fc>] exec_binprm+0x134/0x1a0
[  437.903589]    [<00000000005631fc>] do_execve_common.isra.20+0x1dc/0x2e0
[  437.991664]    [<0000000000563314>] do_execve+0x14/0x40
[  438.060287]    [<0000000000426d20>] run_init_process+0x20/0x40
[  438.136921]    [<0000000000426d44>] try_to_run_init_process+0x4/0x60
[  438.220419]    [<000000000082c754>] kernel_init+0x94/0x100
[  438.292474]    [<00000000004060c4>] ret_from_fork+0x1c/0x2c
[  438.365677]    [<          (null)>]           (null)
[  438.430871] 
[  438.450311] -> (ctx_alloc_lock){+.....} ops: 41008347742208 {
[  438.525799]    HARDIRQ-ON-W at:
[  438.566975]                     [<00000000004ad234>] __lock_acquire+0x6d4/0x960
[  438.663064]                     [<00000000004ada6c>] lock_acquire+0x4c/0x80
[  438.754562]                     [<000000000083f628>] _raw_spin_lock+0x28/0x40
[  438.848351]                     [<00000000004503e4>] hugetlb_setup+0xc4/0x120
[  438.942141]                     [<000000000044f2a8>] do_sparc64_fault+0x608/0x720
[  439.040513]                     [<0000000000407adc>] sparc64_realfault_common+0x10/0x20
[  439.145740]    INITIAL USE at:
[  439.185759]                    [<00000000004ada6c>] lock_acquire+0x4c/0x80
[  439.276123]                    [<000000000083f628>] _raw_spin_lock+0x28/0x40
[  439.368769]                    [<000000000044fc30>] get_new_mmu_context+0x10/0x160
[  439.468286]                    [<0000000000562410>] exec_mmap+0x90/0x260
[  439.556348]                    [<0000000000562610>] flush_old_exec+0x30/0xa0
[  439.648996]                    [<00000000005b3a10>] load_elf_binary+0x350/0xae0
[  439.745078]                    [<0000000000561d4c>] search_binary_handler+0x8c/0x220
[  439.846876]                    [<00000000008336fc>] exec_binprm+0x134/0x1a0
[  439.938372]                    [<00000000005631fc>] do_execve_common.isra.20+0x1dc/0x2e0
[  440.044750]                    [<0000000000563314>] do_execve+0x14/0x40
[  440.131669]                    [<0000000000426d20>] run_init_process+0x20/0x40
[  440.226610]                    [<0000000000426d44>] try_to_run_init_process+0x4/0x60
[  440.328408]                    [<000000000082c754>] kernel_init+0x94/0x100
[  440.418757]                    [<00000000004060c4>] ret_from_fork+0x1c/0x2c
[  440.510260]                    [<          (null)>]           (null)
[  440.593753]  }
[  440.615483]  ... key      at: [<00000000009d5e38>] ctx_alloc_lock+0x18/0x38
[  440.706991]  ... acquired at:
[  440.745876]    [<000000000083018c>] mark_lock_irq+0x128/0x344
[  440.821368]    [<00000000004ac7f0>] mark_lock+0x3b0/0x500
[  440.892282]    [<00000000004acaa8>] mark_irqflags+0x168/0x220
[  440.967772]    [<00000000004ad234>] __lock_acquire+0x6d4/0x960
[  441.044403]    [<00000000004ada6c>] lock_acquire+0x4c/0x80
[  441.116460]    [<000000000083f628>] _raw_spin_lock+0x28/0x40
[  441.190806]    [<00000000004503e4>] hugetlb_setup+0xc4/0x120
[  441.265154]    [<000000000044f2a8>] do_sparc64_fault+0x608/0x720
[  441.344074]    [<0000000000407adc>] sparc64_realfault_common+0x10/0x20
[  441.429858] 
[  441.449297] 
[  441.449297] stack backtrace:
[  441.506502] CPU: 0 PID: 3253 Comm: dpkg-deb Not tainted 3.15.0-rc7 #2
[  441.591138] Call Trace:
[  441.623158]  [00000000004aa8bc] print_irq_inversion_bug+0x1dc/0x200
[  441.705518]  [00000000004aab00] check_usage_backwards+0x100/0x120
[  441.785580]  [000000000083018c] mark_lock_irq+0x128/0x344
[  441.856494]  [00000000004ac7f0] mark_lock+0x3b0/0x500
[  441.922832]  [00000000004acaa8] mark_irqflags+0x168/0x220
[  441.993747]  [00000000004ad234] __lock_acquire+0x6d4/0x960
[  442.065805]  [00000000004ada6c] lock_acquire+0x4c/0x80
[  442.133288]  [000000000083f628] _raw_spin_lock+0x28/0x40
[  442.203058]  [00000000004503e4] hugetlb_setup+0xc4/0x120
[  442.272827]  [000000000044f2a8] do_sparc64_fault+0x608/0x720
[  442.347174]  [0000000000407adc] sparc64_realfault_common+0x10/0x20

-- 
Meelis Roos (mroos@linux.ee)
