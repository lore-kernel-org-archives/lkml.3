Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaKQOpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:45:14 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:59535 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbaKQOpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:45:11 -0500
MIME-Version: 1.0
In-Reply-To: <1416097066-20452-23-git-send-email-cernekee@gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com> <1416097066-20452-23-git-send-email-cernekee@gmail.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Mon, 17 Nov 2014 15:44:34 +0100
Message-ID: <CAOiHx=mGzPKO4N7KR+5FM1RfFDF+-wncdBz6PavR0q47Gtd2Jg@mail.gmail.com>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>, jfraser@broadcom.com,
        dtor@chromium.org, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Nov 16, 2014 at 1:17 AM, Kevin Cernekee <cernekee@gmail.com> wrote:
> bmips_be_defconfig supports Linux running on the following CM and DSL
> SoCs:
>
>  - BCM3384 (BMIPS5000) cable modem application processor, BE, SMP
>  - BCM3384 (BMIPS4355) cable modem "spare CPU"*, BE
>  - BCM6328 (BMIPS4355) ADSL chip, BE

Is BMIPS435*5* intentional? I would have assumed at least 6328 is also
MIPS4350 like BCM6368.

>  - BCM6368 (BMIPS4350) ADSL chip, BE, SMP
>
> *experimental; most configurations will require changing CONFIG_PHYSICAL_START
>
> bmips_stb_defconfig supports Linux running on the (nominally LE) STB
> chipsets:
>
>  - BCM7125 (BMIPS4380) set-top box chip, LE, SMP
>  - BCM7346 (BMIPS5000) set-top box chip, LE, SMP
>  - BCM7360 (BMIPS3300) set-top box chip, LE
>  - BCM7420 (BMIPS5000) set-top box chip, LE, SMP
>  - BCM7425 (BMIPS5000) set-top box chip, LE, SMP
>
> serial8250 and bcm63xx_uart do not currently coexist.  If/when this is
> fixed, it will be also possible to boot the BE image on any supported STB
> board configured for BE.  For now, each defconfig can only pick one UART
> driver, and the BE defconfig enables bcm63xx_uart.
>
> On these MIPS systems, endianness cannot be reconfigured at runtime.  On
> STB it is sometimes offered as a board jumper or 0-ohm resistor, and
> sometimes hardwired to LE only.  The CM and DSL systems always run BE.
>
> Device Tree is used to configure the following items:
>
>  - UART, USB, GENET peripherals
>  - IRQ controllers
>  - Early console base address (bcm63xx_uart only)
>  - SMP or UP mode
>  - MIPS counter frequency
>  - Memory size / regions
>  - DMA remappings
>  - Kernel command line
>
> The DT-enabled bootloader and build instructions for 3384 are posted at
> https://github.com/Broadcom/aeolus .  The other chips use legacy non-DT
> bootloaders, and so the kernel employs autodetection heuristics to select
> a builtin DTB.
>
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

This looks nice, and I think I agree with a new target instead of
trying to retrofit all the dtb/SoC support into bcm63xx.

Some individual comments here because I'm too lazy to search for the
introducing patches (more meant as general commentary than nitpicks).

(snip)

> diff --git a/Documentation/devicetree/bindings/mips/brcm/bmips.txt b/Documentation/devicetree/bindings/mips/brcm/bmips.txt
> new file mode 100644
> index 0000000..4a8cd8f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mips/brcm/bmips.txt
> @@ -0,0 +1,8 @@
> +* Broadcom MIPS (BMIPS) CPUs
> +
> +Required properties:
> +- compatible: "brcm,bmips3300", "brcm,bmips4350", "brcm,bmips4380"
> +              "brcm,bmips5000"
> +
> +- mips-hpt-frequency: This is common to all CPUs in the system so it lives
> +  under the "cpus" node.

Is it a good idea to hardcode this? Some SoC CPUs allow running with
different frequencies, which will directly affect this. Also I would
assume this would break once we add support for runtime clock changes
for BMIPS; at least on the DSL platform you can change the clock
between 1/4 (IIRC) and 1/1 for power saving.

