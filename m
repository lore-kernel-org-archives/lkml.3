Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab3IBOJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 10:09:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43032 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587Ab3IBOJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 10:09:44 -0400
Message-ID: <52249C07.60806@ti.com>
Date: Mon, 2 Sep 2013 10:09:11 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <rui.zhang@intel.com>, <rjw@sisk.pl>, <wni@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCHv2 3/5] drivers: thermal: make usage of CONFIG_THERMAL_HWMON
 optional
References: <1377648836.2335.252.camel@rzhang-lenovo> <1377807167-12206-1-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1377807167-12206-1-git-send-email-eduardo.valentin@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="0mIav62nf4FJ8O5QmP66SWVpUHboEg6uX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0mIav62nf4FJ8O5QmP66SWVpUHboEg6uX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 29-08-2013 16:12, Eduardo Valentin wrote:
> When registering a new thermal_device, the thermal framework
> will always add a hwmon sysfs interface.
>=20
> This patch adds a flag to make this behavior optional. Now
> when registering a new thermal device, the caller can
> optionally inform if hwmon interface is desirable. This can
> be done by means of passing a thermal_zone_params.no_hwmon =3D=3D true.=

>=20
> In order to keep same behavior as of today, all current
> calls will by default create the hwmon interface.
>=20
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: Zhang Rui <rui.zhang@intel.com>
> Suggested-by: Wei Ni <wni@nvidia.com>
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  Documentation/thermal/sysfs-api.txt | 5 +++++
>  drivers/thermal/thermal_core.c      | 8 +++++---
>  include/linux/thermal.h             | 8 ++++++++
>  3 files changed, 18 insertions(+), 3 deletions(-)
> ---
>=20
> Hello all,
>=20
> So, here is then a different way of implementing same feature.
> As requested by Rui, now the flag goes via thermal_zone_params,
> because this seams to be the preferred way, at least in near future.
>=20
> Using this method the amount of subsystems involved is reduced to 1:
> thermal, as requested by Raphael. I just made is a negative flag
> in order to keep the same behavior of the existing drivers, without
> changing them. The flag is documented though.
>=20

Objections on this way of adding this flag?

Rui,

If you are OK, I can add this series to my tree too.


> All best,
>=20
>=20
> diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/therma=
l/sysfs-api.txt
> index a71bd5b..37c5486 100644
> --- a/Documentation/thermal/sysfs-api.txt
> +++ b/Documentation/thermal/sysfs-api.txt
> @@ -142,6 +142,11 @@ temperature) and throttle appropriate devices.
>      This is an optional feature where some platforms can choose not to=

>      provide this data.
>      .governor_name: Name of the thermal governor used for this zone
> +    .no_hwmon: a boolean to indicate if the thermal to hwmon sysfs int=
erface
> +               is required. when no_hwmon =3D=3D false, a hwmon sysfs =
interface
> +               will be created. when no_hwmon =3D=3D true, nothing wil=
l be done.
> +               In case the thermal_zone_params is NULL, the hwmon inte=
rface
> +               will be created (for backward compatibility).
>      .num_tbps: Number of thermal_bind_params entries for this zone
>      .tbp: thermal_bind_params entries
> =20
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_c=
ore.c
> index 247528b..51648bf 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1462,9 +1462,11 @@ struct thermal_zone_device *thermal_zone_device_=
register(const char *type,
> =20
>  	mutex_unlock(&thermal_governor_lock);
> =20
> -	result =3D thermal_add_hwmon_sysfs(tz);
> -	if (result)
> -		goto unregister;
> +	if (!tz->tzp || !tz->tzp->no_hwmon) {
> +		result =3D thermal_add_hwmon_sysfs(tz);
> +		if (result)
> +			goto unregister;
> +	}
> =20
>  	mutex_lock(&thermal_list_lock);
>  	list_add_tail(&tz->node, &thermal_tz_list);
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index a386a1c..b4a975f 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -214,6 +214,14 @@ struct thermal_bind_params {
>  /* Structure to define Thermal Zone parameters */
>  struct thermal_zone_params {
>  	char governor_name[THERMAL_NAME_LENGTH];
> +
> +	/*
> +	 * a boolean to indicate if the thermal to hwmon sysfs interface
> +	 * is required. when no_hwmon =3D=3D false, a hwmon sysfs interface
> +	 * will be created. when no_hwmon =3D=3D true, nothing will be done
> +	 */
> +	bool no_hwmon;
> +
>  	int num_tbps;	/* Number of tbp entries */
>  	struct thermal_bind_params *tbp;
>  };
>=20




--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--0mIav62nf4FJ8O5QmP66SWVpUHboEg6uX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlIknAcACgkQCXcVR3XQvP3vzwD/fiYJ3cVogc+jjYLNqQlZwDdH
Hd5DjJM8r/UidZ8iZzAA/R+xQhW0Ct+5NwMI5fgu1BJ/GCh9W/AhX22TM0aSarno
=U70H
-----END PGP SIGNATURE-----

--0mIav62nf4FJ8O5QmP66SWVpUHboEg6uX--
