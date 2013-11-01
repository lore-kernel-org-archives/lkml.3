Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab3KAHyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 03:54:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:12758 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab3KAHy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 03:54:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,615,1378882800"; 
   d="scan'208";a="420728651"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>
Subject: [PATCH 3/4] mm/rmap: cleanup unnecessary code
Date: Fri,  1 Nov 2013 15:54:26 +0800
Message-Id: <1383292467-28922-4-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Quot from Peter: [ edited by Yuanhan Liu ]
    You can remove all that -- all that trickery was only needed because the
    lock could sleep;

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 mm/rmap.c |   71 +++++++------------------------------------------------------
 1 files changed, 8 insertions(+), 63 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 22e8172..246b5fe 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -85,29 +85,6 @@ static inline struct anon_vma *anon_vma_alloc(void)
 static inline void anon_vma_free(struct anon_vma *anon_vma)
 {
 	VM_BUG_ON(atomic_read(&anon_vma->refcount));
-
-	/*
-	 * Synchronize against page_lock_anon_vma_read() such that
-	 * we can safely hold the lock without the anon_vma getting
-	 * freed.
-	 *
-	 * Relies on the full mb implied by the atomic_dec_and_test() from
-	 * put_anon_vma() against the acquire barrier implied by
-	 * down_read_trylock() from page_lock_anon_vma_read(). This orders:
-	 *
-	 * page_lock_anon_vma_read()	VS	put_anon_vma()
-	 *   down_read_trylock()		  atomic_dec_and_test()
-	 *   LOCK				  MB
-	 *   atomic_read()			  rwlock_is_locked()
-	 *
-	 * LOCK should suffice since the actual taking of the lock must
-	 * happen _before_ what follows.
-	 */
-	if (!write_can_lock(&anon_vma->rwlock)) {
-		anon_vma_lock_write(anon_vma);
-		anon_vma_unlock_write(anon_vma);
-	}
-
 	kmem_cache_free(anon_vma_cachep, anon_vma);
 }
 
@@ -387,10 +364,6 @@ out:
 
 /*
  * Similar to page_get_anon_vma() except it locks the anon_vma.
- *
- * Its a little more complex as it tries to keep the fast path to a single
- * atomic op -- the trylock. If we fail the trylock, we fall back to getting a
- * reference like with page_get_anon_vma() and then block on the mutex.
  */
 struct anon_vma *page_lock_anon_vma_read(struct page *page)
 {
@@ -405,50 +378,22 @@ struct anon_vma *page_lock_anon_vma_read(struct page *page)
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	if (read_trylock(&anon_vma->rwlock)) {
-		/*
-		 * If the page is still mapped, then this anon_vma is still
-		 * its anon_vma, and holding the mutex ensures that it will
-		 * not go away, see anon_vma_free().
-		 */
-		if (!page_mapped(page)) {
-			read_unlock(&anon_vma->rwlock);
-			anon_vma = NULL;
-		}
-		goto out;
-	}
-
-	/* trylock failed, we got to sleep */
-	if (!atomic_inc_not_zero(&anon_vma->refcount)) {
-		anon_vma = NULL;
-		goto out;
-	}
-
-	if (!page_mapped(page)) {
-		put_anon_vma(anon_vma);
-		anon_vma = NULL;
-		goto out;
-	}
-
-	/* we pinned the anon_vma, its safe to sleep */
-	rcu_read_unlock();
 	anon_vma_lock_read(anon_vma);
 
-	if (atomic_dec_and_test(&anon_vma->refcount)) {
-		/*
-		 * Oops, we held the last refcount, release the lock
-		 * and bail -- can't simply use put_anon_vma() because
-		 * we'll deadlock on the anon_vma_lock_write() recursion.
-		 */
+	/*
+	 * If this page is still mapped, then its anon_vma cannot have been
+	 * freed.  But if it has been unmapped, we have no security against the
+	 * anon_vma structure being freed and reused (for another anon_vma:
+	 * SLAB_DESTROY_BY_RCU guarantees that)
+	 */
+	if (!page_mapped(page)) {
 		anon_vma_unlock_read(anon_vma);
-		__put_anon_vma(anon_vma);
 		anon_vma = NULL;
 	}
 
-	return anon_vma;
-
 out:
 	rcu_read_unlock();
+
 	return anon_vma;
 }
 
-- 
1.7.7.6

