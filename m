Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbbARXic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 18:38:32 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:41939 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbbARXia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 18:38:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiYXAFtDvFR5LLLkPGdsb2JhbABbgwZSgw2xMwEBAQEBAQaSRIVvAgIBAQKBD0QBAQEBAQYBAQEBODuEDAEBAQMBJxMcIwULCAMYCSUPBSUDBxoTiCQHDs4QAQEBAQEBAQMBAQEBARkEGIVthAqDXYINB4MWgRMFhD4DiDmFJoVPgRWBG4FhjhqEJCoxgkMBAQE
Date: Mon, 19 Jan 2015 10:33:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>,
        Brian Foster <bfoster@redhat.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
        linux-fsdevel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: file freeze support
Message-ID: <20150118233334.GB16552@dastard>
References: <005c01d030b7$90ab2cb0$b2018610$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <005c01d030b7$90ab2cb0$b2018610$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 08:36:55PM +0900, Namjae Jeon wrote:
> We introduce per-file freeze feature for unifying defrag ext4 and xfs
> as first ingredient. We get the idea courtesy of Dave Chinner
> (https://lkml.org/lkml/2014/7/14/759)

/me pages the context back in

> per-file freeze will be used to avoid that file is not modified while
> userspace is doing the defrag.
> 
> This patch tries to implement file write freeze functionality.
> Introduce new inode state, I_WRITE_FREEZED.

I_WRITE_FROZEN.

> When this state is set, any process which tries to modify the file's address
> space, either by pagefault mmap writes or using write(2), will block until
> the this state is cleared. I_WRITE_FREEZED is set by calling FS_IOC_FWFREEZE
> ioctl and clear by FS_IOC_FWTHAW ioctl.
> 
> File write freeze functionality, when used in conjunction with
> inode's immutable flag can be used for creating truly stable file snapshots
> wherein write freeze will prevent any modification to the file from already
> open file descriptors and immutable flag will prevent any new modification
> to the file. One of the intended uses for stable file snapshots would be in
> the defragmentation applications which defrags single file.

I don't quite understand why the full filesystem freeze is
necessary? The thaw occurs immediately after I_WRITE_FREEZED is set,
which means there's nothing that prevent the file from being
truncated or otherwise modified by fallocate, etc while it is
frozen....

AFAICT, fsync will bring the file down to a consistent state and
we've already got freeze hooks for all inode modification
operations. We also have IO barriers for truncate operations so that
we can wait for all outstanding IO to complete, so I would have
thought this covers all bases for an inode freeze. i.e.:

i_mutex -> I_FROZEN -> fsync -> inode_dio_wait

Should give us a clean inode where there are not ongoing operations
by the time that inode_dio_wait() completes. All new modification
operations need to check I_FROZEN in addition to the superblock
freeze checks...

> For implementation purpose, initially we tried to keep percpu usage counters
> inside struct inode just like there is struct sb_writers in super_block.
> But considering that it will significantly bloat up struct inode when actually
> the usage of file write freeze will be infrequent, we dropped this idea.
> Instead we have tried to use already present filesystem freezing infrastructure.
> Current approach makes it possible for implementing file write freeze without
> bloating any of struct super_block/inode.
> In FS_IOC_FWFREEZE, we wait for complete fs to be frozen, set I_WRITE_FREEZED to
> inode's state and unfreeze the fs. 
> 
> TODO : prevent inode eviction when I_WRITE_FREEZED state is set.

The app needs to retain a reference to the inode (i.e. open
file descriptor) for the length of time that the inode is to be
frozen. That will prevent reclaim of the inode.

If the app fails to thaw the inode before it drops all references
to it, then all bets are off - we do not want to give userspace a
mechanism to pin arbitrarily large amounts of memory....

> TODO : xfstests testcase for file freeze.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  fs/btrfs/inode.c        |  1 +
>  fs/buffer.c             |  1 +
>  fs/ext4/inode.c         |  1 +
>  fs/f2fs/file.c          |  1 +
>  fs/gfs2/file.c          |  1 +
>  fs/inode.c              | 19 ++++++++++++++++++
>  fs/ioctl.c              | 30 +++++++++++++++++++++++++++++
>  fs/nilfs2/file.c        |  1 +
>  fs/ocfs2/mmap.c         |  1 +
>  fs/super.c              | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h      | 13 +++++++++++++
>  include/uapi/linux/fs.h |  2 ++
>  mm/filemap.c            |  1 +
>  13 files changed, 123 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e687bb0..357c749 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8262,6 +8262,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	u64 page_start;
>  	u64 page_end;
>  
> +	inode_start_write(inode);
>  	sb_start_pagefault(inode->i_sb);

Wouldn't it be better to have:

	inode_start_pagefault(inode);

and then have it call sb_start_pagefault() internally?

> +void inode_start_write(struct inode *inode)
> +{
> +	struct super_block *sb = inode->i_sb;
> +
> +retry:
> +	spin_lock(&inode->i_lock);
> +	if (inode->i_state & I_WRITE_FREEZED) {
> +		DEFINE_WAIT(wait);
> +
> +		prepare_to_wait(&sb->s_writers.wait_unfrozen, &wait,
> +				TASK_UNINTERRUPTIBLE);
> +		spin_unlock(&inode->i_lock);
> +		schedule();
> +		finish_wait(&sb->s_writers.wait_unfrozen, &wait);
> +		goto retry;
> +	}
> +	spin_unlock(&inode->i_lock);

Please use a while() loop, not goto.

	spin_lock(&inode->i_lock);
	while(inode->i_state & I_WRITE_FROZEN) {
		DEFINE_WAIT(wait);

		prepare_to_wait(&sb->s_writers.wait_unfrozen, &wait,
				TASK_UNINTERRUPTIBLE);
		spin_unlock(&inode->i_lock);
		schedule();
		finish_wait(&sb->s_writers.wait_unfrozen, &wait);
		spin_lock(&inode->i_lock);
	}
	spin_unlock(&inode->i_lock);

> +
> +int file_write_freeze(struct inode *inode)
> +{
> +	struct super_block *sb = inode->i_sb;
> +	int ret = 0;
> +
> +	if (!S_ISREG(inode->i_mode))
> +		return -EINVAL;
> +
> +	spin_lock(&inode->i_lock);
> +
> +	if (inode->i_state & I_WRITE_FREEZED)
> +		ret = -EBUSY;
> +	spin_unlock(&inode->i_lock);
> +	if (ret)
> +		return ret;
> +
> +	ret = freeze_super(sb);
> +	if (ret)
> +		return ret;
> +
> +	spin_lock(&inode->i_lock);
> +	inode->i_state |= I_WRITE_FREEZED;
> +	smp_wmb();
> +	spin_unlock(&inode->i_lock);
> +
> +	return thaw_super(sb);
> +}
> +EXPORT_SYMBOL(file_write_freeze);
> +
> +int file_write_unfreeze(struct inode *inode)
> +{
> +	struct super_block *sb = inode->i_sb;
> +
> +	if (!S_ISREG(inode->i_mode))
> +		return -EINVAL;
> +
> +	spin_lock(&inode->i_lock);
> +
> +	if (!(inode->i_state & I_WRITE_FREEZED)) {
> +		spin_unlock(&inode->i_lock);
> +		return -EINVAL;
> +	}
> +
> +	inode->i_state &= ~I_WRITE_FREEZED;
> +	smp_wmb();
> +	wake_up(&sb->s_writers.wait_unfrozen);
> +	spin_unlock(&inode->i_lock);
> +	return 0;
> +}
> +EXPORT_SYMBOL(file_write_unfreeze);

These look terrible racy. Freeze can race with other filesystem
freeze and thaw operations, so if thaw_super() fails you could have
frozen the inode but you still get -EINVAL for the ioctl. Or you
could have multiple applications doing file freeze/thaw, and so an
unfreeze occurs while a freeze if waiting on a thaw, and so the app
waiting on a freeze might return with an unfrozen inode, even though
there were no errors....


> @@ -2328,6 +2340,7 @@ static inline bool file_start_write_trylock(struct file *file)
>  {
>  	if (!S_ISREG(file_inode(file)->i_mode))
>  		return true;
> +	inode_start_write(file_inode(file));
>  	return __sb_start_write(file_inode(file)->i_sb, SB_FREEZE_WRITE, false);
>  }

This needs "trylock" semantics, not blocking semantics.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
