Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964991AbaKNBVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:21:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:43895 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964913AbaKNBVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:21:31 -0500
Date: Thu, 13 Nov 2014 17:21:27 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Changman Lee <cm224.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 1/5] f2fs: disable roll-forward when
 active_logs = 2
Message-ID: <20141114012127.GA49179@jaegeuk-mac02.mot.com>
References: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
 <20141110095437.GE14659@lcm>
 <20141110150759.GB25172@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20141111224312.GA16657@lcm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111224312.GA16657@lcm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 07:43:12AM +0900, Changman Lee wrote:
> On Mon, Nov 10, 2014 at 07:07:59AM -0800, Jaegeuk Kim wrote:
> > Hi Changman,
> > 
> > On Mon, Nov 10, 2014 at 06:54:37PM +0900, Changman Lee wrote:
> > > On Sat, Nov 08, 2014 at 11:36:05PM -0800, Jaegeuk Kim wrote:
> > > > The roll-forward mechanism should be activated when the number of active
> > > > logs is not 2.
> > > > 
> > > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > ---
> > > >  fs/f2fs/file.c    | 2 ++
> > > >  fs/f2fs/segment.c | 4 ++--
> > > >  2 files changed, 4 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > > > index 46311e7..54722a0 100644
> > > > --- a/fs/f2fs/file.c
> > > > +++ b/fs/f2fs/file.c
> > > > @@ -132,6 +132,8 @@ static inline bool need_do_checkpoint(struct inode *inode)
> > > >  		need_cp = true;
> > > >  	else if (test_opt(sbi, FASTBOOT))
> > > >  		need_cp = true;
> > > > +	else if (sbi->active_logs == 2)
> > > > +		need_cp = true;
> > > >  
> > > >  	return need_cp;
> > > >  }
> > > > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > > > index 2fb3d7f..16721b5d 100644
> > > > --- a/fs/f2fs/segment.c
> > > > +++ b/fs/f2fs/segment.c
> > > > @@ -1090,8 +1090,8 @@ static int __get_segment_type_4(struct page *page, enum page_type p_type)
> > > >  		else
> > > >  			return CURSEG_COLD_DATA;
> > > >  	} else {
> > > > -		if (IS_DNODE(page) && !is_cold_node(page))
> > > > -			return CURSEG_HOT_NODE;
> > > > +		if (IS_DNODE(page) && is_cold_node(page))
> > > > +			return CURSEG_WARM_NODE;
> > > 
> > > Hi Jaegeuk,
> > > 
> > > We should take hot/cold seperation into account as well.
> > > In case of dir inode, it will be mixed with COLD_NODE.
> > > If it's trade-off, let's notice it kindly as comments.
> > 
> > NAK.
> > This patch tries to fix a bug, which is not a trade-off.
> > We should write files' direct node blocks in CURSEG_WARM_NODE for recovery.
> > 
> > Thanks,
> 
> Okay, a word of 'trade-off' is wrong. We must be able to do recovery.
> However, we break a rule of hot/cold separation we want. So I thought we
> should notice its negative effect.
> Anyway, how about putting WARM and HOT together instead HOT and COLD?
> We can distinguish enough if they are direct node and have fsync_mark at
> recovery time although HOT/WARM are mixed.

We know that it's hard to say any negative effect on each way, since it depends
on the workloads.

At least, however, we need to avoid mixing dir/files, since it increases the
roll-forward recovery time incredibly.
IMO, this is enough reason for not using that.

Thanks,

> Let me know if there is my misundertanding.
> 
> Thanks,
> 
> > 
> > > 
> > > Regards,
> > > Changman
> > > 
> > > >  		else
> > > >  			return CURSEG_COLD_NODE;
> > > >  	}
> > > > -- 
> > > > 2.1.1
> > > > 
> > > > 
> > > > ------------------------------------------------------------------------------
> > > > _______________________________________________
> > > > Linux-f2fs-devel mailing list
> > > > Linux-f2fs-devel@lists.sourceforge.net
> > > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
