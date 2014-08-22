Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbaHVOFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:05:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58712 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443AbaHVODB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:03:01 -0400
From: Nishanth Menon <nm@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 01/10] ARM: OMAP5 / DRA7: PM: Update CPU context register offset
Date: Fri, 22 Aug 2014 09:02:25 -0500
Message-ID: <1408716154-26101-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408716154-26101-1-git-send-email-nm@ti.com>
References: <1408716154-26101-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@ti.com>

On OMAP5, RM_CPUi_CPUi_CONTEXT offset has changed. Update the code
so that same code works for OMAP4+ devices. DRA7 and OMAP5 have the same
context offset as well.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
[rnayak@ti.com: for DRA7]
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
[nm@ti.com: rebase, split/merge etc..]
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/omap-mpuss-lowpower.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
index 4001325..63a1dd7 100644
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
+++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -56,6 +56,7 @@
 #include "omap4-sar-layout.h"
 #include "pm.h"
 #include "prcm_mpu44xx.h"
+#include "prcm_mpu54xx.h"
 #include "prminst44xx.h"
 #include "prcm44xx.h"
 #include "prm44xx.h"
@@ -89,6 +90,7 @@ struct cpu_pm_ops {
 static DEFINE_PER_CPU(struct omap4_cpu_pm_info, omap4_pm_info);
 static struct powerdomain *mpuss_pd;
 static void __iomem *sar_base;
+static u32 cpu_context_offset;
 
 static int default_finish_suspend(unsigned long cpu_state)
 {
@@ -161,14 +163,14 @@ static inline void cpu_clear_prev_logic_pwrst(unsigned int cpu_id)
 
 	if (cpu_id) {
 		reg = omap4_prcm_mpu_read_inst_reg(OMAP4430_PRCM_MPU_CPU1_INST,
-					OMAP4_RM_CPU1_CPU1_CONTEXT_OFFSET);
+					cpu_context_offset);
 		omap4_prcm_mpu_write_inst_reg(reg, OMAP4430_PRCM_MPU_CPU1_INST,
-					OMAP4_RM_CPU1_CPU1_CONTEXT_OFFSET);
+					cpu_context_offset);
 	} else {
 		reg = omap4_prcm_mpu_read_inst_reg(OMAP4430_PRCM_MPU_CPU0_INST,
-					OMAP4_RM_CPU0_CPU0_CONTEXT_OFFSET);
+					cpu_context_offset);
 		omap4_prcm_mpu_write_inst_reg(reg, OMAP4430_PRCM_MPU_CPU0_INST,
-					OMAP4_RM_CPU0_CPU0_CONTEXT_OFFSET);
+					cpu_context_offset);
 	}
 }
 
@@ -392,6 +394,9 @@ int __init omap4_mpuss_init(void)
 		omap_pm_ops.finish_suspend = omap4_finish_suspend;
 		omap_pm_ops.resume = omap4_cpu_resume;
 		omap_pm_ops.scu_prepare = scu_pwrst_prepare;
+		cpu_context_offset = OMAP4_RM_CPU0_CPU0_CONTEXT_OFFSET;
+	} else if (soc_is_omap54xx() || soc_is_dra7xx()) {
+		cpu_context_offset = OMAP54XX_RM_CPU0_CPU0_CONTEXT_OFFSET;
 	}
 
 	return 0;
-- 
1.7.9.5

