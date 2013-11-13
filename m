Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759759Ab3KMSpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:45:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab3KMSpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:45:47 -0500
Date: Wed, 13 Nov 2013 13:45:38 -0500
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: sysfs_bin_mmap lockdep trace.
Message-ID: <20131113184538.GA7269@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, is this one also known ? Also seen on v3.12-7033-g42a2d923cc34
 
======================================================
[ INFO: possible circular locking dependency detected ]
3.12.0+ #2 Not tainted
-------------------------------------------------------
trinity-child0/9004 is trying to acquire lock:
 (&of->mutex){+.+.+.}, at: [<ffffffff8123c0cf>] sysfs_bin_mmap+0x4f/0x120

eady holding lock:
  (&mm->mmap_sem){++++++}, at: [<ffffffff8116b5ff>] vm_mmap_pgoff+0x6f/0xc0
 
which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&mm->mmap_sem){++++++}:
        [<ffffffff810d7a23>] lock_acquire+0x93/0x1c0
        [<ffffffff81175a5c>] might_fault+0x8c/0xb0
        [<ffffffff812fa105>] scsi_cmd_ioctl+0x295/0x470
        [<ffffffff812fa322>] scsi_cmd_blk_ioctl+0x42/0x50
        [<ffffffff81502a61>] cdrom_ioctl+0x41/0x1050
        [<ffffffff814d5baf>] sr_block_ioctl+0x6f/0xd0
        [<ffffffff812f5fe4>] blkdev_ioctl+0x234/0x840
        [<ffffffff811f6b47>] block_ioctl+0x47/0x50
        [<ffffffff811cb4f0>] do_vfs_ioctl+0x300/0x520
        [<ffffffff811cb791>] SyS_ioctl+0x81/0xa0
        [<ffffffff8172e064>] tracesys+0xdd/0xe2
 
-> #2 (sr_mutex){+.+.+.}:
        [<ffffffff810d7a23>] lock_acquire+0x93/0x1c0
        [<ffffffff8171f277>] mutex_lock_nested+0x77/0x400
        [<ffffffff814d6244>] sr_block_open+0x24/0x130
        [<ffffffff811f7911>] __blkdev_get+0xd1/0x4c0
        [<ffffffff811f7ee5>] blkdev_get+0x1e5/0x380
        [<ffffffff811f813a>] blkdev_open+0x6a/0x90
        [<ffffffff811b45f7>] do_dentry_open+0x1e7/0x340
        [<ffffffff811b4860>] finish_open+0x40/0x50
        [<ffffffff811c7274>] do_last+0xa34/0x1170
        [<ffffffff811c7a6e>] path_openat+0xbe/0x6a0
        [<ffffffff811c87ca>] do_filp_open+0x3a/0x90
        [<ffffffff811b627e>] do_sys_open+0x12e/0x210
        [<ffffffff811b637e>] SyS_open+0x1e/0x20
        [<ffffffff8172e064>] tracesys+0xdd/0xe2
 
-> #1 (&bdev->bd_mutex){+.+.+.}:
        [<ffffffff810d7a23>] lock_acquire+0x93/0x1c0
        [<ffffffff8171f277>] mutex_lock_nested+0x77/0x400
        [<ffffffff8112e03f>] sysfs_blk_trace_attr_show+0x5f/0x1f0
        [<ffffffff814a86c0>] dev_attr_show+0x20/0x60
        [<ffffffff8123c968>] sysfs_seq_show+0xc8/0x160
        [<ffffffff811df6dc>] seq_read+0x16c/0x450
        [<ffffffff811b6583>] do_loop_readv_writev+0x63/0x90
        [<ffffffff811b7e9d>] do_readv_writev+0x20d/0x220
        [<ffffffff811b7ee0>] vfs_readv+0x30/0x60
        [<ffffffff811b7fc0>] SyS_readv+0x50/0xd0
        [<ffffffff8172e064>] tracesys+0xdd/0xe2
 
-> #0 (&of->mutex){+.+.+.}:
        [<ffffffff810d7002>] __lock_acquire+0x1782/0x19f0
        [<ffffffff810d7a23>] lock_acquire+0x93/0x1c0
        [<ffffffff8171f277>] mutex_lock_nested+0x77/0x400
        [<ffffffff8123c0cf>] sysfs_bin_mmap+0x4f/0x120
        [<ffffffff81180695>] mmap_region+0x3e5/0x5d0
        [<ffffffff81180bd7>] do_mmap_pgoff+0x357/0x3e0
        [<ffffffff8116b620>] vm_mmap_pgoff+0x90/0xc0
        [<ffffffff8117f125>] SyS_mmap_pgoff+0x1d5/0x270
        [<ffffffff81007eb2>] SyS_mmap+0x22/0x30
        [<ffffffff8172e064>] tracesys+0xdd/0xe2
 
other info that might help us debug this:

Chain exists of:
  &of->mutex --> sr_mutex --> &mm->mmap_sem

Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&mm->mmap_sem);
                                lock(sr_mutex);
                                lock(&mm->mmap_sem);
   lock(&of->mutex);
 
 *** DEADLOCK ***

 1 lock held by trinity-child0/9004:
  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8116b5ff>] vm_mmap_pgoff+0x6f/0xc0
 
stack backtrace:
 CPU: 0 PID: 9004 Comm: trinity-child0 Not tainted 3.12.0+ #2 
  ffffffff82501d30 ffff880093e3bbc0 ffffffff8171b3dc ffffffff825294d0
  ffff880093e3bc00 ffffffff81717c8f ffff880093e3bc50 ffff88009ce00700
  ffff88009ce00000 0000000000000001 0000000000000001 ffff88009ce00700
 Call Trace:
  [<ffffffff8171b3dc>] dump_stack+0x4e/0x7a
  [<ffffffff81717c8f>] print_circular_bug+0x200/0x20f
  [<ffffffff810d7002>] __lock_acquire+0x1782/0x19f0
  [<ffffffff810d7a23>] lock_acquire+0x93/0x1c0
  [<ffffffff8123c0cf>] ? sysfs_bin_mmap+0x4f/0x120
  [<ffffffff8123c0cf>] ? sysfs_bin_mmap+0x4f/0x120
  [<ffffffff8171f277>] mutex_lock_nested+0x77/0x400
  [<ffffffff8123c0cf>] ? sysfs_bin_mmap+0x4f/0x120
  [<ffffffff8123c0cf>] ? sysfs_bin_mmap+0x4f/0x120
  [<ffffffff8123c0cf>] sysfs_bin_mmap+0x4f/0x120
  [<ffffffff81180695>] mmap_region+0x3e5/0x5d0
  [<ffffffff81180bd7>] do_mmap_pgoff+0x357/0x3e0
  [<ffffffff8116b620>] vm_mmap_pgoff+0x90/0xc0
  [<ffffffff8117f125>] SyS_mmap_pgoff+0x1d5/0x270
  [<ffffffff810109f5>] ? syscall_trace_enter+0x145/0x2a0
  [<ffffffff81007eb2>] SyS_mmap+0x22/0x30
  [<ffffffff8172e064>] tracesys+0xdd/0xe2

