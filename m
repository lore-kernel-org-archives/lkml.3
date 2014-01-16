Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaAPJmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:42:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbaAPJmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:42:44 -0500
Message-ID: <52D7A952.3050907@redhat.com>
Date: Thu, 16 Jan 2014 10:41:38 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/4] zram: rework reported to end-user zram statistics
References: <1389780977-18949-1-git-send-email-sergey.senozhatsky@gmail.com> <1389780977-18949-4-git-send-email-sergey.senozhatsky@gmail.com> <20140116005645.GM1992@bbox> <20140116084638.GA2122@swordfish>
In-Reply-To: <20140116084638.GA2122@swordfish>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 09:46 AM, Sergey Senozhatsky wrote:
> On (01/16/14 09:56), Minchan Kim wrote:
>> Hello Sergey,
>>
>> On Wed, Jan 15, 2014 at 01:16:16PM +0300, Sergey Senozhatsky wrote:
>>> 1) Introduce ZRAM_ATTR_RO macro to generate zram atomic64_t stats
>>> `show' functions and reduce code duplication.
>>>
>>> 2) Remove `good' and `bad' compressed sub-requests stats. RW request may
>>> cause a number of RW sub-requests. zram used to account `good' compressed
>>> sub-queries (with compressed size less than 50% of original size), `bad'
>>> compressed sub-queries (with compressed size greater that 75% of original
>>> size), leaving sub-requests with compression size between 50% and 75% of
>>> original size not accounted and not reported. zram already accounts each
>>> sub-request's compression size so we can calculate real device compression
>>> ratio.
>>>
>>> Acked-by: Minchan Kim <minchan@kernel.org>
>>
>> I didn't give any Acked in this patch.
>> If I made you confused, Sorry about that.
>>
> 
> Hello,
> 
> sorry, I misread the situtation.

Now that Minchan draw my attention to it: neither did I.

> 
>> This patch did more than thing you mentioned in desription.
>>
>> 1. Introduce macro to remove code duplication
>>
>>    It's really good.

No argument here.

>>
>> 2. Change atomic_t with atomic64_t
>>
>>    At a first look, I didn't want it because lots of custormer for zram
>>    are still 32bit machines so their cost would be increased a bit due to
>>    any locking facility like cmpxchg on some architectures.
>>
>>    Having said that, I will support your cleanup patch now and then
>>    If we really have trouble with atomic stat operation, we could
>>    change it with percpu_counter so that it could solve atomic overhead and
>>    unnecessary memory space by introducing unsigned long instead of 64bit
>>    atomic_t.
>>
>>    So, please add this comment for future just in case of forgetting.
> 
> ok
> 
>> 3. Remove unreported some stat
>>
>>    Looks good to me.

To me too.

>>
> 
>> 4. Changing name of some stat
>>
>>    I couldn't understand what's the gain because I'm happy with
>>    orig_data_size and compr_data_size now.
>>
> 
> well, compressed_size contains regular english words and thus a regular
> user can easily understand it. compr_data_size looks like a variable name.
> I think I'll drop this at the moment.

I think that anybody who is going to read this stats will know that zram is
about compression and understand these abbreviations. I also like the fact
that they are both expressed in bytes, unlike the couple pages_store /
compressed_size.

> 
>> 5. Removed zram_init_device's warning
>>
>>    Why? This patch doesn't include any justification.
>>
> 
> I think I'll drop this part at the moment. the motivation for this
> cleanup was that, imho, such big informative warnings are part of
> documentation, not the source code.

Yet you didn't update the documentation.

Jerome

