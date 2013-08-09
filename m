Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967550Ab3HILC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 07:02:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967291Ab3HILC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:02:28 -0400
Date: Fri, 9 Aug 2013 07:02:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: Disable at runtime if the kernel enforces module
 signing
Message-ID: <20130809110200.GA9631@redhat.com>
References: <1376033797-24970-1-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376033797-24970-1-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 03:36:37AM -0400, Matthew Garrett wrote:
> kexec permits the loading and execution of arbitrary code in ring 0, which
> is something that module signing enforcement is meant to prevent. It makes
> sense to disable kexec in this situation.
> 

But in the process we wipe out running kernel's context and boot into a new
kernel. So how different it is than root booting a new kernel through BIOS
which does not enforce module signing.

Also it would be nice if we introduce new features, then we make other
features work with those new features instead of disabling existing
features and leave it to other people to make them work.

Thanks
Vivek

> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  include/linux/module.h |  4 ++++
>  kernel/kexec.c         | 10 ++++++++++
>  kernel/module.c        |  4 ++--
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 46f1ea0..2871ab2 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -29,6 +29,10 @@
>  
>  #define MODULE_NAME_LEN MAX_PARAM_PREFIX_LEN
>  
> +#ifdef CONFIG_MODULE_SIG
> +extern bool sig_enforce;
> +#endif
> +
>  struct modversion_info
>  {
>  	unsigned long crc;
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 59f7b55..297a268a 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -32,6 +32,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/swap.h>
>  #include <linux/syscore_ops.h>
> +#include <linux/module.h>
>  
>  #include <asm/page.h>
>  #include <asm/uaccess.h>
> @@ -1645,6 +1646,15 @@ int kernel_kexec(void)
>  		goto Unlock;
>  	}
>  
> +#ifdef CONFIG_MODULE_SIG
> +	/*
> +	 * Kexec makes it trivial to evade module signing, so forbid it when
> +	 * the kernel requires signatures
> +	 */
> +	if (sig_enforce)
> +		return -EPERM;
> +#endif
> +
>  #ifdef CONFIG_KEXEC_JUMP
>  	if (kexec_image->preserve_context) {
>  		lock_system_sleep();
> diff --git a/kernel/module.c b/kernel/module.c
> index 2069158..58f6e21 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -109,9 +109,9 @@ struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
>  
>  #ifdef CONFIG_MODULE_SIG
>  #ifdef CONFIG_MODULE_SIG_FORCE
> -static bool sig_enforce = true;
> +bool sig_enforce = true;
>  #else
> -static bool sig_enforce = false;
> +bool sig_enforce = false;
>  
>  static int param_set_bool_enable_only(const char *val,
>  				      const struct kernel_param *kp)
> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
