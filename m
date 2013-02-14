Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481Ab3BNCLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 21:11:24 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:61033 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760479Ab3BNCLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 21:11:21 -0500
Date: Wed, 13 Feb 2013 18:10:46 -0800
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Zach Brown <zab@zabbo.net>, Jens Axboe <axboe@kernel.dk>,
        Andi Kleen <ak@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH][WIP] dio rewrite
Message-ID: <20130214021046.GA4474@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last posting: http://marc.info/?l=linux-fsdevel&m=136063048002755&w=2

Got it working and ran some benchmarks. On a high end SSD, doing 4k
random reads with fio I got around a 30% increase in throughput.

(That was without the aio changes I recently did. With those, throughput
was aproximately doubled).

The decrease in compiled binary size is even more dramatic than the
reduction in LOC:

3.8-rc7
   text    data     bss     dec     hex filename
  11609      16       8   11633    2d71 fs/direct-io.o

My version:
   text    data     bss     dec     hex filename
   3545      16       0    3561     de9 fs/direct-io.o

It's only been lightly tested - I haven't run xfstests yet - but there
shouldn't be anything broken excluding btrfs.

There's a few more performance optimizations I may do, but aside from
the btrfs issues I think it's essentially done.

Due to the sheer number of hairy corner cases in the dio code, I'd
really like to get as much review as possible. The new code should be
vastly easier to review and understand, I think.

Git repo:
http://evilpiepirate.org/git/linux-bcache.git block_stuff

---
 fs/direct-io.c | 1323 +++++++++++++++-----------------------------------------
 1 file changed, 357 insertions(+), 966 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 8e838b1..1fb9fb4 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -8,7 +8,7 @@
  * 04Jul2002	Andrew Morton
  *		Initial version
  * 11Sep2002	janetinc@us.ibm.com
- * 		added readv/writev support.
+ *		added readv/writev support.
  * 29Oct2002	Andrew Morton
  *		rewrote bio_add_page() support.
  * 30Oct2002	pbadari@us.ibm.com
@@ -38,183 +38,37 @@
 #include <linux/atomic.h>
 #include <linux/prefetch.h>
 
-/*
- * How many user pages to map in one call to get_user_pages().  This determines
- * the size of a structure in the slab cache
- */
-#define DIO_PAGES	64
-
-/*
- * This code generally works in units of "dio_blocks".  A dio_block is
- * somewhere between the hard sector size and the filesystem block size.  it
- * is determined on a per-invocation basis.   When talking to the filesystem
- * we need to convert dio_blocks to fs_blocks by scaling the dio_block quantity
- * down by dio->blkfactor.  Similarly, fs-blocksize quantities are converted
- * to bio_block quantities by shifting left by blkfactor.
- *
- * If blkfactor is zero then the user's request was aligned to the filesystem's
- * blocksize.
- */
-
 /* dio_state only used in the submission path */
-
 struct dio_submit {
-	struct bio *bio;		/* bio under assembly */
-	unsigned blkbits;		/* doesn't change */
-	unsigned blkfactor;		/* When we're using an alignment which
-					   is finer than the filesystem's soft
-					   blocksize, this specifies how much
-					   finer.  blkfactor=2 means 1/4-block
-					   alignment.  Does not change */
-	unsigned start_zero_done;	/* flag: sub-blocksize zeroing has
-					   been performed at the start of a
-					   write */
-	int pages_in_io;		/* approximate total IO pages */
-	size_t	size;			/* total request size (doesn't change)*/
-	sector_t block_in_file;		/* Current offset into the underlying
-					   file in dio_block units. */
-	unsigned blocks_available;	/* At block_in_file.  changes */
-	int reap_counter;		/* rate limit reaping */
-	sector_t final_block_in_request;/* doesn't change */
-	unsigned first_block_in_page;	/* doesn't change, Used only once */
-	int boundary;			/* prev block is at a boundary */
-	get_block_t *get_block;		/* block mapping function */
-	dio_submit_t *submit_io;	/* IO submition function */
-
-	loff_t logical_offset_in_bio;	/* current first logical block in bio */
-	sector_t final_block_in_bio;	/* current final block in bio + 1 */
-	sector_t next_block_for_io;	/* next block to be put under IO,
-					   in dio_blocks units */
-
-	/*
-	 * Deferred addition of a page to the dio.  These variables are
-	 * private to dio_send_cur_page(), submit_page_section() and
-	 * dio_bio_add_page().
-	 */
-	struct page *cur_page;		/* The page */
-	unsigned cur_page_offset;	/* Offset into it, in bytes */
-	unsigned cur_page_len;		/* Nr of bytes at cur_page_offset */
-	sector_t cur_page_block;	/* Where it starts */
-	loff_t cur_page_fs_offset;	/* Offset in file */
-
-	/*
-	 * Page fetching state. These variables belong to dio_refill_pages().
-	 */
-	int curr_page;			/* changes */
-	int total_pages;		/* doesn't change */
-	unsigned long curr_user_address;/* changes */
-
-	/*
-	 * Page queue.  These variables belong to dio_refill_pages() and
-	 * dio_get_page().
-	 */
-	unsigned head;			/* next page to process */
-	unsigned tail;			/* last valid page + 1 */
+	get_block_t	*get_block;	/* block mapping function */
+	dio_submit_t	*submit_io;	/* IO submition function */
+	unsigned	i_blkbits;
 };
 
 /* dio_state communicated between submission path and end_io */
 struct dio {
-	int flags;			/* doesn't change */
-	int rw;
-	struct inode *inode;
-	loff_t i_size;			/* i_size when submitted */
-	dio_iodone_t *end_io;		/* IO completion function */
+	int		flags;		/* doesn't change */
+	int		rw;
+	struct inode	*inode;
+	loff_t		i_size;		/* i_size when submitted */
 
-	void *private;			/* copy from map_bh.b_private */
+	dio_iodone_t	*end_io;	/* IO completion function */
+	void		*private;	/* copy from map_bh.b_private */
 
 	/* BIO completion state */
-	spinlock_t bio_lock;		/* protects BIO fields below */
-	int page_errors;		/* errno from get_user_pages() */
-	int is_async;			/* is IO async ? */
-	int io_error;			/* IO error in completion path */
-	unsigned long refcount;		/* direct_io_worker() and bios */
-	struct bio *bio_list;		/* singly linked via bi_private */
+	int		page_error;	/* errno from get_user_pages() */
+	int		io_error;	/* IO error in completion path */
+	atomic_long_t	refcount;	/* direct_io_worker() and bios */
 	struct task_struct *waiter;	/* waiting task (NULL if none) */
 
 	/* AIO related stuff */
-	struct kiocb *iocb;		/* kiocb */
-	ssize_t result;                 /* IO result */
-
-	/*
-	 * pages[] (and any fields placed after it) are not zeroed out at
-	 * allocation time.  Don't add new fields after pages[] unless you
-	 * wish that they not be zeroed.
-	 */
-	struct page *pages[DIO_PAGES];	/* page buffer */
-} ____cacheline_aligned_in_smp;
+	struct kiocb	*iocb;		/* kiocb */
+	ssize_t		result;		/* IO result */
 
