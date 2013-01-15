Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3AOCFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 21:05:34 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:33344 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab3AOCFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 21:05:32 -0500
MIME-Version: 1.0
In-Reply-To: <20130114145630.GH6597@quack.suse.cz>
References: <1357971188-16023-1-git-send-email-linkinjeon@gmail.com>
	<20130114145630.GH6597@quack.suse.cz>
Date: Tue, 15 Jan 2013 11:05:31 +0900
Message-ID: <CAKYAXd9rM0QWkCQw3fiSxmk-zH2gntjif1rzasxKYX=0g-vd7Q@mail.gmail.com>
Subject: Re: [PATCH] udf: add extent cache support in case of file reading
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/14, Jan Kara <jack@suse.cz>:
> On Sat 12-01-13 15:13:08, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This patch implements extent caching in case of file reading.
>> While reading a file, currently, UDF reads metadata serially
>> which takes a lot of time depending on the number of extents present
>> in the file. Caching last accessd extent improves metadata read time.
>> Instead of reading file metadata from start, now we read from
>> the cached extent.
>>
>> This patch considerably improves the time spent by CPU in kernel mode.
>> For example, while reading a 10.9 GB file using dd:
>> Time before applying patch:
>> 11677022208 bytes (10.9GB) copied, 1529.748921 seconds, 7.3MB/s
>> real    25m 29.85s
>> user    0m 12.41s
>> sys     15m 34.75s
>>
>> Time after applying patch:
>> 11677022208 bytes (10.9GB) copied, 1469.338231 seconds, 7.6MB/s
>> real    24m 29.44s
>> user    0m 15.73s
>> sys     3m 27.61s
>   Thanks for the patch! I have just three minor comments below.
Hi. Jan.
After fixing, I will resend v2 patch again.

