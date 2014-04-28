Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243AbaD1Tyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:54:44 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:28258 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933158AbaD1Txc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:53:32 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 04/10] mfd: vexpress: Define the device as MFD cells
Date: Mon, 28 Apr 2014 18:57:51 +0100
Message-Id: <1398707877-22596-5-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch - finally, after over 6 months! :-( - addresses
Samuel's request to split the vexpress-sysreg driver into
smaller portions and define the device in a form of MFD
cells:

* LEDs code has been completely removed and replaced with
  "gpio-leds" nodes in the tree (referencing dedicated
  GPIO subnodes in sysreg - bindings documentation updated);
  this also better fits the reality as some variants of the
  motherboard don't have all the LEDs populated

* syscfg bridge code has been extracted into a separate
  driver (placed in drivers/misc for no better place)

* all the ID & MISC registers are defined as sysconf
  making them available for other drivers should they need
  to use them (and also to the user via /sys/kernel/debug/regmap
  which can be helpful in platform debugging)

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 .../devicetree/bindings/arm/vexpress-sysreg.txt    |  36 +-
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi            |  76 ++-
 arch/arm/boot/dts/vexpress-v2m.dtsi                |  76 ++-
 arch/arm/mach-vexpress/ct-ca9x4.c                  |   2 +-
 arch/arm/mach-vexpress/v2m.c                       |  15 +-
 drivers/mfd/Kconfig                                |  15 +-
 drivers/mfd/Makefile                               |   2 +-
 drivers/mfd/vexpress-sysreg.c                      | 533 ++++++---------------
 drivers/misc/Kconfig                               |   9 +
 drivers/misc/Makefile                              |   1 +
 drivers/misc/vexpress-syscfg.c                     | 324 +++++++++++++
 include/linux/vexpress.h                           |  16 +-
 12 files changed, 667 insertions(+), 438 deletions(-)
 create mode 100644 drivers/misc/vexpress-syscfg.c

diff --git a/Documentation/devicetree/bindings/arm/vexpress-sysreg.txt b/Documentation/devicetree/bindings/arm/vexpress-sysreg.txt
index 57b423f..00318d0 100644
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
diff --git a/arch/arm/mach-vexpress/ct-ca9x4.c b/arch/arm/mach-vexpress/ct-ca9x4.c
index 35e394a..494d70b 100644
--- a/arch/arm/mach-vexpress/ct-ca9x4.c
+++ b/arch/arm/mach-vexpress/ct-ca9x4.c
@@ -160,7 +160,7 @@ static void __init ct_ca9x4_init(void)
 		amba_device_register(ct_ca9x4_amba_devs[i], &iomem_resource);
 
 	platform_device_register(&pmu_device);
-	vexpress_sysreg_config_device_register(&osc1_device);
+	vexpress_syscfg_device_register(&osc1_device);
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index ac95220..90f04c9 100644
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
@@ -351,10 +352,10 @@ static void __init v2m_init(void)
 	for (i = 0; i < ARRAY_SIZE(v2m_amba_devs); i++)
 		amba_device_register(v2m_amba_devs[i], &iomem_resource);
 
-	vexpress_sysreg_config_device_register(&v2m_muxfpga_device);
-	vexpress_sysreg_config_device_register(&v2m_shutdown_device);
-	vexpress_sysreg_config_device_register(&v2m_reboot_device);
-	vexpress_sysreg_config_device_register(&v2m_dvimode_device);
+	vexpress_syscfg_device_register(&v2m_muxfpga_device);
+	vexpress_syscfg_device_register(&v2m_shutdown_device);
+	vexpress_syscfg_device_register(&v2m_reboot_device);
+	vexpress_syscfg_device_register(&v2m_dvimode_device);
 
 	ct_desc->init_tile();
 }
