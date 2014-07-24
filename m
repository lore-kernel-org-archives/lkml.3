Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbaGXLLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:11:00 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:65093 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000AbaGXLK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:10:58 -0400
Date: Thu, 24 Jul 2014 04:09:19 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-kernel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 5/7] shmem: support RENAME_EXCHANGE
In-Reply-To: <1406121336-1379-6-git-send-email-miklos@szeredi.hu>
Message-ID: <alpine.LSU.2.11.1407240408500.1136@eggly.anvils>
References: <1406121336-1379-1-git-send-email-miklos@szeredi.hu> <1406121336-1379-6-git-send-email-miklos@szeredi.hu>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This is really simple in tmpfs since the VFS already takes care of
> shuffling the dentries.  Just adjust nlink on parent directories and touch
> c & mtimes.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Hugh Dickins <hughd@google.com>

Acked-by: Hugh Dickins <hughd@google.com>

> ---
>  mm/shmem.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 791b05514f9a..75d5ac806f1e 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2016,6 +2016,28 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry)
>  	return shmem_unlink(dir, dentry);
>  }
>  
> +static int shmem_exchange(struct inode *old_dir, struct dentry *old_dentry, struct inode *new_dir, struct dentry *new_dentry)
> +{
> +	bool old_is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
> +	bool new_is_dir = S_ISDIR(new_dentry->d_inode->i_mode);
> +
> +	if (old_dir != new_dir && old_is_dir != new_is_dir) {
> +		if (old_is_dir) {
> +			drop_nlink(old_dir);
> +			inc_nlink(new_dir);
> +		} else {
> +			drop_nlink(new_dir);
> +			inc_nlink(old_dir);
> +		}
> +	}
> +	old_dir->i_ctime = old_dir->i_mtime =
> +	new_dir->i_ctime = new_dir->i_mtime =
> +	old_dentry->d_inode->i_ctime =
> +	new_dentry->d_inode->i_ctime = CURRENT_TIME;
> +
> +	return 0;
> +}
> +
>  /*
>   * The VFS layer already does all the dentry stuff for rename,
>   * we just have to decrement the usage count for the target if
> @@ -2027,9 +2049,12 @@ static int shmem_rename2(struct inode *old_dir, struct dentry *old_dentry, struc
>  	struct inode *inode = old_dentry->d_inode;
>  	int they_are_dirs = S_ISDIR(inode->i_mode);
>  
> -	if (flags & ~(RENAME_NOREPLACE))
> +	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
>  		return -EINVAL;
>  
> +	if (flags & RENAME_EXCHANGE)
> +		return shmem_exchange(old_dir, old_dentry, new_dir, new_dentry);
> +
>  	if (!simple_empty(new_dentry))
>  		return -ENOTEMPTY;
>  
> -- 
> 1.8.1.4
