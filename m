Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbaHHHVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:21:30 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:51983 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575AbaHHHV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:21:29 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: support.opensource@diasemi.com, dmitry.torokhov@gmail.com
Cc: anthony.olech.opensource@diasemi.com, david.chen@diasemi.com,
        kiran.padwal21@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] Input: da9052_onkey: convert to use devm_*
Date: Fri,  8 Aug 2014 12:48:44 +0530
Message-Id: <1407482324-17713-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting to devm functions can make the code smaller and cleaner.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/input/misc/da9052_onkey.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/input/misc/da9052_onkey.c b/drivers/input/misc/da9052_onkey.c
index 184c8f2..909441e 100644
--- a/drivers/input/misc/da9052_onkey.c
+++ b/drivers/input/misc/da9052_onkey.c
@@ -84,12 +84,14 @@ static int da9052_onkey_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	onkey = kzalloc(sizeof(*onkey), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!onkey || !input_dev) {
-		dev_err(&pdev->dev, "Failed to allocate memory\n");
-		error = -ENOMEM;
-		goto err_free_mem;
+	onkey = devm_kzalloc(&pdev->dev, sizeof(*onkey), GFP_KERNEL);
+	if (!onkey)
+		return -ENOMEM;
+
+	input_dev = devm_input_allocate_device(&pdev->dev);
+	if (!input_dev) {
+		dev_err(&pdev->dev, "Failed to allocate input device\n");
+		return -ENOMEM;
 	}
 
 	onkey->input = input_dev;
@@ -108,7 +110,7 @@ static int da9052_onkey_probe(struct platform_device *pdev)
 	if (error < 0) {
 		dev_err(onkey->da9052->dev,
 			"Failed to register ONKEY IRQ: %d\n", error);
-		goto err_free_mem;
+		return error;
 	}
 
 	error = input_register_device(onkey->input);
@@ -124,9 +126,6 @@ static int da9052_onkey_probe(struct platform_device *pdev)
 err_free_irq:
 	da9052_free_irq(onkey->da9052, DA9052_IRQ_NONKEY, onkey);
 	cancel_delayed_work_sync(&onkey->work);
-err_free_mem:
-	input_free_device(input_dev);
-	kfree(onkey);
 
 	return error;
 }
@@ -139,7 +138,6 @@ static int da9052_onkey_remove(struct platform_device *pdev)
 	cancel_delayed_work_sync(&onkey->work);
 
 	input_unregister_device(onkey->input);
-	kfree(onkey);
 
 	return 0;
 }
-- 
1.7.9.5

