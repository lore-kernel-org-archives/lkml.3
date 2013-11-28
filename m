Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab3K1EaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:30:24 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33577 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab3K1EaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:30:21 -0500
MIME-Version: 1.0
In-Reply-To: <20131128041128.GA30156@kroah.com>
References: <CAJn8CcEerEFMQTs6GQK2htgAD3SJmaS_dLgwV006jTO6ce8Hdw@mail.gmail.com>
	<20131128041128.GA30156@kroah.com>
Date: Thu, 28 Nov 2013 12:30:19 +0800
Message-ID: <CAJn8CcE=y6GiRL_Z01Hzv-y93NJO4AxzjHcFOH7=_WNFuZig6g@mail.gmail.com>
Subject: Re: page fault deadlock
From: Xiaotian Feng <xtfeng@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        neilb@suse.de, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 12:11 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 28, 2013 at 11:25:32AM +0800, Xiaotian Feng wrote:
>> Hi,
>>
>>     When I upgrade to latest kernel, I found my system hang there. It
>> is reproducible on my virtualbox, and I found each time I mounted my
>> RAID6 partition and tried to vi or build kernel, my whole system
>> lockup very soon.
>>
>>     After turning on lockdep, I found following lockdep warning:
>>
>> [   27.848462]
>> [   27.848471] ======================================================
>> [   27.848477] [ INFO: possible circular locking dependency detected ]
>> [   27.848484] 3.13.0-rc1+ #1 Tainted: GF       W
>> [   27.848490] -------------------------------------------------------
>> [   27.848496] Xorg/1268 is trying to acquire lock:
>> [   27.848501]  (&of->mutex){+.+.+.}, at: [<ffffffff8125d58f>]
>> sysfs_bin_mmap+0x4f/0x120
>> [   27.848516]
>> [   27.848516] but task is already holding lock:
>> [   27.848521]  (&mm->mmap_sem){++++++}, at: [<ffffffff811875bf>]
>> vm_mmap_pgoff+0x6f/0xc0
>> [   27.848534]
>> [   27.848534] which lock already depends on the new lock.
>> [   27.848534]
>> [   27.848541]
>> [   27.848541] the existing dependency chain (in reverse order) is:
>> [   27.848547]
>> [   27.848547] -> #2 (&mm->mmap_sem){++++++}:
>> [   27.848556]        [<ffffffff810c0510>] lock_acquire+0xb0/0x160
>> [   27.848564]        [<ffffffff8119177c>] might_fault+0x8c/0xb0
>> [   27.848572]        [<ffffffff815f4c08>] md_ioctl+0xa78/0x19b0
>> [   27.848580]        [<ffffffff813915a4>] blkdev_ioctl+0x234/0x840
>> [   27.848588]        [<ffffffff8121db61>] block_ioctl+0x41/0x50
>> [   27.848597]        [<ffffffff811f5330>] do_vfs_ioctl+0x300/0x520
>> [   27.848605]        [<ffffffff811f55d1>] SyS_ioctl+0x81/0xa0
>> [   27.848613]        [<ffffffff81784e98>] tracesys+0xe1/0xe6
>> [   27.848622]
>> [   27.848622] -> #1 (&mddev->reconfig_mutex){+.+.+.}:
>> [   27.848630]        [<ffffffff810c0510>] lock_acquire+0xb0/0x160
>> [   27.848637]        [<ffffffff81778568>]
>> mutex_lock_interruptible_nested+0x78/0x610
>> [   27.848646]        [<ffffffff815e9750>] rdev_attr_show+0x40/0x90
>> [   27.848654]        [<ffffffff8125db2a>] sysfs_seq_show+0xda/0x170
>> [   27.848662]        [<ffffffff812076f4>] seq_read+0x164/0x3e0
>> [   27.848671]        [<ffffffff811e1005>] vfs_read+0x95/0x160
>> [   27.848680]        [<ffffffff811e1b19>] SyS_read+0x49/0xa0
>> [   27.848687]        [<ffffffff81784e98>] tracesys+0xe1/0xe6
>> [   27.848695]
>> [   27.848695] -> #0 (&of->mutex){+.+.+.}:
>> [   27.848703]        [<ffffffff810bfd47>] __lock_acquire+0x1587/0x1ca0
>> [   27.848711]        [<ffffffff810c0510>] lock_acquire+0xb0/0x160
>> [   27.848718]        [<ffffffff81778048>] mutex_lock_nested+0x68/0x510
>> [   27.848725]        [<ffffffff8125d58f>] sysfs_bin_mmap+0x4f/0x120
>> [   27.848732]        [<ffffffff8119d82d>] mmap_region+0x3ed/0x5d0
>> [   27.848741]        [<ffffffff8119dd5e>] do_mmap_pgoff+0x34e/0x3d0
>> [   27.848748]        [<ffffffff811875e0>] vm_mmap_pgoff+0x90/0xc0
>> [   27.848755]        [<ffffffff8119c2b5>] SyS_mmap_pgoff+0x1d5/0x270
>> [   27.848763]        [<ffffffff8101ae52>] SyS_mmap+0x22/0x30
>> [   27.848771]        [<ffffffff81784e98>] tracesys+0xe1/0xe6
>> [   27.848778]
>> [   27.848778] other info that might help us debug this:
>> [   27.848778]
>> [   27.848785] Chain exists of:
>> [   27.848785]   &of->mutex --> &mddev->reconfig_mutex --> &mm->mmap_sem
>> [   27.848785]
>> [   27.848795]  Possible unsafe locking scenario:
>> [   27.848795]
>> [   27.848800]        CPU0                    CPU1
>> [   27.848805]        ----                    ----
>> [   27.848810]   lock(&mm->mmap_sem);
>> [   27.848817]                                lock(&mddev->reconfig_mutex);
>> [   27.848824]                                lock(&mm->mmap_sem);
>> [   27.848830]   lock(&of->mutex);
>> [   27.848837]
>> [   27.848837]  *** DEADLOCK ***
>> [   27.848837]
>> [   27.848844] 1 lock held by Xorg/1268:
>> [   27.848849]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff811875bf>]
>> vm_mmap_pgoff+0x6f/0xc0
>> [   27.848861]
>> [   27.848861] stack backtrace:
>> [   27.848868] CPU: 1 PID: 1268 Comm: Xorg Tainted: GF       W    3.13.0-rc1+ #1
>> [   27.848873] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
>> VirtualBox 12/01/2006
>> [   27.848879]  ffffffff822daa00 ffff8800d0371bc8 ffffffff817725f7
>> ffffffff822cbdc0
>> [   27.848901]  ffff8800d0371c08 ffffffff8176d9eb ffff8800d0371c60
>> ffff880115b42a78
>> [   27.848909]  0000000000000000 ffff880115b42a78 ffff880115b422a0
>> 0000000000000001
>> [   27.848918] Call Trace:
>> [   27.848930]  [<ffffffff817725f7>] dump_stack+0x4e/0x7a
>> [   27.848942]  [<ffffffff8176d9eb>] print_circular_bug+0x1f9/0x208
>> [   27.848952]  [<ffffffff810bfd47>] __lock_acquire+0x1587/0x1ca0
>> [   27.848964]  [<ffffffff8101955f>] ? print_context_stack+0x8f/0x100
>> [   27.848975]  [<ffffffff810c0510>] lock_acquire+0xb0/0x160
>> [   27.848986]  [<ffffffff8125d58f>] ? sysfs_bin_mmap+0x4f/0x120
>> [   27.848996]  [<ffffffff8125d58f>] ? sysfs_bin_mmap+0x4f/0x120
>> [   27.849007]  [<ffffffff81778048>] mutex_lock_nested+0x68/0x510
>> [   27.849016]  [<ffffffff8125d58f>] ? sysfs_bin_mmap+0x4f/0x120
>> [   27.849027]  [<ffffffff8176456e>] ? kmemleak_alloc+0x4e/0xb0
>> [   27.849038]  [<ffffffff8125d58f>] sysfs_bin_mmap+0x4f/0x120
>> [   27.849048]  [<ffffffff8119d82d>] mmap_region+0x3ed/0x5d0
>> [   27.849058]  [<ffffffff8119dd5e>] do_mmap_pgoff+0x34e/0x3d0
>> [   27.849070]  [<ffffffff811875e0>] vm_mmap_pgoff+0x90/0xc0
>> [   27.849080]  [<ffffffff8119c2b5>] SyS_mmap_pgoff+0x1d5/0x270
>> [   27.849092]  [<ffffffff81023c55>] ? syscall_trace_enter+0x145/0x270
>> [   27.849102]  [<ffffffff8101ae52>] SyS_mmap+0x22/0x30
>> [   27.849112]  [<ffffffff81784e98>] tracesys+0xe1/0xe6
>>
>>
>>     I think it is a real deadlock, and it is caused by commit
>> 3124eb1679b28726 "sysfs: merge regular and bin file handling".
>>
>>     With that commit, sysfs_bin_mmap will hold of->mutex.
>>
>>     So assume cpu0 called sysfs_bin_mmap, acquired mmap_sem and trying
>> to get of->mutex.
>>
>>          CPU1 called sysfs_seq_show, acqured of->mutex and trying to
>> get mddev->reconfig_mutex.
>>
>>          CPU2 called md_ioctl, acquired mddev->reconfig_mutex, and
>> later call copy_from_user and page fault trying to get mmap_sem.
>>
>>      DEADLOCK now. I can't test the effort of reverting 3124eb16 as
>> there're a whole patchset and many commits after that. But I do
>> believe it's buggy and the root cause of my system hang.
>>
>>      CPU0:                                                 CPU1:
>>                                         CPU2:
>>  lock(&mm->mmap_sem)
>>                                                        lock(&of->mutex);
>>
>>                                lock(&mddev->reconfig_mutex)
>>
>>                                 lock(&mm->mmap_sem)
>>
>> lock(&mddev->reconfig_mutex)
>>  lock(&of->mutex)
>>
>>      Can we revert commit 3124eb167? or any patches to solve this page
>> fault deadlock? Thanks.
>
> Can you try linux-next, this should be fixed with a patch in my tree
> there, thanks.
>

Okay, building now, I'll update when I got the result, thanks.

> greg k-h
