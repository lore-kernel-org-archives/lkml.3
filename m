Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3LJBwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:52:41 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:63964 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3LJBwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:52:38 -0500
X-AuditID: cbfee61b-b7f006d000003e1f-e7-52a673e3a87d
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <000a01cef4a0$9f2d64a0$dd882de0$@samsung.com>
 <1386576057.2101.106.camel@kjgkr>
In-reply-to: <1386576057.2101.106.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 3/3 V3] f2fs: introduce f2fs_cache_node_page()
 to add page into node_inode cache
Date: Tue, 10 Dec 2013 09:51:50 +0800
Message-id: <000c01cef54a$80fef2a0$82fcd7e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJKxSoRdvYRcRdRLlc/mnXOEGcC1wEMD/ZEmUyk19A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQd0nxcuCDC7PZLO4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2PGmZfsBaeVKl68
	eMvWwPhbqouRk0NCwETizN1mVghbTOLCvfVsXYxcHEIC0xklZtyeygjh/GCUaJ+whxGkik1A
	RWJ5x38mEFtEQFpi1qd5LCA2s0CmxJzXk8EmCQnESnT82go0iYODU0BP4t+0AJCwsEChxJG2
	F2DlLAKqEmtW/AIbwytgKbFt5WxWCFtQ4sfke1Aj1SUmzVvEDGFrSzx5dwHqUAWJHWdfM0Kc
	YCXxtes2K0SNuMTGI7dYJjAKzUIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8
	dL3k/NxNjODAfya9g3FVg8UhRgEORiUeXol/S4OEWBPLiitzDzFKcDArifA6xS4LEuJNSays
	Si3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cAY/l0h49PU/T2OB45V
	RCx3EXi992RV7g6+lWlxHpvDSm0n5/O0z9qybHrJHvHtESd5eUr0VV9lTkzNKjib6Ghslrc9
	bImD21fNfGmlZrb075t2FvU9YwzcfVypXOq6pznDIdsVcVMemzwy6U5liXd4vF2od9PxmxsW
	3b/cYeTHfXzFTv3EWDYlluKMREMt5qLiRAB/HYQ5eAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Monday, December 09, 2013 4:01 PM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH 3/3 V3] f2fs: introduce f2fs_cache_node_page() to add page into node_inode cache
> 
> Hi,
> 
> Sorry for the noise.
> Once I tested this patch, I recognized that I made a mistake:
> 
> f2fs_fill_super()
>  1. build_segment_manager()
>     -> restore_node_summary()
>        -> NULL pointer exception, due to no NAT cache.
>  2. build_node_manager()
> 
> So, we should not call get_node_info() prior to build_node_manager().
> And, it's not easy to change the order of build_*_manager simply.
> 
> Let's consider in more details.

Before we call restore_node_summary(), we have read HOT_DATA
Summary. It means already we got the NAT cache in curseg.
Although we could not call get_node_info() directly, we still could use
NAT cache in HOT_DATA curseg.

So how about using this cache to verify validity of page like this?

f2fs_cache_node_page()
	if(!looup_nat_curseg_cache())
		return;
	grab_cache_page();
	memcpy();
	SetPageUptodate();
	f2fs_put_page();

> Thanks,
> 
> 2013-12-09 (월), 13:35 +0800, Chao Yu:
> > This patch introduces f2fs_cache_node_page(), in this function, page which is
> > readed ahead will be copy to node_inode's mapping cache.
> > It will avoid rereading these node pages.
> >
> > change log:
> >  o check validity of page by searching NAT suggested by Jaegeuk Kim.
> >  o add 'unlikely' for compiler optimization suggested by Jaegeuk Kim.
> >
> > Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/node.c |   39 ++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 38 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 099f06f..4c6da98 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1600,13 +1600,46 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> >  	return 0;
> >  }
> >
> > +/*
> > + * f2fs_cache_node_page() check validaty of input page by searching NAT.
> > + * Then, it will copy updated data of vaild page to node_inode cache.
> > + */
> > +void f2fs_cache_node_page(struct f2fs_sb_info *sbi, struct page *page,
> > +						nid_t nid, block_t blkaddr)
> > +{
> > +	struct address_space *mapping = sbi->node_inode->i_mapping;
> > +	struct page *npage;
> > +	struct node_info ni;
> > +
> > +	get_node_info(sbi, nid, &ni);
> > +
> > +	if (ni.blk_addr != blkaddr)
> > +		return;
> > +
> > +	npage = grab_cache_page(mapping, nid);
> > +	if (unlikely(!npage))
> > +		return;
> > +
> > +	if (PageUptodate(npage)) {
> > +		f2fs_put_page(npage, 1);
> > +		return;
> > +	}
> > +
> > +	memcpy(page_address(npage), page_address(page), PAGE_CACHE_SIZE);
> > +
> > +	SetPageUptodate(npage);
> > +	f2fs_put_page(npage, 1);
> > +
> > +	return;
> > +}
> > +
> >  int restore_node_summary(struct f2fs_sb_info *sbi,
> >  			unsigned int segno, struct f2fs_summary_block *sum)
> >  {
> >  	struct f2fs_node *rn;
> >  	struct f2fs_summary *sum_entry;
> >  	struct page *page, *tmp;
> > -	block_t addr;
> > +	block_t addr, blkaddr;
> >  	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> >  	int i, last_offset, nrpages, err = 0;
> >  	LIST_HEAD(page_list);
> > @@ -1624,6 +1657,7 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> >  		if (err)
> >  			return err;
> >
> > +		blkaddr = addr;
> >  		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> >
> >  			lock_page(page);
> > @@ -1633,6 +1667,8 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> >  				sum_entry->version = 0;
> >  				sum_entry->ofs_in_node = 0;
> >  				sum_entry++;
> > +				f2fs_cache_node_page(sbi, page,
> > +					le32_to_cpu(rn->footer.nid), blkaddr);
> >  			} else {
> >  				err = -EIO;
> >  			}
> > @@ -1640,6 +1676,7 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> >  			list_del(&page->lru);
> >  			unlock_page(page);
> >  			__free_pages(page, 0);
> > +			blkaddr++;
> >  		}
> >  	}
> >  	return err;
> 
> --
> Jaegeuk Kim
> Samsung

