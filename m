Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3LCPBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:01:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59731 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab3LCPBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:01:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Carino <marc.ceeeee@gmail.com>
Subject: Re: [PATCH v2 1/6] ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs
Date: Tue, 3 Dec 2013 16:01:04 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Christian Daudt <bcm@fixthebug.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com> <1385511748-27869-2-git-send-email-marc.ceeeee@gmail.com>
In-Reply-To: <1385511748-27869-2-git-send-email-marc.ceeeee@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312031601.04997.arnd@arndb.de>
X-Provags-ID: V02:K0:EpdlQ17WEC3IDH6sbJCd8wM8hnvEyHPTv9M01ztvW0E
 CE8GxfaCOi/x8cmGYHuS91/5m9xf+zjjryTHQMOBIpjmGbjTKl
 K/lLUaVzMzvphktU15DUqFYdNjgOmCTtYdxqlX/3GeSgJhCBiD
 A2fgzcefBDdLMRn8zD5unMRuJxljwK0pDSB6g98xSlwYxLe7EC
 F8jDRQ0UHXvdFAYIqtNdVrKrQVDcRN74f3xHnfn8vMJcpXoOgl
 uDoG4IU3k+uuSCrWAVT7zXc5jRmTEJFhpY1BhGWi7ZCvJaDMA0
 bUvFIE6+0ha2qghrbhdp+kr9vzKct9JWiyXdVWhZVHjo8RYdcY
 4dd0HnST27dS/Hphe9s0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 November 2013, Marc Carino wrote:
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 5765abf..266c699 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -94,6 +94,17 @@ choice
>  		depends on ARCH_BCM2835
>  		select DEBUG_UART_PL01X
>  
> +	config DEBUG_BRCMSTB_UART
> +		bool "Use BRCMSTB UART for low-level debug"
> +		depends on ARCH_BRCMSTB
> +		select DEBUG_UART_8250
> +		help
> +		  Say Y here if you want the debug print routines to direct
> +		  their output to the first serial port on these devices.
> +
> +		  If you have a Broadcom STB chip and would like early print
> +		  messages to appear over the UART, select this option.
> +
>  	config DEBUG_CLPS711X_UART1
>  		bool "Kernel low-level debugging messages via UART1"
>  		depends on ARCH_CLPS711X

Can you split out the debug UART changes into a separate patch?

> diff --git a/arch/arm/configs/brcmstb_defconfig b/arch/arm/configs/brcmstb_defconfig
> new file mode 100644
> index 0000000..1741d92
> --- /dev/null
> +++ b/arch/arm/configs/brcmstb_defconfig
> @@ -0,0 +1,127 @@
> +CONFIG_CROSS_COMPILE="arm-linux-"
> +CONFIG_KERNEL_LZO=y
> +CONFIG_SYSVIPC=y
> +CONFIG_POSIX_MQUEUE=y
> +CONFIG_LOG_BUF_SHIFT=14
> +CONFIG_SYSFS_DEPRECATED=y
> +CONFIG_RELAY=y
> +CONFIG_BLK_DEV_INITRD=y

Do you have a strong reason to have your own defconfig file? We currently
try to consolidate as much as possible into multi_v7_defconfig, so please
see if you can extend that instead to do what you need.

> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
> index 9fe6d88..9179259 100644
> --- a/arch/arm/mach-bcm/Kconfig
> +++ b/arch/arm/mach-bcm/Kconfig
> @@ -31,6 +31,24 @@ config ARCH_BCM_MOBILE
>  	  BCM11130, BCM11140, BCM11351, BCM28145 and
>  	  BCM28155 variants.
>  
> +config ARCH_BRCMSTB
> +	bool "Broadcom BCM7XXX based boards" if ARCH_MULTI_V7
> +	depends on MMU
> +	select ARM_ARCH_TIMER
> +	select ARM_GIC
> +	select BRCMSTB
> +	select MIGHT_HAVE_PCI
> +	select HAVE_SMP
> +	select USE_OF
> +	select CPU_V7
> +	select GENERIC_CLOCKEVENTS

Some of these are already implied by ARCH_MULTI_V7 and can be dropped
from this list.

> +struct platform_regs brcm_plat_regs;
> +
> +/***********************************************************************
> + * STB CPU (main application processor)
> + ***********************************************************************/
> +
> +static struct map_desc brcmstb_io_map[] __initdata = {
> +	{
> +	.virtual = (unsigned long)BRCMSTB_PERIPH_VIRT,
> +	.pfn     = __phys_to_pfn(BRCMSTB_PERIPH_PHYS),
> +	.length  = BRCMSTB_PERIPH_LENGTH,
> +	.type    = MT_DEVICE,
> +	},
> +};

Why do you need a static I/O mapping? You should not rely on hardcoded
virtual or physical addresses in general.

