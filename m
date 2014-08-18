Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaHRBTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 21:19:50 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:37347 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaHRBTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 21:19:49 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53F154AE.9010908@lge.com>
Date: Mon, 18 Aug 2014 10:19:42 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [PATCH 1/2] fs/buffer.c: allocate buffer cache from non-movable
 area
References: <53EC4531.1000904@lge.com>	<53EC45FC.7050508@lge.com> <20140814142225.50911fd0a0bf65427a1a214f@linux-foundation.org>
In-Reply-To: <20140814142225.50911fd0a0bf65427a1a214f@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-08-15 오전 6:22, Andrew Morton 쓴 글:
> On Thu, 14 Aug 2014 14:15:40 +0900 Gioh Kim <gioh.kim@lge.com> wrote:
>
>> A buffer cache is allocated from movable area
>> because it is referred for a while and released soon.
>> But some filesystems are taking buffer cache for a long time
>> and it can disturb page migration.
>>
>> A new API should be introduced to allocate buffer cache from
>> non-movable area.
>
> I think the API could and should be more flexible than this.
>
> Rather than making the API be "movable or not movable", let's permit
> callers to specify the gfp_t and leave it at that.  That way, if
> someone later wants to allocate a buffer head with, I dunno,
> __GFP_NOTRACK then they can do so.
>
> So the word "movable" shouldn't appear in buffer.c at all, except in a
> single place.

Absolutely I agree with you.
If filesystem developers agree this patch I will send 2nd patch that applies your ideas.

Thank you for your advices.

>
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -993,7 +993,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
>>    */
>>   static int
>>   grow_dev_page(struct block_device *bdev, sector_t block,
>> -               pgoff_t index, int size, int sizebits)
>> +             pgoff_t index, int size, int sizebits, gfp_t movable_mask)
>
> s/movable_mask/gfp/

I got it.

>
>>   {
>>          struct inode *inode = bdev->bd_inode;
>>          struct page *page;
>> @@ -1003,7 +1003,8 @@ grow_dev_page(struct block_device *bdev, sector_t block,
>>          gfp_t gfp_mask;
>>
>>          gfp_mask = mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
>> -       gfp_mask |= __GFP_MOVABLE;
>> +       if (movable_mask & __GFP_MOVABLE)
>> +               gfp_mask |= __GFP_MOVABLE;
>
> This becomes
>
> 	gfp_mask |= gfp;

I got it.

>
>>          /*
>>           * XXX: __getblk_slow() can not really deal with failure and
>>           * will endlessly loop on improvised global reclaim.  Prefer
>> @@ -1058,7 +1059,8 @@ failed:
>>    * that page was dirty, the buffers are set dirty also.
>>    */
>>   static int
>> -grow_buffers(struct block_device *bdev, sector_t block, int size)
>> +grow_buffers(struct block_device *bdev, sector_t block,
>> +            int size, gfp_t movable_mask)
>
> gfp
>
>>   {
>>          pgoff_t index;
>>          int sizebits;
>> @@ -1085,11 +1087,12 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
>>          }
>>
>>          /* Create a page with the proper size buffers.. */
>> -       return grow_dev_page(bdev, block, index, size, sizebits);
>> +       return grow_dev_page(bdev, block, index, size, sizebits, movable_mask);
>>   }
>>
>>   static struct buffer_head *
>> -__getblk_slow(struct block_device *bdev, sector_t block, int size)
>> +__getblk_slow(struct block_device *bdev, sector_t block,
>> +             int size, gfp_t movable_mask)
>
> gfp
>
>>   {
>>          /* Size must be multiple of hard sectorsize */
>>          if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
>> @@ -1111,7 +1114,7 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
>>                  if (bh)
>>                          return bh;
>>
>> -               ret = grow_buffers(bdev, block, size);
>> +               ret = grow_buffers(bdev, block, size, movable_mask);
>
> gfp
>
>>                  if (ret < 0)
>>                          return NULL;
>>                  if (ret == 0)
>> @@ -1385,11 +1388,34 @@ __getblk(struct block_device *bdev, sector_t block, unsigned size)
>>
>>          might_sleep();
>>          if (bh == NULL)
>> -               bh = __getblk_slow(bdev, block, size);
>> +               bh = __getblk_slow(bdev, block, size, __GFP_MOVABLE);
>
> Here is the place where buffer.c. mentions "movable".

I got it.

>
>>          return bh;
>>   }
>>   EXPORT_SYMBOL(__getblk);
>>
>> + /*
>> + * __getblk_nonmovable will locate (and, if necessary, create) the buffer_head
>> + * which corresponds to the passed block_device, block and size. The
>> + * returned buffer has its reference count incremented.
>> + *
>> + * The page cache is allocated from non-movable area
>> + * not to prevent page migration.
>> + *
>> + * __getblk()_nonmovable will lock up the machine
>> + * if grow_dev_page's try_to_free_buffers() attempt is failing. FIXME, perhaps?
>> + */
>> +struct buffer_head *
>> +__getblk_nonmovable(struct block_device *bdev, sector_t block, unsigned size)
>> +{
>> +       struct buffer_head *bh = __find_get_block(bdev, block, size);
>> +
>> +       might_sleep();
>> +       if (bh == NULL)
>> +               bh = __getblk_slow(bdev, block, size, 0);
>> +       return bh;
>> +}
>> +EXPORT_SYMBOL(__getblk_nonmovable);
>
> Suggest this be called __getblk_gfp(bdev, block, size, gfp) and then
> __getblk() be changed to call __getblk_gfp(..., __GFP_MOVABLE).
>
> We could then write a __getblk_nonmovable() which calls __getblk_gfp()
> (a static inlined one-line function) or we can just call
> __getblk_gfp(..., 0) directly from filesystems.

I got it.


>
>> @@ -1423,6 +1450,28 @@ __bread(struct block_device *bdev, sector_t block, unsigned size)
>>   }
>>   EXPORT_SYMBOL(__bread);
>>
>> +/**
>> + *  __bread_nonmovable() - reads a specified block and returns the bh
>> + *  @bdev: the block_device to read from
>> + *  @block: number of block
>> + *  @size: size (in bytes) to read
>> + *
>> + *  Reads a specified block, and returns buffer head that contains it.
>> + *  The page cache is allocated from non-movable area
>> + *  not to prevent page migration.
>> + *  It returns NULL if the block was unreadable.
>> + */
>> +struct buffer_head *
>> +__bread_nonmovable(struct block_device *bdev, sector_t block, unsigned size)
>> +{
>> +       struct buffer_head *bh = __getblk_slow(bdev, block, size, 0);
>> +
>> +       if (likely(bh) && !buffer_uptodate(bh))
>> +               bh = __bread_slow(bh);
>> +       return bh;
>> +}
>> +EXPORT_SYMBOL(__bread_nonmovable);
>
> Treat this in the same fashion as __getblk_nonmovable().

I got it.

>
>
>
