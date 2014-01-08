Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbaAHPGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:06:49 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52397 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755664AbaAHPGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:06:46 -0500
Date: Wed, 8 Jan 2014 15:06:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 4/9] ARM: Introduce CPU_METHOD_OF_DECLARE() for cpu
 hotplug/smp
Message-ID: <20140108150612.GC11753@e106331-lin.cambridge.arm.com>
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
 <1387845593-10050-5-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387845593-10050-5-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 12:39:48AM +0000, Stephen Boyd wrote:
> The goal of multi-platform kernels is to remove the need for mach
> directories and machine descriptors. To further that goal,
> introduce CPU_METHOD_OF_DECLARE() to allow cpu hotplug/smp
> support to be separated from the machine descriptors.
> Implementers should specify an enable-method property in their
> cpus node and then implement a matching set of smp_ops in their
> hotplug/smp code, wiring it up with the CPU_METHOD_OF_DECLARE()
> macro. When the kernel is compiled we'll collect all the
> enable-method smp_ops into one section for use at boot.
> 
> At boot time we'll look for an enable-method in each cpu node and
> try to match that against all known CPU enable methods in the
> kernel. If there are no enable-methods in the cpu nodes we
> fallback to the cpus node and try to use any enable-method found
> there. If that doesn't work we fall back to the old way of using
> the machine descriptor.

Nice!

> 
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/include/asm/smp.h        |  9 +++++++++
>  arch/arm/kernel/devtree.c         | 40 +++++++++++++++++++++++++++++++++++++++
>  include/asm-generic/vmlinux.lds.h | 10 ++++++++++
>  3 files changed, 59 insertions(+)
> 
> diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
> index 22a3b9b..772435b 100644
> --- a/arch/arm/include/asm/smp.h
> +++ b/arch/arm/include/asm/smp.h
> @@ -114,6 +114,15 @@ struct smp_operations {
>  #endif
>  };
>  
> +struct of_cpu_method {
> +	const char *method;
> +	struct smp_operations *ops;
> +};
> +
> +#define CPU_METHOD_OF_DECLARE(name, _method, _ops)			\
> +	static const struct of_cpu_method __cpu_method_of_table_##name	\
> +		__used __section(__cpu_method_of_table)			\
> +		= { .method = _method, .ops = _ops }
>  /*
>   * set platform specific SMP operations
>   */
> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> index 739c3df..91cc3f8 100644
> --- a/arch/arm/kernel/devtree.c
> +++ b/arch/arm/kernel/devtree.c
> @@ -18,6 +18,7 @@
>  #include <linux/of_fdt.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_platform.h>
> +#include <linux/smp.h>
>  
>  #include <asm/cputype.h>
>  #include <asm/setup.h>
> @@ -63,6 +64,34 @@ void __init arm_dt_memblock_reserve(void)
>  	}
>  }
>  
> +#ifdef CONFIG_SMP
> +extern struct of_cpu_method __cpu_method_of_table_begin[];
> +extern struct of_cpu_method __cpu_method_of_table_end[];
> +
> +static int __init set_smp_ops_by_method(struct device_node *node)
> +{
> +	const char *method;
> +	struct of_cpu_method *m = __cpu_method_of_table_begin;
> +
> +	if (of_property_read_string(node, "enable-method", &method))
> +		return 0;
> +
> +	for (; m < __cpu_method_of_table_end; m++)
> +		if (!strcmp(m->method, method)) {
> +			smp_set_ops(m->ops);
> +			return 1;
> +		}
> +
> +	return 0;
> +}
> +#else
> +static inline int set_smp_ops_by_method(struct device_node *node)
> +{
> +	return 1;
> +}
> +#endif

I was going to comment that this would look nicer using an error code or
0, rather than 0 or 1, but I see that would make the call sites more
complicated / less legible.

> +
> +
>  /*
>   * arm_dt_init_cpu_maps - Function retrieves cpu nodes from the device tree
>   * and builds the cpu logical map array containing MPIDR values related to
> @@ -79,6 +108,7 @@ void __init arm_dt_init_cpu_maps(void)
>  	 * read as 0.
>  	 */
>  	struct device_node *cpu, *cpus;
> +	int found_method = 0;
>  	u32 i, j, cpuidx = 1;
>  	u32 mpidr = is_smp() ? read_cpuid_mpidr() & MPIDR_HWID_BITMASK : 0;
>  
> @@ -150,8 +180,18 @@ void __init arm_dt_init_cpu_maps(void)
>  		}
>  
>  		tmp_map[i] = hwid;
> +
> +		if (!found_method)
> +			found_method = set_smp_ops_by_method(cpu);
>  	}
>  
> +	/*
> +	 * Fallback to an enable-method in the cpus node if nothing found in
> +	 * a cpu node.
> +	 */
> +	if (!found_method)
> +		set_smp_ops_by_method(cpus);
> +
>  	if (!bootcpu_valid) {
>  		pr_warn("DT missing boot CPU MPIDR[23:0], fall back to default cpu_logical_map\n");
>  		return;
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index bc2121f..bd02ca7 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -167,6 +167,15 @@
>  #define CLK_OF_TABLES()
>  #endif
>  
> +#ifdef CONFIG_SMP
> +#define CPU_METHOD_OF_TABLES() . = ALIGN(8);				    \
> +			   VMLINUX_SYMBOL(__cpu_method_of_table_begin) = .; \
> +			   *(__cpu_method_of_table)			    \
> +			   VMLINUX_SYMBOL(__cpu_method_of_table_end) = .;
> +#else
> +#define CPU_METHOD_OF_TABLES()
> +#endif

I suspect we'll use this on arm64 in future, where we might need this
even on UP systems (for PSCI's cpu_suspend method). However, I think
that can change that as and when we require it.

> +
>  #define KERNEL_DTB()							\
>  	STRUCT_ALIGN();							\
>  	VMLINUX_SYMBOL(__dtb_start) = .;				\
> @@ -491,6 +500,7 @@
>  	MEM_DISCARD(init.rodata)					\
>  	CLK_OF_TABLES()							\
>  	CLKSRC_OF_TABLES()						\
> +	CPU_METHOD_OF_TABLES()						\
>  	KERNEL_DTB()							\
>  	IRQCHIP_OF_MATCH_TABLE()

Enthusiastically Acked-by: Mark Rutland <mark.rutland@arm.com>

Cheers,
Mark.
