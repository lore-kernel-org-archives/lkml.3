Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559AbaFSU3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:29:49 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44520 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaFSU3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:29:47 -0400
Date: Thu, 19 Jun 2014 13:29:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@gentwo.org>, Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
Message-ID: <20140619202928.GG4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <53A2F406.4010109@oracle.com>
 <alpine.DEB.2.11.1406191001090.2785@gentwo.org>
 <20140619165247.GA4904@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406192127100.5170@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406192127100.5170@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061920-9332-0000-0000-000001255E24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:29:08PM +0200, Thomas Gleixner wrote:
> On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> 
> > On Thu, Jun 19, 2014 at 10:03:04AM -0500, Christoph Lameter wrote:
> > > On Thu, 19 Jun 2014, Sasha Levin wrote:
> > > 
> > > > [  690.770137] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> > > > [  690.770137] __slab_alloc (mm/slub.c:1732 mm/slub.c:2205 mm/slub.c:2369)
> > > > [  690.770137] ? __lock_acquire (kernel/locking/lockdep.c:3189)
> > > > [  690.770137] ? __debug_object_init (lib/debugobjects.c:100 lib/debugobjects.c:312)
> > > > [  690.770137] kmem_cache_alloc (mm/slub.c:2442 mm/slub.c:2484 mm/slub.c:2489)
> > > > [  690.770137] ? __debug_object_init (lib/debugobjects.c:100 lib/debugobjects.c:312)
> > > > [  690.770137] ? debug_object_activate (lib/debugobjects.c:439)
> > > > [  690.770137] __debug_object_init (lib/debugobjects.c:100 lib/debugobjects.c:312)
> > > > [  690.770137] debug_object_init (lib/debugobjects.c:365)
> > > > [  690.770137] rcuhead_fixup_activate (kernel/rcu/update.c:231)
> > > > [  690.770137] debug_object_activate (lib/debugobjects.c:280 lib/debugobjects.c:439)
> > > > [  690.770137] ? discard_slab (mm/slub.c:1486)
> > > > [  690.770137] __call_rcu (kernel/rcu/rcu.h:76 (discriminator 2) kernel/rcu/tree.c:2585 (discriminator 2))
> > > 
> > > __call_rcu does a slab allocation? This means __call_rcu can no longer be
> > > used in slab allocators? What happened?
> > 
> > My guess is that the root cause is a double call_rcu(), call_rcu_sched(),
> > call_rcu_bh(), or call_srcu().
> > 
> > Perhaps the DEBUG_OBJECTS code now allocates memory to report errors?
> > That would be unfortunate...
> 
> Well, no. Look at the callchain:
> 
> __call_rcu
>     debug_object_activate
>        rcuhead_fixup_activate
>           debug_object_init
>               kmem_cache_alloc
> 
> So call rcu activates the object, but the object has no reference in
> the debug objects code so the fixup code is called which inits the
> object and allocates a reference ....

OK, got it.  And you are right, call_rcu() has done this for a very
long time, so not sure what changed.  But it seems like the right
approach is to provide a debug-object-free call_rcu_alloc() for use
by the memory allocators.

Seem reasonable?  If so, please see the following patch.

						Thanx, Paul

------------------------------------------------------------------------

rcu: Provide call_rcu_alloc() and call_rcu_sched_alloc() to avoid recursion

The sl*b allocators use call_rcu() to manage object lifetimes, but
call_rcu() can use debug-objects, which in turn invokes the sl*b
allocators.  These allocators are not prepared for this sort of
recursion, which can result in failures.

