Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaHVCIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 22:08:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:10926 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbaHVCIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 22:08:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,377,1406617200"; 
   d="scan'208";a="580191446"
Date: Fri, 22 Aug 2014 10:08:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Hong Zhiguo <zhiguohong@tencent.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [blkg_stat] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
Message-ID: <20140822020843.GA3247@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Hong and Jens,

FYI, this patch still has the error that impacts the latest linux-next.

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
commit 2c575026fae6e63771bd2a4c1d407214a8096a89
Author:     Hong Zhiguo <zhiguohong@tencent.com>
AuthorDate: Wed Nov 20 10:35:05 2013 -0700
Commit:     Jens Axboe <axboe@kernel.dk>
CommitDate: Wed Nov 20 15:33:04 2013 -0700

    Update of blkg_stat and blkg_rwstat may happen in bh context.
    While u64_stats_fetch_retry is only preempt_disable on 32bit
    UP system. This is not enough to avoid preemption by bh and
    may read strange 64 bit value.
    
    Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
    Acked-by: Tejun Heo <tj@kernel.org>
    Cc: stable@kernel.org
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

+-----------------------------------------------------------------------+------------+------------+
|                                                                       | 82023bb7f7 | 2c575026fa |
+-----------------------------------------------------------------------+------------+------------+
| boot_successes                                                        | 496        | 0          |
| boot_failures                                                         | 494        | 330        |
| WARNING:CPU:PID:at_arch/x86/mm/ioremap.c:__early_ioremap()            | 493        | 177        |
| WARNING:CPU:PID:at_kernel/trace/ring_buffer.c:rb_reserve_next_event() | 493        | 177        |
| backtrace:acpi_initialize_tables                                      | 493        | 177        |
| backtrace:acpi_table_init                                             | 493        | 177        |
| backtrace:acpi_boot_table_init                                        | 493        | 177        |
| backtrace:ring_buffer_producer_thread                                 | 493        | 177        |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference                  | 3          | 2          |
| Oops                                                                  | 3          | 2          |
| EIP_is_at_strlen                                                      | 3          | 2          |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt                 | 2          |            |
| Kernel_panic-not_syncing:Fatal_exception                              | 1          | 2          |
| backtrace:vfs_write                                                   | 1          | 2          |
| backtrace:SyS_write                                                   | 1          | 2          |
| WARNING:CPU:PID:at_kernel/softirq.c:local_bh_enable()                 | 0          | 330        |
| inconsistent_IN-SOFTIRQ-W-SOFTIRQ-ON-W_usage                          | 0          | 330        |
| backtrace:do_mount                                                    | 0          | 330        |
| backtrace:SyS_mount                                                   | 0          | 330        |
| backtrace:smpboot_thread_fn                                           | 0          | 182        |
+-----------------------------------------------------------------------+------------+------------+

[    7.266963] scsi_id (235) used greatest stack depth: 6008 bytes left
[    7.403676] ------------[ cut here ]------------
[    7.404033] WARNING: CPU: 0 PID: 264 at kernel/softirq.c:156 local_bh_enable+0x9c/0x1e0()
[    7.404033] CPU: 0 PID: 264 Comm: mount Tainted: G        W    3.12.0-02795-g2c57502 #16
[    7.404033]  00000001 511d1a58 420d4200 511d1a88 4109f3dd 426e5c40 00000000 00000108
[    7.404033]  426e5fb0 0000009c 410a68dc 410a68dc 00000001 4183189d 00000001 511d1a98
[    7.404033]  4109f4c2 00000009 00000000 511d1aac 410a68dc 51c9f008 51c9f23c 511d1ad8
[    7.404033] Call Trace:
[    7.404033]  [<420d4200>] dump_stack+0x16/0x18
[    7.404033]  [<4109f3dd>] warn_slowpath_common+0x8d/0xb0
[    7.404033]  [<410a68dc>] ? local_bh_enable+0x9c/0x1e0
[    7.404033]  [<410a68dc>] ? local_bh_enable+0x9c/0x1e0
[    7.404033]  [<4183189d>] ? cfqg_stats_update_avg_queue_size+0x2d/0x100
[    7.404033]  [<4109f4c2>] warn_slowpath_null+0x22/0x30
[    7.404033]  [<410a68dc>] local_bh_enable+0x9c/0x1e0
[    7.404033]  [<4183189d>] cfqg_stats_update_avg_queue_size+0x2d/0x100
[    7.404033]  [<41833f4a>] __cfq_set_active_queue+0x15a/0x210
[    7.404033]  [<418300d9>] ? cfq_group_service_tree_add+0x199/0x260
[    7.404033]  [<41831f84>] ? cfq_service_tree_add+0x404/0x4f0
[    7.404033]  [<418320a9>] ? cfq_resort_rr_list+0x39/0x40
[    7.404033]  [<41832fff>] ? cfq_add_cfqq_rr+0x16f/0x1c0
[    7.404033]  [<4183a014>] ? cfq_update_idle_window.isra.78+0x84/0x3a0
[    7.404033]  [<41836b4c>] cfq_select_queue+0x7ec/0xa90
[    7.404033]  [<4183988f>] cfq_dispatch_requests+0x2bf/0x9c0
[    7.404033]  [<410833ec>] ? pvclock_clocksource_read+0xfc/0x240
[    7.404033]  [<410822f3>] ? kvm_clock_read+0x13/0x20
[    7.404033]  [<4183a702>] ? cfq_insert_request+0x3d2/0x8b0
[    7.404033]  [<410e0fc3>] ? sched_clock_local.constprop.2+0x43/0x190
[    7.404033]  [<410f5bd3>] ? __lock_acquire+0x1113/0x11a0
[    7.404033]  [<410f2fcb>] ? trace_hardirqs_off+0xb/0x10
[    7.404033]  [<4180f572>] blk_peek_request+0x302/0x450
[    7.404033]  [<4183fa06>] ? kobject_get+0xd6/0x100
[    7.404033]  [<419f1e08>] scsi_request_fn+0x68/0x8d0
[    7.404033]  [<4180b322>] __blk_run_queue_uncond+0x42/0x50
[    7.404033]  [<4180b370>] __blk_run_queue+0x40/0x50
[    7.404033]  [<418104ed>] blk_queue_bio+0x3dd/0x4e0
[    7.404033]  [<4180d1b2>] generic_make_request+0x102/0x180
[    7.404033]  [<4180d3a7>] submit_bio+0x177/0x250
[    7.404033]  [<412459da>] ? __find_get_block+0x2da/0x390
[    7.404033]  [<4124b46d>] ? bio_alloc_bioset+0xfd/0x340
[    7.404033]  [<4124673c>] _submit_bh+0x2dc/0x320
[    7.404033]  [<4124a595>] __bread+0x85/0x1f0
[    7.404033]  [<41301fb9>] ext3_fill_super+0x1a9/0x1d10
[    7.404033]  [<4184c428>] ? snprintf+0x18/0x20
[    7.404033]  [<41301e10>] ? ext3_setup_super+0x340/0x340
[    7.404033]  [<4120090d>] mount_bdev+0x1ed/0x2c0
[    7.404033]  [<41301e10>] ? ext3_setup_super+0x340/0x340
[    7.404033]  [<411debb0>] ? __kmalloc_track_caller+0xd0/0x2a0
[    7.404033]  [<412fc2bf>] ext3_mount+0x1f/0x30
[    7.404033]  [<41301e10>] ? ext3_setup_super+0x340/0x340
[    7.404033]  [<41200d27>] mount_fs+0x47/0x1f0
[    7.404033]  [<4122a0a5>] ? alloc_vfsmnt+0x175/0x1c0
[    7.404033]  [<4122b633>] vfs_kern_mount+0xa3/0x1a0
[    7.404033]  [<420e8122>] ? _raw_read_unlock+0x22/0x30
[    7.404033]  [<4122e786>] do_mount+0xdb6/0x11c0
[    7.404033]  [<4122d9ac>] ? copy_mount_string+0x5c/0x80
[    7.404033]  [<4122f003>] SyS_mount+0xf3/0x120
[    7.404033]  [<420e8e8c>] syscall_call+0x7/0xb
[    7.404033] ---[ end trace 05e0c07eb1c663a9 ]---
[    7.404033] 
[    7.404033] =================================
[    7.404033] [ INFO: inconsistent lock state ]
[    7.404033] 3.12.0-02795-g2c57502 #16 Tainted: G        W   
[    7.404033] ---------------------------------
[    7.404033] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[    7.404033] mount/264 [HC0[0]:SC0[0]:HE1:SE1] takes:
[    7.404033]  (&(&q->__queue_lock)->rlock){+.?...}, at: [<418104cb>] blk_queue_bio+0x3bb/0x4e0
[    7.404033] {IN-SOFTIRQ-W} state was registered at:
[    7.404033]   [<410f501b>] __lock_acquire+0x55b/0x11a0
[    7.404033]   [<410f63f3>] lock_acquire+0xd3/0x110
[    7.404033]   [<420e7b01>] _raw_spin_lock+0x41/0x90
[    7.404033]   [<419f2fa6>] scsi_device_unbusy+0x76/0xf0
[    7.404033]   [<419ea282>] scsi_finish_command+0x22/0x120
[    7.404033]   [<419f320f>] scsi_softirq_done+0xef/0x170
[    7.404033]   [<4181826b>] blk_done_softirq+0x7b/0x90
[    7.404033]   [<410a6214>] __do_softirq+0x134/0x450
[    7.404033]   [<410a656c>] run_ksoftirqd+0x3c/0x80
[    7.404033]   [<410d89fc>] smpboot_thread_fn+0x1dc/0x250
[    7.404033]   [<410cdec9>] kthread+0xf9/0x100
[    7.404033]   [<420e949b>] ret_from_kernel_thread+0x1b/0x30
[    7.404033] irq event stamp: 2012
[    7.404033] hardirqs last  enabled at (2009): [<420e7dd7>] _raw_spin_unlock_irq+0x27/0x40
[    7.404033] hardirqs last disabled at (2010): [<420e7c0a>] _raw_spin_lock_irq+0x1a/0x90
[    7.404033] softirqs last  enabled at (2012): [<4183189d>] cfqg_stats_update_avg_queue_size+0x2d/0x100
[    7.404033] softirqs last disabled at (2011): [<41831888>] cfqg_stats_update_avg_queue_size+0x18/0x100
[    7.404033] 
[    7.404033] other info that might help us debug this:
[    7.404033]  Possible unsafe locking scenario:
[    7.404033] 
[    7.404033]        CPU0
[    7.404033]        ----
[    7.404033]   lock(&(&q->__queue_lock)->rlock);
[    7.404033]   <Interrupt>
[    7.404033]     lock(&(&q->__queue_lock)->rlock);
[    7.404033] 
[    7.404033]  *** DEADLOCK ***
[    7.404033] 
[    7.404033] 2 locks held by mount/264:
[    7.404033]  #0:  (&type->s_umount_key#19/1){+.+.+.}, at: [<411ff563>] sget+0x2f3/0x530
[    7.404033]  #1:  (&(&q->__queue_lock)->rlock){+.?...}, at: [<418104cb>] blk_queue_bio+0x3bb/0x4e0
[    7.404033] 
[    7.404033] stack backtrace:
[    7.404033] CPU: 0 PID: 264 Comm: mount Tainted: G        W    3.12.0-02795-g2c57502 #16
[    7.404033]  43159a40 511d19d4 420d4200 511d1a10 420b10dc 426e18ee 426e1c9c 00000108
[    7.404033]  00000000 00000000 00000000 00000000 00000001 00000001 426e1c9c 00000006
[    7.404033]  51208484 410f16f0 511d1a40 410f26bd 00000006 00000001 0000009c 511d1a44
[    7.404033] Call Trace:
[    7.404033]  [<420d4200>] dump_stack+0x16/0x18
[    7.404033]  [<420b10dc>] print_usage_bug+0x1d1/0x1db
[    7.404033]  [<410f16f0>] ? check_usage_forwards+0xe0/0xe0
[    7.404033]  [<410f26bd>] mark_lock+0x18d/0x2e0
[    7.404033]  [<410f2911>] mark_held_locks+0x101/0x110
[    7.404033]  [<4109f33f>] ? print_oops_end_marker+0x2f/0x40
[    7.404033]  [<4109f3ec>] ? warn_slowpath_common+0x9c/0xb0
[    7.404033]  [<410a693b>] ? local_bh_enable+0xfb/0x1e0
[    7.404033]  [<410f2c8c>] trace_hardirqs_on_caller+0x17c/0x220
[    7.404033]  [<4183189d>] ? cfqg_stats_update_avg_queue_size+0x2d/0x100
[    7.404033]  [<410f2d3b>] trace_hardirqs_on+0xb/0x10
[    7.404033]  [<410a693b>] local_bh_enable+0xfb/0x1e0
[    7.404033]  [<4183189d>] cfqg_stats_update_avg_queue_size+0x2d/0x100
[    7.404033]  [<41833f4a>] __cfq_set_active_queue+0x15a/0x210
[    7.404033]  [<418300d9>] ? cfq_group_service_tree_add+0x199/0x260
[    7.404033]  [<41831f84>] ? cfq_service_tree_add+0x404/0x4f0
[    7.404033]  [<418320a9>] ? cfq_resort_rr_list+0x39/0x40
[    7.404033]  [<41832fff>] ? cfq_add_cfqq_rr+0x16f/0x1c0
[    7.404033]  [<4183a014>] ? cfq_update_idle_window.isra.78+0x84/0x3a0
[    7.404033]  [<41836b4c>] cfq_select_queue+0x7ec/0xa90
[    7.404033]  [<4183988f>] cfq_dispatch_requests+0x2bf/0x9c0
[    7.404033]  [<410833ec>] ? pvclock_clocksource_read+0xfc/0x240
[    7.404033]  [<410822f3>] ? kvm_clock_read+0x13/0x20
[    7.404033]  [<4183a702>] ? cfq_insert_request+0x3d2/0x8b0
[    7.404033]  [<410e0fc3>] ? sched_clock_local.constprop.2+0x43/0x190
[    7.404033]  [<410f5bd3>] ? __lock_acquire+0x1113/0x11a0
[    7.404033]  [<410f2fcb>] ? trace_hardirqs_off+0xb/0x10
[    7.404033]  [<4180f572>] blk_peek_request+0x302/0x450
[    7.404033]  [<4183fa06>] ? kobject_get+0xd6/0x100
[    7.404033]  [<419f1e08>] scsi_request_fn+0x68/0x8d0
[    7.404033]  [<4180b322>] __blk_run_queue_uncond+0x42/0x50
[    7.404033]  [<4180b370>] __blk_run_queue+0x40/0x50
[    7.404033]  [<418104ed>] blk_queue_bio+0x3dd/0x4e0
[    7.404033]  [<4180d1b2>] generic_make_request+0x102/0x180
[    7.404033]  [<4180d3a7>] submit_bio+0x177/0x250
[    7.404033]  [<412459da>] ? __find_get_block+0x2da/0x390
[    7.404033]  [<4124b46d>] ? bio_alloc_bioset+0xfd/0x340
[    7.404033]  [<4124673c>] _submit_bh+0x2dc/0x320
[    7.404033]  [<4124a595>] __bread+0x85/0x1f0
[    7.404033]  [<41301fb9>] ext3_fill_super+0x1a9/0x1d10
[    7.404033]  [<4184c428>] ? snprintf+0x18/0x20
[    7.404033]  [<41301e10>] ? ext3_setup_super+0x340/0x340
[    7.404033]  [<4120090d>] mount_bdev+0x1ed/0x2c0
[    7.404033]  [<41301e10>] ? ext3_setup_super+0x340/0x340
[    7.404033]  [<411debb0>] ? __kmalloc_track_caller+0xd0/0x2a0
[    7.404033]  [<412fc2bf>] ext3_mount+0x1f/0x30
[    7.404033]  [<41301e10>] ? ext3_setup_super+0x340/0x340
[    7.404033]  [<41200d27>] mount_fs+0x47/0x1f0
[    7.404033]  [<4122a0a5>] ? alloc_vfsmnt+0x175/0x1c0
[    7.404033]  [<4122b633>] vfs_kern_mount+0xa3/0x1a0
[    7.404033]  [<420e8122>] ? _raw_read_unlock+0x22/0x30
[    7.404033]  [<4122e786>] do_mount+0xdb6/0x11c0
[    7.404033]  [<4122d9ac>] ? copy_mount_string+0x5c/0x80
[    7.404033]  [<4122f003>] SyS_mount+0xf3/0x120
[    7.404033]  [<420e8e8c>] syscall_call+0x7/0xb
[    7.789066] qnx6: unable to read the first superblock
[    7.791067] UDF-fs: warning (device sda): udf_fill_super: No partition found (2)
[    7.795064] NILFS: Can't find nilfs on dev sda.
[    7.795738] BeFS(sda): No write support. Marking filesystem read-only
[    7.797064] BeFS(sda): invalid magic header

