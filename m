Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab3ENCux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:50:53 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41864 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3ENCuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:50:50 -0400
Date: Mon, 13 May 2013 19:50:52 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 1/3] evm: calculate HMAC after initializing posix acl
In-Reply-To: <1366805441-12187-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1305131946400.1019@eggly.anvils>
References: <1366805441-12187-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013, Mimi Zohar wrote:
> (Reposting with expanded 'cc' list.)
> 
> Included in the EVM hmac calculation is the i_mode.  Any changes to
> the i_mode need to be reflected in the hmac.  shmem_mknod() currently
> calls posix_acl_init(), which modifies the i_mode, after calling

        generic_acl_init()

> security_inode_init_security().  This patch reverses the order in
> which they are called.
> 
> Reported-by: Sven Vermeulen <sven.vermeulen@siphos.be>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Acked-by: Hugh Dickins <hughd@google.com>

> ---
>  mm/shmem.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 1c44af7..398c195 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1937,6 +1937,13 @@ shmem_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
>  
>  	inode = shmem_get_inode(dir->i_sb, dir, mode, dev, VM_NORESERVE);
>  	if (inode) {
> +#ifdef CONFIG_TMPFS_POSIX_ACL
> +		error = generic_acl_init(inode, dir);
> +		if (error) {
> +			iput(inode);
> +			return error;
> +		}
> +#endif
>  		error = security_inode_init_security(inode, dir,
>  						     &dentry->d_name,
>  						     shmem_initxattrs, NULL);
> @@ -1946,15 +1953,8 @@ shmem_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
>  				return error;
>  			}
>  		}
> -#ifdef CONFIG_TMPFS_POSIX_ACL
> -		error = generic_acl_init(inode, dir);
> -		if (error) {
> -			iput(inode);
> -			return error;
> -		}
> -#else
> +
>  		error = 0;
> -#endif
>  		dir->i_size += BOGO_DIRENT_SIZE;
>  		dir->i_ctime = dir->i_mtime = CURRENT_TIME;
>  		d_instantiate(dentry, inode);
> -- 
> 1.8.1.rc3
