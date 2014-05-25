Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaEYKOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 06:14:10 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50738 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaEYKOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 06:14:08 -0400
Date: Sun, 25 May 2014 15:44:01 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] Input: mc13783-pwrbutton: Allocate resources using managed
 interfaces
Message-ID: <20140525101400.GA19075@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves most data allocated in the probe function from
unmanaged interfaces to managed interfaces. The kfrees and error
handling code is done away with. The unnecesary labels are
removed. Also, linux/device.h is added to make sure the devm_*()
routine declarations are unambiguously available. The name of label
free_priv is changed to unlock as it does not free priv anymore.

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
Not compiled due to incompatible architecture.

mc13xxx_irq_request is not devm'd, and doing so looks complicated due to
the locks around the frees.  Is there some way to resolve this issue?

To send to: Dmitry Torokhov <dmitry.torokhov@gmail.com>,linux-input@vger.kernel.org,linux-kernel@vger.kernel.org
 drivers/input/misc/mc13783-pwrbutton.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/input/misc/mc13783-pwrbutton.c b/drivers/input/misc/mc13783-pwrbutton.c
index 0df6e8d..6afea1a 100644
--- a/drivers/input/misc/mc13783-pwrbutton.c
+++ b/drivers/input/misc/mc13783-pwrbutton.c
@@ -28,6 +28,7 @@
 #include <linux/mfd/mc13783.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/device.h>
 
 struct mc13783_pwrb {
 	struct input_dev *pwr;
@@ -103,17 +104,16 @@ static int mc13783_pwrbutton_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	pwr = input_allocate_device();
+	pwr = devm_input_allocate_device(&pdev->dev);
 	if (!pwr) {
 		dev_dbg(&pdev->dev, "Can't allocate power button\n");
 		return -ENOMEM;
 	}
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv) {
-		err = -ENOMEM;
 		dev_dbg(&pdev->dev, "Can't allocate power button\n");
-		goto free_input_dev;
+		return -ENOMEM;
 	}
 
 	reg |= (pdata->b1on_flags & 0x3) << MC13783_POWER_CONTROL_2_ON1BDBNC;
@@ -140,7 +140,7 @@ static int mc13783_pwrbutton_probe(struct platform_device *pdev)
 					  button_irq, "b1on", priv);
 		if (err) {
 			dev_dbg(&pdev->dev, "Can't request irq\n");
-			goto free_priv;
+			goto unlock;
 		}
 	}
 
@@ -219,12 +219,8 @@ free_irq_b1:
 	if (pdata->b1on_flags & MC13783_BUTTON_ENABLE)
 		mc13xxx_irq_free(mc13783, MC13783_IRQ_ONOFD1, priv);
 
-free_priv:
+unlock:
 	mc13xxx_unlock(mc13783);
-	kfree(priv);
-
-free_input_dev:
-	input_free_device(pwr);
 
 	return err;
 }
@@ -247,9 +243,6 @@ static int mc13783_pwrbutton_remove(struct platform_device *pdev)
 
 	mc13xxx_unlock(priv->mc13783);
 
-	input_unregister_device(priv->pwr);
-	kfree(priv);
-
 	return 0;
 }
 
-- 
1.9.1

