Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3IRGP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:15:57 -0400
Received: from mail-ye0-f181.google.com ([209.85.213.181]:43443 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab3IRGNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:13:32 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 03/28] of: create unflatten_and_copy_device_tree
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <1379372965-22359-4-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-4-git-send-email-robherring2@gmail.com>
Date: Tue, 17 Sep 2013 22:15:51 -0500
Message-Id: <20130918031551.B301FC42C99@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013 18:08:59 -0500, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Several architectures using DT support built-in dtb's in the init
> section. These platforms need to copy the dtb from init since the
> strings are referenced after unflattening. Every arch has their own
> copying routine which do the same thing. Create a common function,
> unflatten_and_copy_device_tree, to copy the dtb when unflattening the
> dtb.

This set of changes looks fine by me, but it does raise a question:
For the platforms using memblock; would it work to use memblock_reserve
on the region containing the device tree? That would avoid an
unnecessary copy of the data. Can anyone tell me if it is legal to do a
memblock_reserve on an __init section?

Also, I think the patch needs to add documentation for the function that
states when it is appropriate to use the function, and that it shouldn't
be used when DT memory has been reserved.

Acked-by: Grant Likely <grant.likely@linaro.org>

> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/of/fdt.c       | 13 +++++++++++++
>  include/linux/of_fdt.h |  2 ++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 229dd9d..eca1810 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -802,6 +802,19 @@ void __init unflatten_device_tree(void)
>  	of_alias_scan(early_init_dt_alloc_memory_arch);
>  }
>  
> +void __init unflatten_and_copy_device_tree(void)
> +{
> +	int size = __be32_to_cpu(initial_boot_params->totalsize);
> +	void *dt = early_init_dt_alloc_memory_arch(size,
> +		__alignof__(struct boot_param_header));
> +
> +	if (dt) {
> +		memcpy(dt, initial_boot_params, size);
> +		initial_boot_params = dt;
> +	}
> +	unflatten_device_tree();
> +}
> +
>  #endif /* CONFIG_OF_EARLY_FLATTREE */
>  
>  /* Feed entire flattened device tree into the random pool */
> diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
> index a478c62..58c28a8 100644
> --- a/include/linux/of_fdt.h
> +++ b/include/linux/of_fdt.h
> @@ -118,9 +118,11 @@ extern int early_init_dt_scan_root(unsigned long node, const char *uname,
>  
>  /* Other Prototypes */
>  extern void unflatten_device_tree(void);
> +extern void unflatten_and_copy_device_tree(void);
>  extern void early_init_devtree(void *);
>  #else /* CONFIG_OF_FLATTREE */
>  static inline void unflatten_device_tree(void) {}
> +static inline void unflatten_and_copy_device_tree(void) {}
>  #endif /* CONFIG_OF_FLATTREE */
>  
>  #endif /* __ASSEMBLY__ */
> -- 
> 1.8.1.2
> 

