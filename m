Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaKZXwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:52:07 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:48711 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaKZXwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:52:04 -0500
Date: Wed, 26 Nov 2014 19:09:24 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: navneet kumar <navneetk@nvidia.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
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
Message-ID: <20141126230922.GA2612@developer>
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-4-git-send-email-l.majewski@samsung.com>
 <20141125203629.GA14292@developer>
 <20141126093510.4233ff7f@amdc2363>
 <20141126151828.GC3925@developer>
 <54763B66.90208@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <54763B66.90208@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello Navneet,

On Wed, Nov 26, 2014 at 12:43:18PM -0800, navneet kumar wrote:
>=20
> Hi Eduardo, Lukasz,
>=20
> [Combining my concerns as a single text blob here]
>=20
> I. Firstly, with the current patch
> 	1. is it really needed to duplicate the struct thermal_trip? Why don=E2=
=80=99t
> 	we get rid of the __thermal_trip and stay with the 'thermal_trip' ? it
> 	is not a big change.
>=20
> 	2. gtrips is not updated on "set_trip_temp" etc. actions via sysfs. (am
> 	I missing something?).
>=20

Good! Comments are always welcome, that's how we make patches :-).

Both above make sense to me.

> II. The other concern is more of a design question
> 	1. Do we intend to keep the of-thermal as a middle layer between the
> 	thermal_core and the sensor device? OR, is the role of of-thermal just
> 	to parse the DT and opt out ? currently of-thermal is somewhat a hybrid
> 	of these as, in addition to parsing the dt, it holds on to the data
> 	related to trip points etc. etc.
>=20

of-thermal has always been as your latter statement, and I intend to keep i=
t as it should
be, just a of parser for thermal data.

> 	2. assuming latter is true (OF is just a dt parser helper): we should
> 	not be adding more intelligence and dependencies linked to the OF.
>=20

Yes this is right. We should never be adding intelligence to it, except
for parsing the thermal data out of device tree and adding the proper
structures inside the kernel.

> 	3. assuming former is true (OF is a well-defined middle layer): All is
> 	good till the point OF maintains the trip points (which is a good thing
> 	since, OF caches on to the data); BUT, if we expose this information to
> 	the sensor device too (as this patch is doing),
>=20

the former is not true.

> 		3a. we violate the layering principle :-)
>=20

well, even if it was, I disagree here. :-) The split between data
coming from DT and the driver is still in place. Besides, there is other
layers that expose some of their data, and that doesn't violate their
layering principles. CPUfreq, for one closer example, exposes its freq tabl=
e.

It would be different if by exposing this data, the users would be
affecting the behavior of the layer. And that is not the intention of
cpufreq table. In the same way, that is not the intention of this patch.

> 		3b. more importantly, this is all just excessive logic that we
> 		put in which *could be useful* only if we intend to extend the
> 		role of OF as a trip point management layer that does more than
> 		just holding on to the data. This may include -
>=20
> 			-> The sensor devices to know nothing about the
> 			trip_points, instead the sensor devices would work on
> 			"temperature thresholds" and OF would map sensor
> 			thresholds to the actual trip points as needed
> 			(configured from DT); while the sensor devices stick to
> 			using "thresholds".
>=20
> 			-> Queuing from above, sensors, most of the time, only
> 			need to know a high and a low temp threshold; which
> 			essentially is a subset of the active/passive etc. trip
> 			points. Calculation of that based on the current temp,
> 			as of today is replicated across all the sensor drivers
> 			and can be hoisted up to the of-thermal.
>=20

There is no intention to add such logic to of thermal. The main reason
is of-thermal should never be competing with thermal core. Any extension
in of-thermal needs to be supported by thermal core.

I believe all the above is left currently to thermal zone device
drivers. The problem with of-thermal is that it had to be born as a
thermal zone device driver. And that is because..

> Seems like this is the opportune time to make a call about the role of of=
-thermal?
>=20

=2E. the point one may be missing here is the fact that with current
thermal subsystem implementation, handling thermal devices is somewhat
different from other devices within the kernel.

The real design issue (or not an issue) we have is the fact that thermal
drivers adds both the driver and the device. Changing that is somewhat
disruptive. Not impossible, but requires considering the existing driver's =
code.

If we had a better split from who adds the device and who provides the
driver, then of-thermal would never be a "glue layer" or born as thermal
zone device driver. It would simply, parse DT, add the devices, done.

Then, drivers would register themselves as handlers for specific thermal
devices. That is the correct design, based on common design found in other
parts of the kernel. Another little missing end would be the "compatible"
string for thermal zone devices in DT. But as I said, it should not be a
blocker.

So, given the current situation, we have essentially two options: (a)
stick to the same design we have for now, having of-thermal as dummy as
possible, and grow in small steps towards the correct design; or (b)
redesign thermal core to have a better split between devices and
drivers, then adjust of-thermal.


