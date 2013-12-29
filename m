Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab3L2Cwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:52:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55192 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271Ab3L2CKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:10 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jean Delvare" <khali@linux-fr.org>,
        "Brian Carnes" <bmcarnes@gmail.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.876812081@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 138/185] hwmon: (w83l786ng) Fix fan speed control mode
 setting and reporting
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Carnes <bmcarnes@gmail.com>

commit cf7559bc053471f32373d71d04a9aa19e0b48d59 upstream.

The wrong mask is used, which causes some fan speed control modes
(pwmX_enable) to be incorrectly reported, and some modes to be
impossible to set.

[JD: add subject and description.]

Signed-off-by: Brian Carnes <bmcarnes@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/w83l786ng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -471,7 +471,7 @@ store_pwm_enable(struct device *dev, str
 	mutex_lock(&data->update_lock);
 	reg = w83l786ng_read_value(client, W83L786NG_REG_FAN_CFG);
 	data->pwm_enable[nr] = val;
-	reg &= ~(0x02 << W83L786NG_PWM_ENABLE_SHIFT[nr]);
+	reg &= ~(0x03 << W83L786NG_PWM_ENABLE_SHIFT[nr]);
 	reg |= (val - 1) << W83L786NG_PWM_ENABLE_SHIFT[nr];
 	w83l786ng_write_value(client, W83L786NG_REG_FAN_CFG, reg);
 	mutex_unlock(&data->update_lock);
@@ -740,7 +740,7 @@ static struct w83l786ng_data *w83l786ng_
 			    ((pwmcfg >> W83L786NG_PWM_MODE_SHIFT[i]) & 1)
 			    ? 0 : 1;
 			data->pwm_enable[i] =
-			    ((pwmcfg >> W83L786NG_PWM_ENABLE_SHIFT[i]) & 2) + 1;
+			    ((pwmcfg >> W83L786NG_PWM_ENABLE_SHIFT[i]) & 3) + 1;
 			data->pwm[i] = w83l786ng_read_value(client,
 			    W83L786NG_REG_PWM[i]);
 		}

