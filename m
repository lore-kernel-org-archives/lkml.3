Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab3IHLf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 07:35:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab3IHLf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 07:35:28 -0400
Date: Sun, 8 Sep 2013 07:35:31 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] vfs - rename user_path_umountat() to
 user_path_mntpointat()
Message-ID: <20130908073531.068baf73@tlielax.poochiereds.net>
In-Reply-To: <20130908084714.14798.32490.stgit@perseus.fritz.box>
References: <20130908084714.14798.32490.stgit@perseus.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Sep 2013 16:47:15 +0800
Ian Kent <raven@themaw.net> wrote:

> The function user_path_umountat() not only avoids revalidation but
> avoids the managed dentry code as well.
> 
> This function has other uses, such as the case where autofs is
> reconnecting to a tree of mounts and needs to avoid the managed
> dentry call since that would incorrectly cause a callback to the
> daemon.
> 
> So give the function a more descriptive name.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Cc: Jeff Layton <jlayton@redhat.com>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> ---
>  fs/namei.c            |   34 +++++++++++++++++++---------------
>  fs/namespace.c        |    2 +-
>  include/linux/namei.h |    2 +-
>  3 files changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index f415c66..24f7562 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2250,7 +2250,7 @@ user_path_parent(int dfd, const char __user *path, struct nameidata *nd,
>   *         to the link, and nd->path will *not* be put.
>   */
>  static int
> -umount_lookup_last(struct nameidata *nd, struct path *path)
> +mntpoint_lookup_last(struct nameidata *nd, struct path *path)
>  {
>  	int error = 0;
>  	struct dentry *dentry;
> @@ -2309,17 +2309,19 @@ error_check:
>  }
>  
>  /**
> - * path_umountat - look up a path to be umounted
> + * path_mntpointat - look up a path to a mount point
>   * @dfd:	directory file descriptor to start walk from
>   * @name:	full pathname to walk
>   * @flags:	lookup flags
>   * @nd:		pathwalk nameidata
>   *
> - * Look up the given name, but don't attempt to revalidate the last component.
> + * Look up the given name, but don't attempt to revalidate the last component
> + * or call the managed dentry code.
>   * Returns 0 and "path" will be valid on success; Retuns error otherwise.
>   */
>  static int
> -path_umountat(int dfd, const char *name, struct path *path, unsigned int flags)
> +path_mntpointat(int dfd, const char *name,
> +		struct path *path, unsigned int flags)
>  {
>  	struct file *base = NULL;
>  	struct nameidata nd;
> @@ -2343,7 +2345,7 @@ path_umountat(int dfd, const char *name, struct path *path, unsigned int flags)
>  		}
>  	}
>  
> -	err = umount_lookup_last(&nd, path);
> +	err = mntpoint_lookup_last(&nd, path);
>  	while (err > 0) {
>  		void *cookie;
>  		struct path link = *path;
> @@ -2354,7 +2356,7 @@ path_umountat(int dfd, const char *name, struct path *path, unsigned int flags)
>  		err = follow_link(&link, &nd, &cookie);
>  		if (err)
>  			break;
> -		err = umount_lookup_last(&nd, path);
> +		err = mntpoint_lookup_last(&nd, path);
>  		put_link(&nd, &link, cookie);
>  	}
>  out:
> @@ -2368,21 +2370,23 @@ out:
>  }
>  
>  /**
> - * user_path_umountat - lookup a path from userland in order to umount it
> + * user_path_mntpointat - lookup a mountpoint path from userland without
> + *      revalidating it or calling the managed dentry code
>   * @dfd:	directory file descriptor
>   * @name:	pathname from userland
>   * @flags:	lookup flags
>   * @path:	pointer to container to hold result
>   *
> - * A umount is a special case for path walking. We're not actually interested
> - * in the inode in this situation, and ESTALE errors can be a problem. We
> - * simply want track down the dentry and vfsmount attached at the mountpoint
> - * and avoid revalidating the last component.
> + * A mount point (when being umounted for example) is a special case for path
> + * walking. We're not actually interested in the inode in this situation, and
> + * ESTALE errors can be a problem. We simply want track down the dentry and
> + * vfsmount attached at the mountpoint and avoid revalidating or calling the
> + * managed dentry code for the last component.
>   *
>   * Returns 0 and populates "path" on success.
>   */
>  int
> -user_path_umountat(int dfd, const char __user *name, unsigned int flags,
> +user_path_mntpointat(int dfd, const char __user *name, unsigned int flags,
>  			struct path *path)
>  {
>  	struct filename *s = getname(name);
> @@ -2391,11 +2395,11 @@ user_path_umountat(int dfd, const char __user *name, unsigned int flags,
>  	if (IS_ERR(s))
>  		return PTR_ERR(s);
>  
> -	error = path_umountat(dfd, s->name, path, flags | LOOKUP_RCU);
> +	error = path_mntpointat(dfd, s->name, path, flags | LOOKUP_RCU);
>  	if (unlikely(error == -ECHILD))
> -		error = path_umountat(dfd, s->name, path, flags);
> +		error = path_mntpointat(dfd, s->name, path, flags);
>  	if (unlikely(error == -ESTALE))
> -		error = path_umountat(dfd, s->name, path, flags | LOOKUP_REVAL);
> +		error = path_mntpointat(dfd, s->name, path, flags|LOOKUP_REVAL);
>  
>  	if (likely(!error))
>  		audit_inode(s, path->dentry, 0);
> diff --git a/fs/namespace.c b/fs/namespace.c
> index fc2b522..c48ad96 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1321,7 +1321,7 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
>  	if (!(flags & UMOUNT_NOFOLLOW))
>  		lookup_flags |= LOOKUP_FOLLOW;
>  
> -	retval = user_path_umountat(AT_FDCWD, name, lookup_flags, &path);
> +	retval = user_path_mntpointat(AT_FDCWD, name, lookup_flags, &path);
>  	if (retval)
>  		goto out;
>  	mnt = real_mount(path.mnt);
> diff --git a/include/linux/namei.h b/include/linux/namei.h
> index cd09751..7908abf 100644
> --- a/include/linux/namei.h
> +++ b/include/linux/namei.h
> @@ -58,7 +58,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
>  
>  extern int user_path_at(int, const char __user *, unsigned, struct path *);
>  extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);
> -extern int user_path_umountat(int, const char __user *, unsigned int, struct path *);
> +extern int user_path_mntpointat(int, const char __user *, unsigned int, struct path *);
>  
>  #define user_path(name, path) user_path_at(AT_FDCWD, name, LOOKUP_FOLLOW, path)
>  #define user_lpath(name, path) user_path_at(AT_FDCWD, name, 0, path)
> 

Looks good to me.

Acked-by: Jeff Layton <jlayton@redhat.com>
