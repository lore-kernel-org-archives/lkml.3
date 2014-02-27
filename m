Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaB0Xzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:55:54 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:50981 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaB0Xzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:55:52 -0500
X-Original-SENDERIP: 10.177.220.194
X-Original-MAILFROM: minchan@kernel.org
Date: Fri, 28 Feb 2014 08:56:29 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: ngupta@vflare.org, LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: zram: lockdep spew for zram->init_lock
Message-ID: <20140227235629.GF31407@bbox>
References: <530F5045.1010604@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530F5045.1010604@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sasha,

On Thu, Feb 27, 2014 at 09:48:37AM -0500, Sasha Levin wrote:
> Hi all,
> 
> I've stumbled on the following spew while fuzzing with trinity
> inside a KVM tools guest running latest -next. It looks like a false
> positive (we only set size for uninitialized devices, so we can't
> deadlock on them being in-use) but I'd really like someone to
> confirm it before I write it down as such.

Thanks for the info!
As you said, it's false positive and introduced by [1] in recent
linux-next but I don't feel we need to annotate to prevent lockdep
spew.

Just enough to move zram_meta_alloc out of lock as old.
Sergey claimed that "let's avoid unnecessary allocation/free of zram_meta
on currently used device" but I think it's not worth to add annotate lock
so that lockdep would be void.

[1] zram: delete zram_init_device()

>From 89353c8319e183826b03bf8562569f46ae460763 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Fri, 28 Feb 2014 08:39:21 +0900
Subject: [PATCH] zram: prevent lockdep spew of init_lock

Sasha reported following below lockdep spew of zram.

It was introduced by [1] in recent linux-next but it's false positive
because zram_meta_alloc with down_write(init_lock) couldn't be called
during zram is working as swap device so we could annotate the lock.

But I don't think it's worthy because it would make greate lockdep
less effective. Instead, move zram_meta_alloc out of the lock as good
old day so we could do unnecessary allocation/free of zram_meta for
initialied device as Sergey claimed in [1] but it wouldn't be common
and be harmful if someone might do it. Rather than, I'd like to respect
lockdep which is great tool to prevent upcoming subtle bugs.

[1] zram: delete zram_init_device

