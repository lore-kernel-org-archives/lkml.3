Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbaCLCcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 22:32:35 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:36493 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbaCLCcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 22:32:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoZpAODGH1N5LJYePGdsb2JhbABRAQiDBjuDC6YdBJh7gRgXAwEBAQEfGQ0ogiUBAQEEOhwjEAgDGAklDwUlAwcaEQKHeNFJFo1rBVYHhDgEmESVbykE
Date: Wed, 12 Mar 2014 13:31:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <waiman.long@hp.com>, arnd@arndb.de,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com
Subject: Re: [RFC][PATCH 0/7] locking: qspinlock
Message-ID: <20140312023153.GW13647@dastard>
References: <20140310154236.038181843@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310154236.038181843@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 04:42:36PM +0100, Peter Zijlstra wrote:
> Hi Waiman,
> 
> I promised you this series a number of days ago; sorry for the delay I've been
> somewhat unwell :/
> 
> That said, these few patches start with a (hopefully) simple and correct form
> of the queue spinlock, and then gradually build upon it, explaining each
> optimization as we go.
> 
> Having these optimizations as separate patches helps twofold; firstly it makes
> one aware of which exact optimizations were done, and secondly it allows one to
> proove or disprove any one step; seeing how they should be mostly identity
> transforms.
> 
> The resulting code is near to what you posted I think; however it has one
> atomic op less in the pending wait-acquire case for NR_CPUS != huge. It also
> doesn't do lock stealing; its still perfectly fair afaict.
> 
> Have I missed any tricks from your code?
> 
> The patches apply to tip/master + lkml.kernel.org/r/20140210195820.834693028@infradead.org

FWIW, I saw this patchset referenced on LWN, and noted that the lock
contention that AIM7 saw was in the VFS and XFS in particular. So,
I pulled out my trusty "smash the VFS locks" test on a 16p VM. The
multithreaded bulkstat test *hammers* the inode cache. I've got a
filesystem with 51.2 million inodes in it, and it pegs all 16 CPUs
with this profile:

$ sudo time src/bstat -t -q /mnt/scratch
0.01user 2300.09system 2:28.13elapsed 1552%CPU (0avgtext+0avgdata 56268maxresident)k
0inputs+0outputs (12major+133515minor)pagefaults 0swaps
$
.....
  73.95%  [kernel]  [k] _raw_spin_lock
      + 48.65% evict
      + 48.21% inode_sb_list_add
      + 1.31% inode_wait_for_writeback
        0.51% __remove_inode_hash
           evict
           iput
           xfs_bulkstat_one_int
           xfs_bulkstat_one
           xfs_bulkstat
           xfs_ioc_bulkstat
           xfs_file_ioctl
           do_vfs_ioctl
           sys_ioctl
           system_call_fastpath
           __GI___ioctl
+   4.87%  [kernel]  [k] native_read_tsc
+   2.72%  [kernel]  [k] do_raw_spin_unlock
+   2.36%  [kernel]  [k] _xfs_buf_find
+   1.35%  [kernel]  [k] delay_tsc
+   1.29%  [kernel]  [k] __crc32c_le
+   1.19%  [kernel]  [k] __slab_alloc
+   0.93%  [kernel]  [k] xfs_setup_inode
+   0.73%  [kernel]  [k] _raw_spin_unlock_irqrestore

It's almost entirely spinlock contention on the inode list lock,
just like the AIM7 disk test that was referenced here:

http://lwn.net/Articles/590268/


With the queuing spinlock, I expected to see somewhat better
results, but I didn't at first. Turns out if you have any sort of
lock debugging turned on, then the code doesn't ever go into the
lock slow path and hence does not ever enter the "lock failed" slow
path where all the contention fixes are supposed to be.

Anyway, with all lock debugging turned off, the system hangs
the instant I start the multithreaded bulkstat workload. Even the
console is unrepsonsive. I did get a partial task trace, indicating
everything was locked up on the contended lock:

