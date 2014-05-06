Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbaEFBDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:03:47 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:55621 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933395AbaEFBDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:03:46 -0400
Message-ID: <1399338214.24993.10.camel@ltli10.sensirion.lokal>
Subject: Re: [RFC][PATCH v2] hwmon: add support for Sensirion SHTC1 sensor
From: Tomas Pop <tomas.pop.mff@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "jdelvare@suse.de" <jdelvare@suse.de>, lm-sensors@lm-sensors.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        johannes.winkelmann@sensirion.com
Date: Mon, 05 May 2014 18:03:34 -0700
In-Reply-To: <20140502231528.GA5157@roeck-us.net>
References: <1398985530.17142.15.camel@ltli10.sensirion.lokal>
	 <5362FDA9.8080300@roeck-us.net>
	 <1399064369.3019.83.camel@ltli10.sensirion.lokal>
	 <20140502231528.GA5157@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter, 

Here is a corrected version, I tried to address your comments and I'm sending it
again with a kind request for comments - we will do some more extensive testing
before the final submission, but I would like to make the code as complete as
as possible before. Here is a list of changes to the previous version:

* positive, but incorrect return codes/lengths from i2c_mater_* are checked
* usleep_range used instead of msleep
* DEVICE_ATTR used instead of SENSOR_DEVICE_ATTR, ATTRIBITE_GROUPS used
* devm_hwmon_device_register_with_groups instead of devm_hwmon_device_register
* direct calls to sysfs_create_group and sysfs_create_group dropped
* shtc1_remove function dropped
* SHTW1 added to documentation and Kconfig
* documentation and formating updates/corrections

I did re-compile with C=1 as suggested and it is clear.

Patch was generated against kernel v3.15-rc3

Thanks,
Tomas

Signed-off-by: Tomas Pop <tomas.pop@sensirion.com>
---
 Documentation/hwmon/shtc1           |  41 ++++++
 drivers/hwmon/Kconfig               |  10 ++
 drivers/hwmon/Makefile              |   1 +
 drivers/hwmon/shtc1.c               | 266 ++++++++++++++++++++++++++++++++++++
 include/linux/platform_data/shtc1.h |  24 ++++
 5 files changed, 342 insertions(+)
 create mode 100644 Documentation/hwmon/shtc1
 create mode 100644 drivers/hwmon/shtc1.c
 create mode 100644 include/linux/platform_data/shtc1.h

diff --git a/Documentation/hwmon/shtc1 b/Documentation/hwmon/shtc1
new file mode 100644
index 0000000..47c9ed1
--- /dev/null
+++ b/Documentation/hwmon/shtc1
@@ -0,0 +1,41 @@
+Kernel driver shtc1
+===================
+
+Supported chips:
+  * Sensirion SHTC1
+    Prefix: 'shtc1'
+    Addresses scanned: none
+    Datasheet: Publicly available at the Sensirion website
+    http://www.sensirion.com/file/datasheet_shtc1
+
+  * Sensirion SHTW1
+    Prefix: 'shtc1'
+    Addresses scanned: none
+    Datasheet: Not publicly available
+
+Author:
+  Johannes Winkelmann <johannes.winkelmann@sensirion.com>
+
+Description
+-----------
+
+This driver implements support for the Sensirion SHTC1 chip, a humidity and
+temperature sensor. Temperature is measured in degrees celsius, relative
+humidity is expressed as a percentage. Driver can be used as well for SHTW1
+chip, which has the same electrical interface.
+
+The device communicates with the I2C protocol. All sensors are set to I2C
+address 0x70. See Documentation/i2c/instantiating-devices for methods to
+instantiate the device.
+
+There are two options configurable by means of shtc1_platform_data:
+1. blocking (pull the I2C clock line down while performing the measurement) or
+   non-blocking mode. Blocking mode will guarantee the fastest result but
+   the I2C bus will be busy during that time.
+2. high or low accuracy. Using high accuracy is strongly recommended.
+
+sysfs-Interface
+---------------
+
+temp1_input - temperature input
+humidity1_input - humidity input
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index bc196f4..f95ba5b 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1114,6 +1114,16 @@ config SENSORS_SHT21
 	  This driver can also be built as a module.  If so, the module
 	  will be called sht21.
 
+config SENSORS_SHTC1
+	tristate "Sensiron humidity and temperature sensors. SHTC1 and compat."
+	depends on I2C
+	help
+	  If you say yes here you get support for the Sensiron SHTC1 and SHTW1
+	  humidity and temperature sensor.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called shtc1.
+
 config SENSORS_S3C
 	tristate "Samsung built-in ADC"
 	depends on S3C_ADC
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index c48f987..1cc5273 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -125,6 +125,7 @@ obj-$(CONFIG_SENSORS_SCH5627)	+= sch5627.o
 obj-$(CONFIG_SENSORS_SCH5636)	+= sch5636.o
 obj-$(CONFIG_SENSORS_SHT15)	+= sht15.o
 obj-$(CONFIG_SENSORS_SHT21)	+= sht21.o
+obj-$(CONFIG_SENSORS_SHTC1)	+= shtc1.o
 obj-$(CONFIG_SENSORS_SIS5595)	+= sis5595.o
 obj-$(CONFIG_SENSORS_SMM665)	+= smm665.o
 obj-$(CONFIG_SENSORS_SMSC47B397)+= smsc47b397.o
