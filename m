Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab3LLC5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 21:57:25 -0500
Received: from ozlabs.org ([203.10.76.45]:48096 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab3LLC5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 21:57:23 -0500
Date: Thu, 12 Dec 2013 13:57:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: linux-next: manual merge of the block tree with the f2fs tree
Message-Id: <20131212135716.bbc72d7f86265da1e4041c7e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Dec_2013_13_57_16_+1100_Dr55fpMVNjDfoftf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Dec_2013_13_57_16_+1100_Dr55fpMVNjDfoftf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/f2fs/data.c between commit 8758e549e105 ("f2fs: add unlikely() macro
for compiler more aggressively") from the f2fs tree and commit
2c30c71bd653 ("block: Convert various code to bio_for_each_segment()")
from the block tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/f2fs/data.c
index 15956fa584de,a2c8de8ba6ce..000000000000
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@@ -25,203 -25,6 +25,199 @@@
  #include <trace/events/f2fs.h>
 =20
  /*
 + * Low-level block read/write IO operations.
 + */
 +static struct bio *__bio_alloc(struct block_device *bdev, int npages)
 +{
 +	struct bio *bio;
 +
 +	/* No failure on bio allocation */
 +	bio =3D bio_alloc(GFP_NOIO, npages);
 +	bio->bi_bdev =3D bdev;
 +	bio->bi_private =3D NULL;
 +	return bio;
 +}
 +
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
++	struct f2fs_sb_info *sbi =3D NULL;
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
++		if (!sbi)
++			sbi =3D F2FS_SB(bvec->bv_page->mapping->host->i_sb);
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
 +static void __submit_merged_bio(struct f2fs_bio_info *io)
 +{
 +	struct f2fs_io_info *fio =3D &io->fio;
 +	int rw;
 +
 +	if (!io->bio)
 +		return;
 +
 +	rw =3D fio->rw | fio->rw_flag;
 +
 +	if (is_read_io(rw)) {
 +		trace_f2fs_submit_read_bio(io->sbi->sb, rw, fio->type, io->bio);
 +		submit_bio(rw, io->bio);
 +		io->bio =3D NULL;
 +		return;
 +	}
 +	trace_f2fs_submit_write_bio(io->sbi->sb, rw, fio->type, io->bio);
 +
 +	/*
 +	 * META_FLUSH is only from the checkpoint procedure, and we should wait
 +	 * this metadata bio for FS consistency.
 +	 */
 +	if (fio->type =3D=3D META_FLUSH) {
 +		DECLARE_COMPLETION_ONSTACK(wait);
 +		io->bio->bi_private =3D &wait;
 +		submit_bio(rw, io->bio);
 +		wait_for_completion(&wait);
 +	} else {
 +		submit_bio(rw, io->bio);
 +	}
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
 +	struct block_device *bdev =3D sbi->sb->s_bdev;
 +	struct bio *bio;
 +
 +	trace_f2fs_submit_page_bio(page, blk_addr, rw);
 +
 +	/* Allocate a new bio */
 +	bio =3D __bio_alloc(bdev, 1);
 +
 +	/* Initialize the bio */
- 	bio->bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
++	bio->bi_iter.bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
 +	bio->bi_end_io =3D is_read_io(rw) ? f2fs_read_end_io : f2fs_write_end_io;
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
 +	struct block_device *bdev =3D sbi->sb->s_bdev;
 +	struct f2fs_bio_info *io;
 +	int bio_blocks;
 +
 +	io =3D is_read_io(fio->rw) ? &sbi->read_io : &sbi->write_io[btype];
 +
 +	verify_block_addr(sbi, blk_addr);
 +
 +	mutex_lock(&io->io_mutex);
 +
 +	if (!is_read_io(fio->rw))
 +		inc_page_count(sbi, F2FS_WRITEBACK);
 +
 +	if (io->bio && (io->last_block_in_bio !=3D blk_addr - 1 ||
 +						io->fio.rw !=3D fio->rw))
 +		__submit_merged_bio(io);
 +alloc_new:
 +	if (io->bio =3D=3D NULL) {
 +		bio_blocks =3D MAX_BIO_BLOCKS(max_hw_blocks(sbi));
 +		io->bio =3D __bio_alloc(bdev, bio_blocks);
- 		io->bio->bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
++		io->bio->bi_iter.bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
 +		io->bio->bi_end_io =3D is_read_io(fio->rw) ? f2fs_read_end_io :
 +							f2fs_write_end_io;
 +		io->fio =3D *fio;
 +		/*
 +		 * The end_io will be assigned at the sumbission phase.
 +		 * Until then, let bio_add_page() merge consecutive IOs as much
 +		 * as possible.
 +		 */
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
 +/*
   * Lock ordering for the change of data block address:
   * ->data_page
   *  ->node_page

--Signature=_Thu__12_Dec_2013_13_57_16_+1100_Dr55fpMVNjDfoftf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSqSYRAAoJEMDTa8Ir7ZwVVgMP/1uUiVhhxcxy20a395i778Wm
eC/FrWT/pVsjCSHSw7uDWZIQ/L18fCtMLMaiOO6whLa1HXYXh83ySGsPyEtSCJRB
CG2DzgW+Xc8cVsPW8NmQ6bplFLo9rJYsom1YaNeqkfEUH5kFnnnHkRMSBc1gqfi7
4oZMlSaNPEo8RiZZtUOipOOqgVff641v4HABevWaRuPhGw75sCNOCZa5GukZlUiZ
3OX8DGONwwYRbEFdjwrK3ZOtdkr4AI//vhggpLMedUYH6vYy+Sp7RQqKVyATdqGN
07dZd1fCOOnit7bqYzjnv4VyRKfrpr5OpzGMpU07ZdkVz/UI4SLWFTPf1xpcNjp+
DWZhyruJ5m7Fsq0uXBTexZ0sptq7WYwqmTC35tOwFuBfWPoH3AHRVwazptRhpxi+
ddeWz1dWJ5WoAyej8mk2KUUYz76AgJ1nbN0uGWwNns4hoEPpUm3lG0AirX+Kn9d0
Ntyx5iVGccZ0sAod6RocM/Bzkd+uZHksEff65FPU1zguzzcDZam9ZyVyLonAuVrg
sYs8XRlJH0GhkRfzmSqQj9dKI6PjWkFZtP7bWvaGV49apEanQFioTSw33H2oThne
0vGq+mxt50y/dSSAQ5IIANTaRkbNvQ9t8OdmhXBjtGLEZ7qYDgpy3ZH8gpyoYRf/
4AAtzOA9ja0c6kcPbSHK
=NCt9
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Dec_2013_13_57_16_+1100_Dr55fpMVNjDfoftf--
