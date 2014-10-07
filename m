Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaJGO0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:26:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41141 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbaJGO0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:26:00 -0400
Date: Tue, 7 Oct 2014 09:25:54 -0500
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
Subject: Re: [RFC v4] usb: phy: Hold wakeupsource when USB is enumerated in
 peripheral mode
Message-ID: <20141007142554.GE24720@saruman>
Reply-To: <balbi@ti.com>
References: <1412673344-25443-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="orO6xySwJI16pVnm"
Content-Disposition: inline
In-Reply-To: <1412673344-25443-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--orO6xySwJI16pVnm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 07, 2014 at 02:45:44PM +0530, Kiran Kumar Raparthy wrote:
> diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wak=
eupsource.c
> new file mode 100644
> index 0000000..00d3359
> --- /dev/null
> +++ b/drivers/usb/phy/otg-wakeupsource.c
> @@ -0,0 +1,134 @@
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
> +static void otgws_handle_event(struct usb_phy *otgws_xceiv, unsigned lon=
g event)
> +{
> +	unsigned long irqflags;
> +
> +	spin_lock_irqsave(&otgws_xceiv->otgws_slock, irqflags);
> +
> +	switch (event) {
> +	case USB_EVENT_VBUS:

Looks like VBUS should be temporary too.

> +	case USB_EVENT_ENUMERATED:
> +		__pm_stay_awake(&otgws_xceiv->wsource);
> +		break;
> +
> +	case USB_EVENT_NONE:
> +	case USB_EVENT_ID:
> +	case USB_EVENT_CHARGER:
> +		__pm_wakeup_event(&otgws_xceiv->wsource,
> +				msecs_to_jiffies(TEMPORARY_HOLD_TIME));
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	spin_unlock_irqrestore(&otgws_xceiv->otgws_slock, irqflags);
> +}
> +
> +static int otgws_otg_usb2_notifications(struct notifier_block *nb,
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
> +static int otgws_otg_usb3_notifications(struct notifier_block *nb,
> +				unsigned long event, void *unused)
> +{
> +	static struct usb_phy *otgws_xceiv;
> +
> +	otgws_xceiv =3D usb_get_phy(USB_PHY_TYPE_USB3);
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
> +static int otg_wakeupsource_init(void)
> +{
> +	int ret_usb2;
> +	int ret_usb3;
> +	char wsource_name_usb2[40];
> +	char wsource_name_usb3[40];
> +	static struct usb_phy *otgws_xceiv_usb2;
> +	static struct usb_phy *otgws_xceiv_usb3;
> +
> +	otgws_xceiv_usb2 =3D usb_get_phy(USB_PHY_TYPE_USB2);
> +	otgws_xceiv_usb3 =3D usb_get_phy(USB_PHY_TYPE_USB3);
> +
> +	if (IS_ERR(otgws_xceiv_usb2) && IS_ERR(otgws_xceiv_usb3)) {
> +		pr_err("%s: No OTG transceiver found\n", __func__);
> +		return PTR_ERR(otgws_xceiv_usb2);
> +	}
> +
> +	spin_lock_init(&otgws_xceiv_usb2->otgws_slock);
> +	spin_lock_init(&otgws_xceiv_usb3->otgws_slock);
> +
> +	snprintf(wsource_name_usb2, sizeof(wsource_name_usb2), "vbus-%s",
> +		dev_name(otgws_xceiv_usb2->dev));
> +	wakeup_source_init(&otgws_xceiv_usb2->wsource, wsource_name_usb2);
> +
> +	snprintf(wsource_name_usb3, sizeof(wsource_name_usb3), "vbus-%s",
> +		dev_name(otgws_xceiv_usb3->dev));
> +	wakeup_source_init(&otgws_xceiv_usb3->wsource, wsource_name_usb3);
> +
> +	otgws_xceiv_usb2->otgws_nb.notifier_call =3D otgws_otg_usb2_notificatio=
ns;
> +	ret_usb2 =3D usb_register_notifier(otgws_xceiv_usb2,
> +					&otgws_xceiv_usb2->otgws_nb);
> +
> +	otgws_xceiv_usb3->otgws_nb.notifier_call =3D otgws_otg_usb3_notificatio=
ns;
> +	ret_usb3 =3D usb_register_notifier(otgws_xceiv_usb3,
> +					&otgws_xceiv_usb3->otgws_nb);
> +
> +	if (ret_usb2 && ret_usb3) {
> +		pr_err("%s: usb_register_notifier on transceiver failed\n",
> +			 __func__);
> +		wakeup_source_trash(&otgws_xceiv_usb2->wsource);
> +		wakeup_source_trash(&otgws_xceiv_usb3->wsource);
> +		otgws_xceiv_usb2 =3D NULL;
> +		otgws_xceiv_usb3 =3D NULL;
> +		return ret_usb2 | ret_usb3;
> +	}
> +
> +	return 0;
> +}
> +
> +late_initcall(otg_wakeupsource_init);

you guys are really not getting what I mean. I asked for this to be
built into the core itself. This means that you shouldn't need to use
notifications nor should you need to call usb_get_phy(). You're part of
the PHY framework.

All this late_initcall() nonsense should go.

This code won't even work if we have more than one phy of the same type
(AM437x SoC, for example, has up to 4 instances of dwc3, so that's 4
USB2 PHYs), because you can't grab the PHY you want.

What you need is to:

1) make PHY notifiers generic (move all of that phy-core.c)
2) introduce usb_phy_set_event(phy, event) (which just sets the even to a
	phy->event member for now)
3) make all PHY drivers use usb_phy_set_event()
4) add the following to usb_phy_set_event()

	switch (event) {
	case USB_EVENT_ENUMERATED:
		pm_stay_awake(&otgws_xceiv->wsource);
		break;

	case USB_EVENT_NONE:
	case USB_EVENT_VBUS:
	case USB_EVENT_ID:
	case USB_EVENT_CHARGER:
		pm_wakeup_event(&otgws_xceiv->wsource,
				msecs_to_jiffies(TEMPORARY_HOLD_TIME));
		break;

	default:
		break;
	}

