Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaIQOt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:49:29 -0400
Received: from kanga.kvack.org ([205.233.56.17]:45768 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbaIQOt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:49:27 -0400
Date: Wed, 17 Sep 2014 10:49:25 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, Andreas Dilger <adilger@dilger.ca>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [RFC 1/2] aio: async readahead
Message-ID: <20140917144925.GU24821@kvack.org>
References: <cover.1410810247.git.milosz@adfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1410810247.git.milosz@adfin.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milosz et al,

This code is probably relevant to the non-blocking read thread.  A 
non-blocking read is pretty useless without some way to trigger and 
become aware of data being read into the page cache, and the attached 
patch is one way to do so.

The changes below introduce an async readahead operation that is based 
on readpage (sorry, I haven't done an mpage version of this code yet).  
Please note that this code was written against an older kernel (3.4) 
and hasn't been extensively tested against recent kernels, so there may 
be a few bugs lingering.  That said, the code has been enabled in our 
internal kernel at Solace Systems for a few months now with no reported 
issues.

There is a companion patch to make ext3's readpage operation use async 
metadata reads that will follow.  A test program that uses the new readhead 
operation can be found at http://www.kvack.org/~bcrl/aio-readahead.c .

		-ben
-- 
"Thought is the essence of where you are now."

 fs/aio.c                     |  220 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pagemap.h      |    2 
 include/uapi/linux/aio_abi.h |    2 
 mm/filemap.c                 |    2 
 4 files changed, 225 insertions(+), 1 deletion(-)
diff --git a/fs/aio.c b/fs/aio.c
index 7337500..f1c0f74 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -46,6 +46,8 @@
 
 #include "internal.h"
 
+static long aio_readahead(struct kiocb *iocb);
+
 #define AIO_RING_MAGIC			0xa10a10a1
 #define AIO_RING_COMPAT_FEATURES	1
 #define AIO_RING_INCOMPAT_FEATURES	0
@@ -1379,6 +1381,12 @@ static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
 		iter_op	= file->f_op->read_iter;
 		goto rw_common;
 
+	case IOCB_CMD_READAHEAD:
+		ret = -EBADF;
+		if (unlikely(!(file->f_mode & FMODE_READ)))
+			break;
+		return aio_readahead(req);
+
 	case IOCB_CMD_PWRITE:
 	case IOCB_CMD_PWRITEV:
 		mode	= FMODE_WRITE;
@@ -1710,3 +1718,215 @@ SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 	}
 	return ret;
 }
