Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaJON6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 09:58:14 -0400
Received: from mail.kernel.org ([198.145.19.201]:48198 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbaJON6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 09:58:12 -0400
Date: Wed, 15 Oct 2014 15:58:06 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [RFT PATCH] power: bq2415x_charger: Properly handle ENODEV from
 power_supply_get_by_phandle
Message-ID: <20141015135806.GA5152@earth.universe>
References: <1413275573-23014-1-git-send-email-k.kozlowski@samsung.com>
 <20141015090512.GA26651@earth.universe>
 <1413371491.26771.15.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <1413371491.26771.15.camel@AMDC1943>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 15, 2014 at 01:11:31PM +0200, Krzysztof Kozlowski wrote:
> > [...] I guess something as the following is needed:
> >=20
> > if (IS_ERR_OR_NULL(bq->notify_psy)) {
> >     if (bq->notify_psy)
> >         dev_err(&client->dev, "no 'ti,usb-charger-detection' property\n=
");
> >     ret =3D PTR_ERR(bq->notify_psy);
> >     goto error_2;
> > }
>=20
> So you do not want to defer the probe? What if notified charger will
> come online after this probe?

No, but resources must be freed fore the EPROBE_DEFER case, too.
You are right, though, that my snipped does not setup the
EPROBE_DEFER return value correctly.

> Second idea - now I think my change is not compatible with bindings
> (documentation) and could break booting of existing boards which do not
> provide the "ti,usb-charger-detection" property. For example
> arch/arm/boot/dts/omap3-n900.dts
>
> The "ti,usb-charger-detection" property is marked as optional but my
> patch actually makes it required.
>=20
> It should be rather like this:
>=20
> if (IS_ERR(bq->notify_psy)) {
>     bq->notify_psy =3D NULL;
>     dev_info(&client->dev, "no 'ti,usb-charger-detection' property \n");
> } else if (!bq->notify_psy) {
>     ret =3D -EPROBE_DEFER;
>     goto error_2;
> }
>
> What do you think?

I thing the dev_info call should include the error code returned,
since its not propagated further:

dev_info(&client->dev, "no 'ti,usb-charger-detection' property (err=3D%d)\n=
",
         PTR_ERR(by->notify_psy));

Apart from that it looks fine to me. Can you send a v2?

> [...]

-- Sebastian

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUPn1uAAoJENju1/PIO/qaSQkP/1rycHAZ79h2rlx8XRdi1LpF
wHk7CXIu313BTLe4JmRwPoy5Q63NzmyMryB+hOehPgUNRIoJwrUcJ6mnUisg/MC3
l37pgnojxgZpPf7YMUkPN9W1KDJacceA04SZh1epqowv53GSGrXK3G9qAhiw3mHs
XY0ODxg93ZaW0RwRirr4sMHTYMaKR4FO+WZiMI0AyY6Scpr98jAEeZrIPVMh+ifS
tGklMor5+whIsY7drc0GJnlgKRs4eEdXr946hOYrYKMknpK/p/pOGkuyTpj1SQmI
hPpXa0exBJBgKLSOCJVPM67sqUZNtEiWEKbt7LjIPbBAkYhLKrW0TiQacTHbQtjR
hSL4XYellHEVB4n9jL/odtyDTxjxVKdua06h6d5DpexupxzU0cGJ6SQ2dgZY6JMs
GWJ7/2MHSQyZITJ1ZGuV7qMUkBt8+dcPIqWfwubjkwOcaLFBC+BRb6E1J7HK+hyg
VED1ycUZXCKtk4E0CS3wHkVDjZAkXUVvuKsU9YhyA4tT1Qey2NIxBMjJT42Zi8g9
QFOB29tPwqBUkUtKm3TrLxPDGKpFQnUJyyaNmHuXE9Cm5S+KhKLfcXXM+EApeHEf
h9+td1oJLW8/4UztbVY5wK5tXDxpdjTOKdSY6qklXlxwMUVlqoP14r6nWH80zy3s
eLZyq5ul3PJ2DXdvseCJ
=XsYw
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
