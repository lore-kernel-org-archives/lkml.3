Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab3KHC3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:29:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626Ab3KHC3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:29:04 -0500
Date: Thu, 7 Nov 2013 21:28:55 -0500
From: Dave Jones <davej@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: sysfs related lockdep trace in current tree.
Message-ID: <20131108022855.GA5380@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haven't seen this before today, so I'm guessing it's related to the sysfs
changes that just got merged?

	Dave

[  853.451912] ======================================================
[  853.451934] [ INFO: possible circular locking dependency detected ]
[  853.451959] 3.12.0+ #113 Not tainted
[  853.451975] -------------------------------------------------------
[  853.451999] trinity-child3/13563 is trying to acquire lock:
[  853.452022]  (&of->mutex){+.+.+.}, at: [<ffffffff8123a6ef>] sysfs_bin_mmap+0x4f/0x120
[  853.452063] 
but task is already holding lock:
[  853.452087]  (&mm->mmap_sem){++++++}, at: [<ffffffff8116b37f>] vm_mmap_pgoff+0x6f/0xc0
[  853.452125] 
which lock already depends on the new lock.

[  853.452156] 
the existing dependency chain (in reverse order) is:
[  853.452184] 
-> #3 (&mm->mmap_sem){++++++}:
[  853.452212]        [<ffffffff810cb243>] lock_acquire+0x93/0x200
[  853.452239]        [<ffffffff811757a4>] might_fault+0x84/0xb0
[  853.452265]        [<ffffffff812f9a75>] scsi_cmd_ioctl+0x295/0x470
[  853.452293]        [<ffffffff812f9c92>] scsi_cmd_blk_ioctl+0x42/0x50
[  853.452320]        [<ffffffff81503951>] cdrom_ioctl+0x41/0x1050
[  853.452347]        [<ffffffff814d6b0f>] sr_block_ioctl+0x6f/0xd0
[  853.452372]        [<ffffffff812f5934>] blkdev_ioctl+0x234/0x840
[  853.452398]        [<ffffffff811f5b87>] block_ioctl+0x47/0x50
[  853.452423]        [<ffffffff811caea5>] do_vfs_ioctl+0x305/0x530
[  853.452449]        [<ffffffff811cb151>] SyS_ioctl+0x81/0xa0
[  853.452473]        [<ffffffff8172db64>] tracesys+0xdd/0xe2
[  853.453341] 
-> #2 (sr_mutex){+.+.+.}:
[  853.455048]        [<ffffffff810cb243>] lock_acquire+0x93/0x200
[  853.455918]        [<ffffffff8171ebbc>] mutex_lock_nested+0x7c/0x420
[  853.456779]        [<ffffffff814d7194>] sr_block_open+0x24/0x130
[  853.457637]        [<ffffffff811f6951>] __blkdev_get+0xd1/0x4c0
[  853.458480]        [<ffffffff811f6f25>] blkdev_get+0x1e5/0x380
[  853.459316]        [<ffffffff811f717a>] blkdev_open+0x6a/0x90
[  853.460138]        [<ffffffff811b49fb>] do_dentry_open+0x24b/0x300
[  853.460963]        [<ffffffff811b4af0>] finish_open+0x40/0x50
[  853.461788]        [<ffffffff811c6cfc>] do_last+0x5cc/0x1230
[  853.462606]        [<ffffffff811c7a1e>] path_openat+0xbe/0x6a0
[  853.463412]        [<ffffffff811c873a>] do_filp_open+0x3a/0x90
[  853.464212]        [<ffffffff811b5f6e>] do_sys_open+0x12e/0x210
[  853.464980]        [<ffffffff811b606e>] SyS_open+0x1e/0x20
[  853.465770]        [<ffffffff8172db64>] tracesys+0xdd/0xe2
[  853.466563] 
-> #1 (&bdev->bd_mutex){+.+.+.}:
[  853.468123]        [<ffffffff810cb243>] lock_acquire+0x93/0x200
[  853.468917]        [<ffffffff8171ebbc>] mutex_lock_nested+0x7c/0x420
[  853.469716]        [<ffffffff8112d9ff>] sysfs_blk_trace_attr_show+0x5f/0x1f0
[  853.470524]        [<ffffffff814a92c0>] dev_attr_show+0x20/0x60
[  853.471322]        [<ffffffff8123af98>] sysfs_seq_show+0xc8/0x160
[  853.472095]        [<ffffffff811de66c>] seq_read+0x16c/0x450
[  853.472841]        [<ffffffff811b6a81>] vfs_read+0xa1/0x170
[  853.473583]        [<ffffffff811b75ec>] SyS_read+0x4c/0xa0
[  853.474318]        [<ffffffff8172db64>] tracesys+0xdd/0xe2
[  853.475052] 
-> #0 (&of->mutex){+.+.+.}:
[  853.476494]        [<ffffffff810ca7ca>] __lock_acquire+0x191a/0x1be0
[  853.477221]        [<ffffffff810cb243>] lock_acquire+0x93/0x200
[  853.477953]        [<ffffffff8171ebbc>] mutex_lock_nested+0x7c/0x420
[  853.478716]        [<ffffffff8123a6ef>] sysfs_bin_mmap+0x4f/0x120
[  853.479444]        [<ffffffff81180438>] mmap_region+0x3e8/0x5d0
[  853.480153]        [<ffffffff81180980>] do_mmap_pgoff+0x360/0x3f0
[  853.480859]        [<ffffffff8116b3a0>] vm_mmap_pgoff+0x90/0xc0
[  853.481548]        [<ffffffff8117eec5>] SyS_mmap_pgoff+0x1d5/0x270
[  853.482232]        [<ffffffff81008042>] SyS_mmap+0x22/0x30
[  853.482933]        [<ffffffff8172db64>] tracesys+0xdd/0xe2
[  853.483634] 
other info that might help us debug this:

