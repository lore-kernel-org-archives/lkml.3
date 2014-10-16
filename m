Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaJPHIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:08:00 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:40460
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaJPHH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:07:57 -0400
Date: Thu, 16 Oct 2014 09:07:55 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Rohit <rohit.kr@samsung.com>
Cc: akpm@linux-foundation.org, casey@schaufler-ca.com,
        james.l.morris@oracle.com, serge@hallyn.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpgs@samsung.com, pintu.k@samsung.com, vishnu.ps@samsung.com,
        iqbal.ams@samsung.com, ed.savinay@samsung.com
Subject: Re: [PATCH v2] Security: smack: replace kzalloc with kmem_cache for
 inode_smack
Message-ID: <20141016070755.GA28226@mail.hallyn.com>
References: <1413375041-29741-1-git-send-email-rohit.kr@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413375041-29741-1-git-send-email-rohit.kr@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rohit (rohit.kr@samsung.com):
> The patch use kmem_cache to allocate/free inode_smack since they are
> alloced in high volumes making it a perfect case for kmem_cache.
> 
> As per analysis, 24 bytes of memory is wasted per allocation due
> to internal fragmentation. With kmem_cache, this can be avoided.
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

Seems sensible.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

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
> -- 
> 1.7.9.5