> 
> 	-ss
> 
>> 6. Removed unused field of enum zram_pageflags
>>
>>    Looks good to me.
>>
>> Please, separate it with each patches so let's focus one by one.
>>
>>
>>> Acked-by: Jerome Marchand <jmarchan@redhat.com>
>>> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
>>> ---
>>>  drivers/block/zram/zram_drv.c | 163 ++++++++++++------------------------------
>>>  drivers/block/zram/zram_drv.h |  17 ++---
>>>  2 files changed, 51 insertions(+), 129 deletions(-)
>>>
>>> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
>>> index b0bcb7e..6eb2155 100644
>>> --- a/drivers/block/zram/zram_drv.c
>>> +++ b/drivers/block/zram/zram_drv.c
>>> @@ -42,6 +42,17 @@ static struct zram *zram_devices;
>>>  /* Module params (documentation at end) */
>>>  static unsigned int num_devices = 1;
>>>  
>>> +#define ZRAM_ATTR_RO(name)						\
>>> +static ssize_t zram_attr_##name##_show(struct device *d,		\
>>> +				struct device_attribute *attr, char *b)	\
>>> +{									\
>>> +	struct zram *zram = dev_to_zram(d);				\
>>> +	return sprintf(b, "%llu\n",					\
>>> +		(u64)atomic64_read(&zram->stats.name));			\
>>> +}									\
>>> +static struct device_attribute dev_attr_##name =			\
>>> +	__ATTR(name, S_IRUGO, zram_attr_##name##_show, NULL);
>>> +
>>>  static inline int init_done(struct zram *zram)
>>>  {
>>>  	return zram->meta != NULL;
>>> @@ -52,97 +63,36 @@ static inline struct zram *dev_to_zram(struct device *dev)
>>>  	return (struct zram *)dev_to_disk(dev)->private_data;
>>>  }
>>>  
>>> -static ssize_t disksize_show(struct device *dev,
>>> -		struct device_attribute *attr, char *buf)
>>> -{
>>> -	struct zram *zram = dev_to_zram(dev);
>>> -
>>> -	return sprintf(buf, "%llu\n", zram->disksize);
>>> -}
>>> -
>>> -static ssize_t initstate_show(struct device *dev,
>>> -		struct device_attribute *attr, char *buf)
>>> -{
>>> -	struct zram *zram = dev_to_zram(dev);
>>> -
>>> -	return sprintf(buf, "%u\n", init_done(zram));
>>> -}
>>> -
>>> -static ssize_t num_reads_show(struct device *dev,
>>> -		struct device_attribute *attr, char *buf)
>>> -{
>>> -	struct zram *zram = dev_to_zram(dev);
>>> -
>>> -	return sprintf(buf, "%llu\n",
>>> -			(u64)atomic64_read(&zram->stats.num_reads));
>>> -}
>>> -
>>> -static ssize_t num_writes_show(struct device *dev,
>>> -		struct device_attribute *attr, char *buf)
>>> -{
>>> -	struct zram *zram = dev_to_zram(dev);
>>> -
>>> -	return sprintf(buf, "%llu\n",
>>> -			(u64)atomic64_read(&zram->stats.num_writes));
>>> -}
>>> -
>>> -static ssize_t invalid_io_show(struct device *dev,
>>> -		struct device_attribute *attr, char *buf)
>>> -{
>>> -	struct zram *zram = dev_to_zram(dev);
>>> -
>>> -	return sprintf(buf, "%llu\n",
>>> -			(u64)atomic64_read(&zram->stats.invalid_io));
>>> -}
>>> -
>>> -static ssize_t notify_free_show(struct device *dev,
>>> -		struct device_attribute *attr, char *buf)
>>> -{
>>> -	struct zram *zram = dev_to_zram(dev);
>>> -
>>> -	return sprintf(buf, "%llu\n",
>>> -			(u64)atomic64_read(&zram->stats.notify_free));
>>> -}
>>> -
>>> -static ssize_t zero_pages_show(struct device *dev,
>>> -		struct device_attribute *attr, char *buf)
>>> -{
>>> -	struct zram *zram = dev_to_zram(dev);
>>> -
>>> -	return sprintf(buf, "%u\n", atomic_read(&zram->stats.pages_zero));
>>> -}
>>> -
>>> -static ssize_t orig_data_size_show(struct device *dev,
>>> +static ssize_t memory_used_show(struct device *dev,
>>>  		struct device_attribute *attr, char *buf)
>>>  {
>>> +	u64 val = 0;
>>>  	struct zram *zram = dev_to_zram(dev);
>>> +	struct zram_meta *meta = zram->meta;
>>>  
>>> -	return sprintf(buf, "%llu\n",
>>> -		(u64)(atomic_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
>>> +	down_read(&zram->init_lock);
>>> +	if (init_done(zram))
>>> +		val = zs_get_total_size_bytes(meta->mem_pool);
>>> +	up_read(&zram->init_lock);
>>> +	return sprintf(buf, "%llu\n", val);
>>>  }
>>>  
>>> -static ssize_t compr_data_size_show(struct device *dev,
>>> +static ssize_t disksize_show(struct device *dev,
>>>  		struct device_attribute *attr, char *buf)
>>>  {
>>>  	struct zram *zram = dev_to_zram(dev);
>>> -
>>> -	return sprintf(buf, "%llu\n",
>>> -			(u64)atomic64_read(&zram->stats.compr_size));
>>> +	return sprintf(buf, "%llu\n", zram->disksize);
>>>  }
>>>  
>>> -static ssize_t mem_used_total_show(struct device *dev,
>>> +static ssize_t initstate_show(struct device *dev,
>>>  		struct device_attribute *attr, char *buf)
>>>  {
>>> -	u64 val = 0;
>>> +	u32 val = 0;
>>>  	struct zram *zram = dev_to_zram(dev);
>>> -	struct zram_meta *meta = zram->meta;
>>> -
>>>  	down_read(&zram->init_lock);
>>> -	if (init_done(zram))
>>> -		val = zs_get_total_size_bytes(meta->mem_pool);
>>> +	val = init_done(zram);
>>>  	up_read(&zram->init_lock);
>>> -
>>> -	return sprintf(buf, "%llu\n", val);
>>> +	return sprintf(buf, "%u\n", val);
>>>  }
>>>  
>>>  /* flag operations needs meta->tb_lock */
>>> @@ -293,7 +243,6 @@ static void zram_free_page(struct zram *zram, size_t index)
>>>  {
>>>  	struct zram_meta *meta = zram->meta;
>>>  	unsigned long handle = meta->table[index].handle;
>>> -	u16 size = meta->table[index].size;
>>>  
>>>  	if (unlikely(!handle)) {
>>>  		/*
>>> @@ -302,21 +251,15 @@ static void zram_free_page(struct zram *zram, size_t index)
>>>  		 */
>>>  		if (zram_test_flag(meta, index, ZRAM_ZERO)) {
>>>  			zram_clear_flag(meta, index, ZRAM_ZERO);
>>> -			atomic_dec(&zram->stats.pages_zero);
>>> +			atomic64_dec(&zram->stats.pages_zero);
>>>  		}
>>>  		return;
>>>  	}
>>>  
>>> -	if (unlikely(size > max_zpage_size))
>>> -		atomic_dec(&zram->stats.bad_compress);
>>> -
>>>  	zs_free(meta->mem_pool, handle);
>>>  
>>> -	if (size <= PAGE_SIZE / 2)
>>> -		atomic_dec(&zram->stats.good_compress);
>>> -
>>> -	atomic64_sub(meta->table[index].size, &zram->stats.compr_size);
>>> -	atomic_dec(&zram->stats.pages_stored);
>>> +	atomic64_sub(meta->table[index].size, &zram->stats.compressed_size);
>>> +	atomic64_dec(&zram->stats.pages_stored);
>>>  
>>>  	meta->table[index].handle = 0;
>>>  	meta->table[index].size = 0;
>>> @@ -459,7 +402,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>>>  		zram_set_flag(meta, index, ZRAM_ZERO);
>>>  		write_unlock(&zram->meta->tb_lock);
>>>  
>>> -		atomic_inc(&zram->stats.pages_zero);
>>> +		atomic64_inc(&zram->stats.pages_zero);
>>>  		ret = 0;
>>>  		goto out;
>>>  	}
>>> @@ -478,7 +421,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>>>  	}
>>>  
>>>  	if (unlikely(clen > max_zpage_size)) {
>>> -		atomic_inc(&zram->stats.bad_compress);
>>>  		clen = PAGE_SIZE;
>>>  		src = NULL;
>>>  		if (is_partial_io(bvec))
>>> @@ -516,11 +458,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>>>  	write_unlock(&zram->meta->tb_lock);
>>>  
>>>  	/* Update stats */
>>> -	atomic64_add(clen, &zram->stats.compr_size);
>>> -	atomic_inc(&zram->stats.pages_stored);
>>> -	if (clen <= PAGE_SIZE / 2)
>>> -		atomic_inc(&zram->stats.good_compress);
>>> -
>>> +	atomic64_add(clen, &zram->stats.compressed_size);
>>> +	atomic64_inc(&zram->stats.pages_stored);
>>>  out:
>>>  	if (locked)
>>>  		mutex_unlock(&meta->buffer_lock);
>>> @@ -583,23 +522,8 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>>>  
>>>  static void zram_init_device(struct zram *zram, struct zram_meta *meta)
>>>  {
>>> -	if (zram->disksize > 2 * (totalram_pages << PAGE_SHIFT)) {
>>> -		pr_info(
>>> -		"There is little point creating a zram of greater than "
>>> -		"twice the size of memory since we expect a 2:1 compression "
>>> -		"ratio. Note that zram uses about 0.1%% of the size of "
>>> -		"the disk when not in use so a huge zram is "
>>> -		"wasteful.\n"
>>> -		"\tMemory Size: %lu kB\n"
>>> -		"\tSize you selected: %llu kB\n"
>>> -		"Continuing anyway ...\n",
>>> -		(totalram_pages << PAGE_SHIFT) >> 10, zram->disksize >> 10
>>> -		);
>>> -	}
>>> -
>>>  	/* zram devices sort of resembles non-rotational disks */
>>>  	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
>>> -
>>>  	zram->meta = meta;
>>>  	pr_debug("Initialization done!\n");
>>>  }
>>> @@ -771,14 +695,15 @@ static DEVICE_ATTR(disksize, S_IRUGO | S_IWUSR,
>>>  		disksize_show, disksize_store);
>>>  static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
>>>  static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
>>> -static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
>>> -static DEVICE_ATTR(num_writes, S_IRUGO, num_writes_show, NULL);
>>> -static DEVICE_ATTR(invalid_io, S_IRUGO, invalid_io_show, NULL);
>>> -static DEVICE_ATTR(notify_free, S_IRUGO, notify_free_show, NULL);
>>> -static DEVICE_ATTR(zero_pages, S_IRUGO, zero_pages_show, NULL);
>>> -static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
>>> -static DEVICE_ATTR(compr_data_size, S_IRUGO, compr_data_size_show, NULL);
>>> -static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
>>> +static DEVICE_ATTR(memory_used, S_IRUGO, memory_used_show, NULL);
>>> +
>>> +ZRAM_ATTR_RO(num_reads);
>>> +ZRAM_ATTR_RO(num_writes);
>>> +ZRAM_ATTR_RO(pages_stored);
>>> +ZRAM_ATTR_RO(invalid_io);
>>> +ZRAM_ATTR_RO(notify_free);
>>> +ZRAM_ATTR_RO(pages_zero);
>>> +ZRAM_ATTR_RO(compressed_size);
>>>  
>>>  static struct attribute *zram_disk_attrs[] = {
>>>  	&dev_attr_disksize.attr,
>>> @@ -786,12 +711,12 @@ static struct attribute *zram_disk_attrs[] = {
>>>  	&dev_attr_reset.attr,
>>>  	&dev_attr_num_reads.attr,
>>>  	&dev_attr_num_writes.attr,
>>> +	&dev_attr_pages_stored.attr,
>>>  	&dev_attr_invalid_io.attr,
>>>  	&dev_attr_notify_free.attr,
>>> -	&dev_attr_zero_pages.attr,
>>> -	&dev_attr_orig_data_size.attr,
>>> -	&dev_attr_compr_data_size.attr,
>>> -	&dev_attr_mem_used_total.attr,
>>> +	&dev_attr_pages_zero.attr,
>>> +	&dev_attr_compressed_size.attr,
>>> +	&dev_attr_memory_used.attr,
>>>  	NULL,
>>>  };
>>>  
>>> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
>>> index e81e9cd..277023d 100644
>>> --- a/drivers/block/zram/zram_drv.h
>>> +++ b/drivers/block/zram/zram_drv.h
>>> @@ -64,22 +64,19 @@ enum zram_pageflags {
>>>  struct table {
>>>  	unsigned long handle;
>>>  	u16 size;	/* object size (excluding header) */
>>> -	u8 count;	/* object ref count (not yet used) */
>>> -	u8 flags;
>>> +	u16 flags;
>>>  } __aligned(4);
>>>  
>>>  struct zram_stats {
>>> -	atomic64_t compr_size;	/* compressed size of pages stored */
>>> -	atomic64_t num_reads;	/* failed + successful */
>>> -	atomic64_t num_writes;	/* --do-- */
>>> -	atomic64_t failed_reads;	/* should NEVER! happen */
>>> +	atomic64_t num_writes;	/* number of writes */
>>> +	atomic64_t num_reads;	/* number of reads */
>>> +	atomic64_t pages_stored;	/* no. of pages currently stored */
>>> +	atomic64_t compressed_size;	/* compressed size of pages stored */
>>> +	atomic64_t pages_zero;		/* no. of zero filled pages */
>>> +	atomic64_t failed_reads;	/* no. of failed reads */
>>>  	atomic64_t failed_writes;	/* can happen when memory is too low */
>>>  	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
>>>  	atomic64_t notify_free;	/* no. of swap slot free notifications */
>>> -	atomic_t pages_zero;		/* no. of zero filled pages */
>>> -	atomic_t pages_stored;	/* no. of pages currently stored */
>>> -	atomic_t good_compress;	/* % of pages with compression ratio<=50% */
>>> -	atomic_t bad_compress;	/* % of pages with compression ratio>=75% */
>>>  };
>>>  
>>>  struct zram_meta {
>>> -- 
>>> 1.8.5.3.493.gb139ac2
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>> -- 
>> Kind regards,
>> Minchan Kim
>>

