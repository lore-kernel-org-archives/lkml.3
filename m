Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3KUDUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 22:20:23 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22894 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KUDTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 22:19:52 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-89-528d7bd65d18
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <001d01cee5bc$779c2fe0$66d48fa0$@samsung.com>
 <1384997517.26319.60.camel@kjgkr>
In-reply-to: <1384997517.26319.60.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH V2 2/2 RESEND] f2fs: read contiguous sit entry
 pages by merging for mount performance
Date: Thu, 21 Nov 2013 11:18:39 +0800
Message-id: <000001cee668$872ec6a0$958c53e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIJ19KASf8zRPdVedlp8ddtfrYm2AK+Dn7CmaMX5QA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t9jQd1r1b1BBhcbxS2u7/rLZHFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr4+yGmcwF
	v+0rNm07xtTA2G7UxcjJISFgInFwQjsbhC0mceHeeiCbi0NIYDqjxL3eGVDOD0aJlS/2MoFU
	sQmoSCzv+A9miwhIS8z6NI8FxGYWmM0osXm2I4gtJBArsfHQF2YQm1NAT2LX+ousILawQJnE
	l6XPgOIcHCwCqhLL3lWDmLwClhLX+sJAKngFBCV+TL4HNVFdYtK8RcwQtrbEk3cXWCHuVJDY
	cfY1I8QFVhIzrt+EqhGX2HjkFssERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFec
	mFtcmpeul5yfu4kRHAHPpHYwrmywOMQowMGoxMPb8bgnSIg1say4MvcQowQHs5II77HK3iAh
	3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjI283Judc7N7
	6q2WC4bf/zNNd6FosNdn1S9rcy88rJFslrm9zuNs0B152RllWdIHhfscFwT0nQ79sCL5eO6y
	5dOT7ucvVf7E075H9FRH/AQGfauk5d6Lg9RsQqIzUudIClvM6vu15+Bj60wbjd3zVgfdfTN3
	IeN7hn3n3fyeWLVLLy7r/pjMrsRSnJFoqMVcVJwIAKcGDUh8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Thursday, November 21, 2013 9:32 AM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> Subject: Re: [f2fs-dev] [PATCH V2 2/2 RESEND] f2fs: read contiguous sit entry pages by merging for mount performance
> 
> Hi,
> 
> It seems that ra_sit_pages() is too tightly coupled with
> build_sit_entries().

This code could be improved.

> Is there another way not to use *is_order?

Previously the code is like this:
 -build_sit_entries()
 next_setp:
	for(start = 0; start < TOTAL_SEGS(sbi); start++)
		/*step#1 readahead all sit entries blocks*/
			if(start % SIT_ENTRY_PER_BLOCK == 0) {
				blk_addr = current_sit_addr(sbi, start);
				/* grab and submit_read_page */
			}
			if(start == TOTAL_SEGS(sbi) - 1)
				f2fs_submit_read_bio();
			continue;
		/*step#2 fill sit entries info*/
		/*step#3 cover sit entries with journal*/

But I think its weakness is that it will cost lots of memory to read 
ahead all sit entry pages when f2fs mount, and also it's serious waste 
that we read them again after these pages are released by VM when 
out of memory.

> 
> The ra_sit_pages() tries to read consecutive sit pages as many as
> possible.
> So then, what about just checking whether its block address is
> contiguous or not?
> 
> Something like this:
>  -ra_sit_pages()
> 	blkno = start;
> 	while (blkno < sit_i->sit_blocks) {
> 		blk_addr = current_sit_addr(sbi, blkno);
> 		if (blkno != start && prev_blk_addr + 1 != blk_addr)
> 			break;
> 
> 		/* grab and submit_read_page */
> 
> 		prev_blk_addr = blk_addr;
> 		blkno++;
> 	}

Agreed, this method could remove *order.
Shouldn't we add nrpages for readahead policy as VM?

> 
> Thanks,
> 
> 2013-11-20 (수), 14:47 +0800, Chao Yu:
> > Previously we read sit entries page one by one, this method lost the chance
> > of reading contiguous page together. So we read pages as contiguous as
> > possible for better mount performance.
> >
> > v1-->v2:
> >  o merge judgements/use 'Continue' or 'Break' instead of 'Goto' as Gu Zheng
> >     suggested.
> >  o add mark_page_accessed() before release page to delay VM reclaiming them.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/segment.c |  108 ++++++++++++++++++++++++++++++++++++++++-------------
> >  fs/f2fs/segment.h |    2 +
> >  2 files changed, 84 insertions(+), 26 deletions(-)
> >
> > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > index 8149eba..52c88de 100644
> > --- a/fs/f2fs/segment.c
> > +++ b/fs/f2fs/segment.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/blkdev.h>
> >  #include <linux/prefetch.h>
> >  #include <linux/vmalloc.h>
> > +#include <linux/swap.h>
> >
> >  #include "f2fs.h"
> >  #include "segment.h"
> > @@ -1488,41 +1489,96 @@ static int build_curseg(struct f2fs_sb_info *sbi)
> >  	return restore_curseg_summaries(sbi);
> >  }
> >
> > +static int ra_sit_pages(struct f2fs_sb_info *sbi, int start,
> > +					int nrpages, bool *is_order)
> 
> Why do you use nrpages?

