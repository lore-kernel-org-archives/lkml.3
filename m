Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbbALTOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:14:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57376 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbbALSFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 015/216] writeback: fix a subtle race condition in I_DIRTY clearing
Date: Mon, 12 Jan 2015 18:02:12 +0000
Message-Id: <1421085933-32536-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 9c6ac78eb3521c5937b2dd8a7d1b300f41092f45 upstream.

After invoking ->dirty_inode(), __mark_inode_dirty() does smp_mb() and
tests inode->i_state locklessly to see whether it already has all the
necessary I_DIRTY bits set.  The comment above the barrier doesn't
contain any useful information - memory barriers can't ensure "changes
are seen by all cpus" by itself.

And it sure enough was broken.  Please consider the following
scenario.

 CPU 0					CPU 1
 -------------------------------------------------------------------------------

					enters __writeback_single_inode()
					grabs inode->i_lock
					tests PAGECACHE_TAG_DIRTY which is clear
 enters __set_page_dirty()
 grabs mapping->tree_lock
 sets PAGECACHE_TAG_DIRTY
 releases mapping->tree_lock
 leaves __set_page_dirty()

 enters __mark_inode_dirty()
 smp_mb()
 sees I_DIRTY_PAGES set
 leaves __mark_inode_dirty()
					clears I_DIRTY_PAGES
					releases inode->i_lock

Now @inode has dirty pages w/ I_DIRTY_PAGES clear.  This doesn't seem
to lead to an immediately critical problem because requeue_inode()
later checks PAGECACHE_TAG_DIRTY instead of I_DIRTY_PAGES when
deciding whether the inode needs to be requeued for IO and there are
enough unintentional memory barriers inbetween, so while the inode
ends up with inconsistent I_DIRTY_PAGES flag, it doesn't fall off the
IO list.

The lack of explicit barrier may also theoretically affect the other
I_DIRTY bits which deal with metadata dirtiness.  There is no
guarantee that a strong enough barrier exists between
I_DIRTY_[DATA]SYNC clearing and write_inode() writing out the dirtied
inode.  Filesystem inode writeout path likely has enough stuff which
can behave as full barrier but it's theoretically possible that the
writeout may not see all the updates from ->dirty_inode().

Fix it by adding an explicit smp_mb() after I_DIRTY clearing.  Note
that I_DIRTY_PAGES needs a special treatment as it always needs to be
cleared to be interlocked with the lockless test on
__mark_inode_dirty() side.  It's cleared unconditionally and
reinstated after smp_mb() if the mapping still has dirty pages.

Also add comments explaining how and why the barriers are paired.

Lightly tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/fs-writeback.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index be568b7311d6..cd4fd8aa3c80 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -478,12 +478,28 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	 * write_inode()
 	 */
 	spin_lock(&inode->i_lock);
-	/* Clear I_DIRTY_PAGES if we've written out all dirty pages */
-	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
-		inode->i_state &= ~I_DIRTY_PAGES;
+
 	dirty = inode->i_state & I_DIRTY;
-	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
+	inode->i_state &= ~I_DIRTY;
+
+	/*
+	 * Paired with smp_mb() in __mark_inode_dirty().  This allows
+	 * __mark_inode_dirty() to test i_state without grabbing i_lock -
+	 * either they see the I_DIRTY bits cleared or we see the dirtied
+	 * inode.
+	 *
+	 * I_DIRTY_PAGES is always cleared together above even if @mapping
+	 * still has dirty pages.  The flag is reinstated after smp_mb() if
+	 * necessary.  This guarantees that either __mark_inode_dirty()
+	 * sees clear I_DIRTY_PAGES or we see PAGECACHE_TAG_DIRTY.
+	 */
+	smp_mb();
+
+	if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
+		inode->i_state |= I_DIRTY_PAGES;
+
 	spin_unlock(&inode->i_lock);
+
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
 		int err = write_inode(inode, wbc);
@@ -1147,12 +1163,11 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	}
 
 	/*
-	 * make sure that changes are seen by all cpus before we test i_state
-	 * -- mikulas
+	 * Paired with smp_mb() in __writeback_single_inode() for the
+	 * following lockless i_state test.  See there for details.
 	 */
 	smp_mb();
 
-	/* avoid the locking if we can */
 	if ((inode->i_state & flags) == flags)
 		return;
 
-- 
2.1.4

