Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbaDIJzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 05:55:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247AbaDIJzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:55:52 -0400
Date: Wed, 9 Apr 2014 11:55:49 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, willy@linux.intel.com
Subject: Re: [PATCH v7 13/22] ext2: Remove ext2_use_xip
Message-ID: <20140409095549.GF32103@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <0c65dcd599646e3054d0c524a0c5b25b07885763.1395591795.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c65dcd599646e3054d0c524a0c5b25b07885763.1395591795.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 23-03-14 15:08:39, Matthew Wilcox wrote:
> Replace ext2_use_xip() with test_opt(XIP) which expands to the same code
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> ---
>  fs/ext2/ext2.h  | 4 ++++
>  fs/ext2/inode.c | 2 +-
>  fs/ext2/namei.c | 4 ++--
>  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
> index d9a17d0..5ecf570 100644
> --- a/fs/ext2/ext2.h
> +++ b/fs/ext2/ext2.h
> @@ -380,7 +380,11 @@ struct ext2_inode {
>  #define EXT2_MOUNT_NO_UID32		0x000200  /* Disable 32-bit UIDs */
>  #define EXT2_MOUNT_XATTR_USER		0x004000  /* Extended user attributes */
>  #define EXT2_MOUNT_POSIX_ACL		0x008000  /* POSIX Access Control Lists */
> +#ifdef CONFIG_FS_XIP
>  #define EXT2_MOUNT_XIP			0x010000  /* Execute in place */
> +#else
> +#define EXT2_MOUNT_XIP			0
> +#endif
>  #define EXT2_MOUNT_USRQUOTA		0x020000  /* user quota */
>  #define EXT2_MOUNT_GRPQUOTA		0x040000  /* group quota */
>  #define EXT2_MOUNT_RESERVATION		0x080000  /* Preallocation */
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index a9346a9..2e587e2 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1393,7 +1393,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
>  
>  	if (S_ISREG(inode->i_mode)) {
>  		inode->i_op = &ext2_file_inode_operations;
> -		if (ext2_use_xip(inode->i_sb)) {
> +		if (test_opt(inode->i_sb, XIP)) {
>  			inode->i_mapping->a_ops = &ext2_aops_xip;
>  			inode->i_fop = &ext2_xip_file_operations;
>  		} else if (test_opt(inode->i_sb, NOBH)) {
> diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
> index c268d0a..846c356 100644
> --- a/fs/ext2/namei.c
> +++ b/fs/ext2/namei.c
> @@ -105,7 +105,7 @@ static int ext2_create (struct inode * dir, struct dentry * dentry, umode_t mode
>  		return PTR_ERR(inode);
>  
>  	inode->i_op = &ext2_file_inode_operations;
> -	if (ext2_use_xip(inode->i_sb)) {
> +	if (test_opt(inode->i_sb, XIP)) {
>  		inode->i_mapping->a_ops = &ext2_aops_xip;
>  		inode->i_fop = &ext2_xip_file_operations;
>  	} else if (test_opt(inode->i_sb, NOBH)) {
> @@ -126,7 +126,7 @@ static int ext2_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
>  		return PTR_ERR(inode);
>  
>  	inode->i_op = &ext2_file_inode_operations;
> -	if (ext2_use_xip(inode->i_sb)) {
> +	if (test_opt(inode->i_sb, XIP)) {
>  		inode->i_mapping->a_ops = &ext2_aops_xip;
>  		inode->i_fop = &ext2_xip_file_operations;
>  	} else if (test_opt(inode->i_sb, NOBH)) {
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