[  853.485660] Chain exists of:
  &of->mutex --> sr_mutex --> &mm->mmap_sem

[  853.487610]  Possible unsafe locking scenario:

[  853.488951]        CPU0                    CPU1
[  853.489638]        ----                    ----
[  853.490271]   lock(&mm->mmap_sem);
[  853.490901]                                lock(sr_mutex);
[  853.491558]                                lock(&mm->mmap_sem);
[  853.492240]   lock(&of->mutex);
[  853.492907] 
 *** DEADLOCK ***

[  853.494769] 1 lock held by trinity-child3/13563:
[  853.495449]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8116b37f>] vm_mmap_pgoff+0x6f/0xc0
[  853.496131] 
stack backtrace:
[  853.497393] CPU: 3 PID: 13563 Comm: trinity-child3 Not tainted 3.12.0+ #113 
[  853.498807]  ffffffff82501cb0 ffff8800a10d9ba8 ffffffff8171a8e8 ffffffff82529260
[  853.499514]  ffff8800a10d9be8 ffffffff81716dae ffff8800a10d9c40 ffff880233544720
[  853.500223]  ffff880233544020 0000000000000000 ffff8802335446e8 ffff880233544720
[  853.500929] Call Trace:
[  853.501622]  [<ffffffff8171a8e8>] dump_stack+0x4e/0x82
[  853.502321]  [<ffffffff81716dae>] print_circular_bug+0x200/0x20f
[  853.503109]  [<ffffffff810ca7ca>] __lock_acquire+0x191a/0x1be0
[  853.503881]  [<ffffffff810cb243>] lock_acquire+0x93/0x200
[  853.504653]  [<ffffffff8123a6ef>] ? sysfs_bin_mmap+0x4f/0x120
[  853.505423]  [<ffffffff8123a6ef>] ? sysfs_bin_mmap+0x4f/0x120
[  853.506193]  [<ffffffff8171ebbc>] mutex_lock_nested+0x7c/0x420
[  853.506956]  [<ffffffff8123a6ef>] ? sysfs_bin_mmap+0x4f/0x120
[  853.507722]  [<ffffffff8123a6ef>] ? sysfs_bin_mmap+0x4f/0x120
[  853.508484]  [<ffffffff8123a6ef>] sysfs_bin_mmap+0x4f/0x120
[  853.509243]  [<ffffffff81180438>] mmap_region+0x3e8/0x5d0
[  853.509983]  [<ffffffff81180980>] do_mmap_pgoff+0x360/0x3f0
[  853.510723]  [<ffffffff8116b3a0>] vm_mmap_pgoff+0x90/0xc0
[  853.511486]  [<ffffffff8117eec5>] SyS_mmap_pgoff+0x1d5/0x270
[  853.512257]  [<ffffffff81010b05>] ? syscall_trace_enter+0x145/0x2a0
[  853.513027]  [<ffffffff81008042>] SyS_mmap+0x22/0x30
[  853.513795]  [<ffffffff8172db64>] tracesys+0xdd/0xe2

