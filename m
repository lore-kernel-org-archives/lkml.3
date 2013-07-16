Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab3GPFTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 01:19:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38060 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab3GPFTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 01:19:00 -0400
Date: Tue, 16 Jul 2013 15:18:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <dchinner@redhat.com>,
        Glauber Costa <glommer@openvz.org>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20130716151852.718fe87b1b71fcaf55fd08d1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Jul_2013_15_18_52_+1000_tMIzYFdgsevaEdK1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Jul_2013_15_18_52_+1000_tMIzYFdgsevaEdK1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/ext4/extents_status.c: In function 'ext4_es_shrink':
fs/ext4/extents_status.c:990:50: error: 'ret' undeclared (first use in this=
 function)
  trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk, ret);
                                                  ^
fs/ext4/extents_status.c: In function 'ext4_es_register_shrinker':
fs/ext4/extents_status.c:999:36: error: 'ext4_es_scan' undeclared (first us=
e in this function)
  sbi->s_es_shrinker.scan_objects =3D ext4_es_scan;
                                    ^

A product of my conflict resolutions :-(

I applied the following fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 16 Jul 2013 15:12:34 +1000
Subject: [PATCH] fixup for ext4 and shrinker changes

Signe-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/ext4/extents_status.c    |  6 +++---
 include/trace/events/ext4.h | 12 +++++-------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index db080c4..87fd719 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -977,8 +977,8 @@ static unsigned long __ext4_es_shrink(struct ext4_sb_in=
fo *sbi, int nr_to_scan,
 	return nr_shrunk;
 }
=20
-static unsigned long ext4_es_shrink(struct shrinker *shrink,
-				    struct shrink_control *sc)
+static unsigned long ext4_es_scan(struct shrinker *shrink,
+				  struct shrink_control *sc)
 {
 	struct ext4_sb_info *sbi =3D container_of(shrink,
 					struct ext4_sb_info, s_es_shrinker);
@@ -987,7 +987,7 @@ static unsigned long ext4_es_shrink(struct shrinker *sh=
rink,
=20
 	nr_shrunk =3D __ext4_es_shrink(sbi, nr_to_scan, NULL);
=20
-	trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk, ret);
+	trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk);
 	return nr_shrunk;
 }
=20
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 2068db2..e62c0d3 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2378,25 +2378,23 @@ TRACE_EVENT(ext4_es_shrink_enter,
 );
=20
 TRACE_EVENT(ext4_es_shrink_exit,
-	TP_PROTO(struct super_block *sb, int shrunk_nr, int cache_cnt),
+	TP_PROTO(struct super_block *sb, unsigned long shrunk_nr),
=20
-	TP_ARGS(sb, shrunk_nr, cache_cnt),
+	TP_ARGS(sb, shrunk_nr),
=20
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
-		__field(	int,	shrunk_nr		)
-		__field(	int,	cache_cnt		)
+		__field(	unsigned long,	shrunk_nr	)
 	),
=20
 	TP_fast_assign(
 		__entry->dev		=3D sb->s_dev;
 		__entry->shrunk_nr	=3D shrunk_nr;
-		__entry->cache_cnt	=3D cache_cnt;
 	),
=20
-	TP_printk("dev %d,%d shrunk_nr %d cache_cnt %d",
+	TP_printk("dev %d,%d shrunk_nr %lu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->shrunk_nr, __entry->cache_cnt)
+		  __entry->shrunk_nr)
 );
=20
 #endif /* _TRACE_EXT4_H */
--=20
1.8.3.2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__16_Jul_2013_15_18_52_+1000_tMIzYFdgsevaEdK1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR5NfAAAoJEECxmPOUX5FEQVAP/0x2n4+/XIjctOwNnBBuqThA
iKGpcTFY6QeJSpkC6XiOFG5+fy6RHlEXYwLkQv3i5GmJ527B1KyGkUvlqJhOyFp7
YMEKWAHZNKLfED1MWONpeJ/wsAyKw9ENj2Q+njUThhkox8r9y1fX6lfNW8jct6Dp
YZXSijxtcexhcZJ2foHqv32sTOGCRBnficYBq9OJdrFHyu2pPXcUI6KBnEYoAbJV
dkE0CQWFEW4udZCykHFtF50K1ceRWdFeQqhuzxDCoFASyZbNFk2anK9XHG2c8NKJ
nWZfqTAZc55Jj9BLpa3TWvmwuo2Mf0225jsea+JyNuFJm0EuKstPKvZIMqojw0eo
v4PdINUUzDwxftn8qOkoQxGygXzx1CHkdY0fV1YI8P/RBSQibrW+0gfo9fXXhAKM
6pvx0v/wf3QBPQDvmSUY17vORV2UHIZ0CdLmlprgtaoTifKD7t9Y+ytJSrfBfnx/
MhFJaBdoguwX5cEnK821MVDPMBAF5BGeTfCxCBWuYTfB0a4n2oDGe8PabEcnFu6R
nnyfady55Nn84XvV5VfwTWN8lAohGFRnN0MVOUqVWwpycIUJTnjmmYx4s2d4emkh
aw8dSTFoMhR4anv3osPgCXSDF68T88GBt0QaFeVID0gK+NjCxyiaTqZBGuSyU5hr
1iK1fBVCNmluPLin70LS
=pXXV
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Jul_2013_15_18_52_+1000_tMIzYFdgsevaEdK1--
