Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339Ab3DILOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:14:31 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60650 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab3DILO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:14:29 -0400
MIME-Version: 1.0
In-Reply-To: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com>
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com>
Date: Tue, 9 Apr 2013 13:14:28 +0200
Message-ID: <CACRpkdbuAvRzVdzKL51k5d7vVpGNUHh_f_ZAxP4m3zFdBOV=xw@mail.gmail.com>
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Tang <dt.tangr@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        fabian@ritter-vogt.de, Lionel Debroux <lionel_debroux@yahoo.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 11:01 AM, Daniel Tang <dt.tangr@gmail.com> wrote:

(I suspect I duplicate a lot of Arnd's comments, I haven't really checked.
If we contradict each other, point it out so we can discuss.)

> +config ARCH_NSPIRE
> +       bool "TI-NSPIRE based"
> +       depends on MMU
> +       select CPU_ARM926T
> +       select HAVE_MACH_CLKDEV
> +       select CLKDEV_LOOKUP

For a new platform you should be selecting COMMON_CLK
and implement your clock drivers under drivers/clk/*.

> +       select ARM_AMBA
> +       select USB_ARCH_HAS_EHCI
> +       select ARCH_WANT_OPTIONAL_GPIOLIB
> +       select GENERIC_ALLOCATOR

I wonder what that is used for ... will be fun to see :-)

> +       select ARCH_HAS_CPUFREQ
> +       select CPU_FREQ_TABLE
> +       help
> +         This enables support for systems using the TI-NSPIRE CPU

This does not select GENERIC_CLOCKEVENTS and SPARSE_IRQ
which is not a good sign.

> +choice
> +       prompt "Early printk and boot message serial interface"
> +       help
> +         Early printk output interface
> +       depends on EARLY_PRINTK
> +       default NSPIRE_EARLYPRINTK_CX
> +
> +config NSPIRE_EARLYPRINTK_CLASSIC
> +       bool "Classic"
> +
> +config NSPIRE_EARLYPRINTK_CX
> +       bool "CX model"
> +endchoice

This kind of stuf should go into
arch/arm/Kconfig.debug these days, along with implementation
of debug macro in arch/arm/debug/foo.S

> diff --git a/arch/arm/mach-nspire/classic.c b/arch/arm/mach-nspire/classic.c
(...)

> +union reg_clk_speed {
> +       unsigned long raw;
> +       struct {
> +               unsigned long __padding0:1;
> +               unsigned long base_cpu_ratio:7;
> +               unsigned long is_base_27mhz:1;
> +               unsigned long __padding1:3;
> +               unsigned long cpu_ahb_ratio:3;
> +               unsigned long __padding2:1;
> +               unsigned long base_val:5;
> +       } val;
> +};

Usually to try to fit a struct over a register range is not such a good
idea in Linux.

Instead define abstract representations of what you want to do
(remove everything named "padding" above, use proper data types instead
of these unsigned longs and that complex union) then use offsets to
registers and remap the base offset in memory.

It makes for simpler debugging and ability to properly use read|write[lwb]
macros.

> +static unsigned long classic_clocks_to_io(struct nspire_clk_speeds *clks)
> +{
> +       union reg_clk_speed reg;
> +
> +       BUG_ON(clks->div.base_cpu < 2);
> +       BUG_ON(clks->div.cpu_ahb < 1);
> +
> +       reg.raw = 0;
> +       reg.val.base_cpu_ratio = clks->div.base_cpu / 2;
> +       reg.val.cpu_ahb_ratio = clks->div.cpu_ahb - 1;
> +       reg.val.is_base_27mhz = (clks->base <= 27000000);
> +       reg.val.base_val = (300 - (clks->base / 1000000)) / 6;
> +
> +       return reg.raw;
> +}

And that avoid having to create special helper functions like this.

In integer divisions consider using DIV_ROUND_CLOSEST()
from <linux/kernel.h> where applicable.

> +/* Interrupt handling */

The interrupt controller driver shall be placed in drivers/irqchips
these days.

> +static inline int check_interrupt(void __iomem *base, struct pt_regs *regs)
> +{
> +       if (readl(base + 0x0)) {

Arrow antipattern, turn it around.

if (!readl(base))
   return 0;

Then de-indent the rest of the code.

> +               int irqnr = readl(base + 0x24);
> +               unsigned prev_priority;
> +               handle_IRQ(irqnr, regs);
> +
> +               /* Reset priorities */
> +               prev_priority = readl(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x28));
> +               writel(prev_priority, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x2c));
> +               return 1;
> +       }
> +       return 0;
> +}

I don't understand this, put in  some explanation of what this function
does please.

> +asmlinkage void __exception_irq_entry
> +       nspire_classic_handle_irq(struct pt_regs *regs)
> +{
> +       int serviced;
> +
> +       do {
> +               void __iomem *reg_base = IOMEM(NSPIRE_INTERRUPT_VIRT_BASE);

Instead of casting this in every IRQ entry define a static local
in the irq driver file to point to the base.

Avoids time in the IRQ handler, so it obviously the right thing to do.

Please also use a dynamic remapping ioremap* insteaf of
this static IOMEM() thing.

> +               serviced = 0;
> +
> +               /* IRQ */
> +               serviced += check_interrupt(reg_base, regs);
> +               /* FIQ */
> +               serviced += check_interrupt(reg_base + 0x100, regs);

Should you now handle FIQs first at all times?

> +       } while (serviced > 0);
> +}
> +
> +static void classic_irq_ack(struct irq_data *d)
> +{
> +       readl(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x28));
> +}

