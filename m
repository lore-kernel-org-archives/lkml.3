Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaJCJ6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:58:08 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43451 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaJCJ6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:58:06 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 2/3] input: alps: For protocol V3, do not process data when last packet's bit7 is set
Date: Fri, 3 Oct 2014 11:58:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com> <1412329392-5580-3-git-send-email-pali.rohar@gmail.com> <542E719A.8030509@redhat.com>
In-Reply-To: <542E719A.8030509@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1979493.cdNC3VAOvc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201410031158.02134@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1979493.cdNC3VAOvc
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 03 October 2014 11:51:22 Hans de Goede wrote:
> Hi,
>=20
> On 10/03/2014 11:43 AM, Pali Roh=C3=A1r wrote:
> > Sometimes laptops with closed lid receive invalid ALPS
> > protocol V3 packets with last bit7 set.
> >=20
> > This happens on Dell Latitude laptops and it looks like it
> > is BIOS bug. Probably EC does not correctly split keyboard
> > and touchpad PS/2 data and when laptop lid is closed it
> > adds 0xFF packet into touchpad PS/2 data.
> >=20
> > When last packet's bit7 is set it is invalid ALPS packet. So
> > Do not process it and drop it with PSMOUSE_FULL_PACKET.
> >=20
> > After testing it looks like this patch fixed problem with
> > reseting mouse (after series of invalid packets) when
> > laptop lid is closed on Dell Latitude machines.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > Tested-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> >=20
> >  drivers/input/mouse/alps.c |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >=20
> > diff --git a/drivers/input/mouse/alps.c
> > b/drivers/input/mouse/alps.c index 1bd5aa1..b1f44d4 100644
> > --- a/drivers/input/mouse/alps.c
> > +++ b/drivers/input/mouse/alps.c
> > @@ -1179,6 +1179,16 @@ static psmouse_ret_t
> > alps_process_byte(struct psmouse *psmouse)
> >=20
> >  		return PSMOUSE_BAD_DATA;
> >  =09
> >  	}
> >=20
> > +	if (priv->proto_version =3D=3D ALPS_PROTO_V3 &&
> > psmouse->pktcnt =3D=3D psmouse->pktsize) { +		// For protocol
> > V3, do not process data when last packet's bit7 is set
> > +		if (psmouse->packet[psmouse->pktcnt - 1] & 0x80) {
> > +			psmouse_dbg(psmouse, "v3 discard packet[%i] =3D=20
%x\n",
> > +				    psmouse->pktcnt - 1,
> > +				    psmouse->packet[psmouse->pktcnt - 1]);
> > +			return PSMOUSE_FULL_PACKET;
> > +		}
> > +	}
> > +
>=20
> I wonder if this should not be PSMOUSE_BAD_DATA as a return
> value ? I realize that with the 3th patch in place, that will
> cause an immediate reset, but if your theory is right that
> this ff gets inserted from the keyboard ps/2 stream, then we
> actually want a full reset as otherwise we will be out of
> sync then.
>=20

We really do not know what is root cause of this problem.=20
Probably it is BIOS/EC/firmware/... but it could be something=20
other too.

On my laptop - Dell Latitude E6440 - I'm getting these invalid=20
packets when I close LID. And they are generated too many (lot of=20
per second). When PSMOUSE_FULL_PACKET is returned then no driver=20
does not reset touchpad. With PSMOUSE_BAD_DATA psmouse decide=20
that it needs reset and with 3rd patch psmouse could try to reset=20
device too many times... So I think PSMOUSE_FULL_PACKET is better=20
here. And having dmesg log full of device resets is probably not=20
good too when laptop lid is closed.

> >  	/* Bytes 2 - pktsize should have 0 in the highest bit */
> >  	if ((priv->proto_version < ALPS_PROTO_V5) &&
> >  =09
> >  	    psmouse->pktcnt >=3D 2 && psmouse->pktcnt <=3D
> >  	    psmouse->pktsize &&
>=20
> Regards,
>=20
> Hans

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1979493.cdNC3VAOvc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlQucyoACgkQi/DJPQPkQ1IwtACguBsaGmdYa+x6VuZodJL3hOfo
8YoAn3F17ws+hz9jsCyVKGDyjrpbBJTQ
=gqCZ
-----END PGP SIGNATURE-----

--nextPart1979493.cdNC3VAOvc--
