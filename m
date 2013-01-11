Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3AKBDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 20:03:32 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53079 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3AKBDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 20:03:31 -0500
Date: Fri, 11 Jan 2013 12:03:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wen Xiong <wenxiong@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>
Subject: linux-next: build failure after merge of the scsi tree
Message-Id: <20130111120323.cdc06081d0fb1c498c9f1779@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Jan_2013_12_03_23_+1100_Fe+_lha2Y2ES2nhw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Jan_2013_12_03_23_+1100_Fe+_lha2Y2ES2nhw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/scsi/ipr.c:9138:22: error: expected '=3D', ',', ';', 'asm' or '__at=
tribute__' before 'ipr_enable_msix'
drivers/scsi/ipr.c:9165:22: error: expected '=3D', ',', ';', 'asm' or '__at=
tribute__' before 'ipr_enable_msi'
drivers/scsi/ipr.c:9188:23: error: expected '=3D', ',', ';', 'asm' or '__at=
tribute__' before 'name_msi_vectors'
drivers/scsi/ipr.c:9200:22: error: expected '=3D', ',', ';', 'asm' or '__at=
tribute__' before 'ipr_request_other_msi_irqs'
drivers/scsi/ipr.c: In function 'ipr_probe_ioa':
drivers/scsi/ipr.c:9422:4: error: implicit declaration of function 'ipr_ena=
ble_msix' [-Werror=3Dimplicit-function-declaration]
drivers/scsi/ipr.c:9425:4: error: implicit declaration of function 'ipr_ena=
ble_msi' [-Werror=3Dimplicit-function-declaration]
drivers/scsi/ipr.c:9517:3: error: implicit declaration of function 'name_ms=
i_vectors' [-Werror=3Dimplicit-function-declaration]
drivers/scsi/ipr.c:9523:4: error: implicit declaration of function 'ipr_req=
uest_other_msi_irqs' [-Werror=3Dimplicit-function-declaration]

Caused by commit 7af0de314b73 ("[SCSI] ipr: Add support for MSI-X and
distributed completion") interacting with commit 54b956b90360 ("Remove
__dev* markings from init.h") from the drover-core.current tree.

I have added the following merge fix patch for today which could be added
directly to the scsi tree (please).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 11 Jan 2013 11:59:34 +1100
Subject: [PATCH] [SCSI] ipr: remove new __dev* annotations

CONFIG_HOTPLUG is always true now and the __dev* macros have been removed.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/ipr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index e1ef0b1..8fe61da 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9135,7 +9135,7 @@ ipr_get_chip_info(const struct pci_device_id *dev_id)
 	return NULL;
 }
=20
-static int __devinit ipr_enable_msix(struct ipr_ioa_cfg *ioa_cfg)
+static int ipr_enable_msix(struct ipr_ioa_cfg *ioa_cfg)
 {
 	struct msix_entry entries[IPR_MAX_MSIX_VECTORS];
 	int i, err, vectors;
@@ -9162,7 +9162,7 @@ static int __devinit ipr_enable_msix(struct ipr_ioa_c=
fg *ioa_cfg)
 	return err;
 }
=20
-static int __devinit ipr_enable_msi(struct ipr_ioa_cfg *ioa_cfg)
+static int ipr_enable_msi(struct ipr_ioa_cfg *ioa_cfg)
 {
 	int i, err, vectors;
=20
@@ -9185,7 +9185,7 @@ static int __devinit ipr_enable_msi(struct ipr_ioa_cf=
g *ioa_cfg)
 	return err;
 }
=20
-static void __devinit name_msi_vectors(struct ipr_ioa_cfg *ioa_cfg)
+static void name_msi_vectors(struct ipr_ioa_cfg *ioa_cfg)
 {
 	int vec_idx, n =3D sizeof(ioa_cfg->vectors_info[0].desc) - 1;
=20
@@ -9197,7 +9197,7 @@ static void __devinit name_msi_vectors(struct ipr_ioa=
_cfg *ioa_cfg)
 	}
 }
=20
-static int __devinit ipr_request_other_msi_irqs(struct ipr_ioa_cfg *ioa_cf=
g)
+static int ipr_request_other_msi_irqs(struct ipr_ioa_cfg *ioa_cfg)
 {
 	int i, rc;
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__11_Jan_2013_12_03_23_+1100_Fe+_lha2Y2ES2nhw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ72TbAAoJEECxmPOUX5FE24gP/2JZQfgl52dreBOwXjKdHAi2
C3X9wTurRoUG1zsX2mGyXD1iGpyiW9UAJpl1bDYyECVPOf3HFJ3FLuB718gok2hw
ozTRIabKBMyftcyWnf4P/KArK7Rrn21qHRYhcYYZ4W2wtiopvX63xKpCJbBikAPu
pXeHhqHjRDgYPwnHXdrLs27pfUrqB4cyb1ahKeHPGMLib0VM/3zs8kLuBE8lb1Sn
Eu5ntOffTX4tLbt7o3/GeXpkh6/VzK4dl/jVNKmb14QZ/7493itjqw96eetXkkpf
uZ9953zzLh7HQ0cd/YgB8q3OwchWiiPnnuBlc3wA+OrGI5jOZ0wE2z2jwKr/w6sP
YYxTs/rC2TS3LJtsgQDGK+0wNxffeC1rAf7ZjqxkLOda/3fMtij9QXSgcNWTNaKm
E/4MTxFYxZouZl3l9QPmU4C6r5TA7TlDArnYoW98A8iRtSodiipappsNpM75KMB5
Wp7INDYLBj2KwR/UFRpkYvFCce3w1PrYmSRw8mGPgRaTo6K4Fe4T59WqOIvDkPbV
7WRw7rnMuPzDoPNR15e5MHevKWQ1cspg2Ucj1EoPe16S9IYYw6mz2GCX/29MQMpo
/c+3lgaBaDJkPdGdY9H/GUmIUjafNg/v9BykvaZcCQ1ZvEdprC5XQfsEx+7dogGd
5Ydkv/9UNw5LKOGUr4Se
=jo6c
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Jan_2013_12_03_23_+1100_Fe+_lha2Y2ES2nhw--
