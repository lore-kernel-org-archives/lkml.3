Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936414Ab3DKDmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:42:43 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:37172 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935998Ab3DKDmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:42:42 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <haojian.zhuang@gmail.com>, <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>, Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 3/4] ARM: mmp: bring up pxa988 with device tree support
Date: Thu, 11 Apr 2013 11:38:49 +0800
Message-ID: <1365651529-11545-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bring up pxa988 with device tree support.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 arch/arm/boot/dts/pxa988-dkb.dts          |   36 ++++++
 arch/arm/boot/dts/pxa988.dtsi             |  196 +++++++++++++++++++++++++++++
 arch/arm/mach-mmp/Kconfig                 |   25 ++++
 arch/arm/mach-mmp/Makefile                |    1 +
 arch/arm/mach-mmp/common.c                |   11 ++-
 arch/arm/mach-mmp/include/mach/addr-map.h |    6 +
 arch/arm/mach-mmp/mmpx-dt.c               |   79 ++++++++++++
 drivers/clk/mmp/Makefile                  |    1 +
 8 files changed, 354 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/boot/dts/pxa988-dkb.dts
 create mode 100644 arch/arm/boot/dts/pxa988.dtsi
 create mode 100644 arch/arm/mach-mmp/mmpx-dt.c

diff --git a/arch/arm/boot/dts/pxa988-dkb.dts b/arch/arm/boot/dts/pxa988-dkb.dts
new file mode 100644
index 0000000..2cee3ed
--- /dev/null
+++ b/arch/arm/boot/dts/pxa988-dkb.dts
@@ -0,0 +1,36 @@
+/*
+ *  Copyright (C) 2012 Marvell Technology Group Ltd.
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ */
+
+/dts-v1/;
+/include/ "pxa988.dtsi"
+
+/ {
+	model = "Marvell PXA988 DKB Development Board";
+	compatible = "mrvl,pxa988-dkb", "mrvl,pxa988";
+
+	chosen {
+		bootargs = "console=ttyS0,115200 root=/dev/nfs nfsroot=192.168.1.100:/nfsroot/ ip=192.168.1.101:192.168.1.100::255.255.255.0::eth0:on";
+	};
+
+	memory {
+		reg = <0x00000000 0x10000000>;
+	};
+
+	soc {
+		apb@d4000000 {
+			uart1: uart@d4017000 {
+				status = "okay";
+			};
+
+			rtc: rtc@d4010000 {
+				status = "okay";
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/pxa988.dtsi b/arch/arm/boot/dts/pxa988.dtsi
new file mode 100644
index 0000000..8ec89b0
--- /dev/null
+++ b/arch/arm/boot/dts/pxa988.dtsi
@@ -0,0 +1,196 @@
+/*
+ *  Copyright (C) 2013 Marvell Technology Group Ltd.
+ *  Author: Chao Xie <chao.xie@marvell.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	interrupt-parent = <&gic>;
+
+	aliases {
+		serial0 = &uart1;
+		serial1 = &uart2;
+		serial2 = &uart3;
+		i2c0 = &twsi1;
+		i2c1 = &twsi2;
+	};
+
+	cpus {
+		cpu@0 {
+			compatible = "arm,cortex-a9";
+			next-level-cache = <&L2>;
+		};
+		cpu@1 {
+			compatible = "arm,cortex-a9";
+			next-level-cache = <&L2>;
+		};
+	};
+
+	gic: interrupt-controller@d1dfe100 {
+		compatible = "arm,cortex-a9-gic";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		reg = <0xd1dff000 0x1000>,
+		      <0xd1dfe100 0x0100>;
+	};
+
+	L2: l2-cache-controller@d1dfb000 {
+		compatible = "arm,pl310-cache";
+		reg = <0xd1dfb000 0x1000>;
+		arm,data-latency = <2 1 1>;
+		arm,tag-latency = <2 1 1>;
+		arm,pwr-dynamic-clk-gating;
+		arm,pwr-standby-mode;
+		cache-unified;
+		cache-level = <2>;
+	};
+
+	local-timer@d1dfe600 {
+		compatible = "arm,cortex-a9-twd-timer";
+		reg = <0xd1dfe600 0x20>;
+		interrupts = <1 13 0x304>;
+	};
+
+	soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "simple-bus";
+		interrupt-parent = <&gic>;
+		ranges;
+
+		axi@d4200000 {	/* AXI */
+			compatible = "mrvl,axi-bus", "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			reg = <0xd4200000 0x00200000>;
+			ranges;
+
+			intc: interrupt-controller@d4282000 {
+				compatible = "mrvl,mmp-intc";
+				reg = <0xd4282000 0x1000>;
+				mrvl,intc-wakeup = <0x114 0x3
+						    0x144 0x3>;
+			};
+
+		};
+
+		apb@d4000000 {	/* APB */
+			compatible = "mrvl,apb-bus", "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			reg = <0xd4000000 0x00200000>;
+			ranges;
+
+			timer0: timer@d4014000 {
+				compatible = "mrvl,mmp-timer";
+				reg = <0xd4014000 0x100>;
+				interrupts = <0 13 0x4>;
+			};
+
+			timer1: timer@d4016000 {
+				compatible = "mrvl,mmp-timer";
+				reg = <0xd4016000 0x100>;
+				interrupts = <0 29 0x4>;
+				status = "disabled";
+			};
+
+			uart1: uart@d4017000 {
+				compatible = "mrvl,mmp-uart";
+				reg = <0xd4017000 0x1000>;
+				interrupts = <0 27 0x4>;
+				status = "disabled";
+			};
+
+			uart2: uart@d4018000 {
+				compatible = "mrvl,mmp-uart";
+				reg = <0xd4018000 0x1000>;
+				interrupts = <0 28 0x4>;
+				status = "disabled";
+			};
+
+			uart3: uart@d4036000 {
+				compatible = "mrvl,mmp-uart";
+				reg = <0xd4036000 0x1000>;
+				interrupts = <0 59 0x4>;
+				status = "disabled";
+			};
+
+			gpio@d4019000 {
+				compatible = "mrvl,mmp-gpio";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				reg = <0xd4019000 0x1000>;
+				gpio-controller;
+				#gpio-cells = <2>;
+				interrupts = <49>;
+				interrupt-names = "gpio_mux";
+				interrupt-controller;
+				#interrupt-cells = <1>;
+				ranges;
+
+				gcb0: gpio@d4019000 {
+					reg = <0xd4019000 0x4>;
+				};
+
+				gcb1: gpio@d4019004 {
+					reg = <0xd4019004 0x4>;
+				};
+
+				gcb2: gpio@d4019008 {
+					reg = <0xd4019008 0x4>;
+				};
+
+				gcb3: gpio@d4019100 {
+					reg = <0xd4019100 0x4>;
+				};
+			};
+
+			twsi1: i2c@d4011000 {
+				compatible = "mrvl,mmp-twsi";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0xd4011000 0x1000>;
+				interrupts = <0 7 0x4>;
+				mrvl,i2c-fast-mode;
+				status = "disabled";
+			};
+
+			twsi2: i2c@d4037000 {
+				compatible = "mrvl,mmp-twsi";
+				#address-cells = <1>;
+				#size-cells = <0>;
+				reg = <0xd4037000 0x1000>;
+				interrupts = <0 54 0x4>;
+				status = "disabled";
+			};
+
+			rtc: rtc@d4010000 {
+				compatible = "mrvl,mmp-rtc";
+				reg = <0xd4010000 0x1000>;
+				interrupts = <0 5 0x4>,<0 6 0x4>;
+				interrupt-names = "rtc 1Hz", "rtc alarm";
+				status = "disabled";
+			};
+			pmx: pinmux@d401e000 {
+				compatible = "pinconf-single";
+				reg = <0xd401e000 0x330>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				#gpio-range-cells = <3>;
+				ranges;
+
+				pinctrl-single,register-width = <32>;
+				pinctrl-single,function-mask = <7>;
+
+				range: gpio-range {
+					#pinctrl-single,gpio-range-cells = <3>;
+				};
+			};
+		};
+	};
+};
diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
index ebdda83..ffdbab9 100644
--- a/arch/arm/mach-mmp/Kconfig
+++ b/arch/arm/mach-mmp/Kconfig
@@ -107,6 +107,16 @@ config MACH_MMP2_DT
 	  Include support for Marvell MMP2 based platforms using
 	  the device tree.
 
+config MACH_MMPX_DT
+	bool "Support no-PJ/PJ4(ARMv7) platforms from device tree"
+	depends on !CPU_MOHAWK && !CPU_PJ4
+	select CPU_PXA988
+	select USE_OF
+	select PINCTRL
+	select PINCTRL_SINGLE
+	help
+	  Include support for Marvell MMP2 based platforms using
+	  the device tree.
 endmenu
 
 config CPU_PXA168
@@ -123,6 +133,21 @@ config CPU_PXA910
 	help
 	  Select code specific to PXA910
 
+config CPU_PXA988
+	bool
+	select CPU_V7
+	select ARM_GIC
+	select HAVE_SMP
+	select SOC_LOCAL_TIMERS
+	select COMMON_CLK
+	select CLKSRC_OF
+	select MIGHT_HAVE_CACHE_L2X0
+	help
+	  Say 'Y' here if you want to support the Marvell pxa988-base
+	  platforms.
+	  PXA988 is an SoC with dual-core Cotex-A9 and comunication
+	  processor, code name "Emei".
+
 config CPU_MMP2
 	bool
 	select COMMON_CLK
diff --git a/arch/arm/mach-mmp/Makefile b/arch/arm/mach-mmp/Makefile
index 095c155..b60065f 100644
--- a/arch/arm/mach-mmp/Makefile
+++ b/arch/arm/mach-mmp/Makefile
@@ -31,5 +31,6 @@ obj-$(CONFIG_MACH_FLINT)	+= flint.o
 obj-$(CONFIG_MACH_MARVELL_JASPER) += jasper.o
 obj-$(CONFIG_MACH_MMP_DT)	+= mmp-dt.o
 obj-$(CONFIG_MACH_MMP2_DT)	+= mmp2-dt.o
+obj-$(CONFIG_MACH_MMPX_DT)	+= mmpx-dt.o
 obj-$(CONFIG_MACH_TETON_BGA)	+= teton_bga.o
 obj-$(CONFIG_MACH_GPLUGD)	+= gplugd.o
diff --git a/arch/arm/mach-mmp/common.c b/arch/arm/mach-mmp/common.c
index 9292b79..0c621bc 100644
--- a/arch/arm/mach-mmp/common.c
+++ b/arch/arm/mach-mmp/common.c
@@ -11,6 +11,10 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/of_address.h>
 
 #include <asm/page.h>
 #include <asm/mach/map.h>
@@ -36,7 +40,12 @@ static struct map_desc standard_io_desc[] __initdata = {
 		.virtual	= (unsigned long)AXI_VIRT_BASE,
 		.length		= AXI_PHYS_SIZE,
 		.type		= MT_DEVICE,
-	},
+	}, {
+		.pfn		= __phys_to_pfn(MMP_CORE_PERIPH_PHYS_BASE),
+		.virtual	= (unsigned long)MMP_CORE_PERIPH_VIRT_BASE,
+		.length		= MMP_CORE_PERIPH_PHYS_SIZE,
+		.type		= MT_DEVICE,
+	}
 };
 
 void __init mmp_map_io(void)
