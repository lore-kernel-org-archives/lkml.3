Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab3ASK2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 05:28:44 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:57826 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3ASK2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 05:28:39 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Mark Zhang <markz@nvidia.com>,
        gnurou@gmail.com, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/3] pwm-backlight: add subdriver mechanism
Date: Sat, 19 Jan 2013 19:30:18 +0900
Message-Id: <1358591420-7790-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358591420-7790-1-git-send-email-acourbot@nvidia.com>
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PWM-controlled backlights often need additional power control prior
to activating the PWM, typically switching regulators or GPIOs. This has
been done so far through hooks defined in board files, but this
mechanism cannot be used on platforms that rely on the device tree.

This patch introduces a "subdriver" mechanism to the pwm-backlight
driver that allows such hooks to be defined in optionally-compiled
sub-drivers. Every subdriver has its own device tree properties, which
sets the correct hooks to the pwm-backlight driver.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/video/backlight/Makefile |  4 +++
 drivers/video/backlight/pwm_bl.c | 67 +++++++++++++++++++++++++++++++++++++++-
 include/linux/pwm_backlight.h    | 15 +++++++++
 3 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index e7ce729..df97ab1 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -29,6 +29,10 @@ obj-$(CONFIG_BACKLIGHT_LP855X)	+= lp855x_bl.o
 obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
 obj-$(CONFIG_BACKLIGHT_PANDORA)	+= pandora_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
+# pwm-backlight subdrivers must be listed *before* pwm_bl.o.
+# Link order is important as subdrivers must register themselves
+# before pwm-backlight's probe function can be called.
+obj-$(CONFIG_BACKLIGHT_PWM_TEGRA) += pwm_bl_tegra.o
 obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
 obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
 obj-$(CONFIG_BACKLIGHT_DA9052)	+= da9052_bl.o
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 069983c..b65a797 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 
 struct pwm_bl_data {
+	void			*subdriver_data;
 	struct pwm_device	*pwm;
 	struct device		*dev;
 	unsigned int		period;
@@ -35,6 +36,54 @@ struct pwm_bl_data {
 	void			(*exit)(struct device *);
 };
 
+static DEFINE_MUTEX(pwm_backlight_subdrivers_mutex);
+static LIST_HEAD(pwm_backlight_subdrivers);
+
+void pwm_backlight_add_subdriver(struct pwm_backlight_subdriver *driver)
+{
+	mutex_lock(&pwm_backlight_subdrivers_mutex);
+	list_add(&driver->list, &pwm_backlight_subdrivers);
+	mutex_unlock(&pwm_backlight_subdrivers_mutex);
+}
+EXPORT_SYMBOL(pwm_backlight_add_subdriver);
+
+void pwm_backlight_remove_subdriver(struct pwm_backlight_subdriver *driver)
+{
+	mutex_lock(&pwm_backlight_subdrivers_mutex);
+	list_del(&driver->list);
+	mutex_unlock(&pwm_backlight_subdrivers_mutex);
+}
+EXPORT_SYMBOL(pwm_backlight_remove_subdriver);
+
+/**
+ * pwm_backlight_set_subdriver_data - set subdriver data
+ * @dev: backlight device which data is to be set
+ * @data: subdriver data
+ *
+ * This function can be called *only* in the init() hook of the subdriver. The
+ * data will be temporarily set as driver data before being retrieved by
+ * the probe() function and moved to its final place.
+ */
+void pwm_backlight_set_subdriver_data(struct device *dev, void *data)
+{
+	dev_set_drvdata(dev, data);
+}
+EXPORT_SYMBOL(pwm_backlight_set_subdriver_data);
+
+/**
+ * pwm_backlight_get_subdriver_data - retrieve subdriver data
+ * @dev: backlight device to get subdriver data of
+ *
+ * This function can be called in any subdriver hook, excepted init().
+ */
+void *pwm_backlight_get_subdriver_data(struct device *dev)
+{
+	struct backlight_device *bl = dev_get_drvdata(dev);
+	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	return pb->subdriver_data;
+}
+EXPORT_SYMBOL(pwm_backlight_get_subdriver_data);
+
 static int pwm_backlight_update_status(struct backlight_device *bl)
 {
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
@@ -98,6 +147,7 @@ static const struct backlight_ops pwm_backlight_ops = {
 static int pwm_backlight_parse_dt(struct device *dev,
 				  struct platform_pwm_backlight_data *data)
 {
+	struct pwm_backlight_subdriver *subdriver;
 	struct device_node *node = dev->of_node;
 	struct property *prop;
 	int length;
@@ -150,6 +200,17 @@ static int pwm_backlight_parse_dt(struct device *dev,
 	 *       backlight power. Support for specifying these needs to be
 	 *       added.
 	 */
+	mutex_lock(&pwm_backlight_subdrivers_mutex);
+	list_for_each_entry(subdriver, &pwm_backlight_subdrivers, list)
+		if (of_device_is_compatible(node, subdriver->name)) {
+			data->init = subdriver->init;
+			data->exit = subdriver->exit;
+			data->notify = subdriver->notify;
+			data->notify_after = subdriver->notify_after;
+			data->check_fb = subdriver->check_fb;
+			break;
+		}
+	mutex_unlock(&pwm_backlight_subdrivers_mutex);
 
 	return 0;
 }
@@ -201,6 +262,9 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		goto err_alloc;
 	}
 
+	/* if the init function set subdriver data, move it to correct place */
+	pb->subdriver_data = dev_get_drvdata(&pdev->dev);
+
 	if (data->levels) {
 		max = data->levels[data->max_brightness];
 		pb->levels = data->levels;
@@ -249,10 +313,11 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 		goto err_alloc;
 	}
 
+	platform_set_drvdata(pdev, bl);
+
 	bl->props.brightness = data->dft_brightness;
 	backlight_update_status(bl);
 
-	platform_set_drvdata(pdev, bl);
 	return 0;
 
 err_alloc:
diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
index 56f4a86..6abe1ef 100644
--- a/include/linux/pwm_backlight.h
+++ b/include/linux/pwm_backlight.h
@@ -20,4 +20,19 @@ struct platform_pwm_backlight_data {
 	int (*check_fb)(struct device *dev, struct fb_info *info);
 };
 
+struct pwm_backlight_subdriver {
+	struct list_head list;
+	const char *name;
+	int (*init)(struct device *dev);
+	int (*notify)(struct device *dev, int brightness);
+	void (*notify_after)(struct device *dev, int brightness);
+	void (*exit)(struct device *dev);
+	int (*check_fb)(struct device *dev, struct fb_info *info);
+};
+
+void pwm_backlight_add_subdriver(struct pwm_backlight_subdriver *driver);
+void pwm_backlight_remove_subdriver(struct pwm_backlight_subdriver *driver);
+
+void pwm_backlight_set_subdriver_data(struct device *dev, void *data);
+void *pwm_backlight_get_subdriver_data(struct device *dev);
 #endif
-- 
1.8.1.1

