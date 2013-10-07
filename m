Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab3JGLkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:40:24 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:58152 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab3JGLkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:40:09 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/12] pwm-backlight: Allow backlight to remain disabled on boot
Date: Mon,  7 Oct 2013 13:37:46 +0200
Message-Id: <1381145866-445-13-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381145866-445-1-git-send-email-treding@nvidia.com>
References: <1381145866-445-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default for backlight devices is to be enabled immediately when
registering with the backlight core. This can be useful for setups that
use a simple framebuffer device and where the backlight cannot otherwise
be hooked up to the panel.

However, when dealing with more complex setups, such as those of recent
ARM SoCs, this can be problematic. Since the backlight is usually setup
separately from the display controller, the probe order is not usually
deterministic. That can lead to situations where the backlight will be
powered up and the panel will show an uninitialized framebuffer.

Furthermore, subsystems such as DRM have advanced functionality to set
the power mode of a panel. In order to allow such setups to power up the
panel at exactly the right moment, a way is needed to prevent the
backlight core from powering the backlight up automatically when it is
registered.

This commit introduces a new boot_off field in the platform data (and
also implements getting the same information from device tree). When set
the initial backlight power mode will be set to "off".

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Note: Perhaps it would be more useful to make this the default behaviour
in the backlight core? Many other subsystems and frameworks assume that
a resource is off unless explicitly enabled.

 .../devicetree/bindings/video/backlight/pwm-backlight.txt         | 1 +
 drivers/video/backlight/pwm_bl.c                                  | 8 ++++++++
 include/linux/pwm_backlight.h                                     | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
index 764db86..65e001a 100644
--- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
+++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
@@ -17,6 +17,7 @@ Optional properties:
                "pwms" property (see PWM binding[0])
   - enable-gpios: contains a single GPIO specifier for the GPIO which enables
                   and disables the backlight (see GPIO binding[1])
+  - backlight-boot-off: keep the backlight disabled on boot
 
 [0]: Documentation/devicetree/bindings/pwm/pwm.txt
 [1]: Documentation/devicetree/bindings/gpio/gpio.txt
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index eec6c98..cd87ecb 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -194,6 +194,8 @@ static int pwm_backlight_parse_dt(struct device *dev,
 	if (gpio_is_valid(data->enable_gpio) && (flags & OF_GPIO_ACTIVE_LOW))
 		data->enable_gpio_flags |= PWM_BACKLIGHT_GPIO_ACTIVE_LOW;
 
+	data->boot_off = of_property_read_bool(node, "backlight-boot-off");
+
 	return 0;
 }
 
@@ -325,6 +327,12 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	}
 
 	bl->props.brightness = data->dft_brightness;
+
+	if (data->boot_off)
+		bl->props.power = FB_BLANK_POWERDOWN;
+	else
+		bl->props.power = FB_BLANK_UNBLANK;
+
 	backlight_update_status(bl);
 
 	platform_set_drvdata(pdev, bl);
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 2de2e27..ea4a239 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -18,6 +18,8 @@ struct platform_pwm_backlight_data {
 	unsigned int *levels;
 	int enable_gpio;
 	unsigned long enable_gpio_flags;
+	bool boot_off;
+
 	int (*init)(struct device *dev);
 	int (*notify)(struct device *dev, int brightness);
 	void (*notify_after)(struct device *dev, int brightness);
-- 
1.8.4

