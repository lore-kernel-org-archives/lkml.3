Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3E0Gjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 02:39:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55413 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab3E0Gjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 02:39:43 -0400
Date: Mon, 27 May 2013 16:39:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20130527163933.a0de3d8a94a15cd8164ee33f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_May_2013_16_39_33_+1000_gF6sofWOTk67URt2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_May_2013_16_39_33_+1000_gF6sofWOTk67URt2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/jfs/jfs_logmgr.c: In function 'lbmRead':
fs/jfs/jfs_logmgr.c:2015:3: error: too few arguments to function 'lbmIODone'
   lbmIODone(bio, 0);
   ^
fs/jfs/jfs_logmgr.c:194:21: note: declared here
 static bio_end_io_t lbmIODone;
                     ^

Caused by commit daf8a85f357a ("block: prep work for batch completion")
from the akpm tree interacting with commit 95bbb82f60c8 ("fs/jfs: Add
check if journaling to disk has been disabled in lbmRead()") from the jfs
tree.

I applied the following fix up patch and can carry it as necessary.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 27 May 2013 16:37:05 +1000
Subject: [PATCH] jfs: fix up for batch completion API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/jfs/jfs_logmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 0787ecc..4c3289c 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2012,7 +2012,7 @@ static int lbmRead(struct jfs_log * log, int pn, stru=
ct lbuf ** bpp)
 	/*check if journaling to disk has been disabled*/
 	if (log->no_integrity) {
 		bio->bi_size =3D 0;
-		lbmIODone(bio, 0);
+		lbmIODone(bio, 0, NULL);
 	} else {
 		submit_bio(READ_SYNC, bio);
 	}
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__27_May_2013_16_39_33_+1000_gF6sofWOTk67URt2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRov+rAAoJEECxmPOUX5FEMf4P/RDaMv+UvPMd7lIz73IN0spv
LnaggmyViC/meClmS4n4JPat/t6Pe6GAUu8rQP7N5yDWTtiG5qoo07uk4zHD85N/
gP1oha8gPpZbfs+3nj6URJoAv3WZvIAKexYZf3pt/kPnm1MnwEU9j7H2vdZRw1wD
RPLobpva9cFwABHPKarZ4TaEJh95toO8t905gzv0fn+hRTUhG+6JILoCJmQtEiH1
S1KISPRXgq0hGOhZpeqMInRkw2rFhU2AByBDaMHVr4qoox0VNBwSvv12VI2lNIXq
mCFZGsaCXElzXcOo4sxsQGZ3cA00sDwyQc6x0rTOSGOUAo+S3+1ESfuBhIXjqO3G
b2kQWqd8Z7MO6j+nRdCaL/h+pWTIKhRhmbNBgvx+NYA+s0sY1JF9uYbSbFYVaeR8
ctwsitSr0ddpbxo/wXxIl5LX0Kva2Sn6+U8xh4x2E/+GbM/mr3mlySELYznFmjGP
Vk3TNuUFJXm5h+sg+4v4kA4416frGV1Rnh+AJJncmGBERUWuS1Vm5khx4o60Uism
YdnvI0raU4RC0NlbzKGiDkIgbLxyYhV98hjR/qZlwYhloiQjGUcqFMLQPYtKr1Rk
q7zlaC184nZ3qOe3asQotYPu4raj6oPCeTzUu+EmwfKcdaTuuRRFayR02nN0YoPI
21KVmrWlTfcH7ndCIrbZ
=+Hw4
-----END PGP SIGNATURE-----

--Signature=_Mon__27_May_2013_16_39_33_+1000_gF6sofWOTk67URt2--
