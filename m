Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab3IRIdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 04:33:31 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:47639 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3IRId2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 04:33:28 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 2/2] RX-51: ARM errata 430973 workaround
Date: Wed, 18 Sep 2013 10:33:24 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, Nishanth Menon <nm@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
References: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com> <1373461145-9812-3-git-send-email-pali.rohar@gmail.com> <20130917232417.GK9994@atomide.com>
In-Reply-To: <20130917232417.GK9994@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9078695.OxvBY3IjGq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309181033.24965@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9078695.OxvBY3IjGq
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 18 September 2013 01:24:17 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130710 06:06]:
> > --- a/arch/arm/mach-omap2/board-rx51.c
> > +++ b/arch/arm/mach-omap2/board-rx51.c
>=20
> This file will be gone as soon as we're moving to device
> tree based booting. So let's do this in more future proof
> way.
>=20
> > +/**
> > + * rx51_secure_dispatcher: Routine to dispatch secure PPA
> > API calls + * @idx: The PPA API index
> > + * @process: Process ID
> > + * @flag: The flag indicating criticality of operation
> > + * @nargs: Number of valid arguments out of four.
> > + * @arg1, arg2, arg3 args4: Parameters passed to secure API
> > + *
> > + * Return the non-zero error value on failure.
> > + */
> > +static u32 rx51_secure_dispatcher(u32 idx, u32 process, u32
> > flag, u32 nargs, +			   u32 arg1, u32 arg2, u32 arg3, u32
> > arg4)
> > +{
> > +	u32 ret;
> > +	u32 param[5];
> > +
> > +	param[0] =3D nargs+1; /* RX-51 needs number of arguments +=20
1
> > */ +	param[1] =3D arg1;
> > +	param[2] =3D arg2;
> > +	param[3] =3D arg3;
> > +	param[4] =3D arg4;
> > +
> > +	/*
> > +	 * Secure API needs physical address
> > +	 * pointer for the parameters
> > +	 */
> > +	local_irq_disable();
> > +	local_fiq_disable();
> > +	flush_cache_all();
> > +	outer_clean_range(__pa(param), __pa(param + 5));
> > +	ret =3D omap_smc3(idx, process, flag, __pa(param));
> > +	flush_cache_all();
> > +	local_fiq_enable();
> > +	local_irq_enable();
> > +
> > +	return ret;
> > +}
>=20
> I think this used to be in omap-secure.c, and then made rx51
> specific.. But since board-rx51.c is going away, let's move
> this function to omap-secure.c.
>=20
> > + * rx51_secure_update_aux_cr: Routine to modify the
> > contents of Auxiliary Control Register + *  @set_bits: bits
> > to set in ACR
> > + *  @clr_bits: bits to clear in ACR
> > + *
> > + * Return the non-zero error value on failure.
> > +*/
> > +static u32 rx51_secure_update_aux_cr(u32 set_bits, u32
> > clear_bits) +{
> > +	u32 acr;
> > +
> > +	/* Read ACR */
> > +	asm volatile ("mrc p15, 0, %0, c1, c0, 1" : "=3Dr" (acr));
> > +	acr &=3D ~clear_bits;
> > +	acr |=3D set_bits;
> > +
> > +	return rx51_secure_dispatcher(RX51_PPA_WRITE_ACR,
> > +				      0,
> > +				      FLAG_START_CRITICAL,
> > +				      1, acr, 0, 0, 0);
> > +}
>=20
> This too.
>=20
> >  static void __init rx51_init(void)
> >  {
> > =20
> >  	struct omap_sdrc_params *sdrc_params;
> >=20
> > @@ -105,6 +175,14 @@ static void __init rx51_init(void)
> >=20
> >  	rx51_peripherals_init();
> >  	rx51_camera_init();
> >=20
> > +	if (omap_type() =3D=3D OMAP2_DEVICE_TYPE_SEC) {
> > +#ifdef CONFIG_ARM_ERRATA_430973
> > +		pr_info("RX-51: Enabling ARM errata 430973
> > workaround\n"); +		/* set IBE to 1 */
> > +		rx51_secure_update_aux_cr(BIT(6), 0);
> > +#endif
> > +	}
> > +
> >=20
> >  	/* Ensure SDRC pins are mux'd for self-refresh */
> >  	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
> >  	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
>=20
> Then this can be called both from board-generic.c based on the
> compatible flag, and board-rx51.c for now.
>=20
> Regards,
>=20
> Tony

Hi Tony,

I'm not very happy. I sent this patch 6 months ago and only now=20
you commented that needs rework again. This patch is needed=20
because all thumb-2 userspace binaries crashing. I want to have
working support for Nokia N900 and not always rebasing and=20
changing patches. Also DT still not working on N900 (file contains=20
only small subset of devices as in board files plus it is not in=20
stable kernel) so I do not want to switch to DT. I need something=20
which is working and not something new non-working. I belive that=20
you and other kernel guys do not remove all n900 board files until=20
every one line will be rewritten to DT and tested that everything=20
working. And from this and other conversation it looks for me=20
that you are going to do that. So please clarify what you want to=20
do (and when) with board-rx51-* files. Aftethat I can decide what=20
to do in future.

=46or now I see this situation something like: I wrote patches,=20
send them to ML and after half of year maintainer politely=20
rejected them becuase my patches not using new uber cool=20
technology with still not working and also was not available half=20
year ago. What happen if I find another time to rework this patch=20
and send it again in next 2 or 5 months?

Tony, if you did not have time for review this patch months ago=20
or you found it only today - no problem, I understand it. But=20
what I need to know is what will happen with board-rx51-* files=20
(and when?) You can see that DT does not have definitions of all=20
n900 hw parts (plus it is not in last 3.11 kernel!) which means=20
that DT is not usable for me and other n900 people. This also=20
means that I cannot rewrite my patches for DT and test if they=20
working.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart9078695.OxvBY3IjGq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlI5ZVQACgkQi/DJPQPkQ1K6awCfRYkuKBejXVY7RsrNw7uQRfXW
GlMAoKQOoyVYdsdBhUhNQXtgivRN+9sd
=7ewG
-----END PGP SIGNATURE-----

--nextPart9078695.OxvBY3IjGq--
