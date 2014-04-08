Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbaDHPdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:33:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891AbaDHPc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:32:57 -0400
Date: Tue, 8 Apr 2014 17:32:55 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v7 05/22] Introduce IS_DAX(inode)
Message-ID: <20140408153255.GC2713@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <6a8918c9a0fb37882179e3699b3e04d96540b24f.1395591795.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a8918c9a0fb37882179e3699b3e04d96540b24f.1395591795.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 23-03-14 15:08:31, Matthew Wilcox wrote:
> Use an inode flag to tag inodes which should avoid using the page cache.
> Convert ext2 to use it instead of mapping_is_xip().
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> ---
>  fs/ext2/inode.c    | 9 ++++++---
>  fs/ext2/xip.h      | 2 --
>  include/linux/fs.h | 6 ++++++
>  3 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 94ed3684..e7d3192 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -731,7 +731,7 @@ static int ext2_get_blocks(struct inode *inode,
>  		goto cleanup;
>  	}
>  
> -	if (ext2_use_xip(inode->i_sb)) {
> +	if (IS_DAX(inode)) {
>  		/*
>  		 * we need to clear the block
>  		 */
> @@ -1201,7 +1201,7 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
>  
>  	inode_dio_wait(inode);
>  
> -	if (mapping_is_xip(inode->i_mapping))
> +	if (IS_DAX(inode))
>  		error = xip_truncate_page(inode->i_mapping, newsize);
>  	else if (test_opt(inode->i_sb, NOBH))
>  		error = nobh_truncate_page(inode->i_mapping,
> @@ -1273,7 +1273,8 @@ void ext2_set_inode_flags(struct inode *inode)
>  {
>  	unsigned int flags = EXT2_I(inode)->i_flags;
>  
> -	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
> +	inode->i_flags &= ~(S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME |
> +				S_DIRSYNC | S_DAX);
>  	if (flags & EXT2_SYNC_FL)
>  		inode->i_flags |= S_SYNC;
>  	if (flags & EXT2_APPEND_FL)
> @@ -1284,6 +1285,8 @@ void ext2_set_inode_flags(struct inode *inode)
>  		inode->i_flags |= S_NOATIME;
>  	if (flags & EXT2_DIRSYNC_FL)
>  		inode->i_flags |= S_DIRSYNC;
> +	if (test_opt(inode->i_sb, XIP))
> +		inode->i_flags |= S_DAX;
>  }
>  
>  /* Propagate flags from i_flags to EXT2_I(inode)->i_flags */
> diff --git a/fs/ext2/xip.h b/fs/ext2/xip.h
> index 18b34d2..29be737 100644
> --- a/fs/ext2/xip.h
> +++ b/fs/ext2/xip.h
> @@ -16,9 +16,7 @@ static inline int ext2_use_xip (struct super_block *sb)
>  }
>  int ext2_get_xip_mem(struct address_space *, pgoff_t, int,
>  				void **, unsigned long *);
> -#define mapping_is_xip(map) unlikely(map->a_ops->get_xip_mem)
>  #else
> -#define mapping_is_xip(map)			0
>  #define ext2_xip_verify_sb(sb)			do { } while (0)
>  #define ext2_use_xip(sb)			0
>  #define ext2_clear_xip_target(inode, chain)	0
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 23b2a35..47fd219 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1644,6 +1644,7 @@ struct super_operations {
>  #define S_IMA		1024	/* Inode has an associated IMA struct */
>  #define S_AUTOMOUNT	2048	/* Automount/referral quasi-directory */
>  #define S_NOSEC		4096	/* no suid or xattr security attributes */
> +#define S_DAX		8192	/* Direct Access, avoiding the page cache */
>  
>  /*
>   * Note that nosuid etc flags are inode-specific: setting some file-system
> @@ -1681,6 +1682,11 @@ struct super_operations {
>  #define IS_IMA(inode)		((inode)->i_flags & S_IMA)
>  #define IS_AUTOMOUNT(inode)	((inode)->i_flags & S_AUTOMOUNT)
>  #define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
> +#ifdef CONFIG_FS_XIP
> +#define IS_DAX(inode)		((inode)->i_flags & S_DAX)
> +#else
> +#define IS_DAX(inode)		0
> +#endif
>  
>  /*
>   * Inode state bits.  Protected by inode->i_lock
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
