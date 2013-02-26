Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876Ab3BZSX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:23:57 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57074 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759802Ab3BZSXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:23:55 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 26 Feb 2013 12:23:54 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v5 07/12] hwmon: (nct6775) Add power management support
Date: Tue, 26 Feb 2013 10:23:35 -0800
Message-Id: <1361903020-18526-8-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1361903020-18526-1-git-send-email-linux@roeck-us.net>
References: <1361903020-18526-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/nct6775.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index ac8be97..96e2ee1 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -508,6 +508,12 @@ struct nct6775_data {
 	u16 have_temp;
 	u16 have_temp_fixed;
 	u16 have_in;
+#ifdef CONFIG_PM
+	/* Remember extra register values over suspend/resume */
+	u8 vbat;
+	u8 fandiv1;
+	u8 fandiv2;
+#endif
 };
 
 struct nct6775_sio_data {
@@ -2267,10 +2273,90 @@ static int nct6775_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int nct6775_suspend(struct device *dev)
+{
+	struct nct6775_data *data = nct6775_update_device(dev);
+	struct nct6775_sio_data *sio_data = dev->platform_data;
+
+	mutex_lock(&data->update_lock);
+	data->vbat = nct6775_read_value(data, data->REG_VBAT);
+	if (sio_data->kind == nct6775) {
+		data->fandiv1 = nct6775_read_value(data, NCT6775_REG_FANDIV1);
+		data->fandiv2 = nct6775_read_value(data, NCT6775_REG_FANDIV2);
+	}
+	mutex_unlock(&data->update_lock);
+
+	return 0;
+}
+
+static int nct6775_resume(struct device *dev)
+{
+	struct nct6775_data *data = dev_get_drvdata(dev);
+	struct nct6775_sio_data *sio_data = dev->platform_data;
+	int i, j;
+
+	mutex_lock(&data->update_lock);
+	data->bank = 0xff;		/* Force initial bank selection */
+
+	/* Restore limits */
+	for (i = 0; i < data->in_num; i++) {
+		if (!(data->have_in & (1 << i)))
+			continue;
+
+		nct6775_write_value(data, data->REG_IN_MINMAX[0][i],
+				    data->in[i][1]);
+		nct6775_write_value(data, data->REG_IN_MINMAX[1][i],
+				    data->in[i][2]);
+	}
+
+	for (i = 0; i < 5; i++) {
+		if (!(data->has_fan_min & (1 << i)))
+			continue;
+
+		nct6775_write_value(data, data->REG_FAN_MIN[i],
+				    data->fan_min[i]);
+	}
+
+	for (i = 0; i < NUM_TEMP; i++) {
+		if (!(data->have_temp & (1 << i)))
+			continue;
+
+		for (j = 1; j < 4; j++)
+			if (data->reg_temp[j][i])
+				nct6775_write_temp(data, data->reg_temp[j][i],
+						   data->temp[j][i]);
+	}
+
+	/* Restore other settings */
+	nct6775_write_value(data, data->REG_VBAT, data->vbat);
+	if (sio_data->kind == nct6775) {
+		nct6775_write_value(data, NCT6775_REG_FANDIV1, data->fandiv1);
+		nct6775_write_value(data, NCT6775_REG_FANDIV2, data->fandiv2);
+	}
+
+	/* Force re-reading all values */
+	data->valid = false;
+	mutex_unlock(&data->update_lock);
+
+	return 0;
+}
+
+static const struct dev_pm_ops nct6775_dev_pm_ops = {
+	.suspend = nct6775_suspend,
+	.resume = nct6775_resume,
+};
+
+#define NCT6775_DEV_PM_OPS	(&nct6775_dev_pm_ops)
+#else
+#define NCT6775_DEV_PM_OPS	NULL
+#endif /* CONFIG_PM */
+
 static struct platform_driver nct6775_driver = {
 	.driver = {
 		.owner	= THIS_MODULE,
 		.name	= DRVNAME,
+		.pm	= NCT6775_DEV_PM_OPS,
 	},
 	.probe		= nct6775_probe,
 	.remove		= nct6775_remove,
-- 
1.7.9.7

