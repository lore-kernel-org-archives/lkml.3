Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbaICQ1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:27:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39369 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaICQ1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:27:45 -0400
Date: Wed, 3 Sep 2014 17:27:39 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v3 10/17] ACPI / processor: Make it possible to get CPU
 hardware ID via GICC
Message-ID: <20140903162739.GF1824@e102568-lin.cambridge.arm.com>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
 <1409583475-6978-11-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
In-Reply-To: <1409583475-6978-11-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 03 Sep 2014 16:27:40.0805 (UTC) FILETIME=[FB58BB50:01CFC793]
X-MC-Unique: 114090317274210001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanjun,

On Mon, Sep 01, 2014 at 03:57:48PM +0100, Hanjun Guo wrote:
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
> index e013dbb..a867467 100644
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

I have comments on the code in this patch, but they are not the most
important point. What I am really worried about, it is that as ARM,
I do not want to know what an apic_id is. This code is *supposed* to be
generic and yet it is chock-full of x86 specific stuff and you are
trying to make ARM HW concepts fit with x86 ones, and I am not happy
with that.

To be clearer, why does not this look-up of:

logical-cpu-index -> physical-cpu-index

is not carried out using the acpi_id ? Every architecture will have to
add arch specific code to carry out the reverse look-up:

acpi_id -> apic_id (x86)
acpi_id -> mpidr_el1 (arm64)

and the code would end up being split in a nice way. On top of that, I wonder
why ACPI structures like eg struct acpi_processor contain x86 specific
data (ie apic_id). I know it is a HW identifier as the MPIDR_EL1 is on
arm64, but I do not want to deal with that in generic ACPI code because
that's not generic at ALL.

What if another architecture wants to use ACPI ? Are we going to map its
HW CPU identifier to an apic_id only because that's what x86 requires ?

I am sorry I do not like that. I understand it is easier to map ARM code
to existing ACPI structures but I feel we will run into issues very soon
because of that.

Is it that complex to remove the apic_id dependency in *generic* ACPI
code and replace it with functions that hook into arch specific code to
carry out the logical to physical cpu mappings ?

I understand this is harder to do, but it will make your life easier
in the long run. I am thinking of other pieces of code like the
supposedly generic ACPI CPUidle driver, where we *still* depend on the apic
to detect idle states, this is not going to fly, I am sorry, we need to
have code that has a chance to be generic from the beginning not as an
afterthought.

Lorenzo

> +static inline u32 pack_mpidr_into_32_bits(u64 mpidr)
> +{
> +	/*
> +	 * Bits [0:7] Aff0;
> +	 * Bits [8:15] Aff1;
> +	 * Bits [16:23] Aff2;
> +	 * Bits [32:39] Aff3;
> +	 */
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
> index fbaaf01..35dff11 100644
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