git bisect start v3.13 v3.12 --
git bisect good 3bad8bb5cd3048a67df43ac6b1e2f191f19d9ff0  # 07:29    330+    207  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
git bisect  bad dd0508093b79141e0044ca02f0acb6319f69f546  # 07:33    266-    234  Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 3f02ff5c2c69753666787ed125708d283a823ffb  # 07:45    103-     70  Merge tag 'tty-3.13-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect good 1ab231b274ba51a54acebec23c6aded0f3cdf54e  # 07:59    330+      0  Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 5ee540613db504a10e15fafaf4c08cac96aa1823  # 08:18     53-      1  Merge branch 'for-linus' of git://git.kernel.dk/linux-block
git bisect good 53c6de50262a8edd6932bb59a32db7b9d92f8d67  # 08:24    330+      0  Merge branch 'x86/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 59fb2f0e9e30ad99a8bab0ff1efaf8f4a3b7105f  # 08:58    330+    130  Merge tag 'fbdev-fixes-3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux
git bisect good ef1e4e32d595d3e6c9a6d3d2956f087d5886c5e5  # 09:06    330+     87  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect good 29be6345bbaec8502a70c4e2204d5818b48c4e8f  # 09:10    330+    163  Merge tag 'nfs-for-3.13-3' of git://git.linux-nfs.org/projects/trondmy/linux-nfs
git bisect  bad e345d767f6530ec9cb0aabab7ea248072a9c6975  # 09:18    228-    125  Merge branch 'stable/for-jens-3.13-take-two' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip into for-linus
git bisect  bad c170bbb45febc03ac4d34ba2b8bb55e06104b7e7  # 09:21      0-     20  block: submit_bio_wait() conversions
git bisect  bad 2c575026fae6e63771bd2a4c1d407214a8096a89  # 09:24      0-      1  Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
# first bad commit: [2c575026fae6e63771bd2a4c1d407214a8096a89] Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
git bisect good 82023bb7f75b0052f40d3e74169d191c3e4e6286  # 09:32    990+    494  Merge tag 'pm+acpi-2-3.13-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect  bad 62287f766a9198a878852be74b35cc8a979c6b25  # 09:32      0-     11  0day head guard for 'devel-hourly-2014082110'
git bisect  bad 5317821c08533e5f42f974e4e68e092beaf099b1  # 09:42     43-     40  Merge branch 'for-3.17-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata
git bisect  bad deb9705745a63948e0a147713d39ed2aaaac97d7  # 09:47     19-     16  Add linux-next specific files for 20140822


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 1
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
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
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

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivb41-100:20140822092449:i386-randconfig-c1-08211449::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-02795-g2c57502 (kbuild@lkp-hsx01) (gcc =
version 4.8.2 (Debian 4.8.2-18) ) #16 Fri Aug 22 09:21:09 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   UMC UMC UMC UMC
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x100000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] initial memory mapped: [mem 0x00000000-0x03bfffff]
[    0.000000] Base memory trampoline at [4009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13800000-0x13bfffff]
[    0.000000]  [mem 0x13800000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13fdffff]
[    0.000000]  [mem 0x13c00000-0x13fdffff] page 4k
[    0.000000] BRK [0x035a0000, 0x035a0fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] Allocated new RAMDISK: [mem 0x1398a000-0x13cbc086]
[    0.000000] Move RAMDISK from [mem 0x13cbd000-0x13fef086] to [mem 0x1398=
a000-0x13cbc086]
[    0.000000] ACPI: RSDP 000f0cf0 000014 (v00 BOCHS )
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at arch/x86/mm/ioremap.c:536 __early_=
ioremap+0x1cb/0x290()
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-02795-g2c5750=
2 #16
[    0.000000]  00000000 42847e40 420d4200 42847e70 4109f3dd 426e5c40 00000=
000 00000000
[    0.000000]  426dcfa8 00000218 42e532c5 42e532c5 00000000 00000854 000bc=
ffc 42847e80
[    0.000000]  4109f4c2 00000009 00000000 42847eb8 42e532c5 00000357 42847=
e9c 4108b704
[    0.000000] Call Trace:
[    0.000000]  [<420d4200>] dump_stack+0x16/0x18
[    0.000000]  [<4109f3dd>] warn_slowpath_common+0x8d/0xb0
[    0.000000]  [<42e532c5>] ? __early_ioremap+0x1cb/0x290
[    0.000000]  [<42e532c5>] ? __early_ioremap+0x1cb/0x290
[    0.000000]  [<4109f4c2>] warn_slowpath_null+0x22/0x30
[    0.000000]  [<42e532c5>] __early_ioremap+0x1cb/0x290
[    0.000000]  [<4108b704>] ? native_set_fixmap+0x44/0x50
[    0.000000]  [<42e53588>] early_ioremap+0xd/0xf
[    0.000000]  [<42e4f681>] __acpi_map_table+0x2c/0x34
[    0.000000]  [<420ac24e>] acpi_os_map_memory+0x3b/0x1b5
[    0.000000]  [<420ac400>] ? acpi_os_unmap_memory+0x38/0x108
[    0.000000]  [<42e8b35c>] acpi_tb_parse_root_table+0x290/0x478
[    0.000000]  [<42e8b9d2>] ? acpi_find_root_pointer+0x171/0x1bd
[    0.000000]  [<42e8b5fd>] acpi_initialize_tables+0xb9/0xc2
[    0.000000]  [<42e89291>] acpi_table_init+0x17/0xb7
[    0.000000]  [<42e4f7c2>] acpi_boot_table_init+0x2d/0xd5
[    0.000000]  [<42e48245>] setup_arch+0xbc8/0xe73
[    0.000000]  [<420b1263>] ? printk+0x3d/0x3f
[    0.000000]  [<42e40a3c>] start_kernel+0xbb/0x494
[    0.000000]  [<42e4039b>] i386_start_kernel+0x145/0x148
[    0.000000] ---[ end trace 05e0c07eb1c663a6 ]---
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, boot clock
[    0.000000] BRK [0x035a1000, 0x035a1fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13fdffff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat 42a63000, node_mem_map 53=
d5f020
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81790 pages, LIFO batch:15
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 285bd00
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81150
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-c1-08211449/linux-devel:devel-hourly-2014082110:2c575026fae6e6377=
1bd2a4c1d407214a8096a89:bisect-linux-0/.vmlinuz-2c575026fae6e63771bd2a4c1d4=
07214a8096a89-20140822092123-129-ivb41 branch=3Dlinux-devel/devel-hourly-20=
14082110 BOOT_IMAGE=3D/kernel/i386-randconfig-c1-08211449/2c575026fae6e6377=
1bd2a4c1d407214a8096a89/vmlinuz-3.12.0-02795-g2c57502 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 655096 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 281596K/327160K available (17320K kernel code, 6121K=
 rwdata, 7524K rodata, 836K init, 6656K bss, 45564K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x547e0000 - 0xff7fe000   (2736 MB)
[    0.000000]     lowmem  : 0x40000000 - 0x53fe0000   ( 319 MB)
[    0.000000]       .init : 0x42e40000 - 0x42f11000   ( 836 kB)
[    0.000000]       .data : 0x420ea6b2 - 0x42e3f4c0   (13651 kB)
[    0.000000]       .text : 0x41000000 - 0x420ea6b2   (17321 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3D40090000 soft=3D40092000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 2 of 2 active objects replaced
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.001000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D2693508)
[    0.003012] pid_max: default: 32768 minimum: 301
[    0.004013] Mount-cache hash table entries: 512
[    0.005714] Initializing cgroup subsys debug
[    0.006025] Initializing cgroup subsys memory
[    0.006554] Initializing cgroup subsys blkio
[    0.007014] Initializing cgroup subsys perf_event
[    0.007662] mce: CPU supports 10 MCE banks
[    0.008012] mce: unknown CPU type - not enabling MCE support
[    0.009020] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009020] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009020] tlb_flushall_shift: -1
[    0.010010] CPU: GenuineIntel Common KVM processor (fam: 0f, model: 06, =
stepping: 01)
[    0.016159] ftrace: allocating 42981 entries in 84 pages
[    0.032406] Performance Events: no PMU driver, software events only.
[    0.033803] ftrace: Allocated trace_printk buffers
[    0.037355] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.038718] devtmpfs: initialized
[    0.049220] xor: measuring software checksum speed
[    0.060011]    pIII_sse  :  9276.000 MB/sec
[    0.071011]    prefetch64-sse: 10016.000 MB/sec
[    0.071538] xor: using function: prefetch64-sse (10016.000 MB/sec)
[    0.072017] atomic64 test passed for i386+ platform with CX8 and with SSE
[    0.073822] regulator-dummy: no parameters
[    0.074498] NET: Registered protocol family 16
[    0.076475] cpuidle: using governor ladder
[    0.076955] cpuidle: using governor menu
[    0.079311] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    0.080010] PCI: Using configuration type 1 for base access
[    0.105953] bio: create slab <bio-0> at 0
[    0.126032] raid6: mmxx1     2695 MB/s
[    0.143022] raid6: mmxx2     2976 MB/s
[    0.160024] raid6: sse1x1    2324 MB/s
[    0.177021] raid6: sse1x2    3007 MB/s
[    0.194011] raid6: sse2x1    4578 MB/s
[    0.211014] raid6: sse2x2    6062 MB/s
[    0.211456] raid6: using algorithm sse2x2 (6062 MB/s)
[    0.212010] raid6: using intx1 recovery algorithm
[    0.212719] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.213064] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.214322] ACPI: Interpreter disabled.
[    0.218267] vgaarb: loaded
[    0.219916] SCSI subsystem initialized
[    0.220095] libata version 3.00 loaded.
[    0.221284] pps_core: LinuxPPS API ver. 1 registered
[    0.221857] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.222035] PTP clock support registered
[    0.224061] PCI: Probing PCI hardware
[    0.224509] PCI: root bus 00: using default resources
[    0.225013] PCI: Probing PCI hardware (bus 00)
[    0.225706] PCI host bridge to bus 0000:00
[    0.226014] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.227012] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
f]
[    0.227797] pci_bus 0000:00: No busn resource found for root bus, will u=
se [bus 00-ff]
[    0.228080] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.230524] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.231666] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.235537] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.237507] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.238436] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.239022] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.240356] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.244016] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.247015] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.254015] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.255124] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.256082] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.259012] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.261501] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.267012] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.268274] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.269521] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.275782] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 00
[    0.276050] pci 0000:00:01.0: PIIX/ICH IRQ router [8086:7000]
[    0.277101] PCI: pci_cache_line_size set to 64 bytes
[    0.278146] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.278833] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.280319] Bluetooth: Core ver 2.17
[    0.280804] NET: Registered protocol family 31
[    0.281009] Bluetooth: HCI device and connection manager initialized
[    0.282034] Bluetooth: HCI socket layer initialized
[    0.282617] Bluetooth: L2CAP socket layer initialized
[    0.283037] Bluetooth: SCO socket layer initialized
[    0.283624] NET: Registered protocol family 8
[    0.284010] NET: Registered protocol family 20
[    0.285057] nfc: nfc_init: NFC Core ver 0.1
[    0.285619] NET: Registered protocol family 39
[    0.286609] Switched to clocksource kvm-clock
[    0.300745] Warning: could not register all branches stats
[    0.301410] Warning: could not register annotated branches stats
[    0.625492] FS-Cache: Loaded
[    0.626418] CacheFiles: Loaded
[    0.626824] pnp: PnP ACPI: disabled
[    0.642247] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.642933] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.643770] NET: Registered protocol family 2
[    0.644895] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    0.645755] TCP bind hash table entries: 4096 (order: 5, 180224 bytes)
[    0.646832] TCP: Hash tables configured (established 4096 bind 4096)
[    0.647613] TCP: reno registered
[    0.648046] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    0.648769] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    0.658869] NET: Registered protocol family 1
[    0.660362] RPC: Registered named UNIX socket transport module.
[    0.661119] RPC: Registered udp transport module.
[    0.661677] RPC: Registered tcp transport module.
[    0.662283] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.663096] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.663833] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.664573] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.665391] pci 0000:00:02.0: Boot video device
[    0.665979] PCI: CLS 0 bytes, default 64
[    0.666951] Unpacking initramfs...
[    1.042927] Freeing initrd memory: 3276K (5398a000 - 53cbd000)
[    1.044326] has_svm: not amd
[    1.044682] kvm: no hardware support
[    1.045278] platform rtc_cmos: registered platform RTC device (no PNP de=
vice found)
[    1.046236] Machine check injector initialized
[    1.047396] apm: BIOS not found.
[    1.048197] cryptomgr_test (19) used greatest stack depth: 7128 bytes le=
ft
[    1.050769] PCLMULQDQ-NI instructions are not detected.
[    1.052370] audit: initializing netlink socket (disabled)
[    1.053136] type=3D2000 audit(1408667844.777:1): initialized
[    1.069071] ------------[ cut here ]------------
[    1.069655] WARNING: CPU: 0 PID: 33 at kernel/trace/ring_buffer.c:2571 r=
b_reserve_next_event+0x109/0x440()
[    1.071025] Delta way too big! 18446741317205823047 ts=3D184467413172058=
23047 write stamp =3D 0
[    1.071025] If you just came from a suspend/resume,
[    1.071025] please switch to the trace global clock:
[    1.071025]   echo global > /sys/kernel/debug/tracing/trace_clock
[    1.073858] CPU: 0 PID: 33 Comm: rb_producer Tainted: G        W    3.12=
=2E0-02795-g2c57502 #16
[    1.074882]  00000000 52bdbdc4 420d4200 52bdbdf4 4109f3dd 426ecffc 52bdb=
e20 00000021
[    1.075929]  426ecf44 00000a0b 41150869 41150869 33930e47 fffffd7e 4001b=
608 52bdbe0c
[    1.076967]  4109f453 00000009 52bdbe04 426ecffc 52bdbe20 52bdbe7c 41150=
869 426ecf44
[    1.078007] Call Trace:
[    1.078317]  [<420d4200>] dump_stack+0x16/0x18
[    1.078840]  [<4109f3dd>] warn_slowpath_common+0x8d/0xb0
[    1.079456]  [<41150869>] ? rb_reserve_next_event+0x109/0x440
[    1.080141]  [<41150869>] ? rb_reserve_next_event+0x109/0x440
[    1.080799]  [<4109f453>] warn_slowpath_fmt+0x33/0x40
[    1.081387]  [<41150869>] rb_reserve_next_event+0x109/0x440
[    1.095073]  [<41151a79>] ring_buffer_lock_reserve+0x99/0xc0
[    1.095734]  [<41156e5f>] trace_buffer_lock_reserve+0xf/0x40
[    1.096390]  [<411532ce>] ? ring_buffer_producer_thread+0x5e/0x590
[    1.097127]  [<4115712d>] __trace_bputs+0x3d/0x80
[    1.097664]  [<41153270>] ? wait_to_die+0x40/0x40
[    1.098232]  [<411532de>] ring_buffer_producer_thread+0x6e/0x590
[    1.098917]  [<410f2d3b>] ? trace_hardirqs_on+0xb/0x10
[    1.099518]  [<41153270>] ? wait_to_die+0x40/0x40
[    1.100093]  [<410cdec9>] kthread+0xf9/0x100
[    1.100588]  [<41153270>] ? wait_to_die+0x40/0x40
[    1.101161]  [<420e949b>] ret_from_kernel_thread+0x1b/0x30
[    1.101792]  [<410cddd0>] ? __kthread_unpark+0x80/0x80
[    1.102391] ---[ end trace 05e0c07eb1c663a7 ]---
[    1.132444] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.133809] VFS: Disk quotas dquot_6.5.2
[    1.134360] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.135656] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.138103] FS-Cache: Netfs 'nfs' registered for caching
[    1.139064] NFS: Registering the id_resolver key type
[    1.139739] Key type id_resolver registered
[    1.140247] Key type id_legacy registered
[    1.154273] NTFS driver 2.1.30 [Flags: R/O].
[    1.154811] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    1.155408] QNX6 filesystem 1.0.0 registered.
[    1.156103] fuse init (API version 7.22)
[    1.156919] 9p: Installing v9fs 9p2000 file system support
[    1.157601] NILFS version 2 loaded
[    1.157998] BeFS version: 0.9.3
[    1.158385] OCFS2 1.5.0
[    1.158951] ocfs2: Registered cluster interface o2cb
[    1.159544] OCFS2 DLMFS 1.5.0
[    1.160056] OCFS2 User DLM kernel interface loaded
[    1.160598] OCFS2 Node Manager 1.5.0
[    1.172976] OCFS2 DLM 1.5.0
[    1.173529] bio: create slab <bio-1> at 1
[    1.174463] Btrfs loaded, assert=3Don
[    1.174971] FS-Cache: Netfs 'ceph' registered for caching
[    1.175603] ceph: loaded (mds proto 32)
[    1.194898] NET: Registered protocol family 38
[    1.195504] async_tx: api initialized (async)
[    1.196045] Key type asymmetric registered
[    1.196531] Asymmetric key parser 'x509' registered
[    1.197191] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    1.198075] io scheduler noop registered
[    1.198529] io scheduler deadline registered
[    1.199107] io scheduler cfq registered (default)
[    1.206052] test_string_helpers: Running tests...
[    1.206716] rbtree testing -> 41987 cycles
[    2.942901] augmented rbtree testing -> 72713 cycles
[    5.897378] HDLC line discipline maxframe=3D4096
[    5.898079] N_HDLC line discipline registered.
[    5.898715] r3964: Philips r3964 Driver $Revision: 1.10 $
[    5.899499] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.953537] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115=
200) is a 16550A
[    5.956951] serial: Freescale lpuart driver
[    5.958116] Non-volatile memory driver v1.3
[    5.958721] toshiba: not a supported Toshiba laptop
[    5.960240] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    5.961313] platform pc8736x_gpio.0: no device found
[    5.962223] nsc_gpio initializing
[    5.962715] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    5.963496] smapi::smapi_init, ERROR invalid usSmapiID
[    5.964233] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    5.965546] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    5.979559] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    5.980543] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    5.981799] Hangcheck: Using getrawmonotonic().
[    5.982785] [drm] Initialized drm 1.1.0 20060810
[    5.983621] dummy-irq: no IRQ given.  Use irq=3DN
[    5.984472] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    5.985796] c2port c2port0: C2 port uc added
[    5.986404] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    5.988839] Uniform Multi-Platform E-IDE driver
[    5.989509] ide-gd driver 1.18
[    5.989939] ide-cd driver 5.00
[    5.990750] Loading iSCSI transport class v2.0-870.
[    6.003200] rdac: device handler registered
[    6.003864] hp_sw: device handler registered
[    6.005289] SCSI Media Changer driver v0.25=20
[    6.011834] scsi_debug: host protection
[    6.012356] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    6.014673] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    6.030824] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.031933] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    6.034576] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    6.035506] sd 0:0:0:0: [sda] Write Protect is off
[    6.036143] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    6.039606] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    6.040895] slram: not enough parameters.
[    6.058712] ftl_cs: FTL header not found.
[    6.061354] HSI/SSI char device loaded
[    6.062201] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    6.064084] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.064790] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.067218] mousedev: PS/2 mouse device common for all mice
[    6.082883] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    6.085623] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    6.087145]  sda: unknown partition table
[    6.089391] ideapad_slidebar: DMI does not match
[    6.091830] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    6.092959] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    6.107320] i2c-parport-light: adapter type unspecified
[    6.108862] pps pps0: new PPS source ktimer
[    6.109442] pps pps0: ktimer PPS source registered
[    6.110064] pps_ldisc: PPS line discipline registered
[    6.110781] Driver for 1-wire Dallas network protocol.
[    6.111700] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    6.113113] power_supply test_ac: uevent
[    6.113601] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    6.114306] power_supply test_ac: prop ONLINE=3D1
[    6.114913] power_supply test_ac: power_supply_changed
[    6.115764] power_supply test_battery: uevent
[    6.116332] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    6.117155] power_supply test_battery: prop STATUS=3DDischarging
[    6.117869] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    6.118571] power_supply test_battery: prop HEALTH=3DGood
[    6.119259] power_supply test_battery: prop PRESENT=3D1
[    6.132948] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    6.133682] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    6.134473] power_supply test_battery: prop CHARGE_FULL=3D100
[    6.135195] power_supply test_battery: prop CHARGE_NOW=3D50
[    6.135881] power_supply test_battery: prop CAPACITY=3D50
[    6.136545] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    6.137322] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    6.138114] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    6.138862] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    6.139638] power_supply test_battery: prop MANUFACTURER=3DLinux
[    6.140385] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-02795=
-g2c57502
[    6.141305] power_supply test_battery: prop TEMP=3D26
[    6.141917] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    6.143093] power_supply test_battery: power_supply_changed
[    6.143881] power_supply test_usb: uevent
[    6.144403] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    6.145138] power_supply test_usb: prop ONLINE=3D1
[    6.158783] power_supply test_usb: power_supply_changed
[    6.161597] f71882fg: Not a Fintek device
[    6.162166] f71882fg: Not a Fintek device
[    6.164305] pc87360: PC8736x not detected, module not inserted
[    6.165145] sch56xx_common: Unsupported device id: 0xff
[    6.165814] sch56xx_common: Unsupported device id: 0xff
[    6.167456] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    6.178967] power_supply test_ac: power_supply_changed_work
[    6.179751] power_supply test_ac: uevent
[    6.180234] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    6.180886] power_supply test_ac: prop ONLINE=3D1
[    6.181593] power_supply test_battery: power_supply_changed_work
[    6.182343] power_supply test_battery: uevent
[    6.182860] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    6.183592] power_supply test_battery: prop STATUS=3DDischarging
[    6.184287] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    6.184937] power_supply test_battery: prop HEALTH=3DGood
[    6.185543] power_supply test_battery: prop PRESENT=3D1
[    6.186166] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    6.199919] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    6.200636] power_supply test_battery: prop CHARGE_FULL=3D100
[    6.201299] power_supply test_battery: prop CHARGE_NOW=3D50
[    6.201924] power_supply test_battery: prop CAPACITY=3D50
[    6.202528] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    6.203255] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    6.203968] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    6.204664] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    6.205389] power_supply test_battery: prop MANUFACTURER=3DLinux
[    6.206100] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-02795=
-g2c57502
[    6.206926] power_supply test_battery: prop TEMP=3D26
[    6.207496] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    6.208300] power_supply test_usb: power_supply_changed_work
[    6.208966] power_supply test_usb: uevent
[    6.209439] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    6.210142] power_supply test_usb: prop ONLINE=3D1
[    6.210766] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.211567] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    6.212403] it87_wdt: no device
[    6.225913] sc1200wdt: build 20020303
[    6.226393] sc1200wdt: io parameter must be specified
[    6.227058] sbc60xxwdt: I/O address 0x0443 already in use
[    6.227669] sbc7240_wdt: I/O address 0x0443 already in use
[    6.228324] cpu5wdt: misc_register failed
[    6.228839] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    6.230828] smsc37b787_wdt: Unable to register miscdev on minor 130
[    6.231543] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG=
/DHG Super I/O chip initialising
[    6.232643] w83627hf_wdt: Watchdog already running. Resetting timeout to=
 60 sec
