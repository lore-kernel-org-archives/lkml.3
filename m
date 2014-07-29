Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaG2NAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:00:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:48815 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaG2NAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:00:04 -0400
Date: Tue, 29 Jul 2014 06:00:25 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 10/11] f2fs: avoid checkpoint when error was
 occurred
Message-ID: <20140729130025.GA86905@jaegeuk-mac02>
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-10-git-send-email-jaegeuk@kernel.org>
 <008301cfab22$27e34fc0$77a9ef40$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008301cfab22$27e34fc0$77a9ef40$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Tue, Jul 29, 2014 at 07:41:35PM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Saturday, July 26, 2014 6:47 AM
> > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Cc: Jaegeuk Kim
> > Subject: [f2fs-dev] [PATCH 10/11] f2fs: avoid checkpoint when error was occurred
> > 
> > No need to do checkpoint, whenever any errors were detected.
> > 
> 
> The code here is modified once at below commit for avoid unneeded cp.
> You can see the reason through the description of the commit.
> 
> Commit 691c6fd2a2d6 ("remove unneeded write checkpoint in recover_fsync_data")
> 
> "Previously, recover_fsync_data still to write checkpoint when there is
> nothing to recover with normal umount image.
> It may reduce mount performance and flash memory lifetime, so let's remove
> it."
> 
> Why we should revert the commit?

Agreed.
Let's ignore this patch. :)
Thanks,

> 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/recovery.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> > 
> > diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> > index a112368..90d7e80 100644
> > --- a/fs/f2fs/recovery.c
> > +++ b/fs/f2fs/recovery.c
> > @@ -436,7 +436,6 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
> >  {
> >  	struct list_head inode_list;
> >  	int err;
> > -	bool need_writecp = false;
> > 
> >  	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
> >  			sizeof(struct fsync_inode_entry));
> > @@ -454,8 +453,6 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
> >  	if (list_empty(&inode_list))
> >  		goto out;
> > 
> > -	need_writecp = true;
> > -
> >  	/* step #2: recover data */
> >  	err = recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
> >  	f2fs_bug_on(!list_empty(&inode_list));
> > @@ -463,7 +460,7 @@ out:
> >  	destroy_fsync_dnodes(&inode_list);
> >  	kmem_cache_destroy(fsync_entry_slab);
> >  	sbi->por_doing = false;
> > -	if (!err && need_writecp)
> > +	if (!err)
> >  		write_checkpoint(sbi, false);
> >  	return err;
> >  }
> > --
> > 1.8.5.2 (Apple Git-48)
> > 
> > 
> > ------------------------------------------------------------------------------
> > Want fast and easy access to all the code in your enterprise? Index and
> > search up to 200,000 lines of code with a free copy of Black Duck
> > Code Sight - the same software that powers the world's largest code
> > search on Ohloh, the Black Duck Open Hub! Try it now.
> > http://p.sf.net/sfu/bds
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
