Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab3AVApM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 19:45:12 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:36302 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3AVApK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 19:45:10 -0500
MIME-Version: 1.0
In-Reply-To: <20130121110442.GF5588@quack.suse.cz>
References: <1358561834-8108-1-git-send-email-linkinjeon@gmail.com>
	<20130121110442.GF5588@quack.suse.cz>
Date: Tue, 22 Jan 2013 09:45:09 +0900
Message-ID: <CAKYAXd-_chC9zFtC7A=puo9AgQSAD5JbkF=y=ZYP5vS7bO7-dg@mail.gmail.com>
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

2013/1/21, Jan Kara <jack@suse.cz>:
> On Sat 19-01-13 11:17:14, Namjae Jeon wrote:
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
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
>> Signed-off-by: Bonggil Bak <bgbak@samsung.com>
>   Thanks for the patch Namjae. I did a few more changes to the patch.
> Please check them whether you think they are OK.
>
> diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
> index 0cb208e..7e5aae4 100644
> --- a/fs/udf/ialloc.c
> +++ b/fs/udf/ialloc.c
> @@ -117,10 +117,6 @@ struct inode *udf_new_inode(struct inode *dir, umode_t
> mode, int *err)
>  	iinfo->i_lenAlloc = 0;
>  	iinfo->i_use = 0;
>  	iinfo->i_checkpoint = 1;
> -	memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
> -	spin_lock_init(&(iinfo->i_extent_cache_lock));
> -	/* Mark extent cache as invalid for now */
> -	iinfo->cached_extent.lstart = -1;
>  	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
>  		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
>  	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 8494b8c..fb0c4c4 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -1305,9 +1305,6 @@ static void udf_fill_inode(struct inode *inode, struct
> buffer_head *bh)
>  	iinfo->i_lenAlloc = 0;
>  	iinfo->i_next_alloc_block = 0;
>  	iinfo->i_next_alloc_goal = 0;
> -	memset(&iinfo->cached_extent, 0, sizeof(struct udf_ext_cache));
> -	spin_lock_init(&(iinfo->i_extent_cache_lock));
> -	iinfo->cached_extent.lstart = -1;
>  	if (fe->descTag.tagIdent == cpu_to_le16(TAG_IDENT_EFE)) {
>  		iinfo->i_efe = 1;
>  		iinfo->i_use = 0;
>
Hi Jan.
>   Initialization now happens in udf_alloc_inode(). Also it's not necessary
> to initialized cached_extent.epos when lstart == -1 - noone should look at
> that.
This change is okay.
>
> @@ -2222,6 +2219,8 @@ int udf_read_extent_cache(struct inode *inode, loff_t
> bcount,
>  		*lbcount = iinfo->cached_extent.lstart;
>  		memcpy(pos, &iinfo->cached_extent.epos,
>  		       sizeof(struct extent_position));
> +		if (pos->bh)
> +			get_bh(pos->bh);
>  		spin_unlock(&iinfo->i_extent_cache_lock);
>  		return 1;
>  	} else
>   This is the most important - we should give buffer reference to pos->bh.
> Caller will eventually free it right?
This change is not required as we give buffer reference to pos->bh at
the time of cache update.
When we start reading a file, first we try to read the cache which
will lead to cache miss.
So, we would really access the pos->bh in udf_update_extent_cache for
the first time, and this is where the buffer reference is incremented.
Calling get_bh at 2 places will eventually lead to mem leak.
Let me know your opinion.

Thanks for review and change!
>
> @@ -2236,8 +2235,7 @@ void udf_update_extent_cache(struct inode *inode,
> loff_t estart,
>  	struct udf_inode_info *iinfo = UDF_I(inode);
>
>  	spin_lock(&iinfo->i_extent_cache_lock);
> -	if (pos->bh != NULL)
> -		/* Increase ref count */
> +	if (pos->bh)
>  		get_bh(pos->bh);
>  	memcpy(&iinfo->cached_extent.epos, pos,
>  	       sizeof(struct extent_position));
> @@ -2266,4 +2264,3 @@ void udf_clear_extent_cache(struct udf_inode_info
> *iinfo)
>  		iinfo->cached_extent.lstart = -1;
>  	}
>  }
> -
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 186adbf..da8ce9f 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -134,6 +134,8 @@ static struct inode *udf_alloc_inode(struct super_block
> *sb)
>  	ei->i_next_alloc_goal = 0;
>  	ei->i_strat4096 = 0;
>  	init_rwsem(&ei->i_data_sem);
> +	ei->cached_extent.lstart = -1;
> +	spin_lock_init(&ei->i_extent_cache_lock);
>
>  	return &ei->vfs_inode;
>  }
>
> 								Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
