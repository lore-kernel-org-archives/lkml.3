Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaHTUmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:42:35 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56388 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaHTUmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:42:32 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 1/9] ARM: zynq: PM: Enable A9 internal clock gating feature
Date: Wed, 20 Aug 2014 13:41:47 -0700
Message-Id: <1408567315-28479-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
In-Reply-To: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/mach-zynq/common.c  |  6 ++++++
 arch/arm/mach-zynq/common.h  | 11 +++++++++++
 arch/arm/mach-zynq/platsmp.c |  9 +++++++++
 3 files changed, 26 insertions(+)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 31a6fa40ba37..3cb7c198615a 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -98,6 +98,11 @@ static int __init zynq_get_revision(void)
 	return revision;
 }
 
+static void __init zynq_init_late(void)
+{
+	zynq_core_pm_init();
+}
+
 /**
  * zynq_init_machine - System specific initialization, intended to be
  *		       called from board specific initialization.
@@ -204,6 +209,7 @@ DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
 	.map_io		= zynq_map_io,
 	.init_irq	= zynq_irq_init,
 	.init_machine	= zynq_init_machine,
+	.init_late	= zynq_init_late,
 	.init_time	= zynq_timer_init,
 	.dt_compat	= zynq_dt_match,
 	.reserve	= zynq_memory_init,
diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index f652f0a884a6..596ef0b5067c 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -40,4 +40,15 @@ extern void __iomem *zynq_scu_base;
 /* Hotplug */
 extern void zynq_platform_cpu_die(unsigned int cpu);
 
+static inline void zynq_core_pm_init(void)
+{
+	/* A9 clock gating */
+	asm volatile ("mrc  p15, 0, r12, c15, c0, 0\n"
+		      "orr  r12, r12, #1\n"
+		      "mcr  p15, 0, r12, c15, c0, 0\n"
+		      : /* no outputs */
+		      : /* no inputs */
+		      : "r12");
+}
+
 #endif
diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index abc82ef085c1..616b99e07c60 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -112,6 +112,14 @@ static void __init zynq_smp_prepare_cpus(unsigned int max_cpus)
 	scu_enable(zynq_scu_base);
 }
 
+/*
+ * This function is in the hotplug path. Don't move it into the init section!!
+ */
+static void zynq_secondary_init(unsigned int cpu)
+{
+	zynq_core_pm_init();
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 static int zynq_cpu_kill(unsigned cpu)
 {
@@ -124,6 +132,7 @@ struct smp_operations zynq_smp_ops __initdata = {
 	.smp_init_cpus		= zynq_smp_init_cpus,
 	.smp_prepare_cpus	= zynq_smp_prepare_cpus,
 	.smp_boot_secondary	= zynq_boot_secondary,
+	.smp_secondary_init	= zynq_secondary_init,
 #ifdef CONFIG_HOTPLUG_CPU
 	.cpu_die		= zynq_platform_cpu_die,
 	.cpu_kill		= zynq_cpu_kill,
-- 
2.0.1.1.gfbfc394

