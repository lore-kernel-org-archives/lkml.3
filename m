Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab3K3FBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 00:01:42 -0500
Received: from smtp1.mail.ru ([94.100.176.129]:34267 "EHLO smtp1.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab3K3FBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 00:01:38 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH RESEND] mfd: mc13xxx: Remove unneeded mc13xxx_lock/unlock
Date: Sat, 30 Nov 2013 09:01:21 +0400
Message-Id: <1385787681-7736-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Locking is performed by regmap API so no additional locking is needed.
Nevertheless, keep locking in the ADC conversion routine. This need
for keep proper read ADC sequence when calling from adc & touchscreen
drivers.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/input/misc/mc13783-pwrbutton.c     | 11 ----
 drivers/input/touchscreen/mc13783_ts.c     |  9 +--
 drivers/leds/leds-mc13783.c                | 16 +----
 drivers/mfd/mc13xxx-core.c                 | 53 +++-------------
 drivers/regulator/mc13783-regulator.c      | 11 +---
 drivers/regulator/mc13892-regulator.c      | 45 +++-----------
 drivers/regulator/mc13xxx-regulator-core.c | 27 +-------
 drivers/rtc/rtc-mc13xxx.c                  | 98 +++++++-----------------------
 include/linux/mfd/mc13xxx.h                |  3 -
 9 files changed, 49 insertions(+), 224 deletions(-)

diff --git a/drivers/input/misc/mc13783-pwrbutton.c b/drivers/input/misc/mc13783-pwrbutton.c
index d0277a7..10e929a 100644
--- a/drivers/input/misc/mc13783-pwrbutton.c
+++ b/drivers/input/misc/mc13783-pwrbutton.c
@@ -124,8 +124,6 @@ static int mc13783_pwrbutton_probe(struct platform_device *pdev)
 	priv->pwr = pwr;
 	priv->mc13783 = mc13783;
 
-	mc13xxx_lock(mc13783);
-
 	if (pdata->b1on_flags & MC13783_BUTTON_ENABLE) {
 		priv->keymap[0] = pdata->b1on_key;
 		if (pdata->b1on_key != KEY_RESERVED)
@@ -185,8 +183,6 @@ static int mc13783_pwrbutton_probe(struct platform_device *pdev)
 
 	mc13xxx_reg_rmw(mc13783, MC13783_REG_POWER_CONTROL_2, 0x3FE, reg);
 
-	mc13xxx_unlock(mc13783);
-
 	pwr->name = "mc13783_pwrbutton";
 	pwr->phys = "mc13783_pwrbutton/input0";
 	pwr->dev.parent = &pdev->dev;
@@ -207,8 +203,6 @@ static int mc13783_pwrbutton_probe(struct platform_device *pdev)
 	return 0;
 
 free_irq:
-	mc13xxx_lock(mc13783);
-
 	if (pdata->b3on_flags & MC13783_BUTTON_ENABLE)
 		mc13xxx_irq_free(mc13783, MC13783_IRQ_ONOFD3, priv);
 
@@ -221,7 +215,6 @@ free_irq_b1:
 		mc13xxx_irq_free(mc13783, MC13783_IRQ_ONOFD1, priv);
 
 free_priv:
-	mc13xxx_unlock(mc13783);
 	kfree(priv);
 
 free_input_dev:
@@ -237,8 +230,6 @@ static int mc13783_pwrbutton_remove(struct platform_device *pdev)
 
 	pdata = dev_get_platdata(&pdev->dev);
 
-	mc13xxx_lock(priv->mc13783);
-
 	if (pdata->b3on_flags & MC13783_BUTTON_ENABLE)
 		mc13xxx_irq_free(priv->mc13783, MC13783_IRQ_ONOFD3, priv);
 	if (pdata->b2on_flags & MC13783_BUTTON_ENABLE)
@@ -246,8 +237,6 @@ static int mc13783_pwrbutton_remove(struct platform_device *pdev)
 	if (pdata->b1on_flags & MC13783_BUTTON_ENABLE)
 		mc13xxx_irq_free(priv->mc13783, MC13783_IRQ_ONOFD1, priv);
 
-	mc13xxx_unlock(priv->mc13783);
-
 	input_unregister_device(priv->pwr);
 	kfree(priv);
 
diff --git a/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13783_ts.c
index d6f099c..8bd62f9 100644
--- a/drivers/input/touchscreen/mc13783_ts.c
+++ b/drivers/input/touchscreen/mc13783_ts.c
@@ -137,21 +137,18 @@ static int mc13783_ts_open(struct input_dev *dev)
 	struct mc13783_ts_priv *priv = input_get_drvdata(dev);
 	int ret;
 
-	mc13xxx_lock(priv->mc13xxx);
-
 	mc13xxx_irq_ack(priv->mc13xxx, MC13XXX_IRQ_TS);
 
 	ret = mc13xxx_irq_request(priv->mc13xxx, MC13XXX_IRQ_TS,
 		mc13783_ts_handler, MC13783_TS_NAME, priv);
 	if (ret)
-		goto out;
+		return ret;
 
 	ret = mc13xxx_reg_rmw(priv->mc13xxx, MC13XXX_ADC0,
 			MC13XXX_ADC0_TSMOD_MASK, MC13XXX_ADC0_TSMOD0);
 	if (ret)
 		mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_TS, priv);
-out:
-	mc13xxx_unlock(priv->mc13xxx);
+
 	return ret;
 }
 
