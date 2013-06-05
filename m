Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3FEJ10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:27:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3FEJ1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:27:24 -0400
Date: Wed, 5 Jun 2013 11:26:55 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lczerner@localhost.localdomain
To: Willy Tarreau <w@1wt.eu>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [ 122/184] ext4: Fix max file size and logical block counting
In-Reply-To: <20130604172135.367032999@1wt.eu>
Message-ID: <alpine.LFD.2.03.1306051125400.2912@redhat.com>
References: <20130604172135.367032999@1wt.eu>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jun 2013, Willy Tarreau wrote:

> Date: Tue, 04 Jun 2013 19:23:32 +0200
> From: Willy Tarreau <w@1wt.eu>
> To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
> Cc: Lukas Czerner <lczerner@redhat.com>, Theodore Tso <tytso@mit.edu>,
>     Willy Tarreau <w@1wt.eu>
> Subject: [ 122/184] ext4: Fix max file size and logical block counting
> 
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.

Now it looks like we could get rid of this thing in e2fsprogs as
well. As well as remove the remaining bits from kernel.
What do you think Ted ?

-Lukas

> 
> ------------------
>  of extent format file
> 
> From: Lukas Czerner <lczerner@redhat.com>
> 
> commit f17722f917b2f21497deb6edc62fb1683daa08e6 upstream
> 
> Kazuya Mio reported that he was able to hit BUG_ON(next == lblock)
> in ext4_ext_put_gap_in_cache() while creating a sparse file in extent
> format and fill the tail of file up to its end. We will hit the BUG_ON
> when we write the last block (2^32-1) into the sparse file.
> 
> The root cause of the problem lies in the fact that we specifically set
> s_maxbytes so that block at s_maxbytes fit into on-disk extent format,
> which is 32 bit long. However, we are not storing start and end block
> number, but rather start block number and length in blocks. It means
> that in order to cover extent from 0 to EXT_MAX_BLOCK we need
> EXT_MAX_BLOCK+1 to fit into len (because we counting block 0 as well) -
> and it does not.
> 
> The only way to fix it without changing the meaning of the struct
> ext4_extent members is, as Kazuya Mio suggested, to lower s_maxbytes
> by one fs block so we can cover the whole extent we can get by the
> on-disk extent format.
> 
> Also in many places EXT_MAX_BLOCK is used as length instead of maximum
> logical block number as the name suggests, it is all a bit messy. So
> this commit renames it to EXT_MAX_BLOCKS and change its usage in some
> places to actually be maximum number of blocks in the extent.
> 
> The bug which this commit fixes can be reproduced as follows:
> 
>  dd if=/dev/zero of=/mnt/mp1/file bs=<blocksize> count=1 seek=$((2**32-2))
>  sync
>  dd if=/dev/zero of=/mnt/mp1/file bs=<blocksize> count=1 seek=$((2**32-1))
> 
> Reported-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> [dannf: Applied the backport from RHEL6 to Debian's 2.6.32]
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  fs/ext4/ext4_extents.h |  7 +++++--
>  fs/ext4/extents.c      | 39 +++++++++++++++++++--------------------
>  fs/ext4/move_extent.c  | 10 +++++-----
>  fs/ext4/super.c        | 15 ++++++++++++---
>  4 files changed, 41 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
> index bdb6ce7..24fa647 100644
> --- a/fs/ext4/ext4_extents.h
> +++ b/fs/ext4/ext4_extents.h
> @@ -137,8 +137,11 @@ typedef int (*ext_prepare_callback)(struct inode *, struct ext4_ext_path *,
>  #define EXT_BREAK      1
>  #define EXT_REPEAT     2
>  
> -/* Maximum logical block in a file; ext4_extent's ee_block is __le32 */
> -#define EXT_MAX_BLOCK	0xffffffff
> +/*
> + * Maximum number of logical blocks in a file; ext4_extent's ee_block is
> + * __le32.
> + */
> +#define EXT_MAX_BLOCKS	0xffffffff
>  
>  /*
>   * EXT_INIT_MAX_LEN is the maximum number of blocks we can have in an
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index b4402c8..f4b471d 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1331,7 +1331,7 @@ got_index:
>  
>  /*
>   * ext4_ext_next_allocated_block:
> - * returns allocated block in subsequent extent or EXT_MAX_BLOCK.
> + * returns allocated block in subsequent extent or EXT_MAX_BLOCKS.
>   * NOTE: it considers block number from index entry as
>   * allocated block. Thus, index entries have to be consistent
>   * with leaves.
> @@ -1345,7 +1345,7 @@ ext4_ext_next_allocated_block(struct ext4_ext_path *path)
>  	depth = path->p_depth;
>  
>  	if (depth == 0 && path->p_ext == NULL)
> -		return EXT_MAX_BLOCK;
> +		return EXT_MAX_BLOCKS;
>  
>  	while (depth >= 0) {
>  		if (depth == path->p_depth) {
> @@ -1362,12 +1362,12 @@ ext4_ext_next_allocated_block(struct ext4_ext_path *path)
>  		depth--;
>  	}
>  
> -	return EXT_MAX_BLOCK;
> +	return EXT_MAX_BLOCKS;
>  }
>  
>  /*
>   * ext4_ext_next_leaf_block:
> - * returns first allocated block from next leaf or EXT_MAX_BLOCK
> + * returns first allocated block from next leaf or EXT_MAX_BLOCKS
>   */
>  static ext4_lblk_t ext4_ext_next_leaf_block(struct inode *inode,
>  					struct ext4_ext_path *path)
> @@ -1379,7 +1379,7 @@ static ext4_lblk_t ext4_ext_next_leaf_block(struct inode *inode,
>  
>  	/* zero-tree has no leaf blocks at all */
>  	if (depth == 0)
> -		return EXT_MAX_BLOCK;
> +		return EXT_MAX_BLOCKS;
>  
>  	/* go to index block */
>  	depth--;
> @@ -1392,7 +1392,7 @@ static ext4_lblk_t ext4_ext_next_leaf_block(struct inode *inode,
>  		depth--;
>  	}
>  
> -	return EXT_MAX_BLOCK;
> +	return EXT_MAX_BLOCKS;
>  }
>  
>  /*
> @@ -1572,13 +1572,13 @@ unsigned int ext4_ext_check_overlap(struct inode *inode,
>  	 */
>  	if (b2 < b1) {
>  		b2 = ext4_ext_next_allocated_block(path);
> -		if (b2 == EXT_MAX_BLOCK)
> +		if (b2 == EXT_MAX_BLOCKS)
>  			goto out;
>  	}
>  
>  	/* check for wrap through zero on extent logical start block*/
>  	if (b1 + len1 < b1) {
> -		len1 = EXT_MAX_BLOCK - b1;
> +		len1 = EXT_MAX_BLOCKS - b1;
>  		newext->ee_len = cpu_to_le16(len1);
>  		ret = 1;
>  	}
> @@ -1654,7 +1654,7 @@ repeat:
>  	fex = EXT_LAST_EXTENT(eh);
>  	next = ext4_ext_next_leaf_block(inode, path);
>  	if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee_block)
> -	    && next != EXT_MAX_BLOCK) {
> +	    && next != EXT_MAX_BLOCKS) {
>  		ext_debug("next leaf block - %d\n", next);
>  		BUG_ON(npath != NULL);
>  		npath = ext4_ext_find_extent(inode, next, NULL);
> @@ -1772,7 +1772,7 @@ int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
>  	BUG_ON(func == NULL);
>  	BUG_ON(inode == NULL);
>  
> -	while (block < last && block != EXT_MAX_BLOCK) {
> +	while (block < last && block != EXT_MAX_BLOCKS) {
>  		num = last - block;
>  		/* find extent for this block */
>  		down_read(&EXT4_I(inode)->i_data_sem);
> @@ -1900,7 +1900,7 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
>  	if (ex == NULL) {
>  		/* there is no extent yet, so gap is [0;-] */
>  		lblock = 0;
> -		len = EXT_MAX_BLOCK;
> +		len = EXT_MAX_BLOCKS;
>  		ext_debug("cache gap(whole file):");
>  	} else if (block < le32_to_cpu(ex->ee_block)) {
>  		lblock = block;
> @@ -2145,8 +2145,8 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
>  		path[depth].p_ext = ex;
>  
>  		a = ex_ee_block > start ? ex_ee_block : start;
> -		b = ex_ee_block + ex_ee_len - 1 < EXT_MAX_BLOCK ?
> -			ex_ee_block + ex_ee_len - 1 : EXT_MAX_BLOCK;
> +		b = ex_ee_block + ex_ee_len - 1 < EXT_MAX_BLOCKS ?
> +			ex_ee_block + ex_ee_len - 1 : EXT_MAX_BLOCKS;
>  
>  		ext_debug("  border %u:%u\n", a, b);
>  
> @@ -3783,15 +3783,14 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
>  		flags |= FIEMAP_EXTENT_UNWRITTEN;
>  
>  	/*
> -	 * If this extent reaches EXT_MAX_BLOCK, it must be last.
> +	 * If this extent reaches EXT_MAX_BLOCKS, it must be last.
>  	 *
> -	 * Or if ext4_ext_next_allocated_block is EXT_MAX_BLOCK,
> +	 * Or if ext4_ext_next_allocated_block is EXT_MAX_BLOCKS,
>  	 * this also indicates no more allocated blocks.
>  	 *
> -	 * XXX this might miss a single-block extent at EXT_MAX_BLOCK
>  	 */
> -	if (ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCK ||
> -	    newex->ec_block + newex->ec_len - 1 == EXT_MAX_BLOCK) {
> +	if (ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCKS ||
> +	    newex->ec_block + newex->ec_len == EXT_MAX_BLOCKS) {
>  		loff_t size = i_size_read(inode);
>  		loff_t bs = EXT4_BLOCK_SIZE(inode->i_sb);
>  
> @@ -3871,8 +3870,8 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  
>  		start_blk = start >> inode->i_sb->s_blocksize_bits;
>  		last_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
> -		if (last_blk >= EXT_MAX_BLOCK)
> -			last_blk = EXT_MAX_BLOCK-1;
> +		if (last_blk >= EXT_MAX_BLOCKS)
> +			last_blk = EXT_MAX_BLOCKS-1;
>  		len_blks = ((ext4_lblk_t) last_blk) - start_blk + 1;
>  
>  		/*
> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> index a73ed78..fe81390 100644
> --- a/fs/ext4/move_extent.c
> +++ b/fs/ext4/move_extent.c
> @@ -1001,12 +1001,12 @@ mext_check_arguments(struct inode *orig_inode,
>  		return -EINVAL;
>  	}
>  
> -	if ((orig_start > EXT_MAX_BLOCK) ||
> -	    (donor_start > EXT_MAX_BLOCK) ||
> -	    (*len > EXT_MAX_BLOCK) ||
> -	    (orig_start + *len > EXT_MAX_BLOCK))  {
> +	if ((orig_start >= EXT_MAX_BLOCKS) ||
> +	    (donor_start >= EXT_MAX_BLOCKS) ||
> +	    (*len > EXT_MAX_BLOCKS) ||
> +	    (orig_start + *len >= EXT_MAX_BLOCKS))  {
>  		ext4_debug("ext4 move extent: Can't handle over [%u] blocks "
> -			"[ino:orig %lu, donor %lu]\n", EXT_MAX_BLOCK,
> +			"[ino:orig %lu, donor %lu]\n", EXT_MAX_BLOCKS,
>  			orig_inode->i_ino, donor_inode->i_ino);
>  		return -EINVAL;
>  	}
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index f1e7077..3ce77c5 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1975,6 +1975,12 @@ static void ext4_orphan_cleanup(struct super_block *sb,
>   * in the vfs.  ext4 inode has 48 bits of i_block in fsblock units,
>   * so that won't be a limiting factor.
>   *
> + * However there is other limiting factor. We do store extents in the form
> + * of starting block and length, hence the resulting length of the extent
> + * covering maximum file size must fit into on-disk format containers as
> + * well. Given that length is always by 1 unit bigger than max unit (because
> + * we count 0 as well) we have to lower the s_maxbytes by one fs block.
> + *
>   * Note, this does *not* consider any metadata overhead for vfs i_blocks.
>   */
>  static loff_t ext4_max_size(int blkbits, int has_huge_files)
> @@ -1996,10 +2002,13 @@ static loff_t ext4_max_size(int blkbits, int has_huge_files)
>  		upper_limit <<= blkbits;
>  	}
>  
> -	/* 32-bit extent-start container, ee_block */
> -	res = 1LL << 32;
> +	/*
> +	 * 32-bit extent-start container, ee_block. We lower the maxbytes
> +	 * by one fs block, so ee_len can cover the extent of maximum file
> +	 * size
> +	 */
> +	res = (1LL << 32) - 1;
>  	res <<= blkbits;
> -	res -= 1;
>  
>  	/* Sanity check against vm- & vfs- imposed limits */
>  	if (res > upper_limit)
> 
