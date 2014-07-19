Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbaGSIwg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 04:52:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:52338 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbaGSIwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 04:52:31 -0400
Date: Sat, 19 Jul 2014 10:52:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq updates for 3.16
Message-ID: <alpine.DEB.2.10.1407191050360.24854@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

Three patches addressing shortcomings in the ARM gic interrupt chip
driver.

Thanks,

	tglx

------------------>
Matthias Brugger (1):
      irqchip: gic: Add support for cortex a7 compatible string

Suravee Suthikulpanit (1):
      irqchip: gic: Add binding probe for ARM GIC400

Tomasz Figa (1):
      irqchip: gic: Fix core ID calculation when topology is read from DT


 drivers/irqchip/irq-gic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 7e11c9d..7c131cf 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -42,6 +42,7 @@
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqchip/arm-gic.h>
 
+#include <asm/cputype.h>
 #include <asm/irq.h>
 #include <asm/exception.h>
 #include <asm/smp_plat.h>
@@ -954,7 +955,9 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 		}
 
 		for_each_possible_cpu(cpu) {
-			unsigned long offset = percpu_offset * cpu_logical_map(cpu);
+			u32 mpidr = cpu_logical_map(cpu);
+			u32 core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+			unsigned long offset = percpu_offset * core_id;
 			*per_cpu_ptr(gic->dist_base.percpu_base, cpu) = dist_base + offset;
 			*per_cpu_ptr(gic->cpu_base.percpu_base, cpu) = cpu_base + offset;
 		}
@@ -1071,8 +1074,10 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 	gic_cnt++;
 	return 0;
 }
+IRQCHIP_DECLARE(gic_400, "arm,gic-400", gic_of_init);
 IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
 IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
+IRQCHIP_DECLARE(cortex_a7_gic, "arm,cortex-a7-gic", gic_of_init);
 IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
 IRQCHIP_DECLARE(msm_qgic2, "qcom,msm-qgic2", gic_of_init);
 
