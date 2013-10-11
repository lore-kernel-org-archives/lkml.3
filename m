Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3JKTFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:05:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53960 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab3JKTF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:05:29 -0400
Date: Fri, 11 Oct 2013 20:04:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>
Message-ID: <20131011190443.GI2443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TA4f0niHM6tHt3xR"
Content-Disposition: inline
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: manual merge of the block tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TA4f0niHM6tHt3xR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Today's linux-next merge of the block tree got additional conflicts due to
interaction between dd879364 (bcache: Break up struct search) and
c0f04d88 (bcache: Fix flushes in writeback mode) in Linus' tree.

I fixed it up (see below) and can carry as required. Please check if the
resolution looks correct.

diff --cc drivers/md/bcache/request.c
index b6a74bc,231b108..0000000
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@@ -979,67 -1059,52 +1059,53 @@@ static void cached_dev_write(struct cac
 =20
  	if (should_writeback(dc, s->orig_bio,
  			     cache_mode(dc, bio),
- 			     s->op.skip)) {
- 		s->op.skip =3D false;
- 		s->writeback =3D true;
+ 			     s->iop.bypass)) {
+ 		s->iop.bypass =3D false;
+ 		s->iop.writeback =3D true;
  	}
 =20
- 	if (s->op.skip)
- 		goto skip;
-=20
- 	trace_bcache_write(s->orig_bio, s->writeback, s->op.skip);
+ 	if (s->iop.bypass) {
+ 		s->iop.bio =3D s->orig_bio;
+ 		bio_get(s->iop.bio);
 =20
- 	if (!s->writeback) {
- 		s->op.cache_bio =3D bio_clone_bioset(bio, GFP_NOIO,
- 						   dc->disk.bio_split);
-=20
- 		closure_bio_submit(bio, cl, s->d);
- 	} else {
+ 		if (!(bio->bi_rw & REQ_DISCARD) ||
+ 		    blk_queue_discard(bdev_get_queue(dc->bdev)))
+ 			closure_bio_submit(bio, cl, s->d);
+ 	} else if (s->iop.writeback) {
  		bch_writeback_add(dc);
- 		s->op.cache_bio =3D bio;
 =20
 -		if (s->iop.flush_journal) {
 +		if (bio->bi_rw & REQ_FLUSH) {
  			/* Also need to send a flush to the backing device */
 -			s->iop.bio =3D bio_clone_bioset(bio, GFP_NOIO,
 -						      dc->disk.bio_split);
 +			struct bio *flush =3D bio_alloc_bioset(0, GFP_NOIO,
 +							     dc->disk.bio_split);
 =20
 -			bio->bi_size =3D 0;
 -			bio->bi_vcnt =3D 0;
 -			closure_bio_submit(bio, cl, s->d);
 -		} else {
 -			s->iop.bio =3D bio;
 +			flush->bi_rw	=3D WRITE_FLUSH;
 +			flush->bi_bdev	=3D bio->bi_bdev;
 +			flush->bi_end_io =3D request_endio;
 +			flush->bi_private =3D cl;
 +
 +			closure_bio_submit(flush, cl, s->d);
  		}
- 	}
- out:
- 	closure_call(&s->op.cl, bch_insert_data, NULL, cl);
- 	continue_at(cl, cached_dev_write_complete, NULL);
- skip:
- 	s->op.skip =3D true;
- 	s->op.cache_bio =3D s->orig_bio;
- 	bio_get(s->op.cache_bio);
+ 	} else {
+ 		s->iop.bio =3D bio_clone_bioset(bio, GFP_NOIO,
+ 					      dc->disk.bio_split);
 =20
- 	if ((bio->bi_rw & REQ_DISCARD) &&
- 	    !blk_queue_discard(bdev_get_queue(dc->bdev)))
- 		goto out;
+ 		closure_bio_submit(bio, cl, s->d);
+ 	}
 =20
- 	closure_bio_submit(bio, cl, s->d);
- 	goto out;
+ 	closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
+ 	continue_at(cl, cached_dev_write_complete, NULL);
  }
 =20
- static void request_nodata(struct cached_dev *dc, struct search *s)
+ static void cached_dev_nodata(struct closure *cl)
  {
- 	struct closure *cl =3D &s->cl;
+ 	struct search *s =3D container_of(cl, struct search, cl);
  	struct bio *bio =3D &s->bio.bio;
 =20
- 	if (bio->bi_rw & REQ_DISCARD) {
- 		request_write(dc, s);
- 		return;
- 	}
-=20
- 	if (s->op.flush_journal)
- 		bch_journal_meta(s->op.c, cl);
+ 	if (s->iop.flush_journal)
+ 		bch_journal_meta(s->iop.c, cl);
 =20
+ 	/* If it's a flush, we send the flush to the backing device too */
  	closure_bio_submit(bio, cl, s->d);
 =20
  	continue_at(cl, cached_dev_bio_complete, NULL);

--TA4f0niHM6tHt3xR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSWEvIAAoJELSic+t+oim9HeMP/iw9SzgJG1RlfvaS9tbwwYD+
x5WWEtF3VajDjERwIU1rHFwPuJGh1PfM0NOn1Z6bnvqL9TleghxOuGEZEgeHzJgX
2881t33LqxLATJ79wYPj3cLIdjueug7A1gekpuVDet4MwOGUrWlCpLhRtwCo4il2
0hpm8OcgD/OWIs2Avtmw321x8nqKPx/NdbQ3J68Rufp9FHpuzYc5qqGDFTuXVhjI
oCBSV/wYwHlgake+tYI44NRhLkb/J1SD1DG59U+sFpIuhWdLi6aOC1D/+lP/im96
vLdTQ7UL6bxaxceY4x5uFWrfwKOn1SgJpjiXhRDYHuzL85kb0VI/9eELRv/6+/wd
/aimoi5WAzm19ox/NNBj27E20ImQiiyPU+/g4b637gILpiwCJTqaKCl/uRnphc9s
wyiL5EHwaBVCfZk+GeT4Wa7Cim8Pz2I3QLLMpkP079esny5BvkrbXgtXPri99CDc
M+Q5D3UuntQp7rTjbQ/wdOIKE+q6FZ2Gl2FkwgseKeB/L6rTFzi36yhG8FDtg0wA
xQHix7PYGUt+AIS9947ZcoZCuoJ0coBxzZz8LuDf5buCXgsTrNDQX/RgjfX0m8h+
er0Mmi4EIkLKPbzBZfVqZ2DW0xgQ7g/s08EkjlrOMiHkHtPffKcwgVcGwBIGdP63
7HQX3VQbYUVvenfqMwrk
=p1Bu
-----END PGP SIGNATURE-----

--TA4f0niHM6tHt3xR--
