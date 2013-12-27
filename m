Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3L0RSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:18:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51368 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711Ab3L0RSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:18:30 -0500
Message-ID: <1388164698.26981.73.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] drivers/base: Fix length checks in
 create_syslog_header()/dev_vprintk_emit()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Kay Sievers <kay@vrfy.org>
Date: Fri, 27 Dec 2013 18:18:18 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RaIYSVdN60+ZoNuIzSMo"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.217.127.160
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RaIYSVdN60+ZoNuIzSMo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

snprintf() returns the number of bytes that could have been written
(excluding the null), not the actual number of bytes written.  Given a
long enough subsystem or device name, these functions will advance
beyond the end of the on-stack buffer in dev_vprintk_exit(), resulting
in an information leak or stack corruption.  I don't know whether such
a long name is currently possible.

In case snprintf() returns a value >=3D the buffer size, do not add
structured logging information.  Also WARN the first time this
happens, so we can fix the driver or increase the buffer size.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/base/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 67b180d..989a93c 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2022,6 +2022,8 @@ create_syslog_header(const struct device *dev, char *=
hdr, size_t hdrlen)
 		return 0;
=20
 	pos +=3D snprintf(hdr + pos, hdrlen - pos, "SUBSYSTEM=3D%s", subsys);
+	if (pos >=3D hdrlen)
+		goto overflow;
=20
 	/*
 	 * Add device identifier DEVICE=3D:
@@ -2053,7 +2055,14 @@ create_syslog_header(const struct device *dev, char =
*hdr, size_t hdrlen)
 				"DEVICE=3D+%s:%s", subsys, dev_name(dev));
 	}
=20
+	if (pos >=3D hdrlen)
+		goto overflow;
+
 	return pos;
+
+overflow:
+	dev_WARN_ONCE(dev, 1, "device/subsystem name too long");
+	return 0;
 }
 EXPORT_SYMBOL(create_syslog_header);
=20

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-RaIYSVdN60+ZoNuIzSMo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUr22Wue/yOyVhhEJAQpxZg//XvLyjhXdOxA3g+dW8R+zdMsBnNyYZBqX
PXkPgm3vldB3HyMuWegrtasmVOza/Rm9+hXCPltgcKq6zHoJnBDbf2zolH8hpF9Y
hCvGJTl90qwQZEqNKhKREIVMi0CVaZViMGE/ebNuwH9Iful8+bWAAdztPaC8zIYp
xyKQVoDXTlLxBxJSsdTSjBrsFbgRku7+dyXM7ogXXBy7p/ma1s/kT5b88w64cn7h
qkxV92oiU+ZXFvUNGujzXnadQF3cee03dBPYeYOLEls7MVrSwaX0x6B4LVU3zO9I
Oe4tgzXlEQj1vvu7BXI6/LUoshCpBTHGnhSm16gS9L41MwhVSKXokMeh8Ink5ioP
BMUbAEa4QYaERV14PKnRdIOFNmDJBg9l2jrHavK4JoHEInd7uvzyw3UG8gd3v3WB
g5t09iT3qkfPScjBD8/mRiYwyllERCJ/x83wkYqvfJy8oLFbNBehHbf/0fCL2m1Y
hUxh5Rk1AKC0pYcN7H77yKZZ3YN8G22xrd2u8C6XGevnB5ZMcpY6AsC3R8Yr6v0J
t2QaHEAZXjYJ2mNtGk0808X/zDJqlgZPlB9TVhdwKkg6/0XS4IE5d0qKSsosiQAG
lvVXqeO9QtOeMwswYb0mpbtIUwUFFebz4gWH86FoGV3kb6XzgYH/v+W+wF3LAFJc
sb3Fv08l63M=
=NDaf
-----END PGP SIGNATURE-----

--=-RaIYSVdN60+ZoNuIzSMo--
