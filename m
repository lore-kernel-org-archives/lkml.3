Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbbAOQRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:17:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbbAOQRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:17:51 -0500
Date: Thu, 15 Jan 2015 17:17:43 +0100
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>,
        Brian Foster <bfoster@redhat.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
        linux-fsdevel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: file freeze support
Message-ID: <20150115161743.GH12739@quack.suse.cz>
References: <005c01d030b7$90ab2cb0$b2018610$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <005c01d030b7$90ab2cb0$b2018610$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Thu 15-01-15 20:36:55, Namjae Jeon wrote:
> We introduce per-file freeze feature for unifying defrag ext4 and xfs
> as first ingredient. We get the idea courtesy of Dave Chinner
> (https://lkml.org/lkml/2014/7/14/759)
> per-file freeze will be used to avoid that file is not modified while
> userspace is doing the defrag.
> 
> This patch tries to implement file write freeze functionality.
> Introduce new inode state, I_WRITE_FREEZED.
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
> 
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
...
> diff --git a/fs/inode.c b/fs/inode.c
> index aa149e7..82a96d0 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1929,3 +1929,22 @@ void inode_set_flags(struct inode *inode, unsigned int flags,
>  				  new_flags) != old_flags));
>  }
>  EXPORT_SYMBOL(inode_set_flags);
> +
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
> +}
...
> diff --git a/fs/super.c b/fs/super.c
> index eae088f..5e44e42 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1393,3 +1393,54 @@ out:
>  	return 0;
>  }
>  EXPORT_SYMBOL(thaw_super);
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
  So I was looking at the implementation and I have a few comments:
1) The trick with freezing superblock looks nice but I'm somewhat worried
that if we wanted to heavily use per-inode freezing to defrag the whole
filesystem it may be too slow to freeze the whole fs, mark one inode as
frozen and then unfreeze the fs. But I guess we'll see that once have some
reasonably working implementation.

2) The tests you are currently doing are racy. If
things happen as:
  CPU1					CPU2
inode_start_write()
					file_write_freeze()
sb_start_pagefault()
Do modifications.

Then you have a CPU modifying a file while file_write_freeze() has
succeeded so it should be frozen.

If you swap inode_start_write() with sb_start_pagefault() the above race
doesn't happen but userspace program has to be really careful not to hit a
deadlock. E.g. if you tried to freeze two inodes the following could happen:
  CPU1					CPU2
					file_write_freeze(inode1)
fault on inode1:
sb_start_pagefault()
inode_start_write() -> blocks
					file_write_freeze(inode2)
					  blocks in freeze_super()

So I don't think this is a good scheme for inode freezing...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