nrpages point out expectation of caller, caller cloud control how many 
pages want to read this time. It solves the weakness of previous coed I 
give above.

> 
> > +{
> > +	struct address_space *mapping = sbi->meta_inode->i_mapping;
> > +	struct sit_info *sit_i = SIT_I(sbi);
> > +	struct page *page;
> > +	block_t blk_addr;
> > +	int blkno = start, readcnt = 0;
> > +	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> > +
> > +	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {
> > +
> > +		if ((!f2fs_test_bit(blkno, sit_i->sit_bitmap) ^ !*is_order)) {
> > +			*is_order = !*is_order;
> > +			break;
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
> > +			mark_page_accessed(page);
> > +			f2fs_put_page(page, 1);
> > +			readcnt++;
> > +			continue;
> > +		}
> > +
> > +		submit_read_page(sbi, page, blk_addr, READ_SYNC);
> > +
> > +		mark_page_accessed(page);
> > +		f2fs_put_page(page, 0);
> > +		readcnt++;
> > +	}
> > +
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
> > -
> > -	for (start = 0; start < TOTAL_SEGS(sbi); start++) {
> > -		struct seg_entry *se = &sit_i->sentries[start];
> > -		struct f2fs_sit_block *sit_blk;
> > -		struct f2fs_sit_entry sit;
> > -		struct page *page;
> > -		int i;
> > +	bool is_order = f2fs_test_bit(0, sit_i->sit_bitmap) ? true : false;
> > +	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> > +	unsigned int i, start, end;
> > +	unsigned int readed, start_blk = 0;
> >
> > -		mutex_lock(&curseg->curseg_mutex);
> > -		for (i = 0; i < sits_in_cursum(sum); i++) {
> > -			if (le32_to_cpu(segno_in_journal(sum, i)) == start) {
> > -				sit = sit_in_journal(sum, i);
> > -				mutex_unlock(&curseg->curseg_mutex);
> > -				goto got_it;
> > +	do {
> > +		readed = ra_sit_pages(sbi, start_blk, sit_blk_cnt, &is_order);
> > +
> > +		start = start_blk * sit_i->sents_per_block;
> > +		end = (start_blk + readed) * sit_i->sents_per_block;
> > +
> > +		for (; start < end && start < TOTAL_SEGS(sbi); start++) {
> > +			struct seg_entry *se = &sit_i->sentries[start];
> > +			struct f2fs_sit_block *sit_blk;
> > +			struct f2fs_sit_entry sit;
> > +			struct page *page;
> > +
> > +			mutex_lock(&curseg->curseg_mutex);
> > +			for (i = 0; i < sits_in_cursum(sum); i++) {
> > +				if (le32_to_cpu(segno_in_journal(sum, i)) == start) {
> > +					sit = sit_in_journal(sum, i);
> > +					mutex_unlock(&curseg->curseg_mutex);
> > +					goto got_it;
> > +				}
> >  			}
> > -		}
> > -		mutex_unlock(&curseg->curseg_mutex);
> > -		page = get_current_sit_page(sbi, start);
> > -		sit_blk = (struct f2fs_sit_block *)page_address(page);
> > -		sit = sit_blk->entries[SIT_ENTRY_OFFSET(sit_i, start)];
> > -		f2fs_put_page(page, 1);
> > +			mutex_unlock(&curseg->curseg_mutex);
> > +
> > +			page = get_current_sit_page(sbi, start);
> > +			sit_blk = (struct f2fs_sit_block *)page_address(page);
> > +			sit = sit_blk->entries[SIT_ENTRY_OFFSET(sit_i, start)];
> > +			f2fs_put_page(page, 1);
> >  got_it:
> > -		check_block_count(sbi, start, &sit);
> > -		seg_info_from_raw_sit(se, &sit);
> > -		if (sbi->segs_per_sec > 1) {
> > -			struct sec_entry *e = get_sec_entry(sbi, start);
> > -			e->valid_blocks += se->valid_blocks;
> > +			check_block_count(sbi, start, &sit);
> > +			seg_info_from_raw_sit(se, &sit);
> > +			if (sbi->segs_per_sec > 1) {
> > +				struct sec_entry *e = get_sec_entry(sbi, start);
> > +				e->valid_blocks += se->valid_blocks;
> > +			}
> >  		}
> > -	}
> > +		start_blk += readed;
> > +	} while (start_blk < sit_blk_cnt);
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
> 
> --
> Jaegeuk Kim
> Samsung

