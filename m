Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaA2T4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:56:54 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:46200 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaA2T4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:56:52 -0500
MIME-Version: 1.0
In-Reply-To: <20140129191322.GC7278@gmail.com>
References: <20140122051510.GB17284@gmail.com>
	<CAFLxGvwmzftdQKSjjjwpFLS8g3EJqMrQ2gU2scBsh2MvG7Wyyw@mail.gmail.com>
	<20140127163939.GA27809@gmail.com>
	<20140129053238.GA6035@gmail.com>
	<52E8AE25.8080502@nod.at>
	<20140129154622.GB7278@gmail.com>
	<52E92494.1090407@nod.at>
	<20140129191322.GC7278@gmail.com>
Date: Wed, 29 Jan 2014 20:56:51 +0100
Message-ID: <CAFLxGvzSYKA-phOJ2wfT55pLV29U70dS5R+qC-1zNz+UmBJMfg@mail.gmail.com>
Subject: Re: [BUG] reproducable ubifs reboot assert and corruption
From: Richard Weinberger <richard.weinberger@gmail.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 8:13 PM, Andrew Ruder <andy@aeruder.net> wrote:
> On Wed, Jan 29, 2014 at 04:56:04PM +0100, Richard Weinberger wrote:
>> Does the issue also happen if you disable preemption?
>> i.e. CONFIG_PREEMPT_NONE=y
>
> CONFIG_PREEMPT_NONE=y still breaks.  I suspect that sync_filesystem
> has some blocking behavior that allows other processes to schedule.

Okay, I have to test this on real hardware.
May take a few days.

BTW: s/not.at/nod.at/g ;)

