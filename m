Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3AUMGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:06:23 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47046 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3AUMFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:05:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 23/24] ab8500-bm: Fix minor niggles experienced during testing
Date: Mon, 21 Jan 2013 12:03:59 +0000
Message-Id: <1358769840-4763-24-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compile testing the new AB8500 Battery Management changes
due for inclusion into upstream, there were a few minor niggles
which required repairing, or adapting for use against the
Mainline kernel. This patch is a collection of them all.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_fg.h       |    6 ++++--
 drivers/power/abx500_chargalg.c |    4 ++--
 drivers/power/pm2301_charger.c  |    4 ++--
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/power/ab8500_fg.h b/drivers/power/ab8500_fg.h
index 946840b..bb78dc9 100644
--- a/drivers/power/ab8500_fg.h
+++ b/drivers/power/ab8500_fg.h
@@ -182,6 +182,7 @@ struct ab8500_fg_test {
  * @fg_check_hw_failure_work:	Work for checking HW state
  * @cc_lock:		Mutex for locking the CC
  * @fg_kobject:		Structure of type kobject
+ * @test:		Structure of type ab8500_fg_test for test purpose
  */
 struct ab8500_fg {
 	struct device *dev;
@@ -224,6 +225,7 @@ struct ab8500_fg {
 	struct delayed_work fg_check_hw_failure_work;
 	struct mutex cc_lock;
 	struct kobject fg_kobject;
+	struct ab8500_fg_test test;
 };
 
 extern char *discharge_state[];
@@ -232,8 +234,8 @@ extern char *charge_state[];
 int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable);
 void ab8500_fg_charge_state_to(struct ab8500_fg *di,
 		enum ab8500_fg_charge_state new_state);
-void ab8500_fg_discharge_state_to(struct ab8500_fg *di,
-		enum ab8500_fg_charge_state new_state);
+static void ab8500_fg_discharge_state_to(struct ab8500_fg *di,
+		enum ab8500_fg_discharge_state new_state);
 /* test initialization */
 #ifdef CONFIG_AB8500_BM_DEEP_DEBUG
 void ab8500_fg_test_init(struct ab8500_fg *di);
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 694f592..cacf512 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1664,8 +1664,8 @@ static int abx500_chargalg_get_property(struct power_supply *psy,
 static ssize_t ab8500_chargalg_sysfs_show(struct kobject *kobj,
 					  struct attribute *attr, char *buf)
 {
-	struct ab8500_chargalg *di = container_of(kobj,
-               struct ab8500_chargalg, chargalg_kobject);
+	struct abx500_chargalg *di = container_of(kobj,
+               struct abx500_chargalg, chargalg_kobject);
 
 	return sprintf(buf, "%d\n",
 		       di->susp_status.ac_suspended &&
diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index 14e37b2..5ebae88 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -22,8 +22,8 @@
 #include <linux/i2c.h>
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
-#include <linux/mfd/ab8500.h>
 #include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
 #include <linux/mfd/abx500/ab8500-bm.h>
 #include <linux/mfd/abx500/ab8500-gpadc.h>
 #include <linux/mfd/abx500/ux500_chargalg.h>
@@ -867,7 +867,7 @@ static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
 
 	/* get parent data */
 	pm2->dev = &i2c_client->dev;
-	pm2->gpadc = ab8500_gpadc_get();
+	pm2->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 
 	pm2->pm2_int = &pm2xxx_int;
 
-- 
1.7.9.5