@@ -159,11 +156,9 @@ static void mc13783_ts_close(struct input_dev *dev)
 {
 	struct mc13783_ts_priv *priv = input_get_drvdata(dev);
 
-	mc13xxx_lock(priv->mc13xxx);
 	mc13xxx_reg_rmw(priv->mc13xxx, MC13XXX_ADC0,
 			MC13XXX_ADC0_TSMOD_MASK, 0);
 	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_TS, priv);
-	mc13xxx_unlock(priv->mc13xxx);
 
 	cancel_delayed_work_sync(&priv->work);
 }
diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
index fa9b439..173cc91 100644
--- a/drivers/leds/leds-mc13783.c
+++ b/drivers/leds/leds-mc13783.c
@@ -117,9 +117,7 @@ static void mc13xxx_led_work(struct work_struct *work)
 		BUG();
 	}
 
-	mc13xxx_lock(led->master);
 	mc13xxx_reg_rmw(led->master, reg, mask << shift, value << shift);
-	mc13xxx_unlock(led->master);
 }
 
 static void mc13xxx_led_set(struct led_classdev *led_cdev,
@@ -134,7 +132,7 @@ static void mc13xxx_led_set(struct led_classdev *led_cdev,
 
 static int __init mc13xxx_led_setup(struct mc13xxx_led *led, int max_current)
 {
-	int shift, mask, reg, ret, bank;
+	int shift, mask, reg, bank;
 
 	switch (led->id) {
 	case MC13783_LED_MD:
@@ -193,12 +191,8 @@ static int __init mc13xxx_led_setup(struct mc13xxx_led *led, int max_current)
 		BUG();
 	}
 
-	mc13xxx_lock(led->master);
-	ret = mc13xxx_reg_rmw(led->master, reg, mask << shift,
-			      max_current << shift);
-	mc13xxx_unlock(led->master);
-
-	return ret;
+	return mc13xxx_reg_rmw(led->master, reg, mask << shift,
+			       max_current << shift);
 }
 
 static int __init mc13xxx_led_probe(struct platform_device *pdev)
@@ -233,7 +227,6 @@ static int __init mc13xxx_led_probe(struct platform_device *pdev)
 	leds->num_leds = num_leds;
 	platform_set_drvdata(pdev, leds);
 
-	mc13xxx_lock(mcdev);
 	for (i = 0; i < devtype->num_regs; i++) {
 		reg = pdata->led_control[i];
 		WARN_ON(reg >= (1 << 24));
@@ -241,7 +234,6 @@ static int __init mc13xxx_led_probe(struct platform_device *pdev)
 		if (ret)
 			break;
 	}
-	mc13xxx_unlock(mcdev);
 
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to init LED driver\n");
@@ -313,10 +305,8 @@ static int mc13xxx_led_remove(struct platform_device *pdev)
 		cancel_work_sync(&leds->led[i].work);
 	}
 
-	mc13xxx_lock(mcdev);
 	for (i = 0; i < leds->devtype->num_regs; i++)
 		mc13xxx_reg_write(mcdev, MC13XXX_REG_LED_CONTROL(i), 0);
-	mc13xxx_unlock(mcdev);
 
 	return 0;
 }
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 625633a..f106fc6 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -133,27 +133,6 @@
 
 #define MC13XXX_ADC2		45
 
