Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaIAOO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:14:26 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64127 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753740AbaIAOLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:11:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: [PATCH 08/13] genirq: Create helper for flow handler entry check
Date: Mon, 01 Sep 2014 16:24:57 +0200
Message-ID: <1951365.DpvK0R7Nqk@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2516134.pmOxkEuOOy@vostro.rjw.lan>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan> <5320472.coYotHR1d0@vostro.rjw.lan> <2516134.pmOxkEuOOy@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

All flow handlers - except the per cpu ones - check for an interrupt
in progress and an eventual concurrent polling on another cpu.

Create a helper function for the repeated code pattern.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/irq/chip.c |   48 ++++++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

Index: linux/kernel/irq/chip.c
===================================================================
--- linux.orig/kernel/irq/chip.c
+++ linux/kernel/irq/chip.c
@@ -342,6 +342,13 @@ static bool irq_check_poll(struct irq_de
 	return irq_wait_for_poll(desc);
 }
 
+static bool irq_may_run(struct irq_desc *desc)
+{
+	if (!irqd_irq_inprogress(&desc->irq_data))
+		return true;
+	return irq_check_poll(desc);
+}
+
 /**
  *	handle_simple_irq - Simple and software-decoded IRQs.
  *	@irq:	the interrupt number
@@ -359,9 +366,8 @@ handle_simple_irq(unsigned int irq, stru
 {
 	raw_spin_lock(&desc->lock);
 
-	if (unlikely(irqd_irq_inprogress(&desc->irq_data)))
-		if (!irq_check_poll(desc))
-			goto out_unlock;
+	if (!irq_may_run(desc))
+		goto out_unlock;
 
 	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
@@ -412,9 +418,8 @@ handle_level_irq(unsigned int irq, struc
 	raw_spin_lock(&desc->lock);
 	mask_ack_irq(desc);
 
-	if (unlikely(irqd_irq_inprogress(&desc->irq_data)))
-		if (!irq_check_poll(desc))
-			goto out_unlock;
+	if (!irq_may_run(desc))
+		goto out_unlock;
 
 	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
@@ -485,9 +490,8 @@ handle_fasteoi_irq(unsigned int irq, str
 
 	raw_spin_lock(&desc->lock);
 
-	if (unlikely(irqd_irq_inprogress(&desc->irq_data)))
-		if (!irq_check_poll(desc))
-			goto out;
+	if (!irq_may_run(desc))
+		goto out;
 
 	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 	kstat_incr_irqs_this_cpu(irq, desc);
@@ -541,16 +545,10 @@ handle_edge_irq(unsigned int irq, struct
 
 	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 
-	/*
-	 * If the handler is currently running, mark it pending,
-	 * handle the necessary masking and go out
-	 */
-	if (unlikely(irqd_irq_inprogress(&desc->irq_data))) {
-		if (!irq_check_poll(desc)) {
-			desc->istate |= IRQS_PENDING;
-			mask_ack_irq(desc);
-			goto out_unlock;
-		}
+	if (!irq_may_run(desc)) {
+		desc->istate |= IRQS_PENDING;
+		mask_ack_irq(desc);
+		goto out_unlock;
 	}
 
 	/*
@@ -612,15 +610,9 @@ void handle_edge_eoi_irq(unsigned int ir
 
 	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
 
-	/*
-	 * If the handler is currently running, mark it pending,
-	 * handle the necessary masking and go out
-	 */
-	if (unlikely(irqd_irq_inprogress(&desc->irq_data))) {
-		if (!irq_check_poll(desc)) {
-			desc->istate |= IRQS_PENDING;
-			goto out_eoi;
-		}
+	if (!irq_may_run(desc)) {
+		desc->istate |= IRQS_PENDING;
+		goto out_eoi;
 	}
 
 	/*

