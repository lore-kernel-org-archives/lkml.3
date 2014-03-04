Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaCDQlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:41:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41525 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaCDQlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:41:37 -0500
Date: Tue, 4 Mar 2014 08:40:51 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-589d03e93f6cd595f68891e48f0804f2c8f38aae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, peterz@infradead.org,
        xen-devel@lists.xenproject.org, tglx@linutronix.de,
        david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, peterz@infradead.org,
        xen-devel@lists.xenproject.org, tglx@linutronix.de,
        david.vrabel@citrix.com
In-Reply-To: <20140223212738.222412125@linutronix.de>
References: <20140223212738.222412125@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] xen: Use the proper irq functions
Git-Commit-ID: 589d03e93f6cd595f68891e48f0804f2c8f38aae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  589d03e93f6cd595f68891e48f0804f2c8f38aae
Gitweb:     http://git.kernel.org/tip/589d03e93f6cd595f68891e48f0804f2c8f38aae
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Feb 2014 21:40:18 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 17:37:52 +0100

xen: Use the proper irq functions

generic_handler_irq() already tests for !desc so use this instead of
generic_handle_irq_desc().

Use irq_get_irq_data() instead of desc->irq_data.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Xen <xen-devel@lists.xenproject.org>
Link: http://lkml.kernel.org/r/20140223212738.222412125@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/xen/events/events_2l.c   | 15 ++++-----------
 drivers/xen/events/events_base.c |  7 ++-----
 drivers/xen/events/events_fifo.c |  8 ++------
 3 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/xen/events/events_2l.c b/drivers/xen/events/events_2l.c
index d7ff917..5db43fc 100644
--- a/drivers/xen/events/events_2l.c
+++ b/drivers/xen/events/events_2l.c
@@ -166,7 +166,6 @@ static void evtchn_2l_handle_events(unsigned cpu)
 	int start_word_idx, start_bit_idx;
 	int word_idx, bit_idx;
 	int i;
-	struct irq_desc *desc;
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
 
@@ -176,11 +175,8 @@ static void evtchn_2l_handle_events(unsigned cpu)
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
@@ -245,11 +241,8 @@ static void evtchn_2l_handle_events(unsigned cpu)
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
 
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index f4a9e33..7fea02c 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -336,9 +336,8 @@ static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
 
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
diff --git a/drivers/xen/events/events_fifo.c b/drivers/xen/events/events_fifo.c
index 1de2a19..96109a9 100644
--- a/drivers/xen/events/events_fifo.c
+++ b/drivers/xen/events/events_fifo.c
@@ -235,14 +235,10 @@ static uint32_t clear_linked(volatile event_word_t *word)
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
