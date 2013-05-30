Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967387Ab3E3DE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:04:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:36341 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967358Ab3E3DED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:04:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,768,1363158000"; 
   d="scan'208";a="342312659"
From: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
To: x86@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, mark.gross@intel.com,
        len.brown@intel.com, david.a.cohen@intel.com, fei.yang@intel.com,
        sathyanarayanan.kuppuswamy@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 13/13] x86: mrst: move to generic SFI GPIO API
Date: Wed, 29 May 2013 19:45:23 -0700
Message-Id: <1369881923-27067-14-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
References: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's use the common SFI helpers for GPIO API.

Change-Id: I7aba6e61af7df3e34ffc4dfe161ab6ea2d723691
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
---
 arch/x86/include/asm/intel-mid.h                   |    2 +-
 .../intel-mid/device_libs/platform_emc1403.c       |    4 +-
 .../intel-mid/device_libs/platform_gpio_keys.c     |    2 +-
 .../intel-mid/device_libs/platform_lis331.c        |    4 +-
 .../intel-mid/device_libs/platform_max3111.c       |    2 +-
 .../intel-mid/device_libs/platform_max7315.c       |    4 +-
 .../intel-mid/device_libs/platform_mpu3050.c       |    2 +-
 .../intel-mid/device_libs/platform_msic_gpio.c     |    2 +-
 .../intel-mid/device_libs/platform_msic_ocd.c      |    2 +-
 .../intel-mid/device_libs/platform_pmic_gpio.c     |    2 +-
 .../intel-mid/device_libs/platform_tc35876x.c      |    6 +--
 .../intel-mid/device_libs/platform_tca6416.c       |    4 +-
 arch/x86/platform/intel-mid/intel_mid_sfi.c        |   51 --------------------
 13 files changed, 18 insertions(+), 69 deletions(-)

diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
index 358e0d2..e66555d 100644
--- a/arch/x86/include/asm/intel-mid.h
+++ b/arch/x86/include/asm/intel-mid.h
@@ -12,10 +12,10 @@
 #define _ASM_X86_INTEL_MID_H
 
 #include <linux/sfi.h>
+#include <linux/sfi_gpio.h>
 #include <linux/platform_device.h>
 
 extern int intel_mid_pci_init(void);
-extern int get_gpio_by_name(const char *name);
 extern void intel_scu_device_register(struct platform_device *pdev);
 extern int __init sfi_parse_mrtc(struct sfi_table_header *table);
 extern int __init sfi_parse_mtmr(struct sfi_table_header *table);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
