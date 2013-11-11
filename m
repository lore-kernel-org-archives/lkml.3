Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab3KKN5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:57:14 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:49048 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab3KKN4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:56:50 -0500
From: Julian Andres Klode <jak@jak-linux.org>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Julian Andres Klode <jak@jak-linux.org>,
        ibm-acpi-devel@lists.sourceforge.net (open list:THINKPAD ACPI EXT...),
        platform-driver-x86@vger.kernel.org (open list:THINKPAD ACPI EXT...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/4] thinkpad_acpi: Add support for controlling charge thresholds
Date: Mon, 11 Nov 2013 14:56:30 +0100
Message-Id: <1384178195-12218-2-git-send-email-jak@jak-linux.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for battery charge thresholds in new Sandy Bridge and Ivy Bridge
ThinkPads. Based on the unofficial documentation in tpacpi-bat.

The threshold files support the values '0' for the controller's default,
and 1-99 as percentages. Values outside of that range are rejected. The
behaviour of '0' might be confusing, especially for the stop case where
it basically seems to mean '100'.

Signed-off-by: Julian Andres Klode <jak@jak-linux.org>
---
 Documentation/laptops/thinkpad-acpi.txt |  17 ++++
 drivers/platform/x86/thinkpad_acpi.c    | 173 ++++++++++++++++++++++++++++++++
 2 files changed, 190 insertions(+)

diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index 86c5236..97b150a 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -46,6 +46,7 @@ detailed description):
 	- Fan control and monitoring: fan speed, fan enable/disable
 	- WAN enable and disable
 	- UWB enable and disable
+	- Charging control
 
 A compatibility table by model and feature is maintained on the web
 site, http://ibm-acpi.sf.net/. I appreciate any success or failure
@@ -1352,6 +1353,22 @@ Sysfs notes:
 	rfkill controller switch "tpacpi_uwb_sw": refer to
 	Documentation/rfkill.txt for details.
 