[ 2655.365684] =================================
[ 2655.368278] [ INFO: inconsistent lock state ]
[ 2655.370163] 3.14.0-rc4-next-20140226-sasha-00013-g082bdac-dirty #4 Tainted: G        W
[ 2655.371972] ---------------------------------
[ 2655.371972] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
[ 2655.371972] kswapd30/5352 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 2655.371972]  (&zram->init_lock){+++++-}, at: [<drivers/block/zram/zram_drv.c:663>]
zram_make_request+0x2a/0xc0
[ 2655.371972] {RECLAIM_FS-ON-W} state was registered at:
[ 2655.371972]   [<kernel/locking/lockdep.c:2523>] mark_held_locks+0x6c/0x90
[ 2655.371972]   [<kernel/locking/lockdep.c:2745 kernel/locking/lockdep.c:2760>]
lockdep_trace_alloc+0xfd/0x140
[ 2655.371972]   [<mm/slub.c:965 mm/slub.c:2402 mm/slub.c:2475 mm/slub.c:2492>]
kmem_cache_alloc_trace+0x32/0x2e0
[ 2655.371972]   [<include/linux/slab.h:453 drivers/block/zram/zram_drv.c:172>]
zram_meta_alloc+0x20/0x150
[ 2655.371972]   [<drivers/block/zram/zram_drv.c:554>] disksize_store+0x8e/0xf0
[ 2655.371972]   [<drivers/base/core.c:139>] dev_attr_store+0x1b/0x20
[ 2655.371972]   [<fs/sysfs/file.c:114>] sysfs_kf_write+0x4a/0x60
[ 2655.371972]   [<fs/kernfs/file.c:299>] kernfs_fop_write+0x110/0x190
[ 2655.371972]   [<fs/read_write.c:473>] vfs_write+0xe3/0x1d0
[ 2655.371972]   [<fs/read_write.c:523 fs/read_write.c:515>] SyS_write+0x5d/0xa0
[ 2655.371972]   [<arch/x86/kernel/entry_64.S:749>] tracesys+0xdd/0xe2
[ 2655.371972] irq event stamp: 10207
[ 2655.371972] hardirqs last  enabled at (10207): [<arch/x86/include/asm/paravirt.h:809
block/blk-throttle.c:982>] throtl_update_dispatch_stats+0x15d/0x1a0
[ 2655.371972] hardirqs last disabled at (10206): [<block/blk-throttle.c:977>]
throtl_update_dispatch_stats+0xa4/0x1a0
[ 2655.371972] softirqs last  enabled at (10172): [<arch/x86/include/asm/preempt.h:22
kernel/softirq.c:297>] __do_softirq+0x447/0x4f0
[ 2655.371972] softirqs last disabled at (10165): [<kernel/softirq.c:347 kernel/softirq.c:388>]
irq_exit+0x83/0x160
[ 2655.371972]
[ 2655.371972] other info that might help us debug this:
[ 2655.371972]  Possible unsafe locking scenario:
[ 2655.371972]
[ 2655.371972]        CPU0
[ 2655.371972]        ----
[ 2655.371972]   lock(&zram->init_lock);
[ 2655.371972]   <Interrupt>
[ 2655.371972]     lock(&zram->init_lock);
[ 2655.371972]
[ 2655.371972]  *** DEADLOCK ***
[ 2655.371972]
[ 2655.371972] no locks held by kswapd30/5352.
[ 2655.371972]
[ 2655.371972] stack backtrace:
[ 2655.371972] CPU: 78 PID: 5352 Comm: kswapd30 Tainted: G        W
3.14.0-rc4-next-20140226-sasha-00013-g082bdac-dirty #4
[ 2655.371972]  ffff880636f98cc0 ffff880636f8d3f8 ffffffff843882e5 0000000000000000
[ 2655.371972]  ffff880636f98000 ffff880636f8d458 ffffffff811a09f7 0000000000000000
[ 2655.371972]  0000000000000001 ffff880600000001 ffffffff876c2060 0000000000000009
[ 2655.371972] Call Trace:
[ 2655.371972]  [<lib/dump_stack.c:52>] dump_stack+0x52/0x7f
[ 2655.371972]  [<kernel/locking/lockdep.c:2254>] print_usage_bug+0x1a7/0x1e0
[ 2655.371972]  [<kernel/locking/lockdep.c:2347>] ? print_usage_bug+0x1e0/0x1e0
[ 2655.371972]  [<kernel/locking/lockdep.c:2465>] mark_lock_irq+0xd9/0x2a0
[ 2655.371972]  [<kernel/locking/lockdep.c:2920>] mark_lock+0x128/0x210
[ 2655.371972]  [<kernel/locking/lockdep.c:2821>] mark_irqflags+0x144/0x170
[ 2655.371972]  [<kernel/locking/lockdep.c:3138>] __lock_acquire+0x2de/0x5a0
[ 2655.371972]  [<arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602>]
lock_acquire+0x182/0x1d0
[ 2655.371972]  [<drivers/block/zram/zram_drv.c:663>] ? zram_make_request+0x2a/0xc0
[ 2655.371972]  [<arch/x86/include/asm/rwsem.h:83 kernel/locking/rwsem.c:23>] down_read+0x47/0xa0
[ 2655.371972]  [<drivers/block/zram/zram_drv.c:663>] ? zram_make_request+0x2a/0xc0
[ 2655.371972]  [<arch/x86/include/asm/current.h:14 kernel/sched/core.c:2508>] ?
preempt_count_add+0x96/0xc0
[ 2655.371972]  [<drivers/block/zram/zram_drv.c:663>] zram_make_request+0x2a/0xc0
[ 2655.371972]  [<block/blk-core.c:1862>] generic_make_request+0xb6/0x110
[ 2655.371972]  [<block/blk-core.c:1913>] submit_bio+0x148/0x170
[ 2655.371972]  [<include/linux/rcupdate.h:800 include/linux/memcontrol.h:180
mm/page-writeback.c:2408>] ? test_set_page_writeback+0x24e/0x2a0
[ 2655.371972]  [<mm/page_io.c:315>] __swap_writepage+0x1fc/0x220
[ 2655.371972]  [<arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:152
kernel/locking/spinlock.c:183>] ? _raw_spin_unlock+0x30/0x50
[ 2655.371972]  [<mm/swapfile.c:898>] ? page_swapcount+0x4e/0x60
[ 2655.371972]  [<mm/page_io.c:249>] swap_writepage+0x72/0x80
[ 2655.371972]  [<mm/vmscan.c:502>] pageout+0x167/0x2e0
[ 2655.371972]  [<mm/vmscan.c:1015>] shrink_page_list+0x4f4/0x7c0
[ 2655.371972]  [<include/linux/spinlock.h:328 mm/vmscan.c:1503>] shrink_inactive_list+0x31c/0x570
[ 2655.371972]  [<mm/vmscan.c:1744>] ? shrink_active_list+0x30b/0x320
[ 2655.371972]  [<mm/vmscan.c:1830 mm/vmscan.c:2054>] shrink_lruvec+0x124/0x300
[ 2655.371972]  [<arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:305>] ?
sched_clock+0x1d/0x30
[ 2655.371972]  [<mm/vmscan.c:2235>] shrink_zone+0x8e/0x1d0
[ 2655.371972]  [<include/linux/bitmap.h:165 include/linux/nodemask.h:131 mm/vmscan.c:2904>]
kswapd_shrink_zone+0xf1/0x1b0
[ 2655.371972]  [<mm/vmscan.c:3088>] balance_pgdat+0x363/0x540
[ 2655.371972]  [<kernel/sched/wait.c:254>] ? finish_wait+0x70/0x90
[ 2655.371972]  [<mm/vmscan.c:3296>] kswapd+0x2eb/0x350
[ 2655.371972]  [<mm/vmscan.c:3213>] ? ftrace_raw_event_mm_vmscan_writepage+0x180/0x180
[ 2655.371972]  [<kernel/kthread.c:216>] kthread+0x105/0x110
[ 2655.371972]  [<kernel/locking/lockdep.c:3506>] ? __lock_release+0x1e2/0x200
[ 2655.371972]  [<kernel/kthread.c:185>] ? set_kthreadd_affinity+0x30/0x30
[ 2655.371972]  [<arch/x86/kernel/entry_64.S:555>] ret_from_fork+0x7c/0xb0
[ 2655.371972]  [<kernel/kthread.c:185>] ? set_kthreadd_affinity+0x30/0x30

Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9baac5b76bfe..76ba67673a90 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -537,26 +537,27 @@ static ssize_t disksize_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	u64 disksize;
+	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
 		return -EINVAL;
 
+	disksize = PAGE_ALIGN(disksize);
+	meta = zram_meta_alloc(disksize);
+	if (!meta)
+		return -ENOMEM;
+
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
+		zram_meta_free(meta);
 		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
 		return -EBUSY;
 	}
 
-	disksize = PAGE_ALIGN(disksize);
-	zram->meta = zram_meta_alloc(disksize);
-	if (!zram->meta) {
-		up_write(&zram->init_lock);
-		return -ENOMEM;
-	}
-
+	zram->meta = meta;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
 	up_write(&zram->init_lock);
-- 
1.8.5.3

-- 
Kind regards,
Minchan Kim
