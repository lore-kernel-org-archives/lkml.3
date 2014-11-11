Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaKKNZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:25:38 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57956 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaKKNZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:25:35 -0500
Message-ID: <54620E62.4040803@gmail.com>
Date: Tue, 11 Nov 2014 14:25:54 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [RESEND][PATCH 5/5] Export the temperatures via hwmon
References: <1407567003-18332-1-git-send-email-kreijack@inwind.it>
In-Reply-To: <1407567003-18332-1-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the temperature via the hwmon subsystem.
See the list below for the sensors exported:

$ cd /sys/devices/temperature/hwmon/hwmon0
$ echo "name: $(cat name)"; for i in temp*; do echo "$i: $(cat $i)"; done
name: therm_windtunnel
temp1_input: 59312
temp1_label: CPU
temp2_input: 36750
temp2_label: Case
temp3_input: 37750
temp3_label: Case2

The Case2 temperature is the sensor temperature inside the adm1030.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 drivers/macintosh/therm_windtunnel.c | 96 ++++++++++++++++++++++++++++++++++--
 1 file changed, 92 insertions(+), 4 deletions(-)

diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index 30a6588..fd9061d 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -37,6 +37,8 @@
 #include <linux/init.h>
 #include <linux/kthread.h>
 #include <linux/of_platform.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
 
 #include <asm/prom.h>
 #include <asm/machdep.h>
@@ -58,9 +60,12 @@ static struct {
 	struct i2c_client	*thermostat;
 	struct i2c_client	*fan;
 
+	struct device		*hwmon;
+
 	int			overheat_temp;		/* 100% fan at this temp */
 	int			overheat_hyst;
 	int			temp;
+	int			casetemp2;
 	int			casetemp;
 	int			fan_level;		/* active fan_table setting */
 
@@ -120,6 +125,66 @@ static DEVICE_ATTR(case_temperature, S_IRUGO, show_case_temperature, NULL );
 static DEVICE_ATTR(fan_level, S_IRUGO, show_fan_level, NULL);
 
 
+static ssize_t
+show_temp1(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d%03d\n", x.temp>>8,
+					(x.temp & 0xff) * 1000 / 256);
+}
+
+static ssize_t
+show_temp1_label(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "CPU\n");
+}
+
+static ssize_t
+show_temp2(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d%03d\n", x.casetemp>>8,
+					(x.casetemp & 0xff) * 1000 / 256);
+}
+
+static ssize_t
+show_temp2_label(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "Case\n");
+}
+
+
+static ssize_t
+show_temp3(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d%03d\n", x.casetemp2>>8,
+					(x.casetemp2 & 0xff) * 1000 / 256);
+}
+
+static ssize_t
+show_temp3_label(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "Case2\n");
+}
+
+static DEVICE_ATTR(temp1_input, S_IRUGO, show_temp1, NULL);
+static DEVICE_ATTR(temp1_label, S_IRUGO, show_temp1_label, NULL);
+static DEVICE_ATTR(temp2_input, S_IRUGO, show_temp2, NULL);
+static DEVICE_ATTR(temp2_label, S_IRUGO, show_temp2_label, NULL);
+static DEVICE_ATTR(temp3_input, S_IRUGO, show_temp3, NULL);
+static DEVICE_ATTR(temp3_label, S_IRUGO, show_temp3_label, NULL);
+
+static struct attribute  *therm_windtunnel_attrs[] = {
+	&dev_attr_temp1_input.attr,
+	&dev_attr_temp1_label.attr,
+	&dev_attr_temp2_input.attr,
+	&dev_attr_temp2_label.attr,
+	&dev_attr_temp3_input.attr,
+	&dev_attr_temp3_label.attr,
+
+	NULL,
+};
+
+ATTRIBUTE_GROUPS(therm_windtunnel);
+
 /************************************************************************/
 /*	controller thread						*/
 /************************************************************************/
@@ -172,16 +237,23 @@ tune_fan( int fan_setting )
 static void
 poll_temp( void )
 {
-	int temp, i, level, casetemp, tempchanged;
+	int temp, i, level, casetemp, tempchanged, casetemp2, reg06;
 
+	/* temperature read from ds1775 */
 	temp = read_reg( x.thermostat, 0, 2 );
 
 	/* this actually occurs when the computer is loaded */
 	if( temp < 0 )
 		return;
 
-	casetemp = read_reg(x.fan, 0x0b, 1) << 8;
-	casetemp |= (read_reg(x.fan, 0x06, 1) & 0x7) << 5;
+	/*
+	 * temperatures read from the adm1030
+	 * casetemp is the external temperature sensor
+	 * casetemp2 is the internal temperature sensor
+	 */
+	reg06 = read_reg(x.fan, 0x06, 1);
+	casetemp = (read_reg(x.fan, 0x0b, 1) << 8) | (reg06 & 0x07 << 5);
+	casetemp2 = (read_reg(x.fan, 0x0a, 1) << 8) | (reg06 & 0xc0);
 
 	level = -1;
 	for( i=0; (temp & 0xffff) > fan_table[i].temp ; i++ )
@@ -200,12 +272,15 @@ poll_temp( void )
 	 * if verbose >=1 log each fan tuning
 	 * if verbose >=2 log each cpu temperature change
 	 */
-	tempchanged = x.temp != temp || x.casetemp != casetemp;
+	tempchanged = x.temp != temp || x.casetemp != casetemp ||
+		x.casetemp2 != casetemp2;
 	if ((verbose > 1 && tempchanged) ||
 	    (verbose > 0 && level >= 0)) {
 		print_temp(KERN_INFO "CPU-temp: ", temp);
 		if (casetemp)
 			print_temp(", Case: ", casetemp);
+		if (casetemp2)
+			print_temp(", Case2: ", casetemp2);
 		if (level >= 0)
 			printk(", Fan: %d (tuned %+d)\n", 11-level,
 				x.fan_level-level);
@@ -215,6 +290,7 @@ poll_temp( void )
 
 	x.temp = temp;
 	x.casetemp = casetemp;
+	x.casetemp2 = casetemp2;
 
 	if( level >= 0 )
 		tune_fan( level );
@@ -274,11 +350,23 @@ setup_hardware( void )
 	if (err)
 		printk(KERN_WARNING
 			"Failed to create temperature attribute file(s).\n");
+
+	x.hwmon = hwmon_device_register_with_groups(&x.of_dev->dev,
+			"therm_windtunnel", NULL,
+			therm_windtunnel_groups);
+	if (IS_ERR(x.hwmon)) {
+		dev_warn(&x.of_dev->dev, "Failed to create the hwmon device\n");
+		x.hwmon = NULL;
+	}
 }
 
 static void
 restore_regs( void )
 {
+	if (x.hwmon)
+		hwmon_device_unregister(x.hwmon);
+	x.hwmon = NULL;
+
 	device_remove_file( &x.of_dev->dev, &dev_attr_cpu_temperature );
 	device_remove_file( &x.of_dev->dev, &dev_attr_case_temperature );
 	device_remove_file(&x.of_dev->dev, &dev_attr_fan_level);
-- 
2.1.0.rc1


