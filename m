Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750796Ab3KAECH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 00:02:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53968 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3KAECE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 00:02:04 -0400
Date: Fri, 1 Nov 2013 15:01:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20131101150153.cc4b855937372d1670f2f4f8@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Nov_2013_15_01_53_+1100_LDmfcTyIsL9/_HlJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Nov_2013_15_01_53_+1100_LDmfcTyIsL9/_HlJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/block/loop.c: In function 'lo_rw_aio':
drivers/block/loop.c:243:28: error: 'struct bio' has no member named 'bi_se=
ctor'
  loff_t pos =3D ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
                            ^
drivers/block/loop.c:254:2: error: implicit declaration of function 'bio_io=
vec_idx' [-Werror=3Dimplicit-function-declaration]
  bvec =3D bio_iovec_idx(bio, bio->bi_idx);
  ^
drivers/block/loop.c:254:31: error: 'struct bio' has no member named 'bi_id=
x'
  bvec =3D bio_iovec_idx(bio, bio->bi_idx);
                               ^
drivers/block/loop.c: In function 'lo_discard':
drivers/block/loop.c:476:28: error: 'struct bio' has no member named 'bi_se=
ctor'
  loff_t pos =3D ((loff_t) bio->bi_sector << 9) + lo->lo_offset;
                            ^
drivers/block/loop.c:489:50: error: 'struct bio' has no member named 'bi_si=
ze'
  ret =3D file->f_op->fallocate(file, mode, pos, bio->bi_size);
                                                  ^

Basically caused by in incomplete merge between the block tree and the
aio-direct tree (see my previous email).

I was going to apply a merge fix patch, but I also got these:

In file included from include/linux/blkdev.h:18:0,
                 from drivers/block/ps3disk.c:22:
drivers/block/ps3disk.c: In function 'ps3disk_scatter_gather':
include/linux/bio.h:239:9: error: incompatible types when assigning to type=
 'struct bio_vec *' from type 'struct bio_vec'
   ((bvl =3D bio_iter_iovec((bio), (iter))), 1);  \
         ^
include/linux/bio.h:243:2: note: in expansion of macro '__bio_for_each_segm=
ent'
  __bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
  ^
include/linux/blkdev.h:748:3: note: in expansion of macro 'bio_for_each_seg=
ment'
   bio_for_each_segment(bvl, _iter.bio, _iter.iter)
   ^
drivers/block/ps3disk.c:102:2: note: in expansion of macro 'rq_for_each_seg=
ment'
  rq_for_each_segment(bvec, req, iter) {
  ^
include/linux/bio.h:239:41: warning: left-hand operand of comma expression =
has no effect [-Wunused-value]
   ((bvl =3D bio_iter_iovec((bio), (iter))), 1);  \
                                         ^
include/linux/bio.h:243:2: note: in expansion of macro '__bio_for_each_segm=
ent'
  __bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
  ^
include/linux/blkdev.h:748:3: note: in expansion of macro 'bio_for_each_seg=
ment'
   bio_for_each_segment(bvl, _iter.bio, _iter.iter)
   ^
drivers/block/ps3disk.c:102:2: note: in expansion of macro 'rq_for_each_seg=
ment'
  rq_for_each_segment(bvec, req, iter) {
  ^
include/linux/bio.h:240:45: error: request for member 'bv_len' in something=
 not a structure or union
       bio_advance_iter((bio), &(iter), (bvl).bv_len))
                                             ^
include/linux/bio.h:243:2: note: in expansion of macro '__bio_for_each_segm=
ent'
  __bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
  ^
include/linux/blkdev.h:748:3: note: in expansion of macro 'bio_for_each_seg=
ment'
   bio_for_each_segment(bvl, _iter.bio, _iter.iter)
   ^
drivers/block/ps3disk.c:102:2: note: in expansion of macro 'rq_for_each_seg=
ment'
  rq_for_each_segment(bvec, req, iter) {
  ^
In file included from block/blk-merge.c:6:0:
block/blk-merge.c: In function '__blk_recalc_rq_segments':
include/linux/bio.h:174:25: warning: 'bvprv.bv_len' may be used uninitializ=
ed in this function [-Wmaybe-uninitialized]
  ((bvec_to_phys((vec1)) + (vec1)->bv_len) =3D=3D bvec_to_phys((vec2)))
                         ^
block/blk-merge.c:15:21: note: 'bvprv.bv_len' was declared here
  struct bio_vec bv, bvprv;
                     ^
In file included from block/blk-merge.c:6:0:
include/linux/bio.h:154:55: warning: 'bvprv.bv_offset' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]
 #define bvec_to_phys(bv) (page_to_phys((bv)->bv_page) + (unsigned long) (b=
v)->bv_offset)
                                                       ^
block/blk-merge.c:15:21: note: 'bvprv.bv_offset' was declared here
  struct bio_vec bv, bvprv;
                     ^
In file included from arch/powerpc/include/asm/page.h:412:0,
                 from arch/powerpc/include/asm/thread_info.h:34,
                 from include/linux/thread_info.h:54,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from block/blk-merge.c:5:
include/asm-generic/memory_model.h:52:52: warning: 'bvprv.bv_page' may be u=
sed uninitialized in this function [-Wmaybe-uninitialized]
 #define __page_to_pfn(page) (unsigned long)((page) - vmemmap)
                                                    ^
block/blk-merge.c:15:21: note: 'bvprv.bv_page' was declared here
  struct bio_vec bv, bvprv;
                     ^

Some of this may be incomplete merge resolution on my part (help would
be appreciated), but some seems to maybe need more work.

I have used the block tree from next-20131031 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__1_Nov_2013_15_01_53_+1100_LDmfcTyIsL9/_HlJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScye2AAoJEMDTa8Ir7ZwVFSIP/R8g0xN5fVG7QrSvmbjm1XKE
sqtphDnrEXfkW9mX6j5lI0Z+y+kzrEwhMXGMA70G3eCJ08Qykri6NyAZ86YnWDSO
Wg3DoyQ9OPmjIzmbyC4rTQZN7nZLEXe4sStlewZolZTvhny9Dj2M1WZs8T5MVefW
FyWh9Tyub97d3sjGfQbCBd3tbwqPZ4fKjEQC2aZiaR8y5R4t2DKl+ERa803lvdfI
eAms+ScsIcnqUD+lzgpg9Sj9f/qZRsV7m+TieekAnrpa8Q/56KiXt2DUrJBOft5E
ro9/3glwvnEd4vyo9i5Yy6q903/yau/hhq0enMlCsx48R0t6ZOLzQluVC3i3MMXM
y5lHTMFAVBbXBflLad0bCaFvcy6AuORubmrHDLSZow1RDqvFBtvR4oZghl+pDy3Q
HA+c6FJ0tERAVgSTefqF/mmy8IqHSBVM+iQoA5vgWRfd6D8Q+CewFO5t+UPr77Gs
svyFGSF4SkCxaUU9p5jyxe8KeTKDHHKX/3mznAVE8qEhM5ezaGUxu71xdt7bMgWb
1nJME8IQ2by1oBvi8FynjPHK1CFX34oHYEUeQLvUDTT4Uhf2FW3XrDnviok7S90p
qpJF0fglAmtWDI1oLdVYQ+Yb7zoj2EV/1UhPxXKqM5GX/yEe4VKDnRqYyywKqBYW
eQz8LTEJcZw8asOcBkqJ
=CmHF
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Nov_2013_15_01_53_+1100_LDmfcTyIsL9/_HlJ--
