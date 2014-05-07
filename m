Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaEGUhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:37:34 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:47316 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaEGUhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:37:32 -0400
Message-ID: <536A998A.4000307@tilera.com>
Date: Wed, 7 May 2014 16:37:30 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Tony Lu <zlu@tilera.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [patch 03/32] genirq: Provide generic hwirq allocation facility
References: <20140507153622.703412101@linutronix.de> <20140507154334.208629358@linutronix.de>
In-Reply-To: <20140507154334.208629358@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/2014 11:44 AM, Thomas Gleixner wrote:
> Not really the solution to the problem, but at least it confines the
> mess in the core code and allows to get rid of the create/destroy_irq
> variants from hell, i.e. 3 implementations with different semantics
> plus the x86 specific variants __create_irqs and create_irq_nr
> which have been invented in another circle of hell.
>
> [...]
>
> tile: Might use irq domains as well, but it has a very limited
>       interrupt space, so handling it via this functionality might be
>       the right thing to do even in the long run.

We have an internal change that we haven't upstreamed yet that makes
irqs actually (cpu,ipi) pairs, so that more irqs can be allocated.
As a result we allocate some irqs as bound to a specific IPI on a single
cpu, and some irqs get bound to a particular IPI registered on every cpu.

I'll have to set aside a bit of time to look more closely at how your
change interacts with the work we've done internally.  I've appended the
per-cpu IRQ change from our internal tree here (and cc'ed the author).
The API change is in the <asm/irq.h> diff at the very start.

--
From: Tony Lu <zlu@tilera.com>
Subject: [PATCH] tile: per-cpu IRQ support

With the change, we are no longer limited to 32 IRQ resources.
We support up to NR_CPUS*32 IRQ resources. Note there are some
IRQ-related API changes.

- create_irq(). Create an IRQ that should happen on every core, such
as Linux IPI reschedule, and mPIPE network ingress IRQ.

- create_irq_on_any(). Create an IRQ that should happen on a single
core. It chooses the core from non-dataplanes.

- create_irq_on(cpu). Create an IRQ that should happen on a single
core. The core is specified if cpu ID is valid, else if cpu=-1, this
function choose a core from non-dataplane.

This change also makes irq_disable/irq_enable into no-ops.  They are
currently used only by request_irq/free_irq. And in the request_irq/
free_irq context during shim driver initialization, we call the gxio
routines to configure the IRQ binding/unbinding, so there is no need
to do irq_disable/irq_enable twice.

Signed-off-by: Tony Lu <zlu@tilera.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/irq.h        |  48 +++++-
 arch/tile/kernel/irq.c             | 294 ++++++++++++++++++++++++++++++++-----
 arch/tile/kernel/pci_gx.c          |  91 ++++++------
 arch/tile/kernel/smp.c             |  18 ++-
 drivers/net/ethernet/tile/tilegx.c |   3 +-
 drivers/tty/hvc/hvc_tile.c         |   6 +-
 drivers/tty/serial/tilegx.c        |   9 +-
 drivers/usb/host/ehci-tilegx.c     |   9 +-
 drivers/usb/host/ohci-tilegx.c     |   9 +-
 9 files changed, 384 insertions(+), 103 deletions(-)

diff --git a/arch/tile/include/asm/irq.h b/arch/tile/include/asm/irq.h
index 33cff9a3058b..aa7577e80bc8 100644
--- a/arch/tile/include/asm/irq.h
+++ b/arch/tile/include/asm/irq.h
@@ -17,14 +17,33 @@
 
 #include <linux/hardirq.h>
 
-/* The hypervisor interface provides 32 IRQs. */
+/* The hypervisor interface provides 32 IPI events per core. */
+#define NR_IPI_EVENTS 32
+
+#if CHIP_HAS_IPI()
+/* 
+ * The number of supported IRQs. This can be set to a larger value
+ * (at most NR_CPUS*NR_IPI_EVENTS) that may be needed with more
+ * peripheral devices.
+ */
+#define NR_IRQS 256
+#else
 #define NR_IRQS 32
+#endif
 
-/* IRQ numbers used for linux IPIs. */
-#define IRQ_RESCHEDULE 0
+/* The IRQ number used for linux IPI reschedule. */
+extern int irq_reschedule;
+/* The IPI event used for irq_reschedule. */
+extern int irq_reschedule_event;
 
 #define irq_canonicalize(irq)   (irq)
 
+/* An IRQ number is bound to a core and an IPI event number. */
+struct irq_map {
+	int cpu;
+	int event;
+};
+
 void ack_bad_irq(unsigned int irq);
 
 /*
@@ -74,6 +93,29 @@ enum {
  */
 void tile_irq_activate(unsigned int irq, int tile_irq_type);
 
+/*
+ * Create an IRQ that is valid only on a single core. The core is
+ * specified by callers with the exception that this function will
+ * choose a core if cpu=-1.
+ */
+int create_irq_on(int cpu);
+
+/* 
+ * Create an IRQ that is valid only on a single core. The core is
+ * chosen from non-dataplanes by this function.
+ */
+static inline int create_irq_on_any(void)
+{
+	return create_irq_on(-1);
+}
+
+/* Create an IRQ that is valid on all cores. */
+int create_irq(void);
+
+/* Map an IRQ number to (cpu, event). For globally-valid IRQs, cpu=-1. */
+int tile_irq_get_cpu(int irq);
+int tile_irq_get_event(int irq);
+
 void setup_irq_regs(void);
 
 #endif /* _ASM_TILE_IRQ_H */
diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
index 906a76bdb31d..7fab97ae6f08 100644
--- a/arch/tile/kernel/irq.c
+++ b/arch/tile/kernel/irq.c
@@ -22,6 +22,7 @@
 #include <arch/spr_def.h>
 #include <asm/traps.h>
 #include <linux/perf_event.h>
+#include <linux/stddef.h>
 
 /* Bit-flag stored in irq_desc->chip_data to indicate HW-cleared irqs. */
 #define IS_HW_CLEARED 1
@@ -54,13 +55,39 @@ static DEFINE_PER_CPU(unsigned long, irq_disable_mask)
  */
 static DEFINE_PER_CPU(int, irq_depth);
 
-/* State for allocating IRQs on Gx. */
+#define IPI_EVENT_INVALID -1
+#define IRQ_INVALID -1
+#define IPI_CORE_INVALID -2
+
 #if CHIP_HAS_IPI()
-static unsigned long available_irqs = ((1UL << NR_IRQS) - 1) &
-				      (~(1UL << IRQ_RESCHEDULE));
-static DEFINE_SPINLOCK(available_irqs_lock);
+/* Mask of CPUs that should receive interrupts. */
+static struct cpumask intr_cpus_map;
+
+/* A global table mapping IRQ numbers to (cpu, event). */
+struct irq_map irq_map[NR_IRQS] = {
+	[0 ... NR_IRQS-1] = {
+		.cpu	= IPI_CORE_INVALID,
+		.event	= IPI_EVENT_INVALID,
+	}
+};
+
+/* A percpu array of IPI numbers for each core, mapping back to the IRQ. */
+static DEFINE_PER_CPU(int [NR_IPI_EVENTS], irq_event) = {
+	[0 ... NR_IPI_EVENTS - 1] = IRQ_INVALID,
+};
+
+static DEFINE_SPINLOCK(irq_events_lock);
+
 #endif
 
+static inline int tile_irq_get_irqnum(int event);
+int tile_irq_get_event(int irq);
+
+/* THe IRQ number used for Linux IPI reschedule. */
+int irq_reschedule;
+/* The IPI event used for irq_reschedule. */
+int irq_reschedule_event;
+
 #if CHIP_HAS_IPI()
 /* Use SPRs to manipulate device interrupts. */
 #define mask_irqs(irq_mask) __insn_mtspr(SPR_IPI_MASK_SET_K, irq_mask)
@@ -81,8 +108,8 @@ static DEFINE_SPINLOCK(available_irqs_lock);
 void tile_dev_intr(struct pt_regs *regs, int intnum)
 {
 	int depth = __get_cpu_var(irq_depth)++;
-	unsigned long original_irqs;
-	unsigned long remaining_irqs;
+	unsigned long original_events;
+	unsigned long remaining_events;
 	struct pt_regs *old_regs;
 
 #if CHIP_HAS_IPI()
@@ -93,17 +120,17 @@ void tile_dev_intr(struct pt_regs *regs, int intnum)
 	 * we're going to handle.
 	 */
 	unsigned long masked = __insn_mfspr(SPR_IPI_MASK_K);
-	original_irqs = __insn_mfspr(SPR_IPI_EVENT_K) & ~masked;
-	__insn_mtspr(SPR_IPI_MASK_SET_K, original_irqs);
+	original_events = __insn_mfspr(SPR_IPI_EVENT_K) & ~masked;
+	__insn_mtspr(SPR_IPI_MASK_SET_K, original_events);
 #else
 	/*
 	 * Hypervisor performs the equivalent of the Gx code above and
 	 * then puts the pending interrupt mask into a system save reg
 	 * for us to find.
 	 */
-	original_irqs = __insn_mfspr(SPR_SYSTEM_SAVE_K_3);
+	original_events = __insn_mfspr(SPR_SYSTEM_SAVE_K_3);
 #endif
-	remaining_irqs = original_irqs;
+	remaining_events = original_events;
 
 	/* Track time spent here in an interrupt context. */
 	old_regs = set_irq_regs(regs);
@@ -121,14 +148,17 @@ void tile_dev_intr(struct pt_regs *regs, int intnum)
 		}
 	}
 #endif