@@ -409,8 +410,6 @@ void __init v2m_dt_init_early(void)
 {
 	u32 dt_hbi;
 
-	vexpress_sysreg_of_early_init();
-
 	/* Confirm board type against DT property, if available */
 	if (of_property_read_u32(of_allnodes, "arm,hbi", &dt_hbi) == 0) {
 		u32 hbi = vexpress_get_hbi(VEXPRESS_SITE_MASTER);
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3383412..490fd48 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1227,12 +1227,17 @@ config MCP_UCB1200_TS
 
 endmenu
 
-config VEXPRESS_CONFIG
-	bool "ARM Versatile Express platform infrastructure"
-	depends on ARM || ARM64
+config MFD_VEXPRESS_SYSREG
+	bool "Versatile Express System Registers"
+	depends on VEXPRESS_CONFIG
+	default y
+	select CLKSRC_MMIO
+	select GPIO_GENERIC_PLATFORM
+	select MFD_CORE
+	select MFD_SYSCON
 	help
-	  Platform configuration infrastructure for the ARM Ltd.
-	  Versatile Express.
+	  System Registers are the platform configuration block
+	  on the ARM Ltd. Versatile Express board.
 
 endmenu
 endif
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 9ba838e..cec3487 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -161,7 +161,7 @@ obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
 obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
 obj-$(CONFIG_MFD_SYSCON)	+= syscon.o
 obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
-obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-sysreg.o
+obj-$(CONFIG_MFD_VEXPRESS_SYSREG)	+= vexpress-sysreg.o
 obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
 obj-$(CONFIG_MFD_AS3711)	+= as3711.o
 obj-$(CONFIG_MFD_AS3722)	+= as3722.o
diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index b4138a7..952df84 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -11,25 +11,22 @@
  * Copyright (C) 2012 ARM Limited
  */
 
+#include <linux/basic_mmio_gpio.h>
 #include <linux/err.h>
-#include <linux/gpio.h>
 #include <linux/io.h>
-#include <linux/leds.h>
+#include <linux/mfd/core.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
+#include <linux/platform_data/syscon.h>
 #include <linux/platform_device.h>
-#include <linux/regulator/driver.h>
-#include <linux/sched.h>
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
@@ -51,36 +48,32 @@
 #define SYS_ID_HBI_SHIFT	16
 #define SYS_PROCIDx_HBI_SHIFT	0
 
-#define SYS_LED_LED(n)		(1 << (n))
-
 #define SYS_MCI_CARDIN		(1 << 0)
 #define SYS_MCI_WPROT		(1 << 1)
 
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
+static void __iomem *__vexpress_sysreg_base;
 
+static void __iomem *vexpress_sysreg_base(void)
+{
+	if (!__vexpress_sysreg_base) {
+		struct device_node *node = of_find_compatible_node(NULL, NULL,
+				"arm,vexpress-sysreg");
 
-static void __iomem *vexpress_sysreg_base;
-static struct device *vexpress_sysreg_dev;
-static LIST_HEAD(vexpress_sysreg_config_funcs);
-static struct device *vexpress_sysreg_config_bridge;
+		__vexpress_sysreg_base = of_iomap(node, 0);
+	}
+
+	WARN_ON(!__vexpress_sysreg_base);
+
+	return __vexpress_sysreg_base;
+}
 
 
 static int vexpress_sysreg_get_master(void)
 {
-	if (readl(vexpress_sysreg_base + SYS_MISC) & SYS_MISC_MASTERSITE)
+	if (readl(vexpress_sysreg_base() + SYS_MISC) & SYS_MISC_MASTERSITE)
 		return VEXPRESS_SITE_DB2;
 
 	return VEXPRESS_SITE_DB1;
@@ -88,8 +81,13 @@ static int vexpress_sysreg_get_master(void)
 
 void vexpress_flags_set(u32 data)
 {
-	writel(~0, vexpress_sysreg_base + SYS_FLAGSCLR);
-	writel(data, vexpress_sysreg_base + SYS_FLAGSSET);
+	writel(~0, vexpress_sysreg_base() + SYS_FLAGSCLR);
+	writel(data, vexpress_sysreg_base() + SYS_FLAGSSET);
+}
+
+unsigned int vexpress_get_mci_cardin(struct device *dev)
+{
+	return readl(vexpress_sysreg_base() + SYS_MCI) & SYS_MCI_CARDIN;
 }
 
 u32 vexpress_get_procid(int site)
@@ -97,7 +95,7 @@ u32 vexpress_get_procid(int site)
 	if (site == VEXPRESS_SITE_MASTER)
 		site = vexpress_sysreg_get_master();
 
-	return readl(vexpress_sysreg_base + (site == VEXPRESS_SITE_DB1 ?
+	return readl(vexpress_sysreg_base() + (site == VEXPRESS_SITE_DB1 ?
 			SYS_PROCID0 : SYS_PROCID1));
 }
 
@@ -107,7 +105,7 @@ u32 vexpress_get_hbi(int site)
 
 	switch (site) {
 	case VEXPRESS_SITE_MB:
-		id = readl(vexpress_sysreg_base + SYS_ID);
+		id = readl(vexpress_sysreg_base() + SYS_ID);
 		return (id >> SYS_ID_HBI_SHIFT) & SYS_HBI_MASK;
 	case VEXPRESS_SITE_MASTER:
 	case VEXPRESS_SITE_DB1:
@@ -121,406 +119,143 @@ u32 vexpress_get_hbi(int site)
 
 void __iomem *vexpress_get_24mhz_clock_base(void)
 {
-	return vexpress_sysreg_base + SYS_24MHZ;
-}
-
-
-struct vexpress_sysreg_config_func {
-	struct list_head list;
-	struct regmap *regmap;
-	int num_templates;
-	u32 template[0]; /* Keep this last */
-};
-
-static int vexpress_sysreg_config_exec(struct vexpress_sysreg_config_func *func,
-		int index, bool write, u32 *data)
-{
-	u32 command, status;
-	int tries;
-	long timeout;
-
-	if (WARN_ON(!vexpress_sysreg_base))
-		return -ENOENT;
-
-	if (WARN_ON(index > func->num_templates))
-		return -EINVAL;
-
-	command = readl(vexpress_sysreg_base + SYS_CFGCTRL);
-	if (WARN_ON(command & SYS_CFGCTRL_START))
-		return -EBUSY;
-
-	command = func->template[index];
-	command |= SYS_CFGCTRL_START;
-	command |= write ? SYS_CFGCTRL_WRITE : 0;
-
-	/* Use a canary for reads */
-	if (!write)
-		*data = 0xdeadbeef;
-
-	dev_dbg(vexpress_sysreg_dev, "command %x, data %x\n",
-			command, *data);
-	writel(*data, vexpress_sysreg_base + SYS_CFGDATA);
-	writel(0, vexpress_sysreg_base + SYS_CFGSTAT);
-	writel(command, vexpress_sysreg_base + SYS_CFGCTRL);
-	mb();
-
-	/* The operation can take ages... Go to sleep, 100us initially */
-	tries = 100;
-	timeout = 100;
-	do {
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(usecs_to_jiffies(timeout));
-		if (signal_pending(current))
-			return -EINTR;
-
-		status = readl(vexpress_sysreg_base + SYS_CFGSTAT);
-		if (status & SYS_CFGSTAT_ERR)
-			return -EFAULT;
-
-		if (timeout > 20)
-			timeout -= 20;
-	} while (--tries && !(status & SYS_CFGSTAT_COMPLETE));
-	if (WARN_ON_ONCE(!tries))
-		return -ETIMEDOUT;
-
-	if (!write) {
-		*data = readl(vexpress_sysreg_base + SYS_CFGDATA);
-		dev_dbg(vexpress_sysreg_dev, "func %p, read data %x\n",
-				func, *data);
-	}
-
-	return 0;
-}
-
-static int vexpress_sysreg_config_read(void *context, unsigned int index,
-		unsigned int *val)
-{
-	struct vexpress_sysreg_config_func *func = context;
-
-	return vexpress_sysreg_config_exec(func, index, false, val);
-}
-
-static int vexpress_sysreg_config_write(void *context, unsigned int index,
-		unsigned int val)
-{
-	struct vexpress_sysreg_config_func *func = context;
-
-	return vexpress_sysreg_config_exec(func, index, true, &val);
-}
-
-struct regmap_config vexpress_sysreg_regmap_config = {
-	.lock = vexpress_config_lock,
-	.unlock = vexpress_config_unlock,
-	.reg_bits = 32,
-	.val_bits = 32,
-	.reg_read = vexpress_sysreg_config_read,
-	.reg_write = vexpress_sysreg_config_write,
-	.reg_format_endian = REGMAP_ENDIAN_LITTLE,
-	.val_format_endian = REGMAP_ENDIAN_LITTLE,
-};
-
-static struct regmap *vexpress_sysreg_config_regmap_init(struct device *dev,
-		void *context)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct vexpress_sysreg_config_func *func;
-	struct property *prop;
-	const __be32 *val = NULL;
-	__be32 energy_quirk[4];
-	int num;
-	u32 site, position, dcc;
-	int err;
-	int i;
-
-	if (dev->of_node) {
-		err = vexpress_config_get_topo(dev->of_node, &site, &position,
-				&dcc);
-		if (err)
-			return ERR_PTR(err);
-
-		prop = of_find_property(dev->of_node,
-				"arm,vexpress-sysreg,func", NULL);
-		if (!prop)
-			return ERR_PTR(-EINVAL);
-
-		num = prop->length / sizeof(u32) / 2;
-		val = prop->value;
-	} else {
-		if (pdev->num_resources != 1 ||
-				pdev->resource[0].flags != IORESOURCE_BUS)
-			return ERR_PTR(-EFAULT);
-
-		site = pdev->resource[0].start;
-		if (site == VEXPRESS_SITE_MASTER)
-			site = vexpress_sysreg_get_master();
-		position = 0;
-		dcc = 0;
-		num = 1;
-	}
-
-	/*
-	 * "arm,vexpress-energy" function used to be described
-	 * by its first device only, now it requires both
-	 */
-	if (num == 1 && of_device_is_compatible(dev->of_node,
-			"arm,vexpress-energy")) {
-		num = 2;
-		energy_quirk[0] = *val;
-		energy_quirk[2] = *val++;
-		energy_quirk[1] = *val;
-		energy_quirk[3] = cpu_to_be32(be32_to_cpup(val) + 1);
-		val = energy_quirk;
-	}
-
-	func = kzalloc(sizeof(*func) + sizeof(*func->template) * num,
-			GFP_KERNEL);
-	if (!func)
-		return NULL;
-
-	func->num_templates = num;
-
-	for (i = 0; i < num; i++) {
-		u32 function, device;
-
-		if (dev->of_node) {
-			function = be32_to_cpup(val++);
-			device = be32_to_cpup(val++);
-		} else {
-			function = pdev->resource[0].end;
-			device = pdev->id;
-		}
-
-		dev_dbg(dev, "func %p: %u/%u/%u/%u/%u\n",
-				func, site, position, dcc,
-				function, device);
-
-		func->template[i] = SYS_CFGCTRL_DCC(dcc);
-		func->template[i] |= SYS_CFGCTRL_SITE(site);
-		func->template[i] |= SYS_CFGCTRL_POSITION(position);
-		func->template[i] |= SYS_CFGCTRL_FUNC(function);
-		func->template[i] |= SYS_CFGCTRL_DEVICE(device);
-	}
-
-	vexpress_sysreg_regmap_config.max_register = num - 1;
-
-	func->regmap = regmap_init(dev, NULL, func,
-			&vexpress_sysreg_regmap_config);
-
-	if (IS_ERR(func->regmap))
-		kfree(func);
-	else
-		list_add(&func->list, &vexpress_sysreg_config_funcs);
-
-	return func->regmap;
-}
-
-static void vexpress_sysreg_config_regmap_exit(struct regmap *regmap,
-		void *context)
-{
-	struct vexpress_sysreg_config_func *func, *tmp;
-
-	regmap_exit(regmap);
-
-	list_for_each_entry_safe(func, tmp, &vexpress_sysreg_config_funcs,
-			list) {
-		if (func->regmap == regmap) {
-			list_del(&vexpress_sysreg_config_funcs);
-			kfree(func);
-			break;
-		}
-	}
-}
-
-static struct vexpress_config_bridge_ops vexpress_sysreg_config_bridge_ops = {
-	.regmap_init = vexpress_sysreg_config_regmap_init,
-	.regmap_exit = vexpress_sysreg_config_regmap_exit,
-};
-
-int vexpress_sysreg_config_device_register(struct platform_device *pdev)
-{
-	pdev->dev.parent = vexpress_sysreg_config_bridge;
-
-	return platform_device_register(pdev);
+	return vexpress_sysreg_base() + SYS_24MHZ;
 }
 
 
 void __init vexpress_sysreg_early_init(void __iomem *base)
 {
-	vexpress_sysreg_base = base;
-	vexpress_config_set_master(vexpress_sysreg_get_master());
-}
-
-void __init vexpress_sysreg_of_early_init(void)
-{
-	struct device_node *node;
-
-	if (vexpress_sysreg_base)
-		return;
-
-	node = of_find_compatible_node(NULL, NULL, "arm,vexpress-sysreg");
-	if (WARN_ON(!node))
-		return;
-
-	vexpress_sysreg_base = of_iomap(node, 0);
-	if (WARN_ON(!vexpress_sysreg_base))
-		return;
+	__vexpress_sysreg_base = base;
 
 	vexpress_config_set_master(vexpress_sysreg_get_master());
 }
 
 
-#ifdef CONFIG_GPIOLIB
-
-#define VEXPRESS_SYSREG_GPIO(_name, _reg, _value) \
-	[VEXPRESS_GPIO_##_name] = { \
-		.reg = _reg, \
-		.value = _reg##_##_value, \
-	}
+/* The sysreg block is just a random collection of various functions... */
 
-static struct vexpress_sysreg_gpio {
-	unsigned long reg;
-	u32 value;
-} vexpress_sysreg_gpios[] = {
-	VEXPRESS_SYSREG_GPIO(MMC_CARDIN,	SYS_MCI,	CARDIN),
-	VEXPRESS_SYSREG_GPIO(MMC_WPROT,		SYS_MCI,	WPROT),
-	VEXPRESS_SYSREG_GPIO(FLASH_WPn,		SYS_FLASH,	WPn),
-	VEXPRESS_SYSREG_GPIO(LED0,		SYS_LED,	LED(0)),
-	VEXPRESS_SYSREG_GPIO(LED1,		SYS_LED,	LED(1)),
-	VEXPRESS_SYSREG_GPIO(LED2,		SYS_LED,	LED(2)),
-	VEXPRESS_SYSREG_GPIO(LED3,		SYS_LED,	LED(3)),
-	VEXPRESS_SYSREG_GPIO(LED4,		SYS_LED,	LED(4)),
-	VEXPRESS_SYSREG_GPIO(LED5,		SYS_LED,	LED(5)),
-	VEXPRESS_SYSREG_GPIO(LED6,		SYS_LED,	LED(6)),
-	VEXPRESS_SYSREG_GPIO(LED7,		SYS_LED,	LED(7)),
+static struct syscon_platform_data vexpress_sysreg_sys_id_pdata = {
+	.label = "sys_id",
 };
 
-static int vexpress_sysreg_gpio_direction_input(struct gpio_chip *chip,
-				       unsigned offset)
-{
-	return 0;
-}
-
-static int vexpress_sysreg_gpio_get(struct gpio_chip *chip,
-				       unsigned offset)
-{
-	struct vexpress_sysreg_gpio *gpio = &vexpress_sysreg_gpios[offset];
-	u32 reg_value = readl(vexpress_sysreg_base + gpio->reg);
-
-	return !!(reg_value & gpio->value);
-}
-
-static void vexpress_sysreg_gpio_set(struct gpio_chip *chip,
-				       unsigned offset, int value)
-{
-	struct vexpress_sysreg_gpio *gpio = &vexpress_sysreg_gpios[offset];
-	u32 reg_value = readl(vexpress_sysreg_base + gpio->reg);
-
-	if (value)
-		reg_value |= gpio->value;
-	else
-		reg_value &= ~gpio->value;
-
-	writel(reg_value, vexpress_sysreg_base + gpio->reg);
-}
-
-static int vexpress_sysreg_gpio_direction_output(struct gpio_chip *chip,
-						unsigned offset, int value)
-{
-	vexpress_sysreg_gpio_set(chip, offset, value);
-
-	return 0;
-}
-
-static struct gpio_chip vexpress_sysreg_gpio_chip = {
-	.label = "vexpress-sysreg",
-	.direction_input = vexpress_sysreg_gpio_direction_input,
-	.direction_output = vexpress_sysreg_gpio_direction_output,
-	.get = vexpress_sysreg_gpio_get,
-	.set = vexpress_sysreg_gpio_set,
-	.ngpio = ARRAY_SIZE(vexpress_sysreg_gpios),
-	.base = 0,
+static struct bgpio_pdata vexpress_sysreg_sys_led_pdata = {
+	.label = "sys_led",
+	.base = -1,
+	.ngpio = 8,
 };
 
-
-#define VEXPRESS_SYSREG_GREEN_LED(_name, _default_trigger, _gpio) \
-	{ \
-		.name = "v2m:green:"_name, \
-		.default_trigger = _default_trigger, \
-		.gpio = VEXPRESS_GPIO_##_gpio, \
-	}
-
-struct gpio_led vexpress_sysreg_leds[] = {
-	VEXPRESS_SYSREG_GREEN_LED("user1",	"heartbeat",	LED0),
-	VEXPRESS_SYSREG_GREEN_LED("user2",	"mmc0",		LED1),
-	VEXPRESS_SYSREG_GREEN_LED("user3",	"cpu0",		LED2),
-	VEXPRESS_SYSREG_GREEN_LED("user4",	"cpu1",		LED3),
-	VEXPRESS_SYSREG_GREEN_LED("user5",	"cpu2",		LED4),
-	VEXPRESS_SYSREG_GREEN_LED("user6",	"cpu3",		LED5),
-	VEXPRESS_SYSREG_GREEN_LED("user7",	"cpu4",		LED6),
-	VEXPRESS_SYSREG_GREEN_LED("user8",	"cpu5",		LED7),
+static struct bgpio_pdata vexpress_sysreg_sys_mci_pdata = {
+	.label = "sys_mci",
+	.base = -1,
+	.ngpio = 2,
 };
 
-struct gpio_led_platform_data vexpress_sysreg_leds_pdata = {
-	.num_leds = ARRAY_SIZE(vexpress_sysreg_leds),
-	.leds = vexpress_sysreg_leds,
+static struct bgpio_pdata vexpress_sysreg_sys_flash_pdata = {
+	.label = "sys_flash",
+	.base = -1,
+	.ngpio = 1,
 };
 
-#endif
-
+static struct syscon_platform_data vexpress_sysreg_sys_misc_pdata = {
+	.label = "sys_misc",
+};
 
-static ssize_t vexpress_sysreg_sys_id_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "0x%08x\n", readl(vexpress_sysreg_base + SYS_ID));
-}
+static struct syscon_platform_data vexpress_sysreg_sys_procid_pdata = {
+	.label = "sys_procid",
+};
 
-DEVICE_ATTR(sys_id, S_IRUGO, vexpress_sysreg_sys_id_show, NULL);
+static struct mfd_cell vexpress_sysreg_cells[] = {
+	{
+		.name = "syscon",
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
 
 static int vexpress_sysreg_probe(struct platform_device *pdev)
 {
-	int err;
-	struct resource *res = platform_get_resource(pdev,
-			IORESOURCE_MEM, 0);
-
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-			resource_size(res), pdev->name)) {
-		dev_err(&pdev->dev, "Failed to request memory region!\n");
-		return -EBUSY;
-	}
+	struct resource *mem;
+	void __iomem *base;
+	struct bgpio_chip *mmc_gpio_chip;
 
-	if (!vexpress_sysreg_base)
-		vexpress_sysreg_base = devm_ioremap(&pdev->dev, res->start,
-				resource_size(res));
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -EINVAL;
 
-	if (!vexpress_sysreg_base) {
-		dev_err(&pdev->dev, "Failed to obtain base address!\n");
-		return -EFAULT;
-	}
+	base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
+	if (!base)
+		return -ENOMEM;
 
 	vexpress_config_set_master(vexpress_sysreg_get_master());
-	vexpress_sysreg_dev = &pdev->dev;
-
-#ifdef CONFIG_GPIOLIB
-	vexpress_sysreg_gpio_chip.dev = &pdev->dev;
-	err = gpiochip_add(&vexpress_sysreg_gpio_chip);
-	if (err) {
-		dev_err(&pdev->dev, "Failed to register GPIO chip! (%d)\n",
-				err);
-		return err;
-	}
 
-	platform_device_register_data(vexpress_sysreg_dev, "leds-gpio",
-			PLATFORM_DEVID_AUTO, &vexpress_sysreg_leds_pdata,
-			sizeof(vexpress_sysreg_leds_pdata));
-#endif
-
-	vexpress_sysreg_config_bridge = vexpress_config_bridge_register(
-			&pdev->dev, &vexpress_sysreg_config_bridge_ops, NULL);
-	WARN_ON(!vexpress_sysreg_config_bridge);
-
-	device_create_file(vexpress_sysreg_dev, &dev_attr_sys_id);
-
-	return 0;
+	/*
+	 * Duplicated SYS_MCI pseudo-GPIO controller for compatibility with
+	 * older trees using sysreg node for MMC control lines.
+	 */
+	mmc_gpio_chip = devm_kzalloc(&pdev->dev, sizeof(*mmc_gpio_chip),
+			GFP_KERNEL);
+	if (!mmc_gpio_chip)
+		return -ENOMEM;
+	bgpio_init(mmc_gpio_chip, &pdev->dev, 0x4, base + SYS_MCI,
+			NULL, NULL, NULL, NULL, 0);
+	mmc_gpio_chip->gc.ngpio = 2;
+	gpiochip_add(&mmc_gpio_chip->gc);
+
+	return mfd_add_devices(&pdev->dev, PLATFORM_DEVID_AUTO,
+			vexpress_sysreg_cells,
+			ARRAY_SIZE(vexpress_sysreg_cells), mem, 0, NULL);
 }
 
 static const struct of_device_id vexpress_sysreg_match[] = {
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 8baff0e..d9663ef 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -515,6 +515,15 @@ config SRAM
 	  the genalloc API. It is supposed to be used for small on-chip SRAM
 	  areas found on many SoCs.
 
+config VEXPRESS_SYSCFG
+	bool "Versatile Express System Configuration driver"
+	depends on VEXPRESS_CONFIG
+	default y
+	help
+	  ARM Ltd. Versatile Express uses specialised platform configuration
+	  bus. System Configuration interface is one of the possible means
+	  of generating transactions on this bus.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 7eb4b69..d59ce12 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -55,3 +55,4 @@ obj-$(CONFIG_SRAM)		+= sram.o
 obj-y				+= mic/
 obj-$(CONFIG_GENWQE)		+= genwqe/
 obj-$(CONFIG_ECHO)		+= echo/
+obj-$(CONFIG_VEXPRESS_SYSCFG)	+= vexpress-syscfg.o
diff --git a/drivers/misc/vexpress-syscfg.c b/drivers/misc/vexpress-syscfg.c
new file mode 100644
index 0000000..73068e5
--- /dev/null
+++ b/drivers/misc/vexpress-syscfg.c
@@ -0,0 +1,324 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Copyright (C) 2014 ARM Limited
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/syscore_ops.h>
+#include <linux/vexpress.h>
+
+
+#define SYS_CFGDATA		0x0
+
+#define SYS_CFGCTRL		0x4
+#define SYS_CFGCTRL_START	(1 << 31)
+#define SYS_CFGCTRL_WRITE	(1 << 30)
+#define SYS_CFGCTRL_DCC(n)	(((n) & 0xf) << 26)
+#define SYS_CFGCTRL_FUNC(n)	(((n) & 0x3f) << 20)
+#define SYS_CFGCTRL_SITE(n)	(((n) & 0x3) << 16)
+#define SYS_CFGCTRL_POSITION(n)	(((n) & 0xf) << 12)
+#define SYS_CFGCTRL_DEVICE(n)	(((n) & 0xfff) << 0)
+
+#define SYS_CFGSTAT		0x8
+#define SYS_CFGSTAT_ERR		(1 << 1)
+#define SYS_CFGSTAT_COMPLETE	(1 << 0)
+
+
+struct vexpress_syscfg {
+	struct device *dev;
+	void __iomem *base;
+	struct list_head funcs;
+};
+
+struct vexpress_syscfg_func {
+	struct list_head list;
+	struct vexpress_syscfg *syscfg;
+	struct regmap *regmap;
+	int num_templates;
+	u32 template[0]; /* Keep it last! */
+};
+
+
+static int vexpress_syscfg_exec(struct vexpress_syscfg_func *func,
+		int index, bool write, u32 *data)
+{
+	struct vexpress_syscfg *syscfg = func->syscfg;
+	u32 command, status;
+	int tries;
+	long timeout;
+
+	if (WARN_ON(index > func->num_templates))
+		return -EINVAL;
+
+	command = readl(syscfg->base + SYS_CFGCTRL);
+	if (WARN_ON(command & SYS_CFGCTRL_START))
+		return -EBUSY;
+
+	command = func->template[index];
+	command |= SYS_CFGCTRL_START;
+	command |= write ? SYS_CFGCTRL_WRITE : 0;
+
+	/* Use a canary for reads */
+	if (!write)
+		*data = 0xdeadbeef;
+
+	dev_dbg(syscfg->dev, "func %p, command %x, data %x\n",
+			func, command, *data);
+	writel(*data, syscfg->base + SYS_CFGDATA);
+	writel(0, syscfg->base + SYS_CFGSTAT);
+	writel(command, syscfg->base + SYS_CFGCTRL);
+	mb();
+
+	/* The operation can take ages... Go to sleep, 100us initially */
+	tries = 100;
+	timeout = 100;
+	do {
+		if (!irqs_disabled()) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(usecs_to_jiffies(timeout));
+			if (signal_pending(current))
+				return -EINTR;
+		} else {
+			udelay(timeout);
+		}
+
+		status = readl(syscfg->base + SYS_CFGSTAT);
+		if (status & SYS_CFGSTAT_ERR)
+			return -EFAULT;
+
+		if (timeout > 20)
+			timeout -= 20;
+	} while (--tries && !(status & SYS_CFGSTAT_COMPLETE));
+	if (WARN_ON_ONCE(!tries))
+		return -ETIMEDOUT;
+
+	if (!write) {
+		*data = readl(syscfg->base + SYS_CFGDATA);
+		dev_dbg(syscfg->dev, "func %p, read data %x\n", func, *data);
+	}
+
+	return 0;
+}
+
+static int vexpress_syscfg_read(void *context, unsigned int index,
+		unsigned int *val)
+{
+	struct vexpress_syscfg_func *func = context;
+
+	return vexpress_syscfg_exec(func, index, false, val);
+}
+
+static int vexpress_syscfg_write(void *context, unsigned int index,
+		unsigned int val)
+{
+	struct vexpress_syscfg_func *func = context;
+
+	return vexpress_syscfg_exec(func, index, true, &val);
+}
+
+struct regmap_config vexpress_syscfg_regmap_config = {
+	.lock = vexpress_config_lock,
+	.unlock = vexpress_config_unlock,
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_read = vexpress_syscfg_read,
+	.reg_write = vexpress_syscfg_write,
+	.reg_format_endian = REGMAP_ENDIAN_LITTLE,
+	.val_format_endian = REGMAP_ENDIAN_LITTLE,
+};
+
+
+static struct regmap *vexpress_syscfg_regmap_init(struct device *dev,
+		void *context)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct vexpress_syscfg *syscfg = context;
+	struct vexpress_syscfg_func *func;
+	struct property *prop;
+	const __be32 *val = NULL;
+	__be32 energy_quirk[4];
+	int num;
+	u32 site, position, dcc;
+	int i;
+
+	if (dev->of_node) {
+		int err = vexpress_config_get_topo(dev->of_node, &site,
+				&position, &dcc);
+
+		if (err)
+			return ERR_PTR(err);
+
+		prop = of_find_property(dev->of_node,
+				"arm,vexpress-sysreg,func", NULL);
+		if (!prop)
+			return ERR_PTR(-EINVAL);
+
+		num = prop->length / sizeof(u32) / 2;
+		val = prop->value;
+	} else {
+		if (pdev->num_resources != 1 ||
+				pdev->resource[0].flags != IORESOURCE_BUS)
+			return ERR_PTR(-EFAULT);
+
+		site = pdev->resource[0].start;
+		if (site == VEXPRESS_SITE_MASTER)
+			site = vexpress_config_get_master();
+		position = 0;
+		dcc = 0;
+		num = 1;
+	}
+
+	/*
+	 * "arm,vexpress-energy" function used to be described
+	 * by its first device only, now it requires both
+	 */
+	if (num == 1 && of_device_is_compatible(dev->of_node,
+			"arm,vexpress-energy")) {
+		num = 2;
+		energy_quirk[0] = *val;
+		energy_quirk[2] = *val++;
+		energy_quirk[1] = *val;
+		energy_quirk[3] = cpu_to_be32(be32_to_cpup(val) + 1);
+		val = energy_quirk;
+	}
+
+	func = kzalloc(sizeof(*func) + sizeof(*func->template) * num,
+			GFP_KERNEL);
+	if (!func)
+		return NULL;
+
+	func->syscfg = syscfg;
+	func->num_templates = num;
+
+	for (i = 0; i < num; i++) {
+		u32 function, device;
+
+		if (dev->of_node) {
+			function = be32_to_cpup(val++);
+			device = be32_to_cpup(val++);
+		} else {
+			function = pdev->resource[0].end;
+			device = pdev->id;
+		}
+
+		dev_dbg(dev, "func %p: %u/%u/%u/%u/%u\n",
+				func, site, position, dcc,
+				function, device);
+
+		func->template[i] = SYS_CFGCTRL_DCC(dcc);
+		func->template[i] |= SYS_CFGCTRL_SITE(site);
+		func->template[i] |= SYS_CFGCTRL_POSITION(position);
+		func->template[i] |= SYS_CFGCTRL_FUNC(function);
+		func->template[i] |= SYS_CFGCTRL_DEVICE(device);
+	}
+
+	vexpress_syscfg_regmap_config.max_register = num - 1;
+
+	func->regmap = regmap_init(dev, NULL, func,
+			&vexpress_syscfg_regmap_config);
+
+	if (IS_ERR(func->regmap))
+		kfree(func);
+	else
+		list_add(&func->list, &syscfg->funcs);
+
+	return func->regmap;
+}
+
+static void vexpress_syscfg_regmap_exit(struct regmap *regmap, void *context)
+{
+	struct vexpress_syscfg *syscfg = context;
+	struct vexpress_syscfg_func *func, *tmp;
+
+	regmap_exit(regmap);
+
+	list_for_each_entry_safe(func, tmp, &syscfg->funcs, list) {
+		if (func->regmap == regmap) {
+			list_del(&syscfg->funcs);
+			kfree(func);
+			break;
+		}
+	}
+}
+
+static struct vexpress_config_bridge_ops vexpress_syscfg_bridge_ops = {
+	.regmap_init = vexpress_syscfg_regmap_init,
+	.regmap_exit = vexpress_syscfg_regmap_exit,
+};
+
+
+/* Non-DT hack, to be gone... */
+static struct device *vexpress_syscfg_bridge;
+
+int vexpress_syscfg_device_register(struct platform_device *pdev)
+{
+	pdev->dev.parent = vexpress_syscfg_bridge;
+
+	return platform_device_register(pdev);
+}
+
+
+int vexpress_syscfg_probe(struct platform_device *pdev)
+{
+	struct vexpress_syscfg *syscfg;
+	struct resource *res;
+	struct device *bridge;
+
+	syscfg = devm_kzalloc(&pdev->dev, sizeof(*syscfg), GFP_KERNEL);
+	if (!syscfg)
+		return -ENOMEM;
+	syscfg->dev = &pdev->dev;
+	INIT_LIST_HEAD(&syscfg->funcs);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!devm_request_mem_region(&pdev->dev, res->start,
+			resource_size(res), pdev->name))
+		return -EBUSY;
+
+	syscfg->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!syscfg->base)
+		return -EFAULT;
+
+	/* Must use dev.parent (MFD), as that's where DT phandle points at... */
+	bridge = vexpress_config_bridge_register(pdev->dev.parent,
+			&vexpress_syscfg_bridge_ops, syscfg);
+	if (IS_ERR(bridge))
+		return PTR_ERR(bridge);
+
+	/* Non-DT case */
+	if (!pdev->dev.of_node)
+		vexpress_syscfg_bridge = bridge;
+
+	return 0;
+}
+
+static const struct platform_device_id vexpress_syscfg_id_table[] = {
+	{ "vexpress-syscfg", },
+	{},
+};
+
+static struct platform_driver vexpress_syscfg_driver = {
+	.driver.name = "vexpress-syscfg",
+	.id_table = vexpress_syscfg_id_table,
+	.probe = vexpress_syscfg_probe,
+};
+
+static int __init vexpress_syscfg_init(void)
+{
+	return platform_driver_register(&vexpress_syscfg_driver);
+}
+core_initcall(vexpress_syscfg_init);
diff --git a/include/linux/vexpress.h b/include/linux/vexpress.h
index 6b206ba..46636e3 100644
--- a/include/linux/vexpress.h
+++ b/include/linux/vexpress.h
@@ -24,18 +24,6 @@
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
 #define VEXPRESS_RES_FUNC(_site, _func)	\
 {					\
 	.start = (_site),		\
@@ -70,14 +58,14 @@ struct regmap *devm_regmap_init_vexpress_config(struct device *dev);
 
 /* Platform control */
 
+unsigned int vexpress_get_mci_cardin(struct device *dev);
 u32 vexpress_get_procid(int site);
 u32 vexpress_get_hbi(int site);
 void *vexpress_get_24mhz_clock_base(void);
 void vexpress_flags_set(u32 data);
 
 void vexpress_sysreg_early_init(void __iomem *base);
-void vexpress_sysreg_of_early_init(void);
-int vexpress_sysreg_config_device_register(struct platform_device *pdev);
+int vexpress_syscfg_device_register(struct platform_device *pdev);
 
 /* Clocks */
 
-- 
1.9.1

