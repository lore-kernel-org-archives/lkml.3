Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab3E1IRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:17:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:21608 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933398Ab3E1IRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:17:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,756,1363158000"; 
   d="scan'208";a="344243636"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: sfi-devel@simplefirmware.org, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH, resend 3/3] x86: mrst: move to generic SFI GPIO API
Date: Tue, 28 May 2013 11:16:54 +0300
Message-Id: <1369729014-20974-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369729014-20974-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369729014-20974-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's use the common SFI helpers for GPIO API.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Len Brown <len.brown@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/platform/mrst/mrst.c | 94 ++++++++++---------------------------------
 1 file changed, 22 insertions(+), 72 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index a0a0a43..9ba13d8 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -17,6 +17,7 @@
 #include <linux/interrupt.h>
 #include <linux/scatterlist.h>
 #include <linux/sfi.h>
+#include <linux/sfi_gpio.h>
 #include <linux/intel_pmic_gpio.h>
 #include <linux/spi/spi.h>
 #include <linux/i2c.h>
@@ -28,7 +29,6 @@
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/mfd/intel_msic.h>
-#include <linux/gpio.h>
 #include <linux/i2c/tc35876x.h>
 
 #include <asm/setup.h>
@@ -219,7 +219,7 @@ static unsigned long __init mrst_calibrate_tsc(void)
 	lapic_timer_frequency = fsb * 1000 / HZ;
 	/* mark tsc clocksource as reliable */
 	set_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE);
-	
+
 	if (fast_calibrate)
 		return fast_calibrate;
 
