Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaKJJSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:18:46 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:65112 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaKJJSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:18:43 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v3 3/4] input: alps: For protocol V3, do not process data when last packet's bit7 is set
Date: Mon, 10 Nov 2014 10:18:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com> <201411091222.59595@pali> <20141109203459.GB37384@dtor-ws>
In-Reply-To: <20141109203459.GB37384@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1491676.ncpUQqPPFe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411101018.40451@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1491676.ncpUQqPPFe
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 09 November 2014 21:34:59 Dmitry Torokhov wrote:
> On Sun, Nov 09, 2014 at 12:22:51PM +0100, Pali Roh=C3=A1r wrote:
> > On Sunday 09 November 2014 08:50:39 Dmitry Torokhov wrote:
> > > Hi Pali,
> > >=20
> > > On Sun, Nov 02, 2014 at 12:25:09AM +0100, Pali Roh=C3=A1r wrote:
> > > > Sometimes on Dell Latitude laptops psmouse/alps driver
> > > > receive invalid ALPS protocol V3 packets with bit7 set
> > > > in last byte. More often it can be reproduced on Dell
> > > > Latitude E6440 or E7440 with closed lid and pushing
> > > > cover above touchpad.
> > > >=20
> > > > If bit7 in last packet byte is set then it is not valid
> > > > ALPS packet. I was told that ALPS devices never send
> > > > these packets. It is not know yet who send those
> > > > packets, it could be Dell EC, bug in BIOS and also bug
> > > > in touchpad firmware...
> > > >=20
> > > > With this patch alps driver does not process those
> > > > invalid packets and drops it with PSMOUSE_FULL_PACKET
> > > > so psmouse driver does not enter to out of sync state.
> > > >=20
> > > > This patch fix problem when psmouse driver still
> > > > resetting ALPS device when laptop lid is closed because
> > > > of receiving invalid packets in out of sync state.
> > > >=20
> > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > > Tested-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > >=20
> > > >  drivers/input/mouse/alps.c |   10 ++++++++++
> > > >  1 file changed, 10 insertions(+)
> > > >=20
> > > > diff --git a/drivers/input/mouse/alps.c
> > > > b/drivers/input/mouse/alps.c index 7c47e97..e802d28
> > > > 100644 --- a/drivers/input/mouse/alps.c
> > > > +++ b/drivers/input/mouse/alps.c
> > > > @@ -1181,6 +1181,16 @@ static psmouse_ret_t
> > > > alps_process_byte(struct psmouse *psmouse)
> > > >=20
> > > >  		return PSMOUSE_BAD_DATA;
> > > >  =09
> > > >  	}
> > > >=20
> > > > +	if (priv->proto_version =3D=3D ALPS_PROTO_V3 &&
> > > > psmouse->pktcnt =3D=3D psmouse->pktsize) { +		// For
> > > > protocol V3, do not process data when last packet's
> > > > bit7 is set +		if (psmouse->packet[psmouse->pktcnt -=20
1]
> > > > & 0x80) { +			psmouse_dbg(psmouse, "v3 discard
> > > > packet[%i] =3D
> >=20
> > %x\n",
> >=20
> > > > +				    psmouse->pktcnt - 1,
> > > > +				    psmouse->packet[psmouse->pktcnt - 1]);
> > > > +			return PSMOUSE_FULL_PACKET;
> > > > +		}
> > > > +	}
> > >=20
> > > I wanted to apply it, but I would like some more data.
> > > Could you please send me the dmesg with i8042.debug wit
> > > this patch in place?
> > >=20
> > > Thanks!
> >=20
> > See attachment. It contains debug log from both
> > i8042.debug=3D1 and psmouse.ko with applied all 4 patches.
>=20
> Thank you Pali.
>=20
> OK, so it looks like the problematic byte is the last one and
> we should be resynching right away. With your other patch
> increasing number of bad packets before issuing resync this
> special handling is no longer needed, right?
>=20
> Thanks.

Problem is that in this special case driver is still out-of-sync=20
and cause problems. E.g there is big dmesg flood and it is not=20
good to have that when LID is closed for a long time.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1491676.ncpUQqPPFe
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRggvAACgkQi/DJPQPkQ1KZVwCcDRUzeln/p9eTCSwbtfDN0kVj
M0YAn2BbDw7n1WMkmJt7vjX0nteiDd9J
=xHri
-----END PGP SIGNATURE-----

--nextPart1491676.ncpUQqPPFe--
