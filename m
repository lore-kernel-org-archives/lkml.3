Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944Ab3BZSYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:24:03 -0500
Received: from mail.active-venture.com ([67.228.131.205]:55728 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759831Ab3BZSXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:23:55 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 26 Feb 2013 12:23:50 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v5 02/12] hwmon: (nct6775) Add case open detection
Date: Tue, 26 Feb 2013 10:23:30 -0800
Message-Id: <1361903020-18526-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1361903020-18526-1-git-send-email-linux@roeck-us.net>
References: <1361903020-18526-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/nct6775.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index f75cd82..435691f 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -76,6 +76,7 @@ MODULE_PARM_DESC(force_id, "Override the detected device ID");
  * Super-I/O constants and functions
  */
 
+#define NCT6775_LD_ACPI		0x0a
 #define NCT6775_LD_HWM		0x0b
 #define NCT6775_LD_VID		0x0d
 
@@ -186,6 +187,11 @@ static const s8 NCT6775_ALARM_BITS[] = {
 	4, 5, 13, -1, -1, -1,		/* temp1..temp6 */
 	12, -1 };			/* intrusion0, intrusion1 */
 
+#define INTRUSION_ALARM_BASE	30
+
+static const u8 NCT6775_REG_CR_CASEOPEN_CLR[] = { 0xe6, 0xee };
+static const u8 NCT6775_CR_CASEOPEN_CLR_MASK[] = { 0x20, 0x01 };
+
 /* NCT6776 specific data */
 
 static const s8 NCT6776_ALARM_BITS[] = {
@@ -694,6 +700,56 @@ show_vid(struct device *dev, struct device_attribute *attr, char *buf)
 
 static DEVICE_ATTR(cpu0_vid, S_IRUGO, show_vid, NULL);
 
+/* Case open detection */
+
+static ssize_t
+clear_caseopen(struct device *dev, struct device_attribute *attr,
+	       const char *buf, size_t count)
+{
+	struct nct6775_data *data = dev_get_drvdata(dev);
+	struct nct6775_sio_data *sio_data = dev->platform_data;
+	int nr = to_sensor_dev_attr(attr)->index - INTRUSION_ALARM_BASE;
+	unsigned long val;
+	u8 reg;
+	int ret;
+
+	if (kstrtoul(buf, 10, &val) || val != 0)
+		return -EINVAL;
+
+	mutex_lock(&data->update_lock);
+
+	/*
+	 * Use CR registers to clear caseopen status.
+	 * The CR registers are the same for all chips, and not all chips
+	 * support clearing the caseopen status through "regular" registers.
+	 */
+	ret = superio_enter(sio_data->sioreg);
+	if (ret) {
+		count = ret;
+		goto error;
+	}
+
+	superio_select(sio_data->sioreg, NCT6775_LD_ACPI);
+	reg = superio_inb(sio_data->sioreg, NCT6775_REG_CR_CASEOPEN_CLR[nr]);
+	reg |= NCT6775_CR_CASEOPEN_CLR_MASK[nr];
+	superio_outb(sio_data->sioreg, NCT6775_REG_CR_CASEOPEN_CLR[nr], reg);
+	reg &= ~NCT6775_CR_CASEOPEN_CLR_MASK[nr];
+	superio_outb(sio_data->sioreg, NCT6775_REG_CR_CASEOPEN_CLR[nr], reg);
+	superio_exit(sio_data->sioreg);
+
+	data->valid = false;	/* Force cache refresh */
+error:
+	mutex_unlock(&data->update_lock);
+	return count;
+}
+
+static struct sensor_device_attribute sda_caseopen[] = {
+	SENSOR_ATTR(intrusion0_alarm, S_IWUSR | S_IRUGO, show_alarm,
+		    clear_caseopen, INTRUSION_ALARM_BASE),
+	SENSOR_ATTR(intrusion1_alarm, S_IWUSR | S_IRUGO, show_alarm,
+		    clear_caseopen, INTRUSION_ALARM_BASE + 1),
+};
+
 /*
  * Driver and device management
  */
@@ -710,6 +766,9 @@ static void nct6775_device_remove_files(struct device *dev)
 	for (i = 0; i < data->in_num; i++)
 		sysfs_remove_group(&dev->kobj, &nct6775_group_in[i]);
 
+	device_remove_file(dev, &sda_caseopen[0].dev_attr);
+	device_remove_file(dev, &sda_caseopen[1].dev_attr);
+
 	device_remove_file(dev, &dev_attr_name);
 	device_remove_file(dev, &dev_attr_cpu0_vid);
 }
@@ -828,6 +887,14 @@ static int nct6775_probe(struct platform_device *pdev)
 			goto exit_remove;
 	}
 
+	for (i = 0; i < ARRAY_SIZE(sda_caseopen); i++) {
+		if (data->ALARM_BITS[INTRUSION_ALARM_BASE + i] < 0)
+			continue;
+		err = device_create_file(dev, &sda_caseopen[i].dev_attr);
+		if (err)
+			goto exit_remove;
+	}
+
 	err = device_create_file(dev, &dev_attr_name);
 	if (err)
 		goto exit_remove;
-- 
1.7.9.7