This commit therefore creates call_rcu_alloc() and call_rcu_sched_alloc(),
which act as their call_rcu() and call_rcu_sched() counterparts, but
which avoid invoking debug-objects.  These new API members are intended
only for use by the sl*b allocators, and this commit makes the sl*b
allocators use call_rcu_alloc().  Why call_rcu_sched_alloc()?  Because
in CONFIG_PREEMPT=n kernels, call_rcu() maps to call_rcu_sched(), so
therefore call_rcu_alloc() must map to call_rcu_sched_alloc().

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Set-straight-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d5e40a42cc43..1f708a7f9e7d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -140,13 +140,24 @@ void do_trace_rcu_torture_read(const char *rcutorturename,
  * if CPU A and CPU B are the same CPU (but again only if the system has
  * more than one CPU).
  */
-void call_rcu(struct rcu_head *head,
-	      void (*func)(struct rcu_head *head));
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *head));
+
+/**
+ * call_rcu__alloc() - Queue an RCU for invocation after grace period.
+ * @head: structure to be used for queueing the RCU updates.
+ * @func: actual callback function to be invoked after the grace period
+ *
+ * Similar to call_rcu(), but avoids invoking debug-objects.  This permits
+ * this to be called from allocators without needing to worry about
+ * recursive calls into those allocators for debug-objects allocations.
+ */
+void call_rcu_alloc(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 
 #else /* #ifdef CONFIG_PREEMPT_RCU */
 
 /* In classic RCU, call_rcu() is just call_rcu_sched(). */
 #define	call_rcu	call_rcu_sched
+#define	call_rcu_alloc	call_rcu_sched_alloc
 
 #endif /* #else #ifdef CONFIG_PREEMPT_RCU */
 
@@ -196,6 +207,19 @@ void call_rcu_bh(struct rcu_head *head,
 void call_rcu_sched(struct rcu_head *head,
 		    void (*func)(struct rcu_head *rcu));
 
+/**
+ * call_rcu_sched_alloc() - Queue RCU for invocation after sched grace period.
+ * @head: structure to be used for queueing the RCU updates.
+ * @func: actual callback function to be invoked after the grace period
+ *
+ * Similar to call_rcu_sched(), but avoids invoking debug-objects.
+ * This permits this to be called from allocators without needing to
+ * worry about recursive calls into those allocators for debug-objects
+ * allocations.
+ */
+void call_rcu_sched_alloc(struct rcu_head *head,
+			  void (*func)(struct rcu_head *rcu));
+
 void synchronize_sched(void);
 
 #ifdef CONFIG_PREEMPT_RCU
diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index d9efcc13008c..515e60067c53 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -338,15 +338,14 @@ void synchronize_sched(void)
 EXPORT_SYMBOL_GPL(synchronize_sched);
 
 /*
- * Helper function for call_rcu() and call_rcu_bh().
+ * Provide call_rcu() function, but avoid invoking debug objects.
  */
-static void __call_rcu(struct rcu_head *head,
-		       void (*func)(struct rcu_head *rcu),
-		       struct rcu_ctrlblk *rcp)
+static void __call_rcu_nodo(struct rcu_head *head,
+			    void (*func)(struct rcu_head *rcu),
+			    struct rcu_ctrlblk *rcp)
 {
 	unsigned long flags;
 
-	debug_rcu_head_queue(head);
 	head->func = func;
 	head->next = NULL;
 
@@ -358,6 +357,17 @@ static void __call_rcu(struct rcu_head *head,
 }
 
 /*
+ * Helper function for call_rcu() and call_rcu_bh().
+ */
+static void __call_rcu(struct rcu_head *head,
+		       void (*func)(struct rcu_head *rcu),
+		       struct rcu_ctrlblk *rcp)
+{
+	debug_rcu_head_queue(head);
+	__call_rcu_nodo(head, func, rcp);
+}
+
+/*
  * Post an RCU callback to be invoked after the end of an RCU-sched grace
  * period.  But since we have but one CPU, that would be after any
  * quiescent state.
@@ -369,6 +379,18 @@ void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 EXPORT_SYMBOL_GPL(call_rcu_sched);
 
 /*
+ * Similar to call_rcu_sched(), but avoids debug-objects and thus calls
+ * into the memory allocators, which don't appreciate that sort of
+ * recursion.
+ */
+void call_rcu_sched_alloc(struct rcu_head *head,
+			  void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu_nodo(head, func, &rcu_sched_ctrlblk);
+}
+EXPORT_SYMBOL_GPL(call_rcu_sched_alloc);
+
+/*
  * Post an RCU bottom-half callback to be invoked after any subsequent
  * quiescent state.
  */
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 8c47d04ecdea..593195d38850 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2640,25 +2640,16 @@ static void rcu_leak_callback(struct rcu_head *rhp)
 }
 
 /*
- * Helper function for call_rcu() and friends.  The cpu argument will
- * normally be -1, indicating "currently running CPU".  It may specify
- * a CPU only if that CPU is a no-CBs CPU.  Currently, only _rcu_barrier()
- * is expected to specify a CPU.
+ * Provide call_rcu() function, but avoid invoking debug objects.
  */
 static void
-__call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
-	   struct rcu_state *rsp, int cpu, bool lazy)
+__call_rcu_nodo(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
+		struct rcu_state *rsp, int cpu, bool lazy)
 {
 	unsigned long flags;
 	struct rcu_data *rdp;
 
 	WARN_ON_ONCE((unsigned long)head & 0x1); /* Misaligned rcu_head! */
-	if (debug_rcu_head_queue(head)) {
-		/* Probable double call_rcu(), so leak the callback. */
-		ACCESS_ONCE(head->func) = rcu_leak_callback;
-		WARN_ONCE(1, "__call_rcu(): Leaked duplicate callback\n");
-		return;
-	}
 	head->func = func;
 	head->next = NULL;
 
@@ -2704,6 +2695,25 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 }
 
 /*
+ * Helper function for call_rcu() and friends.  The cpu argument will
+ * normally be -1, indicating "currently running CPU".  It may specify
+ * a CPU only if that CPU is a no-CBs CPU.  Currently, only _rcu_barrier()
+ * is expected to specify a CPU.
+ */
+static void
+__call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
+	   struct rcu_state *rsp, int cpu, bool lazy)
+{
+	if (debug_rcu_head_queue(head)) {
+		/* Probable double call_rcu(), so leak the callback. */
+		ACCESS_ONCE(head->func) = rcu_leak_callback;
+		WARN_ONCE(1, "__call_rcu(): Leaked duplicate callback\n");
+		return;
+	}
+	__call_rcu_nodo(head, func, rsp, cpu, lazy);
+}
+
+/*
  * Queue an RCU-sched callback for invocation after a grace period.
  */
 void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
