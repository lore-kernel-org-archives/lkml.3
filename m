Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaLVQ3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:29:06 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24487 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaLVQ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:28:59 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-88-549846c907a8
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
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH v2 7/8] hwmon: thermal: Read PWM FAN configuration from device
 tree
Date: Mon, 22 Dec 2014 17:27:47 +0100
Message-id: <1419265668-32283-8-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t9jAd2TbjNCDJb9ULZ4vGYxk8X8I+dY
	LeZfucZqsfTuJzaLH68vsFms+atk0bvgKpvFm0fcFm8ebma0uLxrDpvF594jjBYzzu9jsniy
	8AyTxZ1pe9ksDr9pZ3Xg99g56y67x4OJu9k81k17y+yx83sDu0ffllWMHptPV3t83iQXwB7F
	ZZOSmpNZllqkb5fAlXGgeRJrwSLhirkbl7E1MN7g72Lk5JAQMJHoWr+OGcIWk7hwbz1bFyMX
	h5DAIkaJKw/OskA4XUwSV75NYQepYhPQk/h89ykTSEJEYAajxP6mb+wgDrPAFWaJb6caWUCq
	hAVCJeYcOwNmswioSny79YARxOYVcJM4dmQtC8Q+RYnuZxOA9nFwcAq4S/x+xQuxrZlR4tSC
	RuYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQH7jPpHYyrGiwOMQpwMCrx8HKm
	TQ8RYk0sK67MPcQowcGsJMJ71XJGiBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeJfu2ECGB9MSS
	1OzU1ILUIpgsEwenVAOjQtaigvc2xw+8tKytff7zXXH/6jSv1iOLv92v3dLfO8lSK0Ftl+2s
	WfVuC5da7deueedyev0j1mn3jWQkdweJ+148rPf4RPlPtr/xy+0fG1wTcnnGtP7ck+SjptYH
	P2x+0eYq7VM+RSgk/6zlVTFT5dQJqwUWsfUfa3+Y36Nyj9VATDXRKThdiaU4I9FQi7moOBEA
	T2O9VVgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code for reading PWM FAN configuration data via device tree.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
Changes for v2:
- Rename pwm_fan_max_states to pwm_fan_cooling_levels
- Moving pwm_fan_of_get_cooling_data() call after setting end enabling PWM FAN
- pwm_fan_of_get_cooling_data() now can fail - preserving old behaviour
- Remove unnecessary dev_err() call
---
 drivers/hwmon/pwm-fan.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index 870e100..8e68308 100644
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
+	unsigned int *pwm_fan_cooling_levels;
 };
 
 static int  __set_pwm(struct pwm_fan_ctx *ctx, unsigned long pwm)
@@ -100,6 +103,47 @@ static struct attribute *pwm_fan_attrs[] = {
 
 ATTRIBUTE_GROUPS(pwm_fan);
 
+int pwm_fan_of_get_cooling_data(struct device *dev, struct pwm_fan_ctx *ctx)
+{
+	struct device_node *np = dev->of_node;
+	struct property *pp;
+	int len, num, i;
+
+	pp = of_find_property(np, "cooling-levels", &len);
+	if (!pp) {
+		dev_err(dev, "Property: 'cooling-levels' not found\n");
+		return -EINVAL;
+	}
+
+	if (len == 0) {
+		dev_err(dev, "Length wrong value!\n");
+		return -EINVAL;
+	}
+
+	ctx->pwm_fan_cooling_levels = devm_kzalloc(dev, len, GFP_KERNEL);
+	if (!ctx->pwm_fan_cooling_levels)
+		return -ENOMEM;
+
+	num = len / sizeof(u32);
+	if (of_property_read_u32_array(np, pp->name,
+				       ctx->pwm_fan_cooling_levels, num)) {
+		dev_err(dev, "Property: %s cannot be read!\n", pp->name);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num; i++) {
+		if (ctx->pwm_fan_cooling_levels[i] > MAX_PWM) {
+			dev_err(dev, "PWM fan state[%d]:%d > %d\n", i,
+				ctx->pwm_fan_cooling_levels[i], MAX_PWM);
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
@@ -145,6 +189,8 @@ static int pwm_fan_probe(struct platform_device *pdev)
 		pwm_disable(ctx->pwm);
 		return PTR_ERR(hwmon);
 	}
+
+	pwm_fan_of_get_cooling_data(&pdev->dev, ctx);
 	return 0;
 }
 
-- 
2.0.0.rc2

