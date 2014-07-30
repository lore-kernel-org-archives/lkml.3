Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbaG3Mdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:33:45 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36732 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbaG3MPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Jason Cooper <jason@lakedaemon.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 62/94] irqchip: gic: Fix core ID calculation when topology is read from DT
Date: Wed, 30 Jul 2014 14:14:51 +0200
Message-Id: <5ef74eaa47bf0fe5e43bbd0d8f0a9d9cb7363a6a.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/irqchip/irq-gic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 36fcc1b6264e..0fcbf921fff3 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -42,6 +42,7 @@
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqchip/arm-gic.h>
 
+#include <asm/cputype.h>
 #include <asm/irq.h>
 #include <asm/exception.h>
 #include <asm/smp_plat.h>
@@ -760,7 +761,9 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
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
2.0.1