As stated use an ioremap:ed base static local.

(...)
> +void __init nspire_classic_init_irq(void)
> +{
> +       /* No stickies */
> +       writel(0, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x204));

0x204???

Use

#define FOO_REGISTER 0x204

to define understandable names for all of this so we can read the code.

Usually this means the comments are no longer needed because the
code becomes self-evident.

> +
> +       /* Disable all interrupts */
> +       writel(~0, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0xc));
> +       writel(~0, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x10c));
> +
> +       /* Set all priorities to 0 */
> +       memset_io(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x300), 0, 0x7f);
> +
> +       /* Accept interrupts of all priorities */
> +       writel(0xf, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x2c));
> +       writel(0xf, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x12c));
> +
> +       /* Clear existing interrupts */
> +       readl(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x28));
> +       readl(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x128));

Dito, everywhere.

In the end looking like this:

readl(base + NSPIRE_IRQ_FOO); or something.

No IOMEM, etc.

(...)
> +/* Timer */

Hm, looks like you just forgot to select GENERIC_CLOCKEVENTS?

Strange if it works anyway :-/

We are comtemplating putting these things into drivers/timer,
nothing decided yet.

> +static int classic_timer_set_event(unsigned long delta,
> +                               struct clock_event_device *dev)
> +{
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       writel(delta, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2));
> +       writel(1, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2 + 0x8));
> +       writel(0, NSPIRE_APB_VIRTIO(NSPIRE_APB_TIMER2 + 0x18));

Remove magic numbers, define register names.

Remap a base, get rid of NSPIRE_APB_VIRTIO().

> +       local_irq_restore(flags);
> +
> +       return 0;
> +}
> +static void classic_timer_set_mode(enum clock_event_mode mode,
> +                                struct clock_event_device *evt)
> +{
> +       evt->mode = mode;
> +}
> +
> +static struct clock_event_device nspire_clkevt = {
> +       .name           = "clockevent",
> +       .features       = CLOCK_EVT_FEAT_ONESHOT,
> +       .shift          = 32,
> +       .rating         = 400,
> +       .set_next_event = classic_timer_set_event,
> +       .set_mode       = classic_timer_set_mode,
> +       .cpumask                = cpu_all_mask,
> +};
> +
> +static irqreturn_t classic_timer_interrupt(int irq, void *dev_id)
> +{
> +       struct clock_event_device *c = dev_id;
> +
> +       /* Acknowledge */
> +       writel((1<<0), NSPIRE_APB_VIRTIO(NSPIRE_APB_MISC + 0x20));

writel((1<<0) isn't very helpful.

#include <linux/bitops.h>

#define NSPIRE_TIMER_ACK_REG 0x20
#define NSPIRE_TIMER_ACK BIT(0)

writel(NSPIRE_TIMER_ACK, base +  NSPIRE_TIMER_ACK_REG);

Then follow a lot of platform data and devices. These have to be moved
over to the device tree instead and deleted.

(...)
> +++ b/arch/arm/mach-nspire/touchpad.c
> @@ -0,0 +1,30 @@
> +/*
> + *     linux/arch/arm/mach-nspire/touchpad.c
> + *
> + *     Copyright (C) 2012 Fabian Vogt <fabian@ritter-vogt.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/i2c.h>
> +
> +#include "touchpad.h"
> +
> +#if defined(CONFIG_MOUSE_SYNAPTICS_I2C) || \
> +       defined(CONFIG_MOUSE_SYNAPTICS_I2C_MODULE)
> +static struct i2c_board_info synaptics_i2c = {
> +       I2C_BOARD_INFO("synaptics_i2c", 0x20),
> +       .irq    = 0,
> +};
> +
> +void __init nspire_touchpad_init()
> +{
> +       i2c_register_board_info(0, &synaptics_i2c, 1);
> +}


Not only should this be done from devicetree, but exactly which
synaptics driver are you using with this?

I don't think there is one in the kernel tree yet.

> diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
> index 831e1fd..e76c16b 100644
> --- a/arch/arm/tools/mach-types
> +++ b/arch/arm/tools/mach-types
> @@ -1204,3 +1204,6 @@ baileys                   MACH_BAILEYS            BAILEYS                 4169
>  familybox              MACH_FAMILYBOX          FAMILYBOX               4170
>  ensemble_mx35          MACH_ENSEMBLE_MX35      ENSEMBLE_MX35           4171
>  sc_sps_1               MACH_SC_SPS_1           SC_SPS_1                4172
> +nspireclp              MACH_NSPIRECLP          NSPIRECLP               4441
> +nspiretp               MACH_NSPIRETP           NSPIRETP                4442
> +nspirecx               MACH_NSPIRECX           NSPIRECX                4443

We don't patch this file, Russell updates it from the machine registry on
his webpage.

And with device tree it goes irrelevant.

Yours,
Linus Walleij
