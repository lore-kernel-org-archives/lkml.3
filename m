Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaCABO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 20:14:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45970 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaCABO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 20:14:57 -0500
Message-ID: <53113485.2090407@oracle.com>
Date: Fri, 28 Feb 2014 20:14:45 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: kernfs: possible deadlock between of->mutex and mmap_sem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've stumbled on the following while fuzzing with trinity inside a KVM tools running the latest 
-next kernel.

We deal with files that have an mmap op by giving them a different locking class than the files 
which don't due to mmap_sem nesting being different for those files.

We assume that for mmap supporting files, of->mutex will be nested inside mm->mmap_sem. However, 
this is not always the case. Consider the following:

	kernfs_fop_write()
		copy_from_user()
			might_fault()

might_fault() suggests that we may lock mm->mmap_sem, which causes a reverse lock nesting of 
mm->mmap_sem inside of of->mutex.

I'll send a patch to fix it some time next week unless someone beats me to it :)


[ 1182.846501] ======================================================
[ 1182.847256] [ INFO: possible circular locking dependency detected ]
[ 1182.848111] 3.14.0-rc4-next-20140228-sasha-00011-g4077c67-dirty #26 Tainted: G        W
[ 1182.849088] -------------------------------------------------------
[ 1182.849927] trinity-c236/10658 is trying to acquire lock:
[ 1182.850094]  (&of->mutex#2){+.+.+.}, at: [<fs/kernfs/file.c:487>] kernfs_fop_mmap+0x54/0x120
[ 1182.850094]
[ 1182.850094] but task is already holding lock:
[ 1182.850094]  (&mm->mmap_sem){++++++}, at: [<mm/util.c:397>] vm_mmap_pgoff+0x6e/0xe0
[ 1182.850094]
[ 1182.850094] which lock already depends on the new lock.
[ 1182.850094]
[ 1182.850094]
[ 1182.850094] the existing dependency chain (in reverse order) is:
[ 1182.850094]
-> #1 (&mm->mmap_sem){++++++}:
[ 1182.856968]        [<kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131>] 
validate_chain+0x6c5/0x7b0
[ 1182.856968]        [<kernel/locking/lockdep.c:3182>] __lock_acquire+0x4cd/0x5a0
[ 1182.856968]        [<arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602>] 
lock_acquire+0x182/0x1d0
[ 1182.856968]        [<mm/memory.c:4188>] might_fault+0x7e/0xb0
[ 1182.860975]        [<arch/x86/include/asm/uaccess.h:713 fs/kernfs/file.c:291>] 
kernfs_fop_write+0xd8/0x190
[ 1182.860975]        [<fs/read_write.c:473>] vfs_write+0xe3/0x1d0
[ 1182.860975]        [<fs/read_write.c:523 fs/read_write.c:515>] SyS_write+0x5d/0xa0
[ 1182.860975]        [<arch/x86/kernel/entry_64.S:749>] tracesys+0xdd/0xe2
[ 1182.860975]
-> #0 (&of->mutex#2){+.+.+.}:
[ 1182.860975]        [<kernel/locking/lockdep.c:1840>] check_prev_add+0x13f/0x560
[ 1182.860975]        [<kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131>] 
validate_chain+0x6c5/0x7b0
[ 1182.860975]        [<kernel/locking/lockdep.c:3182>] __lock_acquire+0x4cd/0x5a0
[ 1182.860975]        [<arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602>] 
lock_acquire+0x182/0x1d0
[ 1182.860975]        [<kernel/locking/mutex.c:470 kernel/locking/mutex.c:571>] 
mutex_lock_nested+0x6a/0x510
[ 1182.860975]        [<fs/kernfs/file.c:487>] kernfs_fop_mmap+0x54/0x120
[ 1182.860975]        [<mm/mmap.c:1573>] mmap_region+0x310/0x5c0
[ 1182.860975]        [<mm/mmap.c:1365>] do_mmap_pgoff+0x385/0x430
[ 1182.860975]        [<mm/util.c:399>] vm_mmap_pgoff+0x8f/0xe0
[ 1182.860975]        [<mm/mmap.c:1416 mm/mmap.c:1374>] SyS_mmap_pgoff+0x1b0/0x210
[ 1182.860975]        [<arch/x86/kernel/sys_x86_64.c:72>] SyS_mmap+0x1d/0x20
[ 1182.860975]        [<arch/x86/kernel/entry_64.S:749>] tracesys+0xdd/0xe2
[ 1182.860975]
[ 1182.860975] other info that might help us debug this:
[ 1182.860975]
[ 1182.860975]  Possible unsafe locking scenario:
[ 1182.860975]
[ 1182.860975]        CPU0                    CPU1
[ 1182.860975]        ----                    ----
[ 1182.860975]   lock(&mm->mmap_sem);
[ 1182.860975]                                lock(&of->mutex#2);
[ 1182.860975]                                lock(&mm->mmap_sem);
[ 1182.860975]   lock(&of->mutex#2);
[ 1182.860975]
[ 1182.860975]  *** DEADLOCK ***
[ 1182.860975]
[ 1182.860975] 1 lock held by trinity-c236/10658:
[ 1182.860975]  #0:  (&mm->mmap_sem){++++++}, at: [<mm/util.c:397>] vm_mmap_pgoff+0x6e/0xe0
[ 1182.860975]
[ 1182.860975] stack backtrace:
[ 1182.860975] CPU: 2 PID: 10658 Comm: trinity-c236 Tainted: G        W 
3.14.0-rc4-next-20140228-sasha-00011-g4077c67-dirty #26
[ 1182.860975]  0000000000000000 ffff88011911fa48 ffffffff8438e945 0000000000000000
[ 1182.860975]  0000000000000000 ffff88011911fa98 ffffffff811a0109 ffff88011911fab8
[ 1182.860975]  ffff88011911fab8 ffff88011911fa98 ffff880119128cc0 ffff880119128cf8
[ 1182.860975] Call Trace:
[ 1182.860975]  [<lib/dump_stack.c:52>] dump_stack+0x52/0x7f
[ 1182.860975]  [<kernel/locking/lockdep.c:1213>] print_circular_bug+0x129/0x160
[ 1182.860975]  [<kernel/locking/lockdep.c:1840>] check_prev_add+0x13f/0x560
[ 1182.860975]  [<include/linux/spinlock.h:343 mm/slub.c:1933>] ? deactivate_slab+0x511/0x550
[ 1182.860975]  [<kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131>] 
validate_chain+0x6c5/0x7b0
[ 1182.860975]  [<kernel/locking/lockdep.c:3182>] __lock_acquire+0x4cd/0x5a0
[ 1182.860975]  [<mm/mmap.c:1552>] ? mmap_region+0x24a/0x5c0
[ 1182.860975]  [<arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602>] 
lock_acquire+0x182/0x1d0
[ 1182.860975]  [<fs/kernfs/file.c:487>] ? kernfs_fop_mmap+0x54/0x120
[ 1182.860975]  [<kernel/locking/mutex.c:470 kernel/locking/mutex.c:571>] mutex_lock_nested+0x6a/0x510
[ 1182.860975]  [<fs/kernfs/file.c:487>] ? kernfs_fop_mmap+0x54/0x120
[ 1182.860975]  [<kernel/sched/core.c:2477>] ? get_parent_ip+0x11/0x50
[ 1182.860975]  [<fs/kernfs/file.c:487>] ? kernfs_fop_mmap+0x54/0x120
[ 1182.860975]  [<fs/kernfs/file.c:487>] kernfs_fop_mmap+0x54/0x120
[ 1182.860975]  [<mm/mmap.c:1573>] mmap_region+0x310/0x5c0
[ 1182.860975]  [<mm/mmap.c:1365>] do_mmap_pgoff+0x385/0x430
[ 1182.860975]  [<mm/util.c:397>] ? vm_mmap_pgoff+0x6e/0xe0
[ 1182.860975]  [<mm/util.c:399>] vm_mmap_pgoff+0x8f/0xe0
[ 1182.860975]  [<kernel/rcu/update.c:97>] ? __rcu_read_unlock+0x44/0xb0
[ 1182.860975]  [<fs/file.c:641>] ? dup_fd+0x3c0/0x3c0
[ 1182.860975]  [<mm/mmap.c:1416 mm/mmap.c:1374>] SyS_mmap_pgoff+0x1b0/0x210
[ 1182.860975]  [<arch/x86/kernel/sys_x86_64.c:72>] SyS_mmap+0x1d/0x20
[ 1182.860975]  [<arch/x86/kernel/entry_64.S:749>] tracesys+0xdd/0xe2


Thanks,
Sasha
