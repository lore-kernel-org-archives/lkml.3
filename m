Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab3ENVyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 17:54:07 -0400
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:56617 "EHLO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091Ab3ENVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 17:54:05 -0400
X-Greylist: delayed 8829 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 May 2013 17:54:04 EDT
MIME-Version: 1.0
In-Reply-To: <CAGC=Z9SN1zfT7NjzEcGidDaWCsC7v40uOhqErFq8x9oCiLQhKQ@mail.gmail.com>
References: <51906213.2020005@gmail.com> <20130513070556.GB21431@hli22-desktop>
 <CAGC=Z9SN1zfT7NjzEcGidDaWCsC7v40uOhqErFq8x9oCiLQhKQ@mail.gmail.com>
From: Russell Knize <rknize2@motorola.com>
Date: Tue, 14 May 2013 14:26:31 -0500
Message-ID: <CAGfvh6316D10YjqyowFmCHJxe7UdyPLYPfkVkVC=zVm6+Jy=oA@mail.gmail.com>
Subject: Re: [PATCH] f2fs: Remove BUG_ON in dec_valid_node_count
To: Chris Fries <ccfries@gmail.com>
Cc: Haicheng Li <haicheng.li@linux.intel.com>,
        Chris Fries <c.fries@motorola.com>,
        "jaegeuk.kim" <jaegeuk.kim@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jason Hrycay <jason.hrycay@motorola.com>
Content-Type: text/plain; charset=ISO-8859-1
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The node accounting errors seem to be creeping in during recovery.
Once the error is introduced in the total counts, it gets recorded in
the next checkpoint and is carried forward.  Often times the error
crops-up after a failed recovery attempt, such as when recovery
attempts to recover an inode belonging to a subdirectory that was
previously removed.

We've also seen accounting errors elsewhere, such as the block bitmap
management in update_sit_entry().  In one case, we bug-out on some
random unlink operation because truncate_data_blocks_range() tries to
invalidate a block whose bit is not set in the bitmap:

kernel BUG at ../../../../../../kernel/fs/f2fs/segment.c:199!
...
do_unlinkat()
    evict()
        f2fs_evict_inode()
            f2fs_truncate()
                truncate_data_blocks_range()
                    invalidate_blocks()
                        update_sit_entry()

In another case, we bug-out during recovery while trying to allocate
the dummy page for an fsync.  In this case, the page is already
allocated:

kernel BUG at ../../../../../../kernel/fs/f2fs/segment.c:211!
...
vfs_kern_mount()
    mount_fs()
        f2fs_mount()
            mount_bdev()
                f2fs_fill_super()
                    recover_fsync_data()
                        recover_data_page()
                            update_sit_entry()


I've experimented with some changes to deal with the bug-outs in
update_sit_entry() and regenerate the block counts that are maintained
by the seg_entry and sec_entry structures, but I am not confident that
there still won't exist a disparity between block allocations and
their respective nodes.

Some sort of consistency checker would be handy.  ;)

We're going to run these torture tests with disable_roll_forward to
try to at least confirm that we should be focused on the recovery
process.

Russ W. Knize
Mobile Devices Android Platform
Desk: 847-523-9381
Mobile: 224-622-1391


On Mon, May 13, 2013 at 10:41 AM, Chris Fries <ccfries@gmail.com> wrote:
> Yes, your observations are correct, total_valid_node_count is 0, and the
> caller is truncate_node.  It could be a bug in recovery accounting
> somewhere, but I haven't been able to save a copy of the disk image just
> before the recovery or rmdir failure, which is the best place to start
> investigating the bug.  It could also be some bad state of the disk during
> panic restart rather than a straight recovery bug.
>
> Adding some traces or logs into recovery might give clues too.
>
> The panics I've seen are both during mount and during rmdir.
>
> -- truncate_node
>   -- remove_inode_page
>     -- f2fs_evict_inode
>       -- evict
>         -- recover_orphan_inodes
>           -- f2fs_fill_super
>             -- mount_bdev
>
> or
>
> -- truncate_node
>   -- remove_inode_page
>     -- f2fs_evict_inode
>       -- evict
>         -- d_delete
>           -- vfs_rmdir
>
>
>
>
> On Mon, May 13, 2013 at 2:05 AM, Haicheng Li <haicheng.li@linux.intel.com>
> wrote:
>>
>>
>> On Sun, May 12, 2013 at 10:46:27PM -0500, Chris Fries wrote:
>> > From: Chris Fries <C.Fries@motorola.com>
>> >
>> > Panic loops while running LTP fsstress has been able to get
>> > a disk into two different panic loops from dec_valid_node_count.
>> > f2fs.h:714  BUG_ON(sbi->total_valid_node_count < count);
>>
>> This is interesting catch.
>> from the code, dec_valid_node_count() is only called by truncate_node():
>>         dec_valid_node_count(sbi, dn->inode, 1);
>>
>> So the failure in your test means that sbi->total_valid_node_count < 1,
>> i.e. equal to 0. This should be an unexpected status.
>>
>> I think a better solution should be to avoid such over truncate_node
>> situation.
>>
>> How do you think?
>>
>> > Once, it happens during recovery itself, and the disk would cause
>> > a panic every time it mounted.
>> >
>> > Another time, it would happen during garbage collection, so the disk
>> > would cause a panic within 200 seconds of mounting.
>> >
>> > Removing this BUG_ON hasn't shown any side effects, so let's take it
>> > out and monitor.
>> >
>> > Signed-off-by: Chris Fries <C.Fries@motorola.com>
>> >
>> > ---
>> >  fs/f2fs/f2fs.h | 18 +++++++++++++++---
>> >  1 file changed, 15 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>> > index e80a87c..b8e9679 100644
>> > --- a/fs/f2fs/f2fs.h
>> > +++ b/fs/f2fs/f2fs.h
>> > @@ -722,9 +722,21 @@ static inline void dec_valid_node_count(struct
>> > f2fs_sb_info *sbi,
>> >  {
>> >       spin_lock(&sbi->stat_lock);
>> >
>> > -     BUG_ON(sbi->total_valid_block_count < count);
>> > -     BUG_ON(sbi->total_valid_node_count < count);
>> > -     BUG_ON(inode->i_blocks < count);
>> > +     if (sbi->total_valid_block_count < count) {
>> > +             WARN(1, "F2FS: total_valid_block_count too small- %d vs
>> > %d\n",
>> > +                     (unsigned int)sbi->total_valid_block_count,
>> > count);
>> > +             count = sbi->total_valid_block_count;
>> > +     }
>> > +     if (sbi->total_valid_node_count < count) {
>> > +             WARN(1, "F2FS: total_valid_node_count too small- %d vs
>> > %d\n",
>> > +                     sbi->total_valid_node_count, count);
>> > +             count = sbi->total_valid_node_count;
>> > +     }
>> > +     if (inode->i_blocks < count) {
>> > +             WARN(1, "F2FS: inode->i_blocks too small - %d vs %d\n",
>> > +                     (unsigned int)inode->i_blocks, count);
>> > +             count = sbi->total_valid_node_count;
>> > +     }
>> >
>> >       inode->i_blocks -= count;
>> >       sbi->total_valid_node_count -= count;
>> > --
>> > 1.8.0
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> > in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
