Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3LLNju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:39:50 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47799 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3LLNjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:39:43 -0500
Message-ID: <1386855577.6428.54.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 1/2] ima: hooks for directory integrity protection
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org,
        jmorris@namei.org, dmitry.kasatkin@gmail.com
Date: Thu, 12 Dec 2013 08:39:37 -0500
In-Reply-To: <d9de3562c23e4ac8f59d6eb16c12e303f42c8855.1384806012.git.d.kasatkin@samsung.com>
References: <cover.1384806012.git.d.kasatkin@samsung.com>
	 <d9de3562c23e4ac8f59d6eb16c12e303f42c8855.1384806012.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121213-9332-0000-0000-00000278542C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-18 at 22:24 +0200, Dmitry Kasatkin wrote: 
> Both IMA-appraisal and EVM protect the integrity of regular files.
> IMA protects file data integrity, while EVM protects the file meta-data
> integrity, such as file attributes and extended attributes. This patch
> set adds hooks for offline directory integrity protection.
> 
> An inode itself does not have any file name associated with it.  The
> association of the file name to inode is done via directory entries.
> On a running system, mandatory and/or discretionary access control prevent
> unprivileged file deletion, file name change, or hardlink creation.
> In an offline attack, without these protections, the association between
> a file name and an inode is unprotected. Files can be deleted, renamed
> or moved from one directory to another one. In all of these cases,
> the integrity of the file data and metadata is good.
> 
> To prevent such attacks, it is necessary to protect integrity of directory
> content.

Thanks Dmitry for re-posting these 'directory integrity protection'
patches.
The patches have evolved nicely.  Perhaps not a formal changelog, but a
short
summary of the major changes, would have been nice.

> 
> This patch adds 2 new hooks for directory integrity protection:
>   ima_dir_check() and ima_dir_update().

Although these patches are probably bisect safe, as they rely on
Kconfig, the normal ordering of patches is to define a function and use
it in the same patch.  In the case, like here, where a new function/hook
is defined in one subsystem, but called from another, we can split them,
but the normal convention is to add the new function/hook first in one
patch, and then use it in a subsequent patch.

