Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3IYCxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 22:53:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50333 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab3IYCxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 22:53:10 -0400
X-IronPort-AV: E=Sophos;i="4.90,975,1371052800"; 
   d="scan'208";a="8613314"
Message-ID: <52424EE5.3070807@cn.fujitsu.com>
Date: Wed, 25 Sep 2013 10:48:05 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Russ Knize <rknize@gmail.com>
CC: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russ Knize <Russ.Knize@motorola.com>
Subject: Re: [RFC 1/1] f2fs: don't GC or take an fs_lock from f2fs_initxattrs()
References: <n> <1380055763-13425-1-git-send-email-rknize@gmail.com>
In-Reply-To: <1380055763-13425-1-git-send-email-rknize@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/25 10:51:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/25 10:51:25,
	Serialize complete at 2013/09/25 10:51:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 04:49 AM, Russ Knize wrote:

> From: Russ Knize <Russ.Knize@motorola.com>
> 
> f2fs_initxattrs() is called internally from within F2FS and should
> not call functions that are used by VFS handlers.  This avoids
> certain deadlocks:
> 
> - vfs_create()
>  - f2fs_create() <-- takes an fs_lock
>   - f2fs_add_link()
>    - __f2fs_add_link()
>     - init_inode_metadata()
>      - f2fs_init_security()
>       - security_inode_init_security()
>        - f2fs_initxattrs()
>         - f2fs_setxattr() <-- also takes an fs_lock
> 
> If the caller happens to grab the same fs_lock from the pool in both
> places, they will deadlock.  There are also deadlocks involving
> multiple threads and mutexes:
> 
> - f2fs_write_begin()
>  - f2fs_balance_fs() <-- takes gc_mutex
>   - f2fs_gc()
>    - write_checkpoint()
>     - block_operations()
>      - mutex_lock_all() <-- blocks trying to grab all fs_locks
> 
> - f2fs_mkdir() <-- takes an fs_lock
>  - __f2fs_add_link()
>   - f2fs_init_security()
>    - security_inode_init_security()
>     - f2fs_initxattrs()
>      - f2fs_setxattr()
>       - f2fs_balance_fs() <-- blocks trying to take gc_mutex
> 
> Signed-off-by: Russ Knize <Russ.Knize@motorola.com>

This solution is more thorough.

Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

> ---
>  fs/f2fs/xattr.c |   35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
> index 1ac8a5f..3d900ea 100644
> --- a/fs/f2fs/xattr.c
> +++ b/fs/f2fs/xattr.c
> @@ -154,6 +154,9 @@ static int f2fs_xattr_advise_set(struct dentry *dentry, const char *name,
>  }
>  
>  #ifdef CONFIG_F2FS_FS_SECURITY
> +static int __f2fs_setxattr(struct inode *inode, int name_index,
> +			const char *name, const void *value, size_t value_len,
> +			struct page *ipage);
>  static int f2fs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
>  		void *page)
>  {
> @@ -161,7 +164,7 @@ static int f2fs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
>  	int err = 0;
>  
>  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> -		err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_SECURITY,
> +		err = __f2fs_setxattr(inode, F2FS_XATTR_INDEX_SECURITY,
>  				xattr->name, xattr->value,
>  				xattr->value_len, (struct page *)page);
>  		if (err < 0)
> @@ -469,16 +472,15 @@ cleanup:
>  	return error;
>  }
>  
> -int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
> -			const void *value, size_t value_len, struct page *ipage)
> +static int __f2fs_setxattr(struct inode *inode, int name_index,
> +			const char *name, const void *value, size_t value_len,
> +			struct page *ipage)
>  {
> -	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>  	struct f2fs_inode_info *fi = F2FS_I(inode);
>  	struct f2fs_xattr_entry *here, *last;
>  	void *base_addr;
>  	int found, newsize;
>  	size_t name_len;
> -	int ilock;
>  	__u32 new_hsize;
>  	int error = -ENOMEM;
>  
> @@ -493,10 +495,6 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
>  	if (name_len > F2FS_NAME_LEN || value_len > MAX_VALUE_LEN(inode))
>  		return -ERANGE;
>  
> -	f2fs_balance_fs(sbi);
> -
> -	ilock = mutex_lock_op(sbi);
> -
>  	base_addr = read_all_xattrs(inode, ipage);
>  	if (!base_addr)
>  		goto exit;
> @@ -578,7 +576,24 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
>  	else
>  		update_inode_page(inode);
>  exit:
> -	mutex_unlock_op(sbi, ilock);
>  	kzfree(base_addr);
>  	return error;
>  }
> +
> +int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
> +			const void *value, size_t value_len, struct page *ipage)
> +{
> +	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> +	int ilock;
> +	int err;
> +
> +	f2fs_balance_fs(sbi);
> +
> +	ilock = mutex_lock_op(sbi);
> +
> +	err = __f2fs_setxattr(inode, name_index, name, value, value_len, ipage);
> +
> +	mutex_unlock_op(sbi, ilock);
> +
> +	return err;
> +}


