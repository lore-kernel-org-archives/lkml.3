Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaKZQ73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:59:29 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33401 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaKZQ71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:59:27 -0500
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
        Linus Walleij <linus.walleij@linaro.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH] arm: perf: Directly handle SMP platforms with one SPI
Date: Wed, 26 Nov 2014 16:59:07 +0000
Message-Id: <1417021147-20735-1-git-send-email-daniel.thompson@linaro.org>
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

Tested on imx6q (which has fours cores/PMUs all muxed to a single SPI).

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---

Notes:
    v2:
     * Fixed build problems on systems without SMP.
    
    v1:
     * Thanks to Lucas Stach, Russell King and Thomas Gleixner for
       critiquing an older, completely different way to tackle the
       same problem.
    

 arch/arm/include/asm/pmu.h       |  12 ++++
 arch/arm/kernel/perf_event.c     |  13 ++--
 arch/arm/kernel/perf_event_cpu.c | 126 +++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-ux500/cpu-db8500.c |  29 ---------
 4 files changed, 143 insertions(+), 37 deletions(-)

diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
index 0b648c541293..771201ff0988 100644
--- a/arch/arm/include/asm/pmu.h
+++ b/arch/arm/include/asm/pmu.h
@@ -81,6 +81,12 @@ struct pmu_hw_events {
 	raw_spinlock_t		pmu_lock;
 };

