Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaAPXkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:40:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46426 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaAPXj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:39:58 -0500
Date: Thu, 16 Jan 2014 15:39:48 -0800
From: tip-bot for David Cohen <tipbot@zytor.com>
Message-ID: <tip-a957a14bb4ca976cbaaff3594ef5b8f8f7f65804@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1389913624-9149-3-git-send-email-david.a.cohen@linux.intel.com>
References: <1389913624-9149-3-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] x86, intel-mid: Check get_gpio_by_name()
  error code on platform code
Git-Commit-ID: a957a14bb4ca976cbaaff3594ef5b8f8f7f65804
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 15:39:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a957a14bb4ca976cbaaff3594ef5b8f8f7f65804
Gitweb:     http://git.kernel.org/tip/a957a14bb4ca976cbaaff3594ef5b8f8f7f65804
Author:     David Cohen <david.a.cohen@linux.intel.com>
AuthorDate: Thu, 16 Jan 2014 15:07:03 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 16 Jan 2014 15:06:58 -0800

x86, intel-mid: Check get_gpio_by_name() error code on platform code

This patch does cleanup on all intel mid platform code that uses
gpio_get_by_name() function. From now on they should check for any error
code instead of only hardcoded -1.

There are no functional changes from this change.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1389913624-9149-3-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
index 0d942c1..69a7836 100644
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
index a013a48..dccae6b 100644
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
index 15278c1..54226de 100644
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
index 94ade10..2c8acbc 100644
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
index dd28d63..cfe9a47 100644
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
index d87182a..65c2a9a 100644
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
index 22881c9..33be0b3 100644
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