> Another log is attached and the patch I used to create this log is
> below.  I think the most interesting part of this patch is the last hunk
> that modifies ubifs_remount_ro.  This clearly shows that after the mount
> has been marked as read-only we have dirty inodes waiting for the
> writeback to come in and hit all the asserts.
>
> Here's some of the important parts of the log:
>
>   170 pre sync_filesystem
> # Notice that while we were running sync_filesystem
> # a inode (0xd75ab658) snuck in with a sys_rename
>   204 inode: d75ab658
>   205 ------------[ cut here ]------------
>   206 WARNING: CPU: 0 PID: 625 at fs/fs-writeback.c:1213 __mark_inode_dirty+0x2a4/0x2f4()
>   207 Modules linked in:
>   208 CPU: 0 PID: 625 Comm: fsstress Tainted: G        W    3.12.0-00041-g7f12d39-dirty #250
>   209 [<c0014f54>] (unwind_backtrace+0x0/0x128) from [<c001235c>] (show_stack+0x20/0x24)
>   210 [<c001235c>] (show_stack+0x20/0x24) from [<c0344574>] (dump_stack+0x20/0x28)
>   211 [<c0344574>] (dump_stack+0x20/0x28) from [<c00206d4>] (warn_slowpath_common+0x78/0x98)
>   212 [<c00206d4>] (warn_slowpath_common+0x78/0x98) from [<c00207b0>] (warn_slowpath_null+0x2c/0x34)
>   213 [<c00207b0>] (warn_slowpath_null+0x2c/0x34) from [<c00f0e8c>] (__mark_inode_dirty+0x2a4/0x2f4)
>   214 [<c00f0e8c>] (__mark_inode_dirty+0x2a4/0x2f4) from [<c0136428>] (ubifs_rename+0x4a4/0x600)
>   215 [<c0136428>] (ubifs_rename+0x4a4/0x600) from [<c00d9f44>] (vfs_rename+0x280/0x3f4)
>   216 [<c00d9f44>] (vfs_rename+0x280/0x3f4) from [<c00dabe4>] (SyS_renameat+0x18c/0x218)
>   217 [<c00dabe4>] (SyS_renameat+0x18c/0x218) from [<c00dac9c>] (SyS_rename+0x2c/0x30)
>   218 [<c00dac9c>] (SyS_rename+0x2c/0x30) from [<c000e820>] (ret_fast_syscall+0x0/0x2c)
>   219 ---[ end trace 35ebec8569a53526 ]---
>   754 post sync_filesystem
>   755 pre prepare_remount
>   756 post prepare_remount
>   757 prepare_remount success
>   758 UBIFS: background thread "ubifs_bgt0_0" stops
>   759 we are now a read-only mount
>   760 bdi.work_list = d7ac4110, .next = d7ac4110
> # WE HAVE DIRTY I/O (notice the .next != &b_dirty)
>   761 bdi.wb.b_dirty = d7ac40d8, .next = d75accd0
>   762 bdi.wb.b_io = d7ac40e0, .next = d7ac40e0
>   763 bdi.wb.b_more_io = d7ac40e8, .next = d7ac40e8
>   764 do_remount_sb success
> # And now our friend (inode 0xd75ab658) comes in with a writeback after
> # we are read-only triggering the assert
>   779 inode: d75ab658
>   780 UBIFS assert failed in reserve_space at 125 (pid 11)
>   781 CPU: 0 PID: 11 Comm: kworker/u2:1 Tainted: G        W    3.12.0-00041-g7f12d39-dirty #250
>   782 Workqueue: writeback bdi_writeback_workfn (flush-ubifs_0_0)
>   783 [<c0014f54>] (unwind_backtrace+0x0/0x128) from [<c001235c>] (show_stack+0x20/0x24)
>   784 [<c001235c>] (show_stack+0x20/0x24) from [<c0344574>] (dump_stack+0x20/0x28)
>   785 [<c0344574>] (dump_stack+0x20/0x28) from [<c012f90c>] (make_reservation+0x8c/0x560)
>   786 [<c012f90c>] (make_reservation+0x8c/0x560) from [<c0130c60>] (ubifs_jnl_write_inode+0xbc/0x214)
>   787 [<c0130c60>] (ubifs_jnl_write_inode+0xbc/0x214) from [<c0137ce0>] (ubifs_write_inode+0xec/0x17c)
>   788 [<c0137ce0>] (ubifs_write_inode+0xec/0x17c) from [<c00f0a00>] (__writeback_single_inode+0x1fc/0x308)
>   789 [<c00f0a00>] (__writeback_single_inode+0x1fc/0x308) from [<c00f1780>] (writeback_sb_inodes+0x1f8/0x3c4)
>   790 [<c00f1780>] (writeback_sb_inodes+0x1f8/0x3c4) from [<c00f19cc>] (__writeback_inodes_wb+0x80/0xc0)
>   791 [<c00f19cc>] (__writeback_inodes_wb+0x80/0xc0) from [<c00f1ba4>] (wb_writeback+0x198/0x310)
>   792 [<c00f1ba4>] (wb_writeback+0x198/0x310) from [<c00f2328>] (bdi_writeback_workfn+0x15c/0x454)
>   793 [<c00f2328>] (bdi_writeback_workfn+0x15c/0x454) from [<c0038348>] (process_one_work+0x280/0x420)
>   794 [<c0038348>] (process_one_work+0x280/0x420) from [<c00389e4>] (worker_thread+0x240/0x380)
>   795 [<c00389e4>] (worker_thread+0x240/0x380) from [<c003dff8>] (kthread+0xbc/0xc8)
>   796 [<c003dff8>] (kthread+0xbc/0xc8) from [<c000e8b0>] (ret_from_fork+0x14/0x20)
>
> - Andy
>
>
>
>
> --- patch ---
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 9f4935b..48e4272 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -93,6 +93,10 @@ static void bdi_queue_work(struct backing_dev_info *bdi,
>  {
>         trace_writeback_queue(bdi, work);
>
> +       do {
> +               extern bool ubifs_enable_debug;
> +               WARN_ON(ubifs_enable_debug);
> +       } while (0);
>         spin_lock_bh(&bdi->wb_lock);
>         list_add_tail(&work->list, &bdi->work_list);
>         spin_unlock_bh(&bdi->wb_lock);
> @@ -194,6 +198,11 @@ static void redirty_tail(struct inode *inode, struct bdi_writeback *wb)
>                 if (time_before(inode->dirtied_when, tail->dirtied_when))
>                         inode->dirtied_when = jiffies;
>         }
> +       do {
> +               extern bool ubifs_enable_debug;
> +               if (ubifs_enable_debug) pr_info("inode: %p\n", inode);
> +               WARN_ON(ubifs_enable_debug);
> +       } while (0);
>         list_move(&inode->i_wb_list, &wb->b_dirty);
>  }
>
> @@ -204,6 +213,11 @@ static void requeue_io(struct inode *inode, struct bdi_writeback *wb)
>  {
>         assert_spin_locked(&wb->list_lock);
>         list_move(&inode->i_wb_list, &wb->b_more_io);
> +       do {
> +               extern bool ubifs_enable_debug;
> +               if (ubifs_enable_debug) pr_info("inode: %p\n", inode);
> +               WARN_ON(ubifs_enable_debug);
> +       } while (0);
>  }
>
>  static void inode_sync_complete(struct inode *inode)
> @@ -437,6 +451,8 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>         unsigned dirty;
>         int ret;
>
> +       extern bool ubifs_enable_debug;
> +       if (ubifs_enable_debug) pr_info("inode: %p\n", inode);
>         WARN_ON(!(inode->i_state & I_SYNC));
>
>         trace_writeback_single_inode_start(inode, wbc, nr_to_write);
> @@ -1191,6 +1207,11 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>
>                         inode->dirtied_when = jiffies;
>                         list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
> +       do {
> +               extern bool ubifs_enable_debug;
> +               if (ubifs_enable_debug) pr_info("inode: %p\n", inode);
> +               WARN_ON(ubifs_enable_debug);
> +       } while (0);
>                         spin_unlock(&bdi->wb.list_lock);
>
>                         if (wakeup_bdi)
> diff --git a/fs/super.c b/fs/super.c
> index 0225c20..29afc68 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -737,6 +737,12 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>         int retval;
>         int remount_ro;
>
> +       extern bool ubifs_enable_debug;
> +       if (flags & MS_RDONLY) {
> +               ubifs_enable_debug = true;
> +       }
> +       WARN_ON(ubifs_enable_debug);
> +
>         if (sb->s_writers.frozen != SB_UNFROZEN)
>                 return -EBUSY;
>
> @@ -747,8 +753,11 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>
>         if (flags & MS_RDONLY)
>                 acct_auto_close(sb);
> +       pr_info("pre shrink_dcache_sb\n");
>         shrink_dcache_sb(sb);
> +       pr_info("pre sync_filesystem\n");
>         sync_filesystem(sb);
> +       pr_info("post sync_filesystem\n");
>
>         remount_ro = (flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY);
>
> @@ -758,9 +767,12 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>                 if (force) {
>                         mark_files_ro(sb);
>                 } else {
> +                       pr_info("pre prepare_remount\n");
>                         retval = sb_prepare_remount_readonly(sb);
> +                       pr_info("post prepare_remount\n");
>                         if (retval)
>                                 return retval;
> +                       pr_info("prepare_remount success\n");
>                 }
>         }
>
> @@ -789,6 +801,7 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
>          */
>         if (remount_ro && sb->s_bdev)
>                 invalidate_bdev(sb->s_bdev);
> +       pr_info("do_remount_sb success\n");
>         return 0;
>
>  cancel_readonly:
> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
> index 123c79b..c9f2d5d 100644
> --- a/fs/ubifs/file.c
> +++ b/fs/ubifs/file.c
> @@ -902,6 +902,8 @@ static int do_writepage(struct page *page, int len)
>         struct inode *inode = page->mapping->host;
>         struct ubifs_info *c = inode->i_sb->s_fs_info;
>
> +       WARN_ON(c->ro_mount);
> +
>  #ifdef UBIFS_DEBUG
>         spin_lock(&ui->ui_lock);
>         ubifs_assert(page->index <= ui->synced_i_size << PAGE_CACHE_SIZE);
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 3e4aa72..8cbb731 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -38,6 +38,8 @@
>  #include <linux/writeback.h>
>  #include "ubifs.h"
>
> +bool ubifs_enable_debug;
> +
>  /*
>   * Maximum amount of memory we may 'kmalloc()' without worrying that we are
>   * allocating too much.
> @@ -1756,6 +1758,11 @@ static void ubifs_remount_ro(struct ubifs_info *c)
>         err = dbg_check_space_info(c);
>         if (err)
>                 ubifs_ro_mode(c, err);
> +       pr_info("we are now a read-only mount\n");
> +       pr_info("bdi.work_list = %p, .next = %p\n", &c->bdi.work_list, c->bdi.work_list.next);
> +       pr_info("bdi.wb.b_dirty = %p, .next = %p\n", &c->bdi.wb.b_dirty, c->bdi.wb.b_dirty.next);
> +       pr_info("bdi.wb.b_io = %p, .next = %p\n", &c->bdi.wb.b_io, c->bdi.wb.b_io.next);
> +       pr_info("bdi.wb.b_more_io = %p, .next = %p\n", &c->bdi.wb.b_more_io, c->bdi.wb.b_more_io.next);
>         mutex_unlock(&c->umount_mutex);
>  }
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>



-- 
Thanks,
//richard
