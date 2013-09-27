Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3I0HKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 03:10:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59402 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3I0HKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 03:10:42 -0400
Date: Fri, 27 Sep 2013 17:10:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Sudeep Dutt <sudeep.dutt@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>
Subject: linux-next: build failure after merge of the char-misc tree
Message-Id: <20130927171029.609cf783d3f9645ebe7117c0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Sep_2013_17_10_29_+1000_aFGmXdV+AYEzeWiF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Sep_2013_17_10_29_+1000_aFGmXdV+AYEzeWiF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the char-misc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/misc/mic/host/mic_main.c: In function 'mic_probe':
drivers/misc/mic/host/mic_main.c:320:3: error: too many arguments to functi=
on 'sysfs_get_dirent'
   NULL, "state");
   ^
In file included from include/linux/kobject.h:21:0,
                 from include/linux/module.h:16,
                 from drivers/misc/mic/host/mic_main.c:26:
include/linux/sysfs.h:465:1: note: declared here
 sysfs_get_dirent(struct sysfs_dirent *parent_sd, const unsigned char *name)
 ^

Caused by commit 3a6a9201897c ("Intel MIC Host Driver, card OS state
management") interacting with commit 388975cccaaf ("sysfs: clean up
sysfs_get_dirent()") from the driver-core tree.

I added this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 27 Sep 2013 17:07:12 +1000
Subject: [PATCH] Intel MIC Host Driver: fix for sysfs_get_dirent API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/misc/mic/host/mic_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/mic/host/mic_main.c b/drivers/misc/mic/host/mic_m=
ain.c
index a8965d4..28c8490 100644
--- a/drivers/misc/mic/host/mic_main.c
+++ b/drivers/misc/mic/host/mic_main.c
@@ -316,8 +316,7 @@ static int mic_probe(struct pci_dev *pdev,
 			"device_create_with_groups failed rc %d\n", rc);
 		goto smpt_uninit;
 	}
-	mdev->state_sysfs =3D sysfs_get_dirent(mdev->sdev->kobj.sd,
-		NULL, "state");
+	mdev->state_sysfs =3D sysfs_get_dirent(mdev->sdev->kobj.sd, "state");
 	if (!mdev->state_sysfs) {
 		rc =3D -ENODEV;
 		dev_err(&pdev->dev, "sysfs_get_dirent failed rc %d\n", rc);
--=20
1.8.4.rc3


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Sep_2013_17_10_29_+1000_aFGmXdV+AYEzeWiF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSRS9qAAoJEMDTa8Ir7ZwVwrIP/0lJQVy8Neql76KIJ1ctTdWV
e5HtVbp2fwrvj23nOfTVOsuqNbyalPiTKF9BmPX0GK7e87Lf4z61EhLmg2oCGjjQ
xSepSEXsJbEM+gP208pobGgx6W4RobIkanHQ1xa/dk420T4mqLSCFW552iBdDKRi
c+Bpfe5F2mRjUwrvd+CSu+tU9UdZ3aJAkccPz+osQAZAc/5iwsy/5CA0fuDZ6yOP
3x7BuVAEESwEVgkWcqcZXGI68qwFgfxKM2ngW5uyeIcSy8FTdDrEdKMBk/iwNQ5l
G41DK8SjLteLaqf7WNFaV8zINu2hvGKhdG2+P+2QEB/4OVm5LVY+bh3gjkodGvxi
GKZUXqij6vyN007SwiViAaXKjH9sNtHubd7qZVYf4Kqd05keoJtwUTFB3oBatQZ5
408HLoIvJZ+MqRo7yOJawcP+tW+CK/juSfP4tqpC7iKTs7mn+jSHW6dWpbvFsXNA
ewZzy69fElDHvXN8QPPJ71vmtQ97pyhe/eSYcd0VQcprZzX3HRtaHcoeTNgTQZva
IW9JjeFpyO08nnYuUiDrk4JSxaF9FaxzIonWHn8S00+EmaVaZ7pa1UXDlWJZ4Hlk
c1dPGECruaQhtoq8wfbz5gcnqKd8II9cUjFr0nVzQO1e73Nr01xmkXdBwhxAHJzI
RQu3Td45Mg31KKSZiLMo
=HrbI
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Sep_2013_17_10_29_+1000_aFGmXdV+AYEzeWiF--
