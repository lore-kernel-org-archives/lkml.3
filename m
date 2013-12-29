Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3L2C2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:28:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55517 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089Ab3L2CK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Guenter Roeck" <linux@roeck-us.net>,
        "Jean Delvare" <khali@linux-fr.org>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.174179991@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 066/185] hwmon: (lm90) Fix max6696 alarm handling
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/lm90.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -268,7 +268,7 @@ static const struct lm90_params lm90_par
 	[max6696] = {
 		.flags = LM90_HAVE_EMERGENCY
 		  | LM90_HAVE_EMERGENCY_ALARM | LM90_HAVE_TEMP3,
-		.alert_alarms = 0x187c,
+		.alert_alarms = 0x1c7c,
 		.max_convrate = 6,
 		.reg_local_ext = MAX6657_REG_R_LOCAL_TEMPL,
 	},
@@ -1474,19 +1474,22 @@ static void lm90_alert(struct i2c_client
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
 
 		/* Disable ALERT# output, because these chips don't implement
 		  SMBus alert correctly; they should only hold the alert line

