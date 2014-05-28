Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaE1UBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:01:33 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:64437 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaE1UBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:01:31 -0400
Date: Thu, 29 May 2014 01:31:23 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] Input: 88pm860x_onkey : Introduce the use of the managed
 version of  kzalloc
Message-ID: <20140528200123.GA9946@himangi-Dell>
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
removed and the function pm860x_onkey_remove is removed as it becomes
empty after removing the no longer required function calls. Also,
linux/device.h include is added to make sure the devm_*() routine
declarations are unambiguously available.

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
 drivers/input/misc/88pm860x_onkey.c | 40 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 30 deletions(-)

diff --git a/drivers/input/misc/88pm860x_onkey.c b/drivers/input/misc/88pm860x_onkey.c
index abd8453..220ce0f 100644
--- a/drivers/input/misc/88pm860x_onkey.c
+++ b/drivers/input/misc/88pm860x_onkey.c
@@ -26,6 +26,7 @@
 #include <linux/interrupt.h>
 #include <linux/mfd/88pm860x.h>
 #include <linux/slab.h>
+#include <linux/device.h>
 
 #define PM8607_WAKEUP		0x0b
 
@@ -68,7 +69,8 @@ static int pm860x_onkey_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	info = kzalloc(sizeof(struct pm860x_onkey_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct pm860x_onkey_info),
+			    GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 	info->chip = chip;
@@ -76,11 +78,10 @@ static int pm860x_onkey_probe(struct platform_device *pdev)
 	info->dev = &pdev->dev;
 	info->irq = irq;
 
-	info->idev = input_allocate_device();
+	info->idev = devm_input_allocate_device(&pdev->dev);
 	if (!info->idev) {
 		dev_err(chip->dev, "Failed to allocate input dev\n");
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	info->idev->name = "88pm860x_on";
@@ -93,42 +94,22 @@ static int pm860x_onkey_probe(struct platform_device *pdev)
 	ret = input_register_device(info->idev);
 	if (ret) {
 		dev_err(chip->dev, "Can't register input device: %d\n", ret);
-		goto out_reg;
+		return ret;
 	}
 
-	ret = request_threaded_irq(info->irq, NULL, pm860x_onkey_handler,
-				   IRQF_ONESHOT, "onkey", info);
+	ret = devm_request_threaded_irq(&pdev->dev, info->irq, NULL,
+					pm860x_onkey_handler, IRQF_ONESHOT,
+					"onkey", info);
 	if (ret < 0) {
 		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
 			info->irq, ret);
-		goto out_irq;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, info);
 	device_init_wakeup(&pdev->dev, 1);
 
 	return 0;
-
-out_irq:
-	input_unregister_device(info->idev);
-	kfree(info);
-	return ret;
-
-out_reg:
-	input_free_device(info->idev);
-out:
-	kfree(info);
-	return ret;
-}
-
-static int pm860x_onkey_remove(struct platform_device *pdev)
-{
-	struct pm860x_onkey_info *info = platform_get_drvdata(pdev);
-
-	free_irq(info->irq, info);
-	input_unregister_device(info->idev);
-	kfree(info);
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -161,7 +142,6 @@ static struct platform_driver pm860x_onkey_driver = {
 		.pm	= &pm860x_onkey_pm_ops,
 	},
 	.probe		= pm860x_onkey_probe,
-	.remove		= pm860x_onkey_remove,
 };
 module_platform_driver(pm860x_onkey_driver);
 
-- 
1.9.1

