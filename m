Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbaEOT1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:27:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556AbaEOT0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:26:48 -0400
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Elliott@hp.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/6] x86, nmi:  Implement delayed irq_work mechanism to handle lost NMIs
Date: Thu, 15 May 2014 15:25:44 -0400
Message-Id: <1400181949-157170-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
References: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86's NMI is a fragile beast.  There are times when you can have to many
NMIs or too little.  We have addresses the times when you have to many by
implementing back-to-back NMI detection logic.  This patch attempts to
address the issue of losing NMIs.

A lost NMI situation can occur for example when during the processing of one
NMI, multiple NMIs come in.  Only one NMI can be latched at any given time,
therefore the second NMI would be dropped.  If the latched NMI was handled by
the PMI handler, then the current code logic would never call the SERR or
IO_CHK handlers to process the external NMI.

As a result the external NMI would be blocked from future NMIs (because it
would not be unmasked) and the critical event would not be serviced.

Of course these situations are rare, but with the frequency of the PMI events,
the situation is such that a rare external NMI could be accidentally dropped.

To workaround this small race, I implemented an irq_work item.  For every NMI
processed an irq_work item is queued (lazily) to send a simulated NMI on the
next clock tick.  The idea is to keep simulating NMIs until they pass through
all the handlers without any one claiming them.

The way the irq_work framework is structured only one cpu at a time will handle
the work to avoid an NMI storm on all the cpus.

I have tested this on an Ivy Bridge with 4 events going on all cpus to help
catch various corner cases.  The logic seems to work and under heavy load I
have seen irq_work_queue prevent up to 30-40 events from being queued because
of the small delay utilized during one iteration of an irq_work item.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/nmi.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index b4872b9..7b17864 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -110,6 +110,106 @@ static void nmi_max_handler(struct irq_work *w)
 		a->handler, whole_msecs, decimal_msecs);
 }
 
+/*
+ * setup a lazy irq work queue to handle dropped/lost NMIs
+ *
+ * Because of the way NMIs are shared and are edge triggered,
+ * lots of scenarios pop up that could cause us to lose or
+ * recieve an extra NMI.
+ *
+ * The nmi_delayed_work logic below is trying to handle
+ * the case where we lose an NMI.  How that happens is if
+ * two NMIs arrive roughly at the same time while currently
+ * processing another NMI.  Only one NMI can be latched,
+ * therefore the second NMI would be dropped.
+ *
+ * Why this matters even though we cycle through all the
+ * NMI handlers?  It matters because external NMI for
+ * SERR or IO_CHK currently gets ignored if a local NMI
+ * (like PMI is handled).  This can block the external
+ * NMI from:
+ * - causing proper notification of a critical event
+ * - block future NMIs from happening unti unmasked
+ *
+ * As a result we create a delayed irq work item, that
+ * will blindly check all the NMI handlers on the next
+ * timer tick to see if we missed an NMI.  It will continue
+ * to check until we cycle through cleanly and hit every
+ * handler.
+ */
+DEFINE_PER_CPU(bool, nmi_delayed_work_pending);
+
+static void nmi_delayed_work_func(struct irq_work *irq_work)
+{
+	DECLARE_BITMAP(nmi_mask, NR_CPUS);
+	cpumask_t *mask;
+
+	preempt_disable();
+
+	/*
+	 * Can't use send_IPI_self here because it will
+	 * send an NMI in IRQ context which is not what
+	 * we want.  Create a cpumask for local cpu and
+	 * force an IPI the normal way (not the shortcut).
+	 */
+	bitmap_zero(nmi_mask, NR_CPUS);
+	mask = to_cpumask(nmi_mask);
+	cpu_set(smp_processor_id(), *mask);
+
+	__this_cpu_xchg(nmi_delayed_work_pending, true);
+	apic->send_IPI_mask(to_cpumask(nmi_mask), NMI_VECTOR);
+
+	preempt_enable();
+}
+
+struct irq_work nmi_delayed_work =
+{
+	.func	= nmi_delayed_work_func,
+	.flags	= IRQ_WORK_LAZY,
+};
+
+static bool nmi_queue_work_clear(void)
+{
+	bool set = __this_cpu_read(nmi_delayed_work_pending);
+
+	__this_cpu_write(nmi_delayed_work_pending, false);
+
+	return set;
+}
+
+static int nmi_queue_work(void)
+{
+	bool queued = irq_work_queue(&nmi_delayed_work);
+
+	if (queued) {
+		/*
+		 * If the delayed NMI actually finds a 'dropped' NMI, the
+		 * work pending bit will never be cleared.  A new delayed
+		 * work NMI is supposed to be sent in that case.  But there
+		 * is no guarantee that the same cpu will be used.  So
+		 * pro-actively clear the flag here (the new self-IPI will
+		 * re-set it.
+		 *
+		 * However, there is a small chance that a real NMI and the
+		 * simulated one occur at the same time.  What happens is the
+		 * simulated IPI NMI sets the work_pending flag and then sends
+		 * the IPI.  At this point the irq_work allows a new work
+		 * event.  So when the simulated IPI is handled by a real NMI
+		 * handler it comes in here to queue more work.  Because
+		 * irq_work returns success, the work_pending bit is cleared.
+		 * The second part of the back-to-back NMI is kicked off, the
+		 * work_pending bit is not set and an unknown NMI is generated.
+		 * Therefore check the BUSY bit before clearing.  The theory is
+		 * if the BUSY bit is set, then there should be an NMI for this
+		 * cpu latched somewhere and will be cleared when it runs.
+		 */
+		if (!(nmi_delayed_work.flags & IRQ_WORK_BUSY))
+			nmi_queue_work_clear();
+	}
+
+	return 0;
+}
+
 static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
@@ -341,6 +441,9 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
 		 */
 		if (handled > 1)
 			__this_cpu_write(swallow_nmi, true);
+
+		/* kick off delayed work in case we swallowed external NMI */
+		nmi_queue_work();
 		return;
 	}
 
@@ -362,10 +465,16 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
 #endif
 		__this_cpu_add(nmi_stats.external, 1);
 		raw_spin_unlock(&nmi_reason_lock);
+		/* kick off delayed work in case we swallowed external NMI */
+		nmi_queue_work();
 		return;
 	}
 	raw_spin_unlock(&nmi_reason_lock);
 
+	/* expected delayed queued NMI? Don't flag as unknown */
+	if (nmi_queue_work_clear())
+		return;
+
 	/*
 	 * Only one NMI can be latched at a time.  To handle
 	 * this we may process multiple nmi handlers at once to
-- 
1.7.1

