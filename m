Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaDVAol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 20:44:41 -0400
Received: from pide.tip.net.au ([101.0.96.218]:42537 "EHLO pide.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbaDVAoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 20:44:38 -0400
Date: Tue, 22 Apr 2014 10:44:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sachin Prabhu <sprabhu@redhat.com>, Steve French <smfrench@gmail.com>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-Id: <20140422104429.988a46145950d9973c235992@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Apr_2014_10_44_29_+1000_7LJH+9RaKJMuNFvH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2014_10_44_29_+1000_7LJH+9RaKJMuNFvH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/cifs/cifsfs.c between commit c11f1df5003d ("cifs: Wait for writebacks
to complete before attempting write") from Linus' tree and commit
30b11990262e ("cifs: switch to ->write_iter()") from the vfs tree.

I fixed it up (maybe - see below) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/cifs/cifsfs.c
index 5be1f997ecde,d101af8889fd..000000000000
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@@ -733,30 -728,22 +733,29 @@@ out_nls
  	goto out;
  }
 =20
- static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec=
 *iov,
- 				   unsigned long nr_segs, loff_t pos)
+ static ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *=
from)
  {
  	struct inode *inode =3D file_inode(iocb->ki_filp);
 +	struct cifsInodeInfo *cinode =3D CIFS_I(inode);
  	ssize_t written;
  	int rc;
 =20
 +	written =3D cifs_get_writer(cinode);
 +	if (written)
 +		return written;
 +
- 	written =3D generic_file_aio_write(iocb, iov, nr_segs, pos);
+ 	written =3D generic_file_write_iter(iocb, from);
 =20
  	if (CIFS_CACHE_WRITE(CIFS_I(inode)))
 -		return written;
 +		goto out;
 =20
  	rc =3D filemap_fdatawrite(inode->i_mapping);
  	if (rc)
- 		cifs_dbg(FYI, "cifs_file_aio_write: %d rc on %p inode\n",
+ 		cifs_dbg(FYI, "cifs_file_write_iter: %d rc on %p inode\n",
  			 rc, inode);
 =20
 +out:
 +	cifs_put_writer(cinode);
  	return written;
  }
 =20

--Signature=_Tue__22_Apr_2014_10_44_29_+1000_7LJH+9RaKJMuNFvH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVbtyAAoJEMDTa8Ir7ZwV/pIP/iyWeRIyuJFJShXN0NQtO30I
9WN/68r2djwjQqow+Rc0hRQDzkMaB3Vw5oWEfiQUwJLGi3HzWyUwPLkgJWvosyko
eMtBNe89DnzRx9Vlz9SF6hr1MCG9t66qtJaCKDSFIGgf23KoTSaTfUFjHr2TMMQ7
erbpJI5mOazKFfl1KRuznkknfODMHiDrBXeHYqPkXQZpYgxrAhGaksL3+AD5nq/Z
xnJC92PFDJumCtqrdwT4ttWZ794cHs/nQPlO7kd7pGwF8iepyxsK1s2RaZIqxOi8
o6GYxlDnCfiFc4Esi7397e+uioq689O1888AL6KYVZUho2JcrEdge4l/cz4crN13
PsV+Jskpu6AYbrSUEdEGqdCn34pyg5ph1Kjj804/0enOmVRkzFQlKZYgNDSQxy2e
hu9Xh+RQJqPsjR+qsCdTjgH2TW3n9qiwdUWrxF6gXNjot54IgAjHaLYkTpj64uGz
gfdps0PxP8wu3p6b8b94tmhhRwN/Qns/oHcwE31L1fCHcNqYRJibDeuYbdXNHA0u
Y8Ly2K2eq8k82xIEGZ42V4f5Q+WfKXrCBcBOh5eJ2qGRkr0i8IAUKOxkng0zBk4S
MMpfuVElJqHOS4m3uyn47gOFNKKfkfpvTtRT/EFQ2X7bSocc4I0QIROECUnEgOUS
qLyHGyY1LFFaaEEXcNQ0
=aVzU
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2014_10_44_29_+1000_7LJH+9RaKJMuNFvH--
