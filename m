Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaILRNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:13:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59513 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaILRNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:13:34 -0400
Date: Fri, 12 Sep 2014 17:13:05 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] vfs,userns: Ensure real root is always capable
 towards inodes
Message-ID: <20140912171305.GI26117@ubuntumail>
References: <1410532905-114262-1-git-send-email-seth.forshee@canonical.com>
 <1410532905-114262-3-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410532905-114262-3-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Seth Forshee (seth.forshee@canonical.com):
> Currently root is restricted from performing some modifications
> to inodes whose owner is INVALID_UID or group is INVALID_GID
> because this id doesn't map into any user namespace. Add a
> special case to the relevant checks to make sure root is always
> capable of performing these operations.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

(A case which was previously not possible.)

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  fs/inode.c          | 3 +++
>  kernel/capability.c | 6 +++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 26753ba7b6d6..1029320ff029 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1840,6 +1840,9 @@ bool inode_owner_or_capable(const struct inode *inode)
>  {
>  	struct user_namespace *ns;
>  
> +	if (capable(CAP_SYS_ADMIN))
> +		return true;
> +
>  	if (uid_eq(current_fsuid(), inode->i_uid))
>  		return true;
>  
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 989f5bfc57dc..a472eaa52b6a 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -438,8 +438,12 @@ EXPORT_SYMBOL(capable);
>   */
>  bool capable_wrt_inode_uidgid(const struct inode *inode, int cap)
>  {
> -	struct user_namespace *ns = current_user_ns();
> +	struct user_namespace *ns;
>  
> +	if (capable(CAP_SYS_ADMIN))
> +		return true;
> +
> +	ns = current_user_ns();
>  	return ns_capable(ns, cap) && kuid_has_mapping(ns, inode->i_uid) &&
>  		kgid_has_mapping(ns, inode->i_gid);
>  }
> -- 
> 1.9.1
> 
