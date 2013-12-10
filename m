Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab3LJJoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:44:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30612 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab3LJJo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:44:26 -0500
X-AuditID: cbfee61b-b7f006d000003e1f-e6-52a6e278c76d
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <000a01cef4a0$9f2d64a0$dd882de0$@samsung.com>
 <1386576057.2101.106.camel@kjgkr> <000c01cef54a$80fef2a0$82fcd7e0$@samsung.com>
In-reply-to: <000c01cef54a$80fef2a0$82fcd7e0$@samsung.com>
Subject: RE: [f2fs-dev] [PATCH 3/3 V3] f2fs: introduce f2fs_cache_node_page()
 to add page into node_inode cache
Date: Tue, 10 Dec 2013 17:43:33 +0800
Message-id: <000d01cef58c$66be09c0$343a1d40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJKxSoRdvYRcRdRLlc/mnXOEGcC1wEMD/ZEAg72+V2ZPLPjcA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jQd2KR8uCDFpPiFlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbH18kOWghM6FW+f
	SzUwPlXqYuTkkBAwkZhy+gobhC0mceHeeiCbi0NIYDqjxKQfF5kgnB+MEs+PPWYFqWITUJFY
	3vGfCcQWEZCWmPVpHguIzSyQKTHn9WRWiIZuRonTpx4ygyQ4Bawk7i/8A9YgLFAocaTtBVgD
	i4CqxKu7u8FW8wpYSlx9eR/KFpT4Mfke1FB1iUnzFjFD2NoST95dYIU4VUFix9nXjBBHOEns
	fXYfql5cYuORWywTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcOg/k97BuKrB4hCjAAejEg+vxL+lQUKsiWXFlbmHGCU4mJVEeFefXBYkxJuSWFmVWpQf
	X1Sak1p8iFGag0VJnPdgq3WgkEB6YklqdmpqQWoRTJaJgxMYGZocP6YWTNkYqOdXuSNrs/68
	lZyWXXGLJp/9wdBeu2ptXZ9bOi9zlUdsyklDU2G1XtM7NgrCLXNPZC6o6/Epl65ukd5evKRX
	wlbqhtV/yXBN8ahd5a0rAssnem3SOXNGasNO3a8fZWwd7qWddq4/9qWIs9/4jGHBo1Pvf7Hf
	vZj1wVvE86KpEktxRqKhFnNRcSIAGARk0XkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Chao Yu [mailto:chao2.yu@samsung.com]
> Sent: Tuesday, December 10, 2013 9:52 AM
> To: jaegeuk.kim@samsung.com
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH 3/3 V3] f2fs: introduce f2fs_cache_node_page() to add page into node_inode cache
> 
> Hi,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Monday, December 09, 2013 4:01 PM
> > To: Chao Yu
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> > Subject: Re: [f2fs-dev] [PATCH 3/3 V3] f2fs: introduce f2fs_cache_node_page() to add page into node_inode cache
> >
> > Hi,
> >
> > Sorry for the noise.
> > Once I tested this patch, I recognized that I made a mistake:
> >
> > f2fs_fill_super()
> >  1. build_segment_manager()
> >     -> restore_node_summary()
> >        -> NULL pointer exception, due to no NAT cache.
> >  2. build_node_manager()
> >
> > So, we should not call get_node_info() prior to build_node_manager().
> > And, it's not easy to change the order of build_*_manager simply.
> >
> > Let's consider in more details.
> 
> Before we call restore_node_summary(), we have read HOT_DATA
> Summary. It means already we got the NAT cache in curseg.
> Although we could not call get_node_info() directly, we still could use
> NAT cache in HOT_DATA curseg.
> 
> So how about using this cache to verify validity of page like this?
> 
> f2fs_cache_node_page()
> 	if(!looup_nat_curseg_cache())
> 		return;

Code of verification is missed here.
if (curseg cache blk_addr != current blkaddr)
	return;

