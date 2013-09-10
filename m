Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab3IJTJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:09:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50752 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3IJTJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:09:52 -0400
Date: Tue, 10 Sep 2013 14:09:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: Alexey Pelykh <alexey.pelykh@gmail.com>
CC: Tony Lindgren <tony@atomide.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: commit 5fe212364 causes division by zero with large bauds
Message-ID: <20130910190901.GA10105@radagast>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexey,

your commit 5fe212364 causes division by zero with any baud rate larger
than 3 Mbaud (IP supports up to 3686400).

Maybe this patch is all we need to get it fixed ? (untested)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-ser=
ial.c
index 816d1a2..b50327f 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -240,8 +240,14 @@ serial_omap_baud_is_mode16(struct uart_port *port, uns=
igned int baud)
 {
 	unsigned int n13 =3D port->uartclk / (13 * baud);
 	unsigned int n16 =3D port->uartclk / (16 * baud);
-	int baudAbsDiff13 =3D baud - (port->uartclk / (13 * n13));
-	int baudAbsDiff16 =3D baud - (port->uartclk / (16 * n16));
+	int baudAbsDiff13 =3D 0;
+	int baudAbsDiff16 =3D 0;
+
+	if (n13)
+		baudAbsDiff13 =3D baud - (port->uartclk / (13 * n13));
+	if (n16)
+		baudAbsDiff16 =3D baud - (port->uartclk / (16 * n16));
+
 	if(baudAbsDiff13 < 0)
 		baudAbsDiff13 =3D -baudAbsDiff13;
 	if(baudAbsDiff16 < 0)

Another possibility would be to convert this into a lookup table (also
untested):

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-ser=
ial.c
index 816d1a2..942d68e 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -224,6 +224,48 @@ static void serial_omap_enable_wakeup(struct uart_omap=
_port *up, bool enable)
 	pdata->enable_wakeup(up->dev, enable);
 }
