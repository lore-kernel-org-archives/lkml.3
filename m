Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3BUJIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 04:08:25 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:59166 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3BUJIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 04:08:21 -0500
Message-ID: <5125E3F2.7070402@synopsys.com>
Date: Thu, 21 Feb 2013 14:38:02 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: <linux-kernel@vger.kernel.org>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 1/2] metag: copy devicetree to non-init memory
References: <1361371929-28148-1-git-send-email-james.hogan@imgtec.com> <1361371929-28148-2-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1361371929-28148-2-git-send-email-james.hogan@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Wednesday 20 February 2013 08:22 PM, James Hogan wrote:
> Make a copy of the device tree blob in non-init memory. It is required
> when using built-in device tree files that the platform code copies the
> blob to non-init memory prior to calling unflatten_device_tree(),
> otherwise the strings that the device tree refer to will get poisoned
> and potentially reused, breaking later reading of the device tree
> post-init (such as compatible matching in modules, debugfs, and the
> procfs interface).

While the patch conceptually looks correct, I'm not sure why any user of DT -
post-init would refer to DT bindings using of_fdt_* API which use the flat tree,
instead of the binary tree (more efficient in space/usage). Is this to support
some in-transition drivers and other code.

And if this is a general problem, then it is probably better done in DT core.

I'm sure I'm missing something here.

> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> ---
>  arch/metag/include/asm/prom.h |  1 +
>  arch/metag/kernel/devtree.c   | 17 +++++++++++++++++
>  arch/metag/kernel/setup.c     |  2 ++
>  3 files changed, 20 insertions(+)
>
> diff --git a/arch/metag/include/asm/prom.h b/arch/metag/include/asm/prom.h
> index d881396..ccac97e 100644
> --- a/arch/metag/include/asm/prom.h
> +++ b/arch/metag/include/asm/prom.h
> @@ -18,6 +18,7 @@
>  #define HAVE_ARCH_DEVTREE_FIXUPS
>  
>  extern struct machine_desc *setup_machine_fdt(void *dt);
> +extern void copy_fdt(void);
>  extern void metag_dt_memblock_reserve(void);
>  
>  #endif /* __ASM_METAG_PROM_H */
> diff --git a/arch/metag/kernel/devtree.c b/arch/metag/kernel/devtree.c
> index 5b6b1d85..7cd0252 100644
> --- a/arch/metag/kernel/devtree.c
> +++ b/arch/metag/kernel/devtree.c
> @@ -95,3 +95,20 @@ struct machine_desc * __init setup_machine_fdt(void *dt)
>  
>  	return mdesc_best;
>  }
> +
> +/**
> + * copy_fdt - Copy device tree into non-init memory.
> + *
> + * We must copy the flattened device tree blob into non-init memory because the
> + * unflattened device tree will reference the strings in it directly.
> + */
> +void __init copy_fdt(void)
> +{
> +	void *alloc = early_init_dt_alloc_memory_arch(
> +			be32_to_cpu(initial_boot_params->totalsize), 0x40);
> +	if (alloc) {
> +		memcpy(alloc, initial_boot_params,
> +		       be32_to_cpu(initial_boot_params->totalsize));
> +		initial_boot_params = alloc;
> +	}
> +}
> diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
> index dd6c5ad..8792461 100644
> --- a/arch/metag/kernel/setup.c
> +++ b/arch/metag/kernel/setup.c
> @@ -406,6 +406,8 @@ void __init setup_arch(char **cmdline_p)
>  	cpu_2_hwthread_id[smp_processor_id()] = hard_processor_id();
>  	hwthread_id_2_cpu[hard_processor_id()] = smp_processor_id();
>  
> +	/* Copy device tree blob into non-init memory before unflattening */
> +	copy_fdt();
>  	unflatten_device_tree();
>  
>  #ifdef CONFIG_SMP