> diff --git a/Documentation/devicetree/bindings/mips/brcm/soc.txt b/Documentation/devicetree/bindings/mips/brcm/soc.txt
> new file mode 100644
> index 0000000..1eedcb8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mips/brcm/soc.txt
> @@ -0,0 +1,21 @@
> +* Broadcom cable/DSL/settop platforms
> +
> +SoCs:
> +
> +Required properties:
> +- compatible: "brcm,bcm3384", "brcm,bcm33843"
> +              "brcm,bcm3384-viper", "brcm,bcm33843-viper"
> +              "brcm,bcm6328", "brcm,bcm6368",
> +              "brcm,bcm7125", "brcm,bcm7346", "brcm,bcm7360",
> +              "brcm,bcm7420", "brcm,bcm7425"
> +
> +Boards:
> +
> +Required properties:
> +- compatible: "brcm,bcm93384wvg", "brcm,bcm93384wvg-viper"
> +              "brcm,bcm9ejtagprb", "brcm,bcm96368mvwg",
> +              "brcm,bcm97125cbmb", "brcm,bcm97346dbsmb", "brcm,bcm97360svmb",
> +              "brcm,bcm97420c", "brcm,bcm97425svmb"

Should the list of supported boards really be hardcoded here/in the
kernel? It doesn't match what the code does, as it (as far as I can
tell) accepts dtbs without any of the board compatible ids when passed
from bootloader.

> +
> +The experimental -viper variants are for running Linux on the 3384's
> +BMIPS4355 cable modem CPU instead of the BMIPS5000 application processor.

(snip)

> diff --git a/arch/mips/bmips/irq.c b/arch/mips/bmips/irq.c
> new file mode 100644
> index 0000000..14552e5
> --- /dev/null
> +++ b/arch/mips/bmips/irq.c
> @@ -0,0 +1,38 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * Copyright (C) 2014 Broadcom Corporation
> + * Author: Kevin Cernekee <cernekee@gmail.com>
> + */
> +
> +#include <linux/of.h>
> +#include <linux/irqchip.h>
> +
> +#include <asm/bmips.h>
> +#include <asm/irq.h>
> +#include <asm/irq_cpu.h>
> +#include <asm/time.h>
> +
> +unsigned int get_c0_compare_int(void)
> +{
> +       return CP0_LEGACY_COMPARE_IRQ;
> +}
> +
> +void __init arch_init_irq(void)
> +{
> +       struct device_node *dn;
> +
> +       /* Only the STB (bcm7038) controller supports SMP IRQ affinity */
> +       dn = of_find_compatible_node(NULL, NULL, "brcm,bcm7038-l1-intc");
> +       if (dn)
> +               of_node_put(dn);
> +       else
> +               bmips_tp1_irqs = 0;
> +
> +       irqchip_init();
> +}
> +
> +OF_DECLARE_2(irqchip, mips_cpu_intc, "mti,cpu-interrupt-controller",
> +            mips_cpu_irq_of_init);
> diff --git a/arch/mips/bmips/setup.c b/arch/mips/bmips/setup.c
> new file mode 100644
> index 0000000..c34601d
> --- /dev/null
> +++ b/arch/mips/bmips/setup.c
> @@ -0,0 +1,249 @@
> +/*
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + *
> + * Copyright (C) 2014 Broadcom Corporation
> + * Author: Kevin Cernekee <cernekee@gmail.com>
> + */
> +
> +#include <linux/init.h>
> +#include <linux/bitops.h>
> +#include <linux/bootmem.h>
> +#include <linux/clk-provider.h>
> +#include <linux/ioport.h>
> +#include <linux/kernel.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_fdt.h>
> +#include <linux/of_platform.h>
> +#include <linux/smp.h>
> +#include <asm/addrspace.h>
> +#include <asm/bmips.h>
> +#include <asm/bootinfo.h>
> +#include <asm/cpu-type.h>
> +#include <asm/mipsregs.h>
> +#include <asm/prom.h>
> +#include <asm/smp-ops.h>
> +#include <asm/time.h>
> +#include <asm/traps.h>
> +#include <asm/fw/cfe/cfe_api.h>
> +
> +#define CMT_LOCAL_TPID         BIT(31)
> +#define RELO_NORMAL_VEC                BIT(18)
> +
> +#define REG_DSL_CHIP_ID                ((void __iomem *)CKSEG1ADDR(0x10000000))
> +#define REG_STB_CHIP_ID                ((void __iomem *)CKSEG1ADDR(0x10404000))
> +
> +#define REG_BCM6328_OTP                ((void __iomem *)CKSEG1ADDR(0x1000062c))
> +#define BCM6328_TP1_DISABLED   BIT(9)
> +
> +static const unsigned long kbase = VMLINUX_LOAD_ADDRESS & 0xfff00000;
> +
> +struct bmips_board_list {
> +       void                    *dtb;
> +       u32                     chip_id;
> +       const char              *boardname;
> +       void                    (*quirk_fn)(void);
> +};
> +
> +extern char __dtb_bcm9ejtagprb_begin;
> +extern char __dtb_bcm96368mvwg_begin;
> +extern char __dtb_bcm97125cbmb_begin;
> +extern char __dtb_bcm97346dbsmb_begin;
> +extern char __dtb_bcm97360svmb_begin;
> +extern char __dtb_bcm97420c_begin;
> +extern char __dtb_bcm97425svmb_begin;

