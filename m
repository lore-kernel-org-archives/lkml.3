Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaKUSIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:08:43 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:48667 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaKUSIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:08:41 -0500
Date: Fri, 21 Nov 2014 14:08:28 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] thermal:core:fix: Check return code of the
 ->get_max_state() callback
Message-ID: <20141121180826.GA3331@developer>
References: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <1416305790-27746-1-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <1416305790-27746-1-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Lukasz,

On Tue, Nov 18, 2014 at 11:16:30AM +0100, Lukasz Majewski wrote:
> The return code from ->get_max_state() callback was not checked during
> binding cooling device to thermal zone device.
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> ---
> Changes for v2:
> - It turned out that patches from 1 to 6 from v1 are not needed, since
>   they either already solve the problem (like imx_thermal.c) or not use
>   cpufreq as a thermal cooling device.
> - The patch 7 from v1 is also not needed since this patch on error exits
>   this function without using max_state variable.
> - In thermal driver probe the cpufreq_cooling_register() method presence
>   is crucial to evaluate if the thermal driver needs any actions with=20
>   -EPROBE_DEFER.

Have you tried this patch with of-thermal based systems?

The above proposal works if the thermal driver is dealing with loading
cpu_cooling. But for of-thermal based drivers, the idea is to leave to
cpufreq code to load it.=20

As an example, I am taking the ti-soc-thermal, but we already have other
of-thermal based drivers. Booting with this patch ti-soc-thermal
(of-based boot) loads fine, but the cpu_cooling never gets bound to the
thermal zone.

The thing is that the bind may happen before cpufreq-dt code loads the
cpufreq driver, and when cpu_cooling is checking what is the max freq,
by using cpufreq table, it won't be able to do it, as there is no table.

While, without the patch, it will use wrong in the binding, but after
it gets bound, and cpufreq loads, the max will be used correctly.

And in this case, the system still works besides this bug. The reasoning
is because the max state comes from DT (2) and lower and upper wont be
equal to THERMAL_NO_LIMIT. Then, the following check will use the
parameter, instead of max_state:

        cdev->ops->get_max_state(cdev, &max_state);

	/* lower default 0, upper default max_state */
	lower =3D lower =3D=3D THERMAL_NO_LIMIT ? 0 : lower;
	upper =3D upper =3D=3D THERMAL_NO_LIMIT ?
				max_state : upper;

In summary, introducing this patch, although it fix a problem, will
introduce regressions, in of-thermal based drivers.

I believe, to have this fix, you need to provide a way to have probing
deferring also in cpu_cooling. That needs also the change in the cpufreq
driver, as I mentioned in the other thread.

Cheers,

> ---
>  drivers/thermal/thermal_core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_cor=
e.c
> index 43b9070..8567929 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -928,7 +928,7 @@ int thermal_zone_bind_cooling_device(struct thermal_z=
one_device *tz,
>  	struct thermal_zone_device *pos1;
>  	struct thermal_cooling_device *pos2;
>  	unsigned long max_state;
> -	int result;
> +	int result, ret;
> =20
>  	if (trip >=3D tz->trips || (trip < 0 && trip !=3D THERMAL_TRIPS_NONE))
>  		return -EINVAL;
> @@ -945,7 +945,9 @@ int thermal_zone_bind_cooling_device(struct thermal_z=
one_device *tz,
>  	if (tz !=3D pos1 || cdev !=3D pos2)
>  		return -EINVAL;
> =20
> -	cdev->ops->get_max_state(cdev, &max_state);
> +	ret =3D cdev->ops->get_max_state(cdev, &max_state);
> +	if (ret)
> +		return ret;
> =20
>  	/* lower default 0, upper default max_state */
>  	lower =3D lower =3D=3D THERMAL_NO_LIMIT ? 0 : lower;
> --=20
> 2.0.0.rc2
>=20

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUb3+RAAoJEMLUO4d9pOJWltoH/3EpKRfWaTs1Ygt4XnRLDAiJ
1kt/tiOHZcNx5A9E/QIMmR4MGZ4KZ93UbLiWjIe2vU/63xpJjSFkd7Gr9u6bfrl8
BJCvt85Tsk9cflmAZzZsLJPDgRB8vJNx6usSj8HQ/R8ggZTK8Ef8lU7nHvy0krSK
iub1UHAjMkaFvo38mPSnsdDOj6ToxIvv04wl8RVG9BZzUSEzjy+aQSknwc6sHMkI
6G6yowKQ7N0c0xeWW7uSpA55sK2eB1bjqnWV1Vi3f0InRvYS5gihAZN46B3bqznf
jATFi200E690ELIUROqffNQevOaqaLde7DQUsAM1IyzFGbYAqI5eSYdrkXj1E0g=
=11im
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
