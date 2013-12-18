Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab3LRWP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:15:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35806 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3LRVJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:09:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian Carnes <bmcarnes@gmail.com>, Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 3.4 08/31] hwmon: (w83l786ng) Fix fan speed control mode setting and reporting
Date: Wed, 18 Dec 2013 13:08:16 -0800
Message-Id: <20131218210523.032171995@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
References: <20131218210522.790152625@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Carnes <bmcarnes@gmail.com>

commit cf7559bc053471f32373d71d04a9aa19e0b48d59 upstream.

The wrong mask is used, which causes some fan speed control modes
(pwmX_enable) to be incorrectly reported, and some modes to be
impossible to set.

[JD: add subject and description.]

Signed-off-by: Brian Carnes <bmcarnes@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/w83l786ng.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -510,7 +510,7 @@ store_pwm_enable(struct device *dev, str
 	mutex_lock(&data->update_lock);
 	reg = w83l786ng_read_value(client, W83L786NG_REG_FAN_CFG);
 	data->pwm_enable[nr] = val;
-	reg &= ~(0x02 << W83L786NG_PWM_ENABLE_SHIFT[nr]);
+	reg &= ~(0x03 << W83L786NG_PWM_ENABLE_SHIFT[nr]);
 	reg |= (val - 1) << W83L786NG_PWM_ENABLE_SHIFT[nr];
 	w83l786ng_write_value(client, W83L786NG_REG_FAN_CFG, reg);
 	mutex_unlock(&data->update_lock);
@@ -781,7 +781,7 @@ static struct w83l786ng_data *w83l786ng_
 			    ((pwmcfg >> W83L786NG_PWM_MODE_SHIFT[i]) & 1)
 			    ? 0 : 1;
 			data->pwm_enable[i] =
-			    ((pwmcfg >> W83L786NG_PWM_ENABLE_SHIFT[i]) & 2) + 1;
+			    ((pwmcfg >> W83L786NG_PWM_ENABLE_SHIFT[i]) & 3) + 1;
 			data->pwm[i] = w83l786ng_read_value(client,
 			    W83L786NG_REG_PWM[i]);
 		}


