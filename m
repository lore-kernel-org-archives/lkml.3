Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347Ab3BMQjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:39:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:59969 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759377Ab3BMQjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:39:20 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 12/12] slub: Enable irqs for __GFP_WAIT
Date: Wed, 13 Feb 2013 17:13:51 +0100
Message-Id: <1360772031-27186-13-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360772031-27186-1-git-send-email-bigeasy@linutronix.de>
References: <1360772031-27186-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

SYSTEM_RUNNING might be too late for enabling interrupts. Allocations
with GFP_WAIT can happen before that. So use this as an indicator.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bigeasy@linutronix: fix !page conflict]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 mm/slub.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 624deaa..bdb7f3a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1293,14 +1293,15 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	struct page *page;
 	struct kmem_cache_order_objects oo = s->oo;
 	gfp_t alloc_gfp;
+	bool enableirqs;
 
 	flags &= gfp_allowed_mask;
 
+	enableirqs = (flags & __GFP_WAIT) != 0;
 #ifdef CONFIG_PREEMPT_RT_FULL
-	if (system_state == SYSTEM_RUNNING)
-#else
-	if (flags & __GFP_WAIT)
+	enableirqs |= system_state == SYSTEM_RUNNING;
 #endif
+	if (enableirqs)
 		local_irq_enable();
 
 	flags |= s->allocflags;
@@ -1324,11 +1325,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 			stat(s, ORDER_FALLBACK);
 	}
 
-#ifdef CONFIG_PREEMPT_RT_FULL
-	if (system_state == SYSTEM_RUNNING)
-#else
-	if (flags & __GFP_WAIT)
-#endif
+	if (enableirqs)
 		local_irq_disable();
 
 	if (!page)
-- 
1.7.10.4