[    6.233566] watchdog: W83627HF Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    6.234500] watchdog: W83627HF Watchdog: a legacy watchdog module is pro=
bably present.
[    6.235743] w83627hf_wdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    6.236590] w83977f_wdt: driver v1.00
[    6.237156] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    6.238055] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    6.251810] machzwd: no ZF-Logic found
[    6.252271] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    6.253173] md: raid0 personality registered for level 0
[    6.253787] md: raid1 personality registered for level 1
[    6.254400] md: raid10 personality registered for level 10
[    6.255416] md: raid6 personality registered for level 6
[    6.256071] md: raid5 personality registered for level 5
[    6.256668] md: raid4 personality registered for level 4
[    6.257293] md: multipath personality registered for level -4
[    6.258214] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    6.259753] device-mapper: multipath: version 1.6.0 loaded
[    6.260418] device-mapper: multipath round-robin: version 1.0.0 loaded
[    6.274211] device-mapper: multipath queue-length: version 0.1.0 loaded
[    6.274991] device-mapper: multipath service-time: version 0.2.0 loaded
[    6.275818] device-mapper: cache-policy-mq: version 1.1.0 loaded
[    6.276503] device-mapper: cache cleaner: version 1.0.0 loaded
[    6.277211] Bluetooth: HCI UART driver ver 2.2
[    6.277728] Bluetooth: HCI BCSP protocol initialized
[    6.278303] Bluetooth: HCILL protocol initialized
[    6.278844] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[    6.279715] lguest: switcher text too large (4384)
[    6.280654] sdhci: Secure Digital Host Controller Interface driver
[    6.281381] sdhci: Copyright(c) Pierre Ossman
[    6.281889] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    6.282556] wbsd: Copyright(c) Pierre Ossman
[    6.293656] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    6.298731]  fake-fmc-carrier: mezzanine 0
[    6.299239]       Manufacturer: fake-vendor
[    6.299722]       Product name: fake-design-for-testing
[    6.300416] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    6.314441] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[    6.315508] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    6.316564] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    6.317676] oprofile: using timer interrupt.
[    6.318242] drop_monitor: Initializing network drop monitor service
[    6.319156] NET: Registered protocol family 26
[    6.319718] Netfilter messages via NETLINK v0.30.
[    6.320470] nf_conntrack version 0.5.0 (4451 buckets, 17804 max)
[    6.321378] ctnetlink v0.93: registering with nfnetlink.
[    6.322122] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    6.322872] IPVS: Registered protocols (UDP)
[    6.323392] IPVS: Connection hash table configured (size=3D4096, memory=
=3D32Kbytes)
[    6.324496] IPVS: Creating netns size=3D1344 id=3D0
[    6.334176] IPVS: ipvs loaded.
[    6.334553] IPVS: [rr] scheduler registered.
[    6.335105] IPVS: [lblcr] scheduler registered.
[    6.335613] IPVS: [dh] scheduler registered.
[    6.336138] IPVS: [sh] scheduler registered.
[    6.336623] IPVS: [sed] scheduler registered.
[    6.337220] ipip: IPv4 over IPv4 tunneling driver
[    6.338442] gre: GRE over IPv4 demultiplexor driver
[    6.339048] ip_gre: GRE over IPv4 tunneling driver
[    6.340796] TCP: highspeed registered
[    6.341251] TCP: hybla registered
[    6.341642] TCP: htcp registered
[    6.342049] TCP: vegas registered
[    6.342422] TCP: scalable registered
[    6.351910] TCP: lp registered
[    6.352289] TCP: illinois registered
[    6.352716] Initializing XFRM netlink socket
[    6.353301] NET: Registered protocol family 15
[    6.353886] Bridge firewalling registered
[    6.354396] NET: Registered protocol family 4
[    6.355140] NET: Registered protocol family 9
[    6.355638] X.25 for Linux Version 0.2
[    6.356299] Bluetooth: RFCOMM socket layer initialized
[    6.356921] Bluetooth: RFCOMM ver 1.11
[    6.357385] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    6.358109] Bluetooth: HIDP socket layer initialized
[    6.358937] NET: Registered protocol family 33
[    6.359464] Key type rxrpc registered
[    6.359897] Key type rxrpc_s registered
[    6.360524] Bluetooth: Bind failed -22
[    6.374460] cryptomgr_probe (114) used greatest stack depth: 6912 bytes =
left
[    6.375356] RxRPC: Registered security type 2 'rxkad'
[    6.376109] lec:lane_module_init: lec.c: initialized
[    6.376745] mpoa:atm_mpoa_init: mpc.c: initialized
[    6.377360] l2tp_core: L2TP core driver, V2.0
[    6.377867] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    6.378997] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    6.379779] NET: Registered protocol family 12
[    6.380379] NET: Registered protocol family 35
[    6.381995] DCCP: Activated CCID 2 (TCP-like)
[    6.382552] tipc: Activated (version 2.0.0)
[    6.383279] NET: Registered protocol family 30
[    6.384261] tipc: Started in single node mode
[    6.384786] 9pnet: Installing 9P2000 support
[    6.385358] NET: Registered protocol family 37
[    6.385915] Key type dns_resolver registered
[    6.386441] Key type ceph registered
[    6.400073] libceph: loaded (mon/osd proto 15/24)
[    6.401213] batman_adv: B.A.T.M.A.N. advanced 2013.5.0 (compatibility ve=
rsion 15) loaded
[    6.403470] registered taskstats version 1
[    6.404130] kAFS: Red Hat AFS client v0.1 registering.
[    6.405838] cryptomgr_probe (120) used greatest stack depth: 6852 bytes =
left
[    6.406690] Key type encrypted registered
[    6.408357] rtc-test rtc-test.0: setting system clock to 2014-08-22 00:3=
7:30 UTC (1408667850)
[    6.409480] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.410197] EDD information not available.
[    6.423622] Freeing unused kernel memory: 836K (42e40000 - 42f11000)
[    6.439203] mount (128) used greatest stack depth: 6716 bytes left
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: No such file or directory
[    6.477433] S00fbsetup (130) used greatest stack depth: 6604 bytes left