index 301e414..14812625 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
@@ -20,8 +20,8 @@ void __init *emc1403_platform_data(void *info)
 {
 	static short intr2nd_pdata;
 	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("thermal_int");
-	int intr2nd = get_gpio_by_name("thermal_alert");
+	int intr = sfi_get_gpio_by_name("thermal_int");
+	int intr2nd = sfi_get_gpio_by_name("thermal_alert");
 
 	if (intr == -1 || intr2nd == -1)
 		return NULL;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
index 4cae400..859829c 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
@@ -62,7 +62,7 @@ static int __init pb_keys_init(void)
 
 	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
 	for (i = 0; i < num; i++) {
-		gb[i].gpio = get_gpio_by_name(gb[i].desc);
+		gb[i].gpio = sfi_get_gpio_by_name(gb[i].desc);
 		pr_debug("info[%2d]: name = %s, gpio = %d\n", i, gb[i].desc,
 					gb[i].gpio);
 		if (gb[i].gpio == -1)
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_lis331.c b/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
index db96e30..770fdd4 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
@@ -19,8 +19,8 @@ void __init *lis331dl_platform_data(void *info)
 {
 	static short intr2nd_pdata;
 	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("accel_int");
-	int intr2nd = get_gpio_by_name("accel_2");
+	int intr = sfi_get_gpio_by_name("accel_int");
+	int intr2nd = sfi_get_gpio_by_name("accel_2");
 
 	if (intr == -1 || intr2nd == -1)
 		return NULL;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_max3111.c b/arch/x86/platform/intel-mid/device_libs/platform_max3111.c
index 1fdc259..7466ba7 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_max3111.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_max3111.c
@@ -18,7 +18,7 @@
 void __init *max3111_platform_data(void *info)
 {
 	struct spi_board_info *spi_info = info;
-	int intr = get_gpio_by_name("max3111_int");
+	int intr = sfi_get_gpio_by_name("max3111_int");
 
 	spi_info->mode = SPI_MODE_0;
 	if (intr == -1)
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
index 1c10cb4..30055e6 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
@@ -45,8 +45,8 @@ void __init *max7315_platform_data(void *info)
 		strcpy(intr_pin_name, "max7315_int");
 	}
 
-	gpio_base = get_gpio_by_name(base_pin_name);
-	intr = get_gpio_by_name(intr_pin_name);
+	gpio_base = sfi_get_gpio_by_name(base_pin_name);
+	intr = sfi_get_gpio_by_name(intr_pin_name);
 
 	if (gpio_base == -1)
 		return NULL;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
index 1f91ad3..c29fddc 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
@@ -18,7 +18,7 @@
 void *mpu3050_platform_data(void *info)
 {
 	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("mpu3050_int");
+	int intr = sfi_get_gpio_by_name("mpu3050_int");
 
 	if (intr == -1)
 		return NULL;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
index ada9bd1..d892f2e 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
@@ -25,7 +25,7 @@ void __init *msic_gpio_platform_data(void *info)
 {
 	static struct intel_msic_gpio_pdata msic_gpio_pdata;
 
-	int gpio = get_gpio_by_name("msic_gpio_base");
+	int gpio = sfi_get_gpio_by_name("msic_gpio_base");
 
 	if (gpio < 0)
 		return NULL;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
index 18446ca..974a39b 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
@@ -26,7 +26,7 @@ void __init *msic_ocd_platform_data(void *info)
 	static struct intel_msic_ocd_pdata msic_ocd_pdata;
 	int gpio;
 
-	gpio = get_gpio_by_name("ocd_gpio");
+	gpio = sfi_get_gpio_by_name("ocd_gpio");
 
 	if (gpio < 0)
 		return NULL;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
index f5d3ec8..ed5711a 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
@@ -23,7 +23,7 @@
 void __init *pmic_gpio_platform_data(void *info)
 {
 	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
-	int gpio_base = get_gpio_by_name("pmic_gpio_base");
+	int gpio_base = sfi_get_gpio_by_name("pmic_gpio_base");
 
 	if (gpio_base == -1)
 		gpio_base = 64;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c b/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
index dd9ef63..4a6f228 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
@@ -21,9 +21,9 @@ void *tc35876x_platform_data(void *data)
 	static struct tc35876x_platform_data pdata;
 
 	/* gpio pins set to -1 will not be used by the driver */
-	pdata.gpio_bridge_reset = get_gpio_by_name("LCMB_RXEN");
-	pdata.gpio_panel_bl_en = get_gpio_by_name("6S6P_BL_EN");
-	pdata.gpio_panel_vadd = get_gpio_by_name("EN_VREG_LCD_V3P3");
+	pdata.gpio_bridge_reset = sfi_get_gpio_by_name("LCMB_RXEN");
+	pdata.gpio_panel_bl_en = sfi_get_gpio_by_name("6S6P_BL_EN");
+	pdata.gpio_panel_vadd = sfi_get_gpio_by_name("EN_VREG_LCD_V3P3");
 
 	return &pdata;
 }
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
index 79fccdd..1ca2eec 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
@@ -28,8 +28,8 @@ void *tca6416_platform_data(void *info)
 	strcpy(base_pin_name, TCA6416_BASE);
 	strcpy(intr_pin_name, TCA6416_INTR);
 
-	gpio_base = get_gpio_by_name(base_pin_name);
-	intr = get_gpio_by_name(intr_pin_name);
+	gpio_base = sfi_get_gpio_by_name(base_pin_name);
+	intr = sfi_get_gpio_by_name(intr_pin_name);
 
 	if (gpio_base == -1)
 		return NULL;
diff --git a/arch/x86/platform/intel-mid/intel_mid_sfi.c b/arch/x86/platform/intel-mid/intel_mid_sfi.c
index c4a10de..a5fc58c 100644
--- a/arch/x86/platform/intel-mid/intel_mid_sfi.c
+++ b/arch/x86/platform/intel-mid/intel_mid_sfi.c
@@ -19,7 +19,6 @@
 #include <linux/spi/spi.h>
 #include <linux/i2c.h>
 #include <linux/skbuff.h>
-#include <linux/gpio.h>
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/platform_device.h>
@@ -52,13 +51,11 @@
 static struct platform_device *ipc_devs[MAX_IPCDEVS];
 static struct spi_board_info *spi_devs[MAX_SCU_SPI];
 static struct i2c_board_info *i2c_devs[MAX_SCU_I2C];
-static struct sfi_gpio_table_entry *gpio_table;
 static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
 static int ipc_next_dev;
 static int spi_next_dev;
 static int i2c_next_dev;
 static int i2c_bus[MAX_SCU_I2C];
-static int gpio_num_entry;
 static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
 int sfi_mrtc_num;
 int sfi_mtimer_num;
@@ -178,53 +175,6 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 	return 0;
 }
 
-
-/*
- * Parsing GPIO table first, since the DEVS table will need this table
- * to map the pin name to the actual pin.
- */
-static int __init sfi_parse_gpio(struct sfi_table_header *table)
-{
-	struct sfi_table_simple *sb;
-	struct sfi_gpio_table_entry *pentry;
-	int num, i;
-
-	if (gpio_table)
-		return 0;
-	sb = (struct sfi_table_simple *)table;
-	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
-	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
-
-	gpio_table = kmalloc(num * sizeof(*pentry), GFP_KERNEL);
-	if (!gpio_table)
-		return -1;
-	memcpy(gpio_table, pentry, num * sizeof(*pentry));
-	gpio_num_entry = num;
-
-	pr_debug("GPIO pin info:\n");
-	for (i = 0; i < num; i++, pentry++)
-		pr_debug("info[%2d]: controller = %16.16s, pin_name = %16.16s,"
-		" pin = %d\n", i,
-			pentry->controller_name,
-			pentry->pin_name,
-			pentry->pin_no);
-	return 0;
-}
-
-int get_gpio_by_name(const char *name)
-{
-	struct sfi_gpio_table_entry *pentry = gpio_table;
-	int i;
-
-	if (!pentry)
-		return -1;
-	for (i = 0; i < gpio_num_entry; i++, pentry++) {
-		if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
-			return pentry->pin_no;
-	}
-	return -1;
-}
-
 void __init intel_scu_device_register(struct platform_device *pdev)
 {
 	if (ipc_next_dev == MAX_IPCDEVS)
@@ -478,7 +428,6 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 
 static int __init intel_mid_platform_init(void)
 {
-	sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, sfi_parse_gpio);
 	sfi_table_parse(SFI_SIG_DEVS, NULL, NULL, sfi_parse_devs);
 	return 0;
 }
-- 
1.7.9.5

