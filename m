Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaLZMfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 07:35:44 -0500
Received: from ring0.de ([5.45.105.125]:36889 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbaLZMfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:35:39 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Pali Rohar <pali.rohar@gmail.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, lm-sensors@lm-sensors.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 2/3] hwmon: Driver for OMAP3 temperature sensor
Date: Fri, 26 Dec 2014 13:34:53 +0100
Message-Id: <1419597294-21487-3-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419597294-21487-1-git-send-email-sre@kernel.org>
References: <20141226102933.GA28778@amd>
 <1419597294-21487-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP34xx and OMAP36xx processors contain a register in the syscon area,
which can be used to determine the SoCs temperature. This patch provides
a DT based driver for the temperature sensor based on an older driver
written by Peter De Schrijver for the Nokia N900 and N9.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/hwmon/Kconfig      |   8 ++
 drivers/hwmon/Makefile     |   1 +
 drivers/hwmon/omap3-temp.c | 307 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 316 insertions(+)
 create mode 100644 drivers/hwmon/omap3-temp.c

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 6529c09..749748d 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1135,6 +1135,14 @@ config SENSORS_NCT7802
 	  This driver can also be built as a module.  If so, the module
 	  will be called nct7802.
 
+config SENSORS_OMAP3_TEMP
+	tristate "OMAP3 Temperature Sensor"
+	depends on OF && (ARCH_OMAP3 || COMPILE_TEST)
+	select MFD_SYSCON
+	help
+	  If you say yes here you get support for the temperature sensor
+	  built into OMAP3 processors.
+
 config SENSORS_PCF8591
 	tristate "Philips PCF8591 ADC/DAC"
 	depends on I2C
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 6728064..5a69773 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -120,6 +120,7 @@ obj-$(CONFIG_SENSORS_NCT6683)	+= nct6683.o
 obj-$(CONFIG_SENSORS_NCT6775)	+= nct6775.o
 obj-$(CONFIG_SENSORS_NCT7802)	+= nct7802.o
 obj-$(CONFIG_SENSORS_NTC_THERMISTOR)	+= ntc_thermistor.o
