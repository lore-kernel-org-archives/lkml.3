Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445AbaKSWdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:33:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:53881 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320AbaKSWdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:33:07 -0500
Date: Wed, 19 Nov 2014 14:33:01 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 2/2] f2fs: put the inode page when error was
 occurred
Message-ID: <20141119223301.GA6116@jaegeuk-mac02>
References: <1416275874-74186-1-git-send-email-jaegeuk@kernel.org>
 <1416275874-74186-2-git-send-email-jaegeuk@kernel.org>
 <006b01d002f0$f6da1b80$e48e5280$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <006b01d002f0$f6da1b80$e48e5280$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 01:30:46PM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Tuesday, November 18, 2014 9:58 AM
> > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Cc: Jaegeuk Kim
> > Subject: [f2fs-dev] [PATCH 2/2] f2fs: put the inode page when error was occurred
> > 
> > We should put the inode page when error was occurred.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> 
> You can add Reviewed-by: Chao Yu <chao2.yu@samsung.com>
> after the following issue is fixed.
> 
> > ---
> >  fs/f2fs/data.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index 8f16443..12dd58a 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -963,22 +963,22 @@ repeat:
> >  		} else if (page->index == 0) {
> >  			err = f2fs_convert_inline_page(&dn, page);
> >  			if (err)
> > -				goto unlock_fail;
> > +				goto put_fail;
> >  		} else {
> >  			struct page *p = grab_cache_page(inode->i_mapping, 0);
> >  			if (!p) {
> >  				err = -ENOMEM;
> > -				goto unlock_fail;
> > +				goto put_fail;
> >  			}
> >  			err = f2fs_convert_inline_page(&dn, p);
> >  			f2fs_put_page(p, 1);
> >  			if (err)
> > -				goto unlock_fail;
> > +				goto put_fail;
> >  		}
> >  	}
> >  	err = f2fs_reserve_block(&dn, index);
> >  	if (err)
> > -		goto unlock_fail;
> > +		goto put_fail;
> 
> f2fs_reserve_block will do the clean work, we should not release dn again.

Well, I added this to handle errors consistently.
It's harmless, since f2fs_put_dnode removes the pointers after putting them.

Thanks,

> 
> Thanks,
> Yu
> 
> >  put_next:
> >  	f2fs_put_dnode(&dn);
> >  	f2fs_unlock_op(sbi);
> > @@ -1021,6 +1021,8 @@ out:
> >  	clear_cold_data(page);
> >  	return 0;
> > 
> > +put_fail:
> > +	f2fs_put_dnode(&dn);
> >  unlock_fail:
> >  	f2fs_unlock_op(sbi);
> >  	f2fs_put_page(page, 1);
> > --
> > 2.1.1
> > 
> > 
> > ------------------------------------------------------------------------------
> > Download BIRT iHub F-Type - The Free Enterprise-Grade BIRT Server
> > from Actuate! Instantly Supercharge Your Business Reports and Dashboards
> > with Interactivity, Sharing, Native Excel Exports, App Integration & more
> > Get technology previously reserved for billion-dollar corporations, FREE
> > http://pubads.g.doubleclick.net/gampad/clk?id=157005751&iu=/4140/ostg.clktrk
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
