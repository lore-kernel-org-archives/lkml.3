Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab3JGLkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:40:21 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:39882 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab3JGLkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:40:07 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/12] pwm-backlight: Add power supply support
Date: Mon,  7 Oct 2013 13:37:45 +0200
Message-Id: <1381145866-445-12-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381145866-445-1-git-send-email-treding@nvidia.com>
References: <1381145866-445-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backlights require a power supply to work properly. This commit adds a
regulator to power up and power down the backlight.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- make regulator mandatory and update commit message accordingly

 .../devicetree/bindings/video/backlight/pwm-backlight.txt   |  2 ++
 drivers/video/backlight/pwm_bl.c                            | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 72810cc..764db86 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -10,6 +10,7 @@ Required properties:
       last value in the array represents a 100% duty cycle (brightest).
   - default-brightness-level: the default brightness level (index into the
       array defined by the "brightness-levels" property)
+  - power-supply: regulator for supply voltage
 
 Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
@@ -29,5 +30,6 @@ Example:
 		brightness-levels = <0 4 8 16 32 64 128 255>;
 		default-brightness-level = <6>;
 
+		power-supply = <&vdd_bl_reg>;
 		enable-gpios = <&gpio 58 0>;
 	};
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index cdef4a3..eec6c98 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -21,6 +21,7 @@
 #include <linux/err.h>
 #include <linux/pwm.h>
 #include <linux/pwm_backlight.h>
+#include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 
 struct pwm_bl_data {
@@ -30,6 +31,7 @@ struct pwm_bl_data {
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
 	bool			enabled;
+	struct regulator	*power_supply;
 	int			enable_gpio;
 	unsigned long		enable_gpio_flags;
 	int			(*notify)(struct device *,
@@ -60,6 +62,10 @@ static void pwm_backlight_power_on(struct pwm_bl_data *pb, int brightness,
 
 	pwm_config(pb->pwm, duty_cycle, pb->period);
 
+	err = regulator_enable(pb->power_supply);
+	if (err < 0)
+		dev_err(pb->dev, "failed to enable power supply\n");
+
 	if (gpio_is_valid(pb->enable_gpio)) {
 		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
 			gpio_set_value(pb->enable_gpio, 0);
@@ -86,6 +92,7 @@ static void pwm_backlight_power_off(struct pwm_bl_data *pb)
 			gpio_set_value(pb->enable_gpio, 0);
 	}
 
+	regulator_disable(pb->power_supply);
 	pb->enabled = false;
 }
 
@@ -268,6 +275,12 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		}
 	}
 
+	pb->power_supply = devm_regulator_get(&pdev->dev, "power");
+	if (IS_ERR(pb->power_supply)) {
+		ret = PTR_ERR(pb->power_supply);
+		goto err_gpio;
+	}
+
 	pb->pwm = devm_pwm_get(&pdev->dev, NULL);
 	if (IS_ERR(pb->pwm)) {
 		dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
-- 
1.8.4