diff --git a/arch/arm/mach-mmp/include/mach/addr-map.h b/arch/arm/mach-mmp/include/mach/addr-map.h
index f88a44c..092005b 100644
--- a/arch/arm/mach-mmp/include/mach/addr-map.h
+++ b/arch/arm/mach-mmp/include/mach/addr-map.h
@@ -25,6 +25,10 @@
 #define AXI_VIRT_BASE		IOMEM(0xfe200000)
 #define AXI_PHYS_SIZE		0x00200000
 
+#define MMP_CORE_PERIPH_PHYS_BASE	0xd1dfe000
+#define MMP_CORE_PERIPH_VIRT_BASE	IOMEM(0xfe400000)
+#define MMP_CORE_PERIPH_PHYS_SIZE	0x00002000
+
 /* Static Memory Controller - Chip Select 0 and 1 */
 #define SMC_CS0_PHYS_BASE	0x80000000
 #define SMC_CS0_PHYS_SIZE	0x10000000
@@ -43,4 +47,6 @@
 #define CIU_VIRT_BASE		(AXI_VIRT_BASE + 0x82c00)
 #define CIU_REG(x)		(CIU_VIRT_BASE + (x))
 
+#define SCU_VIRT_BASE		(MMP_CORE_PERIPH_VIRT_BASE)
+
 #endif /* __ASM_MACH_ADDR_MAP_H */
