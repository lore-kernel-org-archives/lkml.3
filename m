Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab3HAPKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:10:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60947 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab3HAPKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:10:20 -0400
Date: Thu, 1 Aug 2013 18:09:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: <akpm@linux-foundation.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>, <swarren@nvidia.com>,
        <pawel.moll@arm.com>, <Mark.Rutland@arm.com>,
        <ian.campbell@citrix.com>, <broonie@kernel.org>
Subject: Re: [PATCH V2] drivers/rtc/rtc-palmas.c: support for backup battery
 charging
Message-ID: <20130801150941.GA11286@radagast>
Reply-To: <balbi@ti.com>
References: <1375367471-29908-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <1375367471-29908-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 01, 2013 at 08:01:11PM +0530, Laxman Dewangan wrote:
> Palmas series device like TPS65913, TPS80036 supports the backup battery
> for powering the RTC when no other energy source is available.
>=20
> The backup battery is optional, connected to the VBACKUP pin, and can be
> nonrechargeable or rechargeable. The rechargeable battery can be charged
> from the system supply using the backup battery charger.
>=20
> Add support for enabling charging of this backup battery.  Also add the DT
> binding document and the new properties to have this support.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - Converted DT property to boolean.
> - cleanups as use "...".
>=20
>  .../devicetree/bindings/rtc/rtc-palmas.txt         |   28 ++++++++++++++=
++
>  drivers/rtc/rtc-palmas.c                           |   35 ++++++++++++++=
++++++
>  2 files changed, 63 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/rtc/rtc-palmas.txt
>=20
> diff --git a/Documentation/devicetree/bindings/rtc/rtc-palmas.txt b/Docum=
entation/devicetree/bindings/rtc/rtc-palmas.txt
> new file mode 100644
> index 0000000..c8c9def
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rtc/rtc-palmas.txt
> @@ -0,0 +1,28 @@
> +Palmas RTC controller bindings
> +
> +Required properties:
> +- compatible:
> +  - "ti,palmas-rtc" for palma series of the RTC controller
> +- interrupt-parent: Parent interrupt device, must be handle of palmas no=
de.
> +- interrupts: Interrupt number of RTC submodule on device.
> +
> +Optional properties:
> +- ti,back-battery-charge-enable: The palmas series device like TPS65913 =
or
> +	TPS80036 supports the battery backup for powering the RTC when main
> +	battery is removed or in very low power state. This flag will enable
> +	the backup battery charging.
> +- ti,back-charge-low-current: Configure lower charging current. Device s=
upports the
> +	charging current as < 100mA or >100mA. Low current will set as <100mA.
> +
> +Example:
> +	palmas: tps65913@58 {
> +		...
> +		palmas_rtc: rtc {
> +			compatible =3D "ti,palmas-rtc";
> +			interrupt-parent =3D <&palmas>;
> +			interrupts =3D <8 0>;
> +			ti,back-battery-charge-enable;
> +			ti,back-charge-low-current;
> +		};
> +		...
> +	};
> diff --git a/drivers/rtc/rtc-palmas.c b/drivers/rtc/rtc-palmas.c
> index a1fecc8..7f34e33 100644
> --- a/drivers/rtc/rtc-palmas.c
> +++ b/drivers/rtc/rtc-palmas.c
> @@ -238,6 +238,15 @@ static int palmas_rtc_probe(struct platform_device *=
pdev)
>  	struct palmas *palmas =3D dev_get_drvdata(pdev->dev.parent);
>  	struct palmas_rtc *palmas_rtc =3D NULL;
>  	int ret;
> +	bool enable_bb_charging =3D false;
> +	bool low_bb_charging;
> +
> +	if (pdev->dev.of_node) {
> +		enable_bb_charging =3D of_property_read_bool(pdev->dev.of_node,
> +					"ti,back-battery-charge-enable");
> +		low_bb_charging =3D of_property_read_bool(pdev->dev.of_node,
> +					"ti,back-charge-low-current");
> +	}
> =20
>  	palmas_rtc =3D devm_kzalloc(&pdev->dev, sizeof(struct palmas_rtc),
>  			GFP_KERNEL);
> @@ -254,6 +263,32 @@ static int palmas_rtc_probe(struct platform_device *=
pdev)
>  	palmas_rtc->dev =3D &pdev->dev;
>  	platform_set_drvdata(pdev, palmas_rtc);
> =20
> +	if (enable_bb_charging) {
> +		unsigned reg =3D 0;
> +
> +		if (low_bb_charging)
> +			reg |=3D PALMAS_BACKUP_BATTERY_CTRL_BBS_BBC_LOW_ICHRG;
> +
> +		ret =3D palmas_update_bits(palmas, PALMAS_PMU_CONTROL_BASE,
> +			PALMAS_BACKUP_BATTERY_CTRL,
> +			PALMAS_BACKUP_BATTERY_CTRL_BBS_BBC_LOW_ICHRG, reg);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev,
> +				"BACKUP_BATTERY_CTRL update failed, %d\n", ret);
> +			return ret;
> +		}
> +
> +		ret =3D palmas_update_bits(palmas, PALMAS_PMU_CONTROL_BASE,
> +			PALMAS_BACKUP_BATTERY_CTRL,
> +			PALMAS_BACKUP_BATTERY_CTRL_BB_CHG_EN,
> +			PALMAS_BACKUP_BATTERY_CTRL_BB_CHG_EN);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev,
> +				"BACKUP_BATTERY_CTRL update failed, %d\n", ret);
> +			return ret;
> +		}

I wonder if this should be exposed via power_supply class, although it's
not really a power supply. So perhaps not needed :-s

looks good though (can't test as I don't have any boards available right
now):

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+no1AAoJEIaOsuA1yqREvW8P+gLvvpyeacGYUSd5bDXuvmJq
Xo85zyQMqRItL9S7OoV1E9FMbo+N5jP1qbGpWFvjsBgxD5w0HYpiIJCRVUZbhIou
HddVtBCJ18aouE9lS4o/KLACK78/RFsewpsdPSFTV5r/o7+qgJE+YbuKlby/6XNG
tM4a/PYp/HdiBtjIjCaZgJM3T2uRSVJbU01pps4ou9XBqrZ005/u5dSUwcVad5Di
zxQqKOrd93O3DDNmWYvswQ3+sX1TVjSPMd8PP1wUE+mnwNqnheaJqzu7duiU8Z7B
LzTwLOWzKvVF9IKKc+30WIFfF4Vp1phR1nezR7o/2wOofjsAzKDeq/Eoq54RxWUU
XRs8GHYfWp03/6BH6Xr0aktPVlCZLf+ceYsDepNJ0f3U9yZ91FW8qia4jjQJjGwN
FOxi5BEi09Ls3VqpSc/i09FM2u07jLq06zXBoVx/8IUrqEim5NwbfuKbucOVLvzV
n22n87Pr2UGPdZqhn+/KBaOVLGij1pWcdE3KbL40IhHvzbfTKnkK7T2QaxyNDNeC
sR8sg8WO6CmBnUiCDQKpvemHaGIY8mzimVo4eYUoZWewVRmabl/stMF789K41aSo
GUlFBF2hrXuqChoROS7jAS7QmLkvEGLiYJWDCDlf3KFkD7YKMd2vAhHUZ/UF9PPJ
codpP6nMtcuO0aW/Bwzv
=coLi
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
