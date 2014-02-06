Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaBFAYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:24:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:47492 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751464AbaBFAYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:24:07 -0500
Date: Wed, 5 Feb 2014 19:24:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: penberg@kernel.org, cl@linux.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] slub: Do not assert not having lock in removing freed
 partial
Message-ID: <20140205192404.550da7dc@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladimir reported the following issue:

Commit c65c1877bd68 ("slub: use lockdep_assert_held") requires
remove_partial() to be called with n->list_lock held, but free_partial()
called from kmem_cache_close() on cache destruction does not follow this
rule, leading to a warning:

  WARNING: CPU: 0 PID: 2787 at mm/slub.c:1536 __kmem_cache_shutdown+0x1b2/0x1f0()
  Modules linked in:
  CPU: 0 PID: 2787 Comm: modprobe Tainted: G        W    3.14.0-rc1-mm1+ #1
  Hardware name:
   0000000000000600 ffff88003ae1dde8 ffffffff816d9583 0000000000000600
   0000000000000000 ffff88003ae1de28 ffffffff8107c107 0000000000000000
   ffff880037ab2b00 ffff88007c240d30 ffffea0001ee5280 ffffea0001ee52a0
  Call Trace:
   [<ffffffff816d9583>] dump_stack+0x51/0x6e
   [<ffffffff8107c107>] warn_slowpath_common+0x87/0xb0
   [<ffffffff8107c145>] warn_slowpath_null+0x15/0x20
   [<ffffffff811c7fe2>] __kmem_cache_shutdown+0x1b2/0x1f0
   [<ffffffff811908d3>] kmem_cache_destroy+0x43/0xf0
   [<ffffffffa013a123>] xfs_destroy_zones+0x103/0x110 [xfs]
   [<ffffffffa0192b54>] exit_xfs_fs+0x38/0x4e4 [xfs]
   [<ffffffff811036fa>] SyS_delete_module+0x19a/0x1f0
   [<ffffffff816dfcd8>] ? retint_swapgs+0x13/0x1b
   [<ffffffff810d2125>] ? trace_hardirqs_on_caller+0x105/0x1d0
   [<ffffffff81359efe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
   [<ffffffff816e8539>] system_call_fastpath+0x16/0x1b


His solution was to add a spinlock in order to quiet lockdep. Although
there would be no contention to adding the lock, that lock also
requires disabling of interrupts which will have a larger impact on the
system.

Instead of adding a spinlock to a location where it is not needed for
lockdep, make a remove_freed_partial() function that does not test if
the list_lock is held, as no one should have it due to it being freed.

Reported-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/mm/slub.c
===================================================================
--- linux-trace.git.orig/mm/slub.c
+++ linux-trace.git/mm/slub.c
@@ -1530,13 +1530,30 @@ static inline void add_partial(struct km
 		list_add(&page->lru, &n->partial);
 }
 
+static __always_inline void
+__remove_partial(struct kmem_cache_node *n, struct page *page)
+{
+	list_del(&page->lru);
+	n->nr_partial--;
+}
+
 static inline void remove_partial(struct kmem_cache_node *n,
 					struct page *page)
 {
 	lockdep_assert_held(&n->list_lock);
+	__remove_partial(n, page);
+}
 
-	list_del(&page->lru);
-	n->nr_partial--;
+/*
+ * The difference between remove_partial and remove_freed_partial
+ * is that remove_freed_partial happens only on a a freed slab
+ * that should not have anyone accessing it, and thus does not
+ * require the n->list_lock.
+ */
+static inline void remove_freed_partial(struct kmem_cache_node *n,
+					struct page *page)
+{
+	__remove_partial(n, page);
 }
 
 /*
@@ -3195,7 +3212,7 @@ static void free_partial(struct kmem_cac
 
 	list_for_each_entry_safe(page, h, &n->partial, lru) {
 		if (!page->inuse) {
-			remove_partial(n, page);
+			remove_freed_partial(n, page);
 			discard_slab(s, page);
 		} else {
 			list_slab_objects(s, page,
