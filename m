Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaKILaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 06:30:11 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47069 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaKILaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 06:30:09 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v3 4/4] input: alps: Fix trackstick detection
Date: Sun, 9 Nov 2014 12:30:03 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com> <1414884310-19842-5-git-send-email-pali.rohar@gmail.com> <20141109080504.GB34700@dtor-ws>
In-Reply-To: <20141109080504.GB34700@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3778126.RZHr1kPRq9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411091230.05337@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3778126.RZHr1kPRq9
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 09 November 2014 09:05:04 Dmitry Torokhov wrote:
> Hi Pali,
>=20
> On Sun, Nov 02, 2014 at 12:25:10AM +0100, Pali Roh=C3=A1r wrote:
> >  int alps_detect(struct psmouse *psmouse, bool
> >  set_properties) {
> >=20
> > -	struct alps_data dummy;
> > +	unsigned char e6[4];
> >=20
> > -	if (alps_identify(psmouse, &dummy) < 0)
> > -		return -1;
> > +	/*
> > +	 * Try "E6 report".
> > +	 * ALPS should return 0,0,10 or 0,0,100 if no buttons are
> > pressed. +	 * The bits 0-2 of the first byte will be 1s if
> > some buttons are +	 * pressed.
> > +	 */
> > +	if (alps_rpt_cmd(psmouse, PSMOUSE_CMD_SETRES,
> > +			 PSMOUSE_CMD_SETSCALE11, e6))
> > +		return -EIO;
> > +
> > +	if ((e6[0] & 0xf8) !=3D 0 || e6[1] !=3D 0 || (e6[2] !=3D 10 &&
> > e6[2] !=3D 100)) +		return -EINVAL;
> >=20
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
> >=20
> >  	return 0;
>=20
> We can't do this; going by e6 only will give us false
> positives and alps_detect is supposed to be authoritative.
>=20
> Thanks.

psmouse-base.c is calling alps_detect() and alps_init()=20
consecutively so it does not matter if code is in _detect or=20
_init function. Just need to make sure that correct order will be=20
used. So this patch could not bring any problems.

If psmouse-base.c detect device false-positive as ALPS (with=20
alps_detect()) then it immediately calls alps_init() which fails=20
and psmouse-base.c will try to use another protocol.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3778126.RZHr1kPRq9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRfUD0ACgkQi/DJPQPkQ1JRsQCcDLZLSjfwk0I/NyUmFIUnU3az
5gsAn3M15js4KkJewDDe5v0zxAmbVkWV
=SF4u
-----END PGP SIGNATURE-----

--nextPart3778126.RZHr1kPRq9--
