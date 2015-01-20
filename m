Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbbATQQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:16:54 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39313 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbbATQQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:16:52 -0500
Date: Tue, 20 Jan 2015 16:16:46 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v7 11/17] ACPI / processor: Make it possible to get CPU
 hardware ID via GICC
Message-ID: <20150120161646.GJ5398@red-moon>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <1421247905-3749-12-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421247905-3749-12-git-send-email-hanjun.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 03:04:59PM +0000, Hanjun Guo wrote:
> Introduce a new function map_gicc_mpidr() to allow MPIDRs to be obtained
> from the GICC Structure introduced by ACPI 5.1.
> 
> MPIDR is the CPU hardware ID as local APIC ID on x86 platform, so we use
> MPIDR not the GIC CPU interface ID to identify CPUs.
> 
> Tested-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Tested-by: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/include/asm/acpi.h | 29 +++++++++++++++++++++++++++++
>  arch/arm64/kernel/acpi.c      |  1 -
>  drivers/acpi/processor_core.c | 37 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index c82d4a1..639bb2a 100644
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

Do we need this mpidr packing only because in drivers/acpi/processor_core.c
phys_id is defined as an int ?

What you could do, is to typedef a cpuid_t type in arch code (with
appropriate size and a corresponding invalid value, say ~0) and use that
instead of an int in drivers/acpi/processor_core.c to store phys_id.

phys_id is used as an error value too (ie -1 as a magic number), see
drivers/acpi/acpi_processor.c, retrieved through acpi_get_phys_id(),
it should not be that difficult to change the parsing API to keep current
code behaviour unchanged and define at the same time a proper type for
the cpu physical identifier, with no mpidr packing needed whatsoever.

Thanks,
Lorenzo
