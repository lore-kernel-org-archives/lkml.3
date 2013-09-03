Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253Ab3ICVND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:13:03 -0400
Received: from nereida.gnuservers.com.ar ([207.192.69.134]:57350 "EHLO
	nereida.gnuservers.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761208Ab3ICVNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:13:01 -0400
Date: Tue, 3 Sep 2013 23:12:53 +0200
From: Maximiliano Curia <maxy@gnuservers.com.ar>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Margarita Manterola <margamanterola@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
Message-ID: <20130903211253.GA22253@gnuservers.com.ar>
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com>
 <51F1B015.50804@hurleysoftware.com>
 <20130730124117.41DC55E4006@freak.gnuservers.com.ar>
 <51F7E4ED.4050409@hurleysoftware.com>
 <20130808175839.GB21618@gnuservers.com.ar>
 <52120EAE.5060906@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <52120EAE.5060906@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=A1Hola Peter!

El 2013-08-19 a las 08:25 -0400, Peter Hurley escribi=F3:
> My primary concern is canonical readers not become stuck with a full
> read buffer, even with bogus input data (IOW, that an error condition will
> not prevent a reader from making forward progress). I believe that won't
> happen with this change, but what I really need in this case is a detailed
> analysis from you of why that won't happen. That analysis should be in
> the patch changelog. (Feel free to send me private mail if you need help
> preparing a patch.)

I'm not sure what level of analysis you are looking for. The driver will bl=
ock
when there are no readers but as soon as there is a read call it unblocks.
I've added this information to the patch description that I'm including bel=
ow.

> And the patch above has a bug that allows a negative 'left' to be
> assigned to tty->receive_room which will be interpreted as a very large
> positive value.

Ok, fixed with an else clause. It could also use an extra &&, but it looks a
bit confusing.

> This approach still has several drawbacks.

> 1) Since additional state is reset when the termios is changed by
> readline(), the canonical line buffer state will be bogus.
> This renders the termios change by readline() pointless; the
> caller will not be able to retrieve expected input properly.

> 2) Since the input data is interpreted with the current termios when
> data is received, any embedded control characters will not be
> interpreted properly; again, the caller will not be able to retrieve
> expected input properly.

Indeed this is correct, however this is not an issue of this patch but of t=
he
current interaction between the kernel and readline. In order to fix this, =
the
reading buffer should always be in raw and only when responding to a read c=
all
for canonical mode should it be interpreted. This is a very big change, and
I'm not sure if anybody will be interested in implementing it.

> >What do you think? Is the proposed solution, or something along those li=
nes,
> >acceptable?

> I'm wondering if this problem might be best addressed on the paste side
> instead of the read side. Although this wouldn't be a magic bullet, it
> would be easier to control when more paste data is added.

I don't see how this could work, could you elaborate?

This is the patch proposal, for comments:

=46rom 81afd3b666cbf94bb9923ebf87fb2017a7cd645e Mon Sep 17 00:00:00 2001
=46rom: Maximiliano Curia <maxy@gnuservers.com.ar>
Date: Tue, 3 Sep 2013 22:48:34 +0200
Subject: [PATCH] Only let characters through when there are active readers.

If there is an active reader, previous behavior is in place. When there is =
no
active reader, input is blocked until the next read call unblocks it.

This fixes a long standing issue with readline when pasting more than 4096
bytes.
---
 drivers/tty/n_tty.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 4bf0fc0..cdc3b19 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -147,9 +147,16 @@ static int set_room(struct tty_struct *tty)
 	 * pending newlines, let characters through without limit, so
 	 * that erase characters will be handled.  Other excess
 	 * characters will be beeped.
+	 * If there is no reader waiting for the input, block instead of
+	 * letting the characters through.
 	 */
 	if (left <=3D 0)
-		left =3D ldata->icanon && !ldata->canon_data;
+		if (waitqueue_active(&tty->read_wait)) {
+			left =3D ldata->icanon && !ldata->canon_data;
+		} else {
+			left =3D 0;
+		}
+
 	old_left =3D tty->receive_room;
 	tty->receive_room =3D left;
=20
--=20
1.8.4.rc3


--=20
"Always code as if the person who ends up maintaining your code is a violent
psychopath who knows where you live."
-- John Woods
Saludos /\/\ /\ >< `/

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJSJlDVAAoJEMcZdpmymyMqeLoP/2Dd9JuGo/HwncOxXFNi+s1A
iBFZ0UBttERo19Dkho6/eaFJzrsAx4ohS657Qubb0wpdIuO+kGCc9ZUk2OswsVfg
Qf0Y8pkfDuw8UzDdl7rmu3P5VAuawTTXm+XjhoJeWq1ItY9f371TUG56ll67/gRw
l1jo9LVaQqn0osssscC8eBgsYAQpma/ZDdQpbks3/JtYyJatyqgx/wNKyPgGYdqt
TmstbwKsoyRxv/haOfgDf8AjkIWS8mL8z9WX0z/VeBSn9R6rgkKrQVDlw255KEGI
WLwA5DmGUpazSn++HM3mqh789SIx16+G+EDxqYNx6W8B1ps550Y83rZKyNtDGu+Y
0HNxGNdYMfrVs7D1KRnkCYI8F+4RzxWEbHGGhbdVm7Cl6wwVdb18m7jOwa53xC1g
bkTwORLbFAUhVPWDGEyHXt+hMzk+yr9/m5opHyFPtxYzpl+ny0tnMoVlgc10mVH7
XDEJbAxTrPlGfG2AUn5qS0GiCcDOCy2O+45z3VP82PP17eXluvLvEjiCW/o/Tqjo
zpuBkHOCUouHk9yNLxOBhNLwKx/4EI+Q7VvuBKpzfOWU1oOOTbAX0Jp3pSapplIg
Onf3xWzqqu/A/WvX9HzTCqWSBl0GvtTl7gl9goXRWwM8bbApZEukPoYVtAhotIO7
6H7RG5vdvcROwOMvqJ7j
=2K3n
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
