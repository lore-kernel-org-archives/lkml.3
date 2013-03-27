Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab3C0OzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:55:18 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:60195 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3C0OzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:55:16 -0400
Message-ID: <51530850.6070405@gmail.com>
Date: Wed, 27 Mar 2013 09:55:12 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: xen-devel@lists.xensource.com, linux@arm.linux.org.uk, arnd@arndb.de,
        marc.zyngier@arm.com, nico@linaro.org, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 07:50 AM, Stefano Stabellini wrote:
> Check for the presence of PSCI before setting smp_ops, use PSCI if it is
> available.
> 
> This is useful because at least when running on Xen it's possible to have a
> PSCI node for example on a Versatile Express or an Exynos5 machine. In these
> cases the PSCI SMP calls should be the ones to be called.

I have a similar patch in my tree. I thought I had sent it out, but
looks like I didn't. I didn't make smp_ops default to this or change
mach-virt, so we should go with yours.

[...]

> @@ -36,7 +38,11 @@ enum psci_function {
>  	PSCI_FN_MAX,
>  };
>  
> -static u32 psci_function_id[PSCI_FN_MAX];
> +struct psci_function_desc {
> +	enum psci_function func;
> +	bool valid;

Why can't you use a NULL function ptr or a 0 psci_function_id to
indicate not valid?

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

You can leave these 2 functions as NULL.

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
> +
> +struct smp_operations __initdata psci_smp_ops = {
> +	.smp_init_cpus		= psci_smp_init_cpus,
> +	.smp_prepare_cpus	= psci_smp_prepare_cpus,
> +	.smp_secondary_init	= psci_secondary_init,
> +	.smp_boot_secondary	= psci_boot_secondary,

You should also include hotplug. Here's what I had:

#ifdef CONFIG_HOTPLUG_CPU
void __ref psci_cpu_die(unsigned int cpu)
{
       const struct psci_power_state ps = {
               .type = PSCI_POWER_STATE_TYPE_POWER_DOWN,
       };

       if (psci_ops.cpu_off)
               psci_ops.cpu_off(ps);

       /* We should never return */
       panic("psci: cpu %d failed to shutdown\n", cpu);
}
#else
#define psci_cpu_die NULL
#endif