> +static struct node_reg sun_top_ctrl_regs[] __initdata = {
> +	{"reset-source-enable-reg", &brcm_plat_regs.reset_source_enable_reg},
> +	{"sw-master-reset-reg", &brcm_plat_regs.sw_master_reset_reg},
> +	{NULL, NULL}
> +};
> +
> +static struct node_reg cpu_biu_ctrl_regs[] __initdata = {
> +	{"cpu-reset-config-reg", &brcm_plat_regs.cpu_reset_config_reg},
> +	{"cpu0-pwr-zone-ctrl-reg", &brcm_plat_regs.cpu0_pwr_zone_ctrl_reg},
> +	{NULL, NULL}
> +};
> +
> +static struct node_reg hif_continuation_regs[] __initdata = {
> +	{"stb-boot-hi-addr0-reg", &brcm_plat_regs.hif_continuation_regs_base},
> +	{NULL, NULL}
> +};
> +
> +static struct node_reg_block top_reg_blocks[] __initdata = {
> +	{"brcm,brcmstb-sun-top-ctrl", sun_top_ctrl_regs},
> +	{"brcm,brcmstb-cpu-biu-ctrl", cpu_biu_ctrl_regs},
> +	{"brcm,brcmstb-hif-continuation", hif_continuation_regs},
> +	{NULL, NULL}
> +};

This seems like stuff that should go into the device drivers for the
respective hardware blocks, not into platform code.

> +	addr = ioremap(BPHYSADDR(BCHP_IRQ0_IRQEN), sizeof(u32));
> +	writel_relaxed(BCHP_IRQ0_IRQEN_uarta_irqen_MASK
> +		| BCHP_IRQ0_IRQEN_uartb_irqen_MASK
> +		| BCHP_IRQ0_IRQEN_uartc_irqen_MASK, addr);
> +	iounmap(addr);

What does this part do? Isn't that something that should have been set
up by the boot loader?

> +	block = top_reg_blocks;
> +	while (block->compatible) {
> +		struct device_node *np;
> +		struct node_reg *reg;
> +
> +		np = of_find_compatible_node(NULL, NULL, block->compatible);
> +		if (!np)
> +			panic("brcmstb: DT missing \"%s\" node\n",
> +				block->compatible);
> +
> +		addr = of_iomap(np, 0);
> +		if (!addr)
> +			panic("brcmstb: iomap failure\n");
> +
> +		reg = block->regs;
> +		while (reg->prop) {
> +			u32 val;
> +
> +			if (!of_property_read_u32(np, reg->prop, &val))
> +				*(reg->addr) = addr + val;
> +			else
> +				panic("brcmstb: node \"%s\" missing prop \"%s\"\n",
> +					block->compatible, reg->prop);
> +
> +			reg++;
> +		}
> +
> +		of_node_put(np);
> +
> +		block++;
> +	}
> +}

We try hard to avoid having register available this early and outside
of device drivers. Can you try to make at least some (if not all) of
these more regular, and provide specific comments in the code why this
is not possible for the others?

> +static void __init brcmstb_init(void)
> +{
> +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +}

This is the default function an can be omitted.

> +#define BRCMSTB_PERIPH_VIRT				0xfc000000
> +#define BRCMSTB_PERIPH_PHYS				0xf0000000
> +#define BRCMSTB_PERIPH_LENGTH				0x02000000
> +
> +#define BVIRTADDR(x)	(BRCMSTB_PERIPH_VIRT + ((x) & 0x0fffffff))
> +#define BPHYSADDR(x)	((x) + BRCMSTB_PERIPH_PHYS)
> +
> +#define BCHP_UARTA_REG_START				0x00406b00
> +
> +#define BCHP_IRQ0_IRQEN					0x00406780
> +#define BCHP_IRQ0_IRQEN_uarta_irqen_MASK		0x00010000
> +#define BCHP_IRQ0_IRQEN_uartb_irqen_MASK		0x00020000
> +#define BCHP_IRQ0_IRQEN_uartc_irqen_MASK		0x00040000

These should probably all be private to the files that use them

> +
> +ENTRY(brcmstb_secondary_startup)
> +        mov     r0, #0xd3
> +        msr     cpsr_fsxc, r0

You should have comments here about why this is necessary.

> +#define ZONE_PWR_DN_REQ_MASK		0x00000200
> +#define ZONE_PWR_UP_REQ_MASK		0x00000400
> +#define ZONE_BLK_RST_ASSERT_MASK	0x00001000
> +#define ZONE_PWR_OFF_STATE_MASK		0x02000000
> +#define ZONE_PWR_ON_STATE_MASK		0x04000000
> +#define ZONE_RESET_STATE_MASK		0x80000000
> +
> +static void __iomem *pwr_zone_ctrl_get_base(unsigned int cpu)
> +{
> +	void __iomem *base = brcm_plat_regs.cpu0_pwr_zone_ctrl_reg;
> +	base += (cpu * 4);
> +	return base;
> +}

It looks like you are accessing a register area that is providing power
domains for not just the CPUs but other parts of the system as well,
which should be a proper device driver, e.g. pm_domain or regulator
depending on what the hardware actually does, and then you plug
the SMP code into that. Do you think that would work here?

In the long run, I would like to see the platform SMP code get merged with
the cpuidle device drivers and moved to drivers/cpuidle, but we're not
quite at the point where this can be done.

> +	/* Magic delay from misc_bpcm_arm.c */
> +	busy_wait(10000);

I think you should use udelay() here rather than creating your own, but
I may be missing the specific requirements. Of course it would be better
not to need it at all.

	Arnd
