Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbaAFXjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:39:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaAFWkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 141/144] aio: clean up and fix aio_setup_ring page mapping
Date: Mon,  6 Jan 2014 14:38:22 -0800
Message-Id: <20140106223749.389483507@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 3dc9acb67600393249a795934ccdfc291a200e6b upstream.

Since commit 36bc08cc01709 ("fs/aio: Add support to aio ring pages
migration") the aio ring setup code has used a special per-ring backing
inode for the page allocations, rather than just using random anonymous
pages.

However, rather than remembering the pages as it allocated them, it
would allocate the pages, insert them into the file mapping (dirty, so
that they couldn't be free'd), and then forget about them.  And then to
look them up again, it would mmap the mapping, and then use
"get_user_pages()" to get back an array of the pages we just created.

Now, not only is that incredibly inefficient, it also leaked all the
pages if the mmap failed (which could happen due to excessive number of
mappings, for example).

So clean it all up, making it much more straightforward.  Also remove
some left-overs of the previous (broken) mm_populate() usage that was
removed in commit d6c355c7dabc ("aio: fix race in ring buffer page
lookup introduced by page migration support") but left the pointless and
now misleading MAP_POPULATE flag around.

Tested-and-acked-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |   58 +++++++++++++++++++++++-----------------------------------
 1 file changed, 23 insertions(+), 35 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -326,7 +326,7 @@ static int aio_setup_ring(struct kioctx
 	struct aio_ring *ring;
 	unsigned nr_events = ctx->max_reqs;
 	struct mm_struct *mm = current->mm;
-	unsigned long size, populate;
+	unsigned long size, unused;
 	int nr_pages;
 	int i;
 	struct file *file;
@@ -347,6 +347,20 @@ static int aio_setup_ring(struct kioctx
 		return -EAGAIN;
 	}
 
+	ctx->aio_ring_file = file;
+	nr_events = (PAGE_SIZE * nr_pages - sizeof(struct aio_ring))
+			/ sizeof(struct io_event);
+
+	ctx->ring_pages = ctx->internal_pages;
+	if (nr_pages > AIO_RING_PAGES) {
+		ctx->ring_pages = kcalloc(nr_pages, sizeof(struct page *),
+					  GFP_KERNEL);
+		if (!ctx->ring_pages) {
+			put_aio_ring_file(ctx);
+			return -ENOMEM;
+		}
+	}
+
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page;
 		page = find_or_create_page(file->f_inode->i_mapping,
@@ -358,19 +372,14 @@ static int aio_setup_ring(struct kioctx
 		SetPageUptodate(page);
 		SetPageDirty(page);
 		unlock_page(page);
+
+		ctx->ring_pages[i] = page;
 	}
-	ctx->aio_ring_file = file;
-	nr_events = (PAGE_SIZE * nr_pages - sizeof(struct aio_ring))
-			/ sizeof(struct io_event);
+	ctx->nr_pages = i;
 
-	ctx->ring_pages = ctx->internal_pages;
-	if (nr_pages > AIO_RING_PAGES) {
-		ctx->ring_pages = kcalloc(nr_pages, sizeof(struct page *),
-					  GFP_KERNEL);
-		if (!ctx->ring_pages) {
-			put_aio_ring_file(ctx);
-			return -ENOMEM;
-		}
+	if (unlikely(i != nr_pages)) {
+		aio_free_ring(ctx);
+		return -EAGAIN;
 	}
 
 	ctx->mmap_size = nr_pages * PAGE_SIZE;
@@ -379,9 +388,9 @@ static int aio_setup_ring(struct kioctx
 	down_write(&mm->mmap_sem);
 	ctx->mmap_base = do_mmap_pgoff(ctx->aio_ring_file, 0, ctx->mmap_size,
 				       PROT_READ | PROT_WRITE,
-				       MAP_SHARED | MAP_POPULATE, 0, &populate);
+				       MAP_SHARED, 0, &unused);
+	up_write(&mm->mmap_sem);
 	if (IS_ERR((void *)ctx->mmap_base)) {
-		up_write(&mm->mmap_sem);
 		ctx->mmap_size = 0;
 		aio_free_ring(ctx);
 		return -EAGAIN;
@@ -389,27 +398,6 @@ static int aio_setup_ring(struct kioctx
 
 	pr_debug("mmap address: 0x%08lx\n", ctx->mmap_base);
 
-	/* We must do this while still holding mmap_sem for write, as we
-	 * need to be protected against userspace attempting to mremap()
-	 * or munmap() the ring buffer.
-	 */
-	ctx->nr_pages = get_user_pages(current, mm, ctx->mmap_base, nr_pages,
-				       1, 0, ctx->ring_pages, NULL);
-
-	/* Dropping the reference here is safe as the page cache will hold
-	 * onto the pages for us.  It is also required so that page migration
-	 * can unmap the pages and get the right reference count.
-	 */
-	for (i = 0; i < ctx->nr_pages; i++)
-		put_page(ctx->ring_pages[i]);
-
-	up_write(&mm->mmap_sem);
-
-	if (unlikely(ctx->nr_pages != nr_pages)) {
-		aio_free_ring(ctx);
-		return -EAGAIN;
-	}
-
 	ctx->user_id = ctx->mmap_base;
 	ctx->nr_events = nr_events; /* trusted copy */
 


