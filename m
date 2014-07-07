Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbaGGE7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 00:59:49 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:38729 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaGGE7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 00:59:46 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH] slab: fix oops when reading /proc/slab_allocators
Date: Mon,  7 Jul 2014 14:05:12 +0900
Message-Id: <1404709513-32187-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 03787301420376ae41fbaf4267f4a6253d152ac5 upstream.
Backport for v3.14-stable.

Commit b1cb0982bdd6 ("change the management method of free objects of
the slab") introduced a bug on slab leak detector
('/proc/slab_allocators').  This detector works like as following
decription.

 1. traverse all objects on all the slabs.
 2. determine whether it is active or not.
 3. if active, print who allocate this object.

but that commit changed the way how to manage free objects, so the logic
determining whether it is active or not is also changed.  In before, we
regard object in cpu caches as inactive one, but, with this commit, we
mistakenly regard object in cpu caches as active one.

This intoduces kernel oops if DEBUG_PAGEALLOC is enabled.  If
DEBUG_PAGEALLOC is enabled, kernel_map_pages() is used to detect who
corrupt free memory in the slab.  It unmaps page table mapping if object
is free and map it if object is active.  When slab leak detector check
object in cpu caches, it mistakenly think this object active so try to
access object memory to retrieve caller of allocation.  At this point,
page table mapping to this object doesn't exist, so oops occurs.

Following is oops message reported from Dave.

It blew up when something tried to read /proc/slab_allocators
(Just cat it, and you should see the oops below)

  Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
  Modules linked in:
  [snip...]
  CPU: 1 PID: 9386 Comm: trinity-c33 Not tainted 3.14.0-rc5+ #131
  task: ffff8801aa46e890 ti: ffff880076924000 task.ti: ffff880076924000
  RIP: 0010:[<ffffffffaa1a8f4a>]  [<ffffffffaa1a8f4a>] handle_slab+0x8a/0x180
  RSP: 0018:ffff880076925de0  EFLAGS: 00010002
  RAX: 0000000000001000 RBX: 0000000000000000 RCX: 000000005ce85ce7
  RDX: ffffea00079be100 RSI: 0000000000001000 RDI: ffff880107458000
  RBP: ffff880076925e18 R08: 0000000000000001 R09: 0000000000000000
  R10: 0000000000000000 R11: 000000000000000f R12: ffff8801e6f84000
  R13: ffffea00079be100 R14: ffff880107458000 R15: ffff88022bb8d2c0
  FS:  00007fb769e45740(0000) GS:ffff88024d040000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff8801e6f84ff8 CR3: 00000000a22db000 CR4: 00000000001407e0
  DR0: 0000000002695000 DR1: 0000000002695000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000070602
  Call Trace:
    leaks_show+0xce/0x240
    seq_read+0x28e/0x490
    proc_reg_read+0x3d/0x80
    vfs_read+0x9b/0x160
    SyS_read+0x58/0xb0
    tracesys+0xd4/0xd9
  Code: f5 00 00 00 0f 1f 44 00 00 48 63 c8 44 3b 0c 8a 0f 84 e3 00 00 00 83 c0 01 44 39 c0 72 eb 41 f6 47 1a 01 0f 84 e9 00 00 00 89 f0 <4d> 8b 4c 04 f8 4d 85 c9 0f 84 88 00 00 00 49 8b 7e 08 4d 8d 46
  RIP   handle_slab+0x8a/0x180

To fix the problem, I introduce an object status buffer on each slab.
With this, we can track object status precisely, so slab leak detector
would not access active object and no kernel oops would occur.  Memory
overhead caused by this fix is only imposed to CONFIG_DEBUG_SLAB_LEAK
which is mainly used for debugging, so memory overhead isn't big
problem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@vger.kernel.org> # 3.14
---
 mm/slab.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 68 insertions(+), 21 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index b264214..6dd8d5f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -375,6 +375,39 @@ static void **dbg_userword(struct kmem_cache *cachep, void *objp)
 
 #endif
 
+#define OBJECT_FREE (0)
+#define OBJECT_ACTIVE (1)
+
+#ifdef CONFIG_DEBUG_SLAB_LEAK
+
+static void set_obj_status(struct page *page, int idx, int val)
+{
+	int freelist_size;
+	char *status;
+	struct kmem_cache *cachep = page->slab_cache;
+
+	freelist_size = cachep->num * sizeof(unsigned int);
+	status = (char *)page->freelist + freelist_size;
+	status[idx] = val;
+}
+
+static inline unsigned int get_obj_status(struct page *page, int idx)
+{
+	int freelist_size;
+	char *status;
+	struct kmem_cache *cachep = page->slab_cache;
+
+	freelist_size = cachep->num * sizeof(unsigned int);
+	status = (char *)page->freelist + freelist_size;
+
+	return status[idx];
+}
+
+#else
+static inline void set_obj_status(struct page *page, int idx, int val) {}
+
+#endif
+
 /*
  * Do not go above this order unless 0 objects fit into the slab or
  * overridden on the command line.
@@ -565,9 +598,18 @@ static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
 	return cachep->array[smp_processor_id()];
 }
 
-static size_t slab_mgmt_size(size_t nr_objs, size_t align)
+static size_t calculate_freelist_size(int nr_objs, size_t align)
 {
-	return ALIGN(nr_objs * sizeof(unsigned int), align);
+	size_t freelist_size;
+
+	freelist_size = nr_objs * sizeof(unsigned int);
+	if (IS_ENABLED(CONFIG_DEBUG_SLAB_LEAK))
+		freelist_size += nr_objs * sizeof(char);
+
+	if (align)
+		freelist_size = ALIGN(freelist_size, align);
+
+	return freelist_size;
 }
 
 /*
@@ -600,6 +642,10 @@ static void cache_estimate(unsigned long gfporder, size_t buffer_size,
 		nr_objs = slab_size / buffer_size;
 
 	} else {
+		int extra_space = 0;
+
+		if (IS_ENABLED(CONFIG_DEBUG_SLAB_LEAK))
+			extra_space = sizeof(char);
 		/*
 		 * Ignore padding for the initial guess. The padding
 		 * is at most @align-1 bytes, and @buffer_size is at
@@ -608,17 +654,18 @@ static void cache_estimate(unsigned long gfporder, size_t buffer_size,
 		 * into the memory allocation when taking the padding
 		 * into account.
 		 */
-		nr_objs = (slab_size) / (buffer_size + sizeof(unsigned int));
+		nr_objs = (slab_size) /
+			(buffer_size + sizeof(unsigned int) + extra_space);
 
 		/*
 		 * This calculated number will be either the right
 		 * amount, or one greater than what we want.
 		 */
-		if (slab_mgmt_size(nr_objs, align) + nr_objs*buffer_size
-		       > slab_size)
+		if (calculate_freelist_size(nr_objs, align) >
+			slab_size - nr_objs * buffer_size)
 			nr_objs--;
 
-		mgmt_size = slab_mgmt_size(nr_objs, align);
+		mgmt_size = calculate_freelist_size(nr_objs, align);
 	}
 	*num = nr_objs;
 	*left_over = slab_size - nr_objs*buffer_size - mgmt_size;
