Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbaAFWmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:42:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933427AbaAFWmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.4 43/43] hwmon: (w83l768ng) Fix fan speed control range
Date: Mon,  6 Jan 2014 14:40:00 -0800
Message-Id: <20140106223943.487291092@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223942.259651490@linuxfoundation.org>
References: <20140106223942.259651490@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
 	val = SENSORS_LIMIT(val, 0, 255);
+	val = DIV_ROUND_CLOSEST(val, 0x11);
 
 	mutex_lock(&data->update_lock);
-	data->pwm[nr] = val;
+	data->pwm[nr] = val * 0x11;
+	val |= w83l786ng_read_value(client, W83L786NG_REG_PWM[nr]) & 0xf0;
 	w83l786ng_write_value(client, W83L786NG_REG_PWM[nr], val);
 	mutex_unlock(&data->update_lock);
 	return count;
@@ -782,8 +784,9 @@ static struct w83l786ng_data *w83l786ng_
 			    ? 0 : 1;
 			data->pwm_enable[i] =
 			    ((pwmcfg >> W83L786NG_PWM_ENABLE_SHIFT[i]) & 3) + 1;
-			data->pwm[i] = w83l786ng_read_value(client,
-			    W83L786NG_REG_PWM[i]);
+			data->pwm[i] =
+			    (w83l786ng_read_value(client, W83L786NG_REG_PWM[i])
+			     & 0x0f) * 0x11;
 		}
 
 