-	while (remaining_irqs) {
-		unsigned long irq = __ffs(remaining_irqs);
-		remaining_irqs &= ~(1UL << irq);
+	while (remaining_events) {
+		unsigned long irq, event = __ffs(remaining_events);
+		remaining_events &= ~(1UL << event);
 
 		/* Count device irqs; Linux IPIs are counted elsewhere. */
-		if (irq != IRQ_RESCHEDULE)
+		if (event != irq_reschedule_event)
 			__get_cpu_var(irq_stat).irq_dev_intr_count++;
 
+		/* Convert IPI event to irq number. */
+		irq = tile_irq_get_irqnum(event);
+
 		generic_handle_irq(irq);
 	}
 
@@ -150,6 +180,19 @@ void tile_dev_intr(struct pt_regs *regs, int intnum)
 	set_irq_regs(old_regs);
 }
 
+#if CHIP_HAS_IPI()
+/*
+ * Do nothing. We leave all IPI events unmasked on all cores by default.
+ */
+static void tile_irq_chip_enable(struct irq_data *d)
+{
+}
+
+static void tile_irq_chip_disable(struct irq_data *d)
+{
+}
+
+#else
 
 /*
  * Remove an irq from the disabled mask.  If we're in an interrupt
@@ -175,17 +218,18 @@ static void tile_irq_chip_disable(struct irq_data *d)
 	mask_irqs(1UL << d->irq);
 	put_cpu_var(irq_disable_mask);
 }
+#endif
 
 /* Mask an interrupt. */
 static void tile_irq_chip_mask(struct irq_data *d)
 {
-	mask_irqs(1UL << d->irq);
+	mask_irqs(1UL << tile_irq_get_event(d->irq));
 }
 
 /* Unmask an interrupt. */
 static void tile_irq_chip_unmask(struct irq_data *d)
 {
-	unmask_irqs(1UL << d->irq);
+	unmask_irqs(1UL << tile_irq_get_event(d->irq));
 }
 
 /*
@@ -195,7 +239,7 @@ static void tile_irq_chip_unmask(struct irq_data *d)
 static void tile_irq_chip_ack(struct irq_data *d)
 {
 	if ((unsigned long)irq_data_get_irq_chip_data(d) != IS_HW_CLEARED)
-		clear_irqs(1UL << d->irq);
+		clear_irqs(1UL << tile_irq_get_event(d->irq));
 }
 
 /*
@@ -204,8 +248,9 @@ static void tile_irq_chip_ack(struct irq_data *d)
  */
 static void tile_irq_chip_eoi(struct irq_data *d)
 {
-	if (!(__get_cpu_var(irq_disable_mask) & (1UL << d->irq)))
-		unmask_irqs(1UL << d->irq);
+	int event = tile_irq_get_event(d->irq);
+	if (!(__get_cpu_var(irq_disable_mask) & (1UL << event)))
+		unmask_irqs(1UL << event);
 }
 
 static struct irq_chip tile_irq_chip = {
@@ -283,33 +328,216 @@ int arch_show_interrupts(struct seq_file *p, int prec)
  */
 
 #if CHIP_HAS_IPI()
+
+int tile_irq_get_cpu(int irq)
+{
+	int cpu;
+
+	BUG_ON(irq < 0 || irq >= NR_IRQS);
+	cpu = irq_map[irq].cpu;
+	BUG_ON(cpu == IPI_CORE_INVALID);
+	return cpu;
+}
+EXPORT_SYMBOL(tile_irq_get_cpu);
+
+int tile_irq_get_event(int irq)
+{
+	int event;
+
+	BUG_ON(irq < 0 || irq >= NR_IRQS);
+	event = irq_map[irq].event;
+	BUG_ON(event < 0 || event >= NR_IPI_EVENTS);
+	return event;
+}
+EXPORT_SYMBOL(tile_irq_get_event);
+
+static inline int tile_irq_get_irqnum(int event)
+{
+	int irq;
+
+	BUG_ON(event >= NR_IPI_EVENTS);
+	irq = __get_cpu_var(irq_event)[event];
+	BUG_ON(irq < 0 || irq >= NR_IRQS);
+	return irq;
+}
+
+static bool global_event_available(int event)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		if (per_cpu(irq_event, cpu)[event] != IPI_EVENT_INVALID)
+			return false;
+
+	return true;
+}
+
 int create_irq(void)
 {
 	unsigned long flags;
-	int result;
-
-	spin_lock_irqsave(&available_irqs_lock, flags);
-	if (available_irqs == 0)
-		result = -ENOMEM;
-	else {
-		result = __ffs(available_irqs);
-		available_irqs &= ~(1UL << result);
-		dynamic_irq_init(result);
+	int irq, event, cpu;
+	int result = -ENOMEM;
+
+	spin_lock_irqsave(&irq_events_lock, flags);
+
+	/* Get an unused IRQ number. */
+	for (irq = 0; irq < NR_IRQS; irq++) {
+		if (irq_map[irq].event == IRQ_INVALID)
+			break;
 	}
-	spin_unlock_irqrestore(&available_irqs_lock, flags);
 
+	if (irq == NR_IRQS)
+		goto out;
+
+	/*
+	 * Get a global IPI event that is not used on every core.
+	 * Search from the low end of the IPI event space.
+	 */
+	for (event = 0; event < NR_IPI_EVENTS; event++) {
+		if (global_event_available(event))
+			break;
+	}
+
+	if (event == NR_IPI_EVENTS)
+		goto out;
+
+	/* Set the IPI event for each core. */
+	for_each_possible_cpu(cpu)
+		per_cpu(irq_event, cpu)[event] = irq;
+
+	/*
+ 	 * Record the core ID and event number for this irq. Core==-1 means
+ 	 * it is a global irq happening on every core.
+ 	 */
+	irq_map[irq].cpu = -1;
+	irq_map[irq].event = event;
+
+	result = irq;
+	dynamic_irq_init(result);
+
+out:
+	spin_unlock_irqrestore(&irq_events_lock, flags);
 	return result;
 }
 EXPORT_SYMBOL(create_irq);
 
+/*
+ * Create an irq on a specified core, if cpu == -1, this function selects
+ * a core.
+ */
+int create_irq_on(int cpu)
+{
+	unsigned long flags;
+	int event, irq = -ENOMEM;
+
+	BUG_ON(cpu >= NR_CPUS || cpu < -1);
+
+	spin_lock_irqsave(&irq_events_lock, flags);
+
+	/* 
+	 * Check if we ran out of available intr CPUs; need to repopulate
+	 * the intr cpu set.
+	 */
+	if (cpumask_weight(&intr_cpus_map) == 0) {
+		cpumask_copy(&intr_cpus_map, cpu_online_mask);
+
+#ifdef CONFIG_DATAPLANE
+		/* Remove dataplane cpus. */
+		cpumask_andnot(&intr_cpus_map, &intr_cpus_map, &dataplane_map);
+#endif
+	}
+
+	if (cpu == -1) {
+		/* cpu id was not specified. */
+		for (event = NR_IPI_EVENTS - 1; event >= 0; event--) {
+			for_each_cpu(cpu, &intr_cpus_map) {
+				if (per_cpu(irq_event, cpu)[event] ==
+				    IRQ_INVALID) {
+					goto event_got;
+				}
+			}
+
+		}
+	} else {
+		/* cpu id was specified. */
+		for (event = NR_IPI_EVENTS - 1; event >= 0; event--) {
+			if (per_cpu(irq_event, cpu)[event] == IRQ_INVALID)
+				break;
+		}
+	}
+
+event_got:
+	if (event <= 0) {
+		pr_err("Run out of IPI events, you may need to decrease "
+			"the number of dataplane tiles, or create irq "
+			"on another CPU.\n");
+		goto out;
+	}
+
+	/* Get an unused irq number. */
+	for (irq = 0; irq < NR_IRQS; irq++) {
+		if (irq_map[irq].event == IPI_EVENT_INVALID)
+			break;
+	}
+
+	if (irq == NR_IRQS) {
+		pr_err("Run out of IRQS, you need to increase NR_IRQS\n");
+		goto out;
+	}
+
+	/*
+ 	 * Remove the cpu from the intr cpu set,  so that next irq allocation
+	 * will start from next cpu.
+ 	 */
+	cpu_clear(cpu, intr_cpus_map);
+
+	/* Set the maps. */
+	per_cpu(irq_event, cpu)[event] = irq;
+	irq_map[irq].cpu = cpu;
+	irq_map[irq].event = event;
+	dynamic_irq_init(irq);
+
+out:
+	spin_unlock_irqrestore(&irq_events_lock, flags);
+	return irq;
+}
+EXPORT_SYMBOL(create_irq_on);
+
 void destroy_irq(unsigned int irq)
 {
 	unsigned long flags;
+	int event, cpu;
+
+	spin_lock_irqsave(&irq_events_lock, flags);
+
+	cpu = tile_irq_get_cpu(irq);
+	event = tile_irq_get_event(irq);
+
+	if (cpu == -1) {
+		for_each_possible_cpu(cpu) {
+			per_cpu(irq_event, cpu)[event] = IRQ_INVALID;
+		}
+	} else {
+		per_cpu(irq_event, cpu)[event] = IRQ_INVALID;
+	}
+
+	irq_map[irq].cpu = IPI_CORE_INVALID;
+	irq_map[irq].event = IPI_EVENT_INVALID;
 
-	spin_lock_irqsave(&available_irqs_lock, flags);
-	available_irqs |= (1UL << irq);
 	dynamic_irq_cleanup(irq);
-	spin_unlock_irqrestore(&available_irqs_lock, flags);
+	spin_unlock_irqrestore(&irq_events_lock, flags);
 }
 EXPORT_SYMBOL(destroy_irq);
-#endif
+
+#else /* !CHIP_HAS_IPI() */
+
+static inline int tile_irq_get_irqnum(int event)
+{
+	return event;
+}
+
+int tile_irq_get_event(int irq)
+{
+	return irq;
+}
+#endif /* CHIP_HAS_IPI() */
diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index 077b7bc437e5..be371c02cd11 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -105,9 +105,6 @@ int num_rc_controllers;
 
 static struct pci_ops tile_cfg_ops;
 
-/* Mask of CPUs that should receive PCIe interrupts. */
-static struct cpumask intr_cpus_map;
-
 /* We don't need to worry about the alignment of resources. */
 resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 				       resource_size_t size,
@@ -117,33 +114,6 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 }
 EXPORT_SYMBOL(pcibios_align_resource);
 
