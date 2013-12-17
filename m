Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab3LQSTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:19:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32937 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab3LQSPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jean Delvare <khali@linux-fr.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 093/103] hwmon: (w83l768ng) Fix fan speed control range
Date: Tue, 17 Dec 2013 18:13:22 +0000
Message-Id: <1387304012-23805-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 33a7ab91d509fa33b4bcd3ce0038cc80298050da upstream.

The W83L786NG stores the fan speed on 4 bits while the sysfs interface
uses a 0-255 range. Thus the driver should scale the user input down
to map it to the device range, and scale up the value read from the
device before presenting it to the user. The reserved register nibble
should be left unchanged.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/w83l786ng.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/w83l786ng.c b/drivers/hwmon/w83l786ng.c
index a97a620..284d469 100644
--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -481,9 +481,11 @@ store_pwm(struct device *dev, struct device_attribute *attr,
 	if (err)
 		return err;
 	val = SENSORS_LIMIT(val, 0, 255);
+	val = DIV_ROUND_CLOSEST(val, 0x11);
 
 	mutex_lock(&data->update_lock);
-	data->pwm[nr] = val;
+	data->pwm[nr] = val * 0x11;
+	val |= w83l786ng_read_value(client, W83L786NG_REG_PWM[nr]) & 0xf0;
 	w83l786ng_write_value(client, W83L786NG_REG_PWM[nr], val);
 	mutex_unlock(&data->update_lock);
 	return count;
@@ -782,8 +784,9 @@ static struct w83l786ng_data *w83l786ng_update_device(struct device *dev)
 			    ? 0 : 1;
 			data->pwm_enable[i] =
 			    ((pwmcfg >> W83L786NG_PWM_ENABLE_SHIFT[i]) & 3) + 1;
-			data->pwm[i] = w83l786ng_read_value(client,
-			    W83L786NG_REG_PWM[i]);
+			data->pwm[i] =
+			    (w83l786ng_read_value(client, W83L786NG_REG_PWM[i])
+			     & 0x0f) * 0x11;
 		}
 
 
-- 
1.8.3.2

