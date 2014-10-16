Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaJPMVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:21:13 -0400
Received: from mail.efficios.com ([78.47.125.74]:36504 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaJPMVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:21:11 -0400
Date: Thu, 16 Oct 2014 14:20:51 +0200
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 14/21] ext2: Remove ext2_use_xip
Message-ID: <20141016122051.GL19075@thinkos.etherlink>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-15-git-send-email-matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411677218-29146-15-git-send-email-matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-Sep-2014 04:33:31 PM, Matthew Wilcox wrote:
> Replace ext2_use_xip() with test_opt(XIP) which expands to the same code
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

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
> index 59d6c7d..cba3833 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -1394,7 +1394,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
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
> 2.1.0
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
Key fingerprint: 2A0B 4ED9 15F2 D3FA 45F5  B162 1728 0A97 8118 6ACF
