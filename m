Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3CCDjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 22:39:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589Ab3CCDi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 22:38:58 -0500
Message-ID: <1362281921.3768.204.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 019/150] serial_core: Fix type definition for
 PORT_BRCM_TRUMANAGE.
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Stephen Hurd <shurd@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        linux-serial@vger.kernel.org
Date: Sun, 03 Mar 2013 03:38:41 +0000
In-Reply-To: <1362279084.3768.200.camel@deadeye.wl.decadent.org.uk>
References: <20130226235523.930663721@linuxfoundation.org>
	 <20130226235526.246172467@linuxfoundation.org>
	 <1362009959.3768.85.camel@deadeye.wl.decadent.org.uk>
	 <20130228003906.GA3754@kroah.com>
	 <1362279084.3768.200.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-oPBdkcX1evdVMv3a5mbR"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oPBdkcX1evdVMv3a5mbR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've queued up the following for 3.2.y.  Let me know if you see any
issue with this or want to ack it.

Ben.

---
From: Ben Hutchings <ben@decadent.org.uk>
Subject: 8250: use correct value for PORT_BRCM_TRUMANAGE
Date: Sun, 03 Mar 2013 03:24:34 +0000

When backporting commit ebebd49a8eab ('8250/16?50: Add support for
Broadcom TruManage redirected serial port') I took the next
available port type number for PORT_BRCM_TRUMANAGE (22).

However, the 8250 port type numbers are exposed to userland through
the TIOC{G,S}SERIAL ioctls and so must remain stable.  Redefine
PORT_BRCM_TRUMANAGE as 25, matching mainline as of commit
85f024401bf807.

This leaves port types 22-24 within the valid range for 8250 but not
implemented there.  Change serial8250_verify_port() to specifically
reject these and change serial8250_type() to return "unknown" for them
(though I'm not sure why it would ever see them).

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -2695,7 +2695,7 @@ serial8250_verify_port(struct uart_port
 	if (ser->irq >=3D nr_irqs || ser->irq < 0 ||
 	    ser->baud_base < 9600 || ser->type < PORT_UNKNOWN ||
 	    ser->type >=3D ARRAY_SIZE(uart_config) || ser->type =3D=3D PORT_CIRRU=
S ||
-	    ser->type =3D=3D PORT_STARTECH)
+	    ser->type =3D=3D PORT_STARTECH || uart_config[ser->type].name =3D=3D =
NULL)
 		return -EINVAL;
 	return 0;
 }
@@ -2705,7 +2705,7 @@ serial8250_type(struct uart_port *port)
 {
 	int type =3D port->type;
=20
-	if (type >=3D ARRAY_SIZE(uart_config))
+	if (type >=3D ARRAY_SIZE(uart_config) || uart_config[type].name =3D=3D NU=
LL)
 		type =3D 0;
 	return uart_config[type].name;
 }
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -47,8 +47,8 @@
 #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
 #define PORT_TEGRA	20	/* NVIDIA Tegra internal UART */
 #define PORT_XR17D15X	21	/* Exar XR17D15x UART */
-#define PORT_BRCM_TRUMANAGE	22
-#define PORT_MAX_8250	22	/* max port ID */
+#define PORT_BRCM_TRUMANAGE	25
+#define PORT_MAX_8250	25	/* max port ID */
=20
 /*
  * ARM specific type numbers.  These are not currently guaranteed

--=20
Ben Hutchings
Time is nature's way of making sure that everything doesn't happen at once.

--=-oPBdkcX1evdVMv3a5mbR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTLFwee/yOyVhhEJAQozhA//QxyYCAWoDvuneWbrHUukjr1oeK+99HqP
US7uNjBD1z8OeHmB3ujzRgozwAFpXL5Tswicq72RGsSnKr94tH7DLC0LElZ+Skhg
xnGg25U/VN5XAnz5j0BtDPQLhXsDTrjoS0K+p3cin/5u73HUKkPPv52w09FYlwpY
26luvDecs4h4LKAFucM3KLnHrV+zb8zL7+ftqqI/lHywTVJSSwK/8dW2El/mwrk1
vyxdSsGqzukBxAeAnwTwfFNhiPT0aebTy2gM8n46oXTEusAWOmvRGptKBHvn4jfG
FxssSOJBBCl/1sQ+8o4dxOvGqkSQI8RhIYaQ3KJsZaPeMelo8oHEOjgLzVi7gts8
Ag1XJBUNUwTBWgG1Zj2Z+7vHJwZm3wbjlJT6E3hepOAOloGX14S7amk3jVupOC1b
nODZUqR/v0i/XadfIWdsE0x//X8csJgpd3fQV2MgB6AaXkbxo5QSwmFRzPC2rWri
sgeXEXvtvoSul2zsExbGV8yRz0XfJM0U9HgJ9wcL1skTiQ5WeIBrl/8APnfoSTel
I8Oh3GkQVUjIUc2gC4C8JF3l2w4ZN+6PGZMTdXaJJ3CN5WN3/MxpH6AUbBf/oGPg
f9NUhpIDUgP+adx+S4DA97Ng8tvKdHjqUm/VCWYYLDRXloT4VwHEZyu1JqcjwS5u
jIqTwsDxRR0=
=Db/w
-----END PGP SIGNATURE-----

--=-oPBdkcX1evdVMv3a5mbR--
