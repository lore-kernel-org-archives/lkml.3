Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3IKPdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:33:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:8089 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107Ab3IKPdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:33:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,885,1371106800"; 
   d="scan'208";a="401818712"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 5/9] drivers/misc: convert existing I2C clients driver to use I2C core runtime PM
Date: Wed, 11 Sep 2013 18:32:36 +0300
Message-Id: <1378913560-2752-6-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C core now prepares runtime PM on behalf of the I2C client device, so
only thing the driver needs to do is to call pm_runtime_put() at the end of
its ->probe().

This patch converts I2C client drivers under drivers/misc to use this
model.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/misc/apds9802als.c |  7 +------
 drivers/misc/apds990x.c    | 16 ++++++----------
 drivers/misc/bh1770glc.c   | 12 +++++-------
 drivers/misc/fsa9480.c     |  2 --
 drivers/misc/isl29020.c    |  3 ++-
 5 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
index 0c6e037..7a177cd 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -246,8 +246,7 @@ static int apds9802als_probe(struct i2c_client *client,
 	als_set_default_config(client);
 	mutex_init(&data->mutex);
 
-	pm_runtime_set_active(&client->dev);
-	pm_runtime_enable(&client->dev);
+	pm_runtime_put(&client->dev);
 
 	return res;
 als_error1:
@@ -264,10 +263,6 @@ static int apds9802als_remove(struct i2c_client *client)
 	als_set_power_state(client, false);
 	sysfs_remove_group(&client->dev.kobj, &m_als_gr);
 
-	pm_runtime_disable(&client->dev);
-	pm_runtime_set_suspended(&client->dev);
-	pm_runtime_put_noidle(&client->dev);
-
 	kfree(data);
 	return 0;
 }
diff --git a/drivers/misc/apds990x.c b/drivers/misc/apds990x.c
index 868a30a..3bb87a8 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -1140,14 +1140,10 @@ static int apds990x_probe(struct i2c_client *client,
 		goto fail3;
 	}
 
-	pm_runtime_set_active(&client->dev);
-
 	apds990x_configure(chip);
 	apds990x_set_arate(chip, APDS_LUX_DEFAULT_RATE);
 	apds990x_mode_on(chip);
 
-	pm_runtime_enable(&client->dev);
-
 	if (chip->pdata->setup_resources) {
 		err = chip->pdata->setup_resources();
 		if (err) {
@@ -1173,6 +1169,9 @@ static int apds990x_probe(struct i2c_client *client,
 			client->irq);
 		goto fail5;
 	}
+
+	pm_runtime_put(&client->dev);
+
 	return err;
 fail5:
 	sysfs_remove_group(&chip->client->dev.kobj,
@@ -1193,6 +1192,8 @@ static int apds990x_remove(struct i2c_client *client)
 {
 	struct apds990x_chip *chip = i2c_get_clientdata(client);
 
+	pm_runtime_get_sync(&client->dev);
+
 	free_irq(client->irq, chip);
 	sysfs_remove_group(&chip->client->dev.kobj,
 			apds990x_attribute_group);
@@ -1200,12 +1201,7 @@ static int apds990x_remove(struct i2c_client *client)
 	if (chip->pdata && chip->pdata->release_resources)
 		chip->pdata->release_resources();
 
-	if (!pm_runtime_suspended(&client->dev))
-		apds990x_chip_off(chip);
-
-	pm_runtime_disable(&client->dev);
-	pm_runtime_set_suspended(&client->dev);
-
+	apds990x_chip_off(chip);
 	regulator_bulk_free(ARRAY_SIZE(chip->regs), chip->regs);
 
 	kfree(chip);
diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index 99a0468..7a85328 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -1245,8 +1245,6 @@ static int bh1770_probe(struct i2c_client *client,
 
 	/* Start chip */
 	bh1770_chip_on(chip);
-	pm_runtime_set_active(&client->dev);
-	pm_runtime_enable(&client->dev);
 
 	chip->lux_corr = bh1770_get_corr_value(chip);
 	if (chip->lux_corr == 0) {
@@ -1286,6 +1284,8 @@ static int bh1770_probe(struct i2c_client *client,
 		goto fail5;
 	}
 	regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
+	pm_runtime_put(&client->dev);
+
 	return err;
 fail5:
 	sysfs_remove_group(&chip->client->dev.kobj,
@@ -1306,6 +1306,8 @@ static int bh1770_remove(struct i2c_client *client)
 {
 	struct bh1770_chip *chip = i2c_get_clientdata(client);
 
+	pm_runtime_get_sync(&client->dev);
+
 	free_irq(client->irq, chip);
 
 	sysfs_remove_group(&chip->client->dev.kobj,
@@ -1316,11 +1318,7 @@ static int bh1770_remove(struct i2c_client *client)
 
 	cancel_delayed_work_sync(&chip->prox_work);
 
-	if (!pm_runtime_suspended(&client->dev))
-		bh1770_chip_off(chip);
-
-	pm_runtime_disable(&client->dev);
-	pm_runtime_set_suspended(&client->dev);
+	bh1770_chip_off(chip);
 
 	regulator_bulk_free(ARRAY_SIZE(chip->regs), chip->regs);
 	kfree(chip);
diff --git a/drivers/misc/fsa9480.c b/drivers/misc/fsa9480.c
index a725c79..1a7dc8b 100644
--- a/drivers/misc/fsa9480.c
+++ b/drivers/misc/fsa9480.c
@@ -450,8 +450,6 @@ static int fsa9480_probe(struct i2c_client *client,
 	/* device detection */
 	fsa9480_detect_dev(usbsw, INT_ATTACH);
 
-	pm_runtime_set_active(&client->dev);
-
 	return 0;
 
 fail2:
diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
index b7f84da..7bf15b8 100644
--- a/drivers/misc/isl29020.c
+++ b/drivers/misc/isl29020.c
@@ -179,12 +179,13 @@ static int  isl29020_probe(struct i2c_client *client,
 	}
 	dev_info(&client->dev, "%s isl29020: ALS chip found\n", client->name);
 	als_set_power_state(client, 0);
-	pm_runtime_enable(&client->dev);
+	pm_runtime_put(&client->dev);
 	return res;
 }
 
 static int isl29020_remove(struct i2c_client *client)
 {
+	pm_runtime_get(&client->dev);
 	sysfs_remove_group(&client->dev.kobj, &m_als_gr);
 	return 0;
 }
-- 
1.8.4.rc3

