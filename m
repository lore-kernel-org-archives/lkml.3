Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbaLWTFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 14:05:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:44264 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaLWTFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 14:05:47 -0500
Date: Tue, 23 Dec 2014 11:05:37 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 6/6] f2fs: avoid double lock for cp_rwsem
Message-ID: <20141223190537.GB12880@jaegeuk-mac02>
References: <1419179723-3234-1-git-send-email-jaegeuk@kernel.org>
 <1419179723-3234-6-git-send-email-jaegeuk@kernel.org>
 <003201d01e7e$66126ae0$323740a0$@samsung.com>
 <20141223074041.GB9946@jaegeuk-mac02.hsd1.ca.comcast.net>
 <003801d01e8e$c496f080$4dc4d180$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003801d01e8e$c496f080$4dc4d180$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 04:58:46PM +0800, Chao Yu wrote:
> Hi Jaegeuk,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > Sent: Tuesday, December 23, 2014 3:41 PM
> > To: Chao Yu
> > Cc: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Subject: Re: [f2fs-dev] [PATCH 6/6] f2fs: avoid double lock for cp_rwsem
> > 
> > Hi,
> > 
> > On Tue, Dec 23, 2014 at 03:01:36PM +0800, Chao Yu wrote:
> > > Hi Jaegeuk,
> > >
> > > > -----Original Message-----
> > > > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > > > Sent: Monday, December 22, 2014 12:35 AM
> > > > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > > > linux-f2fs-devel@lists.sourceforge.net
> > > > Cc: Jaegeuk Kim
> > > > Subject: [f2fs-dev] [PATCH 6/6] f2fs: avoid double lock for cp_rwsem
> > > >
> > > > The __f2fs_add_link is covered by cp_rwsem all the time.
> > > > This calls init_inode_metadata, which conducts some acl operations including
> > > > memory allocation with GFP_KERNEL previously.
> > > > But, under memory pressure, f2fs_write_data_page can be called, which also
> > > > grabs cp_mutex too.
> > >
> > > grabs cp_rwsem.
> > 
> > Got it.
> > 
> > >
> > > > Basically, it's safe since down_read was used in both of cases, but it'd
> > > > better avoid this situation in advance.
> > >
> > > If checkpoint intend to hold down_write in the middle of the two down_read
> > > caller, it will cause a deadlock, so it's not safe.
> > 
> > What I meant was like this.
> > - down_read
> 
> If someone else intends to hold down_write (in checkpoint()) here,
> we will encounter deadlock.
> 
> Because this writer will add itself to inner waiter list of spinlock as there
> is an exist reader had held this lock, then the following reader will start to
> spin as it detect that waiter list is not empty. Then deadlock occurred.

Ah ha. I see. :)
I'll change the description.

Thanks,

> 
> I guess this design can effectively avoid starve for the writer when encounters
> a large number of readers.
> 
> Thanks
> 
> >   - down_read
> >   - up_read
> > - up_read
> > 
> > This should be safe, right?
> > Thanks,
> > 
> > >
> > > Could you update the comments?
> > >
> > > >
> > > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > >
> > > Anyway, Nice catch and please add:
> > >
> > > Reviewed-by: Chao Yu <chao2.yu@samsung.com>
> > >
> > > > ---
> > > >  fs/f2fs/acl.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
> > > > index 1ccb26b..7f12d28 100644
> > > > --- a/fs/f2fs/acl.c
> > > > +++ b/fs/f2fs/acl.c
> > > > @@ -62,7 +62,7 @@ static struct posix_acl *f2fs_acl_from_disk(const char *value, size_t
> > size)
> > > >  	if (count == 0)
> > > >  		return NULL;
> > > >
> > > > -	acl = posix_acl_alloc(count, GFP_KERNEL);
> > > > +	acl = posix_acl_alloc(count, GFP_NOFS);
> > > >  	if (!acl)
> > > >  		return ERR_PTR(-ENOMEM);
> > > >
> > > > @@ -116,7 +116,7 @@ static void *f2fs_acl_to_disk(const struct posix_acl *acl, size_t *size)
> > > >  	int i;
> > > >
> > > >  	f2fs_acl = kmalloc(sizeof(struct f2fs_acl_header) + acl->a_count *
> > > > -			sizeof(struct f2fs_acl_entry), GFP_KERNEL);
> > > > +			sizeof(struct f2fs_acl_entry), GFP_NOFS);
> > > >  	if (!f2fs_acl)
> > > >  		return ERR_PTR(-ENOMEM);
> > > >
> > > > --
> > > > 2.1.1
> > > >
> > > >
> > > > ------------------------------------------------------------------------------
> > > > Download BIRT iHub F-Type - The Free Enterprise-Grade BIRT Server
> > > > from Actuate! Instantly Supercharge Your Business Reports and Dashboards
> > > > with Interactivity, Sharing, Native Excel Exports, App Integration & more
> > > > Get technology previously reserved for billion-dollar corporations, FREE
> > > > http://pubads.g.doubleclick.net/gampad/clk?id=164703151&iu=/4140/ostg.clktrk
> > > > _______________________________________________
> > > > Linux-f2fs-devel mailing list
> > > > Linux-f2fs-devel@lists.sourceforge.net
> > > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
