Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbaHFBBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:01:36 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:48333 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbaHFBBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:01:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140802025046.GA6683@localhost>
References: <20140802025046.GA6683@localhost>
Date: Tue, 5 Aug 2014 21:01:32 -0400
Message-ID: <CAPDOMVivdpnkd9f5GL-8__P=i-uXvqfxsqrr9fm4K792nQ9XyQ@mail.gmail.com>
Subject: Re: [blkg_stat] WARNING: CPU: 0 PID: 85 at kernel/softirq.c:156 _local_bh_enable_ip()
From: Nick Krause <xerofoify@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Hong Zhiguo <zhiguohong@tencent.com>, Jens Axboe <axboe@kernel.dk>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 10:50 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
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
>     Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
>     Acked-by: Tejun Heo <tj@kernel.org>
>     Cc: stable@kernel.org
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> +-----------------------------------------------------------------------------+------------+------------+------------------+
> |                                                                             | 82023bb7f7 | 2c575026fa | v3.16-rc7_080120 |
> +-----------------------------------------------------------------------------+------------+------------+------------------+
> | boot_successes                                                              | 270        | 22         | 7                |
> | boot_failures                                                               | 0          | 68         | 4                |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference                        | 0          | 1          |                  |
> | Oops                                                                        | 0          | 1          |                  |
> | EIP_is_at_strlen                                                            | 0          | 1          |                  |
> | BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/rwsem.c | 0          | 1          |                  |
> | INFO:lockdep_is_turned_off                                                  | 0          | 1          |                  |
> | backtrace:vfs_write                                                         | 0          | 1          |                  |
> | backtrace:SyS_write                                                         | 0          | 1          |                  |
> | WARNING:CPU:PID:at_kernel/softirq.c:_local_bh_enable_ip()                   | 0          | 67         |                  |
> | inconsistent_SOFTIRQ-ON-W-IN-SOFTIRQ-W_usage                                | 0          | 67         | 4                |
> | backtrace:redo_fd_request                                                   | 0          | 67         |                  |
> | backtrace:floppy_work_workfn                                                | 0          | 0          | 4                |
> | backtrace:cpu_startup_entry                                                 | 0          | 0          | 4                |
> +-----------------------------------------------------------------------------+------------+------------+------------------+
>
> [    2.848648] NX-protecting the kernel data: 5832k
> [    2.903073] udev[122]: starting version 164
> [    3.123339] ------------[ cut here ]------------
> [    3.123386] WARNING: CPU: 0 PID: 85 at kernel/softirq.c:156 _local_bh_enable_ip+0x34/0x97()
> [    3.123386] Modules linked in:
> [    3.123386] CPU: 0 PID: 85 Comm: kworker/u2:2 Not tainted 3.12.0-10878-g2c57502 #1
> [    3.123386] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    3.123386] Workqueue: floppy redo_fd_request
> [    3.123386]  c0258bca 00000000 d277bce8 c0646df5 d277bd00 c022d793 c0230f4d c04297b7
> [    3.123386]  d2746634 d277bd6c d277bd10 c022d81d 00000009 00000000 d277bd1c c0230f4d
> [    3.123386]  d277bd4c d277bd24 c0230fc0 d277bd38 c04297b7 c001be10 d2746400 d2743c00
> [    3.123386] Call Trace:
> [    3.123386]  [<c0258bca>] ? console_unlock+0x355/0x382
> [    3.123386]  [<c0646df5>] dump_stack+0x16/0x18
> [    3.123386]  [<c022d793>] warn_slowpath_common+0x5f/0x76
> [    3.123386]  [<c0230f4d>] ? _local_bh_enable_ip+0x34/0x97
> [    3.123386]  [<c04297b7>] ? blkg_rwstat_read+0x1d/0x24
> [    3.123386]  [<c022d81d>] warn_slowpath_null+0x14/0x18
> [    3.123386]  [<c0230f4d>] _local_bh_enable_ip+0x34/0x97
> [    3.123386]  [<c0230fc0>] local_bh_enable+0x10/0x12
> [    3.123386]  [<c04297b7>] blkg_rwstat_read+0x1d/0x24
> [    3.123386]  [<c042ab0a>] __cfq_set_active_queue+0x65/0x165
> [    3.123386]  [<c025348b>] ? mark_lock+0x1e/0x1d3
> [    3.123386]  [<c025348b>] ? mark_lock+0x1e/0x1d3
> [    3.123386]  [<c0252132>] ? __lock_is_held+0x2d/0x43
> [    3.123386]  [<c021d2e1>] ? pvclock_clocksource_read+0xb1/0xda
> [    3.123386]  [<c021c888>] ? kvm_clock_read+0x14/0x1d
> [    3.123386]  [<c0206476>] ? paravirt_sched_clock+0x9/0xd
> [    3.123386]  [<c042d08d>] cfq_dispatch_requests+0x521/0x78a
> [    3.123386]  [<c0253f5c>] ? __lock_acquire+0x523/0xbdf
> [    3.123386]  [<c0253f5c>] ? __lock_acquire+0x523/0xbdf
> [    3.123386]  [<c025348b>] ? mark_lock+0x1e/0x1d3
> [    3.123386]  [<c02548e7>] ? lock_acquire+0xa3/0xfc
> [    3.123386]  [<c04f73a5>] ? redo_fd_request+0x3f/0xc0c
> [    3.123386]  [<c041a1a4>] blk_peek_request+0x59/0x211
> [    3.123386]  [<c041a36a>] blk_fetch_request+0xe/0x1e
> [    3.123386]  [<c04f73e0>] redo_fd_request+0x7a/0xc0c
> [    3.123386]  [<c02407ab>] ? process_one_work+0x13c/0x398
> [    3.123386]  [<c0240843>] process_one_work+0x1d4/0x398
> [    3.123386]  [<c0241092>] worker_thread+0x12b/0x1c8
> [    3.123386]  [<c0240f67>] ? rescuer_thread+0x1ff/0x1ff
> [    3.123386]  [<c0244b79>] kthread+0x8b/0x90
> [    3.123386]  [<c064ccb7>] ret_from_kernel_thread+0x1b/0x28
> [    3.123386]  [<c0244aee>] ? insert_kthread_work+0x5a/0x5a
> [    3.123386] ---[ end trace 470268993472ede8 ]---
> [    3.246919] end_request: I/O error, dev fd0, sector 0
>
> git bisect start v3.13 v3.12 --
> git bisect good 3bad8bb5cd3048a67df43ac6b1e2f191f19d9ff0  # 22:45     62+      0  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
> git bisect  bad dd0508093b79141e0044ca02f0acb6319f69f546  # 22:59      0-     62  Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 3f02ff5c2c69753666787ed125708d283a823ffb  # 23:11      5-     26  Merge tag 'tty-3.13-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
> git bisect good 1ab231b274ba51a54acebec23c6aded0f3cdf54e  # 23:19     62+      5  Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 5ee540613db504a10e15fafaf4c08cac96aa1823  # 23:32      7-      5  Merge branch 'for-linus' of git://git.kernel.dk/linux-block
> git bisect good 53c6de50262a8edd6932bb59a32db7b9d92f8d67  # 23:39     90+      0  Merge branch 'x86/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 59fb2f0e9e30ad99a8bab0ff1efaf8f4a3b7105f  # 00:12     90+      0  Merge tag 'fbdev-fixes-3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux
> git bisect good ef1e4e32d595d3e6c9a6d3d2956f087d5886c5e5  # 01:00     90+      0  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
> git bisect good 29be6345bbaec8502a70c4e2204d5818b48c4e8f  # 01:08     90+      0  Merge tag 'nfs-for-3.13-3' of git://git.linux-nfs.org/projects/trondmy/linux-nfs
> git bisect  bad e345d767f6530ec9cb0aabab7ea248072a9c6975  # 01:38     31-     32  Merge branch 'stable/for-jens-3.13-take-two' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip into for-linus
> git bisect  bad c170bbb45febc03ac4d34ba2b8bb55e06104b7e7  # 01:43     28-     19  block: submit_bio_wait() conversions
> git bisect  bad 2c575026fae6e63771bd2a4c1d407214a8096a89  # 02:04      6-     16  Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
> # first bad commit: [2c575026fae6e63771bd2a4c1d407214a8096a89] Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
> git bisect good 82023bb7f75b0052f40d3e74169d191c3e4e6286  # 02:29    270+      0  Merge tag 'pm+acpi-2-3.13-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> git bisect  bad f1f29248d675d4762e7b7f498be50d2fb9c294f3  # 02:30      0-      4  0day head guard for 'devel-hourly-2014080120'
> git bisect  bad 6f0928036bcbd8dd2ebee9201580da8bcc0a81af  # 03:31     20-     20  Merge tag 'pm+acpi-3.16-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> git bisect  bad 4198cf324ddea447daac3f83d3c2319ced774201  # 03:38     16-     17  Add linux-next specific files for 20140801
>
>
> This script may reproduce the error.
>
> ----------------------------------------------------------------------------
> #!/bin/bash
>
> kernel=$1
> initrd=yocto-minimal-i386.cgz
>
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd
>
> kvm=(
>         qemu-system-x86_64
>         -enable-kvm
>         -cpu Haswell,+smep,+smap
>         -kernel $kernel
>         -initrd $initrd
>         -m 320
>         -smp 1
>         -net nic,vlan=1,model=e1000
>         -net user,vlan=1
>         -boot order=nc
>         -no-reboot
>         -watchdog i6300esb
>         -rtc base=localtime
>         -serial stdio
>         -display none
>         -monitor null
> )
>
> append=(
>         hung_task_panic=1
>         earlyprintk=ttyS0,115200
>         debug
>         apic=debug
>         sysrq_always_enabled
>         rcupdate.rcu_cpu_stall_timeout=100
>         panic=10
>         softlockup_panic=1
>         nmi_watchdog=panic
>         prompt_ramdisk=0
>         console=ttyS0,115200
>         console=tty0
>         vga=normal
>         root=/dev/ram0
>         rw
>         drbd.minor_count=8
> )
>
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
>
> Thanks,
> Fengguang
>
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
>
Hey Fenngguag,
I assume this is the commit your are talking about after the robot
runs git bisect.
commit 2c575026fae6e63771bd2a4c1d407214a8096a89
Author: Hong Zhiguo <zhiguohong@tencent.com>
Date:   Wed Nov 20 10:35:05 2013 -0700

    Update of blkg_stat and blkg_rwstat may happen in bh context.
    While u64_stats_fetch_retry is only preempt_disable on 32bit
    UP system. This is not enough to avoid preemption by bh and
    may read strange 64 bit value.

    Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
    Acked-by: Tejun Heo <tj@kernel.org>
    Cc: stable@kernel.org
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 1610b22..86154ea 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -435,9 +435,9 @@ static inline uint64_t blkg_stat_read(struct
blkg_stat *stat)
        uint64_t v;

        do {
-               start = u64_stats_fetch_begin(&stat->syncp);
+               start = u64_stats_fetch_begin_bh(&stat->syncp);
                v = stat->cnt;
-       } while (u64_stats_fetch_retry(&stat->syncp, start));
+       } while (u64_stats_fetch_retry_bh(&stat->syncp, start));

        return v;
 }
