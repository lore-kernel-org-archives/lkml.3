Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaHSDoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 23:44:38 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:33681 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636AbaHSDoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 23:44:37 -0400
Date: Mon, 18 Aug 2014 22:44:34 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
In-Reply-To: <20140818163757.GA30742@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1408182147400.28727@gentwo.org>
References: <53A2F406.4010109@oracle.com> <alpine.DEB.2.11.1406191001090.2785@gentwo.org> <20140619165247.GA4904@linux.vnet.ibm.com> <alpine.DEB.2.10.1406192127100.5170@nanos> <alpine.DEB.2.11.1406191519090.4002@gentwo.org>
 <20140818163757.GA30742@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2014, Paul E. McKenney wrote:

> > > So call rcu activates the object, but the object has no reference in
> > > the debug objects code so the fixup code is called which inits the
> > > object and allocates a reference ....
> >
> > So we need to init the object in the page struct before the __call_rcu?
>
> And the needed APIs are now in mainline:
>
> 	void init_rcu_head(struct rcu_head *head);
> 	void destroy_rcu_head(struct rcu_head *head);
>
> Over to you, Christoph!  ;-)

The field we are using for the rcu head serves other purposes before
the free action. We cannot init the field at slab creation as we
thought since it is used for the queueing of slabs on the partial, free
and full lists. The kmem_cache information is not available when doing
the freeing so we must force the allocation of reserve fields and the
use of the reserved areas for rcu on all kmem_caches.

I made this conditional on CONFIG_RCU_XYZ. This needs to be the actual
Debug options that will require allocations when initializing rcu heads.

Also note that the allocations in the rcu head initialization must be
restricted to non RCU slabs otherwise the recursion may not terminate.


Subject RFC: Allow allocations on initializing rcu fields in slub.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c
+++ linux/mm/slub.c
@@ -1308,6 +1308,41 @@ static inline struct page *alloc_slab_pa
 	return page;
 }

+#ifdef CONFIG_RCU_DEBUG_XYZ
+/*
+ * We may have to do alloations during the initialization of the
+ * debug portion of the rcu structure for a slab. It must therefore
+ * be separately allocated and initized on allocation.
+ * We cannot overload the lru field in the page struct at all.
+ */
+#define need_reserve_slab_rcu 1
+#else
+/*
+ * Overload the lru field in struct page if it fits.
+ * Should struct rcu_head grow due to debugging fields etc then
+ * additional space will be allocated from the end of the slab to
+ * store the rcu_head.
+ */
+#define need_reserve_slab_rcu						\
+	(sizeof(((struct page *)NULL)->lru) < sizeof(struct rcu_head))
+#endif
+
+static struct rcu_head *get_rcu_head(struct kmem_cache *s, struct page *page)
+{
+	if (need_reserve_slab_rcu) {
+		int order = compound_order(page);
+		int offset = (PAGE_SIZE << order) - s->reserved;
+
+		VM_BUG_ON(s->reserved != sizeof(struct rcu_head));
+		return page_address(page) + offset;
+	} else {
+		/*
+		 * RCU free overloads the RCU head over the LRU
+		 */
+		return (void *)&page->lru;
+	}
+}
+
 static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	struct page *page;
@@ -1357,6 +1392,21 @@ static struct page *allocate_slab(struct
 			kmemcheck_mark_unallocated_pages(page, pages);
 	}

+#ifdef CONFIG_RCU_DEBUG_XYZ
+	if (unlikely(s->flags & SLAB_DESTROY_BY_RCU) && page)
+		/*
+		 * Initialize rcu_head and potentially do other
+		 * allocations. Note that this is still a recursive
+		 * call into the allocator which may recurse endlessly
+		 * if the same kmem_cache is used for allocation here.
+		 *
+		 * So in order to be safe the slab caches used
+		 * in init_rcu_head must be restricted to be of the
+		 * non rcu kind only.
+		 */
+		init_rcu_head(get_rcu_head(s, page));
+#endif
+
 	if (flags & __GFP_WAIT)
 		local_irq_disable();
 	if (!page)
@@ -1452,13 +1502,13 @@ static void __free_slab(struct kmem_cach
 	memcg_uncharge_slab(s, order);
 }

-#define need_reserve_slab_rcu						\
-	(sizeof(((struct page *)NULL)->lru) < sizeof(struct rcu_head))
-
 static void rcu_free_slab(struct rcu_head *h)
 {
 	struct page *page;

+#ifdef CONFIG_RCU_DEBUG_XYZ
+	destroy_rcu_head(h);
+#endif
 	if (need_reserve_slab_rcu)
 		page = virt_to_head_page(h);
 	else
@@ -1469,24 +1519,9 @@ static void rcu_free_slab(struct rcu_hea

 static void free_slab(struct kmem_cache *s, struct page *page)
 {
-	if (unlikely(s->flags & SLAB_DESTROY_BY_RCU)) {
-		struct rcu_head *head;
-
-		if (need_reserve_slab_rcu) {
-			int order = compound_order(page);
-			int offset = (PAGE_SIZE << order) - s->reserved;
-
-			VM_BUG_ON(s->reserved != sizeof(*head));
-			head = page_address(page) + offset;
-		} else {
-			/*
-			 * RCU free overloads the RCU head over the LRU
-			 */
-			head = (void *)&page->lru;
-		}
-
-		call_rcu(head, rcu_free_slab);
-	} else
+	if (unlikely(s->flags & SLAB_DESTROY_BY_RCU))
+		call_rcu(get_rcu_head(s, page), rcu_free_slab);
+	else
 		__free_slab(s, page);
 }

