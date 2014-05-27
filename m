Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaE0GeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:34:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23549 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaE0GeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:34:03 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-1e-538431da72ee
From: Chao Yu <chao2.yu@samsung.com>
To: "'Changman Lee'" <cm224.lee@samsung.com>
Cc: "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <00f501cf7944$7e8a65d0$7b9f3170$@samsung.com>
 <20140527012505.GA4886@cm224.lee>
In-reply-to: <20140527012505.GA4886@cm224.lee>
Subject: RE: [f2fs-dev] [PATCH v2] f2fs: avoid crash when trace
 f2fs_submit_page_mbio event in ra_sum_pages
Date: Tue, 27 May 2014 14:32:57 +0800
Message-id: <00ff01cf7975$a5f5fd10$f1e1f730$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHIWO27tRuSxAm/djtzsmpDxZ6XWQJaFYzdm08sntA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t9jQd1bhi3BBm9WsFtc29fIZHF9118m
	i0uL3C327D3JYnF51xw2B1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxuY1N5gK
	rphUnLuyn7WB8bNmFyMHh4SAicS/R0AmJ5ApJnHh3nq2LkYuDiGB6YwS887tZIZwfjBKrFr8
	hA2kik1ARWJ5x38mEFtEQEtif083C0gRs8AkRoklP5tZQBJCArES7SfnM4Js4BTQk1i5KgAk
	LCyQK3F37XtGEJtFQFVi3dunYCW8ApYSTRP1QMK8AoISPybfA5vCDDR+/c7jTBC2vMTmNW+Z
	IQ5VkNhx9jUjxAlWEuuurmeHqBGX2HjkFssERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCc
	lJ5rpFecmFtcmpeul5yfu4kRHAHPpHcwrmqwOMQowMGoxMM7wbc5WIg1say4MvcQowQHs5II
	byxTS7AQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkGRo8N
	HILNbcY377KcWO6U3p81ZUax+IoHYh+55T4FXZgmZZPaJSf/7+gnQU+u5Lq91uEml2smHD//
	KPXTmX+7Dx4X8H3vXszE/GujyKIrif7f9LaLvti3Pja3leP4ubpm+221ZjuznFMkdcT2b14Z
	r3+Z5R2P4bFJy3ZJ+8p+P7D9j6WLks5fCyWW4oxEQy3mouJEAN+NqHd8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi changman,

> -----Original Message-----
> From: Changman Lee [mailto:cm224.lee@samsung.com]
> Sent: Tuesday, May 27, 2014 9:25 AM
> To: Chao Yu
> Cc: Jaegeuk Kim; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH v2] f2fs: avoid crash when trace f2fs_submit_page_mbio event
> in ra_sum_pages
> 
> Hi, Chao
> 
> Could you think about following once.
> move node_inode in front of build_segment_manager, then use node_inode
> instead of bd_inode.

Jaegeuk and I discussed this solution previously in
[PATCH 3/3 V3] f2fs: introduce f2fs_cache_node_page() to add page into node_inode cache

You can see it from this url:
http://sourceforge.net/p/linux-f2fs/mailman/linux-f2fs-devel/?viewmonth=201312&page=5

And it seems not easy to change order of build_*_manager and make node_inode,
because there are dependency between them.

