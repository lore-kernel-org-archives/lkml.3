Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaEGEqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:46:47 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46782 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaEGEqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:46:45 -0400
Date: Wed, 7 May 2014 10:16:38 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] Input: Introduce the use of the managed version of kzalloc
Message-ID: <20140507044638.GA3447@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions.

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
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/input/misc/pcf50633-input.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/input/misc/pcf50633-input.c b/drivers/input/misc/pcf50633-input.c
index db92f4f..15ae3ad 100644
--- a/drivers/input/misc/pcf50633-input.c
+++ b/drivers/input/misc/pcf50633-input.c
@@ -58,16 +58,13 @@ static int pcf50633_input_probe(struct platform_device *pdev)
 	struct input_dev *input_dev;
 	int ret;
 
-
-	input = kzalloc(sizeof(*input), GFP_KERNEL);
+	input = devm_kzalloc(&pdev->dev, sizeof(*input), GFP_KERNEL);
 	if (!input)
 		return -ENOMEM;
 
 	input_dev = input_allocate_device();
-	if (!input_dev) {
-		kfree(input);
+	if (!input_dev)
 		return -ENOMEM;
-	}
 
 	platform_set_drvdata(pdev, input);
 	input->pcf = dev_to_pcf50633(pdev->dev.parent);
@@ -81,7 +78,6 @@ static int pcf50633_input_probe(struct platform_device *pdev)
 	ret = input_register_device(input_dev);
 	if (ret) {
 		input_free_device(input_dev);
-		kfree(input);
 		return ret;
 	}
 	pcf50633_register_irq(input->pcf, PCF50633_IRQ_ONKEYR,
@@ -100,7 +96,6 @@ static int pcf50633_input_remove(struct platform_device *pdev)
 	pcf50633_free_irq(input->pcf, PCF50633_IRQ_ONKEYF);
 
 	input_unregister_device(input->input_dev);
-	kfree(input);
 
 	return 0;
 }
-- 
1.9.1

