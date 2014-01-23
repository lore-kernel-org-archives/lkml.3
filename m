Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbaAWRyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:54:35 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:34606 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753415AbaAWRye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:54:34 -0500
Message-ID: <52E15756.4060705@arm.com>
Date: Thu, 23 Jan 2014 17:54:30 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Subject: Re: [PATCH 09/20] ARM64 / ACPI: Implement core functions for parsing
 MADT table
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-10-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1389961514-13562-10-git-send-email-hanjun.guo@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanjun,

On 17/01/14 12:25, Hanjun Guo wrote:
> Implement core functions for parsing MADT table to get the information
> about GIC cpu interface and GIC distributor to prepare for SMP and GIC
> initialization.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/include/asm/acpi.h |    3 +
>  drivers/acpi/plat/arm-core.c  |  139 ++++++++++++++++++++++++++++++++++++++++-
>  drivers/acpi/tables.c         |   21 +++++++
>  3 files changed, 162 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index e108d9c..c335c6d 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -83,6 +83,9 @@ void arch_fix_phys_package_id(int num, u32 slot);
>  extern int (*acpi_suspend_lowlevel)(void);
>  #define acpi_wakeup_address (0)
>  
> +#define MAX_GIC_CPU_INTERFACE 256

I'll bite. Where on Earth is this value coming from? If that's for
GICv2, 8 is the maximum. For GICv3+, that's incredibly low, and should
be probed probed at runtime anyway.

> +#define MAX_GIC_DISTRIBUTOR   1		/* should be the same as MAX_GIC_NR */

No support for cascaded GICs?

> +
>  #else	/* !CONFIG_ACPI */
>  #define acpi_disabled 1		/* ACPI sometimes enabled on ARM */
>  #define acpi_noirq 1		/* ACPI sometimes enabled on ARM */
> diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
> index 1835b21..8ba3e6f 100644
> --- a/drivers/acpi/plat/arm-core.c
> +++ b/drivers/acpi/plat/arm-core.c
> @@ -46,6 +46,16 @@ EXPORT_SYMBOL(acpi_disabled);
>  int acpi_pci_disabled;		/* skip ACPI PCI scan and IRQ initialization */
>  EXPORT_SYMBOL(acpi_pci_disabled);
>  
> +/*
> + * Local interrupt controller address,
> + * GIC cpu interface base address on ARM/ARM64
> + */
> +static u64 acpi_lapic_addr __initdata;

If that's a GIC address, why not call it as such?

> +#define BAD_MADT_ENTRY(entry, end) (					\
> +	(!entry) || (unsigned long)entry + sizeof(*entry) > end ||	\
> +	((struct acpi_subtable_header *)entry)->length < sizeof(*entry))
> +
>  #define PREFIX			"ACPI: "

Just do:
#define pr_fmt(fmt)	"ACPI: " fmt

and remove all the occurrences of PREFIX.

