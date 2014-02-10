Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaBJPkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:40:21 -0500
Received: from hofr.at ([212.69.189.236]:43884 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbaBJPkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:40:17 -0500
Date: Mon, 10 Feb 2014 16:40:16 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: linux-rt-users@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: [PATCH RT 5/5] allow preemption in slab_alloc_node and slab_free
Message-ID: <20140210154016.GF20017@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drop preempt_disable/enable in slab_alloc_node and slab_free

__slab_alloc is only called from slub.c:slab_alloc_node
it runs with local irqs disabled so it can't be pushed off this CPU
asynchronously, the preempt_disable/enable is thus not needed.
Aside from that the later this_cpu_cmpxchg_double would catch such a 
migration event anyay.

slab_free:
 slowpath: (if the allocation was on a different CPU) detected by 
  (page == c->page) c pointing to the per cpu slab, this does not need a 
  consistent ref to tid so the slow path is safe without the 
  preempt_disable/enable
 fastpath: if allocation was on the same cpu but we got migrated between
  fetching the cpu_slab and the actual push onto the free list then
  this_cpu_cmpxchg_double would catch this case and loop in redo. So the
  fast path is also safe without the preempt_disable/enable

Testing:
 while : ; do ./hackbench 120 thread 10000 ; done 
Time: 296.631
Time: 298.723
Time: 301.468
Time: 303.880
Time: 301.988
Time: 300.038
Time: 299.634
Time: 301.488
 which seems to be a good way to stress-test slub

Impact on performance:
 The change could negatively impact performance if the removal of the 
 preempt_disable/enable would result in a significant increase of the 
 slow path being taken or looping via goto redo - this was checked by:
 static instrumentation:
  an instrumentation was added to check how often the redo loop is taken
  the results showed that the redo loop is very rarely taken (< 1 in 10000)
  and is below the value with the preempt_disable/enable present. Further
  the slowpath to fastpath ration improves slightly (not sure if this is 
  statistically significant though)
 running slab_test.c:
  the slub-benchmark from Christoph Lameter and Mathieu Desnoyers was used
  the only change being that asm/system.h was droped from the list of
  includes. The results indicate that the removal of preempt_disable/enable
  reduces the cycles needed slightly (though quite a few testsystems would
  need to be checked before this can be confirmed).

Tested-by: Andreas Platschek <platschek@ict.tuwien.ac.at>
Tested-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 mm/slub.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 546bd9a..c422988 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2424,7 +2424,6 @@ redo:
 	 * on a different processor between the determination of the pointer
 	 * and the retrieval of the tid.
 	 */
-	preempt_disable();
 	c = __this_cpu_ptr(s->cpu_slab);
 
 	/*
@@ -2434,7 +2433,6 @@ redo:
 	 * linked list in between.
 	 */
 	tid = c->tid;
-	preempt_enable();
 
 	object = c->freelist;
 	page = c->page;
@@ -2683,11 +2681,9 @@ redo:
 	 * data is retrieved via this pointer. If we are on the same cpu
 	 * during the cmpxchg then the free will succedd.
 	 */
-	preempt_disable();
 	c = __this_cpu_ptr(s->cpu_slab);
 
 	tid = c->tid;
-	preempt_enable();
 
 	if (likely(page == c->page)) {
 		set_freepointer(s, object, c->freelist);
-- 
1.7.2.5