> 
> On Tue, May 27, 2014 at 08:41:07AM +0800, Chao Yu wrote:
> > Previously we allocate pages with no mapping in ra_sum_pages(), so we may
> > encounter a crash in event trace of f2fs_submit_page_mbio where we access
> > mapping data of the page.
> >
> > We'd better allocate pages in bd_inode mapping and invalidate these pages after
> > we restore data from pages. It could avoid crash in above scenario.
> >
> > Changes from V1
> >  o remove redundant code in ra_sum_pages() suggested by Jaegeuk Kim.
> >
> > Call Trace:
> >  [<f1031630>] ? ftrace_raw_event_f2fs_write_checkpoint+0x80/0x80 [f2fs]
> >  [<f10377bb>] f2fs_submit_page_mbio+0x1cb/0x200 [f2fs]
> >  [<f103c5da>] restore_node_summary+0x13a/0x280 [f2fs]
> >  [<f103e22d>] build_curseg+0x2bd/0x620 [f2fs]
> >  [<f104043b>] build_segment_manager+0x1cb/0x920 [f2fs]
> >  [<f1032c85>] f2fs_fill_super+0x535/0x8e0 [f2fs]
> >  [<c115b66a>] mount_bdev+0x16a/0x1a0
> >  [<f102f63f>] f2fs_mount+0x1f/0x30 [f2fs]
> >  [<c115c096>] mount_fs+0x36/0x170
> >  [<c1173635>] vfs_kern_mount+0x55/0xe0
> >  [<c1175388>] do_mount+0x1e8/0x900
> >  [<c1175d72>] SyS_mount+0x82/0xc0
> >  [<c16059cc>] sysenter_do_call+0x12/0x22
> >
> > Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/node.c |   52 ++++++++++++++++++++++++----------------------------
> >  1 file changed, 24 insertions(+), 28 deletions(-)
> >
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 3d60d3d..02a59e9 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1658,35 +1658,29 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
> >
> >  /*
> >   * ra_sum_pages() merge contiguous pages into one bio and submit.
> > - * these pre-readed pages are linked in pages list.
> > + * these pre-readed pages are alloced in bd_inode's mapping tree.
> >   */
> > -static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
> > +static int ra_sum_pages(struct f2fs_sb_info *sbi, struct page **pages,
> >  				int start, int nrpages)
> >  {
> > -	struct page *page;
> > -	int page_idx = start;
> > +	struct inode *inode = sbi->sb->s_bdev->bd_inode;
> > +	struct address_space *mapping = inode->i_mapping;
> > +	int i, page_idx = start;
> >  	struct f2fs_io_info fio = {
> >  		.type = META,
> >  		.rw = READ_SYNC | REQ_META | REQ_PRIO
> >  	};
> >
> > -	for (; page_idx < start + nrpages; page_idx++) {
> > -		/* alloc temporal page for read node summary info*/
> > -		page = alloc_page(GFP_F2FS_ZERO);
> > -		if (!page)
> > +	for (i = 0; page_idx < start + nrpages; page_idx++, i++) {
> > +		/* alloc page in bd_inode for reading node summary info */
> > +		pages[i] = grab_cache_page(mapping, page_idx);
> > +		if (!pages[i])
> >  			break;
> > -
> > -		lock_page(page);
> > -		page->index = page_idx;
> > -		list_add_tail(&page->lru, pages);
> > +		f2fs_submit_page_mbio(sbi, pages[i], page_idx, &fio);
> >  	}
> >
> > -	list_for_each_entry(page, pages, lru)
> > -		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
> > -
> >  	f2fs_submit_merged_bio(sbi, META, READ);
> > -
> > -	return page_idx - start;
> > +	return i;
> >  }
> >
> >  int restore_node_summary(struct f2fs_sb_info *sbi,
> > @@ -1694,11 +1688,11 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> >  {
> >  	struct f2fs_node *rn;
> >  	struct f2fs_summary *sum_entry;
> > -	struct page *page, *tmp;
> > +	struct inode *inode = sbi->sb->s_bdev->bd_inode;
> >  	block_t addr;
> >  	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > -	int i, last_offset, nrpages, err = 0;
> > -	LIST_HEAD(page_list);
> > +	struct page *pages[bio_blocks];
> > +	int i, idx, last_offset, nrpages, err = 0;
> >
> >  	/* scan the node segment */
> >  	last_offset = sbi->blocks_per_seg;
> > @@ -1709,29 +1703,31 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> >  		nrpages = min(last_offset - i, bio_blocks);
> >
> >  		/* read ahead node pages */
> > -		nrpages = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > +		nrpages = ra_sum_pages(sbi, pages, addr, nrpages);
> >  		if (!nrpages)
> >  			return -ENOMEM;
> >
> > -		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> > +		for (idx = 0; idx < nrpages; idx++) {
> >  			if (err)
> >  				goto skip;
> >
> > -			lock_page(page);
> > -			if (unlikely(!PageUptodate(page))) {
> > +			lock_page(pages[idx]);
> > +			if (unlikely(!PageUptodate(pages[idx]))) {
> >  				err = -EIO;
> >  			} else {
> > -				rn = F2FS_NODE(page);
> > +				rn = F2FS_NODE(pages[idx]);
> >  				sum_entry->nid = rn->footer.nid;
> >  				sum_entry->version = 0;
> >  				sum_entry->ofs_in_node = 0;
> >  				sum_entry++;
> >  			}
> > -			unlock_page(page);
> > +			unlock_page(pages[idx]);
> >  skip:
> > -			list_del(&page->lru);
> > -			__free_pages(page, 0);
> > +			page_cache_release(pages[idx]);
> >  		}
> > +
> > +		invalidate_mapping_pages(inode->i_mapping, addr,
> > +							addr + nrpages);
> >  	}
> >  	return err;
> >  }
> > --
> > 1.7.9.5
> >
> >
> >
> > ------------------------------------------------------------------------------
> > The best possible search technologies are now affordable for all companies.
> > Download your FREE open source Enterprise Search Engine today!
> > Our experts will assist you in its installation for $59/mo, no commitment.
> > Test it for FREE on our Cloud platform anytime!
> > http://pubads.g.doubleclick.net/gampad/clk?id=145328191&iu=/4140/ostg.clktrk
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

