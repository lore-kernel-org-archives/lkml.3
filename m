Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3LJNDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:03:41 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:36386 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3LJNDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:03:38 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC part2 PATCH 4/9] ARM64 / ACPI: Use Parked Address in GIC structure for spin table SMP initialisation
To: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linaro-kernel@lists.linaro.org, linux-acpi@vger.kernel.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        Olof Johansson <olof@lixom.net>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Hanjun Guo <hanjun.guo@linaro.org>
In-Reply-To: <1385999094-3152-5-git-send-email-hanjun.guo@linaro.org>
References: <1385999094-3152-1-git-send-email-hanjun.guo@linaro.org> < 1385999094-3152-5-git-send-email-hanjun.guo@linaro.org>
Date: Tue, 10 Dec 2013 13:03:30 +0000
Message-Id: <20131210130330.65087C40A27@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Dec 2013 23:44:49 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> Parked Address in GIC structure can be used as cpu release address
> for spin table SMP initialisation.
> 
> This patch gets parked address from MADT and use it for SMP
> initialisation when DT is not available.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/include/asm/acpi.h      |    3 +++
>  arch/arm64/kernel/smp_spin_table.c |   16 +++++++++---
>  drivers/acpi/plat/arm-core.c       |   50 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 66 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index 423a32c..180de4a 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -90,6 +90,9 @@ extern int boot_cpu_apic_id;
>  
>  extern void prefill_possible_map(void);
>  
> +extern int acpi_get_parked_address_with_gic_id(u32 gic_id,
> +			u64 *parked_address);
> +
>  #else	/* !CONFIG_ACPI */
>  #define acpi_disabled 1		/* ACPI sometimes enabled on ARM */
>  #define acpi_noirq 1		/* ACPI sometimes enabled on ARM */
> diff --git a/arch/arm64/kernel/smp_spin_table.c b/arch/arm64/kernel/smp_spin_table.c
> index 44c2280..7997873 100644
> --- a/arch/arm64/kernel/smp_spin_table.c
> +++ b/arch/arm64/kernel/smp_spin_table.c
> @@ -25,6 +25,7 @@
>  #include <asm/cpu_ops.h>
>  #include <asm/cputype.h>
>  #include <asm/smp_plat.h>
> +#include <asm/acpi.h>
>  
>  extern void secondary_holding_pen(void);
>  volatile unsigned long secondary_holding_pen_release = INVALID_HWID;
> @@ -47,6 +48,11 @@ static void write_pen_release(u64 val)
>  	__flush_dcache_area(start, size);
>  }
>  
> +static int get_cpu_release_addr_acpi(unsigned int cpu, u64 *parked_address)
> +{
> +	return acpi_get_parked_address_with_gic_id(arm_cpu_to_apicid[cpu],
> +						parked_address);
> +}
>  
>  static int smp_spin_table_cpu_init(struct device_node *dn, unsigned int cpu)
>  {
> @@ -55,10 +61,14 @@ static int smp_spin_table_cpu_init(struct device_node *dn, unsigned int cpu)
>  	 */
>  	if (of_property_read_u64(dn, "cpu-release-addr",
>  				 &cpu_release_addr[cpu])) {
> -		pr_err("CPU %d: missing or invalid cpu-release-addr property\n",
> -		       cpu);
>  
> -		return -1;
> +		/* try ACPI way */
> +		if (get_cpu_release_addr_acpi(cpu, &cpu_release_addr[cpu])) {
> +			pr_err("CPU %d: missing or invalid cpu-release-addr property\n",
> +				cpu);
> +
> +			return -1;
> +		}
>  	}
>  
>  	return 0;
> diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
> index 8527ecc..c4c8c68 100644
> --- a/drivers/acpi/plat/arm-core.c
> +++ b/drivers/acpi/plat/arm-core.c
> @@ -262,6 +262,56 @@ static int __init acpi_parse_madt_gic_entries(void)
>  	return 0;
>  }
>  
> +/* Parked Address in ACPI GIC structure can be used as cpu release addr */
> +int acpi_get_parked_address_with_gic_id(u32 gic_id, u64 *parked_address)
> +{
> +	struct acpi_table_header *table_header = NULL;
> +	struct acpi_subtable_header *entry;
> +	int err = 0;
> +	unsigned long table_end;
> +	acpi_size tbl_size;
> +	struct acpi_madt_generic_interrupt *processor = NULL;
> +
> +	if (!parked_address)
> +		return -EINVAL;
> +
> +	acpi_get_table_with_size(ACPI_SIG_MADT, 0, &table_header, &tbl_size);
> +	if (!table_header) {
> +		pr_warn(PREFIX "MADT table not present\n");
> +		return -ENODEV;
> +	}
> +
> +	table_end = (unsigned long)table_header + table_header->length;
> +
> +	/* Parse all entries looking for a match. */
> +	entry = (struct acpi_subtable_header *)
> +	    ((unsigned long)table_header + sizeof(struct acpi_table_madt));
> +
> +	while (((unsigned long)entry) + sizeof(struct acpi_subtable_header) <
> +	       table_end) {
> +		if (entry->type != ACPI_MADT_TYPE_GENERIC_INTERRUPT
> +			|| BAD_MADT_ENTRY(entry, table_end))
> +			continue;
> +
> +		processor = (struct acpi_madt_generic_interrupt *)entry;
> +
> +		if (processor->gic_id == gic_id) {
> +			*parked_address = processor->parked_address;
> +			goto out;
> +		}
> +
> +		entry = (struct acpi_subtable_header *)
> +		    ((unsigned long)entry + entry->length);

All of the casting in this table looks suspicious. If you have to resort
to casting, then the variable types are very likely wrong.

In the case immediately above, it seems that the entry size doesn't
necessarily equal the acpi_subtable_header size, in which case you
should cast the values to a void* instead of an unsigned long. That
would mean you can do this:

	entry = ((void*)entry) + entry->length;

In fact, if I were writing the code, I would have two variables; the
iterator pointer as a void* and a header pointer as a struct
acpi_subtable_header*. Like so:

	void *entry, *table_end;
	struct acpi_subtable_header *header;

	entry = ((void*)table_header) + sizeof(struct acpi_table_madt);
	table_end = ((void*)table_header) + table_header->length;
	while (entry + sizeof(*header)) < table_end) {
		header = entry;

		if (header->type != ACPI_MADT_TYPE_GENERIC_INTERRUPT ||
			BAD_MADT_ENTRY(entry, table_end))
			continue;
		processor = entry;

		if (processor->gic_id == gic_id) {
			*parked_address = processor->parked_address;
			goto out;
		}

		entry += header->length;
	}

See? Much cleaner code.

g.