Please wait: booting...
Starting udev
mount: mounting none on /dev failed: Invalid argument
[    6.626516] udevd (145) used greatest stack depth: 6488 bytes left
[    6.631393] udev[146]: starting version 164
[    6.783508] power_supply test_ac: uevent
[    6.784000] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    6.784654] power_supply test_ac: prop ONLINE=3D1
[    6.785370] power_supply test_battery: uevent
[    6.785891] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    6.786631] power_supply test_battery: prop STATUS=3DDischarging
[    6.787332] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    6.787991] power_supply test_battery: prop HEALTH=3DGood
[    6.788597] power_supply test_battery: prop PRESENT=3D1
[    6.789224] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    6.790160] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    6.790877] power_supply test_battery: prop CHARGE_FULL=3D100
[    6.791527] power_supply test_battery: prop CHARGE_NOW=3D50
[    6.792817] power_supply test_battery: prop CAPACITY=3D50
[    6.793434] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    6.794169] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    6.794886] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    6.795588] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    6.796345] power_supply test_battery: prop MANUFACTURER=3DLinux
[    6.797060] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-02795=
-g2c57502
[    6.797899] power_supply test_battery: prop TEMP=3D26
[    6.798475] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    6.948893] power_supply test_usb: uevent
[    6.949723] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    6.950453] power_supply test_usb: prop ONLINE=3D1
[    7.043016] power_supply test_ac: uevent
[    7.043515] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    7.044202] power_supply test_ac: prop ONLINE=3D1
[    7.044951] power_supply test_battery: uevent
[    7.045482] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    7.059307] power_supply test_battery: prop STATUS=3DDischarging
[    7.059994] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    7.060651] power_supply test_battery: prop HEALTH=3DGood
[    7.061286] power_supply test_battery: prop PRESENT=3D1
[    7.061880] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    7.062549] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    7.063290] power_supply test_battery: prop CHARGE_FULL=3D100
[    7.063941] power_supply test_battery: prop CHARGE_NOW=3D50
[    7.064568] power_supply test_battery: prop CAPACITY=3D50
[    7.065238] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    7.065945] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    7.066663] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    7.067384] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    7.068146] power_supply test_battery: prop MANUFACTURER=3DLinux
[    7.068821] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-02795=
-g2c57502
[    7.069650] power_supply test_battery: prop TEMP=3D26
[    7.070247] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    7.082226] power_supply test_ac: uevent
[    7.082711] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    7.083374] power_supply test_ac: prop ONLINE=3D1
[    7.158405] power_supply test_battery: uevent
[    7.158954] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    7.159713] power_supply test_battery: prop STATUS=3DDischarging
[    7.160400] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    7.161097] power_supply test_battery: prop HEALTH=3DGood
[    7.161705] power_supply test_battery: prop PRESENT=3D1
[    7.162311] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    7.162984] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    7.163713] power_supply test_battery: prop CHARGE_FULL=3D100
[    7.164375] power_supply test_battery: prop CHARGE_NOW=3D50
[    7.165047] power_supply test_battery: prop CAPACITY=3D50
[    7.165649] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    7.166480] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    7.167258] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    7.181049] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    7.181781] power_supply test_battery: prop MANUFACTURER=3DLinux
[    7.182456] power_supply test_battery: prop SERIAL_NUMBER=3D3.12.0-02795=
-g2c57502
[    7.183324] power_supply test_battery: prop TEMP=3D26
[    7.183945] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    7.186186] power_supply test_usb: uevent
[    7.186668] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    7.187355] power_supply test_usb: prop ONLINE=3D1
[    7.202245] power_supply test_usb: uevent
[    7.202776] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    7.203512] power_supply test_usb: prop ONLINE=3D1
[    7.266963] scsi_id (235) used greatest stack depth: 6008 bytes left
[    7.403676] ------------[ cut here ]------------
[    7.404033] WARNING: CPU: 0 PID: 264 at kernel/softirq.c:156 local_bh_en=
able+0x9c/0x1e0()
[    7.404033] CPU: 0 PID: 264 Comm: mount Tainted: G        W    3.12.0-02=
795-g2c57502 #16
[    7.404033]  00000001 511d1a58 420d4200 511d1a88 4109f3dd 426e5c40 00000=
000 00000108
[    7.404033]  426e5fb0 0000009c 410a68dc 410a68dc 00000001 4183189d 00000=
001 511d1a98
[    7.404033]  4109f4c2 00000009 00000000 511d1aac 410a68dc 51c9f008 51c9f=
23c 511d1ad8
[    7.404033] Call Trace:
[    7.404033]  [<420d4200>] dump_stack+0x16/0x18
[    7.404033]  [<4109f3dd>] warn_slowpath_common+0x8d/0xb0
[    7.404033]  [<410a68dc>] ? local_bh_enable+0x9c/0x1e0
[    7.404033]  [<410a68dc>] ? local_bh_enable+0x9c/0x1e0
[    7.404033]  [<4183189d>] ? cfqg_stats_update_avg_queue_size+0x2d/0x100
[    7.404033]  [<4109f4c2>] warn_slowpath_null+0x22/0x30
[    7.404033]  [<410a68dc>] local_bh_enable+0x9c/0x1e0
[    7.404033]  [<4183189d>] cfqg_stats_update_avg_queue_size+0x2d/0x100
[    7.404033]  [<41833f4a>] __cfq_set_active_queue+0x15a/0x210
[    7.404033]  [<418300d9>] ? cfq_group_service_tree_add+0x199/0x260
[    7.404033]  [<41831f84>] ? cfq_service_tree_add+0x404/0x4f0
[    7.404033]  [<418320a9>] ? cfq_resort_rr_list+0x39/0x40
[    7.404033]  [<41832fff>] ? cfq_add_cfqq_rr+0x16f/0x1c0
[    7.404033]  [<4183a014>] ? cfq_update_idle_window.isra.78+0x84/0x3a0
[    7.404033]  [<41836b4c>] cfq_select_queue+0x7ec/0xa90
[    7.404033]  [<4183988f>] cfq_dispatch_requests+0x2bf/0x9c0
[    7.404033]  [<410833ec>] ? pvclock_clocksource_read+0xfc/0x240
[    7.404033]  [<410822f3>] ? kvm_clock_read+0x13/0x20
[    7.404033]  [<4183a702>] ? cfq_insert_request+0x3d2/0x8b0
[    7.404033]  [<410e0fc3>] ? sched_clock_local.constprop.2+0x43/0x190
[    7.404033]  [<410f5bd3>] ? __lock_acquire+0x1113/0x11a0
[    7.404033]  [<410f2fcb>] ? trace_hardirqs_off+0xb/0x10
[    7.404033]  [<4180f572>] blk_peek_request+0x302/0x450
[    7.404033]  [<4183fa06>] ? kobject_get+0xd6/0x100
[    7.404033]  [<419f1e08>] scsi_request_fn+0x68/0x8d0
[    7.404033]  [<4180b322>] __blk_run_queue_uncond+0x42/0x50
[    7.404033]  [<4180b370>] __blk_run_queue+0x40/0x50
[    7.404033]  [<418104ed>] blk_queue_bio+0x3dd/0x4e0
[    7.404033]  [<4180d1b2>] generic_make_request+0x102/0x180
[    7.404033]  [<4180d3a7>] submit_bio+0x177/0x250
[    7.404033]  [<412459da>] ? __find_get_block+0x2da/0x390
[    7.404033]  [<4124b46d>] ? bio_alloc_bioset+0xfd/0x340
[    7.404033]  [<4124673c>] _submit_bh+0x2dc/0x320
[    7.404033]  [<4124a595>] __bread+0x85/0x1f0
[    7.404033]  [<41301fb9>] ext3_fill_super+0x1a9/0x1d10
[    7.404033]  [<4184c428>] ? snprintf+0x18/0x20
[    7.404033]  [<41301e10>] ? ext3_setup_super+0x340/0x340
[    7.404033]  [<4120090d>] mount_bdev+0x1ed/0x2c0
[    7.404033]  [<41301e10>] ? ext3_setup_super+0x340/0x340
[    7.404033]  [<411debb0>] ? __kmalloc_track_caller+0xd0/0x2a0
[    7.404033]  [<412fc2bf>] ext3_mount+0x1f/0x30
[    7.404033]  [<41301e10>] ? ext3_setup_super+0x340/0x340
[    7.404033]  [<41200d27>] mount_fs+0x47/0x1f0
[    7.404033]  [<4122a0a5>] ? alloc_vfsmnt+0x175/0x1c0
[    7.404033]  [<4122b633>] vfs_kern_mount+0xa3/0x1a0
[    7.404033]  [<420e8122>] ? _raw_read_unlock+0x22/0x30
[    7.404033]  [<4122e786>] do_mount+0xdb6/0x11c0
[    7.404033]  [<4122d9ac>] ? copy_mount_string+0x5c/0x80
[    7.404033]  [<4122f003>] SyS_mount+0xf3/0x120
[    7.404033]  [<420e8e8c>] syscall_call+0x7/0xb
[    7.404033] ---[ end trace 05e0c07eb1c663a9 ]---
[    7.404033]=20
[    7.404033] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    7.404033] [ INFO: inconsistent lock state ]
[    7.404033] 3.12.0-02795-g2c57502 #16 Tainted: G        W  =20
[    7.404033] ---------------------------------
[    7.404033] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[    7.404033] mount/264 [HC0[0]:SC0[0]:HE1:SE1] takes:
[    7.404033]  (&(&q->__queue_lock)->rlock){+.?...}, at: [<418104cb>] blk_=
queue_bio+0x3bb/0x4e0
[    7.404033] {IN-SOFTIRQ-W} state was registered at:
[    7.404033]   [<410f501b>] __lock_acquire+0x55b/0x11a0
[    7.404033]   [<410f63f3>] lock_acquire+0xd3/0x110
[    7.404033]   [<420e7b01>] _raw_spin_lock+0x41/0x90
[    7.404033]   [<419f2fa6>] scsi_device_unbusy+0x76/0xf0
[    7.404033]   [<419ea282>] scsi_finish_command+0x22/0x120
[    7.404033]   [<419f320f>] scsi_softirq_done+0xef/0x170
[    7.404033]   [<4181826b>] blk_done_softirq+0x7b/0x90
[    7.404033]   [<410a6214>] __do_softirq+0x134/0x450
[    7.404033]   [<410a656c>] run_ksoftirqd+0x3c/0x80
[    7.404033]   [<410d89fc>] smpboot_thread_fn+0x1dc/0x250
[    7.404033]   [<410cdec9>] kthread+0xf9/0x100
[    7.404033]   [<420e949b>] ret_from_kernel_thread+0x1b/0x30
[    7.404033] irq event stamp: 2012
[    7.404033] hardirqs last  enabled at (2009): [<420e7dd7>] _raw_spin_unl=
ock_irq+0x27/0x40
[    7.404033] hardirqs last disabled at (2010): [<420e7c0a>] _raw_spin_loc=
k_irq+0x1a/0x90
[    7.404033] softirqs last  enabled at (2012): [<4183189d>] cfqg_stats_up=
date_avg_queue_size+0x2d/0x100
[    7.404033] softirqs last disabled at (2011): [<41831888>] cfqg_stats_up=
date_avg_queue_size+0x18/0x100
[    7.404033]=20
[    7.404033] other info that might help us debug this:
[    7.404033]  Possible unsafe locking scenario:
[    7.404033]=20
[    7.404033]        CPU0
[    7.404033]        ----
[    7.404033]   lock(&(&q->__queue_lock)->rlock);
[    7.404033]   <Interrupt>
[    7.404033]     lock(&(&q->__queue_lock)->rlock);
[    7.404033]=20
[    7.404033]  *** DEADLOCK ***
[    7.404033]=20
[    7.404033] 2 locks held by mount/264:
[    7.404033]  #0:  (&type->s_umount_key#19/1){+.+.+.}, at: [<411ff563>] s=
get+0x2f3/0x530
[    7.404033]  #1:  (&(&q->__queue_lock)->rlock){+.?...}, at: [<418104cb>]=
 blk_queue_bio+0x3bb/0x4e0
