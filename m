Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaFAVlI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 17:41:08 -0400
Received: from mail.phunq.net ([184.71.0.62]:47822 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaFAVlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 17:41:07 -0400
Message-ID: <538B9DEE.20800@phunq.net>
Date: Sun, 01 Jun 2014 14:41:02 -0700
From: Daniel Phillips <daniel@phunq.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [RFC][PATCH 1/2] Add a super operation for writeback
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the first of four core changes we would like for Tux3. We
start with a hard one and suggest a simple solution.

The first patch in this series adds a new super operation to write
back multiple inodes in a single call. The second patch applies to
our linux-tux3 repository at git.kernel.org to demonstrate how this
interface is used, and removes about 450 lines of workaround code.

Traditionally, core kernel tells each mounted filesystems which
dirty pages of which inodes should be flushed to disk, but
unfortunately, is blissfully ignorant of filesystem-specific
ordering constraints. This scheme was really invented for Ext2 and
has not evolved much recently. Tux3, with its strong ordering and
optimized delta commit, cannot tolerate random flushing and
therefore takes responsibility for flush ordering itself. On the
other hand, Tux3 has no good way to know when is the right time to
flush, but core is good at that. This proposed API harmonizes those
two competencies so that Tux3 and core each take care of what they
are good at, and not more.

The API extension consists of a new writeback hook and two helpers
to be uses within the hook. The hook sits about halfway down the
fs-writeback stack, just after core has determined that some dirty
inodes should be flushed to disk and just before it starts thinking
about which inodes those should be. At that point, core calls Tux3
instead of continuing on down the usual do_writepages path. Tux3
responds by staging a new delta commit, using the new helpers to
tell core which inodes were flushed versus being left dirty in
cache. This is pretty much the same behavior as the traditional
writeout path, but less convoluted, probably more efficient, and
certainly easier to analyze.

The new writeback hook looks like:

    progress = sb->s_op->writeback(sb, &writeback_control, &nr_pages);

This should be self-explanatory: nr_pages and progress have the
semantics of existing usage in fs-writeback; writeback_control is
ignored by Tux3, but that is only because Tux3 always flushes
everything and does not require hints for now. We can safely assume
that &wbc or equivalent is wanted here. An obvious wart is the
overlap between "progress" and "nr_pages", but fs-writeback thinks
that way, so it would not make much sense to improve one without
improving the other.

Tux3 necessarily keeps its own dirty inode list, which is an area
of overlap with fs-writeback. In a perfect world, there would be
just one dirty inode list per superblock, on which both fs-writeback
and Tux3 would operate. That would be a deeper core change than
seems appropriate right now.

Potential races are a big issue with this API, which is no surprise.
The fs-writeback scheme requires keeping several kinds of object in
sync: tux3 dirty inode lists, fs-writeback dirty inode lists and
inode dirty state. The new helpers inode_writeback_done(inode) and
inode_writeback_touch(inode) take care of that while hiding
internal details of the fs-writeback implementation.

Tux3 calls inode_writeback_done when it has flushed an inode and
marked it clean, or calls inode_writeback_touch if it intends to
retain a dirty inode in cache. These have simple implementations.
The former just removes a clean inode from any fs-writeback list.
The latter updates the inode's dirty timestamp so that fs-writeback
does not keep trying flush it. Both these things could be done more
efficiently by re-engineering fs-writeback, but we prefer to work
with the existing scheme for now.

Hirofumi's masterful hack nicely avoided racy removal of inodes from
the writeback list by taking an internal fs-writeback lock inside
filesystem code. The new helper requires dropping i_lock inside
filesystem code and retaking it in the helper, so inode redirty can
race with writeback list removal. This does not seem to present a
problem because filesystem code is able to enforce strict
alternation of cleaning and calling the helper. As an offsetting
advantage, writeback lock contention is reduced.

Compared to Hirofumi's hack, the cost of this interface is one
additional spinlock per inode_writeback_done,  which is
insignificant compared to the convoluted code path that is avoided.
Regards,

Daniel

---
From: Daniel Phillips <daniel@tux3.org>
Subject: [PATCH] Add a super operation for writeback

Add a "writeback" super operation to be called in the
form:

        progress = sb->s_op->writeback(sb, &wbc, &pages);

The filesystem is expected to flush some inodes to disk
and return progress of at least 1, or if no inodes are
flushed, return progress of zero. The filesystem should
try to flush at least the number of pages specified in
*pages, or if that is not possible, return approximately
the number of pages not flushed into *pages.

Within the ->writeback callback, the filesystem should
call inode_writeback_done(inode) for each inode flushed
(and therefore set clean) or inode_writeback_touch(inode)
for any inode that will be retained dirty in cache.

Signed-off-by: Daniel Phillips  <daniel@tux3.org>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fs-writeback.c  |   59 +++++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/fs.h |    4 +++
 2 files changed, 60 insertions(+), 3 deletions(-)

diff -puN fs/fs-writeback.c~core-writeback fs/fs-writeback.c
--- linux-tux3/fs/fs-writeback.c~core-writeback	2014-05-31 06:43:19.416031712 +0900
+++ linux-tux3-hirofumi/fs/fs-writeback.c	2014-05-31 06:44:46.087904373 +0900
@@ -192,6 +192,35 @@ void inode_wb_list_del(struct inode *ino
 }

 /*
+ * Remove inode from writeback list if clean.
+ */
+void inode_writeback_done(struct inode *inode)
+{
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
+
+	spin_lock(&bdi->wb.list_lock);
+	spin_lock(&inode->i_lock);
+	if (!(inode->i_state & I_DIRTY))
+		list_del_init(&inode->i_wb_list);
+	spin_unlock(&inode->i_lock);
+	spin_unlock(&bdi->wb.list_lock);
+}
+EXPORT_SYMBOL_GPL(inode_writeback_done);
+
+/*
+ * Add inode to writeback dirty list with current time.
+ */
+void inode_writeback_touch(struct inode *inode)
+{
+	struct backing_dev_info *bdi = inode->i_sb->s_bdi;
+	spin_lock(&bdi->wb.list_lock);
+	inode->dirtied_when = jiffies;
+	list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
+	spin_unlock(&bdi->wb.list_lock);
+}
+EXPORT_SYMBOL_GPL(inode_writeback_touch);
+
+/*
  * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
  * furthest end of its superblock's dirty-inode list.
  *
@@ -593,9 +622,9 @@ static long writeback_chunk_size(struct
  *
  * Return the number of pages and/or inodes written.
  */
-static long writeback_sb_inodes(struct super_block *sb,
-				struct bdi_writeback *wb,
-				struct wb_writeback_work *work)
+static long __writeback_sb_inodes(struct super_block *sb,
+				  struct bdi_writeback *wb,
+				  struct wb_writeback_work *work)
 {
 	struct writeback_control wbc = {
 		.sync_mode		= work->sync_mode,
@@ -710,6 +739,30 @@ static long writeback_sb_inodes(struct s
 	return wrote;
 }

+static long writeback_sb_inodes(struct super_block *sb,
+				struct bdi_writeback *wb,
+				struct wb_writeback_work *work)
+{
+	if (sb->s_op->writeback) {
+		struct writeback_control wbc = {
+			.sync_mode		= work->sync_mode,
+			.tagged_writepages	= work->tagged_writepages,
+			.for_kupdate		= work->for_kupdate,
+			.for_background		= work->for_background,
+			.for_sync		= work->for_sync,
+			.range_cyclic		= work->range_cyclic,
+		};
+		long ret;
+
+		spin_unlock(&wb->list_lock);
+		ret = sb->s_op->writeback(sb, &wbc, &work->nr_pages);
+		spin_lock(&wb->list_lock);
+		return ret;
+	}
+
+	return __writeback_sb_inodes(sb, wb, work);
+}
+
 static long __writeback_inodes_wb(struct bdi_writeback *wb,
 				  struct wb_writeback_work *work)
 {
diff -puN include/linux/fs.h~core-writeback include/linux/fs.h
--- linux-tux3/include/linux/fs.h~core-writeback	2014-05-31 06:43:19.436031682 +0900
+++ linux-tux3-hirofumi/include/linux/fs.h	2014-05-31 06:48:41.619558001 +0900
@@ -1536,6 +1536,8 @@ struct super_operations {
 	int (*drop_inode) (struct inode *);
 	void (*evict_inode) (struct inode *);
 	void (*put_super) (struct super_block *);
+	long (*writeback)(struct super_block *super,
+			  struct writeback_control *wbc, long *nr_pages);
 	int (*sync_fs)(struct super_block *sb, int wait);
 	int (*freeze_fs) (struct super_block *);
 	int (*unfreeze_fs) (struct super_block *);
@@ -1737,6 +1739,8 @@ static inline void file_accessed(struct
 		touch_atime(&file->f_path);
 }

+void inode_writeback_done(struct inode *inode);
+void inode_writeback_touch(struct inode *inode);
 int sync_inode(struct inode *inode, struct writeback_control *wbc);
 int sync_inode_metadata(struct inode *inode, int wait);