-/*
- * Pick a CPU to receive and handle the PCIe interrupts, based on the IRQ #.
- * For now, we simply send interrupts to non-dataplane CPUs.
- * We may implement methods to allow user to specify the target CPUs,
- * e.g. via boot arguments.
- */
-static int tile_irq_cpu(int irq)
-{
-	unsigned int count;
-	int i = 0;
-	int cpu;
-
-	count = cpumask_weight(&intr_cpus_map);
-	if (unlikely(count == 0)) {
-		pr_warning("intr_cpus_map empty, interrupts will be"
-			   " delievered to dataplane tiles\n");
-		return irq % (smp_height * smp_width);
-	}
-
-	count = irq % count;
-	for_each_cpu(cpu, &intr_cpus_map) {
-		if (i++ == count)
-			break;
-	}
-	return cpu;
-}
-
 /* Open a file descriptor to the TRIO shim. */
 static int tile_pcie_open(int trio_index)
 {
@@ -274,23 +244,39 @@ static int __init tile_trio_init(void)
 }
 postcore_initcall(tile_trio_init);
 
+/*
+ * Do nothing. We leave all IPI events unmasked on all cores by default.
+ */
+static void tilegx_legacy_irq_enable(struct irq_data *d)
+{
+}
+
+static void tilegx_legacy_irq_disable(struct irq_data *d)
+{
+}
+
 static void tilegx_legacy_irq_ack(struct irq_data *d)
 {
-	__insn_mtspr(SPR_IPI_EVENT_RESET_K, 1UL << d->irq);
+	__insn_mtspr(SPR_IPI_EVENT_RESET_K,
+		     1UL << tile_irq_get_event(d->irq));
 }
 
 static void tilegx_legacy_irq_mask(struct irq_data *d)
 {
-	__insn_mtspr(SPR_IPI_MASK_SET_K, 1UL << d->irq);
+	__insn_mtspr(SPR_IPI_MASK_SET_K,
+		     1UL << tile_irq_get_event(d->irq));
 }
 
 static void tilegx_legacy_irq_unmask(struct irq_data *d)
 {
-	__insn_mtspr(SPR_IPI_MASK_RESET_K, 1UL << d->irq);
+	__insn_mtspr(SPR_IPI_MASK_RESET_K,
+		     1UL << tile_irq_get_event(d->irq));
 }
 
 static struct irq_chip tilegx_legacy_irq_chip = {
 	.name			= "tilegx_legacy_irq",
+	.irq_enable		= tilegx_legacy_irq_enable,
+	.irq_disable		= tilegx_legacy_irq_disable,
 	.irq_ack		= tilegx_legacy_irq_ack,
 	.irq_mask		= tilegx_legacy_irq_mask,
 	.irq_unmask		= tilegx_legacy_irq_unmask,
@@ -342,15 +328,12 @@ static int tile_init_irqs(struct pci_controller *controller)
 	int irq;
 	int result;
 
-	cpumask_copy(&intr_cpus_map, cpu_online_mask);
-
-
 	for (i = 0; i < 4; i++) {
 		gxio_trio_context_t *context = controller->trio;
 		int cpu;
 
 		/* Ask the kernel to allocate an IRQ. */
-		irq = create_irq();
+		irq = create_irq_on_any();
 		if (irq < 0) {
 			pr_err("PCI: no free irq vectors, failed for %d\n", i);
 
@@ -359,12 +342,13 @@ static int tile_init_irqs(struct pci_controller *controller)
 		controller->irq_intx_table[i] = irq;
 
 		/* Distribute the 4 IRQs to different tiles. */
-		cpu = tile_irq_cpu(irq);
+		cpu = tile_irq_get_cpu(irq);
 
 		/* Configure the TRIO intr binding for this IRQ. */
 		result = gxio_trio_config_legacy_intr(context, cpu_x(cpu),
 						      cpu_y(cpu), KERNEL_PL,
-						      irq, controller->mac, i);
+						      tile_irq_get_event(irq),
+						      controller->mac, i);
 		if (result < 0) {
 			pr_err("PCI: MAC intx config failed for %d\n", i);
 
@@ -1459,26 +1443,42 @@ static unsigned int tilegx_msi_startup(struct irq_data *d)
 	return 0;
 }
 
+/*
+ * Do nothing. We leave all IPI events unmasked on all cores by default.
+ */
+static void tilegx_msi_enable(struct irq_data *d)
+{
+}
+
+static void tilegx_msi_disable(struct irq_data *d)
+{
+}
+
 static void tilegx_msi_ack(struct irq_data *d)
 {
-	__insn_mtspr(SPR_IPI_EVENT_RESET_K, 1UL << d->irq);
+	__insn_mtspr(SPR_IPI_EVENT_RESET_K,
+		     1UL << tile_irq_get_event(d->irq));
 }
 
 static void tilegx_msi_mask(struct irq_data *d)
 {
 	mask_msi_irq(d);
-	__insn_mtspr(SPR_IPI_MASK_SET_K, 1UL << d->irq);
+	__insn_mtspr(SPR_IPI_MASK_SET_K,
+		     1UL << tile_irq_get_event(d->irq));
 }
 
 static void tilegx_msi_unmask(struct irq_data *d)
 {
-	__insn_mtspr(SPR_IPI_MASK_RESET_K, 1UL << d->irq);
+	__insn_mtspr(SPR_IPI_MASK_RESET_K,
+		     1UL << tile_irq_get_event(d->irq));
 	unmask_msi_irq(d);
 }
 
 static struct irq_chip tilegx_msi_chip = {
 	.name			= "tilegx_msi",
 	.irq_startup		= tilegx_msi_startup,
+	.irq_enable		= tilegx_msi_enable,
+	.irq_disable		= tilegx_msi_disable,
 	.irq_ack		= tilegx_msi_ack,
 	.irq_mask		= tilegx_msi_mask,
 	.irq_unmask		= tilegx_msi_unmask,
@@ -1500,7 +1500,7 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	int irq;
 	int ret;
 
-	irq = create_irq();
+	irq = create_irq_on_any();
 	if (irq < 0)
 		return irq;
 
@@ -1570,14 +1570,15 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	}
 
 	/* We try to distribute different IRQs to different tiles. */
-	cpu = tile_irq_cpu(irq);
+	cpu = tile_irq_get_cpu(irq);
 
 	/*
 	 * Now call up to the HV to configure the MSI interrupt and
 	 * set up the IPI binding.
 	 */
 	ret = gxio_trio_config_msi_intr(trio_context, cpu_x(cpu), cpu_y(cpu),
-					KERNEL_PL, irq, controller->mac,
+					KERNEL_PL, tile_irq_get_event(irq),
+				        controller->mac,
 					mem_map, mem_map_base, mem_map_limit,
 					trio_context->asid);
 	if (ret < 0) {
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index 01e8ab29f43a..fbba5c0000b6 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -185,7 +185,7 @@ void flush_icache_range(unsigned long start, unsigned long end)
 }
 
 
-/* Called when smp_send_reschedule() triggers IRQ_RESCHEDULE. */
+/* Called when smp_send_reschedule() triggers irq_reschedule. */
 static irqreturn_t handle_reschedule_ipi(int irq, void *token)
 {
 	__get_cpu_var(irq_stat).irq_resched_count++;
@@ -218,11 +218,17 @@ void __init ipi_init(void)
 		offset = PFN_PHYS(pte_pfn(pte));
 		ipi_mappings[cpu] = ioremap_prot(offset, PAGE_SIZE, pte);
 	}
+
+	irq_reschedule = create_irq();
+	irq_reschedule_event = tile_irq_get_event(irq_reschedule);
+#else
+	irq_reschedule = 0;
+	irq_reschedule_event = irq_reschedule;
 #endif
 
-	/* Bind handle_reschedule_ipi() to IRQ_RESCHEDULE. */
-	tile_irq_activate(IRQ_RESCHEDULE, TILE_IRQ_PERCPU);
-	BUG_ON(setup_irq(IRQ_RESCHEDULE, &resched_action));
+	/* Bind handle_reschedule_ipi() to irq_reschedule. */
+	tile_irq_activate(irq_reschedule, TILE_IRQ_PERCPU);
+	BUG_ON(setup_irq(irq_reschedule, &resched_action));
 }
 
 #if CHIP_HAS_IPI()
@@ -237,7 +243,7 @@ void smp_send_reschedule(int cpu)
 	 * directed at the PCI shim.  For now, just do a raw store,
 	 * casting away the __iomem attribute.
 	 */
-	((unsigned long __force *)ipi_mappings[cpu])[IRQ_RESCHEDULE] = 0;
+	((unsigned long __force *)ipi_mappings[cpu])[irq_reschedule_event] = 0;
 }
 
 #else
