Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3LPUZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:25:11 -0500
Received: from 18.mo1.mail-out.ovh.net ([46.105.35.72]:34805 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752012Ab3LPUZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:25:09 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 01/10] genirq: generic chip: export irq_map_generic_chip function
Date: Mon, 16 Dec 2013 21:24:12 +0100
Message-Id: <1387225461-6201-2-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387225461-6201-1-git-send-email-b.brezillon@overkiz.com>
References: <1387225461-6201-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 7041659494298187875
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the generic irq map function in order to provide irq_domain ops with
generic mapping and specific of xlate function (needed by the new atmel
AIC driver).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 include/linux/irq.h       |    2 ++
 kernel/irq/generic-chip.c |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7dc1003..19b5e3b 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -765,6 +765,8 @@ void irq_gc_eoi(struct irq_data *d);
 int irq_gc_set_wake(struct irq_data *d, unsigned int on);
 
 /* Setup functions for irq_chip_generic */
+int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
+			 irq_hw_number_t hw_irq);
 struct irq_chip_generic *
 irq_alloc_generic_chip(const char *name, int nr_ct, unsigned int irq_base,
 		       void __iomem *reg_base, irq_flow_handler_t handler);
diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 452d6f2..cf80e7b 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -341,8 +341,8 @@ static struct lock_class_key irq_nested_lock_class;
 /*
  * irq_map_generic_chip - Map a generic chip for an irq domain
  */
-static int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
-				irq_hw_number_t hw_irq)
+int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
+			 irq_hw_number_t hw_irq)
 {
 	struct irq_data *data = irq_get_irq_data(virq);
 	struct irq_domain_chip_generic *dgc = d->gc;
@@ -394,6 +394,7 @@ static int irq_map_generic_chip(struct irq_domain *d, unsigned int virq,
 	irq_modify_status(virq, dgc->irq_flags_to_clear, dgc->irq_flags_to_set);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(irq_map_generic_chip);
 
 struct irq_domain_ops irq_generic_chip_ops = {
 	.map	= irq_map_generic_chip,
-- 
1.7.9.5

