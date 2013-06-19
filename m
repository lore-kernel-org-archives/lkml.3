Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870Ab3FSH1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:27:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48917 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab3FSH1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:27:31 -0400
Date: Wed, 19 Jun 2013 17:27:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Subject: linux-next: manual merge of the akpm tree with the ext4 tree
Message-Id: <20130619172721.00e757acd76e1f9d362f59be@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Jun_2013_17_27_21_+1000_o9txJCQSY3RSRaDH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Jun_2013_17_27_21_+1000_o9txJCQSY3RSRaDH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/ext4/extents_status.c between commit 6480bad916be ("ext4: improve
extent cache shrink mechanism to avoid to burn CPU time") from the ext
tree and commit 1f42d0934b4e ("fs: convert fs shrinkers to new scan/count
API") from the akpm tree.

I fixed it up (I am not sure if the result makes complete sense - see
below) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/extents_status.c
index 80dcc59,4bce4f0..0000000
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@@ -876,58 -878,32 +876,63 @@@ int ext4_es_zeroout(struct inode *inode
  				     EXTENT_STATUS_WRITTEN);
  }
 =20
 +static int ext4_inode_touch_time_cmp(void *priv, struct list_head *a,
 +				     struct list_head *b)
 +{
 +	struct ext4_inode_info *eia, *eib;
 +	unsigned long diff;
 +
 +	eia =3D list_entry(a, struct ext4_inode_info, i_es_lru);
 +	eib =3D list_entry(b, struct ext4_inode_info, i_es_lru);
 +
 +	diff =3D eia->i_touch_when - eib->i_touch_when;
 +	if (diff < 0)
 +		return -1;
 +	if (diff > 0)
 +		return 1;
 +	return 0;
 +}
 =20
- static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control =
*sc)
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
+ static long ext4_es_scan(struct shrinker *shrink, struct shrink_control *=
sc)
  {
  	struct ext4_sb_info *sbi =3D container_of(shrink,
  					struct ext4_sb_info, s_es_shrinker);
  	struct ext4_inode_info *ei;
 -	struct list_head *cur, *tmp, scanned;
 +	struct list_head *cur, *tmp;
 +	LIST_HEAD(skiped);
  	int nr_to_scan =3D sc->nr_to_scan;
- 	int ret, nr_shrunk =3D 0;
-=20
- 	ret =3D percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
- 	trace_ext4_es_shrink_enter(sbi->s_sb, nr_to_scan, ret);
-=20
- 	if (!nr_to_scan)
- 		return ret;
+ 	int ret =3D 0, nr_shrunk =3D 0;
 =20
 -	INIT_LIST_HEAD(&scanned);
 -
  	spin_lock(&sbi->s_es_lru_lock);
 +
 +	/*
 +	 * If the inode that is at the head of LRU list is newer than
 +	 * last_sorted time, that means that we need to sort this list.
 +	 */
 +	ei =3D list_first_entry(&sbi->s_es_lru, struct ext4_inode_info, i_es_lru=
);
 +	if (sbi->s_es_last_sorted < ei->i_touch_when) {
 +		list_sort(NULL, &sbi->s_es_lru, ext4_inode_touch_time_cmp);
 +		sbi->s_es_last_sorted =3D jiffies;
 +	}
 +
  	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
 -		list_move_tail(cur, &scanned);
 +		/*
 +		 * If we have already reclaimed all extents from extent
 +		 * status tree, just stop the loop immediately.
 +		 */
 +		if (percpu_counter_read_positive(&sbi->s_extent_cache_cnt) =3D=3D 0)
 +			break;
 =20
  		ei =3D list_entry(cur, struct ext4_inode_info, i_es_lru);
 =20
@@@ -951,22 -923,22 +956,22 @@@
  		if (nr_to_scan =3D=3D 0)
  			break;
  	}
 -	list_splice_tail(&scanned, &sbi->s_es_lru);
 +
 +	/* Move the newer inodes into the tail of the LRU list. */
 +	list_splice_tail(&skiped, &sbi->s_es_lru);
  	spin_unlock(&sbi->s_es_lru_lock);
 =20
- 	ret =3D percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
  	trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk, ret);
- 	return ret;
+ 	return nr_shrunk;
  }
 =20
 -void ext4_es_register_shrinker(struct super_block *sb)
 +void ext4_es_register_shrinker(struct ext4_sb_info *sbi)
  {
 -	struct ext4_sb_info *sbi;
 -
 -	sbi =3D EXT4_SB(sb);
  	INIT_LIST_HEAD(&sbi->s_es_lru);
  	spin_lock_init(&sbi->s_es_lru_lock);
 +	sbi->s_es_last_sorted =3D 0;
- 	sbi->s_es_shrinker.shrink =3D ext4_es_shrink;
+ 	sbi->s_es_shrinker.scan_objects =3D ext4_es_scan;
+ 	sbi->s_es_shrinker.count_objects =3D ext4_es_count;
  	sbi->s_es_shrinker.seeks =3D DEFAULT_SEEKS;
  	register_shrinker(&sbi->s_es_shrinker);
  }

--Signature=_Wed__19_Jun_2013_17_27_21_+1000_o9txJCQSY3RSRaDH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwV1eAAoJEECxmPOUX5FEIo8P/RWLvYwS9n0qvCumRP2LqiHv
dNozOaFNHbRZSzLHVPFyJgHMO1WYLw79gwWNIjlxdGUSmwGbt4EvQF0kVbWIbgPy
w7YZ5opE90+QpAjZKi3ZbYPR1TGP26DyAKJoakPUwxVZLhFm0WS5OKcnt+UY1B24
suGnTAEUmSSqdP5D1Z9qZjGSykoDs9Kc5PAQwmWa29qEkKk2hXXX/aMl0bkvaidk
ZPMDpaTCvPRf2Oe5E2kivw5TmyLF9ZSMvG2EUwWF8jybKGaj4FXbGoWaSQqm38oA
vcNjjSJH9JHrYN4WNDQQ6uRb7cSJ9QEuo7vfvNpVSrmjOceL5k/AdBad3usnuQAL
stF/JvXl7JbR+6R0tG2vYnJTz5SBPVjGv22Q/Utuym4FLKo37j746DC16dPpD8iD
laIovkjXdAzNcXaCmfdcWmaixikULJB2sEZtKXJUYD3URwuABYmQGv4usHgQtdH5
reaKMTBkbywy+u4obSo/gSpxb1V/dDAjpTgeKAteWYMoi5GOIVLW3kOtSlCGaCH4
jmjVdv3O+0ALA4BlhURvmavy9wdPnZp2cDHNoL6F86oOxXhp+GlSUsf1Y8itCHVn
4IfZ3ITgF1/yzBYugrON5am/7WkLo8oxXdnOiR3T6ctvjP8kJRurYfkzVua3VmHp
RR6Ij63ComFOiJCEd916
=ApQl
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Jun_2013_17_27_21_+1000_o9txJCQSY3RSRaDH--
