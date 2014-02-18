Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaBRRLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:11:40 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:32890 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaBRRLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:11:38 -0500
Date: Tue, 18 Feb 2014 18:12:52 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 03/11] vfs: Don't allow overwriting mounts in the current
 mount namespace
Message-ID: <20140218171252.GC4026@tucsk.piliscsaba.szeredi.hu>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com>
 <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87ob28kqks.fsf_-_@xmission.com>
 <8761ogkqhl.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761ogkqhl.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 01:36:38PM -0800, Eric W. Biederman wrote:
> 
> In preparation for allowing mountpoints to be renamed and unlinked
> in remote filesystems and in other mount namespaces test if on a dentry
> there is a mount in the local mount namespace before allowing it to
> be renamed or unlinked.
> 
> The primary motivation here are old versions of fusermount unmount
> which is not safe if the a path can be renamed or unlinked while it is
> verifying the mount is safe to unmount.  More recent versions are simpler
> and safer by simply using UMOUNT_NOFOLLOW when unmounting a mount
> in a directory owned by an arbitrary user.
> 
> Miklos Szeredi <miklos@szeredi.hu> reports this is approach is good
> enough to remove concerns about new kernels mixed with old versions
> of fusermount.
> 
> A secondary motivation for restrictions here is that it removing empty
> directories that have non-empty mount points on them appears to
> violate the rule that rmdir can not remove empty directories.  As
> Linus Torvalds pointed out this is useful for programs (like git) that
> test if a directory is empty with rmdir.
> 
> Therefore this patch arranges to enforce the existing mount point
> semantics for local mount namespace.
> 
> v2: Rewrote the test to be a drop in replacement for d_mountpoint
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/mount.h     |    9 +++++++++
>  fs/namei.c     |    8 +++++++-
>  fs/namespace.c |   35 +++++++++++++++++++++++++++++++++++
>  3 files changed, 51 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/mount.h b/fs/mount.h
> index a17458ca6f29..17d913d86add 100644
> --- a/fs/mount.h
> +++ b/fs/mount.h
> @@ -109,3 +109,12 @@ struct proc_mounts {
>  #define proc_mounts(p) (container_of((p), struct proc_mounts, m))
>  
>  extern const struct seq_operations mounts_op;
> +
> +extern int __is_local_mountpoint(struct dentry *dentry);
> +static inline int is_local_mountpoint(struct dentry *dentry)
> +{
> +	if (!d_mountpoint(dentry))
> +		return 0;
> +
> +	return __is_local_mountpoint(dentry);
> +}
> diff --git a/fs/namei.c b/fs/namei.c
> index d580df2e6804..4e6fe16ef488 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3507,6 +3507,8 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentry)
>  	mutex_lock(&dentry->d_inode->i_mutex);
>  
>  	error = -EBUSY;
> +	if (is_local_mountpoint(dentry))
> +		goto out;
>  	if (d_mountpoint(dentry))
>  		goto out;
>  
> @@ -3622,7 +3624,7 @@ int vfs_unlink(struct inode *dir, struct dentry *dentry, struct inode **delegate
>  		return -EPERM;
>  
>  	mutex_lock(&target->i_mutex);
> -	if (d_mountpoint(dentry))
> +	if (is_local_mountpoint(dentry) || d_mountpoint(dentry))
>  		error = -EBUSY;
>  	else {
>  		error = security_inode_unlink(dir, dentry);
> @@ -4001,6 +4003,8 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
>  		mutex_lock(&target->i_mutex);
>  
>  	error = -EBUSY;
> +	if (is_local_mountpoint(old_dentry) || is_local_mountpoint(new_dentry))
> +		goto out;
>  	if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
>  		goto out;
>  
> @@ -4045,6 +4049,8 @@ static int vfs_rename_other(struct inode *old_dir, struct dentry *old_dentry,
>  	lock_two_nondirectories(source, target);
>  
>  	error = -EBUSY;
> +	if (is_local_mountpoint(old_dentry) || is_local_mountpoint(new_dentry))
> +		goto out;
>  	if (d_mountpoint(old_dentry)||d_mountpoint(new_dentry))
>  		goto out;
>  
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 22e536705c45..6dc23614d44d 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -631,6 +631,41 @@ struct vfsmount *lookup_mnt(struct path *path)
>  	return m;
>  }
>  
> +/*
> + * __is_local_mountpoint - Test to see if dentry is a mountpoint in the
> + *                         current mount namespace.
> + *
> + * The common case is dentries are not mountpoints at all and that
> + * test is handled inline.  For the slow case when we are actually
> + * dealing with a mountpoint of some kind, walk through all of the
> + * mounts in the current mount namespace and test to see if the dentry
> + * is a mountpoint.
> + *
> + * The mount_hashtable is not usable in the context because we
> + * need to identify all mounts that may be in the current mount
> + * namespace not just a mount that happens to have some specified
> + * parent mount.
> + */
> +int __is_local_mountpoint(struct dentry *dentry)

Minor nit: return value of any is_* function is either true or false, so why not
declare it bool?

> +{
> +	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
> +	struct mount *mnt;
> +	int is_covered = 0;

And the same for this var.

> +
> +	if (!d_mountpoint(dentry))
> +		goto out;
> +
> +	down_read(&namespace_sem);
> +	list_for_each_entry(mnt, &ns->list, mnt_list) {
> +		is_covered = (mnt->mnt_mountpoint == dentry);
> +		if (is_covered)
> +			break;
> +	}
> +	up_read(&namespace_sem);
> +out:
> +	return is_covered;
> +}
> +
>  static struct mountpoint *new_mountpoint(struct dentry *dentry)
>  {
>  	struct list_head *chain = mountpoint_hashtable + hash(NULL, dentry);
> -- 
> 1.7.5.4
> 
