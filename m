Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161820Ab3BOM6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:58:01 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39627 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161476Ab3BOM55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:57 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>,
        Per Forlin <per.forlin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 18/35] mfd: ab8500-sysctrl: Update correct turn on status
Date: Fri, 15 Feb 2013 12:56:49 +0000
Message-Id: <1360933026-30325-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>

In L9540, turn_on_status register is not updated correctly if
the device is rebooted with AC/USB charger connected. Due to
this, the device boots android instead of entering into charge
only mode. Read the AC/USB status register to detect the charger
presence and update the turn on status manually.

Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Signed-off-by: Per Forlin <per.forlin@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Rupesh KUMAR <rupesh.kumar@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Tested-by: Rupesh KUMAR <rupesh.kumar@stericsson.com>
Tested-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
---
 drivers/mfd/ab8500-core.c         |   39 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/ab8500-sysctrl.c      |    2 +-
 include/linux/mfd/abx500/ab8500.h |   11 +++++++++++
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index f5ceb2e..bbbd6e4 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -113,6 +113,13 @@
 
 #define AB8500_TURN_ON_STATUS		0x00
 
+#define AB8500_CH_USBCH_STAT1_REG	0x02
+#define VBUS_DET_DBNC100		0x02
+#define VBUS_DET_DBNC1			0x01
+
+static DEFINE_SPINLOCK(on_stat_lock);
+static u8 turn_on_stat_mask = 0xFF;
+static u8 turn_on_stat_set;
 static bool no_bm; /* No battery management */
 module_param(no_bm, bool, S_IRUGO);
 
@@ -1329,6 +1336,15 @@ static ssize_t show_switch_off_status(struct device *dev,
 	return sprintf(buf, "%#x\n", value);
 }
 
+/* use mask and set to override the register turn_on_stat value */
+void ab8500_override_turn_on_stat(u8 mask, u8 set)
+{
+	spin_lock(&on_stat_lock);
+	turn_on_stat_mask = mask;
+	turn_on_stat_set = set;
+	spin_unlock(&on_stat_lock);
+}
+
 /*
  * ab8500 has turned on due to (TURN_ON_STATUS):
  * 0x01 PORnVbat
@@ -1352,6 +1368,20 @@ static ssize_t show_turn_on_status(struct device *dev,
 		AB8500_TURN_ON_STATUS, &value);
 	if (ret < 0)
 		return ret;
+
+	/*
+	 * In L9540, turn_on_status register is not updated correctly if
+	 * the device is rebooted with AC/USB charger connected. Due to
+	 * this, the device boots android instead of entering into charge
+	 * only mode. Read the AC/USB status register to detect the charger
+	 * presence and update the turn on status manually.
+	 */
+	if (is_ab9540(ab8500)) {
+		spin_lock(&on_stat_lock);
+		value = (value & turn_on_stat_mask) | turn_on_stat_set;
+		spin_unlock(&on_stat_lock);
+	}
+
 	return sprintf(buf, "%#x\n", value);
 }
 
@@ -1564,6 +1594,15 @@ static int ab8500_probe(struct platform_device *pdev)
 
 	if (plat && plat->init)
 		plat->init(ab8500);
+	if (is_ab9540(ab8500)) {
+		ret = get_register_interruptible(ab8500, AB8500_CHARGER,
+			AB8500_CH_USBCH_STAT1_REG, &value);
+		if (ret < 0)
+			return ret;
+		if ((value & VBUS_DET_DBNC1) && (value & VBUS_DET_DBNC100))
+			ab8500_override_turn_on_stat(~AB8500_POW_KEY_1_ON,
+						     AB8500_VBUS_DET);
+	}
 
 	/* Clear and mask all interrupts */
 	for (i = 0; i < ab8500->mask_size; i++) {
diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index ab6bfd3..6ac63a0 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -21,7 +21,7 @@ void ab8500_power_off(void)
 {
 	sigset_t old;
 	sigset_t all;
-	static char *pss[] = {"ab8500_ac", "ab8500_usb"};
+	static char *pss[] = {"ab8500_ac", "pm2301", "ab8500_usb"};
 	int i;
 	bool charger_present = false;
 	union power_supply_propval val;
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 06a8292..6748129 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -308,6 +308,15 @@ enum ab8500_version {
 #define AB9540_NUM_IRQ_REGS		20
 #define AB8540_NUM_IRQ_REGS		27
 
+/* Turn On Status Event */
+#define AB8500_POR_ON_VBAT		0x01
+#define AB8500_POW_KEY_1_ON		0x02
+#define AB8500_POW_KEY_2_ON		0x04
+#define AB8500_RTC_ALARM		0x08
+#define AB8500_MAIN_CH_DET		0x10
+#define AB8500_VBUS_DET			0x20
+#define AB8500_USB_ID_DET		0x40
+
 /**
  * struct ab8500 - ab8500 internal structure
  * @dev: parent device
@@ -468,6 +477,8 @@ static inline int is_ab8540_2p0(struct ab8500 *ab)
 	return is_ab8540(ab) && (ab->chip_id == AB8500_CUT2P0);
 }
 
+void ab8500_override_turn_on_stat(u8 mask, u8 set);
+
 #ifdef CONFIG_AB8500_DEBUG
 void ab8500_dump_all_banks(struct device *dev);
 void ab8500_debug_register_interrupt(int line);
-- 
1.7.10.4

