Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab3BOEqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 23:46:04 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43131 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766Ab3BOEqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 23:46:03 -0500
Date: Fri, 15 Feb 2013 15:45:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liu Jinsong <jinsong.liu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: build failure after merge of the xen-two tree
Message-Id: <20130215154551.d11e9d376d30d32b9673e6cc@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Feb_2013_15_45_51_+1100_0y09pfsRKLtK7dNw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2013_15_45_51_+1100_0y09pfsRKLtK7dNw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

After merging the xen-two tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/xen/xen-acpi-memhotplug.c: In function 'acpi_memory_get_device':
drivers/xen/xen-acpi-memhotplug.c:191:2: error: implicit declaration of fun=
ction 'acpi_bus_add' [-Werror=3Dimplicit-function-declaration]
drivers/xen/xen-acpi-memhotplug.c: At top level:
drivers/xen/xen-acpi-memhotplug.c:417:3: warning: initialization from incom=
patible pointer type [enabled by default]
drivers/xen/xen-acpi-memhotplug.c:417:3: warning: (near initialization for =
'xen_acpi_memory_device_driver.ops.remove') [enabled by default]

Caused by commit 259f201cb7ea ("xen/acpi: ACPI memory hotplug").

drivers/xen/xen-acpi-cpuhotplug.c: In function 'acpi_processor_device_add':
drivers/xen/xen-acpi-cpuhotplug.c:254:2: error: implicit declaration of fun=
ction 'acpi_bus_add' [-Werror=3Dimplicit-function-declaration]
drivers/xen/xen-acpi-cpuhotplug.c: At top level:
drivers/xen/xen-acpi-cpuhotplug.c:425:3: warning: initialization from incom=
patible pointer type [enabled by default]
drivers/xen/xen-acpi-cpuhotplug.c:425:3: warning: (near initialization for =
'xen_acpi_processor_driver.ops.remove') [enabled by default]

Caused by commit 181232c249f0 ("xen/acpi: ACPI cpu hotplug").

These commits interacted with commits 636458de36f1 ("ACPI: Remove the
arguments of acpi_bus_add() that are not used"), 0cd6ac52b333 ("ACPI:
Make acpi_bus_scan() and acpi_bus_add() take only one argument") and
b8bd759acd05 ("ACPI / scan: Drop acpi_bus_add() and use acpi_bus_scan()
instead") from the pm tree.

I have added this merge fix patch and can carry it as necessary (I did
*not* fix the warnings above):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 15 Feb 2013 15:37:27 +1100
Subject: [PATCH] xen/acpi: fix up for apci_bus_add api change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/xen/xen-acpi-cpuhotplug.c | 2 +-
 drivers/xen/xen-acpi-memhotplug.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-acpi-cpuhotplug.c b/drivers/xen/xen-acpi-cpuho=
tplug.c
index 9eefbb0..0db4722 100644
--- a/drivers/xen/xen-acpi-cpuhotplug.c
+++ b/drivers/xen/xen-acpi-cpuhotplug.c
@@ -251,7 +251,7 @@ int acpi_processor_device_add(acpi_handle handle, struc=
t acpi_device **device)
 	if (acpi_bus_get_device(phandle, &pdev))
 		return -ENODEV;
=20
-	if (acpi_bus_add(device, pdev, handle, ACPI_BUS_TYPE_PROCESSOR))
+	if (acpi_bus_scan(handle))
 		return -ENODEV;
=20
 	return 0;
diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memho=
tplug.c
index 678680c..164287b 100644
--- a/drivers/xen/xen-acpi-memhotplug.c
+++ b/drivers/xen/xen-acpi-memhotplug.c
@@ -188,7 +188,7 @@ acpi_memory_get_device(acpi_handle handle,
 	 * Now add the notified device.  This creates the acpi_device
 	 * and invokes .add function
 	 */
-	result =3D acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE);
+	result =3D acpi_bus_scan(handle);
 	if (result) {
 		pr_warn(PREFIX "Cannot add acpi bus\n");
 		return -EINVAL;
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__15_Feb_2013_15_45_51_+1100_0y09pfsRKLtK7dNw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHb1/AAoJEECxmPOUX5FEiesP/0yV+u+ydQ1Eq0nLa9WE+jo3
3SPy/zsyF2KrYX1Hj7xLyoknVc8Ciy+wbCPOGHLXhb994C9iEzlbLaMkh/+ovg/5
s5AKOO5WFgJ90flOo6qGDGoT1pz5z7lMtpMoT3pyXyPZRdl1QRNipFEtsrl8jDEy
LEACPswsxODexoi7ucK1kuoHpc+wW1zPQLGgynOqc7aOZyVrAOOkXis3AadBWKw+
daOOHl8YaCfY4BRLzMfvTB0vJoWK1O02qwhx/OltlVGGFKw2ApgA7aZX5rGEgX6x
4TsTTxJQkWNCcgCKC6d3RTwQxtJ/t6SMMP9PHRB2PP+rfy6Tz/1uw5XDG9f081Su
qKSxb9XCTVSZn+yn2RDdXdq1Q3dN7IY2/eVZ312rUNsH/R0+TTAkQ5HKi/oBzgfT
qsex90flE1oChV9ZuNptaiTxmYKcHzS6FOuOijAfRU2zq8JV0inCt/9GAcQw+pw3
T5/iohi2XQr/ceKxzMos1CYgWxC5K0nc8n7oVUPSL/TeYFPD7APRh0JJLmaSCvzw
g9a7bOgtE0Ll5YhJ9cZphmrWEvci/c5VB1MFPYTIjwzOF1+bMo9ctME/w9QfBycb
voYepaf5Mq//sZs/dZ4k0cOPSCMjFxcJMKwyCtB/1C3hhrspaWJ6vRjuH5LwGs5A
JH7he6Y7zk3OUU9u9mHQ
=GdNC
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2013_15_45_51_+1100_0y09pfsRKLtK7dNw--