[   64.992006] bstat           R  running task     5128  4488   4397 0x0000000a
[   64.992006]  ffff88041b385a18 ffffffff81ce6c81 ffff88041b385a38 ffffffff811bee8d
[   64.992006]  ffff88041b385a58 ffff8800b8527000 ffff88041b385a58 ffffffff814a0854
[   64.992006]  0000002c80004321 ffff8800b8527000 ffff88041b385b08 ffffffff8149998c
[   64.992006] Call Trace:
[   64.992006]  [<ffffffff81ce6c81>] ? _raw_spin_lock+0x21/0x30
[   64.992006]  [<ffffffff811bee8d>] inode_sb_list_add+0x1d/0x60
[   64.992006]  [<ffffffff814a0854>] xfs_setup_inode+0x34/0x310
[   64.992006]  [<ffffffff8149998c>] xfs_iget+0x4ec/0x750
[   64.992006]  [<ffffffff814a0b30>] ? xfs_setup_inode+0x310/0x310
[   64.992006]  [<ffffffff814a0cb7>] xfs_bulkstat_one_int+0xa7/0x340
[   64.992006]  [<ffffffff814a0f70>] xfs_bulkstat_one+0x20/0x30
[   64.992006]  [<ffffffff814a143c>] xfs_bulkstat+0x4bc/0xa10
[   64.992006]  [<ffffffff814a0f50>] ? xfs_bulkstat_one_int+0x340/0x340
[   64.992006]  [<ffffffff8149bdb0>] xfs_ioc_bulkstat+0xd0/0x1b0
[   64.992006]  [<ffffffff8149d114>] xfs_file_ioctl+0x3e4/0xae0
[   64.992006]  [<ffffffff81cea6fc>] ? __do_page_fault+0x1fc/0x4f0
[   64.992006]  [<ffffffff811b79e3>] do_vfs_ioctl+0x83/0x500
[   64.992006]  [<ffffffff811b7ef1>] SyS_ioctl+0x91/0xb0
[   64.992006]  [<ffffffff81cef652>] system_call_fastpath+0x16/0x1b

And the rest of the threads were in a cond_resched() right after the
code where the lock was taken in teh evict path:

[   64.992006] bstat           R  running task     4576  4493   4397 0x00000000
[   64.992006]  ffff880419c95a48 0000000000000082 ffff880419ec1820 0000000000012e00
[   64.992006]  ffff880419c95fd8 0000000000012e00 ffff880419509820 ffff880419ec1820
[   64.992006]  ffff880419c95a88 ffff8800b8a8a1a8 ffff8800b8a8a000 ffff8800b8a8a1a8
[   64.992006] Call Trace:
[   64.992006]  [<ffffffff81ce3099>] _cond_resched+0x29/0x40
[   64.992006]  [<ffffffff811be526>] clear_inode+0x16/0x70
[   64.992006]  [<ffffffff814a59e9>] xfs_fs_evict_inode+0x59/0xf0
[   64.992006]  [<ffffffff811bf96f>] evict+0xaf/0x1b0
[   64.992006]  [<ffffffff811c00d3>] iput+0x103/0x190
[   64.992006]  [<ffffffff814a0b30>] ? xfs_setup_inode+0x310/0x310
[   64.992006]  [<ffffffff814a0e97>] xfs_bulkstat_one_int+0x287/0x340
[   64.992006]  [<ffffffff814a0f70>] xfs_bulkstat_one+0x20/0x30
[   64.992006]  [<ffffffff814a143c>] xfs_bulkstat+0x4bc/0xa10
[   64.992006]  [<ffffffff814a0f50>] ? xfs_bulkstat_one_int+0x340/0x340
[   64.992006]  [<ffffffff8149bdb0>] xfs_ioc_bulkstat+0xd0/0x1b0
[   64.992006]  [<ffffffff8149d114>] xfs_file_ioctl+0x3e4/0xae0
[   64.992006]  [<ffffffff81cea6fc>] ? __do_page_fault+0x1fc/0x4f0
[   64.992006]  [<ffffffff811b79e3>] do_vfs_ioctl+0x83/0x500
[   64.992006]  [<ffffffff811b7ef1>] SyS_ioctl+0x91/0xb0
[   64.992006]  [<ffffffff81cef652>] system_call_fastpath+0x16/0x1b

So either this patchset doesn't work right now, or there's something
else broken in the tip/master tree...

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com
