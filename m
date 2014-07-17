Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873AbaGQPYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:24:36 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54375 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbaGQPYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:24:34 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-31-53c7eaaf16d0
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH] irqchip: gic: Fix core ID calculation when topology is read
 from DT
Date: Thu, 17 Jul 2014 17:23:44 +0200
Message-id: <1405610624-18722-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t/xy7rrXx0PNvh0ysBi44z1rBaNSy6z
	WPQuuMpmsenxNVaLy7vmsFnMOL+PyeLN7xfsFmuP3GW3WD/jNYvF5k1TmS1W7frD6MDtsWbe
	GkaPnbPusns0HDjP4vHu3Dl2j81L6j36tqxi9Pi8SS6APYrLJiU1J7MstUjfLoEr43pfdsEB
	/orL0x+wNTB+5+li5OSQEDCR+Lz/PiOELSZx4d56ti5GLg4hgaWMEltPbmGEcPqYJC5d/AlW
	xSagJvG54REbiC0ioCrxuW0BO0gRs8AMZokZu1YygSSEBcIkvn39zwpiswAVfV93n6WLkYOD
	V8BJom0DG8Q2OYnebW+YJzByL2BkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREl5fdzAu
	PWZ1iFGAg1GJh/cH1/FgIdbEsuLK3EOMEhzMSiK82feBQrwpiZVVqUX58UWlOanFhxiZODil
	Ghhb1KMNQ2LOZAp6Gk7jiD9y6935nrVeKwV9ufTcrH+U3hHbWJr5Levif48F+qvq3z/bVeQ/
	ycxTlb9qzanM6oBMzbC4uZY210I45ht8aRa87BX3sNTXhM9FKOb22ff883dXTDjpUbiw48Kp
	Cb1Rs8vXF4eXPnmfvDWC8chd/3XKoZNatkn3LldiKc5INNRiLipOBABX1GDHDQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain GIC implementation, namely those found on earlier, single
cluster, Exynos SoCs, have registers mapped without per-CPU banking,
which means that the driver needs to use different offset for each CPU.

Currently the driver calculates the offset by multiplying value returned
by cpu_logical_map() by CPU offset parsed from DT. This is correct when
CPU topology is not specified in DT and aforementioned function returns
core ID alone. However when DT contains CPU topology, the function
changes to return cluster ID as well, which is non-zero on mentioned
SoCs and so breaks the calculation in GIC driver.

This patch fixes this by masking out cluster ID in CPU offset
calculation so that only core ID is considered. Multi-cluster Exynos
SoCs already have banked GIC implementations, so this simple fix should
be enough.

Reported-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/irqchip/irq-gic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index ddee133..5c15a09 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -40,6 +40,7 @@
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqchip/arm-gic.h>
 
+#include <asm/cputype.h>
 #include <asm/irq.h>
 #include <asm/exception.h>
 #include <asm/smp_plat.h>
@@ -901,7 +902,9 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 		}
 
 		for_each_possible_cpu(cpu) {
-			unsigned long offset = percpu_offset * cpu_logical_map(cpu);
+			u32 mpidr = cpu_logical_map(cpu);
+			u32 core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+			unsigned long offset = percpu_offset * core_id;
 			*per_cpu_ptr(gic->dist_base.percpu_base, cpu) = dist_base + offset;
 			*per_cpu_ptr(gic->cpu_base.percpu_base, cpu) = cpu_base + offset;
 		}
-- 
1.9.3

