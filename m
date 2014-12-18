Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaLRKPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:15:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11527 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaLRKPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:15:09 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-c0-5492a92bd6ad
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
Subject: [PATCH 8/9] hwmon: thermal: Provide 'default-pulse-width' property to
 setup FAN on boot
Date: Thu, 18 Dec 2014 11:13:10 +0100
Message-id: <1418897591-18332-9-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jQV3tlZNCDI7dULaYf+Qcq8X8K9dY
	LZbe/cRm8eP1BTaL3gVX2SzePOK2ePNwM6PF5V1z2Cw+9x5htJhxfh+TxZOFZ5gs7kzby2Zx
	+E07qwOvx85Zd9k9HkzczeaxbtpbZo+d3xvYPfq2rGL02Hy62uPzJrkA9igum5TUnMyy1CJ9
	uwSujPnXXrAX7BOu2P5rOVsD4wf+LkZODgkBE4m2X2sZIWwxiQv31rN1MXJxCAlMZ5T43nWI
	FSQhJNDFJPGnOwHEZhPQk/h89ykTSJGIwAxGif1N39hBHGaB70wSTVuXsoBUCQskSXzceZkN
	xGYRUJXYsrIHzOYVcJM4O/s8O8Q6RYnuZxPA4pwC7hJznkPYQkA1TX8vMU9g5F3AyLCKUTS1
	ILmgOCk910ivODG3uDQvXS85P3cTIzhIn0nvYFzVYHGIUYCDUYmHV0JvUogQa2JZcWXuIUYJ
	DmYlEd7oHKAQb0piZVVqUX58UWlOavEhRmkOFiVxXiX7thAhgfTEktTs1NSC1CKYLBMHp1QD
	47bZGy48CTmwvn4ek8FUmYDTy9aXnn95s+bFtHN6X2OjhMIr5E5N8NuQvXp/zdND0dar/2f+
	tt5zxT/IIprjdeQdrZhL195+ZDX5xszR8sj3i57Tr+cOF/+wx59RzPSsNbxQ/ehPzf3LPdWB
	dbINum9mv4vZJ7w9jn3RbSnhhvYPEUG7L7Sdj1diKc5INNRiLipOBABEPON0TgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up till now the PWM fan was enabled by default in the pwm-fan driver.
Now, by defining 'default-pulse-width' device tree property, it is possible
to configure the fan RPM on boot. By specifying value of 0, one can disable it.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/hwmon/pwm-fan.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index 97b77e9..c1cf48b 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -34,6 +34,7 @@ struct pwm_fan_ctx {
 	unsigned int pwm_value;
 	unsigned int pwm_fan_state;
 	unsigned int pwm_fan_max_state;
+	unsigned int pwm_fan_default_width;
 	unsigned int *pwm_fan_cooling_states;
 };
 
@@ -172,8 +173,21 @@ static const struct thermal_cooling_device_ops pwm_fan_cooling_ops = {
 int pwm_fan_of_get_cooling_data(struct device *dev, struct pwm_fan_ctx *ctx)
 {
 	struct device_node *np = dev->of_node;
+	int len, num, i, ret;
 	struct property *pp;
-	int len, num, i;
+
+	ret = of_property_read_u32(np, "default-pulse-width",
+				   &ctx->pwm_fan_default_width);
+	if (ret) {
+		dev_err(dev, "Property: 'default-pulse-width' not found\n");
+		return -EINVAL;
+	}
+
+	if (ctx->pwm_fan_default_width > MAX_PWM) {
+		dev_err(dev, "'default-pulse-width %d larger than %d\n",
+			ctx->pwm_fan_default_width, MAX_PWM);
+		return -EINVAL;
+	}
 
 	pp = of_find_property(np, "cooling-pwm-values", &len);
 	if (!pp) {
@@ -217,7 +231,6 @@ static int pwm_fan_probe(struct platform_device *pdev)
 	struct thermal_cooling_device *cdev;
 	struct pwm_fan_ctx *ctx;
 	struct device *hwmon;
-	int duty_cycle;
 	int ret;
 
 	ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
@@ -237,22 +250,7 @@ static int pwm_fan_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	/* Set duty cycle to maximum allowed */
-	duty_cycle = ctx->pwm->period - 1;
-	ctx->pwm_value = MAX_PWM;
-
-	ret = pwm_config(ctx->pwm, duty_cycle, ctx->pwm->period);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to configure PWM\n");
-		return ret;
-	}
-
-	/* Enbale PWM output */
-	ret = pwm_enable(ctx->pwm);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to enable PWM\n");
-		return ret;
-	}
+	__set_pwm(ctx, ctx->pwm_fan_default_width);
 
 	hwmon = devm_hwmon_device_register_with_groups(&pdev->dev, "pwmfan",
 						       ctx, pwm_fan_groups);
-- 
2.0.0.rc2

