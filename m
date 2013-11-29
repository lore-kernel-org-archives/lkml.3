Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3K2Laa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:30:30 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:53137 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537Ab3K2La1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:30:27 -0500
Date: Fri, 29 Nov 2013 11:30:08 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org,
        grant.likely@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        patches@linaro.org
Subject: Re: [PATCH V5 2/6] Add shared update_fdt() function for ARM/ARM64
Message-ID: <20131129113008.GB11775@console-pimps.org>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
 <1385595115-21488-3-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385595115-21488-3-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov, at 03:31:51PM, Roy Franz wrote:
> Both ARM and ARM64 stubs will update the device tree
> that they pass to the kernel.  In both cases they
> primarily need to add the same UEFI related information,
> so the function can be shared.
> Create a new FDT related file for this to avoid use
> of architecture #ifdefs in efi-stub-helper.c
> Change EFI allocation type for memory map to
> EFI_RUNTIME_SERVICES_DATA, since we are passing
> this buffer to the kernel, or immediately freeing it.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  drivers/firmware/efi/efi-stub-helper.c |    9 ++-
>  drivers/firmware/efi/fdt.c             |  115 ++++++++++++++++++++++++++++++++
>  2 files changed, 123 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/firmware/efi/fdt.c
> 
> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
> index b6bffbf..bc9e37a 100644
> --- a/drivers/firmware/efi/efi-stub-helper.c
> +++ b/drivers/firmware/efi/efi-stub-helper.c
> @@ -4,6 +4,7 @@
>   * implementation files.
>   *
>   * Copyright 2011 Intel Corporation; author Matt Fleming
> + * Copyright 2013 Linaro Limited; author Roy Franz
>   *
>   * This file is part of the Linux kernel, and is made available
>   * under the terms of the GNU General Public License version 2.
> @@ -63,10 +64,16 @@ again:
>  	/*
>  	 * Add an additional efi_memory_desc_t because we're doing an
>  	 * allocation which may be in a new descriptor region.
> +	 * We allocate as EFI_RUNTIME_SERVICES_DATA since this is what
> +	 * we want for when we pass the memory map to the kernel.  This
> +	 * function is also used to get the memory map for other uses,
> +	 * but is always freed by the stub so the allocation type
> +	 * doesn't matter.
>  	 */
>  	*map_size += sizeof(*m);
>  	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
> -				EFI_LOADER_DATA, *map_size, (void **)&m);
> +				EFI_RUNTIME_SERVICES_DATA, *map_size,
> +				(void **)&m);
>  	if (status != EFI_SUCCESS)
>  		goto fail;
  

OK, this needs a stronger justification. Presumably the reason for this
change is that you want the allocation to hang around once the kernel is
running? We have this problem on x86 and it's solved by reserving the
memory early in the kernel, e.g. memblock_reserve().
EFI_RUNTIME_SERVICES_DATA is for firmware use, not for kernel data.

> diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/fdt.c
> new file mode 100644
> index 0000000..7f1431b
> --- /dev/null
> +++ b/drivers/firmware/efi/fdt.c
> @@ -0,0 +1,115 @@
> +/*
> + * FDT related Helper functions used by the EFI stub on multiple
> + * architectures. This should be #included by the EFI stub
> + * implementation files.
> + *
> + * Copyright 2013 Linaro Limited; author Roy Franz
> + *
> + * This file is part of the Linux kernel, and is made available
> + * under the terms of the GNU General Public License version 2.
> + *
> + */
> +
> +static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
> +			       void *fdt, int new_fdt_size, char *cmdline_ptr,
> +			       u64 initrd_addr, u64 initrd_size,
> +			       efi_memory_desc_t *memory_map,
> +			       unsigned long map_size, unsigned long desc_size,
> +			       u32 desc_ver)
> +{
> +	int node;
> +	int status;
> +	u32 fdt_val32;
> +	u64 fdt_val64;

Space here before the comment block please.

> +	/* Copy definition of linux_banner here.  Since this code is
> +	 * built as part of the decompressor for ARM v7, pulling
> +	 * in version.c where linux_banner is defined for the
> +	 * kernel brings other kernel dependencies with it.
> +	 */

	/*
	 * This is the multi-line comment format.
	 */

-- 
Matt Fleming, Intel Open Source Technology Center