-static struct kmem_cache *dio_cache __read_mostly;
-
-/*
- * How many pages are in the queue?
- */
-static inline unsigned dio_pages_present(struct dio_submit *sdio)
-{
-	return sdio->tail - sdio->head;
-}
-
-/*
- * Go grab and pin some userspace pages.   Typically we'll get 64 at a time.
- */
-static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
-{
-	int ret;
-	int nr_pages;
-
-	nr_pages = min(sdio->total_pages - sdio->curr_page, DIO_PAGES);
-	ret = get_user_pages_fast(
-		sdio->curr_user_address,		/* Where from? */
-		nr_pages,			/* How many pages? */
-		dio->rw == READ,		/* Write to memory? */
-		&dio->pages[0]);		/* Put results here */
-
-	if (ret < 0 && sdio->blocks_available && (dio->rw & WRITE)) {
-		struct page *page = ZERO_PAGE(0);
-		/*
-		 * A memory fault, but the filesystem has some outstanding
-		 * mapped blocks.  We need to use those blocks up to avoid
-		 * leaking stale data in the file.
-		 */
-		if (dio->page_errors == 0)
-			dio->page_errors = ret;
-		page_cache_get(page);
-		dio->pages[0] = page;
-		sdio->head = 0;
-		sdio->tail = 1;
-		ret = 0;
-		goto out;
-	}
-
-	if (ret >= 0) {
-		sdio->curr_user_address += ret * PAGE_SIZE;
-		sdio->curr_page += ret;
-		sdio->head = 0;
-		sdio->tail = ret;
-		ret = 0;
-	}
-out:
-	return ret;	
-}
-
-/*
- * Get another userspace page.  Returns an ERR_PTR on error.  Pages are
- * buffered inside the dio so that we can call get_user_pages() against a
- * decent number of pages, less frequently.  To provide nicer use of the
- * L1 cache.
- */
-static inline struct page *dio_get_page(struct dio *dio,
-		struct dio_submit *sdio)
-{
-	if (dio_pages_present(sdio) == 0) {
-		int ret;
+	struct bio	bio;
+};
 
-		ret = dio_refill_pages(dio, sdio);
-		if (ret)
-			return ERR_PTR(ret);
-		BUG_ON(dio_pages_present(sdio) == 0);
-	}
-	return dio->pages[sdio->head++];
-}
+static struct bio_set *dio_pool __read_mostly;
 
 /**
  * dio_complete() - called when all DIO BIO I/O has been completed
@@ -245,13 +99,15 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is
 	if (dio->result) {
 		transferred = dio->result;
 
+		/* XXX: dio_send_bio() could do this */
+
 		/* Check for short read case */
 		if ((dio->rw == READ) && ((offset + transferred) > dio->i_size))
 			transferred = dio->i_size - offset;
 	}
 
 	if (ret == 0)
-		ret = dio->page_errors;
+		ret = dio->page_error;
 	if (ret == 0)
 		ret = dio->io_error;
 	if (ret == 0)
@@ -266,54 +122,10 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is
 		inode_dio_done(dio->inode);
 	}
 
+	bio_put(&dio->bio);
 	return ret;
 }
 
-static int dio_bio_complete(struct dio *dio, struct bio *bio);
-/*
- * Asynchronous IO callback. 
- */
-static void dio_bio_end_aio(struct bio *bio, int error)
-{
-	struct dio *dio = bio->bi_private;
-	unsigned long remaining;
-	unsigned long flags;
-
-	/* cleanup the bio */
-	dio_bio_complete(dio, bio);
-
-	spin_lock_irqsave(&dio->bio_lock, flags);
-	remaining = --dio->refcount;
-	if (remaining == 1 && dio->waiter)
-		wake_up_process(dio->waiter);
-	spin_unlock_irqrestore(&dio->bio_lock, flags);
-
-	if (remaining == 0) {
-		dio_complete(dio, dio->iocb->ki_pos, 0, true);
-		kmem_cache_free(dio_cache, dio);
-	}
-}
-
-/*
- * The BIO completion handler simply queues the BIO up for the process-context
- * handler.
- *
- * During I/O bi_private points at the dio.  After I/O, bi_private is used to
- * implement a singly-linked list of completed BIOs, at dio->bio_list.
- */
-static void dio_bio_end_io(struct bio *bio, int error)
-{
-	struct dio *dio = bio->bi_private;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dio->bio_lock, flags);
-	bio->bi_private = dio->bio_list;
-	dio->bio_list = bio;
-	if (--dio->refcount == 1 && dio->waiter)
-		wake_up_process(dio->waiter);
-	spin_unlock_irqrestore(&dio->bio_lock, flags);
-}
-
 /**
  * dio_end_io - handle the end io action for the given bio
  * @bio: The direct io bio thats being completed
@@ -326,698 +138,365 @@ static void dio_bio_end_io(struct bio *bio, int error)
 void dio_end_io(struct bio *bio, int error)
 {
 	struct dio *dio = bio->bi_private;
+	unsigned long remaining;
 
-	if (dio->is_async)
-		dio_bio_end_aio(bio, error);
-	else
-		dio_bio_end_io(bio, error);
+	if (error)
+		dio->io_error = -EIO;
+
+	if (dio->rw == READ) {
+		bio_check_pages_dirty(bio);	/* transfers ownership */
+	} else {
+		struct bio_vec *bv;
+		int i;
+
+		bio_for_each_segment_all(bv, bio, i)
+			page_cache_release(bv->bv_page);
+		bio_put(bio);
+	}
+
+	remaining = atomic_long_dec_return(&dio->refcount);
+
+	if (remaining == 1 && dio->waiter)
+		wake_up_process(dio->waiter);
+	if (!remaining)
+		dio_complete(dio, dio->iocb->ki_pos, 0, true);
 }
 EXPORT_SYMBOL_GPL(dio_end_io);
 
-static inline void
-dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
-	      struct block_device *bdev,
-	      sector_t first_sector, int nr_vecs)
+static void dio_wait_completion(struct dio *dio)
 {
-	struct bio *bio;
+	if (atomic_long_read(&dio->refcount) == 1)
+		return;
 
-	/*
-	 * bio_alloc() is guaranteed to return a bio when called with
-	 * __GFP_WAIT and we request a valid number of vectors.
-	 */
-	bio = bio_alloc(GFP_KERNEL, nr_vecs);
+	dio->waiter = current;
 
-	bio->bi_bdev = bdev;
-	bio->bi_iter.bi_sector = first_sector;
-	if (dio->is_async)
-		bio->bi_end_io = dio_bio_end_aio;
-	else
-		bio->bi_end_io = dio_bio_end_io;
+	while (1) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (atomic_long_read(&dio->refcount) == 1)
+			break;
 
-	sdio->bio = bio;
-	sdio->logical_offset_in_bio = sdio->cur_page_fs_offset;
+		io_schedule();
+	}
+	__set_current_state(TASK_RUNNING);
 }
 
 /*
- * In the AIO read case we speculatively dirty the pages before starting IO.
- * During IO completion, any of these pages which happen to have been written
- * back will be redirtied by bio_check_pages_dirty().
+ * For reads we speculatively dirty the pages before starting IO. During IO
+ * completion, any of these pages which happen to have been written back will be
+ * redirtied by bio_check_pages_dirty().
  *
  * bios hold a dio reference between submit_bio and ->end_io.
  */
