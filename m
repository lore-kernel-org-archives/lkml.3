Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbaLDRAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:00:06 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33338 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313AbaLDRAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:00:04 -0500
From: Nishanth Menon <nm@ti.com>
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
CC: <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH] hwmon: (gpio-fan) Allow usage of gpio operations that may sleep
Date: Thu, 4 Dec 2014 10:58:47 -0600
Message-ID: <1417712328-29831-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain I2C based GPIO expanders could be used in sleepable context,
this results in:
[  115.890569] ------------[ cut here ]------------
[  115.895422] WARNING: CPU: 0 PID: 1115 at drivers/gpio/gpiolib.c:1370 gpiod_set_raw_value+0x40/0x4c()
[  115.905024] Modules linked in:
[  115.908229] CPU: 0 PID: 1115 Comm: sh Tainted: G        W      3.18.0-rc7-next-20141203-dirty #1
[  115.917461] Hardware name: Generic DRA74X (Flattened Device Tree)
[  115.923876] [<c0015368>] (unwind_backtrace) from [<c00119f4>] (show_stack+0x10/0x14)
[  115.932013] [<c00119f4>] (show_stack) from [<c05b78e8>] (dump_stack+0x78/0x94)
[  115.939594] [<c05b78e8>] (dump_stack) from [<c003de28>] (warn_slowpath_common+0x7c/0xb4)
[  115.948094] [<c003de28>] (warn_slowpath_common) from [<c003de7c>] (warn_slowpath_null+0x1c/0x24)
[  115.957315] [<c003de7c>] (warn_slowpath_null) from [<c03461e8>] (gpiod_set_raw_value+0x40/0x4c)
[  115.966457] [<c03461e8>] (gpiod_set_raw_value) from [<c04866f4>] (set_fan_speed+0x4c/0x64)
[  115.975145] [<c04866f4>] (set_fan_speed) from [<c04868a8>] (set_rpm+0x98/0xac)
[  115.982742] [<c04868a8>] (set_rpm) from [<c039fb4c>] (dev_attr_store+0x18/0x24)
[  115.990426] [<c039fb4c>] (dev_attr_store) from [<c01b0a28>] (sysfs_kf_write+0x4c/0x50)
[  115.998742] [<c01b0a28>] (sysfs_kf_write) from [<c01afe1c>] (kernfs_fop_write+0xbc/0x19c)
[  116.007333] [<c01afe1c>] (kernfs_fop_write) from [<c0148cc4>] (vfs_write+0xb0/0x1a0)
[  116.015461] [<c0148cc4>] (vfs_write) from [<c0148fbc>] (SyS_write+0x44/0x84)
[  116.022881] [<c0148fbc>] (SyS_write) from [<c000e5c0>] (ret_fast_syscall+0x0/0x48)
[  116.030833] ---[ end trace 3a0b636123acab82 ]---

So, switch over to sleepable GPIO operations as there is no mandatory
need for non-sleepable gpio operations in the fan driver.

This allows the fan driver to be used with i2c based gpio expanders such
as palmas_gpio.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
based on next-20141204 , but can rebase to required branch as needed.
 drivers/hwmon/gpio-fan.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 4efa173..7802eb2 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -79,7 +79,7 @@ static ssize_t show_fan_alarm(struct device *dev,
 {
 	struct gpio_fan_data *fan_data = dev_get_drvdata(dev);
 	struct gpio_fan_alarm *alarm = fan_data->alarm;
-	int value = gpio_get_value(alarm->gpio);
+	int value = gpio_get_value_cansleep(alarm->gpio);
 
 	if (alarm->active_low)
 		value = !value;
@@ -131,7 +131,7 @@ static void __set_fan_ctrl(struct gpio_fan_data *fan_data, int ctrl_val)
 	int i;
 
 	for (i = 0; i < fan_data->num_ctrl; i++)
-		gpio_set_value(fan_data->ctrl[i], (ctrl_val >> i) & 1);
+		gpio_set_value_cansleep(fan_data->ctrl[i], (ctrl_val >> i) & 1);
 }
 
 static int __get_fan_ctrl(struct gpio_fan_data *fan_data)
@@ -142,7 +142,7 @@ static int __get_fan_ctrl(struct gpio_fan_data *fan_data)
 	for (i = 0; i < fan_data->num_ctrl; i++) {
 		int value;
 
-		value = gpio_get_value(fan_data->ctrl[i]);
+		value = gpio_get_value_cansleep(fan_data->ctrl[i]);
 		ctrl_val |= (value << i);
 	}
 	return ctrl_val;
@@ -369,7 +369,8 @@ static int fan_ctrl_init(struct gpio_fan_data *fan_data,
 		if (err)
 			return err;
 
-		err = gpio_direction_output(ctrl[i], gpio_get_value(ctrl[i]));
+		err = gpio_direction_output(ctrl[i],
+					    gpio_get_value_cansleep(ctrl[i]));
 		if (err)
 			return err;
 	}
-- 
1.7.9.5

