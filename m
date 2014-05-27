Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaE0CIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 22:08:05 -0400
Received: from ozlabs.org ([103.22.144.67]:49185 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbaE0CIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 22:08:04 -0400
Date: Tue, 27 May 2014 12:07:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: linux-next: manual merge of the vfs tree with the ext4 tree
Message-ID: <20140527120753.5fd79bc1@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/u6kRYbMbNuw5ATCzaOnTk7j"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/u6kRYbMbNuw5ATCzaOnTk7j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/ext4/file.c between commit 00532604c72e ("ext4: introduce new
i_write_mutex to protect fallocate") from the ext4 tree and commit
9b884164d597 ("convert ext4 to ->write_iter()") from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/file.c
index 8c39305abc23,708aad768199..000000000000
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@@ -101,13 -97,10 +97,12 @@@ ext4_file_write_iter(struct kiocb *iocb
  	struct blk_plug plug;
  	int o_direct =3D file->f_flags & O_DIRECT;
  	int overwrite =3D 0;
- 	size_t length =3D iov_length(iov, nr_segs);
+ 	size_t length =3D iov_iter_count(from);
  	ssize_t ret;
-=20
- 	BUG_ON(iocb->ki_pos !=3D pos);
+ 	loff_t pos =3D iocb->ki_pos;
 =20
 +	mutex_lock(&EXT4_I(inode)->i_write_mutex);
 +
  	/*
  	 * Unaligned direct AIO must be serialized; see comment above
  	 * In the case of O_APPEND, assume that we must always serialize
@@@ -116,8 -109,9 +111,8 @@@
  	    ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
  	    !is_sync_kiocb(iocb) &&
  	    (file->f_flags & O_APPEND ||
- 	     ext4_unaligned_aio(inode, iov, nr_segs, pos))) {
+ 	     ext4_unaligned_aio(inode, from, pos))) {
 -		aio_mutex =3D ext4_aio_mutex(inode);
 -		mutex_lock(aio_mutex);
 +		unaligned_direct_aio =3D true;
  		ext4_unwritten_wait(inode);
  	}
 =20
@@@ -181,10 -172,8 +174,10 @@@
  		}
  	}
 =20
- 	ret =3D __generic_file_aio_write(iocb, iov, nr_segs);
+ 	ret =3D __generic_file_write_iter(iocb, from);
  	mutex_unlock(&inode->i_mutex);
 +	if (!unaligned_direct_aio)
 +		mutex_unlock(&EXT4_I(inode)->i_write_mutex);
 =20
  	if (ret > 0) {
  		ssize_t err;

--Sig_/u6kRYbMbNuw5ATCzaOnTk7j
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTg/OAAAoJEMDTa8Ir7ZwVL6EP/RSdfs0KcT86rWzZLwyNPj2A
Gt1UG3h4BkNkMb4JSH0wYOcxg9X2BIs+U4wmwOAV3vLvPDw74T/i/TNsAFRmoIaD
ed186ikiH50r1z8GHGPZ5mtNAUsTCJHrKs0N3CLcNWJn9yipbbOq2BZNyW4rZ4/d
tVz6AlsdwBqObWHGIzfM/n2B9I8vWCwy95ZmPo+weeKtl8X+bnrb02n3DhRUQJvK
RDDAaHxWbbCpuYQYVuJZ2UHPwKdKbBKFuSoRwqrvHCptFNcK664WsK86Km4V9Klp
bpQkMjGQH147tTrv2y9Rm/Nn7gYAqU+16LAQPLydQ1QMN5lt4EDw5eODFE3XUtGz
A/aZh9KCOfaFbPxtvN/wNwSVFraH4eAPbD0hl9EMGwOd8PJ6IdS2AZH9stU9uqMw
nm/iixOh6GSIHMIz9u4k+2ijQMd87oQITfXBQrP/FekScT356X2jZpiiFNHMq8be
lpCqefckvpWQZzrSKcnDpqrEazJ5jLg64sJtAaSq9Lctz2QzhGRUuU6n5Yk2eX0n
bGUp9yE2UagI54CCmldB41PQV5cfnBZLFH4GPwJSIZU1a6YAnvo3iIsiQQ5BG0ZL
U9pIgEXvhcym1C/OmihbCFmIGHzJsnjj1N/1RUDZrlK6zZ3FC90z4KX0MFo+Pi+A
zLVnHOcmo/TaQm1nxsT0
=9SXE
-----END PGP SIGNATURE-----

--Sig_/u6kRYbMbNuw5ATCzaOnTk7j--