-static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
+static void dio_bio_submit(struct dio *dio, struct dio_submit *sdio,
+			   struct bio *bio, loff_t offset)
 {
-	struct bio *bio = sdio->bio;
-	unsigned long flags;
-
-	bio->bi_private = dio;
-
-	spin_lock_irqsave(&dio->bio_lock, flags);
-	dio->refcount++;
-	spin_unlock_irqrestore(&dio->bio_lock, flags);
-
-	if (dio->is_async && dio->rw == READ)
-		bio_set_pages_dirty(bio);
+	/*
+	 * Read accounting is performed in submit_bio()
+	 */
+	if (dio->rw & WRITE)
+		task_io_account_write(bio->bi_iter.bi_size);
 
 	if (sdio->submit_io)
 		sdio->submit_io(dio->rw, bio, dio->inode,
-			       sdio->logical_offset_in_bio);
+				offset >> sdio->i_blkbits);
 	else
 		submit_bio(dio->rw, bio);
-
-	sdio->bio = NULL;
-	sdio->boundary = 0;
-	sdio->logical_offset_in_bio = 0;
 }
 
 /*
- * Release any resources in case of a failure
+ * Clean any dirty buffers in the blockdev mapping which alias newly-created
+ * file blocks.  Only called for S_ISREG files - blockdevs do not set buffer_new
  */
-static inline void dio_cleanup(struct dio *dio, struct dio_submit *sdio)
+static void clean_blockdev_aliases(struct dio *dio, struct dio_submit *sdio,
+				   struct buffer_head *map_bh)
 {
-	while (dio_pages_present(sdio))
-		page_cache_release(dio_get_page(dio, sdio));
+	unsigned i;
+	unsigned nblocks;
+
+	nblocks = map_bh->b_size >> sdio->i_blkbits;
+
+	for (i = 0; i < nblocks; i++)
+		unmap_underlying_metadata(map_bh->b_bdev,
+					  map_bh->b_blocknr + i);
 }
 
-/*
- * Wait for the next BIO to complete.  Remove it and return it.  NULL is
- * returned once all BIOs have been completed.  This must only be called once
- * all bios have been issued so that dio->refcount can only decrease.  This
- * requires that that the caller hold a reference on the dio.
- */
-static struct bio *dio_await_one(struct dio *dio)
+static int get_blocks(struct dio *dio, struct dio_submit *sdio,
+		      struct buffer_head *map_bh,
+		      loff_t offset, size_t size)
 {
-	unsigned long flags;
-	struct bio *bio = NULL;
+	int ret, create;
+	unsigned i_mask = (1 << sdio->i_blkbits) - 1;
+	unsigned fs_offset = offset & i_mask;
+	sector_t fs_block = offset >> sdio->i_blkbits;
 
-	spin_lock_irqsave(&dio->bio_lock, flags);
+	map_bh->b_state = 0;
+	map_bh->b_size = size + fs_offset;
 
 	/*
-	 * Wait as long as the list is empty and there are bios in flight.  bio
-	 * completion drops the count, maybe adds to the list, and wakes while
-	 * holding the bio_lock so we don't need set_current_state()'s barrier
-	 * and can call it after testing our condition.
+	 * For writes inside i_size on a DIO_SKIP_HOLES filesystem we
+	 * forbid block creations: only overwrites are permitted.
+	 * We will return early to the caller once we see an
+	 * unmapped buffer head returned, and the caller will fall
+	 * back to buffered I/O.
+	 *
+	 * Otherwise the decision is left to the get_blocks method,
+	 * which may decide to handle it or also return an unmapped
+	 * buffer head.
 	 */
-	while (dio->refcount > 1 && dio->bio_list == NULL) {
-		__set_current_state(TASK_UNINTERRUPTIBLE);
-		dio->waiter = current;
-		spin_unlock_irqrestore(&dio->bio_lock, flags);
-		io_schedule();
-		/* wake up sets us TASK_RUNNING */
-		spin_lock_irqsave(&dio->bio_lock, flags);
-		dio->waiter = NULL;
-	}
-	if (dio->bio_list) {
-		bio = dio->bio_list;
-		dio->bio_list = bio->bi_private;
+	create = dio->rw & WRITE;
+	if (dio->flags & DIO_SKIP_HOLES) {
+		if (fs_block < dio->i_size >> sdio->i_blkbits)
+			create = 0;
 	}
-	spin_unlock_irqrestore(&dio->bio_lock, flags);
-	return bio;
-}
 
-/*
- * Process one completed BIO.  No locks are held.
- */
-static int dio_bio_complete(struct dio *dio, struct bio *bio)
-{
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec;
-	unsigned i;
+	ret = sdio->get_block(dio->inode, fs_block,
+			      map_bh, create);
+	if (ret)
+		return ret;
 
-	if (!uptodate)
-		dio->io_error = -EIO;
+	BUG_ON(map_bh->b_size <= fs_offset);
+	map_bh->b_size -= fs_offset;
 
-	if (dio->is_async && dio->rw == READ) {
-		bio_check_pages_dirty(bio);	/* transfers ownership */
-	} else {
-		bio_for_each_segment_all(bvec, bio, i) {
-			struct page *page = bvec->bv_page;
+	/* Store for completion */
+	dio->private = map_bh->b_private;
 
-			if (dio->rw == READ && !PageCompound(page))
-				set_page_dirty_lock(page);
-			page_cache_release(page);
-		}
-		bio_put(bio);
-	}
-	return uptodate ? 0 : -EIO;
-}
+	if (!buffer_mapped(map_bh))
+		return 0;
 
-/*
- * Wait on and process all in-flight BIOs.  This must only be called once
- * all bios have been issued so that the refcount can only decrease.
- * This just waits for all bios to make it through dio_bio_complete.  IO
- * errors are propagated through dio->io_error and should be propagated via
- * dio_complete().
- */
-static void dio_await_completion(struct dio *dio)
-{
-	struct bio *bio;
-	do {
-		bio = dio_await_one(dio);
-		if (bio)
-			dio_bio_complete(dio, bio);
-	} while (bio);
-}
+	if (buffer_new(map_bh))
+		clean_blockdev_aliases(dio, sdio, map_bh);
 
-/*
- * A really large O_DIRECT read or write can generate a lot of BIOs.  So
- * to keep the memory consumption sane we periodically reap any completed BIOs
- * during the BIO generation phase.
- *
- * This also helps to limit the peak amount of pinned userspace memory.
- */
-static inline int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
-{
-	int ret = 0;
-
-	if (sdio->reap_counter++ >= 64) {
-		while (dio->bio_list) {
-			unsigned long flags;
-			struct bio *bio;
-			int ret2;
-
-			spin_lock_irqsave(&dio->bio_lock, flags);
-			bio = dio->bio_list;
-			dio->bio_list = bio->bi_private;
-			spin_unlock_irqrestore(&dio->bio_lock, flags);
-			ret2 = dio_bio_complete(dio, bio);
-			if (ret == 0)
-				ret = ret2;
-		}
-		sdio->reap_counter = 0;
-	}
 	return ret;
 }
 
-/*
- * Call into the fs to map some more disk blocks.  We record the current number
- * of available blocks at sdio->blocks_available.  These are in units of the
- * fs blocksize, (1 << inode->i_blkbits).
- *
- * The fs is allowed to map lots of blocks at once.  If it wants to do that,
- * it uses the passed inode-relative block number as the file offset, as usual.
- *
- * get_block() is passed the number of i_blkbits-sized blocks which direct_io
- * has remaining to do.  The fs should not map more than this number of blocks.
- *
- * If the fs has mapped a lot of blocks, it should populate bh->b_size to
- * indicate how much contiguous disk space has been made available at
- * bh->b_blocknr.
- *
- * If *any* of the mapped blocks are new, then the fs must set buffer_new().
- * This isn't very efficient...
- *
- * In the case of filesystem holes: the fs may return an arbitrarily-large
- * hole by returning an appropriate value in b_size and by clearing
- * buffer_mapped().  However the direct-io code will only process holes one
- * block at a time - it will repeatedly call get_block() as it walks the hole.
- */
-static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
-			   struct buffer_head *map_bh)
+static void __zero_fill_bio(struct bio *bio, unsigned bytes)
 {
-	int ret;
-	sector_t fs_startblk;	/* Into file, in filesystem-sized blocks */
-	sector_t fs_endblk;	/* Into file, in filesystem-sized blocks */
-	unsigned long fs_count;	/* Number of filesystem-sized blocks */
-	int create;
-	unsigned int i_blkbits = sdio->blkbits + sdio->blkfactor;
+	unsigned bi_size = bio->bi_iter.bi_size;
 
-	/*
-	 * If there was a memory error and we've overwritten all the
-	 * mapped blocks then we can now return that memory error
-	 */
-	ret = dio->page_errors;
-	if (ret == 0) {
-		BUG_ON(sdio->block_in_file >= sdio->final_block_in_request);
-		fs_startblk = sdio->block_in_file >> sdio->blkfactor;
-		fs_endblk = (sdio->final_block_in_request - 1) >>
-					sdio->blkfactor;
-		fs_count = fs_endblk - fs_startblk + 1;
+	bio->bi_iter.bi_size = bytes;
+	zero_fill_bio(bio);
+	bio->bi_iter.bi_size = bi_size;
+}
 
-		map_bh->b_state = 0;
-		map_bh->b_size = fs_count << i_blkbits;
+static void dio_write_zeroes(struct dio *dio, struct bio *parent,
+			     sector_t sector, size_t size)
+{
+	unsigned pages = DIV_ROUND_UP(size, PAGE_SIZE);
+	struct bio *bio = bio_alloc(GFP_KERNEL, pages);
 
-		/*
-		 * For writes inside i_size on a DIO_SKIP_HOLES filesystem we
-		 * forbid block creations: only overwrites are permitted.
-		 * We will return early to the caller once we see an
-		 * unmapped buffer head returned, and the caller will fall
-		 * back to buffered I/O.
-		 *
-		 * Otherwise the decision is left to the get_blocks method,
-		 * which may decide to handle it or also return an unmapped
-		 * buffer head.
-		 */
-		create = dio->rw & WRITE;
-		if (dio->flags & DIO_SKIP_HOLES) {
-			if (sdio->block_in_file < (i_size_read(dio->inode) >>
-							sdio->blkbits))
-				create = 0;
-		}
+	while (pages--) {
+		bio->bi_io_vec[pages].bv_page = ZERO_PAGE(0);
+		bio->bi_io_vec[pages].bv_len = PAGE_SIZE;
+		bio->bi_io_vec[pages].bv_offset = 0;
+	}
 
-		ret = (*sdio->get_block)(dio->inode, fs_startblk,
-						map_bh, create);
+	bio->bi_bdev = parent->bi_bdev;
+	bio->bi_iter.bi_sector = sector;
+	bio->bi_iter.bi_size = size;
 
-		/* Store for completion */
-		dio->private = map_bh->b_private;
-	}
-	return ret;
+	bio_chain(bio, parent);
+	submit_bio(WRITE, bio);
 }
 
