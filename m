Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaE1UGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:06:13 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:51310 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaE1UGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:06:10 -0400
Date: Thu, 29 May 2014 01:36:03 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] Input: 88pm860x-ts: Introduce the use of the managed version
 of kzalloc
Message-ID: <20140528200603.GA10566@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves most data allocated in the probe function from
unmanaged interfaces to managed interfaces. The kfrees and error
handling code is done away with. Also, the unnecesary labels are
removed and the function pm860x_touch_remove is removed as it becomes
empty after removing the no longer required function calls. 

This changes the order of the freeing operations in the remove
function, putting the free_irq first, and that this may resolve a 
potential race condition.

The following Coccinelle semantic patch was used for making a part of
the change:

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
 drivers/input/touchscreen/88pm860x-ts.c | 36 +++++++++------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/input/touchscreen/88pm860x-ts.c b/drivers/input/touchscreen/88pm860x-ts.c
index 544e20c..30c8cc1 100644
--- a/drivers/input/touchscreen/88pm860x-ts.c
+++ b/drivers/input/touchscreen/88pm860x-ts.c
@@ -16,6 +16,7 @@
 #include <linux/input.h>
 #include <linux/mfd/88pm860x.h>
 #include <linux/slab.h>
+#include <linux/device.h>
 
 #define MEAS_LEN		(8)
 #define ACCURATE_BIT		(12)
@@ -234,16 +235,16 @@ static int pm860x_touch_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	touch = kzalloc(sizeof(struct pm860x_touch), GFP_KERNEL);
+	touch = devm_kzalloc(&pdev->dev, sizeof(struct pm860x_touch),
+			     GFP_KERNEL);
 	if (touch == NULL)
 		return -ENOMEM;
 	platform_set_drvdata(pdev, touch);
 
-	touch->idev = input_allocate_device();
+	touch->idev = devm_input_allocate_device(&pdev->dev);
 	if (touch->idev == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate input device!\n");
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	touch->idev->name = "88pm860x-touch";
@@ -258,10 +259,11 @@ static int pm860x_touch_probe(struct platform_device *pdev)
 	touch->res_x = res_x;
 	input_set_drvdata(touch->idev, touch);
 
-	ret = request_threaded_irq(touch->irq, NULL, pm860x_touch_handler,
-				   IRQF_ONESHOT, "touch", touch);
+	ret = devm_request_threaded_irq(&pdev->dev, touch->irq, NULL,
+					pm860x_touch_handler, IRQF_ONESHOT,
+					"touch", touch);
 	if (ret < 0)
-		goto out_irq;
+		return ret;
 
 	__set_bit(EV_ABS, touch->idev->evbit);
 	__set_bit(ABS_X, touch->idev->absbit);
@@ -279,28 +281,11 @@ static int pm860x_touch_probe(struct platform_device *pdev)
 	ret = input_register_device(touch->idev);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to register touch!\n");
-		goto out_rg;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, touch);
 	return 0;
-out_rg:
-	free_irq(touch->irq, touch);
-out_irq:
-	input_free_device(touch->idev);
-out:
-	kfree(touch);
-	return ret;
-}
-
-static int pm860x_touch_remove(struct platform_device *pdev)
-{
-	struct pm860x_touch *touch = platform_get_drvdata(pdev);
-
-	input_unregister_device(touch->idev);
-	free_irq(touch->irq, touch);
-	kfree(touch);
-	return 0;
 }
 
 static struct platform_driver pm860x_touch_driver = {
@@ -309,7 +294,6 @@ static struct platform_driver pm860x_touch_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe	= pm860x_touch_probe,
-	.remove	= pm860x_touch_remove,
 };
 module_platform_driver(pm860x_touch_driver);
 
-- 
1.9.1

