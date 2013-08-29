Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3H2PBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:01:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab3H2PBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:01:53 -0400
Date: Thu, 29 Aug 2013 11:01:46 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org
Subject: Re: [PATCH V2 01/10] Add secure_modules() call
Message-ID: <20130829150146.GR20828@hansolo.jdub.homelinux.org>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
 <1376933171-9854-2-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376933171-9854-2-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 01:26:02PM -0400, Matthew Garrett wrote:
> Provide a single call to allow kernel code to determine whether the system
> has been configured to either disable module loading entirely or to load
> only modules signed with a trusted key.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  include/linux/module.h | 7 +++++++
>  kernel/module.c        | 9 +++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 46f1ea0..0c266b2 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -509,6 +509,8 @@ int unregister_module_notifier(struct notifier_block * nb);
>  
>  extern void print_modules(void);
>  
> +extern bool secure_modules(void);
> +
>  #else /* !CONFIG_MODULES... */
>  
>  /* Given an address, look for it in the exception tables. */
> @@ -619,6 +621,11 @@ static inline int unregister_module_notifier(struct notifier_block * nb)
>  static inline void print_modules(void)
>  {
>  }
> +
> +static inline bool secure_modules(void)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_MODULES */
>  
>  #ifdef CONFIG_SYSFS
> diff --git a/kernel/module.c b/kernel/module.c
> index 2069158..801021e 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3852,3 +3852,12 @@ void module_layout(struct module *mod,
>  }
>  EXPORT_SYMBOL(module_layout);
>  #endif
> +
> +bool secure_modules(void)
> +{
> +#ifdef CONFIG_MODULE_SIG
> +	return (sig_enforce || modules_disabled);
> +#else
> +	return modules_disabled;
> +#endif
> +}

Needs an EXPORT_SYMBOL/EXPORT_SYMBOL_GPL here, or the patches to drivers
later in the series will fail to link.

josh
