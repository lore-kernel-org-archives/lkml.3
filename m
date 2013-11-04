Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3KDViZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 16:38:25 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:35139 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3KDViY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 16:38:24 -0500
From: Julian Andres Klode <jak@jak-linux.org>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Julian Andres Klode <jak@jak-linux.org>,
        ibm-acpi-devel@lists.sourceforge.net (open list:THINKPAD ACPI EXT...),
        platform-driver-x86@vger.kernel.org (open list:THINKPAD ACPI EXT...),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH] thinkpad_acpi: Add support for controlling charge thresholds
Date: Mon,  4 Nov 2013 22:38:08 +0100
Message-Id: <1383601088-21177-1-git-send-email-jak@jak-linux.org>
X-Mailer: git-send-email 1.8.4.2
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
Does this look OK so far? There are some other things I want to add
(force_discharge and others), but I thought I'd gather some comments
in case I'm doing it all wrong...

I'm slightly abusing struct dev_ext_attribute here, as I'm storing the
battery number in the 'var' pointer.

Note that I export the batteries starting at BAT0, but the EC starts
counting at 1 (0 is reserved for setting all batteries at once, but
that functionality is not provided here).

 drivers/platform/x86/thinkpad_acpi.c | 158 +++++++++++++++++++++++++++++++++++
 1 file changed, 158 insertions(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 03ca6c1..1e17222 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -528,6 +528,12 @@ static acpi_handle ec_handle;
 TPACPI_HANDLE(ecrd, ec, "ECRD");	/* 570 */
 TPACPI_HANDLE(ecwr, ec, "ECWR");	/* 570 */
 
+TPACPI_HANDLE(battery, root, "\\_SB.PCI0.LPC.EC.HKEY",
+	   "\\_SB.PCI0.LPCB.EC.HKEY",		/* X121e, T430u */
+	   "\\_SB.PCI0.LPCB.H_EC.HKEY",		/* L430 */
+	   "\\_SB.PCI0.LPCB.EC0.HKEY",		/* Edge/S series */
+	   );
+
 TPACPI_HANDLE(cmos, root, "\\UCMS",	/* R50, R50e, R50p, R51, */
 					/* T4x, X31, X40 */
 	   "\\CMOS",		/* A3x, G4x, R32, T23, T30, X22-24, X30 */
@@ -8350,6 +8356,154 @@ static struct ibm_struct fan_driver_data = {
 	.resume = fan_resume,
 };
 
+
+/*************************************************************************
+ * Battery subdriver
+ */
+
+/* Define a new battery, _BAT is a number >= 0 */
+#define DEFINE_BATTERY(_BAT) \
+static struct dev_ext_attribute bat##_BAT##_attribute_start_charge_thresh = { \
+	.attr = __ATTR(start_charge_tresh, (S_IWUSR | S_IRUGO), \
+		       battery_start_charge_thresh_show, \
+		       battery_start_charge_thresh_store), \
+	.var = (void *) (_BAT + 1) \
+}; \
+static struct dev_ext_attribute bat##_BAT##_attribute_stop_charge_thresh = { \
+	.attr = __ATTR(stop_charge_tresh, (S_IWUSR | S_IRUGO), \
+		       battery_stop_charge_thresh_show, \
+		       battery_stop_charge_thresh_store), \
+	.var = (void *) (_BAT + 1) \
+}; \
+static struct attribute *bat##_BAT##_attributes[] = { \
+	&bat##_BAT##_attribute_start_charge_thresh.attr.attr, \
+	&bat##_BAT##_attribute_stop_charge_thresh.attr.attr, \
+	NULL \
+}; \
+\
+static struct attribute_group bat##_BAT##_attribute_group = { \
+	.name  = "BAT" #_BAT, \
+	.attrs = bat##_BAT##_attributes \
+};
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
+	if (!battery_handle || !acpi_evalf(battery_handle, &res, "BCCS",
+					   "dd", (int) value | (bat << 8)))
+		return -EIO;
+
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
+	if (!battery_handle || !acpi_evalf(battery_handle, &res, "BCSS",
+					   "dd", (int) value | (bat << 8)))
+		return -EIO;
+
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
+	if (!battery_handle || !acpi_evalf(battery_handle, &value, "BCTG",
+					   "dd", bat))
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
+	if (!battery_handle || !acpi_evalf(battery_handle, &value, "BCSG",
+					   "dd", bat))
+		return -EIO;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", value & 0xFF);
+}
+
+DEFINE_BATTERY(0);
+DEFINE_BATTERY(1);
+
+static struct attribute_group *bat_attribute_groups[] = {
+	&bat0_attribute_group,
+	&bat1_attribute_group,
+};
+
+static int __init battery_init(struct ibm_init_struct *iibm)
+{
+	int res;
+	int i;
+
+	vdbg_printk(TPACPI_DBG_INIT,
+		"initializing battery commands subdriver\n");
+
+	TPACPI_ACPIHANDLE_INIT(battery);
+
+	vdbg_printk(TPACPI_DBG_INIT, "battery commands are %s\n",
+		str_supported(battery_handle != NULL));
+
+	for (i = 0; i < ARRAY_SIZE(bat_attribute_groups); i++) {
+		res = sysfs_create_group(&tpacpi_pdev->dev.kobj,
+					 bat_attribute_groups[i]);
+		if (res)
+			return res;
+	}
+
+	return (battery_handle) ? 0 : 1;
+}
+
+static void battery_exit(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(bat_attribute_groups); i++)
+		sysfs_remove_group(&tpacpi_pdev->dev.kobj,
+				   bat_attribute_groups[i]);
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
@@ -8741,6 +8895,10 @@ static struct ibm_init_struct ibms_init[] __initdata = {
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

