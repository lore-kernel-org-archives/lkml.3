Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaKJMJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:09:29 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40173 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaKJMJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:09:26 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-d5-5460aaf33661
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH 2/3] kernel: irq: use a kmem_cache for allocating struct
 irq_desc
Date: Mon, 10 Nov 2014 15:06:57 +0300
Message-id: <1415621218-6438-2-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com>
References: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGJMWRmVeSWpSXmKPExsVy+t/xa7qfVyWEGOx6ZG2x7dcjNovLu+aw
	WWzeNJXZgdnj3blz7B59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CV8eLoT7aC9WIVTy/+Zm5g
	3CrUxcjJISFgInH/6DZGCFtM4sK99WxdjFwcQgJLGSVevVnBCOH0MUl8n9LEAlLFJqAn8W/W
	djYQW0RAQ2LjpVvMIDazgJfExqtLmUBsYYFgiSUvdgLZHBwsAqoSP+ZIgoR5BVwlznUfZQYJ
	SwjISWxd5w0S5hRwk1h7ZCIriC0EVDK36SfjBEbeBYwMqxhFU0uTC4qT0nMN9YoTc4tL89L1
	kvNzNzFCwuLLDsbFx6wOMQpwMCrx8Hp8iQ8RYk0sK67MPcQowcGsJMI7a1lCiBBvSmJlVWpR
	fnxRaU5q8SFGJg5OqQZGnrzY6EedbwuvWOzrqD//RXn33NtzVBeULWl9PXVdTNK7YPPfGZsf
	LWlpOz23mvWO+NH/Cv2C9+dMWsB1xGt6N/cObe6bn+3LExZoxvMk+os9jv2RkHKMS7Fa97Su
	AH+LuIF5Hfums5eSpMMk26o3MJ1X+8BW3SKu4vt98lVny62tEvsCvL2UWIozEg21mIuKEwGq
	ePu66QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After enabling alignment checks in UBSan I've noticed a lot of
reports like this:

    UBSan: Undefined behaviour in ../kernel/irq/chip.c:195:14
    member access within misaligned address ffff88003e80d6f8
    for type 'struct irq_desc' which requires 16 byte alignment

struct irq_desc declared with ____cacheline_internodealigned_in_smp
attribute. However in some cases it allocated dynamically via kmalloc().
In general case kmalloc() guaranties only sizeof(void *) alignment.
We should use a separate slab cache to make struct irq_desc
properly aligned on SMP configuration.

This also could slightly reduce memory usage on some configurations.
E.g. in my setup sizeof(struct irq_desc) == 320. Which means that
kmalloc-512 will be used for allocating irg_desc via kmalloc().
In that case using separate slab cache will save us 192 bytes per
each irq_desc.

Note: UBSan reports says that 'struct irq_desc' requires 16 byte alignment.
It's wrong, in my setup it should be 64 bytes. This looks like a gcc bug,
but it doesn't change the fact that irq_desc is misaligned.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 kernel/irq/irqdesc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index a1782f8..f22cb87 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -23,6 +23,8 @@
  */
 static struct lock_class_key irq_desc_lock_class;
 
+static struct kmem_cache *irq_desc_cachep;
+
 #if defined(CONFIG_SMP)
 static void __init init_irq_default_affinity(void)
 {
@@ -137,9 +139,10 @@ static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
 	struct irq_desc *desc;
 	gfp_t gfp = GFP_KERNEL;
 
-	desc = kzalloc_node(sizeof(*desc), gfp, node);
+	desc = kmem_cache_zalloc_node(irq_desc_cachep, gfp, node);
 	if (!desc)
 		return NULL;
+
 	/* allocate based on nr_cpu_ids */
 	desc->kstat_irqs = alloc_percpu(unsigned int);
 	if (!desc->kstat_irqs)
@@ -158,7 +161,7 @@ static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
 err_kstat:
 	free_percpu(desc->kstat_irqs);
 err_desc:
-	kfree(desc);
+	kmem_cache_free(irq_desc_cachep, desc);
 	return NULL;
 }
 
@@ -174,7 +177,7 @@ static void free_desc(unsigned int irq)
 
 	free_masks(desc);
 	free_percpu(desc->kstat_irqs);
-	kfree(desc);
+	kmem_cache_free(irq_desc_cachep, desc);
 }
 
 static int alloc_descs(unsigned int start, unsigned int cnt, int node,
@@ -218,6 +221,8 @@ int __init early_irq_init(void)
 
 	init_irq_default_affinity();
 
+	irq_desc_cachep = KMEM_CACHE(irq_desc, SLAB_PANIC);
+
 	/* Let arch update nr_irqs and return the nr of preallocated irqs */
 	initcnt = arch_probe_nr_irqs();
 	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d %d\n", NR_IRQS, nr_irqs, initcnt);
-- 
2.1.3

