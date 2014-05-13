Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaEMTtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:49:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35214 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbaEMTtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:49:16 -0400
Date: Tue, 13 May 2014 21:49:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@suse.de,
        m.chehab@samsung.com, linux-edac@vger.kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 5/7] acpi, apei, ghes: Attach NMI init/deinit functions
 while CONFIG_ACPI_APEI_NMI is enabled.
Message-ID: <20140513194906.GE8760@pd.tnic>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
 <1397056476-9183-6-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1397056476-9183-6-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 05:14:33PM +0200, Tomasz Nowicki wrote:
> Thanks to more generic way of init/deinit error notification, we can
> register NMI related calls in runtime. It happens before walking through
> GHES entries, so probe function will treat NMI as supported.

And we do this special handling which could confuse people because... ?

> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
>  drivers/acpi/apei/ghes.c |   21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 7a0d66e..aaf8db3 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -906,7 +906,6 @@ static void ghes_estatus_pool_shrink(unsigned long len)
>  {
>  	ghes_estatus_pool_size_request -= PAGE_ALIGN(len);
>  }
> -#endif
>  
>  static int ghes_notify_init_nmi(struct ghes *ghes)
>  {
> @@ -941,6 +940,20 @@ static void ghes_notify_remove_nmi(struct ghes *ghes)
>  	ghes_estatus_pool_shrink(len);
>  }
>  
> +static void ghes_init_nmi(void)
> +{
> +	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
> +	ghes_notify_tab[ACPI_HEST_NOTIFY_NMI].init_call = ghes_notify_init_nmi;
> +	ghes_notify_tab[ACPI_HEST_NOTIFY_NMI].remove_call = ghes_notify_remove_nmi;
> +
> +}
> +#else
> +inline static void ghes_init_nmi(void)
> +{
> +
> +}
> +#endif

WARNING: storage class should be at the beginning of the declaration
#51: FILE: drivers/acpi/apei/ghes.c:951:
+inline static void ghes_init_nmi(void)

ERROR: inline keyword should sit between storage class and type
#51: FILE: drivers/acpi/apei/ghes.c:951:
+inline static void ghes_init_nmi(void)

i.e..

static inline void ...

> +
>  static int ghes_notify_init_polled(struct ghes *ghes)
>  {
>  	ghes->timer.function = ghes_poll_func;
> @@ -1018,9 +1031,7 @@ static struct ghes_notify_setup
>  		[ACPI_HEST_NOTIFY_SCI]      = {"SCI",
>  					       ghes_notify_init_sci,
>  					       ghes_notify_remove_sci},
> -		[ACPI_HEST_NOTIFY_NMI]      = {"NMI",
> -					       ghes_notify_init_nmi,
> -					       ghes_notify_remove_nmi},
> +		[ACPI_HEST_NOTIFY_NMI]      = {"NMI", NULL, NULL},
>  		[ACPI_HEST_NOTIFY_CMCI]     = {"CMCI", NULL, NULL},
>  		[ACPI_HEST_NOTIFY_MCE]      = {"MCE", NULL, NULL},
>  };
> @@ -1141,7 +1152,7 @@ static int __init ghes_init(void)
>  		return -EINVAL;
>  	}
>  
> -	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
> +	ghes_init_nmi();
>  
>  	rc = ghes_ioremap_init();
>  	if (rc)
> -- 
> 1.7.9.5
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
