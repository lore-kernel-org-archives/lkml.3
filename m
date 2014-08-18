Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaHRS5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:57:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:37274 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHRS5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:57:07 -0400
Message-ID: <1408388212.22761.100.camel@smoke>
Subject: Re: [PATCH v2 08/18] ARM64 / ACPI: Get the enable method for SMP
 initialization in ACPI way
From: Geoff Levand <geoff@infradead.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, linaro-acpi@lists.linaro.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, Charles.Garcia-Tobin@arm.com,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Date: Mon, 18 Aug 2014 11:56:52 -0700
In-Reply-To: <1407166105-17675-9-git-send-email-hanjun.guo@linaro.org>
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org>
	 <1407166105-17675-9-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanjun,

On Mon, 2014-08-04 at 23:28 +0800, Hanjun Guo wrote:
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -14,6 +14,27 @@
>  
>  /* Basic configuration for ACPI */
>  #ifdef	CONFIG_ACPI

By having this preprocessor conditional in the header leads
to a proliferation of preprocessor conditionals since any
code that includes this header will also need to have
preprocessor conditionals.  Another down side of having
this is that this code will not get a build test for
builds with CONFIG_ACPI=n.

> +/*
> + * ACPI 5.1 only has two explicit methods to
> + * boot up SMP, PSCI and Parking protocol,
> + * but the Parking protocol is only defined
> + * for ARMv7 now, so make PSCI as the only
> + * way for the SMP boot protocol before some
> + * updates for the ACPI spec or the Parking
> + * protocol spec.
> + *
> + * This enum is intend to make the boot method
> + * scalable when above updates are happended,
> + * which NOT means to support all of them.
> + */
> +enum acpi_smp_boot_protocol {
> +	ACPI_SMP_BOOT_PSCI,
> +	ACPI_SMP_BOOT_PARKING_PROTOCOL,
> +	ACPI_SMP_BOOT_PROTOCOL_MAX
> +};
> +
> +enum acpi_smp_boot_protocol smp_boot_protocol(void);

The name smp_boot_protocol() seems like it would be a generic
routine, but it is acpi specific.  Maybe:

enum acpi_boot_protocol_type {...};

enum acpi_boot_protocol_type acpi_boot_protocol(void);

> --- a/arch/arm64/kernel/cpu_ops.c
> +++ b/arch/arm64/kernel/cpu_ops.c
> @@ -49,12 +51,44 @@ static const struct cpu_operations * __init cpu_get_ops(const char *name)
>  	return NULL;
>  }
>  
> +#ifdef CONFIG_ACPI
> +/*
> + * Get a cpu's boot method in the ACPI way.
> + */
> +static char * __init acpi_get_cpu_boot_method(void)
> +{
> +	/*
> +	 * For ACPI 5.1, only two kind of methods are provided,
> +	 * Parking protocol and PSCI, but Parking protocol is
> +	 * specified for ARMv7 only, so make PSCI as the only method
> +	 * for SMP initialization before the ACPI spec or Parking
> +	 * protocol spec is updated.
> +	 */
> +	switch (smp_boot_protocol()) {
> +	case ACPI_SMP_BOOT_PSCI:
> +		return "psci";
> +	case ACPI_SMP_BOOT_PARKING_PROTOCOL:
> +	default:
> +		return NULL;
> +	}
> +}
> +#else
> +static inline char * __init acpi_get_cpu_boot_method(void) { return NULL; }
> +#endif

Since this is inside a C source file, the inline keyword
isn't needed since the optimizer will inline regardless.

With that said, I think it would be cleaner to have this
as:

static char * __init acpi_get_cpu_boot_method(void)
{
#ifdef CONFIG_ACPI
	return NULL;
#else
 ...
#endif
}

Or better to make smp_boot_protocol() callable regardless
of CONFIG_ACPI and then no preprocessor conditionals at all
would be needed.

> +
>  /*
> - * Read a cpu's enable method from the device tree and record it in cpu_ops.
> + * Read a cpu's enable method and record it in cpu_ops.
>   */
>  int __init cpu_read_ops(struct device_node *dn, int cpu)
>  {
> -	const char *enable_method = of_get_property(dn, "enable-method", NULL);
> +	const char *enable_method;
> +
> +	if (!acpi_disabled) {
> +		enable_method = acpi_get_cpu_boot_method();
> +		goto get_ops;
> +	}
> +
> +	enable_method = of_get_property(dn, "enable-method", NULL);
>  	if (!enable_method) {
>  		/*
>  		 * The boot CPU may not have an enable method (e.g. when
> @@ -66,10 +100,17 @@ int __init cpu_read_ops(struct device_node *dn, int cpu)
>  		return -ENOENT;
>  	}
>  
> +get_ops:
>  	cpu_ops[cpu] = cpu_get_ops(enable_method);
>  	if (!cpu_ops[cpu]) {
> -		pr_warn("%s: unsupported enable-method property: %s\n",
> -			dn->full_name, enable_method);
> +		if (acpi_disabled) {
> +			pr_warn("%s: unsupported enable-method property: %s\n",
> +				dn->full_name, enable_method);
> +		} else {
> +			pr_warn("CPU %d: boot protocol unsupported or unknown\n",
> +				cpu);
> +		}
> +

Can't we have this more integrated, maybe something like this?

	enable_method = acpi_disabled ? of_get_property(dn, "enable-method", NULL)
		: acpi_get_cpu_boot_method();
	message = acpi_disabled ? dn->full_name : "";

	...
	
	pr_warn("CPU %d: %s unsupported enable-method property: %s\n",
				cpu, message, enable_method)

-Geoff

