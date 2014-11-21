Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbaKUQIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:08:39 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21397 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbaKUQIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:08:37 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-d5-546f63821da5
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH v2 1/2] kernel: irq: use kmem_cache for allocating struct
 irq_desc
Date: Fri, 21 Nov 2014 19:08:18 +0300
Message-id: <1416586099-13375-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIJMWRmVeSWpSXmKPExsVy+t/xa7pNyfkhBgtvSFts+/WIzeL6tzeM
	Fpd3zWGzaFuykcli86apzA6sHgs2lXq8O3eO3ePJlelMHn1bVjF6fN4kF8AaxWWTkpqTWZZa
	pG+XwJWx7v5EpoKNohXbe+axNTBeEexi5OSQEDCR+Pr2FQuELSZx4d56ti5GLg4hgaWMEkdn
	XmOEcPqYJNbt284MUsUmoCfxb9Z2NhBbREBDYuOlW8wgRcwCUxglts9+wt7FyMEhLBAi0bgp
	A6SGRUBV4sfsx6wgYV4BN4nGZzUgpoSAnMTWdd4TGLkXMDKsYhRNLU0uKE5KzzXUK07MLS7N
	S9dLzs/dxAgJhi87GBcfszrEKMDBqMTDe8AxN0SINbGsuDL3EKMEB7OSCG+5cH6IEG9KYmVV
	alF+fFFpTmrxIUYmDk6pBkbDn4KifGvcv3D8vd4re5zNdOVrloCyMP6f94+fr5ZlORfpn6Je
	xVnev2zO8Rh+5QatIKvgFl3/iPyQ9TLSZQ41kg+tvDZFq3LHSSn9WOheGC75cfH86ZwbXDXt
	VsiJZq1XsFzlrCYtYj9p2v15/VpnXc68l1adqTKLkf1Y4tMnNY8e/D7NqMRSnJFoqMVcVJwI
	AOL+sUjkAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After enabling alignment checks in UBSan I've noticed a lot of
reports like this:

    UBSan: Undefined behaviour in ../kernel/irq/chip.c:195:14
    member access within misaligned address ffff88003e80d6f8
    for type 'struct irq_desc' which requires 64 byte alignment

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

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: David Rientjes <rientjes@google.com>
---

Changes since v1:
  - Drop kmem_cache_zalloc_node() and use kmem_cache_alloc_node with __GFP_ZERO flag.

 kernel/irq/irqdesc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index a1782f8..c7a812c 100644
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
@@ -137,7 +139,7 @@ static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
 	struct irq_desc *desc;
 	gfp_t gfp = GFP_KERNEL;
 
-	desc = kzalloc_node(sizeof(*desc), gfp, node);
+	desc = kmem_cache_alloc_node(irq_desc_cachep, gfp | __GFP_ZERO, node);
 	if (!desc)
 		return NULL;
 	/* allocate based on nr_cpu_ids */
@@ -158,7 +160,7 @@ static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
 err_kstat:
 	free_percpu(desc->kstat_irqs);
 err_desc:
-	kfree(desc);
+	kmem_cache_free(irq_desc_cachep, desc);
 	return NULL;
 }
 
@@ -174,7 +176,7 @@ static void free_desc(unsigned int irq)
 
 	free_masks(desc);
 	free_percpu(desc->kstat_irqs);
-	kfree(desc);
+	kmem_cache_free(irq_desc_cachep, desc);
 }
 
 static int alloc_descs(unsigned int start, unsigned int cnt, int node,
@@ -218,6 +220,8 @@ int __init early_irq_init(void)
 
 	init_irq_default_affinity();
 
+	irq_desc_cachep = KMEM_CACHE(irq_desc, SLAB_PANIC);
+
 	/* Let arch update nr_irqs and return the nr of preallocated irqs */
 	initcnt = arch_probe_nr_irqs();
 	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d %d\n", NR_IRQS, nr_irqs, initcnt);
-- 
2.1.3

