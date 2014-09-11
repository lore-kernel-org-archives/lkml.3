Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaIKNn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:43:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36271 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaIKNn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:43:56 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 13/17] ARM64 / ACPI: Add GICv2 specific ACPI boot
 support
To: Marc Zyngier <marc.zyngier@arm.com>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
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
In-Reply-To: <5405BFE7.5060005@arm.com>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
	<1409583475-6978-14-git-send-email-hanjun.guo@linaro.org>
	<5404AE56.80801@arm.com> <5405AE95.1020201@linaro.org>
	<5405BFE7.5060005@arm.com>
Date: Thu, 11 Sep 2014 14:43:46 +0100
Message-Id: <20140911134346.C9027C408F6@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2014 14:02:31 +0100, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 02/09/14 12:48, Tomasz Nowicki wrote:
> > On 01.09.2014 19:35, Marc Zyngier wrote:
> >> On 01/09/14 15:57, Hanjun Guo wrote:
> >>> From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> >>>
> >>> ACPI kernel uses MADT table for proper GIC initialization. It needs to
> >>> parse GIC related subtables, collect CPU interface and distributor
> >>> addresses and call driver initialization function (which is hardware
> >>> abstraction agnostic). In a similar way, FDT initialize GICv1/2.
> >>>
> >>> NOTE: This commit allow to initialize GICv1/2 only.
> >>
> >> I cannot help but notice that there is no support for KVM here. It'd be
> >> good to add a note to that effect, so that people do not expect
> >> virtualization support to be working when booting with ACPI.
> > 
> > yes, it is worth mentioning!
> > 
> >>
> >>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> >>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> >>> ---
> >>>   arch/arm64/include/asm/acpi.h        |    2 -
> >>>   arch/arm64/kernel/acpi.c             |   23 +++++++
> >>>   arch/arm64/kernel/irq.c              |    5 ++
> >>>   drivers/irqchip/irq-gic.c            |  114 ++++++++++++++++++++++++++++++++++
> >>>   include/linux/irqchip/arm-gic-acpi.h |   33 ++++++++++
> >>>   5 files changed, 175 insertions(+), 2 deletions(-)
> >>>   create mode 100644 include/linux/irqchip/arm-gic-acpi.h
> >>>
> >>> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> >>> index a867467..5d2ab63 100644
> >>> --- a/arch/arm64/include/asm/acpi.h
> >>> +++ b/arch/arm64/include/asm/acpi.h
> >>> @@ -97,8 +97,6 @@ void __init acpi_smp_init_cpus(void);
> >>>   extern int (*acpi_suspend_lowlevel)(void);
> >>>   #define acpi_wakeup_address 0
> >>>
> >>> -#define ACPI_MAX_GIC_CPU_INTERFACE_ENTRIES 65535
> >>> -
> >>>   #else
> >>>
> >>>   static inline bool acpi_psci_present(void) { return false; }
> >>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> >>> index 354b912..b3b82b0 100644
> >>> --- a/arch/arm64/kernel/acpi.c
> >>> +++ b/arch/arm64/kernel/acpi.c
> >>> @@ -23,6 +23,7 @@
> >>>   #include <linux/irqdomain.h>
> >>>   #include <linux/bootmem.h>
> >>>   #include <linux/smp.h>
> >>> +#include <linux/irqchip/arm-gic-acpi.h>
> >>>
> >>>   #include <asm/cputype.h>
> >>>   #include <asm/cpu_ops.h>
> >>> @@ -313,6 +314,28 @@ void __init acpi_boot_table_init(void)
> >>>              pr_err("Can't find FADT or error happened during parsing FADT\n");
> >>>   }
> >>>
> >>> +void __init acpi_gic_init(void)
> >>> +{
> >>> +    struct acpi_table_header *table;
> >>> +    acpi_status status;
> >>> +    acpi_size tbl_size;
> >>> +    int err;
> >>> +
> >>> +    status = acpi_get_table_with_size(ACPI_SIG_MADT, 0, &table, &tbl_size);
> >>> +    if (ACPI_FAILURE(status)) {
> >>> +            const char *msg = acpi_format_exception(status);
> >>> +
> >>> +            pr_err("Failed to get MADT table, %s\n", msg);
> >>> +            return;
> >>> +    }
> >>> +
> >>> +    err = gic_v2_acpi_init(table);
> >>> +    if (err)
> >>> +            pr_err("Failed to initialize GIC IRQ controller");
> >>
> >> What will happen when you get to implement GICv3 support? Another entry
> >> like this? Why isn't this entirely contained in the GIC driver? Do I
> >> sound like a stuck record?
> > 
> > There will be another call to GICv3 init:
> > [...]
> >         err = gic_v3_acpi_init(table);
> >         if (err)
> >                 err = gic_v2_acpi_init(table);
> >         if (err)
> >                 pr_err("Failed to initialize GIC IRQ controller");
> > [...]
> > This is the main reason I put common code here.
> > 
> >>
> >>> +
> >>> +    early_acpi_os_unmap_memory((char *)table, tbl_size);
> >>> +}
> >>> +
> >>>   /*
> >>>    * acpi_suspend_lowlevel() - save kernel state and suspend.
> >>>    *
> >>> diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
> >>> index 0f08dfd..c074d60 100644
> >>> --- a/arch/arm64/kernel/irq.c
> >>> +++ b/arch/arm64/kernel/irq.c
> >>> @@ -28,6 +28,7 @@
> >>>   #include <linux/irqchip.h>
> >>>   #include <linux/seq_file.h>
> >>>   #include <linux/ratelimit.h>
> >>> +#include <linux/irqchip/arm-gic-acpi.h>
> >>>
> >>>   unsigned long irq_err_count;
> >>>
> >>> @@ -78,6 +79,10 @@ void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
> >>>   void __init init_IRQ(void)
> >>>   {
> >>>      irqchip_init();
> >>> +
> >>> +    if (!handle_arch_irq)
> >>> +            acpi_gic_init();
> >>> +
> >>
> >> Why isn't this called from irqchip_init? It would seem like the logical
> >> spot to probe an interrupt controller.
> > 
> > irqchip.c is OF dependent, I want to decouple these from the very
> > beginning.
> 
> No. irqchip.c is not OF dependent, it is just that DT is the only thing
> we support so far. I don't think duplicating the kernel infrastructure
> "because we're different" is the right way.
> 
> There is no reason for your probing structure to be artificially
> different (you're parsing the same information, at the same time). Just
> put in place a similar probing mechanism, and this will look a lot better.
> 
> >>
> >>>      if (!handle_arch_irq)
> >>>              panic("No interrupt controller found.");
> >>>   }
> >>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> >>> index 4b959e6..85cbf43 100644
> >>> --- a/drivers/irqchip/irq-gic.c
> >>> +++ b/drivers/irqchip/irq-gic.c
> >>> @@ -33,12 +33,14 @@
> >>>   #include <linux/of.h>
> >>>   #include <linux/of_address.h>
> >>>   #include <linux/of_irq.h>
> >>> +#include <linux/acpi.h>
> >>>   #include <linux/irqdomain.h>
> >>>   #include <linux/interrupt.h>
> >>>   #include <linux/percpu.h>
> >>>   #include <linux/slab.h>
> >>>   #include <linux/irqchip/chained_irq.h>
> >>>   #include <linux/irqchip/arm-gic.h>
> >>> +#include <linux/irqchip/arm-gic-acpi.h>
> >>>
> >>>   #include <asm/cputype.h>
> >>>   #include <asm/irq.h>
> >>> @@ -1029,3 +1031,115 @@ IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
> >>>   IRQCHIP_DECLARE(msm_qgic2, "qcom,msm-qgic2", gic_of_init);
> >>>
> >>>   #endif
> >>> +
> >>> +#ifdef CONFIG_ACPI
> >>> +static u64 dist_phy_base, cpu_phy_base = ULONG_MAX;
> >>
> >> Please use phys_addr_t for physical addresses. The use of ULONG_MAX
> >> looks dodgy. Please have a proper symbol to flag the fact that it hasn't
> >> been assigned yet.
> > Sure, will do.
> > 
> >>
> >>> +
> >>> +static int __init
> >>> +gic_acpi_parse_madt_cpu(struct acpi_subtable_header *header,
> >>> +                    const unsigned long end)
> >>> +{
> >>> +    struct acpi_madt_generic_interrupt *processor;
> >>> +    u64 gic_cpu_base;
> >>
> >> phys_addr_t
> >>
> >>> +    processor = (struct acpi_madt_generic_interrupt *)header;
> >>> +
> >>> +    if (BAD_MADT_ENTRY(processor, end))
> >>> +            return -EINVAL;
> >>> +
> >>> +    gic_cpu_base = processor->base_address;
> >>> +    if (!gic_cpu_base)
> >>> +            return -EFAULT;
> >>
> >> Is zero an invalid address?
> > Yeah, good point.
> >>
> >>> +
> >>> +    /*
> >>> +     * There is no support for non-banked GICv1/2 register in ACPI spec.
> >>> +     * All CPU interface addresses have to be the same.
> >>> +     */
> >>> +    if (cpu_phy_base != ULONG_MAX && gic_cpu_base != cpu_phy_base)
> >>> +            return -EFAULT;
> >>> +
> >>> +    cpu_phy_base = gic_cpu_base;
> >>> +    return 0;
> >>> +}
> >>> +
> >>> +static int __init
> >>> +gic_acpi_parse_madt_distributor(struct acpi_subtable_header *header,
> >>> +                            const unsigned long end)
> >>> +{
> >>> +    struct acpi_madt_generic_distributor *dist;
> >>> +
> >>> +    dist = (struct acpi_madt_generic_distributor *)header;
> >>> +
> >>> +    if (BAD_MADT_ENTRY(dist, end))
> >>> +            return -EINVAL;
> >>> +
> >>> +    dist_phy_base = dist->base_address;
> >>> +    if (!dist_phy_base)
> >>> +            return -EFAULT;
> >>
> >> Same question about zero.
> >>
> >>> +
> >>> +    return 0;
> >>> +}
> >>> +
> >>> +int __init
> >>> +gic_v2_acpi_init(struct acpi_table_header *table)
> >>> +{
> >>> +    void __iomem *cpu_base, *dist_base;
> >>> +    int count;
> >>> +
> >>> +    /* Collect CPU base addresses */
> >>> +    count = acpi_parse_entries(sizeof(struct acpi_table_madt),
> >>> +                               gic_acpi_parse_madt_cpu, table,
> >>> +                               ACPI_MADT_TYPE_GENERIC_INTERRUPT,
> >>> +                               ACPI_MAX_GIC_CPU_INTERFACE_ENTRIES);
> >>> +    if (count < 0) {
> >>> +            pr_err("Error during GICC entries parsing\n");
> >>> +            return -EFAULT;
> >>> +    } else if (!count) {
> >>> +            /* No GICC entries provided, use address from MADT header */
> >>> +            struct acpi_table_madt *madt = (struct acpi_table_madt *)table;
> >>> +
> >>> +            if (!madt->address)
> >>> +                    return -EFAULT;
> >>> +
> >>> +            cpu_phy_base = (u64)madt->address;
> >>> +    }
> >>> +
> >>> +    /*
> >>> +     * Find distributor base address. We expect one distributor entry since
> >>> +     * ACPI 5.1 spec neither support multi-GIC instances nor GIC cascade.
> >>> +     */
> >>> +    count = acpi_parse_entries(sizeof(struct acpi_table_madt),
> >>> +                               gic_acpi_parse_madt_distributor, table,
> >>> +                               ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
> >>> +                               ACPI_MAX_GIC_DISTRIBUTOR_ENTRIES);
> >>> +    if (count <= 0) {
> >>> +            pr_err("Error during GICD entries parsing\n");
> >>> +            return -EFAULT;
> >>> +    } else if (count > 1) {
> >>> +            pr_err("More than one GICD entry detected\n");
> >>> +            return -EINVAL;
> >>> +    }
> >>> +
> >>> +    cpu_base = ioremap(cpu_phy_base, ACPI_GIC_CPU_IF_MEM_SIZE);
> >>> +    if (!cpu_base) {
> >>> +            pr_err("Unable to map GICC registers\n");
> >>> +            return -ENOMEM;
> >>> +    }
> >>> +
> >>> +    dist_base = ioremap(dist_phy_base, ACPI_GIC_DIST_MEM_SIZE);
> >>> +    if (!dist_base) {
> >>> +            pr_err("Unable to map GICD registers\n");
> >>> +            iounmap(cpu_base);
> >>> +            return -ENOMEM;
> >>> +    }
> >>> +
> >>> +    /*
> >>> +     * Initialize zero GIC instance (no multi-GIC support). Also, set GIC
> >>> +     * as default IRQ domain to allow for GSI registration and GSI to IRQ
> >>> +     * number translation (see acpi_register_gsi() and acpi_gsi_to_irq()).
> >>> +     */
> >>> +    gic_init_bases(0, -1, dist_base, cpu_base, 0, NULL);
> >>> +    irq_set_default_host(gic_data[0].domain);
> >>> +    return 0;
> >>> +}
> >>> +#endif
> >>> diff --git a/include/linux/irqchip/arm-gic-acpi.h b/include/linux/irqchip/arm-gic-acpi.h
> >>> new file mode 100644
> >>> index 0000000..ce2ae1a8
> >>> --- /dev/null
> >>> +++ b/include/linux/irqchip/arm-gic-acpi.h
> >>> @@ -0,0 +1,33 @@
> >>> +/*
> >>> + * Copyright (C) 2014, Linaro Ltd.
> >>> + *  Author: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> >>> + *
> >>> + * This program is free software; you can redistribute it and/or modify
> >>> + * it under the terms of the GNU General Public License version 2 as
> >>> + * published by the Free Software Foundation.
> >>> + */
> >>> +
> >>> +#ifndef ARM_GIC_ACPI_H_
> >>> +#define ARM_GIC_ACPI_H_
> >>> +
> >>> +#include <linux/acpi.h>
> >>
> >> Do we need linux/acpi.h here? You could have a separate forward
> >> declaration of struct acpi_table_header, specially in the light of my
> >> last remark below.
> > Indeed, we can do forward declaration instead of #include
> > <linux/acpi.h>. Thanks!
> > 
> >>
> >>> +
> >>> +#ifdef CONFIG_ACPI
> >>> +#define ACPI_MAX_GIC_CPU_INTERFACE_ENTRIES  65535
> >>
> >> With GICv2? I doubt it.
> > I will create macro for each GIC driver:
> > #define ACPI_MAX_GICV2_CPU_INTERFACE_ENTRIES    8
> > #define ACPI_MAX_GICV3_CPU_INTERFACE_ENTRIES    65535
> 
> Where do you get this value (ACPI_MAX_GICV3_CPU_INTERFACE_ENTRIES) from?
> 
> >>
> >>> +#define ACPI_MAX_GIC_DISTRIBUTOR_ENTRIES    1
> >>> +
> >>> +/*
> >>> + * Hard code here, we can not get memory size from MADT (but FDT does),
> >>> + * Actually no need to do that, because this size can be inferred
> >>> + * from GIC spec.
> >>> + */
> >>> +#define ACPI_GIC_DIST_MEM_SIZE              (SZ_64K)
> >>
> >> I don't know which version of the spec you're looking at, but my version
> >> of the GICv2 spec has a 4kB distributor. Also, it would be good to make
> >> obvious which GIC version this define is about.
> > OK
> > 
> >>
> >>> +#define ACPI_GIC_CPU_IF_MEM_SIZE    (SZ_8K)
> >>> +
> >>> +void acpi_gic_init(void);
> >>> +int gic_v2_acpi_init(struct acpi_table_header *table);
> >>> +#else
> >>> +static inline void acpi_gic_init(void) { }
> >>> +#endif
> >>> +
> >>> +#endif /* ARM_GIC_ACPI_H_ */
> >>>
> >>
> >> In the end, why do we need a separate file for this? I cannot see
> >> anything that prevents it from being merged with arm-gic.h.
> >>
> >> Thanks,
> >>
> >>       M.
> >>
> > Having only GICv2, it would work. Considering we would do the same for
> > GICv3 (arm-gic-v3.h) there will be register name conflicts for both
> > headers inclusion:
> > 
> > [...]
> > #include <linux/irqchip/arm-gic.h>
> > #include <linux/irqchip/arm-gic-v3.h>
> > [...]
> >         err = gic_v3_acpi_init(table);
> >         if (err)
> >                 err = gic_v2_acpi_init(table);
> >         if (err)
> >                 pr_err("Failed to initialize GIC IRQ controller");
> > [...]
> > So instead of changing register names prefix, I choose new header will
> > be less painfully.
> 
> Yes, and this is exactly why I pushed back on that last time. I'll
> continue saying that interrupt controllers should be self-probing, with
> ACPI as they are with DT.