>  /* FIXME: this function should be moved to topology.c when it is ready */
> @@ -92,6 +102,115 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
>  	return;
>  }
>  
> +static int __init acpi_parse_madt(struct acpi_table_header *table)
> +{
> +	struct acpi_table_madt *madt = NULL;

No need to initialize this to NULL, you're doing an assignment at the
next line...

> +
> +	madt = (struct acpi_table_madt *)table;
> +	if (!madt) {
> +		pr_warn(PREFIX "Unable to map MADT\n");

There is no mapping here, please fix the message accordingly.

> +		return -ENODEV;
> +	}
> +
> +	if (madt->address) {
> +		acpi_lapic_addr = (u64) madt->address;

So you're updating this static variable, for the distributor and each
CPU interface? /me puzzled...

> +		pr_info(PREFIX "Local APIC address 0x%08x\n", madt->address);

Away with this APIC madness. GICC and GICD are the concepts we're all
familiar with here, and using the proper terminology would certainly
help reviewing these patches...

> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * GIC structures on ARM are somthing like Local APIC structures on x86,
> + * which means GIC cpu interfaces for GICv2/v3. Every GIC structure in
> + * MADT table represents a cpu in the system.

And what do you do when your GICv3 doesn't have a memory-mapped
interface, but only uses system registers?

> + * GIC distributor structures are somthing like IOAPIC on x86. GIC can
> + * be initialized with information in this structure.
> + *
> + * Please refer to chapter5.2.12.14/15 of ACPI 5.0

A pointer to that documentation?

> + */
> +
> +static int __init
> +acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
> +{
> +	struct acpi_madt_generic_interrupt *processor = NULL;
> +
> +	processor = (struct acpi_madt_generic_interrupt *)header;
> +
> +	if (BAD_MADT_ENTRY(processor, end))
> +		return -EINVAL;
> +
> +	acpi_table_print_madt_entry(header);
> +
> +	return 0;
> +}
> +
> +static int __init
> +acpi_parse_gic_distributor(struct acpi_subtable_header *header,
> +				const unsigned long end)
> +{
> +	struct acpi_madt_generic_distributor *distributor = NULL;
> +
> +	distributor = (struct acpi_madt_generic_distributor *)header;
> +
> +	if (BAD_MADT_ENTRY(distributor, end))
> +		return -EINVAL;
> +
> +	acpi_table_print_madt_entry(header);
> +
> +	return 0;
> +}
> +
> +/*
> + * Parse GIC cpu interface related entries in MADT
> + * returns 0 on success, < 0 on error
> + */
> +static int __init acpi_parse_madt_gic_entries(void)
> +{
> +	int count;
> +
> +	/*
> +	 * do a partial walk of MADT to determine how many CPUs
> +	 * we have including disabled CPUs
> +	 */
> +	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> +				acpi_parse_gic, MAX_GIC_CPU_INTERFACE);
> +
> +	if (!count) {
> +		pr_err(PREFIX "No GIC entries present\n");
> +		return -ENODEV;
> +	} else if (count < 0) {
> +		pr_err(PREFIX "Error parsing GIC entry\n");
> +		return count;
> +	}

So you do a lot of parsing to count stuff, and then discard the number
of counted objects... You might as well check that there is at least one
valid object and stop there.

> +	return 0;
> +}
> +
> +/*
> + * Parse GIC distributor related entries in MADT
> + * returns 0 on success, < 0 on error
> + */
> +static int __init acpi_parse_madt_gic_distributor_entries(void)
> +{
> +	int count;
> +
> +	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
> +			acpi_parse_gic_distributor, MAX_GIC_DISTRIBUTOR);
> +
> +	if (!count) {
> +		pr_err(PREFIX "No GIC distributor entries present\n");
> +		return -ENODEV;
> +	} else if (count < 0) {
> +		pr_err(PREFIX "Error parsing GIC distributor entry\n");
> +		return count;
> +	}
> +
> +	return 0;
> +}
> +
>  int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
>  {
>  	*irq = gsi_to_irq(gsi);
> @@ -141,11 +260,29 @@ static int __init acpi_parse_fadt(struct acpi_table_header *table)
>  
>  static void __init early_acpi_process_madt(void)
>  {
> -	return;
> +	acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt);
>  }
>  
>  static void __init acpi_process_madt(void)
>  {
> +	int error;
> +
> +	if (!acpi_table_parse(ACPI_SIG_MADT, acpi_parse_madt)) {

How many times are you going to parse the same table? Surely you can
stash whatever information you need and be done with it?

> +		/*
> +		 * Parse MADT GIC cpu interface entries
> +		 */
> +		error = acpi_parse_madt_gic_entries();
> +		if (!error) {
> +			/*
> +			 * Parse MADT GIC distributor entries
> +			 */
> +			acpi_parse_madt_gic_distributor_entries();
> +		}
> +	}
> +
> +	pr_info("Using ACPI for processor (GIC) configuration information\n");
> +
>  	return;
>  }
>  
> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
> index d67a1fe..b3e4615 100644
> --- a/drivers/acpi/tables.c
> +++ b/drivers/acpi/tables.c
> @@ -191,6 +191,27 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
>  		}
>  		break;
>  
> +	case ACPI_MADT_TYPE_GENERIC_INTERRUPT:
> +		{
> +			struct acpi_madt_generic_interrupt *p =
> +				(struct acpi_madt_generic_interrupt *)header;
> +			printk(KERN_INFO PREFIX

Use pr_info

> +			       "GIC (acpi_id[0x%04x] gic_id[0x%04x] %s)\n",
> +			       p->uid, p->gic_id,
> +			       (p->flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
> +		}
> +		break;
> +
> +	case ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR:
> +		{
> +			struct acpi_madt_generic_distributor *p =
> +				(struct acpi_madt_generic_distributor *)header;
> +			printk(KERN_INFO PREFIX
> +			       "GIC Distributor (id[0x%04x] address[0x%08llx] gsi_base[%d])\n",
> +			       p->gic_id, p->base_address, p->global_irq_base);
> +		}
> +		break;
> +
>  	default:
>  		printk(KERN_WARNING PREFIX
>  		       "Found unsupported MADT entry (type = 0x%x)\n",
> 

Most of that code seems to be repeatedly parsing and printing stuff, and
I fail to see what it actually does.

	M.
-- 
Jazz is not dead. It just smells funny...
