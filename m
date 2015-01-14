Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbbANScd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:32:33 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:49668 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbbANScb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:32:31 -0500
Date: Wed, 14 Jan 2015 14:32:13 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: Re: [PATCH v2 1/8] thermal: Provide stub for
 thermal_of_cooling_device_register() function
Message-ID: <20150114183211.GB3672@developer>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-2-git-send-email-l.majewski@samsung.com>
 <20150102185426.GC12485@developer>
 <20150102190339.GA22356@developer>
 <20150114160106.20aa160b@amdc2363>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <20150114160106.20aa160b@amdc2363>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2015 at 04:01:06PM +0100, Lukasz Majewski wrote:
> Hi Eduardo,
>=20
> > On Fri, Jan 02, 2015 at 02:54:28PM -0400, Eduardo Valentin wrote:
> > > On Mon, Dec 22, 2014 at 05:27:41PM +0100, Lukasz Majewski wrote:
> > > > Odroid U3 fan can work without being registered as OF cooling
> > > > device (with CONFIG_THERMAL_OF disabled).
> > > > In this situation it can be controlled via PWM entry at
> > > > /sys/class/hwmon/hwmon0/pwm1.
> > > >=20
> > > > Therefore, the thermal_of_cooling_device_register() function
> > > > needs a stub to allow clean compilation.
> > > >=20
> > > > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > >=20
> > > Acked-by: Eduardo Valentin <edubezval@gmail.com>
> >=20
> > Sorry, too fast,
> >=20
> > This is actually
> > Nacked-by: Eduardo Valentin <edubezval@gmail.com>
> >=20
> > :-)
> >=20
> > I get this error:
> > drivers/thermal/thermal_core.c:1210:1: error: redefinition of
> > =E2=80=98thermal_of_cooling_device_register=E2=80=99
> >  thermal_of_cooling_device_register(struct device_node *np,
> >   ^
> >   In file included from drivers/thermal/thermal_core.c:34:0:
> >   include/linux/thermal.h:321:1: note: previous definition of
> >   =E2=80=98thermal_of_cooling_device_register=E2=80=99 was here
> >    thermal_of_cooling_device_register(struct device_node *np,
> >     ^
> >=20
> >=20
> > We provide the function in thermal core even if CONFIG_THERMAL_OF is
> > not set.
>=20
> Unfortunately the PWM fan subsystem can work perfectly fine without
> CONFIG_THERMAL.
>=20

Now I understand what you are trying to do.

> I think that it would be enough to make something like this in
> the ./include/linux/thermal.h:
>=20
> #ifdef CONFIG_THERMAL
Well, I think it should be the opposite here:

#ifndef CONFIG_THERMAL

that is, if no config thermal, then you provide the stub not the other
way around.

> 	static inline struct thermal_cooling_device *
> 		thermal_of_cooling_device_register(struct device_node
> 		*np, char *type, void *devdata,
> 				   const struct
> 		thermal_cooling_device_ops *ops) {
> 		return NULL;
> 	}
> #else
> 	[ already present declaration of
> 	thermal_of_cooling_device_register() ]
> #endif /* CONFIG_THERMAL */


>=20
>=20
>=20
> > >=20
> > > > ---
> > > > Changes for v2:
> > > > - None
> > > > ---
> > > >  include/linux/thermal.h | 14 +++++++++++---
> > > >  1 file changed, 11 insertions(+), 3 deletions(-)
> > > >=20
> > > > diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > > > index 2de3d9e..871123c 100644
> > > > --- a/include/linux/thermal.h
> > > > +++ b/include/linux/thermal.h
> > > > @@ -328,6 +328,10 @@ thermal_zone_of_sensor_register(struct
> > > > device *dev, int id, void *data, const struct
> > > > thermal_zone_of_device_ops *ops); void
> > > > thermal_zone_of_sensor_unregister(struct device *dev, struct
> > > > thermal_zone_device *tz); +struct thermal_cooling_device *
> > > > +thermal_of_cooling_device_register(struct device_node *np,
> > > > +				   char *type, void *devdata,
> > > > +				   const struct
> > > > thermal_cooling_device_ops *); #else
> > > >  static inline struct thermal_zone_device *
> > > >  thermal_zone_of_sensor_register(struct device *dev, int id, void
> > > > *data, @@ -342,6 +346,13 @@ void
> > > > thermal_zone_of_sensor_unregister(struct device *dev, {
> > > >  }
> > > > =20
> > > > +static inline struct thermal_cooling_device *
> > > > +thermal_of_cooling_device_register(struct device_node *np,
> > > > +				   char *type, void *devdata,
> > > > +				   const struct
> > > > thermal_cooling_device_ops *ops) +{
> > > > +	return NULL;
> > > > +}
> > > >  #endif
> > > >  struct thermal_zone_device *thermal_zone_device_register(const
> > > > char *, int, int, void *, struct thermal_zone_device_ops *,
> > > > @@ -357,9 +368,6 @@ void thermal_zone_device_update(struct
> > > > thermal_zone_device *);=20
> > > >  struct thermal_cooling_device
> > > > *thermal_cooling_device_register(char *, void *, const struct
> > > > thermal_cooling_device_ops *); -struct thermal_cooling_device *
> > > > -thermal_of_cooling_device_register(struct device_node *np, char
> > > > *, void *,
> > > > -				   const struct
> > > > thermal_cooling_device_ops *); void
> > > > thermal_cooling_device_unregister(struct thermal_cooling_device
> > > > *); struct thermal_zone_device
> > > > *thermal_zone_get_zone_by_name(const char *name); int
> > > > thermal_zone_get_temp(struct thermal_zone_device *tz, unsigned
> > > > long *temp); -- 2.0.0.rc2
> > > >=20
> >=20
> >=20
>=20
>=20
>=20
> --=20
> Best regards,
>=20
> Lukasz Majewski
>=20
> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUtrYMAAoJEMLUO4d9pOJW/vAH+wcTwVCWNNUyLqf6XB5rf44Q
nGW1m48ZjXoHub4us1T5PBvhufYGImK/vAGEXoJOMRzKmu9rHPd58pAqTozLPFWA
AlqYuwu9u7yxkn1DCQMZtPIKXNoxxvlltbUl+uujE/Qx2/xNl9rVNWEE/MLfIPBR
VNeb9Bxyk1riq8C8SmUgBCIADX1v06WEZmBKtbwqs67RupPyctIO9MbEOQ4bUC87
QBIC4WozI/FcmLRPW6viWvX8Gxi0v+g9v4CHkYJwwcFXV9VKXN0HPg4AFQgHSpz7
P52ne5UG1QRef+Jv/xTlhSNESQTM+njwuHeYpQyE4hNayx3c0P6yObbeOBHABtY=
=kIs0
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