+Charging control
+----------------
+sysfs attribute groups: BAT0, BAT1, and so on, depending on how many batteries
+are supported by the embedded controller.
+
+This feature controls the battery charging process.
+
+battery sysfs attribute: start_charge_thresh
+
+	A percentage value from 1-99%, controlling when charging should start, or
+	0 for the default value.
+
+battery sysfs attribute: stop_charge_thresh
+
+	A percentage value from 1-99%, controlling when charging should stop, or
+	0 for the default value.
 
 Multiple Commands, Module Parameters
 ------------------------------------
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 03ca6c1..66e629e 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -323,6 +323,7 @@ static struct {
 	u32 sensors_pdrv_attrs_registered:1;
 	u32 sensors_pdev_attrs_registered:1;
 	u32 hotkey_poll_active:1;
+	u32 battery:1;
 } tp_features;
 
 static struct {
@@ -8350,6 +8351,174 @@ static struct ibm_struct fan_driver_data = {
 	.resume = fan_resume,
 };
 
+
+/*************************************************************************
+ * Battery subdriver
+ */
+
+/* Modify battery_init() if you modify them */
+#define BATTERY_MAX_COUNT 3
+#define BATTERY_MAX_ATTRS 2
+
+static struct battery {
+	char name[3 + 1 + 1];
+	struct attribute_set *set;
+	struct dev_ext_attribute attributes[BATTERY_MAX_ATTRS];
+} batteries[BATTERY_MAX_COUNT];
+
+static int battery_attribute_get_battery(struct device_attribute *attr)
+{
+	return (int) (unsigned long) container_of(attr,
+						  struct dev_ext_attribute,
+						  attr)->var;
+}
+
+static ssize_t battery_start_charge_thresh_store(struct device *dev,
+						 struct device_attribute *attr,
+						 const char *buf, size_t count)
+{
+	int bat = battery_attribute_get_battery(attr);
+	int res = -EINVAL;
+	unsigned long value;
+
+	res = kstrtoul(buf, 0, &value);
+	if (res || value > 99)
+		return res ? res : -EINVAL;
+
+	if (!hkey_handle || !acpi_evalf(hkey_handle, &res, "BCCS", "dd",
+					(int) value | (bat << 8)) || res < 0)
+		return -EIO;
+	return count;
+}
+
+static ssize_t battery_stop_charge_thresh_store(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	int bat = battery_attribute_get_battery(attr);
+	int res = -EINVAL;
+	unsigned long value;
+
+	res = kstrtoul(buf, 0, &value);
+	if (res || value > 99)
+		return res ? res : -EINVAL;
+
+	if (!hkey_handle || !acpi_evalf(hkey_handle, &res, "BCSS", "dd",
+					(int) value | (bat << 8)) || res < 0)
+		return -EIO;
+	return count;
+}
+
+static ssize_t battery_start_charge_thresh_show(struct device *dev,
+						struct device_attribute *attr,
+						char *buf)
+{
+	int bat = battery_attribute_get_battery(attr);
+	int value;
+
+	if (!hkey_handle || !acpi_evalf(hkey_handle, &value, "BCTG",
+					"dd", bat))
+		return -EIO;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", value & 0xFF);
+}
+
+static ssize_t battery_stop_charge_thresh_show(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	int bat = battery_attribute_get_battery(attr);
+	int value;
+
+	if (!hkey_handle || !acpi_evalf(hkey_handle, &value, "BCSG",
+					"dd", bat))
+		return -EIO;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", value & 0xFF);
+}
+
+static int __init battery_init(struct ibm_init_struct *iibm)
+{
+	int res;
+	int i;
+	int state;
+
+	vdbg_printk(TPACPI_DBG_INIT,
+		    "initializing battery commands subdriver\n");
+
+	TPACPI_ACPIHANDLE_INIT(hkey);
+
+	/* Check whether getter for start threshold exists */
+	tp_features.battery = hkey_handle &&
+	    acpi_evalf(hkey_handle, &state, "BCTG", "qdd", 1);
+
+	vdbg_printk(TPACPI_DBG_INIT, "battery commands are %s\n",
+		    str_supported(tp_features.battery));
+
+	if (!tp_features.battery)
+		return 1;
+
+	for (i = 0; i < BATTERY_MAX_COUNT; i++) {
+		int j = 0;
+		if (!acpi_evalf(hkey_handle, &state, "BCTG", "qdd", i + 1))
+			continue;
+		/* If the sign bit was set, we could not get the start charge
+		 * threshold of that battery. Let's assume that this battery
+		 * (and all following ones) do not exist */
+		if (state < 0)
+			break;
+		/* Modify BATTERY_MAX_ATTRS if you add an attribute */
+		batteries[i].attributes[j++] = (struct dev_ext_attribute) {
+			.attr = __ATTR(start_charge_tresh,
+				       S_IWUSR | S_IRUGO,
+				       battery_start_charge_thresh_show,
+				       battery_start_charge_thresh_store),
+			.var = (void *) (unsigned long) (i + 1)
+		};
+		batteries[i].attributes[j++] = (struct dev_ext_attribute) {
+			.attr = __ATTR(stop_charge_tresh,
+				       S_IWUSR | S_IRUGO,
+				       battery_stop_charge_thresh_show,
+				       battery_stop_charge_thresh_store),
+			.var = (void *) (unsigned long) (i + 1)
+		};
+
+		strncpy(batteries[i].name, "BAT", 3);
+		batteries[i].name[3] = '0' + i;
+		batteries[i].name[4] = '\0';
+		batteries[i].set = create_attr_set(j - 1, batteries[i].name);
+
+		for (j = j - 1; j >= 0; j--)
+			add_to_attr_set(batteries[i].set,
+					&batteries[i].attributes[j].attr.attr);
+
+		res = register_attr_set_with_sysfs(batteries[i].set,
+						   &tpacpi_pdev->dev.kobj);
+
+		if (res)
+			return res;
+	}
+
+	return 0;
+}
+
+static void battery_exit(void)
+{
+	int i;
+
+	for (i = 0; i < BATTERY_MAX_COUNT; i++) {
+		if (batteries[i].set != NULL) {
+			delete_attr_set(batteries[i].set,
+					&tpacpi_pdev->dev.kobj);
+		}
+	}
+}
+
+static struct ibm_struct battery_driver_data = {
+	.name = "battery",
+	.exit = battery_exit,
+};
+
 /****************************************************************************
  ****************************************************************************
  *
@@ -8741,6 +8910,10 @@ static struct ibm_init_struct ibms_init[] __initdata = {
 		.data = &light_driver_data,
 	},
 	{
+		.init = battery_init,
+		.data = &battery_driver_data,
+	},
+	{
 		.init = cmos_init,
 		.data = &cmos_driver_data,
 	},
-- 
1.8.4.2

