Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab3GRHBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:01:51 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:35149 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3GRHBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:01:50 -0400
Date: Thu, 18 Jul 2013 09:01:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH v2] x86, tboot: iomem fixes
Message-ID: <20130718070145.GB17622@gmail.com>
References: <1374114943-5932-1-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374114943-5932-1-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Qiaowei Ren <qiaowei.ren@intel.com> wrote:

> Fixes for iomem annotations in arch/x86/kernel/tboot.c
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

The changelog is not sufficient, as this change is clearly not just about 
annotations: that memcpy_fromio() call is new.

Please use the customary changelog style we use in the kernel:

  " Current code does (A), this has a problem when (B).
    We can improve this doing (C), because (D)."

Thanks,

        Ingo
