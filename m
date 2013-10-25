Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab3JYKZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:25:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54177 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752476Ab3JYKZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:25:09 -0400
Date: Fri, 25 Oct 2013 11:25:01 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Fan Rong <cinifr@gmail.com>
Cc: coosty@163.com, daniel.lezcano@linaro.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-sunxi@googlegroups.com
Subject: Re: [Add SMP support for Allwinner A20: PATCH V5 1/3] Add smp
 support for Allwinner A20(sunxi 7i).
Message-ID: <20131025102501.GD2768@lukather>
References: <1382027827-10080-1-git-send-email-cinifr@gmail.com>
 <1382027827-10080-2-git-send-email-cinifr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pQhZXvAqiZgbeUkD"
Content-Disposition: inline
In-Reply-To: <1382027827-10080-2-git-send-email-cinifr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pQhZXvAqiZgbeUkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2013 at 12:37:05AM +0800, Fan Rong wrote:
> This patch adds SMP support for the Allwinner A20 SoC. This SoC uses
> an IP to, among other things, handle the CPU-related configuration,
> like the power clamp, the boot address of the secondary CPUS, etc. We
> thus need to map this IP during the prepare_cpu SMP operation, before
> bringing up the secondary CPU in the secondary_startup operation.

Please wrap this to 80 chars, and use sun7i in your commit title.

