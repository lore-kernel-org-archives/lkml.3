Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3KNKh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:37:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61223 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab3KNKh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:37:26 -0500
X-IronPort-AV: E=Sophos;i="4.93,699,1378828800"; 
   d="scan'208";a="9034437"
Message-ID: <5284A667.7020103@cn.fujitsu.com>
Date: Thu, 14 Nov 2013 18:31:03 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: "'???'" <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        =?GB2312?B?J8y35q0n?= <shu.tan@samsung.com>
Subject: Re: [f2fs-dev] [PATCH 2/2] f2fs: read contiguous sit entry pages
 by merging for mount performance
References: <000101cedf66$c2e7ea40$48b7bec0$@samsung.com> <5282F470.4020401@cn.fujitsu.com> <000001cee047$e7bebce0$b73c36a0$@samsung.com>
In-Reply-To: <000001cee047$e7bebce0$b73c36a0$@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/14 18:35:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/14 18:35:36
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu,
On 11/13/2013 04:10 PM, Chao Yu wrote:

> Hi Gu,
> 
>> -----Original Message-----
>> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
>> Sent: Wednesday, November 13, 2013 11:39 AM
>> To: Chao Yu
>> Cc: ???; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; Ì·æ­
>> Subject: Re: [f2fs-dev] [PATCH 2/2] f2fs: read contiguous sit entry pages by merging for mount performance
>>
>> Hi Yu,
>> On 11/12/2013 01:18 PM, Chao Yu wrote:
>>
>>> Previously we read sit entries page one by one, this method lost the chance of reading contiguous page together.
>>> So we read pages as contiguous as possible for better mount performance.
>>>
>>> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
>>> ---
>>>  fs/f2fs/f2fs.h    |    2 ++
>>>  fs/f2fs/segment.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>>>  fs/f2fs/segment.h |    2 ++
>>>  3 files changed, 66 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>>> index 0afdcec..bfe9d87 100644
>>> --- a/fs/f2fs/f2fs.h
>>> +++ b/fs/f2fs/f2fs.h
>>> @@ -1113,6 +1113,8 @@ struct page *find_data_page(struct inode *, pgoff_t, bool);
>>>  struct page *get_lock_data_page(struct inode *, pgoff_t);
>>>  struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
>>>  int f2fs_readpage(struct f2fs_sb_info *, struct page *, block_t, int);
>>> +void f2fs_submit_read_bio(struct f2fs_sb_info *, int);
>>> +void submit_read_page(struct f2fs_sb_info *, struct page *, block_t, int);
>>
>> Better to move these declarations into PATCH 1/2.
> 
> Okay, I will move it to the right place.
> 
>>
>>>  int do_write_data_page(struct page *);
>>>
>>>  /*
>>> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
>>> index 86dc289..414c351 100644
>>> --- a/fs/f2fs/segment.c
>>> +++ b/fs/f2fs/segment.c
>>> @@ -1474,19 +1474,72 @@ static int build_curseg(struct f2fs_sb_info *sbi)
>>>  	return restore_curseg_summaries(sbi);
>>>  }
>>>
>>> +static int ra_sit_pages(struct f2fs_sb_info *sbi, int start,
>>> +					int nrpages, bool *is_order)
>>> +{
>>> +	struct address_space *mapping = sbi->meta_inode->i_mapping;
>>> +	struct sit_info *sit_i = SIT_I(sbi);
>>> +	struct page *page;
>>> +	block_t blk_addr;
>>> +	int blkno, readcnt = 0;
>>> +	int sit_blk_cnt = SIT_BLK_CNT(sbi);
>>> +
>>> +	for (blkno = start; blkno < start + nrpages; blkno++) {
>>> +
>>> +		if (blkno >= sit_blk_cnt)
>>
>> Merge these two judgements:
>> for (blkno = start; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++)
> 
> Right, but the line may over 80 characters, if we split this line, it seems not suitable.
> So how about this?
> 	int blkno = start, readcnt = 0;
> 	int sit_blk_cnt = SIT_BLK_CNT(sbi);
> 
> 	for (; blkno < start + nrpages && blkno < sit_blk_cnt; blkno++) {

More neat£¡

> 
>>
>>> +			goto out;
>>
>>> +		if ((!f2fs_test_bit(blkno, sit_i->sit_bitmap) ^ !*is_order)) {
>>> +			*is_order = !*is_order;
>>> +			goto out;
>>
>> 'Break' seems more suitable.
> 
> Yes, you are right.
> 
>>
>>> +		}
>>> +
>>> +		blk_addr = sit_i->sit_base_addr + blkno;
>>> +		if (*is_order)
>>> +			blk_addr += sit_i->sit_blocks;
>>> +repeat:
>>> +		page = grab_cache_page(mapping, blk_addr);
>>> +		if (!page) {
>>> +			cond_resched();
>>> +			goto repeat;
>>> +		}
>>> +		if (PageUptodate(page)) {
>>> +			f2fs_put_page(page, 1);
>>> +			readcnt++;
>>> +			goto out;
>>
>> Here may be 'Continue'.
> 
> 'Out' label could be removed after this modification.
> It seems more neat.

Right.

> 
>>
>>> +		}
>>> +
>>> +		submit_read_page(sbi, page, blk_addr, READ_SYNC);
>>> +
>>> +		page_cache_release(page);
>>
>> Put page here seems not a good idea, otherwise all your work may be in vain.
> 
> You mean that pages could be reclaimed by VM when out of memory?
> IMO, it is designed more like VM read ahead because we should concern 
> memory state of system, and still we have second chance to read these pages.
> 

Yes, but we can avoid to read the same page secondly, that's a serious waste, if we still
reread the page in get_current_sit_page(), all the improvement will disappear.

> Could we use mark_page_accessed () to delay VM reclaimed them?

IMO, this is the right way.

> 
>>
>>> +		readcnt++;
>>> +	}
>>> +out:
>>> +	f2fs_submit_read_bio(sbi, READ_SYNC);
>>> +	return readcnt;
>>> +}
>>> +
>>>  static void build_sit_entries(struct f2fs_sb_info *sbi)
>>>  {
>>>  	struct sit_info *sit_i = SIT_I(sbi);
>>>  	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_COLD_DATA);
>>>  	struct f2fs_summary_block *sum = curseg->sum_blk;
>>> -	unsigned int start;
>>> +	bool is_order = f2fs_test_bit(0, sit_i->sit_bitmap) ? true : false;
>>> +	int sit_blk_cnt = SIT_BLK_CNT(sbi);
>>> +	int bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
>>> +	unsigned int i, start, end;
>>> +	unsigned int readed, start_blk = 0;
>>>
>>> -	for (start = 0; start < TOTAL_SEGS(sbi); start++) {
>>> +next:
>>> +	readed = ra_sit_pages(sbi, start_blk, bio_blocks, &is_order);
>>
>> In fact, you know how many blocks that you want to read(SIT_BLK_CNT(sbi)),
>> so here sit_blk_cnt is more suitable than a MAX one, and it also can make
>> the logic of ra_sit_pages more simple.
> 
> Right.
> 
> BTW, I am considering that maybe we should send dynamical cnt which 
> depend on memory state of system more than the logic of ra_sit_pages.
> May it's the work of anther patch. How do you think?

Agree. It's the same as the way that I suggested previously, and it can make
the contiguous pages reading api more common.

Regards,
Gu

> 
>>
>>> +
>>> +	start = start_blk * sit_i->sents_per_block;
>>> +	end = (start_blk + readed) * sit_i->sents_per_block;
>>> +
>>> +	for (; start < end && start < TOTAL_SEGS(sbi); start++) {
>>>  		struct seg_entry *se = &sit_i->sentries[start];
>>>  		struct f2fs_sit_block *sit_blk;
>>>  		struct f2fs_sit_entry sit;
>>>  		struct page *page;
>>> -		int i;
>>>
>>>  		mutex_lock(&curseg->curseg_mutex);
>>>  		for (i = 0; i < sits_in_cursum(sum); i++) {
>>> @@ -1497,6 +1550,7 @@ static void build_sit_entries(struct f2fs_sb_info *sbi)
>>>  			}
>>>  		}
>>>  		mutex_unlock(&curseg->curseg_mutex);
>>> +
>>>  		page = get_current_sit_page(sbi, start);
>>>  		sit_blk = (struct f2fs_sit_block *)page_address(page);
>>>  		sit = sit_blk->entries[SIT_ENTRY_OFFSET(sit_i, start)];
>>> @@ -1509,6 +1563,11 @@ got_it:
>>>  			e->valid_blocks += se->valid_blocks;
>>>  		}
>>>  	}
>>> +
>>> +	start_blk += readed;
>>> +	if (start_blk >= sit_blk_cnt)
>>> +		return;
>>> +	goto next;
>>
>> Using do {...} while(start_blk < sit_blk_cnt) rather than the so big upstream goto.
> 
> Yes, you are right.
> 
>>
>>>  }
>>>
>>>  static void init_free_segmap(struct f2fs_sb_info *sbi)
>>> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
>>> index 269f690..ad5b9f1 100644
>>> --- a/fs/f2fs/segment.h
>>> +++ b/fs/f2fs/segment.h
>>> @@ -83,6 +83,8 @@
>>>  	(segno / SIT_ENTRY_PER_BLOCK)
>>>  #define	START_SEGNO(sit_i, segno)		\
>>>  	(SIT_BLOCK_OFFSET(sit_i, segno) * SIT_ENTRY_PER_BLOCK)
>>> +#define SIT_BLK_CNT(sbi)			\
>>> +	((TOTAL_SEGS(sbi) + SIT_ENTRY_PER_BLOCK - 1) / SIT_ENTRY_PER_BLOCK)
>>>  #define f2fs_bitmap_size(nr)			\
>>>  	(BITS_TO_LONGS(nr) * sizeof(unsigned long))
>>>  #define TOTAL_SEGS(sbi)	(SM_I(sbi)->main_segments)
> 
> Thanks!
> 
> Regards,
> Yu
> 
> 
> 


