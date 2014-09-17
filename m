Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaIQGRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 02:17:15 -0400
Received: from ozlabs.org ([103.22.144.67]:44151 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbaIQGRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 02:17:12 -0400
Date: Wed, 17 Sep 2014 16:16:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: linux-next: manual merge of the usb-gadget tree with the vfs tree
Message-ID: <20140917161658.2e4eb3f1@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8G_xRFuK7qZHFIHrB9T/Myr"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8G_xRFuK7qZHFIHrB9T/Myr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/gadget/function/f_fs.c between commit 8322215aa91c ("f_fs:
saner API for ffs_sb_create_file()") from the vfs tree and commit
1b0bf88fd8b8 ("usb: gadget: f_fs: virtual endpoint address mapping")
from the usb-gadget tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/gadget/function/f_fs.c
index 4726e278e557,4ad11e03cf54..000000000000
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@@ -1529,11 -1557,13 +1552,14 @@@ static int ffs_epfiles_create(struct ff
  		epfile->ffs =3D ffs;
  		mutex_init(&epfile->mutex);
  		init_waitqueue_head(&epfile->wait);
- 		sprintf(epfiles->name, "ep%u",  i);
+ 		if (ffs->user_flags & FUNCTIONFS_VIRTUAL_ADDR)
+ 			sprintf(epfiles->name, "ep%02x", ffs->eps_addrmap[i]);
+ 		else
+ 			sprintf(epfiles->name, "ep%u", i);
 -		if (!unlikely(ffs_sb_create_file(ffs->sb, epfiles->name, epfile,
 -						 &ffs_epfile_operations,
 -						 &epfile->dentry))) {
 +		epfile->dentry =3D ffs_sb_create_file(ffs->sb, epfiles->name,
 +						 epfile,
 +						 &ffs_epfile_operations);
 +		if (unlikely(!epfile->dentry)) {
  			ffs_epfiles_destroy(epfiles, i - 1);
  			return -ENOMEM;
  		}

--Sig_/8G_xRFuK7qZHFIHrB9T/Myr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUGSdeAAoJEMDTa8Ir7ZwVxGQP/0TTQ2tNMqYUF21vlVsuNBBU
1Un+dVvl0Q2ZHH/2Tnb68wKm6y0tFtLvukMc3yr4enByC5LtrYzGsRmWpzuPvRly
p40VlVB0vpauuwaNeqSMz8QMmfcbL3tw2zN57WHRkguLqlw0kQA0XOewYAhR6FB/
NYYIN/OckDS16TtsL1580eL81+HRSXUBMfbQpI7iicD6S4fJFVzUKVw9yiUB+wvU
XYUlbsEtuZJyBuKQLfPStR1/caJmY9aooZBDHS2Rd99DlIGKDr90mN6fnDwlyHBn
sRT20+OHL94uwe9e5G/9U0YnFJXrJbwTmNJyxVCkN/ylsVcactqODloVF90WyXcQ
QtdE8zDSKyvbdlgw9xcY4CwkLEuQ7Lkz7Y15KzsX3whGvb49BtfMpzvQcZ7q7WIr
sPJrBCQnEBX+zibzamssg0TVSbN4879FVdhOSfVhfXekP8nF9uJ8rs1jr08BowOm
4IOX7OHfX3cef7X5QtD2TpKdqJ5FUHtgVmfZPPhTmDd5+ZuOGh6u7oz8Gnv96N0I
E6YPDlt6akLDExLjhMXviT3erlZ0Q+2a9HqGHGG5frqAXeoCnmlmn7oXMnl5XE56
10dJAAJd4Mr8XgIKMz8y9gvnEiuRUtA83XYTBP7xnwxgpXl57EdmK9TDT/Y9qi/Z
zo+8/VA909wsZapC1O1t
=QGi4
-----END PGP SIGNATURE-----

--Sig_/8G_xRFuK7qZHFIHrB9T/Myr--
