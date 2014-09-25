Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaIYUsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 16:48:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:33804 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaIYUsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 16:48:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,599,1406617200"; 
   d="scan'208,223";a="596944446"
Date: Thu, 25 Sep 2014 16:47:49 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v11 00/21] Add support for NV-DIMMs to ext4
Message-ID: <20140925204749.GP27730@localhost.localdomain>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 25, 2014 at 04:33:17PM -0400, Matthew Wilcox wrote:
...

For those who want to see what changed beteen v10 and v11, here are the patches
that I applied to my internal git tree.

--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-dax-A-couple-of-fixes-from-Dave-Chinner.patch"

>From e41949f26f9cc492aab17a1b94d030a11c020893 Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <willy@linux.intel.com>
Date: Wed, 10 Sep 2014 13:19:22 -0400
Subject: [PATCH 1/7] dax: A couple of fixes from Dave Chinner

If dax_clear_blocks() returns an error, segfault.

Don't bother calling get_block() again if the BH is unwritten; the block
is already allocated, and this won't help matters.

Call b_end_io() if it's set, after zeroing the block, enabling the fs
to convert the block from unwritten to written.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/dax.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index bdf6622..90418ca 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -327,7 +327,7 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (error)
 		goto unlock_page;
 
-	if (!buffer_written(&bh) && !vmf->cow_page) {
+	if (!buffer_mapped(&bh) && !vmf->cow_page) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
 			error = get_block(inode, block, &bh, 1);
 			count_vm_event(PGMAJFAULT);
@@ -364,8 +364,13 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		return VM_FAULT_LOCKED;
 	}
 
-	if (buffer_unwritten(&bh) || buffer_new(&bh))
-		dax_clear_blocks(inode, bh.b_blocknr, bh.b_size);
+	if (buffer_unwritten(&bh) || buffer_new(&bh)) {
+		error = dax_clear_blocks(inode, bh.b_blocknr, bh.b_size);
+		if (error)
+			goto out;
+		if (bh.b_end_io)
+			bh.b_end_io(&bh, 1);
+	}
 
 	/* Check we didn't race with a read fault installing a new page */
 	if (!page && major)
-- 
2.1.0


--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-dax-Missing-unlock-in-error-path.patch"

>From 9c9739b5942dca1e9238631c1bed48f1b21d8b63 Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <willy@linux.intel.com>
Date: Thu, 11 Sep 2014 12:42:47 -0400
Subject: [PATCH 2/7] dax: Missing unlock in error path

If the file was truncated, we have to drop the i_mmap_mutex before
returning an error.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/dax.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dax.c b/fs/dax.c
index 90418ca..fabe9da 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -357,6 +357,7 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			size = (i_size_read(inode) + PAGE_SIZE - 1) >>
 								PAGE_SHIFT;
 			if (vmf->pgoff >= size) {
+				mutex_unlock(&mapping->i_mmap_mutex);
 				error = -EIO;
 				goto out;
 			}
-- 
2.1.0


--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0003-dax-Must-hold-mutex-while-clearing-blocks.patch"

>From ea8e4473e479bbf66a1caa956214b101b6845855 Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <willy@linux.intel.com>
Date: Thu, 11 Sep 2014 12:44:20 -0400
Subject: [PATCH 3/7] dax: Must hold mutex while clearing blocks

The i_mmap_mutex was not being held across the call to dax_clear_blocks().
That made it possible for a truncate racing with the page fault
to have removed the blocks from the file before the call to
dax_clear_blocks().  If the blocks had been reassigned to some other
purpose, dax_clear_blocks() could end up clearing blocks that had somebody
else's data in them.

dax_do_fault() is getting a little long, so bundle up all this code
into a new dax_insert_mapping() function.  Call clear_page() instead
of dax_clear_blocks(), since we know we're only clearing a single page.
And use bdev_direct_access() instead of dax_get_pfn() since we actually
want both the pfn (for inserting the map) and the address (for clearing
the memory).

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 fs/dax.c | 87 ++++++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 49 insertions(+), 38 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index fabe9da..b130b47 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -68,14 +68,6 @@ static long dax_get_addr(struct buffer_head *bh, void **addr, unsigned blkbits)
 	return bdev_direct_access(bh->b_bdev, sector, addr, &pfn, bh->b_size);
 }
 