-void mc13xxx_lock(struct mc13xxx *mc13xxx)
-{
-	if (!mutex_trylock(&mc13xxx->lock)) {
-		dev_dbg(mc13xxx->dev, "wait for %s from %pf\n",
-				__func__, __builtin_return_address(0));
-
-		mutex_lock(&mc13xxx->lock);
-	}
-	dev_dbg(mc13xxx->dev, "%s from %pf\n",
-			__func__, __builtin_return_address(0));
-}
-EXPORT_SYMBOL(mc13xxx_lock);
-
-void mc13xxx_unlock(struct mc13xxx *mc13xxx)
-{
-	dev_dbg(mc13xxx->dev, "%s from %pf\n",
-			__func__, __builtin_return_address(0));
-	mutex_unlock(&mc13xxx->lock);
-}
-EXPORT_SYMBOL(mc13xxx_unlock);
-
 int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val)
 {
 	int ret;
@@ -283,7 +262,6 @@ EXPORT_SYMBOL(mc13xxx_irq_ack);
 int mc13xxx_irq_request_nounmask(struct mc13xxx *mc13xxx, int irq,
 		irq_handler_t handler, const char *name, void *dev)
 {
-	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
 	BUG_ON(!handler);
 
 	if (irq < 0 || irq >= MC13XXX_NUM_IRQ)
@@ -322,7 +300,6 @@ EXPORT_SYMBOL(mc13xxx_irq_request);
 int mc13xxx_irq_free(struct mc13xxx *mc13xxx, int irq, void *dev)
 {
 	int ret;
-	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
 
 	if (irq < 0 || irq >= MC13XXX_NUM_IRQ || !mc13xxx->irqhandler[irq] ||
 			mc13xxx->irqdata[irq] != dev)
@@ -393,8 +370,6 @@ static irqreturn_t mc13xxx_irq_thread(int irq, void *data)
 	irqreturn_t ret;
 	int handled = 0;
 
-	mc13xxx_lock(mc13xxx);
-
 	ret = mc13xxx_irq_handle(mc13xxx, MC13XXX_IRQSTAT0,
 			MC13XXX_IRQMASK0, 0);
 	if (ret > 0)
@@ -405,8 +380,6 @@ static irqreturn_t mc13xxx_irq_thread(int irq, void *data)
 	if (ret > 0)
 		handled = 1;
 
-	mc13xxx_unlock(mc13xxx);
-
 	return IRQ_RETVAL(handled);
 }
 
@@ -500,7 +473,7 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 
 	dev_dbg(mc13xxx->dev, "%s\n", __func__);
 
-	mc13xxx_lock(mc13xxx);
+	mutex_lock(&mc13xxx->lock);
 
 	if (mc13xxx->adcflags & MC13XXX_ADC_WORKING) {
 		ret = -EBUSY;
@@ -536,7 +509,7 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 		break;
 
 	default:
-		mc13xxx_unlock(mc13xxx);
+		mutex_unlock(&mc13xxx->lock);
 		return -EINVAL;
 	}
 
@@ -552,14 +525,14 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 	mc13xxx_reg_write(mc13xxx, MC13XXX_ADC0, adc0);
 	mc13xxx_reg_write(mc13xxx, MC13XXX_ADC1, adc1);
 
-	mc13xxx_unlock(mc13xxx);
+	mutex_unlock(&mc13xxx->lock);
 
 	ret = wait_for_completion_interruptible_timeout(&adcdone_data.done, HZ);
 
 	if (!ret)
 		ret = -ETIMEDOUT;
 
-	mc13xxx_lock(mc13xxx);
+	mutex_lock(&mc13xxx->lock);
 
 	mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_ADCDONE, &adcdone_data);
 
@@ -577,7 +550,7 @@ int mc13xxx_adc_do_conversion(struct mc13xxx *mc13xxx, unsigned int mode,
 
 	mc13xxx->adcflags &= ~MC13XXX_ADC_WORKING;
 out:
-	mc13xxx_unlock(mc13xxx);
+	mutex_unlock(&mc13xxx->lock);
 
 	return ret;
 }
@@ -645,37 +618,29 @@ int mc13xxx_common_init(struct mc13xxx *mc13xxx,
 	int ret;
 	u32 revision;
 
-	mc13xxx_lock(mc13xxx);
-
 	ret = mc13xxx_reg_read(mc13xxx, MC13XXX_REVISION, &revision);
 	if (ret)
-		goto err_revision;
+		return ret;
 
 	mc13xxx->variant->print_revision(mc13xxx, revision);
 
 	/* mask all irqs */
 	ret = mc13xxx_reg_write(mc13xxx, MC13XXX_IRQMASK0, 0x00ffffff);
 	if (ret)
-		goto err_mask;
+		return ret;
 
 	ret = mc13xxx_reg_write(mc13xxx, MC13XXX_IRQMASK1, 0x00ffffff);
 	if (ret)
-		goto err_mask;
+		return ret;
 
 	ret = request_threaded_irq(irq, NULL, mc13xxx_irq_thread,
 			IRQF_ONESHOT | IRQF_TRIGGER_HIGH, "mc13xxx", mc13xxx);
 
-	if (ret) {
-err_mask:
-err_revision:
-		mc13xxx_unlock(mc13xxx);
+	if (ret)
 		return ret;
-	}
 
 	mc13xxx->irq = irq;
 
-	mc13xxx_unlock(mc13xxx);
-
 	if (mc13xxx_probe_flags_dt(mc13xxx) < 0 && pdata)
 		mc13xxx->flags = pdata->flags;
 
diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 7f4a67e..6e8a0c2 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -304,10 +304,9 @@ static int mc13783_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
 
 	BUG_ON(val & ~mask);
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(mc13783, MC13783_REG_POWERMISC, &valread);
 	if (ret)
-		goto out;
+		return ret;
 
 	/* Update the stored state for Power Gates. */
 	priv->powermisc_pwgt_state =
@@ -320,10 +319,7 @@ static int mc13783_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
 	valread = (valread & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
 						priv->powermisc_pwgt_state;
 
-	ret = mc13xxx_reg_write(mc13783, MC13783_REG_POWERMISC, valread);
-out:
-	mc13xxx_unlock(priv->mc13xxx);
-	return ret;
+	return mc13xxx_reg_write(mc13783, MC13783_REG_POWERMISC, valread);
 }
 
 static int mc13783_gpo_regulator_enable(struct regulator_dev *rdev)
@@ -369,10 +365,7 @@ static int mc13783_gpo_regulator_is_enabled(struct regulator_dev *rdev)
 	int ret, id = rdev_get_id(rdev);
 	unsigned int val;
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(priv->mc13xxx, mc13xxx_regulators[id].reg, &val);
-	mc13xxx_unlock(priv->mc13xxx);
-
 	if (ret)
 		return ret;
 
diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index 96c9f80..2b1e11a 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -312,10 +312,9 @@ static int mc13892_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
 
 	BUG_ON(val & ~mask);
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(mc13892, MC13892_POWERMISC, &valread);
 	if (ret)
-		goto out;
+		return ret;
 
 	/* Update the stored state for Power Gates. */
 	priv->powermisc_pwgt_state =
@@ -328,10 +327,7 @@ static int mc13892_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
 	valread = (valread & ~MC13892_POWERMISC_PWGTSPI_M) |
 		priv->powermisc_pwgt_state;
 
-	ret = mc13xxx_reg_write(mc13892, MC13892_POWERMISC, valread);
-out:
-	mc13xxx_unlock(priv->mc13xxx);
-	return ret;
+	return mc13xxx_reg_write(mc13892, MC13892_POWERMISC, valread);
 }
 
 static int mc13892_gpo_regulator_enable(struct regulator_dev *rdev)
@@ -375,10 +371,7 @@ static int mc13892_gpo_regulator_is_enabled(struct regulator_dev *rdev)
 	int ret, id = rdev_get_id(rdev);
 	unsigned int val;
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(priv->mc13xxx, mc13892_regulators[id].reg, &val);
-	mc13xxx_unlock(priv->mc13xxx);
-
 	if (ret)
 		return ret;
 
@@ -407,10 +400,8 @@ static int mc13892_sw_regulator_get_voltage_sel(struct regulator_dev *rdev)
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(priv->mc13xxx,
 		mc13892_regulators[id].vsel_reg, &val);
-	mc13xxx_unlock(priv->mc13xxx);
 	if (ret)
 		return ret;
 
@@ -444,7 +435,6 @@ static int mc13892_sw_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	int volt, mask, id = rdev_get_id(rdev);
 	u32 reg_value;
-	int ret;
 
 	volt = rdev->desc->volt_table[selector];
 	mask = mc13892_regulators[id].vsel_mask;
@@ -475,12 +465,8 @@ static int mc13892_sw_regulator_set_voltage_sel(struct regulator_dev *rdev,
 		}
 	}
 
