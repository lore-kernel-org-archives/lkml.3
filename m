Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaHVOFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:05:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33382 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446AbaHVODB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 04/10] ARM: OMAP5 / DRA7: PM: Enable Mercury retention mode on CPUx powerdomains
Date: Fri, 22 Aug 2014 09:02:28 -0500
Message-ID: <1408716154-26101-5-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408716154-26101-1-git-send-email-nm@ti.com>
References: <1408716154-26101-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@ti.com>

In addition to the standard power-management technique, the OMAP5 / DRA7
MPU subsystem also employs an SR3-APG (mercury) power management
technology to reduce leakage.

It allows for full logic and memories retention on MPU_C0 and MPU_C1 and
is controlled by the PRCM_MPU. Only "Fast-mode" is supported on the
OMAP5 and DRA7 family of processors.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
[nm@ti.com: minor consolidation]
Signed-off-by: Nishanth Menon <nm@ti.com>
---

This has a minor checkpatch warning for aligning with '(', but that
when fixed results in over 80 char warning. So choose '(' check instead :D.

 arch/arm/mach-omap2/omap-mpuss-lowpower.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
index 63a1dd7..fad6e8c 100644
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
+++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -321,6 +321,21 @@ int omap4_hotplug_cpu(unsigned int cpu, unsigned int power_state)
 
 
 /*
+ * Enable Mercury Fast HG retention mode by default.
+ */
+static void enable_mercury_retention_mode(void)
+{
+	u32 reg;
+
+	reg = omap4_prcm_mpu_read_inst_reg(OMAP54XX_PRCM_MPU_DEVICE_INST,
+				  OMAP54XX_PRCM_MPU_PRM_PSCON_COUNT_OFFSET);
+	/* Enable HG_EN, HG_RAMPUP = fast mode */
+	reg |= BIT(24) | BIT(25);
+	omap4_prcm_mpu_write_inst_reg(reg, OMAP54XX_PRCM_MPU_DEVICE_INST,
+				      OMAP54XX_PRCM_MPU_PRM_PSCON_COUNT_OFFSET);
+}
+
+/*
  * Initialise OMAP4 MPUSS
  */
 int __init omap4_mpuss_init(void)
@@ -397,6 +412,7 @@ int __init omap4_mpuss_init(void)
 		cpu_context_offset = OMAP4_RM_CPU0_CPU0_CONTEXT_OFFSET;
 	} else if (soc_is_omap54xx() || soc_is_dra7xx()) {
 		cpu_context_offset = OMAP54XX_RM_CPU0_CPU0_CONTEXT_OFFSET;
+		enable_mercury_retention_mode();
 	}
 
 	return 0;
-- 
1.7.9.5

