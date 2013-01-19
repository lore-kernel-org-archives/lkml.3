Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3ASC3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 21:29:15 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:41549 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3ASC3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 21:29:13 -0500
Date: Sat, 19 Jan 2013 03:29:13 +0100
From: Cong Ding <dinggnu@gmail.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Subject: Re: [PATCH] udf: add extent cache support in case of file reading
Message-ID: <20130119022912.GF18593@gmail.com>
References: <1358561834-8108-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358561834-8108-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 11:17:14AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This patch implements extent caching in case of file reading.
> While reading a file, currently, UDF reads metadata serially
> which takes a lot of time depending on the number of extents present
> in the file. Caching last accessd extent improves metadata read time.
> Instead of reading file metadata from start, now we read from
> the cached extent.
> 
> This patch considerably improves the time spent by CPU in kernel mode.
> For example, while reading a 10.9 GB file using dd:
> Time before applying patch:
> 11677022208 bytes (10.9GB) copied, 1529.748921 seconds, 7.3MB/s
> real    25m 29.85s
> user    0m 12.41s
> sys     15m 34.75s
> 
> Time after applying patch:
> 11677022208 bytes (10.9GB) copied, 1469.338231 seconds, 7.6MB/s
> real    24m 29.44s
> user    0m 15.73s
> sys     3m 27.61s
did you have any test on lots of small files?

 - cong
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Signed-off-by: Bonggil Bak <bgbak@samsung.com>
> ---
>  fs/udf/ialloc.c  |    4 +++
>  fs/udf/inode.c   |   79 +++++++++++++++++++++++++++++++++++++++++++++++++-----
>  fs/udf/udf_i.h   |   16 +++++++++++
>  fs/udf/udfdecl.h |   10 +++----
>  4 files changed, 98 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
> index 7e5aae4..0cb208e 100644
> --- a/fs/udf/ialloc.c
> +++ b/fs/udf/ialloc.c
> @@ -117,6 +117,10 @@ struct inode *udf_new_inode(struct inode *dir, umode_t mode, int *err)
>  	iinfo->i_lenAlloc = 0;
>  	iinfo->i_use = 0;
>  	iinfo->i_checkpoint = 1;
> +	memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
> +	spin_lock_init(&(iinfo->i_extent_cache_lock));
> +	/* Mark extent cache as invalid for now */
> +	iinfo->cached_extent.lstart = -1;
>  	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
>  		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
>  	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index e78ef48..86e0469 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -91,6 +91,7 @@ void udf_evict_inode(struct inode *inode)
>  	}
>  	kfree(iinfo->i_ext.i_data);
>  	iinfo->i_ext.i_data = NULL;
> +	udf_clear_extent_cache(iinfo);
>  	if (want_delete) {
>  		udf_free_inode(inode);
>  	}
> @@ -106,6 +107,7 @@ static void udf_write_failed(struct address_space *mapping, loff_t to)
>  		truncate_pagecache(inode, to, isize);
>  		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
>  			down_write(&iinfo->i_data_sem);
> +			udf_clear_extent_cache(iinfo);
>  			udf_truncate_extents(inode);
>  			up_write(&iinfo->i_data_sem);
>  		}
> @@ -373,7 +375,7 @@ static int udf_get_block(struct inode *inode, sector_t block,
>  		iinfo->i_next_alloc_goal++;
>  	}
>  
> -
> +	udf_clear_extent_cache(iinfo);
>  	phys = inode_getblk(inode, block, &err, &new);
>  	if (!phys)
>  		goto abort;
> @@ -1172,6 +1174,7 @@ set_size:
>  	} else {
>  		if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
>  			down_write(&iinfo->i_data_sem);
> +			udf_clear_extent_cache(iinfo);
>  			memset(iinfo->i_ext.i_data + iinfo->i_lenEAttr + newsize,
>  			       0x00, bsize - newsize -
>  			       udf_file_entry_alloc_offset(inode));
> @@ -1185,6 +1188,7 @@ set_size:
>  		if (err)
>  			return err;
>  		down_write(&iinfo->i_data_sem);
> +		udf_clear_extent_cache(iinfo);
>  		truncate_setsize(inode, newsize);
>  		udf_truncate_extents(inode);
>  		up_write(&iinfo->i_data_sem);
> @@ -1302,6 +1306,9 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
>  	iinfo->i_lenAlloc = 0;
>  	iinfo->i_next_alloc_block = 0;
>  	iinfo->i_next_alloc_goal = 0;
> +	memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
> +	spin_lock_init(&(iinfo->i_extent_cache_lock));
> +	iinfo->cached_extent.lstart = -1;
>  	if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_EFE)) {
>  		iinfo->i_efe = 1;
>  		iinfo->i_use = 0;
> @@ -2157,11 +2164,12 @@ int8_t inode_bmap(struct inode *inode, sector_t block,
>  	struct udf_inode_info *iinfo;
>  
>  	iinfo = UDF_I(inode);
> -	pos->offset = 0;
> -	pos->block = iinfo->i_location;
> -	pos->bh = NULL;
> +	if (!udf_read_extent_cache(inode, bcount, &lbcount, pos)) {
> +		pos->offset = 0;
> +		pos->block = iinfo->i_location;
> +		pos->bh = NULL;
> +	}
>  	*elen = 0;
> -
>  	do {
>  		etype = udf_next_aext(inode, pos, eloc, elen, 1);
>  		if (etype == -1) {
> @@ -2171,7 +2179,8 @@ int8_t inode_bmap(struct inode *inode, sector_t block,
>  		}
>  		lbcount += *elen;
>  	} while (lbcount <= bcount);
> -
> +	/* update extent cache */
> +	udf_update_extent_cache(inode, lbcount - *elen, pos, 1);
>  	*offset = (bcount + *elen - lbcount) >> blocksize_bits;
>  
>  	return etype;
> @@ -2201,3 +2210,61 @@ long udf_block_map(struct inode *inode, sector_t block)
>  	else
>  		return ret;
>  }
> +
> +int udf_read_extent_cache(struct inode *inode, loff_t bcount,
> +			  loff_t *lbcount, struct extent_position *pos)
> +{
> +	struct udf_inode_info *iinfo = UDF_I(inode);
> +
> +	spin_lock(&iinfo->i_extent_cache_lock);
> +	if ((iinfo->cached_extent.lstart <= bcount) &&
> +	    (iinfo->cached_extent.lstart != -1)) {
> +		/* Cache hit */
> +		*lbcount = iinfo->cached_extent.lstart;
> +		memcpy(pos, &iinfo->cached_extent.epos,
> +		       sizeof(struct extent_position));
> +		spin_unlock(&iinfo->i_extent_cache_lock);
> +		return 1;
> +	} else
> +		udf_clear_extent_cache(iinfo);
> +	spin_unlock(&iinfo->i_extent_cache_lock);
> +	return 0;
> +}
> +
> +void udf_update_extent_cache(struct inode *inode, loff_t estart,
> +			     struct extent_position *pos, int next_epos)
> +{
> +	struct udf_inode_info *iinfo = UDF_I(inode);
> +
> +	spin_lock(&iinfo->i_extent_cache_lock);
> +	if (pos->bh != NULL)
> +		/* Increase ref count */
> +		get_bh(pos->bh);
> +	memcpy(&iinfo->cached_extent.epos, pos,
> +	       sizeof(struct extent_position));
> +	iinfo->cached_extent.lstart = estart;
> +	if (next_epos)
> +		switch (iinfo->i_alloc_type) {
> +		case ICBTAG_FLAG_AD_SHORT:
> +			iinfo->cached_extent.epos.offset -=
> +			sizeof(struct short_ad);
> +			break;
> +		case ICBTAG_FLAG_AD_LONG:
> +			iinfo->cached_extent.epos.offset -=
> +			sizeof(struct long_ad);
> +		}
> +	spin_unlock(&iinfo->i_extent_cache_lock);
> +}
> +
> +/* This function should be called after i_data_sem is
> + * held for writing OR i_extent_cache_lock is taken.
> + */
> +void udf_clear_extent_cache(struct udf_inode_info *iinfo)
> +{
> +	if (iinfo->cached_extent.lstart != -1) {
> +		brelse(iinfo->cached_extent.epos.bh);
> +		memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
> +		iinfo->cached_extent.lstart = -1;
> +	}
> +}
> +
> diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
> index bb8309d..b5cd8ed 100644
> --- a/fs/udf/udf_i.h
> +++ b/fs/udf/udf_i.h
> @@ -1,6 +1,19 @@
>  #ifndef _UDF_I_H
>  #define _UDF_I_H
>  
> +struct extent_position {
> +	struct buffer_head *bh;
> +	uint32_t offset;
> +	struct kernel_lb_addr block;
> +};
> +
> +struct udf_ext_cache {
> +	/* Extent position */
> +	struct extent_position epos;
> +	/* Start logical offset in bytes */
> +	loff_t lstart;
> +};
> +
>  /*
>   * The i_data_sem and i_mutex serve for protection of allocation information
>   * of a regular files and symlinks. This includes all extents belonging to
> @@ -35,6 +48,9 @@ struct udf_inode_info {
>  		__u8		*i_data;
>  	} i_ext;
>  	struct rw_semaphore	i_data_sem;
> +	struct udf_ext_cache cached_extent;
> +	/* Spinlock for protecting extent cache */
> +	spinlock_t i_extent_cache_lock;
>  	struct inode vfs_inode;
>  };
>  
> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> index de038da..db4a22e 100644
> --- a/fs/udf/udfdecl.h
> +++ b/fs/udf/udfdecl.h
> @@ -113,11 +113,6 @@ struct ustr {
>  	uint8_t u_len;
>  };
>  
> -struct extent_position {
> -	struct buffer_head *bh;
> -	uint32_t offset;
> -	struct kernel_lb_addr block;
> -};
>  
>  /* super.c */
>  
> @@ -164,6 +159,11 @@ extern int8_t udf_next_aext(struct inode *, struct extent_position *,
>  			    struct kernel_lb_addr *, uint32_t *, int);
>  extern int8_t udf_current_aext(struct inode *, struct extent_position *,
>  			       struct kernel_lb_addr *, uint32_t *, int);
> +int udf_read_extent_cache(struct inode *inode, loff_t bcount, loff_t *lbcount,
> +			  struct extent_position *pos);
> +void udf_update_extent_cache(struct inode *inode, loff_t estart,
> +			     struct extent_position *pos, int next_epos);
> +void udf_clear_extent_cache(struct udf_inode_info *iinfo);
>  
>  /* misc.c */
>  extern struct buffer_head *udf_tgetblk(struct super_block *, int);
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
