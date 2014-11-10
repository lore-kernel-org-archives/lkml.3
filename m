Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaKJMJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:09:48 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21245 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaKJMJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:09:27 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-d8-5460aaf43646
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH 3/3] kernel: irq: use kmem_cache for allocating struct irqaction
Date: Mon, 10 Nov 2014 15:06:58 +0300
Message-id: <1415621218-6438-3-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com>
References: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGJMWRmVeSWpSXmKPExsVy+t/xa7pfViWEGFzcaGOx7dcjNovLu+aw
	WWzeNJXZgdnj3blz7B59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CV8bttAlvBRvmK5t57rA2M
	fVJdjJwcEgImEgd63jNC2GISF+6tZ+ti5OIQEljKKHFg6SdmCKePSWLb1VWsIFVsAnoS/2Zt
	ZwOxRQQ0JDZeusUMYjMLeElsvLqUqYuRg0NYIEBifWsJSJhFQFXi05l7TCA2r4CrxK2LR9hB
	SiQE5CS2rvMGCXMKuEmsPTIRbLoQUMncpp+MExh5FzAyrGIUTS1NLihOSs811CtOzC0uzUvX
	S87P3cQICYsvOxgXH7M6xCjAwajEw+vxJT5EiDWxrLgy9xCjBAezkgjvrGUJIUK8KYmVValF
	+fFFpTmpxYcYmTg4pRoYgxJPpJ5oiC3nza9yXqmsVt7Gn1gQ8pa5plzMqvbC01lB6y1OXhcP
	vXXwUVBDhBeT9m1P3Y5bPwzTmrZstFz0+ABLn/zbU2V59nbF/V3K64y7q34InsnwC258zCx1
	xnTetvtR79kLVwulOLgcehCt4CgdXBswad1SrtvRa7SPveOyC7qw4akSS3FGoqEWc1FxIgBo
	GSmZ6QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After enabling alignment checks in UBSan I've noticed several
reports like this:

   UBSan: Undefined behaviour in kernel/irq/manage.c:1315:13
   member access within misaligned address ffff88007c274558
   for type 'struct irqaction' which requires 16 byte alignment

struct irqaction declared with ____cacheline_internodealigned_in_smp
attribute. However in some cases it allocated dynamically via kmalloc().
In general case kmalloc() guaranties only sizeof(void *) alignment.
We should use a separate slab cache to make struct irqaction
properly aligned on SMP configuration.

Note: UBSan reports says that 'struct irqaction' requires 16 byte alignment.
It's wrong, in my setup it should be 64 bytes. This looks like a gcc bug,
but it doesn't change the fact that irqaction is misaligned.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 kernel/irq/internals.h |  2 ++
 kernel/irq/irqdesc.c   |  1 +
 kernel/irq/manage.c    | 14 ++++++++------
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 4332d76..95b61c5 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -7,6 +7,7 @@
  */
 #include <linux/irqdesc.h>
 #include <linux/kernel_stat.h>
+#include <linux/slab.h>
 
 #ifdef CONFIG_SPARSE_IRQ
 # define IRQ_BITMAP_BITS	(NR_IRQS + 8196)
@@ -17,6 +18,7 @@
 #define istate core_internal_state__do_not_mess_with_it
 
 extern bool noirqdebug;
+extern struct kmem_cache *irqaction_cachep;
 
 /*
  * Bits used by threaded handlers:
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index f22cb87..52c3e4f 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -222,6 +222,7 @@ int __init early_irq_init(void)
 	init_irq_default_affinity();
 
 	irq_desc_cachep = KMEM_CACHE(irq_desc, SLAB_PANIC);
+	irqaction_cachep = KMEM_CACHE(irqaction, SLAB_PANIC);
 
 	/* Let arch update nr_irqs and return the nr of preallocated irqs */
 	initcnt = arch_probe_nr_irqs();
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a9104b..7c69597 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -21,6 +21,8 @@
 
 #include "internals.h"
 
+struct kmem_cache *irqaction_cachep;
+
 #ifdef CONFIG_IRQ_FORCED_THREADING
 __read_mostly bool force_irqthreads;
 
@@ -1409,7 +1411,7 @@ void free_irq(unsigned int irq, void *dev_id)
 #endif
 
 	chip_bus_lock(desc);
-	kfree(__free_irq(irq, dev_id));
+	kmem_cache_free(irqaction_cachep, __free_irq(irq, dev_id));
 	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(free_irq);
@@ -1487,7 +1489,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 		handler = irq_default_primary_handler;
 	}
 
-	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
+	action = kmem_cache_zalloc(irqaction_cachep, GFP_KERNEL);
 	if (!action)
 		return -ENOMEM;
 
@@ -1502,7 +1504,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 	chip_bus_sync_unlock(desc);
 
 	if (retval)
-		kfree(action);
+		kmem_cache_free(irqaction_cachep, action);
 
 #ifdef CONFIG_DEBUG_SHIRQ_FIXME
 	if (!retval && (irqflags & IRQF_SHARED)) {
@@ -1683,7 +1685,7 @@ void free_percpu_irq(unsigned int irq, void __percpu *dev_id)
 		return;
 
 	chip_bus_lock(desc);
-	kfree(__free_percpu_irq(irq, dev_id));
+	kmem_cache_free(irqaction_cachep, __free_percpu_irq(irq, dev_id));
 	chip_bus_sync_unlock(desc);
 }
 
@@ -1738,7 +1740,7 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
 	    !irq_settings_is_per_cpu_devid(desc))
 		return -EINVAL;
 
-	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
+	action = kmem_cache_zalloc(irqaction_cachep, GFP_KERNEL);
 	if (!action)
 		return -ENOMEM;
 
@@ -1752,7 +1754,7 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
 	chip_bus_sync_unlock(desc);
 
 	if (retval)
-		kfree(action);
+		kmem_cache_free(irqaction_cachep, action);
 
 	return retval;
 }
-- 
2.1.3

