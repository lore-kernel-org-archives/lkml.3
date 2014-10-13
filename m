Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaJMRdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 13:33:25 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51040 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbaJMRdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 13:33:23 -0400
Message-ID: <1413221597.13530.17.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v3 4/6] integrity: provide hook to load keys when rootfs
 is ready
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Mon, 13 Oct 2014 13:33:17 -0400
In-Reply-To: <d9c99743a6010aebdea29a9966030e56b84b7418.1412950047.git.d.kasatkin@samsung.com>
References: <cover.1412950047.git.d.kasatkin@samsung.com>
	 <d9c99743a6010aebdea29a9966030e56b84b7418.1412950047.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101317-0025-0000-0000-000005535CD4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 17:09 +0300, Dmitry Kasatkin wrote: 
> Keys can only be loaded when rootfs is mounted. Initcalls
> are not suitable for that. Provide a special hook.

This patch description needs to be expanded a bit.  Please include an
explanation as to why the keys need to be loaded here, before accessing
any file, and why it is safe to do so.  (This information can be taken
from the cover letter.)

thanks,

Mimi

> Changes in v2:
> * Hook renamed as 'integrity_load_keys()' to handle both IMA and EVM
>   keys by integrity subsystem.
> * Hook patch moved after defining loading functions
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  include/linux/integrity.h |  6 ++++++
>  init/main.c               |  6 +++++-
>  security/integrity/iint.c | 11 +++++++++++
>  3 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/integrity.h b/include/linux/integrity.h
> index 83222ce..c2d6082 100644
> --- a/include/linux/integrity.h
> +++ b/include/linux/integrity.h
> @@ -24,6 +24,7 @@ enum integrity_status {
>  #ifdef CONFIG_INTEGRITY
>  extern struct integrity_iint_cache *integrity_inode_get(struct inode *inode);
>  extern void integrity_inode_free(struct inode *inode);
> +extern void __init integrity_load_keys(void);
> 
>  #else
>  static inline struct integrity_iint_cache *
> @@ -36,5 +37,10 @@ static inline void integrity_inode_free(struct inode *inode)
>  {
>  	return;
>  }
> +
> +static inline void integrity_load_keys(void)
> +{
> +}
>  #endif /* CONFIG_INTEGRITY */
> +
>  #endif /* _LINUX_INTEGRITY_H */
> diff --git a/init/main.c b/init/main.c
> index e8ae1fe..2c1928d 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -78,6 +78,7 @@
>  #include <linux/context_tracking.h>
>  #include <linux/random.h>
>  #include <linux/list.h>
> +#include <linux/integrity.h>
> 
>  #include <asm/io.h>
>  #include <asm/bugs.h>
> @@ -1026,8 +1027,11 @@ static noinline void __init kernel_init_freeable(void)
>  	 * Ok, we have completed the initial bootup, and
>  	 * we're essentially up and running. Get rid of the
>  	 * initmem segments and start the user-mode stuff..
> +	 *
> +	 * rootfs is available now, try loading the public keys
> +	 * and default modules
>  	 */
> 
> -	/* rootfs is available now, try loading default modules */
> +	integrity_load_keys();
>  	load_default_modules();
>  }
> diff --git a/security/integrity/iint.c b/security/integrity/iint.c
> index 0a76686..a1f5cd1 100644
> --- a/security/integrity/iint.c
> +++ b/security/integrity/iint.c
> @@ -245,3 +245,14 @@ out:
>  	fput(file);
>  	return rc;
>  }
> +
> +/*
> + * integrity_load_keys - load integrity keys hook
> + *
> + * Hooks is called from init/main.c:kernel_init_freeable()
> + * when rootfs is ready
> + */
> +void __init integrity_load_keys(void)
> +{
> +	ima_load_x509();
> +}


