Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab3LBEEg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 23:04:36 -0500
Received: from ozlabs.org ([203.10.76.45]:40421 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab3LBEEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 23:04:33 -0500
Date: Mon, 2 Dec 2013 15:04:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: linux-next: manual merge of the block tree with the f2fs tree
Message-Id: <20131202150422.f3c9db7e38f91f92d67c3149@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Dec_2013_15_04_22_+1100_T+rnNf2MV6tew7Im"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Dec_2013_15_04_22_+1100_T+rnNf2MV6tew7Im
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got conflicts in
fs/f2fs/data.c and fs/f2fs/segment.c between commits 0626804cd9a6 ("f2fs:
remove the own bi_private allocation") and 899d7625d85a ("f2fs: refactor
bio-related operations") from the f2fs tree and commits 2c30c71bd653
("block: Convert various code to bio_for_each_segment()") and  ("block:
Abstract out bvec iterator") from the block tree.

I fixed it up (hopefully - see below - the handling of sbi in
f2fs_end_io_write is not the best) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/f2fs/data.c
index 53e3bbbba7ed,a2c8de8ba6ce..b62a99cf6561
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@@ -25,205 -25,6 +25,201 @@@
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
- 		if (uptodate) {
++		if (!err) {
 +			SetPageUptodate(page);
 +		} else {
 +			ClearPageUptodate(page);
 +			SetPageError(page);
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
- 		if (!uptodate) {
++		if (!sbi)
++			sbi =3D F2FS_SB(bvec->bv_page->mapping->host->i_sb);
++		if (err) {
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
 +static void __submit_merged_bio(struct f2fs_sb_info *sbi,
 +				struct f2fs_bio_info *io,
 +				enum page_type type, bool sync, int rw)
 +{
 +	enum page_type btype =3D PAGE_TYPE_OF_BIO(type);
 +
 +	if (!io->bio)
 +		return;
 +
 +	if (btype =3D=3D META)
 +		rw |=3D REQ_META;
 +
 +	if (is_read_io(rw)) {
 +		if (sync)
 +			rw |=3D READ_SYNC;
 +		submit_bio(rw, io->bio);
 +		trace_f2fs_submit_read_bio(sbi->sb, rw, type, io->bio);
 +		io->bio =3D NULL;
 +		return;
 +	}
 +
 +	if (sync)
 +		rw |=3D WRITE_SYNC;
 +	if (type >=3D META_FLUSH)
 +		rw |=3D WRITE_FLUSH_FUA;
 +
 +	/*
 +	 * META_FLUSH is only from the checkpoint procedure, and we should wait
 +	 * this metadata bio for FS consistency.
 +	 */
 +	if (type =3D=3D META_FLUSH) {
 +		DECLARE_COMPLETION_ONSTACK(wait);
 +		io->bio->bi_private =3D &wait;
 +		submit_bio(rw, io->bio);
 +		wait_for_completion(&wait);
 +	} else {
 +		submit_bio(rw, io->bio);
 +	}
 +	trace_f2fs_submit_write_bio(sbi->sb, rw, btype, io->bio);
 +	io->bio =3D NULL;
 +}
 +
 +void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
 +				enum page_type type, bool sync, int rw)
 +{
 +	enum page_type btype =3D PAGE_TYPE_OF_BIO(type);
 +	struct f2fs_bio_info *io;
 +
 +	io =3D is_read_io(rw) ? &sbi->read_io : &sbi->write_io[btype];
 +
 +	mutex_lock(&io->io_mutex);
 +	__submit_merged_bio(sbi, io, type, sync, rw);
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
 +			block_t blk_addr, enum page_type type, int rw)
 +{
 +	enum page_type btype =3D PAGE_TYPE_OF_BIO(type);
 +	struct block_device *bdev =3D sbi->sb->s_bdev;
 +	struct f2fs_bio_info *io;
 +	int bio_blocks;
 +
 +	io =3D is_read_io(rw) ? &sbi->read_io : &sbi->write_io[btype];
 +
 +	verify_block_addr(sbi, blk_addr);
 +
 +	mutex_lock(&io->io_mutex);
 +
 +	if (!is_read_io(rw))
 +		inc_page_count(sbi, F2FS_WRITEBACK);
 +
 +	if (io->bio && io->last_block_in_bio !=3D blk_addr - 1)
 +		__submit_merged_bio(sbi, io, type, true, rw);
 +alloc_new:
 +	if (io->bio =3D=3D NULL) {
 +		bio_blocks =3D MAX_BIO_BLOCKS(max_hw_blocks(sbi));
 +		io->bio =3D __bio_alloc(bdev, bio_blocks);
- 		io->bio->bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
++		io->bio->bi_iter.bi_sector =3D SECTOR_FROM_BLOCK(sbi, blk_addr);
 +		io->bio->bi_end_io =3D is_read_io(rw) ? f2fs_read_end_io :
 +							f2fs_write_end_io;
 +		/*
 +		 * The end_io will be assigned at the sumbission phase.
 +		 * Until then, let bio_add_page() merge consecutive IOs as much
 +		 * as possible.
 +		 */
 +	}
 +
 +	if (bio_add_page(io->bio, page, PAGE_CACHE_SIZE, 0) <
 +							PAGE_CACHE_SIZE) {
 +		__submit_merged_bio(sbi, io, type, true, rw);
 +		io->bio =3D NULL;
 +		goto alloc_new;
 +	}
 +
 +	io->last_block_in_bio =3D blk_addr;
 +
 +	mutex_unlock(&io->io_mutex);
 +	trace_f2fs_submit_page_mbio(page, rw, type, blk_addr);
 +}
 +
 +/*
   * Lock ordering for the change of data block address:
   * ->data_page
   *  ->node_page

--Signature=_Mon__2_Dec_2013_15_04_22_+1100_T+rnNf2MV6tew7Im
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSnAbKAAoJEMDTa8Ir7ZwVSE0P+gIkrIRJ9Ny6wSpx2MlNeu7y
Br5iwP4MF9RDf9rH0odlrlSR1x2NWYaAsq75QIF4aX5+S1MaELs8kW71N9g9styK
wCgh4jmenzGuUoUtnbsiAiP1oiCljY9jyDLhW5+xqWWx0y4IisibvDsrS4vXuiHJ
R8gw8ea3k9otBMMA/KNjNh7nGx6Avz7xz5CeEgH500J9UR8ClDhQN4TtEeMFhgbK
lzElsNIAJedThzkRZm/V046q7MxZ1uJw5boYJIc2ghq40puN/HBk8zSSlNQXbTdc
DPn4F81T9Qnm58Telew5wFEBsApaiQsa+7umTa4utMgOqRWe6FeQkQNFZbrt9uLK
Nhabienz7OfxlQ4dwLF6mn9uyCrJZKHb/486xX+Jvmgo6aWvnDkvAJGT96AHFCml
KFaA05Jb7LP9bVQ1H33yUUFC5nccTcJauy6SrDyR63wZd3oYHojpy2UI9cEcqbt5
OOEXS638rXCkNB3xtQXVnE2+55IGK8sF0ay54LR5A2RQMzza3XEZMXwzeQu5zf8c
OMhwqeX8DvOEiRvnhuN2fQfOZCDXK/cmmDX3VINbwSay2s7Ku6aBfkKc5IXB4x/E
ybzpxZEzgIM3fgbJ1JPLmhTnqsl9ngbNw6XAEznLQb1DPgLbJltKzCLg9xRxR3rr
fWGpoB1pMXIMoRbl92jO
=M0bA
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Dec_2013_15_04_22_+1100_T+rnNf2MV6tew7Im--
