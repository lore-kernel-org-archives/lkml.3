Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3LCRJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:09:47 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:49967 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab3LCRJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:09:44 -0500
MIME-Version: 1.0
In-Reply-To: <1386088753-2850-10-git-send-email-hanjun.guo@linaro.org>
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
	<1386088753-2850-10-git-send-email-hanjun.guo@linaro.org>
Date: Tue, 3 Dec 2013 11:09:43 -0600
Message-ID: <CAL_Jsq+XWn5ns850mV6Jvm0W4+TPh8c0aWANZPAqSPmmsDMWoQ@mail.gmail.com>
Subject: Re: [RFC part2 PATCH 9/9] ACPI / GIC: Initialize GIC using the
 information in MADT
From: Rob Herring <robherring2@gmail.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Linaro Patches <patches@linaro.org>, Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 10:39 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> In MADT table, there are GIC cpu interface base address and
> GIC distributor base address, use them to convert GIC to ACPI.
>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/kernel/irq.c      |    5 ++++
>  drivers/acpi/plat/arm-core.c |   66 ++++++++++++++++++++++++++++++++++++------
>  include/linux/acpi.h         |    6 ++++
>  3 files changed, 68 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
> index 473e5db..a9e68bf 100644
> --- a/arch/arm64/kernel/irq.c
> +++ b/arch/arm64/kernel/irq.c
> @@ -25,6 +25,7 @@
>  #include <linux/irq.h>
>  #include <linux/smp.h>
>  #include <linux/init.h>
> +#include <linux/acpi.h>
>  #include <linux/irqchip.h>
>  #include <linux/seq_file.h>
>  #include <linux/ratelimit.h>
> @@ -78,6 +79,10 @@ void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
>  void __init init_IRQ(void)
>  {
>         irqchip_init();
> +
> +       if (!handle_arch_irq)
> +               acpi_gic_init();
> +
>         if (!handle_arch_irq)
>                 panic("No interrupt controller found.");
>  }
> diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
> index 17c99e1..509b847 100644
> --- a/drivers/acpi/plat/arm-core.c
> +++ b/drivers/acpi/plat/arm-core.c
> @@ -29,6 +29,7 @@
>  #include <linux/module.h>
>  #include <linux/irq.h>
>  #include <linux/irqdomain.h>
> +#include <linux/irqchip/arm-gic.h>
>  #include <linux/slab.h>
>  #include <linux/bootmem.h>
>  #include <linux/ioport.h>
> @@ -211,11 +212,21 @@ acpi_parse_gic(struct acpi_subtable_header *header, const unsigned long end)
>         return 0;
>  }
>
> +#ifdef CONFIG_ARM_GIC

Perhaps this should go in the GIC code? This is more of a general
question of where init/probing code goes. For DT, this as been with
the driver code.

> +/*
> + * Hard code here, we can not get memory size from MADT (but FDT does),
> + * this size is described in ARMv8 foudation model's User Guide
> + */
> +#define GIC_DISTRIBUTOR_MEMORY_SIZE (SZ_8K)
> +#define GIC_CPU_INTERFACE_MEMORY_SIZE (SZ_4K)

You have the sizes swapped. The cpu interface has the DIR register at 0x1000.

