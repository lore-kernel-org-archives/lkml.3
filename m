Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3JCVlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:41:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42347 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3JCVlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:41:09 -0400
Message-ID: <524DE45E.1060606@ti.com>
Date: Thu, 3 Oct 2013 17:40:46 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lukasz Majewski <l.majewski@samsung.com>
CC: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, <devicetree@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 1/6] thermal: exynos: fix: Return from exynos_report_trigger()
 when therm_dev is NULL
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com> <1380010102-25817-2-git-send-email-l.majewski@samsung.com>
In-Reply-To: <1380010102-25817-2-git-send-email-l.majewski@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="xQwfTjb0Weq0xtwVOQvLOpvN5PIEdLvVc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xQwfTjb0Weq0xtwVOQvLOpvN5PIEdLvVc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 24-09-2013 04:08, Lukasz Majewski wrote:
> The commit 4de0bdaa9677d11406c9becb70c60887c957e1f0
> ("thermal: exynos: Add support for instance based register/unregister")=

> broke check for presence of therm_dev at global thermal zone in
> exynos_report_trigger().
>=20
> The resulting wrong test prevents thermal_zone_device_update() call, wh=
ich
> calls handlers for situation when trip points are passed.
> Such behavior prevents thermal driver from proper reaction (when TMU in=
terrupt
> is raised) in a situation when overheating is detected at TMU hardware.=

> This patch fixes it.
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_thermal_common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/=
thermal/samsung/exynos_thermal_common.c
> index f10a6ad..55a912a 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.c
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -310,7 +310,7 @@ void exynos_report_trigger(struct thermal_sensor_co=
nf *conf)
>  	}
> =20
>  	th_zone =3D conf->pzone_data;
> -	if (th_zone->therm_dev)
> +	if (!th_zone->therm_dev)

Fine with this fix, as it really looks obvious. But after reading the
code a bit, I am considering if we can remove the above check at all.

Reading the driver code piece at drivers/thermal/samsung/exynos_tmu.c,
by checking how exynos_register_thermal gets called, and how error is
handled, I assume we do not need to check for th_zone->therm_dev.

To me looks like the driver only allows th_zone's exist only with valid
therm_dev, isn't it? Except for the probe sequence, maybe, at run time
there is a time window that we have valid th_zone with invalid
therm_dev. However, reading the probe, still, the irq gets initialized
only in very end, so the work queue don't get queue till then at least.

So, my question before acking is, shall we remove this check altogether?


>  		return;
> =20
>  	if (th_zone->bind =3D=3D false) {
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--xQwfTjb0Weq0xtwVOQvLOpvN5PIEdLvVc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJN5GEACgkQCXcVR3XQvP2OuwEAj9U2Ms2xE2UEYxxrm7TijEwT
sPTR79H3x2Rsv7beTcMBAOGLubRYJnvsDBSN/s+962AwktjKhyaJkyWw1FHIaV06
=g3do
-----END PGP SIGNATURE-----

--xQwfTjb0Weq0xtwVOQvLOpvN5PIEdLvVc--
