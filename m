Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbbAHR6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:58:40 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54939 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbbAHR6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:58:38 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/7] input: alps: Set correct name of psmouse device in alps_init()
Date: Thu, 8 Jan 2015 18:58:28 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>, Vadim Klishko <vadim@cirque.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com> <201412200953.38259@pali> <201412240848.43326@pali>
In-Reply-To: <201412240848.43326@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart38419432.9bFeF9RtOn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501081858.28807@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart38419432.9bFeF9RtOn
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 24 December 2014 08:48:42 Pali Roh=C3=A1r wrote:
> On Saturday 20 December 2014 09:53:38 Pali Roh=C3=A1r wrote:
> > On Tuesday 16 December 2014 12:58:20 Pali Roh=C3=A1r wrote:
> > > On Tuesday 16 December 2014 06:02:34 Dmitry Torokhov wrote:
> > > > Hi Pali,
> > > >=20
> > > > On Fri, Nov 14, 2014 at 08:38:20PM +0100, Pali Roh=C3=A1r=20
wrote:
> > > > > On some laptops after starting them from off state
> > > > > (not after reboot), function
> > > > > alps_probe_trackstick_v3() (called from function
> > > > > alps_identify()) does not detect trackstick. To fix
> > > > > this problem we need to reset device. But function
> > > > > alps_identify() is called also from alps_detect() and
> > > > > we do not want to reset device in detect function
> > > > > because it will slow down
> > > > > initialization of all other non alps devices.
> > > > >=20
> > > > > This patch moves code for setting correct device name
> > > > > & protocol from function alps_detect() to alps_init()
> > > > > which already doing full device reset.
> > > > >=20
> > > > > So this patch removes need to do trackstick detection
> > > > > in alps_detect() function.
> > > > >=20
> > > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > > > ---
> > > > >=20
> > > > >  drivers/input/mouse/alps.c |   17 ++++++++++++++---
> > > > >  1 file changed, 14 insertions(+), 3 deletions(-)
> > > > >=20
> > > > > diff --git a/drivers/input/mouse/alps.c
> > > > > b/drivers/input/mouse/alps.c index 8d85c79..9ffa98d
> > > > > 100644 --- a/drivers/input/mouse/alps.c
> > > > > +++ b/drivers/input/mouse/alps.c
> > > > > @@ -2392,6 +2392,10 @@ int alps_init(struct psmouse
> > > > > *psmouse)
> > > > >=20
> > > > >  	if (input_register_device(priv->dev2))
> > > > >  =09
> > > > >  		goto init_fail;
> > > > >=20
> > > > > +	if (!(priv->flags & ALPS_DUALPOINT))
> > > > > +		psmouse->name =3D "GlidePoint TouchPad";
> > > > > +	psmouse->model =3D priv->proto_version;
> > > > > +
> > > > >=20
> > > > >  	psmouse->protocol_handler =3D alps_process_byte;
> > > > >  	psmouse->poll =3D alps_poll;
> > > > >  	psmouse->disconnect =3D alps_disconnect;
> > > > >=20
> > > > > @@ -2422,11 +2426,18 @@ int alps_detect(struct psmouse
> > > > > *psmouse, bool set_properties)
> > > > >=20
> > > > >  		return -1;
> > > > >  =09
> > > > >  	if (set_properties) {
> > > > >=20
> > > > > +		/*
> > > > > +		 * NOTE: To detect model and trackstick=20
presence we
> > >=20
> > > need
> > >=20
> > > > > to do +		 *       full device reset. To speed up
> > >=20
> > > detection
> > >=20
> > > > > and prevent +		 *       calling duplicate
> >=20
> > initialization
> >=20
> > > > > sequence (both in +		 *       alps_detect() and
> > > > > alps_init()) we set model/protocol +		 *      =20
version
> >=20
> > and
> >=20
> > > > > correct name in alps_init() (which will +		 *
>=20
> do
>=20
> > > full
> > >=20
> > > > > device reset). For now set name to DualPoint. +		 */
> > > > >=20
> > > > >  		psmouse->vendor =3D "ALPS";
> > > > >=20
> > > > > -		psmouse->name =3D dummy.flags & ALPS_DUALPOINT ?
> > > > > -				"DualPoint TouchPad" : "GlidePoint";
> > > > > -		psmouse->model =3D dummy.proto_version << 8;
> > > > > +		psmouse->name =3D "DualPoint TouchPad";
> > > > >=20
> > > > >  	}
> > > > >=20
> > > > > +
> > > >=20
> > > > I do not quite like the way we change the device
> > > > description back and forth. Do you think we could
> > > > allocate the "real" priv structure in alps_detect() and
> > > > have alps_init() expect to find it (and free it if
> > > > set_properties is false). This way we'd go through
> > > > initialization once in detect, it will be authoritative,
> > > > and we would set the name of the device properly from
> > > > the beginning.
> > > >=20
> > > > Thanks.
> > >=20
> > > No without introducing another psmouse_reset call. I want
> > > to reduce time of loading driver, so I think this is
> > > better.
> >=20
> > Also psmouse-base.c call psmouse_reset between alps_detect()
> > and alps_init(). We must do trackstick detection after
> > psmouse_reset, but intorducing another psmouse_reset in
> > alps_detect() will slow down initialization for ALPS
> > devices. Also do not remember that psmouse_reset will lock
> > both keyboard & mouse for one second (sometimes for two) on
> > my laptop. I played with this and I think my patch is good
> > approach how to do trackstick detection without slowdown or
> > other side effects.
> >=20
> > Also we do not need to know if ALPS touchpad has trackstick
> > device in alps_detect() phase. In alps_detect() we just need
> > to know if PS/2 device is ALPS or not. From psmouse/serio
> > point of view there is only one ALPS device on PS/2/i8042
> > bus. Just alps.ko driver parse PS/2 packets and detect which
> > packet has touchpad header and which trackpoint. So we
> > really do not need to know if trackstick is there or not in
> > alps_detect() function.
>=20
> Dmitry ping, can you finally review this patch series? I it
> there for more then month...

Dmitry ping, see ^^^^^

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart38419432.9bFeF9RtOn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSuxUQACgkQi/DJPQPkQ1IBBACfXPEsL8FfnCY5zr7HYtvx+t4A
oqEAoIauVOdR1Fpd3lkOq9s/6S3Rjowh
=HIjO
-----END PGP SIGNATURE-----

--nextPart38419432.9bFeF9RtOn--
