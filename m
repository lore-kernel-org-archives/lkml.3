Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab3IYDL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:11:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41135 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3IYDLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:11:23 -0400
Date: Wed, 25 Sep 2013 13:11:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20130925131113.5106bbddf4b56b77c7ba12ca@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__25_Sep_2013_13_11_13_+1000_v_stM=jMstKfRuJS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Sep_2013_13_11_13_+1000_v_stM=jMstKfRuJS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/md/bcache/request.c between commit c0f04d88e46d ("bcache: Fix
flushes in writeback mode") from Linus' tree and commit 53027147e43c
("bcache: Prune struct btree_op") and dd879364df83 ("bcache: Break up struc=
t search") from the block tree.

I fixed it up (I wasn't sure, but I used the version from Linus' tree -
see below) and can carry the fix as necessary (no action is required).

There were several other patches that affect this area that were commited
directly to Linus' tree today ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/md/bcache/request.c
index 71eb233,231b108..0000000
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@@ -979,68 -1059,52 +1059,55 @@@ static void cached_dev_write(struct cac
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
 +			flush->bi_rw	=3D WRITE_FLUSH;
 +			flush->bi_bdev	=3D bio->bi_bdev;
 +			flush->bi_end_io =3D request_endio;
 +			flush->bi_private =3D cl;
 +
 +			closure_bio_submit(flush, cl, s->d);
  		} else {
- 			s->op.cache_bio =3D bio;
+ 			s->iop.bio =3D bio;
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

--Signature=_Wed__25_Sep_2013_13_11_13_+1000_v_stM=jMstKfRuJS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSQlRWAAoJEECxmPOUX5FEd4IP/2fcq686jj9l4utnre6y3Q8M
bx/lvN6bCfsiheCheNHNEPUy1XjeIhFpudWNk2Utbajl4xxWXxBNLHlLq8zsPYsn
AISRjapQsO1DNxGrXSQckmsYPvnnQ4TuEBV92Unvqr0tBUiiTtPacxGdURwwDpXC
zkdtgRGWgJo8GqRv9Y3zy8NOrp0TAVP9vwhDzHFjtf8I+PeY+gG7FR9z1+Brrk82
G9DrDja68Jc80o6j9X4SZyg/kw9mGvtp0DDc+giatsDrEBdQh3YJdb5tyQCqU4vH
eb+Y57cAq6jlH23t0EQ+isVbBZjKSK+GtaPUOAMXXjdRufM510BZjkfCXM8DkpIP
BjuJdUbJOZqduWHtY1bzt8b7iEiMhRUAnLIIiXnzLBFHCCp90zNIXEwJdC7saEX1
yqB2Ysal7ML1U/mmnYBYcGtIQyJJizFzsjoJVkLObe8WRHT4/B+QsY+SXsrbDRmJ
aSCoQgYYQvK5IFjnFQKggnlC0ZBoJBtxHX5zNpOCdqgkXjR8WUHO/GAk5tOdR0nU
T5kMk1f+c5HB6FleX+PpExcnR5xd/h2GhUvr3e7mB+YysFdd3wr2X8p1ixHRGs7A
J86qZYhZRE7PaaFnmw2G+isGLNHqwvJeCEBmSSRuyK9JblCmKfHoMkpEoY8S1DaI
0sFaXH1HQz0BWYEJEcBU
=ZTHw
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Sep_2013_13_11_13_+1000_v_stM=jMstKfRuJS--
