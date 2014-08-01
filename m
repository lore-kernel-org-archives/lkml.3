Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbaHATUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 15:20:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088AbaHATUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 15:20:37 -0400
Date: Fri, 1 Aug 2014 21:20:18 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Richard Yao <ryao@gentoo.org>
Cc: kernel@gentoo.org, mthode@mthode.org, michael@fds-team.de,
        drobbins@funtoo.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] vfs: Respect MS_RDONLY at bind mount creation
Message-ID: <20140801192017.GC1850@mguzik.redhat.com>
References: <1406916744-6634-1-git-send-email-ryao@gentoo.org>
 <1406916744-6634-2-git-send-email-ryao@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406916744-6634-2-git-send-email-ryao@gentoo.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 02:12:24PM -0400, Richard Yao wrote:
> `mount -o bind,ro ...` suffers from a silent failure where the readonly
> flag is ignored. The bind mount will be created rw whenever the target
> is rw. Users typically workaround this by remounting readonly, but that
> does not work when you want to define readonly bind mounts in fstab.
> This is a major annoyance when dealing with recursive bind mounts
> because the userland mount command does not expose the option to
> recursively remount a subtree as readonly.
> 
> Signed-off-by: Richard Yao <ryao@gentoo.org>
> ---
>  fs/namespace.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 182bc41..0d23525 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1827,11 +1827,12 @@ static bool has_locked_children(struct mount *mnt, struct dentry *dentry)
>   * do loopback mount.
>   */
>  static int do_loopback(struct path *path, const char *old_name,
> -				int recurse)
> +				unsigned long flags)
>  {
>  	struct path old_path;
> -	struct mount *mnt = NULL, *old, *parent;
> +	struct mount *mnt = NULL, *old, *parent, *m;
>  	struct mountpoint *mp;
> +	int recurse = flags & MS_REC;
>  	int err;
>  	if (!old_name || !*old_name)
>  		return -EINVAL;
> @@ -1871,6 +1872,10 @@ static int do_loopback(struct path *path, const char *old_name,
>  		goto out2;
>  	}
>  
> +	if (flags & MS_RDONLY)
> +		for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
> +			mnt_make_readonly(m);
> +
>  	mnt->mnt.mnt_flags &= ~MNT_LOCKED;
>  
>  	err = graft_tree(mnt, parent, mp);
> @@ -2444,7 +2449,8 @@ long do_mount(const char *dev_name, const char *dir_name,
>  		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
>  				    data_page);
>  	else if (flags & MS_BIND)
> -		retval = do_loopback(&path, dev_name, flags & MS_REC);
> +		retval = do_loopback(&path, dev_name, flags & (MS_REC |
> +							       MS_RDONLY));
>  	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
>  		retval = do_change_type(&path, flags);
>  	else if (flags & MS_MOVE)

I don't really know this code, but have to ask.

Would not it be much better to pass down info about rdonly request to
copy_tree/clone_mnt (perhaps CL_MOUNT_RDONLY flag or a separate flags
argument) and handle it there?

This would avoid fishy-looking traversal before graft_tree, which even
if correct should not be necessary.

-- 
Mateusz Guzik
