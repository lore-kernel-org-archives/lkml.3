Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaCFFxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 00:53:13 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:45321 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaCFFxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 00:53:06 -0500
MIME-Version: 1.0
In-Reply-To: <20140305132112.GA10880@localhost>
References: <20140305132112.GA10880@localhost>
Date: Thu, 6 Mar 2014 13:53:05 +0800
Message-ID: <CAA7+ByVYBZUEWMpu_QdX-gTiHd540D2kg3H3dx0exWnhzok4Hw@mail.gmail.com>
Subject: Re: [blkg] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
From: Hong zhi guo <honkiko@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Hong Zhiguo <zhiguohong@tencent.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the report. The q->queue_lock may be taken in irq. And in
sys_read() context, we hold q->queue_lock with irq disabled and then
called local_bh_enable, which turned irq enabled. This leads to
potential double acquire of queue_lock.

One fix is to use "_local_bh_enable()" instead of "local_bh_enable()"
in u64_stats_fetch_retry_bh(). There's no enabling of irq in
_local_bh_enable().

But I wonder why we do "WARN_ON_ONCE(!irqs_disabled())" in
_local_bh_enable()?  What's the bad thing if someone call
_local_bh_enable() with  irqs_diabled()?

Is below change acceptable?

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 490fcbb..f446763 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -142,9 +142,11 @@ EXPORT_SYMBOL(_local_bh_enable);

 void __local_bh_enable_ip(unsigned long ip, unsigned int cnt)
 {
+       unsigned long flags;
+
        WARN_ON_ONCE(in_irq() || irqs_disabled());
 #ifdef CONFIG_TRACE_IRQFLAGS
-       local_irq_disable();
+       raw_local_irq_save(flags);
 #endif
        /*
         * Are softirqs going to be turned on now:
@@ -167,7 +169,7 @@ void __local_bh_enable_ip(unsigned long ip,
unsigned int cnt)

        preempt_count_dec();
 #ifdef CONFIG_TRACE_IRQFLAGS
-       local_irq_enable();
+       raw_local_irq_restore(flags);
 #endif
        preempt_check_resched();
 }

Zhiguo



On Wed, Mar 5, 2014 at 9:21 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> I got the below dmesg and the first bad commit is
>
> commit 2c575026fae6e63771bd2a4c1d407214a8096a89
> Author:     Hong Zhiguo <zhiguohong@tencent.com>
> AuthorDate: Wed Nov 20 10:35:05 2013 -0700
> Commit:     Jens Axboe <axboe@kernel.dk>
> CommitDate: Wed Nov 20 15:33:04 2013 -0700
>
>     Update of blkg_stat and blkg_rwstat may happen in bh context.
>     While u64_stats_fetch_retry is only preempt_disable on 32bit
>     UP system. This is not enough to avoid preemption by bh and
>     may read strange 64 bit value.
>
>
> +------------------------------------------------------------+----+
> |                                                            |    |
> +------------------------------------------------------------+----+
> | boot_successes                                             | 0  |
> | boot_failures                                              | 19 |
> | inconsistent_IN-HARDIRQ-W-HARDIRQ-ON-W_usage               | 12 |
> | backtrace:vfs_read                                         | 10 |
> | backtrace:SyS_read                                         | 10 |
> | BUG:spinlock_lockup_suspected_on_CPU                       | 1  |
> | WARNING:CPU:PID:at_kernel/softirq.c:__local_bh_enable_ip() | 9  |
> | backtrace:do_mount                                         | 9  |
> | backtrace:SyS_mount                                        | 9  |
> | inconsistent_SOFTIRQ-ON-W-IN-SOFTIRQ-W_usage               | 7  |
> | backtrace:floppy_work_workfn                               | 7  |
> +------------------------------------------------------------+----+
>
> [   91.904407] [ INFO: inconsistent lock state ]
> [   91.905533] 3.14.0-rc3-wl-01773-g311db85 #11 Tainted: G        W
> [   91.906880] ---------------------------------
> [   91.908013] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
> [   91.909378] blkid/3517 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [   91.910360]  (&(&q->__queue_lock)->rlock){?.-...}, at: [<c143f35a>] blk_flush_plug_list+0x15a/0x240
> [   91.910360] {IN-HARDIRQ-W} state was registered at:
> [   91.910360]   [<c106235a>] __lock_acquire+0xb5a/0x1aa0
> [   91.910360]   [<c10639c7>] lock_acquire+0x77/0xa0
> [   91.910360]   [<c200b83d>] _raw_spin_lock_irqsave+0x4d/0x60
> [   91.910360]   [<c143e9fb>] blk_end_bidi_request+0x3b/0x60
> [   91.910360]   [<c143eab2>] blk_end_request+0x12/0x20
> [   91.910360]   [<c16382c7>] ide_end_rq+0x27/0x50
> [   91.910360]   [<c1638467>] ide_complete_rq+0x27/0x50
> [   91.910360]   [<c164ff75>] cdrom_newpc_intr+0x315/0x8e0
> [   91.910360]   [<c163873a>] ide_intr+0x15a/0x1f0
> [   91.910360]   [<c106a270>] handle_irq_event_percpu+0x20/0x120
> [   91.910360]   [<c106a39c>] handle_irq_event+0x2c/0x50
> [   91.910360]   [<c106c376>] handle_edge_irq+0x66/0x120
> [   91.910360] irq event stamp: 2248
> [   91.910360] hardirqs last  enabled at (2245): [<c200b9d2>] _raw_spin_unlock_irq+0x22/0x50
> [   91.910360] hardirqs last disabled at (2246): [<c143f2f7>] blk_flush_plug_list+0xf7/0x240
> [   91.910360] softirqs last  enabled at (2248): [<c1456ea5>] __cfq_set_active_queue+0x45/0x1d0
> [   91.910360] softirqs last disabled at (2247): [<c1456ea5>] __cfq_set_active_queue+0x45/0x1d0
> [   91.910360]
> [   91.910360] other info that might help us debug this:
> [   91.910360]  Possible unsafe locking scenario:
> [   91.910360]
> [   91.910360]        CPU0
> [   91.910360]        ----
> [   91.910360]   lock(&(&q->__queue_lock)->rlock);
> [   91.910360]   <Interrupt>
> [   91.910360]     lock(&(&q->__queue_lock)->rlock);
> [   91.910360]
> [   91.910360]  *** DEADLOCK ***
> [   91.910360]
> [   91.910360] 1 lock held by blkid/3517:
> [   91.910360]  #0:  (&(&q->__queue_lock)->rlock){?.-...}, at: [<c143f35a>] blk_flush_plug_list+0x15a/0x240
> [   91.910360]
> [   91.910360] stack backtrace:
> [   91.910360] CPU: 0 PID: 3517 Comm: blkid Tainted: G        W    3.14.0-rc3-wl-01773-g311db85 #11
> [   91.910360] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   91.910360]  c9908000 c9908000 c995db00 c1ff5ece c995db3c c1ff174d c231c847 c231cb6d
> [   91.910360]  00000dbd 00000000 00000000 00000000 00000000 00000001 00000001 c231cb6d
> [   91.910360]  00000002 c99084dc c105f270 c995db70 c1060234 00000002 00000000 c231e494
> [   91.910360] Call Trace:
> [   91.910360]  [<c1ff5ece>] dump_stack+0x16/0x18
> [   91.910360]  [<c1ff174d>] print_usage_bug.part.35+0x252/0x25a
> [   91.910360]  [<c105f270>] ? print_shortest_lock_dependencies+0x1a0/0x1a0
> [   91.910360]  [<c1060234>] mark_lock+0x5d4/0x690
> [   91.910360]  [<c105f270>] ? print_shortest_lock_dependencies+0x1a0/0x1a0
> [   91.910360]  [<c106035f>] mark_held_locks+0x6f/0xf0
> [   91.910360]  [<c102f55a>] ? print_oops_end_marker+0x2a/0x30
> [   91.910360]  [<c1032c51>] ? __local_bh_enable_ip+0x61/0xd0
> [   91.910360]  [<c106047f>] trace_hardirqs_on_caller+0x9f/0x1b0
> [   91.910360]  [<c1456ea5>] ? __cfq_set_active_queue+0x45/0x1d0
> [   91.910360]  [<c106059b>] trace_hardirqs_on+0xb/0x10
> [   91.910360]  [<c1032c51>] __local_bh_enable_ip+0x61/0xd0
> [   91.910360]  [<c1456ef9>] __cfq_set_active_queue+0x99/0x1d0
> [   91.910360]  [<c145002f>] ? blkg_create+0x36f/0x4b0
> [   91.910360]  [<c1459b16>] ? cfq_add_cfqq_rr+0x66/0xb0
> [   91.910360]  [<c1456d94>] ? cfq_update_idle_window.isra.84+0xa4/0xf0
> [   91.910360]  [<c1464619>] ? __delay+0x9/0x10
> [   91.910360]  [<c14595c4>] cfq_dispatch_requests+0x4d4/0x9c0
> [   91.910360]  [<c1023ad3>] ? kvm_clock_read+0x13/0x30
> [   91.910360]  [<c1008d38>] ? sched_clock+0x8/0x10
> [   91.910360]  [<c1459dbf>] ? cfq_insert_request+0x1af/0x480
> [   91.910360]  [<c143dca3>] ? submit_bio+0x43/0xf0
> [   91.910360]  [<c1468766>] ? list_sort+0x146/0x1b0
> [   91.910360]  [<c143ecf4>] blk_peek_request+0x114/0x1a0
> [   91.910360]  [<c1659917>] scsi_request_fn+0x37/0x4d0
> [   91.910360]  [<c143cccc>] __blk_run_queue+0x2c/0x40
> [   91.910360]  [<c143f39e>] blk_flush_plug_list+0x19e/0x240
> [   91.910360]  [<c143f63d>] blk_finish_plug+0xd/0x30
> [   91.910360]  [<c10a3761>] __do_page_cache_readahead+0x1e1/0x270
> [   91.910360]  [<c10a3626>] ? __do_page_cache_readahead+0xa6/0x270
> [   91.910360]  [<c10a3c4c>] force_page_cache_readahead+0x6c/0x90
> [   91.910360]  [<c10a3d0d>] page_cache_sync_readahead+0x4d/0x50
> [   91.910360]  [<c109ac9a>] generic_file_aio_read+0x54a/0x700
> [   91.910360]  [<c10fe52f>] blkdev_aio_read+0x6f/0xb0
> [   91.910360]  [<c10d0371>] do_sync_read+0x51/0x80
> [   91.910360]  [<c10d0320>] ? no_llseek+0x10/0x10
> [   91.910360]  [<c10d0eab>] vfs_read+0x6b/0x110
> [   91.910360]  [<c10d129c>] SyS_read+0x4c/0x90
> [   91.910360]  [<c200cbca>] sysenter_do_call+0x12/0x3c
> [   92.092982] init: Failed to create pty - disabling logging for job
> [   92.094569] init: Temporary process spawn error: No such file or directory
> [   92.172247] init: Failed to create pty - disabling logging for job
>
> git bisect start v3.13 v3.12 --
> git bisect good 3bad8bb5cd3048a67df43ac6b1e2f191f19d9ff0  # 01:27     25+      0  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
> git bisect  bad dd0508093b79141e0044ca02f0acb6319f69f546  # 01:31      0-      4  Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 3f02ff5c2c69753666787ed125708d283a823ffb  # 01:35      0-      3  Merge tag 'tty-3.13-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
> git bisect good 1ab231b274ba51a54acebec23c6aded0f3cdf54e  # 01:40     25+      0  Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 5ee540613db504a10e15fafaf4c08cac96aa1823  # 01:45      0-      1  Merge branch 'for-linus' of git://git.kernel.dk/linux-block
> git bisect good 53c6de50262a8edd6932bb59a32db7b9d92f8d67  # 01:48     25+      0  Merge branch 'x86/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 59fb2f0e9e30ad99a8bab0ff1efaf8f4a3b7105f  # 01:52     25+      0  Merge tag 'fbdev-fixes-3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux
> git bisect good ef1e4e32d595d3e6c9a6d3d2956f087d5886c5e5  # 01:56     25+      0  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
> git bisect good 29be6345bbaec8502a70c4e2204d5818b48c4e8f  # 02:00     25+      0  Merge tag 'nfs-for-3.13-3' of git://git.linux-nfs.org/projects/trondmy/linux-nfs
> git bisect  bad e345d767f6530ec9cb0aabab7ea248072a9c6975  # 02:04      0-      5  Merge branch 'stable/for-jens-3.13-take-two' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip into for-linus
> git bisect  bad c170bbb45febc03ac4d34ba2b8bb55e06104b7e7  # 02:07      0-      7  block: submit_bio_wait() conversions
> git bisect  bad 2c575026fae6e63771bd2a4c1d407214a8096a89  # 02:10      5-      4  Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
> # first bad commit: [2c575026fae6e63771bd2a4c1d407214a8096a89] Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
> git bisect good 82023bb7f75b0052f40d3e74169d191c3e4e6286  # 02:15    108+      0  Merge tag 'pm+acpi-2-3.13-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> git bisect  bad 311db85e8948921a53da32bcbf22b988380d948c  # 02:15      0-     19  0day head guard for 'devel-hourly-2014022117'
> git bisect good 28007194d83767477f15be95a790446edfcbc383  # 02:21    108+      1  Revert "Update of blkg_stat and blkg_rwstat may happen in bh context."
> git bisect  bad 86c7654f4a0afcbbd2fedefec01082f292b14cb4  # 02:26      1-      2  Merge tag 'metag-fixes-v3.14' of git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag
> git bisect  bad b148a42ba7823e34971cd4e5b05a5c74fa3311ed  # 02:32      3-      4  Add linux-next specific files for 20140228
>
> Thanks,
> Fengguang



-- 
best regards
Hong Zhiguo
