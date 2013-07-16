Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935Ab3GPExX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 00:53:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33627 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3GPExW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 00:53:22 -0400
Date: Tue, 16 Jul 2013 14:53:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <dchinner@redhat.com>
Subject: linux-next: manual merge of the akpm tree with the ext4 tree
Message-Id: <20130716145310.b6d6c02fc9dff12361278c7b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Jul_2013_14_53_10_+1000_/btqy9cMs5/19_iU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Jul_2013_14_53_10_+1000_/btqy9cMs5/19_iU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/ext4/extents_status.c between commit decae3aab047 ("ext4: make the
extent_status code more robust against ENOMEM failures") from the ext4
tree and commit  "fs: convert fs shrinkers to new scan/count API" from
the akpm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/extents_status.c
index 91cb110,fb3b95e..0000000
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@@ -903,9 -891,21 +903,20 @@@ static int ext4_inode_touch_time_cmp(vo
  		return -1;
  }
 =20
+ static long ext4_es_count(struct shrinker *shrink, struct shrink_control =
*sc)
+ {
+ 	long nr;
+ 	struct ext4_sb_info *sbi =3D container_of(shrink,
+ 					struct ext4_sb_info, s_es_shrinker);
+=20
+ 	nr =3D percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
+ 	trace_ext4_es_shrink_enter(sbi->s_sb, sc->nr_to_scan, nr);
+ 	return nr;
+ }
+=20
 -static long ext4_es_scan(struct shrinker *shrink, struct shrink_control *=
sc)
 +static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 +			    struct ext4_inode_info *locked_ei)
  {
 -	struct ext4_sb_info *sbi =3D container_of(shrink,
 -					struct ext4_sb_info, s_es_shrinker);
  	struct ext4_inode_info *ei;
  	struct list_head *cur, *tmp;
  	LIST_HEAD(skiped);
@@@ -958,30 -959,8 +969,23 @@@
  	list_splice_tail(&skiped, &sbi->s_es_lru);
  	spin_unlock(&sbi->s_es_lru_lock);
 =20
 +	if (locked_ei && nr_shrunk =3D=3D 0)
 +		nr_shrunk =3D __es_try_to_reclaim_extents(ei, nr_to_scan);
 +
 +	return nr_shrunk;
 +}
 +
- static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control =
*sc)
++static long ext4_es_shrink(struct shrinker *shrink, struct shrink_control=
 *sc)
 +{
 +	struct ext4_sb_info *sbi =3D container_of(shrink,
 +					struct ext4_sb_info, s_es_shrinker);
 +	int nr_to_scan =3D sc->nr_to_scan;
- 	int ret, nr_shrunk;
-=20
- 	ret =3D percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
- 	trace_ext4_es_shrink_enter(sbi->s_sb, nr_to_scan, ret);
-=20
- 	if (!nr_to_scan)
- 		return ret;
++	int nr_shrunk;
 +
 +	nr_shrunk =3D __ext4_es_shrink(sbi, nr_to_scan, NULL);
 +
- 	ret =3D percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
  	trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk, ret);
- 	return ret;
+ 	return nr_shrunk;
  }
 =20
  void ext4_es_register_shrinker(struct ext4_sb_info *sbi)

--Signature=_Tue__16_Jul_2013_14_53_10_+1000_/btqy9cMs5/19_iU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR5NG7AAoJEECxmPOUX5FExwcP/1bymMcJdhi1zX8WiNc2J/+R
Zo10ZuGO6zGJFYl9X+prD9CaiA+fWra4uZDntvPNJefMA5ze4SAR4uvBiQcMqjnU
aqdoMrZU5gWfvB189naeUYSPg/wEvlGaD9zCABzd+U4yGIdiBcLc9HHV9v/mkX+D
qVqkdwgQ2H2yXVjRFEDswt59wV8auNOxzbYP19Ccl1/xKDlEwM5O6mStSljd3z9y
nQW8Gqic1RkWfhsMvmipACxDXOHyCtGSzxWpmx6N1Efynz0mj8xyXUeL4BtwgTkT
zM4a0SFYoOOlRhy1y8ZvMCqd+UmBcCIUkZeumxq85itx2h3v+PL9TIpHE4oZ7gWi
XD+LklUqwYiJArYBENIJ8cord5SdPq4B3kYIETpMCGDSIPQ7rBp661pagX9vXmPq
bOz4i5w7CT1AvJyVAJr7x/ZSVq2QiuysYh4NyAdisujxJd4EAGDI348/q1WSMF9W
ZLvUORDBFqjLDin5yadKsWFqUzI+oB/BUq02Obn0rt6IgAqJQ32Rd5HjH54Obn/u
bdFbiL+/Av1AZ+v2zqN0c6uWm//eIX6OBfuttiJI0FuNJ9m9bW6v0B+rIJNLO5a/
EPcHMqMJvuEXLBs2cS5s60NzZVtEmdbnO9T4iNUyLvSqYvnKOAzPWnBADddsOzM8
Jqg5Tqo7kGBq7hnpP+z/
=WHyN
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Jul_2013_14_53_10_+1000_/btqy9cMs5/19_iU--
