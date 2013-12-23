Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab3LWQ0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:26:01 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39797 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab3LWQYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:12 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>
Subject: [RFC 18/18] mfd: vexpress: Split sysreg functions into MFD cells
Date: Mon, 23 Dec 2013 16:23:50 +0000
Message-Id: <1387815830-8794-19-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 23 Dec 2013 16:24:09.0712 (UTC) FILETIME=[6899FF00:01CEFFFB]
X-MC-Unique: 113122316241009301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBNGQ8vi026621

This patch splits individual sysreg functions into
separate MFD cells, which then become individual
platform devices with their own drivers.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 .../devicetree/bindings/arm/vexpress-sysreg.txt    |  37 ++-
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi            |  76 ++++++-
 arch/arm/boot/dts/vexpress-v2m.dtsi                |  76 ++++++-
 arch/arm/mach-vexpress/v2m.c                       |  23 +-
 drivers/mfd/Kconfig                                |  11 +
 drivers/mfd/Makefile                               |   2 +-
 drivers/mfd/vexpress-sysreg.c                      | 247 +++++++++++++++------
 include/linux/vexpress.h                           |  16 +-
 8 files changed, 377 insertions(+), 111 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/vexpress-sysreg.txt b/Documentation/devicetree/bindings/arm/vexpress-sysreg.txt
index 5580e9c..8caefec6 100644
--- a/Documentation/devicetree/bindings/arm/vexpress-sysreg.txt
+++ b/Documentation/devicetree/bindings/arm/vexpress-sysreg.txt
@@ -8,6 +8,8 @@ interrupt generation, MMC and NOR Flash control etc.
 Required node properties:
 - compatible value : = "arm,vexpress,sysreg";
 - reg : physical base address and the size of the registers window
+
+Deprecated properties, replaced by GPIO subnodes (see below):
 - gpio-controller : specifies that the node is a GPIO controller
 - #gpio-cells : size of the GPIO specifier, should be 2:
   - first cell is the pseudo-GPIO line number:
@@ -16,12 +18,42 @@ Required node properties:
     2 - NOR FLASH WPn
   - second cell can take standard GPIO flags (currently ignored).
 
