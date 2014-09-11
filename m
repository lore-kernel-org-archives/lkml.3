Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaIKKYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:24:43 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:44265 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaIKKYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:24:41 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 09/17] ARM64 / ACPI: Parse MADT for SMP
 initialization
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
In-Reply-To: <1409583475-6978-10-git-send-email-hanjun.guo@linaro.org>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
	<1409583475-6978-10-git-send-email-hanjun.guo@linaro.org>
Date: Thu, 11 Sep 2014 11:24:36 +0100
Message-Id: <20140911102436.B6671C40862@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Sep 2014 22:57:47 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> MADT contains the information for MPIDR which is essential for
> SMP initialization, parse the GIC cpu interface structures to
> get the MPIDR value and map it to cpu_logical_map(), and add
> enabled cpu with valid MPIDR into cpu_possible_map.
> 
> ACPI 5.1 only has two explicit methods to boot up SMP, PSCI and
> Parking protocol, but the Parking protocol is only specified for
> ARMv7 now, so make PSCI as the only way for the SMP boot protocol
> before some updates for the ACPI spec or the Parking protocol spec.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> ---
> +/**
> + * acpi_map_gic_cpu_interface - generates a logical cpu number
> + * and map to MPIDR represented by GICC structure
> + * @mpidr: CPU's hardware id to register, MPIDR represented in MADT
> + * @enabled: this cpu is enabled or not
> + *
> + * Returns the logical cpu number which maps to MPIDR
> + */
> +static int acpi_map_gic_cpu_interface(u64 mpidr, u8 enabled)
> +{
> +	int cpu;
> +
> +	if (mpidr == INVALID_HWID) {
> +		pr_info("Skip invalid cpu hardware ID\n");
> +		return -EINVAL;
> +	}
> +
> +	total_cpus++;
> +	if (!enabled)
> +		return -EINVAL;
> +
> +	if (enabled_cpus >=  NR_CPUS) {
> +		pr_warn("NR_CPUS limit of %d reached, Processor %d/0x%llx ignored.\n",
> +			NR_CPUS, total_cpus, mpidr);
> +		return -EINVAL;
> +	}
> +
> +	/* No need to check duplicate MPIDRs for the first CPU */
> +	if (enabled_cpus) {
> +		/*
> +		 * Duplicate MPIDRs are a recipe for disaster. Scan
> +		 * all initialized entries and check for
> +		 * duplicates. If any is found just ignore the CPU.
> +		 */
> +		for_each_possible_cpu(cpu) {
> +			if (cpu_logical_map(cpu) == mpidr) {
> +				pr_err("Firmware bug, duplicate CPU MPIDR: 0x%llx in MADT\n",
> +				mpidr);
> +				return -EINVAL;
> +			}
> +		}
> +	} else {
> +		/* Fist GICC entry must be BSP as ACPI spec said */
> +		if  (cpu_logical_map(0) != mpidr) {
> +			pr_err("First GICC entry is not BSP for MPIDR 0x%llx\n",
> +			       mpidr);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	/* allocate a logical cpu id for the new comer */
> +	if (cpu_logical_map(0) == mpidr) {
> +		/*
> +		 * boot_cpu_init() already hold bit 0 in cpu_present_mask
> +		 * for BSP, no need to allocate again.
> +		 */
> +		cpu = 0;
> +	} else {
> +		cpu = cpumask_next_zero(-1, cpu_possible_mask);
> +	}

Nit: so the above two if/else blocks are essentially testing for the
same condition: Is this the first cpu? or a secondary cpu? I would
merge the two into a single if/else block.

g.
