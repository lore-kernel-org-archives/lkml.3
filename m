Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3LUBLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 20:11:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:51744 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab3LUBKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 20:10:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,524,1384329600"; 
   d="scan'208";a="428104820"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, david.a.cohen@linux.intel.com
Subject: [PATCH v2 2/3] x86: intel-mid: platform code should return error when failing
Date: Fri, 20 Dec 2013 17:15:12 -0800
Message-Id: <1387588513-25701-3-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1387588513-25701-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1387518179-4316-1-git-send-email-david.a.cohen@linux.intel.com>
 <1387588513-25701-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All Intel MID platform code are responsible for:
 - execute platform initialization code
 - return platform data (when there's one)

But currently it's ambiguous the error condition during platform
initialization and the lack of platform data. In both cases platform
code will return NULL.

This patch fixes such situation. From now on NULL is a valid case when
there is no platform data and ERR_PTR() is used for error conditions.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/platform/intel-mid/device_libs/platform_emc1403.c   | 6 ++++--
 arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_lis331.c    | 6 ++++--
 arch/x86/platform/intel-mid/device_libs/platform_max7315.c   | 6 +++---
 arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c   | 4 ++--
 arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c  | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c  | 6 ++++++
 arch/x86/platform/intel-mid/device_libs/platform_tca6416.c   | 6 +++---
 10 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
index 0d942c1d26d5..58933daa606d 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
@@ -22,8 +22,10 @@ static void __init *emc1403_platform_data(void *info)
 	int intr = get_gpio_by_name("thermal_int");
 	int intr2nd = get_gpio_by_name("thermal_alert");
 
-	if (intr == -1 || intr2nd == -1)
-		return NULL;
+	if (intr < 0)
+		return ERR_PTR(intr);
+	if (intr2nd < 0)
+		return ERR_PTR(intr2nd);
 
 	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
 	intr2nd_pdata = intr2nd + INTEL_MID_IRQ_OFFSET;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
index a013a4834bbe..dccae6b0413f 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
@@ -66,7 +66,7 @@ static int __init pb_keys_init(void)
 		gb[i].gpio = get_gpio_by_name(gb[i].desc);
 		pr_debug("info[%2d]: name = %s, gpio = %d\n", i, gb[i].desc,
 					gb[i].gpio);
-		if (gb[i].gpio == -1)
+		if (gb[i].gpio < 0)
 			continue;
 
 		if (i != good)
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_lis331.c b/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
index 15278c11f714..506856c418a6 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
@@ -21,8 +21,10 @@ static void __init *lis331dl_platform_data(void *info)
 	int intr = get_gpio_by_name("accel_int");
 	int intr2nd = get_gpio_by_name("accel_2");
 
-	if (intr == -1 || intr2nd == -1)
-		return NULL;
+	if (intr < 0)
+		return ERR_PTR(intr);
+	if (intr2nd < 0)
+		return ERR_PTR(intr2nd);
 
 	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
 	intr2nd_pdata = intr2nd + INTEL_MID_IRQ_OFFSET;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
index 94ade10024ae..d25ec6d4b606 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
@@ -31,7 +31,7 @@ static void __init *max7315_platform_data(void *info)
 	if (nr == MAX7315_NUM) {
 		pr_err("too many max7315s, we only support %d\n",
 				MAX7315_NUM);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 	/* we have several max7315 on the board, we only need load several
 	 * instances of the same pca953x driver to cover them
@@ -48,8 +48,8 @@ static void __init *max7315_platform_data(void *info)
 	gpio_base = get_gpio_by_name(base_pin_name);
 	intr = get_gpio_by_name(intr_pin_name);
 
-	if (gpio_base == -1)
-		return NULL;
+	if (gpio_base < 0)
+		return ERR_PTR(gpio_base);
 	max7315->gpio_base = gpio_base;
 	if (intr != -1) {
 		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
index dd28d63c84fb..c0a8fe7791a0 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
@@ -19,8 +19,8 @@ static void *mpu3050_platform_data(void *info)
 	struct i2c_board_info *i2c_info = info;
 	int intr = get_gpio_by_name("mpu3050_int");
 
-	if (intr == -1)
-		return NULL;
+	if (intr < 0)
+		return ERR_PTR(intr);
 
 	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
 	return NULL;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
index 2a4f7b1dd917..a3843c43ae70 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
@@ -29,7 +29,7 @@ static void __init *msic_gpio_platform_data(void *info)
 	int gpio = get_gpio_by_name("msic_gpio_base");
 
 	if (gpio < 0)
-		return NULL;
+		return ERR_PTR(gpio);
 
 	msic_gpio_pdata.gpio_base = gpio;
 	msic_pdata.gpio = &msic_gpio_pdata;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
index 6497111ddb54..65aa98aee28f 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
@@ -30,7 +30,7 @@ static void __init *msic_ocd_platform_data(void *info)
 	gpio = get_gpio_by_name("ocd_gpio");
 
 	if (gpio < 0)
-		return NULL;
+		return ERR_PTR(gpio);
 
 	msic_ocd_pdata.gpio = gpio;
 	msic_pdata.ocd = &msic_ocd_pdata;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
index d87182a09263..65c2a9a19db4 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
@@ -26,7 +26,7 @@ static void __init *pmic_gpio_platform_data(void *info)
 	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
 	int gpio_base = get_gpio_by_name("pmic_gpio_base");
 
-	if (gpio_base == -1)
+	if (gpio_base < 0)
 		gpio_base = 64;
 	pmic_gpio_pdata.gpio_base = gpio_base;
 	pmic_gpio_pdata.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c b/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
index 740fc757050c..53fb3ec7cf5d 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
@@ -21,8 +21,14 @@ static void *tc35876x_platform_data(void *data)
 
 	/* gpio pins set to -1 will not be used by the driver */
 	pdata.gpio_bridge_reset = get_gpio_by_name("LCMB_RXEN");
+	if (pdata.gpio_bridge_reset < 0)
+		return ERR_PTR(pdata.gpio_bridge_reset);
 	pdata.gpio_panel_bl_en = get_gpio_by_name("6S6P_BL_EN");
+	if (pdata.gpio_panel_bl_en < 0)
+		return ERR_PTR(pdata.gpio_panel_bl_en);
 	pdata.gpio_panel_vadd = get_gpio_by_name("EN_VREG_LCD_V3P3");
+	if (pdata.gpio_panel_vadd < 0)
+		return ERR_PTR(pdata.gpio_panel_vadd);
 
 	return &pdata;
 }
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
index 22881c9a6737..e331b38871da 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
@@ -34,10 +34,10 @@ static void *tca6416_platform_data(void *info)
 	gpio_base = get_gpio_by_name(base_pin_name);
 	intr = get_gpio_by_name(intr_pin_name);
 
-	if (gpio_base == -1)
-		return NULL;
+	if (gpio_base < 0)
+		return ERR_PTR(gpio_base);
 	tca6416.gpio_base = gpio_base;
-	if (intr != -1) {
+	if (intr >= 0) {
 		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
 		tca6416.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
 	} else {
-- 
1.8.4.2