[    7.404033]=20
[    7.404033] stack backtrace:
[    7.404033] CPU: 0 PID: 264 Comm: mount Tainted: G        W    3.12.0-02=
795-g2c57502 #16
[    7.404033]  43159a40 511d19d4 420d4200 511d1a10 420b10dc 426e18ee 426e1=
c9c 00000108
[    7.404033]  00000000 00000000 00000000 00000000 00000001 00000001 426e1=
c9c 00000006
[    7.404033]  51208484 410f16f0 511d1a40 410f26bd 00000006 00000001 00000=
09c 511d1a44
[    7.404033] Call Trace:
[    7.404033]  [<420d4200>] dump_stack+0x16/0x18
[    7.404033]  [<420b10dc>] print_usage_bug+0x1d1/0x1db
[    7.404033]  [<410f16f0>] ? check_usage_forwards+0xe0/0xe0
[    7.404033]  [<410f26bd>] mark_lock+0x18d/0x2e0
[    7.404033]  [<410f2911>] mark_held_locks+0x101/0x110
[    7.404033]  [<4109f33f>] ? print_oops_end_marker+0x2f/0x40
[    7.404033]  [<4109f3ec>] ? warn_slowpath_common+0x9c/0xb0
[    7.404033]  [<410a693b>] ? local_bh_enable+0xfb/0x1e0
[    7.404033]  [<410f2c8c>] trace_hardirqs_on_caller+0x17c/0x220
[    7.404033]  [<4183189d>] ? cfqg_stats_update_avg_queue_size+0x2d/0x100
[    7.404033]  [<410f2d3b>] trace_hardirqs_on+0xb/0x10
[    7.404033]  [<410a693b>] local_bh_enable+0xfb/0x1e0
[    7.404033]  [<4183189d>] cfqg_stats_update_avg_queue_size+0x2d/0x100
[    7.404033]  [<41833f4a>] __cfq_set_active_queue+0x15a/0x210
[    7.404033]  [<418300d9>] ? cfq_group_service_tree_add+0x199/0x260
[    7.404033]  [<41831f84>] ? cfq_service_tree_add+0x404/0x4f0
[    7.404033]  [<418320a9>] ? cfq_resort_rr_list+0x39/0x40
[    7.404033]  [<41832fff>] ? cfq_add_cfqq_rr+0x16f/0x1c0
[    7.404033]  [<4183a014>] ? cfq_update_idle_window.isra.78+0x84/0x3a0
[    7.404033]  [<41836b4c>] cfq_select_queue+0x7ec/0xa90
[    7.404033]  [<4183988f>] cfq_dispatch_requests+0x2bf/0x9c0
[    7.404033]  [<410833ec>] ? pvclock_clocksource_read+0xfc/0x240
[    7.404033]  [<410822f3>] ? kvm_clock_read+0x13/0x20
[    7.404033]  [<4183a702>] ? cfq_insert_request+0x3d2/0x8b0
[    7.404033]  [<410e0fc3>] ? sched_clock_local.constprop.2+0x43/0x190
[    7.404033]  [<410f5bd3>] ? __lock_acquire+0x1113/0x11a0
[    7.404033]  [<410f2fcb>] ? trace_hardirqs_off+0xb/0x10
[    7.404033]  [<4180f572>] blk_peek_request+0x302/0x450
[    7.404033]  [<4183fa06>] ? kobject_get+0xd6/0x100
[    7.404033]  [<419f1e08>] scsi_request_fn+0x68/0x8d0
[    7.404033]  [<4180b322>] __blk_run_queue_uncond+0x42/0x50
[    7.404033]  [<4180b370>] __blk_run_queue+0x40/0x50
[    7.404033]  [<418104ed>] blk_queue_bio+0x3dd/0x4e0
[    7.404033]  [<4180d1b2>] generic_make_request+0x102/0x180
[    7.404033]  [<4180d3a7>] submit_bio+0x177/0x250
[    7.404033]  [<412459da>] ? __find_get_block+0x2da/0x390
[    7.404033]  [<4124b46d>] ? bio_alloc_bioset+0xfd/0x340
[    7.404033]  [<4124673c>] _submit_bh+0x2dc/0x320
[    7.404033]  [<4124a595>] __bread+0x85/0x1f0
[    7.404033]  [<41301fb9>] ext3_fill_super+0x1a9/0x1d10
[    7.404033]  [<4184c428>] ? snprintf+0x18/0x20
[    7.404033]  [<41301e10>] ? ext3_setup_super+0x340/0x340
[    7.404033]  [<4120090d>] mount_bdev+0x1ed/0x2c0
[    7.404033]  [<41301e10>] ? ext3_setup_super+0x340/0x340
[    7.404033]  [<411debb0>] ? __kmalloc_track_caller+0xd0/0x2a0
[    7.404033]  [<412fc2bf>] ext3_mount+0x1f/0x30
[    7.404033]  [<41301e10>] ? ext3_setup_super+0x340/0x340
[    7.404033]  [<41200d27>] mount_fs+0x47/0x1f0
[    7.404033]  [<4122a0a5>] ? alloc_vfsmnt+0x175/0x1c0
[    7.404033]  [<4122b633>] vfs_kern_mount+0xa3/0x1a0
[    7.404033]  [<420e8122>] ? _raw_read_unlock+0x22/0x30
[    7.404033]  [<4122e786>] do_mount+0xdb6/0x11c0
[    7.404033]  [<4122d9ac>] ? copy_mount_string+0x5c/0x80
[    7.404033]  [<4122f003>] SyS_mount+0xf3/0x120
[    7.404033]  [<420e8e8c>] syscall_call+0x7/0xb
[    7.789066] qnx6: unable to read the first superblock
[    7.791067] UDF-fs: warning (device sda): udf_fill_super: No partition f=
ound (2)
[    7.795064] NILFS: Can't find nilfs on dev sda.
[    7.795738] BeFS(sda): No write support. Marking filesystem read-only
[    7.797064] BeFS(sda): invalid magic header
[    7.802065] (mount,264,0):ocfs2_fill_super:1038 ERROR: superblock probe =
failed!
[    7.816075] (mount,264,0):ocfs2_fill_super:1229 ERROR: status =3D -22
[    7.819066] F2FS-fs (sda): Magic Mismatch, valid(0xf2f52010) - read(0x0)
[    7.819943] F2FS-fs (sda): Can't find a valid F2FS filesystem in 1th sup=
erblock
[    7.821064] F2FS-fs (sda): Magic Mismatch, valid(0xf2f52010) - read(0x0)
[    7.821943] F2FS-fs (sda): Can't find a valid F2FS filesystem in 2th sup=
erblock
[    7.823139] mount (264) used greatest stack depth: 5532 bytes left
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
[    8.107046] random: nonblocking pool is initialized
/etc/rcS.d/S37populate-volatile.sh: line 57: /dev/tty0: No such device or a=
ddress
Configuring network interfaces... done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
sed: /lib/modules/3.12.0-02795-g2c57502/modules.dep: No such file or direct=
ory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Done parsing arguments.
## couldn't open logfile trinity.log
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
## couldn't open logfile trinity.log
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
Marking all syscalls as enabled.
[init] Disabling syscalls marked as disabled by command line options
[init] Marked syscall get_robust_list (312) as deactivated.
[init] Enabled 350 syscalls. Disabled 1 syscalls.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
Done parsing arguments.
Marking all syscalls as enabled.
[init] Enabled 351 syscalls. Disabled 0 syscalls.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
[init] Kernel was tainted on startup. Will ignore flags that are already se=
t.
[init] Using pid_max =3D 32768
[init] Kernel was tainted on startup. Will ignore flags that are already se=
t.
[init] Started watchdog process, PID is 466
[init] Started watchdog process, PID is 467
[main] Main thread is alive.
[main] Couldn't find socket cachefile. Regenerating.
[main] Setsockopt(1 7 80d3000 4) on fd 6 [1:1:1]
[main] Setsockopt(0 c 80d3000 1) on fd 7 [2:3:151]
[main] Setsockopt(1 2c 80d3000 de) on fd 9 [8:2:214]
[main] Setsockopt(1 1d 80d3000 85) on fd 10 [9:5:0]
[main] Setsockopt(1 1 80d3000 4) on fd 11 [12:1:254]
[main] Setsockopt(1 21 80d3000 4) on fd 12 [16:3:0]
[main] Setsockopt(1 c 80d3000 4) on fd 13 [26:1:165]
[main] Main thread is alive.
[main] Setsockopt(1 2d 80d3000 4) on fd 14 [30:1:0]
[main] Setsockopt(1 20 80d3000 4) on fd 16 [37:5:2]
[main] Setsockopt(1 5 80d3000 4) on fd 19 [2:3:112]
[main] Setsockopt(1 21 80d3000 61) on fd 22 [9:5:0]
[main] Setsockopt(1 2f 80d3000 c6) on fd 23 [12:5:2]
[main] Setsockopt(1 b 80d3000 4) on fd 24 [20:4:43]
[main] Setsockopt(1 2f 80d3000 4) on fd 25 [26:1:223]
[main] Setsockopt(1 20 80d3000 e) on fd 26 [30:5:0]
[main] Setsockopt(1 d 80d3000 8) on fd 27 [35:5:0]
[main] Setsockopt(116 7f 80d3000 4) on fd 28 [37:1:1]
[   18.890764] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
[main] Setsockopt(1 e 80d3000 c) on fd 29 [39:5:0]
[main] Setsockopt(1 1d 80d3000 8) on fd 30 [1:2:1]
[main] Setsockopt(1 2d 80d3000 4) on fd 34 [9:5:0]
[main] Setsockopt(1 2d 80d3000 4) on fd 35 [12:5:2]
[main] Setsockopt(117 42020054 80d3000 4) on fd 36 [20:2:151]
[main] Setsockopt(1 2f 80d3000 4) on fd 37 [26:1:146]
[main] Setsockopt(1 20 80d3000 4) on fd 39 [35:2:0]
[main] Setsockopt(1 2f 80d3000 34) on fd 40 [37:5:5]
[main] Setsockopt(1 6 80d3000 4) on fd 42 [1:2:1]
[main] Setsockopt(1 23 80d3000 4b) on fd 44 [4:2:180]
[main] Setsockopt(1 2d 80d3000 4) on fd 45 [9:5:0]
[main] Setsockopt(10a b 80d3000 4) on fd 46 [12:5:2]
[main] Setsockopt(1 24 80d3000 4) on fd 48 [30:2:0]
[main] Setsockopt(1 d 80d3000 8) on fd 51 [39:1:1]
[main] Setsockopt(1 10 80d3000 4) on fd 52 [1:1:1]
[main] Setsockopt(11 1 80d3000 24) on fd 53 [2:2:0]
[main] Setsockopt(108 42000004 80d3000 4) on fd 55 [8:2:237]
[main] Setsockopt(1 1d 80d3000 5b) on fd 56 [9:5:0]
[main] Setsockopt(1 9 80d3000 4) on fd 57 [12:5:2]
[main] Setsockopt(10e 5 80d3000 de) on fd 58 [16:2:4]
[main] Setsockopt(1 20 80d3000 72) on fd 59 [26:1:97]
[main] Setsockopt(1 8 80d3000 71) on fd 61 [35:5:0]
[main] Setsockopt(1 f 80d3000 4) on fd 62 [37:1:0]
[main] Setsockopt(1 b 80d3000 a6) on fd 63 [39:2:1]
[main] Setsockopt(0 14 80d3000 1) on fd 65 [2:1:0]
[main] Setsockopt(100 1 80d3000 4) on fd 66 [4:2:70]
[main] Setsockopt(1 f 80d3000 4) on fd 67 [8:2:113]
[main] Setsockopt(108 42000004 80d3000 4) on fd 70 [20:2:186]
[main] Setsockopt(1 9 80d3000 e3) on fd 73 [35:5:0]
[main] Setsockopt(1 8 80d3000 fb) on fd 74 [37:1:4]
[main] Setsockopt(1 2a 80d3000 d3) on fd 76 [1:1:1]
[main] Setsockopt(0 16 80d3000 1) on fd 77 [2:3:47]
[main] Setsockopt(1 b 80d3000 4) on fd 79 [8:2:60]
[main] Setsockopt(1 12 80d3000 69) on fd 80 [9:5:0]
[main] Setsockopt(6 d 80d3000 4) on fd 81 [12:5:2]
[main] Setsockopt(1 1d 80d3000 e4) on fd 82 [16:2:6]
[main] Setsockopt(1 10 80d3000 4) on fd 83 [20:10:18]
[main] Setsockopt(1 c 80d3000 4) on fd 84 [26:2:216]
[main] Setsockopt(6 1 0 4) on fd 85 [30:1:0]
[main] Setsockopt(116 7f 80d3000 f6) on fd 87 [37:1:1]
[main] Setsockopt(1 2b 80d3000 4) on fd 89 [1:5:1]
[main] Setsockopt(0 1 80d3000 4) on fd 90 [2:1:0]
[main] Setsockopt(1 12 80d3000 4) on fd 91 [4:2:188]
[main] Setsockopt(1 28 80d3000 4) on fd 93 [12:1:224]
[main] Setsockopt(1 2e 80d3000 c2) on fd 94 [16:3:0]
[main] Setsockopt(1 2d 80d3000 4) on fd 96 [26:1:108]
[main] Setsockopt(1 22 80d3000 4) on fd 97 [30:5:0]
[main] Setsockopt(1 2 80d3000 12) on fd 98 [35:2:0]
[main] Setsockopt(1 29 80d3000 4) on fd 99 [37:1:3]
[main] Setsockopt(1 f 80d3000 4) on fd 100 [39:5:0]
[main] Setsockopt(1 d 80d3000 8) on fd 102 [2:1:0]
[main] Setsockopt(1 2 80d3000 75) on fd 103 [4:2:134]
[main] Setsockopt(107 c 80d3000 4) on fd 106 [12:1:88]
[main] Setsockopt(10e 3 80d3000 51) on fd 107 [16:3:12]
[main] Setsockopt(1 7 80d3000 4) on fd 108 [20:5:130]
[main] Setsockopt(1 28 80d3000 4) on fd 109 [26:2:210]
[main] Setsockopt(1 a 80d3000 4) on fd 110 [30:1:0]
[main] Setsockopt(1 2f 80d3000 99) on fd 113 [39:2:1]
[main] Setsockopt(100 1 80d3000 4) on fd 116 [4:2:143]
[main] Setsockopt(1 6 80d3000 4) on fd 117 [8:4:22]
[main] Setsockopt(1 7 80d3000 78) on fd 118 [9:5:0]
[main] Setsockopt(117 c 80d3000 4) on fd 119 [12:1:30]
[main] Setsockopt(1 b 80d3000 5b) on fd 120 [20:5:180]
[main] Setsockopt(1 2b 80d3000 7f) on fd 121 [26:2:50]
[main] Setsockopt(1 10 80d3000 4) on fd 122 [30:1:0]
[main] Setsockopt(1 5 80d3000 ce) on fd 123 [35:2:0]
[main] Setsockopt(116 7f 80d3000 4) on fd 124 [37:1:0]
[main] Setsockopt(11 1 80d3000 4) on fd 127 [2:2:17]
[main] Setsockopt(100 1 80d3000 4) on fd 128 [4:2:83]
[main] Setsockopt(101 c 80d3000 4) on fd 131 [12:5:2]
[main] Setsockopt(10e 4 80d3000 4) on fd 132 [16:3:14]
[main] Setsockopt(1 24 80d3000 d0) on fd 134 [26:1:235]
[main] Setsockopt(1 9 80d3000 4) on fd 135 [30:1:0]
[main] Setsockopt(1 5 80d3000 ae) on fd 136 [35:2:0]
[main] Setsockopt(1 f 80d3000 bd) on fd 137 [37:1:0]
[main] Setsockopt(1 20 80d3000 4) on fd 138 [39:2:1]
[main] Setsockopt(1 8 80d3000 97) on fd 139 [1:1:1]
[main] Setsockopt(0 14 80d3000 4) on fd 140 [2:2:0]
[main] Setsockopt(100 1 80d3000 4) on fd 141 [4:2:129]
[main] Setsockopt(1 2c 80d3000 50) on fd 143 [9:5:0]
[main] Setsockopt(1 f 80d3000 60) on fd 144 [12:1:55]
[main] Setsockopt(1 1d 80d3000 4) on fd 145 [16:2:2]
[main] Setsockopt(1 2d 80d3000 9d) on fd 146 [20:2:56]
[main] Setsockopt(1 29 80d3000 4) on fd 147 [26:2:138]
[main] Setsockopt(6 200006 80d3000 4) on fd 148 [30:1:0]
[main] Setsockopt(1 10 80d3000 4) on fd 149 [35:5:0]
[main] Setsockopt(1 b 80d3000 aa) on fd 150 [37:1:0]
[main] Setsockopt(1 20 80d3000 4) on fd 153 [2:3:24]
[main] Setsockopt(100 1 80d3000 4) on fd 154 [4:2:179]
[main] Setsockopt(1 c 80d3000 4) on fd 156 [9:5:0]
[main] Setsockopt(6 c 80d3000 4) on fd 157 [12:5:2]
[main] Setsockopt(6 1 0 4) on fd 160 [30:1:0]
[main] Setsockopt(1 2e 80d3000 9a) on fd 161 [35:5:0]
[main] Setsockopt(1 29 80d3000 e5) on fd 162 [37:5:1]
[main] Setsockopt(1 21 80d3000 4) on fd 163 [39:1:1]
[main] Setsockopt(1 10 80d3000 a) on fd 165 [2:1:0]
[main] Setsockopt(100 1 80d3000 4) on fd 166 [4:2:16]
[main] Setsockopt(1 23 80d3000 4) on fd 168 [9:5:0]
[main] Setsockopt(10d b 80d3000 4) on fd 169 [12:5:2]
[main] Setsockopt(1 b 80d3000 4) on fd 170 [16:3:2]
[main] Setsockopt(1 1 80d3000 4) on fd 171 [20:2:155]
[main] Setsockopt(1 2e 80d3000 4) on fd 172 [26:1:110]
[main] Setsockopt(113 3 0 1) on fd 174 [35:5:0]
[main] Setsockopt(1 e 80d3000 4) on fd 175 [37:5:5]
[main] Setsockopt(0 3 80d3000 4) on fd 178 [2:3:139]
[main] Setsockopt(1 b 80d3000 a2) on fd 179 [4:2:18]
[main] Setsockopt(1 28 80d3000 34) on fd 182 [12:5:2]
[main] Setsockopt(1 2d 80d3000 15) on fd 183 [16:3:9]
[main] Setsockopt(1 2b 80d3000 4) on fd 184 [20:4:156]
[main] Setsockopt(1 2d 80d3000 58) on fd 185 [26:1:243]
[main] Setsockopt(1 d 80d3000 8) on fd 188 [37:5:2]
[main] Setsockopt(1 29 80d3000 4) on fd 192 [4:2:207]
[main] Setsockopt(10d c 80d3000 4) on fd 195 [12:5:2]
[main] Setsockopt(1 2f 80d3000 4) on fd 196 [16:2:18]
[main] Setsockopt(1 24 80d3000 34) on fd 197 [20:2:66]
[main] Setsockopt(1 28 80d3000 4) on fd 199 [30:2:0]
[main] Setsockopt(1 c 80d3000 17) on fd 201 [37:5:3]
[main] Setsockopt(1 2c 80d3000 4) on fd 202 [39:5:0]
[main] Setsockopt(1 2f 80d3000 4) on fd 203 [1:1:1]
[main] Setsockopt(0 1 80d3000 38) on fd 204 [2:3:17]
[main] Setsockopt(1 e 80d3000 83) on fd 208 [12:1:196]
[main] Setsockopt(10e 5 80d3000 4) on fd 209 [16:3:8]
[main] Setsockopt(1 d 80d3000 8) on fd 210 [20:4:174]
[main] Setsockopt(1 e 80d3000 4) on fd 211 [26:2:10]
[main] Setsockopt(1 9 80d3000 4) on fd 212 [30:2:0]
[main] Setsockopt(1 29 80d3000 db) on fd 214 [37:1:4]
[main] Setsockopt(6 1 80d3000 4) on fd 217 [2:1:0]
[main] Setsockopt(1 2b 80d3000 4) on fd 218 [4:2:62]
[main] Setsockopt(1 10 80d3000 e5) on fd 219 [9:5:0]
[main] Setsockopt(6 c 80d3000 4) on fd 220 [12:5:2]
[main] Setsockopt(10e 5 80d3000 88) on fd 221 [16:2:14]
[main] Setsockopt(1 e 80d3000 99) on fd 222 [20:10:186]
[main] Setsockopt(6 1 0 5) on fd 224 [30:1:0]
[main] Setsockopt(1 23 80d3000 7a) on fd 226 [37:5:1]
[main] Setsockopt(1 7 80d3000 57) on fd 229 [2:2:17]
[main] Setsockopt(1 20 80d3000 4) on fd 230 [4:2:92]
[main] Setsockopt(1 c 80d3000 4) on fd 231 [8:4:239]
[main] Setsockopt(1 1 80d3000 4) on fd 232 [9:5:0]
[main] Setsockopt(1 2b 80d3000 4) on fd 233 [12:1:32]
[main] Setsockopt(1 1 80d3000 55) on fd 234 [20:5:9]
[main] Setsockopt(1 5 80d3000 dd) on fd 237 [35:5:0]
[main] Setsockopt(1 5 80d3000 e2) on fd 242 [4:2:148]
[main] Setsockopt(1 a 80d3000 4) on fd 243 [8:3:11]
[main] Setsockopt(1 21 80d3000 95) on fd 244 [9:5:0]
[main] Setsockopt(10e 5 80d3000 c9) on fd 246 [16:3:14]
[main] Setsockopt(1 1 80d3000 e8) on fd 250 [35:2:0]
[main] Setsockopt(116 7f 80d3000 3c) on fd 251 [37:5:3]
[main] Setsockopt(1 23 80d3000 4) on fd 252 [39:1:1]
[main] Setsockopt(1 e 80d3000 90) on fd 254 [2:2:0]
[main] Setsockopt(100 1 80d3000 4) on fd 255 [4:2:20]
[main] Setsockopt(1 24 80d3000 4) on fd 256 [8:10:61]
[main] Setsockopt(105 c 80d3000 4) on fd 258 [12:1:251]
[main] Setsockopt(1 21 80d3000 4) on fd 259 [20:5:97]
[main] Setsockopt(1 29 80d3000 4) on fd 260 [26:1:248]
[main] Setsockopt(1 1 80d3000 4) on fd 262 [35:5:0]
[main] Setsockopt(1 e 80d3000 4) on fd 264 [39:1:1]
[main] Setsockopt(0 21 80d3000 1) on fd 266 [2:2:17]
[main] Setsockopt(100 1 80d3000 4) on fd 267 [4:2:112]
[main] Setsockopt(1 a 80d3000 ff) on fd 268 [8:5:194]
[main] Setsockopt(1 c 80d3000 60) on fd 269 [9:5:0]
[main] Setsockopt(1 29 80d3000 aa) on fd 270 [12:5:2]
[main] Setsockopt(1 f 80d3000 4) on fd 271 [16:3:18]
[main] Setsockopt(1 d 80d3000 8) on fd 272 [20:10:236]
[main] Setsockopt(1 23 80d3000 4) on fd 273 [26:2:247]
[main] Setsockopt(1 b 80d3000 98) on fd 274 [30:2:0]
[main] Setsockopt(1 23 80d3000 4) on fd 275 [35:2:0]
[main] Setsockopt(116 7f 80d3000 e1) on fd 276 [37:5:1]
[main] Setsockopt(1 22 80d3000 4) on fd 280 [4:2:112]
[main] Setsockopt(1 6 80d3000 4) on fd 282 [9:5:0]
[main] Setsockopt(105 d 80d3000 4) on fd 283 [12:5:2]
[main] Setsockopt(1 a 80d3000 4) on fd 284 [20:3:41]
[main] Setsockopt(1 22 80d3000 c2) on fd 288 [37:5:3]
[main] Setsockopt(1 29 80d3000 4) on fd 290 [1:2:1]
[main] Setsockopt(1 5 80d3000 4) on fd 292 [4:2:19]
[main] Setsockopt(1 21 80d3000 4) on fd 293 [8:4:3]
[main] Setsockopt(1 29 80d3000 c6) on fd 294 [9:5:0]
[main] Setsockopt(1 23 80d3000 4) on fd 296 [20:5:142]
[main] Setsockopt(1 e 80d3000 4) on fd 297 [26:1:105]
[main] Setsockopt(1 12 80d3000 9c) on fd 299 [35:5:0]
[main] Setsockopt(1 22 80d3000 48) on fd 300 [37:5:2]
[main] Setsockopt(1 2c 80d3000 4) on fd 301 [39:1:1]
[main] Setsockopt(1 2f 80d3000 4) on fd 303 [2:3:179]
[main] Setsockopt(1 22 80d3000 10) on fd 305 [8:10:36]
[main] Setsockopt(1 29 80d3000 94) on fd 306 [9:5:0]
[main] Setsockopt(10a b 80d3000 4) on fd 307 [12:5:2]
[main] Setsockopt(1 b 80d3000 4) on fd 310 [26:2:24]
[main] Setsockopt(1 d 80d3000 8) on fd 311 [30:5:0]
[main] Setsockopt(1 2b 80d3000 4) on fd 313 [37:1:5]
[main] Setsockopt(1 9 80d3000 e3) on fd 314 [39:5:0]
[main] Setsockopt(1 24 80d3000 34) on fd 315 [1:1:1]
[main] Setsockopt(0 8 80d3000 1) on fd 316 [2:1:0]
[main] Setsockopt(100 1 80d3000 4) on fd 317 [4:2:135]
[main] Setsockopt(105 4 80d3000 4) on fd 320 [12:5:2]
[main] Setsockopt(1 7 80d3000 4) on fd 321 [16:3:4]
[main] Setsockopt(10c 2 80d3000 4) on fd 323 [26:1:254]
[main] Setsockopt(1 22 80d3000 20) on fd 325 [35:2:0]
[main] Setsockopt(116 7f 80d3000 4) on fd 326 [37:5:1]
[main] Setsockopt(1 1 80d3000 4) on fd 327 [39:5:0]
[main] Setsockopt(0 14 80d3000 4) on fd 329 [2:2:17]
[main] Setsockopt(1 1 80d3000 4) on fd 331 [9:5:0]
[main] Setsockopt(10d c 80d3000 4) on fd 332 [12:1:27]
[main] Setsockopt(113 42000004 80d3000 4) on fd 333 [20:10:250]
[main] Setsockopt(1 1d 80d3000 4) on fd 334 [26:1:39]
[main] Setsockopt(6 6 80d3000 4) on fd 335 [30:1:0]
[main] Setsockopt(1 d 80d3000 8) on fd 336 [35:2:0]
[main] Setsockopt(116 7f 80d3000 4) on fd 337 [37:5:5]
[main] Setsockopt(0 8 80d3000 4) on fd 340 [2:3:59]
[main] Setsockopt(1 9 80d3000 4) on fd 341 [4:2:225]
[main] Setsockopt(1 24 80d3000 4) on fd 342 [9:5:0]
[main] Setsockopt(29 b 80d3000 4) on fd 343 [12:5:2]
[main] Setsockopt(10e 5 80d3000 4) on fd 344 [16:3:12]
[main] Setsockopt(1 6 80d3000 3a) on fd 345 [20:4:185]
[main] Setsockopt(6 3 80d3000 3a) on fd 347 [30:1:0]
[main] Setsockopt(1 b 80d3000 4) on fd 349 [37:1:4]
[main] Setsockopt(1 f 80d3000 4) on fd 350 [39:5:0]
[main] Setsockopt(11 1 80d3000 4) on fd 352 [2:2:17]
[main] Setsockopt(1 2c 80d3000 4b) on fd 353 [4:2:207]
[main] Setsockopt(1 21 80d3000 4) on fd 356 [12:1:125]
[main] Setsockopt(1 22 80d3000 e5) on fd 357 [16:2:10]
[main] Setsockopt(1 22 80d3000 4) on fd 359 [26:1:22]
[main] Setsockopt(6 10 0 4) on fd 360 [30:1:0]
[main] Setsockopt(1 c 80d3000 fe) on fd 361 [35:2:0]
[main] Setsockopt(1 23 80d3000 4) on fd 365 [2:2:17]
[main] Setsockopt(1 29 80d3000 cf) on fd 367 [8:2:181]
[main] Setsockopt(1 d 80d3000 8) on fd 368 [9:5:0]
[main] Setsockopt(117 d 80d3000 4) on fd 369 [12:5:2]
[main] Setsockopt(6 3 80d3000 fb) on fd 371 [30:1:0]
[main] Setsockopt(1 2f 80d3000 4) on fd 373 [37:5:1]
[main] Setsockopt(1 12 80d3000 eb) on fd 375 [1:5:1]
[main] Setsockopt(6 c 80d3000 4) on fd 376 [2:1:0]
[main] Setsockopt(100 1 80d3000 4) on fd 377 [4:2:217]
[main] Setsockopt(1 22 80d3000 4) on fd 379 [9:5:0]
[main] Setsockopt(113 c 80d3000 4) on fd 380 [12:5:2]
[main] Setsockopt(1 f 80d3000 4) on fd 6 [1:1:1]
[main] Setsockopt(0 d 80d3000 1) on fd 7 [2:3:151]
[main] Setsockopt(108 42000004 80d3000 4) on fd 9 [8:2:214]
[main] Setsockopt(1 9 80d3000 88) on fd 10 [9:5:0]
[main] Setsockopt(10e 5 80d3000 aa) on fd 12 [16:3:0]
[main] Setsockopt(1 2c 80d3000 4e) on fd 13 [26:1:165]
[main] Setsockopt(6 3 80d3000 4) on fd 14 [30:1:0]
[main] Setsockopt(1 20 80d3000 b4) on fd 15 [35:5:0]
[main] Setsockopt(116 7f 80d3000 4) on fd 16 [37:5:2]
[main] created 375 sockets
[main] Setsockopt(0 3 80d3000 4) on fd 19 [2:3:112]
[main] Setsockopt(100 1 80d3000 4) on fd 20 [4:2:76]
[main] Setsockopt(1 2f 80d3000 4) on fd 22 [9:5:0]
[main] Setsockopt(1 20 80d3000 81) on fd 23 [12:5:2]
[main] Setsockopt(1 d 80d3000 8) on fd 24 [20:4:43]
[main] Setsockopt(1 a 80d3000 ab) on fd 25 [26:1:223]
[main] Setsockopt(1 10 80d3000 ac) on fd 26 [30:5:0]
[main] Setsockopt(1 10 80d3000 62) on fd 27 [35:5:0]
[main] Setsockopt(116 7f 80d3000 87) on fd 28 [37:1:1]
[main] Setsockopt(1 2d 80d3000 86) on fd 29 [39:5:0]
[main] Setsockopt(1 a 80d3000 ad) on fd 30 [1:2:1]
[main] Setsockopt(0 8 80d3000 1) on fd 31 [2:1:6]
[main] Setsockopt(100 1 80d3000 4) on fd 32 [4:2:6]
[main] Setsockopt(10b 42000004 80d3000 3e) on fd 33 [8:5:38]
[main] Setsockopt(10a b 80d3000 4) on fd 35 [12:5:2]
[main] Setsockopt(1 d 80d3000 8) on fd 36 [20:2:151]
[main] Setsockopt(1 6 80d3000 4) on fd 38 [30:2:0]
[main] Setsockopt(1 2f 80d3000 ad) on fd 39 [35:2:0]
[main] Setsockopt(116 7f 80d3000 4) on fd 40 [37:5:5]
[main] Setsockopt(1 2d 80d3000 4) on fd 41 [39:5:0]
[main] Setsockopt(0 7 80d3000 1) on fd 43 [2:3:225]
[main] Setsockopt(1 e 80d3000 4) on fd 44 [4:2:180]
[main] Setsockopt(88 b 80d3000 4) on fd 46 [12:5:2]
[main] Setsockopt(1 2d 80d3000 cb) on fd 47 [26:1:103]
[main] Setsockopt(1 1 80d3000 4) on fd 51 [39:1:1]
[main] Setsockopt(1 6 80d3000 4) on fd 53 [2:2:0]
[main] Setsockopt(1 21 80d3000 c9) on fd 54 [4:2:133]
[main] Setsockopt(10d b 80d3000 4) on fd 57 [12:5:2]
[main] Setsockopt(1 b 80d3000 4) on fd 58 [16:2:4]
[main] Setsockopt(1 6 80d3000 94) on fd 60 [30:2:0]
[main] Setsockopt(1 6 80d3000 4) on fd 61 [35:5:0]
[main] Setsockopt(116 7f 80d3000 4) on fd 62 [37:1:0]
[main] Setsockopt(1 2b 80d3000 fe) on fd 66 [4:2:70]
[main] Setsockopt(1 6 80d3000 4) on fd 68 [9:5:0]
[main] Setsockopt(1 a 80d3000 4) on fd 69 [12:1:231]
[main] Setsockopt(1 6 80d3000 4) on fd 70 [20:2:186]
[main] Setsockopt(1 23 80d3000 83) on fd 72 [30:2:0]
[main] Setsockopt(1 21 80d3000 f1) on fd 73 [35:5:0]
[main] Setsockopt(116 7f 80d3000 49) on fd 74 [37:1:4]
[main] Setsockopt(1 8 80d3000 4) on fd 75 [39:2:1]
[main] Setsockopt(1 a 80d3000 1a) on fd 77 [2:3:47]
[main] Setsockopt(1 8 80d3000 4) on fd 79 [8:2:60]
[main] Setsockopt(105 c 80d3000 4) on fd 81 [12:5:2]
[main] Setsockopt(1 1d 80d3000 37) on fd 82 [16:2:6]
[main] Setsockopt(1 f 80d3000 24) on fd 83 [20:10:18]
[main] Setsockopt(1 6 80d3000 ac) on fd 84 [26:2:216]
[main] Setsockopt(1 24 80d3000 2f) on fd 85 [30:1:0]
[main] Setsockopt(1 e 80d3000 4) on fd 86 [35:5:0]
[main] Setsockopt(1 e 80d3000 20) on fd 88 [39:5:0]
[main] Setsockopt(0 c 80d3000 4) on fd 90 [2:1:0]
[main] Setsockopt(100 1 80d3000 4) on fd 91 [4:2:188]
[main] Setsockopt(1 5 80d3000 4) on fd 92 [9:5:0]
[main] Setsockopt(1 a 80d3000 89) on fd 93 [12:1:224]
[main] Setsockopt(10e 4 80d3000 6a) on fd 94 [16:3:0]
[main] Setsockopt(117 42020054 80d3000 57) on fd 95 [20:5:188]
[main] Setsockopt(1 20 80d3000 5d) on fd 100 [39:5:0]
[main] Setsockopt(1 c 80d3000 39) on fd 101 [1:2:1]
[main] Setsockopt(0 1 80d3000 86) on fd 102 [2:1:0]
[main] Setsockopt(100 1 80d3000 4) on fd 103 [4:2:134]
[main] Setsockopt(1 12 80d3000 eb) on fd 104 [8:10:143]
[main] Setsockopt(1 1 80d3000 4) on fd 105 [9:5:0]
[main] Setsockopt(1 2f 80d3000 fb) on fd 109 [26:2:210]
[main] Setsockopt(6 9 80d3000 4) on fd 110 [30:1:0]
[main] Setsockopt(1 5 80d3000 c) on fd 112 [37:5:0]
[main] Setsockopt(1 e 80d3000 bf) on fd 114 [1:5:1]
[main] Setsockopt(1 2d 80d3000 a2) on fd 117 [8:4:22]
[main] Setsockopt(1 8 80d3000 4) on fd 118 [9:5:0]
[main] Setsockopt(107 c 80d3000 4) on fd 119 [12:1:30]
[main] Setsockopt(1 8 80d3000 4) on fd 122 [30:1:0]
[main] Setsockopt(1 f 80d3000 4) on fd 123 [35:2:0]
[main] Setsockopt(116 7f 80d3000 2c) on fd 124 [37:1:0]
[main] Setsockopt(1 2b 80d3000 e3) on fd 125 [39:1:1]
[main] Setsockopt(11 1 80d3000 4) on fd 127 [2:2:17]
[main] Setsockopt(100 1 80d3000 4) on fd 128 [4:2:83]
[main] Setsockopt(1 12 80d3000 4) on fd 130 [9:5:0]
[main] Setsockopt(1 c 80d3000 4) on fd 131 [12:5:2]
[main] Setsockopt(1 2 80d3000 e8) on fd 133 [20:5:214]
[main] Setsockopt(6 16 80d3000 4) on fd 135 [30:1:0]
[main] Setsockopt(1 20 80d3000 cc) on fd 136 [35:2:0]
[main] Setsockopt(1 24 80d3000 4) on fd 137 [37:1:0]
[main] Setsockopt(1 5 80d3000 90) on fd 138 [39:2:1]
[main] Setsockopt(0 1 80d3000 4) on fd 140 [2:2:0]
[main] Setsockopt(1 2 80d3000 5d) on fd 144 [12:1:55]
[main] Setsockopt(1 1d 80d3000 4) on fd 145 [16:2:2]
[main] Setsockopt(1 c 80d3000 4) on fd 146 [20:2:56]
[main] Setsockopt(1 24 80d3000 4) on fd 147 [26:2:138]
[main] Setsockopt(6 4 80d3000 4) on fd 148 [30:1:0]
[main] Setsockopt(1 10 80d3000 f6) on fd 151 [39:5:0]
[main] Setsockopt(0 1 80d3000 7e) on fd 153 [2:3:24]
[main] Setsockopt(1 2b 80d3000 4) on fd 155 [8:10:144]
[main] Setsockopt(113 b 80d3000 4) on fd 157 [12:5:2]
[main] Setsockopt(1 2e 80d3000 89) on fd 159 [26:1:173]
[main] Setsockopt(6 c 80d3000 3e) on fd 160 [30:1:0]
[main] Setsockopt(1 10 80d3000 7d) on fd 161 [35:5:0]
[main] Setsockopt(116 7f 80d3000 4b) on fd 162 [37:5:1]
[main] Setsockopt(1 8 80d3000 6c) on fd 163 [39:1:1]
[main] Setsockopt(1 29 80d3000 4) on fd 164 [1:2:1]
[main] Setsockopt(1 2 80d3000 94) on fd 166 [4:2:16]
[main] Setsockopt(1 2f 80d3000 4) on fd 168 [9:5:0]
[main] Setsockopt(1 12 80d3000 4) on fd 169 [12:5:2]
[main] Setsockopt(10e 3 80d3000 f0) on fd 170 [16:3:2]
[main] Setsockopt(1 2e 80d3000 a5) on fd 171 [20:2:155]
[main] Setsockopt(1 9 80d3000 7) on fd 172 [26:1:110]
[main] Setsockopt(1 2b 80d3000 4) on fd 174 [35:5:0]
[main] Setsockopt(116 7f 80d3000 3f) on fd 175 [37:5:5]
[main] Setsockopt(1 21 80d3000 3a) on fd 176 [39:1:1]
[main] Setsockopt(1 5 80d3000 4) on fd 177 [1:2:1]
[main] Setsockopt(1 f 80d3000 4) on fd 178 [2:3:139]
[main] Setsockopt(100 1 80d3000 4) on fd 179 [4:2:18]
[main] Setsockopt(6 d 80d3000 4) on fd 182 [12:5:2]
[main] Setsockopt(1 20 80d3000 4) on fd 183 [16:3:9]
[main] Setsockopt(1 2c 80d3000 3a) on fd 184 [20:4:156]
[main] Setsockopt(1 2e 80d3000 28) on fd 185 [26:1:243]
[main] Setsockopt(1 9 80d3000 4) on fd 186 [30:2:0]
[main] Setsockopt(1 28 80d3000 f2) on fd 188 [37:5:2]
[main] Setsockopt(1 8 80d3000 5) on fd 190 [1:1:1]
[main] Setsockopt(10e 4 80d3000 8d) on fd 196 [16:2:18]
[main] Setsockopt(1 1d 80d3000 4) on fd 197 [20:2:66]
[main] Setsockopt(1 2 80d3000 49) on fd 200 [35:5:0]
[main] Setsockopt(116 80 80d3000 d0) on fd 201 [37:5:3]
[main] Setsockopt(1 29 80d3000 4) on fd 203 [1:1:1]
[main] Setsockopt(1 1d 80d3000 4d) on fd 205 [4:2:157]
[main] Setsockopt(1 c 80d3000 4) on fd 207 [9:5:0]
[main] Setsockopt(1 1d 80d3000 e4) on fd 208 [12:1:196]
[main] Setsockopt(1 1d 80d3000 4) on fd 209 [16:3:8]
[main] Setsockopt(1 b 80d3000 4) on fd 211 [26:2:10]
[main] Setsockopt(116 7f 80d3000 4) on fd 214 [37:1:4]
[main] Setsockopt(1 e 80d3000 b3) on fd 215 [39:1:1]
[main] Setsockopt(1 28 80d3000 4) on fd 216 [1:5:1]
[main] Setsockopt(6 c 80d3000 2c) on fd 217 [2:1:0]
[main] Setsockopt(100 1 80d3000 4) on fd 218 [4:2:62]
[main] Setsockopt(1 1 80d3000 82) on fd 219 [9:5:0]
[main] Setsockopt(1 2b 80d3000 4) on fd 220 [12:5:2]
[main] Setsockopt(10e 4 80d3000 4) on fd 221 [16:2:14]
[main] Setsockopt(1 d 80d3000 8) on fd 223 [26:1:247]
[main] Setsockopt(1 2c 80d3000 74) on fd 224 [30:1:0]
[main] Setsockopt(1 2d 80d3000 4) on fd 226 [37:5:1]
[main] Setsockopt(1 1 80d3000 40) on fd 227 [39:1:1]
[main] Setsockopt(0 1 80d3000 4) on fd 229 [2:2:17]
[main] Setsockopt(100 1 80d3000 4) on fd 230 [4:2:92]
[main] Setsockopt(1 29 80d3000 9a) on fd 232 [9:5:0]
[main] Setsockopt(88 b 80d3000 4) on fd 233 [12:1:32]
[main] Setsockopt(1 29 80d3000 4) on fd 234 [20:5:9]
[main] Setsockopt(1 2b 80d3000 4) on fd 235 [26:1:124]
[main] Setsockopt(1 a 80d3000 f2) on fd 238 [37:1:0]
[main] Setsockopt(1 10 80d3000 4) on fd 239 [39:2:1]
[main] Setsockopt(1 b 80d3000 ad) on fd 241 [2:3:165]
[main] Setsockopt(1 a 80d3000 4) on fd 243 [8:3:11]
[main] Setsockopt(1 5 80d3000 4) on fd 244 [9:5:0]
[main] Setsockopt(107 c 80d3000 4) on fd 245 [12:5:2]
[main] Setsockopt(1 d 80d3000 8) on fd 247 [20:2:243]
[main] Setsockopt(1 a 80d3000 4b) on fd 248 [26:2:178]
[main] Setsockopt(1 29 80d3000 a9) on fd 249 [30:2:0]
[main] Setsockopt(1 2e 80d3000 bf) on fd 250 [35:2:0]
[main] Setsockopt(116 7f 80d3000 4) on fd 251 [37:5:3]
[main] Setsockopt(1 b 80d3000 1f) on fd 252 [39:1:1]
[main] Setsockopt(1 f 80d3000 dc) on fd 253 [1:1:1]
[main] Setsockopt(88 1 80d3000 4) on fd 254 [2:2:0]
[main] Setsockopt(1 e 80d3000 11) on fd 256 [8:10:61]
[main] Setsockopt(1 b 80d3000 4) on fd 257 [9:5:0]
[main] Setsockopt(10e 4 80d3000 4) on fd 258 [12:1:251]
[main] Setsockopt(1 2c 80d3000 4) on fd 260 [26:1:248]
[main] Setsockopt(1 2c 80d3000 41) on fd 261 [30:2:0]
[main] Setsockopt(116 7f 80d3000 4) on fd 263 [37:1:5]
[main] Setsockopt(1 2b 80d3000 4) on fd 264 [39:1:1]
[main] Setsockopt(1 2b 80d3000 4) on fd 265 [1:2:1]
[main] Setsockopt(11 64 80d3000 4) on fd 266 [2:2:17]
[main] Setsockopt(1 2b 80d3000 4) on fd 268 [8:5:194]
[main] Setsockopt(1 25 80d3000 4) on fd 269 [9:5:0]
[main] Setsockopt(105 c 80d3000 4) on fd 270 [12:5:2]
[main] Setsockopt(10e 5 80d3000 46) on fd 271 [16:3:18]
[main] Setsockopt(1 5 80d3000 4) on fd 272 [20:10:236]
[main] Setsockopt(10c 4 80d3000 4) on fd 273 [26:2:247]
[main] Setsockopt(1 2c 80d3000 4) on fd 275 [35:2:0]
[main] Setsockopt(116 7f 80d3000 4) on fd 276 [37:5:1]
[main] Setsockopt(1 2 80d3000 64) on fd 277 [39:5:0]
[main] Setsockopt(1 6 80d3000 4) on fd 278 [1:2:1]
[main] Setsockopt(1 20 80d3000 4) on fd 279 [2:3:144]
[main] Setsockopt(1 7 80d3000 44) on fd 280 [4:2:112]
[main] Setsockopt(1 7 80d3000 9e) on fd 281 [8:2:253]
[main] Setsockopt(1 8 80d3000 96) on fd 285 [26:1:220]
[main] Setsockopt(1 8 80d3000 4) on fd 287 [35:2:0]
[main] Setsockopt(1 1d 80d3000 ee) on fd 290 [1:2:1]
[main] Setsockopt(1 29 80d3000 4) on fd 291 [2:3:142]
[main] Setsockopt(1 8 80d3000 4) on fd 292 [4:2:19]
[main] Setsockopt(105 b 80d3000 4) on fd 295 [12:5:2]
[main] Setsockopt(1 2b 80d3000 4) on fd 299 [35:5:0]
[main] Setsockopt(116 7f 80d3000 55) on fd 300 [37:5:2]
[main] Setsockopt(1 22 80d3000 4) on fd 302 [1:1:1]
[main] Setsockopt(1 d 80d3000 8) on fd 303 [2:3:179]
[main] Setsockopt(108 42000004 80d3000 4) on fd 305 [8:10:36]
[main] Setsockopt(1 2d 80d3000 d0) on fd 307 [12:5:2]
[main] Setsockopt(1 28 80d3000 b) on fd 308 [16:3:6]
[main] Setsockopt(10c 9 80d3000 4) on fd 310 [26:2:24]
[main] Setsockopt(1 1 80d3000 40) on fd 311 [30:5:0]
[main] Setsockopt(1 c 80d3000 4) on fd 312 [35:2:0]
[main] Setsockopt(116 7f 80d3000 4) on fd 313 [37:1:5]
[main] Setsockopt(1 1 80d3000 51) on fd 317 [4:2:135]
[main] Setsockopt(1 10 80d3000 4) on fd 319 [9:5:0]
[main] Setsockopt(1 2c 80d3000 4c) on fd 320 [12:5:2]
[main] Setsockopt(1 2 80d3000 4) on fd 321 [16:3:4]
[main] Setsockopt(1 7 80d3000 36) on fd 322 [20:2:66]
[main] Setsockopt(1 12 80d3000 4) on fd 324 [30:5:0]
[main] Setsockopt(1 20 80d3000 d4) on fd 325 [35:2:0]
[main] Setsockopt(1 7 80d3000 4) on fd 328 [1:1:1]
[main] Setsockopt(1 1 80d3000 4) on fd 329 [2:2:17]
[main] Setsockopt(1 1 80d3000 4) on fd 331 [9:5:0]
[main] Setsockopt(1 2 80d3000 f4) on fd 334 [26:1:39]
[main] Setsockopt(6 c 80d3000 a0) on fd 335 [30:1:0]
[main] Setsockopt(116 7f 80d3000 6f) on fd 337 [37:5:5]
[main] Setsockopt(1 2d 80d3000 c1) on fd 340 [2:3:59]
[main] Setsockopt(100 1 80d3000 4) on fd 341 [4:2:225]
[main] Setsockopt(109 b 80d3000 4) on fd 343 [12:5:2]
[main] Setsockopt(1 c 80d3000 4) on fd 344 [16:3:12]
[main] Setsockopt(1 1 80d3000 85) on fd 345 [20:4:185]
[main] Setsockopt(6 b 80d3000 4) on fd 347 [30:1:0]
[main] Setsockopt(1 2b 80d3000 4) on fd 348 [35:5:0]
[main] Setsockopt(116 7f 80d3000 7a) on fd 349 [37:1:4]
[main] Setsockopt(1 12 80d3000 4) on fd 352 [2:2:17]
[main] Setsockopt(1 1d 80d3000 7b) on fd 353 [4:2:207]
[main] Setsockopt(1 a 80d3000 d0) on fd 354 [8:2:110]
[main] Setsockopt(1 6 80d3000 4) on fd 355 [9:5:0]
[main] Setsockopt(10a 4 80d3000 4) on fd 356 [12:1:125]
[main] Setsockopt(1 22 80d3000 4) on fd 357 [16:2:10]
[main] Setsockopt(1 22 80d3000 4) on fd 358 [20:4:168]
[main] Setsockopt(1 8 80d3000 7f) on fd 359 [26:1:22]
[main] Setsockopt(6 17 80d3000 4) on fd 360 [30:1:0]
[main] Setsockopt(1 22 80d3000 4) on fd 362 [37:5:0]
[main] Setsockopt(1 1d 80d3000 4) on fd 364 [1:1:1]
[main] Setsockopt(0 14 80d3000 1) on fd 365 [2:2:17]
[main] Setsockopt(1 d 80d3000 8) on fd 366 [4:2:199]
[main] Setsockopt(1 b 80d3000 4) on fd 367 [8:2:181]
[main] Setsockopt(1 24 80d3000 58) on fd 369 [12:5:2]
[main] Setsockopt(6 f 0 4) on fd 371 [30:1:0]
[main] Setsockopt(116 7f 80d3000 97) on fd 373 [37:5:1]
[main] Setsockopt(1 8 80d3000 4) on fd 374 [39:1:1]
[main] Setsockopt(1 1d 80d3000 54) on fd 375 [1:5:1]
[main] Setsockopt(6 12 80d3000 4) on fd 376 [2:1:0]
[main] Setsockopt(1 21 80d3000 27) on fd 377 [4:2:217]
[main] Setsockopt(1 b 80d3000 4) on fd 378 [8:10:250]
[main] Setsockopt(88 b 80d3000 4) on fd 380 [12:5:2]
[main] 375 sockets created based on info from socket cachefile.
lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 09:22:10 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

