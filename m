Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaIHFMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 01:12:12 -0400
Received: from ozlabs.org ([103.22.144.67]:47064 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbaIHFMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 01:12:09 -0400
Date: Mon, 8 Sep 2014 15:12:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kinglong Mee <kinglongmee@gmail.com>
Subject: linux-next: manual merge of the integrity tree with the nfsd tree
Message-ID: <20140908151201.333065c6@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/zxMy0eaiHVm+GFm=Q33ssw/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zxMy0eaiHVm+GFm=Q33ssw/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the integrity tree got a conflict in
fs/nfsd/vfs.c between commit 9b638b816081 ("NFSD: Put file after
ima_file_check fail in nfsd_open()") from the nfsd tree and commit
e8442e203c25 ("ima: pass 'opened' flag to identify newly created
files") from the integrity tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nfsd/vfs.c
index 89d1ae3bcff7,d49c778faecb..000000000000
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@@ -704,25 -704,19 +704,25 @@@ nfsd_open(struct svc_rqst *rqstp, struc
  		else
  			flags =3D O_WRONLY|O_LARGEFILE;
  	}
 -	*filp =3D dentry_open(&path, flags, current_cred());
 -	if (IS_ERR(*filp)) {
 -		host_err =3D PTR_ERR(*filp);
 -		*filp =3D NULL;
 -	} else {
 -		host_err =3D ima_file_check(*filp, may_flags, 0);
 =20
 -		if (may_flags & NFSD_MAY_64BIT_COOKIE)
 -			(*filp)->f_mode |=3D FMODE_64BITHASH;
 -		else
 -			(*filp)->f_mode |=3D FMODE_32BITHASH;
 +	file =3D dentry_open(&path, flags, current_cred());
 +	if (IS_ERR(file)) {
 +		host_err =3D PTR_ERR(file);
 +		goto out_nfserr;
  	}
 =20
- 	host_err =3D ima_file_check(file, may_flags);
++	host_err =3D ima_file_check(file, may_flags, 0);
 +	if (host_err) {
 +		nfsd_close(file);
 +		goto out_nfserr;
 +	}
 +
 +	if (may_flags & NFSD_MAY_64BIT_COOKIE)
 +		file->f_mode |=3D FMODE_64BITHASH;
 +	else
 +		file->f_mode |=3D FMODE_32BITHASH;
 +
 +	*filp =3D file;
  out_nfserr:
  	err =3D nfserrno(host_err);
  out:

--Sig_/zxMy0eaiHVm+GFm=Q33ssw/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDTqmAAoJEMDTa8Ir7ZwVf4YP/2n3apoXrGKFp5/uzc0cJ3qf
9ev4nNbH0rIyhnb+nDLguT8PzVed9gDG/0Evl0+k/8edP7XkX6vBy7ntPCBzW786
BSwMOZKKtFYWEnJLh8dLsjWB0J1M8ebZhSraj7am8U9QN0Nd2Gz21N5qXXcAqM1B
8b6LJamYwDRzDxZqudSGJ8HSaMGiKeToOCJrAw2wwHkWV4hLLzklyiUdDXvRhZcG
kPmKLWWujH+7R1oZk0EEgnuja1SLZklDRZR6Xz0chCDUkDpyr9KO+Psyb8ojP2nR
V/mmSk6okJMIIZuk58cWuSz34JtcS7TuyqqFJM7p+iMQ/6Ikpflpo1D/ZytHWuIR
4HVNoGugAZkzqC+4NiodFkqf1VDVDS5bSWuOXqLc32JTho9j5qKJBgmqnvywVgS+
KJkiUKH6u/5Dop89wEicc9xfMCzgyLD4Nc2Rpybqa08Xq8xCQ9XrPg7kH+gD6Hed
iESzfSD/sAVFB3eFG5XsEn9d0Ut4v1FKG9rCRensVYsrsXD93KJPmrxxy7eupkFg
SpQppmq3S3zZ7xQML8xHsJ47VF6DmcNvc7X+QXIgiSf1RmGbr2FsOuj9ma8tsCX+
h002PvxVDV9/gGIe+CK0/9SJPrzkbx/x2MhVK2ZlImlEO0ijsZfRUDbeuhpwi5c7
742IYKATE17bRHKSFzpH
=9sEZ
-----END PGP SIGNATURE-----

--Sig_/zxMy0eaiHVm+GFm=Q33ssw/--