@@ -250,7 +256,7 @@ void smp_send_reschedule(int cpu)
 
 	coord.y = cpu_y(cpu);
 	coord.x = cpu_x(cpu);
-	hv_trigger_ipi(coord, IRQ_RESCHEDULE);
+	hv_trigger_ipi(coord, irq_reschedule);
 }
 
 #endif /* CHIP_HAS_IPI() */
diff --git a/drivers/net/ethernet/tile/tilegx.c b/drivers/net/ethernet/tile/tilegx.c
index 7e1c91d41a87..d98f3becc7e1 100644
--- a/drivers/net/ethernet/tile/tilegx.c
+++ b/drivers/net/ethernet/tile/tilegx.c
@@ -1233,7 +1233,8 @@ static int tile_net_setup_interrupts(struct net_device *dev)
 		struct tile_net_info *info = &per_cpu(per_cpu_info, cpu);
 		if (info->mpipe[instance].has_iqueue) {
 			gxio_mpipe_request_notif_ring_interrupt(&md->context,
-				cpu_x(cpu), cpu_y(cpu), KERNEL_PL, irq,
+				cpu_x(cpu), cpu_y(cpu), KERNEL_PL,
+				tile_irq_get_event(irq),
 				info->mpipe[instance].iqueue.ring);
 		}
 	}
