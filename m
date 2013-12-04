Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab3LDPdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:33:38 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:64914 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580Ab3LDPdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:33:36 -0500
MIME-Version: 1.0
In-Reply-To: <1386069328-22502-2-git-send-email-hanjun.guo@linaro.org>
References: <1386069328-22502-1-git-send-email-hanjun.guo@linaro.org>
	<1386069328-22502-2-git-send-email-hanjun.guo@linaro.org>
Date: Wed, 4 Dec 2013 09:33:35 -0600
Message-ID: <CAL_JsqJYUasvVDZjkuFwEiMxWhXNEzhhSP2ni1KKDeQQjmnzjg@mail.gmail.com>
Subject: Re: [RFC part3 PATCH 1/2] clocksource / arch_timer: Use ACPI GTDT
 table to initialize arch timer
From: Rob Herring <robherring2@gmail.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-acpi@vger.kernel.org, Linaro Patches <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        Olof Johansson <olof@lixom.net>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 5:15 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> ACPI GTDT (Generic Timer Description Table) contains information for
> arch timer initialization, this patch use this table to probe arm timer.
>
> GTDT table is used for ARM/ARM64 only, please refer to chapter 5.2.24
> of ACPI 5.0 spec for detailed inforamtion
>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  drivers/clocksource/arm_arch_timer.c |  129 ++++++++++++++++++++++++++++++----
>  include/clocksource/arm_arch_timer.h |    7 +-
>  2 files changed, 120 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 95fb944..c968041 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -21,6 +21,7 @@
>  #include <linux/io.h>
>  #include <linux/slab.h>
>  #include <linux/sched_clock.h>
> +#include <linux/acpi.h>
>
>  #include <asm/arch_timer.h>
>  #include <asm/virt.h>
> @@ -632,20 +633,8 @@ static void __init arch_timer_common_init(void)
>         arch_timer_arch_init();
>  }
>
> -static void __init arch_timer_init(struct device_node *np)
> +static void __init arch_timer_init(void)
>  {
> -       int i;
> -
> -       if (arch_timers_present & ARCH_CP15_TIMER) {
> -               pr_warn("arch_timer: multiple nodes in dt, skipping\n");
> -               return;
> -       }
> -
> -       arch_timers_present |= ARCH_CP15_TIMER;
> -       for (i = PHYS_SECURE_PPI; i < MAX_TIMER_PPI; i++)
> -               arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
> -       arch_timer_detect_rate(NULL, np);
> -
>         /*
>          * If HYP mode is available, we know that the physical timer
>          * has been configured to be accessible from PL1. Use it, so
> @@ -667,8 +656,118 @@ static void __init arch_timer_init(struct device_node *np)
>         arch_timer_register();
>         arch_timer_common_init();
>  }
> -CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer", arch_timer_init);
> -CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer", arch_timer_init);
> +
> +static void __init arch_timer_of_init(struct device_node *np)
> +{
> +       int i;
> +
> +       if (arch_timers_present & ARCH_CP15_TIMER) {
> +               pr_warn("arch_timer: multiple nodes in dt, skipping\n");
> +               return;
> +       }
> +
> +       arch_timers_present |= ARCH_CP15_TIMER;
> +       for (i = PHYS_SECURE_PPI; i < MAX_TIMER_PPI; i++)
> +               arch_timer_ppi[i] = irq_of_parse_and_map(np, i);
> +       arch_timer_detect_rate(NULL, np);
> +
> +       arch_timer_init();
> +}
> +CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer", arch_timer_of_init);
> +CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer", arch_timer_of_init);
> +
> +#ifdef CONFIG_ACPI
> +void __init arch_timer_acpi_init(void)
> +{
> +       struct acpi_table_gtdt *gtdt;
> +       acpi_size tbl_size;
> +       int trigger, polarity;
> +       void __iomem *base = NULL;
> +
> +       if (acpi_disabled)

Wouldn't the core ACPI code never call this function if ACPI is disabled?

> +               return;
> +
> +       if (arch_timers_present & ARCH_CP15_TIMER) {
> +               pr_warn("arch_timer: already initialized, skipping\n");
> +               return;
> +       }
> +
> +       if (ACPI_FAILURE(acpi_get_table_with_size(ACPI_SIG_GTDT, 0,
> +                       (struct acpi_table_header **)&gtdt, &tbl_size))) {
> +               pr_err("arch_timer: GTDT table not defined\n");
> +               return;
> +       }
> +
> +       arch_timers_present |= ARCH_CP15_TIMER;

So you have marked the timer as initialized, but then may fail on
error later on here.

> +
> +       /*
> +        * Get the timer frequency. Since there is no frequency info
> +        * in the GTDT table, so we should read it from CNTFREG register
> +        * or hard code here to wait for the new ACPI spec available.
> +        */
> +       if (!gtdt->address) {
> +               arch_timer_rate = arch_timer_get_cntfrq();
> +       } else {
> +               base = ioremap(gtdt->address, CNTFRQ);
> +               if (!base) {
> +                       pr_warn("arch_timer: unable to map arch timer base address\n");
> +                       return;
> +               }
> +
> +               arch_timer_rate = readl_relaxed(base + CNTFRQ);
> +               iounmap(base);

This is for memory mapped timer? If so, then isn't setting
ARCH_CP15_TIMER the wrong thing to do?

> +       }
> +
> +       if (!arch_timer_rate) {
> +               /* Hard code here to set frequence ? */
> +               pr_warn("arch_timer: Could not get frequency from GTDT table or CNTFREG\n");
> +       }
> +
> +       if (gtdt->secure_pl1_interrupt) {

Really, I think the kernel should just ignore the secure interrupt.
The DT code has the same issue, but that doesn't affect the code size.

> +               trigger = (gtdt->secure_pl1_flags & ACPI_GTDT_INTERRUPT_MODE) ?
> +                       ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;

Why not use the already defined linux irq trigger types here and make
acpi_register_gsi use them?

> +               polarity =
> +                       (gtdt->secure_pl1_flags & ACPI_GTDT_INTERRUPT_POLARITY)
> +                       ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
> +               arch_timer_ppi[0] = acpi_register_gsi(NULL,
> +                               gtdt->secure_pl1_interrupt, trigger, polarity);
> +       }
> +       if (gtdt->non_secure_pl1_interrupt) {
> +               trigger =
> +                       (gtdt->non_secure_pl1_flags & ACPI_GTDT_INTERRUPT_MODE)
> +                       ? ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
> +               polarity =
> +               (gtdt->non_secure_pl1_flags & ACPI_GTDT_INTERRUPT_POLARITY)
> +                       ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
> +               arch_timer_ppi[1] = acpi_register_gsi(NULL,
> +                       gtdt->non_secure_pl1_interrupt, trigger, polarity);
> +       }
> +       if (gtdt->virtual_timer_interrupt) {
> +               trigger = (gtdt->virtual_timer_flags & ACPI_GTDT_INTERRUPT_MODE)
> +                       ? ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
> +               polarity =
> +               (gtdt->virtual_timer_flags & ACPI_GTDT_INTERRUPT_POLARITY)
> +                       ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
> +               arch_timer_ppi[2] = acpi_register_gsi(NULL,
> +                       gtdt->virtual_timer_interrupt, trigger, polarity);
> +       }
> +       if (gtdt->non_secure_pl2_interrupt) {
> +               trigger =
> +                       (gtdt->non_secure_pl2_flags & ACPI_GTDT_INTERRUPT_MODE)
> +                       ? ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
> +               polarity =
> +               (gtdt->non_secure_pl2_flags & ACPI_GTDT_INTERRUPT_POLARITY)
> +                       ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
> +               arch_timer_ppi[3] = acpi_register_gsi(NULL,
> +                       gtdt->non_secure_pl2_interrupt, trigger, polarity);
> +       }
> +
> +       early_acpi_os_unmap_memory(gtdt, tbl_size);

Who did the mapping? acpi_get_table_with_size? I think the core code
should handle the mapping and unmapping of ACPI tables. We don't want
to have to duplicate this in every initialization function. This seems
error prone.

Rob