For now, the path we are taking is (a). In fact, to fit the needs of
coming drivers, specially considering they are based on DT booting
platforms, it is always tempting to add intelligence to of-thermal. But,
as I mentioned, I want to avoid growing intelligence in it, for obvious
reasons.

> On 11/26/2014 07:18 AM, Eduardo Valentin wrote:
> > * PGP Signed by an unknown key
> >=20
> > Hello,
> >=20
> > On Wed, Nov 26, 2014 at 09:35:10AM +0100, Lukasz Majewski wrote:
> >> Hi Eduardo,
> >>
> >>> Hello Lukasz,
> >>>
> >>> On Thu, Nov 20, 2014 at 05:21:27PM +0100, Lukasz Majewski wrote:
> >>>> This patch extends the of-thermal.c to export copy of trip points
> >>>> for a given thermal zone.
> >>>>
> >>>> Thermal drivers should use of_thermal_get_trip_points() method to
> >>>> get pointer to table of thermal trip points.
> >>>>
> >>>> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> >>>> ---
> >>>> Changes for v2:
> >>>> - New patch - as suggested by Eduardo Valentin
> >>>> ---
> >>>>  drivers/thermal/of-thermal.c   | 33
> >>>> +++++++++++++++++++++++++++++++++ drivers/thermal/thermal_core.h |
> >>>> 7 +++++++ include/linux/thermal.h        | 14 ++++++++++++++
> >>>>  3 files changed, 54 insertions(+)
> >>>>
> >>>> diff --git a/drivers/thermal/of-thermal.c
> >>>> b/drivers/thermal/of-thermal.c index 336af7f..33921c5 100644
> >>>> --- a/drivers/thermal/of-thermal.c
> >>>> +++ b/drivers/thermal/of-thermal.c
> >>>> @@ -89,6 +89,7 @@ struct __thermal_zone {
> >>>>  	/* trip data */
> >>>>  	int ntrips;
> >>>>  	struct __thermal_trip *trips;
> >>>> +	struct thermal_trip *gtrips;
> Do we really need this duplication ?
> >>>> =20
> >>>>  	/* cooling binding data */
> >>>>  	int num_tbps;
> >>>> @@ -152,6 +153,27 @@ bool of_thermal_is_trip_en(struct
> >>>> thermal_zone_device *tz, int trip) return true;
> >>>>  }
> >>>> =20
> >>>> +/**
> >>>> + * of_thermal_get_trip_points - function to get access to a
> >>>> globally exported
> >>>> + *				trip points
> >>>> + *
> >>>> + * @tz:	pointer to a thermal zone
> >>>> + *
> >>>> + * This function provides a pointer to the copy of trip points
> >>>> table
> >>>> + *
> >>>> + * Return: pointer to trip points table, NULL otherwise
> >>>> + */
> >>>> +const struct thermal_trip * const
> >>>> +of_thermal_get_trip_points(struct thermal_zone_device *tz)
> >>>> +{
> >>>> +	struct __thermal_zone *data =3D tz->devdata;
> >>>> +
> >>>> +	if (!data)
> >>>> +		return NULL;
> >>>> +
> >>>> +	return data->gtrips;
> >>>> +}
> >>>> +
> >>>
> >>> EXPORT_SYMBOL_GPL(of_thermal_get_trip_points);
> >>
> >> Ok.
> >>
> >>>
> >>>>  static int of_thermal_get_trend(struct thermal_zone_device *tz,
> >>>> int trip, enum thermal_trend *trend)
> >>>>  {
> >>>> @@ -767,6 +789,16 @@ thermal_of_build_thermal_zone(struct
> >>>> device_node *np) goto free_tbps;
> >>>>  	}
> >>>> =20
> >>>> +	tz->gtrips =3D kcalloc(tz->ntrips, sizeof(*tz->gtrips),
> >>>> GFP_KERNEL);
> >>>> +	if (!tz->gtrips) {
> >>>> +		ret =3D -ENOMEM;
> >>>> +		goto free_tbps;
> >>>> +	}
> >>>> +
> >>>> +	for (i =3D 0; i < tz->ntrips; i++)
> >>>> +		memcpy(&(tz->gtrips[i]),
> >>>> &(tz->trips[i].temperature),
> >>>> +		       sizeof(*tz->gtrips));
> >>>> +
> >>>>  finish:
> >>>>  	of_node_put(child);
> >>>>  	tz->mode =3D THERMAL_DEVICE_DISABLED;
> >>>> @@ -793,6 +825,7 @@ static inline void of_thermal_free_zone(struct
> >>>> __thermal_zone *tz) {
> >>>>  	int i;
> >>>> =20
> >>>> +	kfree(tz->gtrips);
> >>>>  	for (i =3D 0; i < tz->num_tbps; i++)
> >>>>  		of_node_put(tz->tbps[i].cooling_device);
> >>>>  	kfree(tz->tbps);
> Couldn't find the code that updates *gtrips as a result of set_trip_temp =
via
> sysfs.
>=20
> >>>> diff --git a/drivers/thermal/thermal_core.h
> >>>> b/drivers/thermal/thermal_core.h index 466208c..a9580ca 100644
> >>>> --- a/drivers/thermal/thermal_core.h
> >>>> +++ b/drivers/thermal/thermal_core.h
> >>>> @@ -91,6 +91,8 @@ int of_parse_thermal_zones(void);
> >>>>  void of_thermal_destroy_zones(void);
> >>>>  int of_thermal_get_ntrips(struct thermal_zone_device *);
> >>>>  bool of_thermal_is_trip_en(struct thermal_zone_device *, int);
> >>>> +const struct thermal_trip * const
> >>>> +of_thermal_get_trip_points(struct thermal_zone_device *);
> >>>>  #else
> >>>>  static inline int of_parse_thermal_zones(void) { return 0; }
> >>>>  static inline void of_thermal_destroy_zones(void) { }
> >>>> @@ -102,6 +104,11 @@ static inline bool
> >>>> of_thermal_is_trip_en(struct thermal_zone_device *, int) {
> >>>
> >>> This produces compilation error when CONFIG_THERMAL_OF is not set.
> >>> Name the parameters to fix.
> >>
> >> As all the other cases, I will fix that.
> >>
> >>>
> >>>>  	return 0;
> >>>>  }
> >>>> +static inline const struct thermal_trip * const
> >>>> +of_thermal_get_trip_points(struct thermal_zone_device *)
> >>>> +{
> >>>> +	return NULL;
> >>>> +}
> >>>>  #endif
> >>>> =20
> >>>>  #endif /* __THERMAL_CORE_H__ */
> >>>> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> >>>> index 5bc28a7..88d7249 100644
> >>>> --- a/include/linux/thermal.h
> >>>> +++ b/include/linux/thermal.h
> >>>> @@ -303,6 +303,20 @@ struct thermal_zone_of_device_ops {
> >>>>  	int (*get_trend)(void *, long *);
> >>>>  };
> >>>> =20
> >>>> +/**
> >>>> + * struct thermal_trip - Structure representing themal trip points
> >>>> exported from
> >>>> + *                       of-thermal
> >>>> + *
> >>>
> >>> The only problem I have with this name is that would look like it is
> >>> in use in all thermal framework, which is not really the case. But I
> >>> do think having a type here is a good thing. So, not sure :-)
> >>
> >> It can stay to be struct thermal_trip or we can rename it to
> >> struct of_thermal_trip.
> >>
> >> I'm fine with both names.
> >=20
> > Leave it as 'thermal_trip'.
> >=20
> >>
> >>>
> >>>> + * @temperature:	trip point temperature
> >>>> + * @hysteresis:		trip point hysteresis
> >>>> + * @type:		trip point type
> >>>> + */
> >>>> +struct thermal_trip {
> >>>> +	unsigned long int temperature;
> >>>> +	unsigned long int hysteresis;
> >>>> +	enum thermal_trip_type type;
> >>>> +};
> >>>> +
> >>>>  /* Function declarations */
> >>>>  #ifdef CONFIG_THERMAL_OF
> >>>>  struct thermal_zone_device *
> >>>> --=20
> >>>> 2.0.0.rc2
> >>>>
> >>
> >>
> >>
> >> --=20
> >> Best regards,
> >>
> >> Lukasz Majewski
> >>
> >> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
> >=20
> > * Unknown Key
> > * 0x7DA4E256
> >=20

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdl2CAAoJEMLUO4d9pOJWsX4H/3UuQpIVOQ8+5D/kpQoPyDhu
GAOU64jPCgkDkfohyFkKIA4L5iXqfwAqxwirjxZ6ZlB5ZR8whGHHadmXBwCA4hp8
I2LmkHJRtNXE2/KfW++VALuxz3WcQVgDFRWH747f7Kg+nlfFmEFVCJXh9aJCYr1o
t0flOgvleng5cwr2/sVF/V6G6M/o1PfHboX4vsT9NPTqhWHs2r5MCo/mr4+gjqAb
5mIEK5MarN3dxGOsP6RCVLRZQAzfHWgXmbm+dlBWR0MDKhXJdjAmoSiL6kZEp9e+
4ZS5DMJPIT+VrdZsm7+O3g+NIFuClHCkRV8fcG4c9FVVj6dW4nqdC1HT/DauEuk=
=YKCp
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
