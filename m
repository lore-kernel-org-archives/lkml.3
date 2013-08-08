Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966057Ab3HHSHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:07:08 -0400
Received: from nereida.gnuservers.com.ar ([207.192.69.134]:42281 "EHLO
	nereida.gnuservers.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3HHSHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:07:00 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2013 14:07:00 EDT
Date: Thu, 8 Aug 2013 19:58:39 +0200
From: Maximiliano Curia <maxy@debian.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Margarita Manterola <margamanterola@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
Message-ID: <20130808175839.GB21618@gnuservers.com.ar>
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com>
 <51F1B015.50804@hurleysoftware.com>
 <20130730124117.41DC55E4006@freak.gnuservers.com.ar>
 <51F7E4ED.4050409@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <51F7E4ED.4050409@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> n_tty_set_room() in drivers/tty/n_tty.c (3.10 mainline)

> From n_tty_set_room():

> 	/*
> 	 * If we are doing input canonicalization, and there are no
> 	 * pending newlines, let characters through without limit, so
> 	 * that erase characters will be handled.  Other excess
> 	 * characters will be beeped.
> 	 */
> 	if (left <=3D 0)
> 		left =3D ldata->icanon && !ldata->canon_data;
> 	old_left =3D tty->receive_room;
> 	tty->receive_room =3D left;

I took a long look at this code and thought about how it could be made to w=
ork
for readline's case and also for the canonical readers.  I came up with this
simple patch:

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 4bf0fc0..2ba7f4e 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -149,7 +149,8 @@ static int set_room(struct tty_struct *tty)
         * characters will be beeped.
         */
        if (left <=3D 0)
-               left =3D ldata->icanon && !ldata->canon_data;
+               if (waitqueue_active(&tty->read_wait))
+                       left =3D ldata->icanon && !ldata->canon_data;
        old_left =3D tty->receive_room;
        tty->receive_room =3D left;

This is of course just an idea, but I tested this and it worked correctly f=
or
the cases I was testing.

The effect of this patch is that when there is a canonical reader waiting f=
or
input, it maintains the previous behavior, but when there's no reader (like
when readline is changing modes), it blocks and doesn't lose any characters.

Another approach would be to recalculate the size of canon_data when the mo=
de
is changed, but this would probably be much more invasive, and awfully less
efficient since it would imply going through the buffer.

What do you think? Is the proposed solution, or something along those lines,
acceptable?

If there are other cases that need to be taken into account and that I
currently don't know about, please let me know.

--=20
"If you think your users are idiots, only idiots will use it."
-- Linus Torvalds
Saludos /\/\ /\ >< `/

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJSA9xOAAoJEMcZdpmymyMqqKAQAKOdlZujej9YRw6QZONBfGul
VW7tCuzfUM0i0ozY76Y6JQQPcBVTe639GPGosRk4+vSAl1WZcqcPQ9WN3Y8u8rL8
pu09M7Omg6ccuC6kGGvlpLYmsBELsgB9zCs7izEMaVBMzL4un2/g7L2HqFhK2WhU
21AKTQ0l3pxqSun4sLfiOnKvuusPikr+ZORIW7PJRQwxBEaBmEfhD0lq38mpajeu
rEK+Tm9vP3uOqtJlkFoCvQW5VsYpxst3Sb18elCA/GshWysanNGMcV4cbwljORH3
+OxR15mlaTS6UnM5P5owQVlGCROmssjY3HCMKOP6hwtCmAWpViNjwSXFY/Vcie3d
4I+fmRKzVMiu8fHqgr/qcsocGx2KFJECLAffegj8Q+2v4k0M9KncQiO5F8e96ccS
rboaesEHeJ+5s0hFyNGZT/CQ5R3a+eEde6DWDIra7xfweYZuUQCEKjxwtVrMBev0
KxiCpscR6FnzRP6r19pPJiQk6VPoSLRmJPWoaXavyy107TTug60lkvzvKDoBXxwp
0z1rnzDz3+8Mzh8Iw7MeEj05pWpAi1Ey7+Ls81a62J+VJib8pmIz+WSJMDV0vgLN
HSMRDYepmnDhpTXLCKBbu6wPdJCJgDNG0stI0WwI3n6ne3PR15ydHF8UNxaaKta+
5akk754ksTFBd06H+aff
=jeSh
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
