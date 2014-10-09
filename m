Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbaJIQS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:18:57 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50904 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaJIQSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:18:48 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] mfd: ab8500-sysctrl: Drop ab8500_restart
Date: Thu,  9 Oct 2014 09:18:38 -0700
Message-Id: <1412871518-11359-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ab8500_restart is not called from anywhere in the kernel, so drop it.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/mfd/ab8500-sysctrl.c              | 57 -------------------------------
 include/linux/mfd/abx500/ab8500-sysctrl.h |  1 -
 2 files changed, 58 deletions(-)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index 8e0dae5..94dbcdd 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -85,63 +85,6 @@ shutdown:
 	}
 }
 
-/*
- * Use the AB WD to reset the platform. It will perform a hard
- * reset instead of a soft reset. Write the reset reason to
- * the AB before reset, which can be read upon restart.
- */
-void ab8500_restart(char mode, const char *cmd)
-{
-	struct ab8500_platform_data *plat;
-	struct ab8500_sysctrl_platform_data *pdata;
-	u16 reason = 0;
-	u8 val;
-
-	if (sysctrl_dev == NULL) {
-		pr_err("%s: sysctrl not initialized\n", __func__);
-		return;
-	}
-
-	plat = dev_get_platdata(sysctrl_dev->parent);
-	pdata = plat->sysctrl;
-	if (pdata && pdata->reboot_reason_code)
-		reason = pdata->reboot_reason_code(cmd);
-	else
-		pr_warn("[%s] No reboot reason set. Default reason %d\n",
-			__func__, reason);
-
-	/*
-	 * Disable RTC alarm, just a precaution so that no alarm
-	 * is running when WD reset is executed.
-	 */
-	abx500_get_register_interruptible(sysctrl_dev, AB8500_RTC,
-		RTC_CTRL , &val);
-	abx500_set_register_interruptible(sysctrl_dev, AB8500_RTC,
-		RTC_CTRL , (val & ~RTC_ALARM_ENABLE));
-
-	/*
-	 * Android is not using the RTC alarm registers during reboot
-	 * so we borrow them for writing the reason of reset
-	 */
-
-	/* reason[8 LSB] */
-	val = reason & 0xFF;
-	abx500_set_register_interruptible(sysctrl_dev, AB8500_RTC,
-		AB8500_ALARM_MIN_LOW , val);
-
-	/* reason[8 MSB] */
-	val = (reason>>8) & 0xFF;
-	abx500_set_register_interruptible(sysctrl_dev, AB8500_RTC,
-		AB8500_ALARM_MIN_MID , val);
-
-	/* Setting WD timeout to 0 */
-	ab8500_sysctrl_write(AB8500_MAINWDOGTIMER, 0xFF, 0x0);
-
-	/* Setting the parameters to AB8500 WD*/
-	ab8500_sysctrl_write(AB8500_MAINWDOGCTRL, 0xFF, (AB8500_ENABLE_WD |
-		AB8500_WD_RESTART_ON_EXPIRE | AB8500_KICK_WD));
-}
-
 static inline bool valid_bank(u8 bank)
 {
 	return ((bank == AB8500_SYS_CTRL1_BLOCK) ||
diff --git a/include/linux/mfd/abx500/ab8500-sysctrl.h b/include/linux/mfd/abx500/ab8500-sysctrl.h
index adba89d..6893127 100644
--- a/include/linux/mfd/abx500/ab8500-sysctrl.h
+++ b/include/linux/mfd/abx500/ab8500-sysctrl.h
@@ -12,7 +12,6 @@
 
 int ab8500_sysctrl_read(u16 reg, u8 *value);
 int ab8500_sysctrl_write(u16 reg, u8 mask, u8 value);
-void ab8500_restart(char mode, const char *cmd);
 
 #else
 
-- 
1.9.1

