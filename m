Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaIHNjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:39:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46173 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaIHNjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:39:11 -0400
Date: Mon, 8 Sep 2014 08:38:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Subject: Re: [RFC v3 1/2] usb: phy: Hold wakeupsource when USB is enumerated
 in peripheral mode
Message-ID: <20140908133855.GH22409@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410170963-14182-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZYOWEO2dMm2Af3e3"
Content-Disposition: inline
In-Reply-To: <1410170963-14182-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZYOWEO2dMm2Af3e3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 08, 2014 at 03:39:23PM +0530, Kiran Kumar Raparthy wrote:
> From: Todd Poynor <toddpoynor@google.com>
>=20
> usb: phy: Hold wakeupsource when USB is enumerated in peripheral mode
>=20
> Purpose of this is to prevent the system to enter into suspend state from=
 USB
> peripheral traffic by hodling a wakeupsource when USB is connected and
> enumerated in peripheral mode(say adb).
>=20
> Disabled by default, can enable with:
>    echo Y > /sys/module/otg_wakeupsource/parameters/enabled
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Arve Hj=EF=BF=BDnnev=EF=BF=BDg <arve@android.com>
> Cc: Benoit Goby <benoit@android.com>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> [kiran: Added context to commit message, squished build fixes
> from Benoit Goby and Arve Hj=EF=BF=BDnnev=EF=BF=BDg, changed wakelocks us=
age
> to wakeupsource, merged Todd's refactoring logic and simplified
> the structures and code and addressed community feedback]
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> ---
> v3:
> * As per the feedback,no global phy pointer used.
> * called the one-liner wakeupsource handling calls
>   directly instead of indirect functions implemented in v2.
> * Removed indirect function get_phy_hook and used usb_get_phy
>   to get the phy handle..
>=20
> v2:
> * wakeupsource handling implemeted per-PHY
> * Implemented wakeupsource handling calls in phy
> * included Todd's refactoring logic.
>=20
> v1:
> * changed to "disabled by default" from "enable by default".
> * Kconfig help text modified
> * Included better commit text
> * otgws_nb moved to otg_wakeupsource_init function
> * Introduced get_phy_hook to handle otgws_xceiv per-PHY
>=20
> RFC:
> * Included build fix from Benoit Goby and Arve Hj=EF=BF=BDnnev=EF=BF=BDg
> * Removed lock->held field in driver as this mechanism is
>   provided in wakeupsource driver.
> * wakelock(wl) terminology replaced with wakeup_source(ws).
>=20
>  drivers/usb/phy/Kconfig            |   8 +++
>  drivers/usb/phy/Makefile           |   1 +
>  drivers/usb/phy/otg-wakeupsource.c | 136 +++++++++++++++++++++++++++++++=
++++++
>  include/linux/usb/phy.h            |   4 ++
>  4 files changed, 149 insertions(+)
>  create mode 100644 drivers/usb/phy/otg-wakeupsource.c
>=20
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index e253fa0..d9ddd85 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -6,6 +6,14 @@ menu "USB Physical Layer drivers"
>  config USB_PHY
>  	def_bool n
> =20
> +config USB_OTG_WAKEUPSOURCE
> +	bool "Hold wakeupsource when USB is enumerated in peripheral mode"
> +	depends on PM_SLEEP
> +	select USB_PHY
> +	help
> +	  Prevent the system going into automatic suspend while
> +	  it is attached as a USB peripheral by holding a wakeupsource.
> +
>  #
>  # USB Transceiver Drivers
>  #
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index 24a9133..ca2fbaf 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -3,6 +3,7 @@
>  #
>  obj-$(CONFIG_USB_PHY)			+=3D phy.o
>  obj-$(CONFIG_OF)			+=3D of.o
> +obj-$(CONFIG_USB_OTG_WAKEUPSOURCE)		+=3D otg-wakeupsource.o
> =20
>  # transceiver drivers, keep the list sorted
> =20
> diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wak=
eupsource.c
> new file mode 100644
> index 0000000..d9a1720
> --- /dev/null
> +++ b/drivers/usb/phy/otg-wakeupsource.c
> @@ -0,0 +1,136 @@
> +/*
> + * otg-wakeupsource.c
> + *
> + * Copyright (C) 2011 Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/notifier.h>
> +#include <linux/pm_wakeup.h>
> +#include <linux/spinlock.h>
> +#include <linux/usb/otg.h>
> +
> +bool enabled =3D false;
> +
> +static DEFINE_SPINLOCK(otgws_spinlock);

why do you continue to ignore my comment that this should be built
*into* struct usb_phy so it's a per-PHY setting ? Is this some sort of a
joke that I'm not getting ?

> +static void otgws_handle_event(struct usb_phy *otgws_xceiv, unsigned lon=
g event)
> +{
> +	unsigned long irqflags;
> +
> +	spin_lock_irqsave(&otgws_spinlock, irqflags);
> +
> +	if (!enabled) {
> +		__pm_relax(&otgws_xceiv->wsource);
> +		spin_unlock_irqrestore(&otgws_spinlock, irqflags);
> +		return;
> +	}
> +
> +	switch (event) {
> +	case USB_EVENT_VBUS:
> +	case USB_EVENT_ENUMERATED:
> +		__pm_stay_awake(&otgws_xceiv->wsource);
> +		break;
> +
> +	case USB_EVENT_NONE:
> +	case USB_EVENT_ID:
> +	case USB_EVENT_CHARGER:
> +		__pm_relax(&otgws_xceiv->wsource);
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	spin_unlock_irqrestore(&otgws_spinlock, irqflags);
> +}
> +
> +static int otgws_otg_notifications(struct notifier_block *nb,
> +				unsigned long event, void *unused)
> +{
> +	static struct usb_phy *otgws_xceiv;
> +
> +	otgws_xceiv =3D usb_get_phy(USB_PHY_TYPE_USB2);
> +
> +	if (IS_ERR(otgws_xceiv)) {
> +		pr_err("%s: No OTG transceiver found\n", __func__);
> +		return PTR_ERR(otgws_xceiv);
> +	}
> +
> +	otgws_handle_event(otgws_xceiv, event);
> +
> +	return NOTIFY_OK;
> +}
> +
> +static int set_enabled(const char *val, const struct kernel_param *kp)
> +{
> +	int rv =3D param_set_bool(val, kp);
> +	static struct usb_phy *otgws_xceiv;
> +
> +	if (rv)
> +		return rv;
> +
> +	otgws_xceiv =3D usb_get_phy(USB_PHY_TYPE_USB2);
> +
> +	if (IS_ERR(otgws_xceiv)) {
> +		pr_err("%s: No OTG transceiver found\n", __func__);
> +		return PTR_ERR(otgws_xceiv);
> +	}
> +
> +	otgws_handle_event(otgws_xceiv, otgws_xceiv->last_event);
> +
> +	return 0;
> +}
> +
> +static struct kernel_param_ops enabled_param_ops =3D {
> +	.set =3D set_enabled,
> +	.get =3D param_get_bool,
> +};
> +
> +module_param_cb(enabled, &enabled_param_ops, &enabled, 0644);
> +MODULE_PARM_DESC(enabled, "Hold wakeupsource when VBUS present");

should *not* be a kernel parameter.

> +static int __init otg_wakeupsource_init(void)

no __init

> +{
> +	int ret;
> +	char wsource_name[40];
> +	static struct usb_phy *otgws_xceiv;
> +
> +	otgws_xceiv =3D usb_get_phy(USB_PHY_TYPE_USB2);
> +
> +	if (IS_ERR(otgws_xceiv)) {
> +		pr_err("%s: No OTG transceiver found\n", __func__);
> +		return PTR_ERR(otgws_xceiv);
> +	}
> +
> +	snprintf(wsource_name, sizeof(wsource_name), "vbus-%s",
> +		dev_name(otgws_xceiv->dev));
> +	wakeup_source_init(&otgws_xceiv->wsource, wsource_name);
> +
> +	otgws_xceiv->otgws_nb.notifier_call =3D otgws_otg_notifications;
> +	ret =3D usb_register_notifier(otgws_xceiv, &otgws_xceiv->otgws_nb);
> +
> +	if (ret) {
> +		pr_err("%s: usb_register_notifier on transceiver %s failed\n",
> +			 __func__, dev_name(otgws_xceiv->dev));
> +		wakeup_source_trash(&otgws_xceiv->wsource);
> +		otgws_xceiv =3D NULL;
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +late_initcall(otg_wakeupsource_init);
> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
> index 353053a..c71cf15 100644
> --- a/include/linux/usb/phy.h
> +++ b/include/linux/usb/phy.h
> @@ -88,6 +88,10 @@ struct usb_phy {
> =20
>  	/* for notification of usb_phy_events */
>  	struct atomic_notifier_head	notifier;
> +	struct notifier_block	otgws_nb;
> +
> +	/* wakeup source */
> +	struct wakeup_source	wsource;
> =20
>  	/* to pass extra port status to the root hub */
>  	u16			port_status;
> --=20
> 1.8.2.1
>=20

