Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab3K0BF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:05:59 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:63746 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759131Ab3K0BFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:05:33 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 9/9] arm: zynq: Add support for cpufreq
Date: Tue, 26 Nov 2013 17:04:56 -0800
Message-Id: <1385514296-26702-10-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic cpufreq-cpu0 driver can scale the CPU frequency on Zynq
SOCs. Add the required platform device to the BSP and appropriate
OPPs to the dts.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/boot/dts/zynq-7000.dtsi | 6 ++++++
 arch/arm/mach-zynq/Kconfig       | 2 ++
 arch/arm/mach-zynq/common.c      | 3 +++
 3 files changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 23ba82c205a2..dc030481ee64 100644
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
+				111112  1000000
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
index 9a7bd137c8fd..eeff33a1d14a 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -54,6 +54,8 @@ static struct platform_device zynq_cpuidle_device = {
  */
 static void __init zynq_init_machine(void)
 {
+	struct platform_device_info devinfo = { .name = "cpufreq-cpu0", };
+
 	/*
 	 * 64KB way size, 8-way associativity, parity disabled
 	 */
@@ -62,6 +64,7 @@ static void __init zynq_init_machine(void)
 	of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
 
 	platform_device_register(&zynq_cpuidle_device);
+	platform_device_register_full(&devinfo);
 }
 
 static void __init zynq_timer_init(void)
-- 
1.8.4.4