-	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].vsel_reg, mask,
-			      reg_value);
-	mc13xxx_unlock(priv->mc13xxx);
-
-	return ret;
+	return mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].vsel_reg,
+			       mask, reg_value);
 }
 
 static struct regulator_ops mc13892_sw_regulator_ops = {
@@ -494,17 +480,13 @@ static int mc13892_vcam_set_mode(struct regulator_dev *rdev, unsigned int mode)
 {
 	unsigned int en_val = 0;
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
-	int ret, id = rdev_get_id(rdev);
+	int id = rdev_get_id(rdev);
 
 	if (mode == REGULATOR_MODE_FAST)
 		en_val = MC13892_REGULATORMODE1_VCAMCONFIGEN;
 
-	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].reg,
+	return mc13xxx_reg_rmw(priv->mc13xxx, mc13892_regulators[id].reg,
 		MC13892_REGULATORMODE1_VCAMCONFIGEN, en_val);
-	mc13xxx_unlock(priv->mc13xxx);
-
-	return ret;
 }
 
 static unsigned int mc13892_vcam_get_mode(struct regulator_dev *rdev)
@@ -513,10 +495,7 @@ static unsigned int mc13892_vcam_get_mode(struct regulator_dev *rdev)
 	int ret, id = rdev_get_id(rdev);
 	unsigned int val;
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(priv->mc13xxx, mc13892_regulators[id].reg, &val);
-	mc13xxx_unlock(priv->mc13xxx);
-
 	if (ret)
 		return ret;
 
