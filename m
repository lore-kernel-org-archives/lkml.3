Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbaEELou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 07:44:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50029 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180AbaEELos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 07:44:48 -0400
Date: Mon, 5 May 2014 13:44:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@suse.de,
        m.chehab@samsung.com, linux-edac@vger.kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 1/7] apei, mce: Call MCE-specific code only for X86
 architecture.
Message-ID: <20140505114445.GB4373@pd.tnic>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
 <1397056476-9183-2-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1397056476-9183-2-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 05:14:29PM +0200, Tomasz Nowicki wrote:
> This commit is dealing with MCE code in:
> - hest.c
> Move acpi_disable_cmcff flag to hest_parse_cmc() and makes
> that depend on CONFIG_X86_MCE so that we do not have to maintain
> acpi_disable_cmcff for architectures which do not support MCE.
> Also, wrap architectural MCE header inside #ifdef CONFIG_X86_MCE.
> 
> - ghes.c
> Wrap architectural MCE header inside #ifdef CONFIG_X86_MCE similar to rest
> of the MCE code in this file.
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
>  drivers/acpi/apei/ghes.c |    2 ++
>  drivers/acpi/apei/hest.c |    8 ++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index dab7cb7..f7edffc 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -49,7 +49,9 @@
>  #include <linux/aer.h>
>  
>  #include <acpi/ghes.h>
> +#ifdef CONFIG_X86_MCE
>  #include <asm/mce.h>
> +#endif
>  #include <asm/tlbflush.h>
>  #include <asm/nmi.h>
>  
> diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
> index f5e37f3..98db702 100644
> --- a/drivers/acpi/apei/hest.c
> +++ b/drivers/acpi/apei/hest.c
> @@ -36,7 +36,9 @@
>  #include <linux/io.h>
>  #include <linux/platform_device.h>
>  #include <acpi/apei.h>
> +#ifdef CONFIG_X86_MCE
>  #include <asm/mce.h>
> +#endif

Actually, I would prefer if you wrapped all the arch-specific calls into
arch-specific functions, say, convert

apei_mce_report_mem_error -> apei_arch_report_mem_error

and have default empty functions for arches which don't use that
functionality.

This way you can save yourself the ugly ifdeffery around the place.

>  
>  #include "apei-internal.h"
>  
> @@ -133,6 +135,9 @@ static int __init hest_parse_cmc(struct acpi_hest_header *hest_hdr, void *data)
>  	struct acpi_hest_ia_corrected *cmc;
>  	struct acpi_hest_ia_error_bank *mc_bank;
>  
> +	if (acpi_disable_cmcff)
> +		return 1;

This could be

	if (arch_disable_cmcff())
		return 1;

with the default stub being

static inline bool arch_disable_cmcff(void)
{
	return false;
}

and so on, like it is done in many other places in the kernel.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