-static long dax_get_pfn(struct buffer_head *bh, unsigned long *pfn,
-							unsigned blkbits)
-{
-	void *addr;
-	sector_t sector = bh->b_blocknr << (blkbits - 9);
-	return bdev_direct_access(bh->b_bdev, sector, &addr, pfn, bh->b_size);
-}
-
 static void dax_new_buf(void *addr, unsigned size, unsigned first, loff_t pos,
 			loff_t end)
 {
@@ -283,6 +275,54 @@ static int copy_user_bh(struct page *to, struct buffer_head *bh,
 	return 0;
 }
 
+static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
+			struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct address_space *mapping = inode->i_mapping;
+	sector_t sector = bh->b_blocknr << (inode->i_blkbits - 9);
+	unsigned long vaddr = (unsigned long)vmf->virtual_address;
+	void *addr;
+	unsigned long pfn;
+	pgoff_t size;
+	int error;
+
+	mutex_lock(&mapping->i_mmap_mutex);
+
+	/*
+	 * Check truncate didn't happen while we were allocating a block.
+	 * If it did, this block may or may not be still allocated to the
+	 * file.  We can't tell the filesystem to free it because we can't
+	 * take i_mutex here.  In the worst case, the file still has blocks
+	 * allocated past the end of the file.
+	 */
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (unlikely(vmf->pgoff >= size)) {
+		error = -EIO;
+		goto out;
+	}
+
+	error = bdev_direct_access(bh->b_bdev, sector, &addr, &pfn, bh->b_size);
+	if (error < 0)
+		goto out;
+	if (error < PAGE_SIZE) {
+		error = -EIO;
+		goto out;
+	}
+
+	if (buffer_unwritten(bh) || buffer_new(bh)) {
+		clear_page(addr);
+		if (bh->b_end_io)
+			bh->b_end_io(bh, 1);
+	}
+
+	error = vm_insert_mixed(vma, vaddr, pfn);
+
+ out:
+	mutex_unlock(&mapping->i_mmap_mutex);
+
+	return error;
+}
+
 static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			get_block_t get_block)
 {
@@ -295,7 +335,6 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	unsigned blkbits = inode->i_blkbits;
 	sector_t block;
 	pgoff_t size;
-	unsigned long pfn;
 	int error;
 	int major = 0;
 
@@ -365,14 +404,6 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		return VM_FAULT_LOCKED;
 	}
 
-	if (buffer_unwritten(&bh) || buffer_new(&bh)) {
-		error = dax_clear_blocks(inode, bh.b_blocknr, bh.b_size);
-		if (error)
-			goto out;
-		if (bh.b_end_io)
-			bh.b_end_io(&bh, 1);
-	}
-
 	/* Check we didn't race with a read fault installing a new page */
 	if (!page && major)
 		page = find_lock_page(mapping, vmf->pgoff);
@@ -385,27 +416,7 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		page_cache_release(page);
 	}
 
-	mutex_lock(&mapping->i_mmap_mutex);
-
-	/*
-	 * Check truncate didn't happen while we were allocating a block.
-	 * If it did, this block may or may not be still allocated to the
-	 * file.  We can't tell the filesystem to free it because we can't
-	 * take i_mutex here.  In the worst case, the file still has blocks
-	 * allocated past the end of the file.
-	 */
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (unlikely(vmf->pgoff >= size)) {
-		mutex_unlock(&mapping->i_mmap_mutex);
-		error = -EIO;
-		goto out;
-	}
-
-	error = dax_get_pfn(&bh, &pfn, blkbits);
-	if (error > 0)
-		error = vm_insert_mixed(vma, vaddr, pfn);
-
-	mutex_unlock(&mapping->i_mmap_mutex);
+	error = dax_insert_mapping(inode, &bh, vma, vmf);
 
  out:
 	if (error == -ENOMEM)
-- 
2.1.0


--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0004-dax-Unwritten-extents-don-t-set-the-mapped-flag.patch"

>From 9daf54382b53f3cffc3f050d75edf43e3c51efb4 Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <willy@linux.intel.com>
Date: Wed, 24 Sep 2014 13:53:24 -0400
Subject: [PATCH 4/7] dax: Unwritten extents don't set the mapped flag

Despite an unwritten extent having a defined mapping, buffer_mapped()
returns false.  We don't need to call get_block() again here, since
we know wat the disk block is that corresponds to this file offset.
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index b130b47..59be664 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -366,7 +366,7 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (error)
 		goto unlock_page;
 
-	if (!buffer_mapped(&bh) && !vmf->cow_page) {
+	if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
 			error = get_block(inode, block, &bh, 1);
 			count_vm_event(PGMAJFAULT);
-- 
2.1.0


--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0005-ext4-Add-a-callback-to-convert-unwritten-extents.patch"

>From 96f051597cfd91fe51a30fc3dbdeed290b98d7fe Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <willy@linux.intel.com>
Date: Wed, 24 Sep 2014 14:02:38 -0400
Subject: [PATCH 5/7] ext4: Add a callback to convert unwritten extents

A different bug was masking the problem that unwritten extents need to
be converted to written extents once we've faulted them into existence.
Following the XFS example, add a b_end_io callback.  We "borrow" a few
additional fields in the buffer_head, but there aren't any big enough
for a sector_t.  Fortunately, we only use this callback for DAX, and
ext4 already requires a 4k block size for using DAX, which puts the
limit at 16TB.  The page cache already limits file sizes to 16TB on
32-bit systems, so we don't need to grow any fields.
---
 fs/ext4/inode.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5edd903..eaa293a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -676,6 +676,18 @@ has_zeroout:
 	return retval;
 }
 
