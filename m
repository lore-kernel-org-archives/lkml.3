Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751124AbaLPL60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:58:26 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61576 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaLPL6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:58:24 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/7] input: alps: Set correct name of psmouse device in alps_init()
Date: Tue, 16 Dec 2014 12:58:20 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.2; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>, Vadim Klishko <vadim@cirque.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com> <1415993906-13307-2-git-send-email-pali.rohar@gmail.com> <20141216050234.GA35408@dtor-ws>
In-Reply-To: <20141216050234.GA35408@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3568061.04uXEs5byY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412161258.20925@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3568061.04uXEs5byY
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 16 December 2014 06:02:34 Dmitry Torokhov wrote:
> Hi Pali,
>=20
> On Fri, Nov 14, 2014 at 08:38:20PM +0100, Pali Roh=C3=A1r wrote:
> > On some laptops after starting them from off state (not
> > after reboot), function alps_probe_trackstick_v3() (called
> > from function alps_identify()) does not detect trackstick.
> > To fix this problem we need to reset device. But function
> > alps_identify() is called also from alps_detect() and we do
> > not want to reset device in detect function because it will
> > slow down initialization of all other non alps devices.
> >=20
> > This patch moves code for setting correct device name &
> > protocol from function alps_detect() to alps_init() which
> > already doing full device reset.
> >=20
> > So this patch removes need to do trackstick detection in
> > alps_detect() function.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> >=20
> >  drivers/input/mouse/alps.c |   17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/input/mouse/alps.c
> > b/drivers/input/mouse/alps.c index 8d85c79..9ffa98d 100644
> > --- a/drivers/input/mouse/alps.c
> > +++ b/drivers/input/mouse/alps.c
> > @@ -2392,6 +2392,10 @@ int alps_init(struct psmouse
> > *psmouse)
> >=20
> >  	if (input_register_device(priv->dev2))
> >  =09
> >  		goto init_fail;
> >=20
> > +	if (!(priv->flags & ALPS_DUALPOINT))
> > +		psmouse->name =3D "GlidePoint TouchPad";
> > +	psmouse->model =3D priv->proto_version;
> > +
> >=20
> >  	psmouse->protocol_handler =3D alps_process_byte;
> >  	psmouse->poll =3D alps_poll;
> >  	psmouse->disconnect =3D alps_disconnect;
> >=20
> > @@ -2422,11 +2426,18 @@ int alps_detect(struct psmouse
> > *psmouse, bool set_properties)
> >=20
> >  		return -1;
> >  =09
> >  	if (set_properties) {
> >=20
> > +		/*
> > +		 * NOTE: To detect model and trackstick presence we=20
need
> > to do +		 *       full device reset. To speed up=20
detection
> > and prevent +		 *       calling duplicate initialization
> > sequence (both in +		 *       alps_detect() and
> > alps_init()) we set model/protocol +		 *       version and
> > correct name in alps_init() (which will +		 *       do=20
full
> > device reset). For now set name to DualPoint. +		 */
> >=20
> >  		psmouse->vendor =3D "ALPS";
> >=20
> > -		psmouse->name =3D dummy.flags & ALPS_DUALPOINT ?
> > -				"DualPoint TouchPad" : "GlidePoint";
> > -		psmouse->model =3D dummy.proto_version << 8;
> > +		psmouse->name =3D "DualPoint TouchPad";
> >=20
> >  	}
> >=20
> > +
>=20
> I do not quite like the way we change the device description
> back and forth. Do you think we could allocate the "real"
> priv structure in alps_detect() and have alps_init() expect
> to find it (and free it if set_properties is false). This way
> we'd go through initialization once in detect, it will be
> authoritative, and we would set the name of the device
> properly from the beginning.
>=20
> Thanks.

No without introducing another psmouse_reset call. I want to=20
reduce time of loading driver, so I think this is better.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3568061.04uXEs5byY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSQHlwACgkQi/DJPQPkQ1LkngCdH/HD4GdTkX6oHY63evmGw2rD
8rQAoI8uJZ1IZwpyxGBd1WO8npsr5VOn
=f9jj
-----END PGP SIGNATURE-----

--nextPart3568061.04uXEs5byY--
