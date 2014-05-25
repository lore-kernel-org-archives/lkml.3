Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaEYTnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:43:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33623 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751917AbaEYTn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:43:27 -0400
Date: Sun, 25 May 2014 21:26:52 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 20/22] ARM: sun8i: Add SMP support for the Allwinner A23
Message-ID: <20140525192652.GZ10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-21-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E9SPMlsjsjqOlA3h"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-21-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E9SPMlsjsjqOlA3h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:23PM +0800, Chen-Yu Tsai wrote:
> The A23 is a dual Cortex-A7. Add the logic to use the IPs used to
> control the CPU configuration and the CPU power so that we can
> bring up secondary CPUs at boot.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/mach-sunxi/platsmp.c | 69 +++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 69 insertions(+)
>=20
> diff --git a/arch/arm/mach-sunxi/platsmp.c b/arch/arm/mach-sunxi/platsmp.c
> index c53077b..688faaf 100644
> --- a/arch/arm/mach-sunxi/platsmp.c
> +++ b/arch/arm/mach-sunxi/platsmp.c
> @@ -121,3 +121,72 @@ struct smp_operations sun6i_smp_ops __initdata =3D {
>  	.smp_boot_secondary	=3D sun6i_smp_boot_secondary,
>  };
>  CPU_METHOD_OF_DECLARE(sun6i_smp, "allwinner,sun6i-a31", &sun6i_smp_ops);
> +
> +static void __init sun8i_smp_prepare_cpus(unsigned int max_cpus)
> +{
> +	struct device_node *node;
> +
> +	node =3D of_find_compatible_node(NULL, NULL, "allwinner,sun8i-a23-prcm"=
);
> +	if (!node) {
> +		pr_err("Missing A23 PRCM node in the device tree\n");
> +		return;
> +	}
> +
> +	prcm_membase =3D of_iomap(node, 0);
> +	if (!prcm_membase) {
> +		pr_err("Couldn't map A23 PRCM registers\n");
> +		return;
> +	}
> +
> +	node =3D of_find_compatible_node(NULL, NULL,
> +				       "allwinner,sun8i-a23-cpuconfig");
> +	if (!node) {
> +		pr_err("Missing A23 CPU config node in the device tree\n");
> +		return;
> +	}
> +
> +	cpucfg_membase =3D of_iomap(node, 0);
> +	if (!cpucfg_membase)
> +		pr_err("Couldn't map A23 CPU config registers\n");
> +
> +}
> +
> +static int sun8i_smp_boot_secondary(unsigned int cpu,
> +				    struct task_struct *idle)
> +{
> +	u32 reg;
> +
> +	if (!(prcm_membase && cpucfg_membase))
> +		return -EFAULT;
> +
> +	spin_lock(&cpu_lock);
> +
> +	/* Set CPU boot address */
> +	writel(virt_to_phys(secondary_startup),
> +	       cpucfg_membase + CPUCFG_PRIVATE0_REG);
> +
> +	/* Assert the CPU core in reset */
> +	writel(0, cpucfg_membase + CPUCFG_CPU_RST_CTRL_REG(cpu));
> +
> +	/* Assert the L1 cache in reset */
> +	reg =3D readl(cpucfg_membase + CPUCFG_GEN_CTRL_REG);
> +	writel(reg & ~BIT(cpu), cpucfg_membase + CPUCFG_GEN_CTRL_REG);
> +
> +	/* Clear CPU power-off gating */
> +	reg =3D readl(prcm_membase + PRCM_CPU_PWROFF_REG);
> +	writel(reg & ~BIT(cpu), prcm_membase + PRCM_CPU_PWROFF_REG);
> +	mdelay(1);
> +
> +	/* Deassert the CPU core reset */
> +	writel(3, cpucfg_membase + CPUCFG_CPU_RST_CTRL_REG(cpu));
> +
> +	spin_unlock(&cpu_lock);
> +
> +	return 0;
> +}
> +
> +struct smp_operations sun8i_smp_ops __initdata =3D {
> +	.smp_prepare_cpus	=3D sun8i_smp_prepare_cpus,
> +	.smp_boot_secondary	=3D sun8i_smp_boot_secondary,
> +};
> +CPU_METHOD_OF_DECLARE(sun8i_smp, "allwinner,sun8i-a23", &sun8i_smp_ops);

You forgot to document the new enable-method.

Also, is there any plan to hae a working u-boot? I'd much prefer to
use PSCI if possible.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--E9SPMlsjsjqOlA3h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgkP8AAoJEBx+YmzsjxAg0ukQAICpqLp+cvgYV7AJt8+NrwCl
WIzKr6hYs7muHCljiDmSyZAQeSBMdm6Er1/ngCnPwaMUW9Lx7/flOo4cIedcQBOr
dz3CZRifBTWTcezr9R+Q/2bMl57JQH2D5XH8pzs1mXz7kTU+i7+ZkL5s2R37PLId
HbJMRsSe1ElPc+wc9UWh2LH6apSEK+Kf7V/Q25lH2oqzqk+kepPpjUrFclLLmWij
OnYvO7P41x6LMfRy8dryzmzDiAPgjlvBAf0tTlNSKC1i91717UDiHR0t0jGYFAL9
BL91K1QX9bZTmBd2xfkGtejOotMVWl1uCTRXJtaEUUwcqBVg1JFzAoKrjE5p8tg8
VeUHoelBDEBkXEjHSH38r8D17yaL/NCu+vjfk8huC19onSTyv4CCU1WrF6xbvjeT
k6u71DGreKfeFiaHBvz4iS2M6QgpZiW3+nB6FZ3dyR3W+PrHwJ1ts5XcVsqOhw5L
oGyJLXdCjfv7zm1m4NlBRDGpWkBH/vylo/Q1L5aJ5ak+PchK1bSmzquqYIcDoiuC
0kVVM6sbPii+U85SevZCeC2TXzNUYrXnoxyViDHx71STtbut51hIfnVhFzaR/KMx
c0l4CHVjDYNkB+ezhxiDDWdCw7XxN1gS1gj2x0vN/L+ysymGQiu2oBh7GuHWbGOp
aBgSUsAnvXbNCg22ihFR
=+p2L
-----END PGP SIGNATURE-----

--E9SPMlsjsjqOlA3h--
