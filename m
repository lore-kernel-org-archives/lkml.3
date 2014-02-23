Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaBWVoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:44:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:52297 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaBWVkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:10 -0500
Message-Id: <20140223212738.579581220@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xen <xen-devel@lists.xenproject.org>
Subject: [patch 21/26] xen: Get rid of the last irq_desc abuse
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline;
 filename=xen-get-rid-of-the-last-irq-to-desc-abuse.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd prefer to drop that completely but there seems to be some mystic
value to the error printout and the allocation check.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xen <xen-devel@lists.xenproject.org>
---
 drivers/xen/events/events_base.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

Index: tip/drivers/xen/events/events_base.c
===================================================================
--- tip.orig/drivers/xen/events/events_base.c
+++ tip/drivers/xen/events/events_base.c
@@ -487,13 +487,6 @@ static void pirq_query_unmask(int irq)
 		info->u.pirq.flags |= PIRQ_NEEDS_EOI;
 }
 
-static bool probing_irq(int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	return desc && desc->action == NULL;
-}
-
 static void eoi_pirq(struct irq_data *data)
 {
 	int evtchn = evtchn_from_irq(data->irq);
@@ -517,7 +510,7 @@ static void mask_ack_pirq(struct irq_dat
 	eoi_pirq(data);
 }
 
-static unsigned int __startup_pirq(unsigned int irq)
+static unsigned int __startup_pirq(struct irq_data *data, unsigned int irq)
 {
 	struct evtchn_bind_pirq bind_pirq;
 	struct irq_info *info = info_for_irq(irq);
@@ -535,7 +528,7 @@ static unsigned int __startup_pirq(unsig
 					BIND_PIRQ__WILL_SHARE : 0;
 	rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq);
 	if (rc != 0) {
-		if (!probing_irq(irq))
+		if (!data || irqd_irq_has_action(data))
 			pr_info("Failed to obtain physical IRQ %d\n", irq);
 		return 0;
 	}
@@ -562,7 +555,7 @@ out:
 
 static unsigned int startup_pirq(struct irq_data *data)
 {
-	return __startup_pirq(data->irq);
+	return __startup_pirq(data, data->irq);
 }
 
 static void shutdown_pirq(struct irq_data *data)
@@ -769,15 +762,13 @@ error_irq:
 
 int xen_destroy_irq(int irq)
 {
-	struct irq_desc *desc;
 	struct physdev_unmap_pirq unmap_irq;
 	struct irq_info *info = info_for_irq(irq);
 	int rc = -ENOENT;
 
 	mutex_lock(&irq_mapping_update_lock);
 
-	desc = irq_to_desc(irq);
-	if (!desc)
+	if (!irq_is_allocated(irq))
 		goto out;
 
 	if (xen_initial_domain()) {
@@ -1432,7 +1423,7 @@ static void restore_pirqs(void)
 
 		printk(KERN_DEBUG "xen: --> irq=%d, pirq=%d\n", irq, map_irq.pirq);
 
-		__startup_pirq(irq);
+		__startup_pirq(irq_get_irq_data(irq), irq);
 	}
 }
 


