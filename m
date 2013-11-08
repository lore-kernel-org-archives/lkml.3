Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3KHGuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 01:50:05 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49102 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab3KHGuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 01:50:03 -0500
Date: Fri, 8 Nov 2013 17:49:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: linux-next: manual merge of the userns tree with the vfs tree
Message-Id: <20131108174953.e767ce6af474a71d0653cd32@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_17_49_53_+1100_PAgFOm84T+NbM=Qd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_17_49_53_+1100_PAgFOm84T+NbM=Qd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in fs/namei.c
between commits 45b1139e249d ("namei: minor vfs_unlink cleanup"),
0e22d7c4652b ("locks: break delegations on unlink"), 5d375b9f8afb
("locks: helper functions for delegation breaking") and 909b30216356
("locks: break delegations on rename") from the vfs tree and commit
40216baa0101 ("vfs: Lazily remove mounts on unlinked files and
directories. v2") from the userns tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/namei.c
index a4a30e396136,a12c1d31d4c8..000000000000
--- a/fs/namei.c
+++ b/fs/namei.c
@@@ -3645,22 -3670,16 +3659,20 @@@ int vfs_unlink(struct inode *dir, struc
  	if (!dir->i_op->unlink)
  		return -EPERM;
 =20
 -	mutex_lock(&dentry->d_inode->i_mutex);
 +	mutex_lock(&target->i_mutex);
- 	if (d_mountpoint(dentry))
- 		error =3D -EBUSY;
- 	else {
- 		error =3D security_inode_unlink(dir, dentry);
+ 	error =3D security_inode_unlink(dir, dentry);
+ 	if (!error) {
++		error =3D try_break_deleg(target, delegated_inode);
++		if (error)
++			goto out;
+ 		error =3D dir->i_op->unlink(dir, dentry);
  		if (!error) {
- 			error =3D try_break_deleg(target, delegated_inode);
- 			if (error)
- 				goto out;
- 			error =3D dir->i_op->unlink(dir, dentry);
- 			if (!error)
- 				dont_mount(dentry);
+ 			dont_mount(dentry);
+ 			detach_mounts(dentry);
  		}
  	}
 -	mutex_unlock(&dentry->d_inode->i_mutex);
 +out:
 +	mutex_unlock(&target->i_mutex);
 =20
  	/* We don't d_delete() NFS sillyrenamed files--they still exist. */
  	if (!error && !(dentry->d_flags & DCACHE_NFSFS_RENAMED)) {
@@@ -3708,8 -3726,11 +3720,11 @@@ retry_deleg
  		if (nd.last.name[nd.last.len])
  			goto slashes;
  		inode =3D dentry->d_inode;
 -		if (!inode)
 +		if (d_is_negative(dentry))
  			goto slashes;
+ 		error =3D -EBUSY;
+ 		if (covered(nd.path.mnt, dentry))
+ 			goto exit2;
  		ihold(inode);
  		error =3D security_path_unlink(&nd.path, dentry);
  		if (error)
@@@ -4063,20 -4040,9 +4075,16 @@@ static int vfs_rename_other(struct inod
  		return error;
 =20
  	dget(new_dentry);
 -	if (target)
 -		mutex_lock(&target->i_mutex);
 +	lock_two_nondirectories(source, target);
 =20
- 	error =3D -EBUSY;
- 	if (d_mountpoint(old_dentry)||d_mountpoint(new_dentry))
- 		goto out;
-=20
 +	error =3D try_break_deleg(source, delegated_inode);
 +	if (error)
 +		goto out;
 +	if (target) {
 +		error =3D try_break_deleg(target, delegated_inode);
 +		if (error)
 +			goto out;
 +	}
  	error =3D old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry=
);
  	if (error)
  		goto out;

--Signature=_Fri__8_Nov_2013_17_49_53_+1100_PAgFOm84T+NbM=Qd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfImRAAoJEMDTa8Ir7ZwV1SQP/3qJ7RjYrJh3b1iWOwxU23vG
5s3lCr8BI9dLHh7OU4TiVxx+qPP46Z/j7z9Qw6BPyBTIFQ5+7M0u14MSR/42/wrB
oS89EB8ZouBzIgfcmo79SS/qhP30C71X4En4yrlXCpTYQEeqPQveYRjFSLTjdb5W
rLywVjLOePVtQNviSLCYGvI+OAgZBZAJsAAdATGK34DS3ZVRPBYEUSmMAs62nhrh
WzJo5M4nXgsOVNrfatzYDdQSigkozdujxMXDJvBuURRHLSYjljKUJKDB5PgjutEt
Zk7koDoWhG5oCYkqJTCgmnJP9naXsmxBn4lGfqb3kVoOI4P9VZEvxc+94bR3OUKf
TaB05qRVkGr5lPxTDXCkjlMLOpkYUcoIzp/Zorq0qJphhYyWD7HvxmL1t1eMfxOp
0wotxyIoK7MHtjGWXjbtwUlRrwG8mTDGdMOKyJNALB91vtSMXQUosVqaDTmFUL/Z
mU7M5z9c8/ir5tZ2Smf8n88+5AF5D5ismDTqG2/tHzmxgssvyk1vUajJbeAupUAa
dmXiCbcP1PBo073SsUvIpFPNp9OSiNDSFaMHujv5xaFFZXY0nScJvjN808mLKOJ4
WdChfhsFocSoE0HKCJD1gIg+ib+u3fyKtbKypOxlyqZvoxH/eImbqGDFn+s49LiW
uDJ7rxi9twGNrtcBXfgL
=jGMI
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_17_49_53_+1100_PAgFOm84T+NbM=Qd--
