Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbaLVQ33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:29:29 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53663 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaLVQ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:29:04 -0500
X-AuditID: cbfee61a-f79c06d000004e71-a1-549846ce087a
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
Subject: [PATCH v2 8/8] hwmon: thermal: Code for using PWM FAN as a cooling
 device
Date: Mon, 22 Dec 2014 17:27:48 +0100
Message-id: <1419265668-32283-9-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jAd1zbjNCDL4cU7d4vGYxk8X8I+dY
	LeZfucZqsfTuJzaLH68vsFms+atk0bvgKpvFm0fcFm8ebma0uLxrDpvF594jjBYzzu9jsniy
	8AyTxZ1pe9ksDr9pZ3Xg99g56y67x4OJu9k81k17y+yx83sDu0ffllWMHptPV3t83iQXwB7F
	ZZOSmpNZllqkb5fAlXFzzTv2gjlyFROf9bI2MB6U6GLk5JAQMJFY8XMJE4QtJnHh3no2EFtI
	YBGjxKTbQV2MXEB2F5NE17wrjCAJNgE9ic93nzKBJEQEZjBK7G/6xg7iMAtcYZb4dqqRBaRK
	WCBEYuneq+wgNouAqsTypy1g3bwCbhKf5r1khVinKNH9bALQOg4OTgF3id+veCG2NTNKnFrQ
	yDyBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCwfSa1g3Flg8UhRgEORiUeXo60
	6SFCrIllxZW5hxglOJiVRHivWs4IEeJNSaysSi3Kjy8qzUktPsQozcGiJM6rZN8WIiSQnliS
	mp2aWpBaBJNl4uCUamCcfOJ5/dNOkzNHlLwWr9ll/XVpYIze8n83r7taOrwKusNbP1lUwLGp
	/ezaikVLQq5pbF5h8rwufS0/t41RpJn8Vw+OuXKVZ9+yZV2sXW7bdDM4xT60ceMKe4+c9TIf
	130ye8Cgek2yztRl/g+dly8NthdV1kz58VKs5X7j3twP8nz7LET7OiOUWIozEg21mIuKEwFf
	kEAdVwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PWM FAN device can now be used as a thermal cooling device. Necessary
infrastructure has been added in this commit.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
Changes for v2:
- Replace pwm_fan_cooling_states with pwm_fan_cooling_levels
- Update ctx->pwm_fan_state when correct data from device tree is available
- Using therma_cdev_update() when thermal is ready for controlling the fan
---
 drivers/hwmon/pwm-fan.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index 8e68308..a47fc3c 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/pwm.h>
 #include <linux/sysfs.h>
+#include <linux/thermal.h>
 
 #define MAX_PWM 255
 
@@ -68,6 +69,17 @@ exit_set_pwm_err:
 	return ret;
 }
 
+static void pwm_fan_update_state(struct pwm_fan_ctx *ctx, unsigned long pwm)
+{
+	int i;
+
+	for (i = 0; i < ctx->pwm_fan_max_state; ++i)
+		if (pwm < ctx->pwm_fan_cooling_levels[i + 1])
+			break;
+
+	ctx->pwm_fan_state = i;
+}
+
 static ssize_t set_pwm(struct device *dev, struct device_attribute *attr,
 		       const char *buf, size_t count)
 {
@@ -82,6 +94,7 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
+	pwm_fan_update_state(ctx, pwm);
 	return count;
 }
 
@@ -103,6 +116,59 @@ static struct attribute *pwm_fan_attrs[] = {
 
 ATTRIBUTE_GROUPS(pwm_fan);
 
+/* thermal cooling device callbacks */
+static int pwm_fan_get_max_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	struct pwm_fan_ctx *ctx = cdev->devdata;
+
+	*state = ctx->pwm_fan_max_state;
+
+	return 0;
+}
+
+static int pwm_fan_get_cur_state(struct thermal_cooling_device *cdev,
+				 unsigned long *state)
+{
+	struct pwm_fan_ctx *ctx = cdev->devdata;
+
+	if (!ctx)
+		return -EINVAL;
+
+	*state = ctx->pwm_fan_state;
+
+	return 0;
+}
+
+static int
+pwm_fan_set_cur_state(struct thermal_cooling_device *cdev, unsigned long state)
+{
+	struct pwm_fan_ctx *ctx = cdev->devdata;
+	int ret;
+
+	if (!ctx || (state > ctx->pwm_fan_max_state))
+		return -EINVAL;
+
+	if (state == ctx->pwm_fan_state)
+		return 0;
+
+	ret = __set_pwm(ctx, ctx->pwm_fan_cooling_levels[state]);
+	if (ret) {
+		dev_err(&cdev->device, "Cannot set pwm!\n");
+		return ret;
+	}
+
+	ctx->pwm_fan_state = state;
+
+	return ret;
+}
+
+static const struct thermal_cooling_device_ops pwm_fan_cooling_ops = {
+	.get_max_state = pwm_fan_get_max_state,
+	.get_cur_state = pwm_fan_get_cur_state,
+	.set_cur_state = pwm_fan_set_cur_state,
+};
+
 int pwm_fan_of_get_cooling_data(struct device *dev, struct pwm_fan_ctx *ctx)
 {
 	struct device_node *np = dev->of_node;
@@ -146,8 +212,9 @@ int pwm_fan_of_get_cooling_data(struct device *dev, struct pwm_fan_ctx *ctx)
 
 static int pwm_fan_probe(struct platform_device *pdev)
 {
-	struct device *hwmon;
+	struct thermal_cooling_device *cdev;
 	struct pwm_fan_ctx *ctx;
+	struct device *hwmon;
 	int duty_cycle;
 	int ret;
 
@@ -190,7 +257,21 @@ static int pwm_fan_probe(struct platform_device *pdev)
 		return PTR_ERR(hwmon);
 	}
 
-	pwm_fan_of_get_cooling_data(&pdev->dev, ctx);
+	ret = pwm_fan_of_get_cooling_data(&pdev->dev, ctx);
+	if (!ret) {
+		ctx->pwm_fan_state = ctx->pwm_fan_max_state;
+		cdev = thermal_of_cooling_device_register(pdev->dev.of_node,
+							  "pwm-fan", ctx,
+							  &pwm_fan_cooling_ops);
+		if (IS_ERR(cdev)) {
+			dev_err(&pdev->dev,
+				"Failed to register pwm-fan as cooling device");
+			pwm_disable(ctx->pwm);
+			return PTR_ERR(cdev);
+		}
+		thermal_cdev_update(cdev);
+	}
+
 	return 0;
 }
 
-- 
2.0.0.rc2

