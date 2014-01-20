Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaATFZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 00:25:36 -0500
Received: from ozlabs.org ([203.10.76.45]:55841 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbaATFZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 00:25:33 -0500
Date: Mon, 20 Jan 2014 16:25:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: linux-next: build failure after merge of the target-updates tree
Message-Id: <20140120162524.82964f2972d8933ce05e4df4@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_Jan_2014_16_25_24_+1100_rUdNPtcK682yRAiD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Jan_2014_16_25_24_+1100_rUdNPtcK682yRAiD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

After merging the target-updates tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/target/target_core_iblock.c: In function 'iblock_alloc_bip':
drivers/target/target_core_iblock.c:646:5: error: 'struct bio_integrity_pay=
load' has no member named 'bip_size'
  bip->bip_size =3D (cmd->data_length / dev->dev_attrib.block_size) *
     ^
drivers/target/target_core_iblock.c:648:5: error: 'struct bio_integrity_pay=
load' has no member named 'bip_sector'
  bip->bip_sector =3D bio->bi_sector;
     ^
drivers/target/target_core_iblock.c:648:23: error: 'struct bio' has no memb=
er named 'bi_sector'
  bip->bip_sector =3D bio->bi_sector;
                       ^
In file included from include/linux/printk.h:243:0,
                 from include/linux/kernel.h:13,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:4,
                 from include/linux/ktime.h:24,
                 from include/linux/timer.h:5,
                 from drivers/target/target_core_iblock.c:29:
drivers/target/target_core_iblock.c:650:52: error: 'struct bio_integrity_pa=
yload' has no member named 'bip_size'
  pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_size,
                                                    ^
drivers/target/target_core_iblock.c:651:27: error: 'struct bio_integrity_pa=
yload' has no member named 'bip_sector'
    (unsigned long long)bip->bip_sector);
                           ^

Caused by commit ecebbf6ccbca ("target/iblock: Add blk_integrity + BIP
passthrough support") interacting with commits 4f024f3797c4 ("block:
Abstract out bvec iterator") and d57a5f7c6605 ("bio-integrity: Convert to
bvec_iter") from the block tree.

I applied the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 20 Jan 2014 16:21:31 +1100
Subject: [PATCH] tagtet/iblock: merge for for bvec_iter changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/target/target_core_iblock.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_co=
re_iblock.c
index b7c64ef78338..554d4f75a75a 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -643,12 +643,12 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
 		return -ENOMEM;
 	}
=20
-	bip->bip_size =3D (cmd->data_length / dev->dev_attrib.block_size) *
+	bip->bip_iter.bi_size =3D (cmd->data_length / dev->dev_attrib.block_size)=
 *
 			 dev->prot_length;
-	bip->bip_sector =3D bio->bi_sector;
+	bip->bip_iter.bi_sector =3D bio->bi_iter.bi_sector;
=20
-	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_size,
-		 (unsigned long long)bip->bip_sector);
+	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
+		 (unsigned long long)bip->bip_iter.bi_sector);
=20
 	for_each_sg(cmd->t_prot_sg, sg, cmd->t_prot_nents, i) {
=20
--=20
1.8.5.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__20_Jan_2014_16_25_24_+1100_rUdNPtcK682yRAiD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3LNLAAoJEMDTa8Ir7ZwVM6oP/04s2/pcVCjNBHlc8GhalUQi
tt/uQk0ckFI64LA3wOZeM44xcB48TuUytEATgnj35ZDezkvL8AHrx6TAE+cfsCPU
duO8q78AvadFd4RItnPM55aPIQf6ev37BEo3jN6Ld/U3iUTejeNUkUYvP6VIJT/t
AIVzth8jQvdoRLj64zvnqOHmSNqIrCqWxBObGBdMWPo+8Fp8uZTh6y7vahdZHISK
FJLl6oBObQRYH8+RsyQrpZy18oGTdONkz7g0Nz8xS03SlLt170i3/ruqdMhmpL5W
tgZWfQw3gudOsqE0ubw0QkiaRpTeHk9VaCdBFj5w6WeJ+JMYwNahH7I5GDgA/KiJ
XS2Bz20oaFtd97ODw3l+JWpNI82yqFqp+I6D5UYoOv3yAf4AHt0HjlsIdeDbcVak
2tTA0o1pIt4OR7sqF+cuts3GnDujDDc9RrwSTpEvsd94GIBzJI/G0PuX7K+lCka/
U/nKb3zJ8tQrR/yfQO/FUpV0pK+nZBFKzbslRL93RW+hFJcjUPBHasBFCfMqZQ+F
v5qGjSbBRAXoS3MZiXjMekrYVu6KNLPi3sE7wnNTxn1nAjVsg4K8Vkgd+x6/4/Fx
IU0dpl2N2hJzJmDQIbhSQDDDekObjlaJnHYLc/Ks2gx/Io2tcEt+qZIruX4hDUvn
SsYDV2JHQ5DbJYZRN3Vz
=dL9r
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Jan_2014_16_25_24_+1100_rUdNPtcK682yRAiD--