--=20
balbi

--ZYOWEO2dMm2Af3e3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDbFvAAoJEIaOsuA1yqREYSEP/RZD6/rLQfYHQwtRoNJa5+v0
TcVsKQjY4wT8si8ReIttbF1mWHTapNJ1/PcMa/C6Og3nG/Z7I/eYuVK9ISWIK2ve
MTBBx2w8OcmleRUYYFI1p7baMvXXRukWSuzJzpp80tnIXEw+99BUXZQ4hGCxfIVh
evxgWNF9qTJMFqwzYNlSqlc2K5RY//DAX+IR6gtIcsHO2MtfTt5qqv4msfXl/6ke
O7D1IK6jo79YSVlC/Sl6t4Ak0n9tefBq92wNj9BIoHaffDXmZXcJHm2AHEmQANGw
SyWIPqAxq868Q6ERqRTjnR9/eKpsVNmhQaug9FkcAEJTZGZYH7LFFDRENXo63hN2
e/NIxOtEyKEiCUlpz//xoWdklSoN7ZPtVKEcxwOVL5VbpZss+ObuF6CPTWc9lG4e
jf5DPYxIqcpZdb54+88UeREW+ltTMH2wOm6KXvluutYnxYb52wrDa/RK08CItKs3
nqgLjHx4Aov5HTFCXkyBV1xXu649WlD6uG673ym+VLJlZwCP3x8ILieajIFnezOb
VyJL9iSP4xslW/N5mm0rGRXKaQizTt+prau6fCDUz9FEbbvWur0rDAyPTFGrnLNZ
U1HaeLpFNS7HBcWg0GGpgquPAlq6fxwosoCw9hWDvwP/xBb1fyPW9pNGBbxqjkYD
okHo8MxGdGsmDH/RUPqd
=3jdb
-----END PGP SIGNATURE-----

--ZYOWEO2dMm2Af3e3--