> 	grab_cache_page();
> 	memcpy();
> 	SetPageUptodate();
> 	f2fs_put_page();
> 
> > Thanks,
> >
> > 2013-12-09 (월), 13:35 +0800, Chao Yu:
> > > This patch introduces f2fs_cache_node_page(), in this function, page which is
> > > readed ahead will be copy to node_inode's mapping cache.
> > > It will avoid rereading these node pages.
> > >
> > > change log:
> > >  o check validity of page by searching NAT suggested by Jaegeuk Kim.
> > >  o add 'unlikely' for compiler optimization suggested by Jaegeuk Kim.
> > >
> > > Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > ---
> > >  fs/f2fs/node.c |   39 ++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 38 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > > index 099f06f..4c6da98 100644
> > > --- a/fs/f2fs/node.c
> > > +++ b/fs/f2fs/node.c
> > > @@ -1600,13 +1600,46 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> > >  	return 0;
> > >  }
> > >
> > > +/*
> > > + * f2fs_cache_node_page() check validaty of input page by searching NAT.
> > > + * Then, it will copy updated data of vaild page to node_inode cache.
> > > + */
> > > +void f2fs_cache_node_page(struct f2fs_sb_info *sbi, struct page *page,
> > > +						nid_t nid, block_t blkaddr)
> > > +{
> > > +	struct address_space *mapping = sbi->node_inode->i_mapping;
> > > +	struct page *npage;
> > > +	struct node_info ni;
> > > +
> > > +	get_node_info(sbi, nid, &ni);
> > > +
> > > +	if (ni.blk_addr != blkaddr)
> > > +		return;
> > > +
> > > +	npage = grab_cache_page(mapping, nid);
> > > +	if (unlikely(!npage))
> > > +		return;
> > > +
> > > +	if (PageUptodate(npage)) {
> > > +		f2fs_put_page(npage, 1);
> > > +		return;
> > > +	}
> > > +
> > > +	memcpy(page_address(npage), page_address(page), PAGE_CACHE_SIZE);
> > > +
> > > +	SetPageUptodate(npage);
> > > +	f2fs_put_page(npage, 1);
> > > +
> > > +	return;
> > > +}
> > > +
> > >  int restore_node_summary(struct f2fs_sb_info *sbi,
> > >  			unsigned int segno, struct f2fs_summary_block *sum)
> > >  {
> > >  	struct f2fs_node *rn;
> > >  	struct f2fs_summary *sum_entry;
> > >  	struct page *page, *tmp;
> > > -	block_t addr;
> > > +	block_t addr, blkaddr;
> > >  	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > >  	int i, last_offset, nrpages, err = 0;
> > >  	LIST_HEAD(page_list);
> > > @@ -1624,6 +1657,7 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> > >  		if (err)
> > >  			return err;
> > >
> > > +		blkaddr = addr;
> > >  		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> > >
> > >  			lock_page(page);
> > > @@ -1633,6 +1667,8 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> > >  				sum_entry->version = 0;
> > >  				sum_entry->ofs_in_node = 0;
> > >  				sum_entry++;
> > > +				f2fs_cache_node_page(sbi, page,
> > > +					le32_to_cpu(rn->footer.nid), blkaddr);
> > >  			} else {
> > >  				err = -EIO;
> > >  			}
> > > @@ -1640,6 +1676,7 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> > >  			list_del(&page->lru);
> > >  			unlock_page(page);
> > >  			__free_pages(page, 0);
> > > +			blkaddr++;
> > >  		}
> > >  	}
> > >  	return err;
> >
> > --
> > Jaegeuk Kim
> > Samsung
> 
> 
> ------------------------------------------------------------------------------
> Sponsored by Intel(R) XDK
> Develop, test and display web and hybrid apps with a single code base.
> Download it for free now!
> http://pubads.g.doubleclick.net/gampad/clk?id=111408631&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

