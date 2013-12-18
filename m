Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3LRWM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:12:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab3LRVL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:11:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.10 20/78] hwmon: (w83l768ng) Fix fan speed control range
Date: Wed, 18 Dec 2013 13:10:48 -0800
Message-Id: <20131218211112.474420891@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/w83l786ng.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -481,9 +481,11 @@ store_pwm(struct device *dev, struct dev
 	if (err)
 		return err;
 	val = clamp_val(val, 0, 255);
+	val = DIV_ROUND_CLOSEST(val, 0x11);
 
 	mutex_lock(&data->update_lock);
-	data->pwm[nr] = val;
+	data->pwm[nr] = val * 0x11;
+	val |= w83l786ng_read_value(client, W83L786NG_REG_PWM[nr]) & 0xf0;
 	w83l786ng_write_value(client, W83L786NG_REG_PWM[nr], val);
 	mutex_unlock(&data->update_lock);
 	return count;
@@ -777,8 +779,9 @@ static struct w83l786ng_data *w83l786ng_
 			    ? 0 : 1;
 			data->pwm_enable[i] =
 			    ((pwmcfg >> W83L786NG_PWM_ENABLE_SHIFT[i]) & 3) + 1;
-			data->pwm[i] = w83l786ng_read_value(client,
-			    W83L786NG_REG_PWM[i]);
+			data->pwm[i] =
+			    (w83l786ng_read_value(client, W83L786NG_REG_PWM[i])
+			     & 0x0f) * 0x11;
 		}
 
 


