Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaEXMTF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 08:19:05 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54498 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaEXMTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 08:19:03 -0400
Date: Sat, 24 May 2014 17:48:50 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] input: tc3589x-keypad: Allocate resources using managed
 interfaces
Message-ID: <20140524121850.GA6535@himangi-Dell>
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
removed. The include for linux/device.h is added to make sure the 
devm_*() routine declarations are unambiguously available.

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
---
 drivers/input/keyboard/tc3589x-keypad.c | 35 +++++++++++----------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/input/keyboard/tc3589x-keypad.c b/drivers/input/keyboard/tc3589x-keypad.c
index ad7abae..c412abe 100644
--- a/drivers/input/keyboard/tc3589x-keypad.c
+++ b/drivers/input/keyboard/tc3589x-keypad.c
@@ -17,6 +17,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/mfd/tc3589x.h>
+#include <linux/device.h>
 
 /* Maximum supported keypad matrix row/columns size */
 #define TC3589x_MAX_KPROW               8
@@ -376,12 +377,12 @@ static int tc3589x_keypad_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	keypad = kzalloc(sizeof(struct tc_keypad), GFP_KERNEL);
-	input = input_allocate_device();
+	keypad = devm_kzalloc(&pdev->dev, sizeof(struct tc_keypad),
+			      GFP_KERNEL);
+	input = devm_input_allocate_device(&pdev->dev);
 	if (!keypad || !input) {
 		dev_err(&pdev->dev, "failed to allocate keypad memory\n");
-		error = -ENOMEM;
-		goto err_free_mem;
+		return -ENOMEM;
 	}
 
 	keypad->board = plat;
@@ -400,7 +401,7 @@ static int tc3589x_keypad_probe(struct platform_device *pdev)
 					   NULL, input);
 	if (error) {
 		dev_err(&pdev->dev, "Failed to build keymap\n");
-		goto err_free_mem;
+		return error;
 	}
 
 	keypad->keymap = input->keycode;
@@ -411,20 +412,20 @@ static int tc3589x_keypad_probe(struct platform_device *pdev)
 
 	input_set_drvdata(input, keypad);
 
-	error = request_threaded_irq(irq, NULL,
-			tc3589x_keypad_irq, plat->irqtype,
-			"tc3589x-keypad", keypad);
+	error = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					  tc3589x_keypad_irq, plat->irqtype,
+					  "tc3589x-keypad", keypad);
 	if (error < 0) {
 		dev_err(&pdev->dev,
 				"Could not allocate irq %d,error %d\n",
 				irq, error);
-		goto err_free_mem;
+		return error;
 	}
 
 	error = input_register_device(input);
 	if (error) {
 		dev_err(&pdev->dev, "Could not register input device\n");
-		goto err_free_irq;
+		return error;
 	}
 
 	/* let platform decide if keypad is a wakeup source or not */
@@ -434,29 +435,15 @@ static int tc3589x_keypad_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, keypad);
 
 	return 0;
-
-err_free_irq:
-	free_irq(irq, keypad);
-err_free_mem:
-	input_free_device(input);
-	kfree(keypad);
-	return error;
 }
 
 static int tc3589x_keypad_remove(struct platform_device *pdev)
 {
 	struct tc_keypad *keypad = platform_get_drvdata(pdev);
-	int irq = platform_get_irq(pdev, 0);
 
 	if (!keypad->keypad_stopped)
 		tc3589x_keypad_disable(keypad);
 
-	free_irq(irq, keypad);
-
-	input_unregister_device(keypad->input);
-
-	kfree(keypad);
-
 	return 0;
 }
 
-- 
1.9.1

