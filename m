Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941Ab3BZSZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:25:10 -0500
Received: from mail.active-venture.com ([67.228.131.205]:63034 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759923Ab3BZSYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:24:00 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 26 Feb 2013 12:23:57 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v5 11/12] hwmon: (nct6775) Detect and report additional temperature sources
Date: Tue, 26 Feb 2013 10:23:39 -0800
Message-Id: <1361903020-18526-12-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1361903020-18526-1-git-send-email-linux@roeck-us.net>
References: <1361903020-18526-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scan all temperature sources used for fan control and report if additional
monitoring registers are available.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/nct6775.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index 50e38c6..a4b076a 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -3361,6 +3361,32 @@ nct6775_check_fan_inputs(const struct nct6775_sio_data *sio_data,
 	return 0;
 }
 
+static void add_temp_sensors(struct nct6775_data *data, const u16 *regp,
+			     int *available, int *mask)
+{
+	int i;
+	u8 src;
+
+	for (i = 0; i < data->pwm_num && *available; i++) {
+		int index;
+
+		if (!regp[i])
+			continue;
+		src = nct6775_read_value(data, regp[i]);
+		src &= 0x1f;
+		if (!src || (*mask & (1 << src)))
+			continue;
+		if (src >= data->temp_label_num ||
+		    !strlen(data->temp_label[src]))
+			continue;
+
+		index = __ffs(*available);
+		nct6775_write_value(data, data->REG_TEMP_SOURCE[index], src);
+		*available &= ~(1 << index);
+		*mask |= 1 << src;
+	}
+}
+
 static int nct6775_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -3611,6 +3637,13 @@ static int nct6775_probe(struct platform_device *pdev)
 		mask |= 1 << src;
 	}
 
+	/*
+	 * Now find unmonitored temperature registers and enable monitoring
+	 * if additional monitoring registers are available.
+	 */
+	add_temp_sensors(data, data->REG_TEMP_SEL, &available, &mask);
+	add_temp_sensors(data, data->REG_WEIGHT_TEMP_SEL, &available, &mask);
+
 	mask = 0;
 	s = NUM_TEMP_FIXED;	/* First dynamic temperature attribute */
 	for (i = 0; i < num_reg_temp; i++) {
-- 
1.7.9.7

