Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3KOBTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 20:19:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab3KOBT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 20:19:27 -0500
Date: Thu, 14 Nov 2013 20:19:16 -0500
From: Dave Jones <davej@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sysfs_bin_mmap lockdep trace.
Message-ID: <20131115011916.GA19453@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20131113184538.GA7269@redhat.com>
 <20131113201043.GE13318@ZenIV.linux.org.uk>
 <20131114054116.GC29031@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114054116.GC29031@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 02:41:16PM +0900, Tejun Heo wrote:
 > hey,
 > 
 > On Wed, Nov 13, 2013 at 08:10:43PM +0000, Al Viro wrote:
 > > On Wed, Nov 13, 2013 at 01:45:38PM -0500, Dave Jones wrote:
 > > > Al, is this one also known ? Also seen on v3.12-7033-g42a2d923cc34
 > > 
 > > Umm...  I've seen something like that reported after sysfs merge went in
 > > (right after 3.12), but I hadn't looked into details.
 > > 
 > > > -> #3 (&mm->mmap_sem){++++++}:
 > > 
 > > 	[sr_block_ioctl() grabs sr_mutex and does copy_from_user() under it]
 > > 
 > > > -> #2 (sr_mutex){+.+.+.}:
 > > 	[sr_block_open() grabs sr_mutex under ->bd_mutex]
 > > 
 > > > -> #1 (&bdev->bd_mutex){+.+.+.}:
 > > 	[sysfs_blk_trace_attr_show() grabs ->bd_mutex and is called under
 > > sysfs_open_file ->mutex]
 > > 
 > > > -> #0 (&of->mutex){+.+.+.}:
 > > 	[sysfs_open_file ->mutex is grabbed by ->mmap()]
 > > 
 > > Cute...  AFAICS, it came from "sysfs: copy bin mmap support from fs/sysfs/bin.c
 > > to fs/sysfs/file.c".  The first impression is that sysfs_bin_mmap() is
 > > checking for battr->mmap too late, but I'm not sure whether we need of->mutex
 > > to stabilize it...  Tejun, any comments?
 > 
 > Hmmm... so this is a false positive from regular and bin file paths
 > being merged.  There was a sysfs regular file which grabbed sr_mutex
 > while holding sysfs mutex and only bin files supported mmap which of
 > course nest under mmap_sem.  As the two paths were separate and using
 > separate locks, this deadlock scenario didn't trigger.  Now that the
 > two paths are merged, lockdep considers the two paths to be using the
 > same mutex (they're per-file so still actually separate) and generates
 > this warning.  The easiest way out would be giving different lock
 > subclasses to files w/ and w/o mmap method.  I'll think more about it.

Tejun,

Is this another variant of the above, or something different ?

	Dave


[  218.248982] ======================================================
[  218.249006] [ INFO: possible circular locking dependency detected ]
[  218.249031] 3.12.0+ #8 Not tainted
[  218.249607] -------------------------------------------------------
[  218.250194] trinity-child1/2100 is trying to acquire lock:
[  218.250784]  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff8112f89f>] sysfs_blk_trace_attr_show+0x5f/0x1f0
[  218.251408] 
but task is already holding lock:
[  218.252615]  (&of->mutex){+.+.+.}, at: [<ffffffff8124083f>] sysfs_seq_show+0x7f/0x160
[  218.253249] 
which lock already depends on the new lock.