+
+/* for readahead */
+struct readahead_state;
+struct readahead_pginfo {
+	struct wait_bit_queue		wait_bit;
+	struct page			*page;
+};
+
+struct readahead_state {
+	struct kiocb			*iocb;
+	unsigned			nr_pages;
+	atomic_t			nr_pages_reading;
+
+	struct readahead_pginfo	pginfo[];
+};
+
+static void aio_readahead_complete(struct readahead_state *state)
+{
+	unsigned i, nr_uptodate = 0;
+	struct kiocb *iocb;
+	long res;
+	if (!atomic_dec_and_test(&state->nr_pages_reading))
+		return;
+	for (i = 0; i < state->nr_pages; i++) {
+		struct page *page = state->pginfo[i].page;
+
+		if (PageUptodate(page))
+			nr_uptodate++;
+		page_cache_release(page);
+	}
+	iocb = state->iocb;
+	if (nr_uptodate == state->nr_pages) {
+		res = iocb->ki_nbytes;
+	} else
+		res = -EIO;
+	kfree(state);
+	aio_complete(iocb, res, 0);
+}
+
+static int pginfo_wait_func(wait_queue_t *wait, unsigned mode, int flags,
+			    void *arg)
+{
+	struct readahead_state *state = wait->private;
+	struct readahead_pginfo *pginfo;
+	struct wait_bit_key *key = arg;
+	unsigned idx;
+
+	pginfo = container_of(wait, struct readahead_pginfo, wait_bit.wait);
+	idx = pginfo - state->pginfo;
+	BUG_ON(idx >= state->nr_pages);
+
+	if (pginfo->wait_bit.key.flags != key->flags ||
+	    pginfo->wait_bit.key.bit_nr != key->bit_nr ||
+	    test_bit(key->bit_nr, key->flags))
+		return 0;
+	list_del_init(&wait->task_list);
+	aio_readahead_complete(state);
+	return 1;
+}
+
+static void pginfo_wait_on_page(struct readahead_state *state,
+				struct readahead_pginfo *pginfo)
+{
+	struct page *page = pginfo->page;
+	wait_queue_head_t *wq;
+	unsigned long flags;
+	int ret;
+
+	pginfo->wait_bit.key.flags = &page->flags;
+	pginfo->wait_bit.key.bit_nr = PG_locked;
+	pginfo->wait_bit.wait.private = state;
+	pginfo->wait_bit.wait.func = pginfo_wait_func;
+	
+	page = pginfo->page;
+	wq = page_waitqueue(page);
+	atomic_inc(&state->nr_pages_reading);
+
+	spin_lock_irqsave(&wq->lock, flags);
+	__add_wait_queue(wq, &pginfo->wait_bit.wait);
+	if (!PageLocked(page))
+		ret = pginfo_wait_func(&pginfo->wait_bit.wait, 0, 0,
+				       &pginfo->wait_bit.key);
+	spin_unlock_irqrestore(&wq->lock, flags);
+}
+
+
+/*
+ * __do_page_cache_readahead() actually reads a chunk of disk.  It allocates all
+ * the pages first, then submits them all for I/O. This avoids the very bad
+ * behaviour which would occur if page allocations are causing VM writeback.
+ * We really don't want to intermingle reads and writes like that.
+ *
+ * Returns the number of pages requested, or the maximum amount of I/O allowed.
+ */
+static int
+__do_page_cache_readahead(struct address_space *mapping, struct file *filp,
+			pgoff_t offset, unsigned long nr_to_read,
+			unsigned long lookahead_size,
+			struct readahead_state *state)
+{
+	struct inode *inode = mapping->host;
+	struct page *page;
+	unsigned long end_index;	/* The last page we want to read */
+	LIST_HEAD(page_pool);
+	int page_idx;
+	int ret = 0;
+	loff_t isize = i_size_read(inode);
+
+	if (isize == 0)
+		goto out;
+
+	end_index = ((isize - 1) >> PAGE_CACHE_SHIFT);
+
+	/*
+	 * Preallocate as many pages as we will need.
+	 */
+	for (page_idx = 0; page_idx < nr_to_read; page_idx++) {
+		pgoff_t page_offset = offset + page_idx;
+		struct readahead_pginfo *pginfo = &state->pginfo[page_idx];
+		int locked = 0;
+
+		if (page_offset > end_index)
+			break;
+
+		init_waitqueue_func_entry(&pginfo->wait_bit.wait,
+					  pginfo_wait_func);
+find_page:
+		page = find_get_page(mapping, page_offset);
+		if (!page) {
+			int err;
+			page = page_cache_alloc_cold(mapping);
+			err = add_to_page_cache_lru(page, mapping,
+						    page_offset,
+						    GFP_KERNEL);
+			if (err)
+				page_cache_release(page);
+			if (err == -EEXIST)
+				goto find_page;
+			if (err)
+				break;
+			locked = 1;
+		}
+		if (!page)
+			break;
+
+		ret++;
+		state->nr_pages++;
+		pginfo->page = page;
+		if (!locked && PageUptodate(page))
+			continue;
+		if (locked || trylock_page(page)) {
+			if (PageUptodate(page)) {
+				unlock_page(page);
+				continue;
+			}
+			pginfo_wait_on_page(state, pginfo);
+
+			/* Ignoring the return code from readpage here is
+			 * safe, as the readpage() operation will unlock
+			 * the page and thus kick our state machine.
+			 */
+			mapping->a_ops->readpage(filp, page);
+			continue;
+		}
+		pginfo_wait_on_page(state, pginfo);
+	}
+
+out:
+	return ret;
+}
+
+static long aio_readahead(struct kiocb *iocb)
+{
+	struct file *filp = iocb->ki_filp;
+	struct readahead_state *state;
+	pgoff_t start, end;
+	unsigned nr_pages;
+	int ret;
+
+	if (!filp->f_mapping || !filp->f_mapping->a_ops ||
+	    !filp->f_mapping->a_ops->readpage)
+		return -EINVAL;
+
+	if (iocb->ki_nbytes == 0) {
+		aio_complete(iocb, 0, 0);
+		return 0;
+	}
+
+	start = iocb->ki_pos >> PAGE_CACHE_SHIFT;
+	end = (iocb->ki_pos + iocb->ki_nbytes - 1) >> PAGE_CACHE_SHIFT;
+	nr_pages = 1 + end - start;
+
+	state = kzalloc(sizeof(*state) +
+			nr_pages * sizeof(struct readahead_pginfo),
+			GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	state->iocb = iocb;
+	atomic_set(&state->nr_pages_reading, 1);
+
+	ret = __do_page_cache_readahead(filp->f_mapping, filp, start, nr_pages,
+					0, state);
+	if (ret <= 0) {
+		kfree(state);
+		aio_complete(iocb, 0, 0);
+		return 0;
+	}
+
+	aio_readahead_complete(state);	// Drops ref of 1 from nr_pages_reading
+	return 0;
+}
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
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index bb2554f..11723c53 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -44,6 +44,8 @@ enum {
 	IOCB_CMD_NOOP = 6,
 	IOCB_CMD_PREADV = 7,
 	IOCB_CMD_PWRITEV = 8,
+
+	IOCB_CMD_READAHEAD = 12,
 };
 
 /*
diff --git a/mm/filemap.c b/mm/filemap.c
index 90effcd..3368b73 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -670,7 +670,7 @@ EXPORT_SYMBOL(__page_cache_alloc);
  * at a cost of "thundering herd" phenomena during rare hash
  * collisions.
  */
-static wait_queue_head_t *page_waitqueue(struct page *page)
+wait_queue_head_t *page_waitqueue(struct page *page)
 {
 	const struct zone *zone = page_zone(page);
 
