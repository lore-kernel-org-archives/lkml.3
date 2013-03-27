Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3C0WDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:03:50 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:60853 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab3C0WDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:03:49 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] OMAP3 ROM Random Number Generator support
Date: Wed, 27 Mar 2013 23:03:44 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Juha Yrjola <juha.yrjola@solidboot.com>,
        Russell King <linux@arm.linux.org.uk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201302281905.48546@pali> <20130327210918.GP10155@atomide.com>
In-Reply-To: <20130327210918.GP10155@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1764661.QmgNPEheaY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303272303.44420@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1764661.QmgNPEheaY
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 27 March 2013 22:09:18 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130228 10:09]:
> > --- /dev/null
> > +++ b/drivers/char/hw_random/omap3-rom-asm.S
> > @@ -0,0 +1,27 @@
> > +/*
> > + * Copyright (C) 2009 Nokia Corporation
> > + *
> > + * This program is free software; you can redistribute it
> > and/or modify + * it under the terms of the GNU General
> > Public License version 2 as + * published by the Free
> > Software Foundation.
> > + *
> > + */
> > +
> > +#include <linux/linkage.h>
> > +#include <asm/assembler.h>
> > +
> > +ENTRY(omap3_rng_call_rom_asm)
> > +	.arch_extension sec
> > +	stmfd	sp!, {r4-r12, lr}
> > +	stmfd	sp!, {r0-r3}
> > +	bl	v7_flush_dcache_all
> > +	ldmfd	sp!, {r0-r3}
> > +	mov	r6, #0xff
> > +	mov	r12, r0
> > +	smc	#1
> > +	mov	r12, r0
> > +	bl	v7_flush_dcache_all
> > +	mov	r0, #0
> > +	mcr	p15, 0, r0, c7, c5, 0
> > +	mov	r0, r12
> > +	ldmfd	sp!, {r4-r12, pc}
>=20
> This part should be in arch/arm/mach-omap2 because of the
> direct calls to v7_flush_dcache_all. Then you can pass a
> pointer to this function in platform_data for now, and set it
> up based on the compatible flag with device tree from driver
> later on.
>=20

Ok, I will move this file to arch/arm/mach-omap2/omap3-rom-rng.S=20
and pass function via platform_data to driver.

> > --- /dev/null
> > +++ b/drivers/char/hw_random/omap3-rom-drv.c
> > @@ -0,0 +1,167 @@
> > +/*
> > + * omap3-rom-drv.c - RNG driver for TI OMAP3 CPU family
> > + *
> > + * Copyright (C) 2009 Nokia Corporation
> > + * Author: Juha Yrjola <juha.yrjola@solidboot.com>
> > + *
> > + * This file is licensed under  the terms of the GNU
> > General Public + * License version 2. This program is
> > licensed "as is" without any + * warranty of any kind,
> > whether express or implied. + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/random.h>
> > +#include <linux/hw_random.h>
> > +#include <linux/timer.h>
> > +#include <linux/clk.h>
> > +#include <linux/err.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include "../../../arch/arm/mach-omap2/soc.h"
>=20
> NAK for this, this must be private to arch/arm/mach-omap2.
>=20
> Instead, just create a minimal
> include/linux/platform_data/omap3-rom.h, and pass the
> function pointer in the pdata if passed.
>=20
> > +static int omap3_rom_rng_probe(struct platform_device
> > *pdev) +{
> > +	printk(KERN_INFO "%s: initializing\n",
> > omap3_rom_rng_name); +	if (!cpu_is_omap34xx()) {
> > +		printk(KERN_ERR "%s: currently supports only OMAP34xx
> > CPUs\n", +		       omap3_rom_rng_name);
> > +		return -ENODEV;
> > +	}
> > +	if (omap_type() =3D=3D OMAP2_DEVICE_TYPE_GP) {
> > +		printk(KERN_ERR "%s: GP OMAPs not supported\n",
> > +		       omap3_rom_rng_name);
> > +		return -ENODEV;
> > +	}
> > +
> > +	setup_timer(&idle_timer, omap3_rom_idle_rng, 0);
> > +	rng_clk =3D clk_get_sys("omap_rng", "ick");
> > +	if (IS_ERR(rng_clk)) {
> > +		printk(KERN_ERR "%s: unable to get RNG clock\n",
> > +		       omap3_rom_rng_name);
> > +		return IS_ERR(rng_clk);
> > +	}
> > +
> > +	/* Leave the RNG in reset state. */
> > +	clk_prepare_enable(rng_clk);
> > +	omap3_rom_idle_rng(0);
> > +
> > +	return hwrng_register(&omap3_rom_rng_ops);
> > +}
>=20
> You should replace the cpu_is_omap34xx() and omap_type() with
> some flags that you pass in the pdata. These too can be then
> deciphered based on the DT compatible flag later on. And then
> you don't need to include soc.h.
>=20
> Regards,
>=20
> Tony

I will remove above code for checking omap type from hw rand=20
driver, because same code is in omap part which creating=20
platform_device for this driver. So soc.h is not needed.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1764661.QmgNPEheaY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFTbMAACgkQi/DJPQPkQ1JcdACfbS5Mx3/OT3QvDtD0w8jLvZa8
Mc4AnRF9/qvLNvFoJpDPDEdcTNqPlqBw
=nV9O
-----END PGP SIGNATURE-----

--nextPart1764661.QmgNPEheaY--
