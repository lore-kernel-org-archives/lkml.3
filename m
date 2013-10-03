Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3JCMKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:10:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43281 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3JCMKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:10:12 -0400
Date: Thu, 3 Oct 2013 13:09:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Sage Weil <sage@inktank.com>, Jianpeng Ma <majianpeng@gmail.com>,
        Zheng Yan <zheng.z.yan@intel.com>, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: ceph-devel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>
Message-ID: <20131003120957.GK27287@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6THr7QwYWIbrk6Kt"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Build failure after merge of ceph tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6THr7QwYWIbrk6Kt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

After merging the ceph tree into -next an x86 allmodconfig build fails
with:

fs/ceph/file.c: In function =E2=80=98ceph_sync_read=E2=80=99:
fs/ceph/file.c:437:25: error: =E2=80=98struct iov_iter=E2=80=99 has no memb=
er named =E2=80=98iov=E2=80=99
    void __user *data =3D i->iov[0].iov_base + i->iov_offset;
                         ^
fs/ceph/file.c:438:18: error: =E2=80=98struct iov_iter=E2=80=99 has no memb=
er named =E2=80=98iov=E2=80=99
    size_t len =3D i->iov[0].iov_len - i->iov_offset;
                  ^
fs/ceph/file.c:470:26: error: =E2=80=98struct iov_iter=E2=80=99 has no memb=
er named =E2=80=98iov=E2=80=99
     void __user *data =3D i->iov[0].iov_base
                          ^
In file included from include/linux/cache.h:4:0,
                 from include/linux/time.h:4,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from fs/ceph/file.c:3:
fs/ceph/file.c:472:14: error: =E2=80=98struct iov_iter=E2=80=99 has no memb=
er named =E2=80=98iov=E2=80=99
     l =3D min(i->iov[0].iov_len - i->iov_offset,
              ^
include/linux/kernel.h:670:9: note: in definition of macro =E2=80=98min=E2=
=80=99
  typeof(x) _min1 =3D (x);   \
         ^
fs/ceph/file.c:472:14: error: =E2=80=98struct iov_iter=E2=80=99 has no memb=
er named =E2=80=98iov=E2=80=99
     l =3D min(i->iov[0].iov_len - i->iov_offset,
              ^
include/linux/kernel.h:670:21: note: in definition of macro =E2=80=98min=E2=
=80=99
  typeof(x) _min1 =3D (x);   \
                     ^
include/linux/kernel.h:672:17: warning: comparison of distinct pointer type=
s lacks a cast [enabled by default]
  (void) (&_min1 =3D=3D &_min2);  \
                 ^
fs/ceph/file.c:472:9: note: in expansion of macro =E2=80=98min=E2=80=99
     l =3D min(i->iov[0].iov_len - i->iov_offset,
         ^
fs/ceph/file.c: In function =E2=80=98ceph_sync_direct_write=E2=80=99:
fs/ceph/file.c:586:24: error: =E2=80=98struct iov_iter=E2=80=99 has no memb=
er named =E2=80=98iov=E2=80=99
   void __user *data =3D i.iov->iov_base + i.iov_offset;
                        ^
fs/ceph/file.c:587:14: error: =E2=80=98struct iov_iter=E2=80=99 has no memb=
er named =E2=80=98iov=E2=80=99
   u64 len =3D i.iov->iov_len - i.iov_offset;
              ^
make[2]: *** [fs/ceph/file.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [fs/ceph] Error 2

caused by commits 53d028160 (ceph: implement readv/preadv for sync
operation) and 2f0a7a180 (ceph: Implement writev/pwritev for sync
operation) interacting with commit f6794d33a5ec ("iov_iter: hide iovec
details behind ops function pointers") from the aio-direct tree.

I extended Stephen's previous fix to this:

=46rom 577435f0a97e67b735f355aef0ef55732814818c Mon Sep 17 00:00:00 2001
=46rom: Mark Brown <broonie@linaro.org>
Date: Thu, 3 Oct 2013 13:05:20 +0100
Subject: [PATCH] ceph: Fix up for iov_iter changes

Extend an earlier fixup by Stephen Rothwell.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 fs/ceph/file.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index c4419e8..37b5b5c 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -434,8 +434,8 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struc=
t iov_iter *i,
=20
 	if (file->f_flags & O_DIRECT) {
 		while (iov_iter_count(i)) {
-			void __user *data =3D i->iov[0].iov_base + i->iov_offset;
-			size_t len =3D i->iov[0].iov_len - i->iov_offset;
+			void __user *data =3D iov_iter_iovec(i)->iov_base + i->iov_offset;
+			size_t len =3D iov_iter_iovec(i)->iov_len - i->iov_offset;
=20
 			num_pages =3D calc_pages_for((unsigned long)data, len);
 			pages =3D ceph_get_direct_page_vector(data,
@@ -467,9 +467,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struc=
t iov_iter *i,
 			size_t left =3D len =3D ret;
=20
 			while (left) {
-				void __user *data =3D i->iov[0].iov_base
+				void __user *data =3D iov_iter_iovec(i)->iov_base
 							+ i->iov_offset;
-				l =3D min(i->iov[0].iov_len - i->iov_offset,
+				l =3D min(iov_iter_iovec(i)->iov_len - i->iov_offset,
 					left);
=20
 				ret =3D ceph_copy_page_vector_to_user(&pages[k],
@@ -583,8 +583,8 @@ ceph_sync_direct_write(struct kiocb *iocb, const struct=
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


--6THr7QwYWIbrk6Kt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTV6RAAoJELSic+t+oim9e48QAJpajHmo8BBWPAabl3Hhu2nP
+UmtLIUQsRtCr4Xh14s3u2DYXXIga3JwuZEgjLnbMVCpm0oTHR/PWsxSzxWZJ/2c
TcIbpmwX6DQ8K6n0dN6SQk3LprVgsUsvs4CVWAewXe+J6nm7zOxD0bzQilKTOYHr
acwcXvJDkkkPFXBsqaF23IRfZ60qWZ+fKDKa0SooKuZwCH+QvPP5EZPzA7yYE2nH
n62fdfPPcNE1oBT4swaXHamdo1vlJriA0Pmsjq8ByK7mVvQsffTE9t2ykY7JQ9Av
nSst1r7ldB21vaIQ5j7QQwI2vxx1t5XPqlPldzqDlBUwPQIhqTJ7jNDUSBJRNxH+
u3jLVNa1O3b7k1kXBYqwNmYjeN7wdumS7P9xWwq2G7TQ/EUxFBA7iHz0iEYmPmfC
QWpv5DhsqSCjBkE9AOWxjNTc17jeAiOC+8bTsCosrDViP+BxPnE0XgdflP917QSr
hTlEVxgwRt8gHlTWf6J6EPg4wvva0ds6abadfQHieJayU8YHt35kjS3VtsAHGm5n
U+o3DpkC+gJm3U4Z5iHP+N8X851rR76MnCD5n/qm8WPazvcpvno5LvRBHcwXxNDj
y2fm5oEOAS3t8len9zmKEsrokAR9Kg7KU05CueS8M8Se3FluzD3ZOOVpDS2ucSqE
ZW1R+J+xj/S0B/FkdgNi
=SD2O
-----END PGP SIGNATURE-----

--6THr7QwYWIbrk6Kt--
