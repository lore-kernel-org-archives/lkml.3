Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3KNOzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:55:07 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63828 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab3KNOy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:54:59 -0500
From: Laszlo Papp <lpapp@kde.org>
To: hjk@hansjkoch.de
Cc: linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Laszlo Papp <lpapp@kde.org>
Subject: [PATCH] hwmon: (max6650) Add support for gpiodef
Date: Thu, 14 Nov 2013 14:51:01 +0000
Message-Id: <1384440661-3769-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is necessary for end users when they are using the gpio pins connected to the
fan controller. There is a separate gpiodef register provided, but it is unused
under the usual circumstances and that is probably the reason why this feature
has not been added before. It is necessary for our board to function properly.

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 Documentation/hwmon/max6650 |   5 +++
 drivers/hwmon/max6650.c     | 107 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+)

diff --git a/Documentation/hwmon/max6650 b/Documentation/hwmon/max6650
index 58d9644..32c69a8 100644
--- a/Documentation/hwmon/max6650
+++ b/Documentation/hwmon/max6650
@@ -39,6 +39,11 @@ pwm1		rw	relative speed (0-255), 255=max. speed.
 fan1_div	rw	sets the speed range the inputs can handle. Legal
 			values are 1, 2, 4, and 8. Use lower values for
 			faster fans.
+gpio0     	rw	sets the gpio 0 PIN. Legal values are 0, 1, 2, and 3.
+gpio1     	rw	sets the gpio 1 PIN. Legal values are 0, 1, 2, and 3.
+gpio2     	rw	sets the gpio 2 PIN. Legal values are 0, 1, 2, and 3.
+gpio3     	rw	sets the gpio 3 PIN. Legal values are 0, and 1.
+gpio4     	rw	sets the gpio 4 PIN. Legal values are 0, and 1.
 
 Usage notes
 -----------
diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
index 0cafc39..2268142 100644
--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -90,6 +90,16 @@ module_param(clock, int, S_IRUGO);
 #define MAX6650_COUNT_MASK		0x03
 
 /*
+ * Gpio Def register bits
+ */
+
+#define MAX6650_GPIO_DEF_GPIO0_LOW  0x03
+#define MAX6650_GPIO_DEF_GPIO1_LOW  0x0C
+#define MAX6650_GPIO_DEF_GPIO2_LOW  0x30
+#define MAX6650_GPIO_DEF_GPIO3      0x40
+#define MAX6650_GPIO_DEF_GPIO4      0x80
+
+/*
  * Alarm status register bits
  */
 
@@ -145,6 +155,7 @@ struct max6650_data {
 	/* register values */
 	u8 speed;
 	u8 config;
+	u8 gpiodef;
 	u8 tach[4];
 	u8 count;
 	u8 dac;
@@ -461,6 +472,90 @@ static ssize_t get_alarm(struct device *dev, struct device_attribute *devattr,
 	return sprintf(buf, "%d\n", alarm);
 }
 
+static ssize_t get_gpio(struct device *dev, struct device_attribute *devattr,
+			 char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct max6650_data *data = max6650_update_device(dev);
+
+	int gpio = 0;
+
+	switch (attr->index) {
+	case 0:
+		gpio = data->gpiodef & MAX6650_GPIO_DEF_GPIO0_LOW;
+		break;
+	case 1:
+		gpio = (data->gpiodef & MAX6650_GPIO_DEF_GPIO1_LOW) >> 2;
+		break;
+	case 2:
+		gpio = (data->gpiodef & MAX6650_GPIO_DEF_GPIO2_LOW) >> 4;
+		break;
+	case 3:
+		gpio = (data->gpiodef & MAX6650_GPIO_DEF_GPIO3) >> 6;
+		break;
+	case 4:
+		gpio = (data->gpiodef & MAX6650_GPIO_DEF_GPIO4) >> 7;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return sprintf(buf, "%d\n", gpio);
+}
+
+static ssize_t set_gpio(struct device *dev, struct device_attribute *devattr,
+			 char *buf, size_t count)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct max6650_data *data = max6650_update_device(dev);
+	struct i2c_client *client = to_i2c_client(dev);
+	u8 gpio;
+	int err;
+
+	err = kstrtoul(buf, 10, &gpio);
+	if (err)
+		return err;
+
+	mutex_lock(&data->update_lock);
+
+	switch (attr->index) {
+	case 0:
+		data->gpiodef &= ~MAX6650_GPIO_DEF_GPIO0_LOW;
+		data->gpiodef |= gpio;
+		break;
+	case 1:
+		data->gpiodef &= ~MAX6650_GPIO_DEF_GPIO1_LOW;
+		data->gpiodef &= (gpio << 2);
+		break;
+	case 2:
+		data->gpiodef &= ~MAX6650_GPIO_DEF_GPIO2_LOW;
+		data->gpiodef &= (gpio << 4);
+		break;
+	case 3:
+		data->gpiodef &= ~MAX6650_GPIO_DEF_GPIO3;
+		data->gpiodef &= (gpio << 6);
+		break;
+	case 4:
+		data->gpiodef &= ~MAX6650_GPIO_DEF_GPIO4;
+		data->gpiodef &= (gpio << 7);
+		break;
+	default:
+	    mutex_unlock(&data->update_lock);
+		return -EINVAL;
+	}
+
+	if (i2c_smbus_write_byte_data(client, MAX6650_REG_GPIO_DEF,
+							data->gpiodef)) {
+		dev_err(&client->dev, "Gpiodef write error, aborting.\n");
+	    mutex_unlock(&data->update_lock);
+		return err;
+	}
+
+	mutex_unlock(&data->update_lock);
+
+	return count;
+}
+
 static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, get_fan, NULL, 0);
 static SENSOR_DEVICE_ATTR(fan2_input, S_IRUGO, get_fan, NULL, 1);
 static SENSOR_DEVICE_ATTR(fan3_input, S_IRUGO, get_fan, NULL, 2);
