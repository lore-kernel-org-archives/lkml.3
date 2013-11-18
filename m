Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab3KRBi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 20:38:59 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:11231 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3KRBi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 20:38:56 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-65-52896fa97239
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <000001cee293$3b6e3030$b24a9090$@samsung.com>
 <1384734560.26319.10.camel@kjgkr>
In-reply-to: <1384734560.26319.10.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH V2 1/2] f2fs: add a new function to support for
 merging contiguous read
Date: Mon, 18 Nov 2013 09:37:45 +0800
Message-id: <000901cee3fe$edfa8660$c9ef9320$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQEjOp1BQ4p72/eUWik9AupolSecHAFKR9WBm3cqVPA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jQd2V+Z1BBoumKVhc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxuRXm9gK
	2lQqJl6dytLAeFWmi5GTQ0LARGL1jAcsELaYxIV769m6GLk4hASmM0qsmTKRFcL5wSgx6cZ0
	ZpAqNgEVieUd/5lAbBEBaYlZn+aBdTMLzGaU2DzbEcQWEoiVWHF3O1g9p4CexJIJL8BsYYEM
	icapk1hBbBYBVYnLR2eD2bwClhIrmi6zQ9iCEj8m34OaqS4xad4iZghbW+LJuwusEJcqSOw4
	+5oR4gYriXNHt7NC1IhLbDxyi2UCo9AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs810itO
	zC0uzUvXS87P3cQIjoJn0jsYVzVYHGIU4GBU4uHVCOsMEmJNLCuuzD3EKMHBrCTCa+IPFOJN
	SaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cDYzMn+9UjYsVnF
	4ZblwZKKxpq7jmwWMZ/Kf/zZhaS8pdOqFV72Kr6LqVRvtK05qhS3Y/ENzSSH6RaXvjBOnLr7
	tNdbVfuJWaoNbHpTbr36rO2idKB+j9O2Y2cWH5LYcDPBySFUiXOz2e1N0bwRi9L+fNump1rz
	8+9M81yGTO93Z3oeJYnPU1NXYinOSDTUYi4qTgQAWjGS4n4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Monday, November 18, 2013 8:29 AM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> Subject: Re: [f2fs-dev] [PATCH V2 1/2] f2fs: add a new function to support for merging contiguous read
> 
> Hi Chao,
> 
> 2013-11-16 (토), 14:14 +0800, Chao Yu:
> > For better read performance, we add a new function to support for merging contiguous read as the one for write.
> 
> Please consider 80 columns for the description.
> I cannot fix this at every time though. :(

Got it, sorry about my carelessness in previous patch.

> 
> >
> > v1-->v2:
> >  o add declarations here as Gu Zheng suggested.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > Acked-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> > ---
> >  fs/f2fs/data.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
> >  fs/f2fs/f2fs.h |    4 ++++
> >  2 files changed, 49 insertions(+)
> >
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index aa3438c..18107cb 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -404,6 +404,51 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
> >  	return 0;
> >  }
> >
> > +void f2fs_submit_read_bio(struct f2fs_sb_info *sbi, int rw)
> > +{
> > +	down_read(&sbi->bio_sem);
> 
> Is there any reason to use down_read()?

Isn't that we use bio_sem to let w/r or w/w submitting be mutex?

> It seems that we need to declare sbi->bio_read and sbi->bio_write
> instead of sbi->bio_sem.
> In addition to that, we need to use down_write(&sbi->bio_read) here.

If so, it looks similar between (struct rw_semaphore) sbi->bio_read 
and (struct bio *) sbi->read_bio.
How about using read_bio_sem/rbio_sem to differentiate 
from sbi->read_bio?

> 
> > +	if (sbi->read_bio) {
> > +		submit_bio(rw, sbi->read_bio);
> > +		sbi->read_bio = NULL;
> > +	}
> > +	up_read(&sbi->bio_sem);
> 
> up_write(&sbi->bio_read);
> 
> > +}
> > +
> > +void submit_read_page(struct f2fs_sb_info *sbi, struct page *page,
> > +					block_t blk_addr, int rw)
> > +{
> > +	struct block_device *bdev = sbi->sb->s_bdev;
> > +	int bio_blocks;
> > +
> > +	verify_block_addr(sbi, blk_addr);
> > +
> > +	down_read(&sbi->bio_sem);
> 
> down_write(&sbi->bio_read);
> 
> > +
> > +	if (sbi->read_bio && sbi->last_read_block != blk_addr - 1) {
> > +		submit_bio(rw, sbi->read_bio);
> > +		sbi->read_bio = NULL;
> > +	}
> > +
> > +alloc_new:
> > +	if (sbi->read_bio == NULL) {
> > +		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > +		sbi->read_bio = f2fs_bio_alloc(bdev, bio_blocks);
> > +		sbi->read_bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
> > +		sbi->read_bio->bi_end_io = read_end_io;
> > +	}
> > +
> > +	if (bio_add_page(sbi->read_bio, page, PAGE_CACHE_SIZE, 0) <
> > +							PAGE_CACHE_SIZE) {
> > +		submit_bio(rw, sbi->read_bio);
> > +		sbi->read_bio = NULL;
> > +		goto alloc_new;
> > +	}
> > +
> > +	sbi->last_read_block = blk_addr;
> > +
> > +	up_read(&sbi->bio_sem);
> 
> up_write(&sbi->bio_read);
> 
> > +}
> > +
> >  /*
> >   * This function should be used by the data read flow only where it
> >   * does not check the "create" flag that indicates block allocation.
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 89dc750..bfe9d87 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -359,6 +359,8 @@ struct f2fs_sb_info {
> >
> >  	/* for segment-related operations */
> >  	struct f2fs_sm_info *sm_info;		/* segment manager */
> > +	struct bio *read_bio;			/* read bios to merge */
> > +	sector_t last_read_block;		/* last read block number */
> >  	struct bio *bio[NR_PAGE_TYPE];		/* bios to merge */
> >  	sector_t last_block_in_bio[NR_PAGE_TYPE];	/* last block number */
> >  	struct rw_semaphore bio_sem;		/* IO semaphore */
> > @@ -1111,6 +1113,8 @@ struct page *find_data_page(struct inode *, pgoff_t, bool);
> >  struct page *get_lock_data_page(struct inode *, pgoff_t);
> >  struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
> >  int f2fs_readpage(struct f2fs_sb_info *, struct page *, block_t, int);
> > +void f2fs_submit_read_bio(struct f2fs_sb_info *, int);
> > +void submit_read_page(struct f2fs_sb_info *, struct page *, block_t, int);
> >  int do_write_data_page(struct page *);
> >
> >  /*
> 
> --
> Jaegeuk Kim
> Samsung

