Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaHOVxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 17:53:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:54203 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbaHOVxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 17:53:07 -0400
Date: Fri, 15 Aug 2014 14:54:00 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 08/13] f2fs: do checkpoint at f2fs_put_super
Message-ID: <20140815215027.GA53769@jaegeuk-mac02.mot.com>
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
 <1407872967-26423-8-git-send-email-jaegeuk@kernel.org>
 <000401cfb76b$a3957b20$eac07160$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000401cfb76b$a3957b20$eac07160$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Thu, Aug 14, 2014 at 10:57:10AM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Wednesday, August 13, 2014 3:49 AM
> > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Cc: Jaegeuk Kim
> > Subject: [f2fs-dev] [PATCH 08/13] f2fs: do checkpoint at f2fs_put_super
> > 
> > The generic_shutdown_super calls sync_filesystem, evict_inode, and then
> > f2fs_put_super. In f2fs_evict_inode, we remain some dirty inode information
> > so we should release them at f2fs_put_super.
> > 
> > But normally, it's more reasonable to set its superblock as dirty when
> > evict_inode is called.
> 
> After applying this patch, when we mount and then umount f2fs image without
> modification, we will write checkpoint in f2fs_put_super even though we have
> no more dirty data to sync, it's not needed.
> 
> "some dirty inode information" you mentioned is inode information in ->ino_root of
> sbi, right?

Actually this patch is intended to call release_dirty_inode() in
write_checkpoint, since evict_inode remains information by calling
add_dirty_inode().

Oh, it'd better set sb dirty only when add_dirty_inode is called.
Let me send v2 for this. :)

Thanks,

> 
> Regards,
> Yu
> 
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/inode.c | 1 +
> >  fs/f2fs/super.c | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> > index 2c39999..eeaf5aa 100644
> > --- a/fs/f2fs/inode.c
> > +++ b/fs/f2fs/inode.c
> > @@ -303,6 +303,7 @@ no_delete:
> >  		add_dirty_inode(sbi, inode->i_ino, APPEND_INO);
> >  	if (is_inode_flag_set(F2FS_I(inode), FI_UPDATE_WRITE))
> >  		add_dirty_inode(sbi, inode->i_ino, UPDATE_INO);
> > +	F2FS_SET_SB_DIRT(sbi);
> >  out_clear:
> >  	clear_inode(inode);
> >  }
> > diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> > index 633315a..60e3554 100644
> > --- a/fs/f2fs/super.c
> > +++ b/fs/f2fs/super.c
> > @@ -432,7 +432,7 @@ static void f2fs_put_super(struct super_block *sb)
> >  	stop_gc_thread(sbi);
> > 
> >  	/* We don't need to do checkpoint when it's clean */
> > -	if (sbi->s_dirty && get_pages(sbi, F2FS_DIRTY_NODES))
> > +	if (sbi->s_dirty)
> >  		write_checkpoint(sbi, true);
> > 
> >  	iput(sbi->node_inode);
> > --
> > 1.8.5.2 (Apple Git-48)
> > 
> > 
> > ------------------------------------------------------------------------------
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
