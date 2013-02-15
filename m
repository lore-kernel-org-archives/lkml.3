Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161847Ab3BOM6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:58:10 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57611 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161813Ab3BOM6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 20/35] mfd: ab8500-sysctrl: Add new reset function
Date: Fri, 15 Feb 2013 12:56:51 +0000
Message-Id: <1360933026-30325-21-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new reset function which uses the AB WD with 0 timeout.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-sysctrl.c              |   63 +++++++++++++++++++++++++++++
 include/linux/mfd/abx500/ab8500-sysctrl.h |    6 +++
 2 files changed, 69 insertions(+)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index 6ac63a0..f43c42b 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -15,6 +15,12 @@
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/abx500/ab8500-sysctrl.h>
 
+/* RtcCtrl bits */
+#define AB8500_ALARM_MIN_LOW  0x08
+#define AB8500_ALARM_MIN_MID 0x09
+#define RTC_CTRL 0x0B
+#define RTC_ALARM_ENABLE 0x4
+
 static struct device *sysctrl_dev;
 
 void ab8500_power_off(void)
@@ -79,6 +85,63 @@ shutdown:
 	}
 }
 
+/*
+ * Use the AB WD to reset the platform. It will perform a hard
+ * reset instead of a soft reset. Write the reset reason to
+ * the AB before reset, which can be read upon restart.
+ */
+void ab8500_restart(char mode, const char *cmd)
+{
+	struct ab8500_platform_data *plat;
+	struct ab8500_sysctrl_platform_data *pdata;
+	u16 reason = 0;
+	u8 val;
+
+	if (sysctrl_dev == NULL) {
+		pr_err("%s: sysctrl not initialized\n", __func__);
+		return;
+	}
+
+	plat = dev_get_platdata(sysctrl_dev->parent);
+	pdata = plat->sysctrl;
+	if (pdata->reboot_reason_code)
+		reason = pdata->reboot_reason_code(cmd);
+	else
+		pr_warn("[%s] No reboot reason set. Default reason %d\n",
+			__func__, reason);
+
+	/*
+	 * Disable RTC alarm, just a precaution so that no alarm
+	 * is running when WD reset is executed.
+	 */
+	abx500_get_register_interruptible(sysctrl_dev, AB8500_RTC,
+		RTC_CTRL , &val);
+	abx500_set_register_interruptible(sysctrl_dev, AB8500_RTC,
+		RTC_CTRL , (val & ~RTC_ALARM_ENABLE));
+
+	/*
+	 * Android is not using the RTC alarm registers during reboot
+	 * so we borrow them for writing the reason of reset
+	 */
+
+	/* reason[8 LSB] */
+	val = reason & 0xFF;
+	abx500_set_register_interruptible(sysctrl_dev, AB8500_RTC,
+		AB8500_ALARM_MIN_LOW , val);
+
+	/* reason[8 MSB] */
+	val = (reason>>8) & 0xFF;
+	abx500_set_register_interruptible(sysctrl_dev, AB8500_RTC,
+		AB8500_ALARM_MIN_MID , val);
+
+	/* Setting WD timeout to 0 */
+	ab8500_sysctrl_write(AB8500_MAINWDOGTIMER, 0xFF, 0x0);
+
+	/* Setting the parameters to AB8500 WD*/
+	ab8500_sysctrl_write(AB8500_MAINWDOGCTRL, 0xFF, (AB8500_ENABLE_WD |
+		AB8500_WD_RESTART_ON_EXPIRE | AB8500_KICK_WD));
+}
+
 static inline bool valid_bank(u8 bank)
 {
 	return ((bank == AB8500_SYS_CTRL1_BLOCK) ||
diff --git a/include/linux/mfd/abx500/ab8500-sysctrl.h b/include/linux/mfd/abx500/ab8500-sysctrl.h
index ebf12e7..990bc93 100644
--- a/include/linux/mfd/abx500/ab8500-sysctrl.h
+++ b/include/linux/mfd/abx500/ab8500-sysctrl.h
@@ -12,6 +12,7 @@
 
 int ab8500_sysctrl_read(u16 reg, u8 *value);
 int ab8500_sysctrl_write(u16 reg, u8 mask, u8 value);
+void ab8500_restart(char mode, const char *cmd);
 
 #else
 
@@ -40,6 +41,7 @@ static inline int ab8500_sysctrl_clear(u16 reg, u8 bits)
 /* Configuration data for SysClkReq1RfClkBuf - SysClkReq8RfClkBuf */
 struct ab8500_sysctrl_platform_data {
 	u8 initial_req_buf_config[8];
+	u16 (*reboot_reason_code)(const char *cmd);
 };
 
 /* Registers */
@@ -299,4 +301,8 @@ struct ab8500_sysctrl_platform_data {
 #define AB9540_SYSCLK12BUF4VALID_SYSCLK12BUF4VALID_MASK 0xFF
 #define AB9540_SYSCLK12BUF4VALID_SYSCLK12BUF4VALID_SHIFT 0
 
+#define AB8500_ENABLE_WD 0x1
+#define AB8500_KICK_WD 0x2
+#define AB8500_WD_RESTART_ON_EXPIRE 0x10
+
 #endif /* __AB8500_SYSCTRL_H */
-- 
1.7.10.4

