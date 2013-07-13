Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab3GMIvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 04:51:42 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35355 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172Ab3GMIvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 04:51:40 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 3/5] media: davinci: vpbe_display: convert to devm* api
Date: Sat, 13 Jul 2013 14:20:29 +0530
Message-Id: <1373705431-11500-4-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Replace existing resource handling in the driver with managed
device resource, this ensures more consistent error values and
simplifies error paths.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpbe_display.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index e180ff7..04609cc6 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1743,11 +1743,10 @@ static int vpbe_display_probe(struct platform_device *pdev)
 
 	printk(KERN_DEBUG "vpbe_display_probe\n");
 	/* Allocate memory for vpbe_display */
-	disp_dev = kzalloc(sizeof(struct vpbe_display), GFP_KERNEL);
-	if (!disp_dev) {
-		printk(KERN_ERR "ran out of memory\n");
+	disp_dev = devm_kzalloc(&pdev->dev, sizeof(struct vpbe_display),
+				GFP_KERNEL);
+	if (!disp_dev)
 		return -ENOMEM;
-	}
 
 	spin_lock_init(&disp_dev->dma_queue_lock);
 	/*
@@ -1786,26 +1785,24 @@ static int vpbe_display_probe(struct platform_device *pdev)
 	}
 
 	irq = res->start;
-	if (request_irq(irq, venc_isr,  IRQF_DISABLED, VPBE_DISPLAY_DRIVER,
-		disp_dev)) {
+	err = devm_request_irq(&pdev->dev, irq, venc_isr, IRQF_DISABLED,
+			       VPBE_DISPLAY_DRIVER, disp_dev);
+	if (err) {
 		v4l2_err(&disp_dev->vpbe_dev->v4l2_dev,
 				"Unable to request interrupt\n");
-		err = -ENODEV;
 		goto probe_out;
 	}
 
 	for (i = 0; i < VPBE_DISPLAY_MAX_DEVICES; i++) {
 		if (register_device(disp_dev->dev[i], disp_dev, pdev)) {
 			err = -ENODEV;
-			goto probe_out_irq;
+			goto probe_out;
 		}
 	}
 
 	printk(KERN_DEBUG "Successfully completed the probing of vpbe v4l2 device\n");
 	return 0;
 
-probe_out_irq:
-	free_irq(res->start, disp_dev);
 probe_out:
 	for (k = 0; k < VPBE_DISPLAY_MAX_DEVICES; k++) {
 		/* Get the pointer to the layer object */
@@ -1817,7 +1814,6 @@ probe_out:
 				kfree(disp_dev->dev[k]);
 		}
 	}
-	kfree(disp_dev);
 	return err;
 }
 
@@ -1830,15 +1826,10 @@ static int vpbe_display_remove(struct platform_device *pdev)
 	struct vpbe_layer *vpbe_display_layer;
 	struct vpbe_display *disp_dev = platform_get_drvdata(pdev);
 	struct vpbe_device *vpbe_dev = disp_dev->vpbe_dev;
-	struct resource *res;
 	int i;
 
 	v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "vpbe_display_remove\n");
 
-	/* unregister irq */
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	free_irq(res->start, disp_dev);
-
 	/* deinitialize the vpbe display controller */
 	if (NULL != vpbe_dev->ops.deinitialize)
 		vpbe_dev->ops.deinitialize(&pdev->dev, vpbe_dev);
-- 
1.7.9.5

