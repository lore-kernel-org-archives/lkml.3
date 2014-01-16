Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaAPXCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:02:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:12166 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbaAPXCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:02:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="467941400"
From: David Cohen <david.a.cohen@linux.intel.com>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Cc: david.a.cohen@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] x86: intel-mid: check get_gpio_by_name() error code on platform code
Date: Thu, 16 Jan 2014 15:07:03 -0800
Message-Id: <1389913624-9149-3-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389913624-9149-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1389913624-9149-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does cleanup on all intel mid platform code that uses
gpio_get_by_name() function. From now on they should check for any error
code instead of only hardcoded -1.

There is no functional change out of this change.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/platform/intel-mid/device_libs/platform_emc1403.c   | 4 +++-
 arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_lis331.c    | 4 +++-
 arch/x86/platform/intel-mid/device_libs/platform_max7315.c   | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c   | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c | 2 +-
 arch/x86/platform/intel-mid/device_libs/platform_tca6416.c   | 4 ++--
 7 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
index 0d942c1d26d5..69a783689d21 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
@@ -22,7 +22,9 @@ static void __init *emc1403_platform_data(void *info)
 	int intr = get_gpio_by_name("thermal_int");
 	int intr2nd = get_gpio_by_name("thermal_alert");
 
-	if (intr == -1 || intr2nd == -1)
+	if (intr < 0)
+		return NULL;
+	if (intr2nd < 0)
 		return NULL;
 
 	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
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
index 15278c11f714..54226de7541a 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
@@ -21,7 +21,9 @@ static void __init *lis331dl_platform_data(void *info)
 	int intr = get_gpio_by_name("accel_int");
 	int intr2nd = get_gpio_by_name("accel_2");
 
-	if (intr == -1 || intr2nd == -1)
+	if (intr < 0)
+		return NULL;
+	if (intr2nd < 0)
 		return NULL;
 
 	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
index 94ade10024ae..2c8acbc1e9ad 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
@@ -48,7 +48,7 @@ static void __init *max7315_platform_data(void *info)
 	gpio_base = get_gpio_by_name(base_pin_name);
 	intr = get_gpio_by_name(intr_pin_name);
 
-	if (gpio_base == -1)
+	if (gpio_base < 0)
 		return NULL;
 	max7315->gpio_base = gpio_base;
 	if (intr != -1) {
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
index dd28d63c84fb..cfe9a47a1e87 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
@@ -19,7 +19,7 @@ static void *mpu3050_platform_data(void *info)
 	struct i2c_board_info *i2c_info = info;
 	int intr = get_gpio_by_name("mpu3050_int");
 
-	if (intr == -1)
+	if (intr < 0)
 		return NULL;
 
 	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
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
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
index 22881c9a6737..33be0b3be6e1 100644
--- a/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
+++ b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
@@ -34,10 +34,10 @@ static void *tca6416_platform_data(void *info)
 	gpio_base = get_gpio_by_name(base_pin_name);
 	intr = get_gpio_by_name(intr_pin_name);
 
-	if (gpio_base == -1)
+	if (gpio_base < 0)
 		return NULL;
 	tca6416.gpio_base = gpio_base;
-	if (intr != -1) {
+	if (intr >= 0) {
 		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
 		tca6416.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
 	} else {
-- 
1.8.4.2

