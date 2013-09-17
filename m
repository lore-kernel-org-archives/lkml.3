Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab3IQFqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 01:46:38 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:41837 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3IQFqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 01:46:37 -0400
Message-ID: <5237ECAC.8010400@synopsys.com>
Date: Tue, 17 Sep 2013 11:16:20 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.drivers.devicetree
To: Rob Herring <robherring2@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 09/28] of: Introduce common early_init_dt_scan
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-10-git-send-email-robherring2@gmail.com>
In-Reply-To: <1379372965-22359-10-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 04:39 AM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Most architectures scan the all the same items early in the FDT and none
> are really architecture specific. Create a common early_init_dt_scan to
> unify the early scan of root, memory, and chosen nodes in the flattened
> DT.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@linaro.org>
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
> +
> +	/* Retrieve various information from the /chosen node */
> +	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
> +	/* Initialize {size,address}-cells info */
> +	of_scan_flat_dt(early_init_dt_scan_root, NULL);
> +	/* Setup memory, calling early_init_dt_add_memory_arch */
> +	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
> +	return true;
> +}

You probably need empty lines here.

-Vineet

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
> 

