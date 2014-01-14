Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaANMr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:47:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaANMrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:47:24 -0500
Date: Tue, 14 Jan 2014 13:47:20 +0100
From: Jan Kara <jack@suse.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.cz>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        luto@amacapital.net, mszeredi@suse.cz
Subject: Re: [PATCH 07/11] vfs: add cross-rename
Message-ID: <20140114124720.GC21327@quack.suse.cz>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
 <1389219015-10980-8-git-send-email-miklos@szeredi.hu>
 <20140113075227.GG3837@quack.suse.cz>
 <20140114103159.GA24171@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114103159.GA24171@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 14-01-14 11:31:59, Miklos Szeredi wrote:
> On Mon, Jan 13, 2014 at 08:52:27AM +0100, Jan Kara wrote:
> > On Wed 08-01-14 23:10:11, Miklos Szeredi wrote:
> 
> > > +	if (max_links && new_dir != old_dir) {
> > >  		error = -EMLINK;
> > > -		if (max_links && !target && new_dir != old_dir &&
> > > -		    new_dir->i_nlink >= max_links)
> > > +		if (is_dir && !new_is_dir && new_dir->i_nlink >= max_links)
> > > +			goto out;
> > > +		if ((flags & RENAME_EXCHANGE) && !is_dir && new_is_dir &&
> > > +		    old_dir->i_nlink > max_links)
> >   This should be >=, shouldn't it?
> 
> Yes, good catch, thanks.
> 
> 
> > > @@ -4181,12 +4212,23 @@ retry_deleg:
> > >  	error = -EEXIST;
> > >  	if ((flags & RENAME_NOREPLACE) && d_is_positive(new_dentry))
> > >  		goto exit5;
> > > +	if (flags & RENAME_EXCHANGE) {
> > > +		error = -ENOENT;
> > > +		if (!new_dentry->d_inode)
> > > +			goto exit5;
> >   Should this be d_is_positive()?
> 
> Yes, well, actually d_is_negative().
> 
> Thanks a lot for the review.  Updated patch below.
> 
> Miklos
> ----
> 
> Subject: vfs: add cross-rename
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> If flags contain RENAME_EXCHANGE then exchange source and destination files.
> There's no restriction on the type of the files; e.g. a directory can be
> exchanged with a symlink.
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/dcache.c             |   46 +++++++++++++++++---
>  fs/namei.c              |  107 +++++++++++++++++++++++++++++++++---------------
>  include/linux/dcache.h  |    1 
>  include/uapi/linux/fs.h |    1 
>  security/security.c     |   16 +++++++
>  5 files changed, 131 insertions(+), 40 deletions(-)
> 
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -36,6 +36,7 @@
>  #define SEEK_MAX	SEEK_HOLE
>  
>  #define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
> +#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
>  
>  struct fstrim_range {
>  	__u64 start;
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -4020,6 +4020,8 @@ int vfs_rename(struct inode *old_dir, st
>  	const unsigned char *old_name;
>  	struct inode *source = old_dentry->d_inode;
>  	struct inode *target = new_dentry->d_inode;
> +	bool new_is_dir = false;
> +	unsigned max_links = new_dir->i_sb->s_max_links;
>  
>  	if (source == target)
>  		return 0;
> @@ -4028,10 +4030,16 @@ int vfs_rename(struct inode *old_dir, st
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
> @@ -4042,10 +4050,17 @@ int vfs_rename(struct inode *old_dir, st
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
> @@ -4055,25 +4070,24 @@ int vfs_rename(struct inode *old_dir, st
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
> +		    old_dir->i_nlink >= max_links)
>  			goto out;
> -
> -		if (target)
> -			shrink_dcache_parent(new_dentry);
>  	} else {
>  		error = try_break_deleg(source, delegated_inode);
>  		if (error)
> @@ -4084,27 +4098,40 @@ int vfs_rename(struct inode *old_dir, st
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
> @@ -4124,9 +4151,12 @@ SYSCALL_DEFINE5(renameat2, int, olddfd,
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
> @@ -4161,7 +4191,8 @@ SYSCALL_DEFINE5(renameat2, int, olddfd,
>  
>  	oldnd.flags &= ~LOOKUP_PARENT;
>  	newnd.flags &= ~LOOKUP_PARENT;
> -	newnd.flags |= LOOKUP_RENAME_TARGET;
> +	if (!(flags & RENAME_EXCHANGE))
> +		newnd.flags |= LOOKUP_RENAME_TARGET;
>  
>  retry_deleg:
>  	trap = lock_rename(new_dir, old_dir);
> @@ -4181,12 +4212,23 @@ SYSCALL_DEFINE5(renameat2, int, olddfd,
>  	error = -EEXIST;
>  	if ((flags & RENAME_NOREPLACE) && d_is_positive(new_dentry))
>  		goto exit5;
> +	if (flags & RENAME_EXCHANGE) {
> +		error = -ENOENT;
> +		if (d_is_negative(new_dentry))
> +			goto exit5;
> +
> +		if (!d_is_dir(new_dentry)) {
> +			error = -ENOTDIR;
> +			if (newnd.last.name[newnd.last.len])
> +				goto exit5;
> +		}
> +	}
>  	/* unless the source is a directory trailing slashes give -ENOTDIR */
>  	if (!d_is_dir(old_dentry)) {
>  		error = -ENOTDIR;
>  		if (oldnd.last.name[oldnd.last.len])
>  			goto exit5;
> -		if (newnd.last.name[newnd.last.len])
> +		if (!(flags & RENAME_EXCHANGE) && newnd.last.name[newnd.last.len])
>  			goto exit5;
>  	}
>  	/* source should not be ancestor of target */
> @@ -4194,7 +4236,8 @@ SYSCALL_DEFINE5(renameat2, int, olddfd,
>  	if (old_dentry == trap)
>  		goto exit5;
>  	/* target should not be an ancestor of source */
> -	error = -ENOTEMPTY;
> +	if (!(flags & RENAME_EXCHANGE))
> +		error = -ENOTEMPTY;
>  	if (new_dentry == trap)
>  		goto exit5;
>  
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2483,12 +2483,14 @@ static void switch_names(struct dentry *
>  			dentry->d_name.name = dentry->d_iname;
>  		} else {
>  			/*
> -			 * Both are internal.  Just copy target to dentry
> +			 * Both are internal.
>  			 */
> -			memcpy(dentry->d_iname, target->d_name.name,
> -					target->d_name.len + 1);
> -			dentry->d_name.len = target->d_name.len;
> -			return;
> +			unsigned int i;
> +			BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN, sizeof(long)));
> +			for (i = 0; i < DNAME_INLINE_LEN / sizeof(long); i++) {
> +				swap(((long *) &dentry->d_iname)[i],
> +				     ((long *) &target->d_iname)[i]);
> +			}
>  		}
>  	}
>  	swap(dentry->d_name.len, target->d_name.len);
> @@ -2545,13 +2547,15 @@ static void dentry_unlock_parents_for_mo
>   * __d_move - move a dentry
>   * @dentry: entry to move
>   * @target: new dentry
> + * @exchange: exchange the two dentries
>   *
>   * Update the dcache to reflect the move of a file name. Negative
>   * dcache entries should not be moved in this way. Caller must hold
>   * rename_lock, the i_mutex of the source and target directories,
>   * and the sb->s_vfs_rename_mutex if they differ. See lock_rename().
>   */
> -static void __d_move(struct dentry * dentry, struct dentry * target)
> +static void __d_move(struct dentry *dentry, struct dentry *target,
> +		     bool exchange)
>  {
>  	if (!dentry->d_inode)
>  		printk(KERN_WARNING "VFS: moving negative dcache entry\n");
> @@ -2575,6 +2579,10 @@ static void __d_move(struct dentry * den
>  
>  	/* Unhash the target: dput() will then get rid of it */
>  	__d_drop(target);
> +	if (exchange) {
> +		__d_rehash(target,
> +			   d_hash(dentry->d_parent, dentry->d_name.hash));
> +	}
>  
>  	list_del(&dentry->d_u.d_child);
>  	list_del(&target->d_u.d_child);
> @@ -2601,6 +2609,8 @@ static void __d_move(struct dentry * den
>  	write_seqcount_end(&dentry->d_seq);
>  
>  	dentry_unlock_parents_for_move(dentry, target);
> +	if (exchange)
> +		fsnotify_d_move(target);
>  	spin_unlock(&target->d_lock);
>  	fsnotify_d_move(dentry);
>  	spin_unlock(&dentry->d_lock);
> @@ -2618,11 +2628,31 @@ static void __d_move(struct dentry * den
>  void d_move(struct dentry *dentry, struct dentry *target)
>  {
>  	write_seqlock(&rename_lock);
> -	__d_move(dentry, target);
> +	__d_move(dentry, target, false);
>  	write_sequnlock(&rename_lock);
>  }
>  EXPORT_SYMBOL(d_move);
>  
> +/*
> + * d_exchange - exchange two dentries
> + * @dentry1: first dentry
> + * @dentry2: second dentry
> + */
> +void d_exchange(struct dentry *dentry1, struct dentry *dentry2)
> +{
> +	write_seqlock(&rename_lock);
> +
> +	WARN_ON(!dentry1->d_inode);
> +	WARN_ON(!dentry2->d_inode);
> +	WARN_ON(IS_ROOT(dentry1));
> +	WARN_ON(IS_ROOT(dentry2));
> +
> +	__d_move(dentry1, dentry2, true);
> +
> +	write_sequnlock(&rename_lock);
> +}
> +
> +
>  /**
>   * d_ancestor - search for an ancestor
>   * @p1: ancestor dentry
> @@ -2670,7 +2700,7 @@ static struct dentry *__d_unalias(struct
>  	m2 = &alias->d_parent->d_inode->i_mutex;
>  out_unalias:
>  	if (likely(!d_mountpoint(alias))) {
> -		__d_move(alias, dentry);
> +		__d_move(alias, dentry, false);
>  		ret = alias;
>  	}
>  out_err:
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -308,6 +308,7 @@ extern void dentry_update_name_case(stru
>  
>  /* used for rename() and baskets */
>  extern void d_move(struct dentry *, struct dentry *);
> +extern void d_exchange(struct dentry *, struct dentry *);
>  extern struct dentry *d_ancestor(struct dentry *, struct dentry *);
>  
>  /* appendix may either be NULL or be used for transname suffixes */
> --- a/security/security.c
> +++ b/security/security.c
> @@ -439,6 +439,14 @@ int security_path_rename(struct path *ol
>  	if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
>  		     (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
>  		return 0;
> +
> +	if (flags & RENAME_EXCHANGE) {
> +		int err = security_ops->path_rename(new_dir, new_dentry,
> +						    old_dir, old_dentry);
> +		if (err)
> +			return err;
> +	}
> +
>  	return security_ops->path_rename(old_dir, old_dentry, new_dir,
>  					 new_dentry);
>  }
> @@ -531,6 +539,14 @@ int security_inode_rename(struct inode *
>          if (unlikely(IS_PRIVATE(old_dentry->d_inode) ||
>              (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
>  		return 0;
> +
> +	if (flags & RENAME_EXCHANGE) {
> +		int err = security_ops->inode_rename(new_dir, new_dentry,
> +						     old_dir, old_dentry);
> +		if (err)
> +			return err;
> +	}
> +
>  	return security_ops->inode_rename(old_dir, old_dentry,
>  					   new_dir, new_dentry);
>  }
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