@@ -338,55 +338,6 @@ static inline int __init setup_x86_mrst_timer(char *arg)
 __setup("x86_mrst_timer=", setup_x86_mrst_timer);
 
 /*
- * Parsing GPIO table first, since the DEVS table will need this table
- * to map the pin name to the actual pin.
- */
-static struct sfi_gpio_table_entry *gpio_table;
-static int gpio_num_entry;
-
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
-static int get_gpio_by_name(const char *name)
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
-/*
  * Here defines the array of devices platform data that IAFW would export
  * through SFI "DEVS" table, we use name and type to match the device and
  * its platform data.
@@ -404,7 +355,7 @@ struct devs_id {
 static void __init *pmic_gpio_platform_data(void *info)
 {
 	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
-	int gpio_base = get_gpio_by_name("pmic_gpio_base");
+	int gpio_base = sfi_get_gpio_by_name("pmic_gpio_base");
 
 	if (gpio_base == -1)
 		gpio_base = 64;
@@ -418,7 +369,7 @@ static void __init *pmic_gpio_platform_data(void *info)
 static void __init *max3111_platform_data(void *info)
 {
 	struct spi_board_info *spi_info = info;
-	int intr = get_gpio_by_name("max3111_int");
+	int intr = sfi_get_gpio_by_name("max3111_int");
 
 	spi_info->mode = SPI_MODE_0;
 	if (intr == -1)
@@ -456,8 +407,8 @@ static void __init *max7315_platform_data(void *info)
 		strcpy(intr_pin_name, "max7315_int");
 	}
 
-	gpio_base = get_gpio_by_name(base_pin_name);
-	intr = get_gpio_by_name(intr_pin_name);
+	gpio_base = sfi_get_gpio_by_name(base_pin_name);
+	intr = sfi_get_gpio_by_name(intr_pin_name);
 
 	if (gpio_base == -1)
 		return NULL;
@@ -484,8 +435,8 @@ static void *tca6416_platform_data(void *info)
 	strcpy(base_pin_name, "tca6416_base");
 	strcpy(intr_pin_name, "tca6416_int");
 
-	gpio_base = get_gpio_by_name(base_pin_name);
-	intr = get_gpio_by_name(intr_pin_name);
+	gpio_base = sfi_get_gpio_by_name(base_pin_name);
+	intr = sfi_get_gpio_by_name(intr_pin_name);
 
 	if (gpio_base == -1)
 		return NULL;
@@ -503,7 +454,7 @@ static void *tca6416_platform_data(void *info)
 static void *mpu3050_platform_data(void *info)
 {
 	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("mpu3050_int");
+	int intr = sfi_get_gpio_by_name("mpu3050_int");
 
 	if (intr == -1)
 		return NULL;
@@ -516,8 +467,8 @@ static void __init *emc1403_platform_data(void *info)
 {
 	static short intr2nd_pdata;
 	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("thermal_int");
-	int intr2nd = get_gpio_by_name("thermal_alert");
+	int intr = sfi_get_gpio_by_name("thermal_int");
+	int intr2nd = sfi_get_gpio_by_name("thermal_alert");
 
 	if (intr == -1 || intr2nd == -1)
 		return NULL;
@@ -532,8 +483,8 @@ static void __init *lis331dl_platform_data(void *info)
 {
 	static short intr2nd_pdata;
 	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("accel_int");
-	int intr2nd = get_gpio_by_name("accel_2");
+	int intr = sfi_get_gpio_by_name("accel_int");
+	int intr2nd = sfi_get_gpio_by_name("accel_2");
 
 	if (intr == -1 || intr2nd == -1)
 		return NULL;
@@ -628,7 +579,7 @@ static void *msic_battery_platform_data(void *info)
 static void *msic_gpio_platform_data(void *info)
 {
 	static struct intel_msic_gpio_pdata pdata;
-	int gpio = get_gpio_by_name("msic_gpio_base");
+	int gpio = sfi_get_gpio_by_name("msic_gpio_base");
 
 	if (gpio < 0)
 		return NULL;
@@ -660,7 +611,7 @@ static void *msic_power_btn_platform_data(void *info)
 static void *msic_ocd_platform_data(void *info)
 {
 	static struct intel_msic_ocd_pdata pdata;
-	int gpio = get_gpio_by_name("ocd_gpio");
+	int gpio = sfi_get_gpio_by_name("ocd_gpio");
 
 	if (gpio < 0)
 		return NULL;
@@ -679,14 +630,14 @@ static void *msic_thermal_platform_data(void *info)
 /* tc35876x DSI-LVDS bridge chip and panel platform data */
 static void *tc35876x_platform_data(void *data)
 {
-       static struct tc35876x_platform_data pdata;
+	static struct tc35876x_platform_data pdata;
 
-       /* gpio pins set to -1 will not be used by the driver */
-       pdata.gpio_bridge_reset = get_gpio_by_name("LCMB_RXEN");
-       pdata.gpio_panel_bl_en = get_gpio_by_name("6S6P_BL_EN");
-       pdata.gpio_panel_vadd = get_gpio_by_name("EN_VREG_LCD_V3P3");
+	/* gpio pins set to -1 will not be used by the driver */
+	pdata.gpio_bridge_reset = sfi_get_gpio_by_name("LCMB_RXEN");
+	pdata.gpio_panel_bl_en = sfi_get_gpio_by_name("6S6P_BL_EN");
+	pdata.gpio_panel_vadd = sfi_get_gpio_by_name("EN_VREG_LCD_V3P3");
 
-       return &pdata;
+	return &pdata;
 }
 
 static const struct devs_id __initconst device_ids[] = {
@@ -984,7 +935,6 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 
 static int __init mrst_platform_init(void)
 {
-	sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, sfi_parse_gpio);
 	sfi_table_parse(SFI_SIG_DEVS, NULL, NULL, sfi_parse_devs);
 	return 0;
 }
@@ -1033,7 +983,7 @@ static int __init pb_keys_init(void)
 
 	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
 	for (i = 0; i < num; i++) {
-		gb[i].gpio = get_gpio_by_name(gb[i].desc);
+		gb[i].gpio = sfi_get_gpio_by_name(gb[i].desc);
 		pr_debug("info[%2d]: name = %s, gpio = %d\n", i, gb[i].desc, gb[i].gpio);
 		if (gb[i].gpio == -1)
 			continue;
-- 
1.8.2.rc0.22.gb3600c3

