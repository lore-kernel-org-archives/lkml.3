Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaKDL63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:58:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbaKDL6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:58:23 -0500
Date: Tue, 4 Nov 2014 12:15:25 +0100
From: Jan Kara <jack@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, Anton Blanchard <anton@samba.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: quota: Use quota_err and use %pf to reduce code size
Message-ID: <20141104111525.GE2953@quack.suse.cz>
References: <b0c0688733c11770bd03433eeac7cb2843d9f166.1415073710.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0c0688733c11770bd03433eeac7cb2843d9f166.1415073710.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 03-11-14 20:04:41, Joe Perches wrote:
> Use more standard logging style and remove __func__ passed
> to quota_err.
> 
> Remove the quota_error macro, rename __quota_error to quota_err.
> Add %pf and __builtin_return_address(0) instead of __func__
> 
> Add terminating newlines to formats.
> 
> $ size fs/quota/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
>   47145	  24751	  18428	  90324	  160d4	fs/quota/built-in.o.new
>   47747	  24751	  18428	  90926	  1632e	fs/quota/built-in.o.old
  Nack. Renaming quota_error() to quota_err() is pointless churn. Changing
__func__ to __builtin_return_address(0) is mostly pointless. OK, saves you
600 bytes but quota isn't really aimed at embedded systems and it reduces
usefullness of the message because of inlining. Adding '\n' at the end of
messages instead of doing it automatically in quota_error() is also IMO
pointless churn (there are other error reporting functions in kernel which
do this so it's not like we have a consensus on this).

								Honza

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/quota/dquot.c         | 24 ++++++-------
>  fs/quota/quota_tree.c    | 92 +++++++++++++++++++++++-------------------------
>  fs/quota/quota_v1.c      |  2 +-
>  fs/quota/quota_v2.c      |  8 ++---
>  include/linux/quotaops.h |  8 ++---
>  5 files changed, 62 insertions(+), 72 deletions(-)
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index 6b45272..682175f 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -129,8 +129,7 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_data_lock);
>  EXPORT_SYMBOL(dq_data_lock);
>  DEFINE_STATIC_SRCU(dquot_srcu);
>  
> -void __quota_error(struct super_block *sb, const char *func,
> -		   const char *fmt, ...)
> +void quota_err(struct super_block *sb, const char *fmt, ...)
>  {
>  	if (printk_ratelimit()) {
>  		va_list args;
> @@ -141,13 +140,13 @@ void __quota_error(struct super_block *sb, const char *func,
>  		vaf.fmt = fmt;
>  		vaf.va = &args;
>  
> -		printk(KERN_ERR "Quota error (device %s): %s: %pV\n",
> -		       sb->s_id, func, &vaf);
> +		printk(KERN_ERR "Quota error (device %s): %pf: %pV\n",
> +		       sb->s_id, __builtin_return_address(0), &vaf);
>  
>  		va_end(args);
>  	}
>  }
> -EXPORT_SYMBOL(__quota_error);
> +EXPORT_SYMBOL(quota_err);
>  
>  #if defined(CONFIG_QUOTA_DEBUG) || defined(CONFIG_PRINT_QUOTA_WARNING)
>  static char *quotatypes[] = INITQFNAMES;
> @@ -739,9 +738,9 @@ void dqput(struct dquot *dquot)
>  		return;
>  #ifdef CONFIG_QUOTA_DEBUG
>  	if (!atomic_read(&dquot->dq_count)) {
> -		quota_error(dquot->dq_sb, "trying to free free dquot of %s %d",
> -			    quotatypes[dquot->dq_id.type],
> -			    from_kqid(&init_user_ns, dquot->dq_id));
> +		quota_err(dquot->dq_sb, "trying to free free dquot of %s %d\n",
> +			  quotatypes[dquot->dq_id.type],
> +			  from_kqid(&init_user_ns, dquot->dq_id));
>  		BUG();
>  	}
>  #endif
> @@ -764,9 +763,8 @@ we_slept:
>  		/* Commit dquot before releasing */
>  		ret = dquot->dq_sb->dq_op->write_dquot(dquot);
>  		if (ret < 0) {
> -			quota_error(dquot->dq_sb, "Can't write quota structure"
> -				    " (error %d). Quota may get out of sync!",
> -				    ret);
> +			quota_err(dquot->dq_sb, "Can't write quota structure (error %d). Quota may get out of sync!\n",
> +				  ret);
>  			/*
>  			 * We clear dirty bit anyway, so that we avoid
>  			 * infinite loop here
> @@ -951,9 +949,7 @@ static void add_dquot_ref(struct super_block *sb, int type)
>  
>  #ifdef CONFIG_QUOTA_DEBUG
>  	if (reserved) {
> -		quota_error(sb, "Writes happened before quota was turned on "
> -			"thus quota information is probably inconsistent. "
> -			"Please run quotacheck(8)");
> +		quota_err(sb, "Writes happened before quota was turned on thus quota information is probably inconsistent. Please run quotacheck(8)\n");
>  	}
>  #endif
>  }
> diff --git a/fs/quota/quota_tree.c b/fs/quota/quota_tree.c
> index d65877f..ba7d5de 100644
> --- a/fs/quota/quota_tree.c
> +++ b/fs/quota/quota_tree.c
> @@ -66,7 +66,7 @@ static ssize_t write_blk(struct qtree_mem_dqinfo *info, uint blk, char *buf)
>  	ret = sb->s_op->quota_write(sb, info->dqi_type, buf,
>  	       info->dqi_usable_bs, blk << info->dqi_blocksize_bits);
>  	if (ret != info->dqi_usable_bs) {
> -		quota_error(sb, "dquota write failed");
> +		quota_err(sb, "dquota write failed\n");
>  		if (ret >= 0)
>  			ret = -EIO;
>  	}
> @@ -160,8 +160,8 @@ static int remove_free_dqentry(struct qtree_mem_dqinfo *info, char *buf,
>  	dh->dqdh_next_free = dh->dqdh_prev_free = cpu_to_le32(0);
>  	/* No matter whether write succeeds block is out of list */
>  	if (write_blk(info, blk, buf) < 0)
> -		quota_error(info->dqi_sb, "Can't write block (%u) "
> -			    "with free entries", blk);
> +		quota_err(info->dqi_sb, "Can't write block (%u) with free entries\n",
> +			  blk);
>  	return 0;
>  out_buf:
>  	kfree(tmpbuf);
> @@ -251,8 +251,8 @@ static uint find_free_dqentry(struct qtree_mem_dqinfo *info,
>  	if (le16_to_cpu(dh->dqdh_entries) + 1 >= qtree_dqstr_in_blk(info)) {
>  		*err = remove_free_dqentry(info, buf, blk);
>  		if (*err < 0) {
> -			quota_error(dquot->dq_sb, "Can't remove block (%u) "
> -				    "from entry free list", blk);
> +			quota_err(dquot->dq_sb, "Can't remove block (%u) from entry free list\n",
> +				  blk);
>  			goto out_buf;
>  		}
>  	}
> @@ -266,15 +266,15 @@ static uint find_free_dqentry(struct qtree_mem_dqinfo *info,
>  	}
>  #ifdef __QUOTA_QT_PARANOIA
>  	if (i == qtree_dqstr_in_blk(info)) {
> -		quota_error(dquot->dq_sb, "Data block full but it shouldn't");
> +		quota_err(dquot->dq_sb, "Data block full but it shouldn't\n");
>  		*err = -EIO;
>  		goto out_buf;
>  	}
>  #endif
>  	*err = write_blk(info, blk, buf);
>  	if (*err < 0) {
> -		quota_error(dquot->dq_sb, "Can't write quota data block %u",
> -			    blk);
> +		quota_err(dquot->dq_sb, "Can't write quota data block %u\n",
> +			  blk);
>  		goto out_buf;
>  	}
>  	dquot->dq_off = (blk << info->dqi_blocksize_bits) +
> @@ -308,8 +308,8 @@ static int do_insert_tree(struct qtree_mem_dqinfo *info, struct dquot *dquot,
>  	} else {
>  		ret = read_blk(info, *treeblk, buf);
>  		if (ret < 0) {
> -			quota_error(dquot->dq_sb, "Can't read tree quota "
> -				    "block %u", *treeblk);
> +			quota_err(dquot->dq_sb, "Can't read tree quota block %u\n",
> +				  *treeblk);
>  			goto out_buf;
>  		}
>  	}
> @@ -320,10 +320,9 @@ static int do_insert_tree(struct qtree_mem_dqinfo *info, struct dquot *dquot,
>  	if (depth == info->dqi_qtree_depth - 1) {
>  #ifdef __QUOTA_QT_PARANOIA
>  		if (newblk) {
> -			quota_error(dquot->dq_sb, "Inserting already present "
> -				    "quota entry (block %u)",
> -				    le32_to_cpu(ref[get_index(info,
> -						dquot->dq_id, depth)]));
> +			quota_err(dquot->dq_sb, "Inserting already present quota entry (block %u)\n",
> +				  le32_to_cpu(ref[get_index(info, dquot->dq_id,
> +							    depth)]));
>  			ret = -EIO;
>  			goto out_buf;
>  		}
> @@ -370,8 +369,8 @@ int qtree_write_dquot(struct qtree_mem_dqinfo *info, struct dquot *dquot)
>  	if (!dquot->dq_off) {
>  		ret = dq_insert_tree(info, dquot);
>  		if (ret < 0) {
> -			quota_error(sb, "Error %zd occurred while creating "
> -				    "quota", ret);
> +			quota_err(sb, "Error %zd occurred while creating quota\n",
> +				  ret);
>  			kfree(ddquot);
>  			return ret;
>  		}
> @@ -382,7 +381,7 @@ int qtree_write_dquot(struct qtree_mem_dqinfo *info, struct dquot *dquot)
>  	ret = sb->s_op->quota_write(sb, type, ddquot, info->dqi_entry_size,
>  				    dquot->dq_off);
>  	if (ret != info->dqi_entry_size) {
> -		quota_error(sb, "dquota write failed");
> +		quota_err(sb, "dquota write failed\n");
>  		if (ret >= 0)
>  			ret = -ENOSPC;
>  	} else {
> @@ -406,15 +405,15 @@ static int free_dqentry(struct qtree_mem_dqinfo *info, struct dquot *dquot,
>  	if (!buf)
>  		return -ENOMEM;
>  	if (dquot->dq_off >> info->dqi_blocksize_bits != blk) {
> -		quota_error(dquot->dq_sb, "Quota structure has offset to "
> -			"other block (%u) than it should (%u)", blk,
> -			(uint)(dquot->dq_off >> info->dqi_blocksize_bits));
> +		quota_err(dquot->dq_sb, "Quota structure has offset to other block (%u) than it should (%u)\n",
> +			  blk,
> +			  (uint)(dquot->dq_off >> info->dqi_blocksize_bits));
>  		goto out_buf;
>  	}
>  	ret = read_blk(info, blk, buf);
>  	if (ret < 0) {
> -		quota_error(dquot->dq_sb, "Can't read quota data block %u",
> -			    blk);
> +		quota_err(dquot->dq_sb, "Can't read quota data block %u\n",
> +			  blk);
>  		goto out_buf;
>  	}
>  	dh = (struct qt_disk_dqdbheader *)buf;
> @@ -424,8 +423,8 @@ static int free_dqentry(struct qtree_mem_dqinfo *info, struct dquot *dquot,
>  		if (ret >= 0)
>  			ret = put_free_dqblk(info, buf, blk);
>  		if (ret < 0) {
> -			quota_error(dquot->dq_sb, "Can't move quota data block "
> -				    "(%u) to free list", blk);
> +			quota_err(dquot->dq_sb, "Can't move quota data block (%u) to free list\n",
> +				  blk);
>  			goto out_buf;
>  		}
>  	} else {
> @@ -437,15 +436,15 @@ static int free_dqentry(struct qtree_mem_dqinfo *info, struct dquot *dquot,
>  			/* Insert will write block itself */
>  			ret = insert_free_dqentry(info, buf, blk);
>  			if (ret < 0) {
> -				quota_error(dquot->dq_sb, "Can't insert quota "
> -				    "data block (%u) to free entry list", blk);
> +				quota_err(dquot->dq_sb, "Can't insert quota data block (%u) to free entry list\n",
> +					  blk);
>  				goto out_buf;
>  			}
>  		} else {
>  			ret = write_blk(info, blk, buf);
>  			if (ret < 0) {
> -				quota_error(dquot->dq_sb, "Can't write quota "
> -					    "data block %u", blk);
> +				quota_err(dquot->dq_sb, "Can't write quota data block %u\n",
> +					  blk);
>  				goto out_buf;
>  			}
>  		}
> @@ -469,8 +468,8 @@ static int remove_tree(struct qtree_mem_dqinfo *info, struct dquot *dquot,
>  		return -ENOMEM;
>  	ret = read_blk(info, *blk, buf);
>  	if (ret < 0) {
> -		quota_error(dquot->dq_sb, "Can't read quota data block %u",
> -			    *blk);
> +		quota_err(dquot->dq_sb, "Can't read quota data block %u\n",
> +			  *blk);
>  		goto out_buf;
>  	}
>  	newblk = le32_to_cpu(ref[get_index(info, dquot->dq_id, depth)]);
> @@ -494,9 +493,9 @@ static int remove_tree(struct qtree_mem_dqinfo *info, struct dquot *dquot,
>  		} else {
>  			ret = write_blk(info, *blk, buf);
>  			if (ret < 0)
> -				quota_error(dquot->dq_sb,
> -					    "Can't write quota tree block %u",
> -					    *blk);
> +				quota_err(dquot->dq_sb,
> +					  "Can't write quota tree block %u\n",
> +					  *blk);
>  		}
>  	}
>  out_buf:
> @@ -528,8 +527,8 @@ static loff_t find_block_dqentry(struct qtree_mem_dqinfo *info,
>  		return -ENOMEM;
>  	ret = read_blk(info, blk, buf);
>  	if (ret < 0) {
> -		quota_error(dquot->dq_sb, "Can't read quota tree "
> -			    "block %u", blk);
> +		quota_err(dquot->dq_sb, "Can't read quota tree block %u\n",
> +			  blk);
>  		goto out_buf;
>  	}
>  	ddquot = buf + sizeof(struct qt_disk_dqdbheader);
> @@ -539,9 +538,9 @@ static loff_t find_block_dqentry(struct qtree_mem_dqinfo *info,
>  		ddquot += info->dqi_entry_size;
>  	}
>  	if (i == qtree_dqstr_in_blk(info)) {
> -		quota_error(dquot->dq_sb,
> -			    "Quota for id %u referenced but not present",
> -			    from_kqid(&init_user_ns, dquot->dq_id));
> +		quota_err(dquot->dq_sb,
> +			  "Quota for id %u referenced but not present\n",
> +			  from_kqid(&init_user_ns, dquot->dq_id));
>  		ret = -EIO;
>  		goto out_buf;
>  	} else {
> @@ -565,8 +564,8 @@ static loff_t find_tree_dqentry(struct qtree_mem_dqinfo *info,
>  		return -ENOMEM;
>  	ret = read_blk(info, blk, buf);
>  	if (ret < 0) {
> -		quota_error(dquot->dq_sb, "Can't read quota tree block %u",
> -			    blk);
> +		quota_err(dquot->dq_sb, "Can't read quota tree block %u\n",
> +			  blk);
>  		goto out_buf;
>  	}
>  	ret = 0;
> @@ -600,7 +599,7 @@ int qtree_read_dquot(struct qtree_mem_dqinfo *info, struct dquot *dquot)
>  #ifdef __QUOTA_QT_PARANOIA
>  	/* Invalidated quota? */
>  	if (!sb_dqopt(dquot->dq_sb)->files[type]) {
> -		quota_error(sb, "Quota invalidated while reading!");
> +		quota_err(sb, "Quota invalidated while reading!\n");
>  		return -EIO;
>  	}
>  #endif
> @@ -609,10 +608,9 @@ int qtree_read_dquot(struct qtree_mem_dqinfo *info, struct dquot *dquot)
>  		offset = find_dqentry(info, dquot);
>  		if (offset <= 0) {	/* Entry not present? */
>  			if (offset < 0)
> -				quota_error(sb,"Can't read quota structure "
> -					    "for id %u",
> -					    from_kqid(&init_user_ns,
> -						      dquot->dq_id));
> +				quota_err(sb,"Can't read quota structure for id %u\n",
> +					  from_kqid(&init_user_ns,
> +						    dquot->dq_id));
>  			dquot->dq_off = 0;
>  			set_bit(DQ_FAKE_B, &dquot->dq_flags);
>  			memset(&dquot->dq_dqb, 0, sizeof(struct mem_dqblk));
> @@ -629,8 +627,8 @@ int qtree_read_dquot(struct qtree_mem_dqinfo *info, struct dquot *dquot)
>  	if (ret != info->dqi_entry_size) {
>  		if (ret >= 0)
>  			ret = -EIO;
> -		quota_error(sb, "Error while reading quota structure for id %u",
> -			    from_kqid(&init_user_ns, dquot->dq_id));
> +		quota_err(sb, "Error while reading quota structure for id %u\n",
> +			  from_kqid(&init_user_ns, dquot->dq_id));
>  		set_bit(DQ_FAKE_B, &dquot->dq_flags);
>  		memset(&dquot->dq_dqb, 0, sizeof(struct mem_dqblk));
>  		kfree(ddquot);
> diff --git a/fs/quota/quota_v1.c b/fs/quota/quota_v1.c
> index 469c684..94b5708 100644
> --- a/fs/quota/quota_v1.c
> +++ b/fs/quota/quota_v1.c
> @@ -97,7 +97,7 @@ static int v1_commit_dqblk(struct dquot *dquot)
>  			(char *)&dqblk, sizeof(struct v1_disk_dqblk),
>  			v1_dqoff(from_kqid(&init_user_ns, dquot->dq_id)));
>  	if (ret != sizeof(struct v1_disk_dqblk)) {
> -		quota_error(dquot->dq_sb, "dquota write failed");
> +		quota_err(dquot->dq_sb, "dquota write failed\n");
>  		if (ret >= 0)
>  			ret = -EIO;
>  		goto out;
> diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
> index 02751ec..1f43482 100644
> --- a/fs/quota/quota_v2.c
> +++ b/fs/quota/quota_v2.c
> @@ -63,8 +63,8 @@ static int v2_read_header(struct super_block *sb, int type,
>  	size = sb->s_op->quota_read(sb, type, (char *)dqhead,
>  				    sizeof(struct v2_disk_dqheader), 0);
>  	if (size != sizeof(struct v2_disk_dqheader)) {
> -		quota_error(sb, "Failed header read: expected=%zd got=%zd",
> -			    sizeof(struct v2_disk_dqheader), size);
> +		quota_err(sb, "Failed header read: expected=%zd got=%zd\n",
> +			  sizeof(struct v2_disk_dqheader), size);
>  		return 0;
>  	}
>  	return 1;
> @@ -105,7 +105,7 @@ static int v2_read_file_info(struct super_block *sb, int type)
>  	size = sb->s_op->quota_read(sb, type, (char *)&dinfo,
>  	       sizeof(struct v2_disk_dqinfo), V2_DQINFOOFF);
>  	if (size != sizeof(struct v2_disk_dqinfo)) {
> -		quota_error(sb, "Can't read info structure");
> +		quota_err(sb, "Can't read info structure\n");
>  		return -1;
>  	}
>  	info->dqi_priv = kmalloc(sizeof(struct qtree_mem_dqinfo), GFP_NOFS);
> @@ -165,7 +165,7 @@ static int v2_write_file_info(struct super_block *sb, int type)
>  	size = sb->s_op->quota_write(sb, type, (char *)&dinfo,
>  	       sizeof(struct v2_disk_dqinfo), V2_DQINFOOFF);
>  	if (size != sizeof(struct v2_disk_dqinfo)) {
> -		quota_error(sb, "Can't write info structure");
> +		quota_err(sb, "Can't write info structure\n");
>  		return -1;
>  	}
>  	return 0;
> diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
> index 1d3eee5..4b6a17c 100644
> --- a/include/linux/quotaops.h
> +++ b/include/linux/quotaops.h
> @@ -28,12 +28,8 @@ static inline bool is_quota_modification(struct inode *inode, struct iattr *ia)
>  
>  #if defined(CONFIG_QUOTA)
>  
> -#define quota_error(sb, fmt, args...) \
> -	__quota_error((sb), __func__, fmt , ## args)
> -
> -extern __printf(3, 4)
> -void __quota_error(struct super_block *sb, const char *func,
> -		   const char *fmt, ...);
> +__printf(2, 3)
> +void quota_err(struct super_block *sb, const char *fmt, ...);
>  
>  /*
>   * declaration of quota_function calls in kernel.
> -- 
> 2.1.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