-/*
- * There is no bio.  Make one now.
- */
-static inline int dio_new_bio(struct dio *dio, struct dio_submit *sdio,
-		sector_t start_sector, struct buffer_head *map_bh)
+static void dio_zero_partial_block(struct dio *dio, struct dio_submit *sdio,
+				   struct buffer_head *map_bh,
+				   struct bio *bio, loff_t offset)
 {
-	sector_t sector;
-	int ret, nr_pages;
-
-	ret = dio_bio_reap(dio, sdio);
-	if (ret)
-		goto out;
-	sector = start_sector << (sdio->blkbits - 9);
-	nr_pages = min(sdio->pages_in_io, bio_get_nr_vecs(map_bh->b_bdev));
-	nr_pages = min(nr_pages, BIO_MAX_PAGES);
-	BUG_ON(nr_pages <= 0);
-	dio_bio_alloc(dio, sdio, map_bh->b_bdev, sector, nr_pages);
-	sdio->boundary = 0;
-out:
-	return ret;
+	if ((dio->rw & WRITE) && buffer_new(map_bh)) {
+		unsigned blksize = 1 << sdio->i_blkbits;
+		unsigned blkmask = blksize - 1;
+		unsigned front = offset & blkmask;
+		unsigned back = (offset + bio->bi_iter.bi_size) & blkmask;
+
+		if (front)
+			dio_write_zeroes(dio, bio,
+					 bio->bi_iter.bi_sector - (front >> 9),
+					 front);
+
+		if (back)
+			dio_write_zeroes(dio, bio, bio_end_sector(bio),
+					 blksize - back);
+	}
 }
 
