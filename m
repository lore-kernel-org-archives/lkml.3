Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab3DDCQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:16:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59986 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab3DDCQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:16:43 -0400
Date: Thu, 4 Apr 2013 13:16:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: linux-next: manual merge of the block tree with the vfs tree
Message-Id: <20130404131629.d1ffe5d533045393d1fb7bf7@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_13_16_29_+1100_wFaw.VsM8jglm/V+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_13_16_29_+1100_wFaw.VsM8jglm/V+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/block/drbd/drbd_proc.c between commit 4dfac87dca02 ("procfs: new
helper - PDE_DATA(inode)") from the vfs tree and commit 193d01532a73
("drbd: add module_put() on error path in drbd_proc_open()") from the
block tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/block/drbd/drbd_proc.c
index 928adb8,30fe0a5..0000000
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@@ -313,8 -313,14 +313,14 @@@ static int drbd_seq_show(struct seq_fil
 =20
  static int drbd_proc_open(struct inode *inode, struct file *file)
  {
- 	if (try_module_get(THIS_MODULE))
- 		return single_open(file, drbd_seq_show, PDE_DATA(inode));
+ 	int err;
+=20
+ 	if (try_module_get(THIS_MODULE)) {
 -		err =3D single_open(file, drbd_seq_show, PDE(inode)->data);
++		err =3D single_open(file, drbd_seq_show, PDE_DATA(inode));
+ 		if (err)
+ 			module_put(THIS_MODULE);
+ 		return err;
+ 	}
  	return -ENODEV;
  }
 =20

--Signature=_Thu__4_Apr_2013_13_16_29_+1100_wFaw.VsM8jglm/V+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXOJ9AAoJEECxmPOUX5FEHgUP/3HaXp4MKYhMmvPiejWHXqTA
vm14Ava9QRNFukJCLyVgOdq2xjuahTm6ExobwGDjH+96+YIiBIyw1ZoLjY+2t5PR
nMOQNHmJrmFg5SIylXlHvddX6JE/otAJW4w0vl7Dbh41Lu9oBNW+9O+lbBbENUYq
OV5idlqqHUz3k1kRr8At9H3pVjSCt6sC+0Dm1hQ+AqtzbdZQNIzkMoIOptQRxMHk
ZCvdg0C/+InMbeVcobGKvk+Jjbl37kpDpcc7vGWMkMKEcKuRIOE9yRD8Lp+mFZ0J
3Uwf2V8AzIG7pGgEIiRYDPpBfiFU+D0jWVxcHAmnPorggLpFFVvJZ+7OJf5+CiPR
YV1pFlhJCuH37Ce0gTUEFDmDp8osTOPCZErnx8QiKdOR5aw6fGzYeJa5qAMs5wsc
G+9227w7VhyDh6NctCD8SJESd3l+Gcf4i0gfRYm7JQnpnAbYM5W2VriG1lVanx7O
x8u7BjKqEso2GJWJ/CsxBlcmrC422KLUEQYNsOu3zTqGCslA/DmrlWxElUdiskDW
Xm3hojMsbbyzyxrE8gTGjB1qm9lWvy3+dGQ1SeeCi2YdyJZZTvkxQmzos41J87z9
uSHL13DXDJ3EJQ+ba8Lish8lngkV7yoBy7vodLTSbkoSu6TqMcJyiyibFERidrWJ
ILFKmbk5cDGjDtlrJwu6
=v096
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_13_16_29_+1100_wFaw.VsM8jglm/V+--