diff --git a/drivers/tty/hvc/hvc_tile.c b/drivers/tty/hvc/hvc_tile.c
index af8cdaa1dcb9..602d18543eb0 100644
--- a/drivers/tty/hvc/hvc_tile.c
+++ b/drivers/tty/hvc/hvc_tile.c
@@ -81,7 +81,7 @@ static int hvc_tile_get_chars(uint32_t vt, char *buf, int count)
 static int hvc_tile_notifier_add_irq(struct hvc_struct *hp, int irq)
 {
 	int rc;
-	int cpu = raw_smp_processor_id();  /* Choose an arbitrary cpu */
+	int cpu = tile_irq_get_cpu(irq);
 	HV_Coord coord = { .x = cpu_x(cpu), .y = cpu_y(cpu) };
 
 	rc = notifier_add_irq(hp, irq);
@@ -93,7 +93,7 @@ static int hvc_tile_notifier_add_irq(struct hvc_struct *hp, int irq)
 	 * If the hypervisor returns an error, we still return 0, so that
 	 * we can fall back to polling.
 	 */
-	if (hv_console_set_ipi(KERNEL_PL, irq, coord) < 0)
+	if (hv_console_set_ipi(KERNEL_PL, tile_irq_get_event(irq), coord) < 0)
 		notifier_del_irq(hp, irq);
 
 	return 0;
@@ -133,7 +133,7 @@ static int hvc_tile_probe(struct platform_device *pdev)
 	int tile_hvc_irq;
 
 	/* Create our IRQ and register it. */
-	tile_hvc_irq = create_irq();
+	tile_hvc_irq = create_irq_on_any();
 	if (tile_hvc_irq < 0)
 		return -ENXIO;
 
diff --git a/drivers/tty/serial/tilegx.c b/drivers/tty/serial/tilegx.c
index f92d7e6bd876..434ba89522fe 100644
--- a/drivers/tty/serial/tilegx.c
+++ b/drivers/tty/serial/tilegx.c
@@ -339,8 +339,7 @@ static int tilegx_startup(struct uart_port *port)
 {
 	struct tile_uart_port *tile_uart;
 	gxio_uart_context_t *context;
-	int ret = 0;
-	int cpu = raw_smp_processor_id();  /* pick an arbitrary cpu */
+	int cpu, ret = 0;
 
 	tile_uart = container_of(port, struct tile_uart_port, uart);
 	if (mutex_lock_interruptible(&tile_uart->mutex))
@@ -359,7 +358,7 @@ static int tilegx_startup(struct uart_port *port)
 		}
 
 		/* Create our IRQs. */
-		port->irq = create_irq();
+		port->irq = create_irq_on_any();
 		if (port->irq < 0)
 			goto err_uart_dest;
 		tile_irq_activate(port->irq, TILE_IRQ_PERCPU);
@@ -371,9 +370,11 @@ static int tilegx_startup(struct uart_port *port)
 			goto err_dest_irq;
 
 		/* Request that the hardware start sending us interrupts. */
+		cpu = tile_irq_get_cpu(port->irq);
 		tile_uart->irq_cpu = cpu;
 		ret = gxio_uart_cfg_interrupt(context, cpu_x(cpu), cpu_y(cpu),
-					      KERNEL_PL, port->irq);
+					      KERNEL_PL,
+					      tile_irq_get_event(port->irq));
 		if (ret)
 			goto err_free_irq;
 
