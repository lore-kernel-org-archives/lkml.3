Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbaJXRjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:39:35 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48436 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbaJXRjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:39:33 -0400
Date: Fri, 24 Oct 2014 18:39:20 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "Kangkang.Shen@huawei.com" <Kangkang.Shen@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v5 12/18] ACPI / processor: Make it possible to get CPU
 hardware ID via GICC
Message-ID: <20141024173920.GB8303@red-moon>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <1413553034-20956-13-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413553034-20956-13-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 02:37:08PM +0100, Hanjun Guo wrote:
> Introduce a new function map_gicc_mpidr() to allow MPIDRs to be obtained
> from the GICC Structure introduced by ACPI 5.1.
> 
> MPIDR is the CPU hardware ID as local APIC ID on x86 platform, so we use
> MPIDR not the GIC CPU interface ID to identify CPUs.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/include/asm/acpi.h |   29 +++++++++++++++++++++++++++++
>  arch/arm64/kernel/acpi.c      |    1 -
>  drivers/acpi/processor_core.c |   37 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index c82d4a1..483ff45 100644
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
> @@ -45,6 +47,33 @@ static inline void enable_acpi(void)
>  	acpi_noirq = 0;
>  }
>  
> +/* MPIDR value provided in GICC structure is 64 bits, but the
> + * existing apic_id (CPU hardware ID) using in acpi processor
> + * driver is 32-bit, to conform to the same datatype we need
> + * to repack the GICC structure MPIDR.
> + *
> + * Only 32 bits of MPIDR are used:
> + * 
> + * Bits [0:7] Aff0;
> + * Bits [8:15] Aff1;
> + * Bits [16:23] Aff2;
> + * Bits [32:39] Aff3;
> + */
> +static inline u32 pack_mpidr(u64 mpidr)
> +{
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
> +#define cpu_physical_id(cpu) pack_mpidr(cpu_logical_map(cpu))
> +
>  /*
>   * It's used from ACPI core in kdump to boot UP system with SMP kernel,
>   * with this check the ACPI core will not override the CPU index
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index 34837e0..e91ec76 100644
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
> +		*mpidr = ((gicc->arm_mpidr & 0xff00000000) >> 8)
> +			 | gicc->arm_mpidr;

The simple fact that you define a function to pack the mpidr value and
you can't use it here because this is *generic* code is telling, and
a very bad omen. At the cost of sounding like a broken record, I do not
like this mpidr->apic->logical_cpu song and dance at all.
ACPI is peppered with code (eg hotplug is another example, CPUidle driver
even worse) that is supposed to be generic but contains x86 code to carry
out this cpuid conversion, I really think that in order to start an ARM64
ACPI port properly we should at least try to factor out this physical to
logical cpu id conversion, and it is not the first time that I mention this
on the lists.

I will also talk to Rafael about this at the earliest opportunity, I
guess that x86 code relies on apic-id because some ACPI versions could
not rely on the acpi-id or some other reasons I have to investigate.

Thanks,
Lorenzo

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
> 