I think it would be a good idea to have the embedded dtbs optional,
especially if you already provide an interface for passing a dtb
pointer.

> +
> +static void kbase_setup(void)
> +{
> +       __raw_writel(kbase | RELO_NORMAL_VEC,
> +                    BMIPS_GET_CBR() + BMIPS_RELO_VECTOR_CONTROL_1);
> +       ebase = kbase;
> +}
> +
> +static void bcm3384_quirks(void)
> +{
> +       /*
> +        * Some experimental CM boxes are set up to let CM own the Viper TP0
> +        * and let Linux own TP1.  This requires moving the kernel
> +        * load address to a non-conflicting region (e.g. via
> +        * CONFIG_PHYSICAL_START) and supplying an alternate DTB.
> +        * If we detect this condition, we need to move the MIPS exception
> +        * vectors up to an area that we own.
> +        *
> +        * This is distinct from the OTHER special case mentioned in
> +        * smp-bmips.c (boot on TP1, but enable SMP, then TP0 becomes our
> +        * logical CPU#1).  For the Viper TP1 case, SMP is off limits.
> +        *
> +        * Also note that many BMIPS435x CPUs do not have a
> +        * BMIPS_RELO_VECTOR_CONTROL_1 register, so it isn't safe to just
> +        * write VMLINUX_LOAD_ADDRESS into that register on every SoC.
> +        */
> +       if (current_cpu_type() == CPU_BMIPS4350 &&
> +           kbase != CKSEG0 &&
> +           read_c0_brcm_cmt_local() & CMT_LOCAL_TPID) {
> +               board_ebase_setup = &kbase_setup;
> +               bmips_smp_enabled = 0;
> +       }
> +}
> +
> +static void bcm6328_quirks(void)
> +{
> +       /* Check OTP to see if CPU1 is enabled (it usually isn't) */
> +       if (__raw_readl(REG_BCM6328_OTP) & BCM6328_TP1_DISABLED)
> +               bmips_smp_enabled = 0;
> +}
> +
> +static void bcm6368_quirks(void)
> +{
> +       /*
> +        * The bootloader has set up the CPU1 reset vector at
> +        * 0xa000_0200.
> +        * This conflicts with the special interrupt vector (IV).
> +        * The bootloader has also set up CPU1 to respond to the wrong
> +        * IPI interrupt.
> +        * Here we will start up CPU1 in the background and ask it to
> +        * reconfigure itself then go back to sleep.
> +        */
> +       memcpy((void *)0xa0000200, &bmips_smp_movevec, 0x20);
> +       __sync();
> +       set_c0_cause(C_SW0);
> +       cpumask_set_cpu(1, &bmips_booted_mask);
> +}
> +
> +static const struct bmips_board_list bmips_board_list[] = {
> +       { &__dtb_bcm9ejtagprb_begin,    0x6328, NULL,   &bcm6328_quirks },
> +       { &__dtb_bcm96368mvwg_begin,    0x6368, NULL,   &bcm6368_quirks },
> +       { &__dtb_bcm97125cbmb_begin,    0x7125, "BCM97125C0"            },
> +       { &__dtb_bcm97346dbsmb_begin,   0x7346, "BCM97346DBSMB"         },
> +       { &__dtb_bcm97360svmb_begin,    0x7360, "BCM97360SVMB"          },
> +       { &__dtb_bcm97420c_begin,       0x7420, "BCM97420C_DDR3"        },
> +       { &__dtb_bcm97425svmb_begin,    0x7425, "BCM97425SVMB"          },
> +       { },
> +};
> +
> +void __init prom_init(void)
> +{
> +       register_bmips_smp_ops();
> +}
> +
> +void __init prom_free_prom_memory(void)
> +{
> +}
> +
> +const char *get_system_type(void)
> +{
> +       return "BMIPS multiplatform kernel";
> +}
> +
> +void __init plat_time_init(void)
> +{
> +       struct device_node *np;
> +       u32 freq;
> +
> +       np = of_find_node_by_name(NULL, "cpus");
> +       if (!np)
> +               panic("missing 'cpus' DT node");
> +       if (of_property_read_u32(np, "mips-hpt-frequency", &freq) < 0)
> +               panic("missing 'mips-hpt-frequency' property");
> +       of_node_put(np);
> +
> +       mips_hpt_frequency = freq;
> +}
> +
> +static void __init *find_dtb(void)
> +{
> +       u32 chip_id;
> +       char boardname[64] = "";
> +       const struct bmips_board_list *b;
> +
> +       /* Intended to somewhat resemble ARM; see Documentation/arm/Booting */
> +       if (fw_arg0 == 0 && fw_arg1 == 0xffffffff)
> +               return phys_to_virt(fw_arg2);

I know a bit late, but how about using the OF_DT_MAGIC (0xd00dfeed)
for indicating that there is a device tree in arg2?

> +
> +       if (fw_arg1 != 0 || fw_arg3 != CFE_EPTSEAL ||
> +           (fw_arg2 & 0xf0000000) != CKSEG0)
> +               panic("cannot identify chip");
> +
> +       /*
> +        * Unfortunately the CFE API doesn't seem to provide chip
> +        * identification, but we can check the entry point to see whether
> +        * the current platform is a DSL chip or STB chip.  On STB,
> +        * CAE_STKSIZE = _regidx(13) = 13*8 = 104, so the first instruction is:
> +        * 0:   23bdff98        addi    sp,sp,-104
> +        */
> +       if (__raw_readl((void *)fw_arg2) == 0x23bdff98) {
> +               chip_id = __raw_readl(REG_STB_CHIP_ID);
> +               cfe_init(fw_arg0, fw_arg2);
> +               cfe_getenv("CFE_BOARDNAME", boardname, sizeof(boardname));
> +       } else {
> +               /*
> +                * This works on most modern chips, but will break on older
> +                * ones like 6358
> +                */
> +               chip_id = __raw_readl(REG_DSL_CHIP_ID);

Unfortunately I don't know any good way to discriminate between the
"old" and the "new" chips except by looking a the PRID and REV
(BMIPS3300 <= 3.2 || BMIPS4350 <= 1.0 => 0xfff00000, BMIPS3300 >= 3.3
|| BMIPS4350 >= 3.0 => 0xb0000000).

> +       }
> +
> +       /* 4-digit parts use bits [31:16]; 5-digit parts use [27:8] */

This might be true for the STB chips, but the DSL 5-digit parts use
[31:12]. And to add insult to insury, some 4-digit parts use [15:12]
for the chip variant, so you can't just check [15:12] for 0 or != 0
either (I would assume 63381 and 6328 (variant 63281) will have both 1
at [15:12].


> +       if (chip_id & 0xf0000000)
> +               chip_id >>= 16;
> +       else
> +               chip_id >>= 8;
> +
> +       for (b = bmips_board_list; b->dtb; b++) {
> +               if (b->chip_id != chip_id)
> +                       continue;
> +               if (b->boardname && strcmp(b->boardname, boardname))
> +                       continue;
> +               if (b->quirk_fn)
> +                       b->quirk_fn();

Hmm, maybe move running the quirk out of here and into
plat_mem_setup()? Currently e.g. a BCM6328 with a bootloader passed
dtb won't have its quirk run.

> +               return b->dtb;
> +       }
> +
> +       panic("no dtb found for current board");
> +}
> +
> +void __init plat_mem_setup(void)
> +{
> +       set_io_port_base(0);
> +       ioport_resource.start = 0;
> +       ioport_resource.end = ~0;
> +
> +       __dt_setup_arch(find_dtb());
> +       strlcpy(arcs_cmdline, boot_command_line, COMMAND_LINE_SIZE);
> +
> +       /* BCM3384 DTB comes from the bootloader, not from bmips_board_list */
> +       if (of_flat_dt_is_compatible(of_get_flat_dt_root(),
> +                                    "brcm,bcm3384-viper")) {
> +               bcm3384_quirks();
> +       }
> +}
> +
> +void __init device_tree_init(void)
> +{
> +       struct device_node *np;
> +
> +       unflatten_and_copy_device_tree();
> +
> +       /* Disable SMP boot unless both CPUs are listed in DT and !disabled */
> +       np = of_find_node_by_name(NULL, "cpus");
> +       if (np && of_get_available_child_count(np) <= 1)
> +               bmips_smp_enabled = 0;
> +       of_node_put(np);
> +}
> +
> +int __init plat_of_setup(void)
> +{
> +       return __dt_register_buses("brcm,bmips", "simple-bus");

Huh, "brcm,bmips" does not appear anywhere else. How does this work?
Should this be a required compatible?

(OT: "buses" irks me because in my native tongue the plural uses "ss",
but I accept that using one "s" is also a valid spelling in english
:P)

> +}
> +
> +arch_initcall(plat_of_setup);
> +
> +static int __init plat_dev_init(void)
> +{
> +       of_clk_init(NULL);
> +       return 0;
> +}
> +
> +device_initcall(plat_dev_init);
> diff --git a/arch/mips/boot/dts/Makefile b/arch/mips/boot/dts/Makefile
> index ca9c90e..ffae96b 100644
> --- a/arch/mips/boot/dts/Makefile
> +++ b/arch/mips/boot/dts/Makefile
> @@ -1,3 +1,12 @@
> +dtb-$(CONFIG_BMIPS_MULTIPLATFORM)      += bcm93384wvg.dtb \

Minor stilistic nitpick: I would use

dtb-$(CONFIG_BMIPS_MULTIPLATFORM)      += \
                                          bcm93384wvg.dtb \

so that adding a board before bcm963384wvg would only require an
insert, not also a modification.

> +                                          bcm93384wvg_viper.dtb \
> +                                          bcm96368mvwg.dtb \
> +                                          bcm9ejtagprb.dtb \
> +                                          bcm97125cbmb.dtb \
> +                                          bcm97346dbsmb.dtb \
> +                                          bcm97360svmb.dtb \
> +                                          bcm97420c.dtb \
> +                                          bcm97425svmb.dtb
>  dtb-$(CONFIG_CAVIUM_OCTEON_SOC)                += octeon_3xxx.dtb octeon_68xx.dtb
>  dtb-$(CONFIG_DT_EASY50712)             += easy50712.dtb
>  dtb-$(CONFIG_DT_XLP_EVP)               += xlp_evp.dtb
> diff --git a/arch/mips/boot/dts/bcm3384_common.dtsi b/arch/mips/boot/dts/bcm3384_common.dtsi
> new file mode 100644
> index 0000000..448cb5b
> --- /dev/null
> +++ b/arch/mips/boot/dts/bcm3384_common.dtsi
> @@ -0,0 +1,44 @@
> +/ {
> +       clocks {
> +               #address-cells = <1>;

This does not really make sense, as there is no address used at all
for the periph_clk.

> +               #size-cells = <0>;
> +
> +               periph_clk: periph_clk@0 {

Same for the @0 - there is no appropriate reg = <0>, so using an
address here does not make sense.

> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <54000000>;
> +               };
> +       };
> +
> +       aliases {
> +               uart0 = &uart0;
> +       };
> +
> +       uart0: serial@14e00520 {
> +               compatible = "brcm,bcm6345-uart";
> +               reg = <0x14e00520 0x18>;
> +               interrupt-parent = <&periph_intc>;
> +               interrupts = <2>;
> +               clocks = <&periph_clk>;
> +               status = "disabled";
> +       };
> +
> +       ehci0: usb@15400300 {
> +               compatible = "brcm,bcm3384-ehci", "generic-ehci";
> +               reg = <0x15400300 0x100>;
> +               big-endian;
> +               interrupt-parent = <&periph_intc>;
> +               interrupts = <41>;
> +               status = "disabled";
> +       };
> +
> +       ohci0: usb@15400400 {
> +               compatible = "brcm,bcm3384-ohci", "generic-ohci";
> +               reg = <0x15400400 0x100>;
> +               big-endian;
> +               no-big-frame-no;
> +               interrupt-parent = <&periph_intc>;
> +               interrupts = <40>;
> +               status = "disabled";
> +       };
> +};

(snip)

> diff --git a/arch/mips/boot/dts/bcm6328.dtsi b/arch/mips/boot/dts/bcm6328.dtsi
> new file mode 100644
> index 0000000..a7e397f
> --- /dev/null
> +++ b/arch/mips/boot/dts/bcm6328.dtsi
> @@ -0,0 +1,63 @@
> +/ {
> +       #address-cells = <1>;
> +       #size-cells = <1>;
> +       compatible = "brcm,bcm6328";
> +
> +       cpus {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               mips-hpt-frequency = <160000000>;
> +
> +               cpu@0 {
> +                       compatible = "brcm,bmips4350";
> +                       device_type = "cpu";
> +                       reg = <0>;
> +               };

Since there are SMP-enabled variants, maybe it should have its second
thread documented here (but defaulting to "disabled")?

> +       };
> +
> +       clocks {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +
> +               periph_clk: periph_clk@0 {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <50000000>;
> +               };
> +       };
> +
> +       aliases {
> +               uart0 = &uart0;
> +       };
> +
> +       cpu_intc: cpu_intc@0 {

It does not have an address, so it should not have @0 in the node name I think.

> +               #address-cells = <0>;
> +               compatible = "mti,cpu-interrupt-controller";
> +
> +               interrupt-controller;
> +               #interrupt-cells = <1>;
> +       };
> +
> +       periph_intc: periph_intc@10000024 {
> +               compatible = "brcm,bcm7120-l2-intc";
> +               reg = <0x10000024 0x4 0x1000002c 0x4
> +                      0x10000020 0x4 0x10000028 0x4>;

The "lowest" register address you use is 0x10000020, so the name
should arguably be periph_intc@10000020, not periph_intc@10000024. I
guess the second cpu block (10000030 - 1000003c) wired to hw irq 3 can
be added later.

This will easily translate to a lot of io(re)map calls in case of
63268/6318 when describing both cpu blocks ( a total of 16 "reg"s).

Also I wonder how you properly describe the intc of 63381, where it
has separate mask registers, but a shared status register.

> +
> +               interrupt-controller;
> +               #interrupt-cells = <1>;
> +
> +               interrupt-parent = <&cpu_intc>;
> +               interrupts = <2>;
> +               brcm,int-map-mask = <0xffffffff 0xffffffff>;
> +       };
> +
> +       uart0: serial@10000100 {
> +               compatible = "brcm,bcm6345-uart";
> +               reg = <0x10000100 0x18>;
> +               interrupt-parent = <&periph_intc>;
> +               interrupts = <28>;
> +               clocks = <&periph_clk>;
> +               status = "disabled";
> +       };
> +};

(snip)


Jonas