@@ -479,6 +574,11 @@ static SENSOR_DEVICE_ATTR(gpio1_alarm, S_IRUGO, get_alarm, NULL,
 			  MAX6650_ALRM_GPIO1);
 static SENSOR_DEVICE_ATTR(gpio2_alarm, S_IRUGO, get_alarm, NULL,
 			  MAX6650_ALRM_GPIO2);
+static SENSOR_DEVICE_ATTR(gpio0, S_IWUSR | S_IRUGO, get_gpio, set_gpio, 0);
+static SENSOR_DEVICE_ATTR(gpio1, S_IWUSR | S_IRUGO, get_gpio, set_gpio, 1);
+static SENSOR_DEVICE_ATTR(gpio2, S_IWUSR | S_IRUGO, get_gpio, set_gpio, 2);
+static SENSOR_DEVICE_ATTR(gpio3, S_IWUSR | S_IRUGO, get_gpio, set_gpio, 3);
+static SENSOR_DEVICE_ATTR(gpio4, S_IWUSR | S_IRUGO, get_gpio, set_gpio, 4);
 
 static umode_t max6650_attrs_visible(struct kobject *kobj, struct attribute *a,
 				    int n)
@@ -516,6 +616,8 @@ static struct attribute *max6650_attrs[] = {
 	&sensor_dev_attr_fan1_fault.dev_attr.attr,
 	&sensor_dev_attr_gpio1_alarm.dev_attr.attr,
 	&sensor_dev_attr_gpio2_alarm.dev_attr.attr,
+	&sensor_dev_attr_gpio0.dev_attr.attr,
+	&sensor_dev_attr_gpio1.dev_attr.attr,
 	NULL
 };
 
@@ -528,6 +630,9 @@ static struct attribute *max6651_attrs[] = {
 	&sensor_dev_attr_fan2_input.dev_attr.attr,
 	&sensor_dev_attr_fan3_input.dev_attr.attr,
 	&sensor_dev_attr_fan4_input.dev_attr.attr,
+	&sensor_dev_attr_gpio2.dev_attr.attr,
+	&sensor_dev_attr_gpio3.dev_attr.attr,
+	&sensor_dev_attr_gpio4.dev_attr.attr,
 	NULL
 };
 
@@ -704,6 +809,8 @@ static struct max6650_data *max6650_update_device(struct device *dev)
 						       MAX6650_REG_SPEED);
 		data->config = i2c_smbus_read_byte_data(client,
 							MAX6650_REG_CONFIG);
+		data->gpiodef = i2c_smbus_read_byte_data(client,
+							MAX6650_REG_GPIO_DEF);
 		for (i = 0; i < data->nr_fans; i++) {
 			data->tach[i] = i2c_smbus_read_byte_data(client,
 								 tach_reg[i]);
-- 
1.8.4.2