+static void ext4_end_io_unwritten(struct buffer_head *bh, int uptodate)
+{
+	struct inode *inode = bh->b_assoc_map->host;
+	/* XXX: breaks on 32-bit > 16GB. Is that even supported? */
+	loff_t offset = (loff_t)(uintptr_t)bh->b_private << inode->i_blkbits;
+	int err;
+	if (!uptodate)
+		return;
+	WARN_ON(!buffer_unwritten(bh));
+	err = ext4_convert_unwritten_extents(NULL, inode, offset, bh->b_size);
+}
+
 /* Maximum number of blocks we map for direct IO at once. */
 #define DIO_MAX_BLOCKS 4096
 
@@ -713,6 +725,11 @@ static int _ext4_get_block(struct inode *inode, sector_t iblock,
 
 		map_bh(bh, inode->i_sb, map.m_pblk);
 		bh->b_state = (bh->b_state & ~EXT4_MAP_FLAGS) | map.m_flags;
+		if (IS_DAX(inode) && buffer_unwritten(bh) && !io_end) {
+			bh->b_assoc_map = inode->i_mapping;
+			bh->b_private = (void *)(unsigned long)iblock;
+			bh->b_end_io = ext4_end_io_unwritten;
+		}
 		if (io_end && io_end->flag & EXT4_IO_END_UNWRITTEN)
 			set_buffer_defer_completion(bh);
 		bh->b_size = inode->i_sb->s_blocksize * map.m_len;
-- 
2.1.0


--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0006-vfs-Prevent-DAX-I-Os-from-falling-back-to-buffered-I.patch"

>From b73ccea0e0bb4f09fa4ad0a4fa20f6d346bedf50 Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <willy@linux.intel.com>
Date: Wed, 24 Sep 2014 14:08:40 -0400
Subject: [PATCH 6/7] vfs: Prevent DAX I/Os from falling back to buffered I/O

Unlike regular direct I/O, DAX will handle file holes, and there is
no desire to fall back to buffered I/O.  Buffered I/O ought to fail if
DAX I/O fails, unless we're doing a random-failure test.  So skip the
buffered I/O attempts for DAX files.
---
 mm/filemap.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 19bdb68..e69b586 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1717,9 +1717,11 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		 * we've already read everything we wanted to, or if
 		 * there was a short read because we hit EOF, go ahead
 		 * and return.  Otherwise fallthrough to buffered io for
-		 * the rest of the read.
+		 * the rest of the read.  Buffered reads will not work for
+		 * DAX files, so don't bother trying.
 		 */
-		if (retval < 0 || !iov_iter_count(iter) || *ppos >= size) {
+		if (retval < 0 || !iov_iter_count(iter) || *ppos >= size ||
+		    IS_DAX(inode)) {
 			file_accessed(file);
 			goto out;
 		}
@@ -2582,13 +2584,16 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		loff_t endbyte;
 
 		written = generic_file_direct_write(iocb, from, pos);
-		if (written < 0 || written == count)
-			goto out;
-
 		/*
-		 * direct-io write to a hole: fall through to buffered I/O
-		 * for completing the rest of the request.
+		 * If the write stopped short of completing, fall back to
+		 * buffered writes.  Some filesystems do this for writes to
+		 * holes, for example.  For DAX files, a buffered write will
+		 * not succeed (even if it did, DAX does not handle dirty
+		 * page-cache pages correctly).
 		 */
+		if (written < 0 || written == count || IS_DAX(inode))
+			goto out;
+
 		pos += written;
 		count -= written;
 
-- 
2.1.0


--cNdxnHkX5QqsyA0e
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0007-dax-Call-b_end_io-outside-the-i_mmap_mutex.patch"

>From 953153c75704a3954052b68c63b4cc3ad15b7a06 Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <willy@linux.intel.com>
Date: Wed, 24 Sep 2014 14:27:57 -0400
Subject: [PATCH 7/7] dax: Call b_end_io outside the i_mmap_mutex

Lockdep helpfully points out that ext4_convert_unwritten_extents will
start a jbd transaction, and i_mmap_mutex is already nested inside the
jbd2_handle lock.  So move the call to b_end_io to after we drop the
i_mmap_mutex; this only extends the window in which we can crash and
the allocation will be lost; it does not introduce any new races.
---
 fs/dax.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 59be664..91b7561 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -309,17 +309,17 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 		goto out;
 	}
 
-	if (buffer_unwritten(bh) || buffer_new(bh)) {
+	if (buffer_unwritten(bh) || buffer_new(bh))
 		clear_page(addr);
-		if (bh->b_end_io)
-			bh->b_end_io(bh, 1);
-	}
 
 	error = vm_insert_mixed(vma, vaddr, pfn);
 
  out:
 	mutex_unlock(&mapping->i_mmap_mutex);
 
+	if (bh->b_end_io)
+		bh->b_end_io(bh, 1);
+
 	return error;
 }
 
-- 
2.1.0


--cNdxnHkX5QqsyA0e--
