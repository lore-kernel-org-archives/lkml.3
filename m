Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbaCKWmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:42:21 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:44437 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946AbaCKWlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:41:17 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        ezequiel.garcia@free-electrons.com, ivan.khoronzhuk@ti.com,
        linus.walleij@linaro.org, magnus.damm@gmail.com,
        matthias.bgg@gmail.com, soren.brinkmann@xilinx.com,
        sboyd@codeaurora.org
Subject: [PATCH 16/17] arm: zynq: Add support for cpufreq
Date: Tue, 11 Mar 2014 23:40:52 +0100
Message-Id: <1394577653-8615-16-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
References: <531F8FAC.2040902@linaro.org>
 <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Soren Brinkmann <soren.brinkmann@xilinx.com>

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
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Michal Simek <michal.simek@xilinx.com>
---
 arch/arm/boot/dts/zynq-7000.dtsi |    6 ++++++
 arch/arm/mach-zynq/Kconfig       |    2 ++
 arch/arm/mach-zynq/common.c      |    3 +++
 3 files changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 8b67b19..789d0ba 100644
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
index f84fab1..f03e75b 100644
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
index 1db2a5ca..6444681 100644
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
1.7.9.5