> 
> ima_dir_check() is called to verify integrity of the the directory during
> the initial path lookup.
> 
> ima_dir_update() is called from several places in namei.c, when the directory
> content is changing, for updating the directory hash.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  fs/namei.c                        | 42 ++++++++++++++++++++++++++++++++++++---
>  fs/open.c                         |  6 ++++++
>  include/linux/ima.h               | 23 +++++++++++++++++++++
>  net/unix/af_unix.c                |  2 ++
>  security/integrity/ima/ima_main.c |  3 +++
>  5 files changed, 73 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 645268f..d0e1821 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1469,16 +1469,33 @@ static int lookup_slow(struct nameidata *nd, struct path *path)
>  	return 0;
>  }
> 
> +static inline int may_lookup_ima(struct nameidata *nd, int err)
> +{
> +	if (err)
> +		return err;
> +	err = ima_dir_check(&nd->path, MAY_EXEC|MAY_NOT_BLOCK);
> +	if (err != -ECHILD)
> +		return err;

A short comment here, why -ECHILD is special, would be good.

> +	if (unlazy_walk(nd, NULL))
> +		return -ECHILD;
> +	return ima_dir_check(&nd->path, MAY_EXEC);
> +}
> +
>  static inline int may_lookup(struct nameidata *nd)
>  {
> +	int err = 0;
> +
>  	if (nd->flags & LOOKUP_RCU) {
> -		int err = inode_permission(nd->inode, MAY_EXEC|MAY_NOT_BLOCK);
> +		err = inode_permission(nd->inode, MAY_EXEC|MAY_NOT_BLOCK);
>  		if (err != -ECHILD)
> -			return err;
> +			return may_lookup_ima(nd, err);
>  		if (unlazy_walk(nd, NULL))
>  			return -ECHILD;
>  	}
> -	return inode_permission(nd->inode, MAY_EXEC);
> +	err = inode_permission(nd->inode, MAY_EXEC);
> +	if (err)
> +		return err;
> +	return ima_dir_check(&nd->path, MAY_EXEC);
>  }
> 
>  static inline int handle_dots(struct nameidata *nd, int type)
> @@ -2956,6 +2973,8 @@ retry_lookup:
>  	}
>  	mutex_lock(&dir->d_inode->i_mutex);
>  	error = lookup_open(nd, path, file, op, got_write, opened);
> +	if (error >= 0 && (*opened & FILE_CREATED))
> +		ima_dir_update(&nd->path, NULL);
>  	mutex_unlock(&dir->d_inode->i_mutex);
> 
>  	if (error <= 0) {
> @@ -3454,6 +3473,8 @@ retry:
>  			error = vfs_mknod(path.dentry->d_inode,dentry,mode,0);
>  			break;
>  	}
> +	if (!error)
> +		ima_dir_update(&path, dentry);
>  out:
>  	done_path_create(&path, dentry);
>  	if (retry_estale(error, lookup_flags)) {
> @@ -3510,6 +3531,8 @@ retry:
>  	error = security_path_mkdir(&path, dentry, mode);
>  	if (!error)
>  		error = vfs_mkdir(path.dentry->d_inode, dentry, mode);
> +	if (!error)
> +		ima_dir_update(&path, dentry);
>  	done_path_create(&path, dentry);
>  	if (retry_estale(error, lookup_flags)) {
>  		lookup_flags |= LOOKUP_REVAL;
> @@ -3626,6 +3649,8 @@ retry:
>  	if (error)
>  		goto exit3;
>  	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
> +	if (!error)
> +		ima_dir_update(&nd.path, NULL);
>  exit3:
>  	dput(dentry);
>  exit2:
> @@ -3721,6 +3746,8 @@ retry:
>  		if (error)
>  			goto exit2;
>  		error = vfs_unlink(nd.path.dentry->d_inode, dentry);
> +		if (!error)
> +			ima_dir_update(&nd.path, NULL);
>  exit2:
>  		dput(dentry);
>  	}
> @@ -3801,6 +3828,8 @@ retry:
>  	error = security_path_symlink(&path, dentry, from->name);
>  	if (!error)
>  		error = vfs_symlink(path.dentry->d_inode, dentry, from->name);
> +	if (!error)
> +		ima_dir_update(&path, dentry);
>  	done_path_create(&path, dentry);
>  	if (retry_estale(error, lookup_flags)) {
>  		lookup_flags |= LOOKUP_REVAL;
> @@ -3919,6 +3948,8 @@ retry:
>  	if (error)
>  		goto out_dput;
>  	error = vfs_link(old_path.dentry, new_path.dentry->d_inode, new_dentry);
> +	if (!error)
> +		ima_dir_update(&new_path, NULL);
>  out_dput:
>  	done_path_create(&new_path, new_dentry);
>  	if (retry_estale(error, how)) {
> @@ -4171,6 +4202,11 @@ retry:
>  		goto exit5;
>  	error = vfs_rename(old_dir->d_inode, old_dentry,
>  				   new_dir->d_inode, new_dentry);
> +	if (!error) {
> +		ima_dir_update(&oldnd.path, NULL);
> +		if (!path_equal(&oldnd.path, &newnd.path))
> +			ima_dir_update(&newnd.path, NULL);
> +	}
>  exit5:
>  	dput(new_dentry);
>  exit4:
> diff --git a/fs/open.c b/fs/open.c
> index d420331..021e2c5 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -390,6 +390,9 @@ retry:
>  	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR);
>  	if (error)
>  		goto dput_and_out;
> +	error = ima_dir_check(&path, MAY_EXEC);
> +	if (error)
> +		goto dput_and_out;
> 
>  	set_fs_pwd(current->fs, &path);
> 
> @@ -420,6 +423,9 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd)
>  		goto out_putf;
> 
>  	error = inode_permission(inode, MAY_EXEC | MAY_CHDIR);
> +	if (error)
> +		goto out_putf;
> +	error = ima_dir_check(&f.file->f_path, MAY_EXEC);
>  	if (!error)
>  		set_fs_pwd(current->fs, &f.file->f_path);
>  out_putf:
> diff --git a/include/linux/ima.h b/include/linux/ima.h
> index 1b7f268..e33035e 100644
> --- a/include/linux/ima.h
> +++ b/include/linux/ima.h
> @@ -73,4 +73,27 @@ static inline int ima_inode_removexattr(struct dentry *dentry,
>  	return 0;
>  }
>  #endif /* CONFIG_IMA_APPRAISE */
> +
> +#ifdef CONFIG_IMA_APPRAISE_DIRECTORIES
> +extern int ima_dir_check(struct path *dir, int mask);
> +extern int ima_special_check(struct file *file, int mask);

No mention was made of this new hook.  This should be a separate patch,
with its own patch description.

thanks,

Mimi

> +extern void ima_dir_update(struct path *dir, struct dentry *dentry);
> +#else
> +static inline int ima_dir_check(struct path *dir, int mask)
> +{
> +	return 0;
> +}
> +
> +static inline int ima_special_check(struct file *file, int mask)
> +{
> +	return 0;
> +}
> +
> +static inline void ima_dir_update(struct path *dir, struct dentry *dentry)
> +{
> +	return;
> +}
> +
> +#endif /* CONFIG_IMA_APPRAISE_DIRECTORIES */
> +
>  #endif /* _LINUX_IMA_H */
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 86de99a..6230a50 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -115,6 +115,7 @@
>  #include <net/checksum.h>
>  #include <linux/security.h>
>  #include <linux/freezer.h>
> +#include <linux/ima.h>
> 
>  struct hlist_head unix_socket_table[2 * UNIX_HASH_SIZE];
>  EXPORT_SYMBOL_GPL(unix_socket_table);
> @@ -841,6 +842,7 @@ static int unix_mknod(const char *sun_path, umode_t mode, struct path *res)
>  		if (!err) {
>  			res->mnt = mntget(path.mnt);
>  			res->dentry = dget(dentry);
> +			ima_dir_update(&path, dentry);
>  		}
>  	}
>  	done_path_create(&path, dentry);
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 6c12811..18d76d8 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -300,6 +300,9 @@ int ima_bprm_check(struct linux_binprm *bprm)
>   */
>  int ima_file_check(struct file *file, int mask)
>  {
> +	if (!S_ISREG(file->f_dentry->d_inode->i_mode))
> +		return ima_special_check(file, mask);
> +
>  	ima_rdwr_violation_check(file);
>  	return process_measurement(file, NULL,
>  				   mask & (MAY_READ | MAY_WRITE | MAY_EXEC),


