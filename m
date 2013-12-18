Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab3LRQeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:34:10 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50522 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3LRQeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:34:08 -0500
Date: Wed, 18 Dec 2013 10:33:29 -0600
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: am335x: Enable USB remote wakeup using PHY
 wakeup
Message-ID: <20131218163329.GH4970@saruman.home>
Reply-To: <balbi@ti.com>
References: <1387372929-18629-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CD/aTaZybdUisKIc"
Content-Disposition: inline
In-Reply-To: <1387372929-18629-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CD/aTaZybdUisKIc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 18, 2013 at 06:52:09PM +0530, George Cherian wrote:
> USB remote wakeup using PHY wakeup is supported only in standby mode.
> Enabling the PHY_WKUP will break DS0 mode of system suspend.
> If the same is enabled while entering DS0, AM33xx never stays in DS0,
> it returns immediately from DS0. By default make the PHY wakeup
> disabled, using sysfs entry enable the same manually to get
> the remote wakeup working from standby.
>=20
> echo enabled > /sys/bus/platform/device/<usb phy id>/power/wakeup
> This will enable the PHY wakeup while going to standby.
>=20
> PHY wakeup feature is required to wakeup  the system from standby
> state. Since AM33xx has a bug in which PHY wakeup should not
> be enabled while entering DS0, disable the same by default.
> A user wishing to use USB wakeup from standby mode need to enable
> the same using the sysfs entries.
>=20
> Also remove am335x_phy_runtime_(suspend/resume) this driver doesnot really
> enable/disable the clocks to the PHY.
> Add am335x_phy_(suspend/resume) and use the same for enabling the PHY_WKU=
P.
>=20
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  drivers/usb/phy/phy-am335x.c | 46 +++++++++++++++++++++++++++++++++-----=
------
>  1 file changed, 35 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/usb/phy/phy-am335x.c b/drivers/usb/phy/phy-am335x.c
> index 6370e50..3f78eaf 100644
> --- a/drivers/usb/phy/phy-am335x.c
> +++ b/drivers/usb/phy/phy-am335x.c
> @@ -64,6 +64,19 @@ static int am335x_phy_probe(struct platform_device *pd=
ev)
>  	am_phy->usb_phy_gen.phy.shutdown =3D am335x_shutdown;
> =20
>  	platform_set_drvdata(pdev, am_phy);
> +	device_init_wakeup(dev, true);
> +
> +	/*
> +	 * If we leave PHY wakeup enabled then AM33XX wakes up
> +	 * immediately from DS0. To avoid this we mark dev->power.can_wakeup
> +	 * to false. The same is checked in suspend routine to decide
> +	 * on whether to enable PHY wakeup or not.
> +	 * PHY wakeup works fine in standby mode, there by allowing us to
> +	 * handle remote wakeup, wakeup on disconnect and connect.
> +	 */
> +
> +	device_set_wakeup_enable(dev, false);
> +	phy_ctrl_power(am_phy->phy_ctrl, am_phy->id, false);
> =20
>  	return 0;
> =20
> @@ -78,40 +91,51 @@ static int am335x_phy_remove(struct platform_device *=
pdev)
>  	return 0;
>  }
> =20
> -#ifdef CONFIG_PM_RUNTIME
> -
> -static int am335x_phy_runtime_suspend(struct device *dev)
> +#ifdef CONFIG_PM_SLEEP
> +static int am335x_phy_suspend(struct device *dev)
>  {
>  	struct platform_device	*pdev =3D to_platform_device(dev);
>  	struct am335x_phy *am_phy =3D platform_get_drvdata(pdev);
> =20
> +	/*
> +	 * Enable phy wakeup only if dev->power.can_wakeup is true.
> +	 * Make sure to enable wakeup to support remote wakeup	in
> +	 * standby mode ( same is not supported in OFF(DS0) mode).
> +	 * Enable it by doing
> +	 * echo enabled > /sys/bus/platform/devices/<usb-phy-id>/power/wakeup
> +	 */

Alan, any suggestions on how to handle wakeup correctly ? I mean, it
should be enabled by default during runtime PM and disabled during
system sleep. But when it comes to default state of can_wakeup field,
what should we do ? Should the driver be fiddling with that ? Leave it
to the bus driver ? Any tips ?

cheers

--=20
balbi

--CD/aTaZybdUisKIc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSsc5ZAAoJEIaOsuA1yqRE4tIQAJ2nnKJiCt4cX+yIBLNMa4IK
lThYm08eTB+yp6yXu4RUTnGsBoj7+tEg7hdKQ0YudMYYte+jBCPtupCKLH1T7Jcl
p92YC72w0EXagCfY+asDUnkJI7JfaHVhf2W7/UiGFlTy4ZHKgVVNru3yH64++CZW
zxvz3q8Qw3/pK5z35v73a8IUJ2qM3w9ijHiW2yfzDLcLRl6HL9qaQsgVLjBbheIC
hIBT/7E95m1oQZChnSAnKjkapaAee7BCesgjWeCj5Zc3xO83qKItKL0vdGb8xuKp
rVDrebdIpBhEdPM0ZGijv2OtoZFuSTDs7jHUiKS9BII/6qk0ii/sT3/ig0fEiKZt
h86RDSNTa6+OM0fBYEm2i08JksuPDZepNO1xK5mnTlATMKL19f6DiIWtUgpsAjQh
YEIb+Y6TffNrpoxex5Y1mASktcgDCo2522DlD8dfrViJjPJGzJUu6nu/gbBtaPQ9
EhLil5ZzxObqMUWyeZHjmg0bCJBrHSjMoiOeZUqoAVb+ZlQoTErWFR+WXfNuzcD0
d8MQMJUbGsMD/SqbZDSawyO6UljcP7Q1tIwyIFlVs79Ce+ajAEuBbsFQMvx6i4Z3
71GlgXimG400L+5Q2fMXKaNBkXdkLuGntmOwUENfUmTb93DOfBO+el0MV6UlSgWF
HobrYpsQcMrxul9n3viB
=Fnhu
-----END PGP SIGNATURE-----

--CD/aTaZybdUisKIc--
