Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3AZVUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 16:20:13 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58334 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3AZVUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 16:20:09 -0500
Date: Sat, 26 Jan 2013 21:22:02 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH review 4/6] userns: Allow the userns root to mount of
 devpts
Message-ID: <20130126212202.GF11274@mail.hallyn.com>
References: <87ehh8it9s.fsf@xmission.com>
 <87obgchecv.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obgchecv.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> - The context in which devpts is mounted has no effect on the creation
>   of ptys as the /dev/ptmx interface has been used by unprivileged
>   users for many years.
> 
> - Only support unprivileged mounts in combination with the newinstance
>   option to ensure that mounting of /dev/pts in a user namespace will
>   not allow the options of an existing mount of devpts to be modified.
> 
> - Create /dev/pts/ptmx as the root user in the user namespace that
>   mounts devpts so that it's permissions to be changed.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  fs/devpts/inode.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index 472e6be..073d30b 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -243,6 +243,13 @@ static int mknod_ptmx(struct super_block *sb)
>  	struct dentry *root = sb->s_root;
>  	struct pts_fs_info *fsi = DEVPTS_SB(sb);
>  	struct pts_mount_opts *opts = &fsi->mount_opts;
> +	kuid_t root_uid;
> +	kgid_t root_gid;
> +
> +	root_uid = make_kuid(current_user_ns(), 0);
> +	root_gid = make_kgid(current_user_ns(), 0);
> +	if (!uid_valid(root_uid) || !gid_valid(root_gid))
> +		return -EINVAL;
>  
>  	mutex_lock(&root->d_inode->i_mutex);
>  
> @@ -273,6 +280,8 @@ static int mknod_ptmx(struct super_block *sb)
>  
>  	mode = S_IFCHR|opts->ptmxmode;
>  	init_special_inode(inode, mode, MKDEV(TTYAUX_MAJOR, 2));
> +	inode->i_uid = root_uid;
> +	inode->i_gid = root_gid;
>  
>  	d_add(dentry, inode);
>  
> @@ -438,6 +447,12 @@ static struct dentry *devpts_mount(struct file_system_type *fs_type,
>  	if (error)
>  		return ERR_PTR(error);
>  
> +	/* Require newinstance for all user namespace mounts to ensure
> +	 * the mount options are not changed.
> +	 */
> +	if ((current_user_ns() != &init_user_ns) && !opts.newinstance)
> +		return ERR_PTR(-EINVAL);
> +
>  	if (opts.newinstance)
>  		s = sget(fs_type, NULL, set_anon_super, flags, NULL);
>  	else
> @@ -491,6 +506,9 @@ static struct file_system_type devpts_fs_type = {
>  	.name		= "devpts",
>  	.mount		= devpts_mount,
>  	.kill_sb	= devpts_kill_sb,
> +#ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
> +	.fs_flags	= FS_USERNS_MOUNT | FS_USERNS_DEV_MOUNT,
> +#endif
>  };
>  
>  /*
> -- 
> 1.7.5.4
