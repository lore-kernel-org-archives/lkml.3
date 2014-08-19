Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaHSQLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:11:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:33982 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbaHSQLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:11:36 -0400
Date: Tue, 19 Aug 2014 09:11:30 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 08/13 v2] f2fs: do checkpoint at	f2fs_put_super
Message-ID: <20140819160708.GA68318@jaegeuk-mac02.mot.com>
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
 <1407872967-26423-8-git-send-email-jaegeuk@kernel.org>
 <20140815215818.GB53769@jaegeuk-mac02.mot.com>
 <002e01cfbb78$bf297ab0$3d7c7010$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002e01cfbb78$bf297ab0$3d7c7010$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 02:41:44PM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Saturday, August 16, 2014 5:58 AM
> > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Subject: Re: [f2fs-dev] [PATCH 08/13 v2] f2fs: do checkpoint at f2fs_put_super
> > 
> > Change log from v1:
> >  o relocate F2FS_SET_SB_DIRT to avoid unnecessary checkpoints
> 
> In umount, we will encounter memory leak as we may skip releasing dirty inode
> when IO error occurred in cp. Why not just invoking release_dirty_inode directly
> in f2fs_put_super?

Correct. The release_dirty_inode call will be added to handle -EIO through the
following patch.

Ok, so I need to drop this patch and rewrite another patch to make the issue
clear.
Actually the patch will include:
-	if (sbi->s_dirty && get_pages(sbi, F2FS_DIRTY_NODES))
+	if (sbi->s_dirty)

Thanks,

> 
> Thanks,
> Yu
> 
> > 
> > The generic_shutdown_super calls sync_filesystem, evict_inode, and then
> > f2fs_put_super. In f2fs_evict_inode, we remain some dirty inode information
> > so we should release them at f2fs_put_super.
> > 
> > But normally, it's more reasonable to set its superblock as dirty when
> > evict_inode is called.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/checkpoint.c | 1 +
> >  fs/f2fs/super.c      | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > index 7e1c13b..01e1796 100644
> > --- a/fs/f2fs/checkpoint.c
> > +++ b/fs/f2fs/checkpoint.c
> > @@ -330,6 +330,7 @@ void add_dirty_inode(struct f2fs_sb_info *sbi, nid_t ino, int type)
> >  {
> >  	/* add new dirty ino entry into list */
> >  	__add_ino_entry(sbi, ino, type);
> > +	F2FS_SET_SB_DIRT(sbi);
> >  }
> > 
> >  void remove_dirty_inode(struct f2fs_sb_info *sbi, nid_t ino, int type)
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
> > 
> > ------------------------------------------------------------------------------
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
