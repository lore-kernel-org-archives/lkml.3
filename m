Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbaKRPzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:55:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47460 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbaKRPzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:55:13 -0500
Date: Tue, 18 Nov 2014 09:55:17 -0600
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
Subject: Re: [RFC v6 3/3] usb: phy: hold wakeupsource when USB is enumerated
 in peripheral mode
Message-ID: <20141118155517.GH8223@saruman>
Reply-To: <balbi@ti.com>
References: <1415774479-21794-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7SAgGoIHugoKhRwh"
Content-Disposition: inline
In-Reply-To: <1415774479-21794-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7SAgGoIHugoKhRwh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 12, 2014 at 12:11:19PM +0530, Kiran Kumar Raparthy wrote:
> From: Todd Poynor <toddpoynor@google.com>
>=20
> usb: phy: hold wakeupsource when USB is enumerated in peripheral mode
>=20
> Some systems require a mechanism to prevent system to enter into suspend
> state when USB is connected and enumerated in peripheral mode.
>=20
> This patch provides an interface to hold a wakeupsource to prevent suspen=
d.
> PHY drivers can use this interface when USB is connected and enumerated in
> peripheral mode.
>=20
> A timed wakeupsource is temporarily held on USB disconnect events, to all=
ow
> the rest of the system to react to the USB disconnection (dropping host
> sessions, updating charger status, etc.) prior to re-allowing suspend.
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
> from Benoit Goby and Arve Hj=C3=B8nnev=C3=A5g, changed wakelocks usage
> to wakeupsource, merged Todd's refactoring logic and simplified
> the structures and code and addressed community feedback]
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> ---
>  drivers/usb/phy/phy.c   | 29 +++++++++++++++++++++++++++--
>  include/linux/usb/phy.h |  5 +++++
>  2 files changed, 32 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
> index 2b1039e..b5c5fd3 100644
> --- a/drivers/usb/phy/phy.c
> +++ b/drivers/usb/phy/phy.c
> @@ -329,6 +329,7 @@ int usb_add_phy(struct usb_phy *x, enum usb_phy_type =
type)
>  	int		ret =3D 0;
>  	unsigned long	flags;
>  	struct usb_phy	*phy;
> +	char wsource_name[40];
> =20
>  	if (x->type !=3D USB_PHY_TYPE_UNDEFINED) {
>  		dev_err(x->dev, "not accepting initialized PHY %s\n", x->label);
> @@ -351,6 +352,10 @@ int usb_add_phy(struct usb_phy *x, enum usb_phy_type=
 type)
>  	x->type =3D type;
>  	list_add_tail(&x->head, &phy_list);
> =20
> +	snprintf(wsource_name, sizeof(wsource_name), "vbus-%s",
> +		dev_name(x->dev));
> +	wakeup_source_init(&x->wsource, wsource_name);

do you really need the device name on the wakeup source or would
usb-vbus suffice ? Hmm, I guess we could have several of these in the
same system, so maybe there's no other way.

> @@ -446,13 +452,32 @@ int usb_bind_phy(const char *dev_name, u8 index,
>  EXPORT_SYMBOL_GPL(usb_bind_phy);
> =20
>  /**
> - * usb_phy_set_event - set event to phy event
> + * usb_phy_set_event - set event to phy event and
> + * hold/temporarily hold wakeupsource
>   * @x: the phy returned by usb_get_phy();
>   *
> - * This sets event to phy event
> + * This holds per-PHY wakeupsource/timed wakeupsource
>   */
>  void usb_phy_set_event(struct usb_phy *x, unsigned long event)
>  {
> +
>  	x->last_event =3D event;
> +
> +	switch (event) {
> +	case USB_EVENT_ENUMERATED:
> +		__pm_stay_awake(&x->wsource);
> +		break;
> +
> +	case USB_EVENT_NONE:
> +	case USB_EVENT_ID:
> +	case USB_EVENT_VBUS:
> +	case USB_EVENT_CHARGER:
> +		__pm_wakeup_event(&x->wsource,
> +				msecs_to_jiffies(TEMPORARY_HOLD_TIME));
> +		break;
> +
> +	default:
> +		break;
> +	}

much, much better. Completely hidden from PHY drivers.

>  }
>  EXPORT_SYMBOL_GPL(usb_phy_set_event);
> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
> index 3c713ff..bc58fb8 100644
> --- a/include/linux/usb/phy.h
> +++ b/include/linux/usb/phy.h
> @@ -12,6 +12,8 @@
>  #include <linux/notifier.h>
>  #include <linux/usb.h>
> =20
> +#define TEMPORARY_HOLD_TIME    2000

minor nit:

Let's call this:

#define USB_PHY_DEFAULT_WAKEUP_SRC_TIMEOUT	2000 /* ms */

When resending, please drop that "RFC" from subject and make sure your
series is sent as a single thread, instead of three separate patches.

cheers

--=20
balbi

--7SAgGoIHugoKhRwh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa2vlAAoJEIaOsuA1yqREWEMP/AzSWrymeV4KoRvT/nxqclMT
9LkPvhl5unBha5Ri+/66t4tx2SRKl1jQtaRk+CGtr/OmH3201wCvOwAW9MiGa8ha
5Vlj+8IgWQeoOvSAQcnhf4YlhFCx6Vil5WzDwJxWDeP9lFoo4hWIx1Cn/on+JPDo
4jizRTA5z9ZnrT9o5iaYyIB6VdTW7XW1EjfmsLW2/m6R4+Y5AAP8TumeiaovL0R8
RlbAcXLPj8zakSefZL5QpZMbPCrJMWm0ywE2U4cLAqOidnSr1l2suNZ6hrP6oTuT
NqZdathSyMnNUTKkUA0M09EE/ePKXJi5OCT+UZ4FgYFser0rdtppvuX6w+K16gcn
Adw/WIN2GgZq5B9QAYGIKFaMnVyZXy89L8cvU48A6xhQLsTZRuds3kD8hulWf4Hx
wQsSX/s8GhNXpjJkHzsEFqup65MWARwYiy7O/VsnT1H6Ps/39pTYzYk56BMym0FD
C7OUZCRXWC9XLZ1ry3dmXty0QsAdooU63OUaZCVLcB1WJC0H6MD2m9IS/sEefrgO
ioVYSz7NlQW/flItrJd1yN11CAAz6HcX09qqXjIdRD88zKx1azvfUI4V6y0df1hH
hPnhW+mQ+gLjwRWj3mvayxwMYKYeDvMEtWJc6wXl5oghciQ1nefw/Ao0O+uH9Fsa
jfiURbO8eWcoITjMzjLp
=Yky+
-----END PGP SIGNATURE-----

--7SAgGoIHugoKhRwh--
