Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaHKBlI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 21:41:08 -0400
Received: from mail.tiggerswelt.net ([94.186.151.130]:60532 "EHLO
	mail.tiggerswelt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaHKBlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 21:41:07 -0400
X-Greylist: delayed 1832 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Aug 2014 21:41:06 EDT
Message-ID: <53E81801.8000907@phihag.de>
Date: Mon, 11 Aug 2014 03:10:25 +0200
From: Philipp Hagemeister <phihag@phihag.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, Wei WANG <wei_wang@realsil.com.cn>
CC: 757733@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug#757733: RTS2557 SD card reader does not work
References: <20140810225012.3425.19201.reportbug@t4.home.phihag.de> <1407715088.3017.73.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1407715088.3017.73.camel@deadeye.wl.decadent.org.uk>
OpenPGP: id=A4826A18
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="md2SAJqIRJv76kXNskqQA5tcDxTH9QgXR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--md2SAJqIRJv76kXNskqQA5tcDxTH9QgXR
Content-Type: multipart/mixed;
 boundary="------------020605060606050500090508"

This is a multi-part message in MIME format.
--------------020605060606050500090508
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> A web search shows some similar reports (e.g.
> <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1329566>,
>
<http://askubuntu.com/questions/473848/ubuntu-14-04-realtek-semiconductor=
-co-ltd-rts5227-pci-express-card-reader-isn>).
> But in that last one, it turns out that the out-of-tree driver does
> work.

Indeed, that is a workaround - download from
http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=3D1&PNid=3D=
15&PFid=3D25&Level=3D4&Conn=3D3&DownTypeID=3D3&GetDown=3Dfalse
, apply the attached patch, remove all rtsx_* modules, and insert the
new rts2557 module into the kernel.


--------------020605060606050500090508
Content-Type: text/x-patch;
 name="rts5229.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="rts5229.patch"

commit 31eeecabfabe62c9667464f2144cbbd57c370b6f
Author: Philipp Hagemeister <phihag@phihag.de>
Date:   Mon Aug 11 03:03:56 2014 +0200

    Rename rts2559 to rts2557 and remove outdated macros

diff --git a/Makefile b/Makefile
index 6536bd4..7815096 100644
--- a/Makefile
+++ b/Makefile
@@ -22,7 +22,7 @@
 # Makefile for the PCI-Express Card Reader drivers.
 #
=20
-TARGET_MODULE :=3D rts5229
+TARGET_MODULE :=3D rts5227
=20
 EXTRA_CFLAGS :=3D -Idrivers/scsi=20
=20
diff --git a/rtsx.c b/rtsx.c
index 7fd7a92..8ba9e19 100644
--- a/rtsx.c
+++ b/rtsx.c
@@ -263,7 +263,6 @@ static struct scsi_host_template rtsx_host_template =3D=
 {
 =09
 	.name =3D				CR_DRIVER_NAME,
 	.proc_name =3D			CR_DRIVER_NAME,
-	.proc_info =3D			proc_info,
 	.info =3D				host_info,
=20
 =09
@@ -911,7 +910,7 @@ static void rtsx_init_options(struct rtsx_chip *chip)=

 	chip->support_mmc =3D 1;
 }
=20
-static int __devinit rtsx_probe(struct pci_dev *pci, const struct pci_de=
vice_id *pci_id)
+static int rtsx_probe(struct pci_dev *pci, const struct pci_device_id *p=
ci_id)
 {
 	struct Scsi_Host *host;
 	struct rtsx_dev *dev;
@@ -1066,7 +1065,7 @@ errout:
 }
=20
=20
-static void __devexit rtsx_remove(struct pci_dev *pci)
+static void rtsx_remove(struct pci_dev *pci)
 {
 	struct rtsx_dev *dev =3D (struct rtsx_dev *)pci_get_drvdata(pci);
=20
@@ -1092,7 +1091,7 @@ static struct pci_driver driver =3D {
 	.name =3D CR_DRIVER_NAME,
 	.id_table =3D rts5229_ids,
 	.probe =3D rtsx_probe,
-	.remove =3D __devexit_p(rtsx_remove),
+	.remove =3D rtsx_remove,
 #ifdef CONFIG_PM
 	.suspend =3D rtsx_suspend,
 	.resume =3D rtsx_resume,
diff --git a/rtsx.h b/rtsx.h
index 3a1bb2f..98b26c4 100644
--- a/rtsx.h
+++ b/rtsx.h
@@ -52,7 +52,7 @@
 #include "trace.h"
 #include "general.h"
=20
-#define CR_DRIVER_NAME		"rts5229"
+#define CR_DRIVER_NAME		"rts5227"
=20
=20
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 14)

--------------020605060606050500090508--

--md2SAJqIRJv76kXNskqQA5tcDxTH9QgXR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT6BgBAAoJENtLVMukgmoYdvcQANydril5tXzq6c0v5WFrp5DR
yJWwb7eTho1Aj69F24Kh4PxvpuaaqSt9HG7k0kYoxz+VuruhQheWsI7KTWzk43L5
M4HzafECt/dQ8tZGpZUQ38HMo6CNDgVcIy7DpaPAPQB2nZCLGCQ6z17BVZsU9MiW
d1PIU+14xonEJmsmBjNBqTplskRjEzzVpxNSDVXsb/U6Br+vbgEfpD/wUuxw1aha
nn3U2hevqL/Sp5SzlIAge8VPfOtRqlNnSxpNEKnQum1QIbEg6xDIECtZRV45RGd1
djZMeiGyS2+wfyHCK4upZl0g6HKNlFCTUTXZ6bcD3Kvn59fG1iyXkAKomjN1Vz3E
9BiQYOaBr5uadKLJHYfO7Tz3niXtBpJYgYIFQvHktMrPxSJjUcKZCBzaq2mZ8SHV
MJpvLjcIsk+gbXZ4ROI0exejKV2Ije8Tx7EcJhA6fiNboR3o5g4dvve06XmzqhhI
BYwDmI4NuwgFOTUCzEa/AuenNqS9hfnNAzmnxuUm3dVMMfH/RvBiA7gTtQrYpgzt
kWF6+ra8WGkpTvUT98C2XmwVuyker3+autR25uIXT53z8fn8L3Dvik5WaOLSzDWJ
4oYAhEK+WsXiasW1H4UiyF+kg686/lIK/+gyJ4TTbm9gy6Qv2bjDcn2ay2Tu3qoE
WQQOzFMcgNqwPfP+Uy8B
=+uRi
-----END PGP SIGNATURE-----

--md2SAJqIRJv76kXNskqQA5tcDxTH9QgXR--