@@ -557,10 +536,9 @@ static int mc13892_regulator_probe(struct platform_device *pdev)
 	priv->mc13xxx = mc13892;
 	platform_set_drvdata(pdev, priv);
 
-	mc13xxx_lock(mc13892);
 	ret = mc13xxx_reg_read(mc13892, MC13892_REVISION, &val);
 	if (ret)
-		goto err_unlock;
+		return ret;
 
 	/* enable switch auto mode (on 2.0A silicon only) */
 	if ((val & 0x0000FFFF) == 0x45d0) {
@@ -570,7 +548,7 @@ static int mc13892_regulator_probe(struct platform_device *pdev)
 			MC13892_SWITCHERS4_SW1MODE_AUTO |
 			MC13892_SWITCHERS4_SW2MODE_AUTO);
 		if (ret)
-			goto err_unlock;
+			return ret;
 
 		ret = mc13xxx_reg_rmw(mc13892, MC13892_SWITCHERS5,
 			MC13892_SWITCHERS5_SW3MODE_M |
@@ -578,9 +556,8 @@ static int mc13892_regulator_probe(struct platform_device *pdev)
 			MC13892_SWITCHERS5_SW3MODE_AUTO |
 			MC13892_SWITCHERS5_SW4MODE_AUTO);
 		if (ret)
