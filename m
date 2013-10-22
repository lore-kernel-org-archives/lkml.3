Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3JVLPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 07:15:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3JVLPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 07:15:39 -0400
Date: Tue, 22 Oct 2013 12:15:35 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [ 109/171 ] userns: Dont allow creation if the user is chrooted
Message-ID: <20131022111535.GC4263@hercules>
References: <20130411202503.783159048@goodmis.org>
 <20130411202604.189219756@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411202604.189219756@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 04:26:52PM -0400, Steven Rostedt wrote:
> 3.6.11.2 stable review patch.
> If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> [ Upstream commit 3151527ee007b73a0ebd296010f1c0454a919c7d ]

While looking at some security bugs, I came across this one
(CVE-2013-1956).  All the references I could find refer to the 3.8
kernel only, and this was the only backport I could find to older
stable kernels.

Could someone clarify if this fix should be included in other stable
kernels?  Or the only affected kernels were the 3.8.0 to 3.8.5?

Cheers,
--
Luis

> 
> Guarantee that the policy of which files may be access that is
> established by setting the root directory will not be violated by
> user namespaces by verifying that the root directory points to the
> root of the mount namespace at the time of user namespace creation.
> 
> Changing the root is a privileged operation, and as a matter of policy
> it serves to limit unprivileged processes to files below the current
> root directory.
> 
> For reasons of simplicity and comprehensibility the privilege to
> change the root directory is gated solely on the CAP_SYS_CHROOT
> capability in the user namespace.  Therefore when creating a user
> namespace we must ensure that the policy of which files may be access
> can not be violated by changing the root directory.
> 
> Anyone who runs a processes in a chroot and would like to use user
> namespace can setup the same view of filesystems with a mount
> namespace instead.  With this result that this is not a practical
> limitation for using user namespaces.
> 
> Cc: stable@vger.kernel.org
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Reported-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  fs/namespace.c            |   25 +++++++++++++++++++++++++
>  include/linux/fs_struct.h |    2 ++
>  kernel/user_namespace.c   |    9 +++++++++
>  3 files changed, 36 insertions(+)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 7bdf790..c48b0d3 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -2681,3 +2681,28 @@ bool our_mnt(struct vfsmount *mnt)
>  {
>  	return check_mnt(real_mount(mnt));
>  }
> +
> +bool current_chrooted(void)
> +{
> +	/* Does the current process have a non-standard root */
> +	struct path ns_root;
> +	struct path fs_root;
> +	bool chrooted;
> +
> +	/* Find the namespace root */
> +	ns_root.mnt = &current->nsproxy->mnt_ns->root->mnt;
> +	ns_root.dentry = ns_root.mnt->mnt_root;
> +	path_get(&ns_root);
> +	while (d_mountpoint(ns_root.dentry) && follow_down_one(&ns_root))
> +		;
> +
> +	get_fs_root(current->fs, &fs_root);
> +
> +	chrooted = !path_equal(&fs_root, &ns_root);
> +
> +	path_put(&fs_root);
> +	path_put(&ns_root);
> +
> +	return chrooted;
> +}
> +
> diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
> index 003dc0f..961cdaa 100644
> --- a/include/linux/fs_struct.h
> +++ b/include/linux/fs_struct.h
> @@ -51,4 +51,6 @@ static inline void get_fs_root_and_pwd(struct fs_struct *fs, struct path *root,
>  	spin_unlock(&fs->lock);
>  }
>  
> +extern bool current_chrooted(void);
> +
>  #endif /* _LINUX_FS_STRUCT_H */
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 8660231..a74dc5b 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -39,6 +39,15 @@ int create_user_ns(struct cred *new)
>  	kuid_t owner = new->euid;
>  	kgid_t group = new->egid;
>  
> +	/*
> +	 * Verify that we can not violate the policy of which files
> +	 * may be accessed that is specified by the root directory,
> +	 * by verifing that the root directory is at the root of the
> +	 * mount namespace which allows all files to be accessed.
> +	 */
> +	if (current_chrooted())
> +		return -EPERM;
> +
>  	/* The creator needs a mapping in the parent user namespace
>  	 * or else we won't be able to reasonably tell userspace who
>  	 * created a user_namespace.
> -- 
> 1.7.10.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
