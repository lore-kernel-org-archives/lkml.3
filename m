Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3BKFh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 00:37:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48837 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3BKFh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 00:37:26 -0500
Date: Mon, 11 Feb 2013 16:37:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Jiri Slaby <jslaby@suse.cz>, Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the char-misc tree with the tty tree
Message-Id: <20130211163714.289cb3288ed5098c7b493af3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Feb_2013_16_37_14_+1100_I0eiv6YlZJPsro4y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Feb_2013_16_37_14_+1100_I0eiv6YlZJPsro4y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
drivers/char/pcmcia/synclink_cs.c between commits 2e124b4a390c ("TTY:
switch tty_flip_buffer_push") and 9fe8074b82ed ("TTY: synclink: Convert + to
| for bit operations") from the tty tree and commit 3d55399391c8 ("pcmcia: =
synclink_cs: cleanup checkpatch warnings") from the char-misc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/char/pcmcia/synclink_cs.c
index d0c9852,29f6bec..0000000
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@@ -765,8 -771,11 +771,8 @@@ static void bh_handler(struct work_stru
  	struct tty_struct *tty;
  	int action;
 =20
 -	if (!info)
 -		return;
 -
  	if (debug_level >=3D DEBUG_LEVEL_BH)
- 		printk( "%s(%d):bh_handler(%s) entry\n",
+ 		printk("%s(%d):bh_handler(%s) entry\n",
  			__FILE__,__LINE__,info->device_name);
 =20
  	info->bh_running =3D true;
@@@ -889,8 -898,16 +896,8 @@@ static void rx_ready_async(MGSLPC_INFO=20
  	unsigned char data, status, flag;
  	int fifo_count;
  	int work =3D 0;
-  	struct mgsl_icount *icount =3D &info->icount;
+ 	struct mgsl_icount *icount =3D &info->icount;
 =20
 -	if (!tty) {
 -		/* tty is not available anymore */
 -		issue_command(info, CHA, CMD_RXRESET);
 -		if (debug_level >=3D DEBUG_LEVEL_ISR)
 -			printk("%s(%d):rx_ready_async(tty=3DNULL)\n", __FILE__, __LINE__);
 -		return;
 -	}
 -
  	if (tcd) {
  		/* early termination, get FIFO count from RBCL register */
  		fifo_count =3D (unsigned char)(read_reg(info, CHA+RBCL) & 0x1f);
@@@ -1342,8 -1359,8 +1349,8 @@@ static void shutdown(MGSLPC_INFO * info
  	/* TODO:disable interrupts instead of reset to preserve signal states */
  	reset_device(info);
 =20
-  	if (!tty || tty->termios.c_cflag & HUPCL) {
+ 	if (!tty || tty->termios.c_cflag & HUPCL) {
 -		info->serial_signals &=3D ~(SerialSignal_DTR + SerialSignal_RTS);
 +		info->serial_signals &=3D ~(SerialSignal_RTS | SerialSignal_DTR);
  		set_signals(info);
  	}
 =20
@@@ -1405,12 -1422,12 +1412,12 @@@ static void mgslpc_change_params(MGSLPC
 =20
  	cflag =3D tty->termios.c_cflag;
 =20
 -	/* if B0 rate (hangup) specified then negate DTR and RTS */
 -	/* otherwise assert DTR and RTS */
 +	/* if B0 rate (hangup) specified then negate RTS and DTR */
 +	/* otherwise assert RTS and DTR */
-  	if (cflag & CBAUD)
+ 	if (cflag & CBAUD)
 -		info->serial_signals |=3D SerialSignal_RTS + SerialSignal_DTR;
 +		info->serial_signals |=3D SerialSignal_RTS | SerialSignal_DTR;
  	else
 -		info->serial_signals &=3D ~(SerialSignal_RTS + SerialSignal_DTR);
 +		info->serial_signals &=3D ~(SerialSignal_RTS | SerialSignal_DTR);
 =20
  	/* byte size and parity */
 =20
@@@ -2301,10 -2318,10 +2308,10 @@@ static void mgslpc_set_termios(struct t
  	/* Handle transition to B0 status */
  	if (old_termios->c_cflag & CBAUD &&
  	    !(tty->termios.c_cflag & CBAUD)) {
 -		info->serial_signals &=3D ~(SerialSignal_RTS + SerialSignal_DTR);
 +		info->serial_signals &=3D ~(SerialSignal_RTS | SerialSignal_DTR);
- 		spin_lock_irqsave(&info->lock,flags);
- 	 	set_signals(info);
- 		spin_unlock_irqrestore(&info->lock,flags);
+ 		spin_lock_irqsave(&info->lock, flags);
+ 		set_signals(info);
+ 		spin_unlock_irqrestore(&info->lock, flags);
  	}
 =20
  	/* Handle transition away from B0 status */
@@@ -2462,13 -2479,13 +2469,13 @@@ static void dtr_rts(struct tty_port *po
  	MGSLPC_INFO *info =3D container_of(port, MGSLPC_INFO, port);
  	unsigned long flags;
 =20
- 	spin_lock_irqsave(&info->lock,flags);
+ 	spin_lock_irqsave(&info->lock, flags);
  	if (onoff)
 -		info->serial_signals |=3D SerialSignal_RTS + SerialSignal_DTR;
 +		info->serial_signals |=3D SerialSignal_RTS | SerialSignal_DTR;
  	else
 -		info->serial_signals &=3D ~SerialSignal_RTS + SerialSignal_DTR;
 +		info->serial_signals &=3D ~(SerialSignal_RTS | SerialSignal_DTR);
  	set_signals(info);
- 	spin_unlock_irqrestore(&info->lock,flags);
+ 	spin_unlock_irqrestore(&info->lock, flags);
  }
 =20
 =20

--Signature=_Mon__11_Feb_2013_16_37_14_+1100_I0eiv6YlZJPsro4y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGIOKAAoJEECxmPOUX5FEzFYP+gMvZm+oCnZlARsk+TX3WGmI
/OPXXFb6zZuHsXzbO1R5R9qYXBwsudovlPMn5VElsAeowzyA6/BEI0d3GRiEeAQH
WbbwXjYCsM/YILVu2KoDG8LY+48bTuvkh5ilG2HCR1SU23e0/U6b61qvQtc0XXsK
dAxEK9PVIEf+y3fGfOXxoI+Tfm24yqMOeZxeKnjQTBtMVZ4OHy6ruUKFGcG0Eq9o
Y3hKmRNHea9gYxgrAJsGWhrEd23gbNYU80wOd1GqKfV5wI+acrXUYfpA37JTzQoO
zu930EBFe2sA03Vy1/04RVA3GqCk7pQ+jI0+J1XyTo5YoWM8G3U8KcqCo4HhY3y9
lCDN+EGY/y/BJhV7sjYOA5hj0GA1xmoQ1zSECZS6i1Pn1bZRJfpCmy0rGSe3D2aC
RAuW4o3YAbQAUYeytTG6mOfRw6M3RQlqQiznphn1pCjTht1w8ztgeQDKG6SjDCto
7LXkjzXMhI5bi6rnayqEhu798qESErt4EPJFfq0eVxy4d7sGW4ZfgtfnrsplV4a+
tPCBSG9JdowCywl/rszZjIJEHy8xPqR2+1lj/UeeuleThsVIJIuLNCLg6+WgZJjM
f9vfNh8g5luUqBuqgd0xInfq8YeMfWq3WvY0ZAU5tqZ64bmewQP+Zd3Lv6EH86cU
BY7BLta5/X3ciRrsCMOz
=iCFb
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Feb_2013_16_37_14_+1100_I0eiv6YlZJPsro4y--
