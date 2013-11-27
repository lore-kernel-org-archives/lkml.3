Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913Ab3K0CHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:07:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab3K0A4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:56:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.4 29/39] hwmon: (lm90) Fix max6696 alarm handling
Date: Tue, 26 Nov 2013 16:56:53 -0800
Message-Id: <20131127005621.086816456@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005619.011763867@linuxfoundation.org>
References: <20131127005619.011763867@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit e41fae2b1ed8c78283d73651cd65be0228c0dd1c upstream.

Bit 2 of status register 2 on MAX6696 (external diode 2 open)
sets ALERT; the bit thus has to be listed in alert_alarms.
Also display a message in the alert handler if the condition
is encountered.

Even though not all overtemperature conditions cause ALERT
to be set, we should not ignore them in the alert handler.
Display messages for all out-of-range conditions.

Reported-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/lm90.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -278,7 +278,7 @@ static const struct lm90_params lm90_par
 	[max6696] = {
 		.flags = LM90_HAVE_EMERGENCY
 		  | LM90_HAVE_EMERGENCY_ALARM | LM90_HAVE_TEMP3,
-		.alert_alarms = 0x187c,
+		.alert_alarms = 0x1c7c,
 		.max_convrate = 6,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
@@ -1504,19 +1504,22 @@ static void lm90_alert(struct i2c_client
 	if ((alarms & 0x7f) == 0 && (alarms2 & 0xfe) == 0) {
 		dev_info(&client->dev, "Everything OK\n");
 	} else {
-		if (alarms & 0x61)
+		if ((alarms & 0x61) || (alarms2 & 0x80))
 			dev_warn(&client->dev,
 				 "temp%d out of range, please check!\n", 1);
-		if (alarms & 0x1a)
+		if ((alarms & 0x1a) || (alarms2 & 0x20))
 			dev_warn(&client->dev,
 				 "temp%d out of range, please check!\n", 2);
 		if (alarms & 0x04)
 			dev_warn(&client->dev,
 				 "temp%d diode open, please check!\n", 2);
 
-		if (alarms2 & 0x18)
+		if (alarms2 & 0x5a)
 			dev_warn(&client->dev,
 				 "temp%d out of range, please check!\n", 3);
+		if (alarms2 & 0x04)
+			dev_warn(&client->dev,
+				 "temp%d diode open, please check!\n", 3);
 
 		/*
 		 * Disable ALERT# output, because these chips don't implement


