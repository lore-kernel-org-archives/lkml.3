Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab3HUHpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:45:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56862 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3HUHp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:45:29 -0400
Date: Wed, 21 Aug 2013 17:45:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: linux-next: build failure after merge of the aio tree
Message-Id: <20130821174522.3af60c89647476d2aab5f47c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Aug_2013_17_45_22_+1000_yJ/1qc7x6FF3IJwW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Aug_2013_17_45_22_+1000_yJ/1qc7x6FF3IJwW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Benjamin,

After merging the aio tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/aio.c: In function 'aio_kernel_init_rw':
fs/aio.c:1359:6: error: 'struct kiocb' has no member named 'ki_left'
  iocb->ki_left =3D nr;
      ^
fs/aio.c: In function 'aio_kernel_submit':
fs/aio.c:1394:6: error: 'struct kiocb' has no member named 'ki_opcode'
  iocb->ki_opcode =3D op;
      ^
fs/aio.c:1395:6: error: 'struct kiocb' has no member named 'ki_buf'
  iocb->ki_buf =3D (char __user *)(unsigned long)ptr;
      ^
fs/aio.c:1398:2: error: too few arguments to function 'aio_run_iocb'
  ret =3D aio_run_iocb(iocb, 0);
  ^
fs/aio.c:1217:16: note: declared here
 static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
                ^

Caused by commit af9fa2024c38 ("aio: add aio_kernel_() interface") from
the aio-direct tree interacting with commit 8bc92afcf7f5 ("aio: Kill
unneeded kiocb members") from the aio tree.

I applied the following merge fix patch (and I can carry it as necessary
- thanks, Dave, for the hint patches):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 21 Aug 2013 17:42:14 +1000
Subject: [PATCH] aio: semantic fixup

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/aio.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 39fb7b0..59b46cd 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1356,7 +1356,6 @@ void aio_kernel_init_rw(struct kiocb *iocb, struct fi=
le *filp,
 			size_t nr, loff_t off)
 {
 	iocb->ki_filp =3D filp;
-	iocb->ki_left =3D nr;
 	iocb->ki_nbytes =3D nr;
 	iocb->ki_pos =3D off;
 	iocb->ki_ctx =3D (void *)-1;
@@ -1391,11 +1390,7 @@ int aio_kernel_submit(struct kiocb *iocb, unsigned s=
hort op, void *ptr)
 	BUG_ON(!iocb->ki_obj.complete);
 	BUG_ON(!iocb->ki_filp);
=20
-	iocb->ki_opcode =3D op;
-	iocb->ki_buf =3D (char __user *)(unsigned long)ptr;
-	iocb->ki_iter =3D ptr;
-
-	ret =3D aio_run_iocb(iocb, 0);
+	ret =3D aio_run_iocb(iocb, op, ptr, 0);
=20
 	if (ret)
 		aio_kernel_free(iocb);
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__21_Aug_2013_17_45_22_+1000_yJ/1qc7x6FF3IJwW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFHAXAAoJEECxmPOUX5FE760QAKEaY/I6xKe59/7lNOARR6MO
GzjV1LuAGN+ancE8jn47S8sSEsK0USeyAupgrBS/Eu32PP+3+pI3GZkBTd6HYcJg
Px6S1pH5xGmFw3gR8BTQdWYlLN4rg5f6FCR8qGdMfWGPZeX0c/HDVMHUUH5mL/hI
LFqoQ6ZEZFHbQK3zB4vgrBat4FBTch3FskXE2gQVzTB5lJa6AfWf0YbDgrIyMOPP
Fr2F8UzlNgKr+XcTFzA0AaI9JXEsFmcY6m3EDe/svi6NTtUphlyl0JQ5NHWZcGC3
A0I8hZSraAbK2zdGwIK+KDkhCsWzNblooB/JhKbrqt4S4mu89y3mqPsHGIkP1cNP
kSUYYZrQQk5aA6GIR8uXwRsNIIyDSm0EYTedzymIWb5nvXLPi1hsREhdA12YtE2Y
bviMqKC1dh6AXxq4ixygQaMMdSDG0cIGEMEV7PW0xQOfVnz48dg9klYeQYuEr7my
8Mh2b/PcbjEO6lB6BSGw2lCPDYjxy5upbeGM/ycxUBRftf5ZNh157kRU39Ak5Dio
QdzEOXtLMSX8RPYY3r0cC8ZNnCAdQEUH9m11+L/dcoUsyOTXRE/TtU1lYxt4TqUa
Nwg/amHtFDIYM9yMEQQRB15xEU2DQ19bPWKRZWheqrBzt8ucSqyLSbxZzIRYuQrH
fKit9CN2gJU5NOFPhXHX
=P+OO
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Aug_2013_17_45_22_+1000_yJ/1qc7x6FF3IJwW--
