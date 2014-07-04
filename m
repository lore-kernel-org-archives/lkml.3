Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaGDJAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:00:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56588 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750758AbaGDJAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:00:06 -0400
Date: Fri, 4 Jul 2014 10:57:39 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: devicetree@vger.kernel.org, dbaryshkov@gmail.com,
        Nicolas FERRE <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        dwmw2@infradead.org, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/18] power: reset: Add AT91 reset driver
Message-ID: <20140704085739.GA13487@lukather>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
 <1404396906-25194-8-git-send-email-maxime.ripard@free-electrons.com>
 <F9547E0F-AB97-47E6-BA09-135EE4E1BC73@jcrosoft.com>
 <20140703145957.GH31996@lukather>
 <12CC7818-BC48-4FD2-8663-F30F1AEC5477@jcrosoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <12CC7818-BC48-4FD2-8663-F30F1AEC5477@jcrosoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 04, 2014 at 10:40:56AM +0800, Jean-Christophe PLAGNIOL-VILLARD =
wrote:
>=20
> On Jul 3, 2014, at 10:59 PM, Maxime Ripard <maxime.ripard@free-electrons.=
com> wrote:
>=20
> > On Thu, Jul 03, 2014 at 10:39:08PM +0800, Jean-Christophe PLAGNIOL-VILL=
ARD wrote:
> >>> +++ b/drivers/power/reset/at91-reset.c
> >>> @@ -0,0 +1,202 @@
> >>> +/*
> >>> + * Atmel AT91 SAM9 SoCs reset code
> >>> + *
> >>> + * Copyright (C) 2014 Maxime Ripard
> >>> + *
> >>> + * Maxime Ripard <maxime.ripard@free-electrons.com>
> >>=20
> >> you can not own the copyright as it=E2=80=99s basically a copy of other
> >> people code
> >=20
> > The previous names are missing, right.
> >=20
> >>> + *
> >>> + * This file is licensed under the terms of the GNU General Public
> >>> + * License version 2.  This program is licensed "as is" without any
> >>> + * warranty of any kind, whether express or implied.
> >>> + */
> >>> +
> >>> +#include <linux/io.h>
> >>> +#include <linux/module.h>
> >>> +#include <linux/of_address.h>
> >>> +#include <linux/platform_device.h>
> >>> +#include <linux/reboot.h>
> >>> +
> >>> +#include <asm/system_misc.h>
> >>> +
> >>> +#include <mach/at91sam9_ddrsdr.h>
> >>> +#include <mach/at91sam9_sdramc.h>
> >>> +
> >>> +#define AT91_RSTC_CR	0x00		/* Reset Controller Control Register */
> >>> +#define	AT91_RSTC_PROCRST	BIT(0)		/* Processor Reset */
> >>> +#define	AT91_RSTC_PERRST	BIT(2)		/* Peripheral Reset */
> >>> +#define	AT91_RSTC_EXTRST	BIT(3)		/* External Reset */
> >>> +#define	AT91_RSTC_KEY		(0xa5 << 24)	/* KEY Password */
> >>> +
> >>> +#define AT91_RSTC_SR	0x04		/* Reset Controller Status Register */
> >>> +#define	AT91_RSTC_URSTS		BIT(0)		/* User Reset Status */
> >>> +#define	AT91_RSTC_RSTTYP	GENMASK(10, 8)	/* Reset Type */
> >>> +#define	AT91_RSTC_NRSTL		BIT(16)		/* NRST Pin Level */
> >>> +#define	AT91_RSTC_SRCMP		BIT(17)		/* Software Reset Command in Progr=
ess */
> >>> +
> >>> +#define AT91_RSTC_MR	0x08		/* Reset Controller Mode Register */
> >>> +#define	AT91_RSTC_URSTEN	BIT(0)		/* User Reset Enable */
> >>> +#define	AT91_RSTC_URSTIEN	BIT(4)		/* User Reset Interrupt Enable */
> >>> +#define	AT91_RSTC_ERSTL		GENMASK(11, 8)	/* External Reset Length */
> >>> +
> >>> +enum reset_type {
> >>> +	RESET_TYPE_GENERAL	=3D 0,
> >>> +	RESET_TYPE_WAKEUP	=3D 1,
> >>> +	RESET_TYPE_WATCHDOG	=3D 2,
> >>> +	RESET_TYPE_SOFTWARE	=3D 3,
> >>> +	RESET_TYPE_USER		=3D 4,
> >>> +};
> >>> +
> >>> +static void __iomem *at91_ramc_base[2], *at91_rstc_base;
> >>> +
> >>> +static void at91sam9_restart(enum reboot_mode mode, const char *cmd)
> >>> +{
> >>> +	asm volatile(
> >>> +		".balign 32\n\t"
> >>> +
> >>> +		"str	%2, [%0, #" __stringify(AT91_SDRAMC_TR) "]\n\t"
> >>> +		"str	%3, [%0, #" __stringify(AT91_SDRAMC_LPR) "]\n\t"
> >>> +		"str	%4, [%1, #" __stringify(AT91_RSTC_CR) "]\n\t"
> >>> +
> >>> +		"b	.\n\t"
> >>> +		:
> >>> +		: "r" (at91_ramc_base[0]),
> >>> +		  "r" (at91_rstc_base),
> >>> +		  "r" (1),
> >>> +		  "r" (AT91_SDRAMC_LPCB_POWER_DOWN),
> >>> +		  "r" (AT91_RSTC_KEY | AT91_RSTC_PERRST | AT91_RSTC_PROCRST));
> >>> +}
> >>> +
> >>> +static void at91sam9g45_restart(enum reboot_mode mode, const char *c=
md)
> >>> +{
> >>> +	asm volatile(
> >>> +		"cmp	%1, #0\n\t"
> >>> +		"beq	1f\n\t"
> >>> +
> >>> +		"ldr	r0, [%1]\n\t"
> >>> +		"cmp	r0, #0\n\t"
> >>> +
> >>> +		".balign 32\n\t"
> >>> +
> >>> +		"1:	str	%3, [%0, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
> >>> +		"	str	%4, [%0, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
> >>> +		"	strne	%3, [%1, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
> >>> +		"	strne	%4, [%1, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
> >>> +		"	str	%5, [%2, #" __stringify(AT91_RSTC_CR) "]\n\t"
> >>> +
> >>> +		"	b	.\n\t"
> >>> +		:
> >>> +		: "r" (at91_ramc_base[0]),
> >>> +		  "r" (at91_ramc_base[1]),
> >>> +		  "r" (at91_rstc_base),
> >>> +		  "r" (1),
> >>> +		  "r" (AT91_DDRSDRC_LPCB_POWER_DOWN),
> >>> +		  "r" (AT91_RSTC_KEY | AT91_RSTC_PERRST | AT91_RSTC_PROCRST)
> >>> +		: "r0");
> >>> +}
> >>> +
> >> move this to an assembly file more easy to read than a C code
> >=20
> > Nope. It's a pain to pass variable to an external assembly file, and
> > this makes the use of global variable pretty much mandatory, which is
> > definitely not great.
>=20
> Not at all I did for the PM slow clock code just write a function and pas=
 it as a parameter
