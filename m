Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3EZMCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 08:02:38 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38635 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3EZMCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 08:02:36 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 4/9] media: davinci: vpif_capture: move the freeing of irq and global variables to remove()
Date: Sun, 26 May 2013 17:30:07 +0530
Message-Id: <1369569612-30915-5-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Ideally the freeing of irq's and the global variables needs to be
done in the remove() rather than module_exit(), this patch moves
the freeing up of irq's and freeing the memory allocated to channel
objects to remove() callback of struct platform_driver.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   31 ++++++++++--------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index caaf4fe..f8b7304 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -2225,17 +2225,29 @@ vpif_int_err:
  */
 static int vpif_remove(struct platform_device *device)
 {
-	int i;
+	struct platform_device *pdev;
 	struct channel_obj *ch;
+	struct resource *res;
+	int irq_num, i = 0;
+
+	pdev = container_of(vpif_dev, struct platform_device, dev);
+	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, i))) {
+		for (irq_num = res->start; irq_num <= res->end; irq_num++)
+			free_irq(irq_num,
+				 (void *)(&vpif_obj.dev[i]->channel_id));
+		i++;
+	}
 
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 
+	kfree(vpif_obj.sd);
 	/* un-register device */
 	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		/* Unregister video device */
 		video_unregister_device(ch->video_dev);
+		kfree(vpif_obj.dev[i]);
 	}
 	return 0;
 }
@@ -2347,24 +2359,7 @@ static __init int vpif_init(void)
  */
 static void vpif_cleanup(void)
 {
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
 	platform_driver_unregister(&vpif_driver);
-
-	kfree(vpif_obj.sd);
-	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++)
-		kfree(vpif_obj.dev[i]);
 }
 
 /* Function for module initialization and cleanup */
-- 
1.7.0.4