=20
+struct uart_omap_config {
+	unsigned int baud;
+	unsigned int oversampling;
+	unsigned int divisor;
+};
+
+static struct uart_omap_config omap_port_configs[] =3D {
+	{ .baud =3D 300,		.oversampling =3D 16,	.divisor =3D 10000, },
+	{ .baud =3D 300,		.oversampling =3D 16,	.divisor =3D 10000, },
+	{ .baud =3D 600,		.oversampling =3D 16,	.divisor =3D 5000, },
+	{ .baud =3D 1200,		.oversampling =3D 16,	.divisor =3D 2500, },
+	{ .baud =3D 2400,		.oversampling =3D 16,	.divisor =3D 1250, },
+	{ .baud =3D 4800,		.oversampling =3D 16,	.divisor =3D 625, },
+	{ .baud =3D 9600,		.oversampling =3D 16,	.divisor =3D 312, },
+	{ .baud =3D 14400,	.oversampling =3D 16,	.divisor =3D 208, },
+	{ .baud =3D 19200,	.oversampling =3D 16,	.divisor =3D 156, },
+	{ .baud =3D 28800,	.oversampling =3D 16,	.divisor =3D 704, },
+	{ .baud =3D 38400,	.oversampling =3D 16,	.divisor =3D 78, },
+	{ .baud =3D 57600,	.oversampling =3D 16,	.divisor =3D 52, },
+	{ .baud =3D 115200,	.oversampling =3D 16,	.divisor =3D 26, },
+	{ .baud =3D 230400,	.oversampling =3D 16,	.divisor =3D 13, },
+	{ .baud =3D 460800,	.oversampling =3D 13,	.divisor =3D 8, },
+	{ .baud =3D 921600,	.oversampling =3D 13,	.divisor =3D 4, },
+	{ .baud =3D 1843200,	.oversampling =3D 13,	.divisor =3D 2, },
+	{ .baud =3D 3000000,	.oversampling =3D 16,	.divisor =3D 1, },
+	{ .baud =3D 3686400,	.oversampling =3D 13,	.divisor =3D 1, },
+	{  } /* Terminating Entry */
+};
+
+static struct uart_omap_config *
+__serial_omap_get_config(struct uart_port *port, unsigned int baud)
+{
+	struct uart_omap_config *cfg =3D omap_port_configs;
+
+	while (cfg++) {
+		if (cfg->baud =3D=3D baud)
+			return cfg;
+	}
+
+	return NULL;
+}
+
 /*
  * serial_omap_baud_is_mode16 - check if baud rate is MODE16X
  * @port: uart port info
@@ -238,16 +280,12 @@ static void serial_omap_enable_wakeup(struct uart_oma=
p_port *up, bool enable)
 static bool
 serial_omap_baud_is_mode16(struct uart_port *port, unsigned int baud)
 {
-	unsigned int n13 =3D port->uartclk / (13 * baud);
-	unsigned int n16 =3D port->uartclk / (16 * baud);
-	int baudAbsDiff13 =3D baud - (port->uartclk / (13 * n13));
-	int baudAbsDiff16 =3D baud - (port->uartclk / (16 * n16));
-	if(baudAbsDiff13 < 0)
-		baudAbsDiff13 =3D -baudAbsDiff13;
-	if(baudAbsDiff16 < 0)
-		baudAbsDiff16 =3D -baudAbsDiff16;
-
-	return (baudAbsDiff13 > baudAbsDiff16);
+	struct uart_omap_config *cfg =3D __serial_omap_get_config(port, baud);
+
+	if (!cfg)
+		return -EINVAL;
+
+	return (cfg->oversampling =3D=3D 16);
 }
=20
 /*
@@ -258,13 +296,12 @@ serial_omap_baud_is_mode16(struct uart_port *port, un=
signed int baud)
 static unsigned int
 serial_omap_get_divisor(struct uart_port *port, unsigned int baud)
 {
-	unsigned int divisor;
+	struct uart_omap_config *cfg =3D __serial_omap_get_config(port, baud);
=20
-	if (!serial_omap_baud_is_mode16(port, baud))
-		divisor =3D 13;
-	else
-		divisor =3D 16;
-	return port->uartclk/(baud * divisor);
+	if (!cfg)
+		return -EINVAL;
+
+	return cfg->divisor;
 }
=20
 static void serial_omap_enable_ms(struct uart_port *port)

--=20
balbi

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSL25NAAoJEIaOsuA1yqRER9YP/1wEp+k9f6Bxf2rma9pANpA3
iuDa6IlsxptppBP2/cLcuXuG1fVVuSAxuDasLM5MRihKbhtZInwqNBcabcfmE5/K
NakUw2GW6G4j+Mf8I52p4cKIoJD1dXCkwP2BZ+qeYaJKJiiZqY+hecB8LkCRCeOx
hdd5EVadZpKsJcAv0VlN6jy4bI7GP9YPbrjOhGMkhqkvnDS2gLCdQaW5epY01TQW
/C1MXtwxiulE/hwViSLwJsFSWrDd6PhzkMuLYMXr3VsoZRuJRElaP5sTB5HIBJ+X
nqK3a/dqTOpqUslsixPJbOfRQIIvhvnG2VQ8KstVwDVjgkmXQYLB4Vwsfe5vhE0G
jTD1LaN6gtju7B7A3A2jSEBKGOL+yDe8NOWC8NfaVHBTyg5x96VNe1EqgoyBAtED
sJQGUWr3DW6JI1pIU1ogaDw6hEpJIWoRNbG3auyjyk45ABAiOT9E79f5rEWneIdk
hbVUszxmBtyrSqOCvQN1jADn6rFmaeXkniPTeJOMAYgs7Xt/DGi+b43foECqbDiL
Xx8DdO3vDB1DyNDEi6/Z9tYNyATTdXqXgnQ+kvJvz0xTUdabnylorFti+meprF/X
rcrrmyTtmsndW4hoLZL3tr+5NPhSiUgcafmDag7Wbftnvu/0eMDxJ73rwLf4v37Y
+SAW1a9UhdJm6umHStGb
=kzrb
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
