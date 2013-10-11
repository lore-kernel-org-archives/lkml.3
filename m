Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab3JKPtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:49:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55060 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab3JKPtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:49:45 -0400
Date: Fri, 11 Oct 2013 17:49:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 6/8] ACPI, APEI, CPER: Enhance memory reporting capability
Message-ID: <20131011154938.GK5925@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-7-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381473166-29303-7-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 02:32:44AM -0400, Chen, Gong wrote:
> After H/W error happens under FFM enabled mode, lots of information
> are shown but some important parts like DIMM location missed. This
> patch is used to show these extra fileds.
> 
> Original-author: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  drivers/acpi/apei/cper.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index 680230c..2a4389f 100644
> --- a/drivers/acpi/apei/cper.c
> +++ b/drivers/acpi/apei/cper.c
> @@ -28,6 +28,7 @@
>  #include <linux/module.h>
>  #include <linux/time.h>
>  #include <linux/cper.h>
> +#include <linux/dmi.h>
>  #include <linux/acpi.h>
>  #include <linux/pci.h>
>  #include <linux/aer.h>
> @@ -210,6 +211,8 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
>  		printk("%s""card: %d\n", pfx, mem->card);
>  	if (mem->validation_bits & CPER_MEM_VALID_MODULE)
>  		printk("%s""module: %d\n", pfx, mem->module);
> +	if (mem->validation_bits & CPER_MEM_VALID_RANK_NUMBER)
> +		printk("%s""rank: %d\n", pfx, mem->rank);
>  	if (mem->validation_bits & CPER_MEM_VALID_BANK)
>  		printk("%s""bank: %d\n", pfx, mem->bank);
>  	if (mem->validation_bits & CPER_MEM_VALID_DEVICE)
> @@ -232,6 +235,15 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
>  		       etype < ARRAY_SIZE(cper_mem_err_type_strs) ?
>  		       cper_mem_err_type_strs[etype] : "unknown");
>  	}
> +	if (mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE) {
> +		const char *bank = NULL, *device = NULL;
> +		dmi_memdev_name(mem->mem_dev_handle, &bank, &device);
> +		if (bank != NULL && device != NULL)
> +			printk("%s""DIMM location: %s %s", pfx, bank, device);
> +		else
> +			printk("%s""DIMM DMI handle: 0x%.4x", pfx,
> +					mem->mem_dev_handle);

Just a nitpick: maybe better arg alignment:

			printk("%s""DIMM DMI handle: 0x%.4x",
			       pfx, mem->mem_dev_handle);

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