@@ -2713,6 +2723,18 @@ void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 EXPORT_SYMBOL_GPL(call_rcu_sched);
 
 /*
+ * Similar to call_rcu_sched(), but avoids debug-objects and thus calls
+ * into the memory allocators, which don't appreciate that sort of
+ * recursion.
+ */
+void call_rcu_sched_alloc(struct rcu_head *head,
+			  void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu_nodo(head, func, &rcu_sched_state, -1, 0);
+}
+EXPORT_SYMBOL_GPL(call_rcu_sched_alloc);
+
+/*
  * Queue an RCU callback for invocation after a quicker grace period.
  */
 void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 569b390daa15..e9362d7f8328 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -679,6 +679,17 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
+/*
+ * Similar to call_rcu(), but avoids debug-objects and thus calls
+ * into the memory allocators, which don't appreciate that sort of
+ * recursion.
+ */
+void call_rcu_alloc(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu_nodo(head, func, &rcu_preempt_state, -1, 0);
+}
+EXPORT_SYMBOL_GPL(call_rcu_alloc);
+
 /**
  * synchronize_rcu - wait until a grace period has elapsed.
  *
diff --git a/mm/slab.c b/mm/slab.c
index 9ca3b87edabc..1e5de0d39701 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1994,7 +1994,7 @@ static void slab_destroy(struct kmem_cache *cachep, struct page *page)
 		 * we can use it safely.
 		 */
 		head = (void *)&page->rcu_head;
-		call_rcu(head, kmem_rcu_free);
+		call_rcu_alloc(head, kmem_rcu_free);
 
 	} else {
 		kmem_freepages(cachep, page);
diff --git a/mm/slob.c b/mm/slob.c
index 21980e0f39a8..47ad4a43521a 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -605,7 +605,7 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 		struct slob_rcu *slob_rcu;
 		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
 		slob_rcu->size = c->size;
-		call_rcu(&slob_rcu->head, kmem_rcu_free);
+		call_rcu_alloc(&slob_rcu->head, kmem_rcu_free);
 	} else {
 		__kmem_cache_free(b, c->size);
 	}
diff --git a/mm/slub.c b/mm/slub.c
index b2b047327d76..7f01e57fd99f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1512,7 +1512,7 @@ static void free_slab(struct kmem_cache *s, struct page *page)
 			head = (void *)&page->lru;
 		}
 
-		call_rcu(head, rcu_free_slab);
+		call_rcu_alloc(head, rcu_free_slab);
 	} else
 		__free_slab(s, page);
 }

