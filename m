Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaBWVmn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:42:43 -0500
Received: from www.linutronix.de ([62.245.132.108]:52332 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaBWVkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:13 -0500
Message-Id: <20140223212738.929676976@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [patch 24/26] genirq: Provide handle_percpu_simple_irq()
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline;
 filename=genirq-provide-simple-percpu-handler.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Special case for vmbus to replace their homegrown flow handler.

Not sure whether we need it at all. I can't see a reason why that
needs special handling at all if CONFIG_HYPERV=n

Not-Yet-Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/irq.h |    1 +
 kernel/irq/chip.c   |   15 +++++++++++++++
 2 files changed, 16 insertions(+)

Index: tip/include/linux/irq.h
===================================================================
--- tip.orig/include/linux/irq.h
+++ tip/include/linux/irq.h
@@ -423,6 +423,7 @@ extern void handle_edge_irq(unsigned int
 extern void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_percpu_simple_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_nested_irq(unsigned int irq);
Index: tip/kernel/irq/chip.c
===================================================================
--- tip.orig/kernel/irq/chip.c
+++ tip/kernel/irq/chip.c
@@ -623,6 +623,21 @@ handle_percpu_irq(unsigned int irq, stru
 }
 
 /**
+ *	handle_percpu_simple_irq - Per CPU local irq handler
+ *	@irq:	the interrupt number
+ *	@desc:	the interrupt description structure for this irq
+ *
+ *	Per CPU interrupts on SMP machines without locking
+ *	requirements. No ack/eoi handling.
+ */
+void
+handle_percpu_simple_irq(unsigned int irq, struct irq_desc *desc)
+{
+	kstat_incr_irqs_this_cpu(irq, desc);
+	handle_irq_event_percpu(desc, desc->action);
+}
+
+/**
  * handle_percpu_devid_irq - Per CPU local irq handler with per cpu dev ids
  * @irq:	the interrupt number
  * @desc:	the interrupt description structure for this irq


