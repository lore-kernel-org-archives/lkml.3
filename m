Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbaIIHJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:09:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:58074 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334AbaIIHJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:09:41 -0400
Date: Tue, 9 Sep 2014 00:09:35 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        huang.ying.caritas@gmail.com
Subject: Re: [PATCH] f2fs: Fix recover when nid of non-inode dnode < nid of
 inode
Message-ID: <20140909070811.GA26657@jaegeuk-mac02.mot-mobility.com>
References: <1410176306-1689-1-git-send-email-ying.huang@intel.com>
 <20140909052356.GA25590@jaegeuk-mac02.hsd1.ca.comcast.net>
 <1410241170.732.373.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410241170.732.373.camel@yhuang-dev>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 09, 2014 at 01:39:30PM +0800, Huang Ying wrote:
> On Mon, 2014-09-08 at 22:23 -0700, Jaegeuk Kim wrote:
> > Hi Huang,
> > 
> > On Mon, Sep 08, 2014 at 07:38:26PM +0800, Huang Ying wrote:
> > > For fsync, if the nid of a non-inode dnode < nid of inode and the
> > > inode is not checkpointed.  The non-inode dnode may be written before
> > > inode.  So in find_fsync_dnodes, f2fs_iget will fail, cause the
> > > recovery fail.
> > > 
> > > Usually, inode will be allocated before non-inode dnode, so the nid of
> > > inode < nid of non-inode dnode.  But it is possible for the reverse.
> > > For example, because of alloc_nid_failed.
> > > 
> > > This is fixed via ignoring non-inode dnode before inode dnode in
> > > find_fsync_dnodes.
> > > 
> > > The patch was tested via allocating nid reversely via a debugging
> > > patch, that is, from big number to small number.
> > > 
> > > Signed-off-by: Huang, Ying <ying.huang@intel.com>
> > > ---
> > >  fs/f2fs/recovery.c |    7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > --- a/fs/f2fs/recovery.c
> > > +++ b/fs/f2fs/recovery.c
> > > @@ -172,8 +172,8 @@ static int find_fsync_dnodes(struct f2fs
> > >  			if (IS_INODE(page) && is_dent_dnode(page))
> > >  				set_inode_flag(F2FS_I(entry->inode),
> > >  							FI_INC_LINK);
> > > -		} else {
> > > -			if (IS_INODE(page) && is_dent_dnode(page)) {
> > 
> > If this is not inode block, we should add this inode to recover its data blocks.
> 
> Is it possible that there is only non-inode dnode but no inode when
> find_fsync_dnodes checking dnodes?  Per my understanding, any changes to
> file will cause inode page dirty (for example, mtime changed), so that
> we will write inode block.  Is it right?  If so, the solution in this
> patch should work too.

Your description says that f2fs_iget will fail, which causes the recovery fail.
So, I thought it would be better to handle the f2fs_iget failure directly.

In addition, we cannot guarantee the write order of dnode and inode.
For exmaple,
1. the inode is written by flusher or kswapd, then,
2. f2fs_sync_file writes its dnode.

In that case, we can get only non-inode dnode in the node chain, since the inode
has not fsync_mark.

Thanks,

> 
> Best Regards,
> Huang, Ying
> 
> > Rather than this tweak, if iget is failed, we'd better go to next instead of
> > break.
> > Can you test that?
> > 
> > > +		} else if (IS_INODE(page)) {
> > > +			if (is_dent_dnode(page)) {
> > >  				err = recover_inode_page(sbi, page);
> > >  				if (err)
> > >  					break;
> > > @@ -193,7 +193,8 @@ static int find_fsync_dnodes(struct f2fs
> > >  				break;
> > >  			}
> > >  			list_add_tail(&entry->list, head);
> > > -		}
> > > +		} else
> > > +			goto next;
> > >  		entry->blkaddr = blkaddr;
> > >  
> > >  		err = recover_inode(entry->inode, page);
