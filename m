Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab3GRKm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:42:29 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:40449 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab3GRKm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:42:27 -0400
Date: Thu, 18 Jul 2013 12:42:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH v3] x86, tboot: iomem fixes
Message-ID: <20130718104223.GD23558@gmail.com>
References: <1374134874-8161-1-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374134874-8161-1-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Qiaowei Ren <qiaowei.ren@intel.com> wrote:

> Current code doesn't use specific interface to access I/O space.
> So some potential bugs can be caused. We can fix this by using
> specific API.

This is still very vague.

> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  arch/x86/kernel/tboot.c |   21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
> index 3ff42d2..afe8cf8 100644
> --- a/arch/x86/kernel/tboot.c
> +++ b/arch/x86/kernel/tboot.c
> @@ -466,9 +466,12 @@ struct sinit_mle_data {
>  	u32               vtd_dmars_off;
>  } __packed;
>  
> +#define SINIT_MLE_DATA_VTD_DMAR_OFF	140
> +
>  struct acpi_table_header *tboot_get_dmar_table(struct acpi_table_header *dmar_tbl)
>  {
> -	void *heap_base, *heap_ptr, *config;
> +	void __iomem *heap_base, *heap_ptr, *config;
> +	u32 dmar_tbl_off;
>  
>  	if (!tboot_enabled())
>  		return dmar_tbl;
> @@ -485,25 +488,25 @@ struct acpi_table_header *tboot_get_dmar_table(struct acpi_table_header *dmar_tb
>  		return NULL;
>  
>  	/* now map TXT heap */
> -	heap_base = ioremap(*(u64 *)(config + TXTCR_HEAP_BASE),
> -			    *(u64 *)(config + TXTCR_HEAP_SIZE));
> +	heap_base = ioremap(readl(config + TXTCR_HEAP_BASE),
> +			    readl(config + TXTCR_HEAP_SIZE));
>  	iounmap(config);
>  	if (!heap_base)
>  		return NULL;
>  
>  	/* walk heap to SinitMleData */
>  	/* skip BiosData */
> -	heap_ptr = heap_base + *(u64 *)heap_base;
> +	heap_ptr = heap_base + readq(heap_base);
>  	/* skip OsMleData */
> -	heap_ptr += *(u64 *)heap_ptr;
> +	heap_ptr += readq(heap_ptr);
>  	/* skip OsSinitData */
> -	heap_ptr += *(u64 *)heap_ptr;
> +	heap_ptr += readq(heap_ptr);
>  	/* now points to SinitMleDataSize; set to SinitMleData */
>  	heap_ptr += sizeof(u64);
>  	/* get addr of DMAR table */
> -	dmar_tbl = (struct acpi_table_header *)(heap_ptr +
> -		   ((struct sinit_mle_data *)heap_ptr)->vtd_dmars_off -
> -		   sizeof(u64));
> +	dmar_tbl_off = readl(heap_ptr + SINIT_MLE_DATA_VTD_DMAR_OFF);
> +	memcpy_fromio(dmar_tbl, heap_ptr + dmar_tbl_off - sizeof(u64),
> +			sizeof(struct acpi_table_header));

That memcpy (or an equivalent of it) was not in the code before, AFAICS.

How can this be an 'interface fix'? It adds in new code...

Thanks,

	Ingo
