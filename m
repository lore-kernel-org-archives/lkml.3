Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaAOKKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:10:16 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:60172 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAOKKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:10:11 -0500
Date: Wed, 15 Jan 2014 11:10:58 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: john.johansen@canonical.com, mszeredi@suse.cz,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com, zab@redhat.com,
        jack@suse.cz, luto@amacapital.net
Subject: Re: [PATCH 00/11] cross rename v3
Message-ID: <20140115101058.GC24171@tucsk.piliscsaba.szeredi.hu>
References: <1389632933.16290.15.camel@tucsk.piliscsaba.szeredi.hu>
 <201401140703.ICH21836.HMJStQVFOFOLOF@I-love.SAKURA.ne.jp>
 <CAJfpegs6kzkmJ8NFCuwEBGFgW5toM4X9RC+8JzJPX1V1rMmsow@mail.gmail.com>
 <201401142203.IDB17653.LHVJtFFOSOMQFO@I-love.SAKURA.ne.jp>
 <52D599CC.5050300@canonical.com>
 <201401150553.CFJ12414.VLOtFOSOQFHJMF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201401150553.CFJ12414.VLOtFOSOQFHJMF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 05:53:36AM +0900, Tetsuo Handa wrote:
> Miklos, can you insert below change between a patch which defines
> RENAME_EXCHANGE and a patch which implements RENAME_EXCHANGE functionality?

I don't really want to add this to the series.  This patch actually *breaks*
tomoyo and apparmor, AFAICS, so it makes little sense on its own.

Could you please prepare a separate series, and you can submit that right after
the cross rename patches go in.

Thanks,
Miklos

> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 95cfccc..dbd05ca 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -446,6 +446,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	@old_dentry contains the dentry structure of the old link.
>   *	@new_dir contains the inode structure for parent of the new link.
>   *	@new_dentry contains the dentry structure of the new link.
> + *	@flags contains rename flags.
>   *	Return 0 if permission is granted.
>   * @path_rename:
>   *	Check for permission to rename a file or directory.
> @@ -453,6 +454,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	@old_dentry contains the dentry structure of the old link.
>   *	@new_dir contains the path structure for parent of the new link.
>   *	@new_dentry contains the dentry structure of the new link.
> + *	@flags contains rename flags.
>   *	Return 0 if permission is granted.
>   * @path_chmod:
>   *	Check for permission to change DAC's permission of a file or directory.
> @@ -1491,7 +1493,8 @@ struct security_operations {
>  	int (*path_link) (struct dentry *old_dentry, struct path *new_dir,
>  			  struct dentry *new_dentry);
>  	int (*path_rename) (struct path *old_dir, struct dentry *old_dentry,
> -			    struct path *new_dir, struct dentry *new_dentry);
> +			    struct path *new_dir, struct dentry *new_dentry,
> +			    unsigned int flags);
>  	int (*path_chmod) (struct path *path, umode_t mode);
>  	int (*path_chown) (struct path *path, kuid_t uid, kgid_t gid);
>  	int (*path_chroot) (struct path *path);
> @@ -1514,7 +1517,8 @@ struct security_operations {
>  	int (*inode_mknod) (struct inode *dir, struct dentry *dentry,
>  			    umode_t mode, dev_t dev);
>  	int (*inode_rename) (struct inode *old_dir, struct dentry *old_dentry,
> -			     struct inode *new_dir, struct dentry *new_dentry);
> +			     struct inode *new_dir, struct dentry *new_dentry,
> +			     unsigned int flags);
>  	int (*inode_readlink) (struct dentry *dentry);
>  	int (*inode_follow_link) (struct dentry *dentry, struct nameidata *nd);
>  	int (*inode_permission) (struct inode *inode, int mask);
> diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
> index 4257b7e..2afa7c5 100644
> --- a/security/apparmor/lsm.c
> +++ b/security/apparmor/lsm.c
> @@ -315,7 +315,8 @@ static int apparmor_path_link(struct dentry *old_dentry, struct path *new_dir,
>  }
>  
>  static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
> -				struct path *new_dir, struct dentry *new_dentry)
> +				struct path *new_dir, struct dentry *new_dentry,
> +				unsigned int flags)
>  {
>  	struct aa_profile *profile;
>  	int error = 0;
> diff --git a/security/capability.c b/security/capability.c
> index 8b4f24a..ab2f231 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -176,7 +176,8 @@ static int cap_inode_mknod(struct inode *inode, struct dentry *dentry,
>  }
>  
>  static int cap_inode_rename(struct inode *old_inode, struct dentry *old_dentry,
> -			    struct inode *new_inode, struct dentry *new_dentry)
> +			    struct inode *new_inode, struct dentry *new_dentry,
> +			    unsigned int flags)
>  {
>  	return 0;
>  }
> @@ -280,7 +281,8 @@ static int cap_path_link(struct dentry *old_dentry, struct path *new_dir,
>  }
>  
>  static int cap_path_rename(struct path *old_path, struct dentry *old_dentry,
> -			   struct path *new_path, struct dentry *new_dentry)
> +			   struct path *new_path, struct dentry *new_dentry,
> +			   unsigned int flags)
>  {
>  	return 0;
>  }
> diff --git a/security/security.c b/security/security.c
> index 3dd2258..f90ac9b 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -440,15 +440,8 @@ int security_path_rename(struct path *old_dir, struct dentry *old_dentry,
>  		     (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
>  		return 0;
>  
> -	if (flags & RENAME_EXCHANGE) {
> -		int err = security_ops->path_rename(new_dir, new_dentry,
> -						    old_dir, old_dentry);
> -		if (err)
> -			return err;
> -	}
> -
>  	return security_ops->path_rename(old_dir, old_dentry, new_dir,
> -					 new_dentry);
> +					 new_dentry, flags);
>  }
>  EXPORT_SYMBOL(security_path_rename);
>  
> @@ -540,15 +533,8 @@ int security_inode_rename(struct inode *old_dir, struct dentry *old_dentry,
>              (new_dentry->d_inode && IS_PRIVATE(new_dentry->d_inode))))
>  		return 0;
>  
> -	if (flags & RENAME_EXCHANGE) {
> -		int err = security_ops->inode_rename(new_dir, new_dentry,
> -						     old_dir, old_dentry);
> -		if (err)
> -			return err;
> -	}
> -
>  	return security_ops->inode_rename(old_dir, old_dentry,
> -					   new_dir, new_dentry);
> +					  new_dir, new_dentry, flags);
>  }
>  
>  int security_inode_readlink(struct dentry *dentry)
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 3219560..fffd458 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2714,9 +2714,13 @@ static int selinux_inode_mknod(struct inode *dir, struct dentry *dentry, umode_t
>  }
>  
>  static int selinux_inode_rename(struct inode *old_inode, struct dentry *old_dentry,
> -				struct inode *new_inode, struct dentry *new_dentry)
> +				struct inode *new_inode, struct dentry *new_dentry,
> +				unsigned int flags)
>  {
> -	return may_rename(old_inode, old_dentry, new_inode, new_dentry);
> +	int err = may_rename(old_inode, old_dentry, new_inode, new_dentry);
> +	if (!err && (flags & RENAME_EXCHANGE))
> +		err = may_rename(new_inode, new_dentry, old_inode, old_dentry);
> +	return err;
>  }
>  
>  static int selinux_inode_readlink(struct dentry *dentry)
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index d814e35..623fce6 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -697,6 +697,7 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
>   * @old_dentry: unused
>   * @new_inode: the new directory
>   * @new_dentry: unused
> + * @flags:     rename flags
>   *
>   * Read and write access is required on both the old and
>   * new directories.
> @@ -706,7 +707,8 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
>  static int smack_inode_rename(struct inode *old_inode,
>  			      struct dentry *old_dentry,
>  			      struct inode *new_inode,
> -			      struct dentry *new_dentry)
> +			      struct dentry *new_dentry,
> +			      unsigned int flags)
>  {
>  	int rc;
>  	char *isp;
> diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
> index f0b756e..ac7dd97 100644
> --- a/security/tomoyo/tomoyo.c
> +++ b/security/tomoyo/tomoyo.c
> @@ -287,13 +287,15 @@ static int tomoyo_path_link(struct dentry *old_dentry, struct path *new_dir,
>   * @old_dentry: Pointer to "struct dentry".
>   * @new_parent: Pointer to "struct path".
>   * @new_dentry: Pointer to "struct dentry".
> + * @flags:      Rename flags.
>   *
>   * Returns 0 on success, negative value otherwise.
>   */
>  static int tomoyo_path_rename(struct path *old_parent,
>  			      struct dentry *old_dentry,
>  			      struct path *new_parent,
> -			      struct dentry *new_dentry)
> +			      struct dentry *new_dentry,
> +			      unsigned int flags)
>  {
>  	struct path path1 = { old_parent->mnt, old_dentry };
>  	struct path path2 = { new_parent->mnt, new_dentry };
