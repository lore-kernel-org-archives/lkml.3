Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaLEXjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:39:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbaLEWqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Patrick Schmid <schmid@phys.ethz.ch>
Subject: [PATCH 3.17 068/122] btrfs: fix lockups from btrfs_clear_path_blocking
Date: Fri,  5 Dec 2014 14:44:02 -0800
Message-Id: <20141205223315.951579838@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit f82c458a2c3ffb94b431fc6ad791a79df1b3713e upstream.

The fair reader/writer locks mean that btrfs_clear_path_blocking needs
to strictly follow lock ordering rules even when we already have
blocking locks on a given path.

Before we can clear a blocking lock on the path, we need to make sure
all of the locks have been converted to blocking.  This will remove lock
inversions against anyone spinning in write_lock() against the buffers
we're trying to get read locks on.  These inversions didn't exist before
the fair read/writer locks, but now we need to be more careful.

We papered over this deadlock in the past by changing
btrfs_try_read_lock() to be a true trylock against both the spinlock and
the blocking lock.  This was slower, and not sufficient to fix all the
deadlocks.  This patch adds a btrfs_tree_read_lock_atomic(), which
basically means get the spinlock but trylock on the blocking lock.

Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
Reported-by: Patrick Schmid <schmid@phys.ethz.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.c   |   14 ++------------
 fs/btrfs/locking.c |   24 +++++++++++++++++++++---
 fs/btrfs/locking.h |    2 ++
 3 files changed, 25 insertions(+), 15 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -80,13 +80,6 @@ noinline void btrfs_clear_path_blocking(
 {
 	int i;
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	/* lockdep really cares that we take all of these spinlocks
-	 * in the right order.  If any of the locks in the path are not
-	 * currently blocking, it is going to complain.  So, make really
-	 * really sure by forcing the path to blocking before we clear
-	 * the path blocking.
-	 */
 	if (held) {
 		btrfs_set_lock_blocking_rw(held, held_rw);
 		if (held_rw == BTRFS_WRITE_LOCK)
@@ -95,7 +88,6 @@ noinline void btrfs_clear_path_blocking(
 			held_rw = BTRFS_READ_LOCK_BLOCKING;
 	}
 	btrfs_set_path_blocking(p);
-#endif
 
 	for (i = BTRFS_MAX_LEVEL - 1; i >= 0; i--) {
 		if (p->nodes[i] && p->locks[i]) {
@@ -107,10 +99,8 @@ noinline void btrfs_clear_path_blocking(
 		}
 	}
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 	if (held)
 		btrfs_clear_lock_blocking_rw(held, held_rw);
-#endif
 }
 
 /* this also releases the path */
@@ -2902,7 +2892,7 @@ cow_done:
 					}
 					p->locks[level] = BTRFS_WRITE_LOCK;
 				} else {
-					err = btrfs_try_tree_read_lock(b);
+					err = btrfs_tree_read_lock_atomic(b);
 					if (!err) {
 						btrfs_set_path_blocking(p);
 						btrfs_tree_read_lock(b);
@@ -3034,7 +3024,7 @@ again:
 			}
 
 			level = btrfs_header_level(b);
-			err = btrfs_try_tree_read_lock(b);
+			err = btrfs_tree_read_lock_atomic(b);
 			if (!err) {
 				btrfs_set_path_blocking(p);
 				btrfs_tree_read_lock(b);
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -128,6 +128,26 @@ again:
 }
 
 /*
+ * take a spinning read lock.
+ * returns 1 if we get the read lock and 0 if we don't
+ * this won't wait for blocking writers
+ */
+int btrfs_tree_read_lock_atomic(struct extent_buffer *eb)
+{
+	if (atomic_read(&eb->blocking_writers))
+		return 0;
+
+	read_lock(&eb->lock);
+	if (atomic_read(&eb->blocking_writers)) {
+		read_unlock(&eb->lock);
+		return 0;
+	}
+	atomic_inc(&eb->read_locks);
+	atomic_inc(&eb->spinning_readers);
+	return 1;
+}
+
+/*
  * returns 1 if we get the read lock and 0 if we don't
  * this won't wait for blocking writers
  */
@@ -158,9 +178,7 @@ int btrfs_try_tree_write_lock(struct ext
 	    atomic_read(&eb->blocking_readers))
 		return 0;
 
-	if (!write_trylock(&eb->lock))
-		return 0;
-
+	write_lock(&eb->lock);
 	if (atomic_read(&eb->blocking_writers) ||
 	    atomic_read(&eb->blocking_readers)) {
 		write_unlock(&eb->lock);
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -35,6 +35,8 @@ void btrfs_clear_lock_blocking_rw(struct
 void btrfs_assert_tree_locked(struct extent_buffer *eb);
 int btrfs_try_tree_read_lock(struct extent_buffer *eb);
 int btrfs_try_tree_write_lock(struct extent_buffer *eb);
+int btrfs_tree_read_lock_atomic(struct extent_buffer *eb);
+
 
 static inline void btrfs_tree_unlock_rw(struct extent_buffer *eb, int rw)
 {


