Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbaE1SCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:02:23 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:53968 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaE1SCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:02:22 -0400
Date: Wed, 28 May 2014 23:32:14 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] Input: touchscreen : Introduce the use of the managed
 version of kzalloc
Message-ID: <20140528180214.GA5957@himangi-Dell>
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
removed and the function mrstouch_remove is removed as it becomes
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
 drivers/input/touchscreen/intel-mid-touch.c | 39 ++++++++---------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/input/touchscreen/intel-mid-touch.c b/drivers/input/touchscreen/intel-mid-touch.c
index 4f6b156..b1b1e8b 100644
--- a/drivers/input/touchscreen/intel-mid-touch.c
+++ b/drivers/input/touchscreen/intel-mid-touch.c
@@ -36,6 +36,7 @@
 #include <linux/irq.h>
 #include <linux/delay.h>
 #include <asm/intel_scu_ipc.h>
+#include <linux/device.h>
 
 /* PMIC Interrupt registers */
 #define PMIC_REG_ID1		0x00 /* PMIC ID1 register */
@@ -580,12 +581,12 @@ static int mrstouch_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	tsdev = kzalloc(sizeof(struct mrstouch_dev), GFP_KERNEL);
-	input = input_allocate_device();
+	tsdev = devm_kzalloc(&pdev->dev, sizeof(struct mrstouch_dev),
+			     GFP_KERNEL);
+	input = devm_input_allocate_device(&pdev->dev);
 	if (!tsdev || !input) {
 		dev_err(&pdev->dev, "unable to allocate memory\n");
-		err = -ENOMEM;
-		goto err_free_mem;
+		return -ENOMEM;
 	}
 
 	tsdev->dev = &pdev->dev;
@@ -598,7 +599,7 @@ static int mrstouch_probe(struct platform_device *pdev)
 	err = mrstouch_adc_init(tsdev);
 	if (err) {
 		dev_err(&pdev->dev, "ADC initialization failed\n");
-		goto err_free_mem;
+		return -ENOMEM;
 	}
 
 	input->name = "mrst_touchscreen";
@@ -618,39 +619,22 @@ static int mrstouch_probe(struct platform_device *pdev)
 	input_set_abs_params(tsdev->input, ABS_PRESSURE,
 			     MRST_PRESSURE_MIN, MRST_PRESSURE_MAX, 0, 0);
 
-	err = request_threaded_irq(tsdev->irq, NULL, mrstouch_pendet_irq,
-				   IRQF_ONESHOT, "mrstouch", tsdev);
+	err = devm_request_threaded_irq(&pdev->dev, tsdev->irq, NULL,
+					mrstouch_pendet_irq, IRQF_ONESHOT,
+					"mrstouch", tsdev);
 	if (err) {
 		dev_err(tsdev->dev, "unable to allocate irq\n");
-		goto err_free_mem;
+		return -ENOMEM;
 	}
 
 	err = input_register_device(tsdev->input);
 	if (err) {
 		dev_err(tsdev->dev, "unable to register input device\n");
-		goto err_free_irq;
+		return -ENOMEM;
 	}
 
 	platform_set_drvdata(pdev, tsdev);
 	return 0;
-
-err_free_irq:
-	free_irq(tsdev->irq, tsdev);
-err_free_mem:
-	input_free_device(input);
-	kfree(tsdev);
-	return err;
-}
-
-static int mrstouch_remove(struct platform_device *pdev)
-{
-	struct mrstouch_dev *tsdev = platform_get_drvdata(pdev);
-
-	free_irq(tsdev->irq, tsdev);
-	input_unregister_device(tsdev->input);
-	kfree(tsdev);
-
-	return 0;
 }
 
 static struct platform_driver mrstouch_driver = {
@@ -659,7 +643,6 @@ static struct platform_driver mrstouch_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= mrstouch_probe,
-	.remove		= mrstouch_remove,
 };
 module_platform_driver(mrstouch_driver);
 
-- 
1.9.1

