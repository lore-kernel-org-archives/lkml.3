Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaAWMsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 07:48:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33002 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaAWMsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 07:48:15 -0500
Date: Thu, 23 Jan 2014 13:47:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
Message-ID: <20140123124753.GT30183@twins.programming.kicks-ass.net>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
 <20140120113415.GE30183@twins.programming.kicks-ass.net>
 <20140121221852.GT9037@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121221852.GT9037@kmo>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 02:18:52PM -0800, Kent Overstreet wrote:
> > I do not get the comment near prepare to wait -- why does it matter if
> > percpu_ida_free() flips a cpus_have_tags bit?
> 
> Did I write that comment? It is a crappy comment...
> 
> Ok, in userspace we'd be using condition variables here, but this is the kernel
> so we need to carefully order putting ourselves on a waitlist, and checking the
> condition that determines whether we wait, and on the wakeup end changing things
> that affect that condition and doing the wakeup. steal_tags() is checking the
> condition that goes with the prepare_to_wait(), that's all.

How about something like so?

---
 lib/percpu_ida.c | 126 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 70 insertions(+), 56 deletions(-)

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 9d054bf91d0f..fc13d70b5b5e 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -68,6 +68,8 @@ static inline void steal_tags(struct percpu_ida *pool,
 	unsigned cpus_have_tags, cpu = pool->cpu_last_stolen;
 	struct percpu_ida_cpu *remote;
 
+	lockdep_assert_held(&pool->lock);
+
 	for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
 	     cpus_have_tags * pool->percpu_max_size > pool->nr_tags / 2;
 	     cpus_have_tags--) {
@@ -105,19 +107,7 @@ static inline void steal_tags(struct percpu_ida *pool,
 	}
 }
 
-/*
- * Pop up to IDA_PCPU_BATCH_MOVE IDs off the global freelist, and push them onto
- * our percpu freelist:
- */
-static inline void alloc_global_tags(struct percpu_ida *pool,
-				     struct percpu_ida_cpu *tags)
-{
-	move_tags(tags->freelist, &tags->nr_free,
-		  pool->freelist, &pool->nr_free,
-		  min(pool->nr_free, pool->percpu_batch_size));
-}
-
-static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
+static inline int alloc_local_tag(struct percpu_ida_cpu *tags)
 {
 	int tag = -ENOSPC;
 
@@ -129,6 +119,50 @@ static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
 	return tag;
 }
 
+static inline int
+__alloc_global_tag(struct percpu_ida *pool, struct percpu_ida_cpu *tags)
+{
+	int tag = -ENOSPC;
+
+	spin_lock(&pool->lock);
+
+	if (!tags->nr_free) {
+		/*
+		 * Move tags from the global-, onto our percpu-freelist.
+		 */
+		move_tags(tags->freelist, &tags->nr_free,
+			  pool->freelist, &pool->nr_free,
+			  min(pool->nr_free, pool->percpu_batch_size));
+	}
+
+	if (!tags->nr_free)
+		steal_tags(pool, tags);
+
+	if (tags->nr_free) {
+		tag = tags->freelist[--tags->nr_free];
+		if (tags->nr_free) {
+			cpumask_set_cpu(smp_processor_id(),
+					&pool->cpus_have_tags);
+		}
+	}
+
+	spin_unlock(&pool->lock);
+
+	return tag;
+}
+
+static inline int alloc_global_tag(struct percpu_ida *pool)
+{
+	unsigned long flags;
+	int tag;
+
+	local_irq_safe(flags);
+	tag = __alloc_global_tag(pool, this_cpu_ptr(pool->tag_cpu));
+	local_irq_restore(flags);
+
+	return tag;
+}
+
 /**
  * percpu_ida_alloc - allocate a tag
  * @pool: pool to allocate from
@@ -147,61 +181,34 @@ static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
  *
  * Will not fail if passed __GFP_WAIT.
  */
-int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
+int percpu_ida_alloc(struct percpu_ida *pool, int state)
 {
-	DEFINE_WAIT(wait);
 	struct percpu_ida_cpu *tags;
 	unsigned long flags;
-	int tag;
+	int tag, ret = -ENOSPC;
 
 	local_irq_save(flags);
 	tags = this_cpu_ptr(pool->tag_cpu);
 
-	/* Fastpath */
 	tag = alloc_local_tag(tags);
-	if (likely(tag >= 0)) {
-		local_irq_restore(flags);
-		return tag;
-	}
+	if (unlikely(tag < 0))
+		tag = __alloc_global_tag(pool, tags);
 
-	while (1) {
-		spin_lock(&pool->lock);
-
-		/*
-		 * prepare_to_wait() must come before steal_tags(), in case
-		 * percpu_ida_free() on another cpu flips a bit in
-		 * cpus_have_tags
-		 *
-		 * global lock held and irqs disabled, don't need percpu lock
-		 */
-		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
-
-		if (!tags->nr_free)
-			alloc_global_tags(pool, tags);
-		if (!tags->nr_free)
-			steal_tags(pool, tags);
-
-		if (tags->nr_free) {
-			tag = tags->freelist[--tags->nr_free];
-			if (tags->nr_free)
-				cpumask_set_cpu(smp_processor_id(),
-						&pool->cpus_have_tags);
-		}
-
-		spin_unlock(&pool->lock);
-		local_irq_restore(flags);
+	local_irq_restore(flags);
 
-		if (tag >= 0 || !(gfp & __GFP_WAIT))
-			break;
+	if (likely(tag >= 0))
+		return tag;
 
-		schedule();
+	if (state != TASK_RUNNING) {
+		ret = ___wait_event(pool->wait,
+				(tag = alloc_global_tag(pool)) >= 0,
+				state, 0, 0, schedule());
 
-		local_irq_save(flags);
-		tags = this_cpu_ptr(pool->tag_cpu);
+		if (tag >= 0)
+			ret = tag;
 	}
 
-	finish_wait(&pool->wait, &wait);
-	return tag;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(percpu_ida_alloc);
 
@@ -235,12 +242,19 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 		wake_up(&pool->wait);
 	}
 
+	/*
+	 * No point in waking when 1 < n < max_size free, because steal_tags()
+	 * will assume max_size per set bit, having more free will not make it
+	 * more or less likely it will visit this cpu.
+	 */
+
 	if (nr_free == pool->percpu_max_size) {
 		spin_lock(&pool->lock);
 
 		/*
-		 * Global lock held and irqs disabled, don't need percpu
-		 * lock
+		 * Global lock held and irqs disabled, don't need percpu lock
+		 * because everybody accessing remote @tags will hold
+		 * pool->lock -- steal_tags().
 		 */
 		if (tags->nr_free == pool->percpu_max_size) {
 			move_tags(pool->freelist, &pool->nr_free,
