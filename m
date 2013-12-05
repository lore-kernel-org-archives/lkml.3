Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab3LETZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:25:04 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:54841 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3LETZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:25:01 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH V5 2/6] Add shared update_fdt() function for ARM/ARM64
To: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        matt.fleming@intel.com, linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        patches@linaro.org, Roy Franz <roy.franz@linaro.org>
In-Reply-To: <1385595115-21488-3-git-send-email-roy.franz@linaro.org>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org> < 1385595115-21488-3-git-send-email-roy.franz@linaro.org>
Date: Thu, 05 Dec 2013 19:24:56 +0000
Message-Id: <20131205192456.1B602C40785@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013 15:31:51 -0800, Roy Franz <roy.franz@linaro.org> wrote:
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

Hi Roy,

Comments below...

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
> +	/* Copy definition of linux_banner here.  Since this code is
> +	 * built as part of the decompressor for ARM v7, pulling
> +	 * in version.c where linux_banner is defined for the
> +	 * kernel brings other kernel dependencies with it.
> +	 */
> +	const char linux_banner[] =
> +	    "Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
> +	    LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";

This is inherently fragile because the string is now defined in two
places. This issue shouldn't hold off merging the patch, but a follow up
patch should be crafted to make it possible to pull in version.c without
the other dependencies....

Then again, the version.c strings have a very big "DON'T TOUCH" warning
on them so I'm probably worrying about nothing.  :-)

> +
> +	status = fdt_open_into(orig_fdt, fdt, new_fdt_size);
> +	if (status != 0)
> +		goto fdt_set_fail;
> +
> +	node = fdt_subnode_offset(fdt, 0, "chosen");
> +	if (node < 0) {
> +		node = fdt_add_subnode(fdt, 0, "chosen");
> +		if (node < 0) {
> +			status = node; /* node is error code when negative */
> +			goto fdt_set_fail;
> +		}
> +	}
> +
> +	if ((cmdline_ptr != NULL) && (strlen(cmdline_ptr) > 0)) {
> +		status = fdt_setprop(fdt, node, "bootargs", cmdline_ptr,
> +				     strlen(cmdline_ptr) + 1);
> +		if (status)
> +			goto fdt_set_fail;
> +	}
> +
> +	/* Set intird address/end in device tree, if present */

sp. initrd

None of the above comments are blockers though.

Acked-by: Grant Likely <grant.likely@linaro.org>

