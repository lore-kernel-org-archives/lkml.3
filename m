Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbaGCUkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:40:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29045 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaGCUkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:40:04 -0400
Message-ID: <53B5BF94.7090105@oracle.com>
Date: Thu, 03 Jul 2014 16:39:48 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Alexander E. Patrakov" <patrakov@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] zram: revalidate disk after capacity change
References: <1403745385-18952-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1403745385-18952-1-git-send-email-minchan@kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 09:16 PM, Minchan Kim wrote:
> Alexander reported mkswap on /dev/zram0 is failed if other process
> is opening the block device file.
> 
> Step is as follows,
> 
> 0. Reset the unused zram device.
> 1. Use a program that opens /dev/zram0 with O_RDWR and sleeps
>    until killed.
> 2. While that program sleeps, echo the correct value to
>    /sys/block/zram0/disksize.
> 3. Verify (e.g. in /proc/partitions) that the disk size is applied
>    correctly. It is.
> 4. While that program still sleeps, attempt to mkswap /dev/zram0.
>    This fails: mkswap: error: swap area needs to be at least 40 KiB
> 
> When I investigated, the size get by ioctl(fd, BLKGETSIZE64, xxx)
> on mkswap to get a size of blockdev was zero although zram0 has
> right size by 2.
> 
> The reason is zram didn't revalidate disk after changing capacity
> so that size of blockdev's inode is not uptodate until all of file
> is close.
> 
> This patch should fix the BUG.
> 
> Cc: stable@vger.kernel.org
> Reported-and-Tested-by: Alexander E. Patrakov <patrakov@gmail.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Hi Minchan,

This patch causes the following lockdep warning:


[  249.545546] =================================
[  249.546510] [ INFO: inconsistent lock state ]
[  249.547201] 3.16.0-rc3-next-20140703-sasha-00022-g0b37949-dirty #761 Not tainted
[  249.548316] ---------------------------------
[  249.548980] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
[  249.550044] kswapd1/3912 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  249.550044] (&zram->init_lock){+++++-}, at: zram_make_request (drivers/block/zram/zram_drv.c:1047)
[  249.550044] {RECLAIM_FS-ON-W} state was registered at:
[  249.550044] mark_held_locks (kernel/locking/lockdep.c:2523)
[  249.550044] lockdep_trace_alloc (kernel/locking/lockdep.c:2745 kernel/locking/lockdep.c:2760)
[  249.550044] kmem_cache_alloc (mm/slub.c:1246 mm/slub.c:2386 mm/slub.c:2459 mm/slub.c:2464)
[  249.550044] bdev_alloc_inode (fs/block_dev.c:440)
[  249.550044] alloc_inode (fs/inode.c:208)
[  249.550044] iget5_locked (fs/inode.c:1017)
[  249.550044] bdget (fs/block_dev.c:568)
[  249.550044] bdget_disk (include/linux/genhd.h:268 block/genhd.c:727)
[  249.550044] revalidate_disk (fs/block_dev.c:1042)
[  249.550044] disksize_store (drivers/block/zram/zram_drv.c:685)
[  249.550044] dev_attr_store (drivers/base/core.c:138)
[  249.550044] sysfs_kf_write (fs/sysfs/file.c:115)
[  249.550044] kernfs_fop_write (fs/kernfs/file.c:308)
[  249.550044] vfs_write (fs/read_write.c:532)
[  249.550044] SyS_write (fs/read_write.c:584 fs/read_write.c:576)
[  249.550044] tracesys (arch/x86/kernel/entry_64.S:542)
[  249.550044] irq event stamp: 4395
[  249.550044] hardirqs last enabled at (4395): throtl_update_dispatch_stats (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) block/blk-throttle.c:982 (discriminator 2))
[  249.550044] hardirqs last disabled at (4394): throtl_update_dispatch_stats (block/blk-throttle.c:977)
[  249.550044] softirqs last enabled at (4252): __do_softirq (./arch/x86/include/asm/preempt.h:22 kernel/softirq.c:296)
[  249.550044] softirqs last disabled at (4233): irq_exit (kernel/softirq.c:346 kernel/softirq.c:387)
[  249.550044]
[  249.550044] other info that might help us debug this:
[  249.550044]  Possible unsafe locking scenario:
[  249.550044]
[  249.550044]        CPU0
[  249.550044]        ----
[  249.550044]   lock(&zram->init_lock);
[  249.550044]   <Interrupt>
[  249.550044]     lock(&zram->init_lock);
[  249.550044]
[  249.550044]  *** DEADLOCK ***
[  249.550044]
[  249.550044] no locks held by kswapd1/3912.
[  249.550044]
[  249.550044] stack backtrace:
[  249.550044] CPU: 1 PID: 3912 Comm: kswapd1 Not tainted 3.16.0-rc3-next-20140703-sasha-00022-g0b37949-dirty #761
[  249.550044]  ffffffff9cbff170 ffff8801b3e6f358 ffffffff99489804 0000000000000000
[  249.550044]  ffff8801b3e50000 ffff8801b3e6f3b8 ffffffff9947dc97 0000000000000000
[  249.550044]  ffffffff00000001 ffff880100000001 ffffffff9cbff280 ffff8801b3e6f3b8
[  249.550044] Call Trace:
[  249.550044] dump_stack (lib/dump_stack.c:52)
[  249.550044] print_usage_bug (kernel/locking/lockdep.c:2257)
[  249.550044] ? print_irq_inversion_bug (kernel/locking/lockdep.c:2347)
[  249.550044] mark_lock (kernel/locking/lockdep.c:2465 kernel/locking/lockdep.c:2920)
[  249.550044] __lock_acquire (kernel/locking/lockdep.c:2821 kernel/locking/lockdep.c:3138)
[  249.550044] ? preempt_count_sub (kernel/sched/core.c:2606)
[  249.550044] ? blk_throtl_bio (include/linux/rcupdate.h:906 block/blk-throttle.c:1581)
[  249.550044] ? blk_throtl_bio (include/linux/rcupdate.h:906 block/blk-throttle.c:1581)
[  249.550044] ? rcu_lock_release (kernel/rcu/update.c:192)
[  249.550044] ? blk_throtl_bio (include/linux/rcupdate.h:906 block/blk-throttle.c:1581)
[  249.550044] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[  249.550044] ? zram_make_request (drivers/block/zram/zram_drv.c:1047)
[  249.550044] down_read (./arch/x86/include/asm/rwsem.h:83 kernel/locking/rwsem.c:44)
[  249.550044] ? zram_make_request (drivers/block/zram/zram_drv.c:1047)
[  249.550044] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
[  249.550044] zram_make_request (drivers/block/zram/zram_drv.c:1047)
[  249.550044] ? generic_make_request_checks (block/blk-core.c:1838)
[  249.550044] ? put_lock_stats.isra.12 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[  249.550044] ? __test_set_page_writeback (include/linux/rcupdate.h:906 include/linux/memcontrol.h:171 mm/page-writeback.c:2418)
[  249.550044] generic_make_request (block/blk-core.c:1917 (discriminator 1))
[  249.550044] submit_bio (block/blk-core.c:1968)
[  249.550044] ? __test_set_page_writeback (include/linux/rcupdate.h:906 include/linux/memcontrol.h:171 mm/page-writeback.c:2418)
[  249.550044] __swap_writepage (mm/page_io.c:318)
[  249.550044] ? page_swapcount (mm/swapfile.c:875)
[  249.550044] ? get_parent_ip (kernel/sched/core.c:2550)
[  249.550044] ? preempt_count_sub (kernel/sched/core.c:2606)
[  249.550044] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
[  249.550044] ? page_swapcount (mm/swapfile.c:875)
[  249.550044] swap_writepage (mm/page_io.c:249)
[  249.550044] shmem_writepage (mm/shmem.c:823)
[  249.550044] ? anon_vma_prepare (mm/rmap.c:448)
[  249.550044] shrink_page_list (mm/vmscan.c:509 mm/vmscan.c:1021)
[  249.550044] shrink_inactive_list (include/linux/spinlock.h:328 mm/vmscan.c:1526)
[  249.550044] shrink_lruvec (mm/vmscan.c:1855 mm/vmscan.c:2103)
[  249.550044] shrink_zone (mm/vmscan.c:2287)
[  249.550044] kswapd_shrink_zone (include/linux/nodemask.h:131 include/linux/nodemask.h:131 mm/vmscan.c:2967)
[  249.550044] balance_pgdat (mm/vmscan.c:3153)
[  249.550044] kswapd (mm/vmscan.c:3359)
[  249.550044] ? bit_waitqueue (kernel/sched/wait.c:291)
[  249.550044] ? balance_pgdat (mm/vmscan.c:3276)
[  249.550044] kthread (kernel/kthread.c:210)
[  249.550044] ? put_lock_stats.isra.12 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[  249.550044] ? kthread_create_on_node (kernel/kthread.c:176)
[  249.550044] ret_from_fork (arch/x86/kernel/entry_64.S:349)


Thanks,
Sasha
