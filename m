Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaIEUwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:52:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54097 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaIEUwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:52:35 -0400
From: Nishanth Menon <nm@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@linaro.org>,
        Nishanth Menon <nm@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH V2 3/3] mfd: palmas: Add support for optional wakeup
Date: Fri, 5 Sep 2014 15:51:51 -0500
Message-ID: <1409950311-25236-4-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409950311-25236-1-git-send-email-nm@ti.com>
References: <1409950311-25236-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent pinctrl-single changes, omaps can treat wake-up events
from deeper power  states as interrupts.

This is to handle the case where the system needs two interrupt
sources when SoC is in deep sleep(1 to exit from deep power mode such
as sleep, and other from the module handling the actual event during
system active state). This is not the same as threaded interrupts as the
wakeup interrupt source is used only as part of deeper power saving
mode.

Let's add support for the optional second interrupt for wake-up
events. And then SoC can wakeup and handle the event using it's
regular handler.

This is similar in approach to commit 2a0b965cfb6e ("serial: omap: Add
support for optional wake-up")

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/mfd/palmas.c       |   59 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/palmas.h |    2 ++
 2 files changed, 61 insertions(+)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 28cb048..11186ab 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -24,6 +24,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/palmas.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 
 static const struct regmap_config palmas_regmap_config[PALMAS_NUM_CLIENTS] = {
 	{
@@ -326,6 +327,16 @@ static struct regmap_irq_chip tps65917_irq_chip = {
 			PALMAS_INT1_MASK),
 };
 
+static irqreturn_t palmas_wake_irq(int irq, void *_palmas)
+{
+	/*
+	 * Return Not handled so that interrupt is disabled.
+	 * Level event ensures that the event is eventually handled
+	 * by the appropriate chip handler already registered
+	 */
+	return IRQ_NONE;
+}
+
 int palmas_ext_control_req_config(struct palmas *palmas,
 	enum palmas_external_requestor_id id,  int ext_ctrl, bool enable)
 {
@@ -409,6 +420,7 @@ static void palmas_dt_to_pdata(struct i2c_client *i2c,
 		pdata->mux_from_pdata = 1;
 		pdata->pad2 = prop;
 	}
+	pdata->wakeirq = irq_of_parse_and_map(node, 1);
 
 	/* The default for this register is all masked */
 	ret = of_property_read_u32(node, "ti,power-ctrl", &prop);
@@ -521,6 +533,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	i2c_set_clientdata(i2c, palmas);
 	palmas->dev = &i2c->dev;
 	palmas->irq = i2c->irq;
+	palmas->wakeirq = pdata->wakeirq;
 
 	match = of_match_device(of_palmas_match_tbl, &i2c->dev);
 
@@ -587,6 +600,22 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err_i2c;
 
+	if (!palmas->wakeirq)
+		goto no_wake_irq;
+
+	ret = devm_request_irq(palmas->dev, palmas->wakeirq,
+			       palmas_wake_irq,
+			       IRQF_ONESHOT | pdata->irq_flags,
+			       dev_name(palmas->dev),
+			       &palmas);
+	if (ret < 0)
+		goto err_i2c;
+
+	/* We use wakeirq only during suspend-resume path */
+	device_set_wakeup_capable(palmas->dev, true);
+	disable_irq_nosync(palmas->wakeirq);
+
+no_wake_irq:
 no_irq:
 	slave = PALMAS_BASE_TO_SLAVE(PALMAS_PU_PD_OD_BASE);
 	addr = PALMAS_BASE_TO_REG(PALMAS_PU_PD_OD_BASE,
@@ -706,6 +735,34 @@ static int palmas_i2c_remove(struct i2c_client *i2c)
 	return 0;
 }
 
+static int palmas_i2c_suspend(struct i2c_client *i2c,  pm_message_t mesg)
+{
+	struct palmas *palmas = i2c_get_clientdata(i2c);
+	struct device *dev = &i2c->dev;
+
+	if (!palmas->wakeirq)
+		return 0;
+
+	if (device_may_wakeup(dev))
+		enable_irq(palmas->wakeirq);
+
+	return 0;
+}
+
+static int palmas_i2c_resume(struct i2c_client *i2c)
+{
+	struct palmas *palmas = i2c_get_clientdata(i2c);
+	struct device *dev = &i2c->dev;
+
+	if (!palmas->wakeirq)
+		return 0;
+
+	if (device_may_wakeup(dev))
+		disable_irq_nosync(palmas->wakeirq);
+
+	return 0;
+}
+
 static const struct i2c_device_id palmas_i2c_id[] = {
 	{ "palmas", },
 	{ "twl6035", },
@@ -721,6 +778,8 @@ static struct i2c_driver palmas_i2c_driver = {
 		   .of_match_table = of_palmas_match_tbl,
 		   .owner = THIS_MODULE,
 	},
+	.suspend = palmas_i2c_suspend,
+	.resume = palmas_i2c_resume,
 	.probe = palmas_i2c_probe,
 	.remove = palmas_i2c_remove,
 	.id_table = palmas_i2c_id,
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index fb0390a..e8cf4c2 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -75,6 +75,7 @@ struct palmas {
 	/* IRQ Data */
 	int irq;
 	u32 irq_mask;
+	int wakeirq;
 	struct mutex irq_lock;
 	struct regmap_irq_chip_data *irq_data;
 
@@ -377,6 +378,7 @@ struct palmas_clk_platform_data {
 
 struct palmas_platform_data {
 	int irq_flags;
+	int wakeirq;
 	int gpio_base;
 
 	/* bit value to be loaded to the POWER_CTRL register */
-- 
1.7.9.5

