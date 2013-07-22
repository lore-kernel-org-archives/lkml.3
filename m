Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3GVIuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:50:44 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:33747 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab3GVIun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:50:43 -0400
Date: Mon, 22 Jul 2013 10:50:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH v5] x86, tboot: iomem fixes
Message-ID: <20130722085038.GD25976@gmail.com>
References: <1374337612-6899-1-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374337612-6899-1-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Qiaowei Ren <qiaowei.ren@intel.com> wrote:

> Current code doesn't use specific interface to access I/O space.
> So some potential bugs can be caused. We can fix this by using
> specific API.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  arch/x86/kernel/tboot.c |   18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
> index 3ff42d2..4e149c7 100644
> --- a/arch/x86/kernel/tboot.c
> +++ b/arch/x86/kernel/tboot.c
> @@ -468,7 +468,8 @@ struct sinit_mle_data {
>  
>  struct acpi_table_header *tboot_get_dmar_table(struct acpi_table_header *dmar_tbl)
>  {
> -	void *heap_base, *heap_ptr, *config;
> +	void __iomem *heap_base, *heap_ptr, *config;
> +	u32 dmar_tbl_off;
>  
>  	if (!tboot_enabled())
>  		return dmar_tbl;
> @@ -485,25 +486,26 @@ struct acpi_table_header *tboot_get_dmar_table(struct acpi_table_header *dmar_tb
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

tboot.c is build on 32-bit kernel as well, but readq() is only available 
on 64-bit systems.

Thanks,

	Ingo
