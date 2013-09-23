Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3IWSRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:17:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57680 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753852Ab3IWSRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:17:10 -0400
Date: Mon, 23 Sep 2013 21:17:07 +0300
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Fan Rong <cinifr@gmail.com>
Cc: coosty@163.com, daniel.lezcano@linaro.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.co,
        rob.herring@calxeda.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH V3: Add Smp support for Allwinner A20. 1/3] Add smp
 support for Allwinner A20(sunxi 7i).
Message-ID: <20130923181707.GR2779@lukather>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
 <1379852488-32147-2-git-send-email-cinifr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+S4DbcR7QPeSsP0V"
Content-Disposition: inline
In-Reply-To: <1379852488-32147-2-git-send-email-cinifr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+S4DbcR7QPeSsP0V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fang,

On Sun, Sep 22, 2013 at 08:21:26PM +0800, Fan Rong wrote:
> Signed-off-by: Fan Rong <cinifr@gmail.com>
> ---
>  arch/arm/mach-sunxi/Makefile  |  2 +
>  arch/arm/mach-sunxi/headsmp.S | 17 +++++++++
>  arch/arm/mach-sunxi/platsmp.c | 86 +++++++++++++++++++++++++++++++++++++=
++++++
>  arch/arm/mach-sunxi/sunxi.c   | 31 ++++++++++++++++
>  4 files changed, 136 insertions(+)
>  create mode 100644 arch/arm/mach-sunxi/headsmp.S
>  create mode 100644 arch/arm/mach-sunxi/platsmp.c
>=20
> diff --git a/arch/arm/mach-sunxi/Makefile b/arch/arm/mach-sunxi/Makefile
> index 93bebfc..d7f1ef4 100644
> --- a/arch/arm/mach-sunxi/Makefile
> +++ b/arch/arm/mach-sunxi/Makefile
> @@ -1 +1,3 @@
>  obj-$(CONFIG_ARCH_SUNXI) +=3D sunxi.o
> +obj-$(CONFIG_ARCH_SUNXI) +=3D platsmp.o
> +obj-$(CONFIG_ARCH_SUNXI) +=3D headsmp.o
> diff --git a/arch/arm/mach-sunxi/headsmp.S b/arch/arm/mach-sunxi/headsmp.S
> new file mode 100644
> index 0000000..5899399
> --- /dev/null
> +++ b/arch/arm/mach-sunxi/headsmp.S
> @@ -0,0 +1,17 @@
> +/*
> + * SMP support for A20
> + *
> + *  Copyright (C) 2013 Fan Rong <cinifr@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/linkage.h>
> +#include <linux/init.h>
> +
> +.section ".text.head", "ax" ENTRY(sun7i_secondary_startup)
> +msr cpsr_fsxc,
> +#0xd3
> +b secondary_startup ENDPROC(sun7i_secondary_startup)
> diff --git a/arch/arm/mach-sunxi/platsmp.c b/arch/arm/mach-sunxi/platsmp.c
> new file mode 100644
> index 0000000..5e3e994
> --- /dev/null
> +++ b/arch/arm/mach-sunxi/platsmp.c
> @@ -0,0 +1,86 @@
> +/*
> + *  linux/arch/arm/mach-sun7i/platsmp.c
> + *
> + *  Copyright (C) 2013 Fan Rong <cinifr@gmail.com>
> + *  All Rights Reserved
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/smp.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/smp.h>
> +
> +extern void __iomem *sunxi7i_cc_base;

Please use sun7i here as well.

> +void sun7i_secondary_startup(void);
> +
> +/*
> + * CPUCFG
> + */
> +#define SUN7I_CPUCFG_BOOTADDR	0x01a4
> +
> +#define SUN7I_CPUCFG_GENCTL	0x0184
> +#define SUN7I_CPUCFG_DBGCTL0	0x01e0
> +#define SUN7I_CPUCFG_DBGCTL1	0x01e4
> +
> +#define SUN7I_CPU1_PWR_CLAMP	0x01b0
> +#define SUN7I_CPU1_PWROFF_REG	0x01b4
> +#define SUN7I_CPUX_RESET_CTL(x)	(0x40 + (x)*0x40)
> +
> +static int sun7i_boot_secondary(unsigned int cpu, struct task_struct *id=
le)
> +{
> +	long paddr;
> +	uint32_t pwr_reg;
> +	uint32_t j =3D 0xff << 1;
> +	if (!sunxi7i_cc_base) {
> +		pr_debug("error map cpu configure\n");
> +		return -ENOSYS;
> +	}
> +	/* Set boot addr */
> +	paddr =3D virt_to_phys(sun7i_secondary_startup);
> +	writel(paddr, sunxi7i_cc_base + SUN7I_CPUCFG_BOOTADDR);
> +
> +	/* Assert cpu core reset */
> +	writel(0, sunxi7i_cc_base + SUN7I_CPUX_RESET_CTL(cpu));
> +
> +	/* Ensure CPU reset also invalidates L1 caches */
> +	pwr_reg =3D readl(sunxi7i_cc_base + SUN7I_CPUCFG_GENCTL);
> +	pwr_reg &=3D ~ BIT(cpu);
> +	writel(pwr_reg, sunxi7i_cc_base + SUN7I_CPUCFG_GENCTL);
> +
> +	/* DBGPWRDUP hold low */
> +	pwr_reg =3D readl(sunxi7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
> +	pwr_reg &=3D ~ BIT(cpu);
> +	writel(pwr_reg, sunxi7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
> +
> +	/* Ramp up power to CPU1 */
> +	do {
> +		writel(j, sunxi7i_cc_base + SUN7I_CPU1_PWR_CLAMP);
> +		j =3D j >> 1;
> +	} while (j !=3D 0);
> +
> +	mdelay(10);
> +
> +	pwr_reg =3D readl(sunxi7i_cc_base + SUN7I_CPU1_PWROFF_REG);
> +	pwr_reg &=3D ~1;
> +	writel(pwr_reg, sunxi7i_cc_base + SUN7I_CPU1_PWROFF_REG);
> +	mdelay(1);
> +
> +	/* Release CPU reset */
> +	writel(3, sunxi7i_cc_base + SUN7I_CPUX_RESET_CTL(cpu));
> +
> +	/* Unlock CPU */
> +	pwr_reg =3D readl(sunxi7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
> +	pwr_reg |=3D BIT(cpu);
> +	writel(pwr_reg, sunxi7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
> +
> +	return 0;
> +}
> +
> +struct smp_operations sun7i_smp_ops __initdata =3D {
> +	.smp_boot_secondary =3D sun7i_boot_secondary,
> +};
> diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
> index e79fb34..a692350 100644
> --- a/arch/arm/mach-sunxi/sunxi.c
> +++ b/arch/arm/mach-sunxi/sunxi.c
> @@ -26,6 +26,8 @@
>  #include <asm/mach/map.h>
>  #include <asm/system_misc.h>
> =20
> +extern struct smp_operations sun7i_smp_ops;
> +
>  #define SUN4I_WATCHDOG_CTRL_REG		0x00
>  #define SUN4I_WATCHDOG_CTRL_RESTART		BIT(0)
>  #define SUN4I_WATCHDOG_MODE_REG		0x04
> @@ -42,6 +44,14 @@
>  #define SUN6I_WATCHDOG1_MODE_ENABLE		BIT(0)
> =20
>  static void __iomem *wdt_base;
> +/*
> + * CPU Configure module support
> + * 1: Software reset for smp cpus
> + * 2: Configure for smp cpus including boot.
> + * 3: Three 64-bit idle counters and two 64-bit common counters
> + * it is needed for smp cpus
> + */
> +void __iomem *sunxi7i_cc_base; /*CPU Configure Base*/
> =20
>  static void sun4i_restart(enum reboot_mode mode, const char *cmd)
>  {
> @@ -98,6 +108,11 @@ static struct of_device_id sunxi_restart_ids[] =3D {
>  	{ /*sentinel*/ }
>  };
> =20
> +static struct of_device_id sunxi_cc_ids[] =3D {
> +	{ .compatible =3D "allwinner,sun7i-a20-cpuconfig"},
> +	{ /*sentinel*/ }
> +};
> +
>  static void sunxi_setup_restart(void)
>  {
>  	const struct of_device_id *of_id;
> @@ -138,7 +153,23 @@ static const char * const sunxi_board_dt_compat[] =
=3D {
>  	NULL,
>  };
> =20
> +static int __init sunxi_init_cpuconfig_map(void)
> +{
> +	struct device_node *np;
> +
> +	np =3D of_find_matching_node(NULL, sunxi_cc_ids);
> +	if (WARN(!np, "unable to setup cup configure"))
> +		return -ENOSYS;
> +	sunxi7i_cc_base =3D of_iomap(np, 0);
> +	if (WARN(!sunxi7i_cc_base, "failed to map cup configure base address"))
> +		return -ENOSYS;
> +	return 0;
> +}
> +
> +early_initcall(sunxi_init_cpuconfig_map);

You still haven't said why you don't want to use smp_init_cpus there.

> +
>  DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
> +	.smp	=3D smp_ops(sun7i_smp_ops),

Please align the "=3D" with the rest of the structure, and please rebase
on top of my "ARM: sunxi: Split out the DT machines for sun6i and sun7i"
patch.

Thanks a lot,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--+S4DbcR7QPeSsP0V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQIWjAAoJEBx+YmzsjxAgI6kQAJue1AkNmKAa063bbai5g0Rp
vuFBzw7YDHNXxfMxdvTcZFckbaeADzcQDgZbZ0ACRGuA9C7jKc+1JIR6Ory+TKyr
0y9+aV15YS3h0VF0YsOia9ME2xKgkYbQM6e8+MVBYpUcnBCw/5e1yY7y8LaszLZL
4EIqcXRVth2KTre9ekMeLiJjmdc/py5/Mq2MnVZxWO0XE5PJlJSgW2c/0PkNYxnV
loB4m5EYRVtYmEuhaPkyDrV/L/M9+OhzMsJZ83DLQV4YNHAjioBo4wgyeDoLqaZz
J2am4zohad412Zc5lIRivKHSl/2Xp9I7H25BoPelOUN0CbFiFWGsGZr7apSinqjU
zVmxjsbcqUeg0tcfAH39t+Wf+1XAz3KDYZx+NNoj5Lp6dSB2I0ikJK+OGaKV7Z34
1JnxaeDOz9Ce2OfnhOa6WjMBts+Md7C+cG7Q+Msb80hQJJto0jiyyqiNXrNLKOqF
1PkKAKh3mAvnRvQbAy5fWX0VXj4/wWFlG3PRLVygq/yXvu1MMWI3KGeg07vT96o1
EB2V6V7K6kmji6JnMJrmBMYaNBgn2uj1YsWe+mDDCQB7XgVexDdDjAy68fARCrTZ
5/M0i83GZ7lN24Ohz3tYW1u5eu6zHeJiNwtLPLuJVE3MCBxnr5npEE6WbUMiZEYa
dNLnJsNDFnWzG6r0TRNZ
=Wl86
-----END PGP SIGNATURE-----

--+S4DbcR7QPeSsP0V--
