Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934483Ab3BMQlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:41:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:60029 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934352Ab3BMQlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:41:07 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 10/16] FIX [2/2] slub: Tid must be retrieved from the percpu area of the current processor
Date: Wed, 13 Feb 2013 17:12:05 +0100
Message-Id: <1360771932-27150-11-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

As Steven Rostedt has pointer out: Rescheduling could occur on a differnet processor
after the determination of the per cpu pointer and before the tid is retrieved.
This could result in allocation from the wrong node in slab_alloc.

The effect is much more severe in slab_free() where we could free to the freelist
of the wrong page.

The window for something like that occurring is pretty small but it is possible.

Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 mm/slub.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 08eb4c1..78d2756 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2286,13 +2286,18 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 		return NULL;
 
 redo:
-
 	/*
 	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
 	 * enabled. We may switch back and forth between cpus while
 	 * reading from one cpu area. That does not matter as long
 	 * as we end up on the original cpu again when doing the cmpxchg.
+	 *
+	 * Preemption is disabled for the retrieval of the tid because that
+	 * must occur from the current processor. We cannot allow rescheduling
+	 * on a different processor between the determination of the pointer
+	 * and the retrieval of the tid.
 	 */
+	preempt_disable();
 	c = __this_cpu_ptr(s->cpu_slab);
 
 	/*
@@ -2302,7 +2307,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	 * linked list in between.
 	 */
 	tid = c->tid;
-	barrier();
+	preempt_enable();
 
 	object = c->freelist;
 	if (unlikely(!object || !node_match(c, node)))
@@ -2544,10 +2549,11 @@ static __always_inline void slab_free(struct kmem_cache *s,
 	 * data is retrieved via this pointer. If we are on the same cpu
 	 * during the cmpxchg then the free will succedd.
 	 */
+	preempt_disable();
 	c = __this_cpu_ptr(s->cpu_slab);
 
 	tid = c->tid;
-	barrier();
+	preempt_enable();
 
 	if (likely(page == c->page)) {
 		set_freepointer(s, object, c->freelist);
-- 
1.7.10.4

