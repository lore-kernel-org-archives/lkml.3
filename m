Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab3CTPA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:00:27 -0400
Received: from nm1-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.94]:23804
	"EHLO nm1-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757336Ab3CTPAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:00:24 -0400
X-Yahoo-Newman-Id: 85992.73205.bm@smtp104.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Za0pbrkVM1n.l6zMA1tCXtfXj8Rcx_ZViSaFioRYWBqOupI
 nFbuhNjmaUXXcuq.UROOVD57s8y1YCwkbzGwnIneWGkZTvfBEs9WPNC.Oqh4
 zEi0XwCaJtLCwdwfz17TDdZ_Ue8LAZQxLLaR8hEuYvYCT7pntyFi3dgEs9Ov
 TajaAQtF6MWGKZMc3VK_hz5khpuAq_uabYNc65vY8VOplQq6n.CEOxYyDrrG
 BlkHYphLahq3Q1uxClQ.KbPDFe2R.pJl_JaNoRzmzakznhh_lcrDay1GQjLZ
 zQjOCqBJ731b11Ywy0N_kYnet0.oc8M7RSLZqAR_V5pMNXFmuzl119QR.qv5
 .Aas0DjYPVHGU5ZLBoLXCXYwQVlg0vFBRpdeTsjwABdhwlOgAvGctHLtCOob
 FD4CSciUddgaRfxUra5aMA6wsinfnOaUYfKf07K9TD6407_J9dmGQ14C_1EG
 UIAuEbmTy30HMqRc.W3lhEMECzRC970.MNPVsC6jnQhXm_.MrlfV7aMfv7kd
 FLY_UC2QnxRSO1HJiZ5hyVZ.vnkJVHXFydEafrcFsVPa1XN7Zsftb
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@50.131.111.212 with plain)
        by smtp104.biz.mail.ne1.yahoo.com with SMTP; 20 Mar 2013 08:00:22 -0700 PDT
Message-ID: <5149CF0F.1000204@schaufler-ca.com>
Date: Wed, 20 Mar 2013 08:00:31 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Igor Zhbanov <i.zhbanov@samsung.com>
CC: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] Fix common_audit_data type for smack_inode_unlink() and
 smack_inode_rmdir()
References: <1363002636-14158-1-git-send-email-i.zhbanov@samsung.com>
In-Reply-To: <1363002636-14158-1-git-send-email-i.zhbanov@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/2013 4:50 AM, Igor Zhbanov wrote:
> This patch fixes kernel Oops because of wrong common_audit_data type
> in smack_inode_unlink() and smack_inode_rmdir().
>
> When SMACK security module is enabled and SMACK logging is on (/smack/logging
> is not zero) and you try to delete the file which
> 1) you cannot delete due to SMACK rules and logging of failures is on
> or
> 2) you can delete and logging of success is on,
>
> you will see following:
>
> 	Unable to handle kernel NULL pointer dereference at virtual address 000002d7
>
> 	[<...>] (strlen+0x0/0x28)
> 	[<...>] (audit_log_untrustedstring+0x14/0x28)
> 	[<...>] (common_lsm_audit+0x108/0x6ac)
> 	[<...>] (smack_log+0xc4/0xe4)
> 	[<...>] (smk_curacc+0x80/0x10c)
> 	[<...>] (smack_inode_unlink+0x74/0x80)
> 	[<...>] (security_inode_unlink+0x2c/0x30)
> 	[<...>] (vfs_unlink+0x7c/0x100)
> 	[<...>] (do_unlinkat+0x144/0x16c)
>
> The function smack_inode_unlink() (and smack_inode_rmdir()) need
> to log two structures of different types. First of all it does:
>
> 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_DENTRY);
> 	smk_ad_setfield_u_fs_path_dentry(&ad, dentry);
>
> This will set common audit data type to LSM_AUDIT_DATA_DENTRY
> and store dentry for auditing (by function smk_curacc(), which in turn calls
> dump_common_audit_data(), which is actually uses provided data and logs it).
>
> 	/*
> 	 * You need write access to the thing you're unlinking
> 	 */
> 	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE, &ad);
> 	if (rc == 0) {
> 		/*
> 		 * You also need write access to the containing directory
> 		 */
>
> Then this function wants to log anoter data:
>
> 		smk_ad_setfield_u_fs_path_dentry(&ad, NULL);
> 		smk_ad_setfield_u_fs_inode(&ad, dir);
>
> The function sets inode field, but don't change common_audit_data type.
>
> 		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE, &ad);
> 	}
>
> So the dump_common_audit() function incorrectly interprets inode structure
> as dentry, and Oops will happen.
>
> This patch reinitializes common_audit_data structures with correct type.
> Also I removed unneeded
> 	smk_ad_setfield_u_fs_path_dentry(&ad, NULL);
> initialization, because both dentry and inode pointers are stored
> in the same union.
>
> Signed-off-by: Igor Zhbanov <i.zhbanov@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Applied to git://git.gitorious.org/smack-next/kernel.git#stage-for-3.10

> ---
>  security/smack/smack_lsm.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index fa64740..d52c780 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -654,7 +654,7 @@ static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
>  		/*
>  		 * You also need write access to the containing directory
>  		 */
> -		smk_ad_setfield_u_fs_path_dentry(&ad, NULL);
> +		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_INODE);
>  		smk_ad_setfield_u_fs_inode(&ad, dir);
>  		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE, &ad);
>  	}
> @@ -685,7 +685,7 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
>  		/*
>  		 * You also need write access to the containing directory
>  		 */
> -		smk_ad_setfield_u_fs_path_dentry(&ad, NULL);
> +		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_INODE);
>  		smk_ad_setfield_u_fs_inode(&ad, dir);
>  		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE, &ad);
>  	}

