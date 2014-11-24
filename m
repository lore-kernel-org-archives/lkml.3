Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaKXGEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:04:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:47866 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbaKXGEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:04:01 -0500
Date: Sun, 23 Nov 2014 22:04:03 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Changman Lee <cm224.lee@samsung.com>
Cc: Simon Baatz <gmbnomis@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: call flush_dcache_page when the
 page was updated
Message-ID: <20141124060403.GB24467@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <1416436510-6251-1-git-send-email-jaegeuk@kernel.org>
 <20141120060410.GB3117@lcm>
 <20141120064533.GA8860@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20141120084729.GA4740@lcm>
 <20141123100853.GA6356@schnuecks.de>
 <20141124024646.GB4740@lcm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124024646.GB4740@lcm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 11:46:46AM +0900, Changman Lee wrote:
> Hi Simon,
> Thanks for your explanation kindly.
> 
> On Sun, Nov 23, 2014 at 11:08:54AM +0100, Simon Baatz wrote:
> > Hi Changman, Jaegeuk,
> > 
> > On Thu, Nov 20, 2014 at 05:47:29PM +0900, Changman Lee wrote:
> > > On Wed, Nov 19, 2014 at 10:45:33PM -0800, Jaegeuk Kim wrote:
> > > > On Thu, Nov 20, 2014 at 03:04:10PM +0900, Changman Lee wrote:
> > > > > Hi Jaegeuk,
> > > > > 
> > > > > We should call flush_dcache_page before kunmap because the purpose of the cache flush is to address aliasing problem related to virtual address.
> > > > 
> > > > Oh, I just followed zero_user_segments below.
> > > > 
> > > > static inline void zero_user_segments(struct page *page,
> > > > 	unsigned start1, unsigned end1,
> > > > 	unsigned start2, unsigned end2)
> > > > {
> > > > 	void *kaddr = kmap_atomic(page);
> > > > 
> > > > 	BUG_ON(end1 > PAGE_SIZE || end2 > PAGE_SIZE);
> > > > 
> > > > 	if (end1 > start1)
> > > > 		memset(kaddr + start1, 0, end1 - start1);
> > > > 
> > > > 	if (end2 > start2)
> > > > 		memset(kaddr + start2, 0, end2 - start2);
> > > > 
> > > > 	kunmap_atomic(kaddr);
> > > > 	flush_dcache_page(page);
> > > > }
> > > > 
> > > > Is this a wrong reference? Or, a bug?
> > > > 
> > > 
> > > Well.. Data in cache only have to be flushed until before other users read the data.
> > > If so, it's not a bug.
> > > 
> > 
> > Yes, it is not a bug, since flush_dcache_page() needs to be able to
> > deal with non-kmapped pages. However, this may create overhead in
> > some situations.
> > 
> 
> Previously, I was vague but I thought that it should be different
> according to vaddr exists or not. So I told jaegeuk that it should
> be better to change an order between flush_dache_page and kunmap.
> But actually, it doesn't matter the order between them except
> the situation you said.
> Could you explain the situation that makes overhead by flushing after kummap.
> I can't imagine it by just seeing flush_dcache_page code.
> 
> > According to documentation (see Documentation/cachetlb.txt), this is
> > a use for flush_kernel_dcache_page(), since the page has been
> > modified by the kernel only.  In contrast to flush_dcache_page(),
> > this function must be called before kunmap().
> > 
> > flush_kernel_dcache_page() does not need to flush the user space
> > aliases.  Additionally, at least on ARM, it does not flush at all
> > when called within kmap_atomic()/kunmap_atomic(), when
> > kunmap_atomic() is going to flush the page anyway.  (I know that
> > almost no one uses flush_kernel_dcache_page() (probably because
> > almost no one knows when to use which of the two functions), but it
> > may save a few cache flushes on architectures which are affected by
> > aliasing)
> > 
> > 
> > > > Anyway I modified as below.
> > > > 
> > > > Thanks,
> > > > 
> > > > >From 7cb7b27c8cd2efc8a31d79239bef5b41c6e79216 Mon Sep 17 00:00:00 2001
> > > > From: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > Date: Tue, 18 Nov 2014 10:50:21 -0800
> > > > Subject: [PATCH] f2fs: call flush_dcache_page when the page was updated
> > > > 
> > > > Whenever f2fs updates mapped pages, it needs to call flush_dcache_page.
> > > > 
> > > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > ---
> > > >  fs/f2fs/dir.c    | 7 ++++++-
> > > >  fs/f2fs/inline.c | 2 ++
> > > >  2 files changed, 8 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> > > > index 5a49995..fabf4ee 100644
> > > > --- a/fs/f2fs/dir.c
> > > > +++ b/fs/f2fs/dir.c
> > > > @@ -287,8 +287,10 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
> > > >  	f2fs_wait_on_page_writeback(page, type);
> > > >  	de->ino = cpu_to_le32(inode->i_ino);
> > > >  	set_de_type(de, inode);
> > > > -	if (!f2fs_has_inline_dentry(dir))
> > > > +	if (!f2fs_has_inline_dentry(dir)) {
> > > > +		flush_dcache_page(page);
> > > >  		kunmap(page);
> > > > +	}
> > 
> > Is this a page that may be mapped into user space? (I may be
> > completely wrong here, since I have no idea how this code works.  But
> > it looks like as if the answer is "no" ;-) ).
> > 
> > It is not necessary to flush pages that cannot be seen by user space
> > (see also the NOTE in the documentation of flush_dcache_page() in
> > cachetlb.txt). Thus, if you know that a page will not be mapped into
> > user space, please don't create the overhead of flushing it.
> > 
> 
> In the case of dentry unlike inline data, this is not mapped to user space, so dcache flush
> makes overhead. Do you mean that?
> 
> Best regard,
> Changman

Hi Changman,

This would be ok though.

>From 5c1c46d31452a59a37c96f6dcae600776a8002e3 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Tue, 18 Nov 2014 10:50:21 -0800
Subject: [PATCH v2] f2fs: call flush_dcache_page when the page was updated

Change log from v1:
 o remove flush_dcache_page calls for dentry pages.

Whenever f2fs updates mapped pages, it needs to call flush_dcache_page.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index f26fb87..914b6d3 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -106,6 +106,7 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 	src_addr = inline_data_addr(dn->inode_page);
 	dst_addr = kmap_atomic(page);
 	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
+	flush_dcache_page(page);
 	kunmap_atomic(dst_addr);
 	SetPageUptodate(page);
 no_update:
-- 
2.1.1

