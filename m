Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaFEH2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:28:34 -0400
Received: from ozlabs.org ([103.22.144.67]:33043 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbaFEH2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:28:32 -0400
Date: Thu, 5 Jun 2014 17:28:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: linux-next: manual merge of the userns tree with the btrfs tree
Message-ID: <20140605172824.31ecb811@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/GgDUxb3PRtTURIbPtvWguhG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GgDUxb3PRtTURIbPtvWguhG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in
fs/btrfs/ioctl.c between commit e4e7602f3304 ("btrfs: protect snapshots
from deleting during send") from the btrfs tree and commit 23135a9bd700
("vfs: Make d_invalidate return void") from the userns tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).  Thanks, Chris for the resolution.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/btrfs/ioctl.c
index 99431aa5371f,349848bd54e2..000000000000
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@@ -2334,30 -2229,7 +2334,28 @@@ static noinline int btrfs_ioctl_snap_de
  	}
 =20
  	mutex_lock(&inode->i_mutex);
 +
 +	/*
 +	 * Don't allow to delete a subvolume with send in progress. This is
 +	 * inside the i_mutex so the error handling that has to drop the bit
 +	 * again is not run concurrently.
 +	 */
 +	spin_lock(&dest->root_item_lock);
 +	root_flags =3D btrfs_root_flags(&dest->root_item);
 +	if (dest->send_in_progress =3D=3D 0) {
 +		btrfs_set_root_flags(&dest->root_item,
 +				root_flags | BTRFS_ROOT_SUBVOL_DEAD);
 +		spin_unlock(&dest->root_item_lock);
 +	} else {
 +		spin_unlock(&dest->root_item_lock);
 +		btrfs_warn(root->fs_info,
 +			"Attempt to delete subvolume %llu during send",
 +			dest->root_key.objectid);
 +		err =3D -EPERM;
 +		goto out_dput;
 +	}
 +
- 	err =3D d_invalidate(dentry);
- 	if (err)
- 		goto out_unlock;
+ 	d_invalidate(dentry);
 =20
  	down_write(&root->fs_info->subvol_sem);
 =20
@@@ -2442,14 -2314,6 +2440,14 @@@ out_release
  	btrfs_subvolume_release_metadata(root, &block_rsv, qgroup_reserved);
  out_up_write:
  	up_write(&root->fs_info->subvol_sem);
- out_unlock:
++
 +	if (err) {
 +		spin_lock(&dest->root_item_lock);
 +		root_flags =3D btrfs_root_flags(&dest->root_item);
 +		btrfs_set_root_flags(&dest->root_item,
 +				root_flags & ~BTRFS_ROOT_SUBVOL_DEAD);
 +		spin_unlock(&dest->root_item_lock);
 +	}
  	mutex_unlock(&inode->i_mutex);
  	if (!err) {
  		shrink_dcache_sb(root->fs_info->sb);

--Sig_/GgDUxb3PRtTURIbPtvWguhG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTkBwdAAoJEMDTa8Ir7ZwV5kEP/A/S4/8QvErNSIuQAz2/Jn7J
qYpXlGLr/StTxu5MVy4P/cvFaGA5TyLRm7C8giQzN+Xk8N6VC2RiO6GJpkEtKrwh
PZ/TCpgjWToGR2XLxjBzzirr5Du7KyIhLZ+ndGBkm0OgmWipSSrPaGMA45rG0P9d
n1B2jjoAV0X6rIaUyvQVsybSQiVMcjhTBa13D1dWINeDvdbL7LYwu/fRVbFGXu0u
fW201iyHwlmp66cyJbITaEOrWmQ/3GL/g9JEmQB4Ls7Pw65VIFdeZ9XEsrRTBmDq
yyLZVj1i10zZ0N+IzPhrV93cn8ea0ys92evBYAFEMci5lnfklfaxFBaHl7Rm2kY0
sYvAZC1kjZU6hwKRL4IWNxgL6eq2SwXDHX2U7HDLnBPMEg7yAWTsVoEgyeyBY8EQ
FEe8OEcjp4OG7XUHoylJZAxKWddZYG5X7ysmOH21C4S1KJTktWI7xX4M3iuSH1gl
sWjd6Ie+IBaa1faiZW+7thY52W2sEhZU2Z52SGZAmqmU86z89q4/a219ksWVPRB/
5qzdSfTQ72Zj+WQkBtGdND3xkanXLAACTekUkDFsgvhy+a13ZNeEjaUyv5xs3Z+q
W5PcSEpy+tQDB2z/6yqelRSsigypvmb7ejX1eYHCD3j67GHukF/9T1sQaCQDakG9
YC9ONAyZkTGxwjCAnXRA
=SlMQ
-----END PGP SIGNATURE-----

--Sig_/GgDUxb3PRtTURIbPtvWguhG--