>=20
> Signed-off-by: Fan Rong <cinifr@gmail.com>
> ---
>  arch/arm/mach-sunxi/Makefile  |   2 +
>  arch/arm/mach-sunxi/headsmp.S |  18 +++++++
>  arch/arm/mach-sunxi/platsmp.c | 114 ++++++++++++++++++++++++++++++++++++=
++++++
>  arch/arm/mach-sunxi/sunxi.c   |   3 ++
>  4 files changed, 137 insertions(+)
>  create mode 100644 arch/arm/mach-sunxi/headsmp.S
>  create mode 100644 arch/arm/mach-sunxi/platsmp.c
>  mode change 100644 =3D> 100755 arch/arm/mach-sunxi/sunxi.c
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
> index 0000000..48c9d33
> --- /dev/null
> +++ b/arch/arm/mach-sunxi/headsmp.S
> @@ -0,0 +1,18 @@
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
> +.section ".text.head", "ax"
> +ENTRY(sun7i_secondary_startup)
> +	msr cpsr_fsxc,#0xd3
> +	b secondary_startup
> +ENDPROC(sun7i_secondary_startup)
> diff --git a/arch/arm/mach-sunxi/platsmp.c b/arch/arm/mach-sunxi/platsmp.c
> new file mode 100644
> index 0000000..fa5adde
> --- /dev/null
> +++ b/arch/arm/mach-sunxi/platsmp.c
> @@ -0,0 +1,114 @@
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
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_platform.h>
> +
> +/*
> + * CPU Configure module support
> + * 1: Software reset for smp cpus
> + * 2: Configure for smp cpus including boot.
> + * 3: Three 64-bit idle counters and two 64-bit common counters
> + * it is needed for smp cpus
> + */
> +void __iomem *sun7i_cc_base; /*CPU Configure Base*/
> +extern void sun7i_secondary_startup(void);
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
> +static struct of_device_id sun7i_cc_ids[] =3D {
> +	{ .compatible =3D "allwinner,sun7i-a20-cpuconfig"},
> +	{ /*sentinel*/ }
> +};
> +
> +static int sun7i_boot_secondary(unsigned int cpu, struct task_struct *id=
le)
> +{
> +	long paddr;
> +	uint32_t pwr_reg;
> +	uint32_t j =3D 0xff << 1;
> +	if (!sun7i_cc_base) {
> +		pr_debug("error map cpu configure\n");
> +		return -ENOSYS;
> +	}
> +	/* Set boot addr */
> +	paddr =3D virt_to_phys(sun7i_secondary_startup);
> +	writel(paddr, sun7i_cc_base + SUN7I_CPUCFG_BOOTADDR);
> +
> +	/* Assert cpu core reset */
> +	writel(0, sun7i_cc_base + SUN7I_CPUX_RESET_CTL(cpu));
> +
> +	/* Ensure CPU reset also invalidates L1 caches */
> +	pwr_reg =3D readl(sun7i_cc_base + SUN7I_CPUCFG_GENCTL);
> +	pwr_reg &=3D ~BIT(cpu);
> +	writel(pwr_reg, sun7i_cc_base + SUN7I_CPUCFG_GENCTL);
> +
> +	/* DBGPWRDUP hold low */
> +	pwr_reg =3D readl(sun7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
> +	pwr_reg &=3D ~BIT(cpu);
> +	writel(pwr_reg, sun7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
> +
> +	/* Ramp up power to CPU1 */
> +	do {
> +		writel(j, sun7i_cc_base + SUN7I_CPU1_PWR_CLAMP);
> +		j =3D j >> 1;
> +	} while (j !=3D 0);

In your first version, you were starting by writing 0xff, while here the
first iteration of the loop writes (0xff << 1), is that intentionnal ?

Maybe you could move the j variable affectation just before the loop so
that we can more easily spot such mistakes.

> +
> +	mdelay(10);
> +
> +	pwr_reg =3D readl(sun7i_cc_base + SUN7I_CPU1_PWROFF_REG);
> +	pwr_reg &=3D ~1;
> +	writel(pwr_reg, sun7i_cc_base + SUN7I_CPU1_PWROFF_REG);
> +	mdelay(1);
> +
> +	/* Release CPU reset */
> +	writel(3, sun7i_cc_base + SUN7I_CPUX_RESET_CTL(cpu));
> +
> +	/* Unlock CPU */
> +	pwr_reg =3D readl(sun7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
> +	pwr_reg |=3D BIT(cpu);
> +	writel(pwr_reg, sun7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
> +
> +	return 0;
> +}
> +
> +static void __init sun7i_init_cpuconfig_map(unsigned int max_cpus)
> +{
> +	struct device_node *np;

Add a new line here.

> +	np =3D of_find_matching_node(NULL, sun7i_cc_ids);
> +	if (WARN(!np, "unable to setup cup configure"))
                                       ^ cpu
> +		return;

Add a new line here.

> +	sun7i_cc_base =3D of_iomap(np, 0);
> +	if (WARN(!sun7i_cc_base, "failed to map cup configure base address"))
                                                ^ cpu
> +		return;

I think I would panic here instead of issuing a warning.

> +}
> +
> +struct smp_operations sun7i_smp_ops __initdata =3D {
> +	.smp_boot_secondary =3D sun7i_boot_secondary,
> +	.smp_prepare_cpus =3D sun7i_init_cpuconfig_map,
> +};
> diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
> old mode 100644
> new mode 100755
> index f184f6c..545269d
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
> @@ -155,6 +157,7 @@ static const char * const sun7i_board_dt_compat[] =3D=
 {
>  };
> =20
>  DT_MACHINE_START(SUN7I_DT, "Allwinner sun7i (A20) Family")
> +	.smp	=3D smp_ops(sun7i_smp_ops),

Please align it with the other affectations.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--pQhZXvAqiZgbeUkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSakb8AAoJEBx+YmzsjxAgD9YQAMDifUomJRND9c6Y0XpR5N+X
jOAiNhmMaYzMZXExFJzrujhyvoucuOgMdVy3cBt2KhSMJ81DOkRZLMh5hdP/n4nc
o+LJVMLLfsD61QdtO1LJuyt5LOiP+Gr40vvD5qjK0BZA/0PULfBLGt0p5z/BzxiE
wnoLetTzC+kXGcjr8jRRfW/HnUewYIhGmDzQ3g7LDBR4aptLXMnf4rCJqmD83QnN
xnaNRAkYfi6519aooBueUX7/NbTCnOJkrix4PVIQrpfYnzuL45GcYoOYREKXWI+/
RYb/DgJOdJ8r5woiX4GdyL9hqQJDovJfMR0Ta+cTgYkDNvauQkNte+f6jjSWJAyk
7fB3L88v9wxaFPvjAqKPxCZeZ7ZnwSxq9wELEOKzrhwMPVlspKR/ph4uZ4VP6Lhh
BeHUtzg7/aCcjDPB4OdyXYAtfFy15VVhEtXvQXMoXpgsEPhkViMt6jQwHBuRQshL
IW/YkQAVMjtsmZ/DIAeYoHkBuVeY18QhdnK0WkunQBJRF/He+VaSPyl9+VhGE27n
oeUB9Nil0CHV6lhZ8V4cfw5s+0yZT7+dzyScAbZbE3ZqZ06FpelBgg9q3t8RYAra
9bGohYB7qomyRxuM9BbEdpohAMWXChOPfx4ezb0xjBPqLvc9fcJZiAyZNPgu8FjY
wB8ePsnMumSvbHOmXW3g
=AtCj
-----END PGP SIGNATURE-----

--pQhZXvAqiZgbeUkD--
