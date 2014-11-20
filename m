Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaKTLms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:42:48 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37944 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbaKTLmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:42:46 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RFC PATCH] arm: imx: Workaround i.MX6 PMU interrupts muxed to one SPI
Date: Thu, 20 Nov 2014 11:42:37 +0000
Message-Id: <1416483757-24165-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All PMU interrupts on multi-core i.MX6 devices are muxed onto a single SPI.
Should the PMU of any core except 0 (the default affinity for the
interrupt) trigger the interrupt then it cannot be serviced and,
eventually, the spurious irq detection will forcefully disable the
interrupt.

This can be worked around by getting the interrupt handler to change its
own affinity if it cannot figure out why it has been triggered. This patch
adds logic to rotate the affinity to i.MX6.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---

Notes:
    This patch adopts the approach used on the u8500 (db8500_pmu_handler)
    but the logic has been generalized for any number of CPUs, mostly
    because the i.MX6 has a both dual and quad core variants.
    
    However it might be better to include the generalized logic in the main
    armpmu code. I think the logic could be deployed automatically on SMP
    systems with only a single not-percpu IRQ, replacing the
    plat->handle_irq dance we currently do to hook up this code.
    
    Thoughts? (or is there already shared logic to do this that I
    overlooked)
    

 arch/arm/mach-imx/mach-imx6q.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index d51c6e99a2e9..c056b7b97eaa 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/irqchip.h>
@@ -33,6 +34,7 @@
 #include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/pmu.h>
 #include <asm/system_misc.h>

 #include "common.h"
@@ -261,6 +263,40 @@ static void __init imx6q_axi_init(void)
 	}
 }

+/*
+ * The PMU IRQ lines of all cores are muxed onto a single interrupt.
+ * Rotate the interrupt around the cores if the current CPU cannot
+ * figure out why the interrupt has been triggered.
+ */
+static irqreturn_t imx6q_pmu_handler(int irq, void *dev, irq_handler_t handler)
+{
+	irqreturn_t ret = handler(irq, dev);
+	int next;
+
+	if (ret == IRQ_NONE && num_online_cpus() > 1) {
+		next = cpumask_next(smp_processor_id(), cpu_online_mask);
+		if (next > nr_cpu_ids)
+			next = cpumask_next(-1, cpu_online_mask);
+		irq_set_affinity(irq, cpumask_of(next));
+	}
+
+	/*
+	 * We should be able to get away with the amount of IRQ_NONEs we give,
+	 * while still having the spurious IRQ detection code kick in if the
+	 * interrupt really starts hitting spuriously.
+	 */
+	return ret;
+}
+
+static struct arm_pmu_platdata imx6q_pmu_platdata = {
+	.handle_irq = imx6q_pmu_handler,
+};
+
+static struct of_dev_auxdata imx6q_auxdata_lookup[] __initdata = {
+	OF_DEV_AUXDATA("arm,cortex-a9-pmu", 0, "arm-pmu", &imx6q_pmu_platdata),
+	{},
+};
+
 static void __init imx6q_init_machine(void)
 {
 	struct device *parent;
@@ -276,7 +312,8 @@ static void __init imx6q_init_machine(void)

 	imx6q_enet_phy_init();

-	of_platform_populate(NULL, of_default_bus_match_table, NULL, parent);
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     imx6q_auxdata_lookup, parent);

 	imx_anatop_init();
 	cpu_is_imx6q() ?  imx6q_pm_init() : imx6dl_pm_init();
--
1.9.3

