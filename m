Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbbACM0q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 07:26:46 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:41222 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbbACM0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 07:26:44 -0500
Date: Sat, 3 Jan 2015 08:26:36 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com, rui.zhang@intel.com,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] ti-soc-thermal: implement eocz bit to make driver useful
 on omap3
Message-ID: <20150103122634.GB22356@developer>
References: <20150103114632.GA21883@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <20150103114632.GA21883@amd>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 03, 2015 at 12:46:32PM +0100, Pavel Machek wrote:
> For omap3, proper implementation of eocz bit is needed. It was
> actually a TODO in the driver.
>=20
> When periodic mode is not enabled, it is neccessary to force reads.
>=20
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/therma=
l/ti-soc-thermal/ti-bandgap.c
> index 634b6ce..ee63d08 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> @@ -43,6 +43,8 @@
> =20
>  #include "ti-bandgap.h"
> =20
> +static int ti_bandgap_force_single_read(struct ti_bandgap *bgp, int id);
> +
>  /***   Helper functions to access registers and their bitfields   ***/
> =20
>  /**
> @@ -852,14 +831,20 @@ int ti_bandgap_read_temperature(struct ti_bandgap *=
bgp, int id,
>  	if (ret)
>  		return ret;
> =20
> +	if (!TI_BANDGAP_HAS(bgp, MODE_CONFIG)) {
> +		ret =3D ti_bandgap_force_single_read(bgp, id);

not sure MODE_CONFIG is sufficient condition for single read on all OMAP
versions.

> +		if (ret)
> +			return ret;
> +	}
> +
>  	spin_lock(&bgp->lock);
>  	temp =3D ti_bandgap_read_temp(bgp, id);
>  	spin_unlock(&bgp->lock);
> =20
> -	ret |=3D ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
> +	ret =3D ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);

this one should be part of your clean up patch

>  	if (ret)
>  		return -EIO;
> =20
>  	*temperature =3D temp;
> =20
>  	return 0;
> @@ -917,7 +903,8 @@ void *ti_bandgap_get_sensor_data(struct ti_bandgap *b=
gp, int id)
>  static int
>  ti_bandgap_force_single_read(struct ti_bandgap *bgp, int id)
>  {
> -	u32 temp =3D 0, counter =3D 1000;
> +	u32 counter =3D 1000;
> +	struct temp_sensor_registers *tsr;
> =20
>  	/* Select single conversion mode */
>  	if (TI_BANDGAP_HAS(bgp, MODE_CONFIG))
> @@ -925,16 +912,27 @@ ti_bandgap_force_single_read(struct ti_bandgap *bgp=
, int id)
> =20
>  	/* Start of Conversion =3D 1 */
>  	RMW_BITS(bgp, id, temp_sensor_ctrl, bgap_soc_mask, 1);
> -	/* Wait until DTEMP is updated */
> -	temp =3D ti_bandgap_read_temp(bgp, id);
> =20
> -	while ((temp =3D=3D 0) && --counter)
> -		temp =3D ti_bandgap_read_temp(bgp, id);
> -	/* REVISIT: Check correct condition for end of conversion */
> +	/* Wait for EOCZ going up */
> +	tsr =3D bgp->conf->sensors[id].registers;
> +
> +	while (--counter) {
> +		if (ti_bandgap_readl(bgp, tsr->temp_sensor_ctrl) &
> +		    tsr->bgap_eocz_mask)
> +			break;
> +	}
> =20
>  	/* Start of Conversion =3D 0 */
>  	RMW_BITS(bgp, id, temp_sensor_ctrl, bgap_soc_mask, 0);
> =20
> +	/* Wait for EOCZ going down */
> +	counter =3D 1000;
> +	while (--counter) {
> +		if (!(ti_bandgap_readl(bgp, tsr->temp_sensor_ctrl) &
> +		      tsr->bgap_eocz_mask))
> +			break;
> +	}
> +
>  	return 0;
>  }
> =20
>=20
> --=20
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/b=
log.html

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUp9/xAAoJEMLUO4d9pOJWPmkH/2SlJIWwjwW2CW5JzAk7XK8U
f4FupZ2JqvldNWNaYB/5Dz61Kj/QBD/Y7FJXHKxzxoIWSL37vcRua+0gUBD35ziY
KGzDBtpfhuLHS4xhQ6eQl0JURcIh+O/xllQ42YuRRjOQCRKWMPczINtGc3iZQASk
VWkI/UdnQmG/Ut6XGfxpSpvs7WhemHdWxMhvjE6CIyKsLTE5DgE23WAdY8KxRLq6
5zmk1celWPekwLpiMlSS/0KBa3CuG5fwvxriUkZGl1M7pTT7B6lY/LdzOLGokvE/
8jc41E0uL1cnefNUXk/zOgyAAkRIuYDuv2GPS/f++qp5+7tQ6nYmKeULB89heXc=
=CmDk
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