+struct arm_pmu_work {
+	struct irq_work work;
+	struct arm_pmu *arm_pmu;
+	atomic_t ret;
+};
+
 struct arm_pmu {
 	struct pmu	pmu;
 	cpumask_t	active_irqs;
@@ -108,6 +114,12 @@ struct arm_pmu {
 	u64		max_period;
 	struct platform_device	*plat_device;
 	struct pmu_hw_events	*(*get_hw_events)(void);
+#ifdef CONFIG_SMP
+	irqreturn_t	(*handle_irq_none)(struct arm_pmu *);
+	int             single_irq;
+	struct arm_pmu_work __percpu *work;
+	atomic_t        remaining_work;
+#endif
 };

 #define to_arm_pmu(p) (container_of(p, struct arm_pmu, pmu))
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index b50a770f8c99..ba67d6309e1e 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -306,22 +306,19 @@ validate_group(struct perf_event *event)
 static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
 {
 	struct arm_pmu *armpmu;
-	struct platform_device *plat_device;
-	struct arm_pmu_platdata *plat;
 	int ret;
 	u64 start_clock, finish_clock;

 	if (irq_is_percpu(irq))
 		dev = *(void **)dev;
 	armpmu = dev;
-	plat_device = armpmu->plat_device;
-	plat = dev_get_platdata(&plat_device->dev);

 	start_clock = sched_clock();
-	if (plat && plat->handle_irq)
-		ret = plat->handle_irq(irq, dev, armpmu->handle_irq);
-	else
-		ret = armpmu->handle_irq(irq, dev);
+	ret = armpmu->handle_irq(irq, dev);
+#ifdef CONFIG_SMP
+	if (ret == IRQ_NONE && armpmu->handle_irq_none)
+		ret = armpmu->handle_irq_none(dev);
+#endif
 	finish_clock = sched_clock();

 	perf_sample_event_took(finish_clock - start_clock);
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index eb2c4d55666b..5605d4a4c01f 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -88,6 +88,120 @@ static void cpu_pmu_disable_percpu_irq(void *data)
 	disable_percpu_irq(irq);
 }

+#ifdef CONFIG_SMP
+
+/*
+ * Workaround logic that is distributed to all cores if the PMU has only
+ * a single IRQ and the CPU receiving that IRQ cannot handle it. Its
+ * job is to try to service the interrupt on the current CPU. It will
+ * also enable the IRQ again if all the other CPUs have already tried to
+ * service it.
+ */
+static void cpu_pmu_do_percpu_work(struct irq_work *w)
+{
+	struct arm_pmu_work *work = container_of(w, struct arm_pmu_work, work);
+	struct arm_pmu *cpu_pmu = work->arm_pmu;
+
+	atomic_set(&work->ret,
+		   cpu_pmu->handle_irq(cpu_pmu->single_irq, cpu_pmu));
+
+	if (atomic_dec_and_test(&cpu_pmu->remaining_work))
+		enable_irq(cpu_pmu->single_irq);
+}
+
+/*
+ * This callback, which is enabled only on SMP platforms that are
+ * running with a single IRQ, is called when the PMU handler running in
+ * the current CPU cannot service the interrupt.
+ *
+ * It will disable the interrupt and distribute irqwork to all other
+ * processors in the system. Hopefully one of them will clear the
+ * interrupt...
+ */
+static irqreturn_t cpu_pmu_handle_irq_none(struct arm_pmu *cpu_pmu)
+{
+	int num_online = num_online_cpus();
+	irqreturn_t ret = IRQ_NONE;
+	int cpu, cret;
+
+	if (num_online <= 1)
+		return IRQ_NONE;
+
+	disable_irq_nosync(cpu_pmu->single_irq);
+	atomic_add(num_online, &cpu_pmu->remaining_work);
+	smp_mb__after_atomic();
+
+	for_each_online_cpu(cpu) {
+		struct arm_pmu_work *work = per_cpu_ptr(cpu_pmu->work, cpu);
+
+		if (cpu == smp_processor_id())
+			continue;
+
+		/*
+		 * We can be extremely relaxed about memory ordering
+		 * here. All we are doing is gathering information
+		 * about the past to help us give a return value that
+		 * will keep the spurious interrupt detector both happy
+		 * *and* functional. We are not shared so we can
+		 * tolerate the occasional spurious IRQ_HANDLED.
+		 */
+		cret = atomic_read(&work->ret);
+		if (cret != IRQ_NONE)
+			ret = cret;
+
+		if (!irq_work_queue_on(&work->work, cpu))
+			atomic_dec(&cpu_pmu->remaining_work);
+	}
+
+	if (atomic_dec_and_test(&cpu_pmu->remaining_work))
+		enable_irq(cpu_pmu->single_irq);
+
+	return ret;
+}
+
+static int cpu_pmu_single_irq_workaround_init(struct arm_pmu *cpu_pmu)
+{
+	struct platform_device *pmu_device = cpu_pmu->plat_device;
+	int cpu;
+
+	cpu_pmu->handle_irq_none = cpu_pmu_handle_irq_none;
+	cpu_pmu->single_irq = platform_get_irq(pmu_device, 0);
+
+	cpu_pmu->work = alloc_percpu(struct arm_pmu_work);
+	if (!cpu_pmu->work) {
+		pr_err("no memory for shared IRQ workaround\n");
+		return -ENOMEM;
+	}
+
+	for_each_possible_cpu(cpu) {
+		struct arm_pmu_work *w = per_cpu_ptr(cpu_pmu->work, cpu);
+
+		init_irq_work(&w->work, cpu_pmu_do_percpu_work);
+		w->arm_pmu = cpu_pmu;
+	}
+
+	return 0;
+}
+
+static void cpu_pmu_single_irq_workaround_term(struct arm_pmu *cpu_pmu)
+{
+	cpu_pmu->handle_irq_none = cpu_pmu_handle_irq_none;
+	free_percpu(cpu_pmu->work);
+}
+
+#else /* CONFIG_SMP */
+
+static int cpu_pmu_single_irq_workaround_init(struct arm_pmu *cpu_pmu)
+{
+	return 0;
+}
+
+static void cpu_pmu_single_irq_workaround_term(struct arm_pmu *cpu_pmu)
+{
+}
+
+#endif /* CONFIG_SMP */
+
 static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
 {
 	int i, irq, irqs;
@@ -107,6 +221,8 @@ static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
 			if (irq >= 0)
 				free_irq(irq, cpu_pmu);
 		}
+
+		cpu_pmu_single_irq_workaround_term(cpu_pmu);
 	}
 }

@@ -162,6 +278,16 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)

 			cpumask_set_cpu(i, &cpu_pmu->active_irqs);
 		}
+
+		/*
+		 * If we are running SMP and have only one interrupt source
+		 * then get ready to share that single irq among the cores.
+		 */
+		if (nr_cpu_ids > 1 && irqs == 1) {
+			err = cpu_pmu_single_irq_workaround_init(cpu_pmu);
+			if (err)
+				return err;
+		}
 	}

 	return 0;
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

