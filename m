Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab3KHGt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 01:49:26 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35537 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3KHGtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 01:49:23 -0500
Date: Fri, 8 Nov 2013 17:49:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the userns tree with the vfs tree
Message-Id: <20131108174900.6866199475b68ac6ca1ad2d5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_17_49_00_+1100_n9gn_GOu.OBlIY38"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_17_49_00_+1100_n9gn_GOu.OBlIY38
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in
fs/namespace.c between commit aba809cf0944 ("namespace.c: get rid of
mnt_ghosts") from the vfs tree and commit 484df667efe9 ("vfs: Keep a list
of mounts on a mount point") from the userns tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/namespace.c
index ac2ce8a766e1,78f7c5c9e673..000000000000
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@@ -1207,16 -1193,11 +1212,17 @@@ void umount_tree(struct mount *mnt, in
  		list_del_init(&p->mnt_list);
  		__touch_mnt_namespace(p->mnt_ns);
  		p->mnt_ns =3D NULL;
 +		if (how < 2)
 +			p->mnt.mnt_flags |=3D MNT_SYNC_UMOUNT;
  		list_del_init(&p->mnt_child);
  		if (mnt_has_parent(p)) {
 -			p->mnt_parent->mnt_ghosts++;
+ 			list_del_init(&p->mnt_mp_list);
  			put_mountpoint(p->mnt_mp);
 +			/* move the reference to mountpoint into ->mnt_ex_mountpoint */
 +			p->mnt_ex_mountpoint.dentry =3D p->mnt_mountpoint;
 +			p->mnt_ex_mountpoint.mnt =3D &p->mnt_parent->mnt;
 +			p->mnt_mountpoint =3D p->mnt.mnt_root;
 +			p->mnt_parent =3D p;
  			p->mnt_mp =3D NULL;
  		}
  		change_mnt_propagation(p, MS_PRIVATE);

--Signature=_Fri__8_Nov_2013_17_49_00_+1100_n9gn_GOu.OBlIY38
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfIlhAAoJEMDTa8Ir7ZwVDgsP/R/oe8kWwATyU/XW0jP3hUFM
kzps2Uwfv7gvu8PMDCiVd9kDDdgXMu0Gc3v7zKFAMml6l572zjKU0sHrslzKA/A8
wnl0lsVXhod/xM+PNqHovjRVpJEVpqPq3Z36oI+uQsWCcbs+F35VnR6Fuj4/SSy3
MRTPSfoNxiEZZYDC6jJaqyi+qlhMrZVm20KAK4itNBxtCjJJ8eXu031tKec3ckR9
+rLivcc/iEaAzDu8MTEzJ6z6hcl6Wiqkm9l+IgY30q4TLI2Wt5VAAqWE8lhQYweu
UBH6rla/4IcvDrw2ezjzmu4/2O854vI8mvdXr+Ry/wxyxTaP4MRdw5hL+pTAmX1K
IMYarMxeH/apEUZWb1FyG/ocgI0vtTyJDlsnABIPSVNFUxMZL/DOohrgppZP1xyt
1Iv0K4nolMTFfasXnAvaZrjZJpElqXi9Hz1oXqTgdFGlfZpuR05B0U1BfsbuTINy
6UUFlgPeziqZcjuziTuvjTg4iZAekKnH6iV9jiEy4biSJcFPh+f3gAcsYAc+W+ca
FAQwYXmGspKEeU1/Z2yblQjMPcv165iIV4Q7jW6N8Escg4mLGGUYPVqEJTduoVmy
OzMEWdetz4tUVUta/RF3KbTJd3TauvDO1CX+7m7M/0P69NptbRJwZ3TrEfh8SsS3
uRIeCRkJpu6j1JrpVoR6
=lLkB
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_17_49_00_+1100_n9gn_GOu.OBlIY38--
