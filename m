Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaJGL2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:28:16 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:52236 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbaJGL2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:28:13 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH] Input: opencores-kbd: Switch to using managed resources
Date: Tue,  7 Oct 2014 17:01:41 +0530
Message-Id: <1412681501-28072-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change switch to managed resources to simplifies error handling
and module unloading and does away with platform_driver remove function.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/input/keyboard/opencores-kbd.c |   54 ++++++++------------------------
 1 file changed, 13 insertions(+), 41 deletions(-)

diff --git a/drivers/input/keyboard/opencores-kbd.c b/drivers/input/keyboard/opencores-kbd.c
index 7b9b441..ecacb87 100644
--- a/drivers/input/keyboard/opencores-kbd.c
+++ b/drivers/input/keyboard/opencores-kbd.c
@@ -56,27 +56,27 @@ static int opencores_kbd_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	opencores_kbd = kzalloc(sizeof(*opencores_kbd), GFP_KERNEL);
-	input = input_allocate_device();
+	opencores_kbd = devm_kzalloc(&pdev->dev, sizeof(*opencores_kbd),
+				     GFP_KERNEL);
+	input = devm_input_allocate_device(&pdev->dev);
 	if (!opencores_kbd || !input) {
 		dev_err(&pdev->dev, "failed to allocate device structures\n");
-		error = -ENOMEM;
-		goto err_free_mem;
+		return -ENOMEM;
 	}
 
 	opencores_kbd->addr_res = res;
-	res = request_mem_region(res->start, resource_size(res), pdev->name);
+	res = devm_request_mem_region(&pdev->dev, res->start,
+				      resource_size(res), pdev->name);
 	if (!res) {
 		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		error = -EBUSY;
-		goto err_free_mem;
+		return -EBUSY;
 	}
 
-	opencores_kbd->addr = ioremap(res->start, resource_size(res));
+	opencores_kbd->addr = devm_ioremap(&pdev->dev, res->start,
+					   resource_size(res));
 	if (!opencores_kbd->addr) {
 		dev_err(&pdev->dev, "failed to remap I/O memory\n");
-		error = -ENXIO;
-		goto err_rel_mem;
+		return -ENXIO;
 	}
 
 	opencores_kbd->input = input;
@@ -109,54 +109,26 @@ static int opencores_kbd_probe(struct platform_device *pdev)
 	}
 	__clear_bit(KEY_RESERVED, input->keybit);
 
-	error = request_irq(irq, &opencores_kbd_isr,
+	error = devm_request_irq(&pdev->dev, irq, &opencores_kbd_isr,
 			    IRQF_TRIGGER_RISING, pdev->name, opencores_kbd);
 	if (error) {
 		dev_err(&pdev->dev, "unable to claim irq %d\n", irq);
-		goto err_unmap_mem;
+		return error;
 	}
 
 	error = input_register_device(input);
 	if (error) {
 		dev_err(&pdev->dev, "unable to register input device\n");
-		goto err_free_irq;
+		return error;
 	}
 
 	platform_set_drvdata(pdev, opencores_kbd);
 
 	return 0;
-
- err_free_irq:
-	free_irq(irq, opencores_kbd);
- err_unmap_mem:
-	iounmap(opencores_kbd->addr);
- err_rel_mem:
-	release_mem_region(res->start, resource_size(res));
- err_free_mem:
-	input_free_device(input);
-	kfree(opencores_kbd);
-
-	return error;
-}
-
-static int opencores_kbd_remove(struct platform_device *pdev)
-{
-	struct opencores_kbd *opencores_kbd = platform_get_drvdata(pdev);
-
-	free_irq(opencores_kbd->irq, opencores_kbd);
-
-	iounmap(opencores_kbd->addr);
-	release_mem_region(opencores_kbd->addr_res->start,
-		resource_size(opencores_kbd->addr_res));
-	input_unregister_device(opencores_kbd->input);
-	kfree(opencores_kbd);
-
-	return 0;
 }
 
 static struct platform_driver opencores_kbd_device_driver = {
 	.probe    = opencores_kbd_probe,
-	.remove   = opencores_kbd_remove,
 	.driver   = {
 		.name = "opencores-kbd",
 	},
-- 
1.7.9.5

