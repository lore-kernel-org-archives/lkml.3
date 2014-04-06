Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbaDFLwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 07:52:38 -0400
Received: from ring0.de ([5.45.105.125]:51864 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbaDFLw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 07:52:27 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: linux-media@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Eduardo Valentin <edubezval@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, Dinesh Ram <Dinesh.Ram@cern.ch>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [RFC 1/2] [media] si4713: add Device Tree support
Date: Sun,  6 Apr 2014 13:52:04 +0200
Message-Id: <1396785125-8759-2-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396785125-8759-1-git-send-email-sre@kernel.org>
References: <1396785125-8759-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update si4713 driver to support being instantiated via
Device Tree. This includes moving the regulator names
back into the drivers, using regulator_get_optional
to avoid breaking the USB driver and switching to the
gpio resource interface.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c       |  67 ++++-----
 drivers/media/radio/si4713/radio-platform-si4713.c |  28 +---
 drivers/media/radio/si4713/si4713.c                | 166 +++++++++++++--------
 drivers/media/radio/si4713/si4713.h                |  15 +-
 include/media/radio-si4713.h                       |  30 ----
 include/media/si4713.h                             |   4 +-
 6 files changed, 153 insertions(+), 157 deletions(-)
 delete mode 100644 include/media/radio-si4713.h

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 01184ed..488cfe3 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -23,6 +23,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/gpio.h>
 #include <linux/gpio_keys.h>
+#include <linux/gpio/driver.h>
 #include <linux/mmc/host.h>
 #include <linux/power/isp1704_charger.h>
 #include <linux/power/bq2415x_charger.h>
@@ -39,7 +40,6 @@
 
 #include <sound/tlv320aic3x.h>
 #include <sound/tpa6130a2-plat.h>
-#include <media/radio-si4713.h>
 #include <media/si4713.h>
 #include <linux/platform_data/leds-lp55xx.h>
 
@@ -761,46 +761,17 @@ static struct regulator_init_data rx51_vintdig = {
 	},
 };
 
