Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3KTFjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 00:39:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:30680 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3KTFjC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 00:39:02 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-f6-528c4af4b514
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>
Cc: "'???'" <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?J8y35q0n?= <shu.tan@samsung.com>
References: <000101cee293$4eae78d0$ec0b6a70$@samsung.com>
 <5289F6E3.3020607@cn.fujitsu.com>
In-reply-to: <5289F6E3.3020607@cn.fujitsu.com>
Subject: RE: [f2fs-dev] [PATCH V2 2/2] f2fs: read contiguous sit entry pages by
 merging for mount performance
Date: Wed, 20 Nov 2013 13:37:32 +0800
Message-id: <001801cee5b2$ce8cdac0$6ba69040$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJeUYhyzeQGY4OFPX5veD7TG4awfwH0Wa9QmP2KF1A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jQd0vXj1BBiuuKVg8bz/AbHF9118m
	i0uL3C327D3JYnF51xw2i9aF55kd2Dz+H5zE7LF7wWcmj74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mpof3aRqeCwacXNe3NYGxh/aHYxcnJICJhIdHWeZYWwxSQu3FvP1sXIxSEkMJ1RYkNX
	FwuE84NRYs7bVYwgVWwCKhLLO/4zgdgiAhoS06buZwIpYhbYySixe/0WsFFCArESf188Ygex
	OQX0JPZ0TQSzhQXyJV4s3wTUwMHBIqAqMX+/H0iYV8BSYvPOSWwQtqDEj8n3WEBsZqD5/Ys2
	sEHY2hJP3l2AulRBYsfZ14wQN1hJNE9eyg5RIy6x8cgtlgmMQrOQjJqFZNQsJKNmIWlZwMiy
	ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Mp5J72Bc1WBxiFGAg1GJh7dgUXeQEGtiWXFl
	7iFGCQ5mJRHeW+49QUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFk
	mTg4pRoYJ9ga6iulaS7vOxSob7hj+6/fZWnsPAEzv/yYIFGw5bac+Lewe+bMa68uPXZC7UPH
	ZLP+HeGHTh+JYnnCq/LX4OBG+X0HvU+dN3kiljZF/9MibeM6+w2/eSWXPJhUn+2x8meSg//C
	4zImTa+0I9u+tOd0LG/8XJ2wnnO71OWmaVttPeLDm5NMlFiKMxINtZiLihMBOgNWbYgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Monday, November 18, 2013 7:16 PM
> To: Chao Yu
> Cc: '???'; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; Ì·æ­
> Subject: Re: [f2fs-dev] [PATCH V2 2/2] f2fs: read contiguous sit entry pages by merging for mount performance
> 
> Hi Yu,
> One more comment, please refer to inline.
> On 11/16/2013 02:15 PM, Chao Yu wrote:
> 
> > Previously we read sit entries page one by one, this method lost the chance of reading contiguous page together.
> > So we read pages as contiguous as possible for better mount performance.
> >
> > v1-->v2:
> >  o merge judgements/use 'Continue' or 'Break' instead of 'Goto' as Gu Zheng suggested.
> >  o add mark_page_accessed () before release page to delay VM reclaiming them.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/segment.c |  108 ++++++++++++++++++++++++++++++++++++++++-------------
> >  fs/f2fs/segment.h |    2 +
> >  2 files changed, 84 insertions(+), 26 deletions(-)
> >
> > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > index fa284d3..656fe40 100644
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
> > @@ -1480,41 +1481,96 @@ static int build_curseg(struct f2fs_sb_info *sbi)
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
> 
> How about using find_next_bit to get the suitable start_blk if the next blk
> is not ordered here? And it also can simplify the logic of ra_sit_pages().

That's a good idea.
But I thought there maybe endianness problem between test_bit and 
f2fs_test_bit, so find_next_bit may get wrong result. Am I right?

Thanks,
Yu
> 
> Thanks,
> Gu
> 
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
> 
> 
> 
> 
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


