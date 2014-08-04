Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaHDREV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:04:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56544 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Axel Lin" <axel.lin@ingics.com>,
        "Guenter Roeck" <linux@roeck-us.net>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.480620970@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 52/94] hwmon: (adt7470) Fix writes to temperature
 limit registers
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit de12d6f4b10b21854441f5242dcb29ea96181e58 upstream.

Temperature limit registers are signed. Limits therefore need
to be clamped to (-128, 127) degrees C and not to (0, 255)
degrees C.

Without this fix, writing a limit of 128 degrees C sets the
actual limit to -128 degrees C.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Axel Lin <axel.lin@ingics.com>
[bwh: Backported to 3.2: driver was using SENSORS_LIMIT(), which we can
 replace with clamp_val()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/adt7470.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -515,7 +515,7 @@ static ssize_t set_temp_min(struct devic
 		return -EINVAL;
 
 	temp = DIV_ROUND_CLOSEST(temp, 1000);
-	temp = SENSORS_LIMIT(temp, 0, 255);
+	temp = clamp_val(temp, -128, 127);
 
 	mutex_lock(&data->lock);
 	data->temp_min[attr->index] = temp;
@@ -549,7 +549,7 @@ static ssize_t set_temp_max(struct devic
 		return -EINVAL;
 
 	temp = DIV_ROUND_CLOSEST(temp, 1000);
-	temp = SENSORS_LIMIT(temp, 0, 255);
+	temp = clamp_val(temp, -128, 127);
 
 	mutex_lock(&data->lock);
 	data->temp_max[attr->index] = temp;
@@ -826,7 +826,7 @@ static ssize_t set_pwm_tmin(struct devic
 		return -EINVAL;
 
 	temp = DIV_ROUND_CLOSEST(temp, 1000);
-	temp = SENSORS_LIMIT(temp, 0, 255);
+	temp = clamp_val(temp, -128, 127);
 
 	mutex_lock(&data->lock);
 	data->pwm_tmin[attr->index] = temp;

