Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaEUPOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:14:14 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53388 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaEUPOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:14:12 -0400
Date: Wed, 21 May 2014 20:44:05 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] touchscreen: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140521151405.GA8526@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. Also data allocated using input_allocate_device is moved to
devm_input_allocate_device and unnecessary labels are removed.

The following Coccinelle semantic patch was used for making the change:

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
 drivers/input/touchscreen/da9034-ts.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/input/touchscreen/da9034-ts.c b/drivers/input/touchscreen/da9034-ts.c
index 8ccf7bb..ed85744 100644
--- a/drivers/input/touchscreen/da9034-ts.c
+++ b/drivers/input/touchscreen/da9034-ts.c
@@ -303,7 +303,8 @@ static int da9034_touch_probe(struct platform_device *pdev)
 	struct input_dev *input_dev;
 	int ret;
 
-	touch = kzalloc(sizeof(struct da9034_touch), GFP_KERNEL);
+	touch = devm_kzalloc(&pdev->dev, sizeof(struct da9034_touch),
+			     GFP_KERNEL);
 	if (touch == NULL) {
 		dev_err(&pdev->dev, "failed to allocate driver data\n");
 		return -ENOMEM;
@@ -322,11 +323,10 @@ static int da9034_touch_probe(struct platform_device *pdev)
 	INIT_DELAYED_WORK(&touch->tsi_work, da9034_tsi_work);
 	touch->notifier.notifier_call = da9034_touch_notifier;
 
-	input_dev = input_allocate_device();
+	input_dev = devm_input_allocate_device(&pdev->dev);
 	if (!input_dev) {
 		dev_err(&pdev->dev, "failed to allocate input device\n");
-		ret = -ENOMEM;
-		goto err_free_touch;
+		return -ENOMEM;
 	}
 
 	input_dev->name		= pdev->name;
@@ -348,16 +348,10 @@ static int da9034_touch_probe(struct platform_device *pdev)
 
 	ret = input_register_device(input_dev);
 	if (ret)
-		goto err_free_input;
+		return ret;
 
 	platform_set_drvdata(pdev, touch);
 	return 0;
-
-err_free_input:
-	input_free_device(input_dev);
-err_free_touch:
-	kfree(touch);
-	return ret;
 }
 
 static int da9034_touch_remove(struct platform_device *pdev)
@@ -365,7 +359,6 @@ static int da9034_touch_remove(struct platform_device *pdev)
 	struct da9034_touch *touch = platform_get_drvdata(pdev);
 
 	input_unregister_device(touch->input_dev);
-	kfree(touch);
 
 	return 0;
 }
-- 
1.9.1