> you have 3
>=20
> so basically you have to use the current and just pass at91_ramc_base[0],=
 at91_ramc_base[1]
> and at91_rstc_base
> it=E2=80=99s 3 lignes of modification, if you have at91_ramc_base and at9=
1_ramc_base same
>=20
> so NACK

There's also a strong pattern for doing inline assembly in the kernel:

$ git grep "asm volatile" -- drivers/ | wc -l=20
130

$ find drivers/ -name *.S
9

Most of them being code where we don't have any other choice (FIQ/NMI
handlers, etc.)

Plus, the code is actually much simpler using inline assembly. You
don't have to worry about all the register allocation, you don't have
to worry about the arguments themselves.

I admit that I forgot to reintroduce all the comments that where
there. It's an issue, it will be fixed, but I really don't see what a
separate assembly files bring.

> >=20
> >>=20
> >>> +static void __init at91_reset_status(struct platform_device *pdev)
> >>> +{
> >>> +	u32 reg =3D readl(at91_rstc_base + AT91_RSTC_SR);
> >>> +	char *reason;
> >>> +
> >>> +	switch ((reg & AT91_RSTC_RSTTYP) >> 8) {
> >>> +	case RESET_TYPE_GENERAL:
> >>> +		reason =3D "general reset";
> >>> +		break;
> >>> +	case RESET_TYPE_WAKEUP:
> >>> +		reason =3D "wakeup";
> >>> +		break;
> >>> +	case RESET_TYPE_WATCHDOG:
> >>> +		reason =3D "watchdog reset";
> >>> +		break;
> >>> +	case RESET_TYPE_SOFTWARE:
> >>> +		reason =3D "software reset";
> >>> +		break;
> >>> +	case RESET_TYPE_USER:
> >>> +		reason =3D "user reset";
> >>> +		break;
> >>> +	default:
> >>> +		reason =3D "unknown reset";
> >>> +		break;
> >>> +	}
> >>> +
> >>> +	pr_info("AT91: Starting after %s\n", reason);
> >>> +}
> >>> +
> >>> +static struct of_device_id at91_ramc_of_match[] =3D {
> >>> +	{ .compatible =3D "atmel,at91sam9260-sdramc", },
> >>> +	{ .compatible =3D "atmel,at91sam9g45-ddramc", },
> >>> +	{ /* sentinel */ }
> >>> +};
> >>> +
> >>> +static struct of_device_id at91_reset_of_match[] =3D {
> >>> +	{ .compatible =3D "atmel,at91sam9260-rstc", .data =3D at91sam9_rest=
art },
> >>> +	{ .compatible =3D "atmel,at91sam9g45-rstc", .data =3D at91sam9g45_r=
estart },
> >>> +	{ /* sentinel */ }
> >>> +};
> >>> +
> >>> +static int at91_reset_probe(struct platform_device *pdev)
> >>> +{
> >>> +	struct resource *res;
> >>> +
> >>> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>> +	at91_rstc_base =3D devm_ioremap_resource(&pdev->dev, res);
> >>> +	if (IS_ERR(at91_rstc_base)) {
> >>> +		dev_err(&pdev->dev, "Could not map reset controller address\n");
> >>> +		return PTR_ERR(at91_rstc_base);
> >>> +	}
> >>> +
> >>> +	if (pdev->dev.of_node) {
> >>=20
> >> split in 2 function more easy to ready and less indentation
> >=20
> > ok.
> >=20
> >>> +		const struct of_device_id *match;
> >>> +		struct device_node *np;
> >>> +		int idx =3D 0;
> >>> +
> >>> +		for_each_matching_node(np, at91_ramc_of_match) {
> >>> +			at91_ramc_base[idx] =3D of_iomap(np, 0);
> >>> +			if (!at91_ramc_base[idx]) {
> >>> +				dev_err(&pdev->dev, "Could not map ram controller address\n");
> >>> +				return -ENODEV;
> >>> +			}
> >>> +			idx++;
> >>> +		}
> >>=20
> >> and if you can not probe the ram controler it=E2=80=99s a panic not a =
-ENODEV
> >>=20
> >> as you have an unstable platform
> >=20
> > I don't really see why. That the pm code and the reset code won't be
> > able to work, it's obvious. But making the assumption that the
> > platforms don't have a RAM properly setup just because it doesn't have
> > a DT node seems quite weak.
>=20
> no as if you do not have the RAMC your reset will cause hardware
> issue as there is a bug in the SoC

No, because the reset hook won't be installed. So it will never
trigger any bug, since it won't do anything.

> so yes mandatory as 95% of the people will not known why there board
> will suddenly do not reboot.

Well, there's an error message in the boot logs.

> As this specific reset in assembly was write to run from cache to
> fix a SoC bug in the reset controller

Yes. I know.

So, to sum things up, just because you can't reboot, you don't want to
run at all?

Should we also panic when the reset driver is not compiled in then?

> >=20
> >>> +
> >>> +		match =3D of_match_node(at91_reset_of_match, pdev->dev.of_node);
> >>> +		arm_pm_restart =3D match->data;
> >>> +	} else {
> >>> +		const struct platform_device_id *match;
> >>> +		int idx =3D 0;
> >>> +
> >>> +		for (idx =3D 0; idx < 2; idx++) {
> >>> +			res =3D platform_get_resource(pdev, IORESOURCE_MEM, idx + 1 );
> >>> +			at91_ramc_base[idx] =3D devm_ioremap_resource(&pdev->dev, res);
> >>> +			if (IS_ERR(at91_ramc_base[idx])) {
> >>> +				dev_err(&pdev->dev, "Could not map ram controller address\n");
> >>> +				return PTR_ERR(at91_rstc_base);
> >>> +			}
> >>> +		}
> >>> +
> >>> +		match =3D platform_get_device_id(pdev);
> >>> +		arm_pm_restart =3D (void (*)(enum reboot_mode, const char*))
> >>> +			match->driver_data;
> >>> +	}
> >>> +
> >>> +	at91_reset_status(pdev);
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static struct platform_device_id at91_reset_plat_match[] =3D {
> >>> +	{ "at91-sam9-reset", (unsigned long)at91sam9_restart },
> >>> +	{ "at91-g45-reset", (unsigned long)at91sam9g45_restart },
> >> 	    at91-sam9???
> >>=20
> >> 	    from the beginning of DT we put the first SoC were the
> >> 	    reset was introduce and why do you change the DT binding?
> >=20
> > Except that this is not about DT probing, but the old-style board
> > files one.
> >=20
>=20
> except that in al the other driver such as FBDEV we use the same
> principle for platform_device

Ok. I was trying to keep the former naming of the former restart
functions, but it also makes sense.

I'll change this.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtmyDAAoJEBx+YmzsjxAgpqoP/RpIIEF6fJf6L6FcxLJlP81h
HvNINISxdEkTsdhtxZNlTQRmRdVHYDARHBMwEK7X6WvKiu9v03QJW9zBRCMcSwRz
FKgekXO1N/0Um6P10mqNv7EqMoJVIPGtiNdPFnviz6U/ES0Jkx4oD7EUjpb5CBKu
gE31DVJ+Rak8EsQDCmUVs4GCiUomuMYcNS6S/keyysdRSDapAnzXtNrOpSWpb8FR
kZBgbIw9WPaimCy5fZdsA0M69tHrurM3NzPkmiSL3gx68Qu4quhzFt9GjtVETPzU
cvwy/yxzAVFc2vlJoOlpGUn0A0jhuvCj1THGwUo5r3ToKpQXepEHQ5iiGi2uOzdK
d+p5TIkFSwcDqe7BLNWZGyG9xxLlwHmpKlTeNzbqmFfGyJ8AoQT+IiaxwFXZ74rM
QeYmwmG6Hd68iVUa7l/XZfM6BltXBB179K9AXKkkcTxoHOTh22Z+iQ2xOZ1gWeaP
bIxOWWXMlRZJ2ZRhKJDIar4GKQMyY54nhC9WI6jFWjH9ciNr420RqL+N4L7tlCWT
z1s9cjFAE3AbklyRSS8pVVvzKQ0/M08uT/bwRWWiNh/IEqzqEkGtfK55y25GVwx+
iWH7pu4xI+ypUmShOK2NHZL1yel/ZGyzfz4crCxSoBqVO5QuTaYG0zqGZ5kx2/Sq
Vl7M9eoFlfacU3Cg8nu1
=5wXb
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
