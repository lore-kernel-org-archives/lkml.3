Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161623Ab3BOMs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:48:26 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:46744 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161415Ab3BOMrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:47:06 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 38/40] abx500-chargalg: Add charging current step interface
Date: Fri, 15 Feb 2013 12:45:08 +0000
Message-Id: <1360932310-30065-39-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To prevent overheating, provide differnt steps of charging current
interface to allow thermal mitigation. This will provide possibility
to reduce gradually the charging current.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/abx500_chargalg.c |  231 ++++++++++++++++++++++++++-------------
 1 file changed, 155 insertions(+), 76 deletions(-)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 7e4bc01..9863e42 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -47,6 +47,9 @@
 /* Plus margin for the low battery threshold */
 #define BAT_PLUS_MARGIN                (100)
 
+#define CHARGALG_CURR_STEP_LOW		0
+#define CHARGALG_CURR_STEP_HIGH	100
+
 #define to_abx500_chargalg_device_info(x) container_of((x), \
 	struct abx500_chargalg, chargalg_psy);
 
@@ -80,6 +83,11 @@ struct abx500_chargalg_suspension_status {
 	bool usb_suspended;
 };
 
+struct abx500_chargalg_current_step_status {
+	bool curr_step_change;
+	int curr_step;
+};
+
 struct abx500_chargalg_battery_data {
 	int temp;
 	int volt;
@@ -220,6 +228,7 @@ enum maxim_ret {
  * @batt_data:		data of the battery
  * @susp_status:	current charger suspension status
  * @bm:           	Platform specific battery management information
+ * @curr_status:	Current step status for over-current protection
  * @parent:		pointer to the struct abx500
  * @chargalg_psy:	structure that holds the battery properties exposed by
  *			the charging algorithm
@@ -245,6 +254,7 @@ struct abx500_chargalg {
 	struct abx500_chargalg_battery_data batt_data;
 	struct abx500_chargalg_suspension_status susp_status;
 	struct ab8500 *parent;
+	struct abx500_chargalg_current_step_status curr_status;
 	struct abx500_bm_data *bm;
 	struct power_supply chargalg_psy;
 	struct ux500_charger *ac_chg;
@@ -268,6 +278,12 @@ static enum power_supply_property abx500_chargalg_props[] = {
 	POWER_SUPPLY_PROP_HEALTH,
 };
 
+struct abx500_chargalg_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct abx500_chargalg *, char *);
+	ssize_t (*store)(struct abx500_chargalg *, const char *, size_t);
+};
+
 /**
  * abx500_chargalg_safety_timer_expired() - Expiration of the safety timer
  * @timer:     pointer to the hrtimer structure
@@ -402,6 +418,22 @@ static int abx500_chargalg_check_charger_connection(struct abx500_chargalg *di)
 }
 
 /**
+ * abx500_chargalg_check_current_step_status() - Check charging current
+ * step status.
+ * @di:		pointer to the abx500_chargalg structure
+ *
+ * This function will check if there is a change in the charging current step
+ * and change charge state accordingly.
+ */
+static void abx500_chargalg_check_current_step_status
+	(struct abx500_chargalg *di)
+{
+	if (di->curr_status.curr_step_change)
+		abx500_chargalg_state_to(di, STATE_NORMAL_INIT);
+	di->curr_status.curr_step_change = false;
+}
+
+/**
  * abx500_chargalg_start_safety_timer() - Start charging safety timer
  * @di:		pointer to the abx500_chargalg structure
  *
@@ -1300,6 +1332,7 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 {
 	int charger_status;
 	int ret;
+	int curr_step_lvl;
 
 	/* Collect data from all power_supply class devices */
 	class_for_each_device(power_supply_class, NULL,
@@ -1310,6 +1343,7 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 	abx500_chargalg_check_charger_voltage(di);
 
 	charger_status = abx500_chargalg_check_charger_connection(di);
+	abx500_chargalg_check_current_step_status(di);
 
 	if (is_ab8500(di->parent)) {
 		ret = abx500_chargalg_check_charger_enable(di);
@@ -1523,9 +1557,18 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 			}
 		}
 
-		abx500_chargalg_start_charging(di,
-			di->bm->bat_type[di->bm->batt_id].normal_vol_lvl,
-			di->bm->bat_type[di->bm->batt_id].normal_cur_lvl);
+		if (di->curr_status.curr_step == CHARGALG_CURR_STEP_LOW)
+			abx500_chargalg_stop_charging(di);
+		else {
+			curr_step_lvl = di->bm->bat_type[
+				di->bm->batt_id].normal_cur_lvl
+				* di->curr_status.curr_step
+				/ CHARGALG_CURR_STEP_HIGH;
+			abx500_chargalg_start_charging(di,
+				di->bm->bat_type[di->bm->batt_id]
+				.normal_vol_lvl, curr_step_lvl);
+		}
+
 		abx500_chargalg_state_to(di, STATE_NORMAL);
 		abx500_chargalg_start_safety_timer(di);
 		abx500_chargalg_stop_maintenance_timer(di);
@@ -1767,99 +1810,134 @@ static int abx500_chargalg_get_property(struct power_supply *psy,
 
 /* Exposure to the sysfs interface */
 
-/**
- * abx500_chargalg_sysfs_show() - sysfs show operations
- * @kobj:      pointer to the struct kobject
- * @attr:      pointer to the struct attribute
- * @buf:       buffer that holds the parameter to send to userspace
- *
- * Returns a buffer to be displayed in user space
- */
-static ssize_t abx500_chargalg_sysfs_show(struct kobject *kobj,
-					  struct attribute *attr, char *buf)
+static ssize_t abx500_chargalg_curr_step_show(struct abx500_chargalg *di,
+					      char *buf)
 {
-	struct abx500_chargalg *di = container_of(kobj,
-               struct abx500_chargalg, chargalg_kobject);
+	return sprintf(buf, "%d\n", di->curr_status.curr_step);
+}
+
+static ssize_t abx500_chargalg_curr_step_store(struct abx500_chargalg *di,
+					       const char *buf, size_t length)
+{
+	long int param;
+	int ret;
+
+	ret = kstrtol(buf, 10, &param);
+	if (ret < 0)
+		return ret;
 
+	di->curr_status.curr_step = param;
+	if (di->curr_status.curr_step >= CHARGALG_CURR_STEP_LOW &&
+		di->curr_status.curr_step <= CHARGALG_CURR_STEP_HIGH) {
+		di->curr_status.curr_step_change = true;
+		queue_work(di->chargalg_wq, &di->chargalg_work);
+	} else
+		dev_info(di->dev, "Wrong current step\n"
+			"Enter 0. Disable AC/USB Charging\n"
+			"1--100. Set AC/USB charging current step\n"
+			"100. Enable AC/USB Charging\n");
+
+	return strlen(buf);
+}
+
+
+static ssize_t abx500_chargalg_en_show(struct abx500_chargalg *di,
+				       char *buf)
+{
 	return sprintf(buf, "%d\n",
 		       di->susp_status.ac_suspended &&
 		       di->susp_status.usb_suspended);
 }
 
-/**
- * abx500_chargalg_sysfs_charger() - sysfs store operations
- * @kobj:      pointer to the struct kobject
- * @attr:      pointer to the struct attribute
- * @buf:       buffer that holds the parameter passed from userspace
- * @length:    length of the parameter passed
- *
- * Returns length of the buffer(input taken from user space) on success
- * else error code on failure
- * The operation to be performed on passing the parameters from the user space.
- */
-static ssize_t abx500_chargalg_sysfs_charger(struct kobject *kobj,
-	struct attribute *attr, const char *buf, size_t length)
+static ssize_t abx500_chargalg_en_store(struct abx500_chargalg *di,
+	const char *buf, size_t length)
 {
-	struct abx500_chargalg *di = container_of(kobj,
-		struct abx500_chargalg, chargalg_kobject);
 	long int param;
 	int ac_usb;
 	int ret;
-	char entry = *attr->name;
 
-	switch (entry) {
-	case 'c':
-		ret = strict_strtol(buf, 10, &param);
-		if (ret < 0)
-			return ret;
-
-		ac_usb = param;
-		switch (ac_usb) {
-		case 0:
-			/* Disable charging */
-			di->susp_status.ac_suspended = true;
-			di->susp_status.usb_suspended = true;
-			di->susp_status.suspended_change = true;
-			/* Trigger a state change */
-			queue_work(di->chargalg_wq,
-				&di->chargalg_work);
-			break;
-		case 1:
-			/* Enable AC Charging */
-			di->susp_status.ac_suspended = false;
-			di->susp_status.suspended_change = true;
-			/* Trigger a state change */
-			queue_work(di->chargalg_wq,
-				&di->chargalg_work);
-			break;
-		case 2:
-			/* Enable USB charging */
-			di->susp_status.usb_suspended = false;
-			di->susp_status.suspended_change = true;
-			/* Trigger a state change */
-			queue_work(di->chargalg_wq,
-				&di->chargalg_work);
-			break;
-		default:
-			dev_info(di->dev, "Wrong input\n"
-				"Enter 0. Disable AC/USB Charging\n"
-				"1. Enable AC charging\n"
-				"2. Enable USB Charging\n");
-		};
+	ret = kstrtol(buf, 10, &param);
+	if (ret < 0)
+		return ret;
+
+	ac_usb = param;
+	switch (ac_usb) {
+	case 0:
+		/* Disable charging */
+		di->susp_status.ac_suspended = true;
+		di->susp_status.usb_suspended = true;
+		di->susp_status.suspended_change = true;
+		/* Trigger a state change */
+		queue_work(di->chargalg_wq,
+			&di->chargalg_work);
+		break;
+	case 1:
+		/* Enable AC Charging */
+		di->susp_status.ac_suspended = false;
+		di->susp_status.suspended_change = true;
+		/* Trigger a state change */
+		queue_work(di->chargalg_wq,
+			&di->chargalg_work);
 		break;
+	case 2:
+		/* Enable USB charging */
+		di->susp_status.usb_suspended = false;
+		di->susp_status.suspended_change = true;
+		/* Trigger a state change */
+		queue_work(di->chargalg_wq,
+			&di->chargalg_work);
+		break;
+	default:
+		dev_info(di->dev, "Wrong input\n"
+			"Enter 0. Disable AC/USB Charging\n"
+			"1. Enable AC charging\n"
+			"2. Enable USB Charging\n");
 	};
 	return strlen(buf);
 }
 
-static struct attribute abx500_chargalg_en_charger = \
+static struct abx500_chargalg_sysfs_entry abx500_chargalg_en_charger =
+	__ATTR(chargalg, 0644, abx500_chargalg_en_show,
+				abx500_chargalg_en_store);
+
+static struct abx500_chargalg_sysfs_entry abx500_chargalg_curr_step =
+	__ATTR(chargalg_curr_step, 0644, abx500_chargalg_curr_step_show,
+					abx500_chargalg_curr_step_store);
+
+static ssize_t abx500_chargalg_sysfs_show(struct kobject *kobj,
+	struct attribute *attr, char *buf)
+{
+	struct abx500_chargalg_sysfs_entry *entry = container_of(attr,
+		struct abx500_chargalg_sysfs_entry, attr);
+
+	struct abx500_chargalg *di = container_of(kobj,
+		struct abx500_chargalg, chargalg_kobject);
+
+	if (!entry->show)
+		return -EIO;
+
+	return entry->show(di, buf);
+}
+
+static ssize_t abx500_chargalg_sysfs_charger(struct kobject *kobj,
+	struct attribute *attr, const char *buf, size_t length)
 {
-	.name = "chargalg",
-	.mode = S_IRUGO | S_IWUSR,
-};
+	struct abx500_chargalg_sysfs_entry *entry = container_of(attr,
+		struct abx500_chargalg_sysfs_entry, attr);
+
+	struct abx500_chargalg *di = container_of(kobj,
+		struct abx500_chargalg, chargalg_kobject);
+
+	if (!entry->store)
+		return -EIO;
+
+	return entry->store(di, buf, length);
+}
 
 static struct attribute *abx500_chargalg_chg[] = {
-	&abx500_chargalg_en_charger,
-	NULL
+	&abx500_chargalg_en_charger.attr,
+	&abx500_chargalg_curr_step.attr,
+	NULL,
 };
 
 static const struct sysfs_ops abx500_chargalg_sysfs_ops = {
@@ -2052,6 +2130,7 @@ static int abx500_chargalg_probe(struct platform_device *pdev)
 		dev_err(di->dev, "failed to create sysfs entry\n");
 		goto free_psy;
 	}
+	di->curr_status.curr_step = CHARGALG_CURR_STEP_HIGH;
 
 	/* Run the charging algorithm */
 	queue_delayed_work(di->chargalg_wq, &di->chargalg_periodic_work, 0);
-- 
1.7.10.4