We are in a completely different situation with ACPI compared to DT. In
ACPI there is currently exactly one interrupt controller that is
allowed (GICv2). In the near future there will be a second one (GICv3).
There is zero need to have a infrastructure to abstract a pluggable
interface for registering interrupt controllers.

With DT we've got a tonne of controllers that we need to support. The
pluggable infrastructure was created because we needed it for
maintenance.

All we're really talking about here is a table of registered irq
controllers vs. a few lines of if/else if/else initialization code. The
moment it gets unwieldy, we will refactor it. Until then, the if/else
block is better code.

As for putting the ACPI hook into irqchip_init(), I don't doing so buys
us anything. Common code is good when it is common, but in this case
there is no other platform is going to use this ACPI irq initialization.
Not x86, not ia64. It is ARM64 specific code and moving it out from
arm64 doesn't make sense.

I'm not going to grump and complain if Hanjun decides to move it into
irqchip_init() anyway, but, I don't think this is an issue that should
block the patch series.

g.

> 
> Even with the restrictions of ACPI and SBSA, we end-up with at least 2
> main families of interrupt controllers (GICv2 and GICv3), both with a
> number of "interesting" variations (GICv2m and GICv4, to only mention
> those I'm directly involved with).
> 
> I can safely predict that the above will become a tangled mess within 18
> months, and the idea of littering the arch code with a bunch of
> hardcoded "if (blah())" doesn't fill me with joy and confidence.
> 
> In summary: we have the infrastructure already, just use it.
> 
> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...

