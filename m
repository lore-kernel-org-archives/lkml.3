Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaGZTDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:03:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaGZTDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:03:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.10 46/56] irqchip: gic: Fix core ID calculation when topology is read from DT
Date: Sat, 26 Jul 2014 12:02:39 -0700
Message-Id: <20140726190201.575882381@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190200.061512159@linuxfoundation.org>
References: <20140726190200.061512159@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Figa <t.figa@samsung.com>

commit 29e697b11853d3f83b1864ae385abdad4aa2c361 upstream.

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
Fixes: db0d4db22a78d ("ARM: gic: allow GIC to support non-banked setups")
Link: https://lkml.kernel.org/r/1405610624-18722-1-git-send-email-t.figa@samsung.com
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-gic.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -42,6 +42,7 @@
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqchip/arm-gic.h>
 
+#include <asm/cputype.h>
 #include <asm/irq.h>
 #include <asm/exception.h>
 #include <asm/smp_plat.h>
@@ -754,7 +755,9 @@ void __init gic_init_bases(unsigned int
 		}
 
 		for_each_possible_cpu(cpu) {
-			unsigned long offset = percpu_offset * cpu_logical_map(cpu);
+			u32 mpidr = cpu_logical_map(cpu);
+			u32 core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+			unsigned long offset = percpu_offset * core_id;
 			*per_cpu_ptr(gic->dist_base.percpu_base, cpu) = dist_base + offset;
 			*per_cpu_ptr(gic->cpu_base.percpu_base, cpu) = cpu_base + offset;
 		}


