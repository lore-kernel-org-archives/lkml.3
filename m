Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3IRGOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:14:33 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:62764 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3IRGNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:13:35 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 09/28] of: Introduce common early_init_dt_scan
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <1379372965-22359-10-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-10-git-send-email-robherring2@gmail.com>
Date: Tue, 17 Sep 2013 22:24:19 -0500
Message-Id: <20130918032419.AE8CDC42C9B@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013 18:09:05 -0500, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Most architectures scan the all the same items early in the FDT and none
> are really architecture specific. Create a common early_init_dt_scan to
> unify the early scan of root, memory, and chosen nodes in the flattened
> DT.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@linaro.org>

One caveat below, but otherwise:
Acked-by: Grant Likely <grant.likely@linaro.org>

> ---
>  drivers/of/fdt.c       | 18 ++++++++++++++++++
>  include/linux/of_fdt.h |  2 ++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index eca1810..0714dd4 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -785,6 +785,24 @@ void * __init __weak early_init_dt_alloc_memory_arch(u64 size, u64 align)
>  }
>  #endif
>  
> +bool __init early_init_dt_scan(void *params)
> +{
> +	/* Setup flat device-tree pointer */
> +	initial_boot_params = params;
> +
> +	/* check device tree validity */
> +	if (be32_to_cpu(initial_boot_params->magic) != OF_DT_HEADER)
> +		return false;

If the test fails, then clear initial_boot_params to NULL. Similarly, if
params is NULL, then bail before dereferencing it.

> +
> +	/* Retrieve various information from the /chosen node */
> +	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
> +	/* Initialize {size,address}-cells info */
> +	of_scan_flat_dt(early_init_dt_scan_root, NULL);
> +	/* Setup memory, calling early_init_dt_add_memory_arch */
> +	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
> +	return true;
> +}
> +
>  /**
>   * unflatten_device_tree - create tree of device_nodes from flat blob
>   *
> diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
> index 58c28a8..73e1651 100644
> --- a/include/linux/of_fdt.h
> +++ b/include/linux/of_fdt.h
> @@ -116,6 +116,8 @@ extern void early_init_dt_setup_initrd_arch(u64 start, u64 end);
>  extern int early_init_dt_scan_root(unsigned long node, const char *uname,
>  				   int depth, void *data);
>  
> +extern bool early_init_dt_scan(void *params);
> +
>  /* Other Prototypes */
>  extern void unflatten_device_tree(void);
>  extern void unflatten_and_copy_device_tree(void);
> -- 
> 1.8.1.2
> 