diff --git a/drivers/usb/host/ehci-tilegx.c b/drivers/usb/host/ehci-tilegx.c
index f3713d32c9a1..4798576b5ddb 100644
--- a/drivers/usb/host/ehci-tilegx.c
+++ b/drivers/usb/host/ehci-tilegx.c
@@ -103,8 +103,7 @@ static int ehci_hcd_tilegx_drv_probe(struct platform_device *pdev)
 	struct ehci_hcd *ehci;
 	struct tilegx_usb_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	pte_t pte = { 0 };
-	int my_cpu = smp_processor_id();
-	int ret;
+	int my_cpu, ret;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -142,18 +141,20 @@ static int ehci_hcd_tilegx_drv_probe(struct platform_device *pdev)
 	ehci->hcs_params = readl(&ehci->caps->hcs_params);
 
 	/* Create our IRQs and register them. */
-	pdata->irq = create_irq();
+	pdata->irq = create_irq_on_any();
 	if (pdata->irq < 0) {
 		ret = -ENXIO;
 		goto err_no_irq;
 	}
 
+	my_cpu = tile_irq_get_cpu(pdata->irq);
 	tile_irq_activate(pdata->irq, TILE_IRQ_PERCPU);
 
 	/* Configure interrupts. */
 	ret = gxio_usb_host_cfg_interrupt(&pdata->usb_ctx,
 					  cpu_x(my_cpu), cpu_y(my_cpu),
-					  KERNEL_PL, pdata->irq);
+					  KERNEL_PL,
+					  tile_irq_get_event(pdata->irq));
 	if (ret) {
 		ret = -ENXIO;
 		goto err_have_irq;
diff --git a/drivers/usb/host/ohci-tilegx.c b/drivers/usb/host/ohci-tilegx.c
index 0b183e0b0a8a..b8a100be2d44 100644
--- a/drivers/usb/host/ohci-tilegx.c
+++ b/drivers/usb/host/ohci-tilegx.c
@@ -97,8 +97,7 @@ static int ohci_hcd_tilegx_drv_probe(struct platform_device *pdev)
 	struct usb_hcd *hcd;
 	struct tilegx_usb_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	pte_t pte = { 0 };
-	int my_cpu = smp_processor_id();
-	int ret;
+	int my_cpu, ret;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -129,18 +128,20 @@ static int ohci_hcd_tilegx_drv_probe(struct platform_device *pdev)
 	tilegx_start_ohc();
 
 	/* Create our IRQs and register them. */
-	pdata->irq = create_irq();
+	pdata->irq = create_irq_on_any();
 	if (pdata->irq < 0) {
 		ret = -ENXIO;
 		goto err_no_irq;
 	}
 
+	my_cpu = tile_irq_get_cpu(pdata->irq);
 	tile_irq_activate(pdata->irq, TILE_IRQ_PERCPU);
 
 	/* Configure interrupts. */
 	ret = gxio_usb_host_cfg_interrupt(&pdata->usb_ctx,
 					  cpu_x(my_cpu), cpu_y(my_cpu),
-					  KERNEL_PL, pdata->irq);
+					  KERNEL_PL,
+					  tile_irq_get_event(pdata->irq));
 	if (ret) {
 		ret = -ENXIO;
 		goto err_have_irq;

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

