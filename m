Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaBWVpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:45:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:52270 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaBWVkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:09 -0500
Message-Id: <20140223212738.222412125@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xen <xen-devel@lists.xenproject.org>
Subject: [patch 18/26] xen: Use the proper irq functions
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=xen-use-the-proper-functions.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I really can't understand why people keep adding irq_desc abuse. We
have enough proper interfaces. Delete another 14 lines of hackery.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xen <xen-devel@lists.xenproject.org>
---
 drivers/xen/events/events_2l.c   |   15 ++++-----------
 drivers/xen/events/events_base.c |    7 ++-----
 drivers/xen/events/events_fifo.c |    8 ++------
 3 files changed, 8 insertions(+), 22 deletions(-)

Index: tip/drivers/xen/events/events_2l.c
===================================================================
--- tip.orig/drivers/xen/events/events_2l.c
+++ tip/drivers/xen/events/events_2l.c
@@ -166,7 +166,6 @@ static void evtchn_2l_handle_events(unsi
 	int start_word_idx, start_bit_idx;
 	int word_idx, bit_idx;
 	int i;
-	struct irq_desc *desc;
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
 
@@ -176,11 +175,8 @@ static void evtchn_2l_handle_events(unsi
 		unsigned int evtchn = evtchn_from_irq(irq);
 		word_idx = evtchn / BITS_PER_LONG;
 		bit_idx = evtchn % BITS_PER_LONG;
-		if (active_evtchns(cpu, s, word_idx) & (1ULL << bit_idx)) {
-			desc = irq_to_desc(irq);
-			if (desc)
-				generic_handle_irq_desc(irq, desc);
-		}
+		if (active_evtchns(cpu, s, word_idx) & (1ULL << bit_idx))
+			generic_handle_irq(irq);
 	}
 
 	/*
@@ -245,11 +241,8 @@ static void evtchn_2l_handle_events(unsi
 			port = (word_idx * BITS_PER_EVTCHN_WORD) + bit_idx;
 			irq = get_evtchn_to_irq(port);
 
-			if (irq != -1) {
-				desc = irq_to_desc(irq);
-				if (desc)
-					generic_handle_irq_desc(irq, desc);
-			}
+			if (irq != -1)
+				generic_handle_irq(irq);
 
 			bit_idx = (bit_idx + 1) % BITS_PER_EVTCHN_WORD;
 
Index: tip/drivers/xen/events/events_base.c
===================================================================
--- tip.orig/drivers/xen/events/events_base.c
+++ tip/drivers/xen/events/events_base.c
@@ -336,9 +336,8 @@ static void bind_evtchn_to_cpu(unsigned
 
 	BUG_ON(irq == -1);
 #ifdef CONFIG_SMP
-	cpumask_copy(irq_to_desc(irq)->irq_data.affinity, cpumask_of(cpu));
+	cpumask_copy(irq_get_irq_data(irq)->affinity, cpumask_of(cpu));
 #endif
-
 	xen_evtchn_port_bind_to_cpu(info, cpu);
 
 	info->cpu = cpu;
@@ -373,10 +372,8 @@ static void xen_irq_init(unsigned irq)
 {
 	struct irq_info *info;
 #ifdef CONFIG_SMP
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	/* By default all event channels notify CPU#0. */
-	cpumask_copy(desc->irq_data.affinity, cpumask_of(0));
+	cpumask_copy(irq_get_irq_data(irq)->affinity, cpumask_of(0));
 #endif
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
Index: tip/drivers/xen/events/events_fifo.c
===================================================================
--- tip.orig/drivers/xen/events/events_fifo.c
+++ tip/drivers/xen/events/events_fifo.c
@@ -235,14 +235,10 @@ static uint32_t clear_linked(volatile ev
 static void handle_irq_for_port(unsigned port)
 {
 	int irq;
-	struct irq_desc *desc;
 
 	irq = get_evtchn_to_irq(port);
-	if (irq != -1) {
-		desc = irq_to_desc(irq);
-		if (desc)
-			generic_handle_irq_desc(irq, desc);
-	}
+	if (irq != -1)
+		generic_handle_irq(irq);
 }
 
 static void consume_one_event(unsigned cpu,