-/*
- * Attempt to put the current chunk of 'cur_page' into the current BIO.  If
- * that was successful then update final_block_in_bio and take a ref against
- * the just-added page.
- *
- * Return zero on success.  Non-zero means the caller needs to start a new BIO.
- */
-static inline int dio_bio_add_page(struct dio_submit *sdio)
+static int dio_send_bio(struct dio *dio, struct dio_submit *sdio,
+			struct bio *bio, loff_t offset)
 {
+	struct buffer_head map_bh = { 0, };
+	struct bio *split;
 	int ret;
 
-	ret = bio_add_page(sdio->bio, sdio->cur_page,
-			sdio->cur_page_len, sdio->cur_page_offset);
-	if (ret == sdio->cur_page_len) {
-		/*
-		 * Decrement count only, if we are done with this page
-		 */
-		if ((sdio->cur_page_len + sdio->cur_page_offset) == PAGE_SIZE)
-			sdio->pages_in_io--;
-		page_cache_get(sdio->cur_page);
-		sdio->final_block_in_bio = sdio->cur_page_block +
-			(sdio->cur_page_len >> sdio->blkbits);
-		ret = 0;
-	} else {
-		ret = 1;
-	}
-	return ret;
-}
-		
-/*
- * Put cur_page under IO.  The section of cur_page which is described by
- * cur_page_offset,cur_page_len is put into a BIO.  The section of cur_page
- * starts on-disk at cur_page_block.
- *
- * We take a ref against the page here (on behalf of its presence in the bio).
- *
- * The caller of this function is responsible for removing cur_page from the
- * dio, and for dropping the refcount which came from that presence.
- */
-static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
-		struct buffer_head *map_bh)
-{
-	int ret = 0;
+	while (1) {
+		ret = get_blocks(dio, sdio, &map_bh,
+				 offset, bio->bi_iter.bi_size);
+		if (ret)
+			return ret;
 
-	if (sdio->bio) {
-		loff_t cur_offset = sdio->cur_page_fs_offset;
-		loff_t bio_next_offset = sdio->logical_offset_in_bio +
-			sdio->bio->bi_iter.bi_size;
+		if (buffer_mapped(&map_bh)) {
+			dio->result += map_bh.b_size;
 
-		/*
-		 * See whether this new request is contiguous with the old.
-		 *
-		 * Btrfs cannot handle having logically non-contiguous requests
-		 * submitted.  For example if you have
-		 *
-		 * Logical:  [0-4095][HOLE][8192-12287]
-		 * Physical: [0-4095]      [4096-8191]
-		 *
-		 * We cannot submit those pages together as one BIO.  So if our
-		 * current logical offset in the file does not equal what would
-		 * be the next logical offset in the bio, submit the bio we
-		 * have.
-		 */
-		if (sdio->final_block_in_bio != sdio->cur_page_block ||
-		    cur_offset != bio_next_offset)
-			dio_bio_submit(dio, sdio);
-		/*
-		 * Submit now if the underlying fs is about to perform a
-		 * metadata read
-		 */
-		else if (sdio->boundary)
-			dio_bio_submit(dio, sdio);
-	}
+			bio->bi_bdev = map_bh.b_bdev;
+			bio->bi_iter.bi_sector =
+				map_bh.b_blocknr << (sdio->i_blkbits - 9);
 
-	if (sdio->bio == NULL) {
-		ret = dio_new_bio(dio, sdio, sdio->cur_page_block, map_bh);
-		if (ret)
-			goto out;
-	}
+			dio_zero_partial_block(dio, sdio, &map_bh, bio, offset);
 
-	if (dio_bio_add_page(sdio) != 0) {
-		dio_bio_submit(dio, sdio);
-		ret = dio_new_bio(dio, sdio, sdio->cur_page_block, map_bh);
-		if (ret == 0) {
-			ret = dio_bio_add_page(sdio);
-			BUG_ON(ret != 0);
-		}
-	}
-out:
-	return ret;
-}
+			split = bio_next_split(bio, map_bh.b_size >> 9,
+					       GFP_KERNEL, fs_bio_set);
 
-/*
- * An autonomous function to put a chunk of a page under deferred IO.
- *
- * The caller doesn't actually know (or care) whether this piece of page is in
- * a BIO, or is under IO or whatever.  We just take care of all possible 
- * situations here.  The separation between the logic of do_direct_IO() and
- * that of submit_page_section() is important for clarity.  Please don't break.
- *
- * The chunk of page starts on-disk at blocknr.
- *
- * We perform deferred IO, by recording the last-submitted page inside our
- * private part of the dio structure.  If possible, we just expand the IO
- * across that page here.
- *
- * If that doesn't work out then we put the old page into the bio and add this
- * page to the dio instead.
- */
-static inline int
-submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
-		    unsigned offset, unsigned len, sector_t blocknr,
-		    struct buffer_head *map_bh)
-{
-	int ret = 0;
+			if (split == bio)
+				atomic_long_inc(&dio->refcount);
+			else
+				bio_chain(split, bio);
 
-	if (dio->rw & WRITE) {
-		/*
-		 * Read accounting is performed in submit_bio()
-		 */
-		task_io_account_write(len);
-	}
+			dio_bio_submit(dio, sdio, split, offset);
 
-	/*
-	 * Can we just grow the current page's presence in the dio?
-	 */
-	if (sdio->cur_page == page &&
-	    sdio->cur_page_offset + sdio->cur_page_len == offset &&
-	    sdio->cur_page_block +
-	    (sdio->cur_page_len >> sdio->blkbits) == blocknr) {
-		sdio->cur_page_len += len;
+			if (split == bio)
+				return 0;
+		} else {
+			/* Holes always 1 block? */
+			//map_bh.b_size = 1 << sdio->i_blkbits;
 
-		/*
-		 * If sdio->boundary then we want to schedule the IO now to
-		 * avoid metadata seeks.
-		 */
-		if (sdio->boundary) {
-			ret = dio_send_cur_page(dio, sdio, map_bh);
-			page_cache_release(sdio->cur_page);
-			sdio->cur_page = NULL;
+			/* Hole */
+
+			/* AKPM: eargh, -ENOTBLK is a hack */
+			if (dio->rw & WRITE) {
+				ret = -ENOTBLK;
+				goto out_cleanup;
+			}
+
+			/*
+			 * Be sure to account for a partial block as the
+			 * last block in the file
+			 */
+			if (offset >= ALIGN(dio->i_size,
+					    1 << sdio->i_blkbits)) {
+				/* We hit eof */
+				goto out_cleanup;
+			}
+
+			dio->result += map_bh.b_size;
+
+			__zero_fill_bio(bio, map_bh.b_size);
+			bio_advance(bio, map_bh.b_size);
+
+			if (!bio->bi_iter.bi_size)
+				goto out_cleanup;
 		}
-		goto out;
-	}
 
-	/*
-	 * If there's a deferred page already there then send it.
-	 */
-	if (sdio->cur_page) {
-		ret = dio_send_cur_page(dio, sdio, map_bh);
-		page_cache_release(sdio->cur_page);
-		sdio->cur_page = NULL;
-		if (ret)
-			goto out;
+		offset += map_bh.b_size;
 	}
 
-	page_cache_get(page);		/* It is in dio */
-	sdio->cur_page = page;
-	sdio->cur_page_offset = offset;
-	sdio->cur_page_len = len;
-	sdio->cur_page_block = blocknr;
-	sdio->cur_page_fs_offset = sdio->block_in_file << sdio->blkbits;
-out:
+out_cleanup:
+	atomic_long_inc(&dio->refcount);
+	bio_endio(bio, 0);
 	return ret;
 }
 
-/*
- * Clean any dirty buffers in the blockdev mapping which alias newly-created
- * file blocks.  Only called for S_ISREG files - blockdevs do not set
- * buffer_new
- */
-static void clean_blockdev_aliases(struct dio *dio, struct buffer_head *map_bh)
+static ssize_t dio_fill_bio(struct dio *dio, struct dio_submit *sdio,
+			    struct bio *bio, size_t base, size_t left)
 {
-	unsigned i;
-	unsigned nblocks;
+	int ret;
+	unsigned nr_pages;
+	size_t offset, bytes;
+	struct bio_vec *bv;
+	struct page **pages;
 
-	nblocks = map_bh->b_size >> dio->inode->i_blkbits;
+	offset = base & (PAGE_SIZE - 1);
 
-	for (i = 0; i < nblocks; i++) {
-		unmap_underlying_metadata(map_bh->b_bdev,
-					  map_bh->b_blocknr + i);
-	}
-}
+	nr_pages = min_t(size_t,
+			 DIV_ROUND_UP(left + offset, PAGE_SIZE),
+			 bio->bi_max_vecs - bio->bi_vcnt);
 
-/*
- * If we are not writing the entire block and get_block() allocated
- * the block for us, we need to fill-in the unused portion of the
- * block with zeros. This happens only if user-buffer, fileoffset or
- * io length is not filesystem block-size multiple.
- *
- * `end' is zero if we're doing the start of the IO, 1 at the end of the
- * IO.
- */
-static inline void dio_zero_block(struct dio *dio, struct dio_submit *sdio,
-		int end, struct buffer_head *map_bh)
-{
-	unsigned dio_blocks_per_fs_block;
-	unsigned this_chunk_blocks;	/* In dio_blocks */
-	unsigned this_chunk_bytes;
-	struct page *page;
+	bv = &bio->bi_io_vec[bio->bi_vcnt];
+	pages = (void *) bv;
 
-	sdio->start_zero_done = 1;
-	if (!sdio->blkfactor || !buffer_new(map_bh))
-		return;
+	ret = get_user_pages_fast(base, nr_pages,
+				  dio->rw == READ, pages);
+	if (ret < 0)
+		return ret;
 
-	dio_blocks_per_fs_block = 1 << sdio->blkfactor;
-	this_chunk_blocks = sdio->block_in_file & (dio_blocks_per_fs_block - 1);
+	bio->bi_vcnt += ret;
+	bytes = ret * PAGE_SIZE - offset;
 
-	if (!this_chunk_blocks)
-		return;
+	while (ret--) {
+		bv[ret].bv_page = pages[ret];
+		bv[ret].bv_len = PAGE_SIZE;
+		bv[ret].bv_offset = 0;
+	}
 
-	/*
-	 * We need to zero out part of an fs block.  It is either at the
-	 * beginning or the end of the fs block.
-	 */
-	if (end) 
-		this_chunk_blocks = dio_blocks_per_fs_block - this_chunk_blocks;
+	bv[0].bv_offset += offset;
+	bv[0].bv_len -= offset;
 
-	this_chunk_bytes = this_chunk_blocks << sdio->blkbits;
+	if (bytes > left) {
+		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len -= bytes - left;
+		bytes = left;
+	}
 
-	page = ZERO_PAGE(0);
-	if (submit_page_section(dio, sdio, page, 0, this_chunk_bytes,
-				sdio->next_block_for_io, map_bh))
-		return;
+	bio->bi_iter.bi_size += bytes;
 
-	sdio->next_block_for_io += this_chunk_blocks;
+	return bytes;
 }
 
-/*
- * Walk the user pages, and the file, mapping blocks to disk and generating
- * a sequence of (page,offset,len,block) mappings.  These mappings are injected
- * into submit_page_section(), which takes care of the next stage of submission
- *
- * Direct IO against a blockdev is different from a file.  Because we can
- * happily perform page-sized but 512-byte aligned IOs.  It is important that
- * blockdev IO be able to have fine alignment and large sizes.
- *
- * So what we do is to permit the ->get_block function to populate bh.b_size
- * with the size of IO which is permitted at this offset and this i_blkbits.
- *
- * For best results, the blockdev should be set up with 512-byte i_blkbits and
- * it should set b_size to PAGE_SIZE or more inside get_block().  This gives
- * fine alignment but still allows this function to work in PAGE_SIZE units.
- */
-static int do_direct_IO(struct dio *dio, struct dio_submit *sdio,
-			struct buffer_head *map_bh)
+static int dio_alloc_bios(struct dio *dio, struct dio_submit *sdio,
+			  const struct iovec *iov, loff_t offset,
+			  unsigned long nr_segs, unsigned nr_pages)
 {
-	const unsigned blkbits = sdio->blkbits;
-	const unsigned blocks_per_page = PAGE_SIZE >> blkbits;
-	struct page *page;
-	unsigned block_in_page;
-	int ret = 0;
-
-	/* The I/O can start at any block offset within the first page */
-	block_in_page = sdio->first_block_in_page;
-
-	while (sdio->block_in_file < sdio->final_block_in_request) {
-		page = dio_get_page(dio, sdio);
-		if (IS_ERR(page)) {
-			ret = PTR_ERR(page);
-			goto out;
-		}
+	ssize_t ret;
+	size_t seg_done = 0;
+	unsigned seg = 0;
+	struct bio *bio;
 
-		while (block_in_page < blocks_per_page) {
-			unsigned offset_in_page = block_in_page << blkbits;
-			unsigned this_chunk_bytes;	/* # of bytes mapped */
-			unsigned this_chunk_blocks;	/* # of blocks */
-			unsigned u;
-
-			if (sdio->blocks_available == 0) {
-				/*
-				 * Need to go and map some more disk
-				 */
-				unsigned long blkmask;
-				unsigned long dio_remainder;
-
-				ret = get_more_blocks(dio, sdio, map_bh);
-				if (ret) {
-					page_cache_release(page);
-					goto out;
-				}
-				if (!buffer_mapped(map_bh))
-					goto do_holes;
-
-				sdio->blocks_available =
-						map_bh->b_size >> sdio->blkbits;
-				sdio->next_block_for_io =
-					map_bh->b_blocknr << sdio->blkfactor;
-				if (buffer_new(map_bh))
-					clean_blockdev_aliases(dio, map_bh);
-
-				if (!sdio->blkfactor)
-					goto do_holes;
-
-				blkmask = (1 << sdio->blkfactor) - 1;
-				dio_remainder = (sdio->block_in_file & blkmask);
-
-				/*
-				 * If we are at the start of IO and that IO
-				 * starts partway into a fs-block,
-				 * dio_remainder will be non-zero.  If the IO
-				 * is a read then we can simply advance the IO
-				 * cursor to the first block which is to be
-				 * read.  But if the IO is a write and the
-				 * block was newly allocated we cannot do that;
-				 * the start of the fs block must be zeroed out
-				 * on-disk
-				 */
-				if (!buffer_new(map_bh))
-					sdio->next_block_for_io += dio_remainder;
-				sdio->blocks_available -= dio_remainder;
-			}
-do_holes:
-			/* Handle holes */
-			if (!buffer_mapped(map_bh)) {
-				loff_t i_size_aligned;
-
-				/* AKPM: eargh, -ENOTBLK is a hack */
-				if (dio->rw & WRITE) {
-					page_cache_release(page);
-					return -ENOTBLK;
-				}
-
-				/*
-				 * Be sure to account for a partial block as the
-				 * last block in the file
-				 */
-				i_size_aligned = ALIGN(i_size_read(dio->inode),
-							1 << blkbits);
-				if (sdio->block_in_file >=
-						i_size_aligned >> blkbits) {
-					/* We hit eof */
-					page_cache_release(page);
-					goto out;
-				}
-				zero_user(page, block_in_page << blkbits,
-						1 << blkbits);
-				sdio->block_in_file++;
-				block_in_page++;
-				goto next_block;
+	bio = &dio->bio;
+	bio_get(bio);
+	goto start;
+
+	while (seg < nr_segs) {
+		BUG_ON(!nr_pages);
+
+		bio = bio_alloc(GFP_KERNEL,
+				min_t(unsigned, BIO_MAX_PAGES, nr_pages));
+start:
+		bio->bi_private = dio;
+		bio->bi_end_io = dio_end_io;
+
+		while (bio->bi_vcnt < bio->bi_max_vecs &&
+		       seg < nr_segs) {
+			ret = dio_fill_bio(dio, sdio, bio,
+					(size_t) iov[seg].iov_base + seg_done,
+					iov[seg].iov_len - seg_done);
+			if (ret < 0) {
+				struct bio_vec *bv;
+				int i;
+
+				bio_for_each_segment_all(bv, bio, i)
+					page_cache_release(bv->bv_page);
+				bio_put(bio);
+
+				dio->page_error = ret;
+				return 0;
 			}
 
-			/*
-			 * If we're performing IO which has an alignment which
-			 * is finer than the underlying fs, go check to see if
-			 * we must zero out the start of this block.
-			 */
-			if (unlikely(sdio->blkfactor && !sdio->start_zero_done))
-				dio_zero_block(dio, sdio, 0, map_bh);
+			seg_done += ret;
 
-			/*
-			 * Work out, in this_chunk_blocks, how much disk we
-			 * can add to this page
-			 */
-			this_chunk_blocks = sdio->blocks_available;
-			u = (PAGE_SIZE - offset_in_page) >> blkbits;
-			if (this_chunk_blocks > u)
-				this_chunk_blocks = u;
-			u = sdio->final_block_in_request - sdio->block_in_file;
-			if (this_chunk_blocks > u)
-				this_chunk_blocks = u;
-			this_chunk_bytes = this_chunk_blocks << blkbits;
-			BUG_ON(this_chunk_bytes == 0);
-
-			sdio->boundary = buffer_boundary(map_bh);
-			ret = submit_page_section(dio, sdio, page,
-						  offset_in_page,
-						  this_chunk_bytes,
-						  sdio->next_block_for_io,
-						  map_bh);
-			if (ret) {
-				page_cache_release(page);
-				goto out;
+			if (seg_done == iov[seg].iov_len) {
+				seg++;
+				seg_done = 0;
 			}
-			sdio->next_block_for_io += this_chunk_blocks;
-
-			sdio->block_in_file += this_chunk_blocks;
-			block_in_page += this_chunk_blocks;
-			sdio->blocks_available -= this_chunk_blocks;
-next_block:
-			BUG_ON(sdio->block_in_file > sdio->final_block_in_request);
-			if (sdio->block_in_file == sdio->final_block_in_request)
-				break;
 		}
 
-		/* Drop the ref which was taken in get_user_pages() */
-		page_cache_release(page);
-		block_in_page = 0;
-	}
-out:
-	return ret;
-}
+		nr_pages -= bio->bi_vcnt;
 
-static inline int drop_refcount(struct dio *dio)
-{
-	int ret2;
-	unsigned long flags;
+		if (dio->rw == READ)
+			bio_set_pages_dirty(bio);
 
-	/*
-	 * Sync will always be dropping the final ref and completing the
-	 * operation.  AIO can if it was a broken operation described above or
-	 * in fact if all the bios race to complete before we get here.  In
-	 * that case dio_complete() translates the EIOCBQUEUED into the proper
-	 * return code that the caller will hand to aio_complete().
-	 *
-	 * This is managed by the bio_lock instead of being an atomic_t so that
-	 * completion paths can drop their ref and use the remaining count to
-	 * decide to wake the submission path atomically.
-	 */
-	spin_lock_irqsave(&dio->bio_lock, flags);
-	ret2 = --dio->refcount;
-	spin_unlock_irqrestore(&dio->bio_lock, flags);
-	return ret2;
+		ret = dio_send_bio(dio, sdio, bio,
+				   offset + dio->result);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 /*
@@ -1045,76 +524,57 @@ static inline int drop_refcount(struct dio *dio)
  * individual fields and will generate much worse code. This is important
  * for the whole file.
  */
-static inline ssize_t
+static ssize_t
 do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
+	struct block_device *bdev, const struct iovec *iov, loff_t offset,
 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
 	dio_submit_t submit_io,	int flags)
 {
-	int seg;
-	size_t size;
-	unsigned long addr;
-	unsigned i_blkbits = ACCESS_ONCE(inode->i_blkbits);
-	unsigned blkbits = i_blkbits;
-	unsigned blocksize_mask = (1 << blkbits) - 1;
-	ssize_t retval = -EINVAL;
-	loff_t end = offset;
+	unsigned nr_pages = 0, blocksize_mask;
+	size_t size = 0;
+	ssize_t retval = 0;
+	const struct iovec *v;
 	struct dio *dio;
-	struct dio_submit sdio = { 0, };
-	unsigned long user_addr;
-	size_t bytes;
-	struct buffer_head map_bh = { 0, };
+	struct dio_submit sdio;
 	struct blk_plug plug;
 
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
 
-	/*
-	 * Avoid references to bdev if not absolutely needed to give
-	 * the early prefetch in the caller enough time.
-	 */
+	sdio.get_block	= get_block;
+	sdio.submit_io	= submit_io;
+	sdio.i_blkbits	= ACCESS_ONCE(inode->i_blkbits);
 
-	if (offset & blocksize_mask) {
-		if (bdev)
-			blkbits = blksize_bits(bdev_logical_block_size(bdev));
-		blocksize_mask = (1 << blkbits) - 1;
-		if (offset & blocksize_mask)
-			goto out;
-	}
+	for (v = iov; v < iov + nr_segs; v++) {
+		unsigned offset = (size_t) v->iov_base & (PAGE_SIZE - 1);
 
-	/* Check the memory alignment.  Blocks cannot straddle pages */
-	for (seg = 0; seg < nr_segs; seg++) {
-		addr = (unsigned long)iov[seg].iov_base;
-		size = iov[seg].iov_len;
-		end += size;
-		if (unlikely((addr & blocksize_mask) ||
-			     (size & blocksize_mask))) {
-			if (bdev)
-				blkbits = blksize_bits(
-					 bdev_logical_block_size(bdev));
-			blocksize_mask = (1 << blkbits) - 1;
-			if ((addr & blocksize_mask) || (size & blocksize_mask))
-				goto out;
-		}
+		nr_pages += DIV_ROUND_UP(offset + v->iov_len, PAGE_SIZE);
+		size += v->iov_len;
 	}
 
 	/* watch out for a 0 len io from a tricksy fs */
-	if (rw == READ && end == offset)
+	if (rw == READ && !size)
 		return 0;
 
-	dio = kmem_cache_alloc(dio_cache, GFP_KERNEL);
-	retval = -ENOMEM;
-	if (!dio)
-		goto out;
+	blocksize_mask = (1 << sdio.i_blkbits) - 1;
+
 	/*
-	 * Believe it or not, zeroing out the page array caused a .5%
-	 * performance regression in a database benchmark.  So, we take
-	 * care to only zero out what's needed.
+	 * Avoid references to bdev if not absolutely needed to give
+	 * the early prefetch in the caller enough time.
 	 */
-	memset(dio, 0, offsetof(struct dio, pages));
 
-	dio->flags = flags;
-	if (dio->flags & DIO_LOCKING) {
+	if (unlikely((offset & blocksize_mask) ||
+		     (size & blocksize_mask))) {
+		if (bdev)
+			blocksize_mask = roundup_pow_of_two(
+				bdev_logical_block_size(bdev)) - 1;
+
+		if ((offset & blocksize_mask) ||
+		    (size & blocksize_mask))
+			return -EINVAL;
+	}
+
+	if (flags & DIO_LOCKING) {
 		if (rw == READ) {
 			struct address_space *mapping =
 					iocb->ki_filp->f_mapping;
@@ -1123,11 +583,10 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 			mutex_lock(&inode->i_mutex);
 
 			retval = filemap_write_and_wait_range(mapping, offset,
-							      end - 1);
+							   offset + size - 1);
 			if (retval) {
 				mutex_unlock(&inode->i_mutex);
-				kmem_cache_free(dio_cache, dio);
-				goto out;
+				return retval;
 			}
 		}
 	}
@@ -1137,83 +596,28 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	 */
 	atomic_inc(&inode->i_dio_count);
 
-	/*
-	 * For file extending writes updating i_size before data
-	 * writeouts complete can expose uninitialized blocks. So
-	 * even for AIO, we need to wait for i/o to complete before
-	 * returning in this case.
-	 */
-	dio->is_async = !is_sync_kiocb(iocb) && !((rw & WRITE) &&
-		(end > i_size_read(inode)));
-
-	retval = 0;
-
-	dio->inode = inode;
-	dio->rw = rw;
-	sdio.blkbits = blkbits;
-	sdio.blkfactor = i_blkbits - blkbits;
-	sdio.block_in_file = offset >> blkbits;
-
-	sdio.get_block = get_block;
-	dio->end_io = end_io;
-	sdio.submit_io = submit_io;
-	sdio.final_block_in_bio = -1;
-	sdio.next_block_for_io = -1;
-
-	dio->iocb = iocb;
-	dio->i_size = i_size_read(inode);
-
-	spin_lock_init(&dio->bio_lock);
-	dio->refcount = 1;
-
-	/*
-	 * In case of non-aligned buffers, we may need 2 more
-	 * pages since we need to zero out first and last block.
-	 */
-	if (unlikely(sdio.blkfactor))
-		sdio.pages_in_io = 2;
-
-	for (seg = 0; seg < nr_segs; seg++) {
-		user_addr = (unsigned long)iov[seg].iov_base;
-		sdio.pages_in_io +=
-			((user_addr + iov[seg].iov_len + PAGE_SIZE-1) /
-				PAGE_SIZE - user_addr / PAGE_SIZE);
-	}
+	dio = container_of(bio_alloc_bioset(GFP_KERNEL,
+				    min_t(unsigned, BIO_MAX_PAGES, nr_pages),
+				    dio_pool),
+			   struct dio, bio);
+
+	dio->flags	= flags;
+	dio->rw		= rw;
+	dio->inode	= inode;
+	dio->i_size	= i_size_read(inode);
+	dio->end_io	= end_io;
+	dio->private	= NULL;
+
+	dio->page_error	= 0;
+	dio->io_error	= 0;
+	atomic_long_set(&dio->refcount, 1);
+	dio->waiter	= NULL;
+	dio->iocb	= iocb;
+	dio->result	= 0;
 
 	blk_start_plug(&plug);
 
-	for (seg = 0; seg < nr_segs; seg++) {
-		user_addr = (unsigned long)iov[seg].iov_base;
-		sdio.size += bytes = iov[seg].iov_len;
-
-		/* Index into the first page of the first block */
-		sdio.first_block_in_page = (user_addr & ~PAGE_MASK) >> blkbits;
-		sdio.final_block_in_request = sdio.block_in_file +
-						(bytes >> blkbits);
-		/* Page fetching state */
-		sdio.head = 0;
-		sdio.tail = 0;
-		sdio.curr_page = 0;
-
-		sdio.total_pages = 0;
-		if (user_addr & (PAGE_SIZE-1)) {
-			sdio.total_pages++;
-			bytes -= PAGE_SIZE - (user_addr & (PAGE_SIZE - 1));
-		}
-		sdio.total_pages += (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
-		sdio.curr_user_address = user_addr;
-
-		retval = do_direct_IO(dio, &sdio, &map_bh);
-
-		dio->result += iov[seg].iov_len -
-			((sdio.final_block_in_request - sdio.block_in_file) <<
-					blkbits);
-
-		if (retval) {
-			dio_cleanup(dio, &sdio);
-			break;
-		}
-	} /* end iovec loop */
+	retval = dio_alloc_bios(dio, &sdio, iov, offset, nr_segs, nr_pages);
 
 	if (retval == -ENOTBLK) {
 		/*
@@ -1222,33 +626,10 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 		 */
 		retval = 0;
 	}
-	/*
-	 * There may be some unwritten disk at the end of a part-written
-	 * fs-block-sized block.  Go zero that now.
-	 */
-	dio_zero_block(dio, &sdio, 1, &map_bh);
-
-	if (sdio.cur_page) {
-		ssize_t ret2;
-
-		ret2 = dio_send_cur_page(dio, &sdio, &map_bh);
-		if (retval == 0)
-			retval = ret2;
-		page_cache_release(sdio.cur_page);
-		sdio.cur_page = NULL;
-	}
-	if (sdio.bio)
-		dio_bio_submit(dio, &sdio);
 
 	blk_finish_plug(&plug);
 
 	/*
-	 * It is possible that, we return short IO due to end of file.
-	 * In that case, we need to release all the pages we got hold on.
-	 */
-	dio_cleanup(dio, &sdio);
-
-	/*
 	 * All block lookups have been performed. For READ requests
 	 * we can let i_mutex go now that its achieved its purpose
 	 * of protecting us from looking up uninitialized blocks.
@@ -1264,20 +645,28 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	 * This had *better* be the only place that raises -EIOCBQUEUED.
 	 */
 	BUG_ON(retval == -EIOCBQUEUED);
-	if (dio->is_async && retval == 0 && dio->result &&
-	    ((rw == READ) || (dio->result == sdio.size)))
+
+	/*
+	 * For file extending writes updating i_size before data
+	 * writeouts complete can expose uninitialized blocks. So
+	 * even for AIO, we need to wait for i/o to complete before
+	 * returning in this case.
+	 */
+	if (!is_sync_kiocb(iocb) &&
+	    retval == 0 && dio->result &&
+	    ((rw == READ) ||
+	     (offset + size <= dio->i_size &&
+	      dio->result == size)))
 		retval = -EIOCBQUEUED;
 
 	if (retval != -EIOCBQUEUED)
-		dio_await_completion(dio);
+		dio_wait_completion(dio);
 
-	if (drop_refcount(dio) == 0) {
+	if (atomic_long_dec_and_test(&dio->refcount))
 		retval = dio_complete(dio, offset, retval, false);
-		kmem_cache_free(dio_cache, dio);
-	} else
+	else
 		BUG_ON(retval != -EIOCBQUEUED);
 
-out:
 	return retval;
 }
 
@@ -1308,7 +697,9 @@ EXPORT_SYMBOL(__blockdev_direct_IO);
 
 static __init int dio_init(void)
 {
-	dio_cache = KMEM_CACHE(dio, SLAB_PANIC);
+	dio_pool = bioset_create(4, offsetof(struct dio, bio));
+	if (!dio_pool)
+		return -ENOMEM;
 	return 0;
 }
 module_init(dio_init)
-- 
1.7.10.4

