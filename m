Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3ILPxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:53:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57648 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3ILPx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:53:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130912142619.GB22013@e106331-lin.cambridge.arm.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
	<1378968687-8200-2-git-send-email-cinifr@gmail.com>
	<20130912142619.GB22013@e106331-lin.cambridge.arm.com>
Date: Thu, 12 Sep 2013 23:53:26 +0800
Message-ID: <CAK3cCBxq+nR0ntimjBvirqctXRi6xHTfq80Ei-WZ1ecpOLWqFQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] Add smp support for Allwinner A20(sunxi 7i).
From: cinifr <cinifr@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "coosty@163.com" <coosty@163.com>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for you advice, you are right, I will reupdate the patch. :)

On 12 September 2013 22:26, Mark Rutland <mark.rutland@arm.com> wrote:
> On Thu, Sep 12, 2013 at 07:51:24AM +0100, Fan Rong wrote:
>> Signed-off-by: Fan Rong <cinifr@gmail.com>
>> ---
>>  arch/arm/mach-sunxi/Makefile   |    2 +
>>  arch/arm/mach-sunxi/headsmp.S  |   12 ++
>>  arch/arm/mach-sunxi/platform.h |  346 ++++++++++++++++++++++++++++++++++++++++
>>  arch/arm/mach-sunxi/platsmp.c  |  166 +++++++++++++++++++
>>  arch/arm/mach-sunxi/sunxi.c    |    4 +
>>  5 files changed, 530 insertions(+)
>>  create mode 100644 arch/arm/mach-sunxi/headsmp.S
>>  create mode 100644 arch/arm/mach-sunxi/platform.h
>>  create mode 100644 arch/arm/mach-sunxi/platsmp.c
>>
>
> [...]
>
>> +static struct of_device_id sunxi_cc_ids[] = {
>> +       { .compatible = "allwinner,sun7i-cc"},
>> +       { /*sentinel*/ }
>> +};
>
> NAK - There's no binding document for this in mainline or this series.
>
>> +
>> +
>> +static void enable_aw_cpu(int cpu)
>> +{
>> +       long paddr;
>> +       u32 pwr_reg;
>> +
>> +       struct device_node *np;
>> +       np = of_find_matching_node(NULL, sunxi_cc_ids);
>> +       cc_base = of_iomap(np, 0);
>
> This seems to get called repeatedly in sunxi7i_boot_secondary, so you're
> repeatedly trying to find the cc node and mapping it, but never
> unmapping it. That's both a waste of time and a waste of address space.
>
> It would be nicer to map this once at the start. That seems simpler than
> stashing the physical address and mapping/unmapping it repeatedly.
> smp_boot_secondary.
>
>> +       pr_debug("cc_base is %x\n", (unsigned int)cc_base);
>> +       if (!cc_base) {
>
> You can use %p to print pointers, without casting to an integer type.
>
>> +               pr_debug("error map cc configure\n");
>> +               return;
>
> As this may be called repeatedly, from a function that can return
> errors, it would be nice to propagate an error code if there's a
> failure.
>
>> +       }
>> +
>> +       paddr = virt_to_phys(sun7i_secondary_startup);
>> +       writel(paddr, cc_base + AW_CPUCFG_P_REG0);
>> +    /* step1: Assert nCOREPORESET LOW and hold L1RSTDISABLE LOW.
>> +               Ensure DBGPWRDUP is held LOW to prevent any external
>> +               debug access to the processor.
>> +    */
>> +    /* assert cpu core reset */
>> +       writel(0, cc_base + CPUX_RESET_CTL(cpu));
>> +    /* L1RSTDISABLE hold low */
>> +       pwr_reg = readl(cc_base + AW_CPUCFG_GENCTL);
>> +       pwr_reg &= ~(1<<cpu);
>> +       writel(pwr_reg, cc_base + AW_CPUCFG_GENCTL);
>> +    /* DBGPWRDUP hold low */
>> +       pwr_reg = readl(cc_base + AW_CPUCFG_DBGCTL1);
>> +       pwr_reg &= ~(1<<cpu);
>> +       writel(pwr_reg, cc_base + AW_CPUCFG_DBGCTL1);
>> +
>> +    /* step2: release power clamp */
>> +       writel(0xff, cc_base + AW_CPU1_PWR_CLAMP);
>> +       writel(0x7f, cc_base + AW_CPU1_PWR_CLAMP);
>> +       writel(0x3f, cc_base + AW_CPU1_PWR_CLAMP);
>> +       writel(0x1f, cc_base + AW_CPU1_PWR_CLAMP);
>> +       writel(0x0f, cc_base + AW_CPU1_PWR_CLAMP);
>> +       writel(0x07, cc_base + AW_CPU1_PWR_CLAMP);
>> +       writel(0x03, cc_base + AW_CPU1_PWR_CLAMP);
>> +       writel(0x01, cc_base + AW_CPU1_PWR_CLAMP);
>> +       writel(0x00, cc_base + AW_CPU1_PWR_CLAMP);
>> +       mdelay(10);
>> +
>> +    /* step3: clear power-off gating */
>> +       pwr_reg = readl(cc_base + AW_CPU1_PWROFF_REG);
>> +       pwr_reg &= ~(1);
>> +       writel(pwr_reg, cc_base + AW_CPU1_PWROFF_REG);
>> +       mdelay(1);
>> +
>> +    /* step4: de-assert core reset */
>> +       writel(3, cc_base + CPUX_RESET_CTL(cpu));
>> +
>> +    /* step5: assert DBGPWRDUP signal */
>> +       pwr_reg = readl(cc_base + AW_CPUCFG_DBGCTL1);
>> +       pwr_reg |= (1<<cpu);
>> +       writel(pwr_reg, cc_base + AW_CPUCFG_DBGCTL1);
>> +
>> +}
>> +
>> +
>> +
>> +static void sunxi7i_smp_init_cpus(void)
>> +{
>> +       unsigned int i, ncores;
>> +
>> +
>> +       /* HDG: we do not use scu_get_core_count() here as that does not
>> +          work on the A20 ? */
>> +
>> +       /* Read current CP15 Cache Size ID Register */
>
> Invalid comment. Judging by the encoding, this is the L2CTLR, not the
> CCSIDR.
>
>> +       asm volatile ("mrc p15, 1, %0, c9, c0, 2" : "=r" (ncores));
>> +       ncores = ((ncores >> 24) & 0x3) + 1;
>> +
>> +       pr_debug("[%s] ncores=%d\n", __func__, ncores);
>> +
>> +       for (i = 0; i < ncores; i++)
>> +               set_cpu_possible(i, true);
>> +
>> +}
>
> Even ignoring the above, as long as your dt is correct
> arm_dt_init_cpu_maps (called from stup_arch) will set the cpus as
> possible (and handles arbitrary MPIDR values as may be the case in
> multi-cluster).
>
> You don't need this function -- please remove it.
>
>> +
>> +/*
>> + * for arch/arm/kernel/smp.c:smp_prepare_cpus(unsigned int max_cpus)
>> + */
>> +static void sunxi7i_smp_prepare_cpus(unsigned int max_cpus)
>> +{
>> +       /*
>> +        * HDG: we do not call scu_enable() here as the sun6i source dump has
>> +        * a modified arch/arm/kernel/smp_scu.c, where scu_enable() is a nop.
>> +       */
>> +}
>
> A look in smp.c shows smp_prepare_cpus is perfectly happy to not have a
> smp_prepare_cpus callback. You don't need this function -- please remove
> it.
>
>> +
>> +
>> +
>> +
>> +
>> +
>
> Why so much space here (and elsewhere)?
>
>> +/*
>> + * for linux/arch/arm/kernel/smp.c:__cpu_up(..)
>> + */
>> +static int sunxi7i_boot_secondary(unsigned int cpu, struct task_struct *idle)
>> +{
>> +       pr_debug("[%s] enter cpu %d\n", __func__, cpu);
>> +       spin_lock(&boot_lock);
>> +       enable_aw_cpu(cpu);
>
> This can fail. You should propagate the error when it does.
>
>> +       spin_unlock(&boot_lock);
>> +       return 0;
>> +}
>> +
>> +
>> +
>> +
>> +struct smp_operations sunxi7i_smp_ops __initdata = {
>> +       .smp_init_cpus          = sunxi7i_smp_init_cpus,
>> +       .smp_prepare_cpus       = sunxi7i_smp_prepare_cpus,
>> +       .smp_boot_secondary     = sunxi7i_boot_secondary,
>> +};
>
> I believe only smp_boot_secondary is necessary here.
>
> Thanks,
> Mark.
>
>> +
>> +
>> diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
>> index e79fb34..f3594e6 100644
>> --- a/arch/arm/mach-sunxi/sunxi.c
>> +++ b/arch/arm/mach-sunxi/sunxi.c
>> @@ -26,6 +26,9 @@
>>  #include <asm/mach/map.h>
>>  #include <asm/system_misc.h>
>>
>> +#include "platform.h"
>> +
>> +
>>  #define SUN4I_WATCHDOG_CTRL_REG                0x00
>>  #define SUN4I_WATCHDOG_CTRL_RESTART            BIT(0)
>>  #define SUN4I_WATCHDOG_MODE_REG                0x04
>> @@ -139,6 +142,7 @@ static const char * const sunxi_board_dt_compat[] = {
>>  };
>>
>>  DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
>> +       .smp    = smp_ops(sunxi7i_smp_ops),
>>         .init_machine   = sunxi_dt_init,
>>         .init_time      = sunxi_timer_init,
>>         .dt_compat      = sunxi_board_dt_compat,
>> --
>> 1.7.9.5
>>
>>
