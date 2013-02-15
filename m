Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761708Ab3BOMqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:46:12 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:52951 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161392Ab3BOMqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:46:09 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/40] ab8500-bm: Charge only mode fixes for the ab9540
Date: Fri, 15 Feb 2013 12:44:40 +0000
Message-Id: <1360932310-30065-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for charging not getting enabled in charge only mode by
external charger.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_charger.c            |   42 +++++++++++++++++++++++++++++
 drivers/power/abx500_chargalg.c           |   14 ++++++++++
 drivers/power/pm2301_charger.c            |    7 +++++
 include/linux/mfd/abx500/ux500_chargalg.h |    2 ++
 4 files changed, 65 insertions(+)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 3eb23cf..f1d7123 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/notifier.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
@@ -97,6 +98,10 @@
 #define AB8500_SW_CONTROL_FALLBACK	0x03
 /* Wait for enumeration before charing in us */
 #define WAIT_ACA_RID_ENUMERATION	(5 * 1000)
+/*External charger control*/
+#define AB8500_SYS_CHARGER_CONTROL_REG		0x52
+#define EXTERNAL_CHARGER_DISABLE_REG_VAL	0x03
+#define EXTERNAL_CHARGER_ENABLE_REG_VAL		0x07
 
 /* UsbLineStatus register - usb types */
 enum ab8500_charger_link_status {
@@ -1678,6 +1683,29 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
 	return ret;
 }
 
+static int ab8500_external_charger_prepare(struct notifier_block *charger_nb,
+				unsigned long event, void *data)
+{
+	int ret;
+	struct device *dev = data;
+	/*Toggle External charger control pin*/
+	ret = abx500_set_register_interruptible(dev, AB8500_SYS_CTRL1_BLOCK,
+				  AB8500_SYS_CHARGER_CONTROL_REG,
+				  EXTERNAL_CHARGER_DISABLE_REG_VAL);
+	if (ret < 0) {
+		dev_err(dev, "write reg failed %d\n", ret);
+		goto out;
+	}
+	ret = abx500_set_register_interruptible(dev, AB8500_SYS_CTRL1_BLOCK,
+				  AB8500_SYS_CHARGER_CONTROL_REG,
+				  EXTERNAL_CHARGER_ENABLE_REG_VAL);
+	if (ret < 0)
+		dev_err(dev, "Write reg failed %d\n", ret);
+
+out:
+	return ret;
+}
+
 /**
  * ab8500_charger_usb_check_enable() - enable usb charging
  * @charger:	pointer to the ux500_charger structure
@@ -3221,6 +3249,10 @@ static int ab8500_charger_suspend(struct platform_device *pdev,
 #define ab8500_charger_resume       NULL
 #endif
 
+static struct notifier_block charger_nb = {
+	.notifier_call = ab8500_external_charger_prepare,
+};
+
 static int ab8500_charger_remove(struct platform_device *pdev)
 {
 	struct ab8500_charger *di = platform_get_drvdata(pdev);
@@ -3250,6 +3282,11 @@ static int ab8500_charger_remove(struct platform_device *pdev)
 	/* Delete the work queue */
 	destroy_workqueue(di->charger_wq);
 
+	/* Unregister external charger enable notifier */
+	if (!di->ac_chg.enabled)
+		blocking_notifier_chain_unregister(
+			&charger_notifier_list, &charger_nb);
+
 	flush_scheduled_work();
 	if (di->usb_chg.enabled)
 		power_supply_unregister(&di->usb_chg.psy);
@@ -3331,6 +3368,11 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	di->ac_chg.enabled = di->bm->ac_enabled;
 	di->ac_chg.external = false;
 
+	/*notifier for external charger enabling*/
+	if (!di->ac_chg.enabled)
+		blocking_notifier_chain_register(
+			&charger_notifier_list, &charger_nb);
+
 	/* USB supply */
 	/* power_supply base class */
 	di->usb_chg.psy.name = "ab8500_usb";
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 8ab65a3..a876976 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -26,6 +26,7 @@
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ux500_chargalg.h>
 #include <linux/mfd/abx500/ab8500-bm.h>
+#include <linux/notifier.h>
 
 /* Watchdog kick interval */
 #define CHG_WD_INTERVAL			(6 * HZ)
@@ -243,6 +244,9 @@ struct abx500_chargalg {
 	struct kobject chargalg_kobject;
 };
 
+/*External charger prepare notifier*/
+BLOCKING_NOTIFIER_HEAD(charger_notifier_list);
+
 /* Main battery properties */
 static enum power_supply_property abx500_chargalg_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
@@ -503,6 +507,8 @@ static int abx500_chargalg_kick_watchdog(struct abx500_chargalg *di)
 static int abx500_chargalg_ac_en(struct abx500_chargalg *di, int enable,
 	int vset, int iset)
 {
+	static int abx500_chargalg_ex_ac_enable_toggle;
+
 	if (!di->ac_chg || !di->ac_chg->ops.enable)
 		return -ENXIO;
 
@@ -515,6 +521,14 @@ static int abx500_chargalg_ac_en(struct abx500_chargalg *di, int enable,
 	di->chg_info.ac_iset = iset;
 	di->chg_info.ac_vset = vset;
 
+	/* Enable external charger */
+	if (enable && di->ac_chg->external &&
+	    !abx500_chargalg_ex_ac_enable_toggle) {
+		blocking_notifier_call_chain(&charger_notifier_list,
+					     0, di->dev);
+		abx500_chargalg_ex_ac_enable_toggle++;
+	}
+
 	return di->ac_chg->ops.enable(di->ac_chg, enable, vset, iset);
 }
 
diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 2b7c93d..e7eb63d 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -1059,6 +1059,13 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 	ret = pm2xxx_charger_detection(pm2, &val);
 
 	if ((ret == 0) && val) {
+		/*
+		 * When boot is due to AC charger plug-in,
+		 * read interrupt registers
+		 */
+		pm2xxx_reg_read(pm2, PM2XXX_REG_INT1, &val);
+		pm2xxx_reg_read(pm2, PM2XXX_REG_INT2, &val);
+		pm2xxx_reg_read(pm2, PM2XXX_REG_INT4, &val);
 		pm2->ac.charger_connected = 1;
 		pm2->ac_conn = true;
 		power_supply_changed(&pm2->ac_chg.psy);
diff --git a/include/linux/mfd/abx500/ux500_chargalg.h b/include/linux/mfd/abx500/ux500_chargalg.h
index 110d12f..fa831f1 100644
--- a/include/linux/mfd/abx500/ux500_chargalg.h
+++ b/include/linux/mfd/abx500/ux500_chargalg.h
@@ -41,4 +41,6 @@ struct ux500_charger {
 	bool external;
 };
 
+extern struct blocking_notifier_head charger_notifier_list;
+
 #endif
-- 
1.7.10.4