note that I'm calling locked versions of those functions so you can drop
the spinlock you added. But, dependending on when usb_phy_set_event() is
called, you might want to switch back to unlocked versions. In any case,
the new spinlock is unnecessary because you can either use
dev->power.lock or you're calling usb_phy_set_event() from and IRQ
handler.

> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
> index 353053a..dd64e2e 100644
> --- a/include/linux/usb/phy.h
> +++ b/include/linux/usb/phy.h
> @@ -12,6 +12,8 @@
>  #include <linux/notifier.h>
>  #include <linux/usb.h>
> =20
> +#define TEMPORARY_HOLD_TIME    2000
> +
>  enum usb_phy_interface {
>  	USBPHY_INTERFACE_MODE_UNKNOWN,
>  	USBPHY_INTERFACE_MODE_UTMI,
> @@ -88,6 +90,12 @@ struct usb_phy {
> =20
>  	/* for notification of usb_phy_events */
>  	struct atomic_notifier_head	notifier;
> +	struct notifier_block	otgws_nb;

drop this notifier block.

> +
> +	/* wakeup source */
> +	struct wakeup_source	wsource;

this is the only thing you need.

> +
> +	spinlock_t		otgws_slock;

drop this lock.

--=20
balbi

--orO6xySwJI16pVnm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUM/fxAAoJEIaOsuA1yqRErygQAK1sJUHUgaJeukwC/7xx0cEN
XPbbk/3WeSZuOjbHECFKHknoZyxiUERyw3EwckdliA8+5iKqGk/6hEmhhsix4VbO
BdxVd9SyYEEB9W7vRCiKCmb2h3fJo46uODZJeRhlIdmKlLUSQ2aJALtphyhh7jQD
pwmTYmafbESkd2VFWCEpdpmvsR7I4tEoMzXeU7ExJhIESzHsC60jXbZ/K340NwiJ
QDgSvgrv5khgX7zOSOHKZKfQmYGURUfJy+UpCO7CRDKxUYAuxQS7TOREojcluYQr
1TLgVPFEvcFe3/g5nJ1eZ9yHcqLGpfqz6xHYEzx4arigAgJBxfkhG4sTDIy41me1
K01czOMJoInYo1cwA1sXmqFzW9d6z4DSX9xOy4Lc/awKjmkVdP0Tl7sn7cLxYjjf
D0U/1hjs0PTozs50MrMhmZT9BBaIidrtengzIN0GtX+My2O6SPXxGidlimfY2NsH
z7EDIJwW/5wLOaX2ZTsoIM4XWcERynaCEvcVu4CveKgq81m5HrLuEBn2Z5wRieEx
PwGynj6CNqQATqxCtpo6g5GHpCkb3S2dNUDYjPbFqCP8gD55Uln2bZkWTfl8g8hU
7hV7bmCRwPmP1IIJD1NNgQwcXgnoKP8pTDlN79k55Sz5185MXkXxR8wGzoxVb8Hs
GCQtbTY51JOp6OSaURur
=Usdn
-----END PGP SIGNATURE-----

--orO6xySwJI16pVnm--