+Control registers providing pseudo-GPIO lines must be represented
+by subnodes, each of them requiring the following properties:
+- compatible value : one of
+			"arm,vexpress-sysreg,sys_led"
+			"arm,vexpress-sysreg,sys_mci"
+			"arm,vexpress-sysreg,sys_flash"
+- gpio-controller : makes the node a GPIO controller
+- #gpio-cells : size of the GPIO specifier, must be 2:
+  - first cell is the function number:
+    - for sys_led : 0..7 = LED 0..7
+    - for sys_mci : 0 = MMC CARDIN, 1 = MMC WPROT
+    - for sys_flash : 0 = NOR FLASH WPn
+  - second cell can take standard GPIO flags (currently ignored).
+
 Example:
 	v2m_sysreg: sysreg@10000000 {
  		compatible = "arm,vexpress-sysreg";
  		reg = <0x10000000 0x1000>;
-		gpio-controller;
-		#gpio-cells = <2>;
+
+		v2m_led_gpios: sys_led@08 {
+			compatible = "arm,vexpress-sysreg,sys_led";
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
+		v2m_mmc_gpios: sys_mci@48 {
+			compatible = "arm,vexpress-sysreg,sys_mci";
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+
+		v2m_flash_gpios: sys_flash@4c {
+			compatible = "arm,vexpress-sysreg,sys_flash";
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
  	};
 
 This block also can also act a bridge to the platform's configuration
@@ -41,6 +73,7 @@ property:
 
 Example:
 	mcc {
+		compatible = "arm,vexpress,config-bus";
 		arm,vexpress,config-bridge = <&v2m_sysreg>;
 
 		osc@0 {
diff --git a/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi b/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
index ac870fb..756c986 100644
--- a/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
+++ b/arch/arm/boot/dts/vexpress-v2m-rs1.dtsi
@@ -74,8 +74,24 @@
 			v2m_sysreg: sysreg@010000 {
 				compatible = "arm,vexpress-sysreg";
 				reg = <0x010000 0x1000>;
-				gpio-controller;
-				#gpio-cells = <2>;
+
+				v2m_led_gpios: sys_led@08 {
+					compatible = "arm,vexpress-sysreg,sys_led";
+					gpio-controller;
+					#gpio-cells = <2>;
+				};
+
+				v2m_mmc_gpios: sys_mci@48 {
+					compatible = "arm,vexpress-sysreg,sys_mci";
+					gpio-controller;
+					#gpio-cells = <2>;
+				};
+
+				v2m_flash_gpios: sys_flash@4c {
+					compatible = "arm,vexpress-sysreg,sys_flash";
+					gpio-controller;
+					#gpio-cells = <2>;
+				};
 			};
 
 			v2m_sysctl: sysctl@020000 {
@@ -113,8 +129,8 @@
 				compatible = "arm,pl180", "arm,primecell";
 				reg = <0x050000 0x1000>;
 				interrupts = <9 10>;
-				cd-gpios = <&v2m_sysreg 0 0>;
-				wp-gpios = <&v2m_sysreg 1 0>;
+				cd-gpios = <&v2m_mmc_gpios 0 0>;
+				wp-gpios = <&v2m_mmc_gpios 1 0>;
 				max-frequency = <12000000>;
 				vmmc-supply = <&v2m_fixed_3v3>;
 				clocks = <&v2m_clk24mhz>, <&smbclk>;
@@ -265,6 +281,58 @@
 			clock-output-names = "v2m:refclk32khz";
 		};
 
+		leds {
+			compatible = "gpio-leds";
+
+			user@1 {
+				label = "v2m:green:user1";
+				gpios = <&v2m_led_gpios 0 0>;
+				linux,default-trigger = "heartbeat";
+			};
+
+			user@2 {
+				label = "v2m:green:user2";
+				gpios = <&v2m_led_gpios 1 0>;
+				linux,default-trigger = "mmc0";
+			};
+
+			user@3 {
+				label = "v2m:green:user3";
+				gpios = <&v2m_led_gpios 2 0>;
+				linux,default-trigger = "cpu0";
+			};
+
+			user@4 {
+				label = "v2m:green:user4";
+				gpios = <&v2m_led_gpios 3 0>;
+				linux,default-trigger = "cpu1";
+			};
+
+			user@5 {
+				label = "v2m:green:user5";
+				gpios = <&v2m_led_gpios 4 0>;
+				linux,default-trigger = "cpu2";
+			};
+
+			user@6 {
+				label = "v2m:green:user6";
+				gpios = <&v2m_led_gpios 5 0>;
+				linux,default-trigger = "cpu3";
+			};
+
+			user@7 {
+				label = "v2m:green:user7";
+				gpios = <&v2m_led_gpios 6 0>;
+				linux,default-trigger = "cpu4";
+			};
+
+			user@8 {
+				label = "v2m:green:user8";
+				gpios = <&v2m_led_gpios 7 0>;
+				linux,default-trigger = "cpu5";
+			};
+		};
+
 		mcc {
 			compatible = "arm,vexpress,config-bus";
 			arm,vexpress,config-bridge = <&v2m_sysreg>;
diff --git a/arch/arm/boot/dts/vexpress-v2m.dtsi b/arch/arm/boot/dts/vexpress-v2m.dtsi
index f142036..ba856d6 100644
--- a/arch/arm/boot/dts/vexpress-v2m.dtsi
+++ b/arch/arm/boot/dts/vexpress-v2m.dtsi
@@ -73,8 +73,24 @@
 			v2m_sysreg: sysreg@00000 {
 				compatible = "arm,vexpress-sysreg";
 				reg = <0x00000 0x1000>;
-				gpio-controller;
-				#gpio-cells = <2>;
+
+				v2m_led_gpios: sys_led@08 {
+					compatible = "arm,vexpress-sysreg,sys_led";
+					gpio-controller;
+					#gpio-cells = <2>;
+				};
+
+				v2m_mmc_gpios: sys_mci@48 {
+					compatible = "arm,vexpress-sysreg,sys_mci";
+					gpio-controller;
+					#gpio-cells = <2>;
+				};
+
+				v2m_flash_gpios: sys_flash@4c {
+					compatible = "arm,vexpress-sysreg,sys_flash";
+					gpio-controller;
+					#gpio-cells = <2>;
+				};
 			};
 
 			v2m_sysctl: sysctl@01000 {
@@ -112,8 +128,8 @@
 				compatible = "arm,pl180", "arm,primecell";
 				reg = <0x05000 0x1000>;
 				interrupts = <9 10>;
-				cd-gpios = <&v2m_sysreg 0 0>;
-				wp-gpios = <&v2m_sysreg 1 0>;
+				cd-gpios = <&v2m_mmc_gpios 0 0>;
+				wp-gpios = <&v2m_mmc_gpios 1 0>;
 				max-frequency = <12000000>;
 				vmmc-supply = <&v2m_fixed_3v3>;
 				clocks = <&v2m_clk24mhz>, <&smbclk>;
@@ -264,6 +280,58 @@
 			clock-output-names = "v2m:refclk32khz";
 		};
 
+		leds {
+			compatible = "gpio-leds";
+
+			user@1 {
+				label = "v2m:green:user1";
+				gpios = <&v2m_led_gpios 0 0>;
+				linux,default-trigger = "heartbeat";
+			};
+
+			user@2 {
+				label = "v2m:green:user2";
+				gpios = <&v2m_led_gpios 1 0>;
+				linux,default-trigger = "mmc0";
+			};
+
+			user@3 {
+				label = "v2m:green:user3";
+				gpios = <&v2m_led_gpios 2 0>;
+				linux,default-trigger = "cpu0";
+			};
+
+			user@4 {
+				label = "v2m:green:user4";
+				gpios = <&v2m_led_gpios 3 0>;
+				linux,default-trigger = "cpu1";
+			};
+
+			user@5 {
+				label = "v2m:green:user5";
+				gpios = <&v2m_led_gpios 4 0>;
+				linux,default-trigger = "cpu2";
+			};
+
+			user@6 {
+				label = "v2m:green:user6";
+				gpios = <&v2m_led_gpios 5 0>;
+				linux,default-trigger = "cpu3";
+			};
+
+			user@7 {
+				label = "v2m:green:user7";
+				gpios = <&v2m_led_gpios 6 0>;
+				linux,default-trigger = "cpu4";
+			};
+
+			user@8 {
+				label = "v2m:green:user8";
+				gpios = <&v2m_led_gpios 7 0>;
+				linux,default-trigger = "cpu5";
+			};
+		};
+
 		mcc {
 			compatible = "arm,vexpress,config-bus";
 			arm,vexpress,config-bridge = <&v2m_sysreg>;
diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 325ae06..c39b14a 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -201,8 +201,9 @@ static struct platform_device v2m_cf_device = {
 
 static struct mmci_platform_data v2m_mmci_data = {
 	.ocr_mask	= MMC_VDD_32_33|MMC_VDD_33_34,
-	.gpio_wp	= VEXPRESS_GPIO_MMC_WPROT,
-	.gpio_cd	= VEXPRESS_GPIO_MMC_CARDIN,
+	.status		= vexpress_get_mci_cardin,
+	.gpio_cd	= -1,
+	.gpio_wp	= -1,
 };
 
 static struct resource v2m_sysreg_resources[] = {
@@ -394,23 +395,6 @@ void __init v2m_dt_map_io(void)
 		iotable_init(v2m_io_desc, ARRAY_SIZE(v2m_io_desc));
 }
 
-void __init v2m_dt_init_early(void)
-{
-	u32 dt_hbi;
-
-	vexpress_sysreg_of_early_init();
-
-	/* Confirm board type against DT property, if available */
-	if (of_property_read_u32(of_allnodes, "arm,hbi", &dt_hbi) == 0) {
-		u32 hbi = vexpress_get_hbi(VEXPRESS_SITE_MASTER);
-
-		if (WARN_ON(dt_hbi != hbi))
-			pr_warning("vexpress: DT HBI (%x) is not matching "
-					"hardware (%x)!\n", dt_hbi, hbi);
-	}
-}
-
-
 static void __init v2m_dt_init(void)
 {
 	l2x0_of_init(0x00400000, 0xfe0fffff);
@@ -427,6 +411,5 @@ DT_MACHINE_START(VEXPRESS_DT, "ARM-Versatile Express")
 	.smp		= smp_ops(vexpress_smp_dt_ops),
 	.smp_init	= smp_init_ops(vexpress_smp_init_ops),
 	.map_io		= v2m_dt_map_io,
-	.init_early	= v2m_dt_init_early,
 	.init_machine	= v2m_dt_init,
 MACHINE_END
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 4c8cdc3..a4effd4 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1200,3 +1200,14 @@ config MCP_UCB1200_TS
 
 endmenu
 
+config MFD_VEXPRESS_SYSREG
+	bool "Versatile Express System Registers"
+	depends on VEXPRESS_CONFIG
+	default y
+	select CLKSRC_MMIO
+	select GPIO_GENERIC_PLATFORM
+	select MFD_CORE
+	select MFD_SYSCON
+	help
+	  System Registers are the platform configuration block
+	  on the ARM Ltd. Versatile Express board.
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 0277aa8..b6c9c32 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -159,7 +159,7 @@ obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
 obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
 obj-$(CONFIG_MFD_SYSCON)	+= syscon.o
 obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
-obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-sysreg.o
+obj-$(CONFIG_MFD_VEXPRESS_SYSREG)	+= vexpress-sysreg.o
 obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
 obj-$(CONFIG_MFD_AS3711)	+= as3711.o
 obj-$(CONFIG_MFD_AS3722)	+= as3722.o
diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index 31b3290..2258344 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -8,26 +8,24 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * Copyright (C) 2012 ARM Limited
+ * Copyright (C) 2013 ARM Limited
  */
 
+#include <linux/basic_mmio_gpio.h>
 #include <linux/err.h>
-#include <linux/gpio.h>
 #include <linux/io.h>
-#include <linux/leds.h>
+#include <linux/mfd/core.h>
 #include <linux/of_address.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
-#include <linux/regulator/driver.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
-#include <linux/timer.h>
 #include <linux/vexpress.h>
 
 #define SYS_ID			0x000
 #define SYS_SW			0x004
 #define SYS_LED			0x008
 #define SYS_100HZ		0x024
-#define SYS_FLAGS		0x030
 #define SYS_FLAGSSET		0x030
 #define SYS_FLAGSCLR		0x034
 #define SYS_NVFLAGS		0x038
@@ -45,65 +43,34 @@
 #define SYS_CFGCTRL		0x0a4
 #define SYS_CFGSTAT		0x0a8
 
-#define SYS_HBI_MASK		0xfff
-#define SYS_ID_HBI_SHIFT	16
-#define SYS_PROCIDx_HBI_SHIFT	0
-
-#define SYS_LED_LED(n)		(1 << (n))
-
-#define SYS_MCI_CARDIN		(1 << 0)
-#define SYS_MCI_WPROT		(1 << 1)
-
-#define SYS_FLASH_WPn		(1 << 0)
-
 #define SYS_MISC_MASTERSITE	(1 << 14)
 
-#define SYS_CFGCTRL_START	(1 << 31)
-#define SYS_CFGCTRL_WRITE	(1 << 30)
-#define SYS_CFGCTRL_DCC(n)	(((n) & 0xf) << 26)
-#define SYS_CFGCTRL_FUNC(n)	(((n) & 0x3f) << 20)
-#define SYS_CFGCTRL_SITE(n)	(((n) & 0x3) << 16)
-#define SYS_CFGCTRL_POSITION(n)	(((n) & 0xf) << 12)
-#define SYS_CFGCTRL_DEVICE(n)	(((n) & 0xfff) << 0)
 
-#define SYS_CFGSTAT_ERR		(1 << 1)
-#define SYS_CFGSTAT_COMPLETE	(1 << 0)
+static int vexpress_sysreg_get_master(void __iomem *base)
+{
+	if (readl(base + SYS_MISC) & SYS_MISC_MASTERSITE)
+		return VEXPRESS_SITE_DB2;
 
+	return VEXPRESS_SITE_DB1;
+}
 
-static void __iomem *vexpress_sysreg_base;
 
+/* Non-DT case platform functions, to be gone... */
 
-void vexpress_flags_set(u32 data)
-{
-	writel(~0, vexpress_sysreg_base + SYS_FLAGSCLR);
-	writel(data, vexpress_sysreg_base + SYS_FLAGSSET);
-}
+static void __iomem *vexpress_sysreg_base;
 
 u32 vexpress_get_procid(int site)
 {
 	if (site == VEXPRESS_SITE_MASTER)
-		site = vexpress_config_get_master();
+		site = vexpress_sysreg_get_master(vexpress_sysreg_base);
 
 	return readl(vexpress_sysreg_base + (site == VEXPRESS_SITE_DB1 ?
 			SYS_PROCID0 : SYS_PROCID1));
 }
 
-u32 vexpress_get_hbi(int site)
+unsigned int vexpress_get_mci_cardin(struct device *dev)
 {
-	u32 id;
-
-	switch (site) {
-	case VEXPRESS_SITE_MB:
-		id = readl(vexpress_sysreg_base + SYS_ID);
-		return (id >> SYS_ID_HBI_SHIFT) & SYS_HBI_MASK;
-	case VEXPRESS_SITE_MASTER:
-	case VEXPRESS_SITE_DB1:
-	case VEXPRESS_SITE_DB2:
-		id = vexpress_get_procid(site);
-		return (id >> SYS_PROCIDx_HBI_SHIFT) & SYS_HBI_MASK;
-	}
-
-	return ~0;
+	return readl(vexpress_sysreg_base + SYS_MCI) & 1;
 }
 
 void __iomem *vexpress_get_24mhz_clock_base(void)
@@ -111,34 +78,184 @@ void __iomem *vexpress_get_24mhz_clock_base(void)
 	return vexpress_sysreg_base + SYS_24MHZ;
 }
 
-
-void vexpress_sysreg_setup(struct device_node *node)
+void __init vexpress_sysreg_early_init(void __iomem *base)
 {
-	if (WARN_ON(!vexpress_sysreg_base))
+	if (WARN_ON(!base))
 		return;
 
-	if (readl(vexpress_sysreg_base + SYS_MISC) & SYS_MISC_MASTERSITE)
-		vexpress_config_set_master(VEXPRESS_SITE_DB2);
+	vexpress_sysreg_base = base;
+
+	vexpress_config_set_master(vexpress_sysreg_get_master(base));
+}
+
+
+/* Versatile SMP boot protocol helper */
+
+void vexpress_flags_set(u32 data)
+{
+	struct device_node *node = of_find_compatible_node(NULL, NULL,
+			"arm,vexpress-sysreg");
+	void __iomem *base;
+
+	if (node)
+		base = of_iomap(node, 0);
 	else
-		vexpress_config_set_master(VEXPRESS_SITE_DB1);
+		base = vexpress_sysreg_base;
+
+	if (WARN_ON(!base))
+		return;
+
+	writel(~0, base + SYS_FLAGSCLR);
+	writel(data, base + SYS_FLAGSSET);
+
+	if (node)
+		iounmap(base);
 }
 
-void __init vexpress_sysreg_early_init(void __iomem *base)
+
+/* The sysreg block is just a random collection of various functions... */
+
+static const char vexpress_sysreg_sys_id_pdata[] = "sys_id";
+
+static struct bgpio_pdata vexpress_sysreg_sys_led_pdata = {
+	.label = "sys_led",
+	.base = -1,
+	.ngpio = 8,
+};
+
+static struct bgpio_pdata vexpress_sysreg_sys_mci_pdata = {
+	.label = "sys_mci",
+	.base = -1,
+	.ngpio = 2,
+};
+
+static struct bgpio_pdata vexpress_sysreg_sys_flash_pdata = {
+	.label = "sys_flash",
+	.base = -1,
+	.ngpio = 1,
+};
+
+static const char vexpress_sysreg_sys_misc_pdata[] = "sys_misc";
+
+static const char vexpress_sysreg_sys_procid_pdata[] = "sys_procid";
+
+static struct mfd_cell vexpress_sysreg_cells[] = {
+	{
+		.name = "syscon",
+		.of_compatible = "arm,vexpress-sysreg,sys_id",
+		.num_resources = 1,
+		.resources = (struct resource []) {
+			DEFINE_RES_MEM(SYS_ID, 0x4),
+		},
+		.platform_data = &vexpress_sysreg_sys_id_pdata,
+		.pdata_size = sizeof(vexpress_sysreg_sys_id_pdata),
+	}, {
+		.name = "basic-mmio-gpio",
+		.of_compatible = "arm,vexpress-sysreg,sys_led",
+		.num_resources = 1,
+		.resources = (struct resource []) {
+			DEFINE_RES_MEM_NAMED(SYS_LED, 0x4, "dat"),
+		},
+		.platform_data = &vexpress_sysreg_sys_led_pdata,
+		.pdata_size = sizeof(vexpress_sysreg_sys_led_pdata),
+	}, {
+		.name = "basic-mmio-gpio",
+		.of_compatible = "arm,vexpress-sysreg,sys_mci",
+		.num_resources = 1,
+		.resources = (struct resource []) {
+			DEFINE_RES_MEM_NAMED(SYS_MCI, 0x4, "dat"),
+		},
+		.platform_data = &vexpress_sysreg_sys_mci_pdata,
+		.pdata_size = sizeof(vexpress_sysreg_sys_mci_pdata),
+	}, {
+		.name = "basic-mmio-gpio",
+		.of_compatible = "arm,vexpress-sysreg,sys_flash",
+		.num_resources = 1,
+		.resources = (struct resource []) {
+			DEFINE_RES_MEM_NAMED(SYS_FLASH, 0x4, "dat"),
+		},
+		.platform_data = &vexpress_sysreg_sys_flash_pdata,
+		.pdata_size = sizeof(vexpress_sysreg_sys_flash_pdata),
+	}, {
+		.name = "syscon",
+		.num_resources = 1,
+		.resources = (struct resource []) {
+			DEFINE_RES_MEM(SYS_MISC, 0x4),
+		},
+		.platform_data = &vexpress_sysreg_sys_misc_pdata,
+		.pdata_size = sizeof(vexpress_sysreg_sys_misc_pdata),
+	}, {
+		.name = "syscon",
+		.num_resources = 1,
+		.resources = (struct resource []) {
+			DEFINE_RES_MEM(SYS_PROCID0, 0x8),
+		},
+		.platform_data = &vexpress_sysreg_sys_procid_pdata,
+		.pdata_size = sizeof(vexpress_sysreg_sys_procid_pdata),
+	}, {
+		.name = "vexpress-syscfg",
+		.num_resources = 1,
+		.resources = (struct resource []) {
+			DEFINE_RES_MEM(SYS_CFGDATA, 0xc),
+		},
+	}
+};
+
+static int vexpress_sysreg_probe(struct platform_device *pdev)
 {
-	vexpress_sysreg_base = base;
-	vexpress_sysreg_setup(NULL);
+	struct resource *mem;
+	void __iomem *base;
+	struct bgpio_chip *mmc_gpio_chip;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -EINVAL;
+
+	base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
+	if (!base)
+		return -ENOMEM;
+
+	vexpress_config_set_master(vexpress_sysreg_get_master(base));
+
+	/*
+	 * Duplicated SYS_MCI pseudo-GPIO controller for compatibility with
+	 * older trees using sysreg node for MMC control lines.
+	 */
+	mmc_gpio_chip = devm_kzalloc(&pdev->dev, sizeof(*mmc_gpio_chip),
+			GFP_KERNEL);
+	if (!mmc_gpio_chip)
+		return -ENOMEM;
+	bgpio_init(mmc_gpio_chip, &pdev->dev, 0x4, base + SYS_MCI, NULL,
+			NULL, NULL, NULL, 0);
+	mmc_gpio_chip->gc.ngpio = 2;
+	gpiochip_add(&mmc_gpio_chip->gc);
+
+	return mfd_add_devices(&pdev->dev, PLATFORM_DEVID_AUTO,
+			vexpress_sysreg_cells,
+			ARRAY_SIZE(vexpress_sysreg_cells), mem, 0, 0);
 }
 
-void __init vexpress_sysreg_of_early_init(void)
+static const struct of_device_id vexpress_sysreg_match[] = {
+	{ .compatible = "arm,vexpress-sysreg", },
+	{},
+};
+
+static struct platform_driver vexpress_sysreg_driver = {
+	.driver = {
+		.name = "vexpress-sysreg",
+		.of_match_table = vexpress_sysreg_match,
+	},
+	.probe = vexpress_sysreg_probe,
+};
+
+static int __init vexpress_sysreg_init(void)
 {
 	struct device_node *node;
 
-	if (vexpress_sysreg_base)
-		return;
+	/* Need the sysreg early, before any other device... */
+	for_each_matching_node(node, vexpress_sysreg_match)
+		of_platform_device_create(node, NULL, NULL);
 
-	node = of_find_compatible_node(NULL, NULL, "arm,vexpress-sysreg");
-	if (node) {
-		vexpress_sysreg_base = of_iomap(node, 0);
-		vexpress_sysreg_setup(node);
-	}
+	return platform_driver_register(&vexpress_sysreg_driver);
 }
+core_initcall(vexpress_sysreg_init);
diff --git a/include/linux/vexpress.h b/include/linux/vexpress.h
index 203f63a..72dd902 100644
--- a/include/linux/vexpress.h
+++ b/include/linux/vexpress.h
@@ -23,18 +23,6 @@
 #define VEXPRESS_SITE_DB2		2
 #define VEXPRESS_SITE_MASTER		0xf
 
-#define VEXPRESS_GPIO_MMC_CARDIN	0
-#define VEXPRESS_GPIO_MMC_WPROT		1
-#define VEXPRESS_GPIO_FLASH_WPn		2
-#define VEXPRESS_GPIO_LED0		3
-#define VEXPRESS_GPIO_LED1		4
-#define VEXPRESS_GPIO_LED2		5
-#define VEXPRESS_GPIO_LED3		6
-#define VEXPRESS_GPIO_LED4		7
-#define VEXPRESS_GPIO_LED5		8
-#define VEXPRESS_GPIO_LED6		9
-#define VEXPRESS_GPIO_LED7		10
-
 /* Config infrastructure */
 
 void vexpress_config_set_master(u32 site);
@@ -55,12 +43,10 @@ struct regmap *devm_vexpress_syscfg_regmap_init(struct device *dev,
                u32 site, u32 position, u32 dcc, u32 function, u32 device);
 
 u32 vexpress_get_procid(int site);
-u32 vexpress_get_hbi(int site);
+unsigned int vexpress_get_mci_cardin(struct device *dev);
 void *vexpress_get_24mhz_clock_base(void);
 void vexpress_flags_set(u32 data);
-
 void vexpress_sysreg_early_init(void __iomem *base);
-void vexpress_sysreg_of_early_init(void);
 
 /* Clocks */
 
-- 
1.8.3.2


