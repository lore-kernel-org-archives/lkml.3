Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaBLC2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:28:38 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:34883 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaBLC2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:28:36 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1402111209450.2225@localhost.localdomain>
References: <1391319874-3203-1-git-send-email-linkinjeon@gmail.com>
	<alpine.LFD.2.00.1402111209450.2225@localhost.localdomain>
Date: Wed, 12 Feb 2014 11:28:35 +0900
Message-ID: <CAKYAXd-bD6ZZgpc9E8V1kD9Dj2wrCkbi1i6drNBdUAwsMiv5gg@mail.gmail.com>
Subject: Re: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE
 for fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-11 20:59 GMT+09:00, Lukáš Czerner <lczerner@redhat.com>:
> On Sun, 2 Feb 2014, Namjae Jeon wrote:
>
>> Date: Sun,  2 Feb 2014 14:44:34 +0900
>> From: Namjae Jeon <linkinjeon@gmail.com>
>> To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com,
>> tytso@mit.edu,
>>     adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com
>> Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
>>     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>>     Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon
>> <namjae.jeon@samsung.com>,
>>     Ashish Sangwan <a.sangwan@samsung.com>
>> Subject: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE
>> for
>>     fallocate
>>
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
Hi Lukas.
>
> Description is missing here, please provide FALLOC_FL_COLLAPSE_RANGE
> description so people know what it's supposed to be doing.
>
> more comments bellow.
Okay, I will udpate.
>
> Thanks!
> -Lukas
>
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
>> ---
>>  fs/ext4/ext4.h              |    3 +
>>  fs/ext4/extents.c           |  297
>> ++++++++++++++++++++++++++++++++++++++++++-
>>  fs/ext4/move_extent.c       |    2 +-
>>  include/trace/events/ext4.h |   25 ++++
>>  4 files changed, 325 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index e618503..5cc015a 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -2745,6 +2745,7 @@ extern int ext4_find_delalloc_cluster(struct inode
>> *inode, ext4_lblk_t lblk);
>>  extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info
>> *fieinfo,
>>  			__u64 start, __u64 len);
>>  extern int ext4_ext_precache(struct inode *inode);
>> +extern int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t
>> len);
>>
>>  /* move_extent.c */
>>  extern void ext4_double_down_write_data_sem(struct inode *first,
>> @@ -2754,6 +2755,8 @@ extern void ext4_double_up_write_data_sem(struct
>> inode *orig_inode,
>>  extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>>  			     __u64 start_orig, __u64 start_donor,
>>  			     __u64 len, __u64 *moved_len);
>> +extern int mext_next_extent(struct inode *inode, struct ext4_ext_path
>> *path,
>> +			    struct ext4_extent **extent);
>>
>>  /* page-io.c */
>>  extern int __init ext4_init_pageio(void);
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 267c9fb..12338c1 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -4566,12 +4566,16 @@ long ext4_fallocate(struct file *file, int mode,
>> loff_t offset, loff_t len)
>>  	unsigned int credits, blkbits = inode->i_blkbits;
>>
>>  	/* Return error if mode is not supported */
>> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
>> +		     FALLOC_FL_COLLAPSE_RANGE))
>>  		return -EOPNOTSUPP;
>>
>>  	if (mode & FALLOC_FL_PUNCH_HOLE)
>>  		return ext4_punch_hole(inode, offset, len);
>>
>> +	if (mode & FALLOC_FL_COLLAPSE_RANGE)
>> +		return ext4_collapse_range(inode, offset, len);
>> +
>>  	ret = ext4_convert_inline_data(inode);
>>  	if (ret)
>>  		return ret;
>> @@ -4870,3 +4874,294 @@ int ext4_fiemap(struct inode *inode, struct
>> fiemap_extent_info *fieinfo,
>>  	ext4_es_lru_add(inode);
>>  	return error;
>>  }
>> +
>> +/*
>> + * ext4_access_path:
>> + * Function to access the path buffer for marking it dirty.
>> + * It also checks if there are sufficient credits left in the journal
>> handle
>> + * to update path.
>> + */
>> +static int
>> +ext4_access_path(handle_t *handle, struct inode *inode,
>> +		struct ext4_ext_path *path)
>> +{
>> +	int credits, err;
>> +
>> +	/*
>> +	 * Check if need to extend journal credits
>> +	 * 3 for leaf, sb, and inode plus 2 (bmap and group
>> +	 * descriptor) for each block group; assume two block
>> +	 * groups
>> +	 */
>> +	if (handle->h_buffer_credits < 7) {
>> +		credits = ext4_writepage_trans_blocks(inode);
>> +		err = ext4_ext_truncate_extend_restart(handle, inode, credits);
>> +		/* EAGAIN is success */
>> +		if (err && err != -EAGAIN)
>> +			return err;
>> +	}
>> +
>> +	err = ext4_ext_get_access(handle, inode, path);
>> +	return err;
>> +}
>> +
>> +/*
>> + * ext4_ext_shift_path_extents:
>> + * Shift the extents of a path structure lying between path[depth].p_ext
>> + * and EXT_LAST_EXTENT(path[depth].p_hdr) downwards, by subtracting
>> shift
>> + * from starting block for each extent.
>> + */
>> +static int
>> +ext4_ext_shift_path_extents(struct ext4_ext_path *path, ext4_lblk_t
>> shift,
>> +			    struct inode *inode, handle_t *handle,
>> +			    ext4_lblk_t *start)
>> +{
>> +	int depth, err = 0;
>> +	struct ext4_extent *ex_start, *ex_last;
>> +	bool update = 0;
>> +	depth = path->p_depth;
>> +
>> +	while (depth >= 0) {
>> +		if (depth == path->p_depth) {
>> +			ex_start = path[depth].p_ext;
>> +			if (!ex_start)
>> +				return -EIO;
>> +
>> +			ex_last = EXT_LAST_EXTENT(path[depth].p_hdr);
>> +			if (!ex_last)
>> +				return -EIO;
>> +
>> +			err = ext4_access_path(handle, inode, path + depth);
>> +			if (err)
>> +				goto out;
>> +
>> +			if (ex_start == EXT_FIRST_EXTENT(path[depth].p_hdr))
>> +				update = 1;
>> +
>> +			*start = ex_last->ee_block +
>> +				ext4_ext_get_actual_len(ex_last);
>> +
>> +			while (ex_start <= ex_last) {
>> +				ex_start->ee_block -= shift;
>> +				if (ex_start >
>> +					EXT_FIRST_EXTENT(path[depth].p_hdr)) {
>> +					if (ext4_ext_try_to_merge_right(inode,
>> +						path, ex_start - 1))
>> +						ex_last--;
>> +				}
>> +				ex_start++;
>> +			}
>> +			err = ext4_ext_dirty(handle, inode, path + depth);
>> +			if (err)
>> +				goto out;
>> +
>> +			if (--depth < 0 || !update)
>> +				break;
>> +		}
>> +
>> +		/* Update index too */
>> +		err = ext4_access_path(handle, inode, path + depth);
>> +		if (err)
>> +			goto out;
>> +
>> +		path[depth].p_idx->ei_block -= shift;
>> +		err = ext4_ext_dirty(handle, inode, path + depth);
>> +		if (err)
>> +			goto out;
>> +
>> +		/* we are done if current index is not a starting index */
>> +		if (path[depth].p_idx != EXT_FIRST_INDEX(path[depth].p_hdr))
>> +			break;
>> +
>> +		depth--;
>> +	}
>> +
>> +out:
>> +	return err;
>> +}
>> +
>> +/*
>> + * ext4_ext_shift_extents:
>> + * All the extents which lies in the range from start to the last
>> allocated
>> + * block for the file are shifted downwards by shift blocks.
>> + * On success, 0 is returned, error otherwise.
>> + */
>> +static int
>> +ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
>> +		       ext4_lblk_t start, ext4_lblk_t shift)
>> +{
>> +	struct ext4_ext_path *path;
>> +	int ret = 0, depth;
>> +	struct ext4_extent *extent;
>> +	ext4_lblk_t stop_block, current_block;
>> +	ext4_lblk_t ex_start, ex_end;
>> +
>> +	/* Let path point to the last extent */
>> +	path = ext4_ext_find_extent(inode, EXT_MAX_BLOCKS - 1, NULL, 0);
>> +	if (IS_ERR(path))
>> +		return PTR_ERR(path);
>> +
>> +	depth = path->p_depth;
>> +	extent = path[depth].p_ext;
>> +	if (!extent) {
>> +		ext4_ext_drop_refs(path);
>> +		kfree(path);
>> +		return ret;
>> +	}
>> +
>> +	stop_block = extent->ee_block + ext4_ext_get_actual_len(extent);
>> +	ext4_ext_drop_refs(path);
>> +	kfree(path);
>> +
>> +	/* Nothing to shift, if hole is at the end of file */
>> +	if (start >= stop_block)
>> +		return ret;
>> +
>> +	/*
>> +	 * Don't start shifting extents until we make sure the hole is big
>> +	 * enough to accomodate the shift.
>> +	 */
>> +	path = ext4_ext_find_extent(inode, start - 1, NULL, 0);
>> +	depth = path->p_depth;
>> +	extent =  path[depth].p_ext;
>> +	ex_start = extent->ee_block;
>> +	ex_end = extent->ee_block + ext4_ext_get_actual_len(extent);
>> +	ext4_ext_drop_refs(path);
>> +	kfree(path);
>> +
>> +	if ((ex_start > start - 1 && shift > ex_start) ||
>> +	    (ex_end > start - shift))
>> +		return -EINVAL;
>> +
>> +	/* Its safe to start updating extents */
>> +	while (start < stop_block) {
>> +		path = ext4_ext_find_extent(inode, start, NULL, 0);
>> +		if (IS_ERR(path))
>> +			return PTR_ERR(path);
>> +		depth = path->p_depth;
>> +		extent = path[depth].p_ext;
>> +		current_block = extent->ee_block;
>> +		if (start > current_block) {
>> +			/* Hole, move to the next extent */
>> +			ret = mext_next_extent(inode, path, &extent);
>> +			if (ret != 0) {
>> +				ext4_ext_drop_refs(path);
>> +				kfree(path);
>> +				if (ret == 1)
>> +					ret = 0;
>> +				break;
>> +			}
>> +		}
>> +		ret = ext4_ext_shift_path_extents(path, shift, inode,
>> +				handle, &start);
>> +		ext4_ext_drop_refs(path);
>> +		kfree(path);
>> +		if (ret)
>> +			break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>> + * ext4_collapse_range:
>> + * This implements the fallocate's collapse range functionality for ext4
>> + * Returns: 0 and non-zero on error.
>> + */
>> +int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
>> +{
>> +	struct super_block *sb = inode->i_sb;
>> +	ext4_lblk_t punch_start, punch_stop;
>> +	handle_t *handle;
>> +	unsigned int credits;
>> +	unsigned int rounding;
>> +	loff_t ioffset, new_size;
>> +	int ret;
>> +	unsigned blksize_mask = (1 << inode->i_blkbits) - 1;
>> +
>> +	BUG_ON(offset + len > i_size_read(inode));
>
> So if anyone provides offset + len which exceeds the i_size then it
> crashes the kernel ? That does not sound right, or am I missing a
> check anywhere ?
>
> Also in the patch 0/3 you're saying that:
>
> " It wokrs beyond "EOF", so the extents which are pre-allocated
> beyond "EOF" are also updated. "
>
> so which is true ? Again it would be better to have the description
> in this patch as well.
You might misunderstand by reading old patch-set. please look at this one.
https://lkml.org/lkml/2014/2/2/12
Since then, it has been decided to limit collapse range within file
size and there is check in VFS patch for this condition.
If user wants to collapse a range that is overlapping with EOF,
truncate(2) is better suited.
>
> Moreover offset and len are loff_t which means that the addition
> operation can easily overflow.
Okay, I will check.
>
> Also you're not holding any locks which would prevent i_size from
> changing.
Okay.
>
>
>> +
>> +	/* Collapse range works only on fs block size aligned offsets. */
>> +	if (offset & blksize_mask || len & blksize_mask)
>> +		return -EINVAL;
>> +
>> +	if (!S_ISREG(inode->i_mode))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (EXT4_SB(sb)->s_cluster_ratio > 1)
>> +		return -EOPNOTSUPP;
>
> Please if you're going to write the support for it, make it
> complete and provide support for bigalloc file system as well.
>
> What is the problem when it comes to bigalloc fs ? It should
> concern allocation only, extent tree manipulation should be the
> same.
Acutally, I didn't consider bigalloc feature on collpase range because
when I implmemented collapse range, punch hole didn't provide bigalloc
support.
As you said, bigalloc is only related with allocation, so I will
remove this check.
There has not been much change in ext4 patch since it was posted first
time due to lack of review.
>
>> +
>> +	/* Currently just for extent based files */
>> +	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>> +		return -EOPNOTSUPP;
>
> That's fine indirect block addressing is pretty much obsolete now.
> Ext3 uses it, but we do not need to add functionality to "ext3"
> code.
>
> However the inode flag can change so you should do this under the
> mutex lock.
Okay.
>
>> +
>> +	if (IS_SWAPFILE(inode))
>> +		return -ETXTBSY;
>
> Again, this should be done under the lock.
Right.

>
>> +
>> +	trace_ext4_collapse_range(inode, offset, len);
>> +
>> +	punch_start = offset >> EXT4_BLOCK_SIZE_BITS(sb);
>> +	punch_stop = (offset + len) >> EXT4_BLOCK_SIZE_BITS(sb);
>
> So far you've been using blksize_mask instead of
> EXT4_BLOCK_SIZE_BITS(sb), please use only one to make it easier for
> reader. I suggest using EXT4_BLOCK_SIZE_BITS(sb) since you actually
> have sb available.
Okay, I will use EXT4_BLOCK_SIZE_BITS(sb).

>
>> +
>> +	rounding = max_t(uint, 1 << EXT4_BLOCK_SIZE_BITS(sb), PAGE_CACHE_SIZE);
>> +	ioffset = offset & ~(rounding - 1);
>
> Why do you need to round it to the whole page ?
We don't actually need to round it to page sized boundary but we are
using truncate_pagecache_range to truncate pages from offset till EOF.
All other places where truncate_pagecache_range is used in kernel, do
this sort of rounding, so we just follow the norm.
Currently it seems un-necessary, I will remove it.
>
>> +
>> +	/* Write out all dirty pages */
>> +	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset, -1);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Take mutex lock */
>> +	mutex_lock(&inode->i_mutex);
>
> What about append only and immutable files ? You probably need to
> check for that we well right ? See ext4_punch_hole()
Okay, I will check it.
>
>> +
>> +	/* Wait for existing dio to complete */
>> +	ext4_inode_block_unlocked_dio(inode);
>> +	inode_dio_wait(inode);
>> +
>> +	truncate_pagecache_range(inode, ioffset, -1);
>> +
>> +	credits = ext4_writepage_trans_blocks(inode);
>> +	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
>> +	if (IS_ERR(handle)) {
>> +		ret = PTR_ERR(handle);
>> +		goto out_dio;
>> +	}
>> +
>> +	down_write(&EXT4_I(inode)->i_data_sem);
>> +
>> +	ext4_discard_preallocations(inode);
>> +
>> +	ret = ext4_es_remove_extent(inode, punch_start,
>> +				    EXT_MAX_BLOCKS - punch_start - 1);
>> +	if (ret)
>> +		goto journal_stop;
>> +
>> +	ret = ext4_ext_remove_space(inode, punch_start, punch_stop - 1);
>> +	if (ret)
>> +		goto journal_stop;
>> +
>> +	ret = ext4_ext_shift_extents(inode, handle, punch_stop,
>> +				     punch_stop - punch_start);
>> +	if (ret)
>> +		goto journal_stop;
>> +
>> +	if ((offset + len) > i_size_read(inode))
>> +		new_size = offset;
>
> You've hit BUG_ON() on this case at the beginning of the function. I
> am confused, please provide proper commit description.
Yes, Right. this condition is obsolete as collapse range semantics
have been changed since this condition was added. I will remove this
one.

Thanks for your review!
>
> Thanks!
> -Lukas
>
>> +	else
>> +		new_size = i_size_read(inode) - len;
>> +
>> +	truncate_setsize(inode, new_size);
>> +	EXT4_I(inode)->i_disksize = new_size;
>> +
>> +	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
>> +	ext4_mark_inode_dirty(handle, inode);
>> +
>> +journal_stop:
>> +	ext4_journal_stop(handle);
>> +	up_write(&EXT4_I(inode)->i_data_sem);
>> +
>> +out_dio:
>> +	ext4_inode_resume_unlocked_dio(inode);
>> +	mutex_unlock(&inode->i_mutex);
>> +	return ret;
>> +}
>> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
>> index 773b503..b474558 100644
>> --- a/fs/ext4/move_extent.c
>> +++ b/fs/ext4/move_extent.c
>> @@ -76,7 +76,7 @@ copy_extent_status(struct ext4_extent *src, struct
>> ext4_extent *dest)
>>   * ext4_ext_path structure refers to the last extent, or a negative
>> error
>>   * value on failure.
>>   */
>> -static int
>> +int
>>  mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
>>  		      struct ext4_extent **extent)
>>  {
>> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
>> index 197d312..90e2f71 100644
>> --- a/include/trace/events/ext4.h
>> +++ b/include/trace/events/ext4.h
>> @@ -2410,6 +2410,31 @@ TRACE_EVENT(ext4_es_shrink_exit,
>>  		  __entry->shrunk_nr, __entry->cache_cnt)
>>  );
>>
>> +TRACE_EVENT(ext4_collapse_range,
>> +	TP_PROTO(struct inode *inode, loff_t offset, loff_t len),
>> +
>> +	TP_ARGS(inode, offset, len),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(dev_t,	dev)
>> +		__field(ino_t,	ino)
>> +		__field(loff_t,	offset)
>> +		__field(loff_t, len)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->dev	= inode->i_sb->s_dev;
>> +		__entry->ino	= inode->i_ino;
>> +		__entry->offset	= offset;
>> +		__entry->len	= len;
>> +	),
>> +
>> +	TP_printk("dev %d,%d ino %lu offset %lld len %lld",
>> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
>> +		  (unsigned long) __entry->ino,
>> +		  __entry->offset, __entry->len)
>> +);
>> +
>>  #endif /* _TRACE_EXT4_H */
>>
>>  /* This part must be outside protection */
>>
>
