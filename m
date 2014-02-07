Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaBGICb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:02:31 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35254 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBGIC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:02:28 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-b8-52f49313075e
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <000001cf1bd0$bec85020$3c58f060$@samsung.com>
 <1391756297.25542.89.camel@kjgkr>
In-reply-to: <1391756297.25542.89.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: introduce ra_meta_pages to readahead
 CP/NAT/SIT pages
Date: Fri, 07 Feb 2014 16:01:15 +0800
Message-id: <002101cf23da$ee92e240$cbb8a6c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHqWAp2TZR32TGpz7CWCWXJXleuAwEvrCxymmmCcRA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jAV3hyV+CDE49Fre4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2P7rGbmgj1eFS/m
	z2drYJxv2cXIySEhYCIx9cozJghbTOLCvfVsXYxcHEICixglpt7vYIRwfjBKzJo9nRmkik1A
	RWJ5x3+wDhEBaYlZn+axgNjMApkSc15PZgWxhQRiJRYuPMIOYnMK6EnMvdMMVi8MFF/yvAEs
	ziKgKnHo62mwmbwClhJXzm5ig7AFJX5Mvgc0kwNoprrElCm5EOO1JZ68u8AKcaiCxI6zrxlB
	SkQErCTe/OGCKBGX2HjkFssERqFZSAbNQhg0C8mgWUg6FjCyrGIUTS1ILihOSs810itOzC0u
	zUvXS87P3cQIDvpn0jsYVzVYHGIU4GBU4uE9sfRzkBBrYllxZe4hRgkOZiUR3p8NX4KEeFMS
	K6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1MM670Vm9PH09v96W
	2y/4Q0PmnnFbV2kbNr02kdNI5deFE2W6Dj5F3Fyx0lptrtttfr/jnRDxhSu6r/eL7vVWWdP8
	O/dZE9vUfyRIbdg+2+TqtYaQL5Xffqza8cT/zYI8nfe36vT2nJq4ctLtpDmH35TNPOATm6oh
	osZubDSR86bbktAvQbO/qCixFGckGmoxFxUnAgAbTS2UdgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Friday, February 07, 2014 2:58 PM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: Re: [f2fs-dev] [PATCH] f2fs: introduce ra_meta_pages to readahead CP/NAT/SIT pages
> 
> Hi Chao,
> 
> Sorry for the delay.
> When I tested this patch, a deadlock was occurred, so I couldn't afford
> to look inside in more detail.
> When I see again, there is a bug wrt blkno.
> Please see below.

You're right, and your code could fix this deadloop bug.
Thanks for the test and review. :)
I will send patch v2 later.

