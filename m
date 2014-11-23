Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750812AbaKWKJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 05:09:00 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55993 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaKWKI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 05:08:57 -0500
Date: Sun, 23 Nov 2014 11:08:54 +0100
From: Simon Baatz <gmbnomis@gmail.com>
To: Changman Lee <cm224.lee@samsung.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: call flush_dcache_page when the
 page was updated
Message-ID: <20141123100853.GA6356@schnuecks.de>
References: <1416436510-6251-1-git-send-email-jaegeuk@kernel.org>
 <20141120060410.GB3117@lcm>
 <20141120064533.GA8860@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20141120084729.GA4740@lcm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120084729.GA4740@lcm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Changman, Jaegeuk,

On Thu, Nov 20, 2014 at 05:47:29PM +0900, Changman Lee wrote:
> On Wed, Nov 19, 2014 at 10:45:33PM -0800, Jaegeuk Kim wrote:
> > On Thu, Nov 20, 2014 at 03:04:10PM +0900, Changman Lee wrote:
> > > Hi Jaegeuk,
> > > 
> > > We should call flush_dcache_page before kunmap because the purpose of the cache flush is to address aliasing problem related to virtual address.
> > 
> > Oh, I just followed zero_user_segments below.
> > 
> > static inline void zero_user_segments(struct page *page,
> > 	unsigned start1, unsigned end1,
> > 	unsigned start2, unsigned end2)
> > {
> > 	void *kaddr = kmap_atomic(page);
> > 
> > 	BUG_ON(end1 > PAGE_SIZE || end2 > PAGE_SIZE);
> > 
> > 	if (end1 > start1)
> > 		memset(kaddr + start1, 0, end1 - start1);
> > 
> > 	if (end2 > start2)
> > 		memset(kaddr + start2, 0, end2 - start2);
> > 
> > 	kunmap_atomic(kaddr);
> > 	flush_dcache_page(page);
> > }
> > 
> > Is this a wrong reference? Or, a bug?
> > 
> 
> Well.. Data in cache only have to be flushed until before other users read the data.
> If so, it's not a bug.
> 

Yes, it is not a bug, since flush_dcache_page() needs to be able to
deal with non-kmapped pages. However, this may create overhead in
some situations.

According to documentation (see Documentation/cachetlb.txt), this is
a use for flush_kernel_dcache_page(), since the page has been
modified by the kernel only.  In contrast to flush_dcache_page(),
this function must be called before kunmap().

flush_kernel_dcache_page() does not need to flush the user space
aliases.  Additionally, at least on ARM, it does not flush at all
when called within kmap_atomic()/kunmap_atomic(), when
kunmap_atomic() is going to flush the page anyway.  (I know that
almost no one uses flush_kernel_dcache_page() (probably because
almost no one knows when to use which of the two functions), but it
may save a few cache flushes on architectures which are affected by
aliasing)


> > Anyway I modified as below.
> > 
> > Thanks,
> > 
> > >From 7cb7b27c8cd2efc8a31d79239bef5b41c6e79216 Mon Sep 17 00:00:00 2001
> > From: Jaegeuk Kim <jaegeuk@kernel.org>
> > Date: Tue, 18 Nov 2014 10:50:21 -0800
> > Subject: [PATCH] f2fs: call flush_dcache_page when the page was updated
> > 
> > Whenever f2fs updates mapped pages, it needs to call flush_dcache_page.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/dir.c    | 7 ++++++-
> >  fs/f2fs/inline.c | 2 ++
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> > index 5a49995..fabf4ee 100644
> > --- a/fs/f2fs/dir.c
> > +++ b/fs/f2fs/dir.c
> > @@ -287,8 +287,10 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
> >  	f2fs_wait_on_page_writeback(page, type);
> >  	de->ino = cpu_to_le32(inode->i_ino);
> >  	set_de_type(de, inode);
> > -	if (!f2fs_has_inline_dentry(dir))
> > +	if (!f2fs_has_inline_dentry(dir)) {
> > +		flush_dcache_page(page);
> >  		kunmap(page);
> > +	}

Is this a page that may be mapped into user space? (I may be
completely wrong here, since I have no idea how this code works.  But
it looks like as if the answer is "no" ;-) ).

It is not necessary to flush pages that cannot be seen by user space
(see also the NOTE in the documentation of flush_dcache_page() in
cachetlb.txt). Thus, if you know that a page will not be mapped into
user space, please don't create the overhead of flushing it.


- Simon
