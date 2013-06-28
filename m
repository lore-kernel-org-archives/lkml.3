Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3F1Q1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:27:30 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40117 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab3F1Q12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:27:28 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH v3 06/10] ACPI: introduce helper function acpi_execute_simple_method()
Date: Sat, 29 Jun 2013 00:24:39 +0800
Message-Id: <1372436683-31711-7-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
References: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Introduce helper function acpi_execute_simple_method() to simplify code.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/battery.c  |  8 ++------
 drivers/acpi/bus.c      |  6 +-----
 drivers/acpi/power.c    |  4 +---
 drivers/acpi/sleep.c    |  7 ++-----
 drivers/acpi/thermal.c  | 18 ++++--------------
 drivers/acpi/utils.c    | 12 ++++++++++++
 drivers/acpi/video.c    | 17 +++++------------
 include/acpi/acpi_bus.h |  2 ++
 8 files changed, 29 insertions(+), 45 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index a762716..74669ac 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -525,18 +525,14 @@ static int acpi_battery_get_state(struct acpi_battery *battery)
 static int acpi_battery_set_alarm(struct acpi_battery *battery)
 {
 	acpi_status status = 0;
-	union acpi_object arg0 = { .type = ACPI_TYPE_INTEGER };
-	struct acpi_object_list arg_list = { 1, &arg0 };
 
 	if (!acpi_battery_present(battery) ||
 	    !test_bit(ACPI_BATTERY_ALARM_PRESENT, &battery->flags))
 		return -ENODEV;
 
-	arg0.integer.value = battery->alarm;
-
 	mutex_lock(&battery->lock);
-	status = acpi_evaluate_object(battery->device->handle, "_BTP",
-				 &arg_list, NULL);
+	status = acpi_execute_simple_method(battery->device->handle, "_BTP",
+					    battery->alarm);
 	mutex_unlock(&battery->lock);
 
 	if (ACPI_FAILURE(status))
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index a5bb33b..a5a032e 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -593,8 +593,6 @@ static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
 static int __init acpi_bus_init_irq(void)
 {
 	acpi_status status;
-	union acpi_object arg = { ACPI_TYPE_INTEGER };
-	struct acpi_object_list arg_list = { 1, &arg };
 	char *message = NULL;
 
 
@@ -623,9 +621,7 @@ static int __init acpi_bus_init_irq(void)
 
 	printk(KERN_INFO PREFIX "Using %s for interrupt routing\n", message);
 
-	arg.integer.value = acpi_irq_model;
-
-	status = acpi_evaluate_object(NULL, "\\_PIC", &arg_list, NULL);
+	status = acpi_execute_simple_method(NULL, "\\_PIC", acpi_irq_model);
 	if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND)) {
 		ACPI_EXCEPTION((AE_INFO, status, "Evaluating _PIC"));
 		return -ENODEV;
diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 288bb27..e59ad13 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -637,9 +637,7 @@ int acpi_device_sleep_wake(struct acpi_device *dev,
 	}
 
 	/* Execute _PSW */
-	arg_list.count = 1;
-	in_arg[0].integer.value = enable;
-	status = acpi_evaluate_object(dev->handle, "_PSW", &arg_list, NULL);
+	status = acpi_execute_simple_method(dev->handle, "_PSW", enable);
 	if (ACPI_FAILURE(status) && (status != AE_NOT_FOUND)) {
 		printk(KERN_ERR PREFIX "_PSW execution failed\n");
 		dev->wakeup.flags.valid = 0;
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 187ab61..81b0f03 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -31,12 +31,9 @@ static u8 sleep_states[ACPI_S_STATE_COUNT];
 
 static void acpi_sleep_tts_switch(u32 acpi_state)
 {
-	union acpi_object in_arg = { ACPI_TYPE_INTEGER };
-	struct acpi_object_list arg_list = { 1, &in_arg };
-	acpi_status status = AE_OK;
+	acpi_status status;
 
-	in_arg.integer.value = acpi_state;
-	status = acpi_evaluate_object(NULL, "\\_TTS", &arg_list, NULL);
+	status = acpi_execute_simple_method(NULL, "\\_TTS", acpi_state);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		/*
 		 * OS can't evaluate the _TTS object correctly. Some warning
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index a33821c..94523c7 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -239,26 +239,16 @@ static int acpi_thermal_get_polling_frequency(struct acpi_thermal *tz)
 
 static int acpi_thermal_set_cooling_mode(struct acpi_thermal *tz, int mode)
 {
-	acpi_status status = AE_OK;
-	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
-	struct acpi_object_list arg_list = { 1, &arg0 };
-	acpi_handle handle = NULL;
-
-
 	if (!tz)
 		return -EINVAL;
 
-	status = acpi_get_handle(tz->device->handle, "_SCP", &handle);
-	if (ACPI_FAILURE(status)) {
+	if (!acpi_has_method(tz->device->handle, "_SCP")) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "_SCP not present\n"));
 		return -ENODEV;
-	}
-
-	arg0.integer.value = mode;
-
-	status = acpi_evaluate_object(handle, NULL, &arg_list, NULL);
-	if (ACPI_FAILURE(status))
+	} else if (ACPI_FAILURE(acpi_execute_simple_method(tz->device->handle,
+							   "_SCP", mode))) {
 		return -ENODEV;
+	}
 
 	return 0;
 }
diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index b08d973..87b8588 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -510,3 +510,15 @@ bool acpi_has_method(acpi_handle handle, char *name)
 	return ACPI_SUCCESS(acpi_get_handle(handle, name, &tmp));
 }
 EXPORT_SYMBOL(acpi_has_method);
+
+acpi_status acpi_execute_simple_method(acpi_handle handle, char *method,
+				       u64 arg)
+{
+	union acpi_object obj = { .type = ACPI_TYPE_INTEGER };
+	struct acpi_object_list arg_list = { .count = 1, .pointer = &obj, };
+
+	obj.integer.value = arg;
+
+	return acpi_evaluate_object(handle, method, &arg_list, NULL);
+}
+EXPORT_SYMBOL(acpi_execute_simple_method);
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index a84533e..b862c7f 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -353,14 +353,10 @@ static int
 acpi_video_device_lcd_set_level(struct acpi_video_device *device, int level)
 {
 	int status;
-	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
-	struct acpi_object_list args = { 1, &arg0 };
 	int state;
 
-	arg0.integer.value = level;
-
-	status = acpi_evaluate_object(device->dev->handle, "_BCM",
-				      &args, NULL);
+	status = acpi_execute_simple_method(device->dev->handle,
+					    "_BCM", level);
 	if (ACPI_FAILURE(status)) {
 		ACPI_ERROR((AE_INFO, "Evaluating _BCM failed"));
 		return -EIO;
@@ -628,18 +624,15 @@ static int
 acpi_video_bus_DOS(struct acpi_video_bus *video, int bios_flag, int lcd_flag)
 {
 	acpi_status status;
-	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
-	struct acpi_object_list args = { 1, &arg0 };
 
 	if (!video->cap._DOS)
 		return 0;
 
 	if (bios_flag < 0 || bios_flag > 3 || lcd_flag < 0 || lcd_flag > 1)
 		return -EINVAL;
-	arg0.integer.value = (lcd_flag << 2) | bios_flag;
-	video->dos_setting = arg0.integer.value;
-	status = acpi_evaluate_object(video->device->handle, "_DOS",
-		&args, NULL);
+	video->dos_setting = (lcd_flag << 2) | bios_flag;
+	status = acpi_execute_simple_method(video->device->handle, "_DOS",
+					    (lcd_flag << 2) | bios_flag);
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 503b1b7..d3d5fc1 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -58,6 +58,8 @@ acpi_status
 acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld);
 
 bool acpi_has_method(acpi_handle handle, char *name);
+acpi_status acpi_execute_simple_method(acpi_handle handle, char *method,
+				       u64 arg);
 
 #ifdef CONFIG_ACPI
 
-- 
1.8.1.2

