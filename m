Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbbAPK5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:57:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbbAPK5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:57:16 -0500
Date: Fri, 16 Jan 2015 11:57:12 +0100
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: "'Jan Kara'" <jack@suse.cz>, "'Dave Chinner'" <david@fromorbit.com>,
        "'Theodore Ts'o'" <tytso@mit.edu>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>,
        "'Brian Foster'" <bfoster@redhat.com>,
        "'Dmitry Monakhov'" <dmonakhov@openvz.org>,
        "=?utf-8?B?J0x1a8OhxaE=?= Czerner'" <lczerner@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: file freeze support
Message-ID: <20150116105712.GF25884@quack.suse.cz>
References: <005c01d030b7$90ab2cb0$b2018610$@samsung.com>
 <20150115161743.GH12739@quack.suse.cz>
 <003f01d03158$60c9def0$225d9cd0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003f01d03158$60c9def0$225d9cd0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Fri 16-01-15 15:48:04, Namjae Jeon wrote:
> > > +int file_write_unfreeze(struct inode *inode)
> > > +{
> > > +	struct super_block *sb = inode->i_sb;
> > > +
> > > +	if (!S_ISREG(inode->i_mode))
> > > +		return -EINVAL;
> > > +
> > > +	spin_lock(&inode->i_lock);
> > > +
> > > +	if (!(inode->i_state & I_WRITE_FREEZED)) {
> > > +		spin_unlock(&inode->i_lock);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	inode->i_state &= ~I_WRITE_FREEZED;
> > > +	smp_wmb();
> > > +	wake_up(&sb->s_writers.wait_unfrozen);
> > > +	spin_unlock(&inode->i_lock);
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL(file_write_unfreeze);
> >   So I was looking at the implementation and I have a few comments:
> > 1) The trick with freezing superblock looks nice but I'm somewhat worried
> > that if we wanted to heavily use per-inode freezing to defrag the whole
> > filesystem it may be too slow to freeze the whole fs, mark one inode as
> > frozen and then unfreeze the fs. But I guess we'll see that once have some
> > reasonably working implementation.
> Dmitry has given a good idea to avoid multiple freeze fs and unfreeze fs
> calls.
> 
> ioctl(sb,FIFREEZE)
> while (f = pop(files_list))
>   ioctl(f,FS_IOC_FWFREEZE)
> ioctl(sb,FITHAW)
> 
> In file_write_freeze, we could first check if the fs is already frozen,
> if yes than we can directly set inode write freeze state after taking
> relevant lock to prevent fs_thaw while the inode state is being set.
  Well, doing fs-wide freezing from userspace makes sense as Dmitry pointed
out. We can then just fail FS_IOC_FWFREEZE with error when the whole fs isn't
frozen. I'm just somewhat worried whether the fs-wide freezing won't be too
fragile. E.g. consider a situation when you are running a defrag program
which is freezing and unfreezing the filesystem and then some background
work kicks which will want to snapshot the filesystem so it will freeze &
unfreeze the fs as well. Now depending on how exactly defrag and snapshot
race one of the FIFREEZE ioctls will return EBUSY and the process
(hopefully gracefully) fails.

This isn't a new situation - if you ran two snapshots at once, you'd see
the same failure. But the more fs-wide freezing gets used in different
places the stranger and less expected failure you'll see...

> > 2) The tests you are currently doing are racy. If
> > things happen as:
> >   CPU1					CPU2
> > inode_start_write()
> > 					file_write_freeze()
> > sb_start_pagefault()
> > Do modifications.
> > 
> > Then you have a CPU modifying a file while file_write_freeze() has
> > succeeded so it should be frozen.
> > 
> > If you swap inode_start_write() with sb_start_pagefault() the above race
> > doesn't happen but userspace program has to be really careful not to hit a
> > deadlock. E.g. if you tried to freeze two inodes the following could happen:
> >   CPU1					CPU2
> > 					file_write_freeze(inode1)
> > fault on inode1:
> > sb_start_pagefault()
> > inode_start_write() -> blocks
> > 					file_write_freeze(inode2)
> > 					  blocks in freeze_super()
> > 
> > So I don't think this is a good scheme for inode freezing...
> To solve this race, we can fold inode_start_write with sb_start_write and use
> similar appraoch of __sb_start_write.
> How about the below scheme ?
> 
> void inode_start_write(struct inode *inode)
> {
> 	struct super_block *sb = inode->i_sb;
> 
> retry:
> 
> 	if (unlikely(inode->i_state & I_WRITE_FREEZED)) {
> 		DEFINE_WAIT(wait);
> 
> 		prepare_to_wait(&sb->s_writers.wait_unfrozen, &wait,
> 			TASK_UNINTERRUPTIBLE);
> 		schedule();
> 		finish_wait(&sb->s_writers.wait_unfrozen, &wait);
> 
> 		goto retry;
> 	}
> 
> 	sb_start_write(sb);
> 
> 	/* check if file_write_freeze race with us */
> 	if (unlikely(inode->i_state & I_WRITE_FREEZED) {
> 		sb_end_write(sb);
> 		goto retry;
> 	}
> }
  Yes, this should work. You'll need a similar wrapper for page faults but
that's easy enough.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
