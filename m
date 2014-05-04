Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaEDGHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 02:07:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:61809 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaEDGHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 02:07:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,980,1389772800"; 
   d="scan'208";a="525643604"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, lenb@kernel.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI/Battery: Accelerate battery resume callback
Date: Sun,  4 May 2014 14:07:06 +0800
Message-Id: <1399183626-13152-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most time of battery resume callback is spent on executing AML code
_BTP, _BIF and _BIF to get battery info, status and set alarm. These
AML methods may access EC operation regions several times and consumes
time.

These operations are not necessary during devices resume and can run
during POST_SUSPEND/HIBERNATION event when all processes are thawed.

This also can avoid removing and adding battery sysfs nodes every system
resume even if the battery unit is not actually changed. The original code
updates sysfs nodes without check and this seems not reasonable.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
This patch is to base on the linux pm tree linux-next branch with
patches "ACPI: Revert "ACPI / Battery: Remove battery's proc directory""
and "ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"".

 drivers/acpi/battery.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 6e7b2a1..3b4921e 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -696,7 +696,7 @@ static void acpi_battery_quirks(struct acpi_battery *battery)
 	}
 }
 
-static int acpi_battery_update(struct acpi_battery *battery)
+static int acpi_battery_update(struct acpi_battery *battery, bool resume)
 {
 	int result, old_present = acpi_battery_present(battery);
 	result = acpi_battery_get_status(battery);
@@ -707,6 +707,10 @@ static int acpi_battery_update(struct acpi_battery *battery)
 		battery->update_time = 0;
 		return 0;
 	}
+
+	if (resume)
+		return 0;
+
 	if (!battery->update_time ||
 	    old_present != acpi_battery_present(battery)) {
 		result = acpi_battery_get_info(battery);
@@ -915,7 +919,7 @@ static print_func acpi_print_funcs[ACPI_BATTERY_NUMFILES] = {
 static int acpi_battery_read(int fid, struct seq_file *seq)
 {
 	struct acpi_battery *battery = seq->private;
-	int result = acpi_battery_update(battery);
+	int result = acpi_battery_update(battery, false);
 	return acpi_print_funcs[fid](seq, result);
 }
 
@@ -1030,7 +1034,7 @@ static void acpi_battery_notify(struct acpi_device *device, u32 event)
 	old = battery->bat.dev;
 	if (event == ACPI_BATTERY_NOTIFY_INFO)
 		acpi_battery_refresh(battery);
-	acpi_battery_update(battery);
+	acpi_battery_update(battery, false);
 	acpi_bus_generate_netlink_event(device->pnp.device_class,
 					dev_name(&device->dev), event,
 					acpi_battery_present(battery));
@@ -1045,13 +1049,27 @@ static int battery_notify(struct notifier_block *nb,
 {
 	struct acpi_battery *battery = container_of(nb, struct acpi_battery,
 						    pm_nb);
+	int result;
+
 	switch (mode) {
 	case PM_POST_HIBERNATION:
 	case PM_POST_SUSPEND:
-		if (battery->bat.dev) {
-			sysfs_remove_battery(battery);
-			sysfs_add_battery(battery);
-		}
+		if (!acpi_battery_present(battery))
+			return 0;
+
+		if (!battery->bat.dev) {
+			result = acpi_battery_get_info(battery);
+			if (result)
+				return result;
+
+			result = sysfs_add_battery(battery);
+			if (result)
+				return result;
+		} else
+			acpi_battery_refresh(battery);
+
+		acpi_battery_init_alarm(battery);
+		acpi_battery_get_state(battery);
 		break;
 	}
 
@@ -1087,7 +1105,7 @@ static int acpi_battery_add(struct acpi_device *device)
 	mutex_init(&battery->sysfs_lock);
 	if (acpi_has_method(battery->device->handle, "_BIX"))
 		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
-	result = acpi_battery_update(battery);
+	result = acpi_battery_update(battery, false);
 	if (result)
 		goto fail;
 #ifdef CONFIG_ACPI_PROCFS_POWER
@@ -1149,7 +1167,7 @@ static int acpi_battery_resume(struct device *dev)
 		return -EINVAL;
 
 	battery->update_time = 0;
-	acpi_battery_update(battery);
+	acpi_battery_update(battery, true);
 	return 0;
 }
 #else
-- 
1.8.3.1

