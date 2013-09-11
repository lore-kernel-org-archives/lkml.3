Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3IKPgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:36:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:13815 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab3IKPcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:32:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,885,1371106800"; 
   d="scan'208";a="293584883"
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
Subject: [PATCH v2 3/9] Input: misc - convert existing I2C client drivers to use I2C core runtime PM
Date: Wed, 11 Sep 2013 18:32:34 +0300
Message-Id: <1378913560-2752-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C core now prepares runtime PM on behalf of the I2C client device, so
only thing the driver needs to do is to call pm_runtime_put() at the end of
->probe().

This patch converts bma150 and mpu3050 input drivers to use this model.

While we are there remove call to pm_runtime_set_autosuspend_delay() in
mpu3050 driver because the driver doesn't seem to use autosuspend anyway.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/input/misc/bma150.c  |  4 ++--
 drivers/input/misc/mpu3050.c | 16 ++++------------
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/input/misc/bma150.c b/drivers/input/misc/bma150.c
index 865c2f9..f1bf5e9 100644
--- a/drivers/input/misc/bma150.c
+++ b/drivers/input/misc/bma150.c
@@ -592,7 +592,7 @@ static int bma150_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, bma150);
 
-	pm_runtime_enable(&client->dev);
+	pm_runtime_put(&client->dev);
 
 	return 0;
 
@@ -605,7 +605,7 @@ static int bma150_remove(struct i2c_client *client)
 {
 	struct bma150_data *bma150 = i2c_get_clientdata(client);
 
-	pm_runtime_disable(&client->dev);
+	pm_runtime_get(&client->dev);
 
 	if (client->irq > 0) {
 		free_irq(client->irq, bma150);
diff --git a/drivers/input/misc/mpu3050.c b/drivers/input/misc/mpu3050.c
index dce0d95..9f2ead5 100644
--- a/drivers/input/misc/mpu3050.c
+++ b/drivers/input/misc/mpu3050.c
@@ -43,8 +43,6 @@
 
 #define MPU3050_CHIP_ID		0x69
 
-#define MPU3050_AUTO_DELAY	1000
-
 #define MPU3050_MIN_VALUE	-32768
 #define MPU3050_MAX_VALUE	32767
 
@@ -359,11 +357,9 @@ static int mpu3050_probe(struct i2c_client *client,
 
 	input_set_drvdata(idev, sensor);
 
-	pm_runtime_set_active(&client->dev);
-
 	error = mpu3050_hw_init(sensor);
 	if (error)
-		goto err_pm_set_suspended;
+		goto err_free_mem;
 
 	error = request_threaded_irq(client->irq,
 				     NULL, mpu3050_interrupt_thread,
@@ -372,7 +368,7 @@ static int mpu3050_probe(struct i2c_client *client,
 	if (error) {
 		dev_err(&client->dev,
 			"can't get IRQ %d, error %d\n", client->irq, error);
-		goto err_pm_set_suspended;
+		goto err_free_mem;
 	}
 
 	error = input_register_device(idev);
@@ -381,15 +377,12 @@ static int mpu3050_probe(struct i2c_client *client,
 		goto err_free_irq;
 	}
 
-	pm_runtime_enable(&client->dev);
-	pm_runtime_set_autosuspend_delay(&client->dev, MPU3050_AUTO_DELAY);
+	pm_runtime_put(&client->dev);
 
 	return 0;
 
 err_free_irq:
 	free_irq(client->irq, sensor);
-err_pm_set_suspended:
-	pm_runtime_set_suspended(&client->dev);
 err_free_mem:
 	input_free_device(idev);
 	kfree(sensor);
@@ -406,8 +399,7 @@ static int mpu3050_remove(struct i2c_client *client)
 {
 	struct mpu3050_sensor *sensor = i2c_get_clientdata(client);
 
-	pm_runtime_disable(&client->dev);
-	pm_runtime_set_suspended(&client->dev);
+	pm_runtime_get(&client->dev);
 
 	free_irq(client->irq, sensor);
 	input_unregister_device(sensor->idev);
-- 
1.8.4.rc3

