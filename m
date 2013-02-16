Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3BPSCa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 13:02:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34498 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753806Ab3BPSC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 13:02:29 -0500
Message-ID: <1361037742.5374.441.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 2/2] dmi_scan: Refactor dmi_scan_machine(),
 {smbios,dmi}_present()
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Tim McGrath <tmhikaru@gmail.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Date: Sat, 16 Feb 2013 18:02:22 +0000
In-Reply-To: <1361037634.5374.437.camel@deadeye.wl.decadent.org.uk>
References: <1361037634.5374.437.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BKvIWyKcs/7VhPGKUuwd"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BKvIWyKcs/7VhPGKUuwd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Move the calls to memcpy_fromio() up into the loop in
dmi_scan_machine(), and move the signature checks back down into
dmi_decode().  We need to check at 16-byte intervals but keep a
32-byte buffer for an SMBIOS entry, so shift the buffer after each
iteration.

Merge smbios_present() into dmi_present(), so we look for an SMBIOS
signature at the beginning of the given buffer and then for a DMI
signature at an offset of 16 bytes.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This file mixes up __iomem and regular pointers a lot, and this patch
fixes some but not all of those instances.  Presumably it is quite
safe to read a BIOS image with any mov instructions the compiler
generates, but in that case maybe we should explicitly cast away the
__iomem qualifier in dmi_ioremap()?

Tim, you might like to test that this doesn't cause a regression
of the previous fix.

Ben.

 drivers/firmware/dmi_scan.c |   80 ++++++++++++++++++++-------------------=
----
 1 file changed, 37 insertions(+), 43 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index a86ccff..3439f59 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -410,22 +410,45 @@ static void __init dmi_dump_ids(void)
 	printk(KERN_CONT "\n");
 }