-static const char * const si4713_supply_names[] = {
-	"vio",
-	"vdd",
-};
-
-static struct si4713_platform_data rx51_si4713_i2c_data __initdata_or_module = {
-	.supplies	= ARRAY_SIZE(si4713_supply_names),
-	.supply_names	= si4713_supply_names,
-	.gpio_reset	= RX51_FMTX_RESET_GPIO,
-};
-
-static struct i2c_board_info rx51_si4713_board_info __initdata_or_module = {
-	I2C_BOARD_INFO("si4713", SI4713_I2C_ADDR_BUSEN_HIGH),
-	.platform_data	= &rx51_si4713_i2c_data,
-};
-
-static struct radio_si4713_platform_data rx51_si4713_data __initdata_or_module = {
-	.i2c_bus	= 2,
-	.subdev_board_info = &rx51_si4713_board_info,
-};
-
-static struct platform_device rx51_si4713_dev __initdata_or_module = {
-	.name	= "radio-si4713",
-	.id	= -1,
-	.dev	= {
-		.platform_data	= &rx51_si4713_data,
+static struct gpiod_lookup_table rx51_fmtx_gpios_table = {
+	.dev_id = "2-0063",
+	.table = {
+		GPIO_LOOKUP("gpio.6", 3, "reset", GPIO_ACTIVE_HIGH), /* 163 */
+		{ },
 	},
 };
 
-static __init void rx51_init_si4713(void)
+static __init void rx51_gpio_init(void)
 {
-	int err;
-
-	err = gpio_request_one(RX51_FMTX_IRQ, GPIOF_DIR_IN, "si4713 irq");
-	if (err) {
-		printk(KERN_ERR "Cannot request si4713 irq gpio. %d\n", err);
-		return;
-	}
-	rx51_si4713_board_info.irq = gpio_to_irq(RX51_FMTX_IRQ);
-	platform_device_register(&rx51_si4713_dev);
+	gpiod_add_lookup_table(&rx51_fmtx_gpios_table);
 }
 
 static int rx51_twlgpio_setup(struct device *dev, unsigned gpio, unsigned n)
@@ -1040,7 +1011,17 @@ static struct bq2415x_platform_data rx51_bq24150a_platform_data = {
 	.notify_device = "isp1704",
 };
 
+static struct si4713_platform_data rx51_si4713_platform_data = {
+	.is_platform_device = true
+};
+
 static struct i2c_board_info __initdata rx51_peripherals_i2c_board_info_2[] = {
+#if IS_ENABLED(CONFIG_I2C_SI4713) && IS_ENABLED(CONFIG_PLATFORM_SI4713)
+	{
+		I2C_BOARD_INFO("si4713", 0x63),
+		.platform_data = &rx51_si4713_platform_data,
+	},
+#endif
 	{
 		I2C_BOARD_INFO("tlv320aic3x", 0x18),
 		.platform_data = &rx51_aic3x_data,
@@ -1085,6 +1066,8 @@ static struct i2c_board_info __initdata rx51_peripherals_i2c_board_info_3[] = {
 
 static int __init rx51_i2c_init(void)
 {
+	int err;
+
 	if ((system_rev >= SYSTEM_REV_S_USES_VAUX3 && system_rev < 0x100) ||
 	    system_rev >= SYSTEM_REV_B_USES_VAUX3) {
 		rx51_twldata.vaux3 = &rx51_vaux3_mmc;
@@ -1102,6 +1085,14 @@ static int __init rx51_i2c_init(void)
 	rx51_twldata.vdac->constraints.name = "VDAC";
 
 	omap_pmic_init(1, 2200, "twl5030", 7 + OMAP_INTC_START, &rx51_twldata);
+#if IS_ENABLED(CONFIG_I2C_SI4713) && IS_ENABLED(CONFIG_PLATFORM_SI4713)
+	err = gpio_request_one(RX51_FMTX_IRQ, GPIOF_DIR_IN, "si4713 irq");
+	if (err) {
+		printk(KERN_ERR "Cannot request si4713 irq gpio. %d\n", err);
+		return err;
+	}
+	rx51_peripherals_i2c_board_info_2[0].irq = gpio_to_irq(RX51_FMTX_IRQ);
+#endif
 	omap_register_i2c_bus(2, 100, rx51_peripherals_i2c_board_info_2,
 			      ARRAY_SIZE(rx51_peripherals_i2c_board_info_2));
 #if defined(CONFIG_SENSORS_LIS3_I2C) || defined(CONFIG_SENSORS_LIS3_I2C_MODULE)
@@ -1315,6 +1306,7 @@ static void __init rx51_init_omap3_rom_rng(void)
 
 void __init rx51_peripherals_init(void)
 {
+	rx51_gpio_init();
 	rx51_i2c_init();
 	regulator_has_full_constraints();
 	gpmc_onenand_init(board_onenand_data);
@@ -1322,7 +1314,6 @@ void __init rx51_peripherals_init(void)
 	rx51_add_gpio_keys();
 	rx51_init_wl1251();
 	rx51_init_tsc2005();
-	rx51_init_si4713();
 	rx51_init_lirc();
 	spi_register_board_info(rx51_peripherals_spi_board_info,
 				ARRAY_SIZE(rx51_peripherals_spi_board_info));
diff --git a/drivers/media/radio/si4713/radio-platform-si4713.c b/drivers/media/radio/si4713/radio-platform-si4713.c
index ba4cfc9..27f1ffb 100644
--- a/drivers/media/radio/si4713/radio-platform-si4713.c
+++ b/drivers/media/radio/si4713/radio-platform-si4713.c
@@ -34,7 +34,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-event.h>
-#include <media/radio-si4713.h>
+#include "si4713.h"
 
 /* module parameters */
 static int radio_nr = -1;	/* radio device minor (-1 ==> auto assign) */
@@ -153,7 +153,6 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 {
 	struct radio_si4713_platform_data *pdata = pdev->dev.platform_data;
 	struct radio_si4713_device *rsdev;
-	struct i2c_adapter *adapter;
 	struct v4l2_subdev *sd;
 	int rval = 0;
 
@@ -177,20 +176,11 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
-	adapter = i2c_get_adapter(pdata->i2c_bus);
-	if (!adapter) {
-		dev_err(&pdev->dev, "Cannot get i2c adapter %d\n",
-			pdata->i2c_bus);
-		rval = -ENODEV;
-		goto unregister_v4l2_dev;
-	}
-
-	sd = v4l2_i2c_new_subdev_board(&rsdev->v4l2_dev, adapter,
-				       pdata->subdev_board_info, NULL);
-	if (!sd) {
+	sd = i2c_get_clientdata(pdata->subdev);
+	rval = v4l2_device_register_subdev(&rsdev->v4l2_dev, sd);
+	if (rval) {
 		dev_err(&pdev->dev, "Cannot get v4l2 subdevice\n");
-		rval = -ENODEV;
-		goto put_adapter;
+		goto unregister_v4l2_dev;
 	}
 
 	rsdev->radio_dev = radio_si4713_vdev_template;
@@ -203,14 +193,12 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 	if (video_register_device(&rsdev->radio_dev, VFL_TYPE_RADIO, radio_nr)) {
 		dev_err(&pdev->dev, "Could not register video device.\n");
 		rval = -EIO;
-		goto put_adapter;
+		goto unregister_v4l2_dev;
 	}
 	dev_info(&pdev->dev, "New device successfully probed\n");
 
 	goto exit;
 
-put_adapter:
-	i2c_put_adapter(adapter);
 unregister_v4l2_dev:
 	v4l2_device_unregister(&rsdev->v4l2_dev);
 exit:
@@ -221,14 +209,10 @@ exit:
 static int radio_si4713_pdriver_remove(struct platform_device *pdev)
 {
 	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
-	struct v4l2_subdev *sd = list_entry(v4l2_dev->subdevs.next,
-					    struct v4l2_subdev, list);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct radio_si4713_device *rsdev;
 
 	rsdev = container_of(v4l2_dev, struct radio_si4713_device, v4l2_dev);
 	video_unregister_device(&rsdev->radio_dev);
-	i2c_put_adapter(client->adapter);
 	v4l2_device_unregister(&rsdev->v4l2_dev);
 
 	return 0;
diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 07d5153..c12d3f9 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -23,6 +23,7 @@
 
 #include <linux/completion.h>
 #include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
@@ -366,16 +367,25 @@ static int si4713_powerup(struct si4713_device *sdev)
 	if (sdev->power_state)
 		return 0;
 
-	if (sdev->supplies) {
-		err = regulator_bulk_enable(sdev->supplies, sdev->supply_data);
+	if (sdev->vdd) {
+		err = regulator_enable(sdev->vdd);
 		if (err) {
-			v4l2_err(&sdev->sd, "Failed to enable supplies: %d\n", err);
+			v4l2_err(&sdev->sd, "Failed to enable vdd: %d\n", err);
 			return err;
 		}
 	}
-	if (gpio_is_valid(sdev->gpio_reset)) {
+
+	if (sdev->vio) {
+		err = regulator_enable(sdev->vio);
+		if (err) {
+			v4l2_err(&sdev->sd, "Failed to enable vio: %d\n", err);
+			return err;
+		}
+	}
+
+	if (!IS_ERR(sdev->gpio_reset)) {
 		udelay(50);
-		gpio_set_value(sdev->gpio_reset, 1);
+		gpiod_set_value(sdev->gpio_reset, 1);
 	}
 
 	if (client->irq)
@@ -397,13 +407,20 @@ static int si4713_powerup(struct si4713_device *sdev)
 						SI4713_STC_INT | SI4713_CTS);
 		return err;
 	}
-	if (gpio_is_valid(sdev->gpio_reset))
-		gpio_set_value(sdev->gpio_reset, 0);
-	if (sdev->supplies) {
-		err = regulator_bulk_disable(sdev->supplies, sdev->supply_data);
+	if (!IS_ERR(sdev->gpio_reset))
+		gpiod_set_value(sdev->gpio_reset, 0);
+
+
+	if (sdev->vdd) {
+		err = regulator_disable(sdev->vdd);
 		if (err)
-			v4l2_err(&sdev->sd,
-				 "Failed to disable supplies: %d\n", err);
+			v4l2_err(&sdev->sd, "Failed to disable vdd: %d\n", err);
+	}
+
+	if (sdev->vio) {
+		err = regulator_disable(sdev->vio);
+		if (err)
+			v4l2_err(&sdev->sd, "Failed to disable vio: %d\n", err);
 	}
 
 	return err;
@@ -430,15 +447,25 @@ static int si4713_powerdown(struct si4713_device *sdev)
 		v4l2_dbg(1, debug, &sdev->sd, "Power down response: 0x%02x\n",
 				resp[0]);
 		v4l2_dbg(1, debug, &sdev->sd, "Device in reset mode\n");
-		if (gpio_is_valid(sdev->gpio_reset))
-			gpio_set_value(sdev->gpio_reset, 0);
-		if (sdev->supplies) {
-			err = regulator_bulk_disable(sdev->supplies,
-						     sdev->supply_data);
-			if (err)
+		if (!IS_ERR(sdev->gpio_reset))
+			gpiod_set_value(sdev->gpio_reset, 0);
+
+		if (sdev->vdd) {
+			err = regulator_disable(sdev->vdd);
+			if (err) {
+				v4l2_err(&sdev->sd,
+					"Failed to disable vdd: %d\n", err);
+			}
+		}
+
+		if (sdev->vio) {
+			err = regulator_disable(sdev->vio);
+			if (err) {
 				v4l2_err(&sdev->sd,
-					 "Failed to disable supplies: %d\n", err);
+					"Failed to disable vio: %d\n", err);
+			}
 		}
+
 		sdev->power_state = POWER_OFF;
 	}
 
@@ -1363,38 +1390,50 @@ static int si4713_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
 	struct si4713_device *sdev;
-	struct si4713_platform_data *pdata = client->dev.platform_data;
 	struct v4l2_ctrl_handler *hdl;
-	int rval, i;
+	struct si4713_platform_data *pdata = client->dev.platform_data;
+	struct device_node *np = client->dev.of_node;
+	int rval;
+
+	struct radio_si4713_platform_data si4713_pdev_pdata;
+	struct platform_device *si4713_pdev;
 
-	sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
+	sdev = devm_kzalloc(&client->dev, sizeof(*sdev), GFP_KERNEL);
 	if (!sdev) {
 		dev_err(&client->dev, "Failed to alloc video device.\n");
 		rval = -ENOMEM;
 		goto exit;
 	}
 
-	sdev->gpio_reset = -1;
-	if (pdata && gpio_is_valid(pdata->gpio_reset)) {
-		rval = gpio_request(pdata->gpio_reset, "si4713 reset");
-		if (rval) {
-			dev_err(&client->dev,
-				"Failed to request gpio: %d\n", rval);
-			goto free_sdev;
-		}
-		sdev->gpio_reset = pdata->gpio_reset;
-		gpio_direction_output(sdev->gpio_reset, 0);
-		sdev->supplies = pdata->supplies;
+	sdev->gpio_reset = devm_gpiod_get(&client->dev, "reset");
+	if (!IS_ERR(sdev->gpio_reset)) {
+		gpiod_direction_output(sdev->gpio_reset, 0);
+	} else if (PTR_ERR(sdev->gpio_reset) == -ENOENT) {
+		dev_dbg(&client->dev, "No reset GPIO assigned\n");
+	} else {
+		rval = PTR_ERR(sdev->gpio_reset);
+		dev_err(&client->dev, "Failed to request gpio: %d\n", rval);
+		goto exit;
 	}
 
-	for (i = 0; i < sdev->supplies; i++)
-		sdev->supply_data[i].supply = pdata->supply_names[i];
+	sdev->vdd = devm_regulator_get_optional(&client->dev, "vdd");
+	if (IS_ERR(sdev->vdd)) {
+		rval = PTR_ERR(sdev->vdd);
+		if (rval == -EPROBE_DEFER)
+			goto exit;
 
-	rval = regulator_bulk_get(&client->dev, sdev->supplies,
-				  sdev->supply_data);
-	if (rval) {
-		dev_err(&client->dev, "Cannot get regulators: %d\n", rval);
-		goto free_gpio;
+		dev_info(&client->dev, "no vdd regulator found: %d\n", rval);
+		sdev->vdd = NULL;
+	}
+
+	sdev->vio = devm_regulator_get_optional(&client->dev, "vio");
+	if (IS_ERR(sdev->vio)) {
+		rval = PTR_ERR(sdev->vio);
+		if (rval == -EPROBE_DEFER)
+			goto exit;
+
+		dev_info(&client->dev, "no vio regulator found: %d\n", rval);
+		sdev->vio = NULL;
 	}
 
 	v4l2_i2c_subdev_init(&sdev->sd, client, &si4713_subdev_ops);
@@ -1480,12 +1519,12 @@ static int si4713_probe(struct i2c_client *client,
 	sdev->sd.ctrl_handler = hdl;
 
 	if (client->irq) {
-		rval = request_irq(client->irq,
+		rval = devm_request_irq(&client->dev, client->irq,
 			si4713_handler, IRQF_TRIGGER_FALLING,
 			client->name, sdev);
 		if (rval < 0) {
 			v4l2_err(&sdev->sd, "Could not request IRQ\n");
-			goto put_reg;
+			goto free_ctrls;
 		}
 		v4l2_dbg(1, debug, &sdev->sd, "IRQ requested.\n");
 	} else {
@@ -1495,23 +1534,36 @@ static int si4713_probe(struct i2c_client *client,
 	rval = si4713_initialize(sdev);
 	if (rval < 0) {
 		v4l2_err(&sdev->sd, "Failed to probe device information.\n");
-		goto free_irq;
+		goto free_ctrls;
+	}
+
+	if ((pdata && pdata->is_platform_device) || np) {
+		si4713_pdev = platform_device_alloc("radio-si4713", -1);
+		if (!si4713_pdev)
+			goto put_main_pdev;
+
+		si4713_pdev_pdata.subdev = client;
+		rval = platform_device_add_data(si4713_pdev, &si4713_pdev_pdata,
+						sizeof(si4713_pdev_pdata));
+		if (rval)
+			goto put_main_pdev;
+
+		rval = platform_device_add(si4713_pdev);
+		if (rval)
+			goto put_main_pdev;
+
+		sdev->pd = si4713_pdev;
+	} else {
+		sdev->pd = NULL;
 	}
 
 	return 0;
 
-free_irq:
-	if (client->irq)
-		free_irq(client->irq, sdev);
+put_main_pdev:
+	platform_device_put(si4713_pdev);
+	v4l2_device_unregister_subdev(&sdev->sd);
 free_ctrls:
 	v4l2_ctrl_handler_free(hdl);
-put_reg:
-	regulator_bulk_free(sdev->supplies, sdev->supply_data);
-free_gpio:
-	if (gpio_is_valid(sdev->gpio_reset))
-		gpio_free(sdev->gpio_reset);
-free_sdev:
-	kfree(sdev);
 exit:
 	return rval;
 }
@@ -1522,18 +1574,14 @@ static int si4713_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct si4713_device *sdev = to_si4713_device(sd);
 
+	if (sdev->pd)
+		platform_device_unregister(sdev->pd);
+
 	if (sdev->power_state)
 		si4713_set_power_state(sdev, POWER_DOWN);
 
-	if (client->irq > 0)
-		free_irq(client->irq, sdev);
-
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	regulator_bulk_free(sdev->supplies, sdev->supply_data);
-	if (gpio_is_valid(sdev->gpio_reset))
-		gpio_free(sdev->gpio_reset);
-	kfree(sdev);
 
 	return 0;
 }
diff --git a/drivers/media/radio/si4713/si4713.h b/drivers/media/radio/si4713/si4713.h
index 4837cf6..2ff772e 100644
--- a/drivers/media/radio/si4713/si4713.h
+++ b/drivers/media/radio/si4713/si4713.h
@@ -15,7 +15,9 @@
 #ifndef SI4713_I2C_H
 #define SI4713_I2C_H
 
+#include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
+#include <linux/gpio/consumer.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-ctrls.h>
 #include <media/si4713.h>
@@ -190,8 +192,6 @@
 #define MIN_ACOMP_THRESHOLD		(-40)
 #define MAX_ACOMP_GAIN			20
 
-#define SI4713_NUM_SUPPLIES		2
-
 /*
  * si4713_device - private data
  */
@@ -227,9 +227,10 @@ struct si4713_device {
 		struct v4l2_ctrl *tune_ant_cap;
 	};
 	struct completion work;
-	unsigned supplies;
-	struct regulator_bulk_data supply_data[SI4713_NUM_SUPPLIES];
-	int gpio_reset;
+	struct regulator *vdd;
+	struct regulator *vio;
+	struct gpio_desc *gpio_reset;
+	struct platform_device *pd;
 	u32 power_state;
 	u32 rds_enabled;
 	u32 frequency;
@@ -237,4 +238,8 @@ struct si4713_device {
 	u32 stereo;
 	u32 tune_rnl;
 };
+
+struct radio_si4713_platform_data {
+	struct i2c_client *subdev;
+};
 #endif /* ifndef SI4713_I2C_H */
diff --git a/include/media/radio-si4713.h b/include/media/radio-si4713.h
deleted file mode 100644
index f6aae29..0000000
--- a/include/media/radio-si4713.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * include/media/radio-si4713.h
- *
- * Board related data definitions for Si4713 radio transmitter chip.
- *
- * Copyright (c) 2009 Nokia Corporation
- * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
- *
- * This file is licensed under the terms of the GNU General Public License
- * version 2. This program is licensed "as is" without any warranty of any
- * kind, whether express or implied.
- *
- */
-
-#ifndef RADIO_SI4713_H
-#define RADIO_SI4713_H
-
-#include <linux/i2c.h>
-
-#define SI4713_NAME "radio-si4713"
-
-/*
- * Platform dependent definition
- */
-struct radio_si4713_platform_data {
-	int i2c_bus;
-	struct i2c_board_info *subdev_board_info;
-};
-
-#endif /* ifndef RADIO_SI4713_H*/
diff --git a/include/media/si4713.h b/include/media/si4713.h
index f98a0a7..be4f58e 100644
--- a/include/media/si4713.h
+++ b/include/media/si4713.h
@@ -23,9 +23,7 @@
  * Platform dependent definition
  */
 struct si4713_platform_data {
-	const char * const *supply_names;
-	unsigned supplies;
-	int gpio_reset; /* < 0 if not used */
+	bool is_platform_device;
 };
 
 /*
-- 
1.9.1