-			goto err_unlock;
+			return ret;
 	}
-	mc13xxx_unlock(mc13892);
 
 	mc13892_regulators[MC13892_VCAM].desc.ops->set_mode
 		= mc13892_vcam_set_mode;
@@ -621,10 +598,6 @@ static int mc13892_regulator_probe(struct platform_device *pdev)
 	}
 
 	return 0;
-
-err_unlock:
-	mc13xxx_unlock(mc13892);
-	return ret;
 }
 
 static struct platform_driver mc13892_regulator_driver = {
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index da48592..005122f 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -33,17 +33,12 @@ static int mc13xxx_regulator_enable(struct regulator_dev *rdev)
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
 	int id = rdev_get_id(rdev);
-	int ret;
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
-	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].reg,
+	return mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].reg,
 			mc13xxx_regulators[id].enable_bit,
 			mc13xxx_regulators[id].enable_bit);
-	mc13xxx_unlock(priv->mc13xxx);
-
-	return ret;
 }
 
 static int mc13xxx_regulator_disable(struct regulator_dev *rdev)
@@ -51,16 +46,11 @@ static int mc13xxx_regulator_disable(struct regulator_dev *rdev)
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
 	int id = rdev_get_id(rdev);
-	int ret;
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
-	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].reg,
+	return mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].reg,
 			mc13xxx_regulators[id].enable_bit, 0);
-	mc13xxx_unlock(priv->mc13xxx);
-
-	return ret;
 }
 
 static int mc13xxx_regulator_is_enabled(struct regulator_dev *rdev)
@@ -70,10 +60,7 @@ static int mc13xxx_regulator_is_enabled(struct regulator_dev *rdev)
 	int ret, id = rdev_get_id(rdev);
 	unsigned int val;
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(priv->mc13xxx, mc13xxx_regulators[id].reg, &val);
-	mc13xxx_unlock(priv->mc13xxx);
-
 	if (ret)
 		return ret;
 
@@ -86,15 +73,10 @@ static int mc13xxx_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
 	int id = rdev_get_id(rdev);
-	int ret;
 
-	mc13xxx_lock(priv->mc13xxx);
-	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].vsel_reg,
+	return mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].vsel_reg,
 			mc13xxx_regulators[id].vsel_mask,
 			selector << mc13xxx_regulators[id].vsel_shift);
-	mc13xxx_unlock(priv->mc13xxx);
-
-	return ret;
 }
 
 static int mc13xxx_regulator_get_voltage(struct regulator_dev *rdev)
@@ -106,11 +88,8 @@ static int mc13xxx_regulator_get_voltage(struct regulator_dev *rdev)
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d\n", __func__, id);
 
-	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(priv->mc13xxx,
 				mc13xxx_regulators[id].vsel_reg, &val);
-	mc13xxx_unlock(priv->mc13xxx);
-
 	if (ret)
 		return ret;
 
diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 77ea989..91eef38 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -29,7 +29,7 @@ struct mc13xxx_rtc {
 	int valid;
 };
 
-static int mc13xxx_rtc_irq_enable_unlocked(struct device *dev,
+static int mc13xxx_rtc_irq_enable(struct device *dev,
 		unsigned int enabled, int irq)
 {
 	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
@@ -39,22 +39,8 @@ static int mc13xxx_rtc_irq_enable_unlocked(struct device *dev,
 		return -ENODATA;
 
 	func = enabled ? mc13xxx_irq_unmask : mc13xxx_irq_mask;
-	return func(priv->mc13xxx, irq);
-}
-
-static int mc13xxx_rtc_irq_enable(struct device *dev,
-		unsigned int enabled, int irq)
-{
-	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
-	int ret;
 
-	mc13xxx_lock(priv->mc13xxx);
-
-	ret = mc13xxx_rtc_irq_enable_unlocked(dev, enabled, irq);
-
-	mc13xxx_unlock(priv->mc13xxx);
-
-	return ret;
+	return func(priv->mc13xxx, irq);
 }
 
 static int mc13xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
@@ -64,25 +50,18 @@ static int mc13xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	unsigned long s1970;
 	int ret;
 
-	mc13xxx_lock(priv->mc13xxx);
-
-	if (!priv->valid) {
-		ret = -ENODATA;
-		goto out;
-	}
+	if (!priv->valid)
+		return -ENODATA;
 
 	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCDAY, &days1);
 	if (unlikely(ret))
-		goto out;
+		return ret;
 
 	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCTOD, &seconds);
 	if (unlikely(ret))
-		goto out;
+		return ret;
 
 	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCDAY, &days2);
-out:
-	mc13xxx_unlock(priv->mc13xxx);
-
 	if (ret)
 		return ret;
 
@@ -113,8 +92,6 @@ static int mc13xxx_rtc_set_mmss(struct device *dev, unsigned long secs)
 	seconds = secs % 86400;
 	days = secs / 86400;
 
-	mc13xxx_lock(priv->mc13xxx);
-
 	/*
 	 * temporarily invalidate alarm to prevent triggering it when the day is
 	 * already updated while the time isn't yet.
@@ -162,8 +139,6 @@ static int mc13xxx_rtc_set_mmss(struct device *dev, unsigned long secs)
 out:
 	priv->valid = !ret;
 
-	mc13xxx_unlock(priv->mc13xxx);
-
 	return ret;
 }
 
@@ -175,26 +150,18 @@ static int mc13xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	int enabled, pending;
 	int ret;
 
-	mc13xxx_lock(priv->mc13xxx);
-
 	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCTODA, &seconds);
 	if (unlikely(ret))
-		goto out;
-	if (seconds >= 86400) {
-		ret = -ENODATA;
-		goto out;
-	}
+		return ret;
+	if (seconds >= 86400)
+		return -ENODATA;
 
 	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCDAY, &days);
 	if (unlikely(ret))
-		goto out;
+		return ret;
 
 	ret = mc13xxx_irq_status(priv->mc13xxx, MC13XXX_IRQ_TODA,
 			&enabled, &pending);
-
-out:
-	mc13xxx_unlock(priv->mc13xxx);
-
 	if (ret)
 		return ret;
 
@@ -216,42 +183,34 @@ static int mc13xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	unsigned seconds, days;
 	int ret;
 
-	mc13xxx_lock(priv->mc13xxx);
-
 	/* disable alarm to prevent false triggering */
 	ret = mc13xxx_reg_write(priv->mc13xxx, MC13XXX_RTCTODA, 0x1ffff);
 	if (unlikely(ret))
-		goto out;
+		return ret;
 
 	ret = mc13xxx_irq_ack(priv->mc13xxx, MC13XXX_IRQ_TODA);
 	if (unlikely(ret))
