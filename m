Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab3J2RiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:38:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab3J2RiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:38:20 -0400
Date: Tue, 29 Oct 2013 17:38:14 +0000
From: Mel Gorman <mgorman@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Chris Mason <chris.mason@fusionio.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] futex: Remove requirement for lock_page in get_futex_key
Message-ID: <20131029173814.GH2400@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner and Peter Zijlstra discussed off-list that real-time users
currently have a problem with the page lock being contended for unbounded
periods of time during futex operations. The three of us discussed the
possibiltity that the page lock is unnecessary in this case because we are
not concerned with the usual races with reclaim and page cache updates. For
anonymous pages, the associated futex object is the mm_struct which does
not require the page lock. For inodes, we should be able to check under
RCU read lock if the page mapping is still valid to take a reference to
the inode.  This just leaves one rare race that requires the page lock
in the slow path. This patch does not completely eliminate the page lock
but it should reduce contention in the majority of cases.

Patch boots and futextest did not explode but I did no comparison
performance tests. Thomas, do you have details of the workload that
drove you to examine this problem? Alternatively, can you test it and
see does it help you? I added Chris to the To list because he mentioned
that some filesystems might already be doing tricks similar to this
patch that are worth copying.

Not-yet-signed-off-by: Peter Zijlstra <peterz@infradead.org>
Not-yet-signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/futex.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 81 insertions(+), 8 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c3a1a55..a918358 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -239,6 +239,7 @@ static int
 get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 {
 	unsigned long address = (unsigned long)uaddr;
+	struct address_space *mapping;
 	struct mm_struct *mm = current->mm;
 	struct page *page, *page_head;
 	int err, ro = 0;
@@ -318,10 +319,20 @@ again:
 	}
 #endif
 
-	lock_page(page_head);
+	/*
+	 * The treatment of mapping from this point on is critical. The page
+	 * lock protects many things but in this context the page lock
+	 * stabilises mapping, prevents inode freeing in the shared
+	 * file-backed region case and guards against movement to swap cache.
+	 * Strictly speaking the page lock is not needed in all cases being
+	 * considered here and page lock forces unnecessarily serialisation.
+	 * From this point on, mapping will be reverified if necessary and
+	 * page lock will be acquired only if it is unavoiable.
+	 */
+	mapping = ACCESS_ONCE(page_head->mapping);
 
 	/*
-	 * If page_head->mapping is NULL, then it cannot be a PageAnon
+	 * If mapping is NULL, then it cannot be a PageAnon
 	 * page; but it might be the ZERO_PAGE or in the gate area or
 	 * in a special mapping (all cases which we are happy to fail);
 	 * or it may have been a good file page when get_user_pages_fast
@@ -335,10 +346,22 @@ again:
 	 * shmem_writepage move it from filecache to swapcache beneath us:
 	 * an unlikely race, but we do need to retry for page_head->mapping.
 	 */
-	if (!page_head->mapping) {
-		int shmem_swizzled = PageSwapCache(page_head);
+	if (!mapping) {
+		int shmem_swizzled;
+
+		/*
+		 * Page lock is required to identify which special case above
+		 * applies. If this is really a shmem page then the page lock
+		 * will prevent unexpected transitions.
+		 */
+		lock_page(page_head);
+		mapping = page_head->mapping;
+		shmem_swizzled = PageSwapCache(page_head);
 		unlock_page(page_head);
+
 		put_page(page_head);
+		WARN_ON_ONCE(mapping);
+
 		if (shmem_swizzled)
 			goto again;
 		return -EFAULT;
@@ -347,6 +370,11 @@ again:
 	/*
 	 * Private mappings are handled in a simple way.
 	 *
+	 * If the futex key is stored on an anonymous page then the associated
+	 * object is the mm which is implicitly pinned by the calling process.
+	 * Page lock is unnecessary to stabilise page->mapping in this case and
+	 * is not taken.
+	 *
 	 * NOTE: When userspace waits on a MAP_SHARED mapping, even if
 	 * it's a read-only handle, it's expected that futexes attach to
 	 * the object not the particular process.
@@ -364,16 +392,61 @@ again:
 		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
 		key->private.mm = mm;
 		key->private.address = address;
+
+		get_futex_key_refs(key);
 	} else {
+		struct inode *inode;
+
+		/*
+		 * The associtated futex object in this case is the inode and
+		 * the page->mapping must be traversed. Ordinarily this should
+		 * be stabilised under page lock but it's not strictly
+		 * necessary in this case as we just want to pin the inode, not
+		 * update radix tree or anything like that.
+		 *
+		 * The RCU read lock is taken as the inode is finally freed
+		 * under RCU. If the mapping still matches expectations then the
+		 * mapping->host can be safely accessed as being a valid inode.
+		 */
+		rcu_read_lock();
+		if (page->mapping != mapping || !mapping->host) {
+			rcu_read_unlock();
+			put_page(page_head);
+			goto again;
+		}
+		inode = mapping->host;
+
+		/*
+		 * Take a reference unless it is about to be freed. Previously
+		 * this reference was taken by ihold under the page lock
+		 * pinning the inode in place so i_lock was unnecessary. The
+		 * only way for this check to fail is if the inode was
+		 * truncated in parallel so warn for now if this happens.
+		 *
+		 * TODO: VFS and/or filesystem people should review this check
+		 * and see if there is a safer or more reliable way to do this.
+		 */
+		if (WARN_ON(!atomic_inc_not_zero(&inode->i_count))) {
+			rcu_read_unlock();
+			put_page(page_head);
+			goto again;
+		}
+
+		/* Should be impossible but lets be paranoid for now */
+		if (WARN_ON(inode->i_mapping != mapping)) {
+			rcu_read_unlock();
+			iput(inode);
+			put_page(page_head);
+			goto again;
+		}
+
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
-		key->shared.inode = page_head->mapping->host;
+		key->shared.inode = inode;
 		key->shared.pgoff = basepage_index(page);
+		rcu_read_unlock();
 	}
 
-	get_futex_key_refs(key);
-
 out:
-	unlock_page(page_head);
 	put_page(page_head);
 	return err;
 }
