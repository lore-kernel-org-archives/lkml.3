Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaKRNZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:25:49 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:51934 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaKRNZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:25:46 -0500
Date: Tue, 18 Nov 2014 08:50:31 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Linux PM <linux-pm@vger.kernel.org>,
        Caesar Wang <caesar.wang@rock-chips.com>, Wei Ni <wni@nvidia.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        lm-sensors@lm-sensors.org, Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 1/1] thermal: of: improve of-thermal sensor registration
 API
Message-ID: <20141118125029.GA15239@developer>
References: <1416264255-10083-1-git-send-email-edubezval@gmail.com>
 <1416269103-14149-1-git-send-email-edubezval@gmail.com>
 <20141118083857.18e07130@amdc2363>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20141118083857.18e07130@amdc2363>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hey Lukasz,

On Tue, Nov 18, 2014 at 08:38:57AM +0100, Lukasz Majewski wrote:
> Hi Eduardo,
>=20
> In the mail topic we have PATCH 1/1 but I think that it should be PATCH
> v3 1/1.
>=20

Yeah, sent it without checking that. Fixing in V4, no issues.

<big cut>

> > @@ -107,10 +106,7 @@ static int of_thermal_get_temp(struct
> > thermal_zone_device *tz, {
> >  	struct __thermal_zone *data =3D tz->devdata;
> > =20
> > -	if (!data->get_temp)
> > -		return -EINVAL;
>=20
> To be consistent, I think that we should keep the above check [1].=20
>=20
> 	if (!data->ops->get_temp)
> 		return -EINVAL;
>=20
> The same check is done with get_trend callback.
>=20

OK. I agree, and disagree, :-). Now that you mention here, I will resend
with your request applied. The reasoning is to, yes, keep the
consistency. However, not to be the same as .get_trend, but in fact, to
keep same behavior as the code as it is currently. The thing is
=2Eget_temp is required field, while .get_trend is not. So, checking for
required fields in the registration makes more sense than checking it
only when the field is needed.

However, as I mentioned, to keep the same behavior, before and after the
patch, it makes sense we keep the checks as they are. I will send v4
with this amendment.


> > -
> > -	return data->get_temp(data->sensor_data, temp);
> > +	return data->ops->get_temp(data->sensor_data, temp);
> >  }
> > =20
> >  static int of_thermal_get_trend(struct thermal_zone_device *tz, int
> > trip, @@ -120,10 +116,10 @@ static int of_thermal_get_trend(struct
> > thermal_zone_device *tz, int trip, long dev_trend;
> >  	int r;
> > =20
> > -	if (!data->get_trend)
> > +	if (!data->ops->get_trend)
> >  		return -EINVAL;
> > =20
> > -	r =3D data->get_trend(data->sensor_data, &dev_trend);
> > +	r =3D data->ops->get_trend(data->sensor_data, &dev_trend);
> >  	if (r)
> >  		return r;
> > =20
> > @@ -324,8 +320,7 @@ static struct thermal_zone_device_ops
> > of_thermal_ops =3D { static struct thermal_zone_device *
> >  thermal_zone_of_add_sensor(struct device_node *zone,
> >  			   struct device_node *sensor, void *data,
> > -			   int (*get_temp)(void *, long *),
> > -			   int (*get_trend)(void *, long *))
> > +			   const struct thermal_zone_of_device_ops
> > *ops) {
> >  	struct thermal_zone_device *tzd;
> >  	struct __thermal_zone *tz;
> > @@ -336,9 +331,11 @@ thermal_zone_of_add_sensor(struct device_node
> > *zone,=20
> >  	tz =3D tzd->devdata;
> > =20
> > +	if (!(ops && ops->get_temp))
> > +		return ERR_PTR(-EINVAL);
>=20
> IMHO, here we should only check:
> 	if (!ops)
> 		return ERR_PTR(-EINVAL);
>=20
> 	And check if specific callbacks are available in other
> 	functions (like [1])
>=20


OK. For the sake of this change only, I agree. However, I might be
sending patches on top of this one to keep the checks of required fields in=
 the
registration itself.


Cheers,
> >  }
>=20
> Despite this minor comments, feel free to add :-)
>=20
> Reviewed-by: Lukasz Majewski <l.majewski@samsung.com>

OK. Thanks.

>=20
> --=20
> Best regards,
>=20
> Lukasz Majewski
>=20
> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group


Eduardo Valentin

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUa0CMAAoJEMLUO4d9pOJWdEgH/jM2BxYeN9sJi6SgxDrnfpsf
XvPh75erC/6x9B5vCNN/RM0jQm+oucjdPAljDq+jeBqXxXV/jQH1mFXt4Eyg6rjQ
GwbzvdVXQVjVbrGPQAzd2dtOFrh49pOyO3GnHO8gXftWnYbD3XSDugj9K+EVw/RD
+Agq3sTIGaX6AHbf7uNb9vJk0osI557JPoQpP/GB+qFeeFLeB/eVrZPTWfZxaPj5
iO5Y3UydcBijEnCTX/sR9MbWKoaDg/IZlwn4TkD6xVfcMoc187xtox9BUY53P2eo
8wz+DXU64zJ6E7aYfhbzBjovOCzE9Qfc6M+9cTXDi0cwnS5AB3fxY8ebwBamWwg=
=SARx
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