@@ -508,9 +508,9 @@ static inline struct blkg_rwstat
blkg_rwstat_read(struct blkg_rwstat *rwstat)
        struct blkg_rwstat tmp;

        do {
-               start = u64_stats_fetch_begin(&rwstat->syncp);
+               start = u64_stats_fetch_begin_bh(&rwstat->syncp);
                tmp = *rwstat;
-       } while (u64_stats_fetch_retry(&rwstat->syncp, start));
+       } while (u64_stats_fetch_retry_bh(&rwstat->syncp, start));

        return tmp;
 }

After tracing i actually get the same call with irqs functions instead
of bottom halves,
maybe it's just the lxr I am using but it seems that this may be the issue we
are now calling in irqs, and not bottom halves. I am putting my function traces
below with the line numbers I am hitting in linus's tree after updating today.
Regards

static inline uint64_t blkg_stat_read(struct blkg_stat *stat)
434 {
435 unsigned int start;
436 uint64_t v;
437
438 do {
439 start = u64_stats_fetch_begin_irq(&stat->syncp);
440 v = stat->cnt;
441 } while (u64_stats_fetch_retry_irq(&stat->syncp, start));
442
443 return v;
444 }

506 static inline struct blkg_rwstat blkg_rwstat_read(struct
blkg_rwstat *rwstat)
507 {
508 unsigned int start;
509 struct blkg_rwstat tmp;
510
511 do {
512 start = u64_stats_fetch_begin_irq(&rwstat->syncp);
513 tmp = *rwstat;
514 } while (u64_stats_fetch_retry_irq(&rwstat->syncp, start));
515
516 return tmp;
517 }
