Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaAWQXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:23:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38798 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaAWQXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:23:21 -0500
Date: Thu, 23 Jan 2014 17:22:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
Message-ID: <20140123162254.GK3694@twins.programming.kicks-ass.net>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
 <20140120113415.GE30183@twins.programming.kicks-ass.net>
 <20140121221852.GT9037@kmo>
 <20140123124753.GT30183@twins.programming.kicks-ass.net>
 <20140123132829.GE889@kmo-pixel>
 <20140123135003.GU30183@twins.programming.kicks-ass.net>
 <20140123135539.GF889@kmo-pixel>
 <20140123154312.GX30183@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123154312.GX30183@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 05:28:29AM -0800, Kent Overstreet wrote:
> pool->lock is also going to be fairly badly contended in the worst case,
> and that can get real bad real fast... now that I think about it we
> probably want to avoid the __alloc_global_tag() double call just because
> of that, pool->lock is going to be quite a bit more contended than the
> waitlist lock just because fo the amount of work done under it.

On top of the two previous; I think we can reduce pool->lock contention
by not holding it while doing steal_tags().

By dropping pool->lock around steal_tags() we loose serialization over:

  pool->cpus_have_tags is an atomic bitmask, and
  pool->cpu_last_stolem, that's a heuristic anyway, so sod it.

We further loose the guarantee relied upon by percpu_ida_free(), so have
it also acquire the tags->lock, which should be a far less contended
resource.

Now everything modifying percpu_ida_cpu state holds
percpu_ida_cpu::lock, everything that modifies the actual percpu_ida
freelists holds percpu_ida::lock, and percpu_ida_cpu::lock nests inside
percpu_ida::lock.


The only annoying thing is that we're still holding IRQs over
steal_tags(), we should be able to make that a preempt_disable() without
too much effort, or very much cheat and drop even that and rely on the
percpu_ida_cpu::lock to serialize everything and just hope that we don't
migrate too often.

But that's for another patch.

---
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -68,8 +68,6 @@ static inline void steal_tags(struct per
 	unsigned cpus_have_tags, cpu = pool->cpu_last_stolen;
 	struct percpu_ida_cpu *remote;
 
-	lockdep_assert_held(&pool->lock);
-
 	for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
 	     cpus_have_tags * pool->percpu_max_size > pool->nr_tags / 2;
 	     cpus_have_tags--) {
@@ -141,18 +139,24 @@ static inline int alloc_global_tag(struc
 			  min(pool->nr_free, pool->percpu_batch_size));
 	}
 
+	spin_unlock(&pool->lock);
+
 	if (!tags->nr_free)
 		steal_tags(pool, tags);
 
 	if (tags->nr_free) {
-		tag = tags->freelist[--tags->nr_free];
+		spin_lock(&tags->lock);
 		if (tags->nr_free) {
-			cpumask_set_cpu(smp_processor_id(),
-					&pool->cpus_have_tags);
+			tag = tags->freelist[--tags->nr_free];
+			if (tags->nr_free) {
+				cpumask_set_cpu(smp_processor_id(),
+						&pool->cpus_have_tags);
+			}
 		}
+		spin_unlock(&tags->lock);
 	}
 
-	spin_unlock_irqrestore(&pool->lock, flags);
+	local_irq_restore(flags);
 
 	return tag;
 }
@@ -238,12 +242,8 @@ void percpu_ida_free(struct percpu_ida *
 
 	if (nr_free == pool->percpu_max_size) {
 		spin_lock(&pool->lock);
+		spin_lock(&tags->lock);
 
-		/*
-		 * Global lock held and irqs disabled, don't need percpu lock
-		 * because everybody accessing remote @tags will hold
-		 * pool->lock -- steal_tags().
-		 */
 		if (tags->nr_free == pool->percpu_max_size) {
 			move_tags(pool->freelist, &pool->nr_free,
 				  tags->freelist, &tags->nr_free,
@@ -251,6 +251,8 @@ void percpu_ida_free(struct percpu_ida *
 
 			wake_up(&pool->wait);
 		}
+
+		spin_unlock(&tags->lock);
 		spin_unlock(&pool->lock);
 	}
 
