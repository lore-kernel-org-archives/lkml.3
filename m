Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaBSXPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 18:15:15 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:54724 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaBSXPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 18:15:11 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org
Subject: [PATCH v4 4/4] arm: zynq: Add support for cpufreq
Date: Wed, 19 Feb 2014 15:14:44 -0800
Message-Id: <1392851684-29950-5-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1392851684-29950-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1392851684-29950-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic cpufreq-cpu0 driver can scale the CPU frequency on Zynq
SOCs. Add the required platform device to the BSP and appropriate
OPPs to the dts.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: devicetree@vger.kernel.org
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
v4:
 - no change
v3:
 - change lowest frequency to 222223 (F_max / 3)
---
 arch/arm/boot/dts/zynq-7000.dtsi | 6 ++++++
 arch/arm/mach-zynq/Kconfig       | 2 ++
 arch/arm/mach-zynq/common.c      | 3 +++
 3 files changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 8b67b19392ec..789d0bacc110 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -24,6 +24,12 @@
 			device_type = "cpu";
 			reg = <0>;
 			clocks = <&clkc 3>;
+			operating-points = <
+				/* kHz    uV */
+				666667  1000000
+				333334  1000000
+				222223  1000000
+			>;
 		};
 
 		cpu@1 {
diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index f84fab14f0b7..f03e75bd0b2b 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -2,6 +2,8 @@ config ARCH_ZYNQ
 	bool "Xilinx Zynq ARM Cortex A9 Platform" if ARCH_MULTI_V7
 	select ARM_AMBA
 	select ARM_GIC
+	select ARCH_HAS_CPUFREQ
+	select ARCH_HAS_OPP
 	select COMMON_CLK
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 1db2a5ca9ab8..644468151c04 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -51,6 +51,8 @@ static struct platform_device zynq_cpuidle_device = {
  */
 static void __init zynq_init_machine(void)
 {
+	struct platform_device_info devinfo = { .name = "cpufreq-cpu0", };
+
 	/*
 	 * 64KB way size, 8-way associativity, parity disabled
 	 */
@@ -59,6 +61,7 @@ static void __init zynq_init_machine(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 
 	platform_device_register(&zynq_cpuidle_device);
+	platform_device_register_full(&devinfo);
 }
 
 static void __init zynq_timer_init(void)
-- 
1.9.0.1.g4196000

