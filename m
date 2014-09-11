Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaIKMsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:48:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51610 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755426AbaIKMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Guenter Roeck" <linux@roeck-us.net>,
        "Axel Lin" <axel.lin@ingics.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.781946473@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 055/131] hwmon: (lm92) Prevent overflow problem when
 writing large limits
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 5b963089161b8fb244889c972edf553b9d737545 upstream.

On platforms with sizeof(int) < sizeof(long), writing a temperature
limit larger than MAXINT will result in unpredictable limit values
written to the chip. Avoid auto-conversion from long to int to fix
the problem.

The hysteresis temperature range depends on the value of
data->temp[attr->index], since val is subtracted from it.
Use a wider clamp, [-120000, 220000] should do to cover the
possible range. Also add missing TEMP_TO_REG() on writes into
cached hysteresis value.

Also uses clamp_val to simplify the code a bit.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
[Guenter Roeck: Fixed double TEMP_TO_REG on hysteresis updates]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[bwh: Backported to 3.2:
 - s/temp\[attr->index\]/temp1_crit/
 - s/temp\[t_hyst\]/temp1_hyst/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/lm92.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/hwmon/lm92.c
+++ b/drivers/hwmon/lm92.c
@@ -73,12 +73,9 @@ static inline int TEMP_FROM_REG(s16 reg)
 	return reg / 8 * 625 / 10;
 }
 
-static inline s16 TEMP_TO_REG(int val)
+static inline s16 TEMP_TO_REG(long val)
 {
-	if (val <= -60000)
-		return -60000 * 10 / 625 * 8;
-	if (val >= 160000)
-		return 160000 * 10 / 625 * 8;
+	val = clamp_val(val, -60000, 160000);
 	return val * 10 / 625 * 8;
 }
 
@@ -192,10 +189,12 @@ static ssize_t set_temp1_crit_hyst(struc
 	struct lm92_data *data = i2c_get_clientdata(client);
 	long val = simple_strtol(buf, NULL, 10);
 
+	val = clamp_val(val, -120000, 220000);
 	mutex_lock(&data->update_lock);
-	data->temp1_hyst = TEMP_FROM_REG(data->temp1_crit) - val;
+	 data->temp1_hyst =
+		TEMP_TO_REG(TEMP_FROM_REG(data->temp1_crit) - val);
 	i2c_smbus_write_word_swapped(client, LM92_REG_TEMP_HYST,
-				     TEMP_TO_REG(data->temp1_hyst));
+				     data->temp1_hyst);
 	mutex_unlock(&data->update_lock);
 	return count;
 }

