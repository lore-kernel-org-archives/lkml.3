Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab3KRLaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:30:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:10820 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab3KRLaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:30:14 -0500
X-IronPort-AV: E=Sophos;i="4.93,723,1378828800"; 
   d="scan'208";a="9065225"
Message-ID: <5289F6E3.3020607@cn.fujitsu.com>
Date: Mon, 18 Nov 2013 19:15:47 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: "'???'" <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        =?GB2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: Re: [f2fs-dev] [PATCH V2 2/2] f2fs: read contiguous sit entry pages
 by merging for mount performance
References: <000101cee293$4eae78d0$ec0b6a70$@samsung.com>
In-Reply-To: <000101cee293$4eae78d0$ec0b6a70$@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/18 19:20:12,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/18 19:20:17,
	Serialize complete at 2013/11/18 19:20:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu,
One more comment, please refer to inline.
On 11/16/2013 02:15 PM, Chao Yu wrote:

> Previously we read sit entries page one by one, this method lost the chance of reading contiguous page together.
> So we read pages as contiguous as possible for better mount performance.
> 
> v1-->v2:
>  o merge judgements/use 'Continue' or 'Break' instead of 'Goto' as Gu Zheng suggested.
>  o add mark_page_accessed () before release page to delay VM reclaiming them.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/segment.c |  108 ++++++++++++++++++++++++++++++++++++++++-------------
>  fs/f2fs/segment.h |    2 +
>  2 files changed, 84 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index fa284d3..656fe40 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -14,6 +14,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/prefetch.h>
>  #include <linux/vmalloc.h>
> +#include <linux/swap.h>
>  
>  #include "f2fs.h"
>  #include "segment.h"
> @@ -1480,41 +1481,96 @@ static int build_curseg(struct f2fs_sb_info *sbi)
>  	return restore_curseg_summaries(sbi);
>  }
>  
> +static int ra_sit_pages(struct f2fs_sb_info *sbi, int start,
> +					int nrpages, bool *is_order)
> +{
> +	struct address_space *mapping = sbi->meta_inode->i_mapping;
> +	struct sit_info *sit_i = SIT_I(sbi);
> +	struct page *page;
> +	block_t blk_addr;
> +	int blkno = start, readcnt = 0;
> +	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> +
> +	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {
> +
> +		if ((!f2fs_test_bit(blkno, sit_i->sit_bitmap) ^ !*is_order)) {
> +			*is_order = !*is_order;
> +			break;
> +		}
> +
> +		blk_addr = sit_i->sit_base_addr + blkno;
> +		if (*is_order)
> +			blk_addr += sit_i->sit_blocks;
> +repeat:
> +		page = grab_cache_page(mapping, blk_addr);
> +		if (!page) {
> +			cond_resched();
> +			goto repeat;
> +		}
> +		if (PageUptodate(page)) {
> +			mark_page_accessed(page);
> +			f2fs_put_page(page, 1);
> +			readcnt++;
> +			continue;
> +		}
> +
> +		submit_read_page(sbi, page, blk_addr, READ_SYNC);
> +
> +		mark_page_accessed(page);
> +		f2fs_put_page(page, 0);
> +		readcnt++;
> +	}
> +
> +	f2fs_submit_read_bio(sbi, READ_SYNC);
> +	return readcnt;
> +}
> +
>  static void build_sit_entries(struct f2fs_sb_info *sbi)
>  {
>  	struct sit_info *sit_i = SIT_I(sbi);
>  	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_COLD_DATA);
>  	struct f2fs_summary_block *sum = curseg->sum_blk;
> -	unsigned int start;
> -
> -	for (start = 0; start < TOTAL_SEGS(sbi); start++) {
> -		struct seg_entry *se = &sit_i->sentries[start];
> -		struct f2fs_sit_block *sit_blk;
> -		struct f2fs_sit_entry sit;
> -		struct page *page;
> -		int i;
> +	bool is_order = f2fs_test_bit(0, sit_i->sit_bitmap) ? true : false;
> +	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> +	unsigned int i, start, end;
> +	unsigned int readed, start_blk = 0;
>  
> -		mutex_lock(&curseg->curseg_mutex);
> -		for (i = 0; i < sits_in_cursum(sum); i++) {
> -			if (le32_to_cpu(segno_in_journal(sum, i)) == start) {
> -				sit = sit_in_journal(sum, i);
> -				mutex_unlock(&curseg->curseg_mutex);
> -				goto got_it;
> +	do {

How about using find_next_bit to get the suitable start_blk if the next blk
is not ordered here? And it also can simplify the logic of ra_sit_pages().

Thanks,
Gu

> +		readed = ra_sit_pages(sbi, start_blk, sit_blk_cnt, &is_order);
> +
> +		start = start_blk * sit_i->sents_per_block;
> +		end = (start_blk + readed) * sit_i->sents_per_block;
> +
> +		for (; start < end && start < TOTAL_SEGS(sbi); start++) {
> +			struct seg_entry *se = &sit_i->sentries[start];
> +			struct f2fs_sit_block *sit_blk;
> +			struct f2fs_sit_entry sit;
> +			struct page *page;
> +
> +			mutex_lock(&curseg->curseg_mutex);
> +			for (i = 0; i < sits_in_cursum(sum); i++) {
> +				if (le32_to_cpu(segno_in_journal(sum, i)) == start) {
> +					sit = sit_in_journal(sum, i);
> +					mutex_unlock(&curseg->curseg_mutex);
> +					goto got_it;
> +				}
>  			}
> -		}
> -		mutex_unlock(&curseg->curseg_mutex);
> -		page = get_current_sit_page(sbi, start);
> -		sit_blk = (struct f2fs_sit_block *)page_address(page);
> -		sit = sit_blk->entries[SIT_ENTRY_OFFSET(sit_i, start)];
> -		f2fs_put_page(page, 1);
> +			mutex_unlock(&curseg->curseg_mutex);
> +
> +			page = get_current_sit_page(sbi, start);
> +			sit_blk = (struct f2fs_sit_block *)page_address(page);
> +			sit = sit_blk->entries[SIT_ENTRY_OFFSET(sit_i, start)];
> +			f2fs_put_page(page, 1);
>  got_it:
> -		check_block_count(sbi, start, &sit);
> -		seg_info_from_raw_sit(se, &sit);
> -		if (sbi->segs_per_sec > 1) {
> -			struct sec_entry *e = get_sec_entry(sbi, start);
> -			e->valid_blocks += se->valid_blocks;
> +			check_block_count(sbi, start, &sit);
> +			seg_info_from_raw_sit(se, &sit);
> +			if (sbi->segs_per_sec > 1) {
> +				struct sec_entry *e = get_sec_entry(sbi, start);
> +				e->valid_blocks += se->valid_blocks;
> +			}
>  		}
> -	}
> +		start_blk += readed;




> +	} while (start_blk < sit_blk_cnt);
>  }
>  
>  static void init_free_segmap(struct f2fs_sb_info *sbi)
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> index 269f690..ad5b9f1 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -83,6 +83,8 @@
>  	(segno / SIT_ENTRY_PER_BLOCK)
>  #define	START_SEGNO(sit_i, segno)		\
>  	(SIT_BLOCK_OFFSET(sit_i, segno) * SIT_ENTRY_PER_BLOCK)
> +#define SIT_BLK_CNT(sbi)			\
> +	((TOTAL_SEGS(sbi) + SIT_ENTRY_PER_BLOCK - 1) / SIT_ENTRY_PER_BLOCK)
>  #define f2fs_bitmap_size(nr)			\
>  	(BITS_TO_LONGS(nr) * sizeof(unsigned long))
>  #define TOTAL_SEGS(sbi)	(SM_I(sbi)->main_segments)