diff --git a/arch/arm/mach-mmp/mmpx-dt.c b/arch/arm/mach-mmp/mmpx-dt.c
new file mode 100644
index 0000000..bbc0c50
--- /dev/null
+++ b/arch/arm/mach-mmp/mmpx-dt.c
@@ -0,0 +1,79 @@
+/*
+ *  linux/arch/arm/mach-mmp/mmpx-dt.c
+ *
+ *  Copyright (C) 2012 Marvell Technology Group Ltd.
+ *  Author: Haojian Zhuang <haojian.zhuang@marvell.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  publishhed by the Free Software Foundation.
+ */
+
+#include <linux/clocksource.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/irqchip.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <asm/smp_twd.h>
+#include <asm/hardware/cache-l2x0.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/time.h>
+#include <mach/irqs.h>
+#include <mach/regs-apbc.h>
+
+#include "common.h"
+
+/* PXA988 */
+static const struct of_dev_auxdata pxa988_auxdata_lookup[] __initconst = {
+	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4017000, "pxa2xx-uart.0", NULL),
+	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4018000, "pxa2xx-uart.1", NULL),
+	OF_DEV_AUXDATA("mrvl,mmp-uart", 0xd4036000, "pxa2xx-uart.2", NULL),
+	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4011000, "pxa2xx-i2c.0", NULL),
+	OF_DEV_AUXDATA("mrvl,mmp-twsi", 0xd4037000, "pxa2xx-i2c.1", NULL),
+	OF_DEV_AUXDATA("mrvl,mmp-gpio", 0xd4019000, "pxa-gpio", NULL),
+	OF_DEV_AUXDATA("mrvl,mmp-rtc", 0xd4010000, "sa1100-rtc", NULL),
+	{}
+};
+
+static void __init pxa988_dt_gic_init(void)
+{
+	irqchip_init();
+	/* only for wake up */
+	mmp_dt_irq_init();
+}
+
+void __init pxa988_dt_init_timer(void)
+{
+	/*
+	 * Is is a SOC timer, and will be used for broadcasting
+	 * when local timers are disabled.
+	 */
+	mmp_dt_init_timer();
+
+	clocksource_of_init();
+}
+
+static void __init pxa988_dt_init(void)
+{
+	l2x0_of_init(0x30800000, 0xFE7FFFFF);
+
+	pxa910_clk_init();
+
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     pxa988_auxdata_lookup, NULL);
+}
+
+static const char *pxa988_dt_board_compat[] __initdata = {
+	"mrvl,pxa988-dkb",
+	NULL,
+};
+
+DT_MACHINE_START(PXA988_DT, "Marvell PXA988 (Device Tree Support)")
+	.map_io		= mmp_map_io,
+	.init_irq	= pxa988_dt_gic_init,
+	.init_time	= pxa988_dt_init_timer,
+	.init_machine	= pxa988_dt_init,
+	.dt_compat	= pxa988_dt_board_compat,
+MACHINE_END
diff --git a/drivers/clk/mmp/Makefile b/drivers/clk/mmp/Makefile
index 392d780..59a3f9f7 100644
--- a/drivers/clk/mmp/Makefile
+++ b/drivers/clk/mmp/Makefile
@@ -7,3 +7,4 @@ obj-y += clk-apbc.o clk-apmu.o clk-frac.o
 obj-$(CONFIG_CPU_PXA168) += clk-pxa168.o
 obj-$(CONFIG_CPU_PXA910) += clk-pxa910.o
 obj-$(CONFIG_CPU_MMP2) += clk-mmp2.o
+obj-$(CONFIG_CPU_PXA988) += clk-pxa910.o
-- 
1.7.4.1

