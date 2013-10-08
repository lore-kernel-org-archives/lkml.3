Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab3JHPt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:49:59 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42736 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3JHPt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:49:56 -0400
Date: Tue, 8 Oct 2013 17:50:41 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/3] vfs: Lazily remove mounts on unlinked files and
 directories.
Message-ID: <20131008155041.GI14242@tucsk.piliscsaba.szeredi.hu>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com>
 <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <874n8w1wsz.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874n8w1wsz.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 03:43:56PM -0700, Eric W. Biederman wrote:
> 
> With the introduction of mount namespaces and bind mounts it because
> possible to access files and directories that in other locations in
> were used as mount points.  Especially with mount namespaces has
> become very confusing why rm -rf somedir return -EBUSY because some
> directory is mounted somewhere else.  With the addition of user
> namespaces allowing unprivileged mounts this condition has gone from
> annoying to allowing a DOS attack on more privileged users.
> 
> The simplest approach appears to be to remove the -EBUSY message,
> allow unlink and rename, and lazily unmount the mount point.
> 
> In most cases this is less surprising as this is an implementation
> of the normal unix behavior of allowing unlinking of files.
> 
> The change implemented in this patch allows the following to succeed:
> 
> The vfs does not currently follow paths up to the final component for
> the rename and unlink system calls making the boldest version of this
> idea the simplest to implement.  Which should it simple to spot problems
> with this idea.
> 
> While different from our historical behavior this change does not look
> like it will break anything, or introduce any security
> vulnerabilities.  In a quick survey of all of the common mount points
> on linux systems I found mount points in directories owned and
> modifiable by root, and fuse fuse mounts in directories owned by the
> ``mounter'' of the fuse filesystem.  In both of these cases relying on
> the permissions of the directory does not practically change the user
> who is allowed to unmount the filesystem.
> 
> Attempting to anticipate cases I have not witnessed I observe that
> every directory in a trusted path to a file must limit modification
> such that no one else may modify that directory.  For files trusted by
> suid root executables root most own and be the only user capable of
> modifying the directory and all parent directories for the files to be
> safe.  Therefore for mount points part of a trusted path only root
> should be able to unlink any directory or file on that path.  Which
> means after this change for a secured path only root can unmount
> directories.
> 
> For mount points part of a path we can not trust we should not care if
> the just disappear, as that is just another kind of arbitrary
> manipulation.
> 
> So I conclude that the existing conditions will ensure that the permissions
> on directories will be sufficiently limited that the new unmount on unlink
> behavior will not cause problems.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/afs/dir.c           |    3 +-
>  fs/dcache.c            |   80 ++++++++++++++++++++----------------------------
>  fs/fuse/dir.c          |    3 +-
>  fs/gfs2/dentry.c       |    4 +--
>  fs/namei.c             |   31 ++++++------------
>  fs/nfs/dir.c           |    5 +--
>  fs/sysfs/dir.c         |    9 +-----
>  include/linux/dcache.h |    3 +-
>  8 files changed, 51 insertions(+), 87 deletions(-)
> 
> diff --git a/fs/afs/dir.c b/fs/afs/dir.c
> index 646337dc5201..7fb69d45f1b9 100644
> --- a/fs/afs/dir.c
> +++ b/fs/afs/dir.c
> @@ -686,8 +686,7 @@ not_found:
>  
>  out_bad:
>  	/* don't unhash if we have submounts */
> -	if (check_submounts_and_drop(dentry) != 0)
> -		goto out_skip;
> +	shrink_submounts_and_drop(dentry);
>  
>  	_debug("dropping dentry %s/%s",
>  	       parent->d_name.name, dentry->d_name.name);
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 41000305d716..1e9bf96b0132 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1373,7 +1373,7 @@ int d_set_mounted(struct dentry *dentry)
>  	int ret = -ENOENT;
>  	write_seqlock(&rename_lock);
>  	for (p = dentry->d_parent; !IS_ROOT(p); p = p->d_parent) {
> -		/* Need exclusion wrt. check_submounts_and_drop() */
> +		/* Need exclusion wrt. shrink_submounts_and_drop() */
>  		spin_lock(&p->d_lock);
>  		if (unlikely(d_unhashed(p))) {
>  			spin_unlock(&p->d_lock);
> @@ -1478,70 +1478,56 @@ void shrink_dcache_parent(struct dentry *parent)
>  }
>  EXPORT_SYMBOL(shrink_dcache_parent);
>  
> -static enum d_walk_ret check_and_collect(void *_data, struct dentry *dentry)
> +struct detach_data {
> +	struct dentry *found;
> +};
> +static enum d_walk_ret do_detach_submounts(void *ptr, struct dentry *dentry)
>  {
> -	struct select_data *data = _data;
> -
> -	if (d_mountpoint(dentry)) {
> -		data->found = -EBUSY;
> -		return D_WALK_QUIT;
> -	}
> -
> -	return select_collect(_data, dentry);
> -}
> +	struct detach_data *data = ptr;
>  
> -static void check_and_drop(void *_data)
> -{
> -	struct select_data *data = _data;
> +	if (d_mountpoint(dentry))
> +		data->found = dentry;
>  
> -	if (d_mountpoint(data->start))
> -		data->found = -EBUSY;
> -	if (!data->found)
> -		__d_drop(data->start);
> +	return data->found ? D_WALK_QUIT : D_WALK_CONTINUE;
>  }
>  
>  /**
> - * check_submounts_and_drop - prune dcache, check for submounts and drop
> + * detach_submounts - check for submounts and detach them.
>   *
> - * All done as a single atomic operation relative to has_unlinked_ancestor().
> - * Returns 0 if successfully unhashed @parent.  If there were submounts then
> - * return -EBUSY.
> + * @dentry: dentry to find mount points under.
>   *
> - * @dentry: dentry to prune and drop
> + * If dentry or any of it's children is a mount point detach those mounts.
>   */
> -int check_submounts_and_drop(struct dentry *dentry)
> +void detach_submounts(struct dentry *dentry)
>  {
> -	int ret = 0;
> -
> -	/* Negative dentries can be dropped without further checks */
> -	if (!dentry->d_inode) {
> -		d_drop(dentry);
> -		goto out;
> -	}
> -
> +	struct detach_data data;
>  	for (;;) {
> -		struct select_data data;
> -
> -		INIT_LIST_HEAD(&data.dispose);
> -		data.start = dentry;
> -		data.found = 0;
> +		data.found = NULL;
> +		d_walk(dentry, &data, do_detach_submounts, NULL);
>  
> -		d_walk(dentry, &data, check_and_collect, check_and_drop);
> -		ret = data.found;
> -
> -		if (!list_empty(&data.dispose))
> -			shrink_dentry_list(&data.dispose);
> -
> -		if (ret <= 0)
> +		if (!data.found)
>  			break;
>  
> +		detach_mounts(data.found);
>  		cond_resched();
>  	}
> +	detach_mounts(dentry);
> +}
>  
> -out:
> -	return ret;
> +/**
> + * shrink_submounts_and_drop - detach submounts, prune dcache, and drop
> + *
> + * All done as a single atomic operation reletaive to d_set_mounted().
> + *
> + * @dentry: dentry to detach, prune and drop
> + */
> +void shrink_submounts_and_drop(struct dentry *dentry)
> +{
> +	d_drop(dentry);
> +	detach_submounts(dentry);

And here, between detach_submounts() and shrink_dcache_parent() a new mount can
be added.

It's not accidental that check_submounts_and_drop() did the check and the drop
together, protected by rename_lock and d_lock.

> +	shrink_dcache_parent(dentry);
>  }
> -EXPORT_SYMBOL(check_submounts_and_drop);
> +EXPORT_SYMBOL(shrink_submounts_and_drop);
>  
>  /**
>   * __d_alloc	-	allocate a dcache entry
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 62b43b577bfc..b1cd7b79a325 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -259,8 +259,7 @@ out:
>  
>  invalid:
>  	ret = 0;
> -	if (check_submounts_and_drop(entry) != 0)
> -		ret = 1;
> +	shrink_submounts_and_drop(entry);
>  	goto out;
>  }
>  
> diff --git a/fs/gfs2/dentry.c b/fs/gfs2/dentry.c
> index d3a5d4e29ba5..2ecc2b873829 100644
> --- a/fs/gfs2/dentry.c
> +++ b/fs/gfs2/dentry.c
> @@ -93,9 +93,7 @@ invalid_gunlock:
>  	if (!had_lock)
>  		gfs2_glock_dq_uninit(&d_gh);
>  invalid:
> -	if (check_submounts_and_drop(dentry) != 0)
> -		goto valid;
> -
> +	shrink_submounts_and_drop(dentry);
>  	dput(parent);
>  	return 0;
>  
> diff --git a/fs/namei.c b/fs/namei.c
> index 645268f23eb6..b18b017c946b 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3560,10 +3560,6 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentry)
>  	dget(dentry);
>  	mutex_lock(&dentry->d_inode->i_mutex);
>  
> -	error = -EBUSY;
> -	if (d_mountpoint(dentry))
> -		goto out;
> -
>  	error = security_inode_rmdir(dir, dentry);
>  	if (error)
>  		goto out;
> @@ -3575,6 +3571,7 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentry)
>  
>  	dentry->d_inode->i_flags |= S_DEAD;
>  	dont_mount(dentry);
> +	detach_mounts(dentry);
>  
>  out:
>  	mutex_unlock(&dentry->d_inode->i_mutex);
> @@ -3657,14 +3654,12 @@ int vfs_unlink(struct inode *dir, struct dentry *dentry)
>  		return -EPERM;
>  
>  	mutex_lock(&dentry->d_inode->i_mutex);
> -	if (d_mountpoint(dentry))
> -		error = -EBUSY;
> -	else {
> -		error = security_inode_unlink(dir, dentry);
> +	error = security_inode_unlink(dir, dentry);
> +	if (!error) {
> +		error = dir->i_op->unlink(dir, dentry);
>  		if (!error) {
> -			error = dir->i_op->unlink(dir, dentry);
> -			if (!error)
> -				dont_mount(dentry);
> +			dont_mount(dentry);
> +			detach_mounts(dentry);
>  		}
>  	}
>  	mutex_unlock(&dentry->d_inode->i_mutex);
> @@ -3988,10 +3983,6 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
>  	if (target)
>  		mutex_lock(&target->i_mutex);
>  
> -	error = -EBUSY;
> -	if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
> -		goto out;
> -

I know of at least one app that relied at some point on a mountpoint (directory
or non-directory) not being movable: fusermount uses this to ensure that
unprivileged userspace didn't try replacing a fuse mount with a symlink to trick
fusermount into umounting an arbitrary path.  The code that relied on this was
replaced by UMOUNT_NOFOLLOW on kernels where it is supported.  But in theory
there may exist a running binary without UMOUNT_NOFOLLOW and relying on EBUSY.

And there may be other such horrid hacks out there.

>  	error = -EMLINK;
>  	if (max_links && !target && new_dir != old_dir &&
>  	    new_dir->i_nlink >= max_links)
> @@ -4006,6 +3997,7 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
>  	if (target) {
>  		target->i_flags |= S_DEAD;
>  		dont_mount(new_dentry);
> +		detach_mounts(new_dentry);
>  	}
>  out:
>  	if (target)
> @@ -4031,16 +4023,15 @@ static int vfs_rename_other(struct inode *old_dir, struct dentry *old_dentry,
>  	if (target)
>  		mutex_lock(&target->i_mutex);
>  
> -	error = -EBUSY;
> -	if (d_mountpoint(old_dentry)||d_mountpoint(new_dentry))
> -		goto out;
> -
>  	error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
>  	if (error)
>  		goto out;
>  
> -	if (target)
> +	if (target) {
>  		dont_mount(new_dentry);
> +		detach_mounts(new_dentry);
> +	}
> +	detach_mounts(old_dentry);

Why exactly?  "Moved file changes contents" is not the least surprising result,
IMO.  And why the difference between rename-dir and rename-other in this regard?

>  	if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE))
>  		d_move(old_dentry, new_dentry);
>  out:
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index 854a8f05a610..e8e35acd8850 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -1142,10 +1142,7 @@ out_zap_parent:
>  		if (dentry->d_flags & DCACHE_DISCONNECTED)
>  			goto out_valid;
>  	}
> -	/* If we have submounts, don't unhash ! */
> -	if (check_submounts_and_drop(dentry) != 0)
> -		goto out_valid;
> -
> +	shrink_submounts_and_drop(dentry);
>  	dput(parent);
>  	dfprintk(LOOKUPCACHE, "NFS: %s(%s/%s) is invalid\n",
>  			__func__, dentry->d_parent->d_name.name,
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 4d83cedb9fcb..477c66d4e2a8 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -327,7 +327,6 @@ static int sysfs_dentry_revalidate(struct dentry *dentry, unsigned int flags)
>  	}
>  
>  	mutex_unlock(&sysfs_mutex);
> -out_valid:
>  	return 1;
>  out_bad:
>  	/* Remove the dentry from the dcache hashes.
> @@ -341,13 +340,7 @@ out_bad:
>  	 * to the dcache hashes.
>  	 */
>  	mutex_unlock(&sysfs_mutex);
> -
> -	/* If we have submounts we must allow the vfs caches
> -	 * to lie about the state of the filesystem to prevent
> -	 * leaks and other nasty things.
> -	 */
> -	if (check_submounts_and_drop(dentry) != 0)
> -		goto out_valid;
> +	shrink_submounts_and_drop(dentry);
>  
>  	return 0;
>  }
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index 59066e0b4ff1..17948b49f3d5 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -254,7 +254,8 @@ extern void d_prune_aliases(struct inode *);
>  
>  /* test whether we have any submounts in a subdir tree */
>  extern int have_submounts(struct dentry *);
> -extern int check_submounts_and_drop(struct dentry *);
> +extern void detach_submounts(struct dentry *dentry);
> +extern void shrink_submounts_and_drop(struct dentry *);
>  
>  /*
>   * This adds the entry to the hash queues.
> -- 
> 1.7.5.4
> 
