Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934192AbaICWYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:24:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933893AbaICWSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.16 047/125] hwmon: (lm92) Prevent overflow problem when writing large limits
Date: Wed,  3 Sep 2014 15:06:44 -0700
Message-Id: <20140903220625.060915740@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/lm92.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/hwmon/lm92.c
+++ b/drivers/hwmon/lm92.c
@@ -74,12 +74,9 @@ static inline int TEMP_FROM_REG(s16 reg)
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
 
@@ -206,10 +203,12 @@ static ssize_t set_temp_hyst(struct devi
 	if (err)
 		return err;
 
+	val = clamp_val(val, -120000, 220000);
 	mutex_lock(&data->update_lock);
-	data->temp[t_hyst] = TEMP_FROM_REG(data->temp[attr->index]) - val;
+	 data->temp[t_hyst] =
+		TEMP_TO_REG(TEMP_FROM_REG(data->temp[attr->index]) - val);
 	i2c_smbus_write_word_swapped(client, LM92_REG_TEMP_HYST,
-				     TEMP_TO_REG(data->temp[t_hyst]));
+				     data->temp[t_hyst]);
 	mutex_unlock(&data->update_lock);
 	return count;
 }


