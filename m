Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbbATMZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:25:51 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38730 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbbATMZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:25:48 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v5] arm: perf: Directly handle SMP platforms with one SPI
Date: Tue, 20 Jan 2015 12:25:35 +0000
Message-Id: <1421756735-19699-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416581603-30557-1-git-send-email-daniel.thompson@linaro.org>
References: <1416581603-30557-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some ARM platforms mux the PMU interrupt of every core into a single
SPI. On such platforms if the PMU of any core except 0 raises an interrupt
then it cannot be serviced and eventually, if you are lucky, the spurious
irq detection might forcefully disable the interrupt.

On these SoCs it is not possible to determine which core raised the
interrupt so workaround this issue by queuing irqwork on the other
cores whenever the primary interrupt handler is unable to service the
interrupt.

The u8500 platform has an alternative workaround that dynamically alters
the affinity of the PMU interrupt. This workaround logic is no longer
required so the original code is removed as is the hook it relied upon.

Tested on imx6q (which has fours cores/PMUs all muxed to a single SPI)
using a simple soak, combined perf and CPU hotplug soak and using
perf fuzzer's fast_repro.sh.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---

Notes:
    v2 was tested on u8500 (thanks to Linus Walleij). v4 doesn't change
    anything conceptual but the changes were sufficient for me not to
    preserve the Tested-By:.
    
    v5:
     * Removed the work queue nonsense; being completely race-free requires
       us to take a mutex or avoid dispatch from interrupt (Will Deacon).
       Replacement code can potentially race with a CPU hot unplug however
       it is careful to minimise exposure, to mitigate harmful effects and
       has fairly prominent comments.
    
    v4:
     * Ripped out the logic that tried to preserve the operation of the
       spurious interrupt detector. It was complex and not really needed
       (Will Deacon).
     * Removed a redundant memory barrier and added a comment explaining
       why it is not needed (Will Deacon).
     * Made fully safe w.r.t. hotplug by falling back to a work queue
       if there is a hotplug operation in flight when the PMU interrupt
       comes in (Will Deacon). The work queue code paths have been tested
       synthetically (by changing the if condition).
     * Posted the correct, as in compilable and tested, version of the code
       (Will Deacon).
    
    v3:
     * Removed function pointer indirection when deploying workaround code
       and reorganise the code accordingly (Mark Rutland).
     * Move the workaround state tracking into the existing percpu data
       structure (Mark Rutland).
     * Renamed cret to percpu_ret and rewrote the comment describing the
       purpose of this variable (Mark Rutland).
     * Copy the cpu_online_mask and use that to act on a consistent set of
       cpus throughout the workaround (Mark Rutland).
     * Changed "single_irq" to "muxed_spi" to more explicitly describe
       the problem.
    
    v2:
     * Fixed build problems on systems without SMP.
    
    v1:
     * Thanks to Lucas Stach, Russell King and Thomas Gleixner for
       critiquing an older, completely different way to tackle the
       same problem.
    

 arch/arm/include/asm/pmu.h       |  12 ++++
 arch/arm/kernel/perf_event.c     |   9 +--
 arch/arm/kernel/perf_event_cpu.c | 128 +++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/perf_event_v7.c  |   2 +-
 arch/arm/mach-ux500/cpu-db8500.c |  29 ---------
 5 files changed, 142 insertions(+), 38 deletions(-)

diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
index b1596bd59129..dfef7904b790 100644
--- a/arch/arm/include/asm/pmu.h
+++ b/arch/arm/include/asm/pmu.h
@@ -87,6 +87,14 @@ struct pmu_hw_events {
 	 * already have to allocate this struct per cpu.
 	 */
 	struct arm_pmu		*percpu_pmu;
+
+#ifdef CONFIG_SMP
+	/*
+	 * This is used to schedule workaround logic on platforms where all
+	 * the PMUs are attached to a single SPI.
+	 */
+	struct irq_work work;
+#endif
 };

 struct arm_pmu {
@@ -117,6 +125,10 @@ struct arm_pmu {
 	struct platform_device	*plat_device;
 	struct pmu_hw_events	__percpu *hw_events;
 	struct notifier_block	hotplug_nb;
+#ifdef CONFIG_SMP
+	int			muxed_spi_workaround_irq;
+	atomic_t		remaining_irq_work;
+#endif
 };

 #define to_arm_pmu(p) (container_of(p, struct arm_pmu, pmu))
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index f7c65adaa428..e5c537b57f94 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -299,8 +299,6 @@ validate_group(struct perf_event *event)
 static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
 {
 	struct arm_pmu *armpmu;
-	struct platform_device *plat_device;
-	struct arm_pmu_platdata *plat;
 	int ret;
 	u64 start_clock, finish_clock;

@@ -311,14 +309,9 @@ static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
 	 * dereference.
 	 */
 	armpmu = *(void **)dev;
-	plat_device = armpmu->plat_device;
-	plat = dev_get_platdata(&plat_device->dev);

 	start_clock = sched_clock();
-	if (plat && plat->handle_irq)
-		ret = plat->handle_irq(irq, armpmu, armpmu->handle_irq);
-	else
-		ret = armpmu->handle_irq(irq, armpmu);
+	ret = armpmu->handle_irq(irq, armpmu);
 	finish_clock = sched_clock();

 	perf_sample_event_took(finish_clock - start_clock);
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index dd9acc95ebc0..63f7b19a5ebe 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -59,6 +59,119 @@ int perf_num_counters(void)
 }
 EXPORT_SYMBOL_GPL(perf_num_counters);

+#ifdef CONFIG_SMP
+/*
+ * Workaround logic that is distributed to all cores if the PMU has only
+ * a single IRQ and the CPU receiving that IRQ cannot handle it. Its
+ * job is to try to service the interrupt on the current CPU. It will
+ * also enable the IRQ again if all the other CPUs have already tried to
+ * service it.
+ */
+static void cpu_pmu_do_percpu_work(struct irq_work *w)
+{
+	struct pmu_hw_events *hw_events =
+	    container_of(w, struct pmu_hw_events, work);
+	struct arm_pmu *cpu_pmu = hw_events->percpu_pmu;
+	int count;
+
+	/* Ignore the return code, we can do nothing useful with it */
+	cpu_pmu->handle_irq(0, cpu_pmu);
+
+	count = atomic_dec_return(&cpu_pmu->remaining_irq_work);
+	if (count == 0)
+		enable_irq(cpu_pmu->muxed_spi_workaround_irq);
+
+	/*
+	 * Recover the count. We warn if we perform any recovery because this
+	 * code is expected to be unreachable except in the case were we lose
+	 * a race during CPU hot unplug (see cpu_pmu_handle_irq_none).
+	 */
+	if (WARN_ON(unlikely(count < 0)))
+		atomic_set(&cpu_pmu->remaining_irq_work, 0);
+}
+
+/*
+ * Called when the main interrupt handler cannot determine the source
+ * of interrupt. It will deploy a workaround if we are running on an SMP
+ * platform with only a single muxed SPI.
+ *
+ * The workaround disables the interrupt and distributes irqwork to all
+ * other processors in the system. Hopefully one of them will clear the
+ * interrupt...
+ */
+static irqreturn_t cpu_pmu_handle_irq_none(int irq_num, struct arm_pmu *cpu_pmu)
+{
+	int cpu, count = CONFIG_NR_CPUS;
+
+	if (irq_num != cpu_pmu->muxed_spi_workaround_irq)
+		return IRQ_NONE;
+
+	disable_irq_nosync(cpu_pmu->muxed_spi_workaround_irq);
+
+	/*
+	 * No worker cpu will decrement remaining_irq_work to zero whilst
+	 * we have added CONFIG_NR_CPUS to it (because the current CPU will
+	 * not have work assigned to it)
+	 */
+	atomic_add(count, &cpu_pmu->remaining_irq_work);
+
+	for_each_online_cpu(cpu) {
+		struct pmu_hw_events *hw_events =
+		    per_cpu_ptr(cpu_pmu->hw_events, cpu);
+
+		if (cpu == smp_processor_id())
+			continue;
+
+		/*
+		 * There is a short race between reading the online cpu mask in
+		 * the loop logic above and dispatching work to it below. It
+		 * is unlikely we will lose the race (because the code path to
+		 * offline a CPU is relatively long). If we were to lose the
+		 * race then the interrupt will not be re-enabled and perf will
+		 * be broken until stopped and restarted. This is
+		 * not-a-good-thing (tm) but is not as bad as trying to
+		 * schedule a task to re-distribute the interrupt.
+		 */
+		if (irq_work_queue_on(&hw_events->work, cpu))
+			count--;
+	}
+
+	if (atomic_sub_and_test(count, &cpu_pmu->remaining_irq_work))
+		enable_irq(cpu_pmu->muxed_spi_workaround_irq);
+
+	return IRQ_HANDLED;
+}
+
+static int cpu_pmu_muxed_spi_workaround_init(struct arm_pmu *cpu_pmu)
+{
+	struct platform_device *pmu_device = cpu_pmu->plat_device;
+
+	atomic_set(&cpu_pmu->remaining_irq_work, 0);
+	cpu_pmu->muxed_spi_workaround_irq = platform_get_irq(pmu_device, 0);
+
+	return 0;
+}
+
+static void cpu_pmu_muxed_spi_workaround_term(struct arm_pmu *cpu_pmu)
+{
+	cpu_pmu->muxed_spi_workaround_irq = 0;
+}
+#else /* CONFIG_SMP */
+static int cpu_pmu_muxed_spi_workaround_init(struct arm_pmu *cpu_pmu)
+{
+	return 0;
+}
+
+static void cpu_pmu_muxed_spi_workaround_term(struct arm_pmu *cpu_pmu)
+{
+}
+
+static irqreturn_t cpu_pmu_handle_irq_none(int irq_num, struct arm_pmu *cpu_pmu)
+{
+	return IRQ_NONE;
+}
+#endif /* CONFIG_SMP */
+
 /* Include the PMU-specific implementations. */
 #include "perf_event_xscale.c"
 #include "perf_event_v6.c"
@@ -98,6 +211,8 @@ static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
 			if (irq >= 0)
 				free_irq(irq, per_cpu_ptr(&hw_events->percpu_pmu, i));
 		}
