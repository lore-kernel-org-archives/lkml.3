Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaKJEq3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:46:29 -0500
Received: from ozlabs.org ([103.22.144.67]:44644 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaKJEq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:46:28 -0500
Date: Mon, 10 Nov 2014 15:46:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the tty tree with the tip tree
Message-ID: <20141110154621.3adab2e4@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/xs0HBTwXnmDRG=HnwmiB3b."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/xs0HBTwXnmDRG=HnwmiB3b.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/n_tty.c between commit 97d9e28d1a27 ("sched, tty: Deal with
nested sleeps") from the tip tree and commits 1aa1bf111527 ("tty: Fix
missed wakeup from packet mode status update") and 52bce7f8d4fc ("pty,
n_tty: Simplify input processing on final close") from the tty tree.

I fixed it up (I hope - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/n_tty.c
index 26f097f60b10,112eda7c56bc..000000000000
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@@ -2193,46 -2197,30 +2192,30 @@@ static ssize_t n_tty_read(struct tty_st
 =20
  		if (!input_available_p(tty, 0)) {
  			if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
- 				up_read(&tty->termios_rwsem);
- 				tty_flush_to_ldisc(tty);
- 				down_read(&tty->termios_rwsem);
- 				if (!input_available_p(tty, 0)) {
- 					retval =3D -EIO;
- 					break;
- 				}
- 			} else {
- 				if (tty_hung_up_p(file))
- 					break;
- 				if (!timeout)
- 					break;
- 				if (file->f_flags & O_NONBLOCK) {
- 					retval =3D -EAGAIN;
- 					break;
- 				}
- 				if (signal_pending(current)) {
- 					retval =3D -ERESTARTSYS;
- 					break;
- 				}
- 				n_tty_set_room(tty);
- 				up_read(&tty->termios_rwsem);
-=20
- 				timeout =3D wait_woken(&wait, TASK_INTERRUPTIBLE,
- 						     timeout);
-=20
- 				down_read(&tty->termios_rwsem);
- 				continue;
+ 				retval =3D -EIO;
+ 				break;
  			}
- 		}
-=20
- 		/* Deal with packet mode. */
- 		if (packet && b =3D=3D buf) {
- 			if (tty_put_user(tty, TIOCPKT_DATA, b++)) {
- 				retval =3D -EFAULT;
- 				b--;
+ 			if (tty_hung_up_p(file))
+ 				break;
+ 			if (!timeout)
+ 				break;
+ 			if (file->f_flags & O_NONBLOCK) {
+ 				retval =3D -EAGAIN;
  				break;
  			}
- 			nr--;
+ 			if (signal_pending(current)) {
+ 				retval =3D -ERESTARTSYS;
+ 				break;
+ 			}
+ 			n_tty_set_room(tty);
+ 			up_read(&tty->termios_rwsem);
+=20
 -			timeout =3D schedule_timeout(timeout);
++			timeout =3D wait_woken(&wait, TASK_INTERRUPTIBLE,
++					     timeout);
+=20
+ 			down_read(&tty->termios_rwsem);
+ 			continue;
  		}
 -		__set_current_state(TASK_RUNNING);
 =20
  		if (ldata->icanon && !L_EXTPROC(tty)) {
  			retval =3D canon_copy_from_read_buf(tty, &b, &nr);

--Sig_/xs0HBTwXnmDRG=HnwmiB3b.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYEMhAAoJEMDTa8Ir7ZwVYEMP/08lDPOx/ABrzo0zN4XOAHXG
7w0xOzj6F+oB7Gdf277P4Un61U49GqtQkt2hoinLHCHbwg70hHwozwBpm08y1HJO
H0rapLyHq5FmI0KpeQikTj1eMzJcQ17qZKa5mCX7kILZ/J/Svlv9Upw6g5y8wyB1
WO1pFWgaao9L7nkc0pTMxbsPPfshh832lFsiiIQEHFR/Wx6Pg2s18Be+qcyDupTH
SoLLPWQtwaMpBI0Co6kN7a7P6yrETZLC4LT05KI1LwgdcxwkVDlHX2YUNeNgHZE+
xlBv3NciM4Tz93QVNj5HehzT8pRhjVHOyYXPgDixVRSGjAq4hF/ejvWG44hixMJ1
FN6zvgXnCJ46NhkOINaNHDzfc4XcM+pUfQEoIm2Fz7QeaKgTyYcnNkHW5zrEWrKV
AkgQ85AJfK3OReNTVr7QSXnQlaPBCwNtzb4vHiBiW9VSTdNQuVMqiiGGXsI3F0jU
SccQ5+fXcv3g4Bv0mYX8o5vur+4E9oru6HPXFHd24DkQdE6pvoO6PV5xEMPmUuL3
bInVTqSOg5ooLmxQYJSQAk9Bt+pbOt5zd8AvignU0nrsurGwnST3iHnNetC7vl2N
eFUcrbmxk6dzgw0NBj7qu4VAeDXxHETkrbdRuPj0bmuZzl7e39FS7iKGhXThcTnZ
JrUGXVa18/EqVXyqYH59
=47S3
-----END PGP SIGNATURE-----

--Sig_/xs0HBTwXnmDRG=HnwmiB3b.--
