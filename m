Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaLWI7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:59:41 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:56260 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaLWI7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:59:38 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-3b-54992ef49faf
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1419179723-3234-1-git-send-email-jaegeuk@kernel.org>
 <1419179723-3234-6-git-send-email-jaegeuk@kernel.org>
 <003201d01e7e$66126ae0$323740a0$@samsung.com>
 <20141223074041.GB9946@jaegeuk-mac02.hsd1.ca.comcast.net>
In-reply-to: <20141223074041.GB9946@jaegeuk-mac02.hsd1.ca.comcast.net>
Subject: RE: [f2fs-dev] [PATCH 6/6] f2fs: avoid double lock for cp_rwsem
Date: Tue, 23 Dec 2014 16:58:46 +0800
Message-id: <003801d01e8e$c496f080$4dc4d180$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG1NCgn0vPNMcmFarKO/1VZ45E3HgHz1ZrOAez3nYIBn8/U+5ymqa0A
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAd2vejNDDHqWsFg8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlbH2xXaWgsNyFT87
	TzA3MK6S6GLk5JAQMJHY3LubFcIWk7hwbz1bFyMXh5DAIkaJlu7/7CAJIYEfjBIPXnmA2GwC
	KhLLO/4zgdgiAmoSvfumgNnMApkSE/pfsEM0P2WUeN64FqyZU8BN4vnkHUBTOTiEBTwkdnWV
	goRZBFQlDh95ygxi8wpYSmzvecgEYQtK/Jh8jwVippbE+p3HoebLS2xe85YZ4lAFiR1nXzNC
	3OAmcePgTUaIGnGJjUdusUxgFJqFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6blGesWJucWl
	eel6yfm5mxjBgf9MegfjqgaLQ4wCHIxKPLwLzswIEWJNLCuuzD3EKMHBrCTC+1J8ZogQb0pi
	ZVVqUX58UWlOavEhRmkOFiVxXiX7thAhgfTEktTs1NSC1CKYLBMHp1QDY85GJ7E3DyqWq7bk
	XV+YztsovOXHrPols3Z0yrV0GD4wTnNa+tyo2OVW14Vn1UUZz698nn3IN2cjh41oFg+P4u3I
	Yu9ApnsKypFt86r9Su+nNPXPe573YEL7yo3vc5WOC/O131cMNApvmXEtvHphs/L+vly+9Edp
	F2MZiqKmK4U47HS91fldiaU4I9FQi7moOBEAsRq3V3gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Tuesday, December 23, 2014 3:41 PM
> To: Chao Yu
> Cc: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH 6/6] f2fs: avoid double lock for cp_rwsem
> 
> Hi,
> 
> On Tue, Dec 23, 2014 at 03:01:36PM +0800, Chao Yu wrote:
> > Hi Jaegeuk,
> >
> > > -----Original Message-----
> > > From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> > > Sent: Monday, December 22, 2014 12:35 AM
> > > To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> > > linux-f2fs-devel@lists.sourceforge.net
> > > Cc: Jaegeuk Kim
> > > Subject: [f2fs-dev] [PATCH 6/6] f2fs: avoid double lock for cp_rwsem
> > >
> > > The __f2fs_add_link is covered by cp_rwsem all the time.
> > > This calls init_inode_metadata, which conducts some acl operations including
> > > memory allocation with GFP_KERNEL previously.
> > > But, under memory pressure, f2fs_write_data_page can be called, which also
> > > grabs cp_mutex too.
> >
> > grabs cp_rwsem.
> 
> Got it.
> 
> >
> > > Basically, it's safe since down_read was used in both of cases, but it'd
> > > better avoid this situation in advance.
> >
> > If checkpoint intend to hold down_write in the middle of the two down_read
> > caller, it will cause a deadlock, so it's not safe.
> 
> What I meant was like this.
> - down_read

If someone else intends to hold down_write (in checkpoint()) here,
we will encounter deadlock.

Because this writer will add itself to inner waiter list of spinlock as there
is an exist reader had held this lock, then the following reader will start to
spin as it detect that waiter list is not empty. Then deadlock occurred.

I guess this design can effectively avoid starve for the writer when encounters
a large number of readers.

Thanks

>   - down_read
>   - up_read
> - up_read
> 
> This should be safe, right?
> Thanks,
> 
> >
> > Could you update the comments?
> >
> > >
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> >
> > Anyway, Nice catch and please add:
> >
> > Reviewed-by: Chao Yu <chao2.yu@samsung.com>
> >
> > > ---
> > >  fs/f2fs/acl.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
> > > index 1ccb26b..7f12d28 100644
> > > --- a/fs/f2fs/acl.c
> > > +++ b/fs/f2fs/acl.c
> > > @@ -62,7 +62,7 @@ static struct posix_acl *f2fs_acl_from_disk(const char *value, size_t
> size)
> > >  	if (count == 0)
> > >  		return NULL;
> > >
> > > -	acl = posix_acl_alloc(count, GFP_KERNEL);
> > > +	acl = posix_acl_alloc(count, GFP_NOFS);
> > >  	if (!acl)
> > >  		return ERR_PTR(-ENOMEM);
> > >
> > > @@ -116,7 +116,7 @@ static void *f2fs_acl_to_disk(const struct posix_acl *acl, size_t *size)
> > >  	int i;
> > >
> > >  	f2fs_acl = kmalloc(sizeof(struct f2fs_acl_header) + acl->a_count *
> > > -			sizeof(struct f2fs_acl_entry), GFP_KERNEL);
> > > +			sizeof(struct f2fs_acl_entry), GFP_NOFS);
> > >  	if (!f2fs_acl)
> > >  		return ERR_PTR(-ENOMEM);
> > >
> > > --
> > > 2.1.1
> > >
> > >
> > > ------------------------------------------------------------------------------
> > > Download BIRT iHub F-Type - The Free Enterprise-Grade BIRT Server
> > > from Actuate! Instantly Supercharge Your Business Reports and Dashboards
> > > with Interactivity, Sharing, Native Excel Exports, App Integration & more
> > > Get technology previously reserved for billion-dollar corporations, FREE
> > > http://pubads.g.doubleclick.net/gampad/clk?id=164703151&iu=/4140/ostg.clktrk
> > > _______________________________________________
> > > Linux-f2fs-devel mailing list
> > > Linux-f2fs-devel@lists.sourceforge.net
> > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

