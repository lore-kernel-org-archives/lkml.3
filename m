Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbbAUREz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:04:55 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33569 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbbAUREB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:04:01 -0500
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
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [RFC PATCH v2 5/5] arm: perf: Use FIQ to handle PMU events.
Date: Wed, 21 Jan 2015 17:03:42 +0000
Message-Id: <1421859822-3621-6-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421859822-3621-1-git-send-email-daniel.thompson@linaro.org>
References: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org>
 <1421859822-3621-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using FIQ (if it is available) gives perf a better insight into the
system by allowing code run with interrupts disabled to be profiled.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/include/asm/pmu.h       |  2 ++
 arch/arm/kernel/perf_event.c     |  2 +-
 arch/arm/kernel/perf_event_cpu.c | 14 +++++++++++---
 arch/arm/kernel/traps.c          |  4 ++++
 4 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
index b1596bd59129..e6c87e393547 100644
--- a/arch/arm/include/asm/pmu.h
+++ b/arch/arm/include/asm/pmu.h
@@ -123,6 +123,8 @@ struct arm_pmu {
 
 extern const struct dev_pm_ops armpmu_dev_pm_ops;
 
+irqreturn_t armpmu_dispatch_irq(int irq, void *dev);
+
 int armpmu_register(struct arm_pmu *armpmu, int type);
 
 u64 armpmu_event_update(struct perf_event *event);
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
index b30a2645c2f1..e5c9c5d607ab 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -177,9 +177,17 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
 				continue;
 			}
 
-			err = request_irq(irq, handler,
-					  IRQF_NOBALANCING | IRQF_NO_THREAD, "arm-pmu",
-					  per_cpu_ptr(&hw_events->percpu_pmu, i));
+			err = request_irq(
+			    irq, handler,
+			    IRQF_NOBALANCING | IRQF_NMI,
+			    "arm-pmu", per_cpu_ptr(&hw_events->percpu_pmu, i));
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
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 445fdf26b1af..a5ffddeb224e 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -39,6 +39,7 @@
 #include <asm/tls.h>
 #include <asm/system_misc.h>
 #include <asm/opcodes.h>
+#include <asm/pmu.h>
 
 
 static const char *handler[]= {
@@ -466,6 +467,9 @@ die_sig:
 int arch_filter_nmi_handler(irq_handler_t handler)
 {
 	irq_handler_t whitelist[] = {
+#ifdef CONFIG_HW_PERF_EVENTS
+		armpmu_dispatch_irq,
+#endif
 	};
 	int i;
 
-- 
1.9.3

