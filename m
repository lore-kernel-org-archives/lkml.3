Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab3KMILZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:11:25 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12324 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab3KMILR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:11:17 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-6d-52833423b53c
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>
Cc: "'???'" <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?J8y35q0n?= <shu.tan@samsung.com>
References: <000101cedf66$c2e7ea40$48b7bec0$@samsung.com>
 <5282F470.4020401@cn.fujitsu.com>
In-reply-to: <5282F470.4020401@cn.fujitsu.com>
Subject: RE: [f2fs-dev] [PATCH 2/2] f2fs: read contiguous sit entry pages by
 merging for mount performance
Date: Wed, 13 Nov 2013 16:10:02 +0800
Message-id: <000001cee047$e7bebce0$b73c36a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHtY035AojHiCaL+XzIjuk0HtF0vAI1nMW9mdPx2hA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9jQV1lk+Ygg6erLSyetx9gtri+6y+T
	xaVF7hZ79p5ksbi8aw6bRevC88wObB7/D05i9ti94DOTR9+WVYwenzfJBbBEcdmkpOZklqUW
	6dslcGV8bu5gKfhrXtFw0aKB8Y12FyMnh4SAicTCtzdYIGwxiQv31rOB2EIC0xklvvwT62Lk
	ArJ/MEp83HYNrIhNQEViecd/JhBbREBDYtrU/UwgRcwCOxkldq/fwgrRHSvx5dpFdhCbU0BP
	4vy5NYwgtrBAjsSbx5vANrAIqEpM72sFG8QrYCnR1PiZBcIWlPgx+R6YzQy0oH/RBjYIW1vi
	ybsLrBCXKkjsOPuaEeIIK4nGCafYIWrEJTYeucUygVFoFpJRs5CMmoVk1CwkLQsYWVYxiqYW
	JBcUJ6XnGuoVJ+YWl+al6yXn525iBMfFM6kdjCsbLA4xCnAwKvHwWsQ0BQmxJpYVV+YeYpTg
	YFYS4T0g3BwkxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1Oq
	gTFyyY+aJh6tg+FbozM+pK9REixN+DSnWzQ53ulm5yODHpPuNJbe469dJwXxmZtx+3mrXzGy
	943as+3xinUahzbvFEjPZONNLPr+we3HSjPfn9NSp26auFVsuqLyw7MGwmLbg+39U7b+53QR
	q7JtYDz8mHFafWtt8HM/OwabjLyaoz0+E478U2Ipzkg01GIuKk4EAIlzPuCHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Wednesday, November 13, 2013 11:39 AM
> To: Chao Yu
> Cc: ???; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; Ì·æ­
> Subject: Re: [f2fs-dev] [PATCH 2/2] f2fs: read contiguous sit entry pages by merging for mount performance
> 
> Hi Yu,
> On 11/12/2013 01:18 PM, Chao Yu wrote:
> 
> > Previously we read sit entries page one by one, this method lost the chance of reading contiguous page together.
> > So we read pages as contiguous as possible for better mount performance.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/f2fs.h    |    2 ++
> >  fs/f2fs/segment.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++---
> >  fs/f2fs/segment.h |    2 ++
> >  3 files changed, 66 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 0afdcec..bfe9d87 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -1113,6 +1113,8 @@ struct page *find_data_page(struct inode *, pgoff_t, bool);
> >  struct page *get_lock_data_page(struct inode *, pgoff_t);
> >  struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
> >  int f2fs_readpage(struct f2fs_sb_info *, struct page *, block_t, int);
> > +void f2fs_submit_read_bio(struct f2fs_sb_info *, int);
> > +void submit_read_page(struct f2fs_sb_info *, struct page *, block_t, int);
> 
> Better to move these declarations into PATCH 1/2.

Okay, I will move it to the right place.

