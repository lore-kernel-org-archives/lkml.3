Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbaFWQOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:14:11 -0400
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:57528 "EHLO
	emvm-gh1-uea08.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149AbaFWQOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:14:10 -0400
X-TM-IMSS-Message-ID: <09df6f780000b1d4@nsa.gov>
Message-ID: <53A8523B.3080305@tycho.nsa.gov>
Date: Mon, 23 Jun 2014 12:13:47 -0400
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v3] selinux: no recursive read_lock of policy_rwlock in
 security_genfs_sid()
References: <1403537331-38759-1-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1403537331-38759-1-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 11:28 AM, Waiman Long wrote:
> With the introduction of fair queued rwlock, recursive read_lock()
> may hang the offending process if there is a write_lock() somewhere
> in between.
> 
> With recursive read_lock checking enabled, the following error was
> reported:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.16.0-rc1 #2 Tainted: G            E
> ---------------------------------------------
> load_policy/708 is trying to acquire lock:
>  (policy_rwlock){.+.+..}, at: [<ffffffff8125b32a>]
> security_genfs_sid+0x3a/0x170
> 
> but task is already holding lock:
>  (policy_rwlock){.+.+..}, at: [<ffffffff8125b48c>]
> security_fs_use+0x2c/0x110
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(policy_rwlock);
>   lock(policy_rwlock);
> 
> This patch fixes the occurrence of recursive read_lock() of
> policy_rwlock by adding a helper function __security_genfs_sid()
> which requires caller to take the lock before calling it. The
> security_fs_use() was then modified to call the new helper function.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

> ---
>  security/selinux/ss/services.c |   41 +++++++++++++++++++++++++++++++--------
>  1 files changed, 32 insertions(+), 9 deletions(-)
> 
> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> index 4bca494..2aa9d17 100644
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -2277,7 +2277,7 @@ out:
>  }
>  
>  /**
> - * security_genfs_sid - Obtain a SID for a file in a filesystem
> + * __security_genfs_sid - Helper to obtain a SID for a file in a filesystem
>   * @fstype: filesystem type
>   * @path: path from root of mount
>   * @sclass: file security class
> @@ -2286,11 +2286,13 @@ out:
>   * Obtain a SID to use for a file in a filesystem that
>   * cannot support xattr or use a fixed labeling behavior like
>   * transition SIDs or task SIDs.
> + *
> + * The caller must acquire the policy_rwlock before calling this function.
>   */
> -int security_genfs_sid(const char *fstype,
> -		       char *path,
> -		       u16 orig_sclass,
> -		       u32 *sid)
> +static inline int __security_genfs_sid(const char *fstype,
> +				       char *path,
> +				       u16 orig_sclass,
> +				       u32 *sid)
>  {
>  	int len;
>  	u16 sclass;
> @@ -2301,8 +2303,6 @@ int security_genfs_sid(const char *fstype,
>  	while (path[0] == '/' && path[1] == '/')
>  		path++;
>  
> -	read_lock(&policy_rwlock);
> -
>  	sclass = unmap_class(orig_sclass);
>  	*sid = SECINITSID_UNLABELED;
>  
> @@ -2336,11 +2336,33 @@ int security_genfs_sid(const char *fstype,
>  	*sid = c->sid[0];
>  	rc = 0;
>  out:
> -	read_unlock(&policy_rwlock);
>  	return rc;
>  }
>  
>  /**
> + * security_genfs_sid - Obtain a SID for a file in a filesystem
> + * @fstype: filesystem type
> + * @path: path from root of mount
> + * @sclass: file security class
> + * @sid: SID for path
> + *
> + * Acquire policy_rwlock before calling __security_genfs_sid() and release
> + * it afterward.
> + */
> +int security_genfs_sid(const char *fstype,
> +		       char *path,
> +		       u16 orig_sclass,
> +		       u32 *sid)
> +{
> +	int retval;
> +
> +	read_lock(&policy_rwlock);
> +	retval = __security_genfs_sid(fstype, path, orig_sclass, sid);
> +	read_unlock(&policy_rwlock);
> +	return retval;
> +}
> +
> +/**
>   * security_fs_use - Determine how to handle labeling for a filesystem.
>   * @sb: superblock in question
>   */
> @@ -2370,7 +2392,8 @@ int security_fs_use(struct super_block *sb)
>  		}
>  		sbsec->sid = c->sid[0];
>  	} else {
> -		rc = security_genfs_sid(fstype, "/", SECCLASS_DIR, &sbsec->sid);
> +		rc = __security_genfs_sid(fstype, "/", SECCLASS_DIR,
> +					  &sbsec->sid);
>  		if (rc) {
>  			sbsec->behavior = SECURITY_FS_USE_NONE;
>  			rc = 0;
> 

