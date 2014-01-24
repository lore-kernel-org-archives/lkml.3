Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaAXQYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:24:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:57689 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaAXQYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:24:51 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH RT] arm/unwind: fail on unwind in irq disabled regions
Date: Fri, 24 Jan 2014 17:24:23 +0100
Message-Id: <1390580663-28869-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly unwind is done with irqs enabled however SLUB may call it with
irqs disabled while creating a new SLUB cache.

I had system freeze while loading a module which called
kmem_cache_create() on init. That means SLUB's __slab_alloc() disabled
interrupts and then

->new_slab_objects()
 ->new_slab()
  ->setup_object()
   ->setup_object_debug()
    ->init_tracking()
     ->set_track()
      ->save_stack_trace()
       ->save_stack_trace_tsk()
        ->walk_stackframe()
         ->unwind_frame()
          ->unwind_find_idx()
           =>spin_lock_irqsave(&unwind_lock);

I would prefer not to turn this into a raw lock so for now it will just
fail if it is called with irqs disabled which might return a few "empty"
traces…

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/kernel/unwind.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 00df012..2af232d 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -195,6 +195,11 @@ static const struct unwind_idx *unwind_find_idx(unsigned long addr)
 		/* module unwind tables */
 		struct unwind_table *table;
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+		if (irqs_disabled())
+			goto out;
+#endif
+
 		spin_lock_irqsave(&unwind_lock, flags);
 		list_for_each_entry(table, &unwind_tables, list) {
 			if (addr >= table->begin_addr &&
@@ -211,6 +216,7 @@ static const struct unwind_idx *unwind_find_idx(unsigned long addr)
 	}
 
 	pr_debug("%s: idx = %p\n", __func__, idx);
+out:
 	return idx;
 }
 
@@ -345,7 +351,9 @@ int unwind_frame(struct stackframe *frame)
 
 	idx = unwind_find_idx(frame->pc);
 	if (!idx) {
+#ifndef CONFIG_PREEMPT_RT_FULL
 		pr_warning("unwind: Index not found %08lx\n", frame->pc);
+#endif
 		return -URC_FAILURE;
 	}
 
-- 
1.8.5.3