diff --git a/drivers/hwmon/shtc1.c b/drivers/hwmon/shtc1.c
new file mode 100644
index 0000000..c94f670
--- /dev/null
+++ b/drivers/hwmon/shtc1.c
@@ -0,0 +1,266 @@
+/* Sensirion SHTC1 humidity and temperature sensor driver
+ *
+ * Copyright (C) 2014 Sensirion AG, Switzerland
+ * Author: Johannes Winkelmann <johannes.winkelmann@sensirion.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/platform_data/shtc1.h>
+
+/* commands (high precision mode) */
+static const unsigned char shtc1_cmd_measure_blocking_hpm[]    = { 0x7C, 0xA2 };
+static const unsigned char shtc1_cmd_measure_nonblocking_hpm[] = { 0x78, 0x66 };
+
+/* commands (low precision mode) */
+static const unsigned char shtc1_cmd_measure_blocking_lpm[]    = { 0x64, 0x58 };
+static const unsigned char shtc1_cmd_measure_nonblocking_lpm[] = { 0x60, 0x9c };
+
+/* command for reading the ID register */
+static const unsigned char shtc1_cmd_read_id_reg[]	       = { 0xef, 0xc8 };
+
+/* constants for reading the ID register */
+#define SHTC1_ID_REG_CONTENT 0x07
+#define SHTC1_ID_REG_MASK    0x1f
+
+/* delays for non-blocking i2c commands, both in us */
+#define SHTC1_NONBLOCKING_WAIT_TIME_HPM  14400
+#define SHTC1_NONBLOCKING_WAIT_TIME_LPM   1000
+
+#define SHTC1_CMD_LENGTH      2
+#define SHTC1_RESPONSE_LENGTH 6
+
+struct shtc1_data {
+	struct device *hwmon_dev;
+	struct mutex update_lock;
+	bool valid;
+	unsigned long last_updated; /* In jiffies */
+
+	const unsigned char *command;
+	unsigned int nonblocking_wait_time;
+
+	struct shtc1_platform_data setup;
+
+	int temperature;
+	int humidity;
+};
+
+static int shtc1_update_values(struct i2c_client *client,
+			       struct shtc1_data *data,
+			       char *buf, int bufsize)
+{
+	int ret = i2c_master_send(client, data->command, SHTC1_CMD_LENGTH);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to send command: %d\n", ret);
+		return ret;
+	}
+	if (ret != SHTC1_CMD_LENGTH) {
+		dev_err(&client->dev, "wrong nr bytes written: %d\n", ret);
+		return -EIO;
+	}
+
+	/*
+	* In blocking mode (clock stretching mode) the I2C bus
+	* is blocked for other traffic, thus the call to i2c_master_recv()
+	* will wait until the data is ready. for non blocking mode, we
+	* have to wait ourselves.
+	*/
+	if (!data->setup.blocking_io)
+		usleep_range(data->nonblocking_wait_time,
+			     data->nonblocking_wait_time + 2000);
+
+	ret = i2c_master_recv(client, buf, bufsize);
+	if (ret != bufsize) {
+		dev_err(&client->dev, "failed to read values: %d\n", ret);
+		if (ret < 0)
+			return ret;
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/* sysfs attributes */
+static struct shtc1_data *shtc1_update_client(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct shtc1_data *data = i2c_get_clientdata(client);
+
+	unsigned char buf[SHTC1_RESPONSE_LENGTH];
+	int val;
+	int ret;
+
+	mutex_lock(&data->update_lock);
+
+	/*
+	* Initialize 'ret' in case we had a valid result before, but
+	* read too quickly in which case we return the last values.
+	*/
+	ret = 0;
+
+	if (time_after(jiffies, data->last_updated + HZ / 10) || !data->valid) {
+		ret = shtc1_update_values(client, data, buf, sizeof(buf));
+		if (ret)
+			goto out;
+
+		/*
+		* From datasheet:
+		* T = -45 + 175 * ST / 2^16
+		* RH = 100 * SRH / 2^16
+		*
+		* Adapted for integer fixed point (3 digit) arithmetic.
+		*/
+		val = be16_to_cpup((__be16 *)buf);
+		data->temperature = ((21875 * val) >> 13) - 45000;
+		val = be16_to_cpup((__be16 *)(buf + 3));
+		data->humidity = ((12500 * val) >> 13);
+
+		data->last_updated = jiffies;
+		data->valid = 1;
+	}
+
+out:
+	mutex_unlock(&data->update_lock);
+
+	return ret == 0 ? data : ERR_PTR(ret);
+}
+
+static ssize_t shtc1_show_temperature(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	struct shtc1_data *data = shtc1_update_client(dev);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	return sprintf(buf, "%d\n", data->temperature);
+}
+
+static ssize_t shtc1_show_humidity(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct shtc1_data *data = shtc1_update_client(dev);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	return sprintf(buf, "%d\n", data->humidity);
+}
+
+static DEVICE_ATTR(temp1_input, S_IRUGO, shtc1_show_temperature, NULL);
+static DEVICE_ATTR(humidity1_input, S_IRUGO, shtc1_show_humidity, NULL);
+
+static struct attribute *shtc1_attrs[] = {
+	&dev_attr_temp1_input.attr,
+	&dev_attr_humidity1_input.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(shtc1);
+
+static void shtc1_select_command(struct shtc1_data *data)
+{
+	if (data->setup.high_precision) {
+		data->command = data->setup.blocking_io ?
+				shtc1_cmd_measure_blocking_hpm :
+				shtc1_cmd_measure_nonblocking_hpm;
+		data->nonblocking_wait_time = SHTC1_NONBLOCKING_WAIT_TIME_HPM;
+
+	} else {
+		data->command = data->setup.blocking_io ?
+				shtc1_cmd_measure_blocking_lpm :
+				shtc1_cmd_measure_nonblocking_lpm;
+		data->nonblocking_wait_time = SHTC1_NONBLOCKING_WAIT_TIME_LPM;
+	}
+}
+
+static int shtc1_probe(struct i2c_client *client,
+		       const struct i2c_device_id *id)
+{
+	struct shtc1_data *data;
+	int err;
+	struct i2c_adapter *adap = client->adapter;
+	char id_reg[2];
+
+	if (!i2c_check_functionality(adap, I2C_FUNC_I2C)) {
+		dev_err(&client->dev,
+			"adapter does not support plain i2c transactions\n");
+		return -ENODEV;
+	}
+
+	err = i2c_master_send(client, shtc1_cmd_read_id_reg, SHTC1_CMD_LENGTH);
+	if (err < 0) {
+		dev_err(&client->dev, "could not send read command: %d\n", err);
+		return -ENODEV;
+	}
+	if (err != SHTC1_CMD_LENGTH) {
+		dev_err(&client->dev, "num bytes send is wrong: %d\n", err);
+		return -ENODEV;
+	}
+	err = i2c_master_recv(client, id_reg, sizeof(id_reg));
+	if (err != sizeof(id_reg)) {
+		dev_err(&client->dev, "could not read ID register: %d\n", err);
+		return -ENODEV;
+	}
+	if ((id_reg[1] & SHTC1_ID_REG_MASK) != SHTC1_ID_REG_CONTENT) {
+		dev_err(&client->dev, "ID register doesn't match\n");
+		return -ENODEV;
+	}
+
+	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* defaults: blocking, high precision mode */
+	data->setup.blocking_io = true;
+	data->setup.high_precision = true;
+
+	if (client->dev.platform_data)
+		data->setup = *(struct shtc1_platform_data *)client->dev.platform_data;
+	shtc1_select_command(data);
+	i2c_set_clientdata(client, data);
+	mutex_init(&data->update_lock);
+
+	data->hwmon_dev = devm_hwmon_device_register_with_groups(&client->dev,
+								 client->name,
+								 data,
+								 shtc1_groups);
+	if (IS_ERR(data->hwmon_dev))
+		dev_dbg(&client->dev, "unable to register hwmon device\n");
+
+	return PTR_ERR_OR_ZERO(data->hwmon_dev);
+}
+
+/* device ID table */
+static const struct i2c_device_id shtc1_id[] = {
+	{ "shtc1", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, shtc1_id);
+
+static struct i2c_driver shtc1_i2c_driver = {
+	.driver.name  = "shtc1",
+	.probe        = shtc1_probe,
+	.id_table     = shtc1_id,
+};
+
+module_i2c_driver(shtc1_i2c_driver);
+
+MODULE_AUTHOR("Johannes Winkelmann <johannes.winkelmann@sensirion.com>");
+MODULE_DESCRIPTION("Sensirion SHTC1 humidity and temperature sensor driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_data/shtc1.h b/include/linux/platform_data/shtc1.h
new file mode 100644
index 0000000..b06e3db
--- /dev/null
+++ b/include/linux/platform_data/shtc1.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2014 Sensirion AG, Switzerland
+ * Author: Johannes Winkelmann <johannes.winkelmann@sensirion.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __SHTC1_H_
+#define __SHTC1_H_
+
+struct shtc1_platform_data {
+	bool blocking_io;
+	bool high_precision;
+};
+
+#endif /* __SHTC1_H_ */
-- 
1.8.3.2


On Fre, 2014-05-02 at 16:15 -0700, Guenter Roeck wrote:
> On Fri, May 02, 2014 at 01:59:29PM -0700, Tomas Pop wrote:
> > Hi Guenter, thanks for comments! I will include them in third version,
> > but I have still few questions...
> > 
> > On Don, 2014-05-01 at 19:06 -0700, Guenter Roeck wrote:
> > > On 05/01/2014 04:05 PM, Tomas Pop wrote:
> > > > One more time this patch sent with correct settings of my email client
> > > > - I'm sorry for this.
> > > >
> > > > This is a second version of the driver for Sensirion SHTC1 humidity and
> > > > temperature sensor. Initial version was submitted in July 2012.
> > > > http://www.gossamer-threads.com/lists/linux/kernel/1569130#1569130
> > > >
> > > > We included suggested corrections formerly discussed in this list after
> > > > initial submission, but since it is quite a while, we are re-submitting
> > > > it again as a request for comments. Here is a list of important changes
> > > > to the initial version:
> > > >
> > > > * returning real error codes instead of -1 or -ENODEV
> > > > * using boolean variables instead of bitmaps where possible
> > > > * macros be16_to_cpup used for conversion of indianneess
> > > > * corrected formula for decoding of humidity and temperature values
> > > > * documentation update
> > > >
> > > > Patch was generated against kernel v3.15-rc3
> > > >
> > > > Signed-off-by: Tomas Pop <tomas.pop@sensirion.com>
> > > > ---
> > > >   Documentation/hwmon/shtc1           |  38 +++++
> > > >   drivers/hwmon/Kconfig               |  10 ++
> > > >   drivers/hwmon/Makefile              |   1 +
> > > >   drivers/hwmon/shtc1.c               | 323 ++++++++++++++++++++++++++++++++++++
> > > >   include/linux/platform_data/shtc1.h |  24 +++
> > > >   5 files changed, 396 insertions(+)
> > > >   create mode 100644 Documentation/hwmon/shtc1
> > > >   create mode 100644 drivers/hwmon/shtc1.c
> > > >   create mode 100644 include/linux/platform_data/shtc1.h
> > > >
> > > > diff --git a/Documentation/hwmon/shtc1 b/Documentation/hwmon/shtc1
> > > > new file mode 100644
> > > > index 0000000..6a72ae2d
> > > > --- /dev/null
> > > > +++ b/Documentation/hwmon/shtc1
> > > > @@ -0,0 +1,38 @@
> > > > +Kernel driver shtc1
> > > > +===================
> > > > +
> > > > +Supported chips:
> > > > +  * Sensirion SHTC1
> > > > +    Prefix: 'shtc1'
> > > > +    Addresses scanned: none
> > > > +    Datasheet: Publicly available at the Sensirion website
> > > > +    http://www.sensirion.com/fileadmin/user_upload/customers/sensirion/Dokumente/Humidity/Sensirion_Humidity_SHTC1_Datasheet.pdf
> > > 
> > > Ok to add SHTW1 here if it is known to work.
> > > Just say:
> > > 	Datasheet: Not publicly available
> > 
> > Actually, there is no way to find out, if you are speaking 
> > to SHTC1 or SHTW1. (i.e., the id is the same for both).
> > So I will add it here and we will provide link to data-sheet 
> > later in a separate patch.
> > 
> Ok.
> 
> > > > +
> > > > +Author:
> > > > +  Johannes Winkelmann <johannes.winkelmann@sensirion.com>
> > > > +
> > > > +Description
> > > > +-----------
> > > > +
> > > > +This driver implements support for the Sensirion  SHTC1 chip, a humidity and
> > > 
> > > Two spaces
> > > 
> > > > +temperature sensor. Temperature is measured in degrees celsius, relative
> > > > +humidity is expressed as a percentage. Driver can be used as well for SHTW1
> > > > +chip, that has the same electrical interface, but datasheet has not been
> > > 
> > > ... for SHTW1, which has the same electrical interface.
> > > 
> > > > +yet published.
> > > > +
> > > 
> > > Either add support for the second now, or don't mention it at all
> > > (especially if the chip has a different ID and you don't want to add
> > > that ID at this point for some reason).
> > > 
> > > > +The device communicates with the I2C protocol. All sensors are set to the same
> > > 
> > > ... are set to I2C address 0x70.
> > > 
> > > > +I2C address 0x70, so an entry with I2C_BOARD_INFO("shtc1", 0x70) can be used
> > > > +in the board setup code. See Documentation/i2c/instantiating-devices for
> > > > +other methods to instantiate the device.
> > > > +
> > > I would suggest to just refer to the instantiating-devices document and drop
> > > the I2C_BOARD_INFO example.
> > > 
> > > > +Furthermore, there are two configuration options by means of platform_data:
> > > 
> > > options configurable by means ...
> > > 
> > > > +1. blocking (pull the I2C clock line down while performing the measurement) or
> > > > +   non-blocking, mode. Blocking mode will guarantee the fastest result, but
> > > 
> > > non-blocking mode (no comma)
> > > 
> > > > +   the I2C bus will be busy during that time
> > > 
> > > 					that time.
> > > 
> > > > +2. high or low accuracy. Using high accuracy is always recommended.
> > > > +
> > > > +sysfs-Interface
> > > > +---------------
> > > > +
> > > > +temp1_input - temperature input
> > > > +humidity1_input - humidity input
> > > > diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> > > > index bc196f4..4d58149 100644
> > > > --- a/drivers/hwmon/Kconfig
> > > > +++ b/drivers/hwmon/Kconfig
> > > > @@ -1114,6 +1114,16 @@ config SENSORS_SHT21
> > > >   	  This driver can also be built as a module.  If so, the module
> > > >   	  will be called sht21.
> > > >
> > > > +config SENSORS_SHTC1
> > > > +	tristate "Sensiron humidity and temperature sensors. SHTC1 and compat."
> > > > +	depends on I2C
> > > > +	help
> > > > +	  If you say yes here you get support for the Sensiron SHTC1 humidity
> > > 
> > > and SHTW1 ?
> > 
> > I will add SHTW1 here as well
> > 
> > > 
> > > > +	  and temperature sensor.
> > > > +
> > > > +	  This driver can also be built as a module.  If so, the module
> > > > +	  will be called shtc1.
> > > > +
> > > >   config SENSORS_S3C
> > > >   	tristate "Samsung built-in ADC"
> > > >   	depends on S3C_ADC
> > > > diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> > > > index c48f987..1cc5273 100644
> > > > --- a/drivers/hwmon/Makefile
> > > > +++ b/drivers/hwmon/Makefile
> > > > @@ -125,6 +125,7 @@ obj-$(CONFIG_SENSORS_SCH5627)	+= sch5627.o
> > > >   obj-$(CONFIG_SENSORS_SCH5636)	+= sch5636.o
> > > >   obj-$(CONFIG_SENSORS_SHT15)	+= sht15.o
> > > >   obj-$(CONFIG_SENSORS_SHT21)	+= sht21.o
> > > > +obj-$(CONFIG_SENSORS_SHTC1)	+= shtc1.o
> > > >   obj-$(CONFIG_SENSORS_SIS5595)	+= sis5595.o
> > > >   obj-$(CONFIG_SENSORS_SMM665)	+= smm665.o
> > > >   obj-$(CONFIG_SENSORS_SMSC47B397)+= smsc47b397.o
> > > > diff --git a/drivers/hwmon/shtc1.c b/drivers/hwmon/shtc1.c
> > > > new file mode 100644
> > > > index 0000000..96d398b
> > > > --- /dev/null
> > > > +++ b/drivers/hwmon/shtc1.c
> > > > @@ -0,0 +1,323 @@
> > > > +/* Sensirion SHTC1 humidity and temperature sensor driver
> > > > + *
> > > > + * Copyright (C) 2012 Sensirion AG, Switzerland
> > > 
> > > 2014 ?
> > > 
> > > > + * Author: Johannes Winkelmann <johannes.winkelmann@sensirion.com>
> > > > + *
> > > Is Johannes still involved ?
> > 
> > Yes, Johannes is aware of this re-submission, but I will try to take
> > care about the process this time. I will add him in CC.
> > 
> > > 
> > > > + * This program is free software; you can redistribute it and/or modify
> > > > + * it under the terms of the GNU General Public License as published by
> > > > + * the Free Software Foundation; either version 2 of the License, or
> > > > + * (at your option) any later version.
> > > > + *
> > > > + * This program is distributed in the hope that it will be useful,
> > > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > > + * GNU General Public License for more details.
> > > > + *
> > > > + * Data sheet available soon
> > > > + *  TODO: add link
> > > 
> > > Datasheet is referenced in documentation, so you don't need the link here.
> > > Better to keep it in one please, then there is only one place to change
> > > if it needs to be updated.
> > > > + */
> > > > +
> > > > +#include <linux/module.h>
> > > > +#include <linux/init.h>
> > > > +#include <linux/slab.h>
> > > > +#include <linux/i2c.h>
> > > > +#include <linux/hwmon.h>
> > > > +#include <linux/hwmon-sysfs.h>
> > > > +#include <linux/err.h>
> > > > +#include <linux/delay.h>
> > > > +#include <linux/platform_data/shtc1.h>
> > > > +
> > > > +/* commands (high precision mode) */
> > > > +static const unsigned char shtc1_cmd_measure_blocking_hpm[]    = { 0x7C, 0xA2 };
> > > > +static const unsigned char shtc1_cmd_measure_nonblocking_hpm[] = { 0x78, 0x66 };
> > > > +
> > > > +/* commands (low precision mode) */
> > > > +static const unsigned char shtc1_cmd_measure_blocking_lpm[]    = { 0x64, 0x58 };
> > > > +static const unsigned char shtc1_cmd_measure_nonblocking_lpm[] = { 0x60, 0x9c };
> > > > +
> > > > +/* command and constants for reading the ID register */
> > > > +static const unsigned char shtc1_cmd_read_id_reg[]	     = { 0xef, 0xc8 };
> > > > +static const unsigned char shtc1_id_reg_content = 0x07;
> > > > +static const unsigned char shtc1_id_reg_mask    = 0x1f;
> > > > +
> > > Please use defines here. There is no benefit to have one-byte constants.
> > > If the W1 chip has a different ID, you might as well add it in now and detect it.
> > > 
> > > > +/* delays for non-blocking i2c commands */
> > > > +#define SHTC1_NONBLOCKING_WAIT_TIME_HPM  10
> > > > +#define SHTC1_NONBLOCKING_WAIT_TIME_LPM   1
> 
> Just noticed. Please use tabs between definition and the number.
> 
> > > 
> > > 	delay in what ? ms ? us ? seconds ?
> > > 	Please specify.
> > > 
> > 
> > The delays are in miliseconds. You mean to use it in names - e.g.,
> > SHTC1_NONBLOCKING_WAIT_TIME_LPM_MS? Or comment is enough?
> > 
> 
> Just a comment is enough. No name change, please; that would be overkill.
> 
> #define SHTC1_NONBLOCKING_WAIT_TIME_HPM	10	/* in ms */
> 
> > May be I should then rename 
> > also data->nonblocking_wait_time to data->nonblocking_wait_time_ms...
> > 
> No. 
> 
> > > > +
> > > > +#define SHTC1_CMD_LENGTH      2
> > > > +#define SHTC1_RESPONSE_LENGTH 6
> > > > +
> > > > +struct shtc1_data {
> > > > +	struct device *hwmon_dev;
> > > > +	struct mutex update_lock;
> > > > +	bool valid;
> > > > +	unsigned long last_updated; /* In jiffies */
> > > > +
> > > > +	const unsigned char *command;
> > > > +	unsigned int nonblocking_wait_time;
> > > > +
> > > > +	struct shtc1_platform_data setup;
> > > > +
> > > > +	int temperature;
> > > > +	int humidity;
> > > > +};
> > > > +
> > > > +static void shtc1_select_command(struct shtc1_data *data)
> > > > +{
> > > > +	if (data->setup.high_precision) {
> > > > +		data->command = data->setup.blocking_io ?
> > > > +				shtc1_cmd_measure_blocking_hpm :
> > > > +				shtc1_cmd_measure_nonblocking_hpm;
> > > > +		data->nonblocking_wait_time = SHTC1_NONBLOCKING_WAIT_TIME_HPM;
> > > > +
> > > > +	} else {
> > > > +		data->command = data->setup.blocking_io ?
> > > > +				shtc1_cmd_measure_blocking_lpm :
> > > > +				shtc1_cmd_measure_nonblocking_lpm;
> > > > +		data->nonblocking_wait_time = SHTC1_NONBLOCKING_WAIT_TIME_LPM;
> > > > +	}
> > > > +}
> > > > +
> > > Please move this function down, just before the probe function.
> > > 
> > > > +static int shtc1_update_values(struct i2c_client *client,
> > > > +				struct shtc1_data *data,
> > > > +				char *buf,
> > > > +				int bufsize)
> > > 
> > > Please align continuation lines with (, and limit the number of continuation lines
> > > where possible (eg, buf and bufsize fit into one line).
> > > 
> > > > +{
> > > > +	int ret = i2c_master_send(client, data->command, SHTC1_CMD_LENGTH);
> > > > +	if (ret < 0) {
> > > > +		dev_err(&client->dev, "failed to send command: %d", ret);
> > > 
> > > Newline missing.
> > > 
> > > > +		return ret;
> > > > +	}
> > > 
> > > There is another error condition: the function returns the number of bytes written,
> > > which can be smaller than SHTC1_CMD_LENGTH.
> > > 
> > > > +
> > > > +	/*
> > > > +	* In blocking mode (clock stretching mode) the I2C bus
> > > > +	* is blocked for other traffic, thus the call to i2c_master_recv()
> > > > +	* will wait until the data is ready. for non blocking mode, we
> > > > +	* have to wait ourselves, thus the msleep().
> > > > +	*
> > > > +	* TODO: consider usleep_range
> > > 
> > > Please do ... and fix all the other TODOs in case I missed any.
> > 
> > Sure. I checked the documentation and if I understand it correctly, we  should really use in this case something like:
> > 	if (!data->setup.blocking_io)
> > 		usleep_range(data->nonblocking_wait_time_min_us,
> > 			     data->nonblocking_wait_time_max_us);
> > 
> > where max_time will be min_time plus some fixed margin, e.g, 2000us
> > 
> > sounds this reasonable to you?
> > 
> Yes, but you don't need the second variable. Just add the fixed offset,
> 
> 		usleep_range(data->nonblocking_wait_time,
> 			     data->nonblocking_wait_time + 2000);
> 
> [ and of course specify the timeout in uS, not mS ].
> 
> > > 
> > > > +	*/
> > > > +	if (!data->setup.blocking_io)
> > > > +		msleep(data->nonblocking_wait_time);
> > > > +
> > > > +	ret = i2c_master_recv(client, buf, bufsize);
> > > > +	if (ret != bufsize) {
> > > > +		dev_err(&client->dev, "failed to read values: %d", ret);
> > > 
> > > Newline.
> > > 
> > > The return value can be >= 0, meaning the calling code can get confused.
> > > Please make sure that the function always returns a valid error code.
> > 
> > Ok, so return -EIO or better -ENODEV?
> > 
> -EIO seems common. -ENODEV would be wrong.
> 
> > > 
> > > > +		return ret;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +/* sysfs attributes */
> > > > +static struct shtc1_data *shtc1_update_client(struct device *dev)
> > > > +{
> > > > +	struct i2c_client *client = to_i2c_client(dev);
> > > > +	struct shtc1_data *data = i2c_get_clientdata(client);
> > > > +
> > > > +	unsigned char buf[SHTC1_RESPONSE_LENGTH];
> > > > +	int val;
> > > > +	int ret;
> > > > +
> > > > +	mutex_lock(&data->update_lock);
> > > > +
> > > > +	/*
> > > > +	* Initialize 'ret' in case we had a valid result before, but
> > > > +	* read too quickly in which case we return the last values.
> > > > +	*/
> > > > +	ret = !data->valid;
> > > 
> > > So ret gets pre-initialized with 1 if valid == 0. Doesn't really make sense.
> > > Just initialize it with 0 above.
> > > 
> > > 	int ret = 0;
> > 
> > Sure, thanks.
> > 
> > > 
> > > > +
> > > > +	if (time_after(jiffies, data->last_updated + HZ / 10) || !data->valid) {
> > > > +		ret = shtc1_update_values(client, data, buf, sizeof(buf));
> > > > +
> > > Unnecessary empty line.
> > > 
> > > > +		if (ret)
> > > > +			goto out;
> > > > +
> > > > +		/*
> > > > +		* From datasheet:
> > > > +		* T = -45 + 175 * ST / 2^16
> > > > +		* RH = 100 * SRH / 2^16
> > > > +		*
> > > > +		* Adapted for integer fixed point (3 digit) arithmetic.
> > > > +		*/
> > > > +		val = be16_to_cpup((__be16 *)buf);
> > > > +		data->temperature = ((21875 * val) >> 13) - 45000;
> > > > +		val = be16_to_cpup((__be16 *)(buf+3));
> > > 
> > > 	Spaces before and after '+'
> > > 
> > > Just wondering .. what is in buf[2] and buf[5] ?
> > 
> > There are two CRC-8 checksums: 
> > buf[2] for humidity, buf[5] for temperature value. We would prefer
> > not to check CRC it in this version of the driver...
> > 
> Fine with me - your chip, your call - just asking.
> 
> > > 
> > > > +		data->humidity = ((12500 * val) >> 13);
> > > > +
> > > > +		data->last_updated = jiffies;
> > > > +		data->valid = 1;
> > > 
> > > 			= true;
> > > 
> > > > +	}
> > > > +
> > > > +out:
> > > > +	mutex_unlock(&data->update_lock);
> > > > +
> > > > +	return ret == 0 ? data : ERR_PTR(ret);
> > > > +}
> > > > +
> > > > +static ssize_t shtc1_show_temperature(struct device *dev,
> > > > +				struct device_attribute *attr,
> > > > +				char *buf)
> > > > +{
> > > > +	struct shtc1_data *data = shtc1_update_client(dev);
> > > > +	if (IS_ERR(data))
> > > > +		return PTR_ERR(data);
> > > > +
> > > > +	return sprintf(buf, "%d\n", data->temperature);
> > > > +}
> > > > +
> > > > +static ssize_t shtc1_show_humidity(struct device *dev,
> > > > +				struct device_attribute *attr,
> > > > +				char *buf)
> > > > +{
> > > > +	struct shtc1_data *data = shtc1_update_client(dev);
> > > > +	if (IS_ERR(data))
> > > > +		return PTR_ERR(data);
> > > > +
> > > > +	return sprintf(buf, "%d\n", data->humidity);
> > > > +}
> > > > +
> > > > +static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO,
> > > > +			shtc1_show_temperature, NULL, 0);
> > > > +static SENSOR_DEVICE_ATTR(humidity1_input, S_IRUGO,
> > > > +			shtc1_show_humidity, NULL, 0);
> > > 
> > > You don't need SENSOR_DEVICE_ATTR here. DEVICE_ATTR is sufficient.
> > > 
> > > Another option would be to store temperature and humidity in an array
> > > and use the last parameter of SENSOR_DEVICE_ATTR to index the array.
> > > This way you would only need a single show function. I'll leave
> > > that up to you.
> > 
> > Ok, then we will use DEVICE_ATTR...
> > > 
> > > > +
> > > > +static struct attribute *shtc1_attributes[] = {
> > > > +	&sensor_dev_attr_temp1_input.dev_attr.attr,
> > > > +	&sensor_dev_attr_humidity1_input.dev_attr.attr,
> > > > +	NULL
> > > > +};
> > > > +
> > > > +static const struct attribute_group shtc1_attr_group = {
> > > > +	.attrs = shtc1_attributes,
> > > > +};
> > > 
> > > Please use ATTRIBUTE_GROUPS().
> > > 
> > > > +
> > > > +static int shtc1_probe(struct i2c_client *client,
> > > > +				const struct i2c_device_id *id)
> > > > +{
> > > > +	struct shtc1_data *data;
> > > 
> > > A local variable
> > > 	struct device *dev = &client->dev;
> > > would save you a number of dereference operations.
> > > 
> > > > +	int err;
> > > > +	struct i2c_adapter *adap = client->adapter;
> > > > +	char id_reg[2];
> > > > +
> > > > +	if (!i2c_check_functionality(adap, I2C_FUNC_I2C)) {
> > > > +		dev_err(&client->dev,
> > > > +			"adapter does not support plain i2c transactions\n");
> > > > +		return -ENODEV;
> > > > +	}
> > > > +
> > > > +	err = i2c_master_send(client, shtc1_cmd_read_id_reg, SHTC1_CMD_LENGTH);
> > > > +
> > > Please no empty lines before error checks.
> > > 
> > > > +	if (err < 0) {
> > > 
> > > Also err != SHTC1_CMD_LENGTH.
> > 
> > This is similar to my question above, do you think it is better in that
> > case return -EIO or -ENODEV?
> > 
> 
> This is the probe function, so here you return -ENODEV.
> 
> > > 
> > > > +		dev_err(&client->dev, "could not send read command: %d\n", err);
> > > > +		return -ENODEV;
> > > > +	}
> > > > +	err = i2c_master_recv(client, id_reg, sizeof(id_reg));
> > > > +	if (err != sizeof(id_reg)) {
> > > > +		dev_err(&client->dev, "could not read ID register: %d\n", err);
> > > > +		return -ENODEV;
> > > > +	}
> > > > +	if ((id_reg[1] & shtc1_id_reg_mask) != shtc1_id_reg_content) {
> > > > +		dev_err(&client->dev, "ID register doesn't match\n");
> > > > +		return -ENODEV;
> > > > +	}
> > > > +
> > > > +	data = devm_kzalloc(&client->dev, sizeof(struct shtc1_data),
> > > 
> > > 	sizeof(*data) is preferred.
> > > 
> > > > +				GFP_KERNEL);
> > > > +	if (!data)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	/* defaults: blocking, high precision mode */
> > > > +	data->setup.blocking_io = 1;
> > > > +	data->setup.high_precision = 1;
> > > > +
> > > 		= true;
> > > for both.
> > > 
> > > > +	if (client->dev.platform_data)
> > > > +		data->setup = *(struct shtc1_platform_data *)client->dev.platform_data;
> > > > +	shtc1_select_command(data);
> > > > +
> > > > +	i2c_set_clientdata(client, data);
> > > > +	mutex_init(&data->update_lock);
> > > > +
> > > > +	err = sysfs_create_group(&client->dev.kobj, &shtc1_attr_group);
> > > > +	if (err) {
> > > > +		dev_dbg(&client->dev, "could not create sysfs files\n");
> > > > +		goto fail_free;
> > > > +		return err;
> > > 
> > > goto or return, but not both (doesn't this create a warning about unreachable code ?).
> > > goto is unnecessary, actually. return err is just fine.
> > 
> > I think, there were no warnings, but of course you are right...
> > 
> You might get the warning if you compile with C=1. Might be useful ...
> I'll do it when I merge the driver, so it will save me and you some time
> if you make sure that it is clean.
> 
> > > 
> > > > +	}
> > > > +	data->hwmon_dev = hwmon_device_register(&client->dev);
> > > 
> > > Please use devm_hwmon_device_register_with_groups().
> > > 
> > > 	struct device *hwmon_dev;
> > > 	...
> > > 	hwmon_dev = devm_hwmon_device_register_with_groups(&client->dev, client->name,
> > > 							data, sht1c_groups);
> > > 	return PTR_ERR_OR_ZERO(hwmon_dev);
> > > 
> > > 
> > > > +	if (IS_ERR(data->hwmon_dev)) {
> > > > +		dev_dbg(&client->dev, "unable to register hwmon device\n");
> > > > +		err = PTR_ERR(data->hwmon_dev);
> > > > +		goto fail_remove_sysfs;
> > > > +	}
> > > > +
> > > > +
> > > No more than one empty line, please.
> > > 
> > > > +	dev_info(&client->dev, "initialized\n");
> > > 
> > > Unnecessary noise.
> > > 
> > > > +
> > > > +	return 0;
> > > > +
> > > > +fail_remove_sysfs:
> > > > +	sysfs_remove_group(&client->dev.kobj, &shtc1_attr_group);
> > > > +fail_free:
> > > > +	kfree(data);
> > > 
> > > Unnecessary kfree.
> > 
> > I will remove these two lines at all.
> > 
> > > 
> > > > +
> > > > +	return err;
> > > > +}
> > > > +
> > > > +/**
> > > > + * shtc1_remove() - remove device
> > > > + * @client: I2C client device
> > > > + */
> > > > +static int shtc1_remove(struct i2c_client *client)
> > > > +{
> > > > +	struct shtc1_data *data = i2c_get_clientdata(client);
> > > > +
> > > > +	hwmon_device_unregister(data->hwmon_dev);
> > > > +	sysfs_remove_group(&client->dev.kobj, &shtc1_attr_group);
> > > > +
> > > > +	return 0;
> > > > +}
> > > 
> > > You can drop this entire function with the new hwmon API.
> > > 
> > > > +
> > > > +/* device ID table */
> > > > +static const struct i2c_device_id shtc1_id[] = {
> > > > +	{ "shtc1", 0 },
> > > > +	{ }
> > > > +};
> > > > +MODULE_DEVICE_TABLE(i2c, shtc1_id);
> > > > +
> > > > +static struct i2c_driver shtc1_i2c_driver = {
> > > > +	.driver.name = "shtc1",
> > > > +	.probe	= shtc1_probe,
> > > > +	.remove      = shtc1_remove,
> > > > +	.id_table    = shtc1_id,
> > > > +};
> > > > +
> > > > +/**
> > > > + * shtc1_init() - initialize driver
> > > > + *
> > > > + * Called when kernel is booted or module is inserted.
> > > > + * Returns 0 on success.
> > > > + */
> > > > +static int __init shtc1_init(void)
> > > > +{
> > > > +	return i2c_add_driver(&shtc1_i2c_driver);
> > > > +}
> > > > +module_init(shtc1_init);
> > > > +
> > > > +/*
> > > > + * shtc1_exit() - clean up driver
> > > > + *
> > > > + * Called when module is removed.
> > > > + */
> > > > +static void __exit shtc1_exit(void)
> > > > +{
> > > > +	i2c_del_driver(&shtc1_i2c_driver);
> > > > +}
> > > > +
> > > > +module_exit(shtc1_exit);
> > > 
> > > Please use module_i2c_driver().
> > > 
> > > > +
> > > > +
> > > > +MODULE_AUTHOR("Johannes Winkelmann <johannes.winkelmann@sensirion.com>");
> > > > +MODULE_DESCRIPTION("Sensirion SHTC1 humidity and temperature sensor driver");
> > > > +MODULE_LICENSE("GPL");
> > > > diff --git a/include/linux/platform_data/shtc1.h b/include/linux/platform_data/shtc1.h
> > > > new file mode 100644
> > > > index 0000000..4629364
> > > > --- /dev/null
> > > > +++ b/include/linux/platform_data/shtc1.h
> > > > @@ -0,0 +1,24 @@
> > > > +/*
> > > > + * Copyright (C) 2012 Sensirion AG, Switzerland
> > > 
> > > 2014 ?
> > > 
> > > > + * Author: Johannes Winkelmann <johannes.winkelmann@sensirion.com>
> > > > + *
> > > > + * This software is licensed under the terms of the GNU General Public
> > > > + * License version 2, as published by the Free Software Foundation, and
> > > > + * may be copied, distributed, and modified under those terms.
> > > > + *
> > > > + * This program is distributed in the hope that it will be useful,
> > > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > > + * GNU General Public License for more details.
> > > > + *
> > > > + */
> > > > +
> > > > +#ifndef __SHTC1_H_
> > > > +#define __SHTC1_H_
> > > > +
> > > > +struct shtc1_platform_data {
> > > > +	bool blocking_io;
> > > > +	bool high_precision;
> > > > +};
> > > > +
> > > 
> > > Please no empty line at the end.
> > > 
> > > Wondering ... do you plan to implement devicetree support (or have customers who need it) ?
> > > 
> > > I could imagine that a chip like this will be used, for example, on beagleboard, which would
> > > require devicetree support.
> > > 
> > 
> > Right now, I'm not aware of any particular time plan to implement device
> > tree support, but this may change, if somebody will request it...
> > 
> Fine with me, just asking.
> 
> Thanks,
> Guenter


