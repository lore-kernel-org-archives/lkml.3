Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaAMHwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 02:52:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbaAMHwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 02:52:30 -0500
Date: Mon, 13 Jan 2014 08:52:27 +0100
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 07/11] vfs: add cross-rename
Message-ID: <20140113075227.GG3837@quack.suse.cz>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
 <1389219015-10980-8-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389219015-10980-8-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08-01-14 23:10:11, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> If flags contain RENAME_EXCHANGE then exchange source and destination files.
> There's no restriction on the type of the files; e.g. a directory can be
> exchanged with a symlink.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/dcache.c             |  46 +++++++++++++++++----
>  fs/namei.c              | 107 +++++++++++++++++++++++++++++++++---------------
>  include/linux/dcache.h  |   1 +
>  include/uapi/linux/fs.h |   1 +
>  security/security.c     |  16 ++++++++
>  5 files changed, 131 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 3fbc95c72e31..97c6dbb47eca 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -4020,6 +4020,8 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	const unsigned char *old_name;
>  	struct inode *source = old_dentry->d_inode;
>  	struct inode *target = new_dentry->d_inode;
> +	bool new_is_dir = false;
> +	unsigned max_links = new_dir->i_sb->s_max_links;
>  
>  	if (source == target)
>  		return 0;
> @@ -4028,10 +4030,16 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	if (error)
>  		return error;
>  
> -	if (!target)
> +	if (!target) {
>  		error = may_create(new_dir, new_dentry);
> -	else
> -		error = may_delete(new_dir, new_dentry, is_dir);
> +	} else {
> +		new_is_dir = d_is_dir(new_dentry);
> +
> +		if (!(flags & RENAME_EXCHANGE))
> +			error = may_delete(new_dir, new_dentry, is_dir);
> +		else
> +			error = may_delete(new_dir, new_dentry, new_is_dir);
> +	}
>  	if (error)
>  		return error;
>  
> @@ -4042,10 +4050,17 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	 * If we are going to change the parent - check write permissions,
>  	 * we'll need to flip '..'.
>  	 */
> -	if (is_dir && new_dir != old_dir) {
> -		error = inode_permission(source, MAY_WRITE);
> -		if (error)
> -			return error;
> +	if (new_dir != old_dir) {
> +		if (is_dir) {
> +			error = inode_permission(source, MAY_WRITE);
> +			if (error)
> +				return error;
> +		}
> +		if ((flags & RENAME_EXCHANGE) && new_is_dir) {
> +			error = inode_permission(target, MAY_WRITE);
> +			if (error)
> +				return error;
> +		}
>  	}
>  
>  	error = security_inode_rename(old_dir, old_dentry, new_dir, new_dentry,
> @@ -4055,25 +4070,24 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  
>  	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
>  	dget(new_dentry);
> -	if (!is_dir)
> -		lock_two_nondirectories(source, target);
> -	else if (target)
> -		mutex_lock(&target->i_mutex);
> +	if (!(flags & RENAME_EXCHANGE)) {
> +		if (!is_dir)
> +			lock_two_nondirectories(source, target);
> +		else if (target)
> +			mutex_lock(&target->i_mutex);
> +	}
>  
>  	error = -EBUSY;
>  	if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
>  		goto out;
>  
> -	if (is_dir) {
> -		unsigned max_links = new_dir->i_sb->s_max_links;
> -
> +	if (max_links && new_dir != old_dir) {
>  		error = -EMLINK;
> -		if (max_links && !target && new_dir != old_dir &&
> -		    new_dir->i_nlink >= max_links)
> +		if (is_dir && !new_is_dir && new_dir->i_nlink >= max_links)
> +			goto out;
> +		if ((flags & RENAME_EXCHANGE) && !is_dir && new_is_dir &&
> +		    old_dir->i_nlink > max_links)
  This should be >=, shouldn't it?

>  			goto out;
> -
> -		if (target)
> -			shrink_dcache_parent(new_dentry);
>  	} else {
>  		error = try_break_deleg(source, delegated_inode);
>  		if (error)
> @@ -4084,27 +4098,40 @@ int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>  				goto out;
>  		}
>  	}
> +	if (is_dir && !(flags & RENAME_EXCHANGE) && target)
> +		shrink_dcache_parent(new_dentry);
>  	error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry,
>  				      flags);
>  	if (error)
>  		goto out;
>  
> -	if (target) {
> +	if (!(flags & RENAME_EXCHANGE) && target) {
>  		if (is_dir)
>  			target->i_flags |= S_DEAD;
>  		dont_mount(new_dentry);
>  	}
> -	if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE))
> -		d_move(old_dentry, new_dentry);
> +	if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE)) {
> +		if (!(flags & RENAME_EXCHANGE))
> +			d_move(old_dentry, new_dentry);
> +		else
> +			d_exchange(old_dentry, new_dentry);
> +	}
>  out:
> -	if (!is_dir)
> -		unlock_two_nondirectories(source, target);
> -	else if (target)
> -		mutex_unlock(&target->i_mutex);
> +	if (!(flags & RENAME_EXCHANGE)) {
> +		if (!is_dir)
> +			unlock_two_nondirectories(source, target);
> +		else if (target)
> +			mutex_unlock(&target->i_mutex);
> +	}
>  	dput(new_dentry);
> -	if (!error)
> +	if (!error) {
>  		fsnotify_move(old_dir, new_dir, old_name, is_dir,
> -			      target, old_dentry);
> +			      !(flags & RENAME_EXCHANGE) ? target : NULL, old_dentry);
> +		if (flags & RENAME_EXCHANGE) {
> +			fsnotify_move(new_dir, old_dir, old_dentry->d_name.name,
> +				      new_is_dir, NULL, new_dentry);
> +		}
> +	}
>  	fsnotify_oldname_free(old_name);
>  
>  	return error;
> @@ -4124,9 +4151,12 @@ SYSCALL_DEFINE5(renameat2, int, olddfd, const char __user *, oldname,
>  	bool should_retry = false;
>  	int error;
>  
> -	if (flags & ~RENAME_NOREPLACE)
> +	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
>  		return -EOPNOTSUPP;
>  
> +	if ((flags & RENAME_NOREPLACE) && (flags & RENAME_EXCHANGE))
> +		return -EINVAL;
> +
>  retry:
>  	from = user_path_parent(olddfd, oldname, &oldnd, lookup_flags);
>  	if (IS_ERR(from)) {
> @@ -4161,7 +4191,8 @@ retry:
>  
>  	oldnd.flags &= ~LOOKUP_PARENT;
>  	newnd.flags &= ~LOOKUP_PARENT;
> -	newnd.flags |= LOOKUP_RENAME_TARGET;
> +	if (!(flags & RENAME_EXCHANGE))
> +		newnd.flags |= LOOKUP_RENAME_TARGET;
>  
>  retry_deleg:
>  	trap = lock_rename(new_dir, old_dir);
> @@ -4181,12 +4212,23 @@ retry_deleg:
>  	error = -EEXIST;
>  	if ((flags & RENAME_NOREPLACE) && d_is_positive(new_dentry))
>  		goto exit5;
> +	if (flags & RENAME_EXCHANGE) {
> +		error = -ENOENT;
> +		if (!new_dentry->d_inode)
> +			goto exit5;
  Should this be d_is_positive()?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
