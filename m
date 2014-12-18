Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaLRKOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:14:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21602 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaLRKOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:14:32 -0500
X-AuditID: cbfee61a-f79c06d000004e71-cd-5492a9063925
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>,
        Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH 5/9] hwmon: thermal: Extract __set_pwm() function to only
 modify PWM duty cycle
Date: Thu, 18 Dec 2014 11:13:07 +0100
Message-id: <1418897591-18332-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t9jQV22lZNCDO6slbGYf+Qcq8X8K9dY
	LZbe/cRm8eP1BTaL3gVX2SzePOK2ePNwM6PF5V1z2Cw+9x5htJhxfh+TxZOFZ5gs7kzby2Zx
	+E07qwOvx85Zd9k9HkzczeaxbtpbZo+d3xvYPfq2rGL02Hy62uPzJrkA9igum5TUnMyy1CJ9
	uwSujKZr55kL9vFXbJjTw97AuImni5GTQ0LAROLWscVMELaYxIV769m6GLk4hASmM0rM3fOC
	CcLpYpL4/Ok8O0gVm4CexOe7T8ESIgIzGCX2N31jB3GYBb4zSTRtXcoCUiUskCix79dkNhCb
	RUBVYs+i64wgNq+Am8TrvS+h9ilKdD+bAFbDKeAuMec5hC0EVNP09xLzBEbeBYwMqxhFUwuS
	C4qT0nMN9YoTc4tL89L1kvNzNzGCw/SZ1A7GlQ0WhxgFOBiVeHgl9CaFCLEmlhVX5h5ilOBg
	VhLhjc4BCvGmJFZWpRblxxeV5qQWH2KU5mBREudVsm8LERJITyxJzU5NLUgtgskycXBKNTAu
	SGaS0px+/cHBwNWr+VlieCWvKFYeXZGue2VBhnLLp7cqj159/zDvTs/E/uOadmEBZUXiO6RZ
	NWZ8PefX/m5i78tK+2TT6ParxwqN/2VcXfXLzfxG/VxLrbsfgv7XN9gJHjnxm1Vkw6trL5gE
	zN9d3M7bfm/1celE3zMfC2fnnnV1eRw7yfaZEktxRqKhFnNRcSIA83O2z08CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was necessary to decouple code handling writing to sysfs from the one
responsible for setting PWM of the fan.
Due to that, new __set_pwm() method was extracted, which is responsible for
only setting new PWM duty cycle.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/hwmon/pwm-fan.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index 1991d903..870e100 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -33,21 +33,15 @@ struct pwm_fan_ctx {
 	unsigned char pwm_value;
 };
 
-static ssize_t set_pwm(struct device *dev, struct device_attribute *attr,
-		       const char *buf, size_t count)
+static int  __set_pwm(struct pwm_fan_ctx *ctx, unsigned long pwm)
 {
-	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
-	unsigned long pwm, duty;
-	ssize_t ret;
-
-	if (kstrtoul(buf, 10, &pwm) || pwm > MAX_PWM)
-		return -EINVAL;
-
-	mutex_lock(&ctx->lock);
+	unsigned long duty;
+	int ret;
 
 	if (ctx->pwm_value == pwm)
-		goto exit_set_pwm_no_change;
+		return 0;
 
+	mutex_lock(&ctx->lock);
 	if (pwm == 0) {
 		pwm_disable(ctx->pwm);
 		goto exit_set_pwm;
@@ -66,13 +60,28 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *attr,
 
 exit_set_pwm:
 	ctx->pwm_value = pwm;
-exit_set_pwm_no_change:
-	ret = count;
 exit_set_pwm_err:
 	mutex_unlock(&ctx->lock);
 	return ret;
 }
 
+static ssize_t set_pwm(struct device *dev, struct device_attribute *attr,
+		       const char *buf, size_t count)
+{
+	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
+	unsigned long pwm;
+	int ret;
+
+	if (kstrtoul(buf, 10, &pwm) || pwm > MAX_PWM)
+		return -EINVAL;
+
+	ret = __set_pwm(ctx, pwm);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
 static ssize_t show_pwm(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-- 
2.0.0.rc2

