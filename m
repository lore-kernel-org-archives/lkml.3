Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbaE1R26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:28:58 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49957 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaE1R24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:28:56 -0400
Date: Wed, 28 May 2014 22:58:49 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] bq27x00_battery: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140528172849.GA5614@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions for both platform and i2c drivers. Also, the unecessary
variable ret and labels batt_failed3, err_free were removed.

The following Coccinele script was used for making the change:

@platform@
identifier p, probefn, removefn;
@@
struct platform_driver p = {
  .probe = probefn,
  .remove = removefn,
};

@prb@
identifier platform.probefn, pdev;
expression e, e1, e2;
@@
probefn(struct platform_device *pdev, ...) {
  <+...
- e = kzalloc(e1, e2)
+ e = devm_kzalloc(&pdev->dev, e1, e2)
  ...
?-kfree(e);
  ...+>
}

@rem depends on prb@
identifier platform.removefn;
expression e;
@@
removefn(...) {
  <...
- kfree(e);
  ...>
}

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/power/bq27x00_battery.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index b309713..a0f205b 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -25,6 +25,7 @@
  * http://www.ti.com/product/bq27425-g1
  */
 
+#include <linux/device.h>
 #include <linux/module.h>
 #include <linux/param.h>
 #include <linux/jiffies.h>
@@ -804,7 +805,7 @@ static int bq27x00_battery_probe(struct i2c_client *client,
 		goto batt_failed_1;
 	}
 
-	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	di = devm_kzalloc(&client->dev, sizeof(*di), GFP_KERNEL);
 	if (!di) {
 		dev_err(&client->dev, "failed to allocate device info data\n");
 		retval = -ENOMEM;
@@ -819,14 +820,12 @@ static int bq27x00_battery_probe(struct i2c_client *client,
 
 	retval = bq27x00_powersupply_init(di);
 	if (retval)
-		goto batt_failed_3;
+		goto batt_failed_2;
 
 	i2c_set_clientdata(client, di);
 
 	return 0;
 
-batt_failed_3:
-	kfree(di);
 batt_failed_2:
 	kfree(name);
 batt_failed_1:
@@ -849,8 +848,6 @@ static int bq27x00_battery_remove(struct i2c_client *client)
 	idr_remove(&battery_id, di->id);
 	mutex_unlock(&battery_mutex);
 
-	kfree(di);
-
 	return 0;
 }
 
@@ -933,7 +930,6 @@ static int bq27000_battery_probe(struct platform_device *pdev)
 {
 	struct bq27x00_device_info *di;
 	struct bq27000_platform_data *pdata = pdev->dev.platform_data;
-	int ret;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform_data supplied\n");
@@ -945,7 +941,7 @@ static int bq27000_battery_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
 	if (!di) {
 		dev_err(&pdev->dev, "failed to allocate device info data\n");
 		return -ENOMEM;
@@ -959,16 +955,7 @@ static int bq27000_battery_probe(struct platform_device *pdev)
 	di->bat.name = pdata->name ?: dev_name(&pdev->dev);
 	di->bus.read = &bq27000_read_platform;
 
-	ret = bq27x00_powersupply_init(di);
-	if (ret)
-		goto err_free;
-
-	return 0;
-
-err_free:
-	kfree(di);
-
-	return ret;
+	return bq27x00_powersupply_init(di);
 }
 
 static int bq27000_battery_remove(struct platform_device *pdev)
@@ -977,8 +964,6 @@ static int bq27000_battery_remove(struct platform_device *pdev)
 
 	bq27x00_powersupply_unregister(di);
 
-	kfree(di);
-
 	return 0;
 }
 
-- 
1.9.1

