Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3IJT1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:27:15 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60112 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3IJT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:27:12 -0400
Message-ID: <522F728D.60602@linaro.org>
Date: Tue, 10 Sep 2013 12:27:09 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [RFC v2] seqcount: Add lockdep functionality to seqcount/seqlock
 structures
References: <1378840677-21635-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1378840677-21635-1-git-send-email-john.stultz@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 12:17 PM, John Stultz wrote:
> Currently seqlocks and seqcounts don't support lockdep.
>
> After running across a seqcount related deadlock in the timekeeping
> code, I used a less-refined and more focused varient of this patch
> to narrow down the cause of the issue.
>
> This is a first-pass attempt to properly enable lockdep functionality
> on seqlocks and seqcounts.
>
> Since seqcounts are used in the vdso gettimeofday code, I've provided
> lockdep accessors.
>
> I've also handled one cases where there were nested seqlock writers
> but there may be more edge cases yet to address.

There is one case this triggers which I've not been able to sort out if
its a false positive or not.

It looks potentially real to me, since set_mems_allowed() is called from
kthreadd with irqs enabled, so I think the lockdep warning is right, but
since its really initialization only maybe its not a real problem?

Peter, Ingo: any tips for how to clean these sorts of cases up?

thanks
-john


[    1.070907] ======================================================
[    1.072015] [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
[    1.073181] 3.11.0+ #67 Not tainted
[    1.073801] ------------------------------------------------------
[    1.074882] kworker/u4:2/708 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[    1.076088]  (&p->mems_allowed_seq){+.+...}, at: [<ffffffff81187d7f>] new_slab+0x5f/0x280
[    1.077572] 
[    1.077572] and this task is already holding:
[    1.078593]  (&(&q->__queue_lock)->rlock){..-...}, at: [<ffffffff81339f03>] blk_execute_rq_nowait+0x53/0xf0
[    1.080042] which would create a new lock dependency:
[    1.080042]  (&(&q->__queue_lock)->rlock){..-...} -> (&p->mems_allowed_seq){+.+...}
[    1.080042] 
[    1.080042] but this new dependency connects a SOFTIRQ-irq-safe lock:
[    1.080042]  (&(&q->__queue_lock)->rlock){..-...}
[    1.080042] ... which became SOFTIRQ-irq-safe at:
[    1.080042]   [<ffffffff810ec179>] __lock_acquire+0x5b9/0x1db0
[    1.080042]   [<ffffffff810edfe5>] lock_acquire+0x95/0x130
[    1.080042]   [<ffffffff818968a1>] _raw_spin_lock+0x41/0x80
[    1.080042]   [<ffffffff81560c9e>] scsi_device_unbusy+0x7e/0xd0
[    1.080042]   [<ffffffff8155a612>] scsi_finish_command+0x32/0xf0
[    1.080042]   [<ffffffff81560e91>] scsi_softirq_done+0xa1/0x130
[    1.080042]   [<ffffffff8133b0f3>] blk_done_softirq+0x73/0x90
[    1.080042]   [<ffffffff81095dc0>] __do_softirq+0x110/0x2f0
[    1.080042]   [<ffffffff81095fcd>] run_ksoftirqd+0x2d/0x60
[    1.080042]   [<ffffffff810bc506>] smpboot_thread_fn+0x156/0x1e0
[    1.080042]   [<ffffffff810b3916>] kthread+0xd6/0xe0
[    1.080042]   [<ffffffff818980ac>] ret_from_fork+0x7c/0xb0
[    1.080042] 
[    1.080042] to a SOFTIRQ-irq-unsafe lock:
[    1.080042]  (&p->mems_allowed_seq){+.+...}
[    1.080042] ... which became SOFTIRQ-irq-unsafe at:
[    1.080042] ...  [<ffffffff810ec1d3>] __lock_acquire+0x613/0x1db0
[    1.080042]   [<ffffffff810edfe5>] lock_acquire+0x95/0x130
[    1.080042]   [<ffffffff810b3df2>] kthreadd+0x82/0x180
[    1.080042]   [<ffffffff818980ac>] ret_from_fork+0x7c/0xb0
[    1.080042] 
[    1.080042] other info that might help us debug this:
[    1.080042] 
[    1.080042]  Possible interrupt unsafe locking scenario:
[    1.080042] 
[    1.080042]        CPU0                    CPU1
[    1.080042]        ----                    ----
[    1.080042]   lock(&p->mems_allowed_seq);
[    1.080042]                                local_irq_disable();
[    1.080042]                                lock(&(&q->__queue_lock)->rlock);
[    1.080042]                                lock(&p->mems_allowed_seq);
[    1.080042]   <Interrupt>
[    1.080042]     lock(&(&q->__queue_lock)->rlock);
[    1.080042] 
[    1.080042]  *** DEADLOCK ***
[    1.080042] 
[    1.080042] 4 locks held by kworker/u4:2/708:
[    1.080042]  #0:  (events_unbound){.+.+.+}, at: [<ffffffff810abeae>] process_one_work+0x17e/0x540
[    1.080042]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff810abeae>] process_one_work+0x17e/0x540
[    1.080042]  #2:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff811ca493>] __blkdev_get+0x63/0x490
[    1.080042]  #3:  (&(&q->__queue_lock)->rlock){..-...}, at: [<ffffffff81339f03>] blk_execute_rq_nowait+0x53/0xf0
[    1.080042] 
[    1.080042] the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
[    1.080042] -> (&(&q->__queue_lock)->rlock){..-...} ops: 139 {
[    1.080042]    IN-SOFTIRQ-W at:
[    1.080042]                     [<ffffffff810ec179>] __lock_acquire+0x5b9/0x1db0
[    1.080042]                     [<ffffffff810edfe5>] lock_acquire+0x95/0x130
[    1.080042]                     [<ffffffff818968a1>] _raw_spin_lock+0x41/0x80
[    1.080042]                     [<ffffffff81560c9e>] scsi_device_unbusy+0x7e/0xd0
[    1.080042]                     [<ffffffff8155a612>] scsi_finish_command+0x32/0xf0
[    1.080042]                     [<ffffffff81560e91>] scsi_softirq_done+0xa1/0x130
[    1.080042]                     [<ffffffff8133b0f3>] blk_done_softirq+0x73/0x90
[    1.080042]                     [<ffffffff81095dc0>] __do_softirq+0x110/0x2f0
[    1.080042]                     [<ffffffff81095fcd>] run_ksoftirqd+0x2d/0x60
[    1.080042]                     [<ffffffff810bc506>] smpboot_thread_fn+0x156/0x1e0
[    1.080042]                     [<ffffffff810b3916>] kthread+0xd6/0xe0
[    1.080042]                     [<ffffffff818980ac>] ret_from_fork+0x7c/0xb0
[    1.080042]    INITIAL USE at:
[    1.080042]                    [<ffffffff810ebec7>] __lock_acquire+0x307/0x1db0
[    1.080042]                    [<ffffffff810edfe5>] lock_acquire+0x95/0x130
[    1.080042]                    [<ffffffff818969b7>] _raw_spin_lock_irq+0x47/0x80
[    1.080042]                    [<ffffffff813334e4>] blk_queue_bypass_end+0x14/0xc0
[    1.080042]                    [<ffffffff8133794e>] blk_register_queue+0x3e/0x120
[    1.080042]                    [<ffffffff8133e7d7>] add_disk+0x217/0x4e0
[    1.080042]                    [<ffffffff81556e38>] loop_add+0x1a8/0x240
[    1.080042]                    [<ffffffff8211b947>] loop_init+0x104/0x143
[    1.080042]                    [<ffffffff820dbece>] do_one_initcall+0x7f/0x10d
[    1.080042]                    [<ffffffff820dc0d1>] kernel_init_freeable+0x175/0x203
[    1.080042]                    [<ffffffff81882ee9>] kernel_init+0x9/0xf0
[    1.080042]                    [<ffffffff818980ac>] ret_from_fork+0x7c/0xb0
[    1.080042]  }
[    1.080042]  ... key      at: [<ffffffff82b3aa50>] __key.37046+0x0/0x8
[    1.080042]  ... acquired at:
[    1.080042]    [<ffffffff810e911b>] check_irq_usage+0x5b/0xe0
[    1.080042]    [<ffffffff810ec9f8>] __lock_acquire+0xe38/0x1db0
[    1.080042]    [<ffffffff810edfe5>] lock_acquire+0x95/0x130
[    1.080042]    [<ffffffff8114f367>] __alloc_pages_nodemask+0x117/0xa10
[    1.080042]    [<ffffffff81187d7f>] new_slab+0x5f/0x280
[    1.080042]    [<ffffffff8188a15a>] __slab_alloc.constprop.74+0x15b/0x4a5
[    1.080042]    [<ffffffff81189b37>] kmem_cache_alloc+0xe7/0x170
[    1.080042]    [<ffffffff8114a3a0>] mempool_alloc_slab+0x10/0x20
[    1.080042]    [<ffffffff8114a1d3>] mempool_alloc+0x63/0x180
[    1.080042]    [<ffffffff8155ff78>] scsi_sg_alloc+0x48/0x50
[    1.080042]    [<ffffffff8135db5f>] __sg_alloc_table+0x6f/0x140
[    1.080042]    [<ffffffff815600af>] scsi_init_sgtable+0x2f/0x90
[    1.080042]    [<ffffffff8156161c>] scsi_init_io+0x2c/0xc0
[    1.080042]    [<ffffffff81561849>] scsi_setup_blk_pc_cmnd+0x79/0x120
[    1.080042]    [<ffffffff81571348>] sd_prep_fn+0x688/0xb80
[    1.080042]    [<ffffffff81335637>] blk_peek_request+0x147/0x260
[    1.080042]    [<ffffffff815604c9>] scsi_request_fn+0x49/0x4d0
[    1.080042]    [<ffffffff8133309e>] __blk_run_queue+0x2e/0x40
[    1.080042]    [<ffffffff81339f24>] blk_execute_rq_nowait+0x74/0xf0
[    1.080042]    [<ffffffff8133a020>] blk_execute_rq+0x80/0x120
[    1.080042]    [<ffffffff81560a7f>] scsi_execute+0xdf/0x170
[    1.080042]    [<ffffffff81560ba5>] scsi_execute_req_flags+0x95/0x110
[    1.080042]    [<ffffffff8156e849>] read_capacity_16+0xb9/0x530
[    1.080042]    [<ffffffff8156f1d4>] sd_revalidate_disk+0x3c4/0x1cb0
[    1.080042]    [<ffffffff81341384>] rescan_partitions+0x84/0x2b0
[    1.080042]    [<ffffffff811ca78c>] __blkdev_get+0x35c/0x490
[    1.080042]    [<ffffffff811caa65>] blkdev_get+0x1a5/0x320
[    1.080042]    [<ffffffff8133e9b1>] add_disk+0x3f1/0x4e0
[    1.080042]    [<ffffffff81570bf5>] sd_probe_async+0x135/0x200
[    1.080042]    [<ffffffff810bb1e2>] async_run_entry_fn+0x32/0x130
[    1.080042]    [<ffffffff810abf17>] process_one_work+0x1e7/0x540
[    1.080042]    [<ffffffff810ac6e9>] worker_thread+0x119/0x370
[    1.080042]    [<ffffffff810b3916>] kthread+0xd6/0xe0
[    1.080042]    [<ffffffff818980ac>] ret_from_fork+0x7c/0xb0
[    1.080042] 
[    1.080042] 
[    1.080042] the dependencies between the lock to be acquired and SOFTIRQ-irq-unsafe lock:
[    1.080042] -> (&p->mems_allowed_seq){+.+...} ops: 13662 {
[    1.080042]    HARDIRQ-ON-W at:
[    1.080042]                     [<ffffffff810ec1a4>] __lock_acquire+0x5e4/0x1db0
[    1.080042]                     [<ffffffff810edfe5>] lock_acquire+0x95/0x130
[    1.080042]                     [<ffffffff810b3df2>] kthreadd+0x82/0x180
[    1.080042]                     [<ffffffff818980ac>] ret_from_fork+0x7c/0xb0
[    1.080042]    SOFTIRQ-ON-W at:
[    1.080042]                     [<ffffffff810ec1d3>] __lock_acquire+0x613/0x1db0
[    1.080042]                     [<ffffffff810edfe5>] lock_acquire+0x95/0x130
[    1.080042]                     [<ffffffff810b3df2>] kthreadd+0x82/0x180
[    1.080042]                     [<ffffffff818980ac>] ret_from_fork+0x7c/0xb0
[    1.080042]    INITIAL USE at:
[    1.080042]                    [<ffffffff810ebec7>] __lock_acquire+0x307/0x1db0
[    1.080042]                    [<ffffffff810edfe5>] lock_acquire+0x95/0x130
[    1.080042]                    [<ffffffff810b3df2>] kthreadd+0x82/0x180
[    1.080042]                    [<ffffffff818980ac>] ret_from_fork+0x7c/0xb0
[    1.080042]  }
[    1.080042]  ... key      at: [<ffffffff82205ff8>] __key.46526+0x0/0x8
[    1.080042]  ... acquired at:
[    1.080042]    [<ffffffff810e911b>] check_irq_usage+0x5b/0xe0
[    1.080042]    [<ffffffff810ec9f8>] __lock_acquire+0xe38/0x1db0
[    1.080042]    [<ffffffff810edfe5>] lock_acquire+0x95/0x130
[    1.080042]    [<ffffffff8114f367>] __alloc_pages_nodemask+0x117/0xa10
[    1.080042]    [<ffffffff81187d7f>] new_slab+0x5f/0x280
[    1.080042]    [<ffffffff8188a15a>] __slab_alloc.constprop.74+0x15b/0x4a5
[    1.080042]    [<ffffffff81189b37>] kmem_cache_alloc+0xe7/0x170
[    1.080042]    [<ffffffff8114a3a0>] mempool_alloc_slab+0x10/0x20
[    1.080042]    [<ffffffff8114a1d3>] mempool_alloc+0x63/0x180
[    1.080042]    [<ffffffff8155ff78>] scsi_sg_alloc+0x48/0x50
[    1.080042]    [<ffffffff8135db5f>] __sg_alloc_table+0x6f/0x140
[    1.080042]    [<ffffffff815600af>] scsi_init_sgtable+0x2f/0x90
[    1.080042]    [<ffffffff8156161c>] scsi_init_io+0x2c/0xc0
[    1.080042]    [<ffffffff81561849>] scsi_setup_blk_pc_cmnd+0x79/0x120
[    1.080042]    [<ffffffff81571348>] sd_prep_fn+0x688/0xb80
[    1.080042]    [<ffffffff81335637>] blk_peek_request+0x147/0x260
[    1.080042]    [<ffffffff815604c9>] scsi_request_fn+0x49/0x4d0
[    1.080042]    [<ffffffff8133309e>] __blk_run_queue+0x2e/0x40
[    1.080042]    [<ffffffff81339f24>] blk_execute_rq_nowait+0x74/0xf0
[    1.080042]    [<ffffffff8133a020>] blk_execute_rq+0x80/0x120
[    1.080042]    [<ffffffff81560a7f>] scsi_execute+0xdf/0x170
[    1.080042]    [<ffffffff81560ba5>] scsi_execute_req_flags+0x95/0x110
[    1.080042]    [<ffffffff8156e849>] read_capacity_16+0xb9/0x530
[    1.080042]    [<ffffffff8156f1d4>] sd_revalidate_disk+0x3c4/0x1cb0
[    1.080042]    [<ffffffff81341384>] rescan_partitions+0x84/0x2b0
[    1.080042]    [<ffffffff811ca78c>] __blkdev_get+0x35c/0x490
[    1.080042]    [<ffffffff811caa65>] blkdev_get+0x1a5/0x320
[    1.080042]    [<ffffffff8133e9b1>] add_disk+0x3f1/0x4e0
[    1.080042]    [<ffffffff81570bf5>] sd_probe_async+0x135/0x200
[    1.080042]    [<ffffffff810bb1e2>] async_run_entry_fn+0x32/0x130
[    1.080042]    [<ffffffff810abf17>] process_one_work+0x1e7/0x540
[    1.080042]    [<ffffffff810ac6e9>] worker_thread+0x119/0x370
[    1.080042]    [<ffffffff810b3916>] kthread+0xd6/0xe0
[    1.256117]    [<ffffffff818980ac>] ret_from_fork+0x7c/0xb0
[    1.256117] 
[    1.256117] 
[    1.256117] stack backtrace:
[    1.256117] CPU: 0 PID: 708 Comm: kworker/u4:2 Not tainted 3.11.0+ #67
[    1.256117] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    1.256117] Workqueue: events_unbound async_run_entry_fn
[    1.256117]  ffffffff82379840 ffff880007891098 ffffffff8188bfdc ffff880006b51c40
[    1.256117]  ffff880007891190 ffffffff810e90aa 0000000000000000 0000000000000000
[    1.256117]  0000000000000001 ffff8800078910e8 ffffffff81c43412 ffff880007891128
[    1.256117] Call Trace:
[    1.256117]  [<ffffffff8188bfdc>] dump_stack+0x54/0x74
[    1.256117]  [<ffffffff810e90aa>] check_usage+0x4da/0x4f0
[    1.256117]  [<ffffffff810c4ccd>] ? sched_clock_local+0x1d/0x90
[    1.256117]  [<ffffffff810e911b>] check_irq_usage+0x5b/0xe0
[    1.256117]  [<ffffffff810ec9f8>] __lock_acquire+0xe38/0x1db0
[    1.256117]  [<ffffffff810edfe5>] lock_acquire+0x95/0x130
[    1.256117]  [<ffffffff81187d7f>] ? new_slab+0x5f/0x280
[    1.256117]  [<ffffffff8114f367>] __alloc_pages_nodemask+0x117/0xa10
[    1.256117]  [<ffffffff81187d7f>] ? new_slab+0x5f/0x280
[    1.256117]  [<ffffffff810e72ef>] ? __bfs+0x14f/0x240
[    1.256117]  [<ffffffff810e72ef>] ? __bfs+0x14f/0x240
[    1.256117]  [<ffffffff810c4ccd>] ? sched_clock_local+0x1d/0x90
[    1.256117]  [<ffffffff810e72ef>] ? __bfs+0x14f/0x240
[    1.256117]  [<ffffffff810c4ccd>] ? sched_clock_local+0x1d/0x90
[    1.256117]  [<ffffffff81187d7f>] new_slab+0x5f/0x280
[    1.256117]  [<ffffffff8188a15a>] __slab_alloc.constprop.74+0x15b/0x4a5
[    1.256117]  [<ffffffff8114a3a0>] ? mempool_alloc_slab+0x10/0x20
[    1.256117]  [<ffffffff8114a3a0>] ? mempool_alloc_slab+0x10/0x20
[    1.256117]  [<ffffffff81189b37>] kmem_cache_alloc+0xe7/0x170
[    1.256117]  [<ffffffff810c4ccd>] ? sched_clock_local+0x1d/0x90
[    1.256117]  [<ffffffff8114a3a0>] mempool_alloc_slab+0x10/0x20
[    1.256117]  [<ffffffff8114a1d3>] mempool_alloc+0x63/0x180
[    1.256117]  [<ffffffff810c4e68>] ? sched_clock_cpu+0xa8/0x110
[    1.256117]  [<ffffffff810e9c6d>] ? trace_hardirqs_off+0xd/0x10
[    1.256117]  [<ffffffff8155ff78>] scsi_sg_alloc+0x48/0x50
[    1.256117]  [<ffffffff8135db5f>] __sg_alloc_table+0x6f/0x140
[    1.256117]  [<ffffffff8155ff30>] ? target_block+0x30/0x30
[    1.256117]  [<ffffffff815600af>] scsi_init_sgtable+0x2f/0x90
[    1.256117]  [<ffffffff8156161c>] scsi_init_io+0x2c/0xc0
[    1.256117]  [<ffffffff81561849>] scsi_setup_blk_pc_cmnd+0x79/0x120
[    1.256117]  [<ffffffff81571348>] sd_prep_fn+0x688/0xb80
[    1.256117]  [<ffffffff81335637>] blk_peek_request+0x147/0x260
[    1.256117]  [<ffffffff815604c9>] scsi_request_fn+0x49/0x4d0
[    1.256117]  [<ffffffff81339f03>] ? blk_execute_rq_nowait+0x53/0xf0
[    1.256117]  [<ffffffff8133309e>] __blk_run_queue+0x2e/0x40
[    1.256117]  [<ffffffff81339f24>] blk_execute_rq_nowait+0x74/0xf0
[    1.256117]  [<ffffffff8133a020>] blk_execute_rq+0x80/0x120
[    1.256117]  [<ffffffff8133a3f4>] ? blk_recount_segments+0x24/0x40
[    1.256117]  [<ffffffff811c7379>] ? bio_phys_segments+0x19/0x20
[    1.256117]  [<ffffffff81335860>] ? blk_rq_bio_prep+0x60/0xc0
[    1.256117]  [<ffffffff81339dd4>] ? blk_rq_map_kern+0xc4/0x170
[    1.256117]  [<ffffffff81560a7f>] scsi_execute+0xdf/0x170
[    1.256117]  [<ffffffff81560ba5>] scsi_execute_req_flags+0x95/0x110
[    1.256117]  [<ffffffff8156e849>] read_capacity_16+0xb9/0x530
[    1.256117]  [<ffffffff8156f1d4>] sd_revalidate_disk+0x3c4/0x1cb0
[    1.256117]  [<ffffffff81341384>] rescan_partitions+0x84/0x2b0
[    1.256117]  [<ffffffff81896a92>] ? _raw_spin_unlock+0x22/0x40
[    1.256117]  [<ffffffff811ca78c>] __blkdev_get+0x35c/0x490
[    1.256117]  [<ffffffff811caa65>] blkdev_get+0x1a5/0x320
[    1.256117]  [<ffffffff811ab2b9>] ? unlock_new_inode+0x59/0x80
[    1.256117]  [<ffffffff811c9c1a>] ? bdget+0x13a/0x160
[    1.256117]  [<ffffffff8133e9b1>] add_disk+0x3f1/0x4e0
[    1.256117]  [<ffffffff81570bf5>] sd_probe_async+0x135/0x200
[    1.256117]  [<ffffffff810bb1e2>] async_run_entry_fn+0x32/0x130
[    1.256117]  [<ffffffff810abf17>] process_one_work+0x1e7/0x540
[    1.256117]  [<ffffffff810abeae>] ? process_one_work+0x17e/0x540
[    1.256117]  [<ffffffff810ac6e9>] worker_thread+0x119/0x370
[    1.256117]  [<ffffffff810ac5d0>] ? rescuer_thread+0x320/0x320
[    1.256117]  [<ffffffff810b3916>] kthread+0xd6/0xe0
[    1.256117]  [<ffffffff810b3840>] ? __kthread_unpark+0x50/0x50
[    1.256117]  [<ffffffff818980ac>] ret_from_fork+0x7c/0xb0
[    1.256117]  [<ffffffff810b3840>] ? __kthread_unpark+0x50/0x50


