Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3DVOjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:39:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37949 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080Ab3DVOjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:39:11 -0400
Date: Mon, 22 Apr 2013 17:38:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [RFC/PATCHv2 5/5] arm: omap2+: omap_device: remove
 no_idle_on_suspend
Message-ID: <20130422143839.GE7508@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com>
 <1366638237-6880-6-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pY3vCvL1qV+PayAL"
Content-Disposition: inline
In-Reply-To: <1366638237-6880-6-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pY3vCvL1qV+PayAL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 22, 2013 at 07:13:57PM +0530, Sourav Poddar wrote:
> Remove the "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check, since=20
> driver should be able to prevent idling of an omap device
> whenever required.
>=20
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Rajendra nayak <rnayak@ti.com>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
> Hi Kevin,
>=20
> I have put this as an RFC, due to few comments on cover letter of
> the previous version by Grygorii Strashko.
> As, he has mentioned that there are Audio playback use cases which=20
> also requires "no_idle_on_suspend" and using them on mainline after
> this series can cause regression.
>=20
> What you think will be the right approach on this in relation to this pat=
ch?=20
> I mean every driver(if possible) should  prevent=20
> runtime PM for no_idle_on_suspend usecase and we get=20
> rid of this OMAP_DEVICE_NO_IDLE_ON_SUSPEND check? OR we should
> drop this patch as of now?=20
>=20
> Hi Grygorii,
>=20
> Is it possible to handle ABE no_idle_on_suspend uscase the way I am
> trying to handle it for UART in the 2nd patch of this series?=20

let's ask P=E9ter.

P=E9ter, OMAP_DEVICE_NO_IDLE_ON_SUSPEND should be removed as driver's can
get same behavior by just returning -EBUSY from their ->runtime_suspend
callbacks. Do you see any problems with patch below (left for
reference) ? Would it be too difficult to add
->runtime_suspend/->runtime_resume on ASoC layer ?

> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap=
_device.c
> index 381be7a..2043d71 100644
> --- a/arch/arm/mach-omap2/omap_device.c
> +++ b/arch/arm/mach-omap2/omap_device.c
> @@ -170,9 +170,6 @@ static int omap_device_build_from_dt(struct platform_=
device *pdev)
>  			r->name =3D dev_name(&pdev->dev);
>  	}
> =20
> -	if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
> -		omap_device_disable_idle_on_suspend(pdev);
> -
>  	pdev->dev.pm_domain =3D &omap_device_pm_domain;
> =20
>  odbfd_exit1:
> @@ -620,11 +617,9 @@ static int _od_suspend_noirq(struct device *dev)
>  	ret =3D pm_generic_suspend_noirq(dev);
> =20
>  	if (!ret && !pm_runtime_status_suspended(dev)) {
> -		if (pm_generic_runtime_suspend(dev) =3D=3D 0) {
> -			if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
> -				omap_device_idle(pdev);
> +		if (pm_generic_runtime_suspend(dev) =3D=3D 0)
> +			omap_device_idle(pdev);
>  			od->flags |=3D OMAP_DEVICE_SUSPENDED;
> -		}
>  	}
> =20
>  	return ret;
> @@ -638,8 +633,7 @@ static int _od_resume_noirq(struct device *dev)
>  	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
>  	    !pm_runtime_status_suspended(dev)) {
>  		od->flags &=3D ~OMAP_DEVICE_SUSPENDED;
> -		if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
> -			omap_device_enable(pdev);
> +		omap_device_enable(pdev);
>  		pm_generic_runtime_resume(dev);
>  	}
> =20
> diff --git a/arch/arm/mach-omap2/omap_device.h b/arch/arm/mach-omap2/omap=
_device.h
> index 044c31d..17ca1ae 100644
> --- a/arch/arm/mach-omap2/omap_device.h
> +++ b/arch/arm/mach-omap2/omap_device.h
> @@ -38,7 +38,6 @@ extern struct dev_pm_domain omap_device_pm_domain;
> =20
>  /* omap_device.flags values */
>  #define OMAP_DEVICE_SUSPENDED		BIT(0)
> -#define OMAP_DEVICE_NO_IDLE_ON_SUSPEND	BIT(1)
> =20
>  /**
>   * struct omap_device - omap_device wrapper for platform_devices
> @@ -101,13 +100,4 @@ static inline struct omap_device *to_omap_device(str=
uct platform_device *pdev)
>  {
>  	return pdev ? pdev->archdata.od : NULL;
>  }
> -
> -static inline
> -void omap_device_disable_idle_on_suspend(struct platform_device *pdev)
> -{
> -	struct omap_device *od =3D to_omap_device(pdev);
> -
> -	od->flags |=3D OMAP_DEVICE_NO_IDLE_ON_SUSPEND;
> -}
> -
>  #endif
> --=20
> 1.7.1
>=20

--=20
balbi

--pY3vCvL1qV+PayAL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdUtvAAoJEIaOsuA1yqREx6wP/j47ziFp2nIF2xvBoeAFtB7V
3uuZhE7vQoONRi+tuWQXKkXYW0GLeCw5nsxvr3pxOgiB+4k6sYO7dE5l4evEBh60
JXtaRxJFmNaJtTFNjk/HiwPul1yl+UHwrsJULls1+xKlm9ad6TmSrQ0JceC8K0H0
JPiRgWfMOeuqkYFF/aHrH0jIRMPR4cqMoN85n6GGhPQOoAZtzjrVUE2KS36Ustu/
znCKneLB2rrsEnrJy6UkdqA4WqqElFyisyTHCTn5CTFJ8AB/kW9v8s+soiwIBmvv
pcDL0VUN10svkeFqrrHVDa1LG1UKKvlOBtmv24amSsjKTXU4R4EjDHdyrA1DsvIT
jObCDGb/Xnb2SyZ+jEXzV33drqAe2gZK0e6H5UXiO43y6kJ4GCJAz45DsM/LIVn9
C7ZA58QLuhl+taQrd/8vAV10wgdcGIDdOD2HGZAlhQbqbMDIQEBdWph2eqwtEgQz
IbBboayaI20KYdoXBXDhT6HG/MlFBH+ra75bxSoMn1M9ah2MJCjuJ/NveL3Yn7s2
j10XAN6wG/vz5M+N/Voozmdpt5SN44EviadshAKNgc+9SL57Kcfawx2uBNTRmHyu
TE6ONGtD2lAVeL7j2VLYnhd0T24YTidSJCT1Wu6S81Nmp/piAAQxPJSPlhaTvqXS
THnq2XZjZddjHdEQ7ETQ
=Z/AW
-----END PGP SIGNATURE-----

--pY3vCvL1qV+PayAL--
