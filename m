Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbaHZHfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:35:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59177 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757359AbaHZHe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:34:59 -0400
Message-ID: <1409038484.3033.53.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH v3] drivers/base: Fix length checks in
 create_syslog_header()/dev_vprintk_emit()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Kay Sievers <kay@vrfy.org>
Date: Tue, 26 Aug 2014 00:34:44 -0700
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-F0DTxBRXD6E3ZAbJL4zF"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 131.252.184.246
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F0DTxBRXD6E3ZAbJL4zF
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
v3: the version that actually compiles

 drivers/base/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 20da3ad..28b808c 100644
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
+	dev_WARN(dev, "device/subsystem name too long");
+	return 0;
 }
=20
 int dev_vprintk_emit(int level, const struct device *dev,

--=20
Ben Hutchings
No political challenge can be met by shopping. - George Monbiot

--=-F0DTxBRXD6E3ZAbJL4zF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU/w4mee/yOyVhhEJAQpToRAAgpjyX82aniQWUZaunYBwba42Ts+/fsgV
D6RdWm0eblFBfcmBtbV+0xe+Tq/6cll2Oe/ywTKbVofdK5vIFhH/d33PFrgkNYtI
ZImd3DSpEJF9ACPo0v11ICz/8XyGp/6G96gSLYpms2mMmsR87s8msDILpOPstOpw
cdXB+FL2DNtiOU03rcRatL/WAQqCIa4T+ZFh8s8oh7EZ0Oe5ie6vg+4XYRTnFieF
H/6uW6Bd4bLcXbMDareU80tx8000vlYYuAdzPljQ4sfX9LxnRB3oHBzOmhFLdy8G
4KYXCLfrDIBqpxB8C49G4ZJFcSYRWopN3MDryJildcIDIKY9g4Cnwkq1hVIn4rHb
o+ku9x6Fjrprr/PUSPX6noYB+spxhjMlszJAd+FzlGXmIlOGcKzlLI8KTNjxqnnJ
CMvpW9Sq/puCvuiLL63JWni+E73EjVDwsaEbaxdyyCiHXGroTiCBTSZWQRlIWfYn
tOz17MBVimhC4J7jqnOQ/OQMIHza99VU0KlDTLArkHvBR4cj+GI11k2UWACFy+RO
1MdgpmEuueOsi6yFKyZk+Y+ZivItmt5RYcrptqTU2FEb7sJboKElqpAA0X0QxIv4
FaYSZCBSCEKMPcEsbd5vBGQDMHRcue67ZtGVgrLv1N7/DjcnWojqgM7LzMzER9bJ
Rvb93KNiI+A=
=dpD1
-----END PGP SIGNATURE-----

--=-F0DTxBRXD6E3ZAbJL4zF--
