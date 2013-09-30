Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3I3LBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:01:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38498 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3I3LBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:01:15 -0400
Date: Mon, 30 Sep 2013 13:00:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH, v2] anon_vmas: Convert the rwsem to an rwlock_t
Message-ID: <20130930110047.GY3081@twins.programming.kicks-ass.net>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <20130928192123.GA8228@gmail.com>
 <20130928193739.GA8642@gmail.com>
 <CA+55aFyMXxH-PGewqxse=VJzMdHWkyN4iKMh-VgQ1X2yJFnAgw@mail.gmail.com>
 <20130928195207.GA31245@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928195207.GA31245@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 09:52:07PM +0200, Ingo Molnar wrote:
> Index: tip/mm/rmap.c
> ===================================================================
> --- tip.orig/mm/rmap.c
> +++ tip/mm/rmap.c
> @@ -98,12 +98,12 @@ static inline void anon_vma_free(struct
>  	 * page_lock_anon_vma_read()	VS	put_anon_vma()
>  	 *   down_read_trylock()		  atomic_dec_and_test()
>  	 *   LOCK				  MB
> -	 *   atomic_read()			  rwsem_is_locked()
> +	 *   atomic_read()			  rwlock_is_locked()
>  	 *
>  	 * LOCK should suffice since the actual taking of the lock must
>  	 * happen _before_ what follows.
>  	 */
> -	if (rwsem_is_locked(&anon_vma->root->rwsem)) {
> +	if (!write_can_lock(&anon_vma->root->rwlock)) {
>  		anon_vma_lock_write(anon_vma);
>  		anon_vma_unlock_write(anon_vma);
>  	}
> @@ -457,14 +457,14 @@ struct anon_vma *page_lock_anon_vma_read
>  
>  	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
>  	root_anon_vma = ACCESS_ONCE(anon_vma->root);
> -	if (down_read_trylock(&root_anon_vma->rwsem)) {
> +	if (read_trylock(&root_anon_vma->rwlock)) {
>  		/*
>  		 * If the page is still mapped, then this anon_vma is still
>  		 * its anon_vma, and holding the mutex ensures that it will
>  		 * not go away, see anon_vma_free().
>  		 */
>  		if (!page_mapped(page)) {
> -			up_read(&root_anon_vma->rwsem);
> +			read_unlock(&root_anon_vma->rwlock);
>  			anon_vma = NULL;
>  		}
>  		goto out;
> @@ -1293,7 +1293,7 @@ out_mlock:
>  	/*
>  	 * We need mmap_sem locking, Otherwise VM_LOCKED check makes
>  	 * unstable result and race. Plus, We can't wait here because
> -	 * we now hold anon_vma->rwsem or mapping->i_mmap_mutex.
> +	 * we now hold anon_vma->rwlock or mapping->i_mmap_mutex.
>  	 * if trylock failed, the page remain in evictable lru and later
>  	 * vmscan could retry to move the page to unevictable lru if the
>  	 * page is actually mlocked.


You can remove all that -- all that trickery was only needed because the
lock could sleep;

---
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -85,29 +85,6 @@ static inline struct anon_vma *anon_vma_
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
-	if (!write_can_lock(&anon_vma->root->rwlock)) {
-		anon_vma_lock_write(anon_vma);
-		anon_vma_unlock_write(anon_vma);
-	}
-
 	kmem_cache_free(anon_vma_cachep, anon_vma);
 }
 
@@ -437,15 +414,10 @@ struct anon_vma *page_get_anon_vma(struc
 
 /*
  * Similar to page_get_anon_vma() except it locks the anon_vma.
- *
- * Its a little more complex as it tries to keep the fast path to a single
- * atomic op -- the trylock. If we fail the trylock, we fall back to getting a
- * reference like with page_get_anon_vma() and then block on the mutex.
  */
 struct anon_vma *page_lock_anon_vma_read(struct page *page)
 {
 	struct anon_vma *anon_vma = NULL;
-	struct anon_vma *root_anon_vma;
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
@@ -456,51 +428,22 @@ struct anon_vma *page_lock_anon_vma_read
 		goto out;
 
 	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
-	root_anon_vma = ACCESS_ONCE(anon_vma->root);
-	if (read_trylock(&root_anon_vma->rwlock)) {
-		/*
-		 * If the page is still mapped, then this anon_vma is still
-		 * its anon_vma, and holding the mutex ensures that it will
-		 * not go away, see anon_vma_free().
-		 */
-		if (!page_mapped(page)) {
-			read_unlock(&root_anon_vma->rwlock);
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
+	 * SLAB_DESTROY_BY_RCU guarantees that - so the atomic_inc_not_zero()
+	 * above cannot corrupt).
+	 */
+	if (!page_mapped(page)) {
 		anon_vma_unlock_read(anon_vma);
-		__put_anon_vma(anon_vma);
 		anon_vma = NULL;
 	}
-
-	return anon_vma;
-
 out:
 	rcu_read_unlock();
+
 	return anon_vma;
 }
 
