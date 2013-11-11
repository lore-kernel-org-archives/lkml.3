Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3KKN5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:57:30 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:61889 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3KKN5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:57:04 -0500
From: Julian Andres Klode <jak@jak-linux.org>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Julian Andres Klode <jak@jak-linux.org>,
        ibm-acpi-devel@lists.sourceforge.net (open list:THINKPAD ACPI EXT...),
        platform-driver-x86@vger.kernel.org (open list:THINKPAD ACPI EXT...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/4] thinkpad_acpi: battery: Add inhibit_charge_minutes attribute
Date: Mon, 11 Nov 2013 14:56:33 +0100
Message-Id: <1384178195-12218-5-git-send-email-jak@jak-linux.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be considered experimental. There seem to be to ways to
inhibit charging, one globally using peak shift state, and one using
a battery-specific inhibit charge command. The latter is implemented
here. Setting a permanent timeout is not supported currently.

Reading the timeout is not supported because the ACPI call needed
to read the value is not documented/reverse-engineered yet.

Signed-off-by: Julian Andres Klode <jak@jak-linux.org>
---
 Documentation/laptops/thinkpad-acpi.txt | 12 ++++++++++++
 drivers/platform/x86/thinkpad_acpi.c    | 34 ++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index 8ec1898..e639f72 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -1378,6 +1378,18 @@ battery sysfs attribute: force_discharge_ac_break
 
 	Break the discharging when the AC disconnects (0 or 1)
 
+battery sysfs attribute: inhibit_charge_minutes
+
+	Inhibit charging for the specified amount of minutes. This attribute
+	may not be very precise, the charging may start again some seconds
+	earlier than requested. It's also write-only until someone figured out
+	how reading that value works.
+
+	Values range: -1 to 720
+
+	The value -1 is supposed to mean permanently.
+
+
 Multiple Commands, Module Parameters
 ------------------------------------
 
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 6b0521a..a9cba4e 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8358,7 +8358,7 @@ static struct ibm_struct fan_driver_data = {
 
 /* Modify battery_init() if you modify them */
 #define BATTERY_MAX_COUNT 3
-#define BATTERY_MAX_ATTRS 4
+#define BATTERY_MAX_ATTRS 5
 
 static struct battery {
 	char name[3 + 1 + 1];
@@ -8518,6 +8518,31 @@ static ssize_t battery_force_discharge_ac_break_store(struct device *dev,
 	return count;
 }
 
+static ssize_t battery_inhibit_charge_minutes_store(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	int bat = battery_attribute_get_battery(attr);
+	int res = -EINVAL;
+	int value;
+
+	res = kstrtoint(buf, 0, &value);
+	if (res || value > 720 || value < -1)
+		return res ? res : -EINVAL;
+
+	if (value == -1)
+		value = 1;
+	else
+		value = (value << 8) | (value & 1);
+
+	value |= (bat << 4);
+
+	if (!hkey_handle || !acpi_evalf(hkey_handle, &res, "BICS",
+					"dd", (int) value) || res < 0)
+		return -EIO;
+	return count;
+}
+
 static int __init battery_init(struct ibm_init_struct *iibm)
 {
 	int res;
@@ -8577,6 +8602,13 @@ static int __init battery_init(struct ibm_init_struct *iibm)
 				       battery_force_discharge_ac_break_store),
 			.var = (void *) (unsigned long) (i + 1)
 		};
+		batteries[i].attributes[j++] = (struct dev_ext_attribute) {
+			.attr = __ATTR(inhibit_charge_minutes,
+				       S_IWUSR,
+				       NULL,
+				       battery_inhibit_charge_minutes_store),
+			.var = (void *) (unsigned long) (i + 1)
+		};
 
 		strncpy(batteries[i].name, "BAT", 3);
 		batteries[i].name[3] = '0' + i;
-- 
1.8.4.2