=20
-static int __init dmi_present(const char __iomem *p)
+static int __init dmi_present(const char *buf)
 {
-	u8 buf[15];
+	int smbios_ver;
=20
-	memcpy_fromio(buf, p, 15);
-	if (dmi_checksum(buf, 15)) {
+	if (memcmp(buf, "_SM_", 4) =3D=3D 0 &&
+	    buf[5] < 32 && dmi_checksum(buf, buf[5])) {
+		smbios_ver =3D (buf[6] << 8) + buf[7];
+
+		/* Some BIOS report weird SMBIOS version, fix that up */
+		switch (smbios_ver) {
+		case 0x021F:
+		case 0x0221:
+			pr_debug("SMBIOS version fixup(2.%d->2.%d)\n",
+				 smbios_ver & 0xFF, 3);
+			smbios_ver =3D 0x0203;
+			break;
+		case 0x0233:
+			pr_debug("SMBIOS version fixup(2.%d->2.%d)\n", 51, 6);
+			smbios_ver =3D 0x0206;
+			break;
+		}
+	} else {
+		smbios_ver =3D 0;
+	}
+
+	buf +=3D 16;
+
+	if (memcmp(buf, "_DMI_", 5) =3D=3D 0 && dmi_checksum(buf, 15)) {
 		dmi_num =3D (buf[13] << 8) | buf[12];
 		dmi_len =3D (buf[7] << 8) | buf[6];
 		dmi_base =3D (buf[11] << 24) | (buf[10] << 16) |
 			(buf[9] << 8) | buf[8];
=20
 		if (dmi_walk_early(dmi_decode) =3D=3D 0) {
-			if (dmi_ver)
+			if (smbios_ver) {
+				dmi_ver =3D smbios_ver;
 				pr_info("SMBIOS %d.%d present.\n",
 				       dmi_ver >> 8, dmi_ver & 0xFF);
-			else {
+			} else {
 				dmi_ver =3D (buf[14] & 0xF0) << 4 |
 					   (buf[14] & 0x0F);
 				pr_info("Legacy DMI %d.%d present.\n",
@@ -435,40 +458,14 @@ static int __init dmi_present(const char __iomem *p)
 			return 0;
 		}
 	}
-	dmi_ver =3D 0;
-	return 1;
-}
=20
-static int __init smbios_present(const char __iomem *p)
-{
-	u8 buf[32];
-
-	memcpy_fromio(buf, p, 32);
-	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
-		dmi_ver =3D (buf[6] << 8) + buf[7];
-
-		/* Some BIOS report weird SMBIOS version, fix that up */
-		switch (dmi_ver) {
-		case 0x021F:
-		case 0x0221:
-			pr_debug("SMBIOS version fixup(2.%d->2.%d)\n",
-			       dmi_ver & 0xFF, 3);
-			dmi_ver =3D 0x0203;
-			break;
-		case 0x0233:
-			pr_debug("SMBIOS version fixup(2.%d->2.%d)\n", 51, 6);
-			dmi_ver =3D 0x0206;
-			break;
-		}
-		return memcmp(q + 16, "_DMI_", 5) || dmi_present(p + 16);
-	}
 	return 1;
 }
=20
 void __init dmi_scan_machine(void)
 {
 	char __iomem *p, *q;
-	int rc;
+	char buf[32];
=20
 	if (efi_enabled(EFI_CONFIG_TABLES)) {
 		if (efi.smbios =3D=3D EFI_INVALID_TABLE_ADDR)
@@ -481,10 +478,10 @@ void __init dmi_scan_machine(void)
 		p =3D dmi_ioremap(efi.smbios, 32);
 		if (p =3D=3D NULL)
 			goto error;
-
-		rc =3D smbios_present(p);
+		memcpy_fromio(buf, p, 32);
 		dmi_iounmap(p, 32);
-		if (!rc) {
+
+		if (!dmi_present(buf)) {
 			dmi_available =3D 1;
 			goto out;
 		}
@@ -499,18 +496,15 @@ void __init dmi_scan_machine(void)
 		if (p =3D=3D NULL)
 			goto error;
=20
+		memset(buf, 0, 16);
 		for (q =3D p; q < p + 0x10000; q +=3D 16) {
-			if (memcmp(q, "_SM_", 4) =3D=3D 0 && q - p <=3D 0xFFE0)
-				rc =3D smbios_present(q);
-			else if (memcmp(q, "_DMI_", 5) =3D=3D 0)
-				rc =3D dmi_present(q);
-			else
-				continue;
-			if (!rc) {
+			memcpy_fromio(buf + 16, q, 16);
+			if (!dmi_present(buf)) {
 				dmi_available =3D 1;
 				dmi_iounmap(p, 0x10000);
 				goto out;
 			}
+			memcpy(buf, buf + 16, 16);
 		}
 		dmi_iounmap(p, 0x10000);
 	}


--=-BKvIWyKcs/7VhPGKUuwd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUR/Jrue/yOyVhhEJAQofXw//Sqxlw6K0qCXCoJOaHyfScvEfjoiz+++D
mwIXbByKvFUXYM4w/DUH6qwmNO0yrW4Z8N88ueJtt5qog7Ml1S5IoVSPc44lc0ZG
c5aN3+1LuKIqkPpE03DrfXQawpkPHbugblfja5A3lEn/Y8npMEWI9n3GRPRsGI//
Mjmk4jH0xSy6HbJD1hNpIk1u033gA3bZUjoVOtZfvhFtVqZvflcS8yIQ0Cpkud4H
tf6DPjaxoDfSU34HhkV2yKbb26fD6cDcU28Gzx0m4l/ZUeZCRP/q32DOsVPJxMsG
IU9RIZWYkhqAWudXnXDTt7yJ+krrnAANFenFuAgkxa6yHBILB2PZj8w98q54Zdr6
3b8CtBOariByNoBgmvAcDMVL0YlbN35XLebMCYd8WgSRyRW5grDCIExq7sI5a1BX
SU4zGoAPTT6giHSUBm/oO1e7Wx5nTrtss6KUmROpzkn+YqXmyZ+qCnKgf7twGFNK
txzCO7myPEVfYBGHfcX5CkAudbT2T/xRXZ0GLUlnol4fkjBDLwY42gTR78AXtS+/
Rq0+Jw/piWRuzed3YwQ3PXHNDElVMgAjsnbCjfcqh9dEWv6BEsU5wczzPBEzrR9T
ytrvk7N8FC2yh53eTHTN1QxSAnFq7WC/5OmhAeKgXLr74vMzKKw+NJWKd947KmE7
fo3RqFubZ6w=
=JErp
-----END PGP SIGNATURE-----

--=-BKvIWyKcs/7VhPGKUuwd--