> 
> >  int do_write_data_page(struct page *);
> >
> >  /*
> > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > index 86dc289..414c351 100644
> > --- a/fs/f2fs/segment.c
> > +++ b/fs/f2fs/segment.c
> > @@ -1474,19 +1474,72 @@ static int build_curseg(struct f2fs_sb_info *sbi)
> >  	return restore_curseg_summaries(sbi);
> >  }
> >
> > +static int ra_sit_pages(struct f2fs_sb_info *sbi, int start,
> > +					int nrpages, bool *is_order)
> > +{
> > +	struct address_space *mapping = sbi->meta_inode->i_mapping;
> > +	struct sit_info *sit_i = SIT_I(sbi);
> > +	struct page *page;
> > +	block_t blk_addr;
> > +	int blkno, readcnt = 0;
> > +	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> > +
> > +	for (blkno = start; blkno < start + nrpages; blkno++) {
> > +
> > +		if (blkno >= sit_blk_cnt)
> 
> Merge these two judgements:
> for (blkno = start; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++)

Right, but the line may over 80 characters, if we split this line, it seems not suitable.
So how about this?
	int blkno = start, readcnt = 0;
	int sit_blk_cnt = SIT_BLK_CNT(sbi);

	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {

> 
> > +			goto out;
> 
> > +		if ((!f2fs_test_bit(blkno, sit_i->sit_bitmap) ^ !*is_order)) {
> > +			*is_order = !*is_order;
> > +			goto out;
> 
> 'Break' seems more suitable.

Yes, you are right.

> 
> > +		}
> > +
> > +		blk_addr = sit_i->sit_base_addr + blkno;
> > +		if (*is_order)
> > +			blk_addr += sit_i->sit_blocks;
> > +repeat:
> > +		page = grab_cache_page(mapping, blk_addr);
> > +		if (!page) {
> > +			cond_resched();
> > +			goto repeat;
> > +		}
> > +		if (PageUptodate(page)) {
> > +			f2fs_put_page(page, 1);
> > +			readcnt++;
> > +			goto out;
> 
> Here may be 'Continue'.

'Out' label could be removed after this modification.
It seems more neat.

> 
> > +		}
> > +
> > +		submit_read_page(sbi, page, blk_addr, READ_SYNC);
> > +
> > +		page_cache_release(page);
> 
> Put page here seems not a good idea, otherwise all your work may be in vain.

You mean that pages could be reclaimed by VM when out of memory?
IMO, it is designed more like VM read ahead because we should concern 
memory state of system, and still we have second chance to read these pages.

Could we use mark_page_accessed () to delay VM reclaimed them?

> 
> > +		readcnt++;
> > +	}
> > +out:
> > +	f2fs_submit_read_bio(sbi, READ_SYNC);
> > +	return readcnt;
> > +}
> > +
> >  static void build_sit_entries(struct f2fs_sb_info *sbi)
> >  {
> >  	struct sit_info *sit_i = SIT_I(sbi);
> >  	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_COLD_DATA);
> >  	struct f2fs_summary_block *sum = curseg->sum_blk;
> > -	unsigned int start;
> > +	bool is_order = f2fs_test_bit(0, sit_i->sit_bitmap) ? true : false;
> > +	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> > +	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> > +	unsigned int i, start, end;
> > +	unsigned int readed, start_blk = 0;
> >
> > -	for (start = 0; start < TOTAL_SEGS(sbi); start++) {
> > +next:
> > +	readed = ra_sit_pages(sbi, start_blk, bio_blocks, &is_order);
> 
> In fact, you know how many blocks that you want to read(SIT_BLK_CNT(sbi)),
> so here sit_blk_cnt is more suitable than a MAX one, and it also can make
> the logic of ra_sit_pages more simple.

Right.

BTW, I am considering that maybe we should send dynamical cnt which 
depend on memory state of system more than the logic of ra_sit_pages.
May it's the work of anther patch. How do you think?

> 
> > +
> > +	start = start_blk * sit_i->sents_per_block;
> > +	end = (start_blk + readed) * sit_i->sents_per_block;
> > +
> > +	for (; start < end && start < TOTAL_SEGS(sbi); start++) {
> >  		struct seg_entry *se = &sit_i->sentries[start];
> >  		struct f2fs_sit_block *sit_blk;
> >  		struct f2fs_sit_entry sit;
> >  		struct page *page;
> > -		int i;
> >
> >  		mutex_lock(&curseg->curseg_mutex);
> >  		for (i = 0; i < sits_in_cursum(sum); i++) {
> > @@ -1497,6 +1550,7 @@ static void build_sit_entries(struct f2fs_sb_info *sbi)
> >  			}
> >  		}
> >  		mutex_unlock(&curseg->curseg_mutex);
> > +
> >  		page = get_current_sit_page(sbi, start);
> >  		sit_blk = (struct f2fs_sit_block *)page_address(page);
> >  		sit = sit_blk->entries[SIT_ENTRY_OFFSET(sit_i, start)];
> > @@ -1509,6 +1563,11 @@ got_it:
> >  			e->valid_blocks += se->valid_blocks;
> >  		}
> >  	}
> > +
> > +	start_blk += readed;
> > +	if (start_blk >= sit_blk_cnt)
> > +		return;
> > +	goto next;
> 
> Using do {...} while(start_blk < sit_blk_cnt) rather than the so big upstream goto.

Yes, you are right.

> 
> >  }
> >
> >  static void init_free_segmap(struct f2fs_sb_info *sbi)
> > diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> > index 269f690..ad5b9f1 100644
> > --- a/fs/f2fs/segment.h
> > +++ b/fs/f2fs/segment.h
> > @@ -83,6 +83,8 @@
> >  	(segno / SIT_ENTRY_PER_BLOCK)
> >  #define	START_SEGNO(sit_i, segno)		\
> >  	(SIT_BLOCK_OFFSET(sit_i, segno) * SIT_ENTRY_PER_BLOCK)
> > +#define SIT_BLK_CNT(sbi)			\
> > +	((TOTAL_SEGS(sbi) + SIT_ENTRY_PER_BLOCK - 1) / SIT_ENTRY_PER_BLOCK)
> >  #define f2fs_bitmap_size(nr)			\
> >  	(BITS_TO_LONGS(nr) * sizeof(unsigned long))
> >  #define TOTAL_SEGS(sbi)	(SM_I(sbi)->main_segments)

Thanks!

Regards,
Yu