-		goto out;
+		return ret;
 
 	ret = rtc_tm_to_time(&alarm->time, &s1970);
 	if (unlikely(ret))
-		goto out;
+		return ret;
 
 	dev_dbg(dev, "%s: o%2.s %lu\n", __func__, alarm->enabled ? "n" : "ff",
 			s1970);
 
-	ret = mc13xxx_rtc_irq_enable_unlocked(dev, alarm->enabled,
-			MC13XXX_IRQ_TODA);
+	ret = mc13xxx_rtc_irq_enable(dev, alarm->enabled, MC13XXX_IRQ_TODA);
 	if (unlikely(ret))
-		goto out;
+		return ret;
 
 	seconds = s1970 % 86400;
 	days = s1970 / 86400;
 
 	ret = mc13xxx_reg_write(priv->mc13xxx, MC13XXX_RTCDAYA, days);
 	if (unlikely(ret))
-		goto out;
-
-	ret = mc13xxx_reg_write(priv->mc13xxx, MC13XXX_RTCTODA, seconds);
-
-out:
-	mc13xxx_unlock(priv->mc13xxx);
+		return ret;
 
-	return ret;
+	return mc13xxx_reg_write(priv->mc13xxx, MC13XXX_RTCTODA, seconds);
 }
 
 static irqreturn_t mc13xxx_rtc_alarm_handler(int irq, void *dev)
@@ -325,17 +284,15 @@ static int __init mc13xxx_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, priv);
 
-	mc13xxx_lock(mc13xxx);
-
 	ret = mc13xxx_irq_request(mc13xxx, MC13XXX_IRQ_RTCRST,
 			mc13xxx_rtc_reset_handler, DRIVER_NAME, priv);
 	if (ret)
-		goto err_reset_irq_request;
+		return ret;
 
 	ret = mc13xxx_irq_status(mc13xxx, MC13XXX_IRQ_RTCRST,
 			NULL, &rtcrst_pending);
 	if (ret)
-		goto err_reset_irq_status;
+		return ret;
 
 	priv->valid = !rtcrst_pending;
 
@@ -349,27 +306,18 @@ static int __init mc13xxx_rtc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_alarm_irq_request;
 
-	mc13xxx_unlock(mc13xxx);
-
 	priv->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 					&mc13xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(priv->rtc)) {
 		ret = PTR_ERR(priv->rtc);
 
-		mc13xxx_lock(mc13xxx);
-
 		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_TODA, priv);
-err_alarm_irq_request:
 
+err_alarm_irq_request:
 		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_1HZ, priv);
-err_update_irq_request:
-
-err_reset_irq_status:
 
+err_update_irq_request:
 		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_RTCRST, priv);
-err_reset_irq_request:
-
-		mc13xxx_unlock(mc13xxx);
 	}
 
 	return ret;
@@ -379,14 +327,10 @@ static int __exit mc13xxx_rtc_remove(struct platform_device *pdev)
 {
 	struct mc13xxx_rtc *priv = platform_get_drvdata(pdev);
 
-	mc13xxx_lock(priv->mc13xxx);
-
 	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_TODA, priv);
 	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_1HZ, priv);
 	mc13xxx_irq_free(priv->mc13xxx, MC13XXX_IRQ_RTCRST, priv);
 
-	mc13xxx_unlock(priv->mc13xxx);
-
 	return 0;
 }
 
diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
index 67c17b5..2c2afcf 100644
--- a/include/linux/mfd/mc13xxx.h
+++ b/include/linux/mfd/mc13xxx.h
@@ -13,9 +13,6 @@
 
 struct mc13xxx;
 
-void mc13xxx_lock(struct mc13xxx *mc13xxx);
-void mc13xxx_unlock(struct mc13xxx *mc13xxx);
-
 int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val);
 int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int offset, u32 val);
 int mc13xxx_reg_rmw(struct mc13xxx *mc13xxx, unsigned int offset,
-- 
1.8.3.2

