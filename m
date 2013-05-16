Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3EPNAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:00:23 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:37415 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab3EPNAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:00:19 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 7/7] media: davinci: vpif_display: Convert to devm_* api
Date: Thu, 16 May 2013 18:28:22 +0530
Message-Id: <1368709102-2854-8-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

use devm_request_irq() instead of request_irq().
This ensures more consistent error values and simplifies error paths.

use module_platform_driver to simplify the code.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   62 +++++--------------------
 1 files changed, 12 insertions(+), 50 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index d833056..87e9381 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1718,14 +1718,13 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
 		for (i = res->start; i <= res->end; i++) {
-			if (request_irq(i, vpif_channel_isr, IRQF_SHARED,
-					"VPIF_Display", (void *)
-					(&vpif_obj.dev[res_idx]->channel_id))) {
-				err = -EBUSY;
-				for (j = 0; j < i; j++)
-					free_irq(j, (void *)
-					(&vpif_obj.dev[res_idx]->channel_id));
-				goto vpif_int_err;
+			err = devm_request_irq(&pdev->dev, i, vpif_channel_isr,
+					     IRQF_SHARED, "VPIF_Display",
+					     (void *)(&vpif_obj.dev[res_idx]->
+					     channel_id));
+			if (err) {
+				err = -EINVAL;
+				goto vpif_unregister;
 			}
 		}
 		res_idx++;
@@ -1743,7 +1742,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 				video_device_release(ch->video_dev);
 			}
 			err = -ENOMEM;
-			goto vpif_int_err;
+			goto vpif_unregister;
 		}
 
 		/* Initialize field of video device */
@@ -1876,14 +1875,8 @@ vpif_sd_error:
 		/* Note: does nothing if ch->video_dev == NULL */
 		video_device_release(ch->video_dev);
 	}
-vpif_int_err:
+vpif_unregister:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
-	vpif_err("VPIF IRQ request failed\n");
-	for (i = 0; i < res_idx; i++) {
-		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
-		for (j = res->start; j <= res->end; j++)
-			free_irq(j, (void *)(&vpif_obj.dev[i]->channel_id));
-	}
 
 	return err;
 }
@@ -1898,6 +1891,7 @@ static int vpif_remove(struct platform_device *device)
 
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 
+	kfree(vpif_obj.sd);
 	/* un-register device */
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
@@ -1906,6 +1900,7 @@ static int vpif_remove(struct platform_device *device)
 		video_unregister_device(ch->video_dev);
 
 		ch->video_dev = NULL;
+		kfree(vpif_obj.dev[i]);
 	}
 
 	return 0;
@@ -1991,37 +1986,4 @@ static __refdata struct platform_driver vpif_driver = {
 	.remove	= vpif_remove,
 };
 
-static __init int vpif_init(void)
-{
-	return platform_driver_register(&vpif_driver);
-}
-
-/*
- * vpif_cleanup: This function un-registers device and driver to the kernel,
- * frees requested irq handler and de-allocates memory allocated for channel
- * objects.
- */
-static void vpif_cleanup(void)
-{
-	struct platform_device *pdev;
-	struct resource *res;
-	int irq_num;
-	int i = 0;
-
-	pdev = container_of(vpif_dev, struct platform_device, dev);
-
-	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, i))) {
-		for (irq_num = res->start; irq_num <= res->end; irq_num++)
-			free_irq(irq_num,
-				 (void *)(&vpif_obj.dev[i]->channel_id));
-		i++;
-	}
-
-	platform_driver_unregister(&vpif_driver);
-	kfree(vpif_obj.sd);
-	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++)
-		kfree(vpif_obj.dev[i]);
-}
-
-module_init(vpif_init);
-module_exit(vpif_cleanup);
+module_platform_driver(vpif_driver);
-- 
1.7.4.1

