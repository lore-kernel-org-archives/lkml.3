Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaAFGD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:03:58 -0500
Received: from ozlabs.org ([203.10.76.45]:57085 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbaAFGDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:03:46 -0500
Date: Mon, 6 Jan 2014 17:03:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huajun Li <huajun.li@intel.com>, Chao Yu <chao2.yu@samsung.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: linux-next: manual merge of the block tree with the f2fs tree
Message-Id: <20140106170334.10677a1411be318db882e1fd@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Jan_2014_17_03_34_+1100__yvG2ER.OuJQI5Gi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jan_2014_17_03_34_+1100__yvG2ER.OuJQI5Gi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/f2fs/data.c between various commits from the f2fs tree and commits
2c30c71bd653 ("block: Convert various code to bio_for_each_segment()")
and 4f024f3797c4 ("block: Abstract out bvec iterator") from the block
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

The conflict in this file are a bit of a pain as I am having to fix this
up by hand most days (and I hope I am getting it right).  Maybe the f2fs
tree could merge commit 4f024f3797c4 ("block: Abstract out bvec
iterator") from the block tree (assuming that it will remain stable) as
it is only 4 commits and do these fixups properly (with a bit of help in
case what I have done above is not exactly right).  That merge commit
would need a good commit message, of course.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/f2fs/data.c
index 63d190264a36,a2c8de8ba6ce..000000000000
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@@ -24,195 -24,6 +24,192 @@@
  #include "segment.h"
  #include <trace/events/f2fs.h>
 =20
 +static void f2fs_read_end_io(struct bio *bio, int err)
 +{
- 	const int uptodate =3D test_bit(BIO_UPTODATE, &bio->bi_flags);
- 	struct bio_vec *bvec =3D bio->bi_io_vec + bio->bi_vcnt - 1;
++	struct bio_vec *bvec;
++	int i;
 +
- 	do {
++	bio_for_each_segment_all(bvec, bio, i) {
 +		struct page *page =3D bvec->bv_page;
 +
- 		if (--bvec >=3D bio->bi_io_vec)
- 			prefetchw(&bvec->bv_page->flags);
-=20
- 		if (unlikely(!uptodate)) {
++		if (unlikely(err)) {
 +			ClearPageUptodate(page);
 +			SetPageError(page);
 +		} else {
 +			SetPageUptodate(page);
 +		}
 +		unlock_page(page);
- 	} while (bvec >=3D bio->bi_io_vec);
++	}
 +
 +	bio_put(bio);
 +}
 +
 +static void f2fs_write_end_io(struct bio *bio, int err)
 +{
- 	const int uptodate =3D test_bit(BIO_UPTODATE, &bio->bi_flags);
- 	struct bio_vec *bvec =3D bio->bi_io_vec + bio->bi_vcnt - 1;
- 	struct f2fs_sb_info *sbi =3D F2FS_SB(bvec->bv_page->mapping->host->i_sb);
++	struct bio_vec *bvec;
++	struct f2fs_sb_info *sbi =3D NULL;
++	int i;
 +
- 	do {
++	bio_for_each_segment_all(bvec, bio, i) {
 +		struct page *page =3D bvec->bv_page;
 +
- 		if (--bvec >=3D bio->bi_io_vec)
- 			prefetchw(&bvec->bv_page->flags);
++		if (!sbi)
++			sbi =3D F2FS_SB(bvec->bv_page->mapping->host->i_sb);
 +
- 		if (unlikely(!uptodate)) {
++		if (unlikely(err)) {
 +			SetPageError(page);
 +			set_bit(AS_EIO, &page->mapping->flags);
 +			set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
 +			sbi->sb->s_flags |=3D MS_RDONLY;
 +		}
 +		end_page_writeback(page);
 +		dec_page_count(sbi, F2FS_WRITEBACK);
- 	} while (bvec >=3D bio->bi_io_vec);
++	}
 +
 +	if (bio->bi_private)
 +		complete(bio->bi_private);
 +
 +	if (!get_pages(sbi, F2FS_WRITEBACK) &&
 +			!list_empty(&sbi->cp_wait.task_list))
 +		wake_up(&sbi->cp_wait);
 +
 +	bio_put(bio);
 +}
 +
 +/*
 + * Low-level block read/write IO operations.
 + */
 +static struct bio *__bio_alloc(struct f2fs_sb_info *sbi, block_t blk_addr,
 +				int npages, bool is_read)
 +{
 +	struct bio *bio;
 +
 +	/* No failure on bio allocation */
 +	bio =3D bio_alloc(GFP_NOIO, npages);
 +
 +	bio->bi_bdev =3D sbi->sb->s_bdev;
- 	bio->bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
++	bio->bi_iter.bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
 +	bio->bi_end_io =3D is_read ? f2fs_read_end_io : f2fs_write_end_io;
 +
 +	return bio;
 +}
 +
 +static void __submit_merged_bio(struct f2fs_bio_info *io)
 +{
 +	struct f2fs_io_info *fio =3D &io->fio;
 +	int rw;
 +
 +	if (!io->bio)
 +		return;
 +
 +	rw =3D fio->rw;
 +
 +	if (is_read_io(rw)) {
 +		trace_f2fs_submit_read_bio(io->sbi->sb, rw,
 +						fio->type, io->bio);
 +		submit_bio(rw, io->bio);
 +	} else {
 +		trace_f2fs_submit_write_bio(io->sbi->sb, rw,
 +						fio->type, io->bio);
 +		/*
 +		 * META_FLUSH is only from the checkpoint procedure, and we
 +		 * should wait this metadata bio for FS consistency.
 +		 */
 +		if (fio->type =3D=3D META_FLUSH) {
 +			DECLARE_COMPLETION_ONSTACK(wait);
 +			io->bio->bi_private =3D &wait;
 +			submit_bio(rw, io->bio);
 +			wait_for_completion(&wait);
 +		} else {
 +			submit_bio(rw, io->bio);
 +		}
 +	}
 +
 +	io->bio =3D NULL;
 +}
 +
 +void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
 +				enum page_type type, int rw)
 +{
 +	enum page_type btype =3D PAGE_TYPE_OF_BIO(type);
 +	struct f2fs_bio_info *io;
 +
 +	io =3D is_read_io(rw) ? &sbi->read_io : &sbi->write_io[btype];
 +
 +	mutex_lock(&io->io_mutex);
 +
 +	/* change META to META_FLUSH in the checkpoint procedure */
 +	if (type >=3D META_FLUSH) {
 +		io->fio.type =3D META_FLUSH;
 +		io->fio.rw =3D WRITE_FLUSH_FUA;
 +	}
 +	__submit_merged_bio(io);
 +	mutex_unlock(&io->io_mutex);
 +}
 +
 +/*
 + * Fill the locked page with data located in the block address.
 + * Return unlocked page.
 + */
 +int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
 +					block_t blk_addr, int rw)
 +{
 +	struct bio *bio;
 +
 +	trace_f2fs_submit_page_bio(page, blk_addr, rw);
 +
 +	/* Allocate a new bio */
 +	bio =3D __bio_alloc(sbi, blk_addr, 1, is_read_io(rw));
 +
 +	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
 +		bio_put(bio);
 +		f2fs_put_page(page, 1);
 +		return -EFAULT;
 +	}
 +
 +	submit_bio(rw, bio);
 +	return 0;
 +}
 +
 +void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
 +			block_t blk_addr, struct f2fs_io_info *fio)
 +{
 +	enum page_type btype =3D PAGE_TYPE_OF_BIO(fio->type);
 +	struct f2fs_bio_info *io;
 +	bool is_read =3D is_read_io(fio->rw);
 +
 +	io =3D is_read ? &sbi->read_io : &sbi->write_io[btype];
 +
 +	verify_block_addr(sbi, blk_addr);
 +
 +	mutex_lock(&io->io_mutex);
 +
 +	if (!is_read)
 +		inc_page_count(sbi, F2FS_WRITEBACK);
 +
 +	if (io->bio && (io->last_block_in_bio !=3D blk_addr - 1 ||
 +						io->fio.rw !=3D fio->rw))
 +		__submit_merged_bio(io);
 +alloc_new:
 +	if (io->bio =3D=3D NULL) {
 +		int bio_blocks =3D MAX_BIO_BLOCKS(max_hw_blocks(sbi));
 +
 +		io->bio =3D __bio_alloc(sbi, blk_addr, bio_blocks, is_read);
 +		io->fio =3D *fio;
 +	}
 +
 +	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <
 +							PAGE_CACHE_SIZE) {
 +		__submit_merged_bio(io);
 +		goto alloc_new;
 +	}
 +
 +	io->last_block_in_bio =3D blk_addr;
 +
 +	mutex_unlock(&io->io_mutex);
 +	trace_f2fs_submit_page_mbio(page, fio->rw, fio->type, blk_addr);
 +}
 +
  /*
   * Lock ordering for the change of data block address:
   * ->data_page

--Signature=_Mon__6_Jan_2014_17_03_34_+1100__yvG2ER.OuJQI5Gi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSykc6AAoJEMDTa8Ir7ZwVLVEP/2EiqPTCGOyLxrgdicNvnVgX
h1BM0i6rpJlmxYdydT40k8epOCP6crVIo75KSaVusZGpRLvn2gOwRnwmpOFPqFON
b8gV75cwAmvfZQJ/gABVSP/KZM4ioz1pYD+YUs0Yx8oXzcPccJ3ZJ3ljLTUBvVh4
QZ7lUIz+4W89IZgyPOcCEVIrMWnKPGh7TvO4vHAP/ozLxAhHPSawNCp6fEkv/OUM
hjDHpe/sXmWgCdUhTouGYHjdYUw3jo1jQilg+WpJYNZmFT2cuq3vUPMKOPK/mYwH
QEQo7y285cm0VhWBVw9plf03PsyPYNiLM9q0A4REMp7OkijPnyuOgHyR0JQi28TX
QZ08JtlBKMGvSEoZgjErtf4oqb2X2F+MH/hHg8Z6L/YoGsbOOOCV+1vT7WtWYnH7
XNY+a199L1rS+ovu2HsJp+ybUCO+QE5R6HIGXBJRTnqcnLoeDK6XlNv99rvjcIoB
DNLeYExHL+BaEd5MQOa5yrZHEG9PH21zkZYLf/3/eMkrLYHAZowVqLBej3Iy2qC5
tfSGWxpMXULN42RKgH5+V43WJ/VxPFPQ295qSKhNdvVPkWz57dRTfnA7It/vFwlr
Ow3RPoPAO5FausEJMTSNHUPxluBGHBzMTuOy7tI9AkPuSWHFywppy/nGgS4dI6S9
MxCKaat4tO1600QmTWLG
=4Suf
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jan_2014_17_03_34_+1100__yvG2ER.OuJQI5Gi--
