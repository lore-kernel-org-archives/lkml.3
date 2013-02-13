Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab3BMCGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:06:10 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46596 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3BMCGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:06:08 -0500
Date: Wed, 13 Feb 2013 13:05:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: linux-next: manual merge of the ia64 tree with Linus' tree
Message-Id: <20130213130559.dd6b2ac2c59093cc1794f41b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Feb_2013_13_05_59_+1100_Q_j8Ovl9dXuJuf4l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Feb_2013_13_05_59_+1100_Q_j8Ovl9dXuJuf4l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the ia64 tree got a conflict in
drivers/firmware/efivars.c between commit 83e68189745a ("efi: Make
'efi_enabled' a function to query EFI facilities") from the  tree and
commit a93bc0c6e07e ("efi_pstore: Introducing workqueue updating sysfs")
from the ia64 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/firmware/efivars.c
index f5596db,6922511..0000000
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@@ -790,10 -798,9 +798,10 @@@ static ssize_t efivarfs_file_write(stru
 =20
  	} else if (status =3D=3D EFI_NOT_FOUND) {
  		list_del(&var->list);
- 		spin_unlock(&efivars->lock);
+ 		spin_unlock_irq(&efivars->lock);
  		efivar_unregister(var);
  		drop_nlink(inode);
 +		d_delete(file->f_dentry);
  		dput(file->f_dentry);
 =20
  	} else {
@@@ -993,9 -1000,9 +1001,9 @@@ static int efivarfs_unlink(struct inod
 =20
  	if (status =3D=3D EFI_SUCCESS || status =3D=3D EFI_NOT_FOUND) {
  		list_del(&var->list);
- 		spin_unlock(&efivars->lock);
+ 		spin_unlock_irq(&efivars->lock);
  		efivar_unregister(var);
 -		drop_nlink(dir);
 +		drop_nlink(dentry->d_inode);
  		dput(dentry);
  		return 0;
  	}
@@@ -1823,7 -1906,9 +1907,9 @@@ err_put
  static void __exit
  efivars_exit(void)
  {
+ 	cancel_work_sync(&efivar_work);
+=20
 -	if (efi_enabled) {
 +	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
  		unregister_efivars(&__efivars);
  		kobject_put(efi_kobj);
  	}

--Signature=_Wed__13_Feb_2013_13_05_59_+1100_Q_j8Ovl9dXuJuf4l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGvUHAAoJEECxmPOUX5FEbO0P/3SexI9LcvZm4zRxiCWscJK2
NzS2MB2RIGkeWS3eKiIZ30gCM0cVHl14Ixur9QT43XkaYMOzNRF/7zePzWms//7s
OOykxawT5zJet2wpM3c13VyxWysV+kn6230VKdfWNH9PR9xTm+Hq3j+t+lL+QqI3
CfdmN0GRqxYhAcm6ZyYlSToXKbpMpeiCDY2gJ8VzLopvzKR5B5U7El2o3TzGGrzY
mv74eJI4/9JxmEZwjq0TjdNoQPhwgtLfZ4n3/OFMNOKCMXXkVvFlfHNSnI15hkxF
L6dt1ksJGpeQYvfSGjrPPwY/Bk+5UWncwVs4D4YVhuN4jI/YyFw7VxZCFAFns/YV
sqv6K3ARnu0m0tTT58DmYX+DOhFeZs6NbcDQAOFFY2mYFKIt2nJAe5ZFmT4NRLkv
9wFE93isA/EVp2uhYW9L7vzcoa04NDwptQ6mO/eGZZCVb8VOE70kKSjQubfNMXD6
YXkrcx5OY/k+ILTbN+q9eoonjb21YVGxfrtNLJGRfHDzdTOEFc75nrsOa/4CcG9x
2UqEFoj+vnUd16ZyzIpoR+gAC+q3ZR/SmBFL+ieFfZolqAAhXXAb04HDYlvhM6mX
u3zqRVKnDi7o5D/BPD1xeeKMXdyYn6Iaw3AEo2vtUr9Gqfg7U/L7Ty39n0Vq9K70
8ucX5nc1/3PjRWR1Ll2Q
=fEwd
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Feb_2013_13_05_59_+1100_Q_j8Ovl9dXuJuf4l--
