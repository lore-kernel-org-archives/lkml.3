Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbaLWPN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:13:57 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:50505 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaLWPNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:13:55 -0500
Date: Tue, 23 Dec 2014 11:14:11 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        punit.agrawal@arm.com, broonie@kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [RFC PATCH v6 5/9] thermal: extend the cooling device API to
 include power information
Message-ID: <20141223151359.GB7350@developer>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
 <1417806260-9264-6-git-send-email-javi.merino@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <1417806260-9264-6-git-send-email-javi.merino@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Javi

On Fri, Dec 05, 2014 at 07:04:16PM +0000, Javi Merino wrote:
> Add three optional callbacks to the cooling device interface to allow
> them to express power.  In addition to the callbacks, add helpers to
> identify cooling devices that implement the power cooling device API.
>=20
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Signed-off-by: Javi Merino <javi.merino@arm.com>
> ---
>  Documentation/thermal/power_allocator.txt | 27 ++++++++++++++++++++++
>  drivers/thermal/thermal_core.c            | 38 +++++++++++++++++++++++++=
++++++
>  include/linux/thermal.h                   | 12 ++++++++++
>  3 files changed, 77 insertions(+)
>  create mode 100644 Documentation/thermal/power_allocator.txt
>=20
> diff --git a/Documentation/thermal/power_allocator.txt b/Documentation/th=
ermal/power_allocator.txt
> new file mode 100644
> index 000000000000..d3bb79050c27
> --- /dev/null
> +++ b/Documentation/thermal/power_allocator.txt
> @@ -0,0 +1,27 @@
> +Cooling device power API
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Readers of this file need extra context here, IMO.

> +
> +Cooling devices controlled by this governor must supply the additional

What governor? the files says power allocator, and the title says,
cooling device power API...

> +"power" API in their `cooling_device_ops`.  It consists on three ops:
> +



> +1. u32 get_actual_power(struct thermal_cooling_device *cdev);
> +@cdev: The `struct thermal_cooling_device` pointer
> +
> +`get_actual_power()` returns the power currently consumed by the
> +device in milliwatts.
> +
> +2. u32 state2power(struct thermal_cooling_device *cdev, unsigned long
> +        state);
> +@cdev: The `struct thermal_cooling_device` pointer
> +@state: A cooling device state
> +
> +Convert cooling device state @state into power consumption in
> +milliwatts.
> +
> +3. unsigned long power2state(struct thermal_cooling_device *cdev,
> +        u32 power);
> +@cdev: The `struct thermal_cooling_device` pointer
> +@power: power in milliwatts
> +
> +Calculate a cooling device state that would make the device consume at
> +most @power mW.

I believe it would be more helpful if you could provide extra context in
which the above functions are called, and for what.

> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_cor=
e.c
> index 9021cb72a13a..c490f262ea7f 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -866,6 +866,44 @@ emul_temp_store(struct device *dev, struct device_at=
tribute *attr,
>  static DEVICE_ATTR(emul_temp, S_IWUSR, NULL, emul_temp_store);
>  #endif/*CONFIG_THERMAL_EMULATION*/
> =20
> +/**
> + * power_actor_get_max_power() - get the maximum power that a cdev can c=
onsume
> + * @cdev:	pointer to &thermal_cooling_device
> + *
> + * Calculate the maximum power consumption in milliwats that the
> + * cooling device can currently consume.  If @cdev doesn't support the
> + * power_actor API, this function returns 0.
> + */
> +u32 power_actor_get_max_power(struct thermal_cooling_device *cdev)
> +{
> +	if (!cdev_is_power_actor(cdev))
> +		return 0;
> +
> +	return cdev->ops->state2power(cdev, 0);
> +}
> +
> +/**
> + * power_actor_set_power() - limit the maximum power that a cooling devi=
ce can consume
> + * @cdev:	pointer to &thermal_cooling_device
> + * @power:	the power in milliwatts
> + *
> + * Set the cooling device to consume at most @power milliwatts.
> + *
> + * Returns: 0 on success, -EINVAL if the cooling device does not
> + * implement the power actor API or -E* for other failures.
> + */
> +int power_actor_set_power(struct thermal_cooling_device *cdev, u32 power)
> +{
> +	unsigned long state;
> +
> +	if (!cdev_is_power_actor(cdev))
> +		return -EINVAL;
> +
> +	state =3D cdev->ops->power2state(cdev, power);
> +
> +	return cdev->ops->set_cur_state(cdev, state);
> +}
> +
>  static DEVICE_ATTR(type, 0444, type_show, NULL);
>  static DEVICE_ATTR(temp, 0444, temp_show, NULL);
>  static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 2c14ab1f5c0d..1155457caf52 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -142,6 +142,9 @@ struct thermal_cooling_device_ops {
>  	int (*get_max_state) (struct thermal_cooling_device *, unsigned long *);
>  	int (*get_cur_state) (struct thermal_cooling_device *, unsigned long *);
>  	int (*set_cur_state) (struct thermal_cooling_device *, unsigned long);
> +	u32 (*get_actual_power) (struct thermal_cooling_device *);
> +	u32 (*state2power) (struct thermal_cooling_device *, unsigned long);
> +	unsigned long (*power2state) (struct thermal_cooling_device *, u32);
>  };
> =20
>  struct thermal_cooling_device {
> @@ -322,6 +325,15 @@ void thermal_zone_of_sensor_unregister(struct device=
 *dev,
>  }
> =20
>  #endif
> +
> +static inline bool cdev_is_power_actor(struct thermal_cooling_device *cd=
ev)
> +{

What would happen if one pass cdev =3D=3D NULL?

> +	return cdev->ops->get_actual_power && cdev->ops->state2power &&
> +		cdev->ops->power2state;
> +}
> +
> +u32 power_actor_get_max_power(struct thermal_cooling_device *);
> +int power_actor_set_power(struct thermal_cooling_device *, u32);
>  struct thermal_zone_device *thermal_zone_device_register(const char *, i=
nt, int,
>  		void *, struct thermal_zone_device_ops *,
>  		const struct thermal_zone_params *, int, int);

I am assuming the above two new functions are expected to be used also
outside thermal core, right? If yes, I'd suggest exporting them.=20

> --=20
> 1.9.1
>=20
>=20

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmYauAAoJEMLUO4d9pOJWVIcH/0MXgWuEHK9ih46A4b+N8NL6
R/XjBxttV5xWyGlC1iX+4gry0UQt5RS2SKQ9M4A4HE5SJShtgm0Q8NeZ0yCUMJoZ
ydvxTJ3Ka14nHb8C6SZlRtFkkzquSt1Mkd6N0vCLfoMYY74dJzE+lyIrEmSlcd+Q
ClGK0ubDmc/1Vna7D4tVAg2RWBoq/JUgSrg9zogPnsZEeleL3e/mV6SsziINHJpc
pd7WMnealPuR6nbrWLF57/qW/ZJtt3WlY17FVJU3p4u0wyP/b/k0oIqtHkSX1LWe
m6NtFWGKyYysXFRa2/Dxth2ogN0APP633RHDVs8AT+01Qc+mTAjPBboAiWl12kA=
=YDLZ
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
