Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3LCQfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:35:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab3LCQfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:35:45 -0500
Date: Tue, 3 Dec 2013 11:35:32 -0500
From: Dave Jones <davej@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: another sysfs lockdep report. (blk_trace related)
Message-ID: <20131203163532.GA32223@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>,
	axboe@kernel.dk, Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Tejun, Jens,

I just hit this on a tree based on Linus' pulled from this morning.


[ 1409.199343] ======================================================
[ 1409.199373] [ INFO: possible circular locking dependency detected ]
[ 1409.199405] 3.13.0-rc2+ #15 Not tainted
[ 1409.199426] -------------------------------------------------------
[ 1409.199456] trinity-child3/25324 is trying to acquire lock:
[ 1409.199484]  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff8112ff8f>] sysfs_blk_trace_attr_show+0x5f/0x1f0
[ 1409.199544] 
but task is already holding lock:
[ 1409.199573]  (&of->mutex){+.+.+.}, at: [<ffffffff812419ef>] sysfs_seq_show+0x7f/0x160
[ 1409.199621] 
which lock already depends on the new lock.

[ 1409.199659] 
the existing dependency chain (in reverse order) is:
[ 1409.199695] 
-> #3 (&of->mutex){+.+.+.}:
[ 1409.199729]        [<ffffffff810af853>] lock_acquire+0x93/0x1c0
[ 1409.199762]        [<ffffffff81741df7>] mutex_lock_nested+0x77/0x400
[ 1409.199798]        [<ffffffff8124119f>] sysfs_bin_mmap+0x4f/0x120
[ 1409.199831]        [<ffffffff811835b5>] mmap_region+0x3e5/0x5d0
[ 1409.199864]        [<ffffffff81183af7>] do_mmap_pgoff+0x357/0x3e0
[ 1409.199896]        [<ffffffff8116e0a0>] vm_mmap_pgoff+0x90/0xc0
[ 1409.199928]        [<ffffffff81182045>] SyS_mmap_pgoff+0x1d5/0x270
[ 1409.199961]        [<ffffffff81007ed2>] SyS_mmap+0x22/0x30
[ 1409.199993]        [<ffffffff8174eb64>] tracesys+0xdd/0xe2
[ 1409.200023] 
-> #2 (&mm->mmap_sem){++++++}:
[ 1409.200057]        [<ffffffff810af853>] lock_acquire+0x93/0x1c0
[ 1409.200090]        [<ffffffff8117854c>] might_fault+0x8c/0xb0
[ 1409.201104]        [<ffffffff81304505>] scsi_cmd_ioctl+0x295/0x470
[ 1409.202120]        [<ffffffff81304722>] scsi_cmd_blk_ioctl+0x42/0x50
[ 1409.203133]        [<ffffffff81520961>] cdrom_ioctl+0x41/0x1050
[ 1409.204143]        [<ffffffff814f390f>] sr_block_ioctl+0x6f/0xd0
[ 1409.205134]        [<ffffffff81300414>] blkdev_ioctl+0x234/0x840
[ 1409.206114]        [<ffffffff811fba67>] block_ioctl+0x47/0x50
[ 1409.207075]        [<ffffffff811cf470>] do_vfs_ioctl+0x300/0x520
[ 1409.208031]        [<ffffffff811cf711>] SyS_ioctl+0x81/0xa0
[ 1409.208980]        [<ffffffff8174eb64>] tracesys+0xdd/0xe2
[ 1409.209926] 
-> #1 (sr_mutex){+.+.+.}:
[ 1409.211763]        [<ffffffff810af853>] lock_acquire+0x93/0x1c0
[ 1409.212698]        [<ffffffff81741df7>] mutex_lock_nested+0x77/0x400
[ 1409.213634]        [<ffffffff814f3fa4>] sr_block_open+0x24/0x130
[ 1409.214562]        [<ffffffff811fc831>] __blkdev_get+0xd1/0x4c0
[ 1409.215488]        [<ffffffff811fce05>] blkdev_get+0x1e5/0x380
[ 1409.216413]        [<ffffffff811fd05a>] blkdev_open+0x6a/0x90
[ 1409.217336]        [<ffffffff811b7e77>] do_dentry_open+0x1e7/0x340
[ 1409.218257]        [<ffffffff811b80e0>] finish_open+0x40/0x50
[ 1409.219180]        [<ffffffff811cb0e7>] do_last+0xbc7/0x1370
[ 1409.220102]        [<ffffffff811cb94e>] path_openat+0xbe/0x6a0
[ 1409.221019]        [<ffffffff811cc74a>] do_filp_open+0x3a/0x90
[ 1409.221928]        [<ffffffff811b9afe>] do_sys_open+0x12e/0x210
[ 1409.222836]        [<ffffffff811b9bfe>] SyS_open+0x1e/0x20
[ 1409.223739]        [<ffffffff8174eb64>] tracesys+0xdd/0xe2
[ 1409.224640] 
-> #0 (&bdev->bd_mutex){+.+.+.}:
[ 1409.226422]        [<ffffffff810aed36>] __lock_acquire+0x1786/0x1af0
[ 1409.227341]        [<ffffffff810af853>] lock_acquire+0x93/0x1c0
[ 1409.228258]        [<ffffffff81741df7>] mutex_lock_nested+0x77/0x400
[ 1409.229169]        [<ffffffff8112ff8f>] sysfs_blk_trace_attr_show+0x5f/0x1f0
[ 1409.230075]        [<ffffffff814c5c40>] dev_attr_show+0x20/0x60
[ 1409.230976]        [<ffffffff81241a38>] sysfs_seq_show+0xc8/0x160
[ 1409.231873]        [<ffffffff811e3d92>] traverse.isra.6+0xf2/0x260
[ 1409.232760]        [<ffffffff811e4521>] seq_read+0x3e1/0x450
[ 1409.233641]        [<ffffffff811ba648>] vfs_read+0x98/0x170
[ 1409.234512]        [<ffffffff811bb2f2>] SyS_pread64+0x72/0xb0
[ 1409.235377]        [<ffffffff8174eb64>] tracesys+0xdd/0xe2
[ 1409.236227] 
other info that might help us debug this:

[ 1409.238688] Chain exists of:
  &bdev->bd_mutex --> &mm->mmap_sem --> &of->mutex

[ 1409.241077]  Possible unsafe locking scenario:

[ 1409.242651]        CPU0                    CPU1
[ 1409.243445]        ----                    ----
[ 1409.244227]   lock(&of->mutex);
[ 1409.244998]                                lock(&mm->mmap_sem);
[ 1409.245782]                                lock(&of->mutex);
[ 1409.246555]   lock(&bdev->bd_mutex);
[ 1409.247323] 
 *** DEADLOCK ***

[ 1409.249561] 3 locks held by trinity-child3/25324:
[ 1409.250317]  #0:  (&p->lock){+.+.+.}, at: [<ffffffff811e417d>] seq_read+0x3d/0x450
[ 1409.251109]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff812419ef>] sysfs_seq_show+0x7f/0x160
[ 1409.251914]  #2:  (s_active#220){.+.+.+}, at: [<ffffffff812419f8>] sysfs_seq_show+0x88/0x160
[ 1409.252739] 
stack backtrace:
[ 1409.254328] CPU: 3 PID: 25324 Comm: trinity-child3 Not tainted 3.13.0-rc2+ #15
[ 1409.256043]  ffffffff824d17c0 ffff880228549bd0 ffffffff8173bd22 ffffffff824ca190
[ 1409.256934]  ffff880228549c10 ffffffff817380bd ffff880228549c60 ffff88007b035eb8
[ 1409.257831]  ffff88007b035740 0000000000000002 0000000000000003 ffff88007b035ef0
[ 1409.258732] Call Trace:
[ 1409.259616]  [<ffffffff8173bd22>] dump_stack+0x4e/0x7a
[ 1409.260519]  [<ffffffff817380bd>] print_circular_bug+0x200/0x20f
[ 1409.261426]  [<ffffffff810aed36>] __lock_acquire+0x1786/0x1af0
[ 1409.262334]  [<ffffffff810af853>] lock_acquire+0x93/0x1c0
[ 1409.263245]  [<ffffffff8112ff8f>] ? sysfs_blk_trace_attr_show+0x5f/0x1f0
[ 1409.264165]  [<ffffffff8112ff8f>] ? sysfs_blk_trace_attr_show+0x5f/0x1f0
[ 1409.265072]  [<ffffffff81741df7>] mutex_lock_nested+0x77/0x400
[ 1409.265982]  [<ffffffff8112ff8f>] ? sysfs_blk_trace_attr_show+0x5f/0x1f0
[ 1409.266891]  [<ffffffff8112ff8f>] ? sysfs_blk_trace_attr_show+0x5f/0x1f0
[ 1409.267790]  [<ffffffff8112ff8f>] sysfs_blk_trace_attr_show+0x5f/0x1f0
[ 1409.268691]  [<ffffffff814c5c40>] dev_attr_show+0x20/0x60
[ 1409.269589]  [<ffffffff8124163d>] ? sysfs_file_ops+0x5d/0x80
[ 1409.270493]  [<ffffffff81241a38>] sysfs_seq_show+0xc8/0x160
[ 1409.271403]  [<ffffffff811e3d92>] traverse.isra.6+0xf2/0x260
[ 1409.272308]  [<ffffffff811e4521>] seq_read+0x3e1/0x450
[ 1409.273212]  [<ffffffff811ba648>] vfs_read+0x98/0x170
[ 1409.274113]  [<ffffffff811bb2f2>] SyS_pread64+0x72/0xb0
[ 1409.275017]  [<ffffffff8174eb64>] tracesys+0xdd/0xe2