[  218.255178] 
the existing dependency chain (in reverse order) is:
[  218.256480] 
-> #3 (&of->mutex){+.+.+.}:
[  218.257853]        [<ffffffff810af623>] lock_acquire+0x93/0x1c0
[  218.258557]        [<ffffffff81725f67>] mutex_lock_nested+0x77/0x400
[  218.259263]        [<ffffffff8123ffef>] sysfs_bin_mmap+0x4f/0x120
[  218.259900]        [<ffffffff81182695>] mmap_region+0x3e5/0x5d0
[  218.260526]        [<ffffffff81182bd7>] do_mmap_pgoff+0x357/0x3e0
[  218.261149]        [<ffffffff8116d150>] vm_mmap_pgoff+0x90/0xc0
[  218.261765]        [<ffffffff81181125>] SyS_mmap_pgoff+0x1d5/0x270
[  218.262374]        [<ffffffff81007ec2>] SyS_mmap+0x22/0x30
[  218.262983]        [<ffffffff81732ce4>] tracesys+0xdd/0xe2
[  218.263581] 
-> #2 (&mm->mmap_sem){++++++}:
[  218.264853]        [<ffffffff810af623>] lock_acquire+0x93/0x1c0
[  218.265464]        [<ffffffff8117762c>] might_fault+0x8c/0xb0
[  218.266114]        [<ffffffff81302ed5>] scsi_cmd_ioctl+0x295/0x470
[  218.266760]        [<ffffffff813030f2>] scsi_cmd_blk_ioctl+0x42/0x50
[  218.267405]        [<ffffffff8150b5e1>] cdrom_ioctl+0x41/0x1050
[  218.268056]        [<ffffffff814de69f>] sr_block_ioctl+0x6f/0xd0
[  218.268724]        [<ffffffff812fede4>] blkdev_ioctl+0x234/0x840
[  218.269373]        [<ffffffff811faa27>] block_ioctl+0x47/0x50
[  218.270011]        [<ffffffff811ce4f0>] do_vfs_ioctl+0x300/0x520
[  218.270651]        [<ffffffff811ce791>] SyS_ioctl+0x81/0xa0
[  218.271282]        [<ffffffff81732ce4>] tracesys+0xdd/0xe2
[  218.271913] 
-> #1 (sr_mutex){+.+.+.}:
[  218.273153]        [<ffffffff810af623>] lock_acquire+0x93/0x1c0
[  218.273795]        [<ffffffff81725f67>] mutex_lock_nested+0x77/0x400
[  218.274443]        [<ffffffff814ded34>] sr_block_open+0x24/0x130
[  218.275084]        [<ffffffff811fb7f1>] __blkdev_get+0xd1/0x4c0
[  218.275707]        [<ffffffff811fbdc5>] blkdev_get+0x1e5/0x380
[  218.276314]        [<ffffffff811fc01a>] blkdev_open+0x6a/0x90
[  218.276904]        [<ffffffff811b6f97>] do_dentry_open+0x1e7/0x340
[  218.277490]        [<ffffffff811b7200>] finish_open+0x40/0x50
[  218.278070]        [<ffffffff811ca207>] do_last+0xbc7/0x1370
[  218.278637]        [<ffffffff811caa6e>] path_openat+0xbe/0x6a0
[  218.279206]        [<ffffffff811cb7ca>] do_filp_open+0x3a/0x90
[  218.279718]        [<ffffffff811b8c1e>] do_sys_open+0x12e/0x210
[  218.280221]        [<ffffffff811b8d1e>] SyS_open+0x1e/0x20
[  218.280708]        [<ffffffff81732ce4>] tracesys+0xdd/0xe2
[  218.281184] 
-> #0 (&bdev->bd_mutex){+.+.+.}:
[  218.282109]        [<ffffffff810aec02>] __lock_acquire+0x1782/0x19f0
[  218.282622]        [<ffffffff810af623>] lock_acquire+0x93/0x1c0
[  218.283108]        [<ffffffff81725f67>] mutex_lock_nested+0x77/0x400
[  218.283582]        [<ffffffff8112f89f>] sysfs_blk_trace_attr_show+0x5f/0x1f0
[  218.284060]        [<ffffffff814b09f0>] dev_attr_show+0x20/0x60
[  218.284531]        [<ffffffff81240888>] sysfs_seq_show+0xc8/0x160
[  218.284997]        [<ffffffff811e2da2>] traverse.isra.6+0xf2/0x260
[  218.285468]        [<ffffffff811e3531>] seq_read+0x3e1/0x450
[  218.285929]        [<ffffffff811b9768>] vfs_read+0x98/0x170
[  218.286386]        [<ffffffff811ba412>] SyS_pread64+0x72/0xb0
[  218.286844]        [<ffffffff81732ce4>] tracesys+0xdd/0xe2
[  218.287299] 
other info that might help us debug this:

[  218.288691] Chain exists of:
  &bdev->bd_mutex --> &mm->mmap_sem --> &of->mutex

[  218.290060]  Possible unsafe locking scenario:

[  218.291013]        CPU0                    CPU1
[  218.291512]        ----                    ----
[  218.292003]   lock(&of->mutex);
[  218.292447]                                lock(&mm->mmap_sem);
[  218.292900]                                lock(&of->mutex);
[  218.293348]   lock(&bdev->bd_mutex);
[  218.293793] 
 *** DEADLOCK ***

[  218.295130] 3 locks held by trinity-child1/2100:
[  218.295615]  #0:  (&p->lock){+.+.+.}, at: [<ffffffff811e318d>] seq_read+0x3d/0x450
[  218.296068]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff8124083f>] sysfs_seq_show+0x7f/0x160
[  218.296555]  #2:  (s_active#113){.+.+.+}, at: [<ffffffff81240848>] sysfs_seq_show+0x88/0x160
[  218.297036] 
stack backtrace:
[  218.297952] CPU: 1 PID: 2100 Comm: trinity-child1 Not tainted 3.12.0+ #8 
[  218.299470]  ffffffff824ccc60 ffff8801bccabbd0 ffffffff8172017e ffffffff824c5c00
[  218.300013]  ffff8801bccabc10 ffffffff8171c51d ffff8801bccabc60 ffff8802411a0778
[  218.300571]  ffff8802411a0000 0000000000000002 0000000000000003 ffff8802411a07b0
[  218.301124] Call Trace:
[  218.301670]  [<ffffffff8172017e>] dump_stack+0x4e/0x7a
[  218.302227]  [<ffffffff8171c51d>] print_circular_bug+0x200/0x20f
[  218.302788]  [<ffffffff810aec02>] __lock_acquire+0x1782/0x19f0
[  218.303351]  [<ffffffff810af623>] lock_acquire+0x93/0x1c0
[  218.303916]  [<ffffffff8112f89f>] ? sysfs_blk_trace_attr_show+0x5f/0x1f0
[  218.304488]  [<ffffffff8112f89f>] ? sysfs_blk_trace_attr_show+0x5f/0x1f0
[  218.305051]  [<ffffffff81725f67>] mutex_lock_nested+0x77/0x400
[  218.305606]  [<ffffffff8112f89f>] ? sysfs_blk_trace_attr_show+0x5f/0x1f0
[  218.306165]  [<ffffffff8112f89f>] ? sysfs_blk_trace_attr_show+0x5f/0x1f0
[  218.306719]  [<ffffffff8112f89f>] sysfs_blk_trace_attr_show+0x5f/0x1f0
[  218.307268]  [<ffffffff814b09f0>] dev_attr_show+0x20/0x60
[  218.307837]  [<ffffffff8124048d>] ? sysfs_file_ops+0x5d/0x80
[  218.308389]  [<ffffffff81240888>] sysfs_seq_show+0xc8/0x160
[  218.308944]  [<ffffffff811e2da2>] traverse.isra.6+0xf2/0x260
[  218.309496]  [<ffffffff811e3531>] seq_read+0x3e1/0x450
[  218.310048]  [<ffffffff811b9768>] vfs_read+0x98/0x170
[  218.310601]  [<ffffffff811ba412>] SyS_pread64+0x72/0xb0
[  218.311157]  [<ffffffff81732ce4>] tracesys+0xdd/0xe2