> 
> 2014-01-28 (화), 10:28 +0800, Chao Yu:
> > This patch help us to cleanup the readahead code by merging ra_{sit,nat}_pages
> > function into ra_meta_pages.
> > Additionally the new function is used to readahead cp block in
> > recover_orphan_inodes.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/checkpoint.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/f2fs/f2fs.h       |   10 +++++++
> >  fs/f2fs/node.c       |   38 +-----------------------
> >  fs/f2fs/segment.c    |   43 +---------------------------
> >  4 files changed, 90 insertions(+), 79 deletions(-)
> >
> > diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> > index 293d048..a1986c3 100644
> > --- a/fs/f2fs/checkpoint.c
> > +++ b/fs/f2fs/checkpoint.c
> > @@ -75,6 +75,82 @@ out:
> >  	return page;
> >  }
> >
> > +inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
> > +{
> > +	switch (type) {
> > +	case META_NAT:
> > +		return NM_I(sbi)->max_nid / NAT_ENTRY_PER_BLOCK;
> > +	case META_SIT:
> > +		return SIT_BLK_CNT(sbi);
> > +	case META_CP:
> > +		return 0;
> > +	default:
> > +		BUG();
> > +	}
> > +}
> > +
> > +/*
> > + * Readahead CP/NAT/SIT pages
> > + */
> > +int ra_meta_pages(struct f2fs_sb_info *sbi, int start, int nrpages, int type)
> > +{
> > +	struct address_space *mapping = sbi->meta_inode->i_mapping;
> 
> 	We don't need to do this. Instead, we can use META_MAPPING(sbi) below.
> 
> > +	struct page *page;
> > +	block_t blk_addr, prev_blk_addr = 0;
> > +	int blkno = start;
> > +	int max_blks = get_max_meta_blks(sbi, type);
> 
> 	block_t prev_blk_addr = 0;
> 	struct page *page;
> 	int blkno = start;
> 	int max_blks = get_max_meta_blks(sbi, type);
> 
> > +	struct f2fs_io_info fio = {
> > +		.type = META,
> > +		.rw = READ_SYNC | REQ_META | REQ_PRIO
> > +	};
> > +
> > +	for (blkno = start; blkno < start + nrpages; blkno++) {
> 
> 	for (; nrpages-- > 0; blkno++) {
> 		block_t blk_addr;
> 
>  --> In the case of META_NAT, blkno becomes 0 if it hits max_blks.
>      So, we should not use *blkno < start + nrpages*.
> 
> > +
> > +		switch (type) {
> > +		case META_NAT:
> > +			/* get nat block addr */
> > +			if (unlikely(blkno >= max_blks))
> > +				blkno = 0;
> > +			blk_addr = current_nat_addr(sbi,
> > +					blkno * NAT_ENTRY_PER_BLOCK);
> > +			break;
> > +		case META_SIT:
> > +			/* get sit block addr */
> > +			if (unlikely(blkno >= max_blks))
> > +				goto out;
> > +			blk_addr = current_sit_addr(sbi,
> > +					blkno * SIT_ENTRY_PER_BLOCK);
> > +			if (blkno != start && prev_blk_addr + 1 != blk_addr)
> > +				goto out;
> > +			prev_blk_addr = blk_addr;
> > +			break;
> > +		case META_CP:
> > +			/* get cp block addr */
> > +			blk_addr = blkno;
> > +			break;
> > +		default:
> > +			BUG();
> > +		}
> > +
> > +		page = grab_cache_page(mapping, blk_addr);
> 
> 		page = grab_cache_page(META_MAPPING(sbi), blk_addr);
> 
> > +		if (!page)
> > +			continue;
> > +		if (PageUptodate(page)) {
> > +			mark_page_accessed(page);
> > +			f2fs_put_page(page, 1);
> > +			continue;
> > +		}
> > +
> > +		f2fs_submit_page_mbio(sbi, page, blk_addr, &fio);
> > +		mark_page_accessed(page);
> > +		f2fs_put_page(page, 0);
> > +	}
> > +out:
> > +	f2fs_submit_merged_bio(sbi, META, READ);
> > +	return blkno - start;
> > +}
> > +
> >  static int f2fs_write_meta_page(struct page *page,
> >  				struct writeback_control *wbc)
> >  {
> > @@ -285,6 +361,8 @@ void recover_orphan_inodes(struct f2fs_sb_info *sbi)
> >  	start_blk = __start_cp_addr(sbi) + 1;
> >  	orphan_blkaddr = __start_sum_addr(sbi) - 1;
> >
> > +	ra_meta_pages(sbi, start_blk, orphan_blkaddr, META_CP);
> > +
> >  	for (i = 0; i < orphan_blkaddr; i++) {
> >  		struct page *page = get_meta_page(sbi, start_blk + i);
> >  		struct f2fs_orphan_block *orphan_blk;
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index af51a0b..69ffc1b 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -88,6 +88,15 @@ enum {
> >  	SIT_BITMAP
> >  };
> >
> > +/*
> > + * For CP/NAT/SIT readahead
> > + */
> > +enum {
> > +	META_CP,
> > +	META_NAT,
> > +	META_SIT
> > +};
> > +
> >  /* for the list of orphan inodes */
> >  struct orphan_inode_entry {
> >  	struct list_head list;	/* list head */
> > @@ -1158,6 +1167,7 @@ void destroy_segment_manager_caches(void);
> >   */
> >  struct page *grab_meta_page(struct f2fs_sb_info *, pgoff_t);
> >  struct page *get_meta_page(struct f2fs_sb_info *, pgoff_t);
> > +int ra_meta_pages(struct f2fs_sb_info *, int, int, int);
> >  long sync_meta_pages(struct f2fs_sb_info *, enum page_type, long);
> >  int acquire_orphan_inode(struct f2fs_sb_info *);
> >  void release_orphan_inode(struct f2fs_sb_info *);
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index b0649b7..2f7ae6f 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -82,42 +82,6 @@ static struct page *get_next_nat_page(struct f2fs_sb_info *sbi, nid_t nid)
> >  	return dst_page;
> >  }
> >
> > -/*
> > - * Readahead NAT pages
> > - */
> > -static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
> > -{
> > -	struct address_space *mapping = META_MAPPING(sbi);
> > -	struct f2fs_nm_info *nm_i = NM_I(sbi);
> > -	struct page *page;
> > -	pgoff_t index;
> > -	int i;
> > -	struct f2fs_io_info fio = {
> > -		.type = META,
> > -		.rw = READ_SYNC | REQ_META | REQ_PRIO
> > -	};
> > -
> > -
> > -	for (i = 0; i < FREE_NID_PAGES; i++, nid += NAT_ENTRY_PER_BLOCK) {
> > -		if (unlikely(nid >= nm_i->max_nid))
> > -			nid = 0;
> > -		index = current_nat_addr(sbi, nid);
> > -
> > -		page = grab_cache_page(mapping, index);
> > -		if (!page)
> > -			continue;
> > -		if (PageUptodate(page)) {
> > -			mark_page_accessed(page);
> > -			f2fs_put_page(page, 1);
> > -			continue;
> > -		}
> > -		f2fs_submit_page_mbio(sbi, page, index, &fio);
> > -		mark_page_accessed(page);
> > -		f2fs_put_page(page, 0);
> > -	}
> > -	f2fs_submit_merged_bio(sbi, META, READ);
> > -}
> > -
> >  static struct nat_entry *__lookup_nat_cache(struct f2fs_nm_info *nm_i, nid_t n)
> >  {
> >  	return radix_tree_lookup(&nm_i->nat_root, n);
> > @@ -1413,7 +1377,7 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
> >  		return;
> >
> >  	/* readahead nat pages to be scanned */
> > -	ra_nat_pages(sbi, nid);
> > +	ra_meta_pages(sbi, NAT_BLOCK_OFFSET(nid), FREE_NID_PAGES, META_NAT);
> >
> >  	while (1) {
> >  		struct page *page = get_current_nat_page(sbi, nid);
> > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > index 7caac5f..4c2b35b 100644
> > --- a/fs/f2fs/segment.c
> > +++ b/fs/f2fs/segment.c
> > @@ -1583,47 +1583,6 @@ static int build_curseg(struct f2fs_sb_info *sbi)
> >  	return restore_curseg_summaries(sbi);
> >  }
> >
> > -static int ra_sit_pages(struct f2fs_sb_info *sbi, int start, int nrpages)
> > -{
> > -	struct address_space *mapping = META_MAPPING(sbi);
> > -	struct page *page;
> > -	block_t blk_addr, prev_blk_addr = 0;
> > -	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> > -	int blkno = start;
> > -	struct f2fs_io_info fio = {
> > -		.type = META,
> > -		.rw = READ_SYNC | REQ_META | REQ_PRIO
> > -	};
> > -
> > -	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {
> > -
> > -		blk_addr = current_sit_addr(sbi, blkno * SIT_ENTRY_PER_BLOCK);
> > -
> > -		if (blkno != start && prev_blk_addr + 1 != blk_addr)
> > -			break;
> > -		prev_blk_addr = blk_addr;
> > -repeat:
> > -		page = grab_cache_page(mapping, blk_addr);
> > -		if (!page) {
> > -			cond_resched();
> > -			goto repeat;
> > -		}
> > -		if (PageUptodate(page)) {
> > -			mark_page_accessed(page);
> > -			f2fs_put_page(page, 1);
> > -			continue;
> > -		}
> > -
> > -		f2fs_submit_page_mbio(sbi, page, blk_addr, &fio);
> > -
> > -		mark_page_accessed(page);
> > -		f2fs_put_page(page, 0);
> > -	}
> > -
> > -	f2fs_submit_merged_bio(sbi, META, READ);
> > -	return blkno - start;
> > -}
> > -
> >  static void build_sit_entries(struct f2fs_sb_info *sbi)
> >  {
> >  	struct sit_info *sit_i = SIT_I(sbi);
> > @@ -1635,7 +1594,7 @@ static void build_sit_entries(struct f2fs_sb_info *sbi)
> >  	int nrpages = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> >
> >  	do {
> > -		readed = ra_sit_pages(sbi, start_blk, nrpages);
> > +		readed = ra_meta_pages(sbi, start_blk, nrpages, META_SIT);
> >
> >  		start = start_blk * sit_i->sents_per_block;
> >  		end = (start_blk + readed) * sit_i->sents_per_block;
> 
> --
> Jaegeuk Kim
> Samsung

