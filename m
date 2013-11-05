Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab3KERZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:25:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59427 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3KERZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:25:01 -0500
Subject: Re: [PATCH 05/11] ARM: Introduce CPU_METHOD_OF_DECLARE() for cpu hotplug/smp
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1383343739-23080-6-git-send-email-sboyd@codeaurora.org>
Date: Tue, 5 Nov 2013 11:24:58 -0600
Cc: linux-arm-kernel@lists.infradead.org, David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <E3155290-B7BD-4559-BB0E-6C6C7D74ACFB@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org> <1383343739-23080-6-git-send-email-sboyd@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 1, 2013, at 5:08 PM, Stephen Boyd wrote:

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
> 
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> arch/arm/include/asm/smp.h        |  9 +++++++++
> arch/arm/kernel/devtree.c         | 38 ++++++++++++++++++++++++++++++++++++++
> include/asm-generic/vmlinux.lds.h | 10 ++++++++++
> 3 files changed, 57 insertions(+)
> 
> diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
> index a8cae71c..c27ec55 100644
> --- a/arch/arm/include/asm/smp.h
> +++ b/arch/arm/include/asm/smp.h
> @@ -112,6 +112,15 @@ struct smp_operations {
> #endif
> };
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
> /*
>  * set platform specific SMP operations
>  */
> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> index f35906b..71a8592 100644
> --- a/arch/arm/kernel/devtree.c
> +++ b/arch/arm/kernel/devtree.c
> @@ -25,6 +25,7 @@
> #include <asm/smp_plat.h>
> #include <asm/mach/arch.h>
> #include <asm/mach-types.h>
> +#include <asm/smp.h>
> 
> void __init early_init_dt_add_memory_arch(u64 base, u64 size)
> {
> @@ -63,6 +64,36 @@ void __init arm_dt_memblock_reserve(void)
> 	}
> }
> 
> +#ifdef CONFIG_SMP
> +extern struct of_cpu_method __cpu_method_of_table[];
> +
> +static const struct of_cpu_method __cpu_method_of_table_sentinel
> +	__used __section(__cpu_method_of_table_end);
> +
> +static int __init set_smp_ops_by_method(struct device_node *node)
> +{
> +	const char *method;
> +	struct of_cpu_method *m = __cpu_method_of_table;
> +
> +	if (of_property_read_string(node, "enable-method", &method))
> +		return 0;
> +
> +	for (; m != &__cpu_method_of_table_sentinel; m++)
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
> +
> +
> /*
>  * arm_dt_init_cpu_maps - Function retrieves cpu nodes from the device tree
>  * and builds the cpu logical map array containing MPIDR values related to
> @@ -79,6 +110,7 @@ void __init arm_dt_init_cpu_maps(void)
> 	 * read as 0.
> 	 */
> 	struct device_node *cpu, *cpus;
> +	int found_method = 0;
> 	u32 i, j, cpuidx = 1;
> 	u32 mpidr = is_smp() ? read_cpuid_mpidr() & MPIDR_HWID_BITMASK : 0;
> 
> @@ -150,8 +182,14 @@ void __init arm_dt_init_cpu_maps(void)
> 		}
> 
> 		tmp_map[i] = hwid;
> +
> +		if (!found_method)
> +			found_method = set_smp_ops_by_method(cpu);
> 	}
> 
> +	if (!found_method)
> +		set_smp_ops_by_method(cpus);
> +

I assume this if for the case that the enable method is in the cpus{ } container but not in a specific cpu node?

If so, the binding is not clear that we allow this.  Also a comment would probably be nice.

> 	if (!bootcpu_valid) {
> 		pr_warn("DT missing boot CPU MPIDR[23:0], fall back to default cpu_logical_map\n");
> 		return;

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

