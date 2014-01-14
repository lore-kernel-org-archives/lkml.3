Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaANK7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:59:31 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:39125 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751976AbaANK56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:57:58 -0500
From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stephen.gallimore@st.com>, <kernel@stlinux.com>,
        <lee.jones@linaro.com>
Subject: [PATCH v1 3/6] drivers: reset: Reset controller driver for STiH416
Date: Tue, 14 Jan 2014 10:51:30 +0000
Message-ID: <1389696690-19819-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1389696613-19683-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389696613-19683-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Gallimore <stephen.gallimore@st.com>

This patch adds a reset controller platform driver for the STiH416
SoC. This initial version provides a compatible driver for the
"st,stih416-powerdown" device, which registers a system configuration
register based reset controller that controls the powerdown state of
hardware such as the on-chip USB host controllers.

Signed-off-by: Stephen Gallimore <stephen.gallimore@st.com>
---
 arch/arm/boot/dts/stih416.dtsi                     |    6 ++
 drivers/reset/sti/Kconfig                          |    4 +
 drivers/reset/sti/Makefile                         |    2 +-
 drivers/reset/sti/reset-stih416.c                  |   79 ++++++++++++++++++++
 .../dt-bindings/reset-controller/stih416-resets.h  |   21 +++++
 5 files changed, 111 insertions(+), 1 deletions(-)
 create mode 100644 drivers/reset/sti/reset-stih416.c
 create mode 100644 include/dt-bindings/reset-controller/stih416-resets.h

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index b7ab47b..e5bec66 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -10,6 +10,7 @@
 #include "stih416-clock.dtsi"
 #include "stih416-pinctrl.dtsi"
 #include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/reset-controller/stih416-resets.h>
 / {
 	L2: cache-controller {
 		compatible = "arm,pl310-cache";
@@ -27,6 +28,11 @@
 		ranges;
 		compatible	= "simple-bus";
 
+		powerdown: powerdown-controller {
+			#reset-cells = <1>;
+			compatible = "st,stih416-powerdown";
+		};
+
 		syscfg_sbc:sbc-syscfg@fe600000{
 			compatible	= "st,stih416-sbc-syscfg", "syscon";
 			reg		= <0xfe600000 0x1000>;
diff --git a/drivers/reset/sti/Kconfig b/drivers/reset/sti/Kconfig
index ef6654a..88d2d03 100644
--- a/drivers/reset/sti/Kconfig
+++ b/drivers/reset/sti/Kconfig
@@ -8,4 +8,8 @@ config STIH415_RESET
 	bool
 	select STI_RESET_SYSCFG
 
+config STIH416_RESET
+	bool
+	select STI_RESET_SYSCFG
+
 endif
diff --git a/drivers/reset/sti/Makefile b/drivers/reset/sti/Makefile
index fce4433..be1c976 100644
--- a/drivers/reset/sti/Makefile
+++ b/drivers/reset/sti/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_STI_RESET_SYSCFG) += reset-syscfg.o
 
-# SoC specific reset devices
 obj-$(CONFIG_STIH415_RESET) += reset-stih415.o
+obj-$(CONFIG_STIH416_RESET) += reset-stih416.o
diff --git a/drivers/reset/sti/reset-stih416.c b/drivers/reset/sti/reset-stih416.c
new file mode 100644
index 0000000..0becfc5
--- /dev/null
+++ b/drivers/reset/sti/reset-stih416.c
@@ -0,0 +1,79 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics (R&D) Limited
+ * Author: Stephen Gallimore <stephen.gallimore@st.com>
+ * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+#include <dt-bindings/reset-controller/stih416-resets.h>
+
+#include "reset-syscfg.h"
+
+/*
+ * STiH416 Peripheral powerdown definitions.
+ */
+static const char stih416_front[] = "st,stih416-front-syscfg";
+static const char stih416_rear[] = "st,stih416-rear-syscfg";
+static const char stih416_sbc[] = "st,stih416-sbc-syscfg";
+static const char stih416_lpm[] = "st,stih416-lpm-syscfg";
+
+#define STIH416_PDN_FRONT(_bit) \
+	_SYSCFG_RST_CH(stih416_front, SYSCFG_1500, _bit, SYSSTAT_1578, _bit)
+
+#define STIH416_PDN_REAR(_cntl, _stat) \
+	_SYSCFG_RST_CH(stih416_rear, SYSCFG_2525, _cntl, SYSSTAT_2583, _stat)
+
+#define SYSCFG_1500	0x7d0 /* Powerdown request EMI/NAND/Keyscan */
+#define SYSSTAT_1578	0x908 /* Powerdown status EMI/NAND/Keyscan */
+
+#define SYSCFG_2525	0x834 /* Powerdown request USB/SATA/PCIe */
+#define SYSSTAT_2583	0x91c /* Powerdown status USB/SATA/PCIe */
+
+static const struct syscfg_reset_channel_data stih416_powerdowns[] = {
+	[STIH416_EMISS_POWERDOWN]	= STIH416_PDN_FRONT(0),
+	[STIH416_NAND_POWERDOWN]	= STIH416_PDN_FRONT(1),
+	[STIH416_KEYSCAN_POWERDOWN]	= STIH416_PDN_FRONT(2),
+	[STIH416_USB0_POWERDOWN]	= STIH416_PDN_REAR(0, 0),
+	[STIH416_USB1_POWERDOWN]	= STIH416_PDN_REAR(1, 1),
+	[STIH416_USB2_POWERDOWN]	= STIH416_PDN_REAR(2, 2),
+	[STIH416_USB3_POWERDOWN]	= STIH416_PDN_REAR(6, 5),
+	[STIH416_SATA0_POWERDOWN]	= STIH416_PDN_REAR(3, 3),
+	[STIH416_SATA1_POWERDOWN]	= STIH416_PDN_REAR(4, 4),
+	[STIH416_PCIE0_POWERDOWN]	= STIH416_PDN_REAR(7, 9),
+	[STIH416_PCIE1_POWERDOWN]	= STIH416_PDN_REAR(5, 8),
+};
+
+static struct syscfg_reset_controller_data stih416_powerdown_controller = {
+	.wait_for_ack	= true,
+	.nr_channels	= ARRAY_SIZE(stih416_powerdowns),
+	.channels	= stih416_powerdowns,
+};
+
+static struct of_device_id stih416_reset_match[] = {
+	{ .compatible = "st,stih416-powerdown",
+	  .data = &stih416_powerdown_controller, },
+	{},
+};
+
+static struct platform_driver stih416_reset_driver = {
+	.probe = syscfg_reset_probe,
+	.driver = {
+		.name = "reset-stih416",
+		.owner = THIS_MODULE,
+		.of_match_table = stih416_reset_match,
+	},
+};
+
+static int __init stih416_reset_init(void)
+{
+	return platform_driver_register(&stih416_reset_driver);
+}
+arch_initcall(stih416_reset_init);
diff --git a/include/dt-bindings/reset-controller/stih416-resets.h b/include/dt-bindings/reset-controller/stih416-resets.h
new file mode 100644
index 0000000..d7da55f
--- /dev/null
+++ b/include/dt-bindings/reset-controller/stih416-resets.h
@@ -0,0 +1,21 @@
+/*
+ * This header provides constants for the reset controller
+ * based peripheral powerdown requests on the STMicroelectronics
+ * STiH416 SoC.
+ */
+#ifndef _DT_BINDINGS_RESET_CONTROLLER_STIH416
+#define _DT_BINDINGS_RESET_CONTROLLER_STIH416
+
+#define STIH416_EMISS_POWERDOWN		0
+#define STIH416_NAND_POWERDOWN		1
+#define STIH416_KEYSCAN_POWERDOWN	2
+#define STIH416_USB0_POWERDOWN		3
+#define STIH416_USB1_POWERDOWN		4
+#define STIH416_USB2_POWERDOWN		5
+#define STIH416_USB3_POWERDOWN		6
+#define STIH416_SATA0_POWERDOWN		7
+#define STIH416_SATA1_POWERDOWN		8
+#define STIH416_PCIE0_POWERDOWN		9
+#define STIH416_PCIE1_POWERDOWN		10
+
+#endif /* _DT_BINDINGS_RESET_CONTROLLER_STIH416 */
-- 
1.7.6.5

