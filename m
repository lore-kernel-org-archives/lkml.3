Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab3LCVPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:15:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab3LCVPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:15:33 -0500
Date: Tue, 3 Dec 2013 16:15:15 -0500
From: Dave Jones <davej@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org
Subject: Re: sysfs: use a separate locking class for open files depending on
 mmap
Message-ID: <20131203211515.GA17951@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	gregkh@linuxfoundation.org
References: <20131128051223.45739660885@gitolite.kernel.org>
 <20131203184324.GA11320@redhat.com>
 <20131203211028.GN8277@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203211028.GN8277@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 04:10:28PM -0500, Tejun Heo wrote:
 > Hello, Dave.
 > 
 > On Tue, Dec 03, 2013 at 01:43:24PM -0500, Dave Jones wrote:
 > >  > +	/*
 > >  > +	 * The following is done to give a different lockdep key to
 > >  > +	 * @of->mutex for files which implement mmap.  This is a rather
 > >  > +	 * crude way to avoid false positive lockdep warning around
 > >  > +	 * mm->mmap_sem - mmap nests @of->mutex under mm->mmap_sem and
 > >  > +	 * reading /sys/block/sda/trace/act_mask grabs sr_mutex, under
 > >  > +	 * which mm->mmap_sem nests, while holding @of->mutex.  As each
 > >  > +	 * open file has a separate mutex, it's okay as long as those don't
 > >  > +	 * happen on the same file.  At this point, we can't easily give
 > >  > +	 * each file a separate locking class.  Let's differentiate on
 > >  > +	 * whether the file has mmap or not for now.
 > >  > +	 */
 > >  > +	if (has_mmap)
 > >  > +		mutex_init(&of->mutex);
 > >  > +	else
 > >  > +		mutex_init(&of->mutex);
 > >  > +
 > >  
 > > Somehow I just triggered this trace again, even with this commit applied.
 > > The trace is pretty much identical to the old one.
 > 
 > Hah, ain't that weird.  That's the trace you reported on the other
 > mail, right?  I'll follow up on that one.

just so there's no doubt, here's a fresh one.

[ 1396.487831] ======================================================
[ 1396.487852] [ INFO: possible circular locking dependency detected ]
[ 1396.487879] 3.13.0-rc2+ #15 Not tainted
[ 1396.487894] -------------------------------------------------------
[ 1396.487915] trinity-child0/24146 is trying to acquire lock:
[ 1396.487935]  (&of->mutex){+.+.+.}, at: [<ffffffff8124119f>] sysfs_bin_mmap+0x4f/0x120
[ 1396.487971] 
but task is already holding lock:
[ 1396.487991]  (&mm->mmap_sem){++++++}, at: [<ffffffff8116e07f>] vm_mmap_pgoff+0x6f/0xc0
[ 1396.488027] 
which lock already depends on the new lock.

[ 1396.488054] 
the existing dependency chain (in reverse order) is:
[ 1396.488079] 
-> #3 (&mm->mmap_sem){++++++}:
[ 1396.488104]        [<ffffffff810af853>] lock_acquire+0x93/0x1c0
[ 1396.488127]        [<ffffffff8117854c>] might_fault+0x8c/0xb0
[ 1396.488150]        [<ffffffff81304505>] scsi_cmd_ioctl+0x295/0x470
[ 1396.488174]        [<ffffffff81304722>] scsi_cmd_blk_ioctl+0x42/0x50
[ 1396.488198]        [<ffffffff81520961>] cdrom_ioctl+0x41/0x1050
[ 1396.488221]        [<ffffffff814f390f>] sr_block_ioctl+0x6f/0xd0
[ 1396.488245]        [<ffffffff81300414>] blkdev_ioctl+0x234/0x840
[ 1396.488268]        [<ffffffff811fba67>] block_ioctl+0x47/0x50
[ 1396.488292]        [<ffffffff811cf470>] do_vfs_ioctl+0x300/0x520
[ 1396.488315]        [<ffffffff811cf711>] SyS_ioctl+0x81/0xa0
[ 1396.488337]        [<ffffffff8174eb64>] tracesys+0xdd/0xe2
[ 1396.488359] 
-> #2 (sr_mutex){+.+.+.}:
[ 1396.488384]        [<ffffffff810af853>] lock_acquire+0x93/0x1c0
[ 1396.489088]        [<ffffffff81741df7>] mutex_lock_nested+0x77/0x400
[ 1396.489794]        [<ffffffff814f3fa4>] sr_block_open+0x24/0x130
[ 1396.490496]        [<ffffffff811fc831>] __blkdev_get+0xd1/0x4c0
[ 1396.491200]        [<ffffffff811fce05>] blkdev_get+0x1e5/0x380
[ 1396.491892]        [<ffffffff811fd05a>] blkdev_open+0x6a/0x90
[ 1396.492566]        [<ffffffff811b7e77>] do_dentry_open+0x1e7/0x340
[ 1396.493235]        [<ffffffff811b80e0>] finish_open+0x40/0x50
[ 1396.493910]        [<ffffffff811cb0e7>] do_last+0xbc7/0x1370
[ 1396.494579]        [<ffffffff811cb94e>] path_openat+0xbe/0x6a0
[ 1396.495244]        [<ffffffff811cc74a>] do_filp_open+0x3a/0x90
[ 1396.495905]        [<ffffffff811b9afe>] do_sys_open+0x12e/0x210
[ 1396.496564]        [<ffffffff811b9bfe>] SyS_open+0x1e/0x20
[ 1396.497219]        [<ffffffff8174eb64>] tracesys+0xdd/0xe2
[ 1396.497869] 
-> #1 (&bdev->bd_mutex){+.+.+.}:
[ 1396.499153]        [<ffffffff810af853>] lock_acquire+0x93/0x1c0
[ 1396.499808]        [<ffffffff81741df7>] mutex_lock_nested+0x77/0x400
[ 1396.500462]        [<ffffffff8112ff8f>] sysfs_blk_trace_attr_show+0x5f/0x1f0
[ 1396.501118]        [<ffffffff814c5c40>] dev_attr_show+0x20/0x60
[ 1396.501776]        [<ffffffff81241a38>] sysfs_seq_show+0xc8/0x160
[ 1396.502433]        [<ffffffff811e42a4>] seq_read+0x164/0x450
[ 1396.503085]        [<ffffffff811ba648>] vfs_read+0x98/0x170
[ 1396.503735]        [<ffffffff811bb18c>] SyS_read+0x4c/0xa0
[ 1396.504378]        [<ffffffff8174eb64>] tracesys+0xdd/0xe2
[ 1396.505021] 
-> #0 (&of->mutex){+.+.+.}:
[ 1396.506286]        [<ffffffff810aed36>] __lock_acquire+0x1786/0x1af0
[ 1396.506939]        [<ffffffff810af853>] lock_acquire+0x93/0x1c0
[ 1396.507589]        [<ffffffff81741df7>] mutex_lock_nested+0x77/0x400
[ 1396.508236]        [<ffffffff8124119f>] sysfs_bin_mmap+0x4f/0x120
[ 1396.508883]        [<ffffffff811835b5>] mmap_region+0x3e5/0x5d0
[ 1396.509526]        [<ffffffff81183af7>] do_mmap_pgoff+0x357/0x3e0
[ 1396.510158]        [<ffffffff8116e0a0>] vm_mmap_pgoff+0x90/0xc0
[ 1396.510790]        [<ffffffff81182045>] SyS_mmap_pgoff+0x1d5/0x270
[ 1396.511417]        [<ffffffff81007ed2>] SyS_mmap+0x22/0x30
[ 1396.512041]        [<ffffffff8174eb64>] tracesys+0xdd/0xe2
[ 1396.512657] 
other info that might help us debug this:

[ 1396.514444] Chain exists of:
  &of->mutex --> sr_mutex --> &mm->mmap_sem

[ 1396.516191]  Possible unsafe locking scenario:

[ 1396.517326]        CPU0                    CPU1
[ 1396.517894]        ----                    ----
[ 1396.518461]   lock(&mm->mmap_sem);
[ 1396.519024]                                lock(sr_mutex);
[ 1396.519591]                                lock(&mm->mmap_sem);
[ 1396.520158]   lock(&of->mutex);
[ 1396.520711] 
 *** DEADLOCK ***

[ 1396.522339] 1 lock held by trinity-child0/24146:
[ 1396.522887]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8116e07f>] vm_mmap_pgoff+0x6f/0xc0
[ 1396.523463] 
stack backtrace:
[ 1396.524579] CPU: 0 PID: 24146 Comm: trinity-child0 Not tainted 3.13.0-rc2+ #15 
[ 1396.525796]  ffffffff824a7960 ffff8802161d9bc0 ffffffff8173bd22 ffffffff824d19b0
[ 1396.526427]  ffff8802161d9c00 ffffffff817380bd ffff8802161d9c50 ffff8802406a5e80
[ 1396.527061]  ffff8802406a5740 0000000000000001 0000000000000001 ffff8802406a5e80
[ 1396.527702] Call Trace:
[ 1396.528327]  [<ffffffff8173bd22>] dump_stack+0x4e/0x7a
[ 1396.528962]  [<ffffffff817380bd>] print_circular_bug+0x200/0x20f
[ 1396.529594]  [<ffffffff810aed36>] __lock_acquire+0x1786/0x1af0
[ 1396.530228]  [<ffffffff81183510>] ? mmap_region+0x340/0x5d0
[ 1396.530864]  [<ffffffff810ad05b>] ? mark_held_locks+0xbb/0x140
[ 1396.531506]  [<ffffffff810af853>] lock_acquire+0x93/0x1c0
[ 1396.532144]  [<ffffffff8124119f>] ? sysfs_bin_mmap+0x4f/0x120
[ 1396.532787]  [<ffffffff8124119f>] ? sysfs_bin_mmap+0x4f/0x120
[ 1396.533423]  [<ffffffff81741df7>] mutex_lock_nested+0x77/0x400
[ 1396.534057]  [<ffffffff8124119f>] ? sysfs_bin_mmap+0x4f/0x120
[ 1396.534694]  [<ffffffff8124119f>] ? sysfs_bin_mmap+0x4f/0x120
[ 1396.535329]  [<ffffffff8124119f>] sysfs_bin_mmap+0x4f/0x120
[ 1396.535963]  [<ffffffff811835b5>] mmap_region+0x3e5/0x5d0
[ 1396.536599]  [<ffffffff81183af7>] do_mmap_pgoff+0x357/0x3e0
[ 1396.537234]  [<ffffffff8116e0a0>] vm_mmap_pgoff+0x90/0xc0
[ 1396.537868]  [<ffffffff81182045>] SyS_mmap_pgoff+0x1d5/0x270
[ 1396.538497]  [<ffffffff81010a45>] ? syscall_trace_enter+0x145/0x2a0
[ 1396.539131]  [<ffffffff81007ed2>] SyS_mmap+0x22/0x30
[ 1396.539759]  [<ffffffff8174eb64>] tracesys+0xdd/0xe2


