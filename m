Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaHRScp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:32:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58418 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaHRScn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:32:43 -0400
Message-ID: <53F2472F.5060400@arm.com>
Date: Mon, 18 Aug 2014 19:34:23 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v2 09/18] ACPI / processor: Make it possible to get CPU
 hardware ID via GICC
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <1407166105-17675-10-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1407166105-17675-10-git-send-email-hanjun.guo@linaro.org>
X-OriginalArrivalTime: 18 Aug 2014 18:32:39.0925 (UTC) FILETIME=[CA8FA250:01CFBB12]
X-MC-Unique: 114081819324100501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/08/14 16:28, Hanjun Guo wrote:
> Introduce a new function map_gicc_mpidr() to allow MPIDRs to be obtained
> from the GICC Structure introduced by ACPI 5.1.
>
> MPIDR is the CPU hardware ID as local APIC ID on x86 platform, so we use
> MPIDR not the GIC CPU interface ID to identify CPUs.
>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>   arch/arm64/include/asm/acpi.h |   14 ++++++++++++++
>   arch/arm64/kernel/acpi.c      |   21 ++++++++++++++++++++-
>   drivers/acpi/processor_core.c |   37 +++++++++++++++++++++++++++++++++++++
>   3 files changed, 71 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index 022f4ad..a81898d 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -12,6 +12,8 @@
>   #ifndef _ASM_ACPI_H
>   #define _ASM_ACPI_H
>
> +#include <asm/smp_plat.h>
> +
>   /* Basic configuration for ACPI */
>   #ifdef	CONFIG_ACPI
>   /*
> @@ -59,6 +61,18 @@ static inline void disable_acpi(void)
>   	acpi_noirq = 1;
>   }
>
> +u32 pack_mpidr_into_32_bits(u64 mpidr);
> +
> +/*
> + * The ACPI processor driver for ACPI core code needs this macro
> + * to find out this cpu was already mapped (mapping from CPU hardware
> + * ID to CPU logical ID) or not.
> + *
> + * cpu_logical_map(cpu) is the mapping of MPIDR and the logical cpu,
> + * and MPIDR is the cpu hardware ID we needed.

You need to specify this is packed version of cpu_logical_map or
better is to move pack_mpidr_into_32_bits here along with the
description you have so that it's easy to understand.

> + */
> +#define cpu_physical_id(cpu) pack_mpidr_into_32_bits(cpu_logical_map(cpu))
> +
>   /*
>    * Checking for the posibility that the CPU can be initialized from the MADT.
>    * It's used from ACPI core in crash kernel case where boot CPU is not
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index 8a54b4e..ac7ab34 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -22,7 +22,6 @@
>   #include <linux/bootmem.h>
>   #include <linux/smp.h>
>
> -#include <asm/smp_plat.h>
>   #include <asm/cputype.h>
>
>   int acpi_noirq;			/* skip ACPI IRQ initialization */
> @@ -239,6 +238,26 @@ int __init acpi_boot_init(void)
>   	return err;
>   }
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
> +u32 pack_mpidr_into_32_bits(u64 mpidr)
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
>   /*
>    * acpi_suspend_lowlevel() - save kernel state and suspend.
>    *
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index e32321c..4007313 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -64,6 +64,38 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
>   	return 0;
>   }
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

Reuse pack_mpidr_into_32_bits

> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
>   static int map_madt_entry(int type, u32 acpi_id)
>   {
>   	unsigned long madt_end, entry;
> @@ -99,6 +131,9 @@ static int map_madt_entry(int type, u32 acpi_id)
>   		} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
>   			if (!map_lsapic_id(header, type, acpi_id, &apic_id))
>   				break;
> +		} else if (header->type == ACPI_MADT_TYPE_GENERIC_INTERRUPT) {
> +			if (!map_gicc_mpidr(header, type, acpi_id, &apic_id))
> +				break;
>   		}
>   		entry += header->length;
>   	}
> @@ -131,6 +166,8 @@ static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
>   		map_lsapic_id(header, type, acpi_id, &apic_id);
>   	} else if (header->type == ACPI_MADT_TYPE_LOCAL_X2APIC) {
>   		map_x2apic_id(header, type, acpi_id, &apic_id);
> +	} else if (header->type == ACPI_MADT_TYPE_GENERIC_INTERRUPT) {
> +		map_gicc_mpidr(header, type, acpi_id, &apic_id);
>   	}
>
>   exit:
>

