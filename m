Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3I0BbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 21:31:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52976 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3I0BbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 21:31:10 -0400
Date: Fri, 27 Sep 2013 11:31:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        majianpeng <majianpeng@gmail.com>, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: linux-next: build failure after merge of the ceph tree
Message-Id: <20130927113100.5c261c61856e26da4cf8f949@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Sep_2013_11_31_00_+1000__ltvY_kw=mlkBwmp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Sep_2013_11_31_00_+1000__ltvY_kw=mlkBwmp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

After merging the ceph tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/ceph/file.c: In function 'ceph_sync_direct_write':
fs/ceph/file.c:545:24: error: 'struct iov_iter' has no member named 'iov'
   void __user *data =3D i.iov->iov_base + i.iov_offset;
                        ^
fs/ceph/file.c:546:14: error: 'struct iov_iter' has no member named 'iov'
   u64 len =3D i.iov->iov_len - i.iov_offset;
              ^

This also happened yesterday but was swamped by the other error (now fixed).

Caused by commit d4ce96db671b ("ceph: Implement writev/pwritev for sync
operation") interacting with commit f6794d33a5ec ("iov_iter: hide iovec
details behind ops function pointers") from the aio-direct tree.

I applied the following merge fix patch (but there may be a better
solution):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 27 Sep 2013 11:28:05 +1000
Subject: [PATCH] ceph: fix up for iov_iter changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/ceph/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 5cf034e..1216372 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -542,8 +542,8 @@ ceph_sync_direct_write(struct kiocb *iocb, const struct=
 iovec *iov,
 	iov_iter_init(&i, iov, nr_segs, count, 0);
=20
 	while (iov_iter_count(&i) > 0) {
-		void __user *data =3D i.iov->iov_base + i.iov_offset;
-		u64 len =3D i.iov->iov_len - i.iov_offset;
+		void __user *data =3D iov_iter_iovec(&i)->iov_base + i.iov_offset;
+		u64 len =3D iov_iter_iovec(&i)->iov_len - i.iov_offset;
=20
 		page_align =3D (unsigned long)data & ~PAGE_MASK;
=20
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Sep_2013_11_31_00_+1000__ltvY_kw=mlkBwmp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSRN/YAAoJEMDTa8Ir7ZwVeusP/32ZDwhz0Nzkchp6CrCJugtw
SKHT5UH6nDdha277DhiBOrL9LqIaC+fMTYpzsMKXUWmh1vlH6kdGYBmvrbh1nSM8
ThGMXhRCUdZZPsZ5EL0DQarA1Q+lpdb+83T2thLfeOJ4RpjsA9G5I6kxc8/cwD8M
slEh7al5/TtfTANY2S1W3vsDxMvtzNrS+MMoK4IUeGmcgo2mdtv9fXlGVnHC3AAK
PVD2l1o5kBZRtWu33yw9tjHaaMVp/Jtt/KgAJrQNtUA/JAlCuL2lrEW30ebjPWAJ
CyKPWy0ioJT/AfZhuzVNqAHvK7wezQxqiGILhIVps2nOJKgoAl1hAV4iVCzac6Xy
1GESBkLoKb5FI80u71AmTF3/ksPLL5jPx3zxjoQEJJqDrJvWtETvRkT6jqhlk11f
MzWfE/Qe5lO8MJNXaCjc8zC5iYAtVhb8S9irvzb2+YNZonbCqt4LPxMmL9gi1ilj
Pl9dEHbvHWYMACHpgijkgcN1JrZIWDzWm4H5qbCL0AaUWYe92e4m56bkI787xaJr
UXSlkwNggBD9YhG+JEgwNrhJOh0pAsbKHEJaLDYsgzC/JyzQ+NgGiCjW+E/pzWtD
mTXsY5Jdd8SCphcOkV41yI8XQirbed7+nmeucuDqlI8r1i7QiCx5t8yZ1eacjPcy
psfoZ8J1V7nzI7E5iA0W
=McEv
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Sep_2013_11_31_00_+1000__ltvY_kw=mlkBwmp--
