Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaLEIs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:48:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:34030 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaLEIsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:48:37 -0500
Message-Id: <20141205084147.393737205@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 05 Dec 2014 08:48:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>
Subject: [patch 4/5] irqdomain: Revert gfp hackery
References: <20141204234737.728961990@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=irqdomain-revert-gfp-hackery.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reverts: eda7516e1d428 'irqdomain: Correct early allocation of irq
domains with IRQs off'

Now that we distangled the allocations and the enablement of irq
remapping and removed the pointless preempt disabled region from
native_smp_prepare_cpus() we can remove that hackaround

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdomain.c |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

Index: tip/kernel/irq/irqdomain.c
===================================================================
--- tip.orig/kernel/irq/irqdomain.c
+++ tip/kernel/irq/irqdomain.c
@@ -46,31 +46,14 @@ struct irq_domain *__irq_domain_add(stru
 				    void *host_data)
 {
 	struct irq_domain *domain;
-	gfp_t gfp_flags = GFP_KERNEL;
-
-#ifdef CONFIG_X86
-	/*
-	 * BIG FAT COMMENT: Early initialization paths like enable_IR_x2apic(),
-	 * for example, call into here with interrupts disabled but then we do
-	 * allocate memory and can sleep so no-no. A proper fix would be to do
-	 * x2APIC IR setup in the early irq setup path but it is too late for
-	 * fixing it this way now, shortly before the merge window.
-	 *
-	 * So we do this little brown paper bag, which is temporary! Do not even
-	 * think of calling irq domain setup code with IRQs disabled. You will
-	 * get frozen-sharked!
-	 */
-	if (irqs_disabled())
-		gfp_flags = GFP_NOFS;
-#endif
 
 	domain = kzalloc_node(sizeof(*domain) + (sizeof(unsigned int) * size),
-			      gfp_flags, of_node_to_nid(of_node));
+			      GFP_KERNEL, of_node_to_nid(of_node));
 	if (WARN_ON(!domain))
 		return NULL;
 
 	/* Fill structure */
-	INIT_RADIX_TREE(&domain->revmap_tree, gfp_flags);
+	INIT_RADIX_TREE(&domain->revmap_tree, GFP_KERNEL);
 	domain->ops = ops;
 	domain->host_data = host_data;
 	domain->of_node = of_node_get(of_node);