+obj-$(CONFIG_SENSORS_OMAP3_TEMP)	+= omap3-temp.o
 obj-$(CONFIG_SENSORS_PC87360)	+= pc87360.o
 obj-$(CONFIG_SENSORS_PC87427)	+= pc87427.o
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
diff --git a/drivers/hwmon/omap3-temp.c b/drivers/hwmon/omap3-temp.c
new file mode 100644
index 0000000..5c331c5
--- /dev/null
+++ b/drivers/hwmon/omap3-temp.c
@@ -0,0 +1,307 @@
+/*
+ * omap3-temp.c - driver for OMAP34xx and OMAP36xx temperature sensor
+ *
+ * Copyright (c) 2014 Sebastian Reichel <sre@kernel.org>
+ * Copyright (C) 2008, 2009, 2010 Nokia Corporation
+ *
+ * based on Peter De Schrijver's driver for N9
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/clk.h>
+#include <linux/hrtimer.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/sched.h>
+#include <linux/stat.h>
+
+/* 32.768Khz clock speed in nano seconds */
+#define CLOCK_32K_SPEED_NS 30518
+
+/* minimum delay for EOCZ rise after SOC rise is
+ * 11 cycles of the 32.768Khz clock */
+#define EOCZ_MIN_RISING_DELAY (11 * CLOCK_32K_SPEED_NS)
+
+/* From docs, maximum delay for EOCZ rise after SOC rise is
+ * 14 cycles of the 32.768Khz clock. But after some experiments,
+ * 24 cycles as maximum is safer. */
+#define EOCZ_MAX_RISING_DELAY (24 * CLOCK_32K_SPEED_NS)
+
+/* minimum delay for EOCZ falling is
+ * 36 cycles of the 32.768Khz clock */
+#define EOCZ_MIN_FALLING_DELAY (36 * CLOCK_32K_SPEED_NS)
+
+/* maximum delay for EOCZ falling is
+ * 40 cycles of the 32.768Khz clock */
+#define EOCZ_MAX_FALLING_DELAY (40 * CLOCK_32K_SPEED_NS)
+
+/* temperature register offset in the syscon register area */
+#define SYSCON_TEMP_REG 0x02B4
+
+/* TRM: Table 7-11. ADC Codes Versus Temperature */
+static const int adc_to_temp_3430[] = {
+	-400, -400, -400, -400, -400, -390, -380, -360, -340, -320, -310,
+	-290, -280, -260, -250, -240, -220, -210, -190, -180, -170, -150,
+	-140, -120, -110, -90, -80, -70, -50, -40, -20, -10, 00, 10, 30,
+	40, 50, 70, 80, 100, 110, 130, 140, 150, 170, 180, 200, 210, 220,
+	240, 250, 270, 280, 300, 310, 320, 340, 350, 370, 380, 390, 410, 420,
+	440, 450, 470, 480, 490, 510, 520, 530, 550, 560, 580, 590, 600, 620,
+	630, 650, 660, 670, 690, 700, 720, 730, 740, 760, 770, 790, 800, 810,
+	830, 840, 850, 870, 880, 890, 910, 920, 940, 950, 960, 980, 990, 1000,
+	1020, 1030, 1050, 1060, 1070, 1090, 1100, 1110, 1130, 1140, 1160,
+	1170, 1180, 1200, 1210, 1220, 1240, 1240, 1250, 1250, 1250, 1250,
+	1250};
+
+/* TRM: Table 13-11. ADC Code Versus Temperature */
+static const int adc_to_temp_3630[] = {
+	-400, -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
+	-400, -400, -400, -380, -350, -340, -320, -300, -280, -260, -240,
+	-220, -200, -185, -170, -150, -135, -120, -100, -80, -65, -50, -35,
+	-15, 0, 20, 35, 50, 65, 85, 100, 120, 135, 150, 170, 190, 210, 230,
+	250, 270, 285, 300, 320, 335, 350, 370, 385, 400, 420, 435, 450, 470,
+	485, 500, 520, 535, 550, 570, 585, 600, 620, 640, 660, 680, 700, 715,
+	735, 750, 770, 785, 800, 820, 835, 850, 870, 885, 900, 920, 935, 950,
+	970, 985, 1000, 1020, 1035, 1050, 1070, 1090, 1110, 1130, 1150, 1170,
+	1185, 1200, 1220, 1235, 1250, 1250, 1250, 1250, 1250, 1250, 1250,
+	1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250,
+	1250, 1250, 1250};
+
+struct omap3_temp_type {
+	const int *adc_to_temp;
+	u8 soc_bit;
+	u8 eocz_bit;
+};
+
+/* TRM: Table 7-228. CONTROL_TEMP_SENSOR */
+static const struct omap3_temp_type omap34xx_temp_type = {
+	.eocz_bit = 7,
+	.soc_bit = 8,
+	.adc_to_temp = adc_to_temp_3430,
+};
+
+/* TRM: Table 13-239. CONTROL_TEMP_SENSOR */
+static const struct omap3_temp_type omap36xx_temp_type = {
+	.eocz_bit = 8,
+	.soc_bit = 9,
+	.adc_to_temp = adc_to_temp_3630,
+};
+
+struct omap3_temp_data {
+	struct device *hwmon_dev;
+	struct regmap *syscon;
+	struct clk *clk_32k;
+	struct omap3_temp_type *hwdata;
+	/* mutex to protect the update procedure while reading from sensor */
+	struct mutex update_lock;
+	const char *name;
+	unsigned long last_updated;
+	u32 temperature;
+	bool valid;
+};
+
+static inline u32 wait_for_eocz(int min_delay, int max_delay, u32 level,
+				struct omap3_temp_data *data)
+{
+	ktime_t timeout, expire;
+	u32 temp_sensor_reg, eocz_mask;
+
+	eocz_mask = BIT(data->hwdata->eocz_bit);
+	level &= 1;
+	level *= eocz_mask;
+
+	expire = ktime_add_ns(ktime_get(), max_delay);
+	timeout = ktime_set(0, min_delay);
+	__set_current_state(TASK_INTERRUPTIBLE);
+	schedule_hrtimeout(&timeout, HRTIMER_MODE_REL);
+	do {
+		regmap_read(data->syscon, SYSCON_TEMP_REG, &temp_sensor_reg);
+		if ((temp_sensor_reg & eocz_mask) == level)
+			break;
+	} while (ktime_us_delta(expire, ktime_get()) > 0);
+
+	return (temp_sensor_reg & eocz_mask) == level;
+}
+
+static int omap3_temp_update(struct omap3_temp_data *data)
+{
+	int e = 0;
+	u32 temp_sensor_reg;
+	u32 soc_mask = BIT(data->hwdata->soc_bit);
+
+	mutex_lock(&data->update_lock);
+
+	if (!data->valid || time_after(jiffies, data->last_updated + HZ)) {
+		clk_enable(data->clk_32k);
+
+		regmap_update_bits(data->syscon, SYSCON_TEMP_REG,
+				   soc_mask, soc_mask);
+
+		if (!wait_for_eocz(EOCZ_MIN_RISING_DELAY,
+		    EOCZ_MAX_RISING_DELAY, 1, data)) {
+			e = -EIO;
+			goto err;
+		}
+
+		regmap_update_bits(data->syscon, SYSCON_TEMP_REG, soc_mask, 0);
+
+		if (!wait_for_eocz(EOCZ_MIN_FALLING_DELAY,
+		    EOCZ_MAX_FALLING_DELAY, 0, data)) {
+			e = -EIO;
+			goto err;
+		}
+
+		regmap_read(data->syscon, SYSCON_TEMP_REG, &temp_sensor_reg);
+		data->temperature = temp_sensor_reg & ((1<<7) - 1);
+		data->last_updated = jiffies;
+		data->valid = true;
+
+err:
+		clk_disable(data->clk_32k);
+	}
+
+	mutex_unlock(&data->update_lock);
+	return e;
+}
+
+static ssize_t show_temp(struct device *dev,
+			 struct device_attribute *devattr, char *buf)
+{
+	struct omap3_temp_data *data = dev_get_drvdata(dev);
+	int temp;
+	int ret;
+
+	ret = omap3_temp_update(data);
+	if (ret < 0)
+		return ret;
+
+	temp = data->hwdata->adc_to_temp[data->temperature];
+
+	return sprintf(buf, "%d.%d\n", temp / 10, temp % 10);
+}
+
+static ssize_t show_name(struct device *dev,
+			 struct device_attribute *devattr, char *buf)
+{
+	struct omap3_temp_data *data = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", data->name);
+}
+
+static SENSOR_DEVICE_ATTR_2(temp_input, S_IRUGO, show_temp, NULL, 0, 0);
+static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
+
+static const struct of_device_id omap3_temp_dt_ids[] = {
+	{
+		.compatible = "ti,omap34xx-temperature-sensor",
+		.data = &omap34xx_temp_type,
+	},
+	{
+		.compatible = "ti,omap36xx-temperature-sensor",
+		.data = &omap36xx_temp_type,
+	},
+	{ }
+};
+MODULE_DEVICE_TABLE(of, omap3_temp_dt_ids);
+
+static int omap3_temp_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct omap3_temp_data *data;
+	const struct of_device_id *of_id;
+	int err;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	of_id = of_match_device(omap3_temp_dt_ids, &pdev->dev);
+	if (!of_id) {
+		dev_warn(&pdev->dev, "unsupported device!");
+		return -ENODEV;
+	}
+
+	mutex_init(&data->update_lock);
+	data->name = "omap3-temperature";
+
+	data->clk_32k = devm_clk_get(&pdev->dev, "fck");
+	if (IS_ERR(data->clk_32k))
+		return PTR_ERR(data->clk_32k);
+
+	data->hwdata = (struct omap3_temp_type *)of_id->data;
+
+	data->syscon = syscon_regmap_lookup_by_phandle(np, "syscon");
+	if (IS_ERR(data->syscon))
+		return PTR_ERR(data->syscon);
+
+	platform_set_drvdata(pdev, data);
+
+	err = device_create_file(&pdev->dev,
+				 &sensor_dev_attr_temp_input.dev_attr);
+	if (err)
+		goto fail_temp_file;
+
+	err = device_create_file(&pdev->dev, &dev_attr_name);
+	if (err)
+		goto fail_name_file;
+
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
+		goto fail_hwmon_reg;
+	}
+
+	return 0;
+
+fail_hwmon_reg:
+	device_remove_file(&pdev->dev, &dev_attr_name);
+fail_name_file:
+	device_remove_file(&pdev->dev, &sensor_dev_attr_temp_input.dev_attr);
+fail_temp_file:
+	return err;
+}
+
+static int omap3_temp_remove(struct platform_device *pdev)
+{
+	struct omap3_temp_data *data = platform_get_drvdata(pdev);
+
+	if (!data)
+		return 0;
+
+	hwmon_device_unregister(data->hwmon_dev);
+	device_remove_file(&pdev->dev, &dev_attr_name);
+	device_remove_file(&pdev->dev, &sensor_dev_attr_temp_input.dev_attr);
+
+	return 0;
+}
+
+static struct platform_driver omap3_temp_driver = {
+	.probe	= omap3_temp_probe,
+	.remove	= omap3_temp_remove,
+	.driver = {
+		.name	= "omap3-temperature",
+		.of_match_table	= omap3_temp_dt_ids,
+	},
+};
+
+module_platform_driver(omap3_temp_driver);
+
+MODULE_AUTHOR("Sebastian Reichel");
+MODULE_DESCRIPTION("OMAP34xx/OMAP36xx temperature sensor");
+MODULE_LICENSE("GPL");
-- 
2.1.3

