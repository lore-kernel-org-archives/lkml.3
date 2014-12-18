Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaLRKOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:14:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21634 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaLRKOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:14:44 -0500
X-AuditID: cbfee61a-f79c06d000004e71-e8-5492a912f82f
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
Subject: [PATCH 6/9] hwmon: thermal: Read PWM FAN configuration from device tree
Date: Thu, 18 Dec 2014 11:13:08 +0100
Message-id: <1418897591-18332-7-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t9jQV2hlZNCDFr6DS3mHznHajH/yjVW
	i6V3P7FZ/Hh9gc2id8FVNos3j7gt3jzczGhxedccNovPvUcYLWac38dk8WThGSaLO9P2slkc
	ftPO6sDrsXPWXXaPBxN3s3msm/aW2WPn9wZ2j74tqxg9Np+u9vi8SS6APYrLJiU1J7MstUjf
	LoErY9GDdWwFp4Qq+vfOYWtgbOHvYuTkkBAwkeie9Z8dwhaTuHBvPVsXIxeHkMB0Ron2718Y
	IZwuJokFty+xglSxCehJfL77lAkkISIwg1Fif9M3dhCHWeA7k0TT1qUsIFXCAgES7xafYwSx
	WQRUJb6c7WAGsXkF3CTuL7zHArFPUaL72QQ2EJtTwF1iznMIWwiopunvJeYJjLwLGBlWMYqm
	FiQXFCel5xrqFSfmFpfmpesl5+duYgSH6TOpHYwrGywOMQpwMCrx8EroTQoRYk0sK67MPcQo
	wcGsJMIbnQMU4k1JrKxKLcqPLyrNSS0+xCjNwaIkzqtk3xYiJJCeWJKanZpakFoEk2Xi4JRq
	YMzr00v8JzbdS8/y3SeZDxp/nUQNftp9Mg9NeqClYv5dJt1s4bTAqiWnuK726dSpPLjNH+9w
	X2WW1DyX3d9dWx+9fq8zQ6ODLfPOTfYpbhGG/GfS11t72c5e7uOQNOEcD09Z0j1/2T/zS37u
	2xDyfOP9/zOsr4mpC2XMefD035z8WbNn9nf+CVJiKc5INNRiLipOBACC//25TwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code for reading PWM FAN configuration data via device tree has been added.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/hwmon/pwm-fan.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index 870e100..5854bb3 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -30,7 +30,10 @@
 struct pwm_fan_ctx {
 	struct mutex lock;
 	struct pwm_device *pwm;
-	unsigned char pwm_value;
+	unsigned int pwm_value;
+	unsigned int pwm_fan_state;
+	unsigned int pwm_fan_max_state;
+	unsigned int *pwm_fan_cooling_states;
 };
 
 static int  __set_pwm(struct pwm_fan_ctx *ctx, unsigned long pwm)
@@ -100,6 +103,49 @@ static struct attribute *pwm_fan_attrs[] = {
 
 ATTRIBUTE_GROUPS(pwm_fan);
 
+int pwm_fan_of_get_cooling_data(struct device *dev, struct pwm_fan_ctx *ctx)
+{
+	struct device_node *np = dev->of_node;
+	struct property *pp;
+	int len, num, i;
+
+	pp = of_find_property(np, "cooling-pwm-values", &len);
+	if (!pp) {
+		dev_err(dev, "Property: 'cooling-pwm-values' not found\n");
+		return -EINVAL;
+	}
+
+	if (len == 0) {
+		dev_err(dev, "Length wrong value!\n");
+		return -EINVAL;
+	}
+
+	ctx->pwm_fan_cooling_states = devm_kzalloc(dev, len, GFP_KERNEL);
+	if (!ctx->pwm_fan_cooling_states) {
+		dev_err(dev, "Allocation failed for pwm dan cooling states\n");
+		return -ENOMEM;
+	}
+
+	num = len / sizeof(u32);
+	if (of_property_read_u32_array(np, pp->name,
+				       ctx->pwm_fan_cooling_states, num)) {
+		dev_err(dev, "Property: %s cannot be read!\n", pp->name);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num; i++) {
+		if (ctx->pwm_fan_cooling_states[i] > MAX_PWM) {
+			dev_err(dev, "PWM fan state[%d]:%d > %d\n", i,
+				ctx->pwm_fan_cooling_states[i], MAX_PWM);
+			return -EINVAL;
+		}
+	}
+
+	ctx->pwm_fan_max_state = num - 1;
+
+	return 0;
+}
+
 static int pwm_fan_probe(struct platform_device *pdev)
 {
 	struct device *hwmon;
@@ -120,6 +166,9 @@ static int pwm_fan_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, ctx);
+	ret = pwm_fan_of_get_cooling_data(&pdev->dev, ctx);
+	if (ret)
+		return ret;
 
 	/* Set duty cycle to maximum allowed */
 	duty_cycle = ctx->pwm->period - 1;
-- 
2.0.0.rc2