> +
>  static int __init
>  acpi_parse_gic_distributor(struct acpi_subtable_header *header,
>                                 const unsigned long end)
>  {
>         struct acpi_madt_generic_distributor *distributor = NULL;
> +       void __iomem *dist_base = NULL;
> +       void __iomem *cpu_base = NULL;

Initialization here is unnecessary.

>
>         distributor = (struct acpi_madt_generic_distributor *)header;
>
> @@ -224,8 +235,43 @@ acpi_parse_gic_distributor(struct acpi_subtable_header *header,
>
>         acpi_table_print_madt_entry(header);
>
> +       /* GIC is initialised after page_init(), no need for early_ioremap */
> +       dist_base = ioremap(distributor->base_address,
> +                               GIC_CPU_INTERFACE_MEMORY_SIZE);

Should be GIC_DISTRIBUTOR_MEMORY_SIZE.

> +       if (!dist_base) {
> +               pr_warn(PREFIX "unable to map gic dist registers\n");
> +               return -ENOMEM;
> +       }
> +
> +       /*
> +        * acpi_lapic_addr is stored in acpi_parse_madt(),
> +        * so we can use it here for GIC init
> +        */
> +       if (acpi_lapic_addr) {

Checking this first would be cleaner.

> +               iounmap(dist_base);
> +               pr_warn(PREFIX "Invalid GIC cpu interface base address\n");
> +               return -EINVAL;
> +       }
> +
> +       cpu_base = ioremap(acpi_lapic_addr, GIC_CPU_INTERFACE_MEMORY_SIZE);

How are gic's with different cpu address per core going to be handled?

> +       if (!cpu_base) {
> +               iounmap(dist_base);
> +               pr_warn(PREFIX "unable to map gic cpu registers\n");

All the printks are a bit verbose for my tastes. I think a single
error print would suffice.

> +               return -ENOMEM;
> +       }
> +
> +       gic_init(distributor->gic_id, -1, dist_base, cpu_base);
> +
>         return 0;
>  }
> +#else
> +static int __init
> +acpi_parse_gic_distributor(struct acpi_subtable_header *header,
> +                               const unsigned long end)
> +{
> +       return -ENODEV;
> +}
> +#endif /* CONFIG_ARM_GIC */

A "if (!IS_ENABLED(CONFIG_ARM_GIC)) return;" in the above function
would eliminate this ifdef.

>
>  /*
>   * Parse GIC cpu interface related entries in MADT
> @@ -234,7 +280,7 @@ acpi_parse_gic_distributor(struct acpi_subtable_header *header,
>  static int __init acpi_parse_madt_gic_entries(void)
>  {
>         int count;
> -
> +

Unnecessary whitespace change.

>         /*
>          * do a partial walk of MADT to determine how many CPUs
>          * we have including disabled CPUs
> @@ -468,19 +514,21 @@ static void __init acpi_process_madt(void)
>                  * Parse MADT GIC cpu interface entries
>                  */
>                 error = acpi_parse_madt_gic_entries();
> -               if (!error) {
> -                       /*
> -                        * Parse MADT GIC distributor entries
> -                        */
> -                       acpi_parse_madt_gic_distributor_entries();
> -               }
> +               if (!error)
> +                       pr_info("Using ACPI for processor (GIC) configuration information\n");
>         }
>
> -       pr_info("Using ACPI for processor (GIC) configuration information\n");
> -
>         return;
>  }
>
> +int __init acpi_gic_init(void)
> +{
> +       /*
> +        * Parse MADT GIC distributor entries
> +        */
> +       return acpi_parse_madt_gic_distributor_entries();
> +}
> +
>  /*
>   * acpi_boot_table_init() and acpi_boot_init()
>   *  called from setup_arch(), always.
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index edd5806..58a4bf4 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -112,6 +112,7 @@ char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
>  void __acpi_unmap_table(char *map, unsigned long size);
>  int early_acpi_boot_init(void);
>  int acpi_boot_init (void);
> +int acpi_gic_init(void);
>  void acpi_boot_table_init (void);
>  int acpi_mps_check (void);
>  int acpi_numa_init (void);
> @@ -444,6 +445,11 @@ static inline int acpi_boot_init(void)
>         return 0;
>  }
>
> +static inline int acpi_gic_init(void)
> +{
> +       return -ENODEV;
> +}
> +
>  static inline void acpi_boot_table_init(void)
>  {
>         return;
> --
> 1.7.9.5
>
>
> _______________________________________________
> linaro-kernel mailing list
> linaro-kernel@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-kernel
