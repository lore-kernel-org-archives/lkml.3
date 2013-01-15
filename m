Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab3AOM63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:58:29 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54790 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab3AOM5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:57:05 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Naga Radhesh <naga.radheshy@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 23/26] mfd: ab8500-pwm: Enable support for AB8505 PWMLED blink
Date: Tue, 15 Jan 2013 12:56:03 +0000
Message-Id: <1358254566-12419-24-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naga Radhesh <naga.radheshy@stericsson.com>

Enable support for PWM OUT LED blinking for AB8505. Instead of
having 3 pwm instances from ab8500 core file add it as platform data.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Naga Radhesh <naga.radheshy@stericsson.com>
Reviewed-by: Arun MURTHY <arun.murthy@stericsson.com>
Reviewed-by: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
---
 drivers/mfd/ab8500-core.c          |   10 --
 drivers/misc/ab8500-pwm.c          |  282 ++++++++++++++++++++++++++++++++++++
 include/linux/mfd/ab8500/pwmleds.h |   20 +++
 include/linux/mfd/abx500/ab8500.h  |    2 +
 4 files changed, 304 insertions(+), 10 deletions(-)
 create mode 100644 drivers/misc/ab8500-pwm.c
 create mode 100644 include/linux/mfd/ab8500/pwmleds.h

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 580adf3..c758469 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1015,16 +1015,6 @@ static struct mfd_cell __devinitdata abx500_common_devs[] = {
 		.id = 1,
 	},
 	{
-		.name = "ab8500-pwm",
-		.of_compatible = "stericsson,ab8500-pwm",
-		.id = 2,
-	},
-	{
-		.name = "ab8500-pwm",
-		.of_compatible = "stericsson,ab8500-pwm",
-		.id = 3,
-	},
-	{
 		.name = "ab8500-leds",
 		.of_compatible = "stericsson,ab8500-leds",
 	},
