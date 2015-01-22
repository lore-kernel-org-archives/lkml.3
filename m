Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbbAVHeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:34:01 -0500
Received: from ozlabs.org ([103.22.144.67]:51259 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbbAVHdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:33:45 -0500
Date: Thu, 22 Jan 2015 18:33:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Weiwei Wang <wangww631@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20150122183334.3c5077a9@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/U5xgNWVqYgnl1/93Jjljo8v"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/U5xgNWVqYgnl1/93Jjljo8v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (x86_64 allmo=
dconfig)
failed like this:

fs/ocfs2/aops.c: In function 'ocfs2_direct_IO_write':
fs/ocfs2/aops.c:784:9: error: too few arguments to function 'blkdev_issue_z=
eroout'
   ret =3D blkdev_issue_zeroout(osb->sb->s_bdev,
         ^
In file included from fs/ocfs2/aops.c:31:0:
include/linux/blkdev.h:1165:12: note: declared here
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
            ^

Caused by commit e95f8b5356c4 ("ocfs2: implement
ocfs2_direct_IO_write") interacting with commit d93ba7a5a97c ("block:
Add discard flag to blkdev_issue_zeroout() function") from the block
tree.

I have added this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 22 Jan 2015 18:28:21 +1100
Subject: [PATCH] ocfs2: implement ocfs2_direct_IO_write fix

update for an API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/ocfs2/aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 89f43dc7e440..af22615afd35 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -784,7 +784,7 @@ static ssize_t ocfs2_direct_IO_write(struct kiocb *iocb,
 		ret =3D blkdev_issue_zeroout(osb->sb->s_bdev,
 				p_cpos << (osb->s_clustersize_bits - 9),
 				zero_len >> 9,
-				GFP_KERNEL);
+				GFP_KERNEL, false);
 		if (ret < 0)
 			mlog_errno(ret);
 	}
--=20
2.1.4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/U5xgNWVqYgnl1/93Jjljo8v
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUwKfWAAoJEMDTa8Ir7ZwVCukP/ihNYOCM/8aK4WlmcZNru3Ln
JLh9pHGwy6lrlIAtQwbg3J8nvMdm7YGoZGa18Ilhi/d2XNRu3FlBUgXNwB7jE+vm
amyy0QUnMXAe3xoQxuj52tVUQUxpXkenpQ5S6FEIHa7crc/MMYkt++i2C15WDP4V
BwPsUZ4FBOwhtSMMypJl3H4bL9AUgmU33aRr38A2obcUB7dbAVrN99o6FVGZTmHR
8vx4bZjA/v6wYVDGhgvMC4ZYpKwbmEORsCjVa1aya1YBIq8yFHWv2PJ0PsUF2yzQ
SeDiV6FjDvgGFlUQfofI6VJZGUUBPAGf8ipTS4y35uzysitaBtZiYGhFIKEwegA8
6UTXVbfd+WpfnU98yauXxn51w+UUxXf0oeKHpcd6S+SzcWIcNOvndpzDQABiTd9T
Ci1KuLdzYGaX+5CAPbV+TIpqCdhr6J336t/gVkmQVc/VHqSdpbQ5io5kq/U+B9O7
JnshVNE6ROMGiB5BvqcXw2Pn2KLBWt5omWU7YSyYpXblod/ZWtYS6KmNvEoT08CJ
Wcoi0uRXrvpxulIQbSQA/7GcOXlR/SQVyfQgMC4Oyke/o0n+nAgekRydP488aux9
6Ns1LO3bN96TjhT2j3b6eex00ni+F8fvPlJvPh8EzN30LzSALn3TemTEw6BRpXay
dk/gM+XbkDjDMADHlyDd
=qow7
-----END PGP SIGNATURE-----

--Sig_/U5xgNWVqYgnl1/93Jjljo8v--