+
+		cpu_pmu_muxed_spi_workaround_term(cpu_pmu);
 	}
 }

@@ -155,6 +270,16 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)

 			cpumask_set_cpu(i, &cpu_pmu->active_irqs);
 		}
+
+		/*
+		 * If we are running SMP and have only one interrupt source
+		 * then get ready to share that single irq among the cores.
+		 */
+		if (nr_cpu_ids > 1 && irqs == 1) {
+			err = cpu_pmu_muxed_spi_workaround_init(cpu_pmu);
+			if (err)
+				return err;
+		}
 	}

 	return 0;
@@ -201,6 +326,9 @@ static int cpu_pmu_init(struct arm_pmu *cpu_pmu)
 		struct pmu_hw_events *events = per_cpu_ptr(cpu_hw_events, cpu);
 		raw_spin_lock_init(&events->pmu_lock);
 		events->percpu_pmu = cpu_pmu;
+#ifdef CONFIG_SMP
+		init_irq_work(&events->work, cpu_pmu_do_percpu_work);
+#endif
 	}

 	cpu_pmu->hw_events	= cpu_hw_events;
diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index 8993770c47de..0dd914c10803 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -792,7 +792,7 @@ static irqreturn_t armv7pmu_handle_irq(int irq_num, void *dev)
 	 * Did an overflow occur?
 	 */
 	if (!armv7_pmnc_has_overflowed(pmnc))
-		return IRQ_NONE;
+		return cpu_pmu_handle_irq_none(irq_num, cpu_pmu);

 	/*
 	 * Handle the counter(s) overflow(s)
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 6f63954c8bde..917774999c5c 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -12,8 +12,6 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/amba/bus.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/mfd/abx500/ab8500.h>
@@ -23,7 +21,6 @@
 #include <linux/regulator/machine.h>
 #include <linux/random.h>

-#include <asm/pmu.h>
 #include <asm/mach/map.h>

 #include "setup.h"
@@ -99,30 +96,6 @@ static void __init u8500_map_io(void)
 		iotable_init(u8500_io_desc, ARRAY_SIZE(u8500_io_desc));
 }

-/*
- * The PMU IRQ lines of two cores are wired together into a single interrupt.
- * Bounce the interrupt to the other core if it's not ours.
- */
-static irqreturn_t db8500_pmu_handler(int irq, void *dev, irq_handler_t handler)
-{
-	irqreturn_t ret = handler(irq, dev);
-	int other = !smp_processor_id();
-
-	if (ret == IRQ_NONE && cpu_online(other))
-		irq_set_affinity(irq, cpumask_of(other));
-
-	/*
-	 * We should be able to get away with the amount of IRQ_NONEs we give,
-	 * while still having the spurious IRQ detection code kick in if the
-	 * interrupt really starts hitting spuriously.
-	 */
-	return ret;
-}
-
-static struct arm_pmu_platdata db8500_pmu_platdata = {
-	.handle_irq		= db8500_pmu_handler,
-};
-
 static const char *db8500_read_soc_id(void)
 {
 	void __iomem *uid = __io_address(U8500_BB_UID_BASE);
@@ -143,8 +116,6 @@ static struct device * __init db8500_soc_device_init(void)
 }

 static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
-	/* Requires call-back bindings. */
-	OF_DEV_AUXDATA("arm,cortex-a9-pmu", 0, "arm-pmu", &db8500_pmu_platdata),
 	/* Requires DMA bindings. */
 	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80123000,
 		       "ux500-msp-i2s.0", &msp0_platform_data),
--
1.9.3

