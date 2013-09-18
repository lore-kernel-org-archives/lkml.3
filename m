Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab3IRMMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:12:46 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37796 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168Ab3IRMMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:12:44 -0400
Date: Wed, 18 Sep 2013 13:12:40 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, leif.lindholm@linaro.org, msalter@redhat.com
Subject: Re: [PATCH 08/17] Generalize relocate_kernel() for use by other
 architectures.
Message-ID: <20130918121240.GJ3409@console-pimps.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
 <1379391093-27948-9-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379391093-27948-9-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep, at 09:11:24PM, Roy Franz wrote:
> Rename relocate_kernel() to efi_relocate_kernel(), and take
> parameters rather than x86 specific structure.  Add max_addr
> argument as for ARM we have some address constraints that we
> need to enforce when relocating the kernel.  Add alloc_size
> parameter for use by ARM64 which uses an uncompressed kernel,
> and needs to allocate space for BSS.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |   12 ++++--
>  drivers/firmware/efi/efi-stub-helper.c |   74 ++++++++++++++++++++++----------
>  2 files changed, 60 insertions(+), 26 deletions(-)
 
This commit breaks my ASUS machine.

> -	/*
> -	 * The EFI firmware loader could have placed the kernel image
> -	 * anywhere in memory, but the kernel has various restrictions
> -	 * on the max physical address it can run at. Attempt to move
> -	 * the kernel to boot_params.pref_address, or as low as
> -	 * possible.
> -	 */

[...]

> +
> +	/* The EFI firmware loader could have placed the kernel image
> +	 * anywhere in memory, but the kernel has restrictions on the
> +	 * anywhere in memory, but the kernel has restrictions on the
> +	 * max physical address it can run at.  Some architectures
> +	 * also have a prefered address, so first try to relocate
> +	 * to the preferred address.
> +	 */

Please don't change the comment style of code in the future.

> +	nr_pages = round_up(alloc_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
> +	status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
>  				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
> -				nr_pages, &start);
> +				nr_pages, &efi_addr);
> +	new_addr = efi_addr;
> +	/* If preferred address allocation failed allocate as low as
> +	 * possible. */
>  	if (status != EFI_SUCCESS) {
> -		status = efi_low_alloc(sys_table, hdr->init_size,
> -				   hdr->kernel_alignment, &start);
> -		if (status != EFI_SUCCESS)
> -			efi_printk(sys_table, "Failed to alloc mem for kernel\n");
> +		status = efi_low_alloc(sys_table_arg, alloc_size, 0,
> +				       &new_addr);

This is wrong. You've dropped the hdr->kernel_alignment argument, and
the relaxed alignment of this allocation stops my machine from booting.

-- 
Matt Fleming, Intel Open Source Technology Center
