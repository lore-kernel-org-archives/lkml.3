Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab3J2Cq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 22:46:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50289 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3J2Cq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 22:46:26 -0400
Date: Tue, 29 Oct 2013 13:46:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: linux-next: manual merge of the vfs tree with the v9fs tree
Message-Id: <20131029134608.3544a5cc3d17fd2bec78f2c1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Oct_2013_13_46_08_+1100_KvRovJsPMGTHQ218"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Oct_2013_13_46_08_+1100_KvRovJsPMGTHQ218
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got conflicts in
fs/9p/vfs_file.c, fs/9p/vfs_inode_dotl.c and fs/9p/vfs_inode.c between
commit 94876b5bb6a8 ("9P: introduction of a new cache=3Dmmap model") from
the v9fs tree and commit 2b052ff59861 ("9p: make v9fs_cache_inode_
{get,put,set}_cookie empty inlines for !9P_CACHEFS") from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/9p/vfs_file.c
index d1ab081f6a4e,a0df3e73c2b1..000000000000
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@@ -107,12 -105,8 +107,10 @@@ int v9fs_file_open(struct inode *inode
  		v9inode->writeback_fid =3D (void *) fid;
  	}
  	mutex_unlock(&v9inode->v_mutex);
- #ifdef CONFIG_9P_FSCACHE
 -	if (v9ses->cache)
 +	/* previous check would also set cookie with CACHE_LOOSE?
 +	 * set_cookie does a check if v9inode->fscache anyway... */
 +	if (v9ses->cache =3D=3D CACHE_FSCACHE)
  		v9fs_cache_inode_set_cookie(inode, file);
- #endif
  	return 0;
  out_error:
  	p9_client_clunk(file->private_data);
diff --cc fs/9p/vfs_inode.c
index fd077485426b,4e65aa903345..000000000000
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@@ -911,10 -901,8 +907,8 @@@ v9fs_vfs_atomic_open(struct inode *dir
  		goto error;
 =20
  	file->private_data =3D fid;
- #ifdef CONFIG_9P_FSCACHE
 -	if (v9ses->cache)
 +	if (v9ses->cache =3D=3D CACHE_LOOSE || v9ses->cache =3D=3D CACHE_FSCACHE)
  		v9fs_cache_inode_set_cookie(dentry->d_inode, file);
- #endif
 =20
  	*opened |=3D FILE_CREATED;
  out:
diff --cc fs/9p/vfs_inode_dotl.c
index e68ca293fc9d,4c10edec26a0..000000000000
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@@ -356,10 -353,8 +354,8 @@@ v9fs_vfs_atomic_open_dotl(struct inode=20
  	if (err)
  		goto err_clunk_old_fid;
  	file->private_data =3D ofid;
- #ifdef CONFIG_9P_FSCACHE
 -	if (v9ses->cache)
 +	if (v9ses->cache =3D=3D CACHE_LOOSE || v9ses->cache =3D=3D CACHE_FSCACHE)
  		v9fs_cache_inode_set_cookie(inode, file);
- #endif
  	*opened |=3D FILE_CREATED;
  out:
  	v9fs_put_acl(dacl, pacl);

--Signature=_Tue__29_Oct_2013_13_46_08_+1100_KvRovJsPMGTHQ218
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbyF5AAoJEMDTa8Ir7ZwVW2QP/ijIB6SHSnhIFrt+NHXk1Mq4
PB7MN0ZMJlNgNYqqZzP6m/Rd5kJ/wec/yB1MIq60FzcEWcz/bpLRAVcBSvwDZIVl
Pr4DkGba1bzxz0Hp8162z7Vq7gt5fcSzGghd/OWFJ2WmSm8pQkcRhqIGiO5wd8lD
E/jm9foVaOdZNT9EJ6HNeHfeTmKFbinaP7FgRlzx9gh2jUUlHCEMNpKGJcZjf6i7
jeRBgPlSgGefAx3FkV+/KpyyQjGQ7LYCmgZSCr5sbgB53RDHuJfUUwuTFxB+j2TM
RZuh+4dmRcaMTcfm3N0dBMg511pdd5i4h1Y28ziKDA0nZRZAxoy+5nfE0dGqhZeI
HMR7k+g90uZTVaTqfMYPsOrhLyKe3fJTnUZgY5zzwJH2uDzBivPm6FOTritW88Sg
4ko9AhDtD+RDzNsuhPtOA44M9wNIPAmKQNjpOZnWpw4t0qbomc82ks0y5kX+pK9t
a3or9y89Wx7a0bN7+GeNgGEdEkWIuRpcQiyYwaQ60P97j+0avHvrdwN04pgsljaz
As/jJ4Ua1P/9lCsPiEiD5qNXjnf/nuhBphCSQSl6uHg/9p/xcMLIqZT/or90kH9m
5tk+tnqF3lqDYeYZi+JNtPU6gnHSY+HBMU0wxfflhAq0xQFBLnkTDEcMKWVeSsGS
o+YRiFt1iqJWUxnY4hEm
=qk/O
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Oct_2013_13_46_08_+1100_KvRovJsPMGTHQ218--
