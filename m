Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaIQP0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:26:53 -0400
Received: from kanga.kvack.org ([205.233.56.17]:45822 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbaIQP0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:26:50 -0400
Date: Wed, 17 Sep 2014 11:26:48 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Milosz Tanski <milosz@adfin.com>, "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, Andreas Dilger <adilger@dilger.ca>
Subject: [RFC 2/2] ext4: async readpage for indirect style inodes
Message-ID: <20140917152648.GV24821@kvack.org>
References: <cover.1410810247.git.milosz@adfin.com> <20140917144925.GU24821@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917144925.GU24821@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

And here is the version of readpage for ext3/ext4 that performs async 
metadata reads for old-style indirect block based ext3/ext4 filesystems.  
This version only includes the changes against ext4 -- the changes to 
ext3 are pretty much identical.  This is only an RFC and has at least 
one known issue, that being that it only works on ext3 filesystems with 
block size equal to page size.

		-ben
-- 
"Thought is the essence of where you are now."

 fs/ext4/ext4.h          |    3 
 fs/ext4/indirect.c      |    6 
 fs/ext4/inode.c         |  294 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/mpage.c              |    4 
 include/linux/mpage.h   |    3 
 include/linux/pagemap.h |    2 
 6 files changed, 307 insertions(+), 5 deletions(-)
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b0c225c..8136284 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2835,6 +2835,9 @@ extern struct mutex ext4__aio_mutex[EXT4_WQ_HASH_SZ];
 extern int ext4_resize_begin(struct super_block *sb);
 extern void ext4_resize_end(struct super_block *sb);
 
+extern int ext4_block_to_path(struct inode *inode,
+			      ext4_lblk_t i_block,
+			      ext4_lblk_t offsets[4], int *boundary);
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index e75f840..689267a 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -69,9 +69,9 @@ static inline void add_chain(Indirect *p, struct buffer_head *bh, __le32 *v)
  * get there at all.
  */
 
-static int ext4_block_to_path(struct inode *inode,
-			      ext4_lblk_t i_block,
-			      ext4_lblk_t offsets[4], int *boundary)
+int ext4_block_to_path(struct inode *inode,
+		       ext4_lblk_t i_block,
+		       ext4_lblk_t offsets[4], int *boundary)
 {
 	int ptrs = EXT4_ADDR_PER_BLOCK(inode->i_sb);
 	int ptrs_bits = EXT4_ADDR_PER_BLOCK_BITS(inode->i_sb);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3aa26e9..4b36000 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2820,6 +2820,297 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping, block, ext4_get_block);
 }
 
