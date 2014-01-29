Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbaA2AFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 19:05:47 -0500
Received: from ozlabs.org ([203.10.76.45]:40329 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789AbaA2AFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 19:05:45 -0500
Date: Wed, 29 Jan 2014 11:05:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Core block IO changes for 3.14
Message-Id: <20140129110536.00ce3c9e580f747fd0f1d0e6@canb.auug.org.au>
In-Reply-To: <20140128225229.GH25989@kernel.dk>
References: <20140128224336.GF25989@kernel.dk>
	<20140128225229.GH25989@kernel.dk>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Jan_2014_11_05_36_+1100_YfswOHsVeQu3_Zuv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Jan_2014_11_05_36_+1100_YfswOHsVeQu3_Zuv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 28 Jan 2014 15:52:29 -0700 Jens Axboe <axboe@kernel.dk> wrote:
>
> On Tue, Jan 28 2014, Jens Axboe wrote:
> >=20
> > This is the pull request for the core block IO changes for 3.14. The
> > major piece in here is the immutable bio_ve series from Kent, the rest
> > is fairly minor. It was supposed to go in last round, but various issues
> > pushed it to this release instead. The pull request contains:
> >=20
> >=20
> > - Various smaller blk-mq fixes from different folks. Nothing major here,
> >   just minor fixes and cleanups.
> >=20
> > - Fix for a memory leak in the error path in the block ioctl code from
> >   Christian Engelmayer.
> >=20
> > - Header export fix from CaiZhiyong.
> >=20
> > - Finally the immutable biovec changes from Kent Overstreet. This
> >   enables some nice future work on making arbitrarily sized bios
> >   possible, and splitting more efficient. Related fixes to immutable
> >   bio_vecs:
> >=20
> >         - dm-cache immutable fixup from Mike Snitzer.
> >         - btrfs immutable fixup from Muthu Kumar.
> >=20
> > - bio-integrity fix from Nic Bellinger, which is also going to stable.
> >=20
> >=20
> > Please pull! There will be a bit of merge work for you, but it should be
> > fairly straight forward. It's mostly related to changin:
> >=20
> > bio->bi_sector  -> bio->bi_iter.bi_sector
> > bio->bi_size    -> bio->bi_iter.bi_size
> >=20
> >=20
> > git://git.kernel.dk/linux-block.git for-3.14/core
>=20
> BTW, let me know if you want me to merge this. The above has been in
> for-next since forever, and Stephen has carried a fix or two for new
> merges.

The worst bit is the conflicts with the f2fs changes that have already
been merged.  My current merge commit looks like this (though I don't
remember getting any comments on my fixes):

da3f6c793c656a022453df8bf458d13e5a353beb
diff --cc drivers/md/dm-thin.c
index 726228b33a01,357eb272dbd9..faaf944597ab
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@@ -1258,8 -1262,8 +1264,8 @@@ static void process_bio_read_only(struc
  	r =3D dm_thin_find_block(tc->td, block, 1, &lookup_result);
  	switch (r) {
  	case 0:
- 		if (lookup_result.shared && (rw =3D=3D WRITE) && bio->bi_size)
+ 		if (lookup_result.shared && (rw =3D=3D WRITE) && bio->bi_iter.bi_size)
 -			bio_io_error(bio);
 +			handle_unserviceable_bio(tc->pool, bio);
  		else {
  			inc_all_io_entry(tc->pool, bio);
  			remap_and_issue(tc, bio, lookup_result.block);
diff --cc drivers/md/raid10.c
index 8d39d63281b9,6d43d88657aa..33fc408e5eac
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@@ -1319,8 -1256,8 +1256,8 @@@ read_again
  			/* Could not read all from this device, so we will
  			 * need another r10_bio.
  			 */
 -			sectors_handled =3D (r10_bio->sectors + max_sectors
 +			sectors_handled =3D (r10_bio->sector + max_sectors
- 					   - bio->bi_sector);
+ 					   - bio->bi_iter.bi_sector);
  			r10_bio->sectors =3D max_sectors;
  			spin_lock_irq(&conf->device_lock);
  			if (bio->bi_phys_segments =3D=3D 0)
diff --cc fs/btrfs/extent_io.c
index fbe501d3bd01,bcb6f1b780d6..85bbd01f1271
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@@ -2375,12 -2332,15 +2375,13 @@@ int end_extent_writepage(struct page *p
   */
  static void end_bio_extent_writepage(struct bio *bio, int err)
  {
- 	struct bio_vec *bvec =3D bio->bi_io_vec + bio->bi_vcnt - 1;
+ 	struct bio_vec *bvec;
 -	struct extent_io_tree *tree;
  	u64 start;
  	u64 end;
+ 	int i;
 =20
- 	do {
+ 	bio_for_each_segment_all(bvec, bio, i) {
  		struct page *page =3D bvec->bv_page;
 -		tree =3D &BTRFS_I(page->mapping->host)->io_tree;
 =20
  		/* We always issue full-page reads, but if some block
  		 * in a page fails to read, blk_update_request() will
diff --cc fs/btrfs/inode.c
index 1ef056837755,7ab0e94ad492..f0422a5efa78
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@@ -7016,10 -6891,11 +7013,11 @@@ static void btrfs_end_dio_bio(struct bi
  	struct btrfs_dio_private *dip =3D bio->bi_private;
 =20
  	if (err) {
 -		printk(KERN_ERR "btrfs direct IO failed ino %llu rw %lu "
 -		      "sector %#Lx len %u err no %d\n",
 +		btrfs_err(BTRFS_I(dip->inode)->root->fs_info,
 +			  "direct IO failed ino %llu rw %lu sector %#Lx len %u err no %d",
  		      btrfs_ino(dip->inode), bio->bi_rw,
- 		      (unsigned long long)bio->bi_sector, bio->bi_size, err);
+ 		      (unsigned long long)bio->bi_iter.bi_sector,
+ 		      bio->bi_iter.bi_size, err);
  		dip->errors =3D 1;
 =20
  		/*
diff --cc fs/f2fs/data.c
index 0ae558723506,a2c8de8ba6ce..25d675e6a138
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
 +		io->fio.rw =3D WRITE_FLUSH_FUA | REQ_META | REQ_PRIO;
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
diff --cc include/trace/events/f2fs.h
index 3b9f28dfc849,bd3ee4fbe7a7..67f38faac589
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@@ -627,16 -614,16 +627,16 @@@ DECLARE_EVENT_CLASS(f2fs__submit_bio
 =20
  	TP_fast_assign(
  		__entry->dev		=3D sb->s_dev;
 -		__entry->btype		=3D btype;
 -		__entry->sync		=3D sync;
 +		__entry->rw		=3D rw;
 +		__entry->type		=3D type;
- 		__entry->sector		=3D bio->bi_sector;
- 		__entry->size		=3D bio->bi_size;
+ 		__entry->sector		=3D bio->bi_iter.bi_sector;
+ 		__entry->size		=3D bio->bi_iter.bi_size;
  	),
 =20
 -	TP_printk("dev =3D (%d,%d), type =3D %s, io =3D %s, sector =3D %lld, siz=
e =3D %u",
 +	TP_printk("dev =3D (%d,%d), %s%s, %s, sector =3D %lld, size =3D %u",
  		show_dev(__entry),
 -		show_block_type(__entry->btype),
 -		__entry->sync ? "sync" : "no sync",
 +		show_bio_type(__entry->rw),
 +		show_block_type(__entry->type),
  		(unsigned long long)__entry->sector,
  		__entry->size)
  );

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

--Signature=_Wed__29_Jan_2014_11_05_36_+1100_YfswOHsVeQu3_Zuv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6EXVAAoJEMDTa8Ir7ZwVip8P/j92zt3Wu3/L+02/pfOrt+Fs
MdvTnMpB85osGsVli/ataPTOhT2lQamCvXmcSkziJqgwbcNdK6Gwlflg1OmoP5MS
fZ+Q4ZV1RbK9MU1vYy1vB0+YD3ZEUEJa077NFecDgIkRG6EFW0ckbhRc3OSlYzag
eUGTI47XO5giYKVTMtYENZPAjLDHHWYMEIVSklR6ei3+Ff+J1wG9at/cDpR912WS
rUkUVrkLng5Sc4mky5pECWqVeMbktGnzsmXFdnE08E0gCiOYI2LA6RuySXmV6w1y
FbY1LjHhGGJRLGWj6xlko6WanumYIw583L1WEdNZZQeVwK8gexONlOl2JY22KFSk
+y4pjMX2E9UHNQI3fDCd3xQUwzDb+JyU9Dpkq3N6RSF4Sdl/6juHvyoTXUj02FcF
tXQB6BCUmbYtV8sOkLxt3+kAXA6YFWF0qJou62oSSpcqd83Y43eXd+PTdYa77YpZ
yh1o8T2fulyrQidoXAIiPZg8qpFJl99Vv0VpXVodFK07vXtVK7x7vzlOfxKssnnn
1WDVJ0T1Zb4yog7FZOCHr86kOKwwYm3bNQeu0UwXWgVrChU9fkqebDIuI855nSb3
CnMD/80Gq6KT8/AUesDNEBcQbblg46bvxNPEzviN3yp99dWAtYft2Z6d/PTOV8DG
vXlWqmxZ/SJWYyOxDBYM
=iXT9
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Jan_2014_11_05_36_+1100_YfswOHsVeQu3_Zuv--
