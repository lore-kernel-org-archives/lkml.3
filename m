Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3JCJwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:52:31 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53866 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587Ab3JCJw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:52:29 -0400
Date: Thu, 3 Oct 2013 10:52:24 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org,
        grant.likely@linaro.org, dave.martin@arm.com, msalter@redhat.com
Subject: Re: [PATCH 2/6] Add shared update_fdt() function for ARM/ARM64
Message-ID: <20131003095224.GX21381@console-pimps.org>
References: <1380385403-31904-1-git-send-email-roy.franz@linaro.org>
 <1380385403-31904-3-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380385403-31904-3-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Sep, at 09:23:19AM, Roy Franz wrote:
> Both ARM and ARM64 stubs will update the device tree
> that they pass to the kernel.  In both cases they
> primarily need to add the same UEFI related information,
> so the function can be shared.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  drivers/firmware/efi/efi-stub-helper.c |   86 ++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
> 
> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
> index cc0581d..d3448a9 100644
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
> @@ -636,3 +637,88 @@ static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
>  	*cmd_line_len = options_size;
>  	return (char *)cmdline_addr;
>  }
> +
> +#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
> +static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
> +			       void *fdt, int new_fdt_size, char *cmdline_ptr,
> +			       u64 initrd_addr, u64 initrd_size,
> +			       efi_memory_desc_t *memory_map,
> +			       unsigned long map_size, unsigned long desc_size,
> +			       u32 desc_ver)

Hmm... does this function really belong in efi-stub-helper.c? That file
should be for architecture independent functionality only.

While it currently does include this little snippet,

#ifdef CONFIG_ARM
	/*
	 * For ARM, allocate at a high address to avoid reserved
	 * regions at low addresses that we don't know the specfics of
	 * at the time we are processing the command line.
	 */
	status = efi_high_alloc(sys_table_arg, options_size, 0,
			    &cmdline_addr, 0xfffff000);
#else
	status = efi_low_alloc(sys_table_arg, options_size, 0,
			    &cmdline_addr);
#endif

I think that single #ifdef is justifiable. But including entire
functions that are only used by ARM/ARM64 or x86 isn't.

-- 
Matt Fleming, Intel Open Source Technology Center