@@ -2011,13 +2058,16 @@ static size_t calculate_slab_order(struct kmem_cache *cachep,
 			continue;
 
 		if (flags & CFLGS_OFF_SLAB) {
+			size_t freelist_size_per_obj = sizeof(unsigned int);
 			/*
 			 * Max number of objs-per-slab for caches which
 			 * use off-slab slabs. Needed to avoid a possible
 			 * looping condition in cache_grow().
 			 */
+			if (IS_ENABLED(CONFIG_DEBUG_SLAB_LEAK))
+				freelist_size_per_obj += sizeof(char);
 			offslab_limit = size;
-			offslab_limit /= sizeof(unsigned int);
+			offslab_limit /= freelist_size_per_obj;
 
  			if (num > offslab_limit)
 				break;
@@ -2258,8 +2308,7 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 	if (!cachep->num)
 		return -E2BIG;
 
-	freelist_size =
-		ALIGN(cachep->num * sizeof(unsigned int), cachep->align);
+	freelist_size = calculate_freelist_size(cachep->num, cachep->align);
 
 	/*
 	 * If the slab has been placed off-slab, and we have enough space then
@@ -2272,7 +2321,7 @@ __kmem_cache_create (struct kmem_cache *cachep, unsigned long flags)
 
 	if (flags & CFLGS_OFF_SLAB) {
 		/* really off slab. No need for manual alignment */
-		freelist_size = cachep->num * sizeof(unsigned int);
+		freelist_size = calculate_freelist_size(cachep->num, 0);
 
 #ifdef CONFIG_PAGE_POISONING
 		/* If we're going to use the generic kernel_map_pages()
@@ -2589,6 +2638,7 @@ static void cache_init_objs(struct kmem_cache *cachep,
 		if (cachep->ctor)
 			cachep->ctor(objp);
 #endif
+		set_obj_status(page, i, OBJECT_FREE);
 		slab_freelist(page)[i] = i;
 	}
 }
@@ -2797,6 +2847,7 @@ static void *cache_free_debugcheck(struct kmem_cache *cachep, void *objp,
 	BUG_ON(objnr >= cachep->num);
 	BUG_ON(objp != index_to_obj(cachep, page, objnr));
 
+	set_obj_status(page, objnr, OBJECT_FREE);
 	if (cachep->flags & SLAB_POISON) {
 #ifdef CONFIG_DEBUG_PAGEALLOC
 		if ((cachep->size % PAGE_SIZE)==0 && OFF_SLAB(cachep)) {
@@ -2930,6 +2981,8 @@ static inline void cache_alloc_debugcheck_before(struct kmem_cache *cachep,
 static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
 				gfp_t flags, void *objp, unsigned long caller)
 {
+	struct page *page;
+
 	if (!objp)
 		return objp;
 	if (cachep->flags & SLAB_POISON) {
@@ -2960,6 +3013,9 @@ static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
 		*dbg_redzone1(cachep, objp) = RED_ACTIVE;
 		*dbg_redzone2(cachep, objp) = RED_ACTIVE;
 	}
+
+	page = virt_to_head_page(objp);
+	set_obj_status(page, obj_to_index(cachep, page, objp), OBJECT_ACTIVE);
 	objp += obj_offset(cachep);
 	if (cachep->ctor && cachep->flags & SLAB_POISON)
 		cachep->ctor(objp);
@@ -4201,21 +4257,12 @@ static void handle_slab(unsigned long *n, struct kmem_cache *c,
 						struct page *page)
 {
 	void *p;
-	int i, j;
+	int i;
 
 	if (n[0] == n[1])
 		return;
 	for (i = 0, p = page->s_mem; i < c->num; i++, p += c->size) {
-		bool active = true;
-
-		for (j = page->active; j < c->num; j++) {
-			/* Skip freed item */
-			if (slab_freelist(page)[j] == i) {
-				active = false;
-				break;
-			}
-		}
-		if (!active)
+		if (get_obj_status(page, i) != OBJECT_ACTIVE)
 			continue;
 
 		if (!add_caller(n, (unsigned long)*dbg_userword(c, p)))
-- 
1.7.9.5