+#include <linux/bio.h>
+
+struct ext4_readpage_state {
+	struct page		*page;
+	struct inode		*inode;
+	int			offsets[4];
+	int			depth;
+	int			blocks_to_boundary;
+	int			cur_depth;
+	int			cur_block;
+	int			waiting_on_lock;
+	struct buffer_head	*cur_bh;
+	struct bio		*bio;
+	struct wait_bit_queue	wait_bit;
+	struct work_struct	work;
+};
+
+#define dprintk(x...) do { ; } while (0)
+
+static void ext4_readpage_statemachine(struct ext4_readpage_state *state);
+static void ext4_readpage_work_func(struct work_struct *work)
+{
+	struct ext4_readpage_state *state;
+
+	state = container_of(work, struct ext4_readpage_state, work);
+	dprintk("ext4_readpage_work_func(%p): state=%p\n", work, state);
+	ext4_readpage_statemachine(state);
+}
+
+static int ext4_readpage_wait_func(wait_queue_t *wait, unsigned mode, int flags,
+				   void *arg)
+{
+	struct ext4_readpage_state *state = wait->private;
+	struct wait_bit_key *key = arg;
+
+	dprintk("ext4_readpage_wait_func: state=%p\n", state);
+	dprintk("key->flags=%p key->bit_nr=%d, page->flags=%p\n",
+		key->flags, key->bit_nr, &pginfo->page->flags);
+	if (state->wait_bit.key.flags != key->flags ||
+	    state->wait_bit.key.bit_nr != key->bit_nr ||
+	    test_bit(key->bit_nr, key->flags))
+		 return 0;
+	dprintk("ext4_readpage_wait_func: page is unlocked/uptodate\n");
+	list_del_init(&wait->task_list);
+	INIT_WORK(&state->work, ext4_readpage_work_func);
+	schedule_work(&state->work);
+	return 1;
+}
+
+static void ext4_readpage_wait_on_bh(struct ext4_readpage_state *state)
+{
+	wait_queue_head_t *wq;
+	unsigned long flags;
+	int ret = 0;
+
+	state->wait_bit.key.flags = &state->cur_bh->b_state;
+	state->wait_bit.key.bit_nr = BH_Lock;
+	state->wait_bit.wait.private = state;
+	state->wait_bit.wait.func = ext4_readpage_wait_func;
+
+	wq = bit_waitqueue(state->wait_bit.key.flags,
+			   state->wait_bit.key.bit_nr);
+	spin_lock_irqsave(&wq->lock, flags);
+	__add_wait_queue(wq, &state->wait_bit.wait);
+	if (!buffer_locked(state->cur_bh)) {
+		dprintk("ext4_readpage_wait_on_bh(%p): buffer not locked\n", state);
+		list_del_init(&state->wait_bit.wait.task_list);
+		ret = 1;
+	}
+	spin_unlock_irqrestore(&wq->lock, flags);
+
+	dprintk("ext4_readpage_wait_on_bh(%p): ret=%d\n", state, ret);
+	if (ret)
+		ext4_readpage_statemachine(state);
+}
+
+static void ext4_readpage_statemachine(struct ext4_readpage_state *state)
+{
+	struct ext4_inode_info *ei = EXT4_I(state->inode);
+	struct buffer_head *bh;
+	int offset;
+	__le32 *blkp;
+	u32 blocknr;
+
+	dprintk("ext4_readpage_statemachine(%p): cur_depth=%d\n",
+		state, state->cur_depth);
+
+	if (state->waiting_on_lock)
+		goto lock_buffer;
+
+	offset = state->offsets[state->cur_depth];
+	if (state->cur_depth == 0)
+		blkp = ei->i_data + offset;
+	else {
+		if (!buffer_uptodate(state->cur_bh)) {
+			dprintk("ext4_readpage_statemachine: "
+                               "!buffer_update(%Lu)\n",
+			       (unsigned long long )state->cur_bh->b_blocknr);
+			brelse(state->cur_bh);
+			bio_put(state->bio);
+			SetPageError(state->page);
+			unlock_page(state->page);
+			return;	// FIXME: verify error handling is correct
+		}
+		blkp = (__le32 *)state->cur_bh->b_data + offset;
+	}
+
+	blocknr = le32_to_cpu(*blkp);
+	if (state->cur_bh)
+		brelse(state->cur_bh);
+	state->cur_depth++;
+
+	dprintk("state->cur_depth=%d depth=%d offset=%d blocknr=%u\n",
+		state->cur_depth, state->depth, offset, blocknr);
+	if (state->cur_depth == state->depth) {
+		dprintk("submitting bio %p for block %u\n", state->bio, blocknr);
+		state->bio->bi_iter.bi_sector =
+			(sector_t)blocknr << (state->inode->i_blkbits - 9);
+		mpage_bio_submit(READ, state->bio);
+		return;
+	}
+
+	state->cur_bh = sb_getblk(state->inode->i_sb, blocknr);
+	if (!state->cur_bh) {
+		dprintk("sb_getblk(%p, %u) failed\n",
+			state->inode->i_sb, blocknr);
+		dprintk("FAIL!\n");
+		bio_put(state->bio);
+		SetPageError(state->page);
+		unlock_page(state->page);
+		return;	// FIXME - verify error handling
+	}
+
+	dprintk("ext4_readpage_statemachine: cur_bh=%p\n", state->cur_bh);
+
+lock_buffer:
+	state->waiting_on_lock = 0;
+	if (buffer_uptodate(state->cur_bh)) {
+		dprintk("ext4_readpage_statemachine(%p): buffer uptodate\n",
+			state);
+		return ext4_readpage_statemachine(state);
+	}
+
+	dprintk("ext4_readpage_statemachine(%p): locking buffer\n", state);
+
+	if (!trylock_buffer(state->cur_bh)) {
+		state->waiting_on_lock = 1;
+		ext4_readpage_wait_on_bh(state);
+		return;
+	}
+
+	/* We have the buffer locked */
+	if (buffer_uptodate(state->cur_bh)) {
+		dprintk("ext4_readpage_statemachine: buffer uptodate after lock\n");
+		unlock_buffer(state->cur_bh);
+		return ext4_readpage_statemachine(state);
+	}
+
+	bh = state->cur_bh;
+	get_bh(bh);
+	bh->b_end_io = end_buffer_read_sync;
+	ext4_readpage_wait_on_bh(state);
+	submit_bh(READ | REQ_META /*| REQ_PRIO*/, bh);
+}
+
+static unsigned ext4_count_meta(unsigned blocks, unsigned ind_shift)
+{
+	const unsigned dind_shift = ind_shift * 2;
+	unsigned blocks_per_ind = 1U << ind_shift;
+	unsigned blocks_per_dind = 1U << dind_shift;
+	unsigned nr_meta = 0;
+
+	dprintk("ext4_count_meta(%Ld, %u)\n", (long long)blocks, blocks_per_ind);
+
+	/* direct entry? */
+	if (blocks <= EXT4_NDIR_BLOCKS)
+		return 0;
+
+	/* This has to be an indirect entry */
+	nr_meta ++;			// The indirect block
+	blocks -= EXT4_NDIR_BLOCKS;
+	if (blocks <= blocks_per_ind)
+		return 1;
+	blocks -= blocks_per_ind;
+
+	/* Now we have a double indirect entry */
+	nr_meta ++;			// The double indirect block
+	if (blocks <= blocks_per_dind) {
+		nr_meta += (blocks + blocks_per_ind - 1) >> ind_shift;
+		return nr_meta;
+	}
+
+	nr_meta += blocks_per_ind;	// The indirect blocks in the dind
+	blocks -= blocks_per_dind;
+
+	nr_meta ++;			// The triple indirect block
+
+	// The double indirect in the tind
+	nr_meta += (blocks + blocks_per_dind - 1) >> dind_shift;
+
+	// The indirect blocks pointed to by the dinds by the tind
+	nr_meta += (blocks + blocks_per_ind - 1) >> ind_shift;
+
+	return nr_meta;
+}
+
+static int ext4_async_readpage(struct file *file, struct page *page)
+{
+	struct ext4_readpage_state *state = page_address(page);
+	struct inode *inode = page->mapping->host;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int blocks_to_boundary = 0;
+	int offsets[4] = { 0, };
+	sector_t iblock;
+	__le32 indirect;
+	sector_t blk;
+	int depth;
+
+	/* Attempt metadata readahead if this is a read of the first page of
+	 * the file.  We assume the metadata is contiguously laid out starting
+	 * at the first indirect block of the file.
+	 */
+	indirect = ei->i_data[EXT4_IND_BLOCK];
+	blk = le32_to_cpu(indirect);
+	dprintk("ext4_async_readpage: index=%Lu, blk=%u\n",
+		(unsigned long long)page->index, (unsigned)blk);
+	if ((page->index == 0) && blk) {
+		loff_t i_size = i_size_read(inode);
+		unsigned i, nr_meta;
+		i_size += PAGE_SIZE - 1;
+		nr_meta = ext4_count_meta(i_size >> inode->i_blkbits,
+					  inode->i_blkbits - 2);
+		dprintk("readpage(0): blk[IND]=%u nr_meta=%u blk[0]=%u i_size=%Ld\n",
+			(unsigned)blk, nr_meta, le32_to_cpu(ei->i_data[0]),
+			(long long)i_size);
+		for (i=0; i < nr_meta; i++) {
+			sb_breadahead(inode->i_sb, blk + i);
+		}
+	}
+
+	iblock = (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	depth = ext4_block_to_path(inode, iblock, offsets, &blocks_to_boundary);
+	if (page_has_buffers(page)) {
+		int nr_uptodate = 0, nr = 0;
+		struct buffer_head *bh, *head;
+
+		head = bh = page_buffers(page);
+		do {
+			nr++;
+			nr_uptodate += !!buffer_uptodate(bh);
+			bh = bh->b_this_page;
+		} while (bh != head) ;
+		dprintk("inode(%lu) index=%Lu has nr=%d nr_up=%d\n",
+			inode->i_ino, (unsigned long long)page->index,
+			nr, nr_uptodate);
+		// A previous write may have already marked a buffer_head
+		// covering the page as uptodate.  Reuse mpage_readpage() to
+		// handle this case.
+		if (nr_uptodate > 0) {
+			return mpage_readpage(page, ext4_get_block);
+		}
+	}
+
+	if (depth == 1)
+		return mpage_readpage(page, ext4_get_block);
+
+	/* now set things up for reading the page */
+	memset(state, 0, sizeof(*state));
+	state->page = page;
+	state->inode = inode;
+        state->depth = depth;
+	state->blocks_to_boundary = blocks_to_boundary;
+	memcpy(state->offsets, offsets, sizeof(offsets));
+
+	dprintk("inode[%lu] page[%Lu]: depth=%d, offsets=%d,%d,%d,%d\n",
+		inode->i_ino, (unsigned long long)page->index, state->depth,
+		state->offsets[0], state->offsets[1], state->offsets[2],
+		state->offsets[3]);
+
+	state->bio = mpage_alloc(inode->i_sb->s_bdev, 0, 1, GFP_NOFS);
+	if (!state->bio) {
+		dprintk("ext4_async_readpage(%p, %Lu): mpage_alloc failed\n",
+			file, (unsigned long long)iblock);
+		unlock_page(page);
+		return -ENOMEM;
+	}
+	bio_add_page(state->bio, page, PAGE_SIZE, 0);
+	ext4_readpage_statemachine(state);
+	return 0;
+}
+
 static int ext4_readpage(struct file *file, struct page *page)
 {
 	int ret = -EAGAIN;
@@ -2827,6 +3118,9 @@ static int ext4_readpage(struct file *file, struct page *page)
 
 	trace_ext4_readpage(page);
 
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+		return ext4_async_readpage(file, page);
+
 	if (ext4_has_inline_data(inode))
 		ret = ext4_readpage_inline(inode, page);
 
diff --git a/fs/mpage.c b/fs/mpage.c
index 5f9ed62..0fca557 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -54,14 +54,14 @@ static void mpage_end_io(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-static struct bio *mpage_bio_submit(int rw, struct bio *bio)
+struct bio *mpage_bio_submit(int rw, struct bio *bio)
 {
 	bio->bi_end_io = mpage_end_io;
 	submit_bio(rw, bio);
 	return NULL;
 }
 
-static struct bio *
+struct bio *
 mpage_alloc(struct block_device *bdev,
 		sector_t first_sector, int nr_vecs,
 		gfp_t gfp_flags)
diff --git a/include/linux/mpage.h b/include/linux/mpage.h
index 068a0c9..3bf909b 100644
--- a/include/linux/mpage.h
+++ b/include/linux/mpage.h
@@ -13,6 +13,9 @@
 
 struct writeback_control;
 
+struct bio *mpage_bio_submit(int rw, struct bio *bio);
+struct bio * mpage_alloc(struct block_device *bdev, sector_t first_sector,
+			 int nr_vecs, gfp_t gfp_flags);
 int mpage_readpages(struct address_space *mapping, struct list_head *pages,
 				unsigned nr_pages, get_block_t get_block);
 int mpage_readpage(struct page *page, get_block_t get_block);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 3df8c7d..afd1f20 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -495,6 +495,8 @@ static inline int lock_page_or_retry(struct page *page, struct mm_struct *mm,
 	return trylock_page(page) || __lock_page_or_retry(page, mm, flags);
 }
 
+wait_queue_head_t *page_waitqueue(struct page *page);
+
 /*
  * This is exported only for wait_on_page_locked/wait_on_page_writeback.
  * Never use this directly!
