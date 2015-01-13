Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbbAMQgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:36:07 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62194 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbbAMQgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:36:04 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: [RFC PATCH 5/5] arm: perf: Use FIQ to handle PMU events.
Date: Tue, 13 Jan 2015 16:35:31 +0000
Message-Id: <1421166931-14134-6-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org>
References: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using FIQ (if it is available) gives perf a better insight into the
system by allowing code run with interrupts disabled to be profiled.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/include/asm/pmu.h       |  4 ++++
 arch/arm/kernel/perf_event.c     |  2 +-
 arch/arm/kernel/perf_event_cpu.c | 35 ++++++++++++++++++++++++++++++++---
 arch/arm/kernel/traps.c          |  3 ++-
 4 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
index b1596bd59129..2a7ea97a4a14 100644
--- a/arch/arm/include/asm/pmu.h
+++ b/arch/arm/include/asm/pmu.h
@@ -123,6 +123,8 @@ struct arm_pmu {
 
 extern const struct dev_pm_ops armpmu_dev_pm_ops;
 
+irqreturn_t armpmu_dispatch_irq(int irq, void *dev);
+
 int armpmu_register(struct arm_pmu *armpmu, int type);
 
 u64 armpmu_event_update(struct perf_event *event);
@@ -136,6 +138,8 @@ int armpmu_map_event(struct perf_event *event,
 						[PERF_COUNT_HW_CACHE_RESULT_MAX],
 		     u32 raw_event_mask);
 
+void cpu_pmu_handle_fiq(int irq);
+
 struct pmu_probe_info {
 	unsigned int cpuid;
 	unsigned int mask;
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index f7c65adaa428..5ae9adf7f18e 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -296,7 +296,7 @@ validate_group(struct perf_event *event)
 	return 0;
 }
 
-static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
+irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
 {
 	struct arm_pmu *armpmu;
 	struct platform_device *plat_device;
diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index a80309087a7b..5c4e9ce23389 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -36,6 +36,9 @@
 /* Set at runtime when we know what CPU type we are. */
 static struct arm_pmu *cpu_pmu;
 
+/* Allows us to find out if an IRQ is for us (mostly used from NMI context) */
+static DEFINE_PER_CPU(int, cpu_pmu_irqs);
+
 /*
  * Despite the names, these two functions are CPU-specific and are used
  * by the OProfile/perf code.
@@ -127,6 +130,24 @@ static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
 	}
 }
 
+/*
+ * This handler is called *unconditionally* from the default NMI/FIQ
+ * handler. The irq may not be anything to do with us so the main
+ * job of this function is to figure out if the irq passed in is ours
+ * or not.
+ */
+void cpu_pmu_handle_fiq(int irq)
+{
+	int cpu = smp_processor_id();
+
+	if (irq != get_cpu_var(cpu_pmu_irqs))
+		return;
+
+	(void)armpmu_dispatch_irq(irq,
+				  get_cpu_ptr(&cpu_pmu->hw_events->percpu_pmu));
+}
+
+
 static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 {
 	int i, err, irq, irqs;
@@ -170,9 +191,16 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 				continue;
 			}
 
-			err = request_irq(irq, handler,
-					  IRQF_NOBALANCING | IRQF_NO_THREAD, "arm-pmu",
-					  per_cpu_ptr(&hw_events->percpu_pmu, i));
+			err = request_nmi_irq(
+			    irq, IRQF_NOBALANCING, "arm-pmu",
+			    per_cpu_ptr(&hw_events->percpu_pmu, i));
+			if (err) {
+				err = request_irq(
+				    irq, handler,
+				    IRQF_NOBALANCING | IRQF_NO_THREAD,
+				    "arm-pmu",
+				    per_cpu_ptr(&hw_events->percpu_pmu, i));
+			}
 			if (err) {
 				pr_err("unable to request IRQ%d for ARM PMU counters\n",
 					irq);
@@ -180,6 +208,7 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 			}
 
 			cpumask_set_cpu(i, &cpu_pmu->active_irqs);
+			per_cpu(cpu_pmu_irqs, i) = irq;
 		}
 	}
 
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 74c752b9db68..c581e07517ff 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -38,6 +38,7 @@
 #include <asm/tls.h>
 #include <asm/system_misc.h>
 #include <asm/opcodes.h>
+#include <asm/pmu.h>
 
 
 static const char *handler[]= {
@@ -485,7 +486,7 @@ asmlinkage void __exception_irq_entry handle_fiq_as_nmi(struct pt_regs *regs)
 	irq = gic_ack_fiq();
 
 	if (irq) {
-		/* empty - no SPI handlers (yet) */
+		cpu_pmu_handle_fiq(irq);
 	} else {
 #ifdef CONFIG_SMP
 		ipi_cpu_backtrace(regs);
-- 
1.9.3

