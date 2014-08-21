Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbaHURG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:06:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42440 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbaHURGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:06:24 -0400
Date: Thu, 21 Aug 2014 12:06:15 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: twl4030-usb: Fix regressions to runtime PM on
 omaps
Message-ID: <20140821170615.GG11146@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140821164346.GA10066@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XaUbO9McV5wPQijU"
Content-Disposition: inline
In-Reply-To: <20140821164346.GA10066@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XaUbO9McV5wPQijU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2014 at 09:43:46AM -0700, Tony Lindgren wrote:
> Commit 30a70b026b4cd ("usb: musb: fix obex in g_nokia.ko causing kernel
> panic") attempted to fix runtime PM handling for PHYs that are on the
> I2C bus. Commit 3063a12be2b0 (usb: musb: fix PHY power on/off) then
> changed things around to enable of PHYs that rely on runtime PM.
>=20
> These changes however broke idling of the PHY and causes at least
> 100 mW extra power consumption on omaps, which is a lot with
> the idle power consumption being below 10 mW range on many devices.
>=20
> As calling phy_power_on/off from runtime PM calls in the USB
> causes complicated issues with I2C connected PHYs, let's just let
> the PHY do it's own runtime PM as needed. This leaves out the
> dependency between PHYs and USB controller drivers for runtime
> PM.
>=20
> Let's fix the regression for twl4030-usb by adding minimal runtime
> PM support. This allows idling the PHY on disconnect.
>=20
> Note that we are changing to use standard runtime PM handling
> for twl4030_phy_init() as that function just checks the state
> and does not initialize the PHY. The PHY won't get initialized
> until in twl4030_phy_power_on().
>=20
> Fixes: 30a70b026b4cd ("usb: musb: fix obex in g_nokia.ko causing kernel p=
anic")
> Fixes: 3063a12be2b0 ("usb: musb: fix PHY power on/off")
> Cc: stable@vger.kernel.org # v3.15+
> Signed-off-by: Tony Lindgren <tony@atomide.com>
>=20
> ---
>=20
> Kishon, this regression fix would be nice to get into the v3.17-rc
> series if no objections. If you don't have other fixes, I can also
> queue via arm-soc with proper acks.
>=20
> It probably does not make sense to try to fix this without using
> runtime PM without complicating the code further.
>=20
> --- a/drivers/phy/phy-twl4030-usb.c
> +++ b/drivers/phy/phy-twl4030-usb.c
> @@ -34,6 +34,7 @@
>  #include <linux/delay.h>
>  #include <linux/usb/otg.h>
>  #include <linux/phy/phy.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/usb/musb-omap.h>
>  #include <linux/usb/ulpi.h>
>  #include <linux/i2c/twl.h>
> @@ -422,37 +423,55 @@ static void twl4030_phy_power(struct twl4030_usb *t=
wl, int on)
>  	}
>  }
> =20
> -static int twl4030_phy_power_off(struct phy *phy)
> +static int twl4030_usb_runtime_suspend(struct device *dev)
>  {
> -	struct twl4030_usb *twl =3D phy_get_drvdata(phy);
> +	struct twl4030_usb *twl =3D dev_get_drvdata(dev);
> =20
> +	dev_dbg(twl->dev, "%s\n", __func__);
>  	if (twl->asleep)
>  		return 0;
> =20
>  	twl4030_phy_power(twl, 0);
>  	twl->asleep =3D 1;
> -	dev_dbg(twl->dev, "%s\n", __func__);
> +
>  	return 0;
>  }
> =20
> -static void __twl4030_phy_power_on(struct twl4030_usb *twl)
> +static int twl4030_usb_runtime_resume(struct device *dev)
>  {
> +	struct twl4030_usb *twl =3D dev_get_drvdata(dev);
> +
> +	dev_dbg(twl->dev, "%s\n", __func__);
> +	if (!twl->asleep)
> +		return 0;
> +
>  	twl4030_phy_power(twl, 1);
> -	twl4030_i2c_access(twl, 1);
> -	twl4030_usb_set_mode(twl, twl->usb_mode);
> -	if (twl->usb_mode =3D=3D T2_USB_MODE_ULPI)
> -		twl4030_i2c_access(twl, 0);
> +	twl->asleep =3D 0;
> +
> +	return 0;
> +}
> +
> +static int twl4030_phy_power_off(struct phy *phy)
> +{
> +	struct twl4030_usb *twl =3D phy_get_drvdata(phy);
> +
> +	dev_dbg(twl->dev, "%s\n", __func__);
> +	pm_runtime_mark_last_busy(twl->dev);
> +	pm_runtime_put_autosuspend(twl->dev);
> +
> +	return 0;
>  }
> =20
>  static int twl4030_phy_power_on(struct phy *phy)
>  {
>  	struct twl4030_usb *twl =3D phy_get_drvdata(phy);
> =20
> -	if (!twl->asleep)
> -		return 0;
> -	__twl4030_phy_power_on(twl);
> -	twl->asleep =3D 0;
>  	dev_dbg(twl->dev, "%s\n", __func__);
> +	pm_runtime_get_sync(twl->dev);
> +	twl4030_i2c_access(twl, 1);
> +	twl4030_usb_set_mode(twl, twl->usb_mode);
> +	if (twl->usb_mode =3D=3D T2_USB_MODE_ULPI)
> +		twl4030_i2c_access(twl, 0);
> =20
>  	/*
>  	 * XXX When VBUS gets driven after musb goes to A mode,
> @@ -558,6 +577,16 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_t=
wl)
>  		 * USB_LINK_VBUS state.  musb_hdrc won't care until it
>  		 * starts to handle softconnect right.
>  		 */
> +		if ((status =3D=3D OMAP_MUSB_VBUS_VALID) ||
> +		    (status =3D=3D OMAP_MUSB_ID_GROUND)) {
> +			if (twl->asleep)
> +				pm_runtime_get_sync(twl->dev);
> +		} else {
> +			if (!twl->asleep) {
> +				pm_runtime_mark_last_busy(twl->dev);
> +				pm_runtime_put_autosuspend(twl->dev);
> +			}
> +		}
>  		omap_musb_mailbox(status);
>  	}
>  	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
> @@ -599,22 +628,17 @@ static int twl4030_phy_init(struct phy *phy)
>  	struct twl4030_usb *twl =3D phy_get_drvdata(phy);
>  	enum omap_musb_vbus_id_status status;
> =20
> -	/*
> -	 * Start in sleep state, we'll get called through set_suspend()
> -	 * callback when musb is runtime resumed and it's time to start.
> -	 */
> -	__twl4030_phy_power(twl, 0);
> -	twl->asleep =3D 1;
> -
> +	pm_runtime_get_sync(twl->dev);
>  	status =3D twl4030_usb_linkstat(twl);
>  	twl->linkstat =3D status;
> =20
> -	if (status =3D=3D OMAP_MUSB_ID_GROUND || status =3D=3D OMAP_MUSB_VBUS_V=
ALID) {
> +	if (status =3D=3D OMAP_MUSB_ID_GROUND || status =3D=3D OMAP_MUSB_VBUS_V=
ALID)
>  		omap_musb_mailbox(twl->linkstat);
> -		twl4030_phy_power_on(phy);
> -	}
> =20
>  	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
> +	pm_runtime_mark_last_busy(twl->dev);
> +	pm_runtime_put_autosuspend(twl->dev);
> +
>  	return 0;
>  }
> =20
> @@ -650,6 +674,11 @@ static const struct phy_ops ops =3D {
>  	.owner		=3D THIS_MODULE,
>  };
> =20
> +static const struct dev_pm_ops twl4030_usb_pm_ops =3D {
> +	SET_RUNTIME_PM_OPS(twl4030_usb_runtime_suspend,
> +			   twl4030_usb_runtime_resume, NULL)
> +};
> +
>  static int twl4030_usb_probe(struct platform_device *pdev)
>  {
>  	struct twl4030_usb_data *pdata =3D dev_get_platdata(&pdev->dev);
> @@ -726,6 +755,11 @@ static int twl4030_usb_probe(struct platform_device =
*pdev)
> =20
>  	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
> =20
> +	pm_runtime_use_autosuspend(&pdev->dev);
> +	pm_runtime_set_autosuspend_delay(&pdev->dev, 2000);
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_get_sync(&pdev->dev);
> +
>  	/* Our job is to use irqs and status from the power module
>  	 * to keep the transceiver disabled when nothing's connected.
>  	 *
> @@ -744,6 +778,9 @@ static int twl4030_usb_probe(struct platform_device *=
pdev)
>  		return status;
>  	}
> =20
> +	pm_runtime_mark_last_busy(&pdev->dev);
> +	pm_runtime_put(&pdev->dev);

don't you wanna do a put_autosuspend() here instead ?

Other than that

Acked-by: Felipe Balbi <balbi@ti.com>


--=20
balbi

--XaUbO9McV5wPQijU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9icHAAoJEIaOsuA1yqRE48kP/itcwbLBp+fQ5wAF/ojMzm5t
mOhNMOPE7BD30CCdnfwZBe0iYl8Xts9IBSPWwXE3m0+Dejo7dX7c+sv7uXY3ry1Q
iUrd9Ki9vw+R5A/VjQ41DtTQcQjKLKEByOnSPvPQJY5Rr7bVwpytF0zyiRdd6fCj
Y5zX9w3ZV+HxhFaU09+sAfgeikLduSw0Gk06iLXPZQHwci2RL6wsjLltkP0hTRb9
GVujCrvZ012Jby0GcBRr+mOXfRao1uE2iXNPmJ8Og/+3FcpW8o0caO+Yx04qBBQy
M72dM4pPpHtkU6uHXirF/7Ebw+zmFZ0ddJFqxL/gJma0r/aWWCxTefpDfAGBPMgS
35P6+Z9QB/gTbK/72vgqpGcUIk++BSATO9/ClvGlVcP/M4t8dQzJSiAmEEJpG7Z7
0l9+ZoRH04/TwIEdCVc3Bv8UgcDb1yiYLXr75hGAJBgtaRFWoS9NBonbMHyXFlem
KVKz/fxMAwOeIMA1YOWoOs+TTO/bjyxOCJ6sZArhNDcvzcJQURo/vH2as9A+U7IN
tL4eRz8+FxH3leHMZ0qs387lFjSPPYI2H4/sutww7LmUG82mQEc8/AFUCioHKmoi
CEDJtRFCy26mDrsBsdJcIx+oB38q77Yb/cvfRvrSRL5JjWzrs3uTkKY3fTZXUExq
l1fkpLvCX+mR86GCN9H+
=9EnO
-----END PGP SIGNATURE-----

--XaUbO9McV5wPQijU--
