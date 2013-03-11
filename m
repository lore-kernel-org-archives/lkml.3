Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3CKRUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:20:19 -0400
Received: from nm12.access.bullet.mail.mud.yahoo.com ([66.94.237.213]:27736
	"EHLO nm12.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379Ab3CKRUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:20:16 -0400
X-Yahoo-Newman-Id: 918138.94794.bm@smtp104.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _viQmpsVM1lq2vIbjHpGxUu2D3QcqR71zM4aR5eUm4Ici9v
 CQVK.y72VgAKEfQWJ1SjtqZCCHywzGPYFc6dUyvQbHLOxyhntKpNuoTdlSh8
 gAmUwcazyI05wav0H2FWIbRE_oYNysM8niH91TONF.E2yHTN1B_O_eFVeJ8Y
 _E825P7HlOvr.gv9zHezpQpYFqOcBcw9EdYIEgHIB6df4I7yyuND9Oha5Lfo
 EoIkqvMtaRSEIEwkdca_MwesiTVCrlTb68Jhqc.pC621DHN7tnqlYiwOy0Z6
 Q2319WngpWGlH3UhDdSq6qFu93U_AEkqwN.h_G5YnqSMlns3CXyLENDm3iTp
 FuG0K_DEjIpLAF5MoUwTSH7EMUmeoBFtaSjlfqgDikQHLTNwArcLyi6ltPyT
 BA5U1JNHsCVupJ6mmaLHrq.z0UnbzYjv7r0aSh1fq5c93td0IDecSTmEYRKv
 KKaSD
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <513E124C.3050502@schaufler-ca.com>
Date: Mon, 11 Mar 2013 10:20:12 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Igor Zhbanov <i.zhbanov@samsung.com>
CC: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Casey Schaufler <casey@schaufler-ca.com>
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

This patch does not apply to any tree I have. The lines:

	smk_ad_setfield_u_fs_path_dentry(&ad, NULL);

that the patch is deleting are not present. Can you make
sure that the patch applies to Linus' tree and resubmit?

Thank you.

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

