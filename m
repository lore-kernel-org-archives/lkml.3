Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3IWVm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:42:56 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:64319 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab3IWVmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:42:51 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] pwm-backlight: Use an optional power supply
Date: Mon, 23 Sep 2013 23:41:06 +0200
Message-Id: <1379972467-11243-10-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379972467-11243-1-git-send-email-treding@nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many backlights require a power supply to work properly. This commit
uses a power-supply regulator, if available, to power up and power down
the panel.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 .../bindings/video/backlight/pwm-backlight.txt      |  2 ++
 drivers/video/backlight/pwm_bl.c                    | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 052eb03..3898f26 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -15,6 +15,7 @@ Optional properties:
   - pwm-names: a list of names for the PWM devices specified in the
                "pwms" property (see PWM binding[0])
   - enable-gpios: a list of GPIOs to enable and disable the backlight
+  - power-supply: regulator for supply voltage
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 
@@ -28,4 +29,5 @@ Example:
 		default-brightness-level = <6>;
 
 		enable-gpios = <&gpio 58 0>;
+		power-supply = <&vdd_bl_reg>;
 	};
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 506810c..a2b3876 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -21,6 +21,7 @@
 #include <linux/err.h>
 #include <linux/pwm.h>
 #include <linux/pwm_backlight.h>
+#include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 
 struct pwm_bl_data {
@@ -29,6 +30,7 @@ struct pwm_bl_data {
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
+	struct regulator	*power_supply;
 	int			enable_gpio;
 	unsigned long		enable_gpio_flags;
 	int			(*notify)(struct device *,
@@ -56,6 +58,12 @@ static void pwm_backlight_power_on(struct pwm_bl_data *pb, int brightness,
 
 	pwm_config(pb->pwm, duty_cycle, pb->period);
 
+	if (pb->power_supply) {
+		err = regulator_enable(pb->power_supply);
+		if (err < 0)
+			dev_err(pb->dev, "failed to enable power supply\n");
+	}
+
 	if (gpio_is_valid(pb->enable_gpio)) {
 		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
 			gpio_set_value(pb->enable_gpio, 0);
@@ -76,6 +84,9 @@ static void pwm_backlight_power_off(struct pwm_bl_data *pb)
 		else
 			gpio_set_value(pb->enable_gpio, 0);
 	}
+
+	if (pb->power_supply)
+		regulator_disable(pb->power_supply);
 }
 
 static int pwm_backlight_update_status(struct backlight_device *bl)
@@ -253,6 +264,16 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		}
 	}
 
+	pb->power_supply = devm_regulator_get_optional(&pdev->dev, "power");
+	if (IS_ERR(pb->power_supply)) {
+		if (PTR_ERR(pb->power_supply) != -ENODEV) {
+			ret = PTR_ERR(pb->power_supply);
+			goto err_gpio;
+		}
+
+		pb->power_supply = NULL;
+	}
+
 	pb->pwm = devm_pwm_get(&pdev->dev, NULL);
 	if (IS_ERR(pb->pwm)) {
 		dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
-- 
1.8.4

