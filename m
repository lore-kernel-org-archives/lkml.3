Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbbAEVEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:04:20 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:41387 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbbAEVES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:04:18 -0500
Date: Mon, 5 Jan 2015 17:04:09 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v6 5/9] thermal: extend the cooling device API to
 include power information
Message-ID: <20150105210403.GC31247@developer>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
 <1417806260-9264-6-git-send-email-javi.merino@arm.com>
 <20141223151359.GB7350@developer>
 <20150105153710.GA3042@e104805>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FsscpQKzF/jJk6ya"
Content-Disposition: inline
In-Reply-To: <20150105153710.GA3042@e104805>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FsscpQKzF/jJk6ya
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Javi,

On Mon, Jan 05, 2015 at 03:37:10PM +0000, Javi Merino wrote:
> On Tue, Dec 23, 2014 at 03:14:11PM +0000, Eduardo Valentin wrote:
> > Hi Javi
> >=20
> > On Fri, Dec 05, 2014 at 07:04:16PM +0000, Javi Merino wrote:
> > > Add three optional callbacks to the cooling device interface to allow
> > > them to express power.  In addition to the callbacks, add helpers to
> > > identify cooling devices that implement the power cooling device API.
> > >=20
> > > Cc: Zhang Rui <rui.zhang@intel.com>
> > > Cc: Eduardo Valentin <edubezval@gmail.com>
> > > Signed-off-by: Javi Merino <javi.merino@arm.com>
> > > ---
> > >  Documentation/thermal/power_allocator.txt | 27 ++++++++++++++++++++++
> > >  drivers/thermal/thermal_core.c            | 38 +++++++++++++++++++++=
++++++++++
> > >  include/linux/thermal.h                   | 12 ++++++++++
> > >  3 files changed, 77 insertions(+)
> > >  create mode 100644 Documentation/thermal/power_allocator.txt
> > >=20
> > > diff --git a/Documentation/thermal/power_allocator.txt b/Documentatio=
n/thermal/power_allocator.txt
> > > new file mode 100644
> > > index 000000000000..d3bb79050c27
> > > --- /dev/null
> > > +++ b/Documentation/thermal/power_allocator.txt
> > > @@ -0,0 +1,27 @@
> > > +Cooling device power API
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >=20
> > Readers of this file need extra context here, IMO.
>=20
> Patch 7 adds text before and after this section that provides that
> context.
>=20
> > > +
> > > +Cooling devices controlled by this governor must supply the addition=
al
> >=20
> > What governor? the files says power allocator, and the title says,
> > cooling device power API...
>=20
> Correct, because that's added in the patch that introduces the power
> allocator governor.  Therefore, it's not a problem for the readers of
> this file but for the readers of the patches.  I can move this hunk to
> patch 7 and introduce all the documentation at once if you think
> that's clearer.
>=20

Thinking of the atomicity of each patch/commit, I would prefer you to
move all documentation to a single patch then.

> > > +"power" API in their `cooling_device_ops`.  It consists on three ops:
> > > +
> >=20
> >=20
> >=20
> > > +1. u32 get_actual_power(struct thermal_cooling_device *cdev);
> > > +@cdev: The `struct thermal_cooling_device` pointer
> > > +
> > > +`get_actual_power()` returns the power currently consumed by the
> > > +device in milliwatts.
> > > +
> > > +2. u32 state2power(struct thermal_cooling_device *cdev, unsigned long
> > > +        state);
> > > +@cdev: The `struct thermal_cooling_device` pointer
> > > +@state: A cooling device state
> > > +
> > > +Convert cooling device state @state into power consumption in
> > > +milliwatts.
> > > +
> > > +3. unsigned long power2state(struct thermal_cooling_device *cdev,
> > > +        u32 power);
> > > +@cdev: The `struct thermal_cooling_device` pointer
> > > +@power: power in milliwatts
> > > +
> > > +Calculate a cooling device state that would make the device consume =
at
> > > +most @power mW.
> >=20
> > I believe it would be more helpful if you could provide extra context in
> > which the above functions are called, and for what.
>=20
> Ok, will do.
>=20

tks.

> > > diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal=
_core.c
> > > index 9021cb72a13a..c490f262ea7f 100644
> > > --- a/drivers/thermal/thermal_core.c
> > > +++ b/drivers/thermal/thermal_core.c
> > > @@ -866,6 +866,44 @@ emul_temp_store(struct device *dev, struct devic=
e_attribute *attr,
> > >  static DEVICE_ATTR(emul_temp, S_IWUSR, NULL, emul_temp_store);
> > >  #endif/*CONFIG_THERMAL_EMULATION*/
> > > =20
> > > +/**
> > > + * power_actor_get_max_power() - get the maximum power that a cdev c=
an consume
> > > + * @cdev:	pointer to &thermal_cooling_device
> > > + *
> > > + * Calculate the maximum power consumption in milliwats that the
> > > + * cooling device can currently consume.  If @cdev doesn't support t=
he
> > > + * power_actor API, this function returns 0.
> > > + */
> > > +u32 power_actor_get_max_power(struct thermal_cooling_device *cdev)
> > > +{
> > > +	if (!cdev_is_power_actor(cdev))
> > > +		return 0;
> > > +
> > > +	return cdev->ops->state2power(cdev, 0);
> > > +}
> > > +
> > > +/**
> > > + * power_actor_set_power() - limit the maximum power that a cooling =
device can consume
> > > + * @cdev:	pointer to &thermal_cooling_device
> > > + * @power:	the power in milliwatts
> > > + *
> > > + * Set the cooling device to consume at most @power milliwatts.
> > > + *
> > > + * Returns: 0 on success, -EINVAL if the cooling device does not
> > > + * implement the power actor API or -E* for other failures.
> > > + */
> > > +int power_actor_set_power(struct thermal_cooling_device *cdev, u32 p=
ower)
> > > +{
> > > +	unsigned long state;
> > > +
> > > +	if (!cdev_is_power_actor(cdev))
> > > +		return -EINVAL;
> > > +
> > > +	state =3D cdev->ops->power2state(cdev, power);
> > > +
> > > +	return cdev->ops->set_cur_state(cdev, state);
> > > +}
> > > +
> > >  static DEVICE_ATTR(type, 0444, type_show, NULL);
> > >  static DEVICE_ATTR(temp, 0444, temp_show, NULL);
> > >  static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
> > > diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > > index 2c14ab1f5c0d..1155457caf52 100644
> > > --- a/include/linux/thermal.h
> > > +++ b/include/linux/thermal.h
> > > @@ -142,6 +142,9 @@ struct thermal_cooling_device_ops {
> > >  	int (*get_max_state) (struct thermal_cooling_device *, unsigned lon=
g *);
> > >  	int (*get_cur_state) (struct thermal_cooling_device *, unsigned lon=
g *);
> > >  	int (*set_cur_state) (struct thermal_cooling_device *, unsigned lon=
g);
> > > +	u32 (*get_actual_power) (struct thermal_cooling_device *);
> > > +	u32 (*state2power) (struct thermal_cooling_device *, unsigned long);
> > > +	unsigned long (*power2state) (struct thermal_cooling_device *, u32);
> > >  };
> > > =20
> > >  struct thermal_cooling_device {
> > > @@ -322,6 +325,15 @@ void thermal_zone_of_sensor_unregister(struct de=
vice *dev,
> > >  }
> > > =20
> > >  #endif
> > > +
> > > +static inline bool cdev_is_power_actor(struct thermal_cooling_device=
 *cdev)
> > > +{
> >=20
> > What would happen if one pass cdev =3D=3D NULL?
>=20
> Is it really worth checking it here instead of just making the caller
> pass a valid cdev?  There are a number of functions in the thermal
> framework that don't check for valid cdevs or thermal zone pointers
> and I don't see why this one is different.
>=20


I don't know, maybe we should fix those misbehaving functions then? Can
you please point them out?

> > > +	return cdev->ops->get_actual_power && cdev->ops->state2power &&
> > > +		cdev->ops->power2state;
> > > +}
> > > +
> > > +u32 power_actor_get_max_power(struct thermal_cooling_device *);
> > > +int power_actor_set_power(struct thermal_cooling_device *, u32);
> > >  struct thermal_zone_device *thermal_zone_device_register(const char =
*, int, int,
> > >  		void *, struct thermal_zone_device_ops *,
> > >  		const struct thermal_zone_params *, int, int);
> >=20
> > I am assuming the above two new functions are expected to be used also
> > outside thermal core, right? If yes, I'd suggest exporting them.=20
>=20
> I don't expect it for the time being.  Wouldn't it be preferable to
> export them when its needed instead?

I believe functions in this header are exported. For functions used
inside thermal core and code that goes builtin always, they go into
drivers/thermal/thermal_core.h, and are not exported.

>=20
> Cheers,
> Javi

--FsscpQKzF/jJk6ya
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqvw4AAoJEMLUO4d9pOJWdQoH/ih2uvOj1hlTi2ilM9lWgSD9
PEyRvTVcOCxHfK6wnazZ8lxroQOJI12LaLdhpti59V0gJ+/q0yoOTuHP5Yi2aNmH
nDuMxYGtxeJEHYRm8CIo5S8vJFoBh9CBDZX8wQzlL7wS/HhZJnlSyub9YRtlhrgx
s4YydvBTH0Rcybn80oC2oSasm5UH/5tqQZZKmJJ6VR6M+7I8ufdyvN3/f3xD+aT7
7uiISmCMM5TllDWGNVzHWwWMtAKgCkQNQihWvhbjsnPmlkyVfNZCEN8MogNaROew
psvPuNTWBQNWVpfauwH5HiqEIoezA7WDvYBGSGgrHdHoqdjYuuDGYdMcpY93GTc=
=tu2P
-----END PGP SIGNATURE-----

--FsscpQKzF/jJk6ya--
