Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaJPQar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:30:47 -0400
Received: from smtp103.biz.mail.bf1.yahoo.com ([98.139.221.62]:25026 "EHLO
	smtp103.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231AbaJPQaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:30:46 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Oct 2014 12:30:46 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: t9wCkdIVM1mhlOmn7jGGMIIrzTAJZUJAqK9yRQpNK0RMk5Y
 U6usTevUwy9Hl655F.TgEdaZiqleEeszGc.TlcKJXD_zjVvJagSS0v2d1G7d
 MWUVhPTseVd6aF_sNCfkCF8H6PMKXFJ12kk6gXMgIqeP5Qf8dC_YcPpQ_Ygg
 zW_iE1BkmiascsfX.rk3G3toGbMdaQ060IkGzGtKpvUeYKmbZzEQkQ135y4d
 Wf7tsNM6wLgHTzKDBfeuUq6M1bbj2fEvmyZzOQ_VlLMKfwYfLDuU4GeSxBWv
 M2RrTS0Wa95S7sTf7oQycjx21_fHLaXHY4caOwLniq.njfjcHIS_V3Ci9X1a
 9ytKKYPeWpGcf_rnetebJkGO1r71.X4mRGyG36ZO79jcEbrV.fM5zAaBnLJq
 GLf4lF4MCRZOTMUnHxHP9kvix8JPkKgGV85WIz0If72qDaJS7YjUSWoEZz_7
 gToL4laFbgOxUiWnds_I_B6fuNsDKSG2NuOvdlu0O7Y1ISCg9c72fEAz7v8c
 ecMmi92skZlSIRL_qbHsYgxdv1NjQfodCViii9hSRyMHWmySqZyTUYF.KGFc
 Exu9VrW8U2pS.zXWiu2RcGE5Bb33keC1FbVtfmTwpDNMGxgu12NnGC0RO71s
 sXLfSKWID
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <543FF121.7000502@schaufler-ca.com>
Date: Thu, 16 Oct 2014 09:24:01 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rohit <rohit.kr@samsung.com>, akpm@linux-foundation.org,
        james.l.morris@oracle.com, serge@hallyn.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
CC: cpgs@samsung.com, pintu.k@samsung.com, vishnu.ps@samsung.com,
        iqbal.ams@samsung.com, ed.savinay@samsung.com
Subject: Re: [PATCH v2] Security: smack: replace kzalloc with kmem_cache for
 inode_smack
References: <1413375041-29741-1-git-send-email-rohit.kr@samsung.com>
In-Reply-To: <1413375041-29741-1-git-send-email-rohit.kr@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 5:10 AM, Rohit wrote:
> The patch use kmem_cache to allocate/free inode_smack since they are
> alloced in high volumes making it a perfect case for kmem_cache.
>
> As per analysis, 24 bytes of memory is wasted per allocation due
> to internal fragmentation. With kmem_cache, this can be avoided.

What impact does this have on performance? I am much more
concerned with speed than with small amount of memory.

>
> Accounting of memory allocation is below :
>  total       slack            net      count-alloc/free        caller
> Before (with kzalloc)
> 1919872      719952          1919872      29998/0          new_inode_smack+0x14
>
> After (with kmem_cache)
> 1201680          0           1201680      30042/0          new_inode_smack+0x18
>
> >From above data, we found that 719952 bytes(~700 KB) of memory is
> saved on allocation of 29998 smack inodes.
>
> Signed-off-by: Rohit <rohit.kr@samsung.com>
> ---
> Added static in kmem_cache object declaration noted by Andrew Morton <akpm@
> linux-foundation.org> . Also updated commit message.
>  security/smack/smack_lsm.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index d515ec2..15d985c 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -53,6 +53,7 @@
>  #define SMK_SENDING	2
>  
>  LIST_HEAD(smk_ipv6_port_list);
> +static struct kmem_cache *smack_inode_cache;
>  
>  #ifdef CONFIG_SECURITY_SMACK_BRINGUP
>  static void smk_bu_mode(int mode, char *s)
> @@ -240,7 +241,7 @@ struct inode_smack *new_inode_smack(struct smack_known *skp)
>  {
>  	struct inode_smack *isp;
>  
> -	isp = kzalloc(sizeof(struct inode_smack), GFP_NOFS);
> +	isp = kmem_cache_zalloc(smack_inode_cache, GFP_NOFS);
>  	if (isp == NULL)
>  		return NULL;
>  
> @@ -767,7 +768,7 @@ static int smack_inode_alloc_security(struct inode *inode)
>   */
>  static void smack_inode_free_security(struct inode *inode)
>  {
> -	kfree(inode->i_security);
> +	kmem_cache_free(smack_inode_cache, inode->i_security);
>  	inode->i_security = NULL;
>  }
>  
> @@ -4264,10 +4265,16 @@ static __init int smack_init(void)
>  	if (!security_module_enable(&smack_ops))
>  		return 0;
>  
> +	smack_inode_cache = KMEM_CACHE(inode_smack, 0);
> +	if (!smack_inode_cache)
> +		return -ENOMEM;
> +
>  	tsp = new_task_smack(&smack_known_floor, &smack_known_floor,
>  				GFP_KERNEL);
> -	if (tsp == NULL)
> +	if (tsp == NULL) {
> +		kmem_cache_destroy(smack_inode_cache);
>  		return -ENOMEM;
> +	}
>  
>  	printk(KERN_INFO "Smack:  Initializing.\n");
>  