diff --git a/drivers/misc/ab8500-pwm.c b/drivers/misc/ab8500-pwm.c
new file mode 100644
index 0000000..d7a6276
--- /dev/null
+++ b/drivers/misc/ab8500-pwm.c
@@ -0,0 +1,282 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Author: Arun R Murthy <arun.murthy@stericsson.com>
+ * License terms: GNU General Public License (GPL) version 2
+ */
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/pwm.h>
+#include <linux/clk.h>
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500.h>
+#include <linux/module.h>
+#include <linux/mfd/ab8500/pwmleds.h>
+/*
+ * PWM Out generators
+ * Bank: 0x10
+ */
+#define AB8500_PWM_OUT_CTRL1_REG	0x60
+#define AB8500_PWM_OUT_CTRL2_REG	0x61
+#define AB8500_PWM_OUT_CTRL7_REG	0x66
+#define AB8505_PWM_OUT_BLINK_CTRL1_REG  0x68
+#define AB8505_PWM_OUT_BLINK_CTRL4_REG  0x6B
+#define AB8505_PWM_OUT_BLINK_CTRL_DUTYBIT 4
+#define AB8505_PWM_OUT_BLINK_DUTYMASK (0x0F << AB8505_PWM_OUT_BLINK_CTRL_DUTYBIT)
+
+
+/* backlight driver constants */
+#define ENABLE_PWM			1
+#define DISABLE_PWM			0
+
+struct pwm_device {
+	struct device *dev;
+	struct list_head node;
+	struct clk *clk;
+	const char *label;
+	unsigned int pwm_id;
+	unsigned int blink_en;
+	struct ab8500 *parent;
+	bool clk_enabled;
+};
+
+static LIST_HEAD(pwm_list);
+
+int pwm_config_blink(struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	int ret;
+	unsigned int value;
+	u8 reg;
+	if ((!is_ab8505(pwm->parent)) || (!pwm->blink_en)) {
+		dev_err(pwm->dev, "setting blinking for this "
+					"device not supported\n");
+		return -EINVAL;
+	}
+	/*
+	 * get the period value that is to be written to
+	 * AB8500_PWM_OUT_BLINK_CTRL1 REGS[0:2]
+	 */
+	value = period_ns & 0x07;
+	/*
+	 * get blink duty value to be written to
+	 * AB8500_PWM_OUT_BLINK_CTRL REGS[7:4]
+	 */
+	value |= ((duty_ns << AB8505_PWM_OUT_BLINK_CTRL_DUTYBIT) &
+					AB8505_PWM_OUT_BLINK_DUTYMASK);
+
+	reg = AB8505_PWM_OUT_BLINK_CTRL1_REG + (pwm->pwm_id - 1);
+
+	ret = abx500_set_register_interruptible(pwm->dev, AB8500_MISC,
+			reg, (u8)value);
+	if (ret < 0)
+		dev_err(pwm->dev, "%s: Failed to config PWM blink,Error %d\n",
+							pwm->label, ret);
+	return ret;
+}
+
+int pwm_blink_ctrl(struct pwm_device *pwm , int enable)
+{
+	int ret;
+
+	if ((!is_ab8505(pwm->parent)) || (!pwm->blink_en)) {
+		dev_err(pwm->dev, "setting blinking for this "
+					"device not supported\n");
+		return -EINVAL;
+	}
+	/*
+	 * Enable/disable blinking feature for corresponding PWMOUT
+	 * channel depending on value of enable.
+	 */
+	ret = abx500_mask_and_set_register_interruptible(pwm->dev,
+			AB8500_MISC, AB8505_PWM_OUT_BLINK_CTRL4_REG,
+			1 << (pwm->pwm_id-1), enable << (pwm->pwm_id-1));
+	if (ret < 0)
+		dev_err(pwm->dev, "%s: Failed to control PWM blink,Error %d\n",
+							pwm->label, ret);
+	return ret;
+}
+
+int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
+{
+	int ret = 0;
+	unsigned int higher_val, lower_val;
+	u8 reg;
+
+	/*
+	 * get the first 8 bits that are be written to
+	 * AB8500_PWM_OUT_CTRL1_REG[0:7]
+	 */
+	lower_val = duty_ns & 0x00FF;
+	/*
+	 * get bits [9:10] that are to be written to
+	 * AB8500_PWM_OUT_CTRL2_REG[0:1]
+	 */
+	higher_val = ((duty_ns & 0x0300) >> 8);
+
+	reg = AB8500_PWM_OUT_CTRL1_REG + ((pwm->pwm_id - 1) * 2);
+
+	ret = abx500_set_register_interruptible(pwm->dev, AB8500_MISC,
+			reg, (u8)lower_val);
+	if (ret < 0)
+		return ret;
+	ret = abx500_set_register_interruptible(pwm->dev, AB8500_MISC,
+			(reg + 1), (u8)higher_val);
+
+	return ret;
+}
+EXPORT_SYMBOL(pwm_config);
+
+int pwm_enable(struct pwm_device *pwm)
+{
+	int ret;
+
+	if (!pwm->clk_enabled) {
+		ret = clk_enable(pwm->clk);
+		if (ret < 0) {
+			dev_err(pwm->dev, "failed to enable clock\n");
+			return ret;
+		}
+		pwm->clk_enabled = true;
+	}
+	ret = abx500_mask_and_set_register_interruptible(pwm->dev,
+				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
+				1 << (pwm->pwm_id-1), 1 << (pwm->pwm_id-1));
+	if (ret < 0)
+		dev_err(pwm->dev, "%s: Failed to enable PWM, Error %d\n",
+							pwm->label, ret);
+	return ret;
+}
+EXPORT_SYMBOL(pwm_enable);
+
+void pwm_disable(struct pwm_device *pwm)
+{
+	int ret;
+
+	ret = abx500_mask_and_set_register_interruptible(pwm->dev,
+				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
+				1 << (pwm->pwm_id-1), DISABLE_PWM);
+	/*
+	 * Workaround to set PWM in disable.
+	 * If enable bit is not toggled the PWM might output 50/50 duty cycle
+	 * even though it should be disabled
+	 */
+	ret &= abx500_mask_and_set_register_interruptible(pwm->dev,
+				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
+				1 << (pwm->pwm_id-1),
+				ENABLE_PWM << (pwm->pwm_id-1));
+	ret &= abx500_mask_and_set_register_interruptible(pwm->dev,
+				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
+				1 << (pwm->pwm_id-1), DISABLE_PWM);
+
+	if (ret < 0)
+		dev_err(pwm->dev, "%s: Failed to disable PWM, Error %d\n",
+							pwm->label, ret);
+	if (pwm->clk_enabled) {
+		clk_disable(pwm->clk);
+		pwm->clk_enabled = false;
+	}
+
+	return;
+}
+EXPORT_SYMBOL(pwm_disable);
+
+struct pwm_device *pwm_request(int pwm_id, const char *label)
+{
+	struct pwm_device *pwm;
+	list_for_each_entry(pwm, &pwm_list, node) {
+		if (pwm->pwm_id == pwm_id) {
+			pwm->label = label;
+			pwm->pwm_id = pwm_id;
+			return pwm;
+		}
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL(pwm_request);
+
+void pwm_free(struct pwm_device *pwm)
+{
+	pwm_disable(pwm);
+}
+EXPORT_SYMBOL(pwm_free);
+
+static int __devinit ab8500_pwm_probe(struct platform_device *pdev)
+{
+	struct ab8500 *parent = dev_get_drvdata(pdev->dev.parent);
+	struct ab8500_platform_data *plat = dev_get_platdata(parent->dev);
+	struct ab8500_pwmled_platform_data *pdata = plat->pwmled;
+	struct pwm_device *pwm;
+	int ret = 0 , i;
+
+	/*
+	 * Nothing to be done in probe, this is required to get the
+	 * device which is required for ab8500 read and write
+	 */
+	pwm = kzalloc(((sizeof(struct pwm_device)) * pdata->num_pwm),
+						 GFP_KERNEL);
+	if (pwm == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+	for (i = 0; i < pdata->num_pwm; i++) {
+		pwm[i].dev = &pdev->dev;
+		pwm[i].parent = parent;
+		pwm[i].blink_en = pdata->leds[i].blink_en;
+		pwm[i].pwm_id = pdata->leds[i].pwm_id;
+		list_add_tail(&pwm[i].node, &pwm_list);
+	}
+	pwm->clk = clk_get(pwm->dev, NULL);
+	if (IS_ERR(pwm->clk)) {
+		dev_err(pwm->dev, "clock request failed\n");
+		ret = PTR_ERR(pwm->clk);
+		goto fail;
+	}
+	platform_set_drvdata(pdev, pwm);
+	pwm->clk_enabled = false;
+	dev_dbg(pwm->dev, "pwm probe successful\n");
+	return ret;
+
+fail:
+	list_del(&pwm->node);
+	kfree(pwm);
+	return ret;
+}
+
+static int __devexit ab8500_pwm_remove(struct platform_device *pdev)
+{
+	struct pwm_device *pwm = platform_get_drvdata(pdev);
+
+	list_del(&pwm->node);
+	clk_put(pwm->clk);
+	dev_dbg(&pdev->dev, "pwm driver removed\n");
+	kfree(pwm);
+	return 0;
+}
+
+static struct platform_driver ab8500_pwm_driver = {
+	.driver = {
+		.name = "ab8500-pwm",
+		.owner = THIS_MODULE,
+	},
+	.probe = ab8500_pwm_probe,
+	.remove = __devexit_p(ab8500_pwm_remove),
+};
+
+static int __init ab8500_pwm_init(void)
+{
+	return platform_driver_register(&ab8500_pwm_driver);
+}
+
+static void __exit ab8500_pwm_exit(void)
+{
+	platform_driver_unregister(&ab8500_pwm_driver);
+}
+
+subsys_initcall(ab8500_pwm_init);
+module_exit(ab8500_pwm_exit);
+MODULE_AUTHOR("Arun MURTHY <arun.murthy@stericsson.com>");
+MODULE_DESCRIPTION("AB8500 Pulse Width Modulation Driver");
+MODULE_ALIAS("platform:ab8500-pwm");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/ab8500/pwmleds.h b/include/linux/mfd/ab8500/pwmleds.h
new file mode 100644
index 0000000..e316582
--- /dev/null
+++ b/include/linux/mfd/ab8500/pwmleds.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright ST-Ericsson 2012.
+ *
+ * Author: Naga Radhesh <naga.radheshy@stericsson.com>
+ * Licensed under GPLv2.
+ */
+#ifndef _AB8500_PWMLED_H
+#define _AB8500_PWMLED_H
+
+struct ab8500_led_pwm {
+	int	pwm_id;
+	int	blink_en;
+};
+
+struct ab8500_pwmled_platform_data {
+	int	num_pwm;
+	struct	ab8500_led_pwm *leds;
+};
+
+#endif
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 83de910..62cbe65 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -281,6 +281,7 @@ struct ab8500_sysctrl_platform_data;
  * @regulator_reg_init: regulator init registers
  * @num_regulator: number of regulators
  * @regulator: machine-specific constraints for regulators
+ * @pwmled: machine-specific pwmled data
  */
 struct ab8500_platform_data {
 	int irq_base;
@@ -293,6 +294,7 @@ struct ab8500_platform_data {
 	struct ab8500_gpio_platform_data *gpio;
 	struct ab8500_codec_platform_data *codec;
 	struct ab8500_sysctrl_platform_data *sysctrl;
+	struct ab8500_pwmled_platform_data *pwmled;
 };
 
 extern int __devinit ab8500_init(struct ab8500 *ab8500,
-- 
1.7.9.5