run-parts: /etc/kernel-tests/99-rmmod exited with code 123
wfg: skip syslogd
Deconfiguring network interfaces... done.
Sending all processes the TERM signal...
Sending all processes the KILL signal...
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
Rebooting...=20
[   78.137603] Unregister pv shared memory for cpu 0
[   78.138474] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   78.139268] reboot: Restarting system
[   78.139753] reboot: machine restart
Elapsed time: 85
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
1-08211449/2c575026fae6e63771bd2a4c1d407214a8096a89/vmlinuz-3.12.0-02795-g2=
c57502 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 =
prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=
=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-c1-08211=
449/linux-devel:devel-hourly-2014082110:2c575026fae6e63771bd2a4c1d407214a80=
96a89:bisect-linux-0/.vmlinuz-2c575026fae6e63771bd2a4c1d407214a8096a89-2014=
0822092123-129-ivb41 branch=3Dlinux-devel/devel-hourly-2014082110 BOOT_IMAG=
E=3D/kernel/i386-randconfig-c1-08211449/2c575026fae6e63771bd2a4c1d407214a80=
96a89/vmlinuz-3.12.0-02795-g2c57502 drbd.minor_count=3D8'  -initrd /kernel-=
tests/initrd/yocto-minimal-i386.cgz -m 320 -smp 1 -net nic,vlan=3D1,model=
=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb =
-rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-ivb41-100 -serial f=
ile:/dev/shm/kboot/serial-yocto-ivb41-100 -daemonize -display none -monitor=
 null=20

--0F1p//8PRICkK4MW--
