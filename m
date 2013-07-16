Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003Ab3GPE5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 00:57:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46059 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab3GPE5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 00:57:01 -0400
Date: Tue, 16 Jul 2013 14:56:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <dchinner@redhat.com>,
        Glauber Costa <glommer@openvz.org>
Subject: linux-next: manual merge of the akpm tree with the ext4 tree
Message-Id: <20130716145658.0a31d06ecbe65faf6fcaaaf8@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Jul_2013_14_56_58_+1000_qvpIxhsYcTr.=Ji3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Jul_2013_14_56_58_+1000_qvpIxhsYcTr.=Ji3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/ext4/extents_status.c between commit decae3aab047 ("ext4: make the
extent_status code more robust against ENOMEM failures") from the ext4
tree and commit "fs-convert-fs-shrinkers-to-new-scan-count-api-fix" from
the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/extents_status.c
index 95d5bde,8a45b86..0000000
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@@ -148,8 -148,6 +148,8 @@@ static int __es_remove_extent(struct in
  			      ext4_lblk_t end);
  static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
  				       int nr_to_scan);
- static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
- 			    struct ext4_inode_info *locked_ei);
++static unsigned long __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to=
_scan,
++				      struct ext4_inode_info *locked_ei);
 =20
  int __init ext4_init_es(void)
  {
@@@ -914,13 -903,17 +915,14 @@@ static unsigned long ext4_es_count(stru
  	return nr;
  }
 =20
- static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 -static unsigned long ext4_es_scan(struct shrinker *shrink,
 -				  struct shrink_control *sc)
++static unsigned long __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to=
_scan,
 +			    struct ext4_inode_info *locked_ei)
  {
 -	struct ext4_sb_info *sbi =3D container_of(shrink,
 -					struct ext4_sb_info, s_es_shrinker);
  	struct ext4_inode_info *ei;
  	struct list_head *cur, *tmp;
  	LIST_HEAD(skiped);
- 	int ret, nr_shrunk =3D 0;
 -	int nr_to_scan =3D sc->nr_to_scan;
 -	int ret =3D 0;
++	int ret;
+ 	unsigned long nr_shrunk =3D 0;
 =20
  	spin_lock(&sbi->s_es_lru_lock);
 =20
@@@ -969,21 -962,6 +971,22 @@@
  	list_splice_tail(&skiped, &sbi->s_es_lru);
  	spin_unlock(&sbi->s_es_lru_lock);
 =20
 +	if (locked_ei && nr_shrunk =3D=3D 0)
 +		nr_shrunk =3D __es_try_to_reclaim_extents(ei, nr_to_scan);
 +
 +	return nr_shrunk;
 +}
 +
- static long ext4_es_shrink(struct shrinker *shrink, struct shrink_control=
 *sc)
++static unsigned long ext4_es_shrink(struct shrinker *shrink,
++				    struct shrink_control *sc)
 +{
 +	struct ext4_sb_info *sbi =3D container_of(shrink,
 +					struct ext4_sb_info, s_es_shrinker);
 +	int nr_to_scan =3D sc->nr_to_scan;
- 	int nr_shrunk;
++	unsigned long nr_shrunk;
 +
 +	nr_shrunk =3D __ext4_es_shrink(sbi, nr_to_scan, NULL);
 +
  	trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk, ret);
  	return nr_shrunk;
  }

--Signature=_Tue__16_Jul_2013_14_56_58_+1000_qvpIxhsYcTr.=Ji3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR5NKaAAoJEECxmPOUX5FEtuEP/iF7JSA/3sHahqmxxBzFEBXt
3zipZjMpCgDnSHvJWcYuFhrCEx9k3Fz997b/mJq/49JRI9JR6FZ4/EmzRJG07Fvm
Ra4EblJm1UEMm+DZtJCbSulWmdm6hdb3mNOjQ+RCnlzFp+5nxALoxkn4/NCcQokq
8SFZvEjBVZYlzoTFsgMfPQHdzmHnSAclEv/fRuttqgLa/zIEkOPQ65FtkOyX5NwM
8oRezUCgfDtHlSKMRgNF2Dr4YRrLPQYWStVkNPNP1cR+EepYXNYsVC2XEEpSOXKi
Uten4Wf0se+6zrbJYI3Qufbt/6x46zmP1tOksffJ9SsMPaqVQXWJHl8OheecfRnz
DcjjW1wplnTkJnRec68qey5/xHmNz9+xtg6xlg+EaHkScH0PrWCMnvfQ7yTFZYLg
HqaJx0qoCbC6O9aSDOkbRQUblnzF/sd2Dt8c4OnVM+S5FSEbvZFxRo2SaESFpifh
JkZZE5lqhnT1mQMyC7mDVGq6My6WCAqT1iCl8CeUC1kcmv0k1byTcgpBQDzGqfJf
dX8AkF+gBKbYzUlFM2uHQpAQ6NVrA0ICeuG7WRp8cPa9KLN1V8ZrJlEV+h5yL35x
zU4dcBtsS/0EPv+Rt19oVtehQBJmC7YMnzLnsIBlvUiPg3vdXwfE5QxoKrcYQDUl
4z24vp7MZi4ZT1bmaRlD
=iLjV
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Jul_2013_14_56_58_+1000_qvpIxhsYcTr.=Ji3--
