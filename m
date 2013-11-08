Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab3KHBCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 20:02:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35227 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3KHBCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 20:02:14 -0500
Date: Fri, 8 Nov 2013 12:01:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-Id: <20131108120157.de84e99fedd328c7d8ca7a27@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_12_01_57_+1100_Y+XooKzI++/YQDva"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_12_01_57_+1100_Y+XooKzI++/YQDva
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
drivers/usb/core/file.c between commit 469271f8c48f ("drivers: usb: core:
{file,hub,sysfs,usb}.c: Whitespace fixes") from Linus' tree and commit
e84f9e57b90c ("consolidate the reassignments of ->f_op in ->open()
instances") from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/core/file.c
index 3bdfbf88a0ae,fe0d8365411a..000000000000
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@@ -27,29 -27,21 +27,21 @@@
  static const struct file_operations *usb_minors[MAX_USB_MINORS];
  static DECLARE_RWSEM(minor_rwsem);
 =20
 -static int usb_open(struct inode * inode, struct file * file)
 +static int usb_open(struct inode *inode, struct file *file)
  {
- 	int minor =3D iminor(inode);
- 	const struct file_operations *c;
  	int err =3D -ENODEV;
- 	const struct file_operations *old_fops, *new_fops =3D NULL;
+ 	const struct file_operations *new_fops;
 =20
  	down_read(&minor_rwsem);
- 	c =3D usb_minors[minor];
+ 	new_fops =3D fops_get(usb_minors[iminor(inode)]);
 =20
- 	if (!c || !(new_fops =3D fops_get(c)))
+ 	if (!new_fops)
  		goto done;
 =20
- 	old_fops =3D file->f_op;
- 	file->f_op =3D new_fops;
+ 	replace_fops(file, new_fops);
  	/* Curiouser and curiouser... NULL ->open() as "no device" ? */
  	if (file->f_op->open)
 -		err =3D file->f_op->open(inode,file);
 +		err =3D file->f_op->open(inode, file);
- 	if (err) {
- 		fops_put(file->f_op);
- 		file->f_op =3D fops_get(old_fops);
- 	}
- 	fops_put(old_fops);
   done:
  	up_read(&minor_rwsem);
  	return err;

--Signature=_Fri__8_Nov_2013_12_01_57_+1100_Y+XooKzI++/YQDva
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfDgJAAoJEMDTa8Ir7ZwVaqwQAIe4DsoMkHGKBk2qkICXGNMr
+/efy5vFpBdghWoal6nxc3LZirCWv9kaxXxSH3CcBpYolVgw0iMuIQ1QijvzakGT
BHEcVzUP2BgjenaiOe+zvae6OOmx/cMwStFueTfwxdw0Woo+V1gWnpbmP7EwblXL
248hJi+i0aqzm6NfJe+oEENBCFGKlKHfnWp6h/zepFx1hlE4zCONa+t8fUxgiGT0
UHTKFB7k/Ww5kxJyXf8LprQ/DaN9ZHYYgJ7dKD078Y25Rkey73Tkri3E0ejppXLl
G+MEDVL6/JhK9n0xoSeWbbCz8H6oXtJvgasGTSjESJgcuDchVko40y7K5UR1qAiu
aa4s6Y4iFoC1EZhO0lejFtgsfccBSenHl+IqE3VTX1+JhjvM1Obg1F03weUwiPOJ
RdXPXD1by3pUHOAzfYJwZW9O75jALHF8ACF6aa8emYnYWxQMChlSyHk1lDczmZiH
40KZ15HiGHviuJvfdu/LbU0vpnaUNvIJBaG0OpTzTSdB1StEKvNh1oVZn2EmwPm6
jARVyIe5DpatPvFTV6FPyH8ZyiF4y3psWiwJ+douI1z2bZF+VEXs9CMkU77/J31A
iIA3frO99ZRsxCS9ZXzCT2mhAwDD2AzmLzVWogFprG182ix3VRY+7UvDDHMSm+u5
X6PDHGqe5MI1HFk5xXmt
=Nwxr
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_12_01_57_+1100_Y+XooKzI++/YQDva--