Thanks for review!
>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
>> Signed-off-by: Bonggil Bak <bgbak@samsung.com>
>> ---
>>  fs/udf/ialloc.c  |    2 ++
>>  fs/udf/inode.c   |   74
>> +++++++++++++++++++++++++++++++++++++++++++++++++-----
>>  fs/udf/udf_i.h   |   17 +++++++++++++
>>  fs/udf/udfdecl.h |   10 ++++----
>>  4 files changed, 92 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
>> index 7e5aae4..7dd86a4a 100644
>> --- a/fs/udf/ialloc.c
>> +++ b/fs/udf/ialloc.c
>> @@ -117,6 +117,8 @@ struct inode *udf_new_inode(struct inode *dir, umode_t
>> mode, int *err)
>>  	iinfo->i_lenAlloc = 0;
>>  	iinfo->i_use = 0;
>>  	iinfo->i_checkpoint = 1;
>> +	memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
>> +	mutex_init(&(iinfo->i_extent_cache_lock));
>>  	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
>>  		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
>>  	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
>> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
>> index cbae1ed..9980381 100644
>> --- a/fs/udf/inode.c
>> +++ b/fs/udf/inode.c
>> @@ -90,6 +90,7 @@ void udf_evict_inode(struct inode *inode)
>>  	}
>>  	kfree(iinfo->i_ext.i_data);
>>  	iinfo->i_ext.i_data = NULL;
>> +	udf_clear_extent_cache(iinfo);
>>  	if (want_delete) {
>>  		udf_free_inode(inode);
>>  	}
>> @@ -105,6 +106,7 @@ static void udf_write_failed(struct address_space
>> *mapping, loff_t to)
>>  		truncate_pagecache(inode, to, isize);
>>  		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
>>  			down_write(&iinfo->i_data_sem);
>> +			udf_clear_extent_cache(iinfo);
>>  			udf_truncate_extents(inode);
>>  			up_write(&iinfo->i_data_sem);
>>  		}
>> @@ -372,7 +374,7 @@ static int udf_get_block(struct inode *inode, sector_t
>> block,
>>  		iinfo->i_next_alloc_goal++;
>>  	}
>>
>> -
>> +	udf_clear_extent_cache(iinfo);
>>  	phys = inode_getblk(inode, block, &err, &new);
>>  	if (!phys)
>>  		goto abort;
>> @@ -1171,6 +1173,7 @@ set_size:
>>  	} else {
>>  		if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
>>  			down_write(&iinfo->i_data_sem);
>> +			udf_clear_extent_cache(iinfo);
>>  			memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr + newsize,
>>  			       0x00, bsize - newsize -
>>  			       udf_file_entry_alloc_offset(inode));
>> @@ -1184,6 +1187,7 @@ set_size:
>>  		if (err)
>>  			return err;
>>  		down_write(&iinfo->i_data_sem);
>> +		udf_clear_extent_cache(iinfo);
>>  		truncate_setsize(inode, newsize);
>>  		udf_truncate_extents(inode);
>>  		up_write(&iinfo->i_data_sem);
>> @@ -1301,6 +1305,8 @@ static void udf_fill_inode(struct inode *inode,
>> struct buffer_head *bh)
>>  	iinfo->i_lenAlloc = 0;
>>  	iinfo->i_next_alloc_block = 0;
>>  	iinfo->i_next_alloc_goal = 0;
>> +	memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
>> +	mutex_init(&(iinfo->i_extent_cache_lock));
>>  	if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_EFE)) {
>>  		iinfo->i_efe = 1;
>>  		iinfo->i_use = 0;
>> @@ -2156,11 +2162,12 @@ int8_t inode_bmap(struct inode *inode, sector_t
>> block,
>>  	struct udf_inode_info *iinfo;
>>
>>  	iinfo = UDF_I(inode);
>> -	pos->offset = 0;
>> -	pos->block = iinfo->i_location;
>> -	pos->bh = NULL;
>> +	if (!udf_read_extent_cache(inode, bcount, &lbcount, pos)) {
>> +		pos->offset = 0;
>> +		pos->block = iinfo->i_location;
>> +		pos->bh = NULL;
>> +	}
>>  	*elen = 0;
>> -
>>  	do {
>>  		etype = udf_next_aext(inode, pos, eloc, elen, 1);
>>  		if (etype == -1) {
>> @@ -2170,7 +2177,8 @@ int8_t inode_bmap(struct inode *inode, sector_t
>> block,
>>  		}
>>  		lbcount += *elen;
>>  	} while (lbcount <= bcount);
>> -
>> +	/* update extent cache */
>> +	udf_update_extent_cache(inode, lbcount - *elen, pos, 1);
>>  	*offset = (bcount + *elen - lbcount) >> blocksize_bits;
>>
>>  	return etype;
>> @@ -2200,3 +2208,57 @@ long udf_block_map(struct inode *inode, sector_t
>> block)
>>  	else
>>  		return ret;
>>  }
>> +int udf_read_extent_cache(struct inode *inode, loff_t bcount,
>> +			  loff_t *lbcount, struct extent_position *pos)
>> +{
>> +	struct udf_inode_info *iinfo = UDF_I(inode);
>   Use empty line after declarations please...
>
>> +	mutex_lock(&iinfo->i_extent_cache_lock);
>> +	if ((iinfo->cached_extent.lstart <= bcount) &&
>> +	    (iinfo->cached_extent.valid)) {
>> +		/* Cache hit */
>> +		*lbcount = iinfo->cached_extent.lstart;
>> +		memcpy(pos, &iinfo->cached_extent.epos,
>> +		       sizeof(struct extent_position));
>> +		mutex_unlock(&iinfo->i_extent_cache_lock);
>> +		return 1;
>> +	} else
>> +		udf_clear_extent_cache(iinfo);
>> +	mutex_unlock(&iinfo->i_extent_cache_lock);
>> +	return 0;
>> +}
>> +void udf_update_extent_cache(struct inode *inode, loff_t estart,
>> +			     struct extent_position *pos, int next_epos)
>> +{
>> +	struct udf_inode_info *iinfo = UDF_I(inode);
>> +	mutex_lock(&iinfo->i_extent_cache_lock);
>> +	if (pos->bh != NULL)
>> +		/* Increase ref count */
>> +		get_bh(pos->bh);
>> +	memcpy(&iinfo->cached_extent.epos, pos,
>> +	       sizeof(struct extent_position));
>> +	iinfo->cached_extent.lstart = estart;
>> +	iinfo->cached_extent.valid = 1;
>> +	if (next_epos)
>> +		switch (iinfo->i_alloc_type) {
>> +		case ICBTAG_FLAG_AD_SHORT:
>> +			iinfo->cached_extent.epos.offset -=
>> +			sizeof(struct short_ad);
>> +			break;
>> +		case ICBTAG_FLAG_AD_LONG:
>> +			iinfo->cached_extent.epos.offset -=
>> +			sizeof(struct long_ad);
>> +		}
>> +	mutex_unlock(&iinfo->i_extent_cache_lock);
>> +}
>> +
>> +/* This function should be called after i_data_sem is
>> + * held for writing OR i_extent_cache_lock is taken.
>> + */
>> +void udf_clear_extent_cache(struct udf_inode_info *iinfo)
>> +{
>> +	if (iinfo->cached_extent.valid) {
>> +		brelse(iinfo->cached_extent.epos.bh);
>> +		memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
>> +	}
>> +}
>> +
>> diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
>> index bb8309d..95e5e17 100644
>> --- a/fs/udf/udf_i.h
>> +++ b/fs/udf/udf_i.h
>> @@ -1,6 +1,20 @@
>>  #ifndef _UDF_I_H
>>  #define _UDF_I_H
>>
>> +struct extent_position {
>> +	struct buffer_head *bh;
>> +	uint32_t offset;
>> +	struct kernel_lb_addr block;
>> +};
>> +
>> +struct udf_ext_cache {
>> +	/* Extent position */
>> +	struct extent_position epos;
>> +	/* Start logical offset in bytes */
>> +	loff_t lstart;
>> +	bool valid;
>   I'd just remove the 'valid' entry and use lstart == -1 as an indication
> for invalid cache.
>
>> +};
>> +
>>  /*
>>   * The i_data_sem and i_mutex serve for protection of allocation
>> information
>>   * of a regular files and symlinks. This includes all extents belonging
>> to
>> @@ -35,6 +49,9 @@ struct udf_inode_info {
>>  		__u8		*i_data;
>>  	} i_ext;
>>  	struct rw_semaphore	i_data_sem;
>> +	struct udf_ext_cache cached_extent;
>> +	/* Mutex for protecting extent cache */
>> +	struct mutex i_extent_cache_lock;
>   This should be spinlock not mutex. We don't need to sleep while holding
> the lock and spinlocks are both faster and smaller...
>
>>  	struct inode vfs_inode;
>>  };
>>
>> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
>> index de038da..db4a22e 100644
>> --- a/fs/udf/udfdecl.h
>> +++ b/fs/udf/udfdecl.h
>> @@ -113,11 +113,6 @@ struct ustr {
>>  	uint8_t u_len;
>>  };
>>
>> -struct extent_position {
>> -	struct buffer_head *bh;
>> -	uint32_t offset;
>> -	struct kernel_lb_addr block;
>> -};
>>
>>  /* super.c */
>>
>> @@ -164,6 +159,11 @@ extern int8_t udf_next_aext(struct inode *, struct
>> extent_position *,
>>  			    struct kernel_lb_addr *, uint32_t *, int);
>>  extern int8_t udf_current_aext(struct inode *, struct extent_position *,
>>  			       struct kernel_lb_addr *, uint32_t *, int);
>> +int udf_read_extent_cache(struct inode *inode, loff_t bcount, loff_t
>> *lbcount,
>> +			  struct extent_position *pos);
>> +void udf_update_extent_cache(struct inode *inode, loff_t estart,
>> +			     struct extent_position *pos, int next_epos);
>> +void udf_clear_extent_cache(struct udf_inode_info *iinfo);
>>
>>  /* misc.c */
>>  extern struct buffer_head *udf_tgetblk(struct super_block *, int);
>> --
>> 1.7.9.5
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
