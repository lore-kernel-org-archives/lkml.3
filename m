Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab3EYQix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 12:38:53 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:62813 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab3EYQis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 12:38:48 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 4/5] media: davinci: vpif_capture: Convert to devm_* api
Date: Sat, 25 May 2013 22:06:35 +0530
Message-Id: <1369499796-18762-5-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369499796-18762-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369499796-18762-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

use devm_request_irq() instead of request_irq().
This ensures more consistent error values and simplifies error paths.

use module_platform_driver to simplify the code.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   73 +++++--------------------
 1 files changed, 13 insertions(+), 60 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index caaf4fe..f37adf1 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -2082,14 +2082,13 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
 		for (i = res->start; i <= res->end; i++) {
-			if (request_irq(i, vpif_channel_isr, IRQF_SHARED,
-					"VPIF_Capture", (void *)
-					(&vpif_obj.dev[res_idx]->channel_id))) {
-				err = -EBUSY;
-				for (j = 0; j < i; j++)
-					free_irq(j, (void *)
-					(&vpif_obj.dev[res_idx]->channel_id));
-				goto vpif_int_err;
+			err = devm_request_irq(&pdev->dev, i, vpif_channel_isr,
+					     IRQF_SHARED, "VPIF_Capture",
+					     (void *)(&vpif_obj.dev[res_idx]->
+					     channel_id));
+			if (err) {
+				err = -EINVAL;
+				goto vpif_unregister;
 			}
 		}
 		res_idx++;
@@ -2106,7 +2105,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 				video_device_release(ch->video_dev);
 			}
 			err = -ENOMEM;
-			goto vpif_int_err;
+			goto vpif_unregister;
 		}
 
 		/* Initialize field of video device */
@@ -2207,13 +2206,8 @@ vpif_sd_error:
 		/* Note: does nothing if ch->video_dev == NULL */
 		video_device_release(ch->video_dev);
 	}
-vpif_int_err:
+vpif_unregister:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
-	for (i = 0; i < res_idx; i++) {
-		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
-		for (j = res->start; j <= res->end; j++)
-			free_irq(j, (void *)(&vpif_obj.dev[i]->channel_id));
-	}
 	return err;
 }
 
@@ -2229,14 +2223,16 @@ static int vpif_remove(struct platform_device *device)
 	struct channel_obj *ch;
 
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
-
+	kfree(vpif_obj.sd);
 	/* un-register device */
 	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		/* Unregister video device */
 		video_unregister_device(ch->video_dev);
+		kfree(vpif_obj.dev[i]);
 	}
+
 	return 0;
 }
 
@@ -2326,47 +2322,4 @@ static __refdata struct platform_driver vpif_driver = {
 	.remove = vpif_remove,
 };
 
-/**
- * vpif_init: initialize the vpif driver
- *
- * This function registers device and driver to the kernel, requests irq
- * handler and allocates memory
- * for channel objects
- */
-static __init int vpif_init(void)
-{
-	return platform_driver_register(&vpif_driver);
-}
-
-/**
- * vpif_cleanup : This function clean up the vpif capture resources
- *
- * This will un-registers device and driver to the kernel, frees
- * requested irq handler and de-allocates memory allocated for channel
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
-	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, i))) {
-		for (irq_num = res->start; irq_num <= res->end; irq_num++)
-			free_irq(irq_num,
-				 (void *)(&vpif_obj.dev[i]->channel_id));
-		i++;
-	}
-
-	platform_driver_unregister(&vpif_driver);
-
-	kfree(vpif_obj.sd);
-	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++)
-		kfree(vpif_obj.dev[i]);
-}
-
-/* Function for module initialization and cleanup */
-module_init(vpif_init);
-module_exit(vpif_cleanup);
+module_platform_driver(vpif_driver);
-- 
1.7.0.4

