Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaG2Mm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:42:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:48071 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbaG2Mm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:42:56 -0400
Date: Tue, 29 Jul 2014 05:43:17 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 06/11] f2fs: skip unnecessary data writes
 during fsync
Message-ID: <20140729124317.GE84378@jaegeuk-mac02>
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-6-git-send-email-jaegeuk@kernel.org>
 <008201cfab21$e5c57ff0$b1507fd0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008201cfab21$e5c57ff0$b1507fd0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 07:39:45PM +0800, Chao Yu wrote:
> Hi,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Saturday, July 26, 2014 6:47 AM
> > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Cc: Jaegeuk Kim
> > Subject: [f2fs-dev] [PATCH 06/11] f2fs: skip unnecessary data writes during fsync
> > 
> > This patch intends to improve the fsync performance by skipping remaining the
> > recovery information, only when there is no data that we should recover.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/file.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > index 7c652b3..121689a 100644
> > --- a/fs/f2fs/file.c
> > +++ b/fs/f2fs/file.c
> > @@ -133,6 +133,17 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int
> > datasync)
> >  		return ret;
> >  	}
> > 
> > +	/*
> > +	 * if there is no written data, don't waste time to write recovery info.
> > +	 */
> > +	if (!is_inode_flag_set(fi, FI_APPEND_WRITE) &&
> > +		!exist_written_data(sbi, inode->i_ino, APPEND_INO)) {
> > +		if (is_inode_flag_set(fi, FI_UPDATE_WRITE) &&
> > +			exist_written_data(sbi, inode->i_ino, UPDATE_INO))
> 
> Should we shift this to is_inode_flag_set(fi, FI_UPDATE_WRITE) ||
> exist_written_data(sbi, inode->i_ino, UPDATE_INO) ?

Hehe, I found that and was going to submit new patch. :)
Small changes are not a big deal, so I'll test and then push them into the tree.
The for-next tree can be rebased all the time, so if you have any suggestion,
let me know.

Thanks,

> 
> > +			goto flush_out;
> > +		goto out;
> > +	}
> > +
> >  	/* guarantee free sections for fsync */
> >  	f2fs_balance_fs(sbi);
> > 
> > @@ -188,6 +199,11 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int
> > datasync)
> >  		ret = wait_on_node_pages_writeback(sbi, inode->i_ino);
> >  		if (ret)
> >  			goto out;
> > +
> > +		/* once recovery info is written, don't need to tack this */
> > +		remove_dirty_inode(sbi, inode->i_ino, APPEND_INO);
> > +flush_out:
> > +		remove_dirty_inode(sbi, inode->i_ino, UPDATE_INO);
> >  		ret = f2fs_issue_flush(F2FS_SB(inode->i_sb));
> >  	}
> >  out:
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
