Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3KKN5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:57:24 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:38755 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab3KKN47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:56:59 -0500
From: Julian Andres Klode <jak@jak-linux.org>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Julian Andres Klode <jak@jak-linux.org>,
        ibm-acpi-devel@lists.sourceforge.net (open list:THINKPAD ACPI EXT...),
        platform-driver-x86@vger.kernel.org (open list:THINKPAD ACPI EXT...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/4] thinkpad_acpi: battery: Add force_discharge_ac_break attribute
Date: Mon, 11 Nov 2013 14:56:32 +0100
Message-Id: <1384178195-12218-4-git-send-email-jak@jak-linux.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tells the EC to stop a forceful discharging if the AC is disconnected. First
needs force_discharge set to 1 to be able to work.  Actual functionality is
untested, as that attribute is not supported on an X230.

Signed-off-by: Julian Andres Klode <jak@jak-linux.org>
---
 Documentation/laptops/thinkpad-acpi.txt |  4 +++
 drivers/platform/x86/thinkpad_acpi.c    | 50 ++++++++++++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index 72882bb..8ec1898 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -1374,6 +1374,10 @@ battery sysfs attribute: force_discharge
 
 	Force discharging (0 or 1)
 
+battery sysfs attribute: force_discharge_ac_break
+
+	Break the discharging when the AC disconnects (0 or 1)
+
 Multiple Commands, Module Parameters
 ------------------------------------
 
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 67ce469..6b0521a 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8358,7 +8358,7 @@ static struct ibm_struct fan_driver_data = {
 
 /* Modify battery_init() if you modify them */
 #define BATTERY_MAX_COUNT 3
-#define BATTERY_MAX_ATTRS 3
+#define BATTERY_MAX_ATTRS 4
 
 static struct battery {
 	char name[3 + 1 + 1];
@@ -8477,6 +8477,47 @@ static ssize_t battery_force_discharge_store(struct device *dev,
 	return count;
 }
 
+static ssize_t battery_force_discharge_ac_break_show(struct device *dev,
+						struct device_attribute *attr,
+						char *buf)
+{
+	int bat = battery_attribute_get_battery(attr);
+	int value;
+
+	if (!hkey_handle || !acpi_evalf(hkey_handle, &value, "BDSG",
+					"dd", bat))
+		return -EIO;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", (value >> 1) & 0x1);
+}
+
+static ssize_t battery_force_discharge_ac_break_store(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	int bat = battery_attribute_get_battery(attr);
+	int res = -EINVAL;
+	unsigned long value;
+
+	res = kstrtoul(buf, 0, &value);
+	if (res || value > 1)
+		return res ? res : -EINVAL;
+
+	if (!hkey_handle || !acpi_evalf(hkey_handle, &res, "BDSG", "dd", bat))
+		return -EIO;
+
+	/* Move into the right position */
+	value <<= 1;
+	/* Keep the forcedness state */
+	value |= (res) & 0x1;
+	/* Set the battery */
+	value |= (bat << 8);
+	if (!hkey_handle || !acpi_evalf(hkey_handle, &res, "BDSS",
+					"dd", (int) value) || res < 0)
+		return -EIO;
+	return count;
+}
+
 static int __init battery_init(struct ibm_init_struct *iibm)
 {
 	int res;
@@ -8529,6 +8570,13 @@ static int __init battery_init(struct ibm_init_struct *iibm)
 				       battery_force_discharge_store),
 			.var = (void *) (unsigned long) (i + 1)
 		};
+		batteries[i].attributes[j++] = (struct dev_ext_attribute) {
+			.attr = __ATTR(force_discharge_ac_break,
+				       S_IWUSR | S_IRUGO,
+				       battery_force_discharge_ac_break_show,
+				       battery_force_discharge_ac_break_store),
+			.var = (void *) (unsigned long) (i + 1)
+		};
 
 		strncpy(batteries[i].name, "BAT", 3);
 		batteries[i].name[3] = '0' + i;
-- 
1.8.4.2

