Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162290Ab3LFNGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:06:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44849 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162218Ab3LFNGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:06:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 271/272] hwmon: (lm90) Fix max6696 alarm handling
Date: Fri,  6 Dec 2013 12:59:20 +0000
Message-Id: <1386334761-25517-272-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/lm90.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index cdff742..14e36c1 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -278,7 +278,7 @@ static const struct lm90_params lm90_params[] = {
 	[max6696] = {
 		.flags = LM90_HAVE_EMERGENCY
 		  | LM90_HAVE_EMERGENCY_ALARM | LM90_HAVE_TEMP3,
-		.alert_alarms = 0x187c,
+		.alert_alarms = 0x1c7c,
 		.max_convrate = 6,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
@@ -1500,19 +1500,22 @@ static void lm90_alert(struct i2c_client *client, unsigned int flag)
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
-- 
1.8.3.2

