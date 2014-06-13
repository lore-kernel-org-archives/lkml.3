Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaFMNgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:36:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:36094 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbaFMNgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:36:09 -0400
Date: Fri, 13 Jun 2014 15:35:59 +0200
From: Robert Richter <rric@kernel.org>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        m.chehab@samsung.com, bp@suse.de, linux-edac@vger.kernel.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v3 5/5] acpi, apei, ghes: Factor out ioremap virtual
 memory for IRQ and NMI context.
Message-ID: <20140613133559.GB27560@rric.localhost>
References: <1402657380-18539-1-git-send-email-tomasz.nowicki@linaro.org>
 <1402657380-18539-6-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402657380-18539-6-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.06.14 13:03:00, Tomasz Nowicki wrote:
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 21aeac5..93a4d0b 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -113,12 +113,11 @@ static DEFINE_RAW_SPINLOCK(ghes_nmi_lock);
>   */
>  
>  /*
> - * Two virtual pages are used, one for NMI context, the other for
> - * IRQ/PROCESS context
> + * Two virtual pages are used, one for IRQ/PROCESS context, the other for
> + * NMI context (optionally).
>   */
> -#define GHES_IOREMAP_PAGES		2
> -#define GHES_IOREMAP_NMI_PAGE(base)	(base)
> -#define GHES_IOREMAP_IRQ_PAGE(base)	((base) + PAGE_SIZE)
> +#define GHES_IOREMAP_IRQ_PAGE(base)	(base)
> +#define GHES_IOREMAP_NMI_PAGE(base)	((base) + PAGE_SIZE)
>  
>  /* virtual memory area for atomic ioremap */
>  static struct vm_struct *ghes_ioremap_area;
> @@ -155,7 +154,8 @@ static struct ghes_notify_setup	ghes_notify_tab[];
>  
>  static int ghes_ioremap_init(void)
>  {
> -	ghes_ioremap_area = __get_vm_area(PAGE_SIZE * GHES_IOREMAP_PAGES,
> +	ghes_ioremap_area = __get_vm_area(
> +		PAGE_SIZE * (IS_ENABLED(ARCH_HAS_ACPI_APEI_NMI) ? 2 : 1),

Use this instead above:

#ifdef ARCH_HAS_ACPI_APEI_NMI
#define GHES_IOREMAP_PAGES           2
#else
#define GHES_IOREMAP_PAGES           1
#endif

Otherwise this patch looks fine to me.

-Robert
