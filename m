Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3HFNxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 09:53:33 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37841 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754350Ab3HFNxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 09:53:31 -0400
Date: Tue, 6 Aug 2013 14:53:27 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org
Subject: Re: [PATCH 2/7] Move common EFI stub code from x86 arch code to
 common location
Message-ID: <20130806135327.GY2515@console-pimps.org>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
 <1375478948-22562-3-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375478948-22562-3-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Aug, at 02:29:03PM, Roy Franz wrote:
> No code changes made, just moving functions from x86 arch directory
> to common location.
> Code is shared using #include, similar to how decompression code
> is shared among architectures.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |  442 +-----------------------------
>  arch/x86/boot/compressed/eboot.h       |    6 -
>  drivers/firmware/efi/efi-stub-helper.c |  463 ++++++++++++++++++++++++++++++++
>  include/linux/efi.h                    |    8 +
>  4 files changed, 472 insertions(+), 447 deletions(-)
>  create mode 100644 drivers/firmware/efi/efi-stub-helper.c

[...]

> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
> new file mode 100644
> index 0000000..47891bd
> --- /dev/null
> +++ b/drivers/firmware/efi/efi-stub-helper.c
> @@ -0,0 +1,463 @@
> +/*
> + * Helper functions used by the EFI stub on multiple
> + * architectures. This should be #included by the EFI stub
> + * implementation files.
> + *
> + * Copyright 2011 Intel Corporation; author Matt Fleming
> + *
> + * This file is part of the Linux kernel, and is made available
> + * under the terms of the GNU General Public License version 2.
> + *
> + */
> +
> +
> +struct initrd {
> +	efi_file_handle_t *handle;
> +	u64 size;
> +};

This should really be renamed in a later patch, like 'struct efi_file'
or similar because the dtb case has nothing to do with initrds.

> +/*
> + * Check the cmdline for a LILO-style initrd= arguments.
> + *
> + * We only support loading an initrd from the same filesystem as the
> + * kernel image.
> + */
> +static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
> +				    struct setup_header *hdr)
> +{
> +	struct initrd *initrds;

[...]

> +free_initrds:
> +	efi_call_phys1(sys_table->boottime->free_pool, initrds);
> +fail:
> +	hdr->ramdisk_image = 0;
> +	hdr->ramdisk_size = 0;
> +
> +	return status;
> +}

Likewise, this function would benefit from getting rid of the references
to initrd in a later patch.

-- 
Matt Fleming, Intel Open Source Technology Center
