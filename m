Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab3DXRAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 13:00:40 -0400
Received: from nm19-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.172]:34581
	"EHLO nm19-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258Ab3DXRAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 13:00:38 -0400
X-Yahoo-Newman-Id: 424420.51521.bm@smtp110.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rvvTV7sVM1lGV8tCUW2aiBSOdXxQWYb0g2SeVtgBsy3auXF
 uCKE3d0WZx9VMkqdLRoWKkKcPBt6_hZR397wcltEBU6mUv25P1sT_MHw843B
 pRLyE8MlfpkrC42FUitDi_07KndAOCRLCsN9K1ieUgZlLVSq53v_F5VFbTZR
 ntxzV_jIuoxWMe_2BEIwo36eMjpZGBLIazc4yLIucRNN.9PaMJI1p0R0nchk
 hyTPtNtzKVi5m0Gnmk5XvkHTVqnOjZfrLSM.W_OZck4vtrAeYgz8DdT0XaFV
 xyTDxNdhiv.bFBV2D8eAdEJ7QB9Gz1e1tKhML57B8D8MHhFrnFiK70P9vUrN
 HfTnfYAB.NjyoHqzUkloHhNEGk3uMUqPo87QyVV91KM8L1exGXFj4dva45ot
 Cqb34KdSAWIqUbpwHgHXVdmViQjg6GI.PGEu2gWa0UMWZ9GKl3qAOS9II7mF
 t
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp110.biz.mail.ne1.yahoo.com with SMTP; 24 Apr 2013 10:00:38 -0700 PDT
Message-ID: <51780FB7.2010202@schaufler-ca.com>
Date: Wed, 24 Apr 2013 10:00:39 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: linux-security-module@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 1/3] evm: calculate HMAC after initializing posix acl
References: <1366805441-12187-1-git-send-email-zohar@linux.vnet.ibm.com>
In-Reply-To: <1366805441-12187-1-git-send-email-zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/2013 5:10 AM, Mimi Zohar wrote:
> (Reposting with expanded 'cc' list.)
>
> Included in the EVM hmac calculation is the i_mode.  Any changes to
> the i_mode need to be reflected in the hmac.  shmem_mknod() currently
> calls posix_acl_init(), which modifies the i_mode, after calling
> security_inode_init_security().  This patch reverses the order in
> which they are called.

I haven't tried this with Smack, but I don't anticipate any issues.

> Reported-by: Sven Vermeulen <sven.vermeulen@siphos.be>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
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

