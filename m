Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3FQPVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:21:53 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54201 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3FQPVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:21:50 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 06/11] media: davinci: vpif_capture: Convert to devm_* api
Date: Mon, 17 Jun 2013 20:50:46 +0530
Message-Id: <1371482451-18314-7-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

use devm_request_irq() instead of request_irq(). This ensures
more consistent error values and simplifies error paths.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   36 +++++++++----------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 091c7a4..a4e0eab 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -2016,14 +2016,14 @@ static __init int vpif_probe(struct platform_device *pdev)
 
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
+
 			}
 		}
 		res_idx++;
@@ -2040,7 +2040,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 				video_device_release(ch->video_dev);
 			}
 			err = -ENOMEM;
-			goto vpif_int_err;
+			goto vpif_unregister;
 		}
 
 		/* Initialize field of video device */
@@ -2141,13 +2141,9 @@ vpif_sd_error:
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
+
 	return err;
 }
 
@@ -2160,15 +2156,7 @@ vpif_int_err:
 static int vpif_remove(struct platform_device *device)
 {
 	struct channel_obj *ch;
-	struct resource *res;
-	int irq_num, i = 0;
-
-	while ((res = platform_get_resource(device, IORESOURCE_IRQ, i))) {
-		for (irq_num = res->start; irq_num <= res->end; irq_num++)
-			free_irq(irq_num,
-				 (void *)(&vpif_obj.dev[i]->channel_id));
-		i++;
-	}
+	int i;
 
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 
-- 
1.7.9.5

