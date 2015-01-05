Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbbAEVmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:42:11 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:38506 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbbAEVmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:42:08 -0500
Date: Mon, 5 Jan 2015 17:41:57 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: nm@ti.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: Re: [PATCH] thermal: add omap3 support
Message-ID: <20150105214155.GE31536@developer>
References: <20150103111146.GB7065@amd>
 <20150103123426.GA26069@developer>
 <20150103220219.GA26747@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="so9zsI5B81VjUb/o"
Content-Disposition: inline
In-Reply-To: <20150103220219.GA26747@amd>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--so9zsI5B81VjUb/o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 03, 2015 at 11:02:19PM +0100, Pavel Machek wrote:
> Hi!
>=20
> > Thanks for sending your code.
>=20
> You are welcome.
>=20
> > > Add support for omap3430 sensor. Tested on Nokia N900.
> >=20
> > To my understanding, and as already mentioned by Nishanth Menon
> > (currently TIer), TI has intentionally avoided adding this support.
>=20
> Well, Nokia had similar code in their kernel.
>=20
> > There is a hardware accuracy limitation in this sensor, and therefore it
> > is not advisable to use it, specially in Dynamic Thermal Management,
> > such as the thermal framework.
>=20
> We are talking cellphone here. Yes, sensor may be inacurate (but it
> seems to work pretty well; perhaps TI can point us to some docs that
> explains the details?), but it provides useful information (mostly

sure! you should demand TI the proper data pointers.

> room temperature). I don't think we'll ever run anywhere close to
> thermal limits where inacuracy would matter. (Battery can't really
> take > 60C. AFAICT CPU limit is 120C. Battery is close to the CPU.)

Well, when the sensor's accuracy is +-15C and there is variance across
the sample distribution, well, that means you are gonna see products
behaving way different from each other, even if you are attempting to
find a threshold to shutdown a device.=20

BTW, I am not a TIer anymore, and I don't have the exact data to provide
you.

>=20
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > >=20
> > > diff --git a/drivers/thermal/ti-soc-thermal/Kconfig b/drivers/thermal=
/ti-soc-thermal/Kconfig
> > > index bd4c7be..a49495f 100644
> > > --- a/drivers/thermal/ti-soc-thermal/Kconfig
> > > +++ b/drivers/thermal/ti-soc-thermal/Kconfig
> > > @@ -21,6 +21,15 @@ config TI_THERMAL
> > >  	  This includes trip points definitions, extrapolation rules and
> > >  	  CPU cooling device bindings.
> > > =20
> > > +config OMAP3_THERMAL
> > > +	bool "Texas Instruments OMAP3 thermal support"
> > > +	depends on TI_SOC_THERMAL
> > > +	depends on ARCH_OMAP3
> > > +	help
> > > +	  If you say yes here you get thermal support for the Texas Instrum=
ents
> > > +	  OMAP3 SoC family. The current chip supported are:
> > > +	   - OMAP3430
> >=20
> > But if you insist :-), I believe the user deserves at least a fair
> > message saying this is on his / her own risk.
>=20
> Something like this?
>=20
>           If you say yes here you get thermal support for the Texas Instr=
uments
> 	  OMAP3 SoC family. The current chip supported are:
> 	              - OMAP3430
>=20
>           OMAP3 chips normally don't need thermal management, and sensors=
 in
> 	  this generation are not very accurate, nor they are very close to
>           the important hotspots.

I would be stronger and rephrase with s/very//g.=20


>=20
>           Say 'N' here.
> 	 =20
>=20
> > > +static struct temp_sensor_registers
> > > +omap34xx_mpu_temp_sensor_registers =3D {
> > > +	.temp_sensor_ctrl =3D 0,
> > > +	.bgap_tempsoff_mask =3D 0, /* Unused, we don't have POWER_SWITCH */
> > > +	.bgap_soc_mask =3D BIT(8),
> > > +	.bgap_eocz_mask =3D BIT(7),
> > > +	.bgap_dtemp_mask =3D 0x7f,
> > > +
> > > +	.bgap_mode_ctrl =3D 0,
> > > +	.mode_ctrl_mask =3D BIT(9),
> > > +
> > > +	.bgap_efuse =3D 0,
> >=20
> > The 0'ed filed may be removed here.
>=20
> Ok; I'll keep temp_sensors_ctrl / bgap_mode_ctrl, because it is actually =
used.
>=20
>=20
> > > diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/th=
ermal/ti-soc-thermal/ti-bandgap.c
> > > index 634b6ce..3b4e72f 100644
> > > --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> > > +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> > > @@ -1509,6 +1531,12 @@ static SIMPLE_DEV_PM_OPS(ti_bandgap_dev_pm_ops=
, ti_bandgap_suspend,
> > >  #endif
> > > =20
> > >  static const struct of_device_id of_ti_bandgap_match[] =3D {
> > > +#ifdef CONFIG_OMAP3_THERMAL
> > > +	{
> > > +		.compatible =3D "ti,omap34xx-bandgap",
> >=20
> > This needs to be updated in the binding documentation.
> > Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt
>=20
> Ok.
>=20
> > > +		.data =3D (void *)&omap34xx_data,
> >=20
> >=20
> > Having a run time message intentionally advising users of the risk of
> > using this sensor is also required.
>=20
> Ok, what about?
>=20
>     if (TI_BANDGAP_HAS(bgp, UNRELIABLE))
>               dev_warn(&pdev->dev,
>                          "OMAP3 thermal sensor is unreliable and normally=
 unneccessary\n");
>=20

works for me.

> Will not fit in 80 columns, but keeping message on one line is more impor=
tant.
> 									Pavel
> --=20
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/b=
log.html

--so9zsI5B81VjUb/o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqwUbAAoJEMLUO4d9pOJWVdAH/RtoPUx13kq6u1uUM14+E9ln
VZs1AhnuDFFwcyb2WXFYPUDtR1zOBBQM7/4bMhF+yTPMkJ1s9pNBYBIozGTPGPAg
UpirELS1w3yIdqeFMGLuITgA9z+wOMkMt+rJsFLr1sszqL91cTrUIf6JRNOudBOp
KLhK/O6/lnNjJG62DCZnJJqFS6ePAiPjFoae+osSD3PsixBpV38oX9kI3XyEvJow
Ii3QEMFrqFiyYDlcufjdwpY4qId4S2XVI7qdbir7NBqqRnkqMN+xCiiK6aqrP7eS
f8c6iGOtFO5TlSFGXzBWiZpBrtfo4jtnrdagj6Yr3P8pIY2dGaS2mnLI5oayFSs=
=Kb9D
-----END PGP SIGNATURE-----

--so9zsI5B81VjUb/o--
