Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbaCTXuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 19:50:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40686 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759695AbaCTXuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 19:50:11 -0400
Date: Thu, 20 Mar 2014 18:47:52 -0500
From: Felipe Balbi <balbi@ti.com>
To: Russell King <linux@arm.linux.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: UART 8250 and HW Flow Control
Message-ID: <20140320234752.GA26964@saruman.home>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

long ago you wrote a patch (see below) which converted TI16C750 flow
control quirk into a capability flag followed by a fifosize check.

I've tried to fully understand the rationale behind that commit and,
specifically why 32 bytes. If I understood correctly the problem is that
RTS goes low as soon as FIFO Trigger Level is reached which means that
if the far end isn't fast enough, it might miss our Request To Send.

But then, this causes a problem for UARTs with small FIFOs. I mean, if
the far end _does_ use auto-CTS, then we could enable auto-RTS in our
side, but that commit prevents that unless we patch that check.

Right now we're dealing with a use case which is using a BT device over
UART at 3Mbaud and the UART on the SoC has 16 bytes of FIFO (it's a
16550a compatible UART).

Our first (quickest, dirtiest, crappiest) option is to just change 32
into 16 get it over with. HW Flow Control gets enabled and everybody is
happy, soon after that "what ifs" started to pop :-)

I wonder if a better (albeit with impact to performance, probably)
approach would be to patch tty_{un,}throttle() so that we don't write
an ammount >=3D FIFO_TRIGGER_LEVEL in affected UARTs, but that doesn't
sound very nice either, or does it ?

Do you have any extra insider's information about the reason for that
patch and/or any suggestions on how to patch it in a better way ?

I know it's an old commit (took it from historic Linux tree) but worth
asking anyway.

commit 1ad14ded82602e3753c724ce4647b44faf4dc658
Author: Russell King <rmk@flint.arm.linux.org.uk>
Date:   Tue Oct 19 16:37:05 2004 +0100

    [SERIAL] Convert TI16C750 flow control into a port capability.
   =20
    Add UART_CAP_AFE, and use this to enable TI16C750 flow control,
    but only if we have 32 bytes or more of FIFO.

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 6e2e62d..7e63a7f 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -210,7 +210,7 @@ static const struct serial8250_config uart_config[] =3D=
 {
 		.tx_loadsz	=3D 64,
 		.fcr		=3D UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10 |
 				  UART_FCR7_64BYTE,
-		.flags		=3D UART_CAP_FIFO | UART_CAP_SLEEP,
+		.flags		=3D UART_CAP_FIFO | UART_CAP_SLEEP | UART_CAP_AFE,
 	},
 	[PORT_STARTECH] =3D {
 		.name		=3D "Startech",
@@ -1584,11 +1584,14 @@ serial8250_set_termios(struct uart_port *port, stru=
ct termios *termios,
 	}
=20
 	/*
-	 * TI16C750: hardware flow control and 64 byte FIFOs. When AFE is
-	 * enabled, RTS will be deasserted when the receive FIFO contains
-	 * more characters than the trigger, or the MCR RTS bit is cleared.
+	 * MCR-based auto flow control.  When AFE is enabled, RTS will be
+	 * deasserted when the receive FIFO contains more characters than
+	 * the trigger, or the MCR RTS bit is cleared.  In the case where
+	 * the remote UART is not using CTS auto flow control, we must
+	 * have sufficient FIFO entries for the latency of the remote
+	 * UART to respond.  IOW, at least 32 bytes of FIFO.
 	 */
-	if (up->port.type =3D=3D PORT_16750) {
+	if (up->capabilities & UART_CAP_AFE && up->port.fifosize >=3D 32) {
 		up->mcr &=3D ~UART_MCR_AFE;
 		if (termios->c_cflag & CRTSCTS)
 			up->mcr |=3D UART_MCR_AFE;
diff --git a/drivers/serial/8250.h b/drivers/serial/8250.h
index bbf767d..dcf5859 100644
--- a/drivers/serial/8250.h
+++ b/drivers/serial/8250.h
@@ -47,6 +47,7 @@ struct serial8250_config {
 #define UART_CAP_FIFO	(1 << 8)	/* UART has FIFO */
 #define UART_CAP_EFR	(1 << 9)	/* UART has EFR */
 #define UART_CAP_SLEEP	(1 << 10)	/* UART has IER sleep */
+#define UART_CAP_AFE	(1 << 11)	/* MCR-based hw flow control */
=20
 #undef SERIAL_DEBUG_PCI
=20

--=20
balbi

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTK34oAAoJEIaOsuA1yqREhjkQAKQmGvUlptzNURevEESrpwjj
Mh2WvmiCXcBm7MtZa5UBlk+QrSqtXLk7v6U0qwwiVqrG5AnqHQTaaG70umTh7F31
jmA5TVMJXhXOCU6qKINIwHMy0Oo1Lr3bCALhgUYNPzTdJjhJHLNDNJbW/9vo8Ruh
z6Fla9IuY/uuDIu2UiCWVfM7zX4+BG1e9fpih/k6Kf01DPpZT6fCOXqwGSZ7puWM
j1ch59ZTXbbCfMWSCHC1dLCaTcAbwvbvwbeX1cqurrkGPScf8dpHheTgMTWBVCL1
uEePACaidbrIO9/jxE5v3nbUuD4H8myKSWHMhEHv7YAhivemZo2IszEPe+FTCdao
t0MWQeP7CoHGpI6FdO1AwxE3h21ZJ+GzUFDE4383SlMTsNbVLamDrVqmvQUyy7Hi
bpasY8kerdLS7uEgoppqCwe0h9d3RLw6L2Wtvy2NpI9/Z71pm0oT7/Owli2seIGc
AR1wiC0gEt+tIJ9DJ9AxXXc0aT1FePVRfXb9omNrJfsX/KVKSwB2kb1iL/Q0Skfh
5To9uExsK7gjHUCLl7xXs4erygWN/HviwYQCLaxkLErP13GAPfDYAyNKK4PXrmkI
8HfuTlGmTc4vGTbvHH/EfIJJmdt3E7o+u63YlrwsXwGUpCHFEPApF+I8+UbKFDJ6
k0LgRnvtD5TWTQ3wnoze
=hjRy
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
