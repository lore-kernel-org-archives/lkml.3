Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3FQPWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:22:05 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50619 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3FQPWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:22:02 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 08/11] media: davinci: vpif_display: move the freeing of irq and global variables to remove()
Date: Mon, 17 Jun 2013 20:50:48 +0530
Message-Id: <1371482451-18314-9-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Ideally the freeing of irq's and the global variables needs to be
done in the remove() rather than module_exit(), this patch moves
the freeing up of irq's and freeing the memory allocated to channel
objects to remove() callback of struct platform_driver.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   30 ++++++++++---------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 6c521f2..371af34 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1829,10 +1829,20 @@ vpif_int_err:
 static int vpif_remove(struct platform_device *device)
 {
 	struct channel_obj *ch;
-	int i;
+	struct resource *res;
+	int irq_num;
+	int i = 0;
+
+	while ((res = platform_get_resource(device, IORESOURCE_IRQ, i))) {
+		for (irq_num = res->start; irq_num <= res->end; irq_num++)
+			free_irq(irq_num,
+				 (void *)(&vpif_obj.dev[i]->channel_id));
+		i++;
+	}
 
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 
+	kfree(vpif_obj.sd);
 	/* un-register device */
 	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++) {
 		/* Get the pointer to the channel object */
@@ -1841,6 +1851,7 @@ static int vpif_remove(struct platform_device *device)
 		video_unregister_device(ch->video_dev);
 
 		ch->video_dev = NULL;
+		kfree(vpif_obj.dev[i]);
 	}
 
 	return 0;
@@ -1938,24 +1949,7 @@ static __init int vpif_init(void)
  */
 static void vpif_cleanup(void)
 {
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
 	platform_driver_unregister(&vpif_driver);
-	kfree(vpif_obj.sd);
-	for (i = 0; i < VPIF_DISPLAY_MAX_DEVICES; i++)
-		kfree(vpif_obj.dev[i]);
 }
 
 module_init(vpif_init);
-- 
1.7.9.5

