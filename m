Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab3LSMH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:07:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab3LSL7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Carnes <bmcarnes@gmail.com>, Jean Delvare <khali@linux-fr.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 188/208] hwmon: (w83l786ng) Fix fan speed control mode setting and reporting
Date: Thu, 19 Dec 2013 11:54:46 +0000
Message-Id: <1387454106-19326-189-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Carnes <bmcarnes@gmail.com>

commit cf7559bc053471f32373d71d04a9aa19e0b48d59 upstream.

The wrong mask is used, which causes some fan speed control modes
(pwmX_enable) to be incorrectly reported, and some modes to be
impossible to set.

[JD: add subject and description.]

Signed-off-by: Brian Carnes <bmcarnes@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/w83l786ng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/w83l786ng.c b/drivers/hwmon/w83l786ng.c
index edb06cd..f190219 100644
--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -510,7 +510,7 @@ store_pwm_enable(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&data->update_lock);
 	reg = w83l786ng_read_value(client, W83L786NG_REG_FAN_CFG);
 	data->pwm_enable[nr] = val;
-	reg &= ~(0x02 << W83L786NG_PWM_ENABLE_SHIFT[nr]);
+	reg &= ~(0x03 << W83L786NG_PWM_ENABLE_SHIFT[nr]);
 	reg |= (val - 1) << W83L786NG_PWM_ENABLE_SHIFT[nr];
 	w83l786ng_write_value(client, W83L786NG_REG_FAN_CFG, reg);
 	mutex_unlock(&data->update_lock);
@@ -776,7 +776,7 @@ static struct w83l786ng_data *w83l786ng_update_device(struct device *dev)
 			    ((pwmcfg >> W83L786NG_PWM_MODE_SHIFT[i]) & 1)
 			    ? 0 : 1;
 			data->pwm_enable[i] =
-			    ((pwmcfg >> W83L786NG_PWM_ENABLE_SHIFT[i]) & 2) + 1;
+			    ((pwmcfg >> W83L786NG_PWM_ENABLE_SHIFT[i]) & 3) + 1;
 			data->pwm[i] = w83l786ng_read_value(client,
 			    W83L786NG_REG_PWM[i]);
 		}
-- 
1.8.3.2

