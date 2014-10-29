Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbaJ2TSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:18:00 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:64058 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaJ2TR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:17:59 -0400
From: Giedrius Statkevicius <giedriuswork@gmail.com>
To: eric.piel@tremplin-utc.net
Cc: dvhart@infradead.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Giedrius=20Statkevi=C4=8Dius?= <giedriuswork@gmail.com>
Subject: [PATCH] platform: hp_accel: add a i8042 filter to remove HPQ6000 data from kb bus stream
Date: Wed, 29 Oct 2014 21:16:22 +0200
Message-Id: <1414610182-28702-1-git-send-email-giedriuswork@gmail.com>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a i8042 filter to hp_accel to remove accelerometer's data with acpi
id HPQ6000 from keyboard bus stream. The codes sent by accelerometer are
e0 25, e0 26, e0 27 and e0 28. The relevant information is already
passed through /dev/freefall so no need to send these undocumented weird
signals through the keyboard bus. Also, unclogs `dmesg` because atkbd
complained about weird scan codes, saves processing power and disk
space.

Signed-off-by: Giedrius Statkevičius <giedriuswork@gmail.com>
---
First of all, any Tested-Bys are very welcome by people who also have a
accelerometer with acpi id HPQ6000. If it happens with HPQ6007 too we
can easily modify this to install the filter when HPQ6007 is detected.
For the time being the filter is only installed when HPQ6000 is
detected. 

Now moving to what was changed since the RFC. I reworked the filter
function to hopefully make it more clear what it is doing. Since the
codes sent by the accelerometer are extended then we need to filter all
of 0xe0's and then send one 0xe0 back when the actual key isn't in the
range of 0x25-0x28. Also, I've removed the check for errors for
i8042_install_filter() because it's unnecessary to check if it failed.
If multiple HPQ6000's are in the system then no issue occurs even if
multiple i8042_install_filter() are issued because this is handled by
i8042 and it's smart enough not to install the same filter two or more
times.

 drivers/platform/x86/hp_accel.c | 45 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index 13e14ec..a751621 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -38,6 +38,8 @@
 #include <linux/atomic.h>
 #include <linux/acpi.h>
 #include "../../misc/lis3lv02d/lis3lv02d.h"
+#include <linux/i8042.h>
+#include <linux/serio.h>
 
 #define DRIVER_NAME     "hp_accel"
 #define ACPI_MDPS_CLASS "accelerometer"
@@ -73,6 +75,13 @@ static inline void delayed_sysfs_set(struct led_classdev *led_cdev,
 
 /* HP-specific accelerometer driver ------------------------------------ */
 
+/* e0 25, e0 26, e0 27, e0 28 are scan codes that the accelerometer with acpi id
+ * HPQ6000 sends through the keyboard bus */
+#define ACCEL_1 0x25
+#define ACCEL_2 0x26
+#define ACCEL_3 0x27
+#define ACCEL_4 0x28
+
 /* For automatic insertion of the module */
 static const struct acpi_device_id lis3lv02d_device_ids[] = {
 	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
@@ -82,7 +91,6 @@ static const struct acpi_device_id lis3lv02d_device_ids[] = {
 };
 MODULE_DEVICE_TABLE(acpi, lis3lv02d_device_ids);
 
-
 /**
  * lis3lv02d_acpi_init - ACPI _INI method: initialize the device.
  * @lis3: pointer to the device struct
@@ -294,6 +302,35 @@ static void lis3lv02d_enum_resources(struct acpi_device *device)
 		printk(KERN_DEBUG DRIVER_NAME ": Error getting resources\n");
 }
 
+static bool hp_accel_i8042_filter(unsigned char data, unsigned char str,
+				  struct serio *port)
+{
+	static bool extended;
+
+	if (str & I8042_STR_AUXDATA)
+		return false;
+
+	if (data == 0xe0) {
+		extended = true;
+		return true;
+	} else if (unlikely(extended)) {
+		extended = false;
+
+		switch (data) {
+		case ACCEL_1:
+		case ACCEL_2:
+		case ACCEL_3:
+		case ACCEL_4:
+			return true;
+		default:
+			serio_interrupt(port, 0xe0, 0);
+			return false;
+		}
+	}
+
+	return false;
+}
+
 static int lis3lv02d_add(struct acpi_device *device)
 {
 	int ret;
@@ -326,6 +363,11 @@ static int lis3lv02d_add(struct acpi_device *device)
 	if (ret)
 		return ret;
 
+	/* filter to remove HPQ6000 accelerometer data
+	 * from keyboard bus stream */
+	if (strstr(dev_name(&device->dev), "HPQ6000"))
+		i8042_install_filter(hp_accel_i8042_filter);
+
 	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
 	ret = led_classdev_register(NULL, &hpled_led.led_classdev);
 	if (ret) {
@@ -343,6 +385,7 @@ static int lis3lv02d_remove(struct acpi_device *device)
 	if (!device)
 		return -EINVAL;
 
+	i8042_remove_filter(hp_accel_i8042_filter);
 	lis3lv02d_joystick_disable(&lis3_dev);
 	lis3lv02d_poweroff(&lis3_dev);
 
-- 
2.1.2

