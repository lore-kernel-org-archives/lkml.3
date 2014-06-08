Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaFHWv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 18:51:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41548 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754127AbaFHWvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 18:51:52 -0400
Message-ID: <1402267903.23860.45.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH v2] drivers/base: Fix length checks in
 create_syslog_header()/dev_vprintk_emit()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Kay Sievers <kay@vrfy.org>
Date: Sun, 08 Jun 2014 23:51:43 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Fivrhe8wQsS8otsIBxVU"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Fivrhe8wQsS8otsIBxVU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

snprintf() returns the number of bytes that could have been written
(excluding the null), not the actual number of bytes written.  Given a
long enough subsystem or device name, these functions will advance
beyond the end of the on-stack buffer in dev_vprintk_exit(), resulting
in an information leak or stack corruption.  I don't know whether such
a long name is currently possible.

In case snprintf() returns a value >=3D the buffer size, do not add
structured logging information.  Also WARN if this happens, so we can
fix the driver or increase the buffer size.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
v2: use dev_WARN() not dev_WARN_ON()

 drivers/base/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 20da3ad..062b7bf 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2007,6 +2007,8 @@ create_syslog_header(const struct device *dev, char *=
hdr, size_t hdrlen)
 		return 0;
=20
 	pos +=3D snprintf(hdr + pos, hdrlen - pos, "SUBSYSTEM=3D%s", subsys);
+	if (pos >=3D hdrlen)
+		goto overflow;
=20
 	/*
 	 * Add device identifier DEVICE=3D:
@@ -2038,7 +2040,14 @@ create_syslog_header(const struct device *dev, char =
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
+	dev_WARN(dev, 1, "device/subsystem name too long");
+	return 0;
 }
=20
 int dev_vprintk_emit(int level, const struct device *dev,

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-Fivrhe8wQsS8otsIBxVU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU5TpAOe/yOyVhhEJAQr0lBAAgni3QL8ZJGS4Peq7btR/4eURDX7HE0aI
VTCabI6WEYXWRvI7HNtoiQzdVyusDC+gl6JNuPMVm+yzl5foPsY3+Dmzi6wOng6u
Wr4ylwLJUnptkhNg3KvkRmL+pYrzaKfWHc3E2G0TAks0Kkx35IV5V2BgbCAjJuJK
bwL36Ng3fsn7wh952mtekM8a9TGvbdV/aJcZTNifbX36L2SBasIt5Hz2HMmaHKwg
xKTkvNpOHa+oJ20qZGlwquMAp70W/6lyejhHFw01AN1gCufGaYvsWiZQ5vQAwB7C
lGNmBjg2Ig4109Dh5JQoyjDJA4tmEBTFWwErIqdbtHRRQ8TosZZ69VcqeA0tInlu
O2y+hlBkbJns5RzT4MC7+MqxGe3NdkYhG526jVoPjbzYGZ3rjku61lIyDnN97+XD
bsyNVsk+FBeU/LCX1vOHzf7fbLT2x/CtzcxZF/5U8VaPFhQd/fx30xG3uS4nGP5Q
WjluxxukxNDCphTWyLc6kwPu3dOExJO6P9rczxTb+7uWVjViKrTi45foe2jtDFDF
EY92gjYFNRZvW/765DiNBRGtHRFn6UiOQSW5JbZJlJ3bTQyKbvAe0G3GhIH73xp6
fEIeiQ83Y67T052zIDtI8MRxiIr2r3QkUQLg7zu3gLTOEVaM4Sy0IPELKnOu6OBA
oPGUgd9NatE=
=ppra
-----END PGP SIGNATURE-----

--=-Fivrhe8wQsS8otsIBxVU--
