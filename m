Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab3CZFdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 01:33:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44326 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab3CZFdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 01:33:53 -0400
Date: Tue, 26 Mar 2013 16:33:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>
Subject: linux-next: manual merge of the akpm tree with the block tree
Message-Id: <20130326163349.14db6908651d400d92f91b2f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__26_Mar_2013_16_33_49_+1100_h3uWtgYJNdnHhfU9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Mar_2013_16_33_49_+1100_h3uWtgYJNdnHhfU9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
block/blk-core.c between commit f79ea4161434 ("block: Refactor
blk_update_request()") from the block tree and commit "block, aio: batch
completion for bios/kiocbs" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc block/blk-core.c
index f224d17,186603b..0000000
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@@ -2280,9 -2251,11 +2281,10 @@@ EXPORT_SYMBOL(blk_fetch_request)
   *     %false - this request doesn't have any more data
   *     %true  - this request has more data
   **/
- bool blk_update_request(struct request *req, int error, unsigned int nr_b=
ytes)
+ bool blk_update_request(struct request *req, int error, unsigned int nr_b=
ytes,
+ 			struct batch_complete *batch)
  {
 -	int total_bytes, bio_nbytes, next_idx =3D 0;
 -	struct bio *bio;
 +	int total_bytes;
 =20
  	if (!req->bio)
  		return false;
@@@ -2328,21 -2301,56 +2330,21 @@@
 =20
  	blk_account_io_completion(req, nr_bytes);
 =20
 -	total_bytes =3D bio_nbytes =3D 0;
 -	while ((bio =3D req->bio) !=3D NULL) {
 -		int nbytes;
 +	total_bytes =3D 0;
 +	while (req->bio) {
 +		struct bio *bio =3D req->bio;
 +		unsigned bio_bytes =3D min(bio->bi_size, nr_bytes);
 =20
 -		if (nr_bytes >=3D bio->bi_size) {
 +		if (bio_bytes =3D=3D bio->bi_size)
  			req->bio =3D bio->bi_next;
 -			nbytes =3D bio->bi_size;
 -			req_bio_endio(req, bio, nbytes, error, batch);
 -			next_idx =3D 0;
 -			bio_nbytes =3D 0;
 -		} else {
 -			int idx =3D bio->bi_idx + next_idx;
 =20
- 		req_bio_endio(req, bio, bio_bytes, error);
 -			if (unlikely(idx >=3D bio->bi_vcnt)) {
 -				blk_dump_rq_flags(req, "__end_that");
 -				printk(KERN_ERR "%s: bio idx %d >=3D vcnt %d\n",
 -				       __func__, idx, bio->bi_vcnt);
 -				break;
 -			}
++		req_bio_endio(req, bio, bio_bytes, error, batch);
 =20
 -			nbytes =3D bio_iovec_idx(bio, idx)->bv_len;
 -			BIO_BUG_ON(nbytes > bio->bi_size);
 +		total_bytes +=3D bio_bytes;
 +		nr_bytes -=3D bio_bytes;
 =20
 -			/*
 -			 * not a complete bvec done
 -			 */
 -			if (unlikely(nbytes > nr_bytes)) {
 -				bio_nbytes +=3D nr_bytes;
 -				total_bytes +=3D nr_bytes;
 -				break;
 -			}
 -
 -			/*
 -			 * advance to the next vector
 -			 */
 -			next_idx++;
 -			bio_nbytes +=3D nbytes;
 -		}
 -
 -		total_bytes +=3D nbytes;
 -		nr_bytes -=3D nbytes;
 -
 -		bio =3D req->bio;
 -		if (bio) {
 -			/*
 -			 * end more in this run, or just return 'not-done'
 -			 */
 -			if (unlikely(nr_bytes <=3D 0))
 -				break;
 -		}
 +		if (!nr_bytes)
 +			break;
  	}
 =20
  	/*

--Signature=_Tue__26_Mar_2013_16_33_49_+1100_h3uWtgYJNdnHhfU9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUTM9AAoJEECxmPOUX5FE5y0P/AvF5HfcfIuNUBgrQW30ZPfP
Y3VHRweAju2lleg8zTeGjb/EALMtWYY7JlkIZOJT9gvuwV4Le+tOBfrDYo7aqu+G
v3aQlmqVK/A+vta6Fqo7MgCRas5TGJP/ia2w8Vk3f6vH67yc5sEolFPdhaWciGrM
ffPr0/A6H+pw3Mb7G6JFOoZx5Enjmi0Pl9HPM0tLr0nr7o9QaKAhYgeCbR53XkUB
I2sWZ29muSiXS0EoQb/usMSU6rBK6UTJJowzdnk00d0iqMDV/FaOvjEipK9gK3sT
ZBAXfkBDbJOwR9BMaS1bwFPEpmsLbiaFhqcogLtj4PthwiltP99vaumh3/y+M9sT
tuVkX+qdLQzILA6A7CsftZdly0Dlu8FFwg+2u33IKXpc8tEFr48qTN/BstbmizYC
27im4uGtaJP6MNsTryzD/l6pqGKPYv5JFyibeQLeKEEV2FLS/DwOmOS76lSh2l0p
MzM8paXvKOBIA+To2D2pA7wMW2II+8edEjNOKARrrjPrP6QBObNFUwYQmHrM7uTY
jGcgHY8XQrWAdo3GUYdUEfCOKjRs22ryXZZfKQIXluZ3T3oNUxpb7bKuXYLf6hSU
ep+V02U9UtSuTlzgxX0MTRxgizypkw+glQ4Thno7h7bOYDBxCscU5fjZpLVOVZo6
hrBUMX2osFj+5xpEphID
=nbgM
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Mar_2013_16_33_49_+1100_h3uWtgYJNdnHhfU9--
