Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab3FMSeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:34:05 -0400
Received: from etezian.org ([198.101.225.253]:56454 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758940Ab3FMS27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:28:59 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 01/19] bh1770glc: added input device interface
Date: Thu, 13 Jun 2013 20:20:35 +0200
Message-Id: <90a9ed312d038eda11648a6ed49bb968824bf875.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver generates an event in /dev/input/ under the name
'bh1770'. It's a switch event where is reported '0' or '1'
whenever the sensor detects something crossing the threshold.

Signed-off-by: Onur Atilla <oatilla@gmail.com>
Signed-off-by: Phil Carmody <pc@asdf.org>
Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c |   58 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index f4975f7..d60b317 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -34,6 +34,7 @@
 #include <linux/delay.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/input.h>
 
 #define BH1770_ALS_CONTROL	0x80 /* ALS operation mode control */
 #define BH1770_PS_CONTROL	0x81 /* PS operation mode control */
@@ -168,6 +169,8 @@ struct bh1770_chip {
 	bool	prox_force_update;
 	u8	prox_abs_thres;
 	u8	prox_led;
+
+	struct input_dev *input_dev;
 };
 
 static const char reg_vcc[] = "Vcc";
@@ -461,6 +464,11 @@ static int bh1770_prox_mode_control(struct bh1770_chip *chip)
 	return 0;
 }
 
+static void bh1770_report_input_value(struct bh1770_chip *chip, int val)
+{
+	input_report_switch(chip->input_dev, SW_FRONT_PROXIMITY, val);
+}
+
 /* chip->mutex is kept when this is called */
 static int bh1770_prox_read_result(struct bh1770_chip *chip)
 {
@@ -506,13 +514,13 @@ static int bh1770_prox_read_result(struct bh1770_chip *chip)
 	} else {
 		chip->prox_persistence_counter = 0;
 		mode = PROX_BELOW_THRESHOLD;
-		chip->prox_data = 0;
 		ret = 0;
 	}
 
 	/* Set proximity detection rate based on above or below value */
 	if (ret == 0) {
 		bh1770_prox_rate(chip, mode);
+		bh1770_report_input_value(chip, mode);
 		sysfs_notify(&chip->client->dev.kobj, NULL, "prox0_raw");
 	}
 out:
@@ -818,6 +826,42 @@ static int bh1770_prox_rate_validate(int rate)
 	return i;
 }
 
+static void bh1770_input_cleanup(struct bh1770_chip *chip)
+{
+	input_unregister_device(chip->input_dev);
+}
+
+static int bh1770_input_init(struct bh1770_chip *chip)
+{
+	int err;
+
+	chip->input_dev = input_allocate_device();
+	if (!chip->input_dev) {
+		err = -ENOMEM;
+		goto alloc_err;
+	}
+
+	chip->input_dev->id.bustype = BUS_I2C;
+	chip->input_dev->dev.parent = &chip->client->dev;
+	chip->input_dev->name = "bh1770glc";
+
+	input_set_drvdata(chip->input_dev, chip);
+
+	set_bit(EV_SW, chip->input_dev->evbit);
+	set_bit(SW_FRONT_PROXIMITY, chip->input_dev->swbit);
+
+	err = input_register_device(chip->input_dev);
+	if (err)
+		goto reg_err;
+
+	return 0;
+
+reg_err:
+	input_free_device(chip->input_dev);
+alloc_err:
+	return err;
+}
+
 static ssize_t bh1770_set_prox_rate_above(struct device *dev,
 					struct device_attribute *attr,
 					const char *buf, size_t count)
@@ -1246,6 +1290,13 @@ static int bh1770_probe(struct i2c_client *client,
 		}
 	}
 
+	err = bh1770_input_init(chip);
+	if (err < 0) {
+		dev_err(&client->dev,
+				"impossible to allocate input event device\n");
+		goto no_input_dev;
+	}
+
 	err = sysfs_create_group(&chip->client->dev.kobj,
 				&bh1770_attribute_group);
 	if (err < 0) {
@@ -1274,6 +1325,8 @@ fail5:
 	sysfs_remove_group(&chip->client->dev.kobj,
 			&bh1770_attribute_group);
 fail4:
+	bh1770_input_cleanup(chip);
+no_input_dev:
 	if (chip->pdata->release_resources)
 		chip->pdata->release_resources();
 fail3:
@@ -1294,6 +1347,9 @@ static int bh1770_remove(struct i2c_client *client)
 	sysfs_remove_group(&chip->client->dev.kobj,
 			&bh1770_attribute_group);
 
+	/* input interface cleanup */
+	bh1770_input_cleanup(chip);
+
 	if (chip->pdata->release_resources)
 		chip->pdata->release_resources();
 
-- 
1.7.10.4

