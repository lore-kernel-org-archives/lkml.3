Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763777Ab3DDGpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:45:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54357 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763496Ab3DDGpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:45:00 -0400
Date: Thu, 4 Apr 2013 17:44:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kent Overstreet <koverstreet@google.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20130404174450.0ffe81ac6c994dcce442f88d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_17_44_50_+1100_A.8zfjwGjH8bi/7r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_17_44_50_+1100_A.8zfjwGjH8bi/7r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/aio.c: In function 'aio_rw_vect_retry':
fs/aio.c:1106:6: error: 'opcode' undeclared (first use in this function)

Caused by commit 36bd5dc0c4e2 ("lift sb_start_write/sb_end_write out of
->aio_write()") from the vfs tree interacting with commit 61ead3d450a4
("aio: kill ki_retry") from the akpm tree.

I applied the following fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 4 Apr 2013 17:41:59 +1100
Subject: [PATCH] aio: kill ki_retry merge fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/aio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 162b418..5b7ed78 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1103,7 +1103,7 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb, =
int rw, aio_rw_op *rw_op)
 	if (iocb->ki_pos < 0)
 		return -EINVAL;
=20
-	if (opcode =3D=3D IOCB_CMD_PWRITEV)
+	if (rw =3D=3D WRITE)
 		file_start_write(file);
 	do {
 		ret =3D rw_op(iocb, &iocb->ki_iovec[iocb->ki_cur_seg],
@@ -1117,7 +1117,7 @@ static ssize_t aio_rw_vect_retry(struct kiocb *iocb, =
int rw, aio_rw_op *rw_op)
 	} while (ret > 0 && iocb->ki_left > 0 &&
 		 (rw =3D=3D WRITE ||
 		  (!S_ISFIFO(inode->i_mode) && !S_ISSOCK(inode->i_mode))));
-	if (opcode =3D=3D IOCB_CMD_PWRITEV)
+	if (rw =3D=3D WRITE)
 		file_end_write(file);
=20
 	/* This means we must have transferred all that we could */
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Apr_2013_17_44_50_+1100_A.8zfjwGjH8bi/7r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXSFiAAoJEECxmPOUX5FEHmUQAKeIR02SzwPOnJTZ69RLgyPd
xsdqCS4QW5mqZ9Z+ghr73BImPBC8vYJSXO6ovItYufMpbOrCR0lElBzG92ro1RCW
siAKF16EW4/GvSStmEHfu3JlxShWw5QQmWdRmZjfDVIgf2gJ8SKpN0SE/0UkM31y
vNunlr+bTtQNk1rxpY0s3yZg100SZzhwbFHp8M+wFUkJ07m6sh+aAaOhHGlix3B3
NXV0qhKWN7hmSvez3Oq1LtcMg7ZUXltTTcIMp1ibgG8VF425d14SkUvR7v+iN1fv
XBqe5qxsSRqpsUcPdXMgmoyfw6KUr3RAiteWDeyNgeKyA/W3ASpsCIyxz+DecsJR
pHwHVdEhrwfHOaY3GNZ4crxysUkFW0aL0wJCwwo9KZzlVnyT/eJ5UuSPHfZd4ILx
3MzGqgpRaoENRrq/qLiit8PSrwThasVnSwFuwgaCHxJ42hjDZSsf7iLQ1mq0kmVX
wh+AVolWwnyxnDfqrdd0zUMF2hdL60rG7SfI/f6xsM6JQQKvluuQMCVeotdeRy0/
obw03QtVqQG032Tk72YCkuNdo8Btz1KMnZgZ29PuXMH5dRIjUUnDEG6br8Y5y4+0
N2uxlH2EMj5r4kIHC3p9bGC5bZJGbmM343KhAebVnjmiWBJAEkzSRmUvamxokDZj
JqmywPcY+s5EETVgK0Y7
=rVdn
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_17_44_50_+1100_A.8zfjwGjH8bi/7r--
