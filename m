Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaKZPSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:18:53 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:47468 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbaKZPSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:18:49 -0500
Date: Wed, 26 Nov 2014 11:18:30 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: Re: [PATCH v2 3/4] thermal: of: Extend of-thermal to export table of
 trip points
Message-ID: <20141126151828.GC3925@developer>
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-4-git-send-email-l.majewski@samsung.com>
 <20141125203629.GA14292@developer>
 <20141126093510.4233ff7f@amdc2363>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hYooF8G/hrfVAmum"
Content-Disposition: inline
In-Reply-To: <20141126093510.4233ff7f@amdc2363>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hYooF8G/hrfVAmum
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, Nov 26, 2014 at 09:35:10AM +0100, Lukasz Majewski wrote:
> Hi Eduardo,
>=20
> > Hello Lukasz,
> >=20
> > On Thu, Nov 20, 2014 at 05:21:27PM +0100, Lukasz Majewski wrote:
> > > This patch extends the of-thermal.c to export copy of trip points
> > > for a given thermal zone.
> > >=20
> > > Thermal drivers should use of_thermal_get_trip_points() method to
> > > get pointer to table of thermal trip points.
> > >=20
> > > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > > ---
> > > Changes for v2:
> > > - New patch - as suggested by Eduardo Valentin
> > > ---
> > >  drivers/thermal/of-thermal.c   | 33
> > > +++++++++++++++++++++++++++++++++ drivers/thermal/thermal_core.h |
> > > 7 +++++++ include/linux/thermal.h        | 14 ++++++++++++++
> > >  3 files changed, 54 insertions(+)
> > >=20
> > > diff --git a/drivers/thermal/of-thermal.c
> > > b/drivers/thermal/of-thermal.c index 336af7f..33921c5 100644
> > > --- a/drivers/thermal/of-thermal.c
> > > +++ b/drivers/thermal/of-thermal.c
> > > @@ -89,6 +89,7 @@ struct __thermal_zone {
> > >  	/* trip data */
> > >  	int ntrips;
> > >  	struct __thermal_trip *trips;
> > > +	struct thermal_trip *gtrips;
> > > =20
> > >  	/* cooling binding data */
> > >  	int num_tbps;
> > > @@ -152,6 +153,27 @@ bool of_thermal_is_trip_en(struct
> > > thermal_zone_device *tz, int trip) return true;
> > >  }
> > > =20
> > > +/**
> > > + * of_thermal_get_trip_points - function to get access to a
> > > globally exported
> > > + *				trip points
> > > + *
> > > + * @tz:	pointer to a thermal zone
> > > + *
> > > + * This function provides a pointer to the copy of trip points
> > > table
> > > + *
> > > + * Return: pointer to trip points table, NULL otherwise
> > > + */
> > > +const struct thermal_trip * const
> > > +of_thermal_get_trip_points(struct thermal_zone_device *tz)
> > > +{
> > > +	struct __thermal_zone *data =3D tz->devdata;
> > > +
> > > +	if (!data)
> > > +		return NULL;
> > > +
> > > +	return data->gtrips;
> > > +}
> > > +
> >=20
> > EXPORT_SYMBOL_GPL(of_thermal_get_trip_points);
>=20
> Ok.
>=20
> >=20
> > >  static int of_thermal_get_trend(struct thermal_zone_device *tz,
> > > int trip, enum thermal_trend *trend)
> > >  {
> > > @@ -767,6 +789,16 @@ thermal_of_build_thermal_zone(struct
> > > device_node *np) goto free_tbps;
> > >  	}
> > > =20
> > > +	tz->gtrips =3D kcalloc(tz->ntrips, sizeof(*tz->gtrips),
> > > GFP_KERNEL);
> > > +	if (!tz->gtrips) {
> > > +		ret =3D -ENOMEM;
> > > +		goto free_tbps;
> > > +	}
> > > +
> > > +	for (i =3D 0; i < tz->ntrips; i++)
> > > +		memcpy(&(tz->gtrips[i]),
> > > &(tz->trips[i].temperature),
> > > +		       sizeof(*tz->gtrips));
> > > +
> > >  finish:
> > >  	of_node_put(child);
> > >  	tz->mode =3D THERMAL_DEVICE_DISABLED;
> > > @@ -793,6 +825,7 @@ static inline void of_thermal_free_zone(struct
> > > __thermal_zone *tz) {
> > >  	int i;
> > > =20
> > > +	kfree(tz->gtrips);
> > >  	for (i =3D 0; i < tz->num_tbps; i++)
> > >  		of_node_put(tz->tbps[i].cooling_device);
> > >  	kfree(tz->tbps);
> > > diff --git a/drivers/thermal/thermal_core.h
> > > b/drivers/thermal/thermal_core.h index 466208c..a9580ca 100644
> > > --- a/drivers/thermal/thermal_core.h
> > > +++ b/drivers/thermal/thermal_core.h
> > > @@ -91,6 +91,8 @@ int of_parse_thermal_zones(void);
> > >  void of_thermal_destroy_zones(void);
> > >  int of_thermal_get_ntrips(struct thermal_zone_device *);
> > >  bool of_thermal_is_trip_en(struct thermal_zone_device *, int);
> > > +const struct thermal_trip * const
> > > +of_thermal_get_trip_points(struct thermal_zone_device *);
> > >  #else
> > >  static inline int of_parse_thermal_zones(void) { return 0; }
> > >  static inline void of_thermal_destroy_zones(void) { }
> > > @@ -102,6 +104,11 @@ static inline bool
> > > of_thermal_is_trip_en(struct thermal_zone_device *, int) {
> >=20
> > This produces compilation error when CONFIG_THERMAL_OF is not set.
> > Name the parameters to fix.
>=20
> As all the other cases, I will fix that.
>=20
> >=20
> > >  	return 0;
> > >  }
> > > +static inline const struct thermal_trip * const
> > > +of_thermal_get_trip_points(struct thermal_zone_device *)
> > > +{
> > > +	return NULL;
> > > +}
> > >  #endif
> > > =20
> > >  #endif /* __THERMAL_CORE_H__ */
> > > diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > > index 5bc28a7..88d7249 100644
> > > --- a/include/linux/thermal.h
> > > +++ b/include/linux/thermal.h
> > > @@ -303,6 +303,20 @@ struct thermal_zone_of_device_ops {
> > >  	int (*get_trend)(void *, long *);
> > >  };
> > > =20
> > > +/**
> > > + * struct thermal_trip - Structure representing themal trip points
> > > exported from
> > > + *                       of-thermal
> > > + *
> >=20
> > The only problem I have with this name is that would look like it is
> > in use in all thermal framework, which is not really the case. But I
> > do think having a type here is a good thing. So, not sure :-)
>=20
> It can stay to be struct thermal_trip or we can rename it to
> struct of_thermal_trip.
>=20
> I'm fine with both names.

Leave it as 'thermal_trip'.

>=20
> >=20
> > > + * @temperature:	trip point temperature
> > > + * @hysteresis:		trip point hysteresis
> > > + * @type:		trip point type
> > > + */
> > > +struct thermal_trip {
> > > +	unsigned long int temperature;
> > > +	unsigned long int hysteresis;
> > > +	enum thermal_trip_type type;
> > > +};
> > > +
> > >  /* Function declarations */
> > >  #ifdef CONFIG_THERMAL_OF
> > >  struct thermal_zone_device *
> > > --=20
> > > 2.0.0.rc2
> > >=20
>=20
>=20
>=20
> --=20
> Best regards,
>=20
> Lukasz Majewski
>=20
> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group

--hYooF8G/hrfVAmum
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUde84AAoJEMLUO4d9pOJWSS8IAJ/rqT9KawuqdmG+PDGBpU85
4oi+SZpIALuVIe19tuTj9waPT73bVfDc8IfxZa1ytBn3RsKqoyOVIGz45u/DtsOv
l1/h79he/EAp1d/jyp1LgIV2D4Z6iwkSFPpBcAC2O3GZilTer3Mq3Xuo5u/9dWob
44RQcHrrx9ezlOuAEjqkUEP/gu/0QnpiTEhfBzU25N0c4xbmOZsviPRGNWpt18N3
fSesEAg9jsYUwqRFpibAJv1u37AtstmgV8P/m2pyiWFQHv7Auss5bE7W/YZDwTGD
jT66kmB3TCZFwwKhCDl7vjLHQIJOG9X6k7CF3EJxCGNpeaBRqXzmfqTx1OWC8yg=
=gszd
-----END PGP SIGNATURE-----

--hYooF8G/hrfVAmum--
