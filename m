Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3BPSAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 13:00:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34485 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753806Ab3BPSAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 13:00:46 -0500
Message-ID: <1361037634.5374.437.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 1/2] dmi_scan: Fix missing check for _DMI_ signature in
 smbios_present()
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Tim McGrath <tmhikaru@gmail.com>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>
Date: Sat, 16 Feb 2013 18:00:34 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-trHrhLccxojDMa4mc44b"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-trHrhLccxojDMa4mc44b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Commit 9f9c9cbb6057 ('drivers/firmware/dmi_scan.c: fetch dmi version
from SMBIOS if it exists') hoisted the check for "_DMI_" into
dmi_scan_machine(), which means that we don't bother to check for
"_DMI_" at offset 16 in an SMBIOS entry.  smbios_present() may also
call dmi_present() for an address where we found "_SM_", if it failed
further validation.

Check for "_DMI_" in smbios_present() before calling dmi_present().

Reported-by: Tim McGrath <tmhikaru@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable <stable@vger.kernel.org>
---
This has a memcmp() that wasn't in the previous version, so I've not
included the Acked-by or Tested-by for that.

Ben.

 drivers/firmware/dmi_scan.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 982f1f5..a86ccff 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -442,7 +442,6 @@ static int __init dmi_present(const char __iomem *p)
 static int __init smbios_present(const char __iomem *p)
 {
 	u8 buf[32];
-	int offset =3D 0;
=20
 	memcpy_fromio(buf, p, 32);
 	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
@@ -461,9 +460,9 @@ static int __init smbios_present(const char __iomem *p)
 			dmi_ver =3D 0x0206;
 			break;
 		}
-		offset =3D 16;
+		return memcmp(q + 16, "_DMI_", 5) || dmi_present(p + 16);
 	}
-	return dmi_present(buf + offset);
+	return 1;
 }
=20
 void __init dmi_scan_machine(void)


--=-trHrhLccxojDMa4mc44b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUR/JQue/yOyVhhEJAQqX4w/+JCywNYd4jJ57BxbXJVLQUqLOmSjQvclw
DG7FDeD/L7SabkltgIGtzhQ5oWZgymhEazJahHqschVdRIOeA495+d2LceJNsB1y
kKe5ZGcVUyowJXBhdSe9bSMvxYHzQQ4hHs5FwLgYuQoNO4C/ZlZo42qJsz9Cau6V
zoilJDC6yQwvVB/3Yw29fZimhKGg/CJhg3EHkkDa0K+ic+8i3lYQe8QoBWrruNp5
PXmWMo4lfrtBH/owPWFHG8/8I0dSaEdCz92KklNaEbsWaJLUBXlwODMcQYw6YeZZ
OREMdw8G+rEAqrv2oF9/IIZxz39lOsQfWcR2hviI50c5BCZP0fBCjt1bzB9wo1Lg
dVo8XkzlNZYuRE19UhSZcDRvlrBB1TnnQ8X349xBOd0weoHR6ybF/anNRMu50RNf
wWgybgMK1fkVetjxNomjHasQ5QZ6Zm1rfgD6jtj0VEmgju/yYikYTkqGb+nSYbbz
RjqLzYk+vL0Ni6gbAjl9kGGHhBBE5oYZuSIxe69J+tvG8dfBY+ZCk+2k+poztetM
ZDv+9bF/gDaflMNhJklQpjG5xXtCUGjnSuKoXkisdaKCRSO6wdb4wOpHufPoQp9v
lQZOUhaNxvtenvrirEBl9cuz9glU/fPXUtpLqTLaxo/Cazm1dB1hhbSgcuQvmY+t
lwRMpFR43tE=
=lnNQ
-----END PGP SIGNATURE-----

--=-trHrhLccxojDMa4mc44b--
