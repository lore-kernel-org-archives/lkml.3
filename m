Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab3KEG0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:26:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41006 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3KEG0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:26:07 -0500
Date: Tue, 5 Nov 2013 17:25:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: linux-next: manual merge of the akpm-current tree with the block
 tree
Message-Id: <20131105172558.325b95c1f365028250a0eab2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Nov_2013_17_25_58_+1100_vIk=bx/yKJp=UmQD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Nov_2013_17_25_58_+1100_vIk=bx/yKJp=UmQD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
fs/bio-integrity.c between commits ed2d2f9a8265 ("block: Abstract out
bvec iterator") and 5d1f127c3e0c ("block: Convert bio_for_each_segment()
to bvec_iter") from the block tree and commit 6952c5b3b2b7
("fs/bio-integrity.c: remove duplicated code") from the akpm-current tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/bio-integrity.c
index 31f2d5af7b24,8a78830133ab..000000000000
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@@ -304,26 -295,37 +300,38 @@@ static int bio_integrity_generate_verif
  {
  	struct blk_integrity *bi =3D bdev_get_integrity(bio->bi_bdev);
  	struct blk_integrity_exchg bix;
 -	struct bio_vec *bv;
 +	struct bio_vec bv;
 +	struct bvec_iter iter;
- 	sector_t sector =3D bio->bi_iter.bi_sector;
- 	unsigned int sectors, total;
+ 	sector_t sector;
 -	unsigned int i, sectors, total, ret;
++	unsigned int sectors, total, ret;
  	void *prot_buf =3D bio->bi_integrity->bip_buf;
 =20
- 	total =3D 0;
+ 	if (operate)
 -		sector =3D bio->bi_sector;
++		sector =3D bio->bi_iter.bi_sector;
+ 	else
 -		sector =3D bio->bi_integrity->bip_sector;
++		sector =3D bio->bi_integrity->bip_iter.bi_sector;
+=20
+ 	ret =3D total =3D 0;
  	bix.disk_name =3D bio->bi_bdev->bd_disk->disk_name;
  	bix.sector_size =3D bi->sector_size;
 =20
 -	bio_for_each_segment(bv, bio, i) {
 -		void *kaddr =3D kmap_atomic(bv->bv_page);
 -		bix.data_buf =3D kaddr + bv->bv_offset;
 -		bix.data_size =3D bv->bv_len;
 +	bio_for_each_segment(bv, bio, iter) {
 +		void *kaddr =3D kmap_atomic(bv.bv_page);
 +		bix.data_buf =3D kaddr + bv.bv_offset;
 +		bix.data_size =3D bv.bv_len;
  		bix.prot_buf =3D prot_buf;
  		bix.sector =3D sector;
-=20
- 		bi->generate_fn(&bix);
+ 		if (operate) {
+ 			bi->generate_fn(&bix);
+ 		} else {
+ 			ret =3D bi->verify_fn(&bix);
+ 			if (ret) {
+ 				kunmap_atomic(kaddr);
+ 				return ret;
+ 			}
+ 		}
 =20
 -		sectors =3D bv->bv_len / bi->sector_size;
 +		sectors =3D bv.bv_len / bi->sector_size;
  		sector +=3D sectors;
  		prot_buf +=3D sectors * bi->tuple_size;
  		total +=3D sectors * bi->tuple_size;

--Signature=_Tue__5_Nov_2013_17_25_58_+1100_vIk=bx/yKJp=UmQD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSeI96AAoJEMDTa8Ir7ZwVSwUP/1jiRd9awe+C+y5aNnkjjqau
aqHpThvFDmUzE4LWWm0ImEekkIsqh1iiLa30Tnc4tjn5c704PBqOopZrmT9L3GzI
/NrvWIEI7kGPkvMvGD2PY0Oi85HwchgSEBmg0+FlkUvOU8fowtzH7V7PCWMYCla7
988LzM3zvM8ytaXKzmNueb1+/gq0rVwmbfCYIJDEcxGCdvRox9lD/TGPTE3cuWbQ
o6QlZ0PR3VNSlLxHqaDldYFA3Ete569BCRPF/eehJPayZI++gWRPIew91vCR4+qz
AIASPEBLZZE2k4JVcpKtnUB72MG4T1QonDoyu4GMNxyz+8rOa5nVBhGU45ExwxxC
cE73CdinFpeVlWd1tfThyJOHIpVJbsC2fih20WX0lpWKfjZyTQERqEP8JJDhKawB
ZeMmu2nvyAmLIiKndeZ6/cET36OcEeeU7wPHqhFYYRVGCu8PW247IHAKT2PneHs6
yy+epZppEGd/osdjCu3JKpya1wWZ1VGN65HNjXbrK0MtuTh1ZOLdlWAzRNIDxejz
n4zQy98YWzyvqjYcMKfSQ7KbtGvYpDgI3O5gMjuzoNuTIdI0tu1Xk4BLNXwB7kjD
TezUqDimU4Sf+xMFRWrdpzxUJgDudHZWmv/Rzuh/OHAjVuJmsIGo+40KK6eLnB3y
HhoHChzpOlUmCzJoJjw6
=aud7
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Nov_2013_17_25_58_+1100_vIk=bx/yKJp=UmQD--
