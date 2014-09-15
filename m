Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaIOHfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 03:35:38 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48649 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbaIOHeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 03:34:17 -0400
Date: Mon, 15 Sep 2014 00:05:31 -0700
From: Olof Johansson <olof@lixom.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jon Masters <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
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
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v4 12/18] ACPI / processor: Make it possible to get CPU
 hardware ID via GICC
Message-ID: <20140915070531.GF26649@localhost>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <1410530416-30200-13-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410530416-30200-13-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 10:00:10PM +0800, Hanjun Guo wrote:
> Introduce a new function map_gicc_mpidr() to allow MPIDRs to be obtained
> from the GICC Structure introduced by ACPI 5.1.
> 
> MPIDR is the CPU hardware ID as local APIC ID on x86 platform, so we use
> MPIDR not the GIC CPU interface ID to identify CPUs.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/include/asm/acpi.h |   32 ++++++++++++++++++++++++++++++++
>  arch/arm64/kernel/acpi.c      |    1 -
>  drivers/acpi/processor_core.c |   37 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 69 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index da8f74a..2c48f70e 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -12,6 +12,8 @@
>  #ifndef _ASM_ACPI_H
>  #define _ASM_ACPI_H
>  
> +#include <asm/smp_plat.h>
> +
>  /* Basic configuration for ACPI */
>  #ifdef	CONFIG_ACPI
>  #define acpi_strict 1	/* No out-of-spec workarounds on ARM64 */
> @@ -38,6 +40,36 @@ static inline void disable_acpi(void)
>  	acpi_noirq = 1;
>  }
>  
> +/* MPIDR value provided in GICC structure is 64 bits, but
> + * the acpi processor driver use the 32 bits cpu hardware
> + * ID (apic_id on intel platform) everywhere, it is pretty
> + * hard to modify the acpi processor driver to accept the
> + * 64 bits MPIDR value, at the same time, only 32 bits of
> + * the MPIDR is used in the 64 bits MPIDR, just pack the
> + * Affx fields into a single 32 bit identifier to accommodate
> + * the acpi processor drivers.
> + */

This is a pretty run-on comment.

I'd much rather value something like:

Existing apic_id is 32-bit, to conform to the same datatype we need to repack the GICC
structure MPIDR.

The two formats are:

<show how the 64-bit format is laid out>
<show how the 32-bit format is laid out>


> +static inline u32 pack_mpidr_into_32_bits(u64 mpidr)

That's a pretty long name for an exported function.

> +{
> +	/*
> +	 * Bits [0:7] Aff0;
> +	 * Bits [8:15] Aff1;
> +	 * Bits [16:23] Aff2;
> +	 * Bits [32:39] Aff3;
> +	 */

With the format description above added, then this comment can be removed.

> +	return (u32) ((mpidr & 0xff00000000) >> 8) | mpidr;
> +}
> +
> +/*
> + * The ACPI processor driver for ACPI core code needs this macro
> + * to find out this cpu was already mapped (mapping from CPU hardware
> + * ID to CPU logical ID) or not.
> + *
> + * cpu_logical_map(cpu) is the mapping of MPIDR and the logical cpu,
> + * and MPIDR is the cpu hardware ID we needed to pack.
> + */
> +#define cpu_physical_id(cpu) pack_mpidr_into_32_bits(cpu_logical_map(cpu))
> +
>  /*
>   * It's used from ACPI core in kdump to boot UP system with SMP kernel,
>   * with this check the ACPI core will not override the CPU index
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index 644b8b8..2ef8721 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -24,7 +24,6 @@
>  #include <linux/bootmem.h>
>  #include <linux/smp.h>
>  
> -#include <asm/smp_plat.h>
>  #include <asm/cputype.h>
>  #include <asm/cpu_ops.h>
>  
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index e32321c..4007313 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -64,6 +64,38 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
>  	return 0;
>  }
>  
> +/*
> + * On ARM platform, MPIDR value is the hardware ID as apic ID
> + * on Intel platforms
> + */
> +static int map_gicc_mpidr(struct acpi_subtable_header *entry,
> +		int device_declaration, u32 acpi_id, int *mpidr)
> +{
> +	struct acpi_madt_generic_interrupt *gicc =
> +	    container_of(entry, struct acpi_madt_generic_interrupt, header);
> +
> +	if (!(gicc->flags & ACPI_MADT_ENABLED))
> +		return -ENODEV;
> +
> +	/* In the GIC interrupt model, logical processors are
> +	 * required to have a Processor Device object in the DSDT,
> +	 * so we should check device_declaration here
> +	 */
> +	if (device_declaration && (gicc->uid == acpi_id)) {
> +		/*
> +		 * Only bits [0:7] Aff0, bits [8:15] Aff1, bits [16:23] Aff2
> +		 * and bits [32:39] Aff3 are meaningful, so pack the Affx
> +		 * fields into a single 32 bit identifier to accommodate the
> +		 * acpi processor drivers.
> +		 */

Here's duplicated information again. Reusing the same macro as in the header file
would help overall readability, I think.

> +		*mpidr = ((gicc->arm_mpidr & 0xff00000000) >> 8)
> +			 | gicc->arm_mpidr;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
>  static int map_madt_entry(int type, u32 acpi_id)
>  {
>  	unsigned long madt_end, entry;
> @@ -99,6 +131,9 @@ static int map_madt_entry(int type, u32 acpi_id)
>  		} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
>  			if (!map_lsapic_id(header, type, acpi_id, &apic_id))
>  				break;
> +		} else if (header->type == ACPI_MADT_TYPE_GENERIC_INTERRUPT) {
> +			if (!map_gicc_mpidr(header, type, acpi_id, &apic_id))
> +				break;
>  		}
>  		entry += header->length;
>  	}
> @@ -131,6 +166,8 @@ static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
>  		map_lsapic_id(header, type, acpi_id, &apic_id);
>  	} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
>  		map_x2apic_id(header, type, acpi_id, &apic_id);
> +	} else if (header->type == ACPI_MADT_TYPE_GENERIC_INTERRUPT) {
> +		map_gicc_mpidr(header, type, acpi_id, &apic_id);
>  	}
>  
>  exit:
> -- 
> 1.7.9.5
> 
