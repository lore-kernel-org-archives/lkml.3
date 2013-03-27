Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab3C0NfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:35:20 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53690 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3C0NfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:35:19 -0400
Message-ID: <5152F591.40201@arm.com>
Date: Wed, 27 Mar 2013 13:35:13 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 27 Mar 2013 13:35:14.0512 (UTC) FILETIME=[E99AF500:01CE2AEF]
X-MC-Unique: 113032713351704301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/03/13 12:50, Stefano Stabellini wrote:
> Check for the presence of PSCI before setting smp_ops, use PSCI if it is
> available.
> 
> This is useful because at least when running on Xen it's possible to have a
> PSCI node for example on a Versatile Express or an Exynos5 machine. In these
> cases the PSCI SMP calls should be the ones to be called.
> 
> Remove virt_smp_ops and platsmp.c from mach-virt because they aren't needed
> anymore.
> 
> 
> 
> This patch was originally part of this series:
> 
> http://marc.info/?l=linux-arm-kernel&m=136430903110734&w=2
> 
> I am keeping it separate now since it is the only non-obvious change and
> it is not Xen related.
> 
> 
> 
> 
> Changes in v3:
> - move the call to psci_init to setup_arch;
> - export psci_smp_ops from psci.h;
> - introduce psci_smp_available;
> - introduce stub functions for psci_init and psci_smp_available ifndef
> CONFIG_ARM_PSCI;
> - only compile psci_smp functions ifdef CONFIG_SMP.
> 
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: will.deacon@arm.com
> CC: arnd@arndb.de
> CC: marc.zyngier@arm.com
> CC: linux@arm.linux.org.uk
> CC: nico@linaro.org
> ---
>  arch/arm/include/asm/psci.h  |    9 ++++
>  arch/arm/kernel/psci.c       |   97 ++++++++++++++++++++++++++++++++++--------
>  arch/arm/kernel/setup.c      |    7 +++-
>  arch/arm/mach-virt/Makefile  |    1 -
>  arch/arm/mach-virt/platsmp.c |   58 -------------------------
>  arch/arm/mach-virt/virt.c    |    3 -
>  6 files changed, 94 insertions(+), 81 deletions(-)
>  delete mode 100644 arch/arm/mach-virt/platsmp.c
> 
> diff --git a/arch/arm/include/asm/psci.h b/arch/arm/include/asm/psci.h
> index ce0dbe7..ddef231 100644
> --- a/arch/arm/include/asm/psci.h
> +++ b/arch/arm/include/asm/psci.h
> @@ -32,5 +32,14 @@ struct psci_operations {
>  };
>  
>  extern struct psci_operations psci_ops;
> +extern struct smp_operations psci_smp_ops;
> +
> +#ifdef CONFIG_ARM_PSCI
> +int psci_init(void);
> +bool psci_smp_available(void);
> +#else
> +static inline int psci_init(void) { return -ENODEV; }
> +static inline bool psci_smp_available(void) { return false; }
> +#endif
>  
>  #endif /* __ASM_ARM_PSCI_H */
> diff --git a/arch/arm/kernel/psci.c b/arch/arm/kernel/psci.c
> index 3653164..90f0839 100644
> --- a/arch/arm/kernel/psci.c
> +++ b/arch/arm/kernel/psci.c
> @@ -16,6 +16,7 @@
>  #define pr_fmt(fmt) "psci: " fmt
>  
>  #include <linux/init.h>
> +#include <linux/irqchip/arm-gic.h>
>  #include <linux/of.h>
>  
>  #include <asm/compiler.h>
> @@ -23,8 +24,9 @@
>  #include <asm/opcodes-sec.h>
>  #include <asm/opcodes-virt.h>
>  #include <asm/psci.h>
> +#include <asm/smp_plat.h>
>  
> -struct psci_operations psci_ops;
> +extern void secondary_startup(void);
>  
>  static int (*invoke_psci_fn)(u32, u32, u32, u32);
>  
> @@ -36,7 +38,11 @@ enum psci_function {
>  	PSCI_FN_MAX,
>  };
>  
> -static u32 psci_function_id[PSCI_FN_MAX];
> +struct psci_function_desc {
> +	enum psci_function func;
> +	bool valid;
> +};
> +static struct psci_function_desc psci_function_id[PSCI_FN_MAX];
>  
>  #define PSCI_RET_SUCCESS		0
>  #define PSCI_RET_EOPNOTSUPP		-1
> @@ -116,7 +122,10 @@ static int psci_cpu_suspend(struct psci_power_state state,
>  	int err;
>  	u32 fn, power_state;
>  
> -	fn = psci_function_id[PSCI_FN_CPU_SUSPEND];
> +	if (!psci_function_id[PSCI_FN_CPU_SUSPEND].valid)
> +		return -ENOSYS;
> +
> +	fn = psci_function_id[PSCI_FN_CPU_SUSPEND].func;
>  	power_state = psci_power_state_pack(state);
>  	err = invoke_psci_fn(fn, power_state, entry_point, 0);
>  	return psci_to_linux_errno(err);
> @@ -127,7 +136,10 @@ static int psci_cpu_off(struct psci_power_state state)
>  	int err;
>  	u32 fn, power_state;
>  
> -	fn = psci_function_id[PSCI_FN_CPU_OFF];
> +	if (!psci_function_id[PSCI_FN_CPU_OFF].valid)
> +		return -ENOSYS;
> +
> +	fn = psci_function_id[PSCI_FN_CPU_OFF].func;
>  	power_state = psci_power_state_pack(state);
>  	err = invoke_psci_fn(fn, power_state, 0, 0);
>  	return psci_to_linux_errno(err);
> @@ -138,7 +150,10 @@ static int psci_cpu_on(unsigned long cpuid, unsigned long entry_point)
>  	int err;
>  	u32 fn;
>  
> -	fn = psci_function_id[PSCI_FN_CPU_ON];
> +	if (!psci_function_id[PSCI_FN_CPU_ON].valid)
> +		return -ENOSYS;
> +
> +	fn = psci_function_id[PSCI_FN_CPU_ON].func;
>  	err = invoke_psci_fn(fn, cpuid, entry_point, 0);
>  	return psci_to_linux_errno(err);
>  }
> @@ -148,25 +163,64 @@ static int psci_migrate(unsigned long cpuid)
>  	int err;
>  	u32 fn;
>  
> -	fn = psci_function_id[PSCI_FN_MIGRATE];
> +	if (!psci_function_id[PSCI_FN_MIGRATE].valid)
> +		return -ENOSYS;
> +
> +	fn = psci_function_id[PSCI_FN_MIGRATE].func;
>  	err = invoke_psci_fn(fn, cpuid, 0, 0);
>  	return psci_to_linux_errno(err);
>  }
>  
> +struct psci_operations psci_ops = {
> +	.cpu_suspend = psci_cpu_suspend,
> +	.cpu_off     = psci_cpu_off,
> +	.cpu_on      = psci_cpu_on,
> +	.migrate     = psci_migrate,
> +};
> +
> +#ifdef CONFIG_SMP
> +static void __init psci_smp_init_cpus(void)
> +{
> +}
> +
> +static void __init psci_smp_prepare_cpus(unsigned int max_cpus)
> +{
> +}
> +
> +static int __cpuinit psci_boot_secondary(unsigned int cpu,
> +					 struct task_struct *idle)
> +{
> +	return psci_cpu_on(cpu_logical_map(cpu), __pa(secondary_startup));
> +}
> +
> +static void __cpuinit psci_secondary_init(unsigned int cpu)
> +{
> +	gic_secondary_init(0);
> +}

So here we end-up with a dependency between SMP, PSCI, and GIC.
I really can't see that being a good idea, even I like the general
direction of this series.

	M.
-- 
Jazz is not dead. It just smells funny...

