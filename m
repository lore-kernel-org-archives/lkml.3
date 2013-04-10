Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936722Ab3DJWT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:19:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759380Ab3DJWTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:19:52 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH/RFC 4/6] ARM: shmobile: sh73a0: add support for the DMA0 controller in DT
Date: Thu, 11 Apr 2013 00:19:47 +0200
Message-Id: <1365632389-2249-5-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:B8clt/RCLzG40CR2uLHPFVJvio2lCNNGxdrwSQUSZZ0
 AbBsj6a8GuinzypFidAEW2gUiUpEdt27j5rvVqaRZqVT9wPmr/
 RV88um85eZmIPdTVDm5un14bbFZX7jX7VUwYyjGLhOU2T60RqX
 DbUfz9cuxnEMp3P0VHM9NGpfKTBUPGZp/RncFFX6teSbNV/B/f
 X2X0O5P6EiKyYumLBUeqWvqINgsEmfQ0bLW5njuk+m7mYlbI+C
 39FGnmbcupiamkGGze8lzCWHhGlDjLKRJkOTyEa7wp2b/BmoqV
 EvReFwmq3N6Z9kom6kVOYBPlBYnZRJYlWhkdz7ydSk7Za5CoFa
 GE3r7g+TGdQfyXr3SGvF1+byIoNM9UWqZQWcbiqXnQ5QJUdwvA
 7quP7BUROyOnQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a Device Tree node for the DMA0 controller on sh73a0 and
auxdata to supply platform data to the driver. To enable the
DMA0 controller it also has to be taken out of reset.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 arch/arm/boot/dts/sh73a0.dtsi         |   36 +++++++++++++++++++++++++++++++++
 arch/arm/mach-shmobile/setup-sh73a0.c |    4 +++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/sh73a0.dtsi b/arch/arm/boot/dts/sh73a0.dtsi
index ec40bf7..edcf4f7 100644
--- a/arch/arm/boot/dts/sh73a0.dtsi
+++ b/arch/arm/boot/dts/sh73a0.dtsi
@@ -119,6 +119,42 @@
 			      0 32 0x4>;
 	};
 
+	dma0: shdma@fe000020 {
+		compatible = "renesas,shdma";
+		reg = <0xfe000020 0x89e0>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 129 4
+				0 109 4
+				0 110 4
+				0 111 4
+				0 112 4
+				0 113 4
+				0 114 4
+				0 115 4
+				0 116 4
+				0 117 4
+				0 118 4
+				0 119 4
+				0 120 4
+				0 121 4
+				0 122 4
+				0 123 4
+				0 124 4
+				0 125 4
+				0 126 4
+				0 127 4
+				0 128 4>;
+		interrupt-names = "error",
+				"ch0", "ch1", "ch2", "ch3",
+				"ch4", "ch5", "ch6", "ch7",
+				"ch8", "ch9", "ch10", "ch11",
+				"ch12", "ch13", "ch14", "ch15",
+				"ch16", "ch17", "ch18", "ch19";
+		#dma-cells = <1>;
+		dma-channels = <20>;
+		dma-requests = <256>;
+	};
+
 	i2c0: i2c@0xe6820000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index b8aa795..980dcf3 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -998,6 +998,7 @@ void __init sh73a0_init_delay(void)
 }
 
 static const struct of_dev_auxdata sh73a0_auxdata_lookup[] __initconst = {
+	OF_DEV_AUXDATA("renesas,shdma", 0xfe000020, "sh-dma-engine.0", &sh73a0_dmae_platform_data),
 	{},
 };
 
@@ -1005,6 +1006,9 @@ void __init sh73a0_add_standard_devices_dt(void)
 {
 	struct platform_device_info devinfo = { .name = "cpufreq-cpu0", .id = -1, };
 
+	/* Clear software reset bit on SY-DMAC module */
+	__raw_writel(__raw_readl(SRCR2) & ~(1 << 18), SRCR2);
+
 	platform_add_devices(sh73a0_devices_dt,
 			     ARRAY_SIZE(sh73a0_devices_dt));
 	of_platform_populate(NULL, of_default_bus_match_table,
-- 
1.7.2.5

